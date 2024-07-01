

FLAGS <- flags(
  flag_numeric("nodes", 128),
  flag_numeric("batch_size", 100),
  flag_string("activation", "relu"),
  flag_numeric("learning_rate", 0.01),
  flag_numeric("epochs", 30)
)


model = keras_model_sequential()

model %>%
  layer_dense(units = FLAGS$nodes, activation =
                FLAGS$activation) %>%
  layer_dense(units = 1, activation = 'linear') 

model %>% compile(
  optimizer = optimizer_adam(lr=FLAGS$learning_rate),
  loss = "mse",
  metrics = c('mse'))


model %>% fit(
  train_mat,
  train_labels, 
  epochs = FLAGS$epochs, 
  batch_size= FLAGS$batch_size,
  validation_data=list(eval_mat, eval_labels))





