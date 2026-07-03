# Hypothesis Frontier

Date: 2026-07-03

## Current proof status

- `sorry`: none in `main`.
- Project `axiom`: none.
- Unproved mathematics: carried only through explicit hypothesis records in
  `YMFlow/Interfaces.lean`.

## Explicit hypothesis records

### `CompactGradientFlowHypotheses`

M0 compact finite-dimensional gradient flow.

- `local_exists_unique : P.localExistsUnique`
- `energy_nonincreasing : forall x s t, P.timeLe P.zeroTime s -> P.timeLe s t -> ...`
- `global_exists : forall x t, P.timeLe P.zeroTime t -> Nonempty P.State`

Distance to target: the interface has not yet connected `P.flow` to a
manifold vector field, the negative gradient of `P.energy`, or Mathlib's
Picard-Lindelof/Gronwall API.  The compact-extension argument is not yet
formalized.  `Time`, `Energy`, and their orders are abstract pending the first
Mathlib-backed proof.

### `LatticeFlowHypotheses`

M1 lattice Yang-Mills flow.

- `gauge_equivariant`
- `action_nonincreasing`
- `subsequential_limit_critical`

Distance to target: `Config = SU(2)^Edge` is not yet realized.  The Wilson
action, its gradient, gauge action on edges, and compactness/subsequence
topology are still abstract.  `vertexFinite`, `edgeFinite`, and
`plaquetteFinite` are proposition fields, not Mathlib `Fintype` instances yet.

### `LatticeSmoothingHypotheses`

M2 smoothing.

- `plaquette_bound`
- `t0_scale_condition`

Distance to target: no Luescher-type lattice gradient-flow estimate has been
proved.  The `t0` interface is present only as an explicit predicate.

### `ContinuousYangMillsHypotheses`

M3 continuum statements-first.

- `rade_global_dim_two_three`
- `struwe_schlatter_dim_four_conditional`
- `waldron_no_finite_time_blowup_dim_four`

Distance to target: these are bibliographic wrappers only.  They do not
formalize bundles, connections, curvature, Sobolev spaces on manifolds,
Uhlenbeck compactness, epsilon-regularity, or bubbling analysis.

### `ParabolicToolboxHypotheses`

M4 shared parabolic toolbox.

- `energy_inequality_available`
- `energy_inequality_proof`
- `gagliardo_nirenberg_available`
- `gagliardo_nirenberg_proof`
- `epsilon_regularization_available`
- `epsilon_regularization_proof`

Distance to target: Mathlib has general Sobolev and ODE ingredients, but the
Yang-Mills-specific parabolic estimates are not yet formalized.

## Honest distance to the programme objective

This repository currently fixes import names and hypothesis boundaries.  It
does not yet prove any substantive Yang-Mills flow theorem.  The first real
proof objective is to replace the M0 `local_exists_unique` field with a theorem
using Mathlib's ODE APIs, then prove energy monotonicity from an explicit
finite-dimensional negative-gradient equation.
