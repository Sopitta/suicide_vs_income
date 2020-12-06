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
  vector[2] theta1;
  vector[2] theta2;
  vector[2] theta3;
  vector[2] mu_theta;
  corr_matrix[2] sig_corr; //Correlation matrix 
  vector<lower=0>[2] sig_scale; // Scale
  real <lower=0> sigma;
}

transformed parameters {
  matrix[2,2] sig_hyp = diag_matrix(sig_scale)*sig_corr*diag_matrix(sig_scale); //Creating the covariance matrix
  vector[N1] mu1 = theta1[1] +theta1[2]*x1;
  vector[N2] mu2 = theta2[1] +theta2[2]*x2;
  vector[N3] mu3 = theta3[1] +theta3[2]*x3;
}


model {
  sigma ~ gamma(1,1); // Uninformative prior
  sig_corr ~ lkj_corr(2); //Prior for the correlation matrix
  sig_scale ~  multi_normal([10,10], [[100,10],[10,100]]) ; // Creating prior from uninformative hyperprior
  mu_theta ~ multi_normal([10,10], [[100,10],[10,100]]) ; // Creating prior from uninformative hyperprior

  theta1 ~ multi_normal(mu_theta, sig_hyp); 
  y1 ~ normal(mu1, sigma);
  
  
  theta2 ~ multi_normal(mu_theta, sig_hyp); 
  y2 ~ normal(mu2, sigma);

  
  theta3 ~ multi_normal(mu_theta, sig_hyp); 
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




