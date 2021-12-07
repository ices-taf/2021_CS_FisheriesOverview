# Initial formatting of the data

library(icesTAF)
library(icesFO)
library(dplyr)

mkdir("data")

# set working directory
setwd("D:/Profile/Documents/GitHub/2021_CS_FisheriesOverview")

# load species list
species_list <- read.taf("bootstrap/initial/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/initial/data/ICES_StockInformation/sid.csv")


# 1: ICES official catch statistics

hist <- read.taf("bootstrap/initial/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/initial/data/ICES_nominal_catches/ICES_2006_2019_catches.csv")
prelim <- read.taf("bootstrap/initial/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <-
  format_catches(2021, "Celtic Seas",
    hist, official, prelim, species_list, sid)

write.taf(catch_dat, dir = "data", quote = TRUE)


# 2: SAG
sag_sum <- read.taf("bootstrap/initial/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/initial/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/initial/data/SAG_data/SAG_status.csv")

clean_sag <- format_sag(sag_sum, sag_refpts, 2021, "Celtic Seas")
clean_sag <- unique(clean_sag)
clean_status <- format_sag_status(sag_status, 2021, "Celtic Seas")

out_stocks <-  c("aru.27.123a4", "bli.27.nea", "bll.27.3a47de",
                 "cap.27.2a514", "her.27.1-24a514a", "lin.27.5b", "reb.2127.dp",
                 "reg.27.561214", "rjb.27.3a4", "rng.27.1245a8914ab",
                 "san.sa.7r", "smn-dp")

library(operators)
clean_sag <- dplyr::filter(clean_sag, StockKeyLabel %!in% out_stocks)
clean_status <- dplyr::filter(clean_status, StockKeyLabel %!in% out_stocks)
detach("package:operators", unload=TRUE)

write.taf(clean_sag, dir = "data")
write.taf(clean_status, dir = "data", quote = TRUE)

# 3: STECF effort and landings

effort <- read.taf("bootstrap/initial/data/Effort-by-country.csv", check.names = TRUE)
names(effort)
effort$sub.region <- tolower(effort$sub.region)
unique(effort$sub.region)
effort_CS <- dplyr::filter(effort, grepl("27.6.a|27.7.b|27.7.j|27.7.g|27.7.a|
                                          27.7.h|27.7.f", sub.region))





landings1 <- read.taf("bootstrap/initial/data/Catches-by-country-2018.csv", check.names = TRUE)
landings2 <- read.taf("bootstrap/initial/data/Catches-by-country-2017.csv", check.names = TRUE)
landings3 <- read.taf("bootstrap/initial/data/Catches-by-country-2016.csv", check.names = TRUE)
landings4 <- read.taf("bootstrap/initial/data/Catches-by-country-2015.csv", check.names = TRUE)
landings <- rbind(landings1, landings2, landings3, landings4)
names(landings)
landings$sub.region <- tolower(landings$sub.region)
landings_CS <- dplyr::filter(landings, grepl("27.6.a|27.7.b|27.7.j|27.7.g|27.7.a|
                                          27.7.h|27.7.f|27.6.b|27.7.c|27.7.k", sub.region))

# need to group gears, Sarah help.
unique(landings_CS$gear.type)
unique(effort_CS$gear.type)


landings_CS <- dplyr::mutate(landings_CS, gear_class = case_when(
  grepl("TBB", gear.type) ~ "Beam trawl",
  grepl("DRB|DRH|HMD", gear.type) ~ "Dredge",
  grepl("GNS|GND|GTN|LHP|LLS|FPN|GTR|FYK|LLD|SDN|LTL|LNB", gear.type) ~ "Static/Gill net/LL",
  grepl("OTT|OTB|PTB|SSC|SB|SPR|SV", gear.type) ~ "Otter trawl/seine",
  grepl("PTM|OTM|PS", gear.type) ~ "Pelagic trawl/seine",
  grepl("FPO", gear.type) ~ "Pots",
  grepl("NK|NO|LHM", gear.type) ~ "other",
  is.na(gear.type) ~ "other",
  TRUE ~ "other"
)
)

effort_CS <- dplyr::mutate(effort_CS, gear_class = case_when(
  grepl("TBB", gear.type) ~ "Beam trawl",
  grepl("DRB|DRH|HMD", gear.type) ~ "Dredge",
  grepl("GNS|GND|GTN|LHP|LLS|FPN|GTR|FYK|LLD|SDN|LTL|LNB", gear.type) ~ "Static/Gill net/LL",
  grepl("OTT|OTB|PTB|SSC|SB|SPR|SV", gear.type) ~ "Otter trawl/seine",
  grepl("PTM|OTM|PS", gear.type) ~ "Pelagic trawl/seine",
  grepl("FPO", gear.type) ~ "Pots",
  grepl("NK|NO|LHM", gear.type) ~ "other",
  is.na(gear.type) ~ "other",
  TRUE ~ "other"
)
)

unique(landings_CS[c("gear.type", "gear_class")])
unique(effort_CS[c("gear.type", "gear_class")])


