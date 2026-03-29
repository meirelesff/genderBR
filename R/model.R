# Model used to predict the probability of a name being female
# based on a bidirectional GRU architecture. Trained on the Brazilian name dataset
# with the luz training framework.
# @noRd

#' @import torch
name_gru_model <- torch::nn_module(
  "NameGRU",

  initialize = function(vocab_size = 40L, embed_dim = 32L, hidden_dim = 64L) {
    self$embedding <- torch::nn_embedding(
      num_embeddings = vocab_size,
      embedding_dim = embed_dim,
      padding_idx = 1L
    )
    self$gru <- torch::nn_gru(
      input_size = embed_dim,
      hidden_size = hidden_dim,
      num_layers = 1L,
      batch_first = TRUE,
      bidirectional = TRUE
    )
    self$dropout <- torch::nn_dropout(p = 0.3)
    self$fc <- torch::nn_linear(hidden_dim * 2L, 1L)
  },

  forward = function(x) {
    emb <- self$embedding(x)
    out <- self$gru(emb)
    h <- out[[2]]

    h_fwd <- h[1L, , ]
    h_bwd <- h[2L, , ]
    
    hidden <- torch::torch_cat(list(h_fwd, h_bwd), dim = 2L)

    hidden <- self$dropout(hidden)
    self$fc(hidden)
  }
)
