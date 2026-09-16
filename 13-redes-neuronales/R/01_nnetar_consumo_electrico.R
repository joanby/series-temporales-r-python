# Modulo 13 - Red neuronal autorregresiva (nnetar) sobre consumo electrico
#
# Curso: Series Temporales con R y Python (Frogames Formacion).
# Codigo de acompanamiento de la leccion 05-nnetar-red-autorregresiva-en-r.
# Dataset: APTelectricity.csv (consumo en watt + nº de electrodomesticos activos,
# medido cada 5 minutos), en esta misma carpeta.
#
# Fix de la auditoria tecnica: el script original leia el CSV con una ruta absoluta
# del disco de la autora original y con col_types = cols(X1 = col_skip()). Con la
# version actual de readr, la primera columna (sin nombre en el CSV) se autonombra
# "...1", no "X1" -- se ajusta aqui. La ruta ya es relativa al propio dataset.

library(readr)
library(forecast)
library(ggplot2)

APTelectric <- read_csv("APTelectricity.csv",
                        col_types = cols(...1 = col_skip()))
head(APTelectric)

# Objeto ts -- frecuencia 288 = observaciones cada 5 min dentro de un dia (24*60/5)
myts <- ts(APTelectric$watt, frequency = 288)
plot(myts)

# Ajuste del modelo nnetar (red neuronal autorregresiva), sin variable exogena
set.seed(101)
fit <- nnetar(myts)
fit

# Prediccion a 400 pasos
nnetforecast <- forecast(fit, h = 400, PI = FALSE)
autoplot(nnetforecast)

# Usando una variable exogena: appliances (nº de electrodomesticos activos)
set.seed(101)
fit2 <- nnetar(myts, xreg = APTelectric$appliances)
fit2

# Definiendo los pronosticos de la variable exogena para 10 horas
# (12 observaciones/hora x 10 horas = 120 pasos), asumiendo 2 electrodomesticos activos
y <- rep(2, times = 12 * 10)
nnetforecast <- forecast(fit2, xreg = y, PI = FALSE)
autoplot(nnetforecast)

# Definiendo los pronosticos de la variable exogena para 30 horas
y <- rep(2, times = 12 * 30)
nnetforecast <- forecast(fit2, xreg = y, PI = FALSE)
autoplot(nnetforecast)
