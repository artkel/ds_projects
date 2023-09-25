# Wine Quality - Multiclass Classification Problem

The goal of this project is to predict wine quality based on physicochemical tests. The quality scala features descrete values from 3 to 9, with 3 refering to the lowest quality and 9 being a top grade. 

We will approach the problem as a **multiclass classification** task, although it can also be solved by means of regression algorithms.

As models' performance metrics, we will use *accuracy*, *f1-measure*, *recall* and *precision*.

We are dealing here with [rather clean, structured data](https://query.data.world/s/i7ryk6swyw4zylwytuw66dciymeps4). Some new techniques I implemented in the course of the project are:

* Calculating feature importance using *Mutual Information Statistics* & *ANOVA F-test*
* Oversampling to solve imbalance classes issue
* Feature engineering using `PolynomialFeatures` from sklearn
* Feature selection with *Recursive Feature Elimination*
* Fine tuning of hyperparameters with `RandomizedSearchCV` from sklearn.