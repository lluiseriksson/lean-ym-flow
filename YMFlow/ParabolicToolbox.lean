import YMFlow.Interfaces

/-!
# M4: shared parabolic toolbox interface

This module tracks reusable analytical obligations without turning them into
axioms.
-/

namespace YMFlow

namespace ParabolicToolboxHypotheses

/--
M4 energy inequality availability, as an explicit toolbox hypothesis.
-/
theorem energy_inequality
    (h : ParabolicToolboxHypotheses) :
    h.energy_inequality_available := by
  exact h.energy_inequality_proof

/--
M4 Gagliardo-Nirenberg type inequality availability, as an explicit toolbox
hypothesis.
-/
theorem gagliardo_nirenberg
    (h : ParabolicToolboxHypotheses) :
    h.gagliardo_nirenberg_available := by
  exact h.gagliardo_nirenberg_proof

/--
M4 epsilon-regularity availability, as an explicit toolbox hypothesis.
-/
theorem epsilon_regularization
    (h : ParabolicToolboxHypotheses) :
    h.epsilon_regularization_available := by
  exact h.epsilon_regularization_proof

end ParabolicToolboxHypotheses

end YMFlow
