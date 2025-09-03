#' Collection of helper/utility functions not intended to be directly used by end user
#'
#' @returns Path of user's current working directory
#' @export
#'
#' @examples
#' findUserCD()
findUserCD <- function() {
  # cur_dir <- getwd()
  return(getwd())
}
#' Title
#'
#' @param path Path to folder containing fastq files
#' @param chatty If set to FALSE, don't print as much to console.
#'
#' @returns file path to a folder
#' @export
#' @import stringr
#'
#' @examples
#' whereFastqs(".")
whereFastqs <- function(path = NULL, chatty = TRUE) {
  # Check if the folder exists first
  if (!file.exists(path)) {
    stop("Error: The folder you provided does not exist at the provided path.")
  }

  # Check if the file is a directory (not a file)
  if (!file_test("-d", path)) {
    stop("Error: You provided a path to a file; provide path to the directory where your fastq files are located.")
  }

  files <- tibble::as_tibble(list.files(path, pattern = "\\."))
  if (chatty == TRUE) {
    print(files)
  }

  fastq_filename_patterns <- tibble::tribble(
    ~pattern,
    "fastq",
    "fq",
    "R1",
    "R2"
  )

  files <- files %>%
    dplyr::mutate(
      fastq = stringr::str_count(.data$value, regex("fastq", ignore_case = TRUE)),
      fq = stringr::str_count(.data$value, regex("fq", ignore_case = TRUE)),
      R1 = stringr::str_count(.data$value, regex("R1", ignore_case = TRUE)),
      R2 = stringr::str_count(.data$value, regex("R2", ignore_case = TRUE)),
    ) %>%
    rowwise() %>%
    dplyr::mutate(any_fq = sum(c_across(c(.data$fastq, .data$fq)))) %>%
    ungroup()

  fastq_sum <- files %>%
    summarise(total_value = sum(.data$any_fq)) %>%
    as.numeric()
  r1_sum <- files %>%
    summarise(total_value = sum(.data$R1)) %>%
    as.numeric()
  r2_sum <- files %>%
    summarise(total_value = sum(.data$R2)) %>%
    as.numeric()

  if (r1_sum == r2_sum & r1_sum * 2 == fastq_sum) {
    print(sprintf("The total number of potential FASTQ files detected in the directory was %s, and the number of potential forward reads and reverse reads was %s. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!", fastq_sum, r1_sum))
  }

  if (r1_sum != r2_sum) {
    print(sprintf("CAUTION: the number of forward reads and reverse reads does not appear to match! The total number of potential FASTQ files detected in the directory was %s, the number of potential forward reads was %s and reverse reads was %s. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you! If you're sure everything is OK, then carry on.", fastq_sum, r1_sum, r2_sum))
  }

  if (r1_sum * 2 != fastq_sum | r2_sum * 2 != fastq_sum) {
    print(sprintf("CAUTION: the number of total reads detected is not double the number of either forward or reverse reads. The total number of potential FASTQ files detected in the directory was %s, the number of potential forward reads was %s, and reverse reads was %s. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!", fastq_sum, r1_sum, r2_sum))
  }


  if (chatty == TRUE) {
    return(path)
  }

  if (chatty == FALSE) {
    return(invisible(path))
  }
}
#' A simple tibble of the names of maintained dada2-formatted taxonomy reference databases
#'
#' @param what A keypair listing the expected pattern name or a vector of the known names.
#'
#' @returns A tibble
#' @export
#'
#' @examples
#' known_dada2_dbs()
known_dada2_dbs <- function(what = "list") {
  if (what != "keypair" & what != "list" & !is.null(what)) {
    stop("You did not provide a valid value. Valid options are 'list' or 'keypair'.")
  }

  if (what == "keypair") { # i wasn't smart enough to get this to work properly, but saving in case i ever do figure it out
    return_value <- tibble::tribble(
      ~db, ~pattern,
      "silva", "^silva_.*fa.gz$",
      "rdp", "^rdp_.*trainset.fa.gz$",
      "greengenes", "^gg2_trainset.fa.gz$",
      "unite", "sh_general_release_all_.*tgz"
    )
  }

  if (what == "list") {
    return_value <- tibble::tribble(
      ~database, ~database_file_name,
      "GreenGenes", "gg2_2024_09_toGenus_trainset.fa.gz",
      "GreenGenes", "gg2_2024_09_toSpecies_trainset.fa.gz",
      "RDP", "rdp_19_toGenus_trainset.fa.gz",
      "RDP", "rdp_19_toSpecies_trainset.fa.gz",
      "UNITE", "sh_general_release_all_19.02.2025.tgz",
      "SILVA", "silva_nr99_v138.2_toGenus_trainset.fa.gz",
      "SILVA", "silva_nr99_v138.2_toSpecies_trainset.fa.gz",
      "SILVA", "silva_v138.2_assignSpecies.fa.gz",
    )
  }
  return(return_value)
}
#' Set a reference database for taxonomy assignment
#'
#' @param db File path to the reference database to use
#' @param chatty Set to FALSE for less text printed to console
#'
#' @returns The file path of the database
#' @export
#'
ref_db <- function(db, chatty = TRUE) {
  #db <- normalizePath(db)

  if(db == "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"){
    db <- system.file("extdata/db", package = "micro4R", "EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", mustWork = TRUE)
  }

  if(db == "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"){
    db <- system.file("extdata/db", package = "micro4R", "EXAMPLE_silva_v138.2_assignSpecies.fa.gz", mustWork = TRUE)
  }

  # Check if the file exists first
  if (!file.exists(db)) {
    stop("Error: The file name you provided does not exist at the provided path.")
  }

  # Check if the file is a file (not a directory)
  if (!file_test("-f", db)) {
    stop("Error: You provided a path to a directory. Provide the file name too. E.g., instead of /path/to/reference, use /path/to/reference/database.gz.")
  }

  filename <- basename(db)

  # Check if the file name matches *known* patterns:
  if (grepl("^silva_.*fa.gz$", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the SILVA databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^rdp_.*trainset.fa.gz$", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the RDP databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^gg2_.*trainset.fa.gz$", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the greengenes databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^sh_general_release_all_.*tgz", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the UNITE all eukaryotes databases. If that does not seem correct to you, please check!")
  }
  if ((grepl("EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", filename) | grepl("EXAMPLE_silva_v138.2_assignSpecies.fa.gz", filename)) & chatty == TRUE) {
    print("You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstrating purposes. DO NOT use them with your real data.")
  }
  if (!grepl("^silva_.*fa.gz$", filename) & !grepl("^rdp_.*trainset.fa.gz$", filename) & !grepl("^gg2_.*trainset.fa.gz$", filename) & !grepl("^sh_general_release_all_.*tgz", filename) & !grepl("EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", filename) & !grepl("EXAMPLE_silva_v138.2_assignSpecies.fa.gz", filename)) {
    print("The file name of your reference database did not match any of the known maintained dada2-formatted taxonomic databases. This does not mean your database is wrong! Just that it's not on my known list. Check below to see the names of all known databases:")
    print(known_dada2_dbs("list"))
  }

  if (chatty == TRUE) {
    return(db)
  }

  if (chatty == FALSE) {
    return(invisible(db))
  }
}
#' Option to use googledrive package to download example data
#'
#' @param path Path to directory where you want to download file to.
#'
#' @returns Downloads zipped folder of full fastq files used in example
#' @export
#'
#' @examples
#' full_example_data("example")
full_example_data <- function(path = NULL) {
  if (path == "example") {
    path <- tempdir()
  }
  if (rlang::is_installed("googledrive") == TRUE) {
    googledrive::drive_download(
      "micro4r_example_data.zip",
      path = file.path(path, "micro4r_example_data.zip"),
      overwrite = TRUE
    )
  }
  if (rlang::is_installed("googledrive") == FALSE) {
    print("To use this function, package 'googledrive' must be installed first. Visit https://googledrive.tidyverse.org/index.html for more information.")
  }
}
tibblefy <- function(x) {
  as_tibble(x, rownames = "SampleID", .name_repair = 'unique')
}
