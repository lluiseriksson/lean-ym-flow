# Contributing

This repository follows statements-first development with an honesty frontier.

Rules:

- `main` has no `sorry`.
- No project `axiom`.
- A theorem that depends on unproved analysis must take that analysis as an
  explicit hypothesis.
- Frontier branches may contain `sorry`, but every such branch must update
  `HYPOTHESIS_FRONTIER.md`.
- Every public interface change updates `INTERFACES.md`.
- Lemma names are English and Mathlib-style.
- Docstrings for mathematical results must include precise bibliography.  If
  theorem/page data are not yet verified, say so explicitly and keep the result
  as a hypothesis wrapper.
- General-purpose lemmas should be considered for Mathlib upstreaming.

Recommended PR shape:

1. State the target theorem or hypothesis reduction.
2. Mention the exact frontier item being reduced.
3. Run `lake build`.
4. Include any Mathlib audit additions if new imported theory is used.
