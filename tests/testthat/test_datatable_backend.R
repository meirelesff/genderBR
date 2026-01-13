test_that("data.table backend preserves order and duplicates (internal data)", {

  names_in <- c("Ana", "ana ", "Joao", "ana", "joao")

  res <- get_gender(names_in, internal = TRUE)

  expect_equal(length(res), length(names_in))
  expect_equal(res, c("Female", "Female", "Male", "Female", "Male"))
  expect_type(res, "character")
})


test_that("prob output stays numeric and aligned (internal data)", {

  names_in <- c("ana", "joao", "unknown_name")

  res <- get_gender(names_in, prob = TRUE, internal = TRUE)

  expect_equal(length(res), length(names_in))
  expect_type(res, "double")
  expect_true(res[1] > 0.8)
  expect_true(res[2] < 0.2)
  expect_true(is.na(res[3]))
})


test_that("internal 2022 data works with duplicates", {

  names_in <- c("ana", "mario", "ana", "Ariel")

  res_char <- get_gender(names_in, internal = TRUE, year = 2022)
  res_prob <- get_gender(names_in, prob = TRUE, internal = TRUE, year = 2022)

  expect_equal(length(res_char), length(names_in))
  expect_type(res_char, "character")
  expect_equal(res_char[c(1, 3)], c("Female", "Female"))
  expect_equal(res_char[2], "Male")
  expect_true(is.na(res_char[4]) || res_char[4] %in% c("Male", "Female"))

  expect_equal(length(res_prob), length(names_in))
  expect_type(res_prob, "double")
  expect_true(res_prob[1] > 0.8)
  expect_true(res_prob[2] < 0.2)
})
