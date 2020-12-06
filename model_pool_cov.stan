//pooled model when
data {
  int <lower=0> N;
  vector[N] y;
  vector[N] x;
}

parameters {
  vector[2] t;
  real <lower=0> sigma;
  vector[2] mu_prior = [10, 10];
  matrix[2, 2] cov_prior = [[100,10,10,100]];
}

transformed parameters {
  vector[N] mu = t[1] + t[2] * x;
}

model {
  //  priors
  t ~ multi_normal(mu_prior, cov_prior);
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
