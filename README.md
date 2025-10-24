# Binary Butterfly Trees in Wolfram Language

This project implements the Horton-Strahler (register) analysis for binary butterfly trees, following the derivations in `reference_paper/glue-register.tex`. The core Wolfram Language packages cover both structural tree utilities and the closed-form generating functions that emerge from the paper.

## Contents

- `src/BinaryTreeUtils.wl` – structural utilities for binary trees, register evaluation, enumeration by size, and the glue operation.
- `src/ButterflyGeneratingFunctions.wl` – generating functions for classic binary trees and the glued (butterfly) model, including the closed form for $T_p(z)$.
- `tests/run_tests.wl` – regression tests that cross-check symbolic recurrences against explicit enumeration for small instances.
- `FORMULAS.md` – list of mathematical identities reproduced in the code.
- `TEST_SUMMARY.md` – record of the test command and outcome.

## Running the tests

Run the automated checks with:

```bash
"/mnt/d/Software/Wolfram Research/Mathematica/14.0/wolframscript.exe" -script tests/run_tests.wl
```

The script reports success or failure and acts as a quick health check for both symbolic and combinatorial parts of the implementation.

## Future Extensions

- Add symbolic routines that extract coefficient tables for $T_p(z)$ beyond the current truncation utilities.
- Build visualization helpers that render `BTNode`/`BTLeaf` structures, mirroring the figures from the reference paper.
- Extend the recurrence verification to higher $p$ via numeric evaluation and automatic simplification heuristics.
- Package the workflow as a Mathematica notebook and expose a small API for exploratory experimentation.
