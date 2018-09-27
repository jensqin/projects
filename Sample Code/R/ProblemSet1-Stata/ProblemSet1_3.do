*------------------------------------------------------------------------*
* Stats 506 FA 17
* Problem Set 1 - 3 (ProblemSet1_3.do)
*
* This script uses Audiometry data from AUX_D.DTA and DEMO_D.DTA
* They are transfered by Stat\Transfer on scs server.
* Original files are from:
* https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Examination&
* CycleBeginYear=2005 and https://wwwn.cdc.gov/Nchs/Nhanes/Search/DataPage.aspx?
* Component=Demographics&CycleBeginYear=2005
* The script illustrates the power (and simplicity) of Stata in Data Management.
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
log using PS1_3.log, replace 	// Generate a log
*cd ~/stata506    	   		// Working directory
*display "$S_DATE"			// Print system dates
clear					// Start with a clean session

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Data Management *
*-----------------*

/*Question:
a.Download the Audiometry data (AUX_D) from here and the demographics file 
(DEMO_D) from here. Determine how to load them into Stata and then merge on the 
common identifier seqn. Drop all cases without audiometry data.
b.Read the information under the headings ‘Eligible Sample’ and ‘Protocol and 
Procedure’ in the doc file for the audiometry data at the first link above. For 
each hearing threshold test, compare the old and young sub-populations stratified 
by left and right ear. You may compare each frequency separately and only need 
to use the first test at each frequency. Based on these data, is hearing loss due 
to age more common at particular frequencies? Is either left or right ear more 
prone to hearing loss? Produce a nicely formatted table or graph to justify your 
answer.
c.For this question you should consider only the right (not left) ear and can 
again analyze each frequency separately. Is either gender more prone to age-related 
hearing loss?
*/

*------------*
* Question A *
*------------*

//Use Audiometry data
use AUX_D.DTA

/*One-to-one merge on the common identifier seqn. Keep only matched observations 
and unmatched master observations after merging.*/
merge 1:1 seqn using DEMO_D, keep(match)

*------------*
* Question B *
*------------*

//Generate variable, 0 if younger than 20, 1 if older than 69 
gen group = 0
replace group = 1 if ridageyr > 69

//Label variable
label variable group "Group by Age"

//Compare between groups
sort group
foreach var of varlist AUXU1K1R AUXU1K1L AUXU500R AUXU500L AUXU2KR AUXU2KL AUXU3KR AUXU3KL AUXU4KR AUXU4KL AUXU6KR AUXU6KL AUXU8KR AUXU8KL{
by group: summarize `var'
}

*------------*
* Question C *
*------------*

//Male if riagendr == 1, female if riagendr == 2
//For left ear
sort riagendr
foreach var of varlist AUXU1K1L AUXU500L AUXU2KL AUXU3KL AUXU4KL AUXU6KL AUXU8KL{
by riagendr: summarize `var'
}

clear

*------------------------------------------------------------------------*


*------------------------------------------------------------------------*
*-----------------*
* Script Cleanup  *
*-----------------*
log close
*------------------------------------------------------------------------*
