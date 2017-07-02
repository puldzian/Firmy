# TUTAJ WKLEJAM SOBIE KOMENDY "NA ZAŚ"

firmybazowe = read.table("warianty/firmy_bazowe.txt", header = F)


# WYWAL DODATKOWE LITERKI
dodatki = c("Ą", "Ć", "Ę", "Ł", "Ń", "Ó", "Ś", "Ż", "Ź")
wysrajLitery = function() {
  for (i in dodatki) {
    literka = as.character(i)
    temp = firmybazowe[grepl(pattern = paste("^", literka, sep="", collapse="|"), firmybazowe$V1),]
    filepath = paste("warianty/alfabet/liter", literka, ".txt", sep="", collapse="|")
    write.table(temp, file = filepath, col.names = FALSE, quote = FALSE, row.names = FALSE)
  }
}
