# Modulo 2 - ts vs zoo con datos reales: Starbucks y Microsoft
# Curso: Series Temporales con R y Python (Frogames Formacion)
# Codigo de acompanamiento de la leccion 02-manejo-de-series-en-r-y-python/04-ts-vs-zoo-starbucks-microsoft
# Ejecuta este script con: Rscript 03_ts_vs_zoo_starbucks_microsoft.R
# Descarga en vivo de Yahoo Finance via quantmod.

library(quantmod)
library(zoo)

cat("=== Descargando SBUX y MSFT desde Yahoo Finance (quantmod) ===\n")
getSymbols("SBUX", from = "2015-01-01", to = "2026-09-16", src = "yahoo")
getSymbols("MSFT", from = "2015-01-01", to = "2026-09-16", src = "yahoo")

cat("\nSBUX (xts diario, precio ajustado):\n")
print(head(Ad(SBUX)))
cat("Observaciones diarias SBUX:", nrow(SBUX), "\n")

cat("\n--- Guardamos el precio ajustado diario como CSV para el resto del curso ---\n")
sbux_df <- data.frame(Date = index(SBUX), Adj.Close = as.numeric(Ad(SBUX)))
msft_df <- data.frame(Date = index(MSFT), Adj.Close = as.numeric(Ad(MSFT)))
write.csv(sbux_df, "sbuxPrices.csv", row.names = FALSE)
write.csv(msft_df, "msftPrices.csv", row.names = FALSE)

cat("\n\n=== Agregando a frecuencia MENSUAL (quantmod::to.monthly) ===\n")
sbux_m <- to.monthly(SBUX, indexAt = "lastof", OHLC = FALSE)
msft_m <- to.monthly(MSFT, indexAt = "lastof", OHLC = FALSE)
sbux_adj_m <- Ad(sbux_m)
msft_adj_m <- Ad(msft_m)
cat("Observaciones mensuales SBUX:", length(sbux_adj_m), "\n")
print(head(sbux_adj_m))

cat("\n\n=== Objeto ts: frecuencia 12, inicio 2015 ===\n")
sbux.ts <- ts(data = as.numeric(sbux_adj_m), frequency = 12, start = c(2015, 1))
msft.ts <- ts(data = as.numeric(msft_adj_m), frequency = 12, start = c(2015, 1))
cat("Clase:", class(sbux.ts), "\n")
cat("start:", start(sbux.ts), " end:", end(sbux.ts), " frequency:", frequency(sbux.ts), "\n")

cat("\n--- Subconjunto por posicion (tmp = sbux.ts[1:5]): pierde la nocion de tiempo ---\n")
tmp <- sbux.ts[1:5]
cat("class(tmp):", class(tmp), "\n")
print(tmp)

cat("\n--- Subconjunto con window(): mantiene la nocion de tiempo ---\n")
tmp2 <- window(sbux.ts, start = c(2015, 1), end = c(2015, 6))
cat("class(tmp2):", class(tmp2), "\n")
print(tmp2)

cat("\n--- Combinando dos series ts (cbind -> objeto mts) ---\n")
sbuxmsft.ts <- cbind(sbux.ts, msft.ts)
cat("class(sbuxmsft.ts):", class(sbuxmsft.ts), "\n")
print(head(sbuxmsft.ts))

png("sbux_ts.png", width = 900, height = 500, res = 120)
plot(sbux.ts, col = "blue", lwd = 2, ylab = "Precio ajustado", main = "SBUX -- precio mensual (objeto ts)")
dev.off()

png("sbuxmsft_ts.png", width = 900, height = 500, res = 120)
plot(sbuxmsft.ts, plot.type = "single", main = "SBUX vs MSFT -- precio ajustado mensual (ts)",
     ylab = "Precio ajustado", col = c("blue", "red"), lty = 1:2)
legend("topleft", legend = c("SBUX", "MSFT"), col = c("blue", "red"), lty = 1:2)
dev.off()

cat("\n\n=== Lo mismo con zoo: el indice es la FECHA real, no un contador de periodo ===\n")
sbux.z <- zoo(x = as.numeric(sbux_adj_m), order.by = as.Date(index(sbux_adj_m)))
msft.z <- zoo(x = as.numeric(msft_adj_m), order.by = as.Date(index(msft_adj_m)))
cat("class(sbux.z):", class(sbux.z), "\n")
print(head(sbux.z))

