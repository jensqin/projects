*------------------------------------------------------------------------*
* Stats 506 FA 17
* Problem Set 1 - 1.(c) (ProblemSet1_1(c).do)
*
* This script illustrates the power (and simplicity) of Stata in one-sample 
* t-test.
* 
* The script follows instructions from:
* https://stats.idre.ucla.edu/stata/dae/power-analysis-for-one-sample-t-test/
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
log using PS1_1c.log, replace 	// Generate a log
*cd ~/stata506    	   		// Working directory
*display "$S_DATE"			// Print system dates
clear					// Start with a clean session

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-------------------*
* One-Sample T-test *
*-------------------*

/*Question:
Visit https://stats.idre.ucla.edu/other/dae/ and choose and any one Stata example 
to work through and document. The example I choose is one-sample t-test*/

//A short introduction and details of the data are available on the website.

*----------------*
* Power Analysis *
*----------------*

//Use Stata’s sampsi command for our calculation as shown below
//Specify the two means, standard deviation and the power
sampsi 850 810, sd(50) power(.9) onesamp

//Calculate it when supposing we have a sample of size 10
sampsi 850 810, sd(50) n(10) onesamp

//Calculate it when supposing we have a sample of size 15
sampsi 850 810, sd(50)  n(15) onesamp

//Calculate it when supposing we have a sample of size 20
sampsi 850 810, sd(50)  n(20) onesamp

//Specified a lower power
sampsi 850 810, sd(50) power(.8) onesamp

//Specified a lower power and a standard deviation
sampsi 850 810, sd(30) power(.8) onesamp

*------------*
* Discussion *
*------------*

//What really matters is the difference of the means over the standard deviation
sampsi 50 10, sd(50) power(.9) onesamp

//Standardize our variable
sampsi 1 .2, sd(1) power(.9) onesamp

/*We make our best guess based upon the existing literature or a pilot study. 
A good estimate of the effect size is the key to a successful power analysis*/

clear

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Script Cleanup  *
*-----------------*
log close
*------------------------------------------------------------------------*
