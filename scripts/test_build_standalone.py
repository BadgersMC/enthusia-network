import importlib.util
from pathlib import Path
import tempfile
import unittest
import zipfile
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location("standalone", Path(__file__).with_name("build-standalone.py"))
standalone = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(standalone)


class StandaloneBuildTest(unittest.TestCase):
    def test_autoclicker_selects_server_plugin_not_client_root(self):
        self.assertEqual(standalone.project_path("enthusia-autoclicker"),
                         standalone.ROOT / "plugins/enthusia-autoclicker/server-plugin")

    def test_autoclicker_requires_pmd_after_verify(self):
        with patch.object(standalone.shutil, "which", return_value="mvn"):
            self.assertEqual(standalone.followup_commands("enthusia-autoclicker"),
                             [["mvn", "-B", "-ntp", "org.apache.maven.plugins:maven-pmd-plugin:3.26.0:check"]])

    def test_autoclicker_packaging_guards(self):
        required = {"net/enthusia/autoclicker/server/api/ClientHandshakeSnapshot.class",
                    "net/enthusia/autoclicker/server/api/EnthusiaAutoClickerClientApi.class"}
        with tempfile.TemporaryDirectory() as folder:
            jar = Path(folder) / "plugin.jar"
            for entries in (required, required | {"org/bukkit/Player.class"},
                            required | {"org/junit/Test.class"}, set()):
                with zipfile.ZipFile(jar, "w") as archive:
                    for name in entries:
                        archive.writestr(name, b"test")
                if entries == required:
                    standalone.verify_packaging(jar, "enthusia-autoclicker")
                else:
                    with self.assertRaises(ValueError):
                        standalone.verify_packaging(jar, "enthusia-autoclicker")

    def test_missing_java_is_not_skipped(self):
        with patch.dict(standalone.os.environ, {}, clear=True):
            with self.assertRaisesRegex(ValueError, "JAVA_HOME_21_X64"):
                standalone.java_environment(21)

    def test_wrong_java_is_rejected(self):
        with patch.dict(standalone.os.environ, {"JAVA_HOME": "/jdk"}, clear=True), patch.object(
                standalone.subprocess, "check_output", return_value='openjdk version "25.0.3"'):
            with self.assertRaisesRegex(ValueError, "Expected Java 21"):
                standalone.java_environment(21)

    def test_java_environment_preserves_other_toolchains(self):
        with patch.dict(standalone.os.environ, {"JAVA_HOME_21_X64": "/jdk21", "JAVA_HOME_25_X64": "/jdk25"}, clear=True), patch.object(
                standalone.subprocess, "check_output", return_value='openjdk version "21.0.12"'):
            env = standalone.java_environment(21)
            self.assertEqual(env["JAVA_HOME"], "/jdk21")
            self.assertEqual(env["JAVA_HOME_25_X64"], "/jdk25")

    def test_maven_quality_gate_has_no_skip_flags(self):
        with patch.object(standalone.shutil, "which", return_value="mvn"):
            self.assertEqual(standalone.command(Path("."), "maven"), ["mvn", "-B", "-ntp", "clean", "verify"])

    def test_missing_maven_is_rejected(self):
        with patch.object(standalone.shutil, "which", return_value=None):
            with self.assertRaisesRegex(ValueError, "Maven is required"):
                standalone.command(Path("."), "maven")

    def test_discordsrv_quality_gate_has_all_tasks(self):
        args = standalone.command(Path("."), "gradle")
        self.assertEqual(args[-5:], ["clean", "test", "shadowJar", "spotlessCheck", "--no-daemon"])

    def test_pin_mismatch_rejected_before_build(self):
        with patch.object(standalone, "git", side_effect=["160000 abc 0\tplugins/discordsrv", "def"]):
            with self.assertRaisesRegex(ValueError, "differs from gitlink"):
                standalone.pin("discordsrv")

    def test_dirty_pin_rejected(self):
        with patch.object(standalone, "git", side_effect=["160000 abc 0\tplugins/discordsrv", "abc", " M file"]):
            with self.assertRaisesRegex(ValueError, "local changes"):
                standalone.pin("discordsrv")

    def test_addon_requires_all_three_executed_proofs(self):
        log = "Passed 21 Discord item-name checks\nPassed 24 plain Discord chat checks\nStaff visibility proof: 10 checks passed"
        self.assertEqual(sum(standalone.evidence(Path("."), "interactivechat-discord-addon", log).values()), 55)
        with self.assertRaisesRegex(ValueError, "staff_visibility_checks"):
            standalone.evidence(Path("."), "interactivechat-discord-addon", log.split("Staff")[0])

    def test_missing_test_reports_fail_closed(self):
        with tempfile.TemporaryDirectory() as folder:
            with self.assertRaisesRegex(ValueError, "Missing or failing"):
                standalone.evidence(Path(folder), "startup-guardian", "")

    def test_failed_pin_check_invalidates_previous_provenance(self):
        with tempfile.TemporaryDirectory() as folder, patch.object(standalone, "ROOT", Path(folder)), patch.object(
                standalone, "pin", side_effect=ValueError("dirty")):
            previous = Path(folder) / "build/standalone/discordsrv.json"
            previous.parent.mkdir(parents=True)
            previous.write_text("old successful build")
            with self.assertRaisesRegex(ValueError, "dirty"):
                standalone.build("discordsrv")
            self.assertFalse(previous.exists())

    def test_all_skipped_or_failed_reports_are_not_a_pass(self):
        with tempfile.TemporaryDirectory() as folder:
            reports = Path(folder) / "target/surefire-reports"
            reports.mkdir(parents=True)
            report = reports / "TEST-example.xml"
            for attributes in ('tests="1" skipped="1"', 'tests="1" failures="1"'):
                report.write_text(f"<testsuite {attributes}/>")
                with self.assertRaisesRegex(ValueError, "Missing or failing"):
                    standalone.evidence(Path(folder), "startup-guardian", "")


if __name__ == "__main__":
    unittest.main()
