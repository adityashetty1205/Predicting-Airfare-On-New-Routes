# ✈️ Predicting Airfare on New Routes

This project was based on historical U.S. airfare data collected between Q3 1996 and Q2 1997. It aimed to help an aviation consulting firm build models to estimate average airfare on new routes, especially when planning to repurpose old airports for commercial use. Our job was to explore the data, build predictive models using **Excel**, **R**, and **SAP Analytics Cloud (SAC)**, and compare their accuracy in predicting airfare.

---

## 📁 Dataset Overview

We started with a dataset containing real U.S. domestic route information. Each row represented a city-to-city route with variables that influence airfare, such as:

* **COUPON**: Average number of legs (non-stop = 1, one-stop = 2, etc.)
* **NEW**: Number of new carriers on the route
* **SW**: Whether Southwest Airlines serves the route
* **VACATION**: Whether it's a typical vacation route
* **HI**: Market concentration (Herfindahl Index)
* **INCOME/POPULATION**: Income and population of starting and ending cities
* **SLOT/GATE**: Congestion constraints at airports
* **DISTANCE**: Route distance in miles
* **PAX**: Number of passengers
* **FARE**: Average fare (our target variable)

---

## 🧹 Data Cleaning & Preparation

Before modeling, we checked for missing values and confirmed that data types were appropriate. Some variables like "SW" and "VACATION" were originally categorical ("Yes"/"No") and had to be transformed into numerical binary form (1 or 0).

We also looked at correlations and distributions of all input variables to understand potential relationships with the target variable **FARE**.

---

## 📊 Excel Modeling (Analytics Solver)

We built multiple regression models in Excel using Analytics Solver:

* **Initial Model**: Included all 17 predictors. However, we noticed that some had very high p-values (e.g., `S_POP`, `NEW`), indicating they didn’t contribute much to predicting fare.
* **Improved Model**: After removing these weak predictors, we kept the top 10 that had stronger correlation with FARE.

### Key Results:

* Adjusted R² improved to **0.626**, indicating that ~63% of variation in fare could be explained by the chosen predictors.
* **SW (Southwest Airlines presence)** showed a strong negative impact on fare, confirming that low-cost carriers reduce average ticket prices.
* **DISTANCE** and **COUPON** positively influenced fare — longer or multi-leg trips cost more.
* Final model in Excel had good interpretability but moderate prediction performance.

---

## 📉 R Modeling (RStudio)

In R, we tested two types of models:

### 1. Multiple Linear Regression

* Similar to Excel, we built a linear model with selected predictors.
* **Adjusted R²** was around **0.648**.
* The `summary()` output confirmed the same pattern — SW presence decreased fares significantly, while `DISTANCE`, `COUPON`, and `HI` increased them.

### 2. Regression Tree

* Built using the `rpart` package for decision trees.
* This model revealed thresholds: for example, routes with `DISTANCE < 500 miles` and no Southwest service were more likely to have higher fares.
* Although less accurate (R² = ~0.51), the regression tree helped in segmenting routes based on key decision points.

---

## 📈 SAC (SAP Analytics Cloud) Modeling

SAC offered more visual tools for model building and residual diagnostics:

### 1. Multiple Regression (SAC)

* Identical predictor selection process.
* **Adjusted R² = 0.652**, slightly better than Excel and R.
* All major predictors (SW, COUPON, DISTANCE) were significant.
* SAS also provided VIF and residual plots to confirm model assumptions like linearity and multicollinearity.

### 2. Regression Tree (CHAID)

* This tree model grouped data based on splits in COUPON, SW, and SLOT.
* It was useful for rule-based predictions but not as accurate as linear regression.

---

## 📊 Model Comparison

| Software | Model Type        | Adjusted R² | Strengths                              |
| -------- | ----------------- | ----------- | -------------------------------------- |
| Excel    | Linear Regression | 0.626       | Easy to interpret, beginner-friendly   |
| R        | Linear Regression | 0.648       | Statistically flexible, deeper control |
| R        | Regression Tree   | ~0.51       | Good segmentation, low accuracy        |
| SAC      | Linear Regression | 0.652       | Best performance overall               |
| SAC      | CHAID Tree        | ~0.49       | Good insights, lower precision         |

---

## 📌 Interpretation & Learnings

* **Southwest Airlines**’ presence consistently led to lower fares across all models.
* **Route distance**, **market concentration (HI)**, and **flight structure (COUPON)** were major fare drivers.
* Across tools, **SAS linear regression** performed best, followed closely by R.
* **Tree-based models** helped in route segmentation but were weaker in prediction accuracy.

---

## 🔗 Project Structure

This project includes models built in:

* Excel (Analytics Solver)
* R (Linear Regression & Regression Tree)
* SAP Analytics Cloud (Linear Regression & CHAID)

All results were compared based on accuracy, interpretability, and suitability for business use.

---

## 👤 Author

**Aditya Pramod Shetty**  
Master's in Business Analytics |
Isenberg School of Management | University of Massachusetts Amherst

📧 Email: adityashetty1205@gmail.com  
🔗 Linkedin: https://www.linkedin.com/in/aditya-shetty1205/

---

## 🏷️ Tags

`Excel` `R` `SAC` `Airfare Prediction` `Regression Models` `Regression Tree` `SAS EG` `Southwest Airlines` `Linear Modeling` `Aviation Data` `Price Prediction` `Analytics Project` `Multiple Linear Regression` `Machine Learning` `Data Analytics` `Logistic Regression` 
