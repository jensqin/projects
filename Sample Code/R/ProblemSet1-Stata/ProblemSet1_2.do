*------------------------------------------------------------------------*
* Stats 506 FA 17
* Problem Set 1 - 2 (ProblemSet1_2.do)
*
* This script uses RECS data from:
* http://www.eia.gov/consumption/residential/data/2009/csv/recs2009_public.csv
* and illustrates the power (and simplicity) of Stata in Data Management.
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
log using PS1_2.log, replace 	// Generate a log
*cd ~/stata506    	   		// Working directory
*display "$S_DATE"			// Print system dates
clear					// Start with a clean session

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Data Management *
*-----------------*

/*Question:
a.Which state has the highest proportion of wood shingle roofs? Which state(s) 
the lowest?
b.Compute the proportion of each roof type for all houses constructed in each 
decade. Which roof type saw the largest relative rise in use between 1950 and 
2000?*/

*------------*
* Question A *
*------------*

//Use RECS data
insheet using https://www.eia.gov/consumption/residential/data/2009/csv/recs2009_public.csv, comma

//Label variables
label variable rooftype "Rooftype"
label variable reportable~n "State"


//Create distribution table
tabulate reportable~n rooftype if rooftype == 2
//The answer 1 is California, the answer 2 is Tennessee

*------------*
* Question B *
*------------*

//Label variable
label variable yearmaderange "Year Constructed"

//Create new variable decades
gen decades = yearmaderange
replace decades = 7 if yearmaderange == 8   //Calculate roofs in 2000s

//Label variable
label variable decades "Decade Built"
label variable occupyyrange "Decade Occupied"

//Show the joint frequencies of two variables
tabulate decades rooftype, row

//Show the joint frequencies of two variables
tabulate rooftype occupyyrange, row
/*Ceramic or Clay Tiles and Concrete Tiles roof saw the largest relative rise 
because there were no such roofs in use before 1950*/

clear

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Script Cleanup  *
*-----------------*
log close
*------------------------------------------------------------------------*
