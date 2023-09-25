# BitPredict Project: Forecasting Bitcoin prices based on historical data

In this project, I am going to be building a series of Deep Learning models in an attempt to predict the price of Bitcoin. The problem is framed as a **Time Series Regression**. To train my models, I will use the historical Bitcoin prices for the period from 2014-11-02 to 2021-10-10. The data are collected from https://www.coindesk.com/price/bitcoin/. 

Looking ahead, it's important to note, that all models (even rather complicated ones) were having a hard time beating a simple naïve model (i.e., a model which uses the previous timestep value to predict the next timestep value). This is a common problem to face when trying to forecast data with a strong temporal dependance (i.e. autocorrelated data). 

When considering application of a Time Series forecasting approach, one should be aware that the predictability of an event or a quantity depends on several factors including:

how well we understand the factors that contribute to it;
* how much data is available;
* how similar the future is to the past;
* whether the forecasts can affect the thing we are trying to forecast.

When forecasting cryptocurrency prices, hardly any of the conditions is satisfied (we do not even have enough data, for the whole crypto story begun only a decade ago). We have a very limited understanding of the factors that affect exchange rates (the most profound one is probably the human psychology), the future may well be different to the past if there is a financial crisis or some new financial regulations in one of the countries, and forecasts of the crypto market prices have a direct effect on the prices themselves. If there are well-publicised forecasts that the BTC prices will increase, then people will immediately adjust the price they are willing to pay and so the forecasts are self-fulfilling. In a sense, the exchange rates become their own forecasts. -> [Source](https://otexts.com/fpp3/what-can-be-forecast.html)

Having mentioned this, I still consider the problem as a good playground to learn some underlying concepts of using Deep Learning for Time Series Forecasting. These methods & techniques can be applied for more appropriate forecasting situations to create models that capture the genuine patterns and relationships which exist in the historical data.

I've structured this project as a sequence of experiments, in which I train different models and compare their validation results. I've used MAE, MAPE, MSE, MASE, and RMSE as [metrics](https://www.tensorflow.org/api_docs/python/tf/losses) to compare, whereas MAE is used as a loss function in all models. 

Below, I have included some relevant techniques that I learned and implemented during the project: 
* Using `tf.data` API for more computationally efficient data processing 
* Callbacks for saving the best model during training
* Framing a BTC prices forecasting problem in seq2seq terms and using Conv1D model
* Recurrent neural network to model sequential time series data
* Transforming the problem to multivariat time series problem by adding additional variable - *block reward size*
* Replicating the generic architecture of the [N-BEATS algorithm](https://arxiv.org/abs/1905.10437)
* Creating an ensemble: stacking models trained with different loss-functions together


I believe it is already apparent after all aforementioned about the random process forecasting, but I feel I should still put a disclaimer that **the predictions I've made here are not financial advice**, since the project will be publically available :)
