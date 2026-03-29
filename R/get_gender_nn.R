# Inputs
.hf_user <- "fmeireles"
.hf_repo <- "genderBR"
.gbr_cache <- new.env(parent = emptyenv())


#' Predict gender from Brazilian first names using a neural network
#'
#' \code{get_gender_nn} uses a character-level GRU neural network to predict
#' gender from Brazilian first names. Unlike \code{\link{get_gender}}, this
#' function can generalise to names not present in the IBGE census dataset.
#'
#' Model weights and vocabulary must be downloaded before first use with
#' \code{\link{download_gender_model}}. If the files are not found in an
#' interactive session, you will be prompted to download them. Subsequent
#' calls within the same session use an in-memory cache.
#'
#' @param names A character vector specifying a person's first name. Names can
#'   also be passed to the function as a full name (e.g., Ana Maria de Souza).
#'   \code{get_gender_nn} is case insensitive.
#' @param prob Report the proportion of female uses of the name? Defaults to
#'   \code{FALSE}.
#' @param threshold Numeric indicating the threshold used in predictions.
#'   Defaults to 0.9.
#' @param encoding Encoding used to read Brazilian names and strip accents.
#'   Defaults to \code{ASCII//TRANSLIT}.
#'
#' @return \code{get_gender_nn} may return three different values:
#'   \code{Female}, if the name provided is female; \code{Male}, if the name
#'   provided is male; or \code{NA}, if we can not predict gender from the
#'   name given the chosen threshold.
#'
#'   If the \code{prob} argument is set to \code{TRUE}, then the function
#'   returns the proportion of females uses of the provided name.
#'
#' @seealso \code{\link{get_gender}}, \code{\link{download_gender_model}}
#'
#' @examples
#' \dontrun{
#' get_gender_nn("Maria")
#' get_gender_nn(c("Maria", "Joao"), prob = TRUE)
#' get_gender_nn("Ana Maria de Souza")
#' }
#'
#' @export

get_gender_nn <- function(names, prob = FALSE, threshold = 0.9,
                          encoding = "ASCII//TRANSLIT") {

  if (!is.character(names)) {
    stop("'names' must be character.", call. = FALSE)
  }
  if (!is.logical(prob)) stop("'prob' must be logical.", call. = FALSE)
  if (!is.numeric(threshold)) stop("'threshold' must be numeric, between 0 and 1.", call. = FALSE)
  if (threshold < 0 || threshold > 1) stop("'threshold' must be between 0 and 1.", call. = FALSE)

  .load_nn_model()
  meta <- .gbr_cache$meta
  model <- .gbr_cache$model

  # Clean names (same logic as get_gender)
  cleaned <- clean_names(name = names, encoding = encoding)

  # Pre-allocate result
  n <- length(names)
  probs <- rep(NA_real_, n)

  # Identify valid (non-NA, non-empty) entries
  valid <- !is.na(cleaned) & nchar(cleaned) > 0
  if (any(valid)) {
    encoded <- vapply(
      cleaned[valid],
      .encode_name,
      integer(meta$max_len),
      meta = meta,
      USE.NAMES = FALSE
    )
    # encoded is (max_len, n_valid) matrix; transpose to (n_valid, max_len)
    x <- torch::torch_tensor(t(encoded), dtype = torch::torch_long())

    model$eval()
    torch::with_no_grad({
      logits <- model(x)
    })
    probs[valid] <- as.numeric(torch::torch_sigmoid(logits)$squeeze(2L))
  }

  if (prob) {
    return(probs)
  }

  # Apply threshold
  result <- rep(NA_character_, n)
  female <- !is.na(probs) & probs >= threshold
  male   <- !is.na(probs) & probs <= (1 - threshold)
  result[female] <- "Female"
  result[male]   <- "Male"
  result
}


#' Clear the neural network in-memory cache
#'
#' Removes the model and vocabulary metadata from the in-memory session cache.
#' The next call to \code{\link{get_gender_nn}} will reload them from the
#' on-disk cache (no re-download needed if the files are already cached).
#'
#' @return Invisible \code{NULL}.
#'
#' @examples
#' \dontrun{
#' clear_nn_cache()
#' }
#'
#' @export
clear_nn_cache <- function() {
  rm(list = ls(.gbr_cache), envir = .gbr_cache)
  invisible(NULL)
}


# --- Private helpers --------------------------------------------------------

.hf_resolve_url <- function(filename) {
  paste0(
    "https://huggingface.co/", .hf_user, "/", .hf_repo,
    "/resolve/main/", filename
  )
}

.cache_dir <- function() {
  d <- tools::R_user_dir("genderBR", "cache")
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
  d
}

#' Download neural network model files
#'
#' Downloads the pre-trained model weights and vocabulary from Hugging Face
#' to a local cache directory. This is required before using
#' \code{\link{get_gender_nn}}.
#'
#' Files are stored in \code{tools::R_user_dir("genderBR", "cache")} and
#' only downloaded if not already present.
#'
#' @return Invisible character vector with the paths to the downloaded files.
#'
#' @examples
#' \dontrun{
#' download_gender_model()
#' }
#'
#' @export

download_gender_model <- function() {
  files <- c("genderbr_weights.pt", "genderbr_vocab.rds")
  paths <- vapply(files, function(f) {
    dest <- file.path(.cache_dir(), f)
    if (!file.exists(dest)) {
      url <- .hf_resolve_url(f)
      utils::download.file(url, dest, mode = "wb", quiet = TRUE)
    }
    dest
  }, character(1), USE.NAMES = FALSE)
  invisible(paths)
}

.load_nn_model <- function() {
  if (!is.null(.gbr_cache$model)) return(invisible(NULL))

  vocab_path   <- file.path(.cache_dir(), "genderbr_vocab.rds")
  weights_path <- file.path(.cache_dir(), "genderbr_weights.pt")

  if (!file.exists(vocab_path) || !file.exists(weights_path)) {
    if (interactive()) {
      ans <- readline(
        "Model files not found. Download them from Hugging Face? (Y/n) "
      )
      if (!tolower(trimws(ans)) %in% c("y", "yes", "")) {
        stop("Model files are required. Run download_gender_model() to ",
             "download them.", call. = FALSE)
      }
      download_gender_model()
    } else {
      stop("Model files not found. Run download_gender_model() first.",
           call. = FALSE)
    }
  }

  meta <- readRDS(vocab_path)
  model <- name_gru_model(
    vocab_size = meta$vocab_size,
    embed_dim  = meta$embed_dim,
    hidden_dim = meta$hidden_dim
  )
  model$load_state_dict(torch::torch_load(weights_path))
  model$eval()

  .gbr_cache$model <- model
  .gbr_cache$meta  <- meta
  invisible(NULL)
}

.encode_name <- function(nm, meta) {

  chars <- strsplit(nm, "")[[1]]
  if (length(chars) > meta$max_len) {
    chars <- chars[seq_len(meta$max_len)]
  }

  idx <- vapply(chars, function(ch) {
    if (ch %in% names(meta$char2idx)) meta$char2idx[[ch]] else 1L
  }, integer(1), USE.NAMES = FALSE)

  # Right-pad with PAD index (1L in 1-based R torch)
  pad_idx <- meta$char2idx[["<PAD>"]]
  out <- rep(pad_idx, meta$max_len)
  out[seq_along(idx)] <- idx
  out
}
