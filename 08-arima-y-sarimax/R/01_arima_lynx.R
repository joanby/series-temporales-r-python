library(forecast)
library(tseries)

data(lynx)

cat("----- serie lynx -----\n")
print(lynx)

png("lynx-serie.png", width = 1000, height = 450, res = 130)
plot(lynx, main = "Capturas anuales de linces en Canada (1821-1934)", ylab = "capturas", col = "#449cb9", lwd = 1.4)
dev.off()

cat("\n----- ADF test sobre lynx (nivel) -----\n")
print(adf.test(lynx))

lynx_log <- log(lynx)

png("lynx-log.png", width = 1000, height = 450, res = 130)
plot(lynx_log, main = "log(lynx)", ylab = "log(capturas)", col = "#7c4dff", lwd = 1.4)
dev.off()

cat("\n----- ADF test sobre log(lynx) -----\n")
print(adf.test(lynx_log))

png("lynx-acf-pacf.png", width = 1000, height = 450, res = 130)
par(mfrow = c(1, 2))
acf(lynx_log, main = "ACF log(lynx)")
pacf(lynx_log, main = "PACF log(lynx)")
dev.off()

cat("\n----- arima() base R: AR(2) sobre log(lynx) -----\n")
modelo_base <- arima(lynx_log, order = c(2, 0, 0))
print(modelo_base)

cat("\n----- forecast::Arima() -- mismo modelo, interfaz forecast -----\n")
modelo <- Arima(lynx_log, order = c(2, 0, 0))
print(summary(modelo))

cat("\n----- prediccion a 10 anhos -----\n")
pred <- forecast(modelo, h = 10)
print(pred)

png("lynx-forecast.png", width = 1000, height = 450, res = 130)
plot(pred, main = "Prediccion AR(2) sobre log(lynx) -- 10 anhos", col = "#449cb9")
dev.off()

cat("\n----- diagnostico de residuos (Ljung-Box) -----\n")
lb <- Box.test(residuals(modelo), lag = 10, type = "Ljung-Box", fitdf = 2)
print(lb)

png("lynx-residuos.png", width = 1000, height = 600, res = 130)
checkresiduals(modelo)
dev.off()
