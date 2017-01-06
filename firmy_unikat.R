# do testów wystarczą te dwa zbiory
firmy <- read.csv(file = "slowniki_gotowe/export_firmy.txt", header = FALSE)
dicten <- read.csv(file = "slowniki_gotowe/export_slowniken.txt", header = FALSE)

# łączenie słowników
dictpl <- read.csv(file = "slowniki_gotowe/export_slownikpl.txt", header = FALSE)
dictde <- read.csv(file = "slowniki/ngerman.txt", header = FALSE)
dictna <- read.csv(file = "slowniki_gotowe/export_nazwiska.txt", header = FALSE)

slownik <- rbind(dicten,dictpl,dictde,dictna)

# NO I BADAMY UNIKATY
# http://stackoverflow.com/questions/13774773/check-whether-value-exist-in-one-data-frame-or-not

somtam = firmy$V1 %in% slownik$V1
unikat = firmy$V1[!somtam]

write.table(unikat, file="slowniki_gotowe/unikatFULL.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

# dłuższe niż 4?
unikat4 <- subset(unikat, nchar(as.character(unikat)) > 4)  
write.table(unikat, file="slowniki_gotowe/unikat4.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

# te które kończą się na "x"
guwno <- grep('x$', unikat)
unikatx <- unikat[guwno]
unikatx = as.data.frame(unikatx)
write.table(unikatx, file="slowniki_gotowe/unikatx.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

# te które kończą się na "pol"
guwno <- grep('pol$', unikat)
unikatpol <- unikat[guwno]
unikatpol = as.data.frame(unikatpol)
write.table(unikatpol, file="slowniki_gotowe/unikatpol.txt", col.names = FALSE, quote = FALSE, row.names = FALSE )

