import Lake
open Lake DSL

package «YMFlow» where
  -- Satellite repository for finite-dimensional and lattice Yang-Mills flow.

@[default_target]
lean_lib «YMFlow» where
  -- Import root: YMFlow.lean.

@[default_target]
lean_lib «Interfaces» where
  -- Stable contract root imported by THE-ERIKSSON-PROGRAMME.

-- Kept in lockstep with THE-ERIKSSON-PROGRAMME at repository creation time.
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @
    "07642720480157414db592fa85b626dafb71355b"
