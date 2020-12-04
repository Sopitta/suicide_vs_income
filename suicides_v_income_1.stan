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
  vector[3] alpha;
  vector[3] beta;
  real mu_alpha;
  real mu_beta;
  real sigma_hyp;
  real <lower=0> sigma;
}

transformed parameters {
  vector[N1] mu1 = alpha[1] +beta[1]*x1;
  vector[N2] mu2 = alpha[2] +beta[2]*x2;
  vector[N3] mu3 = alpha[3] +beta[3]*x3;

}


model {
  //  priors
  mu_alpha ~ normal(0,2); 
  mu_beta ~ normal(0,2); 
  sigma_hyp ~ inv_chi_square(0.1); 
  
  
  alpha[1] ~ normal(mu_alpha, sigma_hyp); 
  beta[1] ~ normal(mu_beta, sigma_hyp); 
  y1 ~ normal(mu1, sigma);
  
  
  alpha[2] ~ normal(mu_alpha, sigma_hyp); 
  beta[2] ~ normal(mu_beta, sigma_hyp); 
  y2 ~ normal(mu2, sigma);
  
  
  alpha[3] ~ normal(mu_alpha, sigma_hyp); 
  beta[3] ~ normal(mu_beta, sigma_hyp); 
  y3 ~ normal(mu3, sigma);  
  
 // theta[J+1] ~ normal(mu, sigma_p); // Getting the mean for the seventh machine
  
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




