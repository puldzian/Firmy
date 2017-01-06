# FIRMY Almanach
# CC-Zero Piotr Puldzian Płucienniczak

# pozostałe chyba niepotrzebne
# library(stringr)
# library(readr)
# library(compare)
library(dplyr)
library(stringi)
library(stringr)




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

# bierzemy słownik angielski
# słownik oxford.txt to gówno

# TU SIE PRACUJE!!!

importujSlownikEN <- function() {
  # wczytujemy pliczek nazwisk
  slowniken <- read.csv(file = "slowniki/oxford.txt", sep = " ", header = FALSE, flush = TRUE)
  # proszę o małe literki
  slowniken <- as.data.frame(sapply(slowniken,tolower))
  # porządek w kolumnach
  colnames(slownikpl) <- c("slownikpl")
  # kolejność alfabetyczna
  slownikpl[,1] <- sort(slownikpl[,1])
  # wypierdol te kretyńskie znaczki z końca linii
  slownikpl$nazwafirmy <- stri_sub(slownikpl$nazwafirmy, 1, -3)
  # wywal krótsze niż 3 znaki, bo nie używamy takich
  slownikpl <- subset(slownikpl, nchar(as.character(slownikpl$nazwafirmy)) > 3)  
  # pokaż główkę
  head(slownikpl)
}


# TUTAJ SIĘ PRACUJE
# PLAN: weź wyraz z firmy, sprawdź czy występuje w słownikach,
# jeśli występuje w którymś to porzuć
# jeśli nie występuje, to przesuń do firmygold

unikat <- function() {
  
  
  
} 






# to ma być maszyna do porównywania zbiorów
# ale się wypierdala, więc trzeba to zrobić inaczej
porownajDane <- function(BAZA, SLOWNIK) {
  require(dplyr)
  bazatbl <- tbl_df(baza)
  nazwtbl <- tbl_df(nazwiska)
  
  # sprawdź z listą nazwisk
  # sprawdź ze słownikiem polskim
  # sprawdź ze słownikiem angielskim
  # sprawdź ze słownikiem niemieckim
}


# w przypadku pełnej bazy
# usuń duplikaty...
# podnieś pierwszą literkę
# coś jeszcze?



# TUTAJ SIE PRACUJE!!

# śliczne eksporty
write.table(baza, file="export_baza.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )
write.table(nazwiska, file="export_nazwiska.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )