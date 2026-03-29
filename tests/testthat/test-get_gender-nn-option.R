# Tests for get_gender(..., nn = TRUE) delegation to get_gender_nn

skip_if_no_nn_model <- function() {
  skip_if_not_installed("torch")
  tryCatch(
    {
      .load_nn_model <- getFromNamespace(".load_nn_model", "genderBR")
      .load_nn_model()
    },
    error = function(e) {
      skip("NN model artifacts not available")
    }
  )
}

test_that("get_gender(nn = TRUE) delegates to the neural network model", {
  skip_if_no_nn_model()
  expect_equal(get_gender("maria", nn = TRUE), "Female")
  expect_equal(get_gender("joao", nn = TRUE), "Male")
})

test_that("get_gender(nn = TRUE, prob = TRUE) returns probabilities", {
  skip_if_no_nn_model()
  p <- get_gender("maria", nn = TRUE, prob = TRUE)
  expect_type(p, "double")
  expect_gt(p, 0.5)
})

test_that("get_gender(nn = TRUE) ignores state, internal, and year", {
  skip_if_no_nn_model()
  # These extra arguments should be silently ignored
  res <- get_gender("maria", nn = TRUE, state = "SP", internal = FALSE, year = 2010)
  expect_equal(res, "Female")
})

test_that("get_gender(nn = TRUE) works with vectorised input", {
  skip_if_no_nn_model()
  res <- get_gender(c("maria", "joao"), nn = TRUE)
  expect_length(res, 2)
  expect_equal(res, c("Female", "Male"))
})

test_that("get_gender rejects non-logical nn", {
  expect_error(get_gender("Ana", nn = "true"), "'nn' must be logical")
  expect_error(get_gender("Ana", nn = 1), "'nn' must be logical")
})
