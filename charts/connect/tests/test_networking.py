"""Credential-free tests of chart rendering and networking values."""

import json
from pathlib import Path
import subprocess
import tempfile
import unittest

import yaml

CHART = Path(__file__).resolve().parents[1]


def render(values=None, template=None, check=True):
    with tempfile.TemporaryDirectory() as directory:
        values_file = Path(directory) / "values.json"
        values_file.write_text(json.dumps(values or {}))
        command = ["helm", "template", "connect", str(CHART), "--namespace", "connect-test",
                   "--values", str(values_file)]
        if template:
            command.extend(["--show-only", "templates/" + template])
        result = subprocess.run(command, text=True, capture_output=True)
    if not check:
        return result
    if result.returncode:
        raise AssertionError(result.stderr)
    return [obj for obj in yaml.safe_load_all(result.stdout) if obj]


def service(values=None):
    return render({"connect": values or {}}, "service.yaml")[0]


def monitor(values=None, connect=None):
    settings = {"api": {"serviceMonitor": {"enabled": True, **(values or {})}},
                **(connect or {})}
    return render({"connect": settings}, "servicemonitor.yaml")[0]


class ServiceFamiliesTests(unittest.TestCase):
    def test_defaults_omit_family_fields_and_keep_ports(self):
        spec = service()["spec"]
        self.assertNotIn("ipFamilies", spec)
        self.assertNotIn("ipFamilyPolicy", spec)
        self.assertTrue(any(obj["metadata"]["name"] == "connect-health-check"
                            for obj in render()))
        self.assertEqual(spec["type"], "ClusterIP")
        self.assertEqual(spec["selector"], {"app": "onepassword-connect"})
        self.assertEqual(spec["ports"], [{"name": "connect-sync", "port": 8081},
                                        {"name": "connect-api", "port": 8080}])

    def test_family_and_policy_matrix(self):
        for families, policy in [(["IPv4"], "SingleStack"), (["IPv6"], "SingleStack"),
                                 (["IPv4", "IPv6"], "PreferDualStack"),
                                 (["IPv6", "IPv4"], "RequireDualStack")]:
            with self.subTest(families=families, policy=policy):
                spec = service({"ipFamilies": families, "ipFamilyPolicy": policy})["spec"]
                self.assertEqual(spec["ipFamilies"], families)
                self.assertEqual(spec["ipFamilyPolicy"], policy)

    def test_independent_family_and_policy_options(self):
        self.assertNotIn("ipFamilyPolicy", service({"ipFamilies": ["IPv6"]})["spec"])
        self.assertNotIn("ipFamilies", service({"ipFamilyPolicy": "PreferDualStack"})["spec"])

    def test_empty_options_preserve_default_service(self):
        self.assertEqual(service(), service({"ipFamilies": [], "ipFamilyPolicy": ""}))

    def test_family_settings_preserve_tls_and_load_balancer(self):
        spec = service({"ipFamilies": ["IPv6"], "ipFamilyPolicy": "SingleStack",
                        "tls": {"enabled": True}, "serviceType": "LoadBalancer",
                        "loadBalancerSourceRanges": ["2001:db8::/32"]})["spec"]
        self.assertEqual(spec["ports"][1], {"port": 8443, "name": "connect-api-https"})
        self.assertEqual(spec["type"], "LoadBalancer")
        self.assertEqual(spec["loadBalancerSourceRanges"], ["2001:db8::/32"])

    def test_invalid_family_values_are_rejected_by_schema(self):
        for settings in [{"ipFamilies": ["IPv5"]}, {"ipFamilies": "IPv6"},
                         {"ipFamilies": ["IPv6", "IPv6"]},
                         {"ipFamilies": ["IPv4", "IPv6", "IPv4"]},
                         {"ipFamilyPolicy": "DualStack"}, {"ipFamilyPolicy": 1}]:
            with self.subTest(settings=settings):
                result = render({"connect": settings}, check=False)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("schema", result.stderr)

    def test_connect_disabled_emits_no_service(self):
        docs = render({"connect": {"create": False, "ipFamilies": ["IPv6"]},
                       "operator": {"create": True}})
        self.assertFalse(any(obj["kind"] == "Service" for obj in docs))


class MonitorDiscoveryTests(unittest.TestCase):
    def test_default_selector_and_endpoint_are_unchanged(self):
        obj = monitor()
        self.assertEqual(obj["spec"]["selector"], {"matchLabels": {
            **obj["metadata"]["labels"], "app.kubernetes.io/component": "connect"}})
        self.assertEqual(obj["spec"]["namespaceSelector"], {"matchNames": ["connect-test"]})
        self.assertEqual(obj["spec"]["endpoints"], [{"port": "connect-api",
                                                    "path": "/metrics", "interval": "30s"}])

    def test_empty_settings_preserve_default_monitor(self):
        self.assertEqual(monitor(), monitor({"selector": {}, "relabelings": []}))

    def test_full_selector_replaces_default_without_merging(self):
        selector = {"matchLabels": {"example.com/component": "connect"},
                    "matchExpressions": [{"key": "example.com/family", "operator": "In",
                                          "values": ["ipv6"]}]}
        spec = monitor({"selector": selector})["spec"]
        self.assertEqual(spec["selector"], selector)
        self.assertNotIn("app.kubernetes.io/version", spec["selector"]["matchLabels"])

    def test_expression_only_selector(self):
        selector = {"matchExpressions": [{"key": "example.com/metrics", "operator": "Exists"}]}
        self.assertEqual(monitor({"selector": selector})["spec"]["selector"], selector)

    def test_relabelings_preserve_literal_replacements_and_order(self):
        rules = [{"sourceLabels": ["__address__"], "regex": r"\[.+\]:8080", "action": "keep"},
                 {"sourceLabels": ["__meta_kubernetes_service_name"], "regex": "(.*)",
                  "targetLabel": "service", "replacement": "${1}"},
                 {"targetLabel": "job", "replacement": "onepassword-connect"}]
        self.assertEqual(monitor({"relabelings": rules})["spec"]["endpoints"][0]["relabelings"], rules)

    def test_custom_endpoint_fields_and_tls_survive_overrides(self):
        rules = [{"targetLabel": "job", "replacement": "connect"}]
        spec = monitor({"selector": {"matchLabels": {"metrics": "ipv6"}},
                        "relabelings": rules, "path": "/custom-metrics", "interval": "1m",
                        "params": {"format": ["prometheus"]}},
                       {"tls": {"enabled": True}})["spec"]
        self.assertEqual(spec["endpoints"], [{"port": "connect-api-https", "path": "/custom-metrics",
                                             "interval": "1m", "params": {"format": ["prometheus"]},
                                             "relabelings": rules}])

    def test_invalid_monitor_value_types_are_rejected_by_schema(self):
        for settings in [{"selector": []}, {"selector": {"matchLabels": {"metrics": 1}}},
                         {"selector": {"matchExpressions": "ipv6"}},
                         {"relabelings": {}}, {"relabelings": ["bad"]}]:
            with self.subTest(settings=settings):
                result = render({"connect": {"api": {"serviceMonitor": settings}}}, check=False)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("schema", result.stderr)

    def test_disabled_monitor_ignores_valid_discovery_options(self):
        docs = render({"connect": {"api": {"serviceMonitor": {
            "selector": {"matchLabels": {"metrics": "ipv6"}},
            "relabelings": [{"targetLabel": "job", "replacement": "connect"}]}}}})
        self.assertFalse(any(obj["kind"] == "ServiceMonitor" for obj in docs))


if __name__ == "__main__":
    unittest.main()
