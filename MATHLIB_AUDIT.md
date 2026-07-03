# Mathlib Audit

Date: 2026-07-03

Audited Mathlib commit:

```text
07642720480157414db592fa85b626dafb71355b
```

This is the exact commit pinned by THE-ERIKSSON-PROGRAMME at repository
creation time.

## Method

The audit used a local Mathlib checkout at the pinned commit and targeted
`rg` searches over `Mathlib`.

Representative searches:

```bash
rg -n "Picard|Lindel|Cauchy|ODE|Initial.*Value|IsPicard" Mathlib
rg -n "Gradient|gradient|HasFDerivAt|ContDiff|TangentBundle|ChartedSpace|SmoothManifoldWithCorners|CompactSpace" Mathlib/Analysis Mathlib/Geometry Mathlib/Topology
rg -n "SpecialUnitary|Unitary|LieGroup|Haar|Measure.haar|volume" Mathlib/Analysis Mathlib/Geometry Mathlib/MeasureTheory Mathlib/LinearAlgebra
rg -n "Gagliardo|Nirenberg|Sobolev|Poincare|Gronwall|Heat|parabolic|epsilon|regularity" Mathlib/Analysis Mathlib/MeasureTheory Mathlib/Probability
rg -n "Yang-Mills|YangMills|Wilson action|Wilson flow|plaquette|Plaquette|lattice gauge|gauge field" Mathlib
```

## Available foundations

- ODE local existence: `Mathlib/Analysis/ODE/PicardLindelof.lean`
  contains `IsPicardLindelof` and local existence theorems for ODEs.
- ODE uniqueness/comparison: `Mathlib/Analysis/ODE/Gronwall.lean`
  contains Gronwall-based trajectory comparison and uniqueness tools.
- Manifold integral curves: `Mathlib/Geometry/Manifold/IntegralCurve/*`
  includes `Basic`, `Transform`, `UniformTime`, and `ExistUnique`.
- Smooth manifolds and tangent bundles:
  `Mathlib/Geometry/Manifold/*`, including vector bundles and tangent bundles.
- Lie groups: `Mathlib/Geometry/Manifold/Algebra/LieGroup.lean`.
- Matrix unitary and special unitary groups:
  `Mathlib/LinearAlgebra/UnitaryGroup.lean` defines
  `Matrix.unitaryGroup` and `Matrix.specialUnitaryGroup`.
- Haar and product measures: `Mathlib/MeasureTheory/Measure/Haar/*` and
  `Mathlib/MeasureTheory/Constructions/Pi.lean`, including product Haar
  instances under suitable hypotheses.
- Sobolev/Gagliardo-Nirenberg-Sobolev:
  `Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean`.
- Compactness infrastructure: `CompactSpace`, `IsCompact`, compact Hausdorff
  categories, and compact-open topology appear throughout `Mathlib/Topology`.

## Current import policy

The initial Lean files do not import Mathlib modules directly.  They keep
scalars, orders, compactness, and finiteness abstract so `lake build YMFlow`
does not rebuild Mathlib from source in a fresh satellite scaffold.  As each
frontier hypothesis is reduced, the corresponding Mathlib imports from this
audit should replace the abstract fields.

## Missing for this repository

The strict search for Yang-Mills/lattice-gauge terms returned no hits:

```text
Yang-Mills, YangMills, Wilson action, Wilson flow, plaquette, lattice gauge,
gauge field
```

Therefore the following are not currently available as ready Mathlib APIs:

- Wilson plaquette action.
- Lattice gauge configurations on `SU(2)^Edge`.
- Gauge transformations at vertices and their action on oriented edges.
- Lattice Yang-Mills gradient/Wilson flow.
- Luescher-style lattice smoothing bounds.
- Continuum Yang-Mills bundles, connections, curvature, covariant derivative,
  and Yang-Mills heat equation.
- Uhlenbeck compactness, epsilon-regularity, and Yang-Mills bubbling analysis.

## Upstream candidates

Likely Mathlib-upstreamable material:

- Finite-dimensional compact gradient-flow lemmas for smooth vector fields.
- General ODE global-extension-by-compactness theorem.
- Reusable gradient-flow energy monotonicity in finite-dimensional inner
  product spaces.
- Basic product compact Lie group/Haar helpers specialized to finite products.
- Generic lattice combinatorics for finite oriented cell complexes, if kept
  independent of physics-specific naming.

Material that should stay in this satellite initially:

- Wilson action and lattice Yang-Mills naming.
- Gauge covariance statements tied to lattice conventions.
- Luescher/Wilson-flow smoothing constants and `t0` scale definitions.
