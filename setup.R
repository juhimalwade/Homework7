#This file is used to train the model and export it

library(lubridate)
library(plumber)

#--------LOAD AND PREPARE DATA-------------
cat("Loading training data...\n")
train <- read.csv("train_dataset.csv.gz")

# Convert categorical variables
train$specialty <- as.factor(train$specialty)
train$address <- as.factor(train$address)
train$provider_id <- as.factor(train$provider_id)

# Convert date/time variables
train$appt_time <- ymd_hms(as.character(train$appt_time))
train$appt_made <- ymd(as.character(train$appt_made))

# Create days_booked_in_advance variable
train$days_booked_in_advance <- as.numeric(
  difftime(train$appt_time, train$appt_made, units = "days")
)

#----------TRAIN MODEL-----------------
cat("Training model...\n")
model <- glm(
  no_show ~ age + address + specialty + provider_id + days_booked_in_advance,
  data = train,
  family = binomial
)

cat("Model trained successfully!\n")
cat("Model summary:\n")
print(summary(model))

#----------SAVE MODEL---------------
cat("\nSaving model to model.rds...\n")
saveRDS(model, "model.rds")
cat("Model saved successfully!\n")

#---------RUN API-SERVER------------------
pr <- plumb("HW7_api_server.R")
pr$run(host = "127.0.0.1", port = 8080)

