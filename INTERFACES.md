# Interfaces

Public Lean import:

```lean
import Interfaces
```

The mother repository and `ym-lattice-numerics` should import from
`Interfaces` unless they need a milestone wrapper theorem.

## Breaking-change policy

Any change to a public structure name, field name, theorem name, or theorem
signature below is breaking.  Such changes must update this file and should be
called out in the PR description.

## M0 finite-dimensional flow

```lean
structure CompactGradientFlowProblem where
  State : Type u
  Time : Type v
  Energy : Type w
  zeroTime : Time
  timeLe : Time -> Time -> Prop
  energyLe : Energy -> Energy -> Prop
  stateCompact : Prop
  localExistsUnique : Prop
  energy : State -> Energy
  flow : Time -> State -> State
```

```lean
structure CompactGradientFlowHypotheses
    (P : CompactGradientFlowProblem) : Prop where
  local_exists_unique : Prop
  energy_nonincreasing :
    forall (x : P.State) (s t : P.Time), P.timeLe P.zeroTime s -> P.timeLe s t ->
      P.energyLe (P.energy (P.flow t x)) (P.energy (P.flow s x))
  global_exists : forall (_ : P.State) (t : P.Time), P.timeLe P.zeroTime t ->
    Nonempty P.State
```

Wrapper theorems:

```lean
YMFlow.CompactGradientFlowProblem.local_exists_unique
YMFlow.CompactGradientFlowProblem.energy_nonincreasing
YMFlow.CompactGradientFlowProblem.global_exists
```

## M1-M2 lattice flow

```lean
structure LatticeGaugeSystem where
  Vertex : Type u
  Edge : Type v
  Plaquette : Type w
  Config : Type x
  GaugeTransform : Type y
  Time : Type z
  ActionValue : Type a
  PlaquetteValue : Type b
  zeroTime : Time
  timeLe : Time -> Time -> Prop
  actionLe : ActionValue -> ActionValue -> Prop
  plaquetteLe : PlaquetteValue -> PlaquetteValue -> Prop
  vertexFinite : Prop
  edgeFinite : Prop
  plaquetteFinite : Prop
  wilsonAction : Config -> ActionValue
  flow : Time -> Config -> Config
  gaugeAction : GaugeTransform -> Config -> Config
  plaquetteDeviation : Plaquette -> Time -> Config -> PlaquetteValue
  critical : Config -> Prop
```

```lean
structure LatticeFlowHypotheses (L : LatticeGaugeSystem) : Prop where
  gauge_equivariant :
    forall (gamma : L.GaugeTransform) (U : L.Config) (t : L.Time),
      L.flow t (L.gaugeAction gamma U) = L.gaugeAction gamma (L.flow t U)
  action_nonincreasing :
    forall (U : L.Config) (s t : L.Time), L.timeLe L.zeroTime s -> L.timeLe s t ->
      L.actionLe (L.wilsonAction (L.flow t U)) (L.wilsonAction (L.flow s U))
  subsequential_limit_critical :
    forall (_ : L.Config), exists V : L.Config, L.critical V
```

```lean
structure LatticeSmoothingHypotheses (L : LatticeGaugeSystem) where
  plaquette_bound :
    forall (p : L.Plaquette) (U : L.Config) (t : L.Time), L.timeLe L.zeroTime t ->
      L.plaquetteLe (L.plaquetteDeviation p t U) (L.plaquetteDeviation p L.zeroTime U)
  t0_scale_condition : (L.Config -> L.ActionValue) -> Prop
```

Wrapper theorems:

```lean
YMFlow.LatticeGaugeSystem.flow_gauge_equivariant
YMFlow.LatticeGaugeSystem.wilsonAction_nonincreasing
YMFlow.LatticeGaugeSystem.subsequential_limit_critical
YMFlow.LatticeGaugeSystem.plaquette_bound_along_flow
```

## M3 continuum statements

```lean
structure ContinuousYangMillsProblem where
  Dimension : Type u
  Connection : Type v
  Time : Type w
  Energy : Type x
  zeroTime : Time
  timeLe : Time -> Time -> Prop
  energy : Connection -> Energy
  flow : Time -> Connection -> Connection
  smooth : Connection -> Prop
  noFiniteTimeBlowUp : Connection -> Prop
  globalSolution : Connection -> Prop
```

```lean
structure ContinuousYangMillsHypotheses
    (P : ContinuousYangMillsProblem) : Prop where
  rade_global_dim_two_three :
    forall A : P.Connection, P.globalSolution A
  struwe_schlatter_dim_four_conditional :
    forall A : P.Connection, P.globalSolution A
  waldron_no_finite_time_blowup_dim_four :
    forall A : P.Connection, P.noFiniteTimeBlowUp A
```

Wrapper theorems:

```lean
YMFlow.ContinuousYangMillsProblem.rade_global_dim_two_three
YMFlow.ContinuousYangMillsProblem.struwe_schlatter_dim_four_conditional
YMFlow.ContinuousYangMillsProblem.waldron_no_finite_time_blowup_dim_four
```

## M4 parabolic toolbox

```lean
structure ParabolicToolboxHypotheses where
  energy_inequality_available : Prop
  energy_inequality_proof : energy_inequality_available
  gagliardo_nirenberg_available : Prop
  gagliardo_nirenberg_proof : gagliardo_nirenberg_available
  epsilon_regularization_available : Prop
  epsilon_regularization_proof : epsilon_regularization_available
```

Wrapper theorems:

```lean
YMFlow.ParabolicToolboxHypotheses.energy_inequality
YMFlow.ParabolicToolboxHypotheses.gagliardo_nirenberg
YMFlow.ParabolicToolboxHypotheses.epsilon_regularization
```
