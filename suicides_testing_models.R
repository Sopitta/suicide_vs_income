library(rstan)
library(shinystan)
library(loo)

#setwd("C:/Users/SopittaT/Desktop/Fall2020/BDA/Project/Data")
#setwd("~/Documents/work/bda/project")
setwd("/m/home/home7/75/ranjitm1/unix/Downloads/bda/suicide_v_income")


ukdata =read.csv('UKdata.csv');
usdata =read.csv('USdata.csv');
countrydata =read.csv('countrydata.csv')
loo_vals = list(1,2,3,4)
k_vals = integer(1,2,3,4)

file_names = c("Model_1.stan", "Model_2.stan", "Model_3.stan")

i=1;
for(file_name in file_names)
{sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol))
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)
if(i==1) model_hier1=model_hier;
if(i==2) model_hier2=model_hier;
if(i==3) model_hier3=model_hier;
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models

if(i==1) draws_hier1=draws_hier
if(i==2) draws_hier2=draws_hier
if(i==3) draws_hier3=draws_hier
loo1 <- loo(log_lik)
loo_vals[i]=loo1$estimates[1];
k_vals[[i]] = max(loo1$diagnostics$pareto_k); 
i=i+1;



}
###################4k_vals
model_hier3 = model_hier; 

file_name = "Model_4.stan"

sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y = c(ukdata$suicides100k, usdata$suicides100k, countrydata$suicides100k), x=c(ukdata$wagepercol, usdata$wagepercol, countrydata$wagepercol), N = 124)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))


draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models

draws_hier4=draws_hier
model_hier4=model_hier;

loo1 <- loo(log_lik)
print(loo1$estimates[1])
loo_vals[i]=loo1$estimates[1];
k_vals[[i]] = max(loo1$diagnostics$pareto_k); 


list_of_draws <- extract(model_hier3)
mu1 = list_of_draws$mu1;
mu2 = list_of_draws$mu2;
mu3 = list_of_draws$mu3

mu1v = matrix(1:27,ncol=3) 
for (i in c(1:9)){
  mu1v[i,1] = mean(mu1[,i]);
  mu1v[i,2:3] = quantile(mu1[,i], c(0.025, 0.975));
} 

plot(ukdata$wagepercol, ukdata$suicides100k, ylim=c(0,22))
lines(ukdata$wagepercol, mu1v[,1])
lines(ukdata$wagepercol, mu1v[,2], col='blue')
lines(ukdata$wagepercol, mu1v[,3], col='blue')

mu2v = matrix(1:66,ncol=3) 
for (i in c(1:22)){
  mu2v[i,1] = mean(mu2[,i]);
  mu2v[i,2:3] = quantile(mu2[,i], c(0.025, 0.975));
} 

plot(usdata$wagepercol, usdata$suicides100k)
lines(usdata$wagepercol, mu2v[,1])
lines(usdata$wagepercol, mu2v[,2], col='blue')
lines(usdata$wagepercol, mu2v[,3], col='blue')


mu3v = matrix(1:279,ncol=3) 
for (i in c(1:93)){
  mu3v[i,1] = mean(mu3[,i]);
  mu3v[i,2:3] = quantile(mu3[,i], c(0.025, 0.975));
} 

plot(countrydata$wagepercol, countrydata$suicides100k, ylim=c(0,22))
lines(countrydata$wagepercol, mu3v[,1])
lines(countrydata$wagepercol, mu3v[,2], col='blue')
lines(countrydata$wagepercol, mu3v[,3], col='blue')
