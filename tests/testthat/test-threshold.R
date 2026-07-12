test_that("check_threshold normalizes valid inputs", {

  # A single value is symmetrical
  expect_equal(check_threshold(0.9), c(female = 0.9, male = 0.9))
  expect_equal(check_threshold(c(Female = 0.9)), c(female = 0.9, male = 0.9))

  # Unnamed vectors take the female threshold first
  expect_equal(check_threshold(c(0.9, 0.8)), c(female = 0.9, male = 0.8))

  # Named vectors can come in any order, in upper or lower case
  expect_equal(check_threshold(c(Female = 0.9, Male = 0.8)), c(female = 0.9, male = 0.8))
  expect_equal(check_threshold(c(Male = 0.8, Female = 0.9)), c(female = 0.9, male = 0.8))
  expect_equal(check_threshold(c(F = 0.9, M = 0.8)), c(female = 0.9, male = 0.8))
  expect_equal(check_threshold(c(m = 0.8, f = 0.9)), c(female = 0.9, male = 0.8))

  # Validation is idempotent (get_gender passes its result to get_gender_nn)
  expect_equal(check_threshold(check_threshold(c(0.9, 0.8))), c(female = 0.9, male = 0.8))
})


test_that("check_threshold rejects invalid inputs", {

  # Invalid types and values
  expect_error(check_threshold("0.8"), "'threshold' must be numeric")
  expect_error(check_threshold(2), "'threshold' must be between 0 and 1")
  expect_error(check_threshold(-0.1), "'threshold' must be between 0 and 1")
  expect_error(check_threshold(c(0.9, 2)), "'threshold' must be between 0 and 1")

  # Invalid lengths and missing values
  expect_error(check_threshold(numeric(0)), "length 1 or 2")
  expect_error(check_threshold(c(0.9, 0.8, 0.7)), "length 1 or 2")
  expect_error(check_threshold(NA_real_), "without missing values")
  expect_error(check_threshold(c(0.9, NA)), "without missing values")

  # Invalid names
  expect_error(check_threshold(c(Female = 0.9, Sex = 0.8)), "must be named")
  expect_error(check_threshold(c(Female = 0.9, Female = 0.8)), "must be named")

  # Overlapping thresholds, which would make a name both female and male
  expect_error(check_threshold(c(0.3, 0.4)), "ambiguous")
  expect_error(check_threshold(0.4), "ambiguous")
})


test_that("Asymmetrical thresholds are applied to each sex", {

  # 'marion' is 72% female: a lower female threshold classifies it
  expect_equal(get_gender("marion"), "Unknown")
  expect_equal(get_gender("marion", threshold = c(0.7, 0.9)), "Female")
  expect_equal(get_gender("marion", threshold = c(Female = 0.7, Male = 0.9)), "Female")
  expect_equal(get_gender("marion", threshold = c(M = 0.9, F = 0.7)), "Female")

  # 'ariel' is 10% female: a higher male threshold stops classifying it
  expect_equal(get_gender("ariel"), "Male")
  expect_equal(get_gender("ariel", threshold = c(0.9, 0.95)), "Unknown")

  # Confident names are not affected
  expect_equal(get_gender("ana", threshold = c(0.7, 0.9)), "Female")
  expect_equal(get_gender("joao", threshold = c(0.7, 0.9)), "Male")
})


test_that("Symmetrical thresholds keep the previous behavior", {

  nms <- c("ana", "joao", "marion", "ariel", "cicrano")

  expect_equal(get_gender(nms, threshold = c(0.8, 0.8)), get_gender(nms, threshold = 0.8))
  expect_equal(get_gender(nms, threshold = c(0.5, 0.5)), get_gender(nms, threshold = 0.5))

  # Probabilities ignore the threshold
  expect_equal(get_gender(nms, threshold = c(0.7, 0.95), prob = TRUE),
               get_gender(nms, prob = TRUE))
})
