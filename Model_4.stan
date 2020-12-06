//pooled model when
data {
  int <lower=0> N;
  vector[N] y;
  vector[N] x;
  real v[7];
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
  t ~ multi_normal([v[1], v[2]], [[v[3],v[4]],[v[4],v[5]]]);
  sigma ~ gamma(v[6],v[7]);

  
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
