# Modulo 3 - Pasajeros de avion en R: descomposicion clasica y STL
# Curso: Series Temporales con R y Python (Frogames Formacion)
# Codigo de acompanamiento de la leccion 03-caracteristicas-fundamentales/05-autocorrelacion-temperaturas-y-pasajeros-en-r
# Ejecuta este script con: Rscript 02_pasajeros_avion.R
#
# NUEVO: no habia hasta ahora una version en R de esta serie (solo existia en Python).
# AirPassengers ya viene incluido en R base (paquete "datasets"), no hace falta descargar ningun CSV.

library(forecast)
library(ggplot2)

cat("=== AirPassengers: pasajeros de avion mensuales, 1949-1960 (miles) ===\n")
cat("Clase:", class(AirPassengers), "\n")
cat("Frecuencia:", frequency(AirPassengers), " | inicio:", start(AirPassengers), " | fin:", end(AirPassengers), "\n")
print(head(AirPassengers, 12))

png("airline_plot.png", width = 900, height = 500, res = 120)
plot(AirPassengers, main = "Pasajeros de avion mensuales (miles), 1949-1960", ylab = "Pasajeros (miles)")
dev.off()

cat("\n\n=== Descomposicion clasica ADITIVA ===\n")
dec_add <- decompose(AirPassengers, type = "additive")
png("airline_decompose_additive.png", width = 900, height = 650, res = 120)
plot(dec_add)
dev.off()

cat("Amplitud del residuo aditivo al principio (1950) vs al final (1959), sd:\n")
resid_add <- na.omit(dec_add$random)
cat("  1950:", round(sd(window(resid_add, start = c(1950, 1), end = c(1950, 12))), 3), "\n")
cat("  1959:", round(sd(window(resid_add, start = c(1959, 1), end = c(1959, 12))), 3), "\n")

cat("\n\n=== Descomposicion clasica MULTIPLICATIVA ===\n")
dec_mult <- decompose(AirPassengers, type = "multiplicative")
png("airline_decompose_multiplicative.png", width = 900, height = 650, res = 120)
plot(dec_mult)
dev.off()

resid_mult <- na.omit(dec_mult$random)
cat("Amplitud del residuo multiplicativo (sd), 1950 vs 1959:\n")
cat("  1950:", round(sd(window(resid_mult, start = c(1950, 1), end = c(1950, 12))), 4), "\n")
cat("  1959:", round(sd(window(resid_mult, start = c(1959, 1), end = c(1959, 12))), 4), "\n")

cat("\n\n=== STL: Seasonal-Trend decomposition using Loess ===\n")
stl_fit <- stl(AirPassengers, s.window = "periodic")
png("airline_stl.png", width = 900, height = 650, res = 120)
plot(stl_fit)
dev.off()

png("airline_stl_ggplot.png", width = 900, height = 650, res = 120)
print(autoplot(stl_fit))
dev.off()

cat("\n\n=== Comparando aditivo, multiplicativo y STL con autoplot ===\n")
png("airline_autoplot.png", width = 900, height = 500, res = 120)
print(autoplot(AirPassengers) + ggtitle("AirPassengers -- autoplot"))
dev.off()

cat("\nListo. PNGs generados: airline_plot.png, airline_decompose_additive.png,\n")
cat("airline_decompose_multiplicative.png, airline_stl.png, airline_stl_ggplot.png, airline_autoplot.png\n")
