## STAT 506 - Problem Set 1

### Author: Zhen Qin, Uniqname: qinzhen

Notes: scripts and well formatted markdown files can be downloaded on [my github repo](https://github.com/jensqin/jensqin.github.io)/.

#### Problem1

a. Converting between long and wide data formats

The corresponding file and websites are **ProblemSet1_1(a).do**  and https://stats.idre.ucla.edu/stata/modules/ and https://stats.idre.ucla.edu/stat/stata/modules/kids , https://jbhender.github.io/Stats506/dadmomlong.dta , https://stats.idre.ucla.edu/stat/stata/modules/dadmomw.

b. Stata example 1

The corresponding file and websites are **ProblemSet1_1(b).do** and https://stats.idre.ucla.edu/other/dae/ .

c. Stata example 2
The corresponding file and websites are **ProblemSet1_1(c).do** and https://stats.idre.ucla.edu/other/dae/ .



#### Problem2

The corresponding file and websites are **ProblemSet1_2.do** and http://www.eia.gov/consumption/residential/data/2009/ .

a.

`reportable~n` represents state and `rate` represents proportion of wood shingle roofs.

![Capture1](E:\UM academy\stat 506\STATA8\Capture1.PNG)

The max value is .1246495 and report~n is 16, the min value is .0144062 and reportable~n is 19. According to the codebook, the answer 1 is North Carolina, South Carolina, the answer 2 is Tennessee.



b.

A part of the table is shown below, which is the proportion of each roof type for all houses constructed in each decade. `rate` represents  the proportion of each roof type for all houses constructed in each decade.

![Capture2](E:\UM academy\stat 506\STATA8\Capture2.PNG)

For full table, please execute the script.

The following table includes `relrate` (rate in the picture) representing relative rise between 1950 and 2000.

![Capture6](E:\UM academy\stat 506\Capture6.PNG)

Use this subset by decades to calculate, Concrete Tiles roof saw the largest relative rise.



#### Problem3

The corresponding file and websites are **ProblemSet1_3.do** , **AUX_D.XPT**, **DEMO_D.XPT** and https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Examination&CycleBeginYear=2005 and https://wwwn.cdc.gov/Nchs/Nhanes/Search/DataPage.aspx?Component=Demographics&CycleBeginYear=2005 .

a.

By using command option, I can drop unnecessary cases.



b.

Above all, I replace AUXU* with log(AUXU*), because when decibel increases by 10db, volume increases by 10 times.

Compare each frequency separately and only need to use the first test at each frequency.  Here is just an example.

![Capture4](E:\UM academy\stat 506\Capture4.PNG)

Use t test to examine it.

![Capture5](E:\UM academy\stat 506\Capture5.PNG)

Based on data, hearing loss due to age is common at each frequency because the two-sample t tests reject the null hypothesis: diff=0. Besides, neither ear is more prone to hearing loss.

For left and right ears:

![Graph1](E:\UM academy\stat 506\STATA8\Graph1.png)

For the left ear:

![GraphL](E:\UM academy\stat 506\STATA8\GraphL.png)

For the right ear:

![GraphR](E:\UM academy\stat 506\STATA8\GraphR.png)

There are no distinct differences between pictures, so I think left ear tests and right ear tests have the same results.

Furthermore, it can be verified by t test. For example, examine differences of left and right ear threshold by `group`, the null hypothesis cannot be rejected.



c.

For right ear, plot a graph about mean:

![Graphg](E:\UM academy\stat 506\STATA8\Graphg.png)

And plot a graph about all data:

![Graphg1](E:\UM academy\stat 506\STATA8\Graphg1.png)

Neither gender is more prone to age-related hearing loss.