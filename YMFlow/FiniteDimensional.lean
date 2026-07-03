import YMFlow.Interfaces

/-!
# M0: compact finite-dimensional gradient flow

Theorems in this file are honest wrappers around explicit frontier
hypotheses.  They fix the import names without pretending that the analytic
Picard-Lindelof and compactness arguments have already been formalized.
-/

namespace YMFlow

namespace CompactGradientFlowProblem

/--
M0 local existence and uniqueness placeholder interface.

Reference target: Picard-Lindelof / Cauchy-Lipschitz theory as available in
Mathlib's ODE development, then specialized to a compact finite-dimensional
manifold.
-/
theorem local_exists_unique
    (P : CompactGradientFlowProblem) (h : CompactGradientFlowHypotheses P) :
    P.localExistsUnique := by
  exact h.local_exists_unique

/--
M0 energy monotonicity for gradient flow.

Target statement: along the negative gradient flow of the action, energy is
nonincreasing.  The proof obligation remains explicit in
`CompactGradientFlowHypotheses.energy_nonincreasing`.
-/
theorem energy_nonincreasing
    (P : CompactGradientFlowProblem) (h : CompactGradientFlowHypotheses P)
    (x : P.State) (s t : P.Time) (hs : P.timeLe P.zeroTime s) (hst : P.timeLe s t) :
    P.energyLe (P.energy (P.flow t x)) (P.energy (P.flow s x)) := by
  exact h.energy_nonincreasing x s t hs hst

/--
M0 global existence by compactness.

Target statement: local solutions extend for all nonnegative time because the
finite-dimensional phase space is compact and no escape to infinity is
possible.
-/
theorem global_exists
    (P : CompactGradientFlowProblem) (h : CompactGradientFlowHypotheses P)
    (x : P.State) (t : P.Time) (ht : P.timeLe P.zeroTime t) :
    Nonempty P.State := by
  exact h.global_exists x t ht

end CompactGradientFlowProblem

end YMFlow
