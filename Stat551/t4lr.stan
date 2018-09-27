data {
  int<lower=0> N; // number of observations
  real y[N]; // responses
  matrix[N,9] x;
  }
parameters {
  vector[9] beta;
  real<lower=0> sigma;
  real con;
}
model {
  for(i in 1:N){
   y~normal(con + beta[1]*x[i,1]+ beta[2]*x[i,2]+ beta[3]*x[i,3] + beta[4]*x[i,4]+beta[5]*x[i,5] + beta[6]*x[i,6]+beta[7]*x[i,7] + beta[8]*x[i,8] + beta[9]*x[i,9],sigma);
  }
  for(j in 1:9)
  {
    beta[j]~student_t(4, 0, 1);
  }
  target += -2*log(sigma);
}
