# Random-Variables.md

# Prediction of Global Warming through Analysis of Countries' Development Indicators

## Vincent Li, Innokentiy Kaurov, Henry Greenhut, Oliver Zhou, Krishna Suresh

## Data
[Dataset 1 with temperature changes of world countries](https://www.kaggle.com/sevgisarac/temperature-change)

[Dataset 2 with indicators of world countries](https://www.kaggle.com/ploverbrown/world-bank-indicators-collection)

## Importance of data
### To be able to predict the global (and domestic!) warming by the following indicators:
- Infrastructure
- Economic Growth
- Trade
- Poverty
## Benchmark. Existing projects include:
## [Sample 1](https://www.kaggle.com/ghenima/temperature-change-analysis-in-progress)
This person did a forecast of temperature. We are going to use World Bank indicators to predict the temperature change in individual areas.

## [Sample 2](https://www.kaggle.com/gatandubuc/forecast-with-n-beats-interpretable-model)
This person also did a forecast of temperature. We are going to use neural networks to make more accurate forecasts of global warming.
## Proposed Model/Algorithm
Our initial aim is to carry out 2 investigations. In both projects, we will try to build
a model that predicts the global and domestic temperature changes. We will then assess the accuracy of the model by comparing the results to 
the actual values. This will allow us to compare the effectiveness of both models, and choose the best one.
We will use the following approaches for creating each model:
1. **Probabilistic Approach.** This first method relies on randomness. We will only use the information from dataset 1. We will select a portion of the past temperature data and run a Monte Carlo Tree Search algorithm. In our algorithm we will use the in-built *rnorm()* function in R to generate paths, and *Mean Squared Error* to assess the accuracy of each path. By selecting the randomly-generated path which matches actual data the most, we will be able to use this path to predict the future temperature changes (data outside this portion).
2. **Deterministic Approach.** In the second method we will try to come up with a linear formula to forecast the future temperature changes based on the 
countries' World Bank indicators. This approach will use machine learning, in particular the Linear Regression algorithm. This time we will use data from both datasets.
We will take the countries' indicators from dataset 2 as the explanatory variables (*X*), and the temperature change from dataset 1 as the response variable (*Y*).
This will require us to combine the two datasets, which may be quite difficult to do. We will then write an algorithm that learns from *X* to predict *Y*.
If the results are unsatisfactory, we may need to use a Neural Network to boost the algorithm's performance.

## Diagram: coming soon...
