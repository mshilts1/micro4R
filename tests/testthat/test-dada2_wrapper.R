test_that("checking on inherited arguments", {
  expect_equal(length(dada2_wrapper(listargs = TRUE)), 0)
  expect_equal(length(dada2_wrapper(listargs = TRUE, metadata = example_metadata())), 0)
  expect_equal(length(dada2_wrapper(listargs = TRUE, metadata = example_metadata(), multi = TRUE)), 1)
  expect_equal(length(dada2_wrapper(listargs = TRUE, metadata = example_metadata(), multi = TRUE, species = "species")), 2)
})
test_that("checking example output", {
  out <- dada2_wrapper(example = TRUE, full.wrapper = FALSE, log = FALSE)
  expect_type(out, "list")
  expect_equal(length(out), 3)
  expect_equal(names(out), c("asvtable", "taxa", "metadata"))
  expect_equal(dim(out$asvtable), c(7, 7))
  expect_equal(dim(out$taxa), c(6, 8))
  expect_equal(dim(out$metadata), c(7, 7))
})
test_that("checking output if no metadata file provided", {
  out <- dada2_wrapper(example = FALSE, where = "inst/extdata/f", logfile = FALSE, chatty = FALSE, train = test_dbs()$train)
  expect_type(out, "list")
  expect_equal(length(out), 2)
  expect_equal(names(out), c("asvtable", "taxa"))
  expect_equal(dim(out$asvtable), c(7, 7))
  expect_equal(dim(out$taxa), c(6, 7)) # one fewer than above because no species database provided
})
