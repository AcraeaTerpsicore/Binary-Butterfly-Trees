# Binary Butterfly Trees in Wolfram Language

This project implements the Horton-Strahler (register) analysis for binary butterfly trees, following the derivations in the paper *[Horton-Strahler numbers for binary butterfly trees: exact analysis](https://arxiv.org/pdf/2510.18664)*. The core Wolfram Language packages cover both structural tree utilities and the closed-form generating functions that emerge from the paper.

## Contents

- `src/BinaryTreeUtils.wl` – structural utilities for binary trees, register evaluation, enumeration by size, and the glue operation.
- `src/ButterflyGeneratingFunctions.wl` – generating functions for classic binary trees and the glued (butterfly) model, including closed forms and symbolic coefficient extraction for $T_p(z)$.
- `src/ButterflyAPI.wl` – exploratory helpers that enumerate glued trees, register distributions, and averages.
- `tests/run_tests.wl` – regression tests that cross-check symbolic recurrences against explicit enumeration for small instances.
- `FORMULAS.md` – list of mathematical identities reproduced in the code.
- `TEST_SUMMARY.md` – record of the test command and outcome.
- `notebooks/ButterflyExploration.nb` – interactive notebook for experimenting with the API.

## Running the tests

Run the automated checks with:

```bash
"/mnt/d/Software/Wolfram Research/Mathematica/14.0/wolframscript.exe" -script tests/run_tests.wl
```

The script reports success or failure and acts as a quick health check for both symbolic and combinatorial parts of the implementation.

## Exploration Notebook

Open `notebooks/ButterflyExploration.nb` to load the packages automatically, inspect register distributions, and experiment with the API from a Mathematica front end.

## Future Extensions

- Build visualization helpers that render `BTNode`/`BTLeaf` structures, mirroring the figures from the reference paper.
- Implement asymptotic estimators for $[z^n]T_p(z)$ using Mellin-transform techniques discussed in the reference.
- Extend the recurrence verification to higher $p$ via numeric evaluation and automatic simplification heuristics.
- Add exporters that materialize coefficient tables and register distributions as CSV/JSON for downstream analysis.
