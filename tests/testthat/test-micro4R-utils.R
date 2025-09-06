test_that("problems with path", {
  expect_error(whereFastqs())
  expect_error(whereFastqs("messed/up/path"))
  filepath <- system.file("extdata/objects", package = "micro4R", "metadata.csv", mustWork = TRUE)
  expect_error(whereFastqs(filepath))
})
test_that("problems with path", {
})
