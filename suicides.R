library(rstan)
library(shinystan)
library(loo)

#setwd("C:/Users/SopittaT/Desktop/Fall2020/BDA/Project/Data")
#setwd("~/Documents/work/bda/project")
setwd("/m/home/home7/75/ranjitm1/unix/Downloads/bda/suicide_v_income")


ukdata =read.csv('UKdata.csv');
usdata =read.csv('USdata.csv');
countrydata =read.csv('countrydata.csv')
loo_vals = integer(9)
k_vals = integer(9)

file_names = c("model_1.stan", "suicides_v_income_1.stan", "suicides_v_income_2.stan", "model_2.stan", "suicides_v_income_cov2.stan", "separate_model_1.stan", "Model_3.stan"  )

#file_name = "suicides_v_income.stan"
#file_name = "separate_model_1.stan"
file_name = "suicides_v_income_2.stan"
i=1;
for(file_name in file_names)
{sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol))
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models


loo1 <- loo(log_lik)
print(loo1$estimates[1])
loo_vals[i]=loo1;
k_vals[i] = max(loo1$diagnostics$pareto_k); 
i=i+1;
}
###################4k_vals

file_name = "model_pool_1.stan"

sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y = c(ukdata$suicides100k, usdata$suicides100k, countrydata$suicides100k), x=c(ukdata$wagepercol, usdata$wagepercol, countrydata$wagepercol), N = 124)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models


loo1 <- loo(log_lik)
print(loo1$estimates[1])
loo_vals[i]=loo1
k_vals[i] = max(loo1$diagnostics$pareto_k)
i=i+1;

file_name = "Model_4.stan"

sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y = c(ukdata$suicides100k, usdata$suicides100k, countrydata$suicides100k), x=c(ukdata$wagepercol, usdata$wagepercol, countrydata$wagepercol), N = 124)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models


loo1 <- loo(log_lik)
print(loo1$estimates[1])
loo_vals[i]=loo1
k_vals[i] = max(loo1$diagnostics$pareto_k)

