import YMFlow.Interfaces

/-!
# M3: continuum Yang-Mills flow statements

This file intentionally contains no unconditional continuum theorem.  It
records the exact names of future wrappers around published results, each fed
by an explicit hypothesis record.
-/

namespace YMFlow

namespace ContinuousYangMillsProblem

/--
M3 continuum statement wrapper for Rade's global existence theorem in
dimensions two and three.

Bibliographic target: J. Rade, "On the Yang-Mills heat equation in two and
three dimensions", J. Reine Angew. Math. 431 (1992), 123-164.
Precise theorem/page locator remains a frontier bibliographic item before
this wrapper is strengthened beyond an explicit hypothesis.
-/
theorem rade_global_dim_two_three
    (P : ContinuousYangMillsProblem) (h : ContinuousYangMillsHypotheses P)
    (A : P.Connection) :
    P.globalSolution A := by
  exact h.rade_global_dim_two_three A

/--
M3 continuum statement wrapper for the four-dimensional conditional theory of
Struwe and Schlatter.

Bibliographic target: M. Struwe, "The Yang-Mills flow in four dimensions",
Calc. Var. Partial Differential Equations 2 (1994), 123-150; A. Schlatter,
"Global existence of the Yang-Mills flow in four dimensions", J. Reine
Angew. Math. 479 (1996), 133-148; A. Schlatter, "Long-time behaviour of the
Yang-Mills flow in four dimensions", Ann. Global Anal. Geom. 15 (1997), 1-25.
Precise theorem/page locators remain frontier bibliographic items.
-/
theorem struwe_schlatter_dim_four_conditional
    (P : ContinuousYangMillsProblem) (h : ContinuousYangMillsHypotheses P)
    (A : P.Connection) :
    P.globalSolution A := by
  exact h.struwe_schlatter_dim_four_conditional A

/--
M3 continuum statement wrapper for Waldron's no finite-time blow-up theorem
in four dimensions.

Bibliographic target: A. Waldron, "Long-time existence for Yang-Mills flow",
Invent. Math. 217 (2019), 1069-1147, Theorem 1.1.
-/
theorem waldron_no_finite_time_blowup_dim_four
    (P : ContinuousYangMillsProblem) (h : ContinuousYangMillsHypotheses P)
    (A : P.Connection) :
    P.noFiniteTimeBlowUp A := by
  exact h.waldron_no_finite_time_blowup_dim_four A

end ContinuousYangMillsProblem

end YMFlow
