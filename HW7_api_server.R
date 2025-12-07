## Write your API endpoints in this file

library(plumber)
library(lubridate)

model <- readRDS("model.rds")

#* @apiTitle No-Show Appointment Prediction API
#* @apiDescription API for predicting no-show appointments based on patient and appointment features

#* Predict probability of no-show appointment
#* @param age:numeric Patient's age
#* @param address:character Patient's address (categorical, 1 or 2)
#* @param specialty:character Provider specialty (categorical, 1-3)
#* @param provider_id:character Provider ID (categorical, 1-5)
#* @param appt_time:character Appointment time (YYYY-MM-DD HH:MM:SS format)
#* @param appt_made:character Date appointment was made (YYYY-MM-DD format)
#* @post /predict_prob
#* @serializer unboxedJSON
function(req) {
  body <- jsonlite::fromJSON(req$postBody)
  
  #Create dataframe based on input
  input_data <- data.frame(
    age = as.numeric(body$age),
    address = as.factor(body$address),
    specialty = as.factor(body$specialty),
    provider_id = as.factor(body$provider_id),
    appt_time = ymd_hms(body$appt_time),
    appt_made = ymd(body$appt_made),
    stringsAsFactors = FALSE
  )
  
  #Calculate days_booked_in_advance
  input_data$days_booked_in_advance <- as.numeric(
    difftime(input_data$appt_time, input_data$appt_made, units = "days")
  )
  
  #Predict probability
  pred_prob <- predict(model, newdata = input_data, type = "response")
  
  #Return probability as numeric value between 0 and 1
  return(as.numeric(pred_prob))
}

#* Predict class (0 or 1) for no-show appointment
#* @param age:numeric Patient's age
#* @param address:character Patient's address (categorical, 1 or 2)
#* @param specialty:character Provider specialty (categorical, 1-3)
#* @param provider_id:character Provider ID (categorical, 1-5)
#* @param appt_time:character Appointment time (YYYY-MM-DD HH:MM:SS format)
#* @param appt_made:character Date appointment was made (YYYY-MM-DD format)
#* @post /predict_class
#* @serializer unboxedJSON
function(req) {
  #Parse the request body
  body <- jsonlite::fromJSON(req$postBody)
  
  #Create data frame from input
  input_data <- data.frame(
    age = as.numeric(body$age),
    address = as.factor(body$address),
    specialty = as.factor(body$specialty),
    provider_id = as.factor(body$provider_id),
    appt_time = ymd_hms(body$appt_time),
    appt_made = ymd(body$appt_made),
    stringsAsFactors = FALSE
  )
  
  #Calculate days_booked_in_advance
  input_data$days_booked_in_advance <- as.numeric(
    difftime(input_data$appt_time, input_data$appt_made, units = "days")
  )
  
  #Predict probability
  pred_prob <- predict(model, newdata = input_data, type = "response")
  
  #Binary classification (threshold = 0.5)
  pred_class <- ifelse(pred_prob > 0.5, 1, 0)
  
  #Return class (0 or 1)
  return(as.integer(pred_class))
}