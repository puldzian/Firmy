# FIRMY Almanach
# Piotr Puldzian Płucienniczak

# library(stringr)
# library(readr)
# library(compare)
library(dplyr)
library(stringi)

# do testów wystarczą te dwa zbiory
firmy <- read.csv(file = "slowniki_gotowe/export_firmy.txt", header = FALSE)
dicten <- read.csv(file = "slowniki_gotowe/export_slowniken.txt", header = FALSE)


# TU SIE PRACUJE!!!
# Jedna wizja f() jest taka, żeby zrobić for i in firmy, dla każdego wersu
# sprawdzać obecność w pozostałych słownikach [albo połączyć je w jeden,
# tak będzie najprościej]
# 1 > połączyć w 1 firmy ze wszystkich województw
# 2 > połączyć w 1 wszystkie słowniki
# 3 > przepuścić funkcję, która dla każdego słowa z firmy szuka odpowiednika
#     w słownikach, i jeśli nie ma - dodaje do firmy_unique

unikat = function() {
  i = 1
  for(i in 5) {
    # od 1 do "długość zbioru firm"
    wyraz = as.character(firmy[i,1])
    # tutaj trzeba: czy wyraz jest w bazie?
    print(wyraz)
    i = i +1
  }
}




# ARCHIWUM
# te gówna nie są już potrzebne, bo wyeksportowałem rafinowany materiał
# do slowniki_export i nie będę tego mulił ponownie

# DONE, jako tako
importujBaze <- function() {
  # ładujemy pliczek z argumentu
  baza <- read.csv(file = "test/bazafirm-test.csv", header = TRUE)
  # ustaw alfabetycznie
  baza[,1] <- sort(baza[,1])
  # usuń dwie zbedne kolumny
  baza[,2] <- NULL
  baza[,2] <- NULL
  # zostaw tylko pierwsze wyrazy
  baza[,1] <- stri_extract_first_words(baza[,1])
  # obniż literki
  baza <- as.data.frame(sapply(baza,tolower))
  # wywal duble
  baza <- unique(baza)
  # wywal puste
  baza <- na.omit(baza)
  # wywal wersy zawierające cyfry
  baza <- as.data.frame(baza[-grep("[0-9]", baza[,1]),])
  # wywal zawierające znaki specjalne
  baza <- as.data.frame(baza[-grep("[.,-]", baza[,1]),])
  # czas uspokoić sytuację z nazwą kolumny
  colnames(baza) <- c("nazwafirmy")
  # wywal krótsze niż 3 znaki
  baza <- subset(baza, nchar(as.character(baza$nazwafirmy)) > 3)
  # pokaż główkę
  head(baza)
}

# DONE
importujNazwiska <- function() {
  # wczytujemy pliczek nazwisk
  nazwiska <- read.csv(file = "slowniki/nazwiska-utf.txt", sep = " ", header = FALSE, flush = TRUE)
  # śmieci precz
  nazwiska[,1] <- NULL
  # proszę o małe literki
  nazwiska <- as.data.frame(sapply(nazwiska,tolower))
  # porządek w kolumnach
  colnames(nazwiska) <- c("nazwafirmy")
  # kolejność alfabetyczna
  nazwiska[,1] <- sort(nazwiska[,1])
  # wywal krótsze niż 3 znaki, bo nie używamy takich
  nazwiska <- subset(nazwiska, nchar(as.character(nazwiska$nazwafirmy)) > 3)  
  # pokaż główkę
  head(nazwiska)
}

# bierzemy słownik polski
importujSlownikPL <- function() {
  # wczytujemy pliczek nazwisk
  slownikpl <- read.csv(file = "slowniki/slowa-utf.txt", sep = " ", header = FALSE, flush = TRUE)
  # proszę o małe literki
  slownikpl <- as.data.frame(sapply(slownikpl,tolower))
  # porządek w kolumnach
  colnames(slownikpl) <- c("nazwiska")
  # kolejność alfabetyczna
  slownikpl[,1] <- sort(slownikpl[,1])
  # wypierdol te kretyńskie znaczki z końca linii
  slownikpl$nazwafirmy <- stri_sub(slownikpl$nazwafirmy, 1, -3)
  # wywal krótsze niż 3 znaki, bo nie używamy takich
  slownikpl <- subset(slownikpl, nchar(as.character(slownikpl$nazwafirmy)) > 3)  
  # pokaż główkę
  head(slownikpl)
}

importujSlownikEN <- function() {
  # wczytujemy pliczek nazwisk
  slowniken <- read.csv(file = "slowniki/american-english.txt", sep = " ", header = FALSE, flush = TRUE)
  # proszę o małe literki
  slowniken <- as.data.frame(sapply(slowniken,tolower))
  # porządek w kolumnach
  colnames(slowniken) <- c("slowniken")
  # kolejność alfabetyczna
  slowniken[,1] <- sort(slowniken[,1])
  # wyprostuj format danych
  slowniken[,1] <- as.character(slowniken[,1])
  # wywal krótsze niż 3 znaki, bo nie używamy takich
  slowniken <- subset(slowniken, nchar(as.character(slowniken)) > 3)  
  # wywal znaki specjalne
  baza <- as.data.frame(baza[-grep("[.,-]", baza),])
  # pokaż główkę
  head(slowniken)
}

# śliczne eksporty
write.table(baza, file="slowniki_gotowe/export_baza.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )
write.table(nazwiska, file="slowniki_gotowe/export_nazwiska.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )
