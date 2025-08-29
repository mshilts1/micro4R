#' Collection of helper/utility functions not intended to be used by end user
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
#' Simple tibble key pair of known patterns of maintained dada2-formatted taxonomy reference databases
#'
#' @returns A tibble
#' @export
#'
#' @examples
#' known_dada2_dbs()
known_dada2_dbs <- function(){
  return(tibble::tribble(
          ~db, ~pattern,
          "silva",   "^silva_.*fa.gz$",
          "rdp",   "^rdp_.*trainset.fa.gz$",
          "greengenes",   "^gg2_trainset.fa.gz$",
          "unite",  "sh_general_release_all_.*tgz"
  ))
}
#' Set a reference database for taxonomy assignment
#'
#' @param db File path to the reference database to use
#'
#' @returns The file path of the database
#' @export
#' @import stringi
#'
ref_db <- function(db) {
  # Check if the file exists first
  if (!file.exists(db)) {
    stop("Error: The file name your provided does not exist at the provided path.")
  }

  # Check if the file is a file (not a directory)
  if (!file_test("-f", db)) {
    stop("Error: You provided a path to a directory. Provide the file name too. E.g., instead of /path/to/reference, use /path/to/reference/database.gz.")
  }

  filename <- basename(db)

  stringi::stri_match_all_regex(str = filename, pattern = known_dada2_dbs()$pattern)

  return(db)
}
