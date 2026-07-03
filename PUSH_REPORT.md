# Informe de sesión — lean-ym-flow (empuje M0-instancia + toolbox discreto)

## Plantilla §B2

```
HECHO:
  Rama push/m0-discrete-parabolic (candidato a main, 0 sorry, 0 axiom):
    DiscreteHeat.lean — primera matemática parabólica real del repo, sin
      dependencias de interfaces: PRINCIPIO DEL MÁXIMO Y DEL MÍNIMO
      DISCRETOS para el esquema de Euler explícito del calor en grafos
      finitos ponderados bajo la condición CFL τ·deg(v) ≤ 1; estabilidad en
      norma sup; CONSERVACIÓN EXACTA DE MASA para pesos simétricos
      (antisimetría bajo el intercambio de vértices — el mismo truco de
      swap que funcionó en os-positivity); y persistencia de ambas
      propiedades bajo iteración del esquema. Son las dos columnas de todo
      argumento parabólico de M2/M4 en versión discreta, y los enunciados
      exactos que ym-lattice-numerics puede espejar empíricamente
      (smearing).
    LinearModel.lean — PRIMERA INSTANCIA TOTALMENTE INCONDICIONAL de
      CompactGradientFlowHypotheses: el flujo lineal x ↦ e^{−t}x sobre el
      intervalo compacto {|x| ≤ 1}, con Time = ℝ≥0. Cada campo es teorema:
      las leyes de flujo (condición inicial + semigrupo) instancian el
      campo Prop localExistsUnique y están probadas; la monotonía de
      energía está probada; la proposición de compacidad cargada por el
      problema está probada aparte (linearIntervalProblem_stateCompact); y
      de propina el decaimiento EXACTO de energía a tasa 2
      (linearFlow_energy_decay) — el enunciado modelo que las cotas de
      smoothing de M2 discretizan.
    HYPOTHESIS_FRONTIER.md actualizado. Barrel extendido solo aditivamente.
  Rama frontier/M0-M2 (statements-first, sorried, NUNCA a main):
    Frontier/MatrixFlow.lean — monotonía de energía para el semigrupo
      matricial exp(−tL) con L PSD simétrica (ruta Matrix.exp + teorema
      espectral); la mejora Picard-Lindelöf de localExistsUnique (unicidad
      contra TODA solución competidora, no solo las leyes de flujo); el
      puente M1 (el esquema discreto converge al semigrupo del laplaciano
      del grafo); y el smoothing de Lüscher discreto con la nota TODO de
      constantes explícitas para ym-lattice-numerics.
SIGUIENTE: verificar CI en push/m0-discrete-parabolic; luego
  iterate_heatStep_oscillation_decay con constantes explícitas (gap
  espectral del laplaciano del grafo) como unidad — es el entregable
  directo M2 → ym-lattice-numerics.
BLOQUEOS: ninguno. La realización SU(2)^aristas de M1 sigue pendiente de la
  capa Peter-Weyl compartida (mismo bloqueador que lean-2d-yang-mills;
  coordinar, no duplicar).
IMPACTO-INTERFAZ: Interfaces.lean INTACTO. Barrel con dos imports aditivos.
  Nota de diseño para el Revisor (sin tocar nada): los campos Prop-como-dato
  del problema (localExistsUnique, stateCompact) permiten instanciarse con
  proposiciones débiles; la instancia de main documenta explícitamente QUÉ
  proposición carga cada campo y la prueba aparte — patrón recomendado
  para futuras instancias, y el mismo hallazgo de subespecificación que en
  lean-connes-kreimer (allí con Nonempty, aquí con Prop-campos).
HONESTIDAD: (1) La instancia lineal muestra que la interfaz M0 es sana, NO
  que el análisis general esté hecho: el caso variedad compacta general
  sigue abierto y así consta. (2) localExistsUnique se instancia con las
  leyes de flujo, no con unicidad Picard-Lindelöf: la diferencia está
  declarada en el docstring y la mejora está enunciada en frontier.
  (3) Empuje escrito SIN build local de Mathlib (límites del contenedor);
  el CI es el juez: push/m0-discrete-parabolic NO toca main sin heartbeat
  verde. (4) Navier-Stokes NO es objetivo de este repo; nada aquí lo
  contradice.
```

## Cómo aplicar

```bash
git fetch origin
git checkout -b push/m0-discrete-parabolic origin/main
git am 0001-*.patch
git push -u origin push/m0-discrete-parabolic   # CI juzga; si verde → PR a main
git checkout -b frontier/M0-M2
git am 0002-*.patch
git push -u origin frontier/M0-M2
```

## VERIFICATION — puntos de riesgo del primer build (orden de probabilidad)

1. Los `nlinarith` de los principios del máximo/mínimo llevan como hints los
   dos productos exactos que cierran la desigualdad
   ((1 − τ·deg)·(M − u v) ≥ 0 y τ·A ≤ τ·deg·M); si nlinarith no cierra,
   sustituir por el cálculo lineal explícito con `linarith` tras
   `have h1 := mul_nonneg ...`.
2. `Finset.sum_sub_distrib` / `Finset.sum_add_distrib` / `Finset.mul_sum` /
   `Finset.sum_mul` / `Finset.sum_comm`: estables en el pin.
3. En LinearModel, los `show` encadenados atraviesan las proyecciones de la
   estructura y del subtipo por defeq; si el segundo `show` de
   energy_nonincreasing protesta, sustituir por
   `unfold linearIntervalProblem linearFlow` + `dsimp only`.
4. `NNReal.coe_add`, `NNReal.coe_zero`, `NNReal.coe_le_coe`, `t.coe_nonneg`:
   estables. Si `coe_nonneg` no es proyección directa, usar `t.2`.
5. `Function.iterate_succ_apply'` (f^[n+1] x = f (f^[n] x)): estable; la
   variante sin prima itera por el otro lado.
6. `Real.exp_nat_mul` NO se usa en main (el decaimiento usa sq + exp_add):
   sin riesgo ahí.
7. Frontier: `Matrix.exp` requiere `Mathlib.Analysis.Normed.Algebra.
   MatrixExponential` (cubierto por el import Mathlib global de la rama);
   `⬝ᵥ` (dotProduct) y `Matrix.of` estables. Solo afecta a frontier.
8. `isCompact_Icc` y el `Set.ext fun x => abs_le`: estables.

## Qué gana el madre con este empuje

Cierra la sesión de flota con el patrón completo en los ocho satélites: el
toolbox parabólico ya no es una lista de deseos — tiene su primer teorema
discreto de verdad (máximo + masa, iterados, bajo CFL) en el lenguaje
exacto que ym-lattice-numerics puede certificar numéricamente, y la
interfaz M0 tiene su primera instancia con cero hipótesis cargadas,
incluida la proposición de compacidad probada. La brecha entre "instancia
sana" y "análisis general" queda medida y enunciada en frontier con las
cuatro piezas que la cierran.
