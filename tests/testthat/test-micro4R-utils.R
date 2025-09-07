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
