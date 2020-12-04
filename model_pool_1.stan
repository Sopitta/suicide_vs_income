//pooled model when alpha and beta are the same for all mu
data {
  int <lower=0> N1;    //  number  of data  points, uk
  int <lower=0> N2;    //  number  of data  points, us
  int <lower=0> N3;    //  number  of data  points, country
  vector[N1] y1;
  vector[N2] y2;
  vector[N3] y3;
  vector[N1] x1;
  vector[N2] x2;
  vector[N3] x3;
}

parameters {
  real alpha;
  real beta;
  real <lower=0> sigma;
}

transformed parameters {
  vector[N1] mu1 = alpha + beta * x1;
  vector[N2] mu2 = alpha + beta * x2;
  vector[N3] mu3 = alpha + beta * x3;
}

model {
  //  priors
  alpha ~ normal(0, 3); 
  beta ~ normal(0, 3); 
  
  
  for (n in 1:N1){
    y1[n] ~ normal(mu1[n], sigma);
  } 
  
  for (n in 1:N2){
    y2[n] ~ normal(mu2[n], sigma);
  } 
  
  for (n in 1:N3){
    y3[n] ~ normal(mu3[n], sigma);
  } 
}

generated quantities {
  vector[N1] log_lik1;
  vector[N2] log_lik2;
  vector[N3] log_lik3;
  
  
  for (n in 1:N1){
    log_lik1[n] = normal_lpdf(y1[n] | mu1[n], sigma);
  } 
  for (n in 1:N2){
    log_lik2[n] = normal_lpdf(y2[n] | mu2[n], sigma);
  } 
  for (n in 1:N3){
    log_lik3[n] = normal_lpdf(y3[n] | mu3[n], sigma);
  } 
 }

