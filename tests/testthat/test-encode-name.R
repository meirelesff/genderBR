# Tests for the internal .encode_name() vocabulary mapping.
# .encode_name() is pure R and takes `meta` as an argument, so these tests use a
# small fake vocabulary and need neither torch nor the downloaded model.

fake_meta <- list(
  char2idx = c("<PAD>" = 1L, "<UNK>" = 2L, "a" = 3L, "n" = 4L),
  max_len  = 5L
)

test_that("unseen characters map to <UNK>, not <PAD>", {
  enc <- .encode_name("az", fake_meta)          # a=3 known, z unseen -> <UNK>=2
  expect_equal(enc, c(3L, 2L, 1L, 1L, 1L))
  expect_false(any(enc[1:2] == 1L))             # no PAD among real chars
})

test_that("only trailing positions are padded", {
  enc <- .encode_name("ana", fake_meta)         # a=3, n=4, a=3
  expect_equal(enc, c(3L, 4L, 3L, 1L, 1L))
  pad_pos <- which(enc == 1L)
  expect_equal(pad_pos, seq(min(pad_pos), length(enc)))  # contiguous, ends at max_len

  enc2 <- .encode_name("axa", fake_meta)        # unseen char in the middle
  expect_false(any(enc2[1:3] == 1L))            # middle OOV char is <UNK>, not PAD
})
