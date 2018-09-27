*------------------------------------------------------------------------*
* Stats 506 FA 17
* Problem Set 1 - 1.(a) (ProblemSet1_1(a).do)
*
* This script uses family income data from:
* https://stats.idre.ucla.edu/stat/stata/modules/faminc
* kids data from:
* https://stats.idre.ucla.edu/stat/stata/modules/kidshtwt
* wide dadmom data from:
* https://stats.idre.ucla.edu/stat/stata/modules/dadmomw
* long dadmom data from:
* https://jbhender.github.io/Stats506/dadmomlong.dta
* and illustrates the power (and simplicity) of Stata in its ability to reshape 
* data files. 
* 
* The script follows instructions from:
* https://stats.idre.ucla.edu/stata/modules/
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
log using PS1_1a.log, replace 	// Generate a log
*cd ~/stata506    	   		// Working directory
*display "$S_DATE"			// Print system dates
clear					// Start with a clean session

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------------------------------------*
* Converting between long and wide data formats *
*-----------------------------------------------*

/*Question:
First, read http://www.theanalysisfactor.com/wide-and-long-data/ about wide vs 
long format data. Visit this page https://stats.idre.ucla.edu/stata/modules/ 
and find the links ‘Reshaping Data from Wide to Long’ and ‘Reshaping Data from 
Long to Wide’. Work through the examples and write a script (.do) documenting 
your work. Use comments to clearly organize the script into parts and provide 
brief explanations about what each reshape call is accomplishing.*/

*-----------------------------*
* Reshaping data wide to long *
*-----------------------------*

/*The general syntax of reshape long can be expressed as…

reshape long stem-of-wide-vars, i(wide-id-var)  j(var-for-suffix)

where

stem-of-wide-vars  is the stem of the wide variables, e.g., faminc
wide-id-var        is the variable that uniquely identifies wide 
                   observations, e.g., famid
var-for-suffix     is the variable that will contain the suffix of 
                   the wide variables, e.g., year*/

*-----------------------------------------*
* Example #1: Reshaping data wide to long *
*-----------------------------------------*

//Use family income data and show the data
use https://stats.idre.ucla.edu/stat/stata/modules/faminc, clear
list
//It is a wide format

//Reshape data to long, where each year of data is in a separate observation 
reshape long faminc, i(famid) j(year)
//long tells reshape that we want to go from wide to long
/*faminc tells Stata that the stem of the variable to be converted from wide to 
long is faminc*/
/*i(famid) option tells reshape that famid is the unique identifier for records 
in their wide format*/
/*j(year) tells reshape that the suffix of faminc (i.e., 96 97 98) should be 
placed in a variable called year*/
list
//It is a long format
//Each year is represented as its own observation

//The reshape wide command puts the data back into wide format
reshape wide
list

//The reshape long command puts the data back into long format
reshape long
list

*-----------------------------------------*
* Example #2: Reshaping data wide to long *
*-----------------------------------------*

//Use kids data and show the data
/*The file contains the kids and their heights at 1 year of age (ht1) and at 2 
years of age (ht2)*/
use https://stats.idre.ucla.edu/stat/stata/modules/kidshtwt, clear
list famid birth ht1 ht2
//It is a wide format

//Reshape data to long
reshape long ht, i(famid birth) j(age)
//long tells reshape that we want to from wide to long
/*ht tells Stata that the stem of the variable to be converted from wide to 
long is ht*/
/*i(famid birth) option tells reshape that famid birth is the unique identifier 
for records in their wide format*/
/*j(age) tells reshape that the suffix of ht (i.e., 1 2) should be 
placed in a variable called age*/
list famid birth age ht
//It is a long format

*-----------------------------------------*
* Example #3: Reshaping data wide to long *
*-----------------------------------------*

//Use kids data and show the data
/*The file with the kids heights at age 1 and age 2 also contains their weights 
at age 1 and age 2 (called wt1 and wt2)*/
use https://stats.idre.ucla.edu/stat/stata/modules/kidshtwt, clear 
list famid birth ht1 ht2 wt1 wt2
//It is a wide format

//Reshape data to long
reshape long ht wt, i(famid birth) j(age)
//long tells reshape that we want to from wide to long
/*ht wt tell Stata that the stem of the variables to be converted from wide to 
long are ht wt*/
/*i(famid birth) option tells reshape that famid birth is the unique identifier 
for records in their wide format*/
/*j(age) tells reshape that the suffix of ht (i.e., 1 2) should be 
placed in a variable called age*/
list famid birth age ht wt
//It is a long format

*-----------------------------------------------------------------*
* Example #4: Reshaping data wide to long with character suffixes *
*-----------------------------------------------------------------*

//Use dadmom data and show the data
use https://stats.idre.ucla.edu/stat/stata/modules/dadmomw, clear 
list
//It is a wide format

//Reshape data to long
reshape long name  inc, i(famid) j(dadmom) string
//long tells reshape that we want to go from wide to long
/*name inc tell Stata that the stem of the variables to be converted from wide 
to long are name inc*/
/*i(famid) option tells reshape that famid is the unique identifier for records 
in their wide format*/
/*j(dadmom) tells reshape that the suffix of name inc should be placed in a 
variable called dadmon, which is a charater*/
list 
//It is a long format

*-----------------------------*
* Reshaping data long to wide *
*-----------------------------*

/*The general syntax of reshape wide can be expressed as:

reshape wide long-var(s),  i( wide-id-var ) j( var-with-suffix ) 
where
long-var(s)      is the name of the long variable(s) to be made wide e.g. age
wide-id-var      is the variable that uniquely identifies wide 
                 observations, e.g. famid
var-with-suffix  is the variable from the long file that contains 
                 the suffix for the wide variables, e.g. birth*/
				 
*-----------------------------------------*
* Example #1: Reshaping data long to wide *
*-----------------------------------------*

//Use kids data and show the data 
//From the kids file, drop the variables kidname, sex and wt)
use https://stats.idre.ucla.edu/stat/stata/modules/kids, clear 
drop  kidname sex wt 
list
//It is a long format

//Reshape data to wide
reshape wide age, i(famid)  j(birth)
//wide tells reshape that we want to go from long to wide
//age tells Stata that the variable to be converted from long to wide is age
/*i(famid) tells reshape that famid uniquely identifies observations in the 
wide form*/
/*j(birth) tells reshape that the suffix of age (1 2 3) should be taken from 
the variable birth*/
list
//It is a wide format

*---------------------------------------------------------------------*
* Example #2: Reshaping data long to wide with more than one variable *
*---------------------------------------------------------------------*

//Use kids data and show the data
use https://stats.idre.ucla.edu/stat/stata/modules/kids, clear 
list
//It is a long format

//Reshape data to wide
reshape wide kidname age wt sex, i(famid) j(birth)
//wide tells reshape that we want to go from long to wide
/*kidname age wt sex tell Stata that the variables to be converted from long to 
wide are kidname age wt sex*/
/*i(famid) tells reshape that famid uniquely identifies observations in the 
wide form*/
/*j(birth) tells reshape that the suffix of age (1 2 3) should be taken from 
the variable birth*/
list
//It is a wide format

*----------------------------------------------------*
* Example #3: Reshaping wide with character suffixes *
*----------------------------------------------------*

//Use dadmom data and show the data
use https://jbhender.github.io/Stats506/dadmomlong.dta, clear 
list
//It is a long format

//Reshape data to wide
reshape wide name inc,  i(famid) j(dadmom) string
//wide tells reshape that we want to go from long to wide
/*name inc tell Stata that the stem of the variables to be converted from long 
to wide are name inc*/
/*i(famid) option tells reshape that famid is the unique identifier for records 
in their wide format*/
/*j(dadmom) tells reshape that the suffix of name inc should be placed in a 
variable called dadmon, which is a charater*/
list
//It is a wide format

clear

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Script Cleanup  *
*-----------------*
log close
*------------------------------------------------------------------------*
