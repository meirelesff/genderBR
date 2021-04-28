test_that("Inputs have valid types", {

  # Test invalid input 'names'
  expect_error(get_gender(123))
  expect_error(get_gender(TRUE))
  expect_error(get_gender(as.factor("Ana")))

  # Test invalid input 'threshold'
  expect_error(get_gender("Ana", threshold = "0.8"))
  expect_error(get_gender("Ana", threshold = 2))

  # Test invalid input 'prob'
  expect_error(get_gender("Ana", prob = "true"))
  expect_error(get_gender("Ana", prob = 1))

  # Test invalid input 'internal'
  expect_error(get_gender("Ana", internal = "true"))
  expect_error(get_gender("Ana", internal = 1))

  # Test invalid input 'encoding'
  expect_error(get_gender("Ana", encoding = 1))
  expect_error(get_gender("Ana", encoding = TRUE))
})

