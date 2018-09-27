data {
  int<lower=0> J; // 
  int<lower=0> y[J]; // 
  int<lower=0> n[J]; // 
}
parameters {
  real<lower=0> alpha; 
  real<lower=0> beta;
  real<lower=0, upper=1> theta[J];
}
transformed parameters {
  real x1;
  real x2;
  x1 = log(alpha/beta);
  x2 = log(alpha+beta);
}
model {
  theta ~ beta(alpha, beta);
  y ~ binomial(n, theta);
}
