# ============================================================================
# Practica de repaso final: pipeline completo de series temporales en R
# Dataset: AirPassengers (pasajeros mensuales de lineas aereas, 1949-1960)
# Curso: Series Temporales con R y Python (Frogames Formacion)
#
# Este script recorre, de principio a fin, los 7 pasos que deberias aplicar
# tu solo ante CUALQUIER serie temporal nueva que nunca hayas visto:
#   1. Cargar y convertir a objeto ts
#   2. Explorar (grafico, ¿hay tendencia/estacionalidad visible?)
#   3. Test de estacionariedad (tseries::adf.test)
#   4. Descomposicion (clasica o STL)
#   5. Ajustar un modelo (auto.arima())
#   6. Diagnostico de residuos (checkresiduals())
#   7. Prediccion y grafico final con intervalos de confianza
#
# Ejecutar con: Rscript 01_practica_repaso_completa.R
# (genera las imagenes en ./images/ — ejecutar desde esta misma carpeta)
# ============================================================================

if (!requireNamespace("forecast", quietly = TRUE)) {
  install.packages("forecast", repos = "https://cloud.r-project.org")
}
if (!requireNamespace("tseries", quietly = TRUE)) {
  install.packages("tseries", repos = "https://cloud.r-project.org")
}

library(forecast)
library(tseries)

dir.create("images", showWarnings = FALSE)

cat("\n============================================================\n")
cat("PASO 1 — Cargar y convertir a objeto ts\n")
cat("============================================================\n")

# AirPassengers ya viene como ts() en el propio R (dataset de ejemplo). Si
# partieras de un CSV, el equivalente seria:
#   df <- read.csv("mi_serie.csv")
#   serie <- ts(df$valor, start = c(anio_inicio, mes_inicio), frequency = 12)
data("AirPassengers")
serie <- AirPassengers

cat("Clase del objeto:", class(serie), "\n")
cat("Inicio:", paste(start(serie), collapse = "-"),
    "| Fin:", paste(end(serie), collapse = "-"),
    "| Frecuencia:", frequency(serie), "\n")
cat("Numero de observaciones:", length(serie), "\n")
print(head(serie, 12))

cat("\n============================================================\n")
cat("PASO 2 — Exploracion visual: ¿tendencia? ¿estacionalidad?\n")
cat("============================================================\n")

png("images/01-serie-original.png", width = 1000, height = 520, res = 120)
plot(serie,
     main = "AirPassengers — pasajeros mensuales de lineas aereas (1949-1960)",
     ylab = "Pasajeros (miles)", xlab = "Año",
     col = "#449cb9", lwd = 2)
dev.off()

cat("Grafico guardado en images/01-serie-original.png\n")
cat("Lectura a simple vista: tendencia creciente clara, y la amplitud de las\n")
cat("oscilaciones estacionales CRECE con el nivel de la serie (mas grande al\n")
cat("final que al principio) — la señal de un patron MULTIPLICATIVO, no aditivo.\n")

cat("\n============================================================\n")
cat("PASO 3 — Test de estacionariedad (ADF)\n")
cat("============================================================\n")

adf_original <- adf.test(serie)
print(adf_original)

cat("\nOJO a la trampa: el p-valor sale 0.01 (< 0.05), asi que en teoria se\n")
cat("RECHAZA la hipotesis nula de raiz unitaria y adf.test() dice que la\n")
cat("serie 'es estacionaria'. Pero el grafico del paso 2 muestra tendencia y\n")
cat("estacionalidad a simple vista, evidencia contradictoria. La explicacion:\n")
cat("tseries::adf.test() incluye por defecto un termino de tendencia\n")
cat("determinista en la regresion de contraste, asi que en realidad testea\n")
cat("'estacionaria ALREDEDOR de una tendencia', no 'sin tendencia en\n")
cat("absoluto' — con una tendencia tan marcada y limpia como la de\n")
cat("AirPassengers, el test puede rechazar la raiz unitaria aunque la serie\n")
cat("siga sin ser apta para modelizar tal cual. Esta es la razon de fondo\n")
cat("por la que NUNCA te fias de un unico test: lo corroboras siempre con la\n")
cat("inspeccion visual del paso 2 y dejas que el propio algoritmo de\n")
cat("ajuste (paso 5) decida el orden de diferenciacion con sus propios\n")
cat("criterios internos, mas robustos que un test aislado.\n")

serie_log <- log(serie)
adf_log <- adf.test(serie_log)
print(adf_log)

