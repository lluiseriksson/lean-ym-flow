/-!
# Public interfaces for `lean-ym-flow`

This file is the stable import surface intended for
THE-ERIKSSON-PROGRAMME and `ym-lattice-numerics`.

No analytical theorem is asserted here without proof.  Difficult analytical
claims are represented as explicit hypothesis records, consumed by named
wrapper theorems in the milestone files.
-/

namespace YMFlow

/--
An abstract compact finite-dimensional gradient-flow problem.

The actual manifold, charts, vector field regularity, and Picard-Lindelof
premises are intentionally outside this record.  They enter through
`CompactGradientFlowHypotheses`, so the interface can be imported before the
analytic proof is complete.
-/
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

/--
Explicit frontier hypotheses for M0.

The intended theorem package is: local existence and uniqueness by
Picard-Lindelof, energy monotonicity for gradient flow, and global existence
by compactness of the finite-dimensional phase space.
-/
structure CompactGradientFlowHypotheses (P : CompactGradientFlowProblem) : Prop where
  local_exists_unique : P.localExistsUnique
  energy_nonincreasing :
    forall (x : P.State) (s t : P.Time), P.timeLe P.zeroTime s -> P.timeLe s t ->
      P.energyLe (P.energy (P.flow t x)) (P.energy (P.flow s x))
  global_exists : forall (_ : P.State) (t : P.Time), P.timeLe P.zeroTime t -> Nonempty P.State

/--
Abstract lattice Yang-Mills system.

For the target SU(2) model, `Config` is intended to be `SU(2)^Edge`.
The concrete Mathlib realization is a separate frontier item; the interface
does not assume it as an axiom.
-/
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

/--
Explicit frontier hypotheses for M1.

These are the exact imported assumptions needed to expose gauge covariance,
Wilson-action decay, and subsequential convergence to critical points for the
lattice flow.
-/
structure LatticeFlowHypotheses (L : LatticeGaugeSystem) : Prop where
  gauge_equivariant :
    forall (gamma : L.GaugeTransform) (U : L.Config) (t : L.Time),
      L.flow t (L.gaugeAction gamma U) = L.gaugeAction gamma (L.flow t U)
  action_nonincreasing :
    forall (U : L.Config) (s t : L.Time), L.timeLe L.zeroTime s -> L.timeLe s t ->
      L.actionLe (L.wilsonAction (L.flow t U)) (L.wilsonAction (L.flow s U))
  subsequential_limit_critical :
    forall (_ : L.Config), exists V : L.Config, L.critical V

/--
Explicit frontier hypotheses for M2 lattice smoothing bounds.

The intended consumer is a lattice smearing interface and a `t0`-scale
definition for `ym-lattice-numerics`.
-/
structure LatticeSmoothingHypotheses (L : LatticeGaugeSystem) where
  plaquette_bound :
    forall (p : L.Plaquette) (U : L.Config) (t : L.Time), L.timeLe L.zeroTime t ->
      L.plaquetteLe (L.plaquetteDeviation p t U) (L.plaquetteDeviation p L.zeroTime U)
  t0_scale_condition : (L.Config -> L.ActionValue) -> Prop

/--
Abstract continuous Yang-Mills flow package for statements-first work.

No continuum theorem is proved in this repository yet.  Published regularity
theorems are represented by explicit hypotheses with bibliographic wrappers.
-/
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

/--
Explicit frontier hypotheses for M3 continuum statements.
-/
structure ContinuousYangMillsHypotheses (P : ContinuousYangMillsProblem) : Prop where
  rade_global_dim_two_three :
    forall A : P.Connection, P.globalSolution A
  struwe_schlatter_dim_four_conditional :
    forall A : P.Connection, P.globalSolution A
  waldron_no_finite_time_blowup_dim_four :
    forall A : P.Connection, P.noFiniteTimeBlowUp A

/--
Shared parabolic-analysis obligations expected to be reusable if a later
Navier-Stokes repository forks the toolbox.
-/
structure ParabolicToolboxHypotheses where
  energy_inequality_available : Prop
  energy_inequality_proof : energy_inequality_available
  gagliardo_nirenberg_available : Prop
  gagliardo_nirenberg_proof : gagliardo_nirenberg_available
  epsilon_regularization_available : Prop
  epsilon_regularization_proof : epsilon_regularization_available

end YMFlow
