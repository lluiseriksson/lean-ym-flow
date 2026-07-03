import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# The discrete parabolic toolbox: explicit heat scheme on finite graphs

First real parabolic mathematics of the repository, with no interface
dependencies: for the explicit Euler scheme of the heat equation on a finite
weighted graph, under the CFL condition `τ · deg(v) ≤ 1`,

* the **discrete maximum principle** holds (upper and lower), hence the
  sup-norm is nonincreasing;
* **mass is conserved** for symmetric weights;
* both persist under iteration.

These are the discrete counterparts of the comparison principle and the
conservation structure every parabolic argument in M2/M4 rests on, and the
exact statements `ym-lattice-numerics` can mirror empirically for smearing.

References: Lüscher (2010), JHEP 1008:071, Section 2 (gradient-flow
smoothing on the lattice); standard finite-difference parabolic theory,
e.g. Thomée (2006), Chapter 1 (maximum principle under CFL).
-/

namespace YMFlow

open scoped BigOperators

/-- A finite weighted graph with nonnegative symmetric weights. -/
structure WeightedGraph (V : Type u) [Fintype V] where
  weight : V -> V -> ℝ
  weight_nonneg : ∀ x y, 0 ≤ weight x y
  weight_symm : ∀ x y, weight x y = weight y x

namespace WeightedGraph

variable {V : Type u} [Fintype V] (G : WeightedGraph V)

/-- The weighted degree of a vertex. -/
noncomputable def degree (v : V) : ℝ :=
  ∑ x, G.weight v x

theorem degree_nonneg (v : V) : 0 ≤ G.degree v :=
  Finset.sum_nonneg fun x _ => G.weight_nonneg v x

/-- One explicit Euler step of the graph heat equation. -/
noncomputable def heatStep (tau : ℝ) (u : V -> ℝ) : V -> ℝ :=
  fun v => u v + tau * ∑ x, G.weight v x * (u x - u v)

/-- The CFL stability condition for the explicit scheme. -/
def CFL (tau : ℝ) : Prop :=
  0 ≤ tau ∧ ∀ v, tau * G.degree v ≤ 1

/-- Splitting the diffusion term into neighbour mass and degree drain. -/
theorem heatStep_split (tau : ℝ) (u : V -> ℝ) (v : V) :
    G.heatStep tau u v
      = u v + tau * ((∑ x, G.weight v x * u x) - G.degree v * u v) := by
  show u v + tau * (∑ x, G.weight v x * (u x - u v)) = _
  congr 1
  congr 1
  rw [degree, Finset.sum_mul, ← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun x _ => by ring

/-- **Discrete maximum principle.**  Under CFL, one heat step cannot exceed
any pointwise upper bound of the initial datum. -/
theorem heatStep_le_of_le {tau M : ℝ} (hcfl : G.CFL tau) {u : V -> ℝ}
    (hu : ∀ v, u v ≤ M) (v : V) :
    G.heatStep tau u v ≤ M := by
  obtain ⟨htau, hdeg⟩ := hcfl
  have hS : 0 ≤ G.degree v := G.degree_nonneg v
  have hA : (∑ x, G.weight v x * u x) ≤ G.degree v * M := by
    rw [degree, Finset.sum_mul]
    exact Finset.sum_le_sum fun x _ =>
      mul_le_mul_of_nonneg_left (hu x) (G.weight_nonneg v x)
  rw [G.heatStep_split]
  nlinarith [mul_nonneg (sub_nonneg.mpr (hdeg v)) (sub_nonneg.mpr (hu v)),
    mul_le_mul_of_nonneg_left hA htau, hu v]

/-- **Discrete minimum principle.**  Under CFL, one heat step cannot drop
below any pointwise lower bound of the initial datum. -/
theorem le_heatStep_of_le {tau m : ℝ} (hcfl : G.CFL tau) {u : V -> ℝ}
    (hu : ∀ v, m ≤ u v) (v : V) :
    m ≤ G.heatStep tau u v := by
  obtain ⟨htau, hdeg⟩ := hcfl
  have hS : 0 ≤ G.degree v := G.degree_nonneg v
  have hA : G.degree v * m ≤ ∑ x, G.weight v x * u x := by
    rw [degree, Finset.sum_mul]
    exact Finset.sum_le_sum fun x _ =>
      mul_le_mul_of_nonneg_left (hu x) (G.weight_nonneg v x)
  rw [G.heatStep_split]
  nlinarith [mul_nonneg (sub_nonneg.mpr (hdeg v)) (sub_nonneg.mpr (hu v)),
    mul_le_mul_of_nonneg_left hA htau, hu v]

/-- Sup-norm stability: the heat step preserves uniform bounds. -/
theorem abs_heatStep_le {tau M : ℝ} (hcfl : G.CFL tau) {u : V -> ℝ}
    (hu : ∀ v, |u v| ≤ M) (v : V) :
    |G.heatStep tau u v| ≤ M := by
  rw [abs_le]
  constructor
  · exact G.le_heatStep_of_le hcfl (fun w => (abs_le.mp (hu w)).1) v
  · exact G.heatStep_le_of_le hcfl (fun w => (abs_le.mp (hu w)).2) v

/-- **Mass conservation** for symmetric weights: the heat step preserves the
total mass exactly.  Proof: the diffusion double sum is antisymmetric under
the vertex swap. -/
theorem sum_heatStep (tau : ℝ) (u : V -> ℝ) :
    (∑ v, G.heatStep tau u v) = ∑ v, u v := by
  show (∑ v, (u v + tau * ∑ x, G.weight v x * (u x - u v))) = _
  rw [Finset.sum_add_distrib]
  have hswap : (∑ v, ∑ x, G.weight v x * u x)
      = ∑ v, ∑ x, G.weight v x * u v := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun b _ => ?_
    rw [G.weight_symm b a]
  have hsplit : (∑ v, ∑ x, G.weight v x * (u x - u v))
      = (∑ v, ∑ x, G.weight v x * u x) - ∑ v, ∑ x, G.weight v x * u v := by
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun v _ => ?_
    rw [← Finset.sum_sub_distrib]
    exact Finset.sum_congr rfl fun x _ => by ring
  have hzero : (∑ v, tau * ∑ x, G.weight v x * (u x - u v)) = 0 := by
    rw [← Finset.mul_sum, hsplit, hswap, sub_self, mul_zero]
  rw [hzero, add_zero]

/-- The maximum principle persists under iteration of the scheme. -/
theorem iterate_heatStep_le_of_le {tau M : ℝ} (hcfl : G.CFL tau)
    {u : V -> ℝ} (hu : ∀ v, u v ≤ M) (n : ℕ) :
    ∀ v, (G.heatStep tau)^[n] u v ≤ M := by
  induction n with
  | zero =>
    intro v
    simpa using hu v
  | succ n ih =>
    intro v
    rw [Function.iterate_succ_apply']
    exact G.heatStep_le_of_le hcfl ih v

/-- Mass conservation persists under iteration of the scheme. -/
theorem sum_iterate_heatStep (tau : ℝ) (u : V -> ℝ) (n : ℕ) :
    (∑ v, (G.heatStep tau)^[n] u v) = ∑ v, u v := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Function.iterate_succ_apply', G.sum_heatStep, ih]

end WeightedGraph

end YMFlow
