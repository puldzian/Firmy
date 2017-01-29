# FIRMY
# Piotr Puldzian Płucienniczak

## Niezbędne foldery
# /bazy - bazy pobrane przez webscrape

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
bazafirm[,2] <- stri_extract_first_words(bazafirm[,1])
bazafirm[,1] <- NULL
# write.csv (bazafirm, file = "złom/bazafirm_01.csv, row.names = FALSE")
# bazafirm = read.csv(file = "złom/bazafirm_01.csv")
# Tutaj plik ma 1050761 wpisów
# Zostaw dłuższe niż 3 znaki
bazafirm <- subset(bazafirm, nchar(as.character(bazafirm[,1])) > 3) 
# write.csv (bazafirm, file = "złom/bazafirm_02.csv", row.names = FALSE)
# Tutaj plik ma 934416 wpisów
# Usuń wpisy zawierające znaki specjalne
bazafirm <- as.data.frame(bazafirm[-grep("[.,-]", bazafirm[,1]),])
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
# write.csv (bazafirm, file = "złom/bazafirm_06.csv", row.names = FALSE)
# Tutaj plik ma 124289 wpisów

## ŁADOWANIE SŁOWNIKÓW
# Metoda taka, jak wyżej
plikislownikow = list.files(path = "slowniki", pattern = "*txt", full.names = TRUE)
tymczasem <- lapply(plikislownikow, fread, sep=",")
bazaslow <- rbindlist( tymczasem )
# Sprzątamy śmieci
rm(tymczasem, plikislownikow)
# write.csv (bazaslow, file = "złom/bazaslow_06.csv", row.names = FALSE)

## KOPIE ZAPASOWE
# bazafirm = read.csv(file = "złom/bazafirm_06.csv")
# bazaslow = read.csv(file = "złom/bazaslow_06.csv", header = FALSE)
# colnames(bazaform) <- c("V1")

## PORÓWNAJ BAZĘ ZE SŁOWNIKIEM
zwykleslowa = bazafirm$V1 %in% bazaslow$V1
noweslowa = bazafirm$V1[!zwykleslowa]
bazanowych = as.data.frame(noweslowa)
# Baza ma 77902 wpisy
write.table(bazanowych, file="złom/firmy.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )



## Testujemy, co będzie się działo dalej
tester <- as.data.frame(sample(bazafirm[,1], 100))
