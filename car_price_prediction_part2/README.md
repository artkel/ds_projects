# Car Price Prediction (part 2) - Combining ML & DL methods

This project is a continuation of [my previous project](https://github.com/artkel/skillfactory_rds/tree/main/module_6), in which I trained a machine learning model to predict used cars' prices based on their characteristics (manufacturer, brand, engine power, body type, fuel type, etc.) using data collected on the Internet.

This time, in addition to classical ML methods, we use RNN, CNN and Transfer Learning to try to improve the quality of predictions using visual and textual information from our dataset (car pictures and ads description).

This time, [all data is given](https://www.kaggle.com/c/sf-dst-car-price-prediction-part2/data), so we don’t have to parse it. **Mean absolute percentage error (MAPE)** is used as a loss function. 

I structured the project as previously to follow a standard DS workflow:

* Data preparation & cleaning
* Data analysis
* Baseline model
* Feature engineering
* Modelling (this part is now complemented with DL methods)

This project is also a part of this Kaggle competition: https://www.kaggle.com/c/sf-dst-car-price-prediction-part2/overview
