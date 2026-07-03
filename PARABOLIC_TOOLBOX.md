# Parabolic Toolbox

Primary consumer: Yang-Mills flow.

Non-goal: Navier-Stokes is not a target of this repository.  If a later
Navier-Stokes repository exists, it should fork reusable parabolic material
from here instead of steering this repository.

## Shared obligations

| Obligation | Mathlib status | Repository status |
| --- | --- | --- |
| ODE local existence | Present via `Analysis/ODE/PicardLindelof.lean` | Not yet specialized |
| ODE uniqueness/comparison | Present via `Analysis/ODE/Gronwall.lean` | Not yet specialized |
| Compact global extension | Ingredients present | Frontier |
| Gradient-flow energy identity | Ingredients present | Frontier |
| Gagliardo-Nirenberg-Sobolev | Present via `Analysis/FunctionalSpaces/SobolevInequality.lean` | Not yet adapted |
| Heat/parabolic smoothing | Partial general infrastructure | Frontier |
| Epsilon-regularity | Not present for Yang-Mills | Frontier |
| Uhlenbeck compactness | Not present | Frontier |

## Upstream plan

Propose upstream when statements are physics-independent:

- global extension of ODE solutions on compact finite-dimensional spaces;
- energy monotonicity for abstract negative-gradient flow;
- finite product compactness and Haar helpers;
- clean reusable Sobolev inequality wrappers.

Keep local until the formulation stabilizes:

- Wilson action;
- gauge covariance of lattice flow;
- plaquette smoothing bounds;
- `t0` scale definitions;
- continuum Yang-Mills bibliographic wrappers.

## First proof path

1. Replace `CompactGradientFlowHypotheses.local_exists_unique` with a theorem
   using Mathlib Picard-Lindelof or manifold integral-curve APIs.
2. Add an explicit negative-gradient equation to `CompactGradientFlowProblem`.
3. Prove `energy_nonincreasing` from the chain rule and the gradient equation.
4. Prove global-in-time extension from compactness.
5. Instantiate the abstract result for finite lattice configuration spaces.
