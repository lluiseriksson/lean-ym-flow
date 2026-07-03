# lean-ym-flow

Lean 4 + Mathlib satellite repository for Yang-Mills gradient flow in the
THE-ERIKSSON-PROGRAMME ecosystem.

This repository starts with the finite-dimensional and lattice side of the
story: compact finite-dimensional gradient flow, Wilson-flow style lattice
Yang-Mills flow, gauge covariance, action decay, subsequential compactness,
and lattice smoothing bounds intended for later consumers.

The current Lean interface keeps time, energy, order, compactness, and finiteness
as abstract fields.  This avoids forcing CI to rebuild all of Mathlib before the
first real proof lands.  The repository is still pinned to Mathlib, and
`MATHLIB_AUDIT.md` records the Mathlib APIs that should be used as hypotheses
are discharged.

## Scope disclaimer

This is a formalization workbench for Yang-Mills flow interfaces and proofs.
It is not a proof of the Yang-Mills mass gap.  It is not a replacement for the
Kotecky-Preiss layer, Balaban hypotheses, or the conditional mass-gap assembly
in the mother repository.  It does not claim continuum Yang-Mills regularity
unless a theorem is either proved in Lean or carried as an explicit hypothesis.

Main branch policy:

- no `sorry`;
- no project `axiom`;
- all unproved mathematics is carried in named hypothesis records;
- `HYPOTHESIS_FRONTIER.md` lists the exact current frontier;
- signature changes in `YMFlow/Interfaces.lean` are breaking changes and must
  be announced in `INTERFACES.md`.

## Toolchain

The repository is pinned to the same toolchain as THE-ERIKSSON-PROGRAMME at
creation time:

- Lean: `leanprover/lean4:v4.29.0-rc6`
- Mathlib: `07642720480157414db592fa85b626dafb71355b`

## Layout

- `Interfaces.lean`: stable root contract imported by the mother repository.
- `YMFlow/Interfaces.lean`: internal implementation surface re-exported by
  `Interfaces.lean` and used by milestone wrappers.
- `YMFlow/FiniteDimensional.lean`: M0 wrappers for compact finite-dimensional
  gradient flow.
- `YMFlow/Lattice.lean`: M1-M2 lattice flow wrappers.
- `YMFlow/ContinuumStatements.lean`: M3 statements-first continuum wrappers.
- `YMFlow/ParabolicToolbox.lean`: M4 reusable parabolic-analysis interface.
- `MATHLIB_AUDIT.md`: audit of what Mathlib already provides.
- `HYPOTHESIS_FRONTIER.md`: exact list of explicit hypotheses and proof debt.
- `INTERFACES.md`: public signatures and breaking-change policy.
- `MOTHER_INTERFACE_DIGEST.md`: exact import/API digest for mother-repo consumers.
- `PARABOLIC_TOOLBOX.md`: shared analysis obligations and upstream targets.

## Build

```bash
lake build
```

For a fresh clone, first allow Lake to resolve/download Mathlib:

```bash
lake update
lake exe cache get
lake build
```

## Milestones

- M0: compact finite-dimensional gradient flow.
- M1: lattice Yang-Mills flow on `SU(2)^Edge`.
- M2: lattice smoothing bounds, including flow-time scale interfaces.
- M3: continuum statements-first wrappers with precise bibliography.
- M4: reusable parabolic toolbox, with Mathlib upstream candidates.
