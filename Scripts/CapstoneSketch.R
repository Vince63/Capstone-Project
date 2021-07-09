install.packages("readxl")

library("readxl")

# In this experiment, we tried to predict the CO2 gas emissions (in kilotonnes, kt) in every single country by analysing the following indicators:
# - Population
# - Access to Electricity (% of population)
# - Forest Area (in km^2)
# - Agricultural Land (in km^2)

# The data used was taken from years 2010-13.

# The predictions were made using the Linear Regression model.
# The model learned from the indicators (the explanatory variables) to predict the CO2 emissions (the response variable).
# For calculating the error of the model, we decided to use Mean Absolute Error (MAE) instead of Mean Squared Error (MSE),
# because we think it provides a clearer representation of the algorithm's accuracy compared to the original data.
# Credits to Prof. Yin for the original version of the Linear Regression algorithm.


# Import data
dta = as.data.frame(read_excel("..."))

# This vector stores which rows from the data must be kept for every country (by rows' indices)
rowkeep = c(4, 45, 62, 68, 0)

# The FOR loop below expands the list of rows that must be kept, considering every single country.
keep = c()

for (i in 1:20064){

  cur = i %% 76

  if (cur %in% rowkeep) keep = c(keep, i)

}

#Update data: remove unnecessary rows
newdta = dta[keep, ]

# Reset indexation
row.names(newdta) = NULL

# Now, every 2nd row out of 5 is the data for greenhouse emissions (what we are predicting)

# Initialise empty dataframe that will store all the needed stats.
dta1 = data.frame()

# The FOR loop below goes through every year from 2010 to 2013 and adds the data for each indicator into the main dataframe "dta1".
for (i in 2010:2013){

  year = as.character(i)
  
  GasEmissions = newdta[rep(0:263) * 5 + 2, year]

  Population = newdta[rep(0:263) * 5 + 1, year]

  AccessToElectricity = newdta[rep(0:263) * 5 + 3, year]

  ForestArea = newdta[rep(0:263) * 5 + 4, year]

  AgriculturalLand = newdta[rep(0:263) * 5 + 5, year]
 
  # Gas emissions column is now placed first.

  dta2 = data.frame(

    GasEmissions,

    Population,

    AccessToElectricity,

    ForestArea,

    AgriculturalLand

  )

  dta1 = rbind(dta1, dta2)

}

# The Linear Regression algorithm

LinearRegression = function(

  x = all[, -1],

  y = all[, 1],

  cutoff = 0.9,

  ) {

 

  # Compile data

  all <- data.frame(cbind(y,x))

  print(head(all, 10))

 

  # Split data:

  train <- all[1:round(cutoff*nrow(all),0),]; dim(train) # Training set

  test <- all[(round(cutoff*nrow(all),0)+1):nrow(all),]; dim(test) # Testing set

 

  # Identify Response and Explanatory:

  train.x <- data.frame(train[,-1]); colnames(train.x) <- colnames(train)[-1]; dim(train.x)

  train.y <- train[,1]; head(train.y)

  test.x <- data.frame(test[,-1]); dim(test.x)

  test.y <- test[,1]; dim(data.frame(test.y))

 

  # Modeling fitting:

  # GLM or # LM

  model <- glm(

    train.y ~.,

    data = train.x

  )

  sum <- summary(model)

 

  # Make prediction on training:

  preds.train.prob <- predict(model, train.x)
 
  # The following FOR loop computes the MAE, omitting any NA entries.

  train.dif = 0

  train.cnt = 0

  for (i in 1:length(train.y)){

    if (!is.na(train.y[i]) && !is.na(preds.train.prob[i])){

      train.dif = train.dif + abs(preds.train.prob[i] - train.y[i])

      train.cnt = train.cnt + 1

    }

  }

  train.mae <- train.dif / train.cnt

 

  # Make prediction on testing:

  colnames(test.x) <- colnames(train.x)

  preds.prob <- predict(model, test.x)

  # The following FOR loop computes the MAE, omitting any NA entries.

  test.dif = 0

  test.cnt = 0

  for (i in 1:length(test.y)){

    if (!is.na(test.y[i]) && !is.na(preds.prob[i])){

      test.dif = test.dif + abs(preds.prob[i] - test.y[i])

      test.cnt = test.cnt + 1

    }

  }

  test.mae <- test.dif / test.cnt

 

  # Truth.vs.Predicted.Probabilities

  truth.vs.pred.prob <- cbind(test.y, preds.prob)

  colnames(truth.vs.pred.prob) <- c("True_Test_Y", "Predicted_Test_Y")

 

  # Final output:

  return(

    list(

      Summary = sum,

      Train = train,

      Test = test,

      Train.MAE = train.mae,

      Test.MAE = test.mae,

      Truth_and_Predicted = truth.vs.pred.prob

    )

  )

}

# Shuffle the data, setting a custom seed for reproducibility 

set.seed(40)

dta1 = dta1[sample(nrow(dta1)), ]

# Run the algorithm, taking the 1st column (Gas Emissions) as Y, and all other columns as X.
# Cutoff is 95%.

results = LinearRegression(

  x = dta1[, -1],

  y = dta1[, 1],

  cutoff = 0.95

)

print(results$Train.MAE)

print(results$Test.MAE)

plot(results$Truth_and_Predicted)

# After running the whole program, we get the following output:
# Train MAE = 745128 kt
# Test MAE = 773731 kt
# The plot of predicted data against true data can be found in the file "CO2-Emissions-Prediction.jpeg", located in the same "Scripts" folder.
