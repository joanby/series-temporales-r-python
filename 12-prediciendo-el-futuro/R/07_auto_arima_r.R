# Módulo 12 · Auto ARIMA en R (equipamiento eléctrico zona euro + linces) — R
# Curso: Series Temporales con R y Python (Frogames Formación)
# Código de acompañamiento de la lección 12-prediciendo-el-futuro/07-auto-arima-en-r
#
# Nota de sustitución de dataset (licencia de expansión, ver course.context.md): el script
# original de este bloque (5_R_SARIMA.R) dependía de "germaninfl.xlsx", un fichero que no viaja
# con este repo nuevo. En vez de reconstruir esos datos a mano (arriesgando introducir un dato
# no verificado), se sustituye por `fpp2::elecequip` — pedidos nuevos de equipamiento eléctrico
# de la zona euro (Eurostat, mensual, 1996-2012), un dataset real, publico y del mismo tipo
# (macro europeo, con tendencia y estacionalidad) ya integrado en el ecosistema de forecasting
# de Hyndman que usa el resto del curso. `lynx` (poblacion de linces canadienses, ya en R base)
# se mantiene igual que en el original.

library(forecast)
library(tseries)

# ============================================================
# PARTE 1 — Auto ARIMA sobre pedidos de equipamiento electrico (zona euro)
# ============================================================
data(elecequip, package = "fpp2")
cat("elecequip: serie mensual,", length(elecequip), "observaciones,",
    "de", start(elecequip)[1], "a", end(elecequip)[1], "\n")

png("elecequip_serie.png", width = 1000, height = 450, res = 110)
plot(elecequip, col = "#449cb9", lwd = 1.3,
     main = "Zona euro - nuevos pedidos de equipamiento electrico (indice, Eurostat)")
dev.off()

adf_elec <- adf.test(elecequip)
cat("\nADF test sobre la serie original: estadistico =", round(adf_elec$statistic, 3),
    " p-valor =", round(adf_elec$p.value, 4), "\n")

modelo_elec <- auto.arima(elecequip, stepwise = TRUE, approximation = FALSE)
cat("\nmodelo elegido por auto.arima (stepwise):\n")
print(modelo_elec)

pred_elec <- forecast(modelo_elec, h = 12)
png("elecequip_forecast.png", width = 1000, height = 450, res = 110)
plot(pred_elec, col = "#449cb9",
     main = "Auto ARIMA - equipamiento electrico zona euro, prediccion a 12 meses")
dev.off()

cat("\nresiduos - checkresiduals (Ljung-Box):\n")
lb <- Box.test(residuals(modelo_elec), lag = 12, type = "Ljung-Box", fitdf = length(modelo_elec$coef))
print(lb)

# ---- Stepwise vs busqueda completa: tiempo y modelo elegido ----
t0 <- Sys.time()
modelo_stepwise <- auto.arima(elecequip, stepwise = TRUE)
t_stepwise <- as.numeric(Sys.time() - t0, units = "secs")

t0 <- Sys.time()
modelo_completo <- auto.arima(elecequip, stepwise = FALSE, approximation = FALSE)
t_completo <- as.numeric(Sys.time() - t0, units = "secs")

cat("\nstepwise:", capture.output(modelo_stepwise)[2], " | tiempo:", round(t_stepwise, 2), "s\n")
cat("busqueda completa:", capture.output(modelo_completo)[2], " | tiempo:", round(t_completo, 2), "s\n")

# ============================================================
# PARTE 2 — Auto ARIMA sobre la poblacion de linces (dataset base de R)
# ============================================================
data(lynx)
cat("\n\nlynx: serie anual,", length(lynx), "observaciones, de", start(lynx)[1], "a", end(lynx)[1], "\n")

png("lynx_serie.png", width = 1000, height = 450, res = 110)
plot(lynx, col = "#7c4dff", lwd = 1.3, main = "Poblacion anual de linces canadienses (1821-1934)")
dev.off()

# lynx tiene un ciclo casi decenal muy marcado, pero no es "estacionalidad" en sentido
# calendario (es un ciclo poblacional depredador-presa) - por eso se prueba sin componente
# estacional forzado y se deja que auto.arima decida el orden AR/MA puro.
modelo_lynx <- auto.arima(lynx, stepwise = TRUE, approximation = FALSE)
cat("\nmodelo elegido para lynx:\n")
print(modelo_lynx)

pred_lynx <- forecast(modelo_lynx, h = 10)
png("lynx_forecast.png", width = 1000, height = 450, res = 110)
plot(pred_lynx, col = "#7c4dff", main = "Auto ARIMA - poblacion de linces, prediccion a 10 anos")
dev.off()

cat("\nOK: elecequip_serie.png, elecequip_forecast.png, lynx_serie.png, lynx_forecast.png generados.\n")
