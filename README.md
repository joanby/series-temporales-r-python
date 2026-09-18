# Series Temporales con R y Python

Material de código del curso **Series Temporales con R y Python**, de [Frogames Formación](https://cursos.frogamesformacion.com).

Cada carpeta es un módulo del curso, con dos subcarpetas — `Python/` y `R/` — que contienen los notebooks/scripts y los datasets que se usan en las lecciones de ese módulo. Las lecciones (teoría, explicaciones, ejercicios) están en la plataforma del curso; este repo es solo el código que acompaña a cada una: cuando una lección dice "abre `05-modelos-ar/Python/02_ar_precios.ipynb` y ejecútalo", es aquí donde lo encuentras.

## Cómo usar este repo

**Python**: cada módulo trae sus dependencias exactas en `requirements.txt` (en la raíz del repo, versión única para todo el curso — ver más abajo). Recomendado con [`uv`](https://docs.astral.sh/uv/):

```bash
uv venv --python 3.11
source .venv/bin/activate
uv pip install -r requirements.txt
jupyter lab
```

**R**: cada script `.R` indica al principio qué paquetes necesita (`library(...)`). Instálalos con `install.packages("nombre")` la primera vez, o usa el listado de versiones fijadas más abajo.

## Versiones fijadas

Este curso se auditó y se probó de verdad, celda a celda, contra estas versiones (Python 3.11, R 4.6):

```
pandas 3.0.5 · numpy 2.4.6 · matplotlib 3.11.2 · scipy 1.17.1 · statsmodels 0.15.0
scikit-learn 1.9.1 · seaborn 0.13.2 · yfinance 1.7.0 · arch 8.0.0 · pmdarima 2.1.1
prophet 1.4.0 · cmdstanpy 1.3.0 · tensorflow 2.21.0 · keras 3.15.1
```

```
forecast 9.0.2 · tseries 0.10.63 · lubridate 1.9.5 · zoo 1.9.0 · xts 0.14.3
quantmod 0.4.29 · TTR 0.24.4 · pracma 2.4.6 · anomalize 0.3.0 · fpp2 2.5.1
```

Si un notebook o script falla con una versión más nueva, es más probable que sea la librería la que cambió su API — antes de abrir un issue, prueba con las versiones de esta tabla.

### Excepción: Módulo 14 (Métodos modernos de forecasting) tiene su propio entorno

`14-metodos-modernos-de-forecasting/` **no usa el `requirements.txt` de esta raíz** — usa el suyo
propio, en esa misma carpeta. Motivo: `statsforecast` (Lección 1 de ese módulo) no tiene ninguna
versión que soporte a la vez `pandas==3.0.5` y `scipy==1.17.1` (los pines de esta raíz) — es un techo
real del ecosistema Nixtla, no un fix de una línea:

- `statsforecast>=2.1.0` (la serie estable actual, `2.1.1` en el momento de escribir esto) fija
  `pandas<3.0.0` en su propio `requires_dist` — incompatible de raíz con `pandas==3.0.5`.
- `statsforecast==2.0.3` (la última que no pone techo a `pandas`, acepta `pandas>=1.3.5`) fija a
  cambio `scipy<1.16.0` — incompatible con el `scipy==1.17.1` de esta raíz.

No hay ninguna versión publicada que satisfaga las dos restricciones a la vez. **Re-verificado el
2026-09-18** con `uv pip install "pandas==3.0.5" "scipy==1.17.1" "statsforecast==2.1.1" --dry-run`
contra PyPI en un venv limpio, que falla con:

```
× No solution found when resolving dependencies:
╰─▶ Because statsforecast>=2.1.1 depends on pandas<3.0.0 and you
    require pandas==3.0.5, we can conclude that your requirements and
    statsforecast>=2.1.1 are incompatible.
    And because you require statsforecast==2.1.1, we can conclude that your
    requirements are unsatisfiable.
```

Ese entorno separado es idéntico a este en todo excepto `pandas` (rama 2.x en vez de 3.0.5); añade
además `statsforecast` y `neuralforecast`. Antes de trabajar en ese módulo:

```bash
cd 14-metodos-modernos-de-forecasting
uv venv --python 3.11 .venv
source .venv/bin/activate
uv pip install -r requirements.txt
```

El resto de módulos (01-13, 15) siguen usando el `requirements.txt` de esta raíz sin cambios.

## Sobre este código

Código de acompañamiento del curso, escrito y verificado para las versiones actuales de cada librería.

---
© Frogames Formación | Juan Gabriel Gomila
