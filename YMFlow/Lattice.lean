import YMFlow.Interfaces

/-!
# M1-M2: lattice Yang-Mills flow

The lattice is finite-dimensional.  The SU(2) realization, Wilson action
gradient, and smoothing estimates are not axiomatized; they are explicit
hypotheses.
-/

namespace YMFlow

namespace LatticeGaugeSystem

/--
M1 gauge covariance of the lattice Yang-Mills flow.

Target model: Wilson action on `SU(2)^Edge`, with gauge transformations at
vertices acting on incident edges.
-/
theorem flow_gauge_equivariant
    (L : LatticeGaugeSystem) (h : LatticeFlowHypotheses L)
    (gamma : L.GaugeTransform) (U : L.Config) (t : L.Time) :
    L.flow t (L.gaugeAction gamma U) = L.gaugeAction gamma (L.flow t U) := by
  exact h.gauge_equivariant gamma U t

/--
M1 Wilson-action decay along the lattice Yang-Mills flow.
-/
theorem wilsonAction_nonincreasing
    (L : LatticeGaugeSystem) (h : LatticeFlowHypotheses L)
    (U : L.Config) (s t : L.Time) (hs : L.timeLe L.zeroTime s) (hst : L.timeLe s t) :
    L.actionLe (L.wilsonAction (L.flow t U)) (L.wilsonAction (L.flow s U)) := by
  exact h.action_nonincreasing U s t hs hst

/--
M1 subsequential convergence to critical points.

The compactness/subsequence data are intentionally compressed into an
explicit hypothesis until the topology of `Config = SU(2)^Edge` is fully
realized.
-/
theorem subsequential_limit_critical
    (L : LatticeGaugeSystem) (h : LatticeFlowHypotheses L)
    (U : L.Config) :
    exists V : L.Config, L.critical V := by
  exact h.subsequential_limit_critical U

/--
M2 lattice smoothing plaquette bound.

Reference target: Luescher's lattice gauge-field gradient-flow estimates.
This theorem only exposes the intended import name and consumes the explicit
frontier hypothesis.
-/
theorem plaquette_bound_along_flow
    (L : LatticeGaugeSystem) (h : LatticeSmoothingHypotheses L)
    (p : L.Plaquette) (U : L.Config) (t : L.Time) (ht : L.timeLe L.zeroTime t) :
    L.plaquetteLe (L.plaquetteDeviation p t U) (L.plaquetteDeviation p L.zeroTime U) := by
  exact h.plaquette_bound p U t ht

end LatticeGaugeSystem

end YMFlow
