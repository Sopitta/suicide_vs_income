library(rstan)
library(shinystan)

setwd("~/Documents/work/bda/project")
ukdata =read.csv('UKdata.csv');
usdata =read.csv('USdata.csv');
countrydata =read.csv('countrydata.csv')


file_name = "suicides_v_income.stan"

sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol))
model_hier <- rstan::sampling(sm_suicide, data = stan_data, control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)