
ufs <- get_states()
test_that("Function to return Brazilian states is working", {

  # Basic testing
  expect_equal(class(ufs), c("tbl_df", "tbl", "data.frame"))
  expect_equal(ufs$state[ufs$abb == "AC"], "ACRE")
})
