library(rstan)
library(shinystan)
library(loo)

#setwd("C:/Users/SopittaT/Desktop/Fall2020/BDA/Project/Data")
#setwd("~/Documents/work/bda/project")
setwd("/m/home/home7/75/ranjitm1/unix/Downloads/bda/suicide_v_income")


ukdata =read.csv('UKdata.csv');
usdata =read.csv('USdata.csv');
countrydata =read.csv('countrydata.csv')


file_names = c("Model_1.stan", "Model_2.stan", "Model_3.stan", "Model_4.stan"  )


file_name = file_names[1]
i=1; loo_vals1 <-list(1,2,3,4); k_vals1<- list(c(1,2,3), c(1,2,3), c(1,2,3))
v_list1 = list(c(10, 100,   1,100,   1, 1,   1, 1,   1, 1), c(0, 10,   0,10,   1, 1,   1, 1,   1, 1), c(10, 100,   1,100,   4, 4,   4, 4,   4, 1), c(0, 10,   0,10,   4, 4,   4, 4,   4, 4))
for(v_val in v_list)
{sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol), v=v_val)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))
draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models
loo1 <- loo(log_lik)
loo_vals1[i]=loo1$estimates[1]
k_good = sum(loo1$diagnostics$pareto_k<0.7); k_ok = sum(loo1$diagnostics$pareto_k>=0.7 & loo1$diagnostics$pareto_k<0.9);
k_bad = sum(loo1$diagnostics$pareto_k>=0.9)
k_vals1[[i]] = c(k_good, k_ok, k_bad); i=i+1
}




file_name = file_names[2]
i=1; loo_vals2 <-list(1,2,3,4); k_vals2<- list(c(1,2,3), c(1,2,3), c(1,2,3))
v_list2 = list(c(1,1,   2,    0,10,   100,10,100,   10,0,   100,10,100),
               c(4,4,   0.5,    0,2,   20,10,20,   2,0,   20,10,20),
               c(2,2,   0.25,    2,5,   100,10,100,   5,2,   100,30,100),
               c(1,1,   0.75,    2,20,   20,10,20,   20,20,   20,10,20)               
)
for(v_val in v_list2)
{sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol), v=v_val)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))
draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models
loo1 <- loo(log_lik)
loo_vals2[i]=loo1$estimates[1]
k_good = sum(loo1$diagnostics$pareto_k<0.7); k_ok = sum(loo1$diagnostics$pareto_k>=0.7 & loo1$diagnostics$pareto_k<0.9);
k_bad = sum(loo1$diagnostics$pareto_k>=0.9)
k_vals2[[i]] = c(k_good, k_ok, k_bad); i=i+1
}





file_name = file_names[3]
i=1; loo_vals3 <-list(1,2,3,4); k_vals3<- list(c(1,2,3), c(1,2,3), c(1,2,3))
v_list3 = list(c(1,1,  10,0,   100,10,100),
               c(4,4,   50,2,   50,20,10),
               c(0.5,0.5,   5,2,   50,10,50),
               c(2,2,   10,0,   100,5,100)  
)
for(v_val in v_list3)
{sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y1 = ukdata$suicides100k, x1=ukdata$wagepercol, N1 = length(ukdata$wagepercol), y2 = usdata$suicides100k, x2=usdata$wagepercol, N2 = length(usdata$wagepercol), y3 = countrydata$suicides100k, x3=countrydata$wagepercol, N3 = length(countrydata$wagepercol), v=v_val)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))
draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models
loo1 <- loo(log_lik)
loo_vals3[i]=loo1$estimates[1]
k_good = sum(loo1$diagnostics$pareto_k<0.7); k_ok = sum(loo1$diagnostics$pareto_k>=0.7 & loo1$diagnostics$pareto_k<0.9);
k_bad = sum(loo1$diagnostics$pareto_k>=0.9)
k_vals3[[i]] = c(k_good, k_ok, k_bad); i=i+1
}






file_name = file_names[4]
i=1; loo_vals4 <-list(1,2,3,4); k_vals4 <-list(c(1,2,3), c(1,2,3), c(1,2,3))
v_list4 = list(c(1,1,  10,0,   100,10,100),
               c(4,4,   50,2,   50,20,10),
               c(0.5,0.5,   5,2,   50,10,50),
               c(2,2,   10,0,   100,5,100)  )
for(v_val in v_list4)
{sm_suicide <- rstan::stan_model(file = file_name)

stan_data <- list(y = c(ukdata$suicides100k, usdata$suicides100k, countrydata$suicides100k), x=c(ukdata$wagepercol, usdata$wagepercol, countrydata$wagepercol), N = 124, v=v_val)
model_hier <- rstan::sampling(sm_suicide, data = stan_data, seed = 2,control=list(adapt_delta=0.95))
draws_hier <- as.data.frame(model_hier)
log_lik  <- data.matrix(draws_hier[(length(draws_hier)-123):(length(draws_hier)-1)]) #Works for all models
loo1 <- loo(log_lik)
loo_vals4[i]=loo1$estimates[1]
k_good = sum(loo1$diagnostics$pareto_k<0.7); k_ok = sum(loo1$diagnostics$pareto_k>=0.7 & loo1$diagnostics$pareto_k<0.9);
k_bad = sum(loo1$diagnostics$pareto_k>=0.9)
k_vals4[[i]] = c(k_good, k_ok, k_bad); i=i+1
}
