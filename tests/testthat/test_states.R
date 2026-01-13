
ufs <- get_states()
test_that("Function to return Brazilian states is working", {

  # Basic testing
  expect_equal(class(ufs), c("tbl_df", "tbl", "data.frame"))
  expect_equal(ufs$state[ufs$abb == "AC"], "ACRE")

  # Internal helpers
  expect_equal(genderBR:::state2code("rj"), 33L)
  expect_equal(genderBR:::get_state("sp", 3), rep(35L, 3))
  expect_equal(genderBR:::get_state(c("rj", "sp"), 2), c(33L, 35L))
})
