# Modulo 2 - El objeto serie temporal en R: ts(), nottem y limpieza de NAs/outliers
# Curso: Series Temporales con R y Python (Frogames Formacion)
# Codigo de acompanamiento de la leccion 02-manejo-de-series-en-r-y-python/03-objeto-ts-en-r
# Ejecuta este script con: Rscript 02_objeto_serie_temporal.R
# Requiere: Rmissing.csv en la misma carpeta

library(forecast)
library(zoo)
library(ggplot2)

cat("=== Creando un objeto ts desde cero ===\n")
set.seed(1)
mydata <- runif(n = 50, min = 10, max = 45)
mytimeseries <- ts(data = mydata, start = 1956, frequency = 4)
print(class(mytimeseries))
cat("\n--- time(mytimeseries), primeros 8 ---\n")
print(head(time(mytimeseries), 8))

png("ts_sintetica.png", width = 900, height = 500, res = 120)
plot(mytimeseries, main = "Serie sintetica ts(start=1956, frequency=4)")
dev.off()

cat("\n--- redefiniendo el inicio a 1956 T3 ---\n")
mytimeseries2 <- ts(data = mydata, start = c(1956, 3), frequency = 4)
print(head(mytimeseries2, 4))

cat("\n\n=== nottem: temperaturas de Nottingham (dataset base de R) ===\n")
cat("Clase:", class(nottem), "\n")
cat("Frecuencia:", frequency(nottem), " | inicio:", start(nottem), " | fin:", end(nottem), "\n")
print(head(nottem, 12))

png("nottem_serie.png", width = 900, height = 500, res = 120)
plot(nottem, main = "Temperatura media mensual, castillo de Nottingham (F)")
dev.off()

png("nottem_autoplot.png", width = 900, height = 500, res = 120)
print(autoplot(nottem) + ggtitle("Autoplot de la temperatura de Nottingham"))
dev.off()

cat("\n\n=== Datos faltantes y outliers: Rmissing.csv ===\n")
mydata_csv <- read.csv("Rmissing.csv")
myts <- ts(mydata_csv$mydata)
cat("--- summary(myts) ---\n")
print(summary(myts))
cat("\n--- posiciones con NA ---\n")
print(which(is.na(myts)))

png("myts_con_na.png", width = 900, height = 500, res = 120)
plot(myts, main = "Serie con un NA sin tratar")
dev.off()

cat("\n--- na.locf: last observation carried forward ---\n")
myts.NAlocf <- na.locf(myts)
cat("valor imputado en la posicion del NA:", myts.NAlocf[which(is.na(myts))], "\n")

cat("\n--- na.fill: relleno con un valor fijo (33) ---\n")
myts.NAfill <- na.fill(myts, 33)
cat("valor impuesto:", myts.NAfill[which(is.na(myts))], "\n")

cat("\n--- na.interp (forecast): relleno por interpolacion ---\n")
myts.NAinterp <- na.interp(myts)
cat("valor interpolado:", round(myts.NAinterp[which(is.na(myts))], 4), "\n")

cat("\n--- tsoutliers (forecast): deteccion automatica de outliers ---\n")
outliers <- tsoutliers(myts)
print(outliers)

cat("\n--- tsclean: limpia NAs y outliers de una vez ---\n")
mytsclean <- tsclean(myts)
print(summary(mytsclean))

png("myts_limpia.png", width = 900, height = 500, res = 120)
plot(mytsclean, main = "Serie tras tsclean() -- NA y outliers corregidos")
dev.off()

cat("\nListo. PNGs generados: ts_sintetica.png, nottem_serie.png, nottem_autoplot.png, myts_con_na.png, myts_limpia.png\n")
