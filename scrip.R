FLAGS <- flags(
  flag_numeric("nodes", 128),
  flag_numeric("batch_size", 32),
  flag_string("activation","relu"),
  flag_numeric("learning_rate", 128),
  flag_numeric("epochs", 30)
)

model <- keras_model_sequential() %>%
  layer_dense(units = 32, activation = FLAGS$activation, input_shape = dim(scaled_train_dtm)[2]) %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_adam(learning_rate=FLAGS$learning_rate),
  metrics = "accuracy"
)

summary(model)


train_dtm_matrix <- as.matrix(scaled_train_dtm)
val_dtm_matrix <- as.matrix(scaled_val_dtm)
test_dtm_matrix <- as.matrix(scaled_test_dtm)

train_labels <- as.numeric(train_data_labels)
valid_labels <- as.numeric(valid_data_labels)

history <- model %>% fit(
  x = train_dtm_matrix, y = train_labels,
  epochs = FLAGS$epochs, 
  batch_size= FLAGS$batch_size,
  validation_data = list(x = val_dtm_matrix, y = valid_labels), verbose = 2)



predicted_probs <- model %>% predict(scaled_test_dtm)
predicted_labels <- ifelse(predicted_probs > 0.5, 1, 0)


confusion_matrix <- table(Predicted = factor(predicted_labels, levels = c(0, 1), labels = c("no-thriller", "Thriller")), 
                          Actual = factor(test_data_labels, levels = c(0, 1), labels = c("no-thriller", "Thriller")))
confusion_matrix