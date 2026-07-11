# `self` is used in the `torch` 
utils::globalVariables("self")

# Bidirectional GRU model with attention pooling, used to predict the
# probability of a name being female. Trained on the Brazilian name dataset with
# the luz training framework. The module is defined lazily inside a function so
# that torch is only required when the neural-network backend is used.
# @noRd
name_gru_model <- function(vocab_size = 40L, embed_dim = 32L, hidden_dim = 64L) {

  generator <- torch::nn_module(
    "NameGRU",

    initialize = function(vocab_size = 40L, embed_dim = 32L, hidden_dim = 64L) {
      self$embedding <- torch::nn_embedding(
        num_embeddings = vocab_size,
        embedding_dim = embed_dim,
        padding_idx = 1L
      )
      self$embed_drop <- torch::nn_dropout(p = 0.1)
      self$gru <- torch::nn_gru(
        input_size = embed_dim,
        hidden_size = hidden_dim,
        num_layers = 2L,
        batch_first = TRUE,
        bidirectional = TRUE,
        dropout = 0.2
      )
      self$attn <- torch::nn_linear(hidden_dim * 2L, 1L, bias = FALSE)
      self$dropout <- torch::nn_dropout(p = 0.4)
      self$fc <- torch::nn_linear(hidden_dim * 2L, 1L)
    },

    forward = function(x) {
      mask <- (x != 1L)
      emb <- self$embed_drop(self$embedding(x))
      out <- self$gru(emb)
      h_seq <- out[[1]]

      scores <- self$attn(h_seq)$squeeze(3L)
      scores <- scores$masked_fill(!mask, -1e9)
      weights <- torch::nnf_softmax(scores, dim = 2L)
      hidden <- torch::torch_bmm(weights$unsqueeze(2L), h_seq)$squeeze(2L)

      hidden <- self$dropout(hidden)
      self$fc(hidden)
    }
  )

  generator(vocab_size = vocab_size, embed_dim = embed_dim, hidden_dim = hidden_dim)
}
