#Einlesen benoetigter Bibliotheken
library(dplyr)
library(ggplot2)
library(rstudioapi)
library(stringr)

#Setzen des Arbeitsverzeichnisses
path <- toString(getSourceEditorContext()$path)
pieces <- as.data.frame(str_split(path, "/"))
path <- ""
for (i in 1:(nrow(pieces) - 1)) {
  if (i == 1) {
    path <- paste0(path, pieces[i, 1])
  } else {
    path <- paste0(path, "/", pieces[i, 1])
  }
}
setwd(path)

#Datum
##Funktion zur Ueberfuehrung des Datums in eine Zahl
dateAsANumber <- function(date) {
  day <- as.numeric(substring(date, 1, 2))
  month <- as.numeric(substring(date, 4, 5))
  year <- as.numeric(substring(date, 7, 10))
  
  days <- (year - 1900) * 365 + floor((year - 1900)/4) + day
  days = days + ifelse(month == 1, 0,
                       ifelse(month == 2, 31,
                       ifelse(month == 3, 59,
                       ifelse(month == 4, 90,
                       ifelse(month == 5, 120,
                       ifelse(month == 6, 151,
                       ifelse(month == 7, 181,
                       ifelse(month == 8, 212,
                       ifelse(month == 9, 243,
                       ifelse(month == 10, 273,
                       ifelse(month == 11, 304,
                       ifelse(month == 12, 334))))))))))))
  if (year %% 4 == 0 & month > 2) {
    days = days + 1
  }
  
  return(days)
}

##Aktuelles Datum als String im deutschen Datumsformat
date <- as.character(Sys.Date())
pieces <- as.data.frame(str_split(date, "-"))
current_date <- paste0(rev(pieces[,1]), collapse = ".")
current_date

#Trainingsteilnahmen im Vergleich zur Spielzeit
#*Es werden zwei z-Werte gebildet: Einer fuer die Trainingsteilnahme, ein
#*zweiter zu den Spielminuten (Einsatzzeit)

##Einlesen des Datensatzes zu den Spielminuten
data = read.csv2("Einsatzzeiten.csv", skip = 4, header = T)
data <- data %>%
  mutate(name = as.factor(paste(SPIELER.VORNAME, SPIELER.NACHNAME))) %>%
  mutate(einsatzzeit = EINSATZ.REAL) %>%
  select(name, einsatzzeit)

##Spielernamen als Vektor speichern
spieler <- levels(data$name)

##Kuerzel fuer die Spieler als Vektor speichern
initialen <- rep(NA, length(spieler))
for (i in 1:length(spieler)) {
  initialen[i] = paste0(substring(strsplit(spieler, " ")[[i]][1], 1, 1),
                        substring(strsplit(spieler, " ")[[i]][2], 1, 3))
}

##Kummulieren der Spielzeiten fuer jeden einzelnen Spieler
zeitenCum <- rep(0, length(spieler))

for (i in 1:length(spieler)) {
  for (j in 1:length(data$name)) {
    if (spieler[i] == data$name[j]) {
      zeitenCum[i] = zeitenCum[i] + data$einsatzzeit[j]
    }
  }
}

##Neuen Data Frame mit den Variablen Nr, Name, Kuerzel und Spielminuten
df <- as.data.frame(cbind(c(1:length(spieler)), spieler, initialen, zeitenCum))
names(df)[1] <- "Nr"

##Total mit Spielen
###Einlesen des Datensatzes fuer alle Teilnahmen inkl. Spiele
data2 <- read.delim("TrainingsteilnahmenTotal.txt", sep = ",", header = F)
colnames(data2) <- c("name", "trainingsteilnahmen")

teilnahmen <- rep(0, length(spieler))

for (i in 1:nrow(df)) {
  for (j in 1:nrow(data2)) {
    if (df$spieler[i] == data2$name[j]) {
      teilnahmen[i] = data2$trainingsteilnahmen[j]
    }
  }
}

teilnahmen <- cbind(df, teilnahmen)

teilnahmen$zeitenCum <- as.numeric(teilnahmen$zeitenCum)

