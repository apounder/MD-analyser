"""Wizard configuration and offline planning exercise no native MD engine."""
import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from mdwb.cli import _indices, main, wizard
from mdwb.config import normalize_config
from test_config_topology import amber_metadata


class CliTests(unittest.TestCase):
    def test_wizard_standard_defaults_save_and_plan_without_cpptraj(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            topology = root / "protein.prmtop"
            topology.write_text(amber_metadata([("ALA", ["N", "CA", "C", "O"])] * 3), encoding="ascii")
            (root / "rep1.nc").write_bytes(b"Synthetic placeholder, not MD")
            config_path = root / "config.json"
            # Empty input accepts safe defaults; all optional yes/no prompts
            # are answered according to their displayed defaults.
            with patch("builtins.input", return_value=""), contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(wizard(root, config_path), 0)
            config = json.loads(config_path.read_text())
            self.assertIsNone(config["analysis"]["enabled"])
            self.assertIsNone(config["frames"]["dt_ps"])
            self.assertEqual(config["analysis"]["level"], "standard")
            self.assertEqual(config["replicas"][0]["trajectories"], [str(root / "rep1.nc")])
            plan_dir = root / "plan"
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(main(["plan", str(config_path), "--output", str(plan_dir)]), 0)
            plan = (plan_dir / "PLAN.md").read_text(encoding="utf-8")
            self.assertIn("rms", plan)
            self.assertIn("offline plan", plan)
            self.assertIn("secstruct", plan)

    def test_explicit_reordered_file_choices_remain_ordered(self):
        self.assertEqual(_indices("3,1-2", 3), [2, 0, 1])
        with self.assertRaises(ValueError):
            _indices("1,1-2", 3)

    def test_cli_missing_inputs_returns_error_code(self):
        with contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(main(["run", "does-not-exist-config.json"]), 2)

    def test_replica_names_cannot_collide_on_case_insensitive_filesystems(self):
        config = {"topology": "system.prmtop", "replicas": [
            {"name": "RepA", "trajectories": ["a.nc"]},
            {"name": "repa", "trajectories": ["b.nc"]}]}
        with self.assertRaisesRegex(ValueError, "Duplicate replica"):
            normalize_config(config, check_files=False)


if __name__ == "__main__":
    unittest.main()
