import json
from pathlib import Path
import subprocess
import tomllib
import unittest


ROOT = Path(__file__).resolve().parents[1]


class PiSetupTest(unittest.TestCase):
    def test_portable_setup(self):
        with (ROOT / "dot_config/mise/config.toml").open("rb") as config_file:
            tools = tomllib.load(config_file)["tools"]
        self.assertIn("node", tools)
        self.assertEqual(tools.get("npm:@earendil-works/pi-coding-agent"), "latest")
        self.assertIn("mise install", (ROOT / "run_after_apply.sh").read_text())

        settings_path = "dot_pi/agent/private_settings.json"
        settings = json.loads((ROOT / settings_path).read_text())
        self.assertIs(settings["enableInstallTelemetry"], False)
        self.assertIs(settings["enableAnalytics"], False)
        self.assertNotIn("defaultProvider", settings)
        self.assertNotIn("defaultModel", settings)

        for path, ignored in (
            (settings_path, False),
            ("dot_pi/agent/auth.json", True),
            ("dot_pi/agent/private_auth.json.tmpl", True),
            ("dot_pi/agent/trust.json", True),
            ("dot_pi/agent/private_trust.json", True),
            ("dot_pi/agent/sessions/project/session.jsonl", True),
            ("dot_pi/agent/private_sessions/project/session.jsonl", True),
        ):
            with self.subTest(path=path):
                result = subprocess.run(
                    ["git", "check-ignore", "--no-index", path],
                    cwd=ROOT,
                    capture_output=True,
                    text=True,
                )
                self.assertEqual(result.returncode, 0 if ignored else 1, result.stderr)


if __name__ == "__main__":
    unittest.main()
