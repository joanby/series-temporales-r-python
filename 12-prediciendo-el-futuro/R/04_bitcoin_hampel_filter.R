# Módulo 12 · Bitcoin y detección de atípicos (Hampel Filter) — R
# Curso: Series Temporales con R y Python (Frogames Formación)
# Código de acompañamiento de la lección 12-prediciendo-el-futuro/04-bitcoin-y-hampel-filter
#
# Nota de fuente de datos (ver AUDITORIA-TECNICA.md y course.context.md del curso): el repo
# original de este curso usaba el paquete `coindeskr` para el precio de Bitcoin en R — retirado
# de CRAN porque la API de CoinDesk que envolvía se descontinuo. Se sustituye por Yahoo Finance
# via quantmod::getSymbols(src = "yahoo"), el mismo mecanismo que ya usa el resto del curso.

library(quantmod)
library(pracma)

# ---- Descarga del precio de Bitcoin ----
btc_xts <- getSymbols("BTC-USD", src = "yahoo", from = "2020-01-01", to = "2026-09-16",
                       auto.assign = FALSE)
btc <- as.numeric(Cl(btc_xts))
fechas <- index(btc_xts)
cat("observaciones:", length(btc), "\n")
cat("ultimas 3 fechas:\n")
print(tail(data.frame(fecha = fechas, close = btc), 3))

# ---- Grafico del precio ----
png("bitcoin_precio_r.png", width = 1000, height = 450, res = 110)
plot(fechas, btc, type = "l", col = "#449cb9", lwd = 1.2,
     main = "Bitcoin (BTC-USD) - precio de cierre diario, 2020-2026",
     xlab = "", ylab = "USD")
dev.off()

# ---- Hampel Filter con pracma::hampel() ----
# pracma::hampel(x, k, t0) usa una ventana de (2k+1) puntos centrada en cada observacion,
# calcula la mediana y la MAD locales, y sustituye por la mediana los puntos que se alejan
# mas de t0 desviaciones MAD - misma logica que la version manual usada en Python.
res <- hampel(btc, k = 7, t0 = 3)
atipicos_idx <- res$ind
cat("\nnº de atipicos detectados (t0=3):", length(atipicos_idx), "de", length(btc), "observaciones\n")

top10 <- order(btc[atipicos_idx], decreasing = TRUE)[1:min(10, length(atipicos_idx))]
tabla_top <- data.frame(fecha = fechas[atipicos_idx][top10], precio = btc[atipicos_idx][top10])
cat("\ntop atipicos por precio:\n")
print(tabla_top)

png("bitcoin_hampel_r.png", width = 1000, height = 450, res = 110)
plot(fechas, btc, type = "l", col = "#449cb9", lwd = 1,
     main = "Bitcoin - atipicos detectados por el filtro de Hampel (pracma, k=7, t0=3)",
     xlab = "", ylab = "USD")
points(fechas[atipicos_idx], btc[atipicos_idx], col = "#ff6b6b", pch = 19, cex = 0.7)
dev.off()

# ---- Sensibilidad de t0 ----
res_sensible <- hampel(btc, k = 7, t0 = 2)
cat("\nt0=3:", length(res$ind), "atipicos\n")
cat("t0=2 (mas sensible):", length(res_sensible$ind), "atipicos\n")

cat("\nOK: bitcoin_precio_r.png y bitcoin_hampel_r.png generados en esta carpeta.\n")
