library(xlsx)
library(rstudioapi)
library(stringr)
library(ggplot2)

# Setzen des Arbeitsverzeichnisses
path <- toString(getSourceEditorContext()$path)
pieces <- as.data.frame(str_split(path, "/"))
pieces
length(pieces)
path <- ""
for (i in 1:(nrow(pieces) - 1)) {
  if (i == 1) {
    path <- paste0(path, pieces[i, 1])
  } else {
    path <- paste0(path, "/", pieces[i, 1])
  }
}
setwd(path)

# Einlesen der Daten zu Tor oder Gegentor
## Ereignis: 0 := Gegentor, 1 := Tor
## Spieler: 0 := nicht auf dem Feld, 1 := eingesetzt
data <- read.xlsx("EW.xlsx", 1)
data$Ort <- factor(data$Ort)
data$Platz <- factor(data$Platz)

df <- as.data.frame(data[,1])
var_names <- names(data)[1]
##Pruefen, ob die Spieler haeufig genug eingesetzt wurden
for (i in 2:(ncol(data) - 1)) {
  if (i < 6 ) {
    df <- cbind(df, data[,i])
    var_names <- c(var_names, names(data)[i])
  } else {
    if (sum(data[,i]) > (nrow(data) / 4)) {
      var_names <- c(var_names, names(data)[i])
      df <- cbind(df, data[,i])
    }
  }
}

##Zuweisen der Variablennamen
names(df) <- var_names

#Erstellen des lm-Modells
##Erstellen der Formel
###Elemente fuer die Formel bestimmen
f <- NULL
for(i in 6:ncol(df)) {
  f <- c(f, names(df)[i])
}
###Diese Angaben gehoeren immer zur Formel
f <- c("Punkteschnitt", "Ort", "Platz", f)
###Endgueltige Formel
formel <- as.formula(paste("Ereignis ~", paste(f, collapse="+")))

##Modell berechnen
model <- lm(formula = formel, data = df)
summary(model)

##Data Frame aus dem Modell erstellen, um sich die Resultate grafisch anzeigen zu lassen
model_df <- as.data.frame(cbind(c("Intercept", f), as.numeric(model$coefficients)))
names(model_df) <- c("Coefficient", "Value")
players <- f[!f %in% "Punkteschnitt"]
players <- players[!players %in% "Ort"]
players <- players[!players %in% "Platz"]
model_df$Coefficient <- factor(model_df$Coefficient, levels = c("Intercept",
                                                                "Punkteschnitt", 
                                                                "Ort", 
                                                                "Platz",
                                                                players),
                               ordered = TRUE
                               )
model_df$Value <- as.numeric(model_df$Value)

##Grafik
jpeg("lm.jpg", width = 800, height = 600)
ggplot(data = model_df, aes(x = Coefficient, y = Value)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size = 18, hjust = 0.5))
dev.off()