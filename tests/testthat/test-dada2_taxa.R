asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE, chatty = FALSE)
train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
taxa <- dada2_taxa(asvtable = asvtable, train = train, species = species)

rownames <- c("TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG", "TACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGCACGCAGGCGGTCTGTCAAGTCGGATGTGAAATCCCCGGGCTCAACCTGGGAACTGCATTCGAAACTGGCAGGCTAGAGTCTTGTAGAGGGGGGTAGAATTCCAGGTGTAGCGGTGAAATGCGTAGAGATCTGGAGGAATACCGGTGGCGAAGGCGGCCCCCTGGACAAAGACTGACGCTCAGGTGCGAAAGCGTGGGGAGCAAACAGG", "TACGTAGGGTGCGAGCGTTGTCCGGAATTACTGGGCGTAAAGGGCTCGTAGGTGGTTTGTCGCGTCGTCTGTGAAATTCTGGGGCTTAACTCCGGGCGTGCAGGCGATACGGGCATAACTTGAGTGCTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCGAACAGG", "TACGTAGGGTGCAAGCGTTGTCCGGAATTACTGGGCGTAAAGAGCTCGTAGGTGGTTTGTCACGTCGTCTGTGAAATTCCACAGCTTAACTGTGGGCGTGCAGGCGATACGGGCTGACTTGAGTACTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCAAACAGG", "TACGTAGGTGACAAGCGTTGTCCGGATTTATTGGGCGTAAAGGGAGCGCAGGCGGTCTGTTTAGTCTAATGTGAAAGCCCACGGCTTAACCGTGGAACGGCATTGGAAACTGACAGACTTGAATGTAGAAGAGGAAAATGGAATTCCAAGTGTAGCGGTGGAATGCGTAGATATTTGGAGGAACACCAGTGGCGAAGGCGATTTTCTGGTCTAACATTGACGCTGAGGCTCGAAAGCGTGGGGAGCGAACAGG", "TACGTAGGTCCCGAGCGTTGTCCGGATTTATTGGGCGTAAAGCGAGCGCAGGCGGTTAGATAAGTCTGAAGTTAAAGGCTGTGGCTTAACCATAGTACGCTTTGGAAACTGTTTAACTTGAGTGCAAGAGGGGAGAGTGGAATTCCATGTGTAGCGGTGAAATGCGTAGATATATGGAGGAACACCGGTGGCGAAAGCGGCTCTCTGGCTTGTAACTGACGCTGAGGCTCGAAAGCGTGGGGAGCAAACAGG")

test_that("returned taxa is a list type", {
  testthat::expect_type(taxa, "list")
})
test_that("output to console", {
  expect_output(dada2_taxa(asvtable = asvtable, train = train, species = species, logfile = FALSE))
})
test_that("returns taxa visibly", {
  expect_visible(dada2_taxa(asvtable = asvtable, train = train, species = species, logfile = FALSE))
})
# test_that("returns taxa invisibly", { # something wrong here
#  expect_invisible(dada2_taxa(asvtable = asvtable, train = train, species = species, logfile = FALSE, chatty = FALSE))
# })
test_that("get no errors, warnings, or messages", {
  expect_no_condition(dada2_taxa(asvtable = asvtable, train = train, species = species, logfile = FALSE, chatty = FALSE))
})
test_that("dimensions are correct", {
  expect_equal(length(taxa), 8)
  expect_equal(nrow(taxa), 6)
  expect_equal(ncol(taxa), 8)
})
test_that("rownames correct", {
  expect_equal(taxa$ASV, rownames)
})
test_that("example asv table ok", {
  # asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE)
  expect_equal(class(asvtable), c("tbl_df", "tbl", "data.frame"))
})
test_that("example databases ok", {
  train <- test_dbs()$train
  species <- test_dbs()$species
  expect_equal(file.size(train), 2345)
  expect_equal(file.size(species), 655)
})
test_that("fails if not example and no asvtable object", {
  expect_error(dada2_taxa(asvtable = NULL, example = FALSE))
})
test_that("fails if not example and no path to training database", {
  expect_error(dada2_taxa(asvtable = asvtable, example = FALSE, train = NULL))
})
test_that("ref_db working ok", {
  expect_error(ref_db())
  expect_output(ref_db(train))
})
test_that("example true", {
  expect_output(dada2_taxa(example = TRUE))
})
