# Contributing

This source bundle is not yet associated with a public repository or named
maintainers. Add those real details when publishing; do not invent contact addresses
or software DOIs. Include the package version and native CPPTRAJ version in reports.

For a bug report, provide the smallest shareable configuration, expected/observed
behavior, `manifest.json`, relevant CPPTRAJ input/log and environment versions.
Remove confidential paths and structures. A short, legally shareable trajectory
with its matching topology is preferable to an entire production simulation.

Analysis generators live in `mdwb/analysis.py`; orchestration in `runner.py`;
numeric interpretation and SVGs in `reporting.py`; sampling/distribution methods in
`diagnostics.py`; configuration and prompts in `config.py` and `cli.py`.
Keep CPPTRAJ command references beside new analysis definitions. Specify units,
periodic-boundary behavior, atom correspondence, angular wrapping and failure modes.
Do not apply linear statistics to state labels or circular torsions.

Before releasing changes, run the regression suite in an existing environment:

```text
python -m unittest discover -s tests -v
```

The shipped suite predates the 1.2 features. Additional acceptance checks should
cover white noise and correlated stationary signals; constant/missing/short series;
known histogram distances; unequal replicas; bundle extraction/replot on Windows
and Linux; escaped titles in the HTML viewer; missing prerequisites; native protein
and protein–DNA runs; and inspection of SVGs. These checks were not executed for 1.2.

Document observed validation separately from proposed checks. Do not add a passing
CI badge until a real repository workflow has passed. Use the MIT license for this
original workbench code; external software retains its own licensing and citations.
