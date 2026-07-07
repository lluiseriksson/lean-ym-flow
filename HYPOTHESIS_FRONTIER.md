# Hypothesis Frontier

Date: 2026-07-07 (heat negation oracle)

## Current proof status

- `sorry`: none in `main`. Project `axiom`: none.
- Unproved mathematics: carried only through explicit hypothesis records in
  `YMFlow/Interfaces.lean`, PLUS the closed facts below.

## Closed facts on `main` (new this iteration)

Discrete parabolic toolbox (`DiscreteHeat.lean`) — no interface deps:

- `WeightedGraph`, `degree`, `heatStep`, the `CFL` condition, `CFL_zero`, and
  `CFL_of_nonneg_le`.
- `heatStep_le_of_le` / `le_heatStep_of_le`: **discrete maximum and minimum
  principles** under CFL; `abs_heatStep_le` (sup-norm stability).
- `heatStep_nonneg`: nonnegative data remains nonnegative after one heat step
  under CFL.
- `heatStep_zero_tau`: the zero-time heat step is exactly the identity map.
- `heatStep_mem_Icc`: one-step closed interval invariance under CFL.
- `heatStep_const`: spatially constant states are fixed by one heat step.
- `heatStep_add_const`: adding a spatial constant commutes with one heat step.
- `heatStep_add`: pointwise sums commute with one heat step.
- `heatStep_smul`: scalar multiplication commutes with one heat step.
- `heatStep_neg`: pointwise negation commutes with one heat step.
- `heatStep_sub`: pointwise differences commute with one heat step.
- `heatStep_sub_const`: subtracting a spatial constant commutes with one heat
  step.
- `sum_heatStep`: **exact mass conservation** for symmetric weights (vertex-
  swap antisymmetry).
- `iterate_heatStep_le_of_le`, `le_iterate_heatStep_of_le`,
  `iterate_heatStep_nonneg`, `abs_iterate_heatStep_le`,
  `iterate_heatStep_mem_Icc`, `iterate_heatStep_const`,
  `iterate_heatStep_add_const`,
  `iterate_heatStep_add`,
  `iterate_heatStep_smul`,
  `iterate_heatStep_neg`,
  `iterate_heatStep_sub`,
  `iterate_heatStep_sub_const`,
  `iterate_heatStep_zero_steps`,
  `iterate_heatStep_zero_tau`, `sum_iterate_heatStep`: maximum, minimum,
  nonnegativity, sup-norm stability, interval invariance, constant states,
  additive-constant covariance, additivity, scalar covariance, pointwise
  negation covariance, pointwise subtraction covariance, subtractive-centering
  covariance, zero-step identity, zero-time identity, and mass conservation
  persist under iteration of the scheme.

`CFL_of_nonneg_le` is the current substepping oracle: if `tau` satisfies CFL,
then every `sigma` with `0 ≤ sigma ≤ tau` also satisfies CFL.

Linear model (`LinearModel.lean`) — M0 discharged:

- `linearIntervalProblem`: the linear flow `x ↦ e^{-t} x` on the compact
  interval `{|x| ≤ 1}`, packaged as a `CompactGradientFlowProblem` whose
  `localExistsUnique` field carries the honest flow laws (initial condition
  + semigroup) and whose `stateCompact` field carries interval compactness.
- `linearInterval_hypotheses`: **first fully unconditional instance of
  `CompactGradientFlowHypotheses`** — every field a theorem.
- `linearIntervalProblem_stateCompact`: the carried compactness proposition
  is proved.
- `linearFlow_energy_decay`: exact exponential energy decay at rate 2 — the
  model statement the M2 smoothing bounds discretize.

## Explicit hypothesis records (unchanged, still open for real models)

`CompactGradientFlowHypotheses` for a general vector field (Picard-Lindelöf
backing), `LatticeFlowHypotheses`, `LatticeSmoothingHypotheses`,
`ContinuumStatements` packages, `ParabolicToolboxHypotheses`.

## Frontier obligations (branch `frontier/M0-M2`, statement-first, sorried)

`Frontier/MatrixFlow.lean`:

- `matrixFlow_energy_nonincreasing` (PSD matrix semigroup decreases the
  quadratic energy; route: `Matrix.exp` + spectral theorem).
- `linearFlow_unique_solution` (Picard-Lindelöf upgrade of the flow-law
  `localExistsUnique` proved on `main`).
- `heatStep_iterate_tendsto_semigroup` (the discrete scheme converges to
  the graph-Laplacian semigroup: the M1 bridge).
- `iterate_heatStep_oscillation_decay` (discrete Lüscher smoothing;
  constants must become explicit before `ym-lattice-numerics` can certify
  them).

## Honest distance to the goal

M0 has one fully discharged instance (the linear interval flow), but the
general compact-manifold version remains open — the instance shows the
interface is sound, not that the analysis is done.  M1/M2 now have their
discrete substrate (maximum principle + mass conservation, iterated) and
their bridge statements; the SU(2) lattice realization is untouched.
M3 statements and M4 toolbox remain as at T0.  Navier-Stokes is NOT a goal
of this repository, as per MILESTONES.md.
