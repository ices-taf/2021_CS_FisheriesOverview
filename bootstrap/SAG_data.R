library(icesFO)


summary <- load_sag_summary(2021)
write.taf(summary, dir = "bootstrap/initial/data/SAG_data", file = "SAG_summary.csv")

refpts <- load_sag_refpts(2021)
write.taf(refpts, dir = "bootstrap/initial/data/SAG_data", file = "SAG_refpts.csv")

status <- load_sag_status(2021)
write.taf(status, dir = "bootstrap/initial/data/SAG_data", file = "SAG_status.csv", quote = TRUE)
