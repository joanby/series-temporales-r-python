## AR en R: ar() base con seleccion automatica de orden (AIC)
## Modulo 05 - Series Temporales con R y Python
## Contrapartida breve en R de la Leccion 03 (AutoReg / ar_select_order en Python).
## Amplia el modulo con su lado en R: seleccion automatica de orden AR por AIC.

cat("=== Serie: capturas anuales de linces (dataset lynx, incluido en R) ===\n")
print(lynx)

cat("\n=== ar() con seleccion automatica de orden por AIC ===\n")
ar_fit <- ar(lynx, method = "mle")
cat("Orden seleccionado (order):", ar_fit$order, "\n")
cat("Coeficientes:\n")
print(ar_fit$ar)
cat("Varianza residual (var.pred):", ar_fit$var.pred, "\n")

png("lynx-ar-orden.png", width = 1000, height = 500, res = 120, bg = "#0d0d10")
par(col.axis = "#a8a8b3", col.lab = "#e1e1e6", col.main = "#ffffff", fg = "#a8a8b3", family = "sans")
plot(1:25, sapply(1:25, function(p) tryCatch(AIC(arima(lynx, order = c(p, 0, 0))), error = function(e) NA)),
     type = "b", col = "#449cb9", pch = 19, lwd = 2,
     xlab = "orden p", ylab = "AIC", main = "AIC por orden AR(p) sobre lynx")
abline(v = ar_fit$order, col = "#00e676", lty = 2, lwd = 2)
legend("topright", legend = paste0("orden elegido por ar(): p=", ar_fit$order),
       text.col = "#e1e1e6", bty = "n")
dev.off()

cat("\n=== Confirmando con arima() al orden elegido ===\n")
arima_fit <- arima(lynx, order = c(ar_fit$order, 0, 0))
print(arima_fit)

cat("\n=== Prediccion a 10 anios ===\n")
library(forecast)
fc <- forecast(arima_fit, h = 10)
print(fc)

png("lynx-ar-forecast.png", width = 1000, height = 500, res = 120, bg = "#0d0d10")
par(col.axis = "#a8a8b3", col.lab = "#e1e1e6", col.main = "#ffffff", fg = "#a8a8b3", family = "sans")
plot(fc, col = "#e1e1e6", lwd = 1.5, fcol = "#449cb9",
     main = paste0("Pronostico AR(", ar_fit$order, ") sobre capturas de linces"))
dev.off()

cat("\nOK -- figuras: lynx-ar-orden.png, lynx-ar-forecast.png\n")
