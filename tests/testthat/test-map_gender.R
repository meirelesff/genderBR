# Tests for map_gender()

skip_if_no_internet <- function() {
  skip_on_cran()
  tryCatch(
    {
      res <- httr::GET("https://servicodados.ibge.gov.br/api/v1/censos/nomes/mapa",
                       query = list(nome = "maria"),
                       httr::timeout(5))
      if (httr::http_error(res)) skip("IBGE API not reachable")
    },
    error = function(e) skip("No internet connection or IBGE API unavailable")
  )
}

test_that("map_gender returns a data.frame with expected columns", {
  skip_if_no_internet()
  res <- map_gender("maria")
  expect_s3_class(res, "data.frame")
  expect_true(nrow(res) > 0)
  expect_true(all(c("nome", "uf", "freq", "populacao", "sexo", "prop") %in% names(res)))
})

test_that("map_gender works with full names (uses first name only)", {
  skip_if_no_internet()
  res <- map_gender("Maria da Silva Santos")
  expect_s3_class(res, "data.frame")
  expect_true(nrow(res) > 0)
})

test_that("map_gender is case insensitive", {
  skip_if_no_internet()
  res_lower <- map_gender("maria")
  res_upper <- map_gender("MARIA")
  expect_equal(nrow(res_lower), nrow(res_upper))
})

test_that("map_gender accepts gender filter", {
  skip_if_no_internet()
  res_f <- map_gender("maria", gender = "f")
  expect_s3_class(res_f, "data.frame")
  expect_true(nrow(res_f) > 0)

  res_m <- map_gender("joao", gender = "m")
  expect_s3_class(res_m, "data.frame")
  expect_true(nrow(res_m) > 0)
})

test_that("map_gender returns empty or errors for unknown name", {
  skip_if_no_internet()
  # The API may error or return an empty/zero-row result
  res <- tryCatch(map_gender("xyzxyzxyznotaname"), error = function(e) "error")
  if (!identical(res, "error")) {
    expect_s3_class(res, "data.frame")
    expect_true(nrow(res) == 0 || all(res$freq == 0))
  }
})
