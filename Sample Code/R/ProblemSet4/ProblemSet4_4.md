## Stat 506 - Problem 4

#### Zhen Qin

#### 4.

Datasets are from https://github.com/jensqin/Stat506 .

###### a.

```{r}
install.packages("mgcv")
library(mgcv)

setwd("E:/UM academy/stat 506/ProblemSet4")
load('ps4_q4.RData')

fit=gam(y~x,data=sample_data)
pred=predict(fit)
```

###### b.

```{r}

```

###### c.

```{r}

```

###### d.

```{r}

```

