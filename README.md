# Homework 7: Patient No-Show Prediction API

## Overview
An API for predicting patient no-show appointments using a logistic regression model built with the `plumber` package in R.

## Files
- `HW7_api_server.R` - API endpoint definitions
- `HW7_client_test.R` - Client test code
- `setup.R` - Helper script to train model and start server
- `train_dataset.csv.gz` - Training data

## API Endpoints

### POST `/predict_prob`
Returns probability of no-show (0-1)

### POST `/predict_class`
Returns binary classification (0 or 1)

**Input Format (JSON):**
```json
{
  "age": 57,
  "address": "1",
  "specialty": "1",
  "provider_id": "1",
  "appt_time": "2023-12-07 15:15:00",
  "appt_made": "2023-09-20"
}
```

## Usage

### 1. Install packages
```r
install.packages(c("plumber", "httr", "jsonlite", "lubridate"))
```

### 2. Start API server
```r
source("setupn.R")
```
Server runs on `http://127.0.0.1:8080`

### 3. Test API
```r
source("HW7_client_test.R")
```

## Model Features
- age
- address (categorical)
- specialty (categorical)
- provider_id (categorical)
- days_booked_in_advance (calculated from dates)
