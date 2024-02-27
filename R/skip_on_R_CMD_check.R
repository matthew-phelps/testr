#' Skip tests on R CMD check or devtools::check()
#' @description Some tests that require user input (i.e. a function that
#'   launches a shiny app when certain conditons are met) cannot be run
#'   programmatically. This function allows us to still write tests that can be
#'   executed manually, but skipped when tests are run as part of check().
#'
#'   This is unlikely to be a robust solution so use with caution.
#'
#'   This doet **not** seem to work on ADO, so you need `skip_on_devops()` for
#'   that.
#'
#'   This does **not** skip when tests are run via devtools::test(). I currently
#'   do not know a way of differentiating between a test run manually versus via
#'   test()
#' @param message Message to display when skipped
#'
#' @return invisible TRUE
#' @export
#'
skip_on_R_CMD_check <- function(message=NULL){
  if (!nzchar(Sys.getenv("_R_CHECK_CRAN_INCOMING_"))) {
    return(invisible(TRUE))
  }

  message(message)
  testthat::skip("Skipping, since it's part of R CMD check or devtools::check().")
}


#' Skip of DevOps
#' @description If you do not want your test to run on the CI/CD pipeline, add this to the
#' top of the test
#' @return Nothing, run for side-effects
#' @export
#'
skip_on_devops <- function() {
  if (!identical(Sys.getenv("ON_DEVOPS"), "TRUE")) {
    return(invisible(TRUE))
  }
  testthat::skip("On DevOps")
}

