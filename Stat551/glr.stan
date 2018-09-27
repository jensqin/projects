data {
  int<lower=0> N; // number of observations
  real y[N]; // responses
  matrix[N,6] x;
  row_vector[6] xtx[6];
}
parameters {
  vector[6] beta;
  real mu;
  real<lower=0> sigma;
}
model {
  for(i in 1:N){
   y~normal(beta[1]*x[i,1]+ beta[2]*x[i,2]+ beta[3]*x[i,3] + beta[4]*x[i,4]+beta[5]*x[i,5] + beta[6]*x[i,6],sigma);
  }
  target += -2*sigma*sigma-log(sigma)/2;
  beta ~ normal(0, N*sigma^2.*xtx);
}
