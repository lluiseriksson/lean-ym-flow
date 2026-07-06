# Mother Interface Digest

Date: 2026-07-07

This digest lists the current `main` artifacts that the mother repository may
consume or monitor.  It is an integration map, not a new mathematical claim.
In particular, it does not assert continuum Yang-Mills regularity, mass gap
progress, Navier-Stokes progress, or any Balaban/Kotecky-Preiss discharge.

## Import Policy

Stable contract import:

```lean
import Interfaces
```

Concrete local facts from this satellite:

```lean
import YMFlow.DiscreteHeat
import YMFlow.LinearModel
```

The barrel import also exposes them:

```lean
import YMFlow
```

Do not import `YMFlow.Frontier.*` from the mother repository.  Frontier modules
are statement-first branches and may contain deliberate `sorry`.

## Discrete Parabolic Toolbox

File: `YMFlow/DiscreteHeat.lean`

Main API:

- `YMFlow.WeightedGraph`
- `YMFlow.WeightedGraph.degree`
- `YMFlow.WeightedGraph.degree_nonneg`
- `YMFlow.WeightedGraph.heatStep`
- `YMFlow.WeightedGraph.CFL`
- `YMFlow.WeightedGraph.CFL_zero`
- `YMFlow.WeightedGraph.CFL_of_nonneg_le`
- `YMFlow.WeightedGraph.heatStep_split`
- `YMFlow.WeightedGraph.heatStep_zero_tau`
- `YMFlow.WeightedGraph.heatStep_le_of_le`
- `YMFlow.WeightedGraph.le_heatStep_of_le`
- `YMFlow.WeightedGraph.heatStep_nonneg`
- `YMFlow.WeightedGraph.abs_heatStep_le`
- `YMFlow.WeightedGraph.heatStep_mem_Icc`
- `YMFlow.WeightedGraph.heatStep_const`
- `YMFlow.WeightedGraph.heatStep_add_const`
- `YMFlow.WeightedGraph.heatStep_add`
- `YMFlow.WeightedGraph.heatStep_smul`
- `YMFlow.WeightedGraph.heatStep_sub_const`
- `YMFlow.WeightedGraph.sum_heatStep`
- `YMFlow.WeightedGraph.iterate_heatStep_le_of_le`
- `YMFlow.WeightedGraph.le_iterate_heatStep_of_le`
- `YMFlow.WeightedGraph.iterate_heatStep_nonneg`
- `YMFlow.WeightedGraph.abs_iterate_heatStep_le`
- `YMFlow.WeightedGraph.iterate_heatStep_mem_Icc`
- `YMFlow.WeightedGraph.iterate_heatStep_const`
- `YMFlow.WeightedGraph.iterate_heatStep_add_const`
- `YMFlow.WeightedGraph.iterate_heatStep_add`
- `YMFlow.WeightedGraph.iterate_heatStep_smul`
- `YMFlow.WeightedGraph.iterate_heatStep_sub_const`
- `YMFlow.WeightedGraph.iterate_heatStep_zero_steps`
- `YMFlow.WeightedGraph.iterate_heatStep_zero_tau`
- `YMFlow.WeightedGraph.sum_iterate_heatStep`

Input assumptions:

- `[Fintype V]` for the vertex set.
- `WeightedGraph.weight_nonneg` and `WeightedGraph.weight_symm` are fields of
  the graph structure.
- Maximum/minimum/sup-norm statements require `G.CFL tau`.
- Mass conservation uses the stored symmetry of weights and has no CFL
  assumption.

Consumer meaning:

- `CFL_of_nonneg_le` is the substepping oracle: once a time step is CFL,
  every nonnegative smaller step is also CFL.
- `heatStep_le_of_le` and `le_heatStep_of_le` are the discrete maximum and
  minimum principles for explicit Euler heat flow under CFL.
- `heatStep_nonneg` is the one-step positivity-preservation oracle under CFL.
- `abs_heatStep_le` is the sup-norm stability form.
- `heatStep_mem_Icc` packages one-step closed interval invariance from the
  upper and lower comparison principles.
- `CFL_zero`, `heatStep_zero_tau`, and `iterate_heatStep_zero_tau` give the
  zero-time oracle: tau `0` satisfies CFL and every zero-time heat iterate is
  the identity map.
- `heatStep_const` and `iterate_heatStep_const` say spatially constant states
  are fixed by the scheme and all its iterates.
- `heatStep_add_const` and `iterate_heatStep_add_const` say adding a spatial
  constant commutes with the scheme and all iterates; this is a small oracle
  for later oscillation estimates.
- `heatStep_add` and `iterate_heatStep_add` say pointwise sums commute with
  the scheme and all iterates; this is a small decomposition oracle for later
  linearized estimates.
- `heatStep_smul` and `iterate_heatStep_smul` say scalar multiplication
  commutes with the scheme and all iterates; this is a small normalization
  oracle for later discrete estimates.
- `heatStep_sub_const` and `iterate_heatStep_sub_const` say subtracting a
  spatial constant commutes with the scheme and all iterates; this is a small
  centering oracle for later oscillation estimates.
- `iterate_heatStep_zero_steps` gives the zero-step oracle: for any time step,
  zero scheme iterations are exactly the identity map.
- `iterate_heatStep_le_of_le`, `le_iterate_heatStep_of_le`, and
  `iterate_heatStep_nonneg` are the iterated maximum/minimum/nonnegativity
  forms.
- `abs_iterate_heatStep_le` is the iterated sup-norm stability form.
- `iterate_heatStep_mem_Icc` packages interval invariance for any number of
  heat steps.
- `sum_heatStep` and `sum_iterate_heatStep` are exact mass-conservation
  identities for symmetric weights.

## M0 Linear Model

File: `YMFlow/LinearModel.lean`

Main API:

- `YMFlow.IntervalState`
- `YMFlow.linearFlow`
- `YMFlow.linearFlow_zero`
- `YMFlow.linearFlow_add`
- `YMFlow.linearIntervalProblem`
- `YMFlow.linearIntervalProblem_stateCompact`
- `YMFlow.linearInterval_hypotheses`
- `YMFlow.linearFlow_energy_decay`

Input assumptions:

- `linearFlow` takes `t : NNReal` and `p : IntervalState`.
- `linearInterval_hypotheses` is unconditional for
  `linearIntervalProblem`.
- The `localExistsUnique` proposition carried by `linearIntervalProblem` is
  the proved initial-condition and semigroup law.  It is not the full
  Picard-Lindelof uniqueness theorem against arbitrary competing solutions.

Consumer meaning:

- `linearInterval_hypotheses` is the first no-sorry/no-axiom instance of the
  M0 `CompactGradientFlowHypotheses` interface.
- `linearFlow_energy_decay` gives exact quadratic-energy decay for the model
  flow and can be used as a simple oracle for later smoothing statements.

## Current Frontier

The following are not available on `main` as proved facts:

- compact-manifold gradient-flow existence and uniqueness in the general M0
  form;
- SU(2) lattice Yang-Mills flow on `SU(2)^Edge`;
- lattice Luescher smoothing with explicit constants;
- continuum Yang-Mills regularity statements;
- any Navier-Stokes objective.

The statement-first branch `frontier/M0-M2` tracks the matrix semigroup,
Picard-Lindelof upgrade, discrete-to-semigroup bridge, and discrete smoothing
targets separately from `main`.
