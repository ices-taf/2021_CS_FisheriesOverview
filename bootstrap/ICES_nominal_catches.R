# wd: bootstrap/data/ICES_nominal_catches

library(icesTAF)
library(icesFO)

hist <- load_historical_catches()
write.taf(hist, file = "ICES_historical_catches.csv", quote = TRUE)

official <- load_official_catches()
write.taf(official, file = "ICES_2006_2019_catches.csv", quote = TRUE)

prelim <- load_preliminary_catches(2020)
<<<<<<< HEAD
write.taf(preliminary, file = "ICES_preliminary_catches.csv", quote = TRUE)
=======
write.taf(prelim, file = "ICES_preliminary_catches.csv", quote = TRUE)
>>>>>>> 2ce21d959d49b160f462c007ca7111ce6f1ebc2c


# load_preliminary_catches <- function (year){
#         url<- "http://data.ices.dk/rec12/download/1bjygg4mzskn1idq5tusannp569A0.csv"
#         tmpFilePrelimCatch <- tempfile(fileext = ".csv")
#         download.file(url, destfile = tmpFilePrelimCatch, mode = "wb", quiet = TRUE)
#         out <- read.csv(tmpFilePrelimCatch,
#                         stringsAsFactors = FALSE,
#                         header = TRUE,
#                         fill = TRUE)
#         out
# }
