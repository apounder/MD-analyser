# CPPTRAJ Workbench

A guided, reproducible workflow for protein, DNA/RNA and mixed-system MD analysis
with CPPTRAJ. Version **1.6.0**.

## Quick start

Use an existing environment with **Python 3.10+**, **NumPy 1.24+** and **CPPTRAJ**
(AmberTools). **Matplotlib 3.7+** enables publication SVGs. Nothing is installed
automatically; run the source directly:

```text
python mdworkbench.py doctor
python mdworkbench.py wizard --root /path/to/trajectories --quick
python mdworkbench.py run analysis_config.json
```

The wizard discovers topology/trajectory files, asks how to group replicas and
segments, explains selections, and saves a reusable configuration. Use its saved
filename in the run command. Omit `--quick` for the full guided setup.

## What it provides

- Any number of ordered trajectory segments per replica; combined `.dat` tables
  preserve replica identities and individual results.
- Basic presets plus optional hydrogen bonds, contacts, secondary structure,
  torsions, SASA, NAStruct, RDF, solvent shells, PCA, clustering and matrix analyses.
- Guided distance, angle and dihedral monitors; protein/backbone/nucleic selections,
  residue ranges and named regions.
- Individual, overlaid and concatenated SVGs where appropriate; coordinated
  palettes, configurable sizing and Arial preference with a recorded fallback.
- Offline HTML with grouped analysis dropdowns, numerical previews, per-replica
  statistics and sampling guidance. Optional click-to-load **3Dmol.js** shows one
  reference structure, with atom/file limits and no trajectory animation.

Open `analysis_results/index.html` locally after a run. On a cluster, copy this
file to your computer: embedded previews work without a server or internet.
Keep the full output folder for linked raw data and supporting files.

```text
python mdworkbench.py report analysis_results --no-plots
python mdworkbench.py bundle analysis_results --destination study_results.zip
```

`--no-plots` retains numerical/HTML previews without Matplotlib. Open the included
[example report](examples/rendered/index.html) after downloading/cloning this
repository; it uses synthetic curves and an unrelated experimental structure.

## Scope and guidance

One comparison requires a matching topology and the same atom identities/order
across replicas. You establish topology compatibility, replica independence and
scientific comparability; automatic discovery cannot prove these. Stable traces
do not prove convergence. Native CPPTRAJ and browser/WebGL behavior of this update
remain unverified; see the [validation record](docs/VALIDATION.md).

[HTML and 3D viewer](docs/HTML_REPORT.md) · [Group workflows](docs/GROUP_GUIDE.md) ·
[Figure styling](docs/PUBLICATION_STYLE.md) · [Configurations](examples/README.md) ·
[Citation](CITATION.md) · [Contributing](CONTRIBUTING.md) ·
[MIT license](LICENSE) · [Third-party attribution](THIRD_PARTY.md)
