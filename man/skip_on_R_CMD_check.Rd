% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/skip_on_R_CMD_check.R
\name{skip_on_R_CMD_check}
\alias{skip_on_R_CMD_check}
\title{Skip tests on R CMD check or devtools::check()}
\usage{
skip_on_R_CMD_check(message = NULL)
}
\arguments{
\item{message}{Message to display when skipped}
}
\value{
invisible TRUE
}
\description{
Some tests that require user input (i.e. a function that
launches a shiny app when certain conditons are met) cannot be run
programmatically. This function allows us to still write tests that can be
executed manually, but skipped when tests are run as part of check().

This is unlikely to be a robust solution so use with caution.

This doet \strong{not} seem to work on ADO, so you need \code{skip_on_devops()} for
that.

This does \strong{not} skip when tests are run via devtools::test(). I currently
do not know a way of differentiating between a test run manually versus via
test()
}
