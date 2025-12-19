
Airfare_1_ <- read_excel("C:/Users/rmahendru/OneDrive - University of Massachusetts/Downloads/Airfare (1).xlsx")
names(Airfare_1_)
str(Airfare_1_)
Airfare_1_ <- na.omit(Airfare_1_)
set.seed(123)
install.packages("caret")
library(caret)

# =========================
# 1. Prepare data
# =========================

# Remove rows with missing values
Airfare_1_ <- na.omit(Airfare_1_)

# Keep only numeric columns
Airfare_num <- Airfare_1_[ , sapply(Airfare_1_, is.numeric)]

# Check FARE exists
stopifnot("FARE" %in% colnames(Airfare_num))

# =========================
# 2. Linear Regression
# =========================

fare_lm <- lm(FARE ~ ., data = Airfare_num)

# Model output
summary(fare_lm)

# =========================
# 3. Predictions (SAFE)
# =========================

predictions <- fitted(fare_lm)

# View first predictions
head(predictions)
fare_lm_log <- lm(log(FARE) ~ ., data = Airfare_num)

summary(fare_lm_log)

# Predicted fares (back to dollars)
pred_log <- fitted(fare_lm_log)
pred_fare <- exp(pred_log)
step_lm <- step(fare_lm, direction = "both", trace = FALSE)
summary(step_lm)
nzv <- apply(Airfare_num, 2, sd)
Airfare_num_clean <- Airfare_num[ , nzv > 0]

fare_lm2 <- lm(FARE ~ ., data = Airfare_num_clean)
summary(fare_lm2)

fare_lm_poly <- lm(log(FARE) ~ poly(DISTANCE, 2, raw = TRUE) + ., 
                   data = Airfare_num)

summary(fare_lm_poly)


fare_lm_log <- lm(log(FARE) ~ ., data = Airfare_num)
summary(fare_lm_log)

pred_fare <- exp(fitted(fare_lm_log))
rmse_dollars <- sqrt(mean((pred_fare - Airfare_num$FARE)^2))
rmse_dollars


q <- quantile(Airfare_num$FARE, c(0.01, 0.99))
Airfare_trim <- Airfare_num[
  Airfare_num$FARE >= q[1] & Airfare_num$FARE <= q[2], ]

fare_lm_trim <- lm(log(FARE) ~ ., data = Airfare_trim)
summary(fare_lm_trim)


fare_lm_int <- lm(log(FARE) ~ DISTANCE * MARKET_SHARE + ., data = Airfare_num)
summary(fare_lm_int)


cols_to_remove <- c("S_CODE", "E_CODE", "S_CITY", "E_CITY")

Airfare_1_ <- Airfare_1_[ , !(names(Airfare_1_) %in% cols_to_remove)]

# Remove missing values
Airfare_1_ <- na.omit(Airfare_1_)

# Keep only numeric columns
Airfare_num <- Airfare_1_[ , sapply(Airfare_1_, is.numeric)]

# Linear regression
fare_lm <- lm(FARE ~ ., data = Airfare_num)

summary(fare_lm)

# Predictions
predictions <- fitted(fare_lm)






# =========================
# 1. Load package
# =========================
install.packages("glmnet")   # run once
library(glmnet)

# =========================
# 2. Prepare data (numeric only)
# =========================
Airfare_1_ <- na.omit(Airfare_1_)

# Remove unwanted columns if still present
cols_to_remove <- c("S_CODE", "E_CODE", "S_CITY", "E_CITY")
Airfare_1_ <- Airfare_1_[ , !(names(Airfare_1_) %in% cols_to_remove)]

# Keep numeric variables
Airfare_num <- Airfare_1_[ , sapply(Airfare_1_, is.numeric)]

# Predictor matrix (X) and target (y)
X <- as.matrix(Airfare_num[ , setdiff(names(Airfare_num), "FARE")])
y <- Airfare_num$FARE


set.seed(123)

lasso_cv <- cv.glmnet(
  X, y,
  alpha = 1,        # LASSO
  standardize = TRUE
)

# Best lambda
best_lambda <- lasso_cv$lambda.min
best_lambda


lasso_model <- glmnet(
  X, y,
  alpha = 1,
  lambda = best_lambda
)

