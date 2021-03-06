library(rstan)
library(shinystan)
library(loo)

setwd("C:/Users/SopittaT/Desktop/Fall2020/BDA/Project/suicide_v_income")
ukdata =read.csv('UKdata.csv');
usdata =read.csv('USdata.csv');
countrydata =read.csv('countrydata.csv')

file_name = "model_pool_1.stan"
sm_suicide <- rstan::stan_model(file = file_name)

y1 <- ukdata$suicides100k
x1 <- ukdata$wagepercol 
N1 <- length(ukdata$wagepercol)
y2 <- usdata$suicides100k
x2 <- usdata$wagepercol
N2 <- length(usdata$wagepercol)
y3 <- countrydata$suicides100k
x3 <- countrydata$wagepercol
N3 <- length(countrydata$wagepercol)
x <- c(x1,x2,x3)
y <- c(y1,y2,y3)
N<-N1+N2+N3

stan_data <- list(y = y, x = x, N=N)
model_pool <- rstan::sampling(sm_suicide, data = stan_data, seed = 2)
draws_pool <- as.data.frame(model_pool)
log_lik_pool <- data.matrix(draws_pool[128:251])