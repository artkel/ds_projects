# Car Price Prediction - Data Parsing & Regression Model

## GENERAL INFORMATION

### Introduction

This is the final project after the sixth unit of the Data Science PRO course on the SkillFactory educational online platform. The project is also a part of the [Kaggle competition](https://www.kaggle.com/c/sf-dst-car-price-prediction/overview).

Goal of the project: prepare a regression machine learning algorithm to predict prices of used cars based on their characteristics, such as mileage, engine power and displacement, body type and color, number of owners, etc.

In practice, such solutions are used, for example, to quickly estimate the cost of a used car by a buyer or to detect anomalies, i.e. when the price of the offered car significantly differs from the price offered by the algorithm, which indicates a possibly stolen or damaged vehicle.

Some of new challenges I faced during the project:
* [data web scraping](https://github.com/artkel/skillfactory_rds/blob/main/module_6/Parsing.ipynb) for training set using the BeautifulSoup library
* using clustering for feature engineering
* using target encoding with smoothing to encode categorical variables
* implementing robust scaler to scale numeric features rich with outliers
* using the powerful CatBoost ensemble algorithm
* also a lot of work was done to cleanse and prepare the parsed data for the subsequent algorithm training

### Table of content
0. General information
1. Prepare problem
2. Analize data
3. Feature engineering
4. Modelling
5. Submission
