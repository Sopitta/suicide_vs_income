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
  real sigma_alpha;
  real sigma_beta;
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
  sigma_alpha ~ inv_chi_square(0.1); 
  sigma_beta ~ inv_chi_square(0.1); 
  
  
  alpha[1] ~ normal(mu_alpha, sigma_alpha); 
  beta[1] ~ normal(mu_beta, sigma_beta); 
  y1 ~ normal(mu1, sigma);
  
  
  alpha[2] ~ normal(mu_alpha, sigma_alpha); 
  beta[2] ~ normal(mu_beta, sigma_beta); 
  y2 ~ normal(mu2, sigma);
  
  
  alpha[3] ~ normal(mu_alpha, sigma_alpha); 
  beta[3] ~ normal(mu_beta, sigma_beta); 
  y3 ~ normal(mu3, sigma);  
  
 // theta[J+1] ~ normal(mu, sigma_p); // Getting the mean for the seventh machine
  
}


