import YMFlow.Interfaces
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Topology.Order.Compact

/-!
# The linear flow on the compact interval: M0 fully discharged

The gradient flow of the quadratic energy on the compact state space
`{x : ℝ | |x| ≤ 1}` has the explicit solution `x(t) = e^{-t} x(0)`.  This
file packages it as a `CompactGradientFlowProblem` and proves EVERY field of
`CompactGradientFlowHypotheses` — the first fully unconditional instance of
the M0 interface.  The `localExistsUnique` proposition carried by the
problem is instantiated with the honest flow laws (initial condition and
semigroup property), both proved; the Picard-Lindelöf-backed version for a
general vector field remains the frontier and is stated there.

Reference: any ODE text; e.g. Teschl (2012), "Ordinary Differential
Equations and Dynamical Systems", Section 1.3 (the linear scalar equation).
-/

namespace YMFlow

/-- The compact state space `[-1, 1]` as a subtype. -/
def IntervalState : Type :=
  {x : ℝ // |x| ≤ 1}

/-- The explicit linear flow `x ↦ e^{-t} x`, which preserves the interval
for nonnegative times. -/
noncomputable def linearFlow (t : NNReal) (p : IntervalState) : IntervalState :=
  ⟨Real.exp (-(t : ℝ)) * p.1, by
    have hexp1 : Real.exp (-(t : ℝ)) ≤ 1 := by
      rw [← Real.exp_zero]
      exact Real.exp_le_exp.mpr (neg_nonpos.mpr t.coe_nonneg)
    have hexp0 : 0 ≤ Real.exp (-(t : ℝ)) := (Real.exp_pos _).le
    have hp := p.2
    rw [abs_mul, abs_of_nonneg hexp0]
    nlinarith [mul_nonneg (sub_nonneg.mpr hexp1) (sub_nonneg.mpr hp),
      abs_nonneg p.1]⟩

theorem linearFlow_zero (p : IntervalState) : linearFlow 0 p = p := by
  apply Subtype.ext
  show Real.exp (-((0 : NNReal) : ℝ)) * p.1 = p.1
  rw [NNReal.coe_zero, neg_zero, Real.exp_zero, one_mul]

theorem linearFlow_add (s t : NNReal) (p : IntervalState) :
    linearFlow (s + t) p = linearFlow s (linearFlow t p) := by
  apply Subtype.ext
  show Real.exp (-((s + t : NNReal) : ℝ)) * p.1
    = Real.exp (-(s : ℝ)) * (Real.exp (-(t : ℝ)) * p.1)
  rw [NNReal.coe_add, neg_add, Real.exp_add]
  ring

/-- The linear flow on the compact interval, packaged as an M0 problem.  The
`localExistsUnique` field carries the honest flow laws; `stateCompact`
carries compactness of the underlying interval (proved below). -/
noncomputable def linearIntervalProblem : CompactGradientFlowProblem where
  State := IntervalState
  Time := NNReal
  Energy := ℝ
  zeroTime := 0
  timeLe := fun s t => (s : ℝ) ≤ (t : ℝ)
  energyLe := fun a b => a ≤ b
  stateCompact := IsCompact {x : ℝ | |x| ≤ 1}
  localExistsUnique :=
    (∀ p, linearFlow 0 p = p) ∧
      ∀ (s t : NNReal) (p), linearFlow (s + t) p = linearFlow s (linearFlow t p)
  energy := fun p => p.1 ^ 2
  flow := linearFlow

/-- The carried compactness proposition is true. -/
theorem linearIntervalProblem_stateCompact : linearIntervalProblem.stateCompact := by
  show IsCompact {x : ℝ | |x| ≤ 1}
  have h : {x : ℝ | |x| ≤ 1} = Set.Icc (-1 : ℝ) 1 := by
    ext x
    simpa [Set.mem_Icc] using
      (abs_le : |x| ≤ (1 : ℝ) ↔ -(1 : ℝ) ≤ x ∧ x ≤ (1 : ℝ))
  rw [h]
  exact isCompact_Icc

/-- **First fully unconditional instance of the M0 hypotheses**: every field
is a theorem for the linear flow on the compact interval. -/
theorem linearInterval_hypotheses :
    CompactGradientFlowHypotheses linearIntervalProblem where
  local_exists_unique :=
    ⟨linearFlow_zero, linearFlow_add⟩
  energy_nonincreasing := by
    intro p s t _ hst
    let sN : NNReal := s
    let tN : NNReal := t
    change (linearFlow tN p).1 ^ 2 ≤ (linearFlow sN p).1 ^ 2
    show (Real.exp (-(tN : ℝ)) * p.1) ^ 2
      ≤ (Real.exp (-(sN : ℝ)) * p.1) ^ 2
    have hmono : Real.exp (-(tN : ℝ)) ≤ Real.exp (-(sN : ℝ)) :=
      Real.exp_le_exp.mpr (neg_le_neg hst)
    have hpos : (0 : ℝ) ≤ Real.exp (-(tN : ℝ)) := (Real.exp_pos _).le
    rw [mul_pow, mul_pow]
    have hsq : Real.exp (-(tN : ℝ)) ^ 2
        ≤ Real.exp (-(sN : ℝ)) ^ 2 := by
      nlinarith [hmono, hpos]
    exact mul_le_mul_of_nonneg_right hsq (sq_nonneg p.1)
  global_exists := fun _ _ _ => ⟨⟨0, by norm_num⟩⟩

/-- Quantitative energy decay of the linear flow: exact exponential rate 2.
This is the model statement the lattice smoothing bounds (M2) discretize. -/
theorem linearFlow_energy_decay (t : NNReal) (p : IntervalState) :
    (linearFlow t p).1 ^ 2 = Real.exp (-(2 * (t : ℝ))) * p.1 ^ 2 := by
  show (Real.exp (-(t : ℝ)) * p.1) ^ 2 = _
  have h : Real.exp (-(t : ℝ)) ^ 2 = Real.exp (-(2 * (t : ℝ))) := by
    rw [sq, ← Real.exp_add]
    congr 1
    ring
  rw [mul_pow, h]

end YMFlow