###Grafik
jpeg("Teilnahmen total.jpg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = teilnahmen, y = zeitenCum)) +
  geom_label(label = initialen, label.r = unit(0.25, "lines"), 
             position = "identity") +
  labs(y = "Einsatzzeit in Minuten", 
       x = "Teilnahme am Training", 
       title = "Einsatzzeiten im Verhaeltnis zur Trainingsbeteiligung",
       subtitle = "Gesamte Halbserie mit Spielen")
dev.off()

##Berechnung der z-Werte von Trainingsteilnahmen und Spielzeiten
###Berechnung der z-Werte
for (i in 1:nrow(teilnahmen)) {
  teilnahmen$zZeitenCum[i] <- (teilnahmen$zeitenCum[i] - 
                                 mean(teilnahmen$zeitenCum)) / sd(teilnahmen$zeitenCum)
  teilnahmen$zTeilnahmen[i] <- (teilnahmen$teilnahmen[i] - 
                                  mean(teilnahmen$teilnahmen)) / sd(teilnahmen$teilnahmen)
  teilnahmen$z[i] <- teilnahmen$zZeitenCum[i] - teilnahmen$zTeilnahmen[i]
}

###Herausfiltern von Gastspielern (Spieler unterer Mannschaften)
limit <- nrow(teilnahmen)
for (i in 1:limit) {
  if (teilnahmen$spieler[i] %in% data2$name) {
    teilnahmen <- rbind(teilnahmen, teilnahmen[i,])
  }
}
teilnahmen$Nr <- seq(1:nrow(teilnahmen)) - limit
teilnahmen <- subset(teilnahmen, Nr > 0)

###Grafik
jpeg(file="z total mit Spielen.jpeg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = spieler, y = z)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
  labs(x = "", 
       title = "z-Wertstatistik ueber Spieleranteile",
       subtitle = "Gesamte Hinrunde mit Spielen",
       y = "Kum. z-Werte") +
  scale_y_continuous(limits = c(-3, 3)) +
  theme(axis.text.x = element_text(size = 13)) +
  theme(axis.text.y = element_text(size = 13)) +
  theme(axis.title.y = element_text(size = 13))
dev.off()

##Total ohne Spiele
###Einlesen des Datensatzes fuer alle Teilnahmen inkl. Spiele
data2 <- read.delim("TrainingsteilnahmenTotalWithoutGames.txt", sep = ",", header = F)
colnames(data2) <- c("name", "trainingsteilnahmen")

teilnahmen <- rep(0, length(spieler))

for (i in 1:nrow(df)) {
  for (j in 1:nrow(data2)) {
    if (df$spieler[i] == data2$name[j]) {
      teilnahmen[i] = data2$trainingsteilnahmen[j]
    }
  }
}

teilnahmen <- cbind(df, teilnahmen)

teilnahmen$zeitenCum <- as.numeric(teilnahmen$zeitenCum)

###Grafik
jpeg("Teilnahmen total ohne Spiele.jpg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = teilnahmen, y = zeitenCum)) +
  geom_label(label = initialen, label.r = unit(0.25, "lines"), 
             position = "identity") +
  labs(y = "Einsatzzeit in Minuten", 
       x = "Teilnahme am Training", 
       title = "Einsatzzeiten im Verhaeltnis zur Trainingsbeteiligung",
       subtitle = "Gesamte Halbserie mit Spielen")
dev.off()

##Berechnung der z-Werte von Trainingsteilnahmen und Spielzeiten
###Berechnung der z-Werte
for (i in 1:nrow(teilnahmen)) {
  teilnahmen$zZeitenCum[i] <- (teilnahmen$zeitenCum[i] - 
                                 mean(teilnahmen$zeitenCum)) / sd(teilnahmen$zeitenCum)
  teilnahmen$zTeilnahmen[i] <- (teilnahmen$teilnahmen[i] - 
                                  mean(teilnahmen$teilnahmen)) / sd(teilnahmen$teilnahmen)
  teilnahmen$z[i] <- teilnahmen$zZeitenCum[i] - teilnahmen$zTeilnahmen[i]
}

###Herausfiltern von Gastspielern (Spieler unterer Mannschaften)
limit <- nrow(teilnahmen)
for (i in 1:limit) {
  if (teilnahmen$spieler[i] %in% data2$name) {
    teilnahmen <- rbind(teilnahmen, teilnahmen[i,])
  }
}
teilnahmen$Nr <- seq(1:nrow(teilnahmen)) - limit
teilnahmen <- subset(teilnahmen, Nr > 0)

###Grafik
jpeg(file="z total ohne Spiele.jpeg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = spieler, y = z)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
  labs(x = "", 
       title = "z-Wertstatistik ueber Spieleranteile",
       subtitle = "Gesamte Hinrunde mit Spielen",
       y = "Kum. z-Werte") +
  scale_y_continuous(limits = c(-3, 3)) +
  theme(axis.text.x = element_text(size = 13)) +
  theme(axis.text.y = element_text(size = 13)) +
  theme(axis.title.y = element_text(size = 13))
dev.off()

##Letzter Monat mit Spielen
###Einlesen des Datensatzes fuer alle Teilnahmen inkl. Spiele
data2 <- read.delim("TrainingsteilnahmenLastMonth.txt", sep = ",", header = F)
colnames(data2) <- c("name", "trainingsteilnahmen")

teilnahmen <- rep(0, length(spieler))

for (i in 1:nrow(df)) {
  for (j in 1:nrow(data2)) {
    if (df$spieler[i] == data2$name[j]) {
      teilnahmen[i] = data2$trainingsteilnahmen[j]
    }
  }
}

teilnahmen <- cbind(df, teilnahmen)

teilnahmen$zeitenCum <- as.numeric(teilnahmen$zeitenCum)

###Grafik
jpeg("Teilnahmen letzer Monat mit Spielen.jpg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = teilnahmen, y = zeitenCum)) +
  geom_label(label = initialen, label.r = unit(0.25, "lines"), 
             position = "identity") +
  labs(y = "Einsatzzeit in Minuten", 
       x = "Teilnahme am Training", 
       title = "Einsatzzeiten im Verhaeltnis zur Trainingsbeteiligung",
       subtitle = "Gesamte Halbserie mit Spielen")
dev.off()

##Berechnung der z-Werte von Trainingsteilnahmen und Spielzeiten
###Berechnung der z-Werte
for (i in 1:nrow(teilnahmen)) {
  teilnahmen$zZeitenCum[i] <- (teilnahmen$zeitenCum[i] - 
                                 mean(teilnahmen$zeitenCum)) / sd(teilnahmen$zeitenCum)
  teilnahmen$zTeilnahmen[i] <- (teilnahmen$teilnahmen[i] - 
                                  mean(teilnahmen$teilnahmen)) / sd(teilnahmen$teilnahmen)
  teilnahmen$z[i] <- teilnahmen$zZeitenCum[i] - teilnahmen$zTeilnahmen[i]
}

###Herausfiltern von Gastspielern (Spieler unterer Mannschaften)
limit <- nrow(teilnahmen)
for (i in 1:limit) {
  if (teilnahmen$spieler[i] %in% data2$name) {
    teilnahmen <- rbind(teilnahmen, teilnahmen[i,])
  }
}
teilnahmen$Nr <- seq(1:nrow(teilnahmen)) - limit
teilnahmen <- subset(teilnahmen, Nr > 0)

###Grafik
jpeg(file="z letzter Monat mit Spielen.jpeg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = spieler, y = z)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
  labs(x = "", 
       title = "z-Wertstatistik ueber Spieleranteile",
       subtitle = "Gesamte Hinrunde mit Spielen",
       y = "Kum. z-Werte") +
  scale_y_continuous(limits = c(-3, 3)) +
  theme(axis.text.x = element_text(size = 13)) +
  theme(axis.text.y = element_text(size = 13)) +
  theme(axis.title.y = element_text(size = 13))
dev.off()

##Letzter Monat ohne Spiele
###Einlesen des Datensatzes fuer alle Teilnahmen inkl. Spiele
data2 <- read.delim("TrainingsteilnahmenLastMonthWithoutGames.txt", sep = ",", header = F)
colnames(data2) <- c("name", "trainingsteilnahmen")

teilnahmen <- rep(0, length(spieler))

for (i in 1:nrow(df)) {
  for (j in 1:nrow(data2)) {
    if (df$spieler[i] == data2$name[j]) {
      teilnahmen[i] = data2$trainingsteilnahmen[j]
    }
  }
}

teilnahmen <- cbind(df, teilnahmen)

teilnahmen$zeitenCum <- as.numeric(teilnahmen$zeitenCum)

###Grafik
jpeg("Teilnahmen letzer Monat ohne Spiele.jpg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = teilnahmen, y = zeitenCum)) +
  geom_label(label = initialen, label.r = unit(0.25, "lines"), 
             position = "identity") +
  labs(y = "Einsatzzeit in Minuten", 
       x = "Teilnahme am Training", 
       title = "Einsatzzeiten im Verhaeltnis zur Trainingsbeteiligung",
       subtitle = "Gesamte Halbserie mit Spielen")
dev.off()

##Berechnung der z-Werte von Trainingsteilnahmen und Spielzeiten
###Berechnung der z-Werte
for (i in 1:nrow(teilnahmen)) {
  teilnahmen$zZeitenCum[i] <- (teilnahmen$zeitenCum[i] - 
                                 mean(teilnahmen$zeitenCum)) / sd(teilnahmen$zeitenCum)
  teilnahmen$zTeilnahmen[i] <- (teilnahmen$teilnahmen[i] - 
                                  mean(teilnahmen$teilnahmen)) / sd(teilnahmen$teilnahmen)
  teilnahmen$z[i] <- teilnahmen$zZeitenCum[i] - teilnahmen$zTeilnahmen[i]
}

###Herausfiltern von Gastspielern (Spieler unterer Mannschaften)
limit <- nrow(teilnahmen)
for (i in 1:limit) {
  if (teilnahmen$spieler[i] %in% data2$name) {
    teilnahmen <- rbind(teilnahmen, teilnahmen[i,])
  }
}
teilnahmen$Nr <- seq(1:nrow(teilnahmen)) - limit
teilnahmen <- subset(teilnahmen, Nr > 0)

###Grafik
jpeg(file="z letzter Monat ohne Spiele.jpeg", width = 800, height = 600)
ggplot(data = teilnahmen, aes(x = spieler, y = z)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
  labs(x = "", 
       title = "z-Wertstatistik ueber Spieleranteile",
       subtitle = "Gesamte Hinrunde mit Spielen",
       y = "Kum. z-Werte") +
  scale_y_continuous(limits = c(-3, 3)) +
  theme(axis.text.x = element_text(size = 13)) +
  theme(axis.text.y = element_text(size = 13)) +
  theme(axis.title.y = element_text(size = 13))
dev.off()
