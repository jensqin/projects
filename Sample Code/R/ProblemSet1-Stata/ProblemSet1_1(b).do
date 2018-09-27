*------------------------------------------------------------------------*
* Stats 506 FA 17
* Problem Set 1 - 1.(b) (ProblemSet1_1(b).do)
*
* This script uses crime data from:
* https://stats.idre.ucla.edu/stat/stata/dae/crime
* and illustrates the power (and simplicity) of Stata in robust regression.
* 
* The script follows instructions from:
* https://stats.idre.ucla.edu/stata/dae/robust-regression/
* 
* See also ProblemSet1.pdf for answers to questions.
*
* Author: Zhen Qin (qinzhen@umich.edu)
* Date:   Sep 21, 2017
*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*---------------*  
* Script Setup  *
*---------------*
version 15   				// Stata version used
log using PS1_1b.log, replace 	// Generate a log
*cd ~/stata506    	   		// Working directory
*display "$S_DATE"			// Print system dates
clear					// Start with a clean session

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-------------------*
* Robust Regression *
*-------------------*

/*Question:
Visit https://stats.idre.ucla.edu/other/dae/ and choose and any one Stata example 
to work through and document. The example I choose is robust regression*/

//A short introduction and details of the data are available on the website.

*-------------------------*
* Description of the data *
*-------------------------*

//Use the crime data set
use https://stats.idre.ucla.edu/stat/stata/dae/crime, clear
summarize crime poverty single

*----------------------------*
* Robust regression analysis *
*----------------------------*

//Begin by running an OLS regression and doing some diagnostics
regress crime poverty single

/*The lvr2plot is used to create a graph showing the leverage versus the squared 
residuals, and the mlabel option is used to label the points on the graph with 
the two-letter abbreviation for each state*/
lvr2plot, mlabel(state)

/*Let’s compute Cook’s D and display the observations that have relatively large 
values of Cook’s D*/
predict d1, cooksd
clist state crime poverty single d1 if d1>4/51, noobs

//Use the predict command, this time with the rstandard option
predict r1, rstandard

//Generate a new variable called absr1
gen absr1 = abs(r1)

//The gsort command is used to sort the data by descending order 
gsort -absr1
clist state absr1 in 1/10, noobs

//Save the final weights to a new variable which we call weight in the data set
rreg crime poverty single, gen(weight)

//Observation for DC has been dropped since its Cook’s D is greater than 1
clist state weight if state =="dc", noobs

//Other observations with relatively small weight
sort weight
clist sid state weight absr1 d1 in 1/10, noobs

/*visualize the relationship by graphing the data points with the weight 
information as the size of circles*/
twoway  (scatter crime single [weight=weight], msymbol(oh)) if state !="dc"

/*Get the predicted values with respect to a set of values of variable single 
holding poverty at its mean*/
margins, at(single=(8(2)22)) vsquish

clear

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Script Cleanup  *
*-----------------*
log close
*------------------------------------------------------------------------*

