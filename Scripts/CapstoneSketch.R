install.packages("readxl")

library("readxl")

 

 

 

 

 

dta = as.data.frame(read_excel("C:/Users/Lyudmila/Desktop/ClimateCapstone.xlsx"))

rowkeep = c(4, 45, 62, 68, 0)

keep = c()

for (i in 1:20064){

  cur = i %% 76

  if (cur %in% rowkeep) keep = c(keep, i)

}

newdta = dta[keep, ]

row.names(newdta) = NULL

# Every 5th row is the data for greenhouse emissions (what we are predicting)

 

dta1 = data.frame()

 

for (i in 2010:2013){

  year = as.character(i)

  GasEmissions = newdta[rep(0:263) * 5 + 2, year]

  Population = newdta[rep(0:263) * 5 + 1, year]

  AccessToElectricity = newdta[rep(0:263) * 5 + 3, year]

  ForestArea = newdta[rep(0:263) * 5 + 4, year]

  AgriculturalLand = newdta[rep(0:263) * 5 + 5, year]

  dta2 = data.frame(

    GasEmissions,

    Population,

    AccessToElectricity,

    ForestArea,

    AgriculturalLand

  )

  dta1 = rbind(dta1, dta2)

}

 

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

  test.mae <- sum(abs(preds.prob - test.y))/nrow(test)

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

 

set.seed(40)

dta1 = dta1[sample(nrow(dta1)), ]

 

 

results = LinearRegression(

  x = dta1[, -1],

  y = dta1[, 1],

  cutoff = 0.95

)

 

print(results$Train.MAE)

print(results$Test.MAE)

plot(results$Truth_and_Predicted)
