package integration

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"testing"
	"time"

	"github.com/1Password/connect-sdk-go/onepassword"
	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/require"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

var (
	itemID       = os.Getenv("OP_ITEM_ID")
	vaultID      = os.Getenv("OP_VAULT_ID")
	connectToken = os.Getenv("OP_CONNECT_TOKEN")
)

func TestDeployConnectChart(t *testing.T) {
	t.Parallel()
	options := k8s.NewKubectlOptions("", "", "default")
	releaseName := "connect-test"
	chartPath := "../../../../charts/connect"

	helmOptions := &helm.Options{
		KubectlOptions: options,
		SetValues: map[string]string{
			"connect.create":       "true",
			"operator.token.value": connectToken,
		},
		SetFiles: map[string]string{
			"connect.credentials": os.Getenv("OP_CONNECT_CREDENTIALS_PATH"),
		},
	}

	helm.Install(t, helmOptions, chartPath, releaseName)
	t.Cleanup(func() {
		helm.Delete(t, helmOptions, releaseName, true)
	})

	k8s.WaitUntilNumPodsCreated(t, options, metav1.ListOptions{LabelSelector: "app=onepassword-connect"}, 1, 60, 5*time.Second)
	pods := k8s.ListPods(t, options, metav1.ListOptions{LabelSelector: "app=onepassword-connect"})

	pod := pods[0]
	k8s.WaitUntilPodAvailable(t, options, pod.Name, 60, 20*time.Second)

	tunnel := k8s.NewTunnel(options, k8s.ResourceTypePod, pod.Name, 8080, 8080)
	t.Cleanup(func() {
		tunnel.Close()
	})
	tunnel.ForwardPort(t)

	url := fmt.Sprintf("http://%s/v1/vaults/%s/items/%s", tunnel.Endpoint(), vaultID, itemID)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("Authorization", "Bearer "+connectToken)

	client := http.Client{Timeout: 5 * time.Second}
	resp, err := client.Do(req)
	require.NoError(t, err)
	t.Cleanup(func() {
		resp.Body.Close()
	})
	require.Equal(t, http.StatusOK, resp.StatusCode)

	var item onepassword.Item
	err = json.NewDecoder(resp.Body).Decode(&item)
	require.NoError(t, err)
	require.Equal(t, itemID, item.ID)
	require.Equal(t, vaultID, item.Vault.ID)
}

func TestUpgradeConnectChart(t *testing.T) {
	t.Parallel()
	options := k8s.NewKubectlOptions("", "", "default")
	releaseName := "connect-upgrade"

	initialHelmOptions := &helm.Options{
		KubectlOptions: options,
		SetValues: map[string]string{
			"connect.create":       "true",
			"operator.token.value": connectToken,
		},
		SetFiles: map[string]string{
			"connect.credentials": os.Getenv("OP_CONNECT_CREDENTIALS_PATH"),
		},
	}

	// Step 1: Install Connect and fetch an item
	helm.Install(t, initialHelmOptions, "1password/connect", releaseName)
	t.Cleanup(func() {
		helm.Delete(t, initialHelmOptions, releaseName, true)
	})

	k8s.WaitUntilNumPodsCreated(t, options, metav1.ListOptions{LabelSelector: "app=onepassword-connect"}, 1, 60, 5*time.Second)
	pods := k8s.ListPods(t, options, metav1.ListOptions{LabelSelector: "app=onepassword-connect"})

	pod := pods[0]
	k8s.WaitUntilPodAvailable(t, options, pod.Name, 60, 20*time.Second)

	tunnel := k8s.NewTunnel(options, k8s.ResourceTypePod, pod.Name, 8080, 8080)
	tunnel.ForwardPort(t)

	// Step 2: Fetch an item from the vault
	url := fmt.Sprintf("http://%s/v1/vaults/%s/items/%s", tunnel.Endpoint(), vaultID, itemID)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("Authorization", "Bearer "+connectToken)

	client := http.Client{Timeout: 5 * time.Second}
	resp, err := client.Do(req)
	require.NoError(t, err)
	t.Cleanup(func() {
		resp.Body.Close()
	})
	require.Equal(t, http.StatusOK, resp.StatusCode)

	var item onepassword.Item
	err = json.NewDecoder(resp.Body).Decode(&item)
	require.NoError(t, err)
	require.Equal(t, itemID, item.ID)
	require.Equal(t, vaultID, item.Vault.ID)
	tunnel.Close() // close tunnel after getting an item

	// Step 3: Upgrade chart using current version and verify pods are healthy
	upgradeHelmOptions := &helm.Options{
		KubectlOptions: options,
		SetValues: map[string]string{
			"connect.create":       "true",
			"operator.create":      "true",
			"operator.token.value": connectToken,
		},
		SetFiles: map[string]string{
			"connect.credentials": os.Getenv("OP_CONNECT_CREDENTIALS_PATH"),
		},
	}

	helm.Upgrade(t, upgradeHelmOptions, "../../../../charts/connect", releaseName)

	// Step 3: Re-verify pods are healthy after upgrade
	k8s.WaitUntilNumPodsCreated(t, options, metav1.ListOptions{LabelSelector: "app=onepassword-connect"}, 1, 60, 5*time.Second)
	pods = k8s.ListPods(t, options, metav1.ListOptions{LabelSelector: "app=onepassword-connect"})
	require.Len(t, pods, 1)

	pod = pods[0]
	k8s.WaitUntilPodAvailable(t, options, pod.Name, 60, 20*time.Second)

	tunnel = k8s.NewTunnel(options, k8s.ResourceTypePod, pod.Name, 8080, 8080)
	tunnel.ForwardPort(t)

	// Step 2: Fetch an item from the vault
	url = fmt.Sprintf("http://%s/v1/vaults/%s/items/%s", tunnel.Endpoint(), vaultID, itemID)
	req, _ = http.NewRequest("GET", url, nil)
	req.Header.Set("Authorization", "Bearer "+connectToken)

	client = http.Client{Timeout: 5 * time.Second}
	resp, err = client.Do(req)
	require.NoError(t, err)
	t.Cleanup(func() {
		resp.Body.Close()
	})
	require.Equal(t, http.StatusOK, resp.StatusCode)

	var item2 onepassword.Item
	err = json.NewDecoder(resp.Body).Decode(&item2)
	require.NoError(t, err)
	require.Equal(t, itemID, item2.ID)
	require.Equal(t, vaultID, item2.Vault.ID)
	tunnel.Close() // close tunnel after getting an item
}
