## Suavizado con TTR y ets() en R
## Módulo 04 - Series Temporales con R y Python

if (!requireNamespace("TTR", quietly = TRUE)) install.packages("TTR", repos = "https://cloud.r-project.org")
if (!requireNamespace("forecast", quietly = TRUE)) install.packages("forecast", repos = "https://cloud.r-project.org")

library(TTR)
library(forecast)

cat("=== SMA con TTR — ejemplo minimo ===\n")
x <- c(1, 2, 3, 4, 5, 6, 7)
print(SMA(x, n = 3))

cat("\n=== SMA sobre lynx, n=3 ===\n")
lynx_sma3 <- SMA(lynx, n = 3)
print(head(lynx_sma3, 10))

cat("\n=== SMA sobre lynx, n=9 ===\n")
lynx_sma9 <- SMA(lynx, n = 9)
print(head(lynx_sma9, 10))

png("lynx-sma.png", width = 1000, height = 500, res = 120, bg = "#0d0d10")
par(col.axis = "#a8a8b3", col.lab = "#e1e1e6", col.main = "#ffffff", fg = "#a8a8b3", family = "sans")
plot(lynx, col = "#e1e1e6", lwd = 1.3, main = "Capturas de linces — serie original vs SMA(3) vs SMA(9)")
lines(lynx_sma3, col = "#449cb9", lwd = 2)
lines(lynx_sma9, col = "#00e676", lwd = 2)
legend("topright", legend = c("Original", "SMA(3)", "SMA(9)"),
       col = c("#e1e1e6", "#449cb9", "#00e676"), lwd = 2, bty = "n", text.col = "#e1e1e6")
dev.off()

cat("\n=== ets() sobre nottem ===\n")
ets_model <- ets(nottem)
print(ets_model)

png("nottem-ets.png", width = 1000, height = 500, res = 120, bg = "#0d0d10")
par(col.axis = "#a8a8b3", col.lab = "#e1e1e6", col.main = "#ffffff", fg = "#a8a8b3", family = "sans")
plot(nottem, lwd = 2, col = "#e1e1e6", main = "Temperaturas de Nottingham — original vs ajuste ets()")
lines(ets_model$fitted, col = "#449cb9", lwd = 2)
legend("topright", legend = c("Original", "Ajuste ets()"),
       col = c("#e1e1e6", "#449cb9"), lwd = 2, bty = "n", text.col = "#e1e1e6")
dev.off()

cat("\n=== Pronóstico ets(), h=12, IC 95% ===\n")
fc <- forecast(ets_model, h = 12, level = 95)
print(fc)

png("nottem-ets-forecast.png", width = 1000, height = 500, res = 120, bg = "#0d0d10")
par(col.axis = "#a8a8b3", col.lab = "#e1e1e6", col.main = "#ffffff", fg = "#a8a8b3", family = "sans")
plot(fc, col = "#e1e1e6", lwd = 1.5, fcol = "#449cb9",
     main = "Pronóstico ets() a 12 meses (IC 95%)")
dev.off()

cat("\n=== ets() forzando Holt-Winters multiplicativo (MMM) ===\n")
ets_mult <- ets(nottem, model = "MMM")
print(ets_mult)

cat("\nOK -- figuras: lynx-sma.png, nottem-ets.png, nottem-ets-forecast.png\n")
