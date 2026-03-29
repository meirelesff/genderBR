# Tests for get_gender() API-based paths (internal = FALSE, by state)

skip_if_no_internet <- function() {
  skip_on_cran()
  tryCatch(
    {
      res <- httr::GET("https://servicodados.ibge.gov.br/api/v3/nomes/2022/nome/maria",
                       query = list(tipo = "nome", localidade = 0),
                       httr::timeout(5))
      if (httr::http_error(res)) skip("IBGE API not reachable")
    },
    error = function(e) skip("No internet connection or IBGE API unavailable")
  )
}

# --- API with state (forces internal = FALSE) ---

test_that("get_gender with state returns correct gender (2022 API)", {

  skip_if_no_internet()
  res <- get_gender("maria", state = "SP", year = 2022)
  expect_equal(res, "Female")
})

test_that("get_gender with state returns probabilities (2022 API)", {
  skip_if_no_internet()
  p <- get_gender("maria", state = "RJ", prob = TRUE, year = 2022)
  expect_type(p, "double")
  expect_gt(p, 0.9)
})

test_that("get_gender with state works for multiple names (2022 API)", {
  skip_if_no_internet()
  res <- get_gender(c("maria", "joao"), state = "SP", year = 2022)
  expect_length(res, 2)
  expect_equal(res, c("Female", "Male"))
})

test_that("get_gender with state handles duplicate names (2022 API)", {
  skip_if_no_internet()
  res <- get_gender(c("ana", "ana", "joao"), state = "RJ", year = 2022)
  expect_length(res, 3)
  expect_equal(res[1], res[2])
})

test_that("get_gender with multiple states (2022 API)", {
  skip_if_no_internet()
  res <- get_gender(c("ana", "joao"), state = c("SP", "RJ"), year = 2022)
  expect_length(res, 2)
  expect_equal(res, c("Female", "Male"))
})

# --- API 2010 ---

test_that("get_gender with internal = FALSE uses API (2010)", {
  skip_if_no_internet()
  # The 2010 v1 endpoint may no longer be available; skip if it 404s
  res <- tryCatch(
    get_gender("maria", internal = FALSE, year = 2010),
    error = function(e) {
      if (grepl("404", conditionMessage(e))) skip("2010 API endpoint unavailable")
      stop(e)
    }
  )
  expect_equal(res, "Female")
})

test_that("get_gender with state works (2010 API)", {
  skip_if_no_internet()
  res <- tryCatch(
    get_gender("maria", state = "SP", year = 2010),
    error = function(e) {
      if (grepl("404", conditionMessage(e))) skip("2010 API endpoint unavailable")
      stop(e)
    }
  )
  expect_equal(res, "Female")
})

# --- Unknown names via API ---

test_that("get_gender returns NA or errors for unknown names via API (2022)", {
  skip_if_no_internet()
  res <- tryCatch(
    get_gender("xyzxyznotaname", internal = FALSE, year = 2022),
    error = function(e) NA
  )
  expect_true(is.na(res))
})
