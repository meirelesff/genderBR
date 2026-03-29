skip_if_no_nn_model <- function() {
  skip_if_not_installed("torch")
  tryCatch(
    {
      .load_nn_model <- getFromNamespace(".load_nn_model", "genderBR")
      .load_nn_model()
    },
    error = function(e) {
      skip("NN model artifacts not available (not yet uploaded to HF?)")
    }
  )
}

test_that("get_gender_nn returns 'Female' for 'maria'", {
  skip_if_no_nn_model()
  expect_equal(get_gender_nn("maria"), "Female")
})

test_that("get_gender_nn returns 'Male' for 'joao'", {
  skip_if_no_nn_model()
  expect_equal(get_gender_nn("joao"), "Male")
})

test_that("NA input returns NA without error", {
  skip_if_no_nn_model()
  result <- get_gender_nn(NA_character_)
  expect_true(is.na(result))
  expect_type(result, "character")
})

test_that("empty string returns NA without error", {
  skip_if_no_nn_model()
  result <- get_gender_nn("")
  expect_true(is.na(result))
})

test_that("prob = TRUE returns numeric in (0, 1)", {
  skip_if_no_nn_model()
  p <- get_gender_nn("maria", prob = TRUE)
  expect_type(p, "double")
  expect_gt(p, 0)
  expect_lt(p, 1)
})

test_that("threshold = 1 returns NA (sigmoid never reaches 0 or 1)", {
  skip_if_no_nn_model()
  expect_true(is.na(get_gender_nn("maria", threshold = 1)))
  expect_true(is.na(get_gender_nn("joao", threshold = 1)))
})

test_that("vectorised input works correctly", {
  skip_if_no_nn_model()
  result <- get_gender_nn(c("maria", "joao", NA))
  expect_length(result, 3)
  expect_true(is.na(result[3]))
})

test_that("second call is faster than first (cache is used)", {
  skip_if_no_nn_model()
  clear_nn_cache()
  t1 <- system.time(get_gender_nn("maria"))
  t2 <- system.time(get_gender_nn("maria"))
  expect_lt(t2[["elapsed"]], t1[["elapsed"]])
})

test_that("clear_nn_cache() causes next call to reload from disk", {
  skip_if_no_nn_model()
  # Ensure model is loaded
  get_gender_nn("maria")
  clear_nn_cache()
  expect_null(.gbr_cache$model)
  # Next call should reload without error
  expect_no_error(get_gender_nn("maria"))
  expect_false(is.null(.gbr_cache$model))
})

test_that("full names use only the first token", {
  skip_if_no_nn_model()
  expect_equal(
    get_gender_nn("Maria Silva"),
    get_gender_nn("Maria")
  )
})
