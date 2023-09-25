# Credit Scoring - Binary probabilistic classifier

## GENERAL INFORMATION

### Introduction

As part of this project, I built a credit scoring model based on a binary probabilistic classifier.

In machine learning, a probabilistic binary classifier is a supervised classifier that is able to predict, given an observation of an input, a probability distribution over a set of two classes, rather than only outputting the most likely class that the observation should belong to.

A credit scoring model is a mathematical model used to estimate the probability of default, which is the probability that customers may trigger a credit event (i.e. bankruptcy, obligation default, failure to pay, and cross-default events). In a credit scoring model, the probability of default is normally presented in the form of a credit score. The higher score refers to a lower probability of default.

Based on this score, a bank employee can make an educated decision, whether to issue a loan to a client, and if so, at what interest rate. Accurate and predictive credit scoring models help maximize the risk-adjusted return of a financial institution.

[Source 1](https://en.wikipedia.org/wiki/Probabilistic_classification), [Source 2](https://www.mathworks.com/discovery/credit-scoring-model.html)

### Description of variables

* **client_id** - client id number
* **education** - education level
* **sex** - client's gender
* **age** - client's age
* **car** - car availability
* **car_type** - foreign-made car indicator
* **decline_app_cnt** - number of rejected applications
* **good_work** - well-paid job indicator
* **bki_request_cnt** - number of BKI requests 
* **home_address** - home address categorizer
* **work_address** - work address categorizer
* **income** - client's income (RUB)
* **foreign_passport** - availability of foreign passport
* **sna** - degree of connection to other bank's clients
* **first_time** - indicator of how long client's info exists in bank's database
* **score_bki** - BKI internal score
* **region_rating** - rating of client'region
* **app_date** - date of application
* **default** - credit default indicator

### Table of content
0. General information
1. Prepare problem
2. Analize data
3. Prepare data
4. Modelling
5. Submission
