# Tests for get_gender_nn input validation
# These do NOT require torch or model files

test_that("get_gender_nn rejects non-character names", {
  skip_if_not_installed("torch")
  expect_error(get_gender_nn(123), "'names' must be character")
  expect_error(get_gender_nn(TRUE), "'names' must be character")
  expect_error(get_gender_nn(as.factor("Ana")), "'names' must be character")
})

test_that("get_gender_nn rejects non-logical prob", {
  skip_if_not_installed("torch")
  expect_error(get_gender_nn("Ana", prob = "true"), "'prob' must be logical")
  expect_error(get_gender_nn("Ana", prob = 1), "'prob' must be logical")
})

test_that("get_gender_nn rejects non-numeric threshold", {
  skip_if_not_installed("torch")
  expect_error(get_gender_nn("Ana", threshold = "0.9"), "'threshold' must be numeric")
})

test_that("get_gender_nn rejects threshold outside [0, 1]", {
  skip_if_not_installed("torch")
  expect_error(get_gender_nn("Ana", threshold = -0.1), "'threshold' must be between 0 and 1")
  expect_error(get_gender_nn("Ana", threshold = 1.5), "'threshold' must be between 0 and 1")
})
