## code to prepare `assess_example` dataset goes here

usethis::use_data(assess_example, overwrite = FALSE)

setwd("/Users/meghanshilts/Library/CloudStorage/Dropbox/Mac/Desktop/_r_micro4R_data/9266")
metadata <- read.csv(file="metadata.csv", header = TRUE)

train <- "/Users/meghanshilts/r_code/databases/silva_nr99_v138.2_toGenus_trainset.fa.gz"
species <- "/Users/meghanshilts/r_code/databases/silva_v138.2_assignSpecies.fa.gz"

out <- dada2_wrapper(example = FALSE, metadata = metadata, train = train, species = species, multi = TRUE)

