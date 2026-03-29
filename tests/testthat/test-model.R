test_that("name_gru_model instantiates without error", {
  skip_if_not_installed("torch")
  expect_no_error(name_gru_model(40L, 32L, 64L))
})

test_that("forward pass returns correct output shape", {
  skip_if_not_installed("torch")
  model <- name_gru_model(40L, 32L, 64L)
  x <- torch::torch_randint(1, 40, c(4L, 20L), dtype = torch::torch_long())
  out <- model(x)
  expect_equal(out$shape, c(4, 1))
})

test_that("output values are finite", {
  skip_if_not_installed("torch")
  model <- name_gru_model(40L, 32L, 64L)
  x <- torch::torch_randint(1, 40, c(4L, 20L), dtype = torch::torch_long())
  out <- model(x)
  expect_true(all(is.finite(as.numeric(out))))
})

test_that("model has no gradient after eval() + with_no_grad()", {
  skip_if_not_installed("torch")
  model <- name_gru_model(40L, 32L, 64L)
  model$eval()
  x <- torch::torch_randint(1, 40, c(4L, 20L), dtype = torch::torch_long())
  torch::with_no_grad({
    out <- model(x)
  })
  expect_false(out$requires_grad)
})
