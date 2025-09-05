test_that("returned asvtable is an integer type", {
  asvtable <- dada2_asvtable("example", logfile = FALSE, chatty = FALSE)
  testthat::expect_type(asvtable, "integer")
})
test_that("output to console", {
  expect_output(dada2_asvtable("example", logfile = FALSE))
})
test_that("returns asvtable visibly", {
  expect_visible(dada2_asvtable("example", logfile = FALSE))
})
test_that("returns asvtable invisibly", {
  expect_invisible(dada2_asvtable("example", logfile = FALSE, chatty = FALSE))
})
test_that("get no errors, warnings, or messages", {
  expect_no_condition(dada2_asvtable("example", logfile = FALSE, chatty = FALSE))
})
test_that("dimensions are correct", {
  asvtable <- dada2_asvtable("example", logfile = FALSE, chatty = FALSE)
  expect_equal(length(asvtable), 42)
  expect_equal(nrow(asvtable), 7)
  expect_equal(ncol(asvtable), 6)
})
