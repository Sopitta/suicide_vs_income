//pooled model when alpha and beta are the same for all mu
data {
  int <lower=0> N;    //  number  of data  points, uk
  vector[N] y;
  vector[N] x;
}

parameters {
  real alpha;
  real beta;
  real <lower=0> sigma;
}

transformed parameters {
  vector[N] mu = alpha + beta * x;
}

model {
  //  priors
  alpha ~ normal(0, 3); 
  beta ~ normal(0, 3); 
  sigma ~ gamma(1,1);

  
  for (n in 1:N){
    y[n] ~ normal(mu[n], sigma);
  } 
}

generated quantities {
  vector[N] log_lik;
  
  for (n in 1:N){
    log_lik[n] = normal_lpdf(y[n] | mu[n], sigma);
  } 
 }

