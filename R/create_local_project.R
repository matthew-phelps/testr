# These were taking from usethis, but I'm not entirely sure why they need to be
# set up like they are
proj <- new.env(parent = emptyenv())

#' Get project in testing setting
#' @description Use with caution. Often used in conjunction with
#'   `usethis::proj_get()`, `usethis::proj_set()`, `proj_set_()` and
#'   `withr::defer()`
#' @return project or NULL
#' @export
#'
proj_get_ <- function(){proj$cur}


#' Set project in testing setting
#' @description Use with caution. Often used in conjunction with
#'   `usethis::proj_get()`, `usethis::proj_set()`, `testr::proj_get_()` and
#'   `withr::defer()`#'
#' @param path path
#'
#' @return old project path
#'
proj_set_ <- function(path) {
  old <- proj$cur
  proj$cur <- path
  invisible(old)
}



#' Create a local thing (could be RStudio project or R package)
#'
#' @param dir Dir string
#' @param env env object
#' @param rstudio Boolean
#' @param thing project or package
#'
#' @return nothing, run for side effects
#'
create_local_thing <- function(dir = fs::file_temp(pattern = pattern),
                               env = parent.frame(),
                               rstudio = FALSE,
                               thing = c("package", "project")) {
  thing <- match.arg(thing)
  if (fs::dir_exists(dir)) {
    usethis::ui_stop("Target {usethis::ui_code('dir')} {usethis::ui_path(dir)} already exists.")
  }

  old_project <- proj_get_() # this could be `NULL`, i.e. no active project
  old_wd <- getwd()          # not necessarily same as `old_project`

  withr::defer(
    {
      usethis::ui_done("Deleting temporary project: {usethis::ui_path(dir)}")
      fs::dir_delete(dir)
    },
    envir = env
  )
  usethis::ui_silence(
    switch(
      thing,
      package = usethis::create_package(dir, rstudio = rstudio, open = FALSE, check_name = FALSE),
      project = usethis::create_project(dir, rstudio = rstudio, open = FALSE)
    )
  )

  withr::defer(usethis::proj_set(old_project, force = TRUE), envir = env)
  usethis::proj_set(dir)

  withr::defer(
    {
      usethis::ui_done("Restoring original working directory: {usethis::ui_path(old_wd)}")
      setwd(old_wd)
    },
    envir = env
  )
  setwd(usethis::proj_get())

  invisible(usethis::proj_get())
}


#'Create local project using withr
#'
#'@description Create a temporary RStudio Project that will be deleted when the
#'  calling function exits. Useful when you need to test something using an
#'  example project (like testing functions that help users set up a new
#'  RStudio project).
#'@param dir Dir string
#'@param env env object
#'@param rstudio Boolean
#'
#'@return nothing, run for side effects
#'@export
#'@examples
#'\donttest{
#'  old  <- getwd()
#'testthat::test_that("creates RStudion Project", {
#'  create_local_project()
#'  tmp_path <- usethis::proj_path()
#'  testthat::expect_s3_class(tmp_path, "character")
#'  testthat::expect_failure(testthat::expect_equivalent(tmp_path, old))
#'})
#' # Upon completion of the function, working space is returned to starting conditions
#' getwd()==old
#'}
create_local_project <- function(dir = fs::file_temp(pattern = "testproj"),
                                 env = parent.frame(),
                                 rstudio = FALSE) {
  create_local_thing(dir, env, rstudio, "project")
}


#' Create local package using withr
#'
#'@description Create a temporary R package that will be deleted when the
#'  calling function exits. Useful when you need to test something using an
#'  example R package (like testing functions that help users set up a new
#'  R package).
#' @param dir Dir string
#' @param env env object
#' @param rstudio Boolean
#'
#' @return nothing, run for side effects
#' @export
#'
create_local_package <- function(dir = fs::file_temp(pattern = "testpkg"),
                                 env = parent.frame(),
                                 rstudio = FALSE) {
  create_local_thing(dir, env, rstudio, "package")
}

utils::globalVariables("pattern")
