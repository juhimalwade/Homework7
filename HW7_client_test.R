library(httr)
library(jsonlite)

#API server URL (local server)
base_url <- "http://127.0.0.1:8080"

cat("-----Testing API------- \n\n")

#Prep test cases from dataset
test_cases <- list(
  list(
    age = 81,
    address = "2",
    specialty = "3",
    provider_id = "5",
    appt_time = "2023-06-29T17:45:00Z",
    appt_made = "2023-05-17"
  ),
  list(
    age = 78,
    address = "1",
    specialty = "3",
    provider_id = "3",
    appt_time = "2023-06-18T19:00:00Z",
    appt_made = "2023-04-14"
  ),
  list(
    age = 61,
    address = "2",
    specialty = "1",
    provider_id = "4",
    appt_time = "2023-01-21T18:45:00Z",
    appt_made = "2022-11-13"
  ),
  list(
    age = 48,
    address = "2",
    specialty = "2",
    provider_id = "5",
    appt_time = "2023-02-12T18:00:00Z",
    appt_made = "2022-12-19"
  )
)

#Test each case
for (i in seq_along(test_cases)) {
  cat(sprintf("--- Test Case %d ---\n", i))
  
  #Convert to JSON
  test_json <- toJSON(test_cases[[i]], auto_unbox = TRUE)
  
  #Test predict_prob endpoint
  response_prob <- POST(
    url = paste0(base_url, "/predict_prob"),
    body = test_json,
    content_type("application/json")
  )
  
  #Unserialize the return value
  prob_result <- content(response_prob, as = "parsed")
  cat("  /predict_prob result:", prob_result, "\n")
  
  #Test predict_class endpoint
  response_class <- POST(
    url = paste0(base_url, "/predict_class"),
    body = test_json,
    content_type("application/json")
  )
  
  #Unserialize the return value
  class_result <- content(response_class, as = "parsed")
  cat("  /predict_class result:", class_result, "\n\n")
}

cat("-----Testing Done-----\n")