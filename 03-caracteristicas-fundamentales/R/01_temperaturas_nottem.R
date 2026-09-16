# Modulo 3 - Estacionariedad, descomposicion y autocorrelacion en R: temperaturas de Nottingham
# Curso: Series Temporales con R y Python (Frogames Formacion)
# Codigo de acompanamiento de la leccion 03-caracteristicas-fundamentales/05-autocorrelacion-temperaturas-y-pasajeros-en-r
# Ejecuta este script con: Rscript 01_temperaturas_nottem.R

library(tseries)
library(forecast)
library(ggplot2)

cat("=== Estacionariedad: ADF test sobre ruido blanco sintetico (referencia) ===\n")
set.seed(123)
x <- rnorm(1000)
print(adf.test(x))

cat("\n\n=== nottem: temperatura media mensual, castillo de Nottingham (20 anios) ===\n")
png("nottem_plot.png", width = 900, height = 500, res = 120)
plot(nottem, main = "Temperatura media mensual, Nottingham (F)")
dev.off()

cat("\n--- ADF test sobre nottem ---\n")
print(adf.test(nottem))

cat("\n\n=== Descomposicion clasica (additive) ===\n")
png("nottem_decompose.png", width = 900, height = 600, res = 120)
plot(decompose(nottem))
dev.off()

png("nottem_autoplot_decompose.png", width = 900, height = 600, res = 120)
print(autoplot(decompose(nottem, type = "additive")))
dev.off()

mynottem <- decompose(nottem, "additive")
cat("Clase de decompose():", class(mynottem), "\n")
cat("Nombres de los componentes:", paste(names(mynottem), collapse = ", "), "\n")

cat("\n\n=== Serie NO estacionaria: integrando ruido blanco ===\n")
y <- diffinv(x)
png("y_no_estacionaria.png", width = 900, height = 500, res = 120)
plot(y, main = "Integral acumulada de ruido blanco (no estacionaria, tipo random walk)", type = "l")
dev.off()

cat("--- ADF test sobre y (se espera NO rechazar H0: no estacionaria) ---\n")
print(adf.test(y))

cat("\n\n=== ACF y PACF de nottem ===\n")
png("nottem_acf_pacf.png", width = 900, height = 500, res = 120)
par(mfrow = c(1, 2))
acf(nottem, lag.max = 20, main = "ACF -- nottem")
pacf(nottem, lag.max = 20, main = "PACF -- nottem")
dev.off()
par(mfrow = c(1, 1))

cat("\n--- ACF de x (ruido blanco), para contraste ---\n")
png("x_acf_wn.png", width = 900, height = 500, res = 120)
acf(x, main = "ACF -- ruido blanco sintetico")
dev.off()

cat("\n\n=== Alternativa: STL (Seasonal-Trend decomposition using Loess) ===\n")
png("nottem_stl.png", width = 900, height = 600, res = 120)
plot(stl(nottem, s.window = "periodic"))
dev.off()

cat("\nListo. PNGs generados: nottem_plot.png, nottem_decompose.png, nottem_autoplot_decompose.png,\n")
cat("y_no_estacionaria.png, nottem_acf_pacf.png, x_acf_wn.png, nottem_stl.png\n")
