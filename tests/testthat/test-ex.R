test_that("creates R package", {
  old  <- getwd()
  create_local_package()
  expect_true(file.exists("DESCRIPTION"))
  expect_true(file.exists("NAMESPACE"))
  expect_true(dir.exists("R"))
  expect_failure(expect_equivalent(usethis::proj_path(), old))
})

test_that("creates RStudion Project", {
  old  <- getwd()
  create_local_project()
  tmp_path <- usethis::proj_path()
  expect_s3_class(tmp_path, "character")
  expect_failure(expect_equivalent(tmp_path, old))
})
