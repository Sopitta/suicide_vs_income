//pooled model when
data {
  int <lower=0> N;
  vector[N] y;
  vector[N] x;
}

parameters {
  vector[2] t;
  real <lower=0> sigma;

}

transformed parameters {
  vector[N] mu = t[1] + t[2] * x;
}

model {
  //  priors
  t ~ multi_normal([0, 0], [[100,10],[10,100]]);
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
