# Ten plik zawiera ścinki z innych plików
# Wartość historyczna, powiedzmy

# Firmy: ściągnięte przy pomocy http://webscraper.io / nazwiska: http://www.futrega.org/etc/nazwiska.html / słowa polskie: http://sjp.pl/slownik/growy / słowa angielskie: /usr/share/dict/ / słowa niemieckie: ?


### TESTOWANIE BAZY

firmy <- read.csv(file = "slowniki_gotowe/export_firmy.txt", header = FALSE)
dicten <- read.csv(file = "slowniki_gotowe/export_slowniken.txt", header = FALSE)

### KONIEC PLIKU 

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

## Tutaj importuje ten plik z nazwami miejscowości
miejsca = read.csv(file = "miejscowosci2015.csv")

# śliczne eksporty
write.table(baza, file="slowniki_gotowe/export_baza.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )
write.table(nazwiska, file="slowniki_gotowe/export_nazwiska.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

# Funkcja do podnoszenia pierwszych liter rekordu
capFirst <- function(s) {
  paste(toupper(substring(s, 1, 1)), substring(s, 2), sep = "")
}

# Tester na 1000 wpisów
nowe5 <- sample(bazanowych[,1], 5000)
nowe5 <- sort(nowe5)
nowe5 <- capFirst(nowe5)
write.table(nowe5, file="warianty/firmy5.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

## Testujemy, co będzie się działo dalej
tester <- as.data.frame(sample(bazafirm[,1], 100))

# Testowanie dodatkowych filtrów
bazanowych$koncuwka = grepl(pattern = "(nka)$", bazanowych$noweslowa)
filtr_nka = bazanowych[bazanowych$koncuwka == TRUE,] #może zostać

bazanowych$koncuwka = grepl(pattern = "(sna)$", bazanowych$noweslowa)
filtr_sna = bazanowych[bazanowych$koncuwka == TRUE,] #może zostać

bazanowych$koncuwka = grepl(pattern = "(skie)$", bazanowych$noweslowa)
filtr_skie = bazanowych[bazanowych$koncuwka == TRUE,] #może zostać

bazanowych$koncuwka = grepl(pattern = "(tka)$", bazanowych$noweslowa)
filtr_tka = bazanowych[bazanowych$koncuwka == TRUE,] #może zostać

bazanowych$koncuwka = grepl(pattern = "(iego)$", bazanowych$noweslowa)
filtr_iego = bazanowych[bazanowych$koncuwka == TRUE,]

bazanowych$koncuwka = grepl(pattern = "(iacy)$", bazanowych$noweslowa)
filtr_iacy = bazanowych[bazanowych$koncuwka == TRUE,]

