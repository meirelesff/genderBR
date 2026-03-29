# ============================================================================
# Train the GRU neural network for genderBR
# ============================================================================


pkgload::load_all()
library(torch)
library(luz)

set.seed(42)
torch_manual_seed(42)

# --- Device ------------------------------------------------------------------
device <- if (cuda_is_available()) torch_device("cuda") else torch_device("cpu")
device <- if (backends_mps_is_available()) torch_device("mps") else device

# --- Config ------------------------------------------------------------------
EMBED_DIM <- 64L
HIDDEN_DIM <- 192L
MAX_LEN <- 20L
BATCH_SIZE <- 1024L
EPOCHS <- 60L

# --- Vocabulary (1-based for R torch) ----------------------------------------
vocab <- c("<PAD>", "<UNK>", letters, as.character(0:9), "-", " ")
char2idx <- setNames(seq_along(vocab), vocab)
PAD <- char2idx[["<PAD>"]]
UNK <- char2idx[["<UNK>"]]

# --- Pre-tokenize everything into a matrix -----------------------------------
dat <- genderBR:::nomes
dat$label <- ifelse(!is.na(dat$prob_fem22), dat$prob_fem22, dat$prob_fem10)
dat <- dat[!is.na(dat$label), c("nome", "label")]

encode <- function(nm) {
  chars <- strsplit(sub("\\s.*", "", tolower(trimws(nm))), "")[[1]]
  if (length(chars) > MAX_LEN) chars <- chars[seq_len(MAX_LEN)]
  idx <- match(chars, names(char2idx), nomatch = UNK)
  out <- rep(PAD, MAX_LEN)
  out[seq_along(idx)] <- idx
  out
}

x_mat <- t(vapply(dat$nome, encode, integer(MAX_LEN), USE.NAMES = FALSE))
y_vec <- dat$label

# --- 80 / 10 / 10 split -----------------------------------------------------
n <- nrow(x_mat)
ids <- sample(n)
i_train <- ids[1:round(0.8 * n)]
i_val <- ids[(round(0.8 * n) + 1):round(0.9 * n)]
i_test <- ids[(round(0.9 * n) + 1):n]

make_ds <- function(idx) {
  tensor_dataset(
    x = torch_tensor(x_mat[idx, , drop = FALSE], dtype = torch_long(), device = device),
    y = torch_tensor(y_vec[idx], dtype = torch_float(), device = device)$unsqueeze(2)
  )
}

train_ds <- make_ds(i_train)
val_ds <- make_ds(i_val)
test_ds <- make_ds(i_test)

# --- Custom accuracy metric --------------------------------------------------
metric_acc <- luz_metric(
  abbrev = "Acc",
  initialize = function() { self$correct <- 0; self$total <- 0 },
  update = function(preds, targets) {
    p <- (torch_sigmoid(preds) > 0.5)$to(dtype = torch_float(), device = device)
    t <- (targets > 0.5)$to(dtype = torch_float(), device = device)
    self$correct <- self$correct + (p == t)$sum()$item()
    self$total   <- self$total + targets$size(1)
  },
  compute = function() self$correct / self$total
)

# --- Train with early stopping -----------------------------------------------
fitted <- name_gru_model |>
  luz::setup(
    loss = nn_bce_with_logits_loss(),
    optimizer = optim_adam,
    metrics = list(metric_acc())
  ) |>
  set_hparams(vocab_size = length(vocab), embed_dim = EMBED_DIM,
              hidden_dim = HIDDEN_DIM) |>
  set_opt_hparams(lr = 1e-3, weight_decay = 1e-4) |>
  fit(
    train_ds,
    epochs = EPOCHS,
    valid_data = val_ds,
    dataloader_options = list(batch_size = BATCH_SIZE, shuffle = TRUE),
    callbacks = list(
      luz_callback_early_stopping(monitor = "valid_loss", patience = 5)
    ),
    verbose = TRUE
  )

# --- Evaluate on held-out test set -------------------------------------------
test_result <- fitted |>
  evaluate(
    test_ds,
    dataloader_options = list(batch_size = BATCH_SIZE),
    metrics = list(metric_acc())
  )
print(get_metrics(test_result))

# --- Save artifacts ----------------------------------------------------------
dir.create("inst/model", showWarnings = FALSE, recursive = TRUE)

final_model <- fitted$model$to(device = "cpu")
torch_save(final_model$state_dict(), "inst/model/genderbr_weights.pt")

saveRDS(
  list(vocab = vocab, char2idx = char2idx, max_len = MAX_LEN,
       vocab_size = length(vocab), embed_dim = EMBED_DIM,
       hidden_dim = HIDDEN_DIM),
  "inst/model/genderbr_vocab.rds"
)
