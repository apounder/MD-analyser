# Validation record

## Version 1.7 update

Reviewed shared histogram edges, per-replica normalization, circular wrapping,
finite-sample counts, profile/categorical separation, presentation labels and
HTML navigation. Python and report JavaScript syntax were checked. The synthetic
example was regenerated without Matplotlib. No test suite, native CPPTRAJ run,
browser/WebGL check or Matplotlib figure rendering was performed; visual appearance
remains unverified. No packages were installed.

## Version 1.6 update

Code review covered dropdown grouping, bounded PDB embedding, optional native
reference export and local third-party asset packaging. The synthetic report
example was regenerated with NumPy and a separately attributed experimental
structure. This is artifact generation, not validation of molecular calculations.
No test suite, native CPPTRAJ run, Matplotlib rendering or browser/WebGL check was
performed. Browser appearance remains unverified because the available browser
tool rejected local-file access. No packages were installed.

## Version 1.5 update

Native RDF/watershell commands were checked against official cpptraj documentation
and watershell source. Configuration, beginner flow, terminal output and figure-style
changes were reviewed by reading the code. No tests, native solvation calculations,
Matplotlib rendering or browser checks were run, and no dependencies were installed.
Earlier synthetic demonstrations do not validate the new figure rendering or analyses.

## Version 1.4 update

A synthetic report was generated with publication plotting disabled, exercising
report assembly and embedded numerical payload generation without Matplotlib or
CPPTRAJ. The synthetic example includes continuous, circular and categorical
observables and is explicitly labelled as artificial data. Browser visual review
was attempted but blocked by the browser's local-file URL security policy; the
JavaScript charts and interactions have not been visually verified. Code and setup
changes were reviewed statically. No test suite or native calculation was run, and
no dependencies were installed. Synthetic generation is not scientific validation.

## Version 1.3 update

The multi-page HTML report, evidence-linked review rules and semantic figure
indexing were inspected by reading the code. No tests, calculations, demos or
browser/rendering checks were run. No dependencies were installed. Earlier
validation results do not validate the new report pages.

## Version 1.2 update

Literature-informed diagnostics, diagnostic figures, offline HTML reporting,
environment/configuration checks, result bundling and methods records were reviewed
by reading the code only. No tests, calculations, demos or rendering checks were
run, and no dependencies were installed. Historical results below do not validate
these new features. Contributor guidance lists the remaining acceptance checks.

## Version 1.1 update

The preset/add-on menu, custom geometry monitors, configuration validation, and
terminal progress changes were reviewed by reading the code. No tests, demo,
CPPTRAJ calculation, or rendering checks were run for this update, at the user's
request. No dependencies were installed. The results below describe version 1.0
only and must not be treated as validation of version 1.1.

## Version 1.0 historical results

Validation date: 2026-09-05.

The final Python test suite ran **88 tests: 87 passed and 1 was skipped**.
Run the same suite from the source directory with:

```text
python -m unittest discover -s tests -v
```

The tests cover fixed-width Amber metadata, modified/terminal residues,
selection safety, file ordering and duplicate detection, global frame windows
across chunks, common-reference construction, resource guards, failure handling,
pooled projection splitting, numerical/circular/categorical summaries, contact
and nucleic parameter tables, compatible matrix axes, and the interactive wizard.

Workflow smoke tests use a clearly identified simulated CPPTRAJ subprocess.
They execute the actual Python orchestration/reporting code with synthetic
outputs. A separate three-replica synthetic demo exercises unequal lengths.
All three example JSON configurations passed schema/path normalization with
placeholder file existence checks disabled.

**Not validated in this environment:** real CPPTRAJ execution on molecular
trajectories, native command compatibility with a particular installed version,
and the appearance of rendered SVG files. CPPTRAJ and Matplotlib were absent;
the Matplotlib rendering smoke test was skipped explicitly. No dependencies
were installed. The implementation was checked against official CPPTRAJ
documentation and selected upstream source for output formats and commands.

The packaged `.pyz` is a standard Python executable ZIP containing the same
application modules. Its CLI/version and numerical-demo entry points were
smoke-tested without installing it. It still requires NumPy for numerical
reporting, Matplotlib for figures, and CPPTRAJ for trajectory calculations.

For an initial real-system check, select a short frame window, run the basic
preset, and inspect the generated input, log, reference, selected atoms and
numerical results before expanding the requested analyses. Verify complex
imaging and atom identities with your own topology and trajectories.
