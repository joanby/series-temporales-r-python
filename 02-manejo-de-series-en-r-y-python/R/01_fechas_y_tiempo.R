# Modulo 2 - Fechas y tiempo en R
# Curso: Series Temporales con R y Python (Frogames Formacion)
# Codigo de acompanamiento de la leccion 02-manejo-de-series-en-r-y-python/02-fechas-y-tiempo-en-r
# Ejecuta este script con: Rscript 01_fechas_y_tiempo.R

if (!requireNamespace("chron", quietly = TRUE)) install.packages("chron", repos = "https://cloud.r-project.org")
library(lubridate)
library(chron)

cat("\n=== POSIXct vs POSIXlt ===\n")
x <- as.POSIXct("2019-12-25 11:45:34")
y <- as.POSIXlt("2019-12-25 11:45:34")
print(x); print(y)

cat("\n--- unclass(x): segundos desde 1970-01-01 ---\n")
print(unclass(x))
cat("\n--- unclass(y): lista de componentes ---\n")
print(unclass(y))

cat("\n--- y$zone (POSIXlt SI permite extraer componentes) ---\n")
print(y$zone)

cat("\n--- x$zone (POSIXct NO permite extraer componentes: error esperado) ---\n")
result <- try(x$zone, silent = TRUE)
if (inherits(result, "try-error")) {
  cat("Error (esperado):", conditionMessage(attr(result, "condition")), "\n")
} else {
  print(result)
}

cat("\n=== as.Date ===\n")
d <- as.Date("2019-12-25")
print(d); print(class(d))
cat("unclass(d):", unclass(d), "(dias desde 1970-01-01)\n")

cat("\n=== chron ===\n")
ch <- chron::chron("12/25/2019", "23:34:09")
print(ch); print(class(ch))

cat("\n=== strptime: texto a fecha-hora ===\n")
a <- as.character(c("1993-12-30 23:45", "1994-11-05 11:43", "1992-03-09 21:54"))
b <- strptime(a, format = "%Y-%m-%d %H:%M")
print(b); print(class(b))

cat("\n=== lubridate: ymd / dmy / mdy ===\n")
print(ymd(19931123))
print(dmy(23111993))
print(mdy(11231993))

cat("\n=== lubridate: fecha + hora + zona horaria ===\n")
mytimepoint <- ymd_hm("1993-11-23 11:23", tz = "Europe/Madrid")
print(mytimepoint)
print(class(mytimepoint))

cat("\n--- extrayendo componentes ---\n")
cat("minute:", minute(mytimepoint), "\n")
cat("day:", day(mytimepoint), "\n")
cat("hour:", hour(mytimepoint), "\n")
cat("year:", year(mytimepoint), "\n")
cat("month:", month(mytimepoint), "\n")

cat("\n--- modificando un componente (hour de 11 a 14) ---\n")
hour(mytimepoint) <- 14
print(mytimepoint)

cat("\n--- dia de la semana ---\n")
print(wday(mytimepoint))
print(wday(mytimepoint, label = TRUE, abbr = FALSE))

cat("\n--- misma fecha en otra zona horaria ---\n")
print(with_tz(mytimepoint, tz = "Europe/London"))

cat("\n--- intervalo entre dos fechas ---\n")
time1 <- ymd_hm("1993-09-23 11:23", tz = "Europe/Madrid")
time2 <- ymd_hm("1995-11-02 15:23", tz = "Europe/Madrid")
myinterval <- interval(time1, time2)
print(myinterval)
print(class(myinterval))
print(as.duration(myinterval))

cat("\n\n=== Ejercicio: dataframe fecha + tiempo + medida ===\n")
fechas_txt <- c("1998,11,11", "1983/01/23", "1982:09:04", "1945-05-09", 19821224, "1974.12.03", 19871210)
fechas <- ymd(fechas_txt, tz = "CET")
print(fechas)

horas_txt <- c("22 4 5", "04;09;45", "11:9:56", "23,15,12", "14 16 34", "8 8 23", "21 16 14")
horas <- hms(horas_txt)
print(horas)

set.seed(42)
medida <- round(rnorm(7, 10), digits = 2)
print(medida)

tabla <- cbind.data.frame(fecha = fechas, hora = horas, medida = medida)
cat("\n--- dataframe final ---\n")
print(tabla)

cat("\n\n=== Ejercicio 2: minuto, zona horaria y diferencia entre fechas ===\n")
x2 <- ymd_hm(tz = "CET", "2014-04-12 23:12")
minute(x2) <- 7
cat("x2 con minuto cambiado a 7:\n")
print(x2)
cat("x2 visto desde Londres:\n")
print(with_tz(x2, tz = "Europe/London"))

y2 <- ymd_hm(tz = "CET", "2015-12-12 09:45")
cat("diferencia y2 - x2:\n")
print(y2 - x2)
