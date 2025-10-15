#test_that("where if example OK", {
#  where <- "inst/extdata/f"
#  testthat::expect_type(asvtable, "integer")
#})
test_that("returned asvtable is an integer type", {
  asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE, chatty = FALSE)
  testthat::expect_type(asvtable, "list")
})
test_that("output to console", {
  expect_output(dada2_asvtable(example = TRUE, logfile = FALSE))
})
test_that("returns asvtable visibly", {
  expect_visible(dada2_asvtable(example = TRUE, logfile = FALSE))
})
test_that("returns asvtable invisibly", {
  expect_invisible(dada2_asvtable(example = TRUE, logfile = FALSE, chatty = FALSE))
})
test_that("get no errors, warnings, or messages", {
  expect_no_condition(dada2_asvtable(example = TRUE, logfile = FALSE, chatty = FALSE))
})
test_that("dimensions are correct", {
  asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE, chatty = FALSE)
  expect_equal(length(asvtable), 7)
  expect_equal(nrow(asvtable), 7)
  expect_equal(ncol(asvtable), 7)
})
test_that("rownames correct", {
  asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE, chatty = FALSE)
  rownames <- c("SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001", "SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001", "SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001", "SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001", "SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001", "SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001", "SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001")
  expect_equal(asvtable$SampleID, rownames)
})
