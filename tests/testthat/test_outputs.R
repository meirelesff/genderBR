test_that("Main function returns what is expected", {

  # Test single names
  expect_equal(get_gender("Ana"), "Female")
  expect_equal(get_gender("Joao"), "Male")
  expect_equal(get_gender("MARIA DO SOCORRO"), "Female")
  expect_equal(get_gender("MARIO ANTUNES"), "Male")
  expect_equal(get_gender("  Jose de Almeida"), "Male")
  expect_equal(get_gender("  marlene  "), "Female")

  # Test single names, return probabilities
  expect_lt(get_gender("Acir", prob = TRUE), 0.05)
  expect_gt(get_gender("Ana", prob = TRUE), 0.9)

  # Test multiple names
  expect_equal(get_gender(c("mario", "ana")), c("Male", "Female"))
  expect_equal(get_gender(rep("Arnaldo", 5)), rep("Male", 5))

  # Test names that return NA
  expect_equal(get_gender("Champions League"), as.character(NA))
  expect_equal(get_gender("Cicrano"), as.character(NA))

  # Test internal data with 2022 probabilities
  expect_equal(get_gender("Ana", year = 2022), "Female")
  expect_gt(get_gender("Ana", prob = TRUE, year = 2022), 0.9)

  # Test explicit year selection matches default 2010 behavior
  expect_equal(get_gender("Ana", year = 2010), get_gender("Ana"))
  expect_gt(get_gender("Ana", prob = TRUE, year = 2010), 0.9)

  # Test vectorized calls with 2022 internal data
  expect_equal(get_gender(c("mario", "ana"), year = 2022), c("Male", "Female"))
})
