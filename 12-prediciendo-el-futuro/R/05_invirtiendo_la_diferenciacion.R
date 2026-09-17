# Módulo 12 · Invirtiendo la diferenciación — R
# Curso: Series Temporales con R y Python (Frogames Formación)
# Código de acompañamiento de la lección 12-prediciendo-el-futuro/05-invirtiendo-la-diferenciacion
#
# En vez de depender de un CSV local con ruta absoluta al disco de quien lo generó, aquí se usa
# una descarga real y propia del oro via quantmod::getSymbols(src = "yahoo").

library(quantmod)
library(forecast)

# ---- Descarga del precio del oro ----
gold_xts <- getSymbols("GC=F", src = "yahoo", from = "2015-01-01", to = "2026-09-16",
                        auto.assign = FALSE)
gold <- na.omit(Cl(gold_xts))
cat("observaciones:", length(gold), "\n")
print(tail(gold, 3))

# ---- Diferenciar a mano ----
d1 <- diff(gold)
d1 <- d1[!is.na(d1)]
cat("\nprecio original  - media:", round(mean(gold), 2), " sd:", round(sd(gold), 2), "\n")
cat("serie diferenciada - media:", round(mean(d1), 4), " sd:", round(sd(d1), 2), "\n")

png("gold_diferenciacion_r.png", width = 1000, height = 650, res = 110)
par(mfrow = c(2, 1))
plot(gold, main = "Oro (GC=F) - precio original", col = "#449cb9")
plot(d1, main = "Oro - primera diferencia", col = "#7c4dff")
dev.off()

# ---- Train/test y ajuste ARMA(2,2) sobre las diferencias ----
n <- length(d1)
h <- 20
train_d1 <- as.numeric(d1)[1:(n - h)]
modelo <- Arima(train_d1, order = c(2, 0, 2))
pred <- forecast(modelo, h = h)
cat("\nprimeras predicciones (escala diferencia):\n")
print(head(as.numeric(pred$mean)))

# ---- Invertir la diferenciación: acumular + anclar al último precio conocido ----
ultimo_precio_conocido <- as.numeric(gold)[n - h]  # gold tiene un dato mas que d1 (diff pierde el primero)
pred_precio <- ultimo_precio_conocido + cumsum(as.numeric(pred$mean))
real_precio <- as.numeric(gold)[(n - h + 1):n]

rmse_precio <- sqrt(mean((real_precio - pred_precio)^2))
cat("\nRMSE en la escala de precio (dolares):", round(rmse_precio, 2), "\n")
cat("precio medio del tramo test:", round(mean(real_precio), 2), "\n")

png("gold_forecast_reconstruido_r.png", width = 1000, height = 450, res = 110)
plot(real_precio, type = "l", col = "#00e676", lwd = 2,
     main = "Oro - prediccion reconstruida a escala de precio (R)",
     xlab = "dias del tramo test", ylab = "USD",
     ylim = range(c(real_precio, pred_precio)))
lines(pred_precio, col = "#ff6b6b", lwd = 2, lty = 2)
legend("topleft", legend = c("real", "predicho (reconstruido)"), col = c("#00e676", "#ff6b6b"), lty = c(1,2), lwd=2, bty = "n")
dev.off()

cat("\nOK: gold_diferenciacion_r.png y gold_forecast_reconstruido_r.png generados en esta carpeta.\n")