cat("\nMismo resultado sobre el log: p-valor bajo, pero la tendencia sigue\n")
cat("ahi a simple vista. log() estabiliza la VARIANZA (por eso lo aplicamos:\n")
cat("la amplitud estacional creciente del paso 2), no elimina la tendencia.\n")
cat("La diferenciacion real se la dejamos a auto.arima() en el paso 5, que\n")
cat("busca su propio orden (d, D) con un criterio distinto al ADF simple.\n")

cat("\n============================================================\n")
cat("PASO 4 — Descomposicion (STL sobre la serie en escala log)\n")
cat("============================================================\n")

# Con varianza estabilizada (log), STL puede tratar el patron como aditivo
# sobre la escala log-transformada, que es equivalente a multiplicativo en
# la escala original. Alternativa clasica: decompose(serie, type="multiplicative").
descomp_stl <- stl(serie_log, s.window = "periodic")

png("images/02-descomposicion-stl.png", width = 1000, height = 750, res = 120)
plot(descomp_stl,
     main = "Descomposicion STL de log(AirPassengers)")
dev.off()

cat("Grafico guardado en images/02-descomposicion-stl.png\n")
cat("Componentes STL extraidos: seasonal, trend, remainder.\n")
print(summary(descomp_stl))

cat("\n============================================================\n")
cat("PASO 5 — Ajustar un modelo: auto.arima() sobre la serie en log\n")
cat("============================================================\n")

# auto.arima() ya incluye por si mismo la busqueda del orden de
# diferenciacion (d, D) que vimos que hacia falta en el paso 3, y detecta
# la componente estacional (frequency = 12) automaticamente.
modelo <- auto.arima(serie_log, seasonal = TRUE, stepwise = FALSE,
                      approximation = FALSE, trace = FALSE)

print(summary(modelo))

ord <- arimaorder(modelo)
cat("\nModelo elegido automaticamente: ARIMA(", ord["p"], ",", ord["d"], ",", ord["q"],
    ")(", ord["P"], ",", ord["D"], ",", ord["Q"], ")[", ord["Frequency"], "]\n", sep = "")

cat("\n============================================================\n")
cat("PASO 6 — Diagnostico de residuos\n")
cat("============================================================\n")

png("images/03-diagnostico-residuos.png", width = 1000, height = 750, res = 120)
checkresiduals(modelo)
dev.off()

cat("Grafico guardado en images/03-diagnostico-residuos.png\n")
cat("(el test de Ljung-Box de arriba se ha impreso automaticamente al\n")
cat("llamar a checkresiduals(); interpretacion en la leccion)\n")

cat("\n============================================================\n")
cat("PASO 7 — Prediccion con intervalos de confianza\n")
cat("============================================================\n")

pred <- forecast(modelo, h = 24, level = c(80, 95))

png("images/04-prediccion-final.png", width = 1000, height = 550, res = 120)
plot(pred,
     main = "Prediccion a 24 meses — AirPassengers (escala log)",
     ylab = "log(pasajeros)", xlab = "Año")
dev.off()

cat("Grafico guardado en images/04-prediccion-final.png\n")

cat("\nPrediccion en escala LOG (primeros 6 meses):\n")
print(head(as.data.frame(pred), 6))

# Deshacer el log() para volver a la escala original de pasajeros
pred_original <- data.frame(
  mes            = as.character(time(pred$mean)),
  prediccion     = exp(pred$mean),
  lo80           = exp(pred$lower[, "80%"]),
  hi80           = exp(pred$upper[, "80%"]),
  lo95           = exp(pred$lower[, "95%"]),
  hi95           = exp(pred$upper[, "95%"])
)

cat("\nPrediccion en escala ORIGINAL (pasajeros, miles) — primeros 6 meses:\n")
print(head(pred_original, 6))

cat("\n============================================================\n")
cat("FIN DEL PIPELINE — resumen de las 7 decisiones tomadas\n")
cat("============================================================\n")
cat("1. ts() con frequency=12 (mensual) porque la serie trae 12 obs/año.\n")
cat("2. El grafico muestra tendencia + estacionalidad de amplitud creciente.\n")
cat("3. El ADF por si solo enganya (p=0.01, por el termino de tendencia que\n")
cat("   incluye por defecto) -> se corrobora siempre con la inspeccion visual.\n")
cat("4. La amplitud creciente indica patron multiplicativo -> log() antes de\n")
cat("   descomponer, para poder tratarlo como aditivo en escala log.\n")
cat("5. auto.arima() sobre el log, dejando que el algoritmo busque el orden\n")
cat("   de diferenciacion y la componente estacional por si mismo.\n")
cat("6. checkresiduals() valida que los residuos se comportan como ruido\n")
cat("   blanco antes de confiar en las predicciones.\n")
cat("7. forecast() genera la prediccion con intervalos de confianza, y\n")
cat("   exp() deshace el log() para volver a la escala de pasajeros reales.\n")
