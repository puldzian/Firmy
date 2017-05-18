# FIRMY
# Piotr Puldzian Płucienniczak

## Załaduj biblioteki
# Używana przy ładowaniu plików
library(data.table)
# Metoda na wybieranie pierwszych słów
library(stringi)
## nie ładuj bibliotek dopóki nie są naprawde potrzebne!
library(dplyr)

## ŁADOWANIE FIRM
## Prawidłowo ładujemy wszystkie bazy
plikibaz = list.files(path = "bazy", pattern = "*csv", full.names = TRUE)
tymczasem <- lapply(plikibaz, fread, sep=",")
bazafirm <- rbindlist( tymczasem )
# Sprzątamy śmieci
rm(tymczasem, plikibaz)
# Usuń dwie zbedne kolumny
bazafirm[,2] <- NULL
bazafirm[,2] <- NULL
# write.csv (bazafirm, file = "złom/bazafirm_00.csv, row.names = FALSE")
# bazafirm = read.csv(file = "złom/bazafirm_00.csv")
# Tutaj plik ma 1050799 wpisów
# Zostaw tylko pierwsze słowa
# Przesuwam kolumny, bo w [,1] <- [,1] funkcja się jebie
# To jest najsłabszy element całego skryptu
bazafirm$V1 <- stri_extract_first_words(bazafirm$nazwafirmy)
bazafirm$nazwafirmy <- NULL
# write.csv (bazafirm, file = "złom/bazafirm_01.csv, row.names = FALSE")
# bazafirm = read.csv(file = "złom/bazafirm_01.csv")
# Tutaj plik ma 1050761 wpisów
# Zostaw dłuższe niż 3 znaki
bazafirm <- subset(bazafirm, nchar(as.character(bazafirm$V1)) > 3) 
# write.csv (bazafirm, file = "złom/bazafirm_02.csv", row.names = FALSE)
# Tutaj plik ma 934416 wpisów
# Usuń wpisy zawierające znaki specjalne
bazafirm <- as.data.frame(bazafirm[-grep("[.,-]", bazafirm$V1),])
# write.csv (bazafirm, file = "złom/bazafirm_03.csv", row.names = FALSE)
# Tutaj plik ma 925067 wpisów
# Usuń wpisy zawierające cyfry
bazafirm <- as.data.frame(bazafirm[-grep("[0-9]", bazafirm[,1]),])
# write.csv (bazafirm, file = "złom/bazafirm_04.csv", row.names = FALSE)
# Tutaj plik ma 924601 wpisów
# Obniż literki
bazafirm <- as.data.frame(sapply(bazafirm,tolower))
#Usuń powtórki i braki danych
bazafirm <- unique(bazafirm)
bazafirm <- na.omit(bazafirm)
# Ustaw alfabetycznie, jest pięknie
bazafirm[,1] <- sort(bazafirm[,1])
colnames(bazafirm) <- c("V1")
write.csv (bazafirm, file = "złom/bazafirm_99.csv", row.names = FALSE)
# Finiszowy plik ma 124289 wpisów, to indywidualne pierwsze wyrazy nazw
# przedsiębiorstw dłuższe niż 3 znaki

## ŁADOWANIE SŁOWNIKÓW
# Metoda taka, jak wyżej
plikislownikow = list.files(path = "slowniki", pattern = "*txt", full.names = TRUE)
tymczasem <- lapply(plikislownikow, fread, sep=",")
bazaslow <- rbindlist( tymczasem )
bazaslow <- as.data.frame(sapply(bazaslow,tolower))
# Sprzątamy śmieci
rm(tymczasem, plikislownikow)
# Obniż słowniki!!!
write.csv (bazaslow, file = "złom/bazaslow_99.csv", row.names = FALSE)

### KOPIE ZAPASOWE - TUTAJ ZACZYNA SIĘ PRZYGODA
# Bazafirm -  124289 rekordów
# Bazaslow - 3613135 (pl, ang, niem, nazwiska, miejsca)
bazafirm = read.csv(file = "złom/bazafirm_99.csv")
bazaslow = read.csv(file = "złom/bazaslow_99.csv", header = FALSE)

## PORÓWNAJ BAZĘ ZE SŁOWNIKIEM
zwykleslowa = bazafirm$V1 %in% bazaslow$V1
noweslowa = bazafirm$V1[!zwykleslowa]
bazanowych = as.data.frame(noweslowa)
# Baza ma 77902 wpisy
# Wyjeb wszystko, co kończy się na -ska -ski -scy -cka -czyk
bazanowych$koncuwka = grepl(pattern = "(ska|ski|scy|cka|czyk|iacy|iego|skie)$", bazanowych$noweslowa)
bazanowych = bazanowych[bazanowych$koncuwka == FALSE,] 
# Baza ma 73868 wpisów
bazanowych$koncuwka = NULL
write.table(bazanowych, file="warianty/firmy_bazowe.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )
# Podnieś pierwszą literę każdego wpisu
capFirst <- function(s) {
  paste(toupper(substring(s, 1, 1)), substring(s, 2), sep = "")
}
bazanowych$noweslowa <- capFirst(bazanowych$noweslowa)
# Nazwijmy to normalnie
firmy <- bazanowych
firmy$slowa <- firmy$noweslowa
firmy$noweslowa <- NULL

# Podział na litery
podzielLitery = function() {
  for (i in LETTERS) {
    literka = as.character(i)
    temp = firmy[grepl(pattern = paste("^", literka, sep="", collapse="|"), firmy$slowa),]
    filepath = paste("warianty/alfabet/liter", literka, ".txt", sep="", collapse="|")
    write.table(temp, file = filepath, col.names = FALSE, quote = FALSE, row.names = FALSE)
  }
}

# Eksport dla notesu
firmy$pol = grepl(pattern = "(pol)$", firmy$slowa)
firmypol = firmy[firmy$pol == TRUE,] 
firmypol1000 = sample(firmypol[,1], 1000)
firmypol1000 = sort(firmypol1000)
firmypol1000 = as.data.frame(firmypol1000)
write.table(firmypol1000, file="notes/firmypol.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

firmy$ex = grepl(pattern = "(ex)$", firmy$slowa)
firmyex = firmy[firmy$ex == TRUE,] 
