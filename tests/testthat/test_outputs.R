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
})
