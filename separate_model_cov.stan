//separated model
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
  vector[2] t1;
  vector[2] t2;
  vector[2] t3;
  real <lower=0> sigma1;
  real <lower=0> sigma2;
  real <lower=0> sigma3;

}

transformed parameters {
  vector[N1] mu1 = t1[1] + t1[2] * x1;
  vector[N2] mu2 = t2[1] + t2[2] * x2;
  vector[N3] mu3 = t3[1] + t3[2] * x3;
}

model {
  //  priors
  sigma1 ~ gamma(1,1);
  sigma2 ~ gamma(1,1);
  sigma3 ~ gamma(1,1);
  t1 ~ multi_normal([0, 0], [[100,10],[10,100]]);
  t2 ~ multi_normal([0, 0], [[100,10],[10,100]]);
  t3 ~ multi_normal([0, 0], [[100,10],[10,100]]);
  
  
  for (n in 1:N1){
    y1[n] ~ normal(mu1[n], sigma1);
  } 
  
  for (n in 1:N2){
    y2[n] ~ normal(mu2[n], sigma2);
  } 
  
  for (n in 1:N3){
    y3[n] ~ normal(mu3[n], sigma3);
  } 
}

generated quantities {
  vector[N1] log_lik1;
  vector[N2] log_lik2;
  vector[N3] log_lik3;
  
  
  for (n in 1:N1){
    log_lik1[n] = normal_lpdf(y1[n] | mu1[n], sigma1);
  } 
  for (n in 1:N2){
    log_lik2[n] = normal_lpdf(y2[n] | mu2[n], sigma2);
  } 
  for (n in 1:N3){
    log_lik3[n] = normal_lpdf(y3[n] | mu3[n], sigma3);
  } 
 }

