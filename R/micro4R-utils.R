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

fastq_files <- function() {
  findUserCD()
}