cat("\n--- index() y coredata() ---\n")
print(head(index(sbux.z)))
print(head(coredata(sbux.z)))

cat("\n--- start/end reales (fechas, no 'anio + periodo') ---\n")
cat("start:", format(start(sbux.z)), " end:", format(end(sbux.z)), "\n")

cat("\n--- window() con zoo: se indexa con fechas reales, no con anio+trimestre ---\n")
sub_z <- window(sbux.z, start = as.Date("2020-01-01"), end = as.Date("2020-06-01"))
print(sub_z)

cat("\n--- combinando dos zoo (cbind) ---\n")
sbuxmsft.z <- cbind(sbux.z, msft.z)
cat("class(sbuxmsft.z):", class(sbuxmsft.z), "\n")
print(head(sbuxmsft.z))

png("sbuxmsft_zoo.png", width = 900, height = 500, res = 120)
plot(sbuxmsft.z, plot.type = "single", col = c("blue", "red"), lty = 1:2, lwd = 2,
     main = "SBUX vs MSFT -- precio ajustado mensual (zoo, eje = fecha real)",
     ylab = "Precio ajustado", xlab = "Fecha")
legend("topleft", legend = c("SBUX", "MSFT"), col = c("blue", "red"), lty = 1:2)
dev.off()

cat("\n\n=== Lo mismo con datos DIARIOS (sin agregar): aqui el argumento a favor de zoo es mas fuerte ===\n")

sbux.ts.diario <- ts(as.numeric(Ad(SBUX)), start = 1, frequency = 1)
msft.ts.diario <- ts(as.numeric(Ad(MSFT)), start = 1, frequency = 1)
cat("Clase:", class(sbux.ts.diario), " longitud:", length(sbux.ts.diario), "\n")
print(head(sbux.ts.diario))

sbux.z.diario <- zoo(as.numeric(Ad(SBUX)), order.by = as.Date(index(SBUX)))
msft.z.diario <- zoo(as.numeric(Ad(MSFT)), order.by = as.Date(index(MSFT)))
cat("\nClase:", class(sbux.z.diario), " longitud:", length(sbux.z.diario), "\n")
print(head(sbux.z.diario))

cat("\n--- ts diario: la posicion 1,2,3... no dice nada de festivos bursatiles ---\n")
cat("sbux.ts.diario[1:6]:\n")
print(sbux.ts.diario[1:6])
cat("Con ts no hay forma de saber, mirando solo el objeto, si esas 6 observaciones son 6 dias\n")
cat("de calendario consecutivos o si hubo un fin de semana o festivo de por medio -- la posicion\n")
cat("avanza siempre de 1 en 1, pase lo que pase en el calendario.\n")

cat("\n--- zoo diario: los huecos de calendario son visibles directamente en el indice ---\n")
huecos <- diff(index(sbux.z.diario))
cat("Resumen de huecos entre observaciones consecutivas (en dias de calendario):\n")
print(table(huecos))

cat("\n--- El hueco mas largo del periodo (festivo pegado a un fin de semana) ---\n")
i_max <- which.max(huecos)
cat("Entre", format(index(sbux.z.diario)[i_max]), "y", format(index(sbux.z.diario)[i_max + 1]),
    "hay", as.numeric(huecos[i_max]), "dias de calendario sin cotizacion.\n")

cat("\n--- window() con fechas reales: aislar una semana exacta con zoo es trivial ---\n")
semana_navidad <- window(sbux.z.diario, start = as.Date("2025-12-22"), end = as.Date("2025-12-31"))
print(semana_navidad)
cat("\nCon sbux.ts.diario, aislar 'la ultima semana de diciembre de 2025' exige buscar a mano\n")
cat("en que posicion (indice entero) cae esa fecha -- ts no tiene forma de preguntarselo\n")
cat("directamente, porque nunca almaceno la fecha.\n")

cat("\n\nListo. CSV generados: sbuxPrices.csv, msftPrices.csv. PNGs: sbux_ts.png, sbuxmsft_ts.png, sbuxmsft_zoo.png\n")
