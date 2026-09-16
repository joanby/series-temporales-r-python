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

## Origen

Este curso es un **remake** — no una regrabación — de un curso previo con el mismo temario general. El código de este repo está escrito y verificado de cero para las versiones actuales de cada librería; varios ejemplos y datasets son nuevos (datos de mercado refrescados, casos añadidos). No es una copia de ningún repo de terceros.

---
© Frogames Formación | Juan Gabriel Gomila
