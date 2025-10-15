test_that("problems with path", {
  expect_error(whereFastqs())
  expect_error(whereFastqs("messed/up/path"))
  filepath <- system.file("extdata/objects", package = "micro4R", "metadata.csv", mustWork = TRUE)
  expect_error(whereFastqs(filepath))
})
test_that("path is ok", {
  filepath <- system.file("extdata/f", package = "micro4R", mustWork = TRUE)
  expect_no_error(whereFastqs(filepath))
  expect_no_message(whereFastqs(filepath))
  expect_output(whereFastqs(filepath, chatty = FALSE))
})
test_that("fastq files", {
  fnFs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R1_001.fastq.gz", full.names = TRUE)
  fnRs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R2_001.fastq.gz", full.names = TRUE)
})
test_that("returns path invisibly", {
  filepath <- system.file("extdata/f", package = "micro4R", mustWork = TRUE)
  expect_invisible(whereFastqs(filepath, chatty = FALSE))
})
test_that("returns path visibly", {
  filepath <- system.file("extdata/f", package = "micro4R", mustWork = TRUE)
  expect_visible(whereFastqs(filepath))
})

test_that("Get a warning if NAs are detected", {
  expect_warning(checkMeta(dplyr::starwars %>% dplyr::select(-c(films, vehicles, starships)), "name"))
})
test_that("Get a warning if your sample IDs are not all unique", {
  expect_warning(checkMeta(dplyr::storms, "name"))
})
test_that("Get a warning if the column name you gave for the sample IDs can't be found", {
  expect_warning(checkMeta(dplyr::storms, "nameee"))
})

test_that("No output if it passes all tests", {
  expect_null(checkMeta(dplyr::band_members, "name"))
})
test_that("whereFastqs returning tibble", {
  path <- system.file("extdata/f", package = "micro4R", mustWork = TRUE)
  out <- whereFastqs(path = path, return_tibble_or_path = "tibble")
  expect_equal(class(out), c("tbl_df", "tbl", "data.frame"))
  expect_equal(colnames(out), c("SampleID"))
  expect_visible(whereFastqs(path = path, return_tibble_or_path = "tibble"))
  expect_invisible(whereFastqs(path = path, return_tibble_or_path = "tibble", chatty = FALSE))
})
test_that("get an error with invalid option for known_dada2_dbs", {
  expect_error(known_dada2_dbs(what = "something"))
})
test_that("known_dada2_dbs output for keypair looks ok", {
  out <- known_dada2_dbs(what = "keypair")
  expect_equal(class(out), c("tbl_df", "tbl", "data.frame"))
  expect_equal(colnames(out), c("db", "pattern"))
  expect_equal(dim(out), c(4, 2))
})
test_that("known_dada2_dbs output for list looks ok", {
  out <- known_dada2_dbs(what = "list")
  expect_equal(class(out), c("tbl_df", "tbl", "data.frame"))
  expect_equal(colnames(out), c("database", "database_file_name"))
  expect_equal(dim(out), c(8, 2))
})
test_that("ref_db ok", {
  expect_error(ref_db("this/is/a/fake/path")) # error if path doesn't exist
  path <- system.file("extdata/f", package = "micro4R", mustWork = TRUE)
  expect_error(ref_db(path)) # error if path is to a directory and not a file

  out <- ref_db(test_dbs()$train)
  out_expect <- system.file("extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", package = "micro4R", mustWork = TRUE)
  expect_equal(out, out_expect)
})
test_that("converter ok", {
  out <- dada2_wrapper(example = TRUE)
  expect_equal(out$asvtable, converter(out$asvtable, out = "tibble")) # tibble to tibble; returns original object
  expect_equal(out$taxa, converter(out$taxa, out = "tibble", id = "ASV")) # tibble to tibble; returns original object
  expect_equal(out$metadata, converter(out$metadata, out = "tibble")) # tibble to tibble; returns original object

  a_typo <- converter(out$asvtable, out = "df") # quietly fixes common typos
  expect_equal(class(a_typo), "data.frame")
  expect_equal(a_typo, converter(out$asvtable, out = "data.frame"))
  a_typo <- converter(out$asvtable, out = "data_frame") # quietly fixes common typos
  expect_equal(class(a_typo), "data.frame")
  expect_equal(a_typo, converter(out$asvtable, out = "data.frame"))

  a_typo <- converter(out$asvtable, out = "tbl_df") # quietly fixes common typos
  expect_equal(class(a_typo), c("tbl_df", "tbl", "data.frame"))
  expect_equal(a_typo, converter(out$asvtable, out = "tibble"))

  a_typo <- converter(out$asvtable, out = "tbl") # quietly fixes common typos
  expect_equal(class(a_typo), c("tbl_df", "tbl", "data.frame"))
  expect_equal(a_typo, converter(out$asvtable, out = "tibble"))

  a_typo <- converter(out$asvtable, out = "array") # quietly fixes common typos
  expect_equal(class(a_typo), c("matrix", "array"))
  expect_equal(a_typo, converter(out$asvtable, out = "matrix"))

  expect_error(converter(out)) # get an error if input isn't a tibble, data frame, or matrix.
  expect_error(converter(out$asvtable, out = "doesntexist")) # get an error if requested output isn't a valid option

  expect_error(converter(out$asvtable, out = "matrix", id = "notexist")) # get an error if 'id' column doesn't exist
  expect_invisible(converter(out$asvtable, out = "data.frame"))

  path <- system.file("extdata/objects/asvtable.csv", package = "micro4R", mustWork = TRUE)
  asvtable_df <- read.csv(file = path, header = TRUE)
  expect_equal(asvtable_df, converter(out$asvtable, out = "data.frame"))
  expect_equal(class(converter(out$asvtable, out = "matrix")), c("matrix", "array"))
  expect_equal(length(converter(out$asvtable, out = "matrix")), 42)
  expect_error(converter(out$asvtable, out = "matrix", id = "fake"))

  expect_error(converter(asvtable_df, out = "matrix", id = "notexist")) # get an error if 'id' column doesn't exist
  expect_invisible(converter(asvtable_df, out = "data.frame"))
})
test_that("unsampled example", {
  out <- unsampled_example()
  expect_equal(class(out), "list")
  expect_equal(length(out), 2)
  expect_equal(names(out), c("asvtable", "metadata"))
  expect_equal(dim(out$asvtable), c(7, 236))
  expect_equal(dim(out$metadata), c(7, 7))
  expect_equal(names(out$asvtable[1]), "SampleID")
  expect_equal(names(out$metadata[1]), "SampleID")

  expect_equal(class(out$asvtable), c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(out$metadata), c("tbl_df", "tbl", "data.frame"))
})
test_that("filtering working", {
  out <- unsampled_example()
  expect_warning(filtering(asvtable = out$asvtable, minDepth = 10000000000000)) # overly aggressive filtering gives a warning
  expect_warning(filtering(asvtable = out$asvtable, minASVCount = 100000000000))

  out_filter <- filtering(asvtable = out$asvtable) # check if default filtering working correctly
  expect_equal(class(out_filter), c("tbl_df", "tbl", "data.frame"))
  expect_equal(dim(out_filter), c(5, 234))
  expect_equal(out_filter$SampleID, c("5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001", "5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001", "5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001", "5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001", "5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001"))
})
