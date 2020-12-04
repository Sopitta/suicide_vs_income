library(rstan)
library(shinystan)
library(loo)

setwd("C:/Users/SopittaT/Desktop/Fall2020/BDA/Project/Data")
ukdata =read.csv('UKdata.csv');
usdata =read.csv('USdata.csv');
countrydata =read.csv('countrydata.csv')


#file_name = "suicides_v_income.stan"
file_name = "suicides_v_income_1.stan"

sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol))
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)
#suicides_v_income
log_lik1 <- data.matrix(draws_hier[136:144])
log_lik2 <- data.matrix(draws_hier[145:166])
log_lik3 <- data.matrix(draws_hier[167:259])
log_lik  <- data.matrix(draws_hier[136:259])

##suicides_v_income_1
log_lik  <- data.matrix(draws_hier[135:258])


loo1 <- loo(log_lik1)
loo2 <- loo(log_lik2)
loo3 <- loo(log_lik3)