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
  corr_matrix[2] sig_cov;
  vector<lower=0>[2] sig_scale;
  vector<lower=0>[3] sigma;
  real mu_sd;
  real <lower=0> sigma_sd;
}

transformed parameters {
 // matrix[2,2] sig_hyp = [[sig_scale_areal <lower=0>lpha, sqrt(sig_scale_alpha*sig_scale_beta)*sig_cov[1,2]], [sqrt(sig_scale_beta*sig_scale_alpha)*sig_cov[2,1], sig_scale_beta]]; 
  matrix[2,2] sig_hyp = diag_matrix(sig_scale)*sig_cov*diag_matrix(sig_scale);
  vector[N1] mu1 = theta1[1] +theta1[2]*x1;
  vector[N2] mu2 = theta2[1] +theta2[2]*x2;
  vector[N3] mu3 = theta3[1] +theta3[2]*x3;
}


model {
  sig_cov ~ lkj_corr(2);
  sig_scale ~  multi_normal([10,10], [[100,10],[10,100]]) ;
  mu_theta ~ multi_normal([10,10], [[100,10],[10,100]]) ;
  
  mu_sd~ normal(0,50);
  sigma_sd ~ gamma(1, 1);
  
  
  for (i in 1:3){
    sigma[i] ~ normal(mu_sd, sigma_sd);
  } 

  theta1 ~ multi_normal(mu_theta, sig_hyp); 
  y1 ~ normal(mu1, sigma[1]);
  
  
  theta2 ~ multi_normal(mu_theta, sig_hyp); 
  y2 ~ normal(mu2, sigma[2]);

  
  theta3 ~ multi_normal(mu_theta, sig_hyp); 
  y3 ~ normal(mu3, sigma[3]);  
  
 // theta[J+1] ~ normal(mu, sigma_p); // Getting the mean for the seventh machine
  
}
generated quantities {
  vector[N1] log_lik1;
  vector[N2] log_lik2;
  vector[N3] log_lik3;
  
  
  for (n in 1:N1){
    log_lik1[n] = normal_lpdf(y1[n] | mu1[n], sigma[1]);
  } 
  for (n in 1:N2){
    log_lik2[n] = normal_lpdf(y2[n] | mu2[n], sigma[2]);
  } 
  for (n in 1:N3){
    log_lik3[n] = normal_lpdf(y3[n] | mu3[n], sigma[3]);
  } 
 }