# Coefficients
coef(lasso_model)


predictions <- predict(lasso_model, X)

rmse <- sqrt(mean((predictions - y)^2))
r2 <- 1 - sum((predictions - y)^2) /
  sum((y - mean(y))^2)

cat("RMSE:", rmse, "\n")
cat("R-squared:", r2, "\n")







y_log <- log(Airfare_num$FARE)

enet_cv <- cv.glmnet(
  X, y_log,
  alpha = 0.5
)

enet_model <- glmnet(
  X, y_log,
  lambda = enet_cv$lambda.min,
  alpha = 0.5
)

pred_log <- predict(enet_model, X)
pred <- exp(pred_log)

rmse <- sqrt(mean((pred - Airfare_num$FARE)^2))
r2 <- 1 - sum((pred - Airfare_num$FARE)^2) /
  sum((Airfare_num$FARE - mean(Airfare_num$FARE))^2)

rmse
r2

# =========================
# 1. Load package
# =========================
install.packages("randomForest")   # run once
library(randomForest)

# =========================
# 2. Prepare data
# =========================
set.seed(123)

rf_model <- randomForest(
  FARE ~ .,
  data = Airfare_num,
  ntree = 500,
  mtry = floor(sqrt(ncol(Airfare_num) - 1)),
  importance = TRUE
)

# =========================
# 3. Model output
# =========================
print(rf_model)

# Variable importance
importance(rf_model)
varImpPlot(rf_model)

# =========================
# 4. Predictions & performance
# =========================
rf_pred <- predict(rf_model, Airfare_num)

rmse_rf <- sqrt(mean((rf_pred - Airfare_num$FARE)^2))
r2_rf <- 1 - sum((rf_pred - Airfare_num$FARE)^2) /
  sum((Airfare_num$FARE - mean(Airfare_num$FARE))^2)

cat("Random Forest RMSE:", rmse_rf, "\n")
cat("Random Forest R-squared:", r2_rf, "\n")


# =========================
# 1. Load package
# =========================
install.packages("gbm")   # run once
library(gbm)

# =========================
# 2. Gradient Boosting Model
# =========================
set.seed(123)

gbm_model <- gbm(
  FARE ~ .,
  data = Airfare_num,
  distribution = "gaussian",
  n.trees = 3000,
  interaction.depth = 4,
  shrinkage = 0.01,
  n.minobsinnode = 10,
  bag.fraction = 0.7,
  train.fraction = 1.0,
  verbose = FALSE
)

# =========================
# 3. Predictions & performance
# =========================
gbm_pred <- predict(gbm_model, Airfare_num, n.trees = 3000)

rmse_gbm <- sqrt(mean((gbm_pred - Airfare_num$FARE)^2))
r2_gbm <- 1 - sum((gbm_pred - Airfare_num$FARE)^2) /
  sum((Airfare_num$FARE - mean(Airfare_num$FARE))^2)

cat("GBM RMSE:", rmse_gbm, "\n")
cat("GBM R-squared:", r2_gbm, "\n")




set.seed(123)

n <- nrow(Airfare_num)
idx <- sample(seq_len(n), size = 0.8 * n)

train <- Airfare_num[idx, ]
test  <- Airfare_num[-idx, ]




library(randomForest)

rf_model <- randomForest(
  FARE ~ .,
  data = train,
  ntree = 500
)

rf_pred <- predict(rf_model, test)

rmse_rf <- sqrt(mean((rf_pred - test$FARE)^2))
r2_rf <- 1 - sum((rf_pred - test$FARE)^2) /
  sum((test$FARE - mean(test$FARE))^2)

rmse_rf
r2_rf




library(gbm)

gbm_model <- gbm(
  FARE ~ .,
  data = train,
  distribution = "gaussian",
  n.trees = 3000,
  interaction.depth = 4,
  shrinkage = 0.01,
  bag.fraction = 0.7,
  verbose = FALSE
)

gbm_pred <- predict(gbm_model, test, n.trees = 3000)

rmse_gbm <- sqrt(mean((gbm_pred - test$FARE)^2))
r2_gbm <- 1 - sum((gbm_pred - test$FARE)^2) /
  sum((test$FARE - mean(test$FARE))^2)

rmse_gbm
r2_gbm





