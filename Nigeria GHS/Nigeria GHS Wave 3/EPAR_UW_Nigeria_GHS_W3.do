
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: Agricultural Development Indicators for the LSMS-ISA, Nigeria General Household Survey (GHS) LSMS-ISA Wave 3 (2015-16)

*Author(s)		: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu

*Date			: March 31st, 2025
*Dataset version: NGA_2015_GHSP-W3_v02_M_Stata
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Nigeria General Household Survey was collected by the Nigeria National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period  September - October 2015, November - December 2015, and February - April 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2734

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Nigeria General Household Survey .


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Nigeria General Household Survey (NG LSMS) data set.
*Using data files from within the "Nigeria GHSP - LSMS-ISA - Wave 3 (2015-16)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "\Nigeria GHSP - LSMS-ISA - Wave 3 (2015-16)\Nigeria_GHS_W3_created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Nigeria GHSP - LSMS-ISA - Wave 3 (2015-16)" within the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Nigeria_GHS_W3_summary_stats.xlsx" in the "Nigeria GHSP - LSMS-ISA - Wave 3 (2015-16)" within the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".


/*

*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Nigeria_GHS_W3_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Nigeria_GHS_W3_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Nigeria_GHS_W3_field_plot_variables.dta
*SUMMARY STATISTICS					Nigeria_GHS_W3_summary_stats.xlsx

*/


clear
clear matrix
clear mata
program drop _all
set more off
set maxvar 10000


*Set location of raw data and output
global directory			"../.." //Update this to match the path to your local repo
global Nigeria_GHS_W3_raw_data 			"$directory/Nigeria GHS/Nigeria GHS Wave 3/Raw DTA files/"
global Nigeria_GHS_W3_created_data 		"$directory/Nigeria GHS/Nigeria GHS Wave 3/Final DTA files/created_data"
global Nigeria_GHS_W3_final_data  		"$directory/Nigeria GHS/Nigeria GHS Wave 3/Final DTA files/final_data"
global summary_stats 					"$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do"

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD
********************************************************************************
global Nigeria_GHS_W3_exchange_rate 401.15  		// https://www.bloomberg.com/quote/USDETB:CUR, https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2023&locations=NG&start=2011
// {2017:315,2021:401.15}
global Nigeria_GHS_W3_gdp_ppp_dollar 146.72		// https://data.worldbank.org/indicator/PA.NUS.PRVT //2021
global Nigeria_GHS_W3_cons_ppp_dollar 155.72		// https://data.worldbank.org/indicator/PA.NUS.PRVT.P //2021
global Nigeria_GHS_W3_inflation 0.519052 //2017: 183.9/214.2, 2021: 183.9/354.3 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2024&locations=NG&start=2008

global Nigeria_GHS_W3_poverty_190 ((1.90*83.58) * (183.9/110.8)) //2016 val / 2011 val, updated to 83.58 on 6/1
global Nigeria_GHS_W3_poverty_npl (361 * (183.9/267.5)) //361 in 2019
global Nigeria_GHS_W3_poverty_215 (2.15*(0.858196 * 112.0983276))  //New 2023 WB poverty threshold														
global Nigeria_GHS_W3_poverty_300 (3*($Nigeria_GHS_W3_inflation * $Nigeria_GHS_W3_cons_ppp_dollar ))							   

 

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables



*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Nigeria_GHS_W3_pop_tot 183995785
global Nigeria_GHS_W3_pop_rur 95975881
global Nigeria_GHS_W3_pop_urb 88019904


********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "maize rice sorgum millet cowpea grdnt yam swtptt cassav banana cocoa soy" //no wheat or beans		//DMC changing mill to millet to be consistent across instruments
global topcrop_area "1080 1110 1070 1100 1010 1060 1120 2181 1020 2030 3040 2220"
global comma_topcrop_area "1080, 1110, 1070, 1100, 1010, 1060, 1120, 2181, 1020, 2030, 3040, 2220"
global topcropname_area_full "maize rice sorghum millet cowpea grdnt yam swtptt cassav banana cocoa soy"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
set obs $nb_topcrops 
egen rnum = seq(), f(1) t($nb_topcrops)
gen crop_code = .
gen crop_name = ""
forvalues k=1(1)$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area 
	replace crop_code = `c' if rnum==`k'
	replace crop_name = "`cn'" if rnum==`k'
}
drop rnum
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropname_table.dta", replace //This gets used to generate the monocrop files.



********************************************************************************
* HOUSEHOLD IDS *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/HHTrack.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W3_raw_data}/sectaa_plantingw3.dta"
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave3 rural
ren wt_wave3 weight
drop if weight==. //Non-surveyed households
recast double weight
save  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", replace

********************************************************************************
* WEIGHTS *
********************************************************************************
/* //ALT: Redundant 
use "${Nigeria_GHS_W3_raw_data}/HHTrack.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W3_raw_data}/sectaa_plantingw3.dta"
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave3 rural
ren wt_wave3 weight
recast double weight
save  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", replace
*/

********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect1_plantingw3.dta", clear
gen season="plan"
append using "${Nigeria_GHS_W3_raw_data}/sect1_harvestw3.dta"
replace season="harv" if season==""
*keep if s1q4==1 //Drop individuals who've left household   // AYW_3.5.20 This question wasn't asked of all individuals. 
gen member = s1q4
replace member = 1 if s1q3 != . 
drop if member!=1
gen female= s1q2==2
gen fhh = s1q3==1 & female
recode fhh (.=0)
preserve 
collapse (max) fhh, by(hhid)
tempfile fhh
save `fhh'
restore 
la var female "1= individual is female"
ren s1q6 age
la var age "Individual age"
keep hhid indiv female age season
ren female female_
ren age age_ 
reshape wide female_ age_, i(hhid indiv) j(season) string
gen age = age_plan 
replace age=age_harv if age==.
gen female=female_plan 
replace female=female_harv if female==.
drop *harv *plan
merge m:1 hhid using `fhh', nogen
merge m:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", keep(2 3) nogen  // keeping hh surveyed
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", replace


********************************************************************************
* HOUSEHOLD SIZE *
********************************************************************************
/*
use "${Nigeria_GHS_W3_raw_data}/PTrack.dta", clear
gen hh_members = 1
ren sex gender
gen fhh = (relat_w3v1==1 | relat_w3v2==1) & gender==2

collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhsize.dta", replace
*/

*Initial individidual not longer in the hh were counted as hh members though they have moved away
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", clear
gen member=1
collapse (max) fhh (sum) hh_members=member, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
*DYA.11.1.2020 Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", nogen
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Nigeria_GHS_W3_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Nigeria_GHS_W3_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Nigeria_GHS_W3_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", replace
*end hh_member correction
//use "${Nigeria_GHS_W3_raw_data}/sect1_harvestw3.dta", clear
 
 
********************************************************************************
* PLOT AREAS *
********************************************************************************
*starting with planting
clear
//ALT 06.03.21: I think it'd be easier if we just built a file for area conversions.

*using conversion factors from LSMS-ISA Nigeria Wave 2 Basic Information Document (Wave 3 unavailable, but Waves 1 & 2 are identical) 
*found at http://econ.worldbank.org/WBSITE/EXTERNAL/EXTDEC/EXTRESEARCH/EXTLSMS/0,,contentMDK:23635560~pagePK:64168445~piPK:64168309~theSitePK:3358997,00.html
*General Conversion Factors to Hectares
//		Zone   Unit         Conversion Factor
//		All    Plots        0.0667
//		All    Acres        0.4
//		All    Hectares     1
//		All    Sq Meters    0.0001

*Zone Specific Conversion Factors to Hectares
//		Zone           Conversion Factor
//				 Heaps      Ridges      Stands
//		1 		 0.00012 	0.0027 		0.00006
//		2 		 0.00016 	0.004 		0.00016
//		3 		 0.00011 	0.00494 	0.00004
//		4 		 0.00019 	0.0023 		0.00004
//		5 		 0.00021 	0.0023 		0.00013
//		6  		 0.00012 	0.00001 	0.00041

set obs 42 //6 zones x 7 units
egen zone=seq(), f(1) t(6) b(7)
egen area_unit=seq(), f(1) t(7)
gen conversion=1 if area_unit==6
gen area_size=1 //This makes it easy for me to copy-paste existing code rather than having to write a new block
replace conversion = area_size*0.0667 if area_unit==4									//reported in plots
replace conversion = area_size*0.404686 if area_unit==5		    						//reported in acres
replace conversion = area_size*0.0001 if area_unit==7									//reported in square meters

replace conversion = area_size*0.00012 if area_unit==1 & zone==1						//reported in heaps
replace conversion = area_size*0.00016 if area_unit==1 & zone==2
replace conversion = area_size*0.00011 if area_unit==1 & zone==3
replace conversion = area_size*0.00019 if area_unit==1 & zone==4
replace conversion = area_size*0.00021 if area_unit==1 & zone==5
replace conversion = area_size*0.00012 if area_unit==1 & zone==6

replace conversion = area_size*0.0027 if area_unit==2 & zone==1							//reported in ridges
replace conversion = area_size*0.004 if area_unit==2 & zone==2
replace conversion = area_size*0.00494 if area_unit==2 & zone==3
replace conversion = area_size*0.0023 if area_unit==2 & zone==4
replace conversion = area_size*0.0023 if area_unit==2 & zone==5
replace conversion = area_size*0.00001 if area_unit==2 & zone==6

replace conversion = area_size*0.00006 if area_unit==3 & zone==1						//reported in stands
replace conversion = area_size*0.00016 if area_unit==3 & zone==2
replace conversion = area_size*0.00004 if area_unit==3 & zone==3
replace conversion = area_size*0.00004 if area_unit==3 & zone==4
replace conversion = area_size*0.00013 if area_unit==3 & zone==5
replace conversion = area_size*0.00041 if area_unit==3 & zone==6

drop area_size
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_landcf.dta", replace

use "${Nigeria_GHS_W3_raw_data}/sect11a1_plantingw3", clear
*merging in planting section to get cultivated status
merge 1:1 hhid plotid using "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3", nogen
*merging in harvest section to get areas for new plots
merge 1:1 hhid plotid using "${Nigeria_GHS_W3_raw_data}/secta1_harvestw3.dta", gen(plot_merge)
ren s11aq4a area_size
ren s11aq4b area_unit
ren sa1q9a area_size2
ren sa1q9b area_unit2
ren s11aq4c area_meas_sqm
ren sa1q9c area_meas_sqm2
gen cultivate = s11b1q27 ==1 
recode area_size area_size2 area_meas_sqm area_meas_sqm2 (0=.)

*assuming new plots are cultivated
replace cultivate = 1 if sa1q3==1
merge m:1 zone area_unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_landcf.dta", nogen keep(1 3) //Should be no unmatched values.
*farmer reported field size for post-planting
gen field_size= area_size*conversion
drop area_unit conversion
*farmer reported field size for post-harvest added fields
ren area_unit2 area_unit
merge m:1 zone area_unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_landcf.dta", nogen keep(1 3)
replace field_size= area_size2*conversion if field_size==.
*replacing farmer reported with GPS if available
replace field_size = area_meas_sqm*0.0001 if area_meas_sqm!=.       
replace field_size = area_meas_sqm2*0.0001 if area_meas_sqm2!=.         				
gen gps_meas = (area_meas_sqm!=. | area_meas_sqm2!=.)
la var gps_meas "Plot was measured with GPS, 1=Yes"
la var field_size "Area of plot (ha)"
ren plotid plot_id
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", replace


********************************************************************************
* PLOT DECISION MAKERS *
********************************************************************************
/*
*Creating gender variables for plot manager from post-planting
use "${Nigeria_GHS_W3_raw_data}/sect1_plantingw3.dta", clear
gen female = s1q2==2 if s1q2!=.
gen age = s1q6
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop hhid indiv, force
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_gender_merge_temp.dta", replace

*adding in gender variables for plot manager from post-harvest
use "${Nigeria_GHS_W3_raw_data}/sect1_harvestw3.dta", clear
gen female = s1q2==2 if s1q2!=.
gen age = s1q4
duplicates drop hhid indiv, force
merge 1:1 hhid indiv using "$Nigeria_GHS_W3_created_data/Nigeria_GHS_W3_gender_merge_temp.dta", nogen 		
keep hhid indiv female age
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_gender_merge.dta", replace
*/
*Using planting data 	
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", clear 	
gen indiv1=s11aq6a
gen indiv2=s11aq6b 
gen indiv3=sa1q11
gen indiv4=sa1q11b
replace indiv1=indiv3 if indiv1==.
keep hhid plot_id indiv* 
reshape long indiv, i(hhid plot_id) j(id_no)
drop if indiv==.
merge m:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", keep(1 3) nogen keepusing(female)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_dm_ids.dta", replace
gen dm1_gender=female+1 if id_no==1
gen dm1_id = indiv if id_no==1
collapse (mean) female (firstnm) dm1_gender dm1_id, by(hhid plot_id)
gen dm_gender = 3
replace dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
*replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(1  3) keepusing (fhh)
replace dm_gender=1 if fhh ==0 & dm_gender==. 
replace dm_gender=2 if fhh ==1 & dm_gender==. 
gen dm_male = dm_gender==1
gen dm_female = dm_gender==2
gen dm_mixed = dm_gender==3
keep plot_id hhid dm* 
la var dm_gender "Gender category of all plot decisionmakers"
//la var dm_primary "Individual ID of main decisionmaker"
la var dm1_gender "Gender of main decisionmaker"
la def genderlab 1 "Male" 2 "Female" 3 "Mixed"
la val dm_gender genderlab
la val dm1_gender genderlab
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_decision_makers", replace


********************************************************************************
*Formalized Land Rights*
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta", clear
*DYA.11.21.2020  we need to recode . to 0 or exclude them as . as treated as very large numbers in Stata
*recode s11b1q8 (.=0)
gen formal_land_rights = 1 if (s11b1q8>=1 & s11b1q8!=.)	| (s11b1q10a>=1 & s11b1q10a!=.)  | (s11b1q10b>=1 & s11b1q10b!=.) | (s11b1q10c>=1 & s11b1q10c!=.) | (s11b1q10d>=1 & s11b1q10d!=.)						
*Individual level (for women)
*Starting with first owner
preserve
ren s11b1q8b1 indiv
merge m:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen keep(3)		
keep hhid indiv female formal_land_rights
tempfile p1
save `p1', replace
restore
*Now second owner
preserve
ren s11b1q8b2 indiv		
merge m:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen keep(3)		
keep hhid indiv female
tempfile p2
save `p2', replace
restore	
*Now third owner
preserve
ren s11b1q8b3 indiv		
merge m:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen keep(3)	
keep hhid indiv female
append using `p1'
append using `p2' 
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid indiv)		
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_rights_ind.dta", replace
restore	
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_rights_hh.dta", replace


********************************************************************************
*crop unit conversion factors
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/ag_conv_w3", clear
ren crop_cd crop_code
ren conv_NC_1 conv_fact1
ren conv_NE_2 conv_fact2
ren conv_NW_3 conv_fact3
ren conv_SE_4 conv_fact4
ren conv_SS_5 conv_fact5
ren conv_SW_6 conv_fact6
sort crop_code unit_cd conv_national
reshape long conv_fact, i(crop_code unit_cd conv_national) j(zone)
fillin crop_code unit_cd zone
	//bys unit_cd zone state: egen state_conv_unit = median(conv_fact) //We don't have state-level factors
	bys unit_cd zone: egen zone_conv_unit = median(conv_fact)
	bys unit_cd: egen national_conv = median(conv_fact)	
	replace conv_fact = zone_conv_unit if conv_fact==. & unit_cd!=900		
	replace conv_fact = national_conv if conv_fact==. & unit_cd!=900
	replace conv_fact = 1958 if unit_cd==180 //Pickups, using the local weights and measures handbook cited in wave 4
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", replace


********************************************************************************
*ALL PLOTS
********************************************************************************
				
	***************************
	*Crop Values
	***************************
	//Nonstandard unit values (kg values in plot variables section)
use "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestw3.dta", clear
	keep if sa3iiq3==1
	ren sa3iiq5a qty
	ren sa3iiq5b unit_cd
	ren sa3iiq6 value
	keep zone state lga sector ea hhid cropcode qty unit_cd value
	merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keepusing(weight_pop_rururb)
	gen weight = weight_pop_rururb*qty
	ren cropcode crop_code
	gen price_unit = value/qty
	gen obs=price_unit!=.
	foreach i in zone state lga ea hhid {
		preserve
		collapse (median) price_unit_`i'=price_unit (rawsum) obs_`i'_price=obs [aw=weight], by (`i' unit_cd crop_code)
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	collapse (median) price_unit_country = price_unit (rawsum) obs_country_price=obs [aw=weight], by(crop_code unit_cd)
	tempfile price_unit_country_median
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_prices_median_country.dta", replace
	//Unfortunately, only a small number of obs for shelled/unshelled (the ***1 ***2 etc cropcodes) Not entirely clear what the *0's represent (probably shelled?)
	//ALT 05.09.23: Bringing this over from the other file 
	use "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestW3.dta", clear
	keep if sa3iiq3==1
	ren sa3iiq5a qty
	ren sa3iiq5b unit_cd
	ren sa3iiq6 value
	keep zone state lga sector ea hhid cropcode qty unit_cd value
	ren cropcode crop_code
	merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keepusing(weight_pop_rururb) keep(1 3)
	merge m:1 crop_code unit_cd zone using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", nogen keep(1 3)
	//ren cropcode crop_code
	gen qty_kg = qty*conv_fact 
	drop if qty_kg==. //34 dropped; largely basin and bowl.
	gen price_kg = value/qty_kg
	gen obs=price_kg !=.
	keep if obs == 1
	replace weight = qty_kg*weight_pop_rururb
	foreach i in zone state lga ea hhid {
		preserve
		collapse (median) price_kg_`i'=price_kg (rawsum) obs_`i'_pkg=obs [aw=weight], by (`i' crop_code)
		tempfile price_kg_`i'_median
		save `price_kg_`i'_median'
		restore
	}
	collapse (median) price_kg_country = price_kg (rawsum) obs_country_pkg=obs [aw=weight], by(crop_code)
	tempfile price_kg_country_median
	save `price_kg_country_median'

	
	
	***************************
	*Plot variables
	***************************	
	//issue with incorrect ea id for two households here.
use	"${Nigeria_GHS_W3_raw_data}/secta3i_harvestw3.dta", clear
drop zone state lga ea 
tempfile harvest_vars
save `harvest_vars'

use "${Nigeria_GHS_W3_raw_data}/sect11e_plantingw3.dta", clear
gen use_imprv_seed=s11eq3b==1 |  s11eq3b==2
gen use_hybrid_seed=s11eq3b==1
ren plotid plot_id
ren cropcode crop_code
//Crop recode
recode crop_code (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) /*Counting this generically as pumpkin, but it is different commodities
	*/				 (3181 3182 3183 3184 = 3180) (2170=2030) (3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) (1121 1122 1123=1120)
collapse (max) use_imprv_seed use_hybrid_seed, by(hhid plot_id crop_code)
tempfile imprv_seed
save `imprv_seed'

use "${Nigeria_GHS_W3_raw_data}/sect11f_plantingw3.dta", clear
drop zone state lga ea
	ren cropcode crop_code_11f
	merge 1:1 hhid plotid /*cropcode*/ cropid using `harvest_vars'
	merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", nogen keepusing(zone state lga ea) keep(3)
	ren plotid plot_id
	//sort hhid plot_id
	//bys hhid : gen plot_id2 = _n
	ren s11fq5 number_trees_planted
	//merge m:1 plot_id hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas", nogen keep(1 3)
	ren cropcode crop_code_a3i //i.e., if harvested units are different from planted units
	//Consolidating cropcodes
	replace crop_code_11f=crop_code_a3i if crop_code_11f==.
	//not necessary for Ethiopia - replace with crop_code 
	gen crop_code_master =crop_code_11f //Generic level
	ren crop_code_11f crop_code
	recode crop_code_master (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) /*Counting this generically as pumpkin, but it is different commodities
	*/				 (3181 3182 3183 3184 = 3180) (2170=2030) (3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) (1121 1122 1123=1120) //Cutting three-leaved yams from generic yam category because crop calendar is different.
	la values crop_code_master cropcode
	gen area_unit=s11fq1b
	replace area_unit=s11fq4b if area_unit==.
	merge m:1 zone area_unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_landcf.dta", nogen keep(1 3)
	gen ha_planted = s11fq1a*conversion
	replace ha_planted = s11fq4a*conversion if ha_planted==. & s11fq4a!=0 //Tree crops.A few obs reported in stands equal to the number of trees reported. The WB conversion for "stand" is probably for something different, because it results in very low converted hectares. Might distort yields for oil palm a little.
	
	recode ha_planted (0=.)
	drop conversion area_unit
	ren sa3iq5b area_unit
	merge m:1 zone area_unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_landcf.dta", nogen keep(1 3)
	gen ha_harvest = sa3iq5a*conversion
	merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", nogen keep(1 3) //keepusing(field_size)
	replace ha_harvest = field_size*sa3iq5c/100 if sa3iq5c!=. & sa3iq5c!=0  //Preferring percentage estimates over area estimates when we have both.
	replace ha_harvest = ha_planted if s11fq11a!=0 & s11fq11a!=. & ha_planted!=. 
	replace ha_planted = ha_harvest if ha_planted==. & ha_harvest!=. & ha_harvest!=0
	
	gen month_planted = s11fq3a+(s11fq3b-2014)*12
	gen month_harvested = sa3iq4a1 + (sa3iq4a2-2014)*12
	gen months_grown = month_harvested-month_planted if s11fc5==1 //Ignoring permanent crops that may be grown multiple seasons
	replace months_grown=. if months_grown < 1 | month_planted==. | month_harvested==.
	
	//ALT 05.09.2023: Plot workdays
	preserve
	gen days_grown = months_grown*30 
	collapse (max) days_grown, by(hhid plot_id)
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_season_length.dta", replace
	restore
	//ALT 05.09.23: END Update
/* To revisit
	preserve
		gen obs=1
		replace obs=0 if inrange(sa3iq4,1,5) & s11fc5==1
		collapse (sum) crops_plot=obs, by(hhid plot_id)
		tempfile ncrops 
		save `ncrops'
	restore //286 plots have >1 crop but list monocropping, 382 say intercropping; meanwhile 130 list intercropping or mixed cropping but only report one crop
	merge m:1 hhid plot_id using `ncrops', nogen

	gen lost_crop=inrange(sa3iq4,1,5) & s11fc5==1
	bys hhid plot_id : egen max_lost = max(lost_crop)
	gen replanted = (max_lost==1 & crops_plot>0)
		preserve 
		keep if replanted == 1 & lost_crop == 1 //we'll keep this for planting area, which might cause the plot to go over 100% planted 
		drop crop_code 
		ren crop_code_master crop_code
		keep zone state lga ea hhid crop_code plot_id ha_planted lost_crop
		tempfile lost_crops
		save `lost_crops'
	restore
	drop if replanted==1 & lost_crop==1 
	//95 plots did not replant; keeping and assuming yield is 0.
*/
	bys hhid plot_id : gen n_crops=_N
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. 
	gen percent_field=ha_planted/field_size
	gen pct_harv = ha_harvest/ha_planted //This will allow us to rescale harvests based on rescaled planted areas and catch issues where we only had area harvested reported and not percentage harvested. 
	replace pct_harv = 1 if ha_harv > ha_planted & ha_harv!=.
	replace pct_harv = 0 if pct_harv==. & sa3iq4 < 6
*Generating total percent of purestand and monocropped on a field
	bys hhid plot_id: egen tot_ha_planted = sum(ha_planted)
	replace field_size = tot_ha_planted if field_size==. //assuming crops are filling the plot when plot area is not known.
	replace percent_field = ha_planted/tot_ha_planted if tot_ha_planted >= field_size & n_crops > 1 //Adding the = to catch plots that were filled in previous line
	replace percent_field = 1 if tot_ha_planted>=field_size & n_crops==1
	replace ha_planted = percent_field*field_size if (tot_ha_planted > field_size) & field_size!=. & ha_planted!=.
	replace ha_harvest = pct_harv*ha_planted
	
	*renaming unit code for merge
	ren sa3iq6ii unit_cd 
	replace unit_cd = s11fq11b if unit_cd==.
	ren sa3iq6i quantity_harvested
	replace quantity_harvested = s11fq11a if quantity_harvested==.
	//we recoded plantains to bananas in the yield section - doing the same here
	//recode crop_code (2170=2030) - see above; we account for the plantain/banana stuff in the master crop_code variable
	*merging in conversion factors
	merge m:1 crop_code unit_cd zone using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", keep(1 3) gen(cf_merge) //1829 not matched, but only 304 have units. We should still see if we can fill in from W4.
	gen quant_harv_kg= quantity_harvested*conv_fact
	ren sa3iq6a val_harvest_est
	gen val_unit_est = val_harvest_est/quantity_harvested
	gen val_kg_est = val_harvest_est/quant_harv_kg
	merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(1 3)
	gen plotweight = ha_planted*weight_pop_rururb
	//IMPLAUSIBLE ENTRIES - at least 100x the typical yield
	//A lot of extremely high yields are relatively normal amounts from small numbers of fruit-bearing trees whose planted area estimates are likely too small; I leave those alone 
	//ALT note 09.29.22: some of these issues may result from flaws in area measurement/estimation rather than yield estimates.
	//10 sq m is 0.0001 ha; hard to see plantings occurring smaller than this 
	/* ALT 03.21.25 Alternative trimming now @ end of section.
	gen yield = quant_harv_kg/ha_planted
	foreach var in quantity_harvested quant_harv_kg val_harvest_est val_unit_est val_kg_est {
	replace `var' = . if (hhid == 18089 & plot_id == 2 & cropid==2) | /* 5 tons sorghum on 0.0000246 Ha. Plot  is 2500 sq m, so even if the whole plot was planted the yield would still be way high 
	*/ (hhid == 230067 & plot_id == 1 & cropid == 1) | /* 13 tons yam on 0.0024 ha
	*/ (hhid == 260040 & plot_id == 1 & cropid == 1) | /* 3500 sacks of yam on < 1 ha
	*/ (crop_code_11f==1080 & yield > 1e+6) //Many corn obs w/ million-plus per-ha yields. I think plot area is an issue here.
	}
	drop yield
	*/
	gen obs=quantity_harvested>0 & quantity_harvested!=.

foreach i in zone state lga ea hhid {
	merge m:1 `i' unit_cd crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code using `price_kg_`i'_median', nogen keep(1 3)
}

merge m:1 unit_cd crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `price_kg_country_median', nogen keep(1 3)

gen price_unit = price_unit_hh
gen price_kg = price_kg_hh

foreach i in country zone state lga ea {
	replace price_unit = price_unit_`i' if obs_`i'_price>9 & obs_`i'_price != .
	replace price_kg = price_kg_`i' if obs_`i'_pkg>9 & obs_`i'_pkg != .
}

	gen value_harvest = price_unit * quantity_harvested
	replace value_harvest=price_kg*quant_harv_kg if value_harvest==.
	gen value_harvest_hh=price_unit_hh * quantity_harvested
	replace value_harvest_hh=price_kg_hh*quant_harv_kg 
	replace value_harvest = val_harvest_est if value_harvest == . & val_harvest_est!=0 //Some zeroes for expected harvest crops														   
	replace val_unit = value_harvest/quantity_harvested if val_unit==.
preserve
	ren unit_cd unit
	collapse (mean) val_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_prices_for_wages.dta", replace
restore
	//still-to-harvest value, only for plots where some crop was harvested.
	gen same_unit=unit_cd==sa3iq6d2
	drop unit_cd quantity_harvested *conv* cf_merge
	ren sa3iq6d2 unit_cd
	ren sa3iq6d1 quantity_harvested
	merge m:1 crop_code unit_cd zone using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", nogen keep(1 3)
	gen quant_harv_kg2= quantity_harvested*conv_fact
	gen val_harv2 = 0
	gen val_harv2_hh=0
	recode quant_harv_kg2 quantity_harvested (.=0)
	replace val_harv2=quantity_harvested*price_unit if same_unit==1
	replace val_harv2_hh=quantity_harvested*price_unit_hh if same_unit==1
	replace val_harv2=quant_harv_kg2*price_kg if val_harv2==0
	replace val_harv2_hh=quant_harv_kg2*price_kg_hh if val_harv2_hh==0
	gen missing_unit =val_harv2 == 0		
	
	recode quant_harv* val*_harv* (.=0)
	replace quant_harv_kg = quant_harv_kg+quant_harv_kg2
	replace value_harvest = value_harvest+val_harv2	
	replace value_harvest_hh=value_harvest+val_harv2_hh
	gen lost_drought = sa3iq4==6 |  s11fq10==1 
	gen lost_flood = sa3iq4==5 |  s11fq10==2 
	gen lost_pest = sa3iq4==12 |  s11fq10==5 
	//Only affects 966 obs 
	drop val_harv2 quant_harv_kg2 val_* obs*
	
	gen no_harvest = sa3iq4 >= 6 & sa3iq4 <= 10
	ren crop_code crop_code_full //We drop this here and report everything as the consolidated crop group, but it could be retained here.
	ren crop_code_master crop_code 

	collapse (sum) quant_harv_kg value_harvest* ha_planted ha_harvest number_trees_planted percent_field (max) lost_pest lost_flood lost_drought no_harvest, by(zone state lga sector ea hhid plot_id crop_code field_size gps_meas)
	//no need for a collapse because there's no duplicates
	drop if (ha_planted==0 | ha_planted==.) & (ha_harv==0 | ha_harv==.) & (quant_harv_kg==0)
	replace ha_harvest=. if (ha_harvest==0 & no_harvest==1) | (ha_harvest==0 & quant_harv_kg>0 & quant_harv_kg!=.)
	replace value_harvest = . if value_harvest==0 & (no_harvest==1 | quant_harv_kg!=0)
	replace quant_harv_kg = . if quant_harv_kg==0 & no_harvest==1
	recode ha_planted (0=.)
	bys hhid plot_id : egen percent_area = sum(percent_field)
	bys hhid plot_id : gen percent_inputs = percent_field/percent_area
	bys hhid plot_id : gen purestand = _N 
	replace purestand=0 if purestand >1
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	//We remove small planted areas from the sample for yield, as these areas are likely undermeasured/underestimated and cause substantial outliers. The harvest quantities are retained for farm income and production estimates. 
	gen ha_harv_yld= ha_harvest if ha_planted >= 0.05
	gen ha_plan_yld= ha_planted if ha_planted >= 0.05
	merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm*)
	merge 1:1 hhid plot_id crop_code using `imprv_seed', nogen
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta",replace
//One suspicious obs of cassava - 560 tons on 1 ha, should probably be trimmed. 
/*
Monocrop plots are in their own section below
*/

********************************************************************************
* GROSS CROP REVENUE *
********************************************************************************
*Generating Value of crop sales
use "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestw3.dta", clear
ren cropcode crop_code 
ren sa3iiq6 sales_value
recode sales_value (.=0)
/*DYA*/ ren sa3iiq5a quantity_sold
/*DYA*/ ren sa3iiq5b unit_quantity_sold
/*DYA*/ ren sa3iiq5b_os unit_other_quantity_sold
*renaming unit code for merge 
ren unit_quantity_sold unit_cd
*merging in conversion factors
merge m:1 crop_code unit_cd zone using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", gen(cf_merge)
gen kgs_sold= quantity_sold*conv_fact
collapse (sum) sales_value kgs_sold, by (hhid crop_code)
lab var sales_value "Value of sales of this crop"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropsales_value.dta", replace 


use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear

collapse (sum) value_harvest , by (hhid crop_code) 
merge 1:1 hhid crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropsales_value.dta"
recode  value_harvest sales_value (.=0)
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
collapse (sum) value_harvest value_crop_sales, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production.dta", replace 
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
replace proportion_cropvalue_sold = . if proportion_cropvalue_sold > 1 // HKS 4/11/23: We should not have household reporting significantly more value crop sold than value crop produced/harvested; so for now, we are eliminating the proportions that are greater than 1 for AQP																																																																			   
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_production.dta", replace

/*In the all plots file
Generating value of crop production at plot level
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
collapse (sum) value_harvest, by (hhid plot_id)
ren value_harvest plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cropvalue.dta", replace
*/

*Crops lost post-harvest
use "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestw3.dta", clear
ren cropname crop_name
ren cropcode crop_code
ren sa3iiq18c share_lost
merge m:1 hhid crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production.dta", nogen keep(1 3)
recode share_lost (.=0)
gen crop_value_lost = value_crop_production * (share_lost/100)
collapse (sum) crop_value_lost, by (hhid)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_losses.dta", replace


********************************************************************************
* CROP EXPENSES *
********************************************************************************
/* Explanation of changes
This section has been formatted significantly differently from previous waves and the Tanzania template file (see also NGA W3 and TZA W3-5).
Previously, inconsistent nomenclature forced the complete enumeration of variables at each step, which led to accidental omissions messing with prices.
This section is designed to reduce the amount of code needed to compute expenses and ensure everything gets included. I accomplish this by 
taking advantage of Stata's "reshape" command to take a wide-formatted file and convert it to long (see help(reshape) for more info). The resulting file has 
additional columns for expense type ("input") and whether the expense should be categorized as implicit or explicit ("exp"). This allows simple file manipulation using
collapse rather than rowtotal and can easily be converted back into our standard "wide" format using reshape. 
*/
	*********************************
	* 			LABOR				*
	*********************************
	*Hired
use "${Nigeria_GHS_W3_raw_data}/sect11c1_plantingw3.dta", clear	
	ren plotid plot_id
	ren s11c1q2 numberhiredmale
	ren s11c1q5 numberhiredfemale
	ren s11c1q8 numberhiredchild
	ren s11c1q3 dayshiredmale
	ren s11c1q6 dayshiredfemale
	ren s11c1q9 dayshiredchild
	ren s11c1q4 wagehiredmale
	ren s11c1q7 wagehiredfemale
	ren s11c1q10 wagehiredchild
	keep hhid plot_id *hired*
	gen season="pp"
tempfile postplanting_hired
save `postplanting_hired'

use "${Nigeria_GHS_W3_raw_data}/secta2_harvestw3.dta", clear
	ren plotid plot_id
	ren sa2q1m_a crop_code
	ren sa2q1m_b qty
	ren sa2q1m_c unit

	ren sa2q1c numberhiredmale
	ren sa2q1d dayshiredmale
	ren sa2q1f numberhiredfemale
	ren sa2q1g dayshiredfemale
	ren sa2q1i numberhiredchild
	ren sa2q1j dayshiredchild
	ren sa2q1e wagehiredmale
	ren sa2q1h wagehiredfemale
	ren sa2q1k wagehiredchild
	
	keep hhid plot_id *hired* crop_code qty unit
	gen season = "mid"
tempfile mid_hired
save `mid_hired'

use "${Nigeria_GHS_W3_raw_data}/secta2_harvestw3.dta", clear
ren plotid plot_id
	ren sa2q11a crop_code
	ren sa2q11b qty
	ren sa2q11c unit
	ren sa2q2 numberhiredmale 
	ren sa2q3 dayshiredmale
	ren sa2q5 numberhiredfemale
	ren sa2q6 dayshiredfemale
	ren sa2q8 numberhiredchild
	ren sa2q9 dayshiredchild
	ren sa2q4 wagehiredmale //Wage per person/per day
	ren sa2q7 wagehiredfemale
	ren sa2q10 wagehiredchild
	keep hhid plot_id *hired* crop_code qty unit
	gen season="ph"
tempfile harvest_hired
save `harvest_hired'

use `postplanting_hired'
append using `mid_hired'
append using `harvest_hired'
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(3) keepusing(zone state lga ea)
preserve
	//Not including in-kind payments as part of wages b/c they are not disaggregated by worker gender (but including them as an explicit expense below)
	merge m:1 hhid crop_code unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_prices_for_wages.dta", nogen keep(1 3)
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep hhid val plot_id
	gen exp = "exp"
	merge m:1 plot_id hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments'
restore
	drop qty crop_code unit
reshape long numberhired dayshired wagehired /*inkindhired*/, i(zone state lga ea hhid plot_id season) j(gender) string
reshape long number days wage /*inkind*/, i(zone state lga ea hhid plot_id gender season) j(labor_type) string
	recode wage days number /*inkind*/ (.=0)
	drop if wage==0 & days==0 & number==0 /*& inkind==0*/
	replace wage = wage/number //ALT 08.16.21: The question is "How much did you pay in total per day to the hired <laborers>." For getting median wages for implicit values, we need the wage/person/day
	gen val = wage*days*number
	replace days = days*number //ALT 05.02.23

merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(1 3) keepusing(weight_pop_rururb)
merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
gen plotweight = weight*field_size
recode wage (0=.)
gen obs=wage!=.
*Median wages

foreach i in zone state lga ea hhid {
preserve
	if "`i'"=="ea" {
		drop if ea==0
	}
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i'=wage [aw=plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
}
preserve
collapse (median) wage_country = wage (sum) obs_country=obs [aw=plotweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore

drop obs plotweight wage 
tempfile all_hired
save `all_hired'

//Family labor
use "${Nigeria_GHS_W3_raw_data}/sect11c1_plantingw3.dta", clear
	drop s11c1q11 s11c1q12 //These mess with the filters
	ren plotid plot_id
	ren s11c1q1*1 indiv*
	ren s11c1q1*2 weeks_worked*
	ren s11c1q1*3 days_week*
keep hhid plot_id indiv* weeks_worked* days_week*
gen season="pp"
tempfile postplanting_family
save `postplanting_family'

use "${Nigeria_GHS_W3_raw_data}/secta2_harvestw3.dta", clear
	ren plotid plot_id
	ren sa2q1b_*1 indiv*
	ren sa2q1b_*2 weeks_worked*
	ren sa2q1b_*3 days_week*
preserve
keep hhid plot_id indiv* weeks_worked* days_week*
gen season="mid"
tempfile mid_family
save `mid_family'
restore
	drop indiv* weeks_worked* days_week*
	ren sa2q1*1 indiv*
	ren sa2q1*2 weeks_worked*
	ren sa2q1*3 days_week*
preserve
keep hhid plot_id indiv* weeks_worked* days_week*
gen season="ph"
tempfile harvest_family
save `harvest_family'
//exchange labor, note no planting data
restore
	drop indiv* weeks_worked* days_week*
	ren sa2q1n_a daysnonhiredmale
	ren sa2q1n_b daysnonhiredfemale
	ren sa2q1n_c daysnonhiredchild
preserve
	keep hhid plot_id days* 
	gen season="mid"
	tempfile mid_exchange
	save `mid_exchange'
restore
	drop days*
	//ALT 05.02.23 11 -> 12
	ren sa2q12a daysnonhiredmale
	ren sa2q12b daysnonhiredfemale
	ren sa2q12c daysnonhiredchild
	gen season="ph"
	append using `mid_exchange'
	reshape long daysnonhired, i(hhid plot_id season) j(gender) string
	reshape long days, i(hhid plot_id season gender) j(labor_type) string
tempfile all_exchange
save `all_exchange'

use `postplanting_family',clear
append using `mid_family'
append using `harvest_family'
reshape long indiv weeks_worked days_week, i(hhid plot_id season) j(colid) string
gen days=weeks_worked*days_week
drop if days==.
//ALT 05.09.23: rescaling fam labor to growing season duration
preserve
collapse (sum) days_rescale=days, by(hhid plot_id indiv)
merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_season_length.dta", nogen keep(1 3)
replace days_rescale = days_grown if days_rescale > days_grown
tempfile rescaled_days
save `rescaled_days'
restore
//Rescaling to season
bys hhid plot_id indiv : egen tot_days = sum(days)
gen days_prop = days/tot_days 
merge m:1 hhid plot_id indiv using `rescaled_days'
replace days = days_rescale * days_prop if tot_days > days_grown
//ALT end update. 
merge m:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen keep(1 3)
gen gender="child" if age<16
replace gender="male" if strmatch(gender,"") & female==0
replace gender="female" if strmatch(gender,"") & female==1
gen labor_type="family"
keep hhid plot_id season gender days labor_type
append using `all_exchange'
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", nogen keep(3) keepusing(zone state lga ea)
foreach i in zone state lga ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //~234 with missing vals b/c they don't have matches on pid

	gen wage=wage_hhid
gen missing_wage = wage == . //ALT 05.09.23							
foreach i in country zone state lga ea {
	replace wage = wage_`i' if obs_`i' > 9  & missing_wage==1
}
//ALT: Experimental 
//egen wage_sd = sd(wage_hhid), by(gender season)
//egen mean_wage = mean(wage_hhid), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 14 stdevs above the mean while the min is only 1.15 below. 
*/
//replace wage=wage_hhid if wage_hhid !=. & abs(wage_hhid-mean_wage)/wage_sd <3 //Using household wage when available, but omitting implausibly high or low values. Trims about 5,000 hh obs, max goes from 80,000->35,000; mean 3,300 -> 2,600

gen val = wage*days
append using `all_hired'
preserve 
	keep if labor_type=="hired"
	drop if strmatch(gender, "child") //Not keeping track of hired labor for some reason.
	collapse (sum) days number val, by(hhid gender)
	gen hired_ = days*number
	gen wage_paid_aglabor_ = val/(days*number)
	keep hhid gender hired_ wage_paid_aglabor_
	reshape wide hired_ wage_paid_aglabor_, i(hhid) j(gender) string
	egen hired_all=rowtotal(hired*)
	egen wage_paid_aglabor=rowtotal(wage*)
	lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
	lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers (local currency)"
	lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
	lab var hired_all "Total hired labor (number of person-days)" 
	lab var hired_female "Total hired women's (number of person-days)"
	lab var hired_male "Total hired men's labor (number of person-days)"
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ag_wage.dta", replace 
restore
keep zone state lga sector ea hhid plot_id season days val labor_type gender number
drop if val==.&days==.
merge m:1 plot_id hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) number val days, by(hhid plot_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_=days, by (hhid plot_id labor_type)
	reshape wide labor_, i(hhid plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_labor_days.dta",replace //AgQuery
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	append using `inkind_payments'
	collapse (sum) val, by(hhid plot_id exp dm_gender)
	gen input="labor"
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_labor.dta", replace //this gets used below.
restore	
//And now we go back to wide
collapse (sum) val, by(hhid plot_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid plot_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender) j(season) string
gen dm_gender2="unkown"
replace dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_cost_labor.dta", replace

	******************************************************
	* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES *
	******************************************************

	*** Pesticides/Herbicides/Animals/Machines
//ALT 05.05.21: Realigning the ag inputs with the labor to make valuation easier.
use "${Nigeria_GHS_W3_raw_data}/secta11c2_harvestw3.dta", clear
ren plotid plot_id
ren s11c2q2a qtypestexp
ren s11c2q2b unitpestexp
ren s11c2q4a valpestexp1
ren s11c2q4b valpestexp2
ren s11c2q5a valpestexp3
ren s11c2q5b valpestexp4
egen valpestexp=rowtotal(valpestexp*)

ren s11c2q7a qtypestimp
ren s11c2q7b unitpestimp

ren s11c2q11a qtyherbexp
ren s11c2q11b unitherbexp
ren s11c2q13a valherbexp1
ren s11c2q13b valherbexp2
ren s11c2q14a valherbexp3
ren s11c2q14b valherbexp4
egen valherbexp = rowtotal(valherbexp*)

ren s11c2q16a qtyherbimp
ren s11c2q16b unitherbimp

foreach i in herbexp pestexp herbimp pestimp {
	replace qty`i'=qty`i'/1000 if unit`i'==2 & qty`i'>9 //Many people reporting 1-5 grams of pesticide/herbicide on their plot - assuming this is likely a typo (and values bear this out)
	replace unit`i'=1 if unit`i'==2
	replace qty`i'=qty`i'/100 if unit`i'==4 & qty`i'>9
	replace unit`i'=3 if unit`i'==4
}

*NOTE: Assuming 0.5 acres per day (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4635562/ says a pair of draft cattle can plow 1 acre in about 2.2 days, at 4.3 hours per day)
*ALT 05.05.21 To keep this consistent with everything else and to produce a valuation for own animals used, I'm changing this to per-day cost
ren s11c2q21 qtyanmlexp
gen valanmlexp1=0
replace valanmlexp1 = s11c2q23a if s11c2q23b==6		// full planting period
replace valanmlexp1 = s11c2q23a*5*qtyanmlexp if s11c2q23b==1				// ASSUME FIVE HOURS PER DAY: payment times number of days times 5 if unit is payment per hour
replace valanmlexp1 = s11c2q23a*qtyanmlexp if s11c2q23b==2					// payment times number of days if unit is payment per day
replace valanmlexp1 = s11c2q23a*0.5*qtyanmlexp if s11c2q23b==4				// acres times 0.5 to put payment into days. then times days (e.g. if you hired for one day but paid "per acre" and they did half an acre, you pay half of the "per acre" price)
replace valanmlexp1 = s11c2q23a*qtyanmlexp*(0.5/2.47105) if s11c2q23b==5	// hectares times 2.47105 for acres, then acres times 0.5 to put payment into days. then times days (e.g. if you hired for one day but paid "per hectare" and they did half an acre, you pay (0.5/2.47105)~0.202 of the "per hectare" price)
replace valanmlexp1 = s11c2q23a/8*qtyanmlexp if s11c2q23c=="8 Days"			// "Other" unit: payment divided by 8 times number of days if reported as "8 days"

gen valanmlexp2 = 0
replace valanmlexp2 = s11c2q24a if s11c2q24b==6		// full planting period
replace valanmlexp2 = s11c2q24a*5*qtyanmlexp if s11c2q24b==1		// ASSUME FIVE HOURS PER DAY: payment times number of days times 5 if unit is payment per hour
replace valanmlexp2 = s11c2q24a*qtyanmlexp if s11c2q24b==2		// payment times number of days if unit is payment per day

gen valanmlexp = valanmlexp1+valanmlexp2
gen valfeedanmlexp = s11c2q25 //Assuming all feed values are explicit regardless of own/rented animal status.
gen qtyfeedanmlexp = valfeedanmlexp!=.
gen unitfeedanmlexp=0 //To exclude from geographic medians.
gen valfeedanmlimp=.
gen qtyfeedanmlimp=0
gen unitfeedanmlimp=0
gen valanmlimp=. //ALT 05.05.21: We should count "own animal use" as an impicit cost We need a per-day cost estimate, though
gen qtyanmlimp=s11c2q20
//We can't do any imputation for machinery, so we don't need to include those.
gen unitanmlexp=1 //Dummies for the reshape
gen unitanmlimp=1
gen valmechexp=s11c2q32+s11c2q33
gen qtymechexp=valmechexp!=.
gen unitmechexp=0
//More dummies

drop *exp1 *exp2 *exp3 *exp4
//Now to reshape long and get all the medians at once.
keep hhid plot_id qty* val* unit*
unab vars : *exp
local stubs : subinstr local vars "exp" "", all
reshape long `stubs', i(hhid plot_id) j(exp) string
reshape long val qty unit, i(hhid plot_id exp) j(input) string
gen itemcode=1
tempfile plot_inputs
save `plot_inputs'

	***Fertilizer
use "${Nigeria_GHS_W3_raw_data}/secta11d_harvestw3.dta", clear

//Prices for imp inputs
ren plotid plot_id
ren s11dq15 itemcodefertexp1
ren s11dq16a qtyfertexp1
ren s11dq16b unitfertexp1
ren s11dq19 valfertexp1
ren s11dq27 itemcodefertexp2
ren s11dq28a qtyfertexp2
ren s11dq28b unitfertexp2
ren s11dq29 valfertexp2
//organic fertilizer
ren s11dq38a qtyfertexp3
ren s11dq38b unitfertexp3
ren s11dq3 itemcodefertimp1
ren s11dq4a qtyfertimp1
ren s11dq4b unitfertimp1
ren s11dq10 valtransfertexp1 //All transportation costs are explicit
ren s11dq18 valtransfertexp2
ren s11dq31 valtransfertexp3
ren s11dq41 valtransfertexp4 
ren s11dq37b unitfertimp4 //We do 1-3 below
ren sect11dq7 itemcodefertimp3
ren sect11dq8a qtyfertimp3
ren sect11dq8b unitfertimp3
//ALT 06.29.23: Updating to capture the os section and moving composite fertilizer to organic
replace itemcodefertimp1 = 1 if s11dq3_os=="SUPER GROW"
replace itemcodefertexp1 = 3 if s11dq15_os != "COMPOST" & s11dq15_os!="" //most of these are name brands; assuming "liquid fertilizer" is some sort of mixture and not liquid ammonia; superphosphate is technically just a P-based fertilizer  but lumping in with NPK for the purposes of inorganic fertilizer accounting. 
replace itemcodefertexp1 = 3 if s11dq15_os == "COMPOST" 

gen itemcodefertexp3=5 if qtyfertexp3!=. //Current codes are 1-4; we'll add 5 as a temporary label for organic
recode itemcodefert* (3=5) //Changing composite manure to organic 
//ALT 06.29.23: end updates
ren s11dq39 valfertexp3
replace unitfertexp3=1 if unitfertexp3==2 & qtyfertexp3 <100 //Likely mistaken reporting - It isn't plausible that someone would use 30 grams of organic fertilizer on even a small plot.
replace unitfertimp4 = 1 if unitfertimp4==2 & s11dq37a<100

gen same_unit = unitfertimp4==unitfertexp3
gen qtyfertimp4 = s11dq37a-qtyfertexp3 if same_unit==1 //Should be no mismatches.
gen itemcodefertimp4=5 if qtyfertimp4!=.

//breaking the subsidized fertilier up
gen subsidized_pct = s11dq5d/s11dq5e
replace subsidized_pct = 1 if subsidized_pct>1
gen itemcodefertimp2 = s11dq5b
gen unitfertimp2 = s11dq5c2
gen qtyfertimp2 = s11dq5c1*subsidized_pct
gen valfertimp2=s11dq5e*subsidized_pct //This corrects for the 6 cases where the e-wallet val is greater than the unsubsidized val
gen itemcodefertexp4=s11dq5b
gen unitfertexp4=s11dq5c2
gen qtyfertexp4=s11dq5c1*(1-subsidized_pct)
gen valfertexp4=s11dq5e*(1-subsidized_pct)

keep item* qty* unit* val* zone state lga ea sector hhid plot_id
gen dummy=_n
unab vars : *2
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(zone state lga ea sector hhid plot_id dummy) j(entry_no)
drop entry_no
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if (itemcodefertexp==. & itemcodefertimp==.) | (unitfertimp==. & unitfertexp==.)
replace dummy=_n
reshape long `stubs2', i(zone state lga ea sector hhid plot_id dummy) j(exp) string
replace dummy=_n
reshape long qty val itemcode, i(zone state lga ea sector hhid plot_id exp dummy) j(input) string
recode qty val (.=0)
replace qty=qty/1000 if unitfert==2 & qty/1000 >=1 //Catching typos.
replace unit=1 if unit==2
replace qty=qty/100 if unit==4 & qty/100 >=1
replace unit=3 if unit==4
gen unit = 1 if strmatch(input, "fert")
	recode qty (.=0)
	replace input="inorg" if itemcode!=5 & !strmatch(input, "transfert")
	replace input="orgfert" if itemcode==5
collapse (sum) qty* val*, by(zone state lga ea sector hhid plot_id exp input unit itemcode)
tempfile phys_inputs
save `phys_inputs'

//Nutrient unit estimates for fertilizers; dry urea: 46%, N & NPK: decide to go with 18-12-11 (identical to W1 & 2)
append using `plot_inputs'
gen n_kg = qty*(itemcode==1)*0.18 + qty*(itemcode==2)*0.46
gen p_kg = qty*(itemcode==1)*0.12
gen k_kg = qty*(itemcode==1)*0.11
gen n_org_kg = qty*(itemcode==5)*0.01
la var n_kg "Kg of nitrogen applied to plot from inorganic fertilizer"
la var p_kg "Kg of phosphorus applied to plot from inorganic fertilizer"
la var k_kg "Kg of potassium applied to plot from inorganic fertilizer"
la var n_org_kg "Kg of nitrogen from manure and organic fertilizer applied to plot"
gen npk_kg = qty*(itemcode==1)
gen urea_kg = qty*(itemcode==2)
la var npk_kg "Total quantity of NPK fertilizer applied to plot"
la var urea_kg "Total quantity of urea fertilizer applied to plot"
gen inorg_fert_kg = qty*(itemcode==1)+qty*(itemcode==2)
gen org_fert_kg = qty*(itemcode==5)
gen pest_kg = qty*input=="pest"
gen herb_kg = qty*input=="herb"
collapse (sum) *kg, by(ea hhid plot_id)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_input_quantities.dta", replace

//Get area planted first
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid plot_id)
tempfile planted_area
save `planted_area' 

//unable to include sharecrop section because of missing plot id.
// use "${Nigeria_GHS_W3_raw_data}/secta3i_harvestW3.dta", clear //Including sharecrops as rental expenses
// ren cropid crop_number
// merge 1:1 zone state lga sector ea hhid crop_number cropname cropcode using "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestW3.dta", nogen
// ren cropcode crop_code
// ren crop_number crop_id
// ren plotid plot_id
// ren sa3iiq16a qty //using "Harvest given as reimbursement for sharecropping"
// ren sa3iiq16b unit
// merge m:1 hhid crop_code unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_prices_for_wages.dta", keep(1 3) nogen
// gen val_sharecrop = qty*hh_price_mean 
// recode val_sharecrop (.=0)
// collapse (sum) val_sharecrop, by(hhid plot_id)
// tempfile sharecrop_vals
// save `sharecrop_vals'

use "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta", clear
ren plotid plot_id
ren s11b1q27 cultivate
// merge 1:1 hhid plot_id using `sharecrop_vals', nogen
// egen valplotrentexp=rowtotal(s11b1q13 s11b1q14 val_sharecrop)
egen valplotrentexp=rowtotal(s11b1q13 s11b1q14)
merge 1:1 plot_id hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas", nogen keep(1 3) keepusing(field_size)
merge 1:1 plot_id hhid using `planted_area'
gen qtyplotrentexp=field_size if valplotrentexp>0 & valplotrentexp!=.
replace qtyplotrentexp=ha_planted if qtyplotrentexp==. & valplotrentexp>0 & valplotrentexp!=. //as in quantity of land rented
gen qtyplotrentimp = field_size if qtyplotrentexp==.
replace qtyplotrentimp = ha_planted if qtyplotrentimp==. & qtyplotrentexp==.
keep if cultivate==1 //No need for uncultivated plots
keep hhid plot_id valplotrent* qtyplotrent* 
reshape long valplotrent qtyplotrent, i(hhid plot_id) j(exp) string
reshape long val qty, i(hhid plot_id exp) j(input) string
gen unit=1 //dummy var
gen itemcode=1 //dummy var
tempfile plotrents
save `plotrents'

use "${Nigeria_GHS_W3_raw_data}/sect11e_plantingw3.dta", clear
//Issues with alternative crop codes here - not sure how much trouble the shelled vs unshelled issue really is, but we only have conversions for the generic crop levels in this wave.

ren plotid plot_id
ren s11eq5 itemcodeseedsimp1
ren s11eq6a qtyseedsimp1
ren s11eq6b unitseedsimp1

ren s11eq9 itemcodeseedsimp2
ren s11eq10a qtyseedsimp2
ren s11eq10b unitseedsimp2

ren s11eq12 valseedtransexp1 //all transportation is explicit
ren s11eq17 itemcodeseedsexp1
ren s11eq18a qtyseedsexp1
ren s11eq18b unitseedsexp1
ren s11eq19 valseedtransexp2
ren s11eq21 valseedsexp1
ren s11eq29 itemcodeseedsexp2
ren s11eq30a qtyseedsexp2
ren s11eq30b unitseedsexp2
ren s11eq31 valseedtransexp3
ren s11eq33 valseedsexp2

keep item* qty* unit* val* hhid plot_id
gen dummy=_n
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i(hhid plot_id dummy) j(entry_no)
drop entry_no
replace dummy=_n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if qtyseedsexp==. & valseedsexp==.
reshape long `stubs2', i(hhid plot_id dummy) j(exp) string
replace dummy=_n
reshape long qty unit val itemcode, i(hhid plot_id exp dummy) j(input) string
drop if strmatch(exp,"imp") & strmatch(input,"seedtrans") //No implicit transportation costs
recode itemcode (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) (3181 3182 3183 3184 = 3180) (2170=2030) /*
*/ 				(3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) /*(1121 1122 1123 1124=1120)*/
collapse (sum) val qty, by(hhid plot_id unit itemcode exp input)
ren itemcode crop_code
ren unit unit_cd
drop if crop_code==. & strmatch(input,"seeds")
replace unit_cd = 31 if unit_cd==32 //Both large mudu, not sure where the surplus unit code came from.
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", nogen keep(3) keepusing(zone)
merge m:1 crop_code unit_cd zone using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", nogen keep(1 3)
//The problem is that not all of these are seeds (see w4) and so some of the conversions are probably off.
ren conv_fact conversion
replace conversion = 10 if crop_code==1020 & inrange(unit_cd,160,162) //10 stems per bundle, regardless of size
replace conversion = 1 if inrange(unit_cd,80,82) | (unit_cd==1 & conversion==.) //pieces //why there are kgs not converted at this point is beyond my ken. 
gen unit=1 if inlist(unit_cd,160,161,162,80,81,82) //pieces
replace unit=2 if unit==. //Weight, meaningless for transportation
replace unit=0 if conversion==. //useless for price calculations
replace qty=qty*conversion if conversion!=.
ren crop_code itemcode
recode val (.=0)
collapse (sum) val qty, by(hhid plot_id exp input itemcode unit) //Eventually, quantity won't matter for things we don't have units for.
//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta",nogen keep(3) keepusing(zone state lga ea weight_pop_rururb)
merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_decision_makers",nogen keep(1 3) keepusing(dm_gender)
tempfile all_plot_inputs
save `all_plot_inputs' //Woo, now we have 53k unique entries and can estimate vals.

keep if strmatch(exp,"exp") & qty!=. //Now for geographic medians
gen plotweight = weight*field_size
recode val (0=.)
drop if unit==0 //Remove things with unknown units.
gen price = val/qty
drop if price==.
gen obs=1

foreach i in zone state lga ea hhid {
preserve
	bys `i' input unit itemcode : egen obs_`i' = sum(obs)
	collapse (median) price_`i'=price [aw=plotweight], by (`i' input unit itemcode obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
}

preserve
bys input unit itemcode : egen obs_country = sum(obs)
collapse (median) price_country = price [aw=plotweight], by(input unit itemcode obs_country)
tempfile price_country_median
save `price_country_median'
restore

use `all_plot_inputs',clear
foreach i in zone state lga ea hhid {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_hhid (.=0)
	gen price=price_hhid
foreach i in country zone state lga ea {
	replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
}
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
recode val qty (.=0)
drop if val==0 & qty==0 //Dropping unnecessary observations.
replace val=qty*price if val==0

replace input = "orgfert" if itemcode==5
replace input = "inorg" if strmatch(input,"fert")

append using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_labor.dta"
collapse (sum) val, by (hhid plot_id exp input dm_gender)

save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cost_inputs_long.dta",replace 
preserve
collapse (sum) val, by(hhid exp input) 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_cost_inputs_long.dta", replace //ALT 02.07.2022: Holdover from W4.
restore

preserve
	collapse (sum) val_=val, by(hhid plot_id exp dm_gender)
	reshape wide val_, i(hhid plot_id dm_gender) j(exp) string
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cost_inputs.dta", replace //This gets used below.
restore
	
//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
ren val val_ 
reshape wide val_, i(hhid plot_id exp dm_gender) j(input) string
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender) j(exp) string
gen dm_gender2="unknown"
replace dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cost_inputs_wide.dta", replace //Used for monocrop plots
collapse (sum) val*, by(hhid)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}
egen val_exp_hh=rowtotal(*_exp_hh)
egen val_imp_hh=rowtotal(*_imp_hh)
drop val_mech_imp* val_seedtrans_imp* val_transfert_imp* val_feedanml_imp* //Not going to have any data
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_cost_inputs_verbose.dta", replace


//We can do this more simply by:
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cost_inputs_long.dta", clear
//back to wide
drop input
collapse (sum) val, by(hhid plot_id exp dm_gender)
gen dm_gender2="unknown"
replace dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender2) j(exp) string
ren val* val*_
merge 1:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
merge 1:1 plot_id hhid using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid)
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_cost_inputs.dta", replace

********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************

//Setting things up for AgQuery first
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
	keep if purestand==1  //For now, omitting relay crops.
	//File now has 2550 unique entries after omitting the crops that were "replaced" - it should be noted that some these were grown in mixed plots and only one crop was lost. Which is confusing.
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono

forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	keep if crop_code==`c'			
	ren monocrop_ha `cn'_monocrop_ha
	drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==.
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	/*
	gen dm_male = dm_gender==1 
	gen dm_female = dm_gender==2
	gen dm_mixed = dm_gender==3
	*/
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (Naira)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	collapse (sum) *monocrop* kgs_harv* val_harv* (max) dm*, by(hhid)
	foreach i in kgs_harv_mono_`cn' val_harv_mono_`cn' {
	foreach j in male female mixed {
	replace `i'_`j' = . if dm_`j'==0
	}
	}
	recode `cn'_monocrop_ha* (0=.)
	drop dm*
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_`cn'_monocrop_hh_area.dta", replace
restore
}

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid plot_id dm_gender) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2="unknown"
replace dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	reshape wide val*, i(hhid plot_id) j(dm_gender2) string
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_inputs_`cn'.dta", replace
restore
}

********************************************************************************
* TLU (Tropical Livestock Units) *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta", clear
gen tlu=0.5 if (animal_cd==101|animal_cd==102|animal_cd==103|animal_cd==104|animal_cd==105|animal_cd==106|animal_cd==107|animal_cd==109)
replace tlu=0.3 if (animal_cd==108)
replace tlu=0.1 if (animal_cd==110|animal_cd==111)
replace tlu=0.2 if (animal_cd==112)
replace tlu=0.01 if (animal_cd==113|animal_cd==114|animal_cd==115|animal_cd==116|animal_cd==117|animal_cd==118|animal_cd==119|animal_cd==120|animal_cd==121)
replace tlu=0.7 if (animal_cd==122)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
ren animal_cd lvstckid
gen cattle=inrange(lvstckid,101,107)
gen smallrum=inlist(lvstckid,110,  111, 119,  120)
gen largerum = inlist(lvstckid,101,102,103,104,105,106,107) // HKS 6.16.23
gen poultry=inrange(lvstckid,113,118)
gen other_ls=inlist(lvstckid,108,109, 121, 122, 123)
gen cows=inrange(lvstckid,105,105)
gen chickens=inrange(lvstckid,113,116)
ren s11iq6 nb_ls_stardseas
gen nb_cattle_stardseas=nb_ls_stardseas if cattle==1 
gen nb_smallrum_stardseas=nb_ls_stardseas if smallrum==1 
gen nb_poultry_stardseas=nb_ls_stardseas if poultry==1 
gen nb_other_ls_stardseas=nb_ls_stardseas if other_ls==1 
gen nb_cows_stardseas=nb_ls_stardseas if cows==1 
gen nb_chickens_stardseas=nb_ls_stardseas if chickens==1 
gen nb_ls_today =s11iq2
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_largerum_today=nb_ls_today if largerum==1 // HKS 6.16.23
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_stardseas = nb_ls_stardseas * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
ren s11iq16 nb_ls_sold 
ren s11iq17 income_ls_sales 
recode   tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_stardseas "Number of cattle owned at the begining of ag season"
lab var nb_smallrum_stardseas "Number of small ruminant owned at the begining of ag season"
lab var nb_poultry_stardseas "Number of cattle poultry at the begining of ag season"
lab var nb_other_ls_stardseas "Number of other livestock (dog, donkey, and other) owned at the begining of ag season"
lab var nb_cows_stardseas "Number of cows owned at the begining of ag season"
lab var nb_chickens_stardseas "Number of chickens owned at the begining of ag season"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_largerum_today "Number of large ruminant owned as of the time of survey" // HKS 6.16.23
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_stardseas "Tropical Livestock Units at the begining of ag season"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_stardseas  "Number of livestock owned at the begining of ag season"
lab var nb_ls_stardseas  "Number of livestock owned at the begining of ag season"
lab var nb_ls_today "Number of livestock owned as of today"
lab var nb_ls_sold "Number of total livestock sold alive this ag season"
drop tlu_coefficient
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_TLU_Coefficients.dta", replace

//ALT Update 10.25.21: For AgQuery


********************************************************************************
* LIVESTOCK INCOME *
********************************************************************************
//ALT 10.25.21 updating this section to mirror the code in crop income/expenses
***Expenses
use "${Nigeria_GHS_W3_raw_data}/sect11j_plantingw3.dta", clear
ren s11jq2a val_cash 
ren s11jq2b val_inkind 
recode val* (.=0)
gen val_total = val_cash+val_inkind
//Using names below for compatibility with old files; should consider shortening them. 
gen input = "hired_labor" if item_cd == 1 | item_cd==4
replace input = "fodder" if item_cd==2
replace input = "vaccines" if item_cd==3
replace input = "other" if inrange(item_cd, 5, 9)
collapse (sum) val_total, by(input hhid)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_expenses_long.dta", replace //AgQuery 
ren val_total cost_ 
reshape wide cost_, i(hhid) j(input) string 
ren cost* cost*_livestock
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_expenses.dta", replace

//ALT 10.25.21: Leaving this section as-is for now b/c it's (mostly) ready to use.
use "${Nigeria_GHS_W3_raw_data}/sect11k_plantingw3.dta", clear
ren prod_cd livestock_code
ren s11kq2 months_produced
ren s11kq3a quantity_produced
ren s11kq3b quantity_produced_unit
ren s11kq5a quantity_sold_season
ren s11kq5b quantity_sold_season_unit
ren s11kq6 earnings_sales
recode quantity_produced quantity_sold_season months_produced (.=0)
gen price_unit = earnings_sales / quantity_sold_season
recode price_unit (0=.)
bys livestock_code: count if quantity_sold_season !=0
keep hhid livestock_code months_produced quantity_produced quantity_produced_unit quantity_sold_season quantity_sold_season_unit earnings_sales price_unit
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_products.dta", replace

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_products", clear
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta"
drop if _merge==2
collapse (median) price_unit [aw=weight], by (livestock_code quantity_sold_season_unit)
ren price_unit price_unit_median_country
ren quantity_sold_season_unit unit
replace price_unit_median_country = 100 if livestock_code == 1 & unit==1 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_products_prices_country.dta", replace

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_products", clear
replace quantity_produced_unit = 80 if livestock_code==2 & (quantity_produced_unit==70 | quantity_produced_unit==82 | quantity_produced_unit==90 | quantity_produced_unit==191 /*
*/ | quantity_produced_unit==141 | quantity_produced_unit==160 | quantity_produced_unit==3 | quantity_produced_unit==1)
replace quantity_produced_unit = 3 if livestock_code==1 & (quantity_produced_unit==1 | quantity_produced_unit==70 | quantity_produced_unit==81  | quantity_produced_unit==80 | quantity_produced_unit==191)
gen unit = quantity_produced_unit 
merge m:1 livestock_code unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_products_prices_country.dta", nogen keep(1 3)
keep if quantity_produced!=0
gen value_produced = price_unit * quantity_produced * months_produced if quantity_produced_unit == quantity_sold_season_unit
replace value_produced = price_unit_median_country * quantity_produced * months_produced if value_produced==.
replace value_produced = earnings_sales if value_produced==.
lab var price_unit "Price per liter (milk) or per egg/liter/container honey or palm wine, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_unit * months_produced if livestock_code==1
replace value_milk_produced = quantity_produced * price_unit_median_country * months_produced if livestock_code==1 & value_milk_produced==.
gen value_eggs_produced = quantity_produced * price_unit * months_produced if livestock_code==2
replace value_eggs_produced = quantity_produced * price_unit_median_country * months_produced if livestock_code==2 & value_eggs_produced==.
gen value_other_produced = quantity_produced * price_unit * months_produced if livestock_code!=1 & livestock_code!=2 //ALT: This is labeled as "honey and skins" below, but there's other products in here as well.
*Share of total production sold
gen sales_livestock_products = earnings_sales	
/*Agquery 12.01*/
//No way to limit this to just cows and chickens b/c the actual livestock code is missing.
gen sales_milk = earnings_sales if livestock_code==1
gen sales_eggs = earnings_sales if livestock_code==2
collapse (sum) value_milk_produced value_eggs_produced sales_livestock_products value_other_produced /*agquery*/ sales_milk sales_eggs, by (hhid)
*Share of production sold
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins produced"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_products.dta", replace

*Sales (live animals)
use "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta", clear
ren animal_cd livestock_code 
ren s11iq16 number_sold 
ren s11iq17 income_live_sales 
ren s11iq19a number_slaughtered_sold 
ren s11iq19b number_slaughtered_consumption 
ren s11iq11 value_livestock_purchases
recode number_sold income_live_sales number_slaughtered_sold number_slaughtered_consumption value_livestock_purchases (.=0)
gen number_slaughtered = number_slaughtered_sold + number_slaughtered_consumption 
lab var number_slaughtered "Number slaughtered for sale and home consumption"
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(1 3)
keep if price_per_animal !=. & price_per_animal!=0
keep hhid weight zone state lga ea livestock_code number_sold income_live_sales number_slaughtered number_slaughtered_sold price_per_animal value_livestock_purchases
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_sales", replace

*Implicit prices (shorter)
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_sales", clear
gen obs = 1
foreach i in zone state lga ea {
preserve
bys `i' livestock_code : egen obs_`i' =sum(obs)
collapse (median) price_median_`i'=price_per_animal [aw=weight], by(`i' obs_`i' livestock_code)
tempfile livestock_prices_`i'
save `livestock_prices_`i''
restore 
merge m:1 `i' livestock_code using `livestock_prices_`i'', nogen keep(1 3)
}
preserve
collapse (median) price_median_country=price_per_animal (sum) obs_country = obs [aw=weight], by(livestock_code) //Collapsing the obs here is unnecessary b/c we assume there will be >9 per livestock species per country; however, it makes the loop in the next block run.
tempfile livestock_prices_country
save `livestock_prices_country'
restore
merge m:1 livestock_code using `livestock_prices_country', nogen keep(1 3) 

foreach i in ea lga zone state country {
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
gen value_livestock_sales = value_lvstck_sold + value_slaughtered_sold
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01*/value_slaughtered_sold, by (hhid)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.01*/ gen prop_meat_sold = value_slaughtered_sold/value_slaughtered 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_sales.dta", replace


*TLU (Tropical Livestock Units)
use "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta", clear
gen tlu=0.5 if (animal_cd==101|animal_cd==102|animal_cd==103|animal_cd==104|animal_cd==105|animal_cd==106|animal_cd==107|animal_cd==109)
replace tlu=0.3 if (animal_cd==108)
replace tlu=0.1 if (animal_cd==110|animal_cd==111)
replace tlu=0.2 if (animal_cd==112)
replace tlu=0.01 if (animal_cd==113|animal_cd==114|animal_cd==115|animal_cd==116|animal_cd==117|animal_cd==118|animal_cd==119|animal_cd==120|animal_cd==121)
replace tlu=0.7 if (animal_cd==122)
lab var tlu "Tropical Livestock Unit coefficient"
ren animal_cd livestock_code
ren tlu tlu_coefficient
ren s11iq2 number_today 
ren s11iq3 price_per_animal_est /* Estimated by the respondent */
ren s11iq6 number_start_agseas 
gen tlu_start_agseas = number_start_agseas * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
ren s11iq16 number_sold 
ren s11iq17 income_live_sales
egen lost_disease = rowtotal (s11iq21b s11iq21d) 

*Livestock mortality rate and percent of improved livestock breeds

egen animals_lost_agseas = rowtotal(s11iq21b s11iq21d)	// Only animals lost to disease; thefts and death by accidents not included
gen species = "lrum" if inlist(livestock_code,101,102,103,104,105,106,107)
replace species = "srum" if inlist(livestock_code,110,111)
replace species = "pigs" if livestock_code==112
replace species = "equine" if inlist(livestock_code,108,109,122)
replace species = "poultry" if inlist(livestock_code,113,114,115,116,117,118,120)
drop if strmatch(species,"") //Omitting fish and rabbits; might be better to include these (not a large number of hh's, though)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)

merge m:1 livestock_code using `livestock_prices_country', nogen keep(1 3)
foreach i in ea lga zone state {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}


gen value_start_agseas = number_start_agseas * price_per_animal
gen value_today = number_today * price_per_animal
gen value_today_est = number_today * price_per_animal_est

collapse (sum) number_today number_start_agseas animals_lost_agseas lost_disease lvstck_holding=number_today value* tlu*, by(hhid species)
egen mean_agseas=rowmean(number_today number_start_agseas)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_herd_characteristics_long", replace //AgQuery

preserve
keep hhid species number_today number_start_agseas animals_lost_agseas lost_disease lvstck_holding mean_agseas
global lvstck_vars number_today number_start_agseas animals_lost_agseas lost_disease lvstck_holding mean_agseas
foreach i in $lvstck_vars {
	ren `i' `i'_
}
reshape wide $lvstck_vars, i(hhid) j(species) string
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_herd_characteristics", replace
restore

collapse (sum) tlu_start_agseas tlu_today value_start_agseas value_today value_today_est, by (hhid)
lab var tlu_start_agseas "Tropical Livestock Units as of the start of the agricultural season"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_start_agseas "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
lab var value_today_est "Value of livestock holdings today, per estimates (not observed sales)"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_TLU.dta", replace

********************************************************************************
* FISH INCOME *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/secta9a2_harvestw3.dta", clear
ren fish_cd fish_code
ren sa9aq5b unit
ren sa9aq6 price_per_unit
recode price_per_unit (0=.)
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta"
drop if _merge==2
collapse (median) price_per_unit [aw=weight_pop_rururb], by (fish_code unit)
ren price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_prices_1.dta", replace /* Caught fish */

use "${Nigeria_GHS_W3_raw_data}/secta9a2_harvestw3.dta", clear
ren fish_cd fish_code
ren sa9aq7b unit
ren sa9aq8 price_per_unit
recode price_per_unit (0=.)
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta"
drop if _merge==2
collapse (median) price_per_unit [aw=weight_pop_rururb], by (fish_code unit)
ren price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_prices_2.dta", replace /* Harvested fish */

use "${Nigeria_GHS_W3_raw_data}/secta9a2_harvestw3.dta", clear
keep if sa9aq2==1
ren fish_cd fish_code
ren sa9aq3 weeks_fishing
ren sa9aq4a1 quantity_caught /* on average per week */
ren sa9aq4a2 quantity_caught_unit
ren sa9aq4b1 quantity_harvested /* on average per week */
ren sa9aq4b2 quantity_harvested_unit
ren sa9aq5b sold_unit
ren sa9aq6 price_per_unit
ren sa9aq7b sold_unit_harvested
ren sa9aq8 price_per_unit_harvested
recode quantity_caught quantity_harvested (.=0)
ren quantity_caught_unit unit
merge m:1 fish_code unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_prices_1.dta", nogen keep(1 3)
gen value_fish_caught = (quantity_caught * price_per_unit) if unit==sold_unit
replace value_fish_caught = (quantity_caught * price_per_unit_median) if value_fish_caught==.
replace value_fish_caught = (quantity_caught * price_per_unit) if unit==91 & sold_unit==90 & value_fish_caught==. 
ren unit quantity_caught_unit 
ren quantity_harvested_unit unit
drop price_per_unit_median
merge m:1 fish_code unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_prices_2.dta", nogen keep(1 3)
gen value_fish_harvest = (quantity_harvested * price_per_unit_harvested) if unit==sold_unit_harvested
replace value_fish_harvest = (quantity_harvested * price_per_unit_median) if value_fish_harvest==.
replace value_fish_harvest = (quantity_harvested * (3500*10)) if unit==80 & sold_unit_harvested==1 & value_fish_harvest==. 
replace value_fish_harvest = (quantity_harvested * (600)) if unit==3 & sold_unit_harvested==. & value_fish_harvest==.
replace value_fish_harvest = value_fish_harvest * weeks_fishing /* Multiply average weekly earnings by number of weeks */
replace value_fish_caught = value_fish_caught * weeks_fishing
recode value_fish_harvest value_fish_caught weeks_fishing (.=0)
collapse (median) value_fish_harvest value_fish_caught (max) weeks_fishing, by (hhid)
lab var value_fish_caught "Value of fish caught over the past 12 months"
lab var value_fish_harvest "Value of fish harvested over the past 12 months"
lab var weeks_fishing "Maximum number weeks fishing for any species"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_income.dta", replace

use "${Nigeria_GHS_W3_raw_data}/secta9b2_harvestw3.dta", clear
ren sa9bq7 rental_costs_day
ren sa9bq6 days_rental
ren sa9bq9 maintenance_costs_per_week
ren sa9bq8 fuel_per_week /* Multiply this by weeks fishing */
recode days_rental rental_costs_day maintenance_costs_per_week (.=0)
gen rental_costs_fishing = rental_costs_day * days_rental
gen fish_expenses_1 = fuel_per_week + maintenance_costs_per_week
collapse (sum) fish_expenses_1, by (hhid)
lab var fish_expenses_1 "Expenses associated with boat rental and maintenance per week" 
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_income.dta"
replace fish_expenses_1 = fish_expenses_1 * weeks_fishing
keep hhid fish_expenses_1
lab var fish_expenses_1 "Expenses associated with boat rental and maintenance over the year"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fishing_expenses_1.dta", replace

use "${Nigeria_GHS_W3_raw_data}/secta9b3_harvestw3.dta", clear
ren sa9bq10a number_men
ren sa9bq10b weeks_men
ren sa9bq11a number_women
ren sa9bq11b weeks_women
ren sa9bq12a number_children
ren sa9bq12b weeks_child
ren sa9bq15a wages_week_man
ren sa9bq15b wages_week_woman
ren sa9bq15c wages_week_child
ren sa9bq19a cash_men
ren sa9bq19b cash_women
ren sa9bq19c cash_child
ren sa9bq22a costs_feed 
ren sa9bq22b costs_irrigation 
ren sa9bq22c costs_maintenance 
ren sa9bq22d costs_fishnets 
ren sa9bq22e costs_other
recode number_men weeks_men number_women weeks_women number_children weeks_child wages_week_man wages_week_woman /*
*/ wages_week_child cash_men cash_women cash_child costs_feed costs_irrigation costs_maintenance costs_fishnets costs_other (.=0)
gen fish_expenses_2 = (number_men * weeks_men * wages_week_man) + (number_women * weeks_women * wages_week_woman) + /*
*/ (number_children * weeks_child * wages_week_child) + (cash_men + cash_women + cash_child) + /*
*/ (costs_feed + costs_irrigation + costs_maintenance + costs_fishnets + costs_other)
keep hhid fish_expenses_2
lab var fish_expenses_2 "Expenses associated with hired labor and fish pond maintenance"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fishing_expenses_2.dta", replace


********************************************************************************
* SELF-EMPLOYMENT INCOME *
********************************************************************************	
use "${Nigeria_GHS_W3_raw_data}/sect9_harvestw3.dta", clear
local vars s9q10a s9q10b s9q10c s9q10d s9q10e s9q10f s9q10g s9q10h s9q10i s9q10j s9q10k s9q10l 
foreach p of local vars {
replace `p' = "1" if `p'=="X"
replace `p' = "0" if `p'==""
destring `p', replace
}
egen months_activ = rowtotal(s9q10a - s9q10l)
ren s9q27a monthly_profit
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months (Feb 15 - Jan 16)"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_self_employment_income.dta", replace

*Sales of processed crops were captured separately.
*Value crop inputs used in the processed products.
use "${Nigeria_GHS_W3_raw_data}/secta3i_harvestw3.dta", clear
ren cropname crop_name
ren cropcode crop_code
ren sa3iq3 harvest_yesno
ren sa3iq6i quantity_harvested
ren sa3iq6ii unit
ren sa3iq6ii_os quantity_harvested_unit_other
ren sa3iq6a value_harvested
replace value_harvested = 0 if harvest_yesno==2
replace value_harvested = 0 if value_harvested==. & quantity_harvested == 0
ren sa3iq6b finished_harvest
ren sa3iq6d1 quantity_to_harvest
ren sa3iq6d2 quantity_to_harvest_unit
ren sa3iq6d2_os quantity_to_harvest_unit_other
collapse (sum) value_harvested quantity_harvested, by (hhid crop_code unit)
gen price_per_unit = value_harvested / quantity_harvested
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_unit_values.dta", replace

use "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestw3.dta", clear
ren cropname crop_name
ren cropcode crop_code
ren sa3iiq19 sell_processedcrop_yesno
ren sa3iiq20a quant_processed_crop_sold
ren sa3iiq20b unit
ren sa3iiq20b_os quant_proccrop_sold_unit_other
ren sa3iiq21 value_processed_crop_sold
merge m:1 hhid crop_code unit using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_unit_values.dta", nogen keep(1 3)
ren unit unit_cd
merge m:1 crop_code unit_cd using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_prices_median_country.dta", nogen keep(1 3) //ALT 08.01.21: I think it would be better to use the same approach we use for raw crop values here.
gen price_received = value_processed_crop_sold / quant_processed_crop_sold
gen price_as_input = price_per_unit
replace price_as_input = price_unit_country if price_as_input==.
replace price_as_input = price_received if price_as_input > price_received /* Where unit-value of input exceeds the unit-value of processed output, we'll cap the per-unit price at the processed output price */
gen value_crop_input = quant_processed_crop_sold * price_as_input
gen profit_processed_crop_sold = value_processed_crop_sold - value_crop_input
collapse (sum) profit_processed_crop_sold, by (hhid)
lab var profit_processed_crop_sold "Net value of processed crops sold, with crop inputs valued at the unit price for the harvest"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_agproduct_income.dta", replace

********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect3_harvestw3.dta", clear
gen  hrs_main_wage_off_farm=s3q18 if (s3q14>1 & s3q14!=.) & s3q15b1!=1		// s3q14 1   is agriculture (exclude mining). Also exclude apprenticeship and considered this as unpaid work.
gen  hrs_sec_wage_off_farm= s3q31 if (s3q27>1 & s3q27!=.) & s3q28b1!=1 
gen  hrs_other_wage_off_farm= s3q47 if (s3q44b>1 & s3q44b!=.) 
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm hrs_other_wage_off_farm) 
gen  hrs_main_wage_on_farm=s3q18 if (s3q14<=1 & s3q14!=.)  & s3q15b1!=1		 
gen  hrs_sec_wage_on_farm= s3q31 if (s3q27<=1 & s3q27!=.) & s3q28b1!=1 	 
gen  hrs_other_wage_on_farm= s3q47 if (s3q44b<=1 & s3q44b!=.) 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm hrs_other_wage_on_farm)
gen  hrs_main_unpaid_off_farm=s3q18 if (s3q14>1 & s3q14!=.) & s3q15b1!=1
gen  hrs_sec_unpaid_off_farm= s3q31 if s3q28b1!=1 
egen hrs_unpaid_off_farm= rowtotal(hrs_main_unpaid_off_farm hrs_sec_unpaid_off_farm)
drop *main* *sec* *other*
recode s3q39_new s3q40_new (.=0) 
gen hrs_domest_fire_fuel=(s3q39_new/60+s3q40_new/60)*7  // hours worked just yesterday
ren  s3q5b hrs_ag_activ
ren  s3q6b hrs_self_off_farm
egen hrs_off_farm=rowtotal(hrs_wage_off_farm hrs_self_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
egen hrs_domest_all=rowtotal(hrs_domest_fire_fuel)
egen hrs_other_all=rowtotal(hrs_unpaid_off_farm)
foreach v of varlist hrs_* {
	local l`v'=subinstr("`v'", "hrs", "nworker",.)
	gen  `l`v''=`v'!=0
} 
gen member_count = 1
collapse (sum) nworker_* hrs_*  member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var hrs_unpaid_off_farm  "Total household hours - unpaid activities"
la var hrs_ag_activ "Total household hours - agricultural activities"
la var hrs_wage_off_farm "Total household hours - wage off-farm"
la var hrs_wage_on_farm  "Total household hours - wage on-farm"
la var hrs_domest_fire_fuel  "Total household hours - collecting fuel and making fire"
la var hrs_off_farm  "Total household hours - work off-farm"
la var hrs_on_farm  "Total household hours - work on-farm"
la var hrs_domest_all  "Total household hours - domestic activities"
la var hrs_other_all "Total household hours - other activities"
la var hrs_self_off_farm  "Total household hours - self-employment off-farm"
la var nworker_unpaid_off_farm  "Number of HH members with positve hours - unpaid activities"
la var nworker_ag_activ "Number of HH members with positve hours - agricultural activities"
la var nworker_wage_off_farm "Number of HH members with positve hours - wage off-farm"
la var nworker_wage_on_farm  "Number of HH members with positve hours - wage on-farm"
la var nworker_domest_fire_fuel  "Number of HH members with positve hours - collecting fuel and making fire"
la var nworker_off_farm  "Number of HH members with positve hours - work off-farm"
la var nworker_on_farm  "Number of HH members with positve hours - work on-farm"
la var nworker_domest_all  "Number of HH members with positve hours - domestic activities"
la var nworker_other_all "Number of HH members with positve hours - other activities"
la var nworker_self_off_farm  "Number of HH members with positve hours - self-employment off-farm"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_off_farm_hours.dta", replace


********************************************************************************
* WAGE INCOME *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect3_harvestw3.dta", clear
ren s3q13b activity_code
ren s3q14 sector_code
ren s3q12b1 mainwage_yesno
ren s3q16 mainwage_number_months
ren s3q17 mainwage_number_weeks
ren s3q18 mainwage_number_hours
ren s3q21a mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity==1 // exclude ag wages 
ren s3q21b mainwage_payment_period
ren s3q24a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity==1
ren s3q24b mainwage_payment_period_other
ren s3q27 sec_sector_code
ren s3q25 secwage_yesno
ren s3q29 secwage_number_months
ren s3q30 secwage_number_weeks
ren s3q31 secwage_number_hours
ren s3q34a secwage_recent_payment
gen sec_ag_activity = (sec_sector_code==1)
replace secwage_recent_payment = . if sec_ag_activity==1 // exclude ag wages 
ren s3q34b secwage_payment_period
ren s3q37a secwage_recent_payment_other
replace secwage_recent_payment_other = . if sec_ag_activity==1
ren s3q44b other_sector_code
ren s3q37b secwage_payment_period_other
ren s3q42 othwage_yesno
ren s3q45 othwage_number_months
ren s3q46 othwage_number_weeks
ren s3q47 othwage_number_hours
ren s3q49a othwage_recent_payment
replace othwage_recent_payment = . if other_sector_code==1 // exclude ag wages
ren s3q49b othwage_payment_period
gen othwage_recent_payment_other = .
gen othwage_payment_period_other = .
ren s3q4 worked_as_employee
recode  mainwage_number_months secwage_number_months (12/max=12)
recode  mainwage_number_weeks secwage_number_weeks (52/max=52)
recode  mainwage_number_hours secwage_number_hours (84/max=84)
local vars main sec
local vars main sec oth
foreach p of local vars {
	replace `p'wage_recent_payment=. if worked_as_employee!=1
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = ((`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	replace `p'wage_recent_payment_other=. if worked_as_employee!=1
	gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
	replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
	replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
	replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
	replace `p'wage_salary_other = ((`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
	replace `p'wage_salary_other = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
	recode `p'wage_salary_cash `p'wage_salary_other (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary = mainwage_annual_salary + secwage_annual_salary + othwage_annual_salary
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_wage_income.dta", replace


*Ag wage income
use "${Nigeria_GHS_W3_raw_data}/sect3_harvestw3.dta", clear
ren s3q13b activity_code
ren s3q14 sector_code
ren s3q12b1 mainwage_yesno
ren s3q16 mainwage_number_months
ren s3q17 mainwage_number_weeks
ren s3q18 mainwage_number_hours
ren s3q21a mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity!=1 // include only ag wages
ren s3q21b mainwage_payment_period
ren s3q24a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity!=1 // include only ag wages
ren s3q24b mainwage_payment_period_other
ren s3q25 secwage_yesno
ren s3q27 sec_sector_code
ren s3q29 secwage_number_months
ren s3q30 secwage_number_weeks
ren s3q31 secwage_number_hours
ren s3q34a secwage_recent_payment
gen sec_ag_activity = (sec_sector_code==1)
replace secwage_recent_payment = . if sec_ag_activity!=1
ren s3q34b secwage_payment_period
ren s3q37a secwage_recent_payment_other
replace secwage_recent_payment_other = . if sec_ag_activity!=1 // include only ag wages
ren s3q37b secwage_payment_period_other
ren s3q42 othwage_yesno
ren s3q44b other_sector_code
ren s3q45 othwage_number_months
ren s3q46 othwage_number_weeks
ren s3q47 othwage_number_hours
ren s3q49a othwage_recent_payment
replace othwage_recent_payment = . if other_sector_code!=1 // include only ag wages
ren s3q49b othwage_payment_period
gen othwage_recent_payment_other = .
gen othwage_payment_period_other = .
ren s3q4 worked_as_employee
recode  mainwage_number_months secwage_number_months (12/max=12)
recode  mainwage_number_weeks secwage_number_weeks (52/max=52)
recode  mainwage_number_hours secwage_number_hours (84/max=84)
local vars main sec

local vars main sec oth
foreach p of local vars {
	replace `p'wage_recent_payment=. if worked_as_employee!=1
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = ((`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	replace `p'wage_recent_payment_other=. if worked_as_employee!=1
	gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
	replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
	replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
	replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
	replace `p'wage_salary_other = ((`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
	replace `p'wage_salary_other = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
	recode `p'wage_salary_cash `p'wage_salary_other (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary_agwage = mainwage_annual_salary + secwage_annual_salary + othwage_annual_salary
collapse (sum) annual_salary_agwage, by (hhid)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_agwage_income.dta", replace 


********************************************************************************
*OTHER INCOME *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect6_harvestw3.dta", clear
*To convert from US dollars and Euros, we'll use the June 2015 exchange rate.
*https://fx-rate.net/NGN/?date_input=2015-06-05
*1 USD --> 199 naira; 1 Euro --> 223.1 naira for June 5, 2015 
ren s6q4a cash_received
ren s6q4b cash_received_unit
ren s6q8a inkind_received
ren s6q8b inkind_received_unit
local vars cash_received inkind_received
foreach p of local vars {
	replace `p' = `p'*199 if `p'_unit==1
	replace `p' = `p'*223.1 if `p'_unit==2
	replace `p'_unit = 5 if `p'_unit==1|`p'_unit==2
	tab `p'_unit
}
recode cash_received inkind_received (.=0)
gen remittance_income = cash_received + inkind_received
collapse (sum) remittance_income, by (hhid)
lab var remittance_income "Estimated income from OVERSEAS remittances over previous 12 months"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_remittance_income.dta", replace

use "${Nigeria_GHS_W3_raw_data}/sect13_harvestw3.dta", clear
append using "${Nigeria_GHS_W3_raw_data}/sect14_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/secta4_harvestw3.dta"
ren s13q2 investment_income
ren s13q5 rental_income_buildings
ren s13q8 other_income 
ren s14q2a assistance_cash
ren s14q2d assistance_food
ren s14q2e assistance_inkind
ren sa4q7 rental_income_assets
recode investment_income rental_income_buildings other_income assistance_cash assistance_food assistance_inkind rental_income_assets (.=0)
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) investment_income rental_income_buildings other_income assistance_income rental_income_assets, by (hhid)
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var rental_income_buildings "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
lab var rental_income_assets "Estimated income from rentals of tools and other agricultural assets over previous 12 months"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_other_income.dta", replace

*Land rental
use "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta", clear
ren s11b1q29 year_rented
ren s11b1q31 land_rental_income_cash
ren s11b1q33 land_rental_income_inkind
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income = land_rental_income_cash + land_rental_income_inkind
replace land_rental_income = . if year_rented < 2015 | year_rented == .
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_rental_income.dta", replace


********************************************************************************
* FARM SIZE/LAND SIZE *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/secta3i_harvestw3.dta", clear
gen cultivated = 1
merge m:1 hhid plotid using "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta"
ren s11b1q27 cultivated_this_year
preserve 
use "${Nigeria_GHS_W3_raw_data}/sect11f_plantingw3.dta", clear
gen cultivated = 1 if (s11fq7!=. & s11fq7!=0) |  (s11fq11a!=. & s11fq11a!=0)
collapse (max) cultivated, by (hhid plotid)
tempfile tree
save `tree', replace
restore
append using `tree'

replace cultivated = 1 if cultivated_this_year==1 & cultivated==.
ren plotid plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_cultivated.dta", replace

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", clear
merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) field_size, by (hhid plot_id)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_sizes.dta", replace
collapse (sum) field_size, by (hhid)
ren field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_size.dta", replace

*All Agricultural Land
use "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta", clear
ren plotid plot_id
gen agland = (s11b1q27==1 | s11b1q28==1 | s11b1q28==6) // Cultivated, fallow, or pasture
merge m:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_cultivated.dta", nogen keep(1 3)
preserve 
use "${Nigeria_GHS_W3_raw_data}/sect11f_plantingw3.dta", clear
gen cultivated = 1 if (s11fq7!=. & s11fq7!=0) |  (s11fq11a!=. & s11fq11a!=0)
collapse (max) cultivated, by (hhid plotid)
ren plotid plot_id
tempfile tree
save `tree', replace
restore
append using `tree'
replace agland=1 if cultivated==1
keep if agland==1
collapse (max) agland, by (hhid plot_id)
keep hhid plot_id agland
lab var agland "1= Plot was cultivated, left fallow, or used for pasture"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_agland.dta", replace

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_agland.dta", nogen
keep if agland==1
collapse (sum) field_size, by (hhid)
ren field_size farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmsize_all_agland.dta", replace

*Total land holding including cultivated and rented out
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", clear
collapse (sum) field_size, by (hhid)
ren field_size land_size_total
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_size_total.dta", replace

********************************************************************************
*LAND SIZE
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta", clear
ren plotid plot_id
gen rented_out = 1 if s11b1q29==2015
drop if rented_out==1
gen plot_held=1
keep hhid plot_id plot_held
lab var plot_held "1= Plot was NOT rented out in 2015"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_held.dta", replace

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_parcels_held.dta", nogen
keep if plot_held==1
collapse (sum) field_size, by (hhid)
ren field_size land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_size_all.dta", replace 


********************************************************************************
*FARM LABOR
********************************************************************************
//ALT 05.06.21: Replaced in crop expenses - recreating the file here for the sake of continuity.
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_labor_long.dta", clear
drop if strmatch(gender,"all")
ren days labor_
collapse (sum) labor_, by(hhid labor_type gender)
reshape wide labor_, i(hhid gender) j(labor_type) string
drop if strmatch(gender,"")
ren labor* labor*_
reshape wide labor*, i(hhid) j(gender) string
egen labor_total=rowtotal(labor*)
egen labor_hired = rowtotal(labor_hired*)
egen labor_family = rowtotal(labor_family*)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"		
lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"		
keep hhid labor_total labor_hired labor_family labor_hired_male labor_hired_female
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_family_hired_labor.dta", replace


********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta", clear
gen vac_animal= s11iq22>=1 & s11iq1==1
replace  vac_animal=. if animal_cd==121 | animal_cd==123 // other categories includes essentially dogsa and cats and other animals for which vaccination is not relevant
replace vac_animal = . if s11iq1==2 | s11iq1==. //missing if the household did now own any of these types of animals 
*disagregating vaccine usage by animal type 
ren animal_cd livestock_code
gen species = (inlist(livestock_code,101,102,103,104,105,106,107)) + 2*(inlist(livestock_code,110,111)) + 3*(livestock_code==112) + 4*(inlist(livestock_code,108,109,122)) + 5*(inlist(livestock_code,113,114,115,116,117,118,120))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species
*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) vac_animal*, by (hhid)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_vaccine.dta", replace
 
use "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta", clear
gen all_vac_animal=s11iq22>=1 & s11iq1==1
replace  all_vac_animal=. if animal_cd==121 | animal_cd==123 // other categories includes essentially dogsa and cats and other animals for which vaccination is not relevant
replace all_vac_animal = . if s11iq1==2 | s11iq1==. //missing if the household did now own any of these types of animals 
preserve
keep hhid s11iq5a all_vac_animal 
ren s11iq5a farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid  s11iq5b  all_vac_animal 
ren s11iq5b farmerid
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen
keep hhid farmerid all_vac_animal indiv female age
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmer_vaccine.dta", replace

********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta", clear
gen disease_animal = 1 if s11iq20==1
replace disease_animal = 0 if s11iq20==2
gen disease_fmd = (s11iq21a==4 | s11iq21c==4 )
gen disease_lump = (s11iq21a==5 | s11iq21c==5 )
gen disease_bruc = (s11iq21a==7 | s11iq21c==7 )
gen disease_cbpp = (s11iq21a==9 | s11iq21c==9 )
gen disease_bq = (s11iq21a==6 | s11iq21c==6 )
ren animal_cd livestock_code
gen species = (inlist(livestock_code,101,102,103,104,105,106,107)) + 2*(inlist(livestock_code,110,111)) + 3*(livestock_code==112) + 4*(inlist(livestock_code,108,109,122)) + 5*(inlist(livestock_code,113,114,115,116,117,118,120))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species
*A loop to create species variables
foreach i in disease_animal disease_fmd disease_lump disease_bruc disease_cbpp disease_bq{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) disease_*, by (hhid)
lab var disease_animal "1= Household has animal that suffered from disease"
lab var disease_fmd "1= Household has animal that suffered from foot and mouth disease"
lab var disease_lump "1= Household has animal that suffered from lumpy skin disease"
lab var disease_bruc "1= Household has animal that suffered from black quarter"
lab var disease_cbpp "1= Household has animal that suffered from brucelosis"
lab var disease_bq "1= Household has animal that suffered from black quarter"
foreach i in disease_animal disease_fmd disease_lump disease_bruc disease_cbpp disease_bq{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_diseases.dta", replace


********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
**cannot construct

********************************************************************************
* PLOT MANAGERS *
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.


use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
keep ea hhid plot_id crop_code use_imprv_seed use_hybrid_seed
merge m:1 ea hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_input_quantities.dta", nogen
foreach i in inorg_fert org_fert pest herb {
	recode `i'_kg (.=0)
	gen use_`i'= `i'_kg > 0
}
collapse (max) use*, by(hhid plot_id crop_code)
recode use* (.=0)
preserve 
keep hhid plot_id crop_code use_imprv_seed use_hybrid_seed
ren use_imprv_seed imprv_seed_
ren use_hybrid_seed hybrid_seed_
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_imprvseed_crop.dta",replace 
restore 


merge m:m hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_dm_ids.dta", nogen keep(1 3)
preserve
ren use_imprv_seed all_imprv_seed_
ren use_hybrid_seed all_hybrid_seed_
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmer_improvedseed_use.dta", replace
restore

collapse (max) use_*, by(hhid indiv female)
gen all_imprv_seed_use = use_imprv_seed //Legacy
//Temp code to get the values out faster
/*	collapse (max) use_*, by(hhid)
	merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(3)
	recode use* (.=0)
	collapse (mean) use* [aw=weight_pop_rururb] */
//Legacy files, replacing the code below.

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_hybrid_seed use_org_fert use_pest use_herb, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_herb "1 = household uses herbicide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	la var use_hybrid_seed "1=household uses hybrid seeds"
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if indiv!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore


********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************

*Extension
use "${Nigeria_GHS_W3_raw_data}/sect11l1_plantingw3.dta", clear
ren s11l1q1 receive_advice
ren s11l1q2 sourceid
ren s11l1q2_os sourceid_other
preserve
use "${Nigeria_GHS_W3_raw_data}/secta5a_harvestw3.dta", clear
ren sa5aq1 receive_advice
ren sa5aq2 sourceid
ren sa5aq2b sourceid_other
tempfile advie_ph
save `advie_ph'
restore
append using `advie_ph'

// NKF 11.6.20 Breaking down by each specific type of extension, combining all non-peer sources to "advice_all"
**Government Extension
gen advice_gov_ag = ((sourceid==1 ) & receive_advice==1)
gen advice_gov_fish = ((sourceid==3) & receive_advice==1)
**private Extension
gen advice_private = (sourceid==2 & receive_advice==1)
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1)
**Fishing Co-iop
gen advice_fish_coop = (sourceid==6 & receive_advice==1)
**Farmer field day
gen advice_field_day = (sourceid==7 & receive_advice==1)
*Village ag extension
gen advice_village_ag_ext = (sourceid==8 & receive_advice==1)
**Ag extension course
gen advice_ag_ext_course = (sourceid==9 & receive_advice==1)
**Leader farmer
gen advice_lead_farmer = (sourceid==10 & receive_advice==1)
**Peer farmer
gen advice_peer_farmer = (sourceid==11 & receive_advice==1)
**Radio
gen advice_media = (sourceid==12 & receive_advice==1)
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1)
**Other
gen advice_other = ((sourceid==14)  & receive_advice==1)

*DYA.04.26.2022 added here
*gen ext_reach_all=(advice_gov==1 | advice_ngo==1 | advice_coop==1 | advice_media==1  | advice_pub==1)
gen ext_reach_public=(advice_gov_ag==1 & advice_gov_fish==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1)
gen ext_reach_unspecified=(advice_media==1 | advice_pub==1 | advice_other==1)
gen ext_reach_ict=(advice_media==1)

*End

*Advice All // BT 11.24.20 added in lead farmers and peer farmers as sources (sourceid = 10 or 11)
gen advice_all = ((sourceid==1 | sourceid==2 | sourceid==3 | sourceid==4 | sourceid==5 | sourceid==6 | sourceid==7 | sourceid==8 | sourceid==9 | sourceid==10 | sourceid==11| sourceid==12 | sourceid==13 | sourceid==14 )  & receive_advice==1)

preserve
use "${Nigeria_GHS_W3_raw_data}/sect11e_plantingw3.dta", clear
gen seed_ext_advice=0
replace seed_ext_advice=1 if (s11eq7==2 | s11eq7==3 | s11eq7==4) // BT 11.24.20 adding in if farmer recieved advice from input supplier or fellow farmer
tempfile advie_seed
save `advie_seed'
restore
append using `advie_seed'
replace advice_all=1 if seed_ext_advice==1 & advice_all==0 

// NKF 11.6.20 - There's supposed to be a question on fertilizer use + extension officer in PH Sect 11D Q5, but I'm not seeing it in .dta

collapse (max) advice_* , by (hhid)
ren advice_all ext_reach_all
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_any_ext.dta", replace 															   
********************************************************************************
* MOBILE PHONE OWNERSHIP *
********************************************************************************
*BET 03.25.2021

use "${Nigeria_GHS_W3_raw_data}/sect5_plantingw3.dta", clear
append using "${Nigeria_GHS_W3_raw_data}/sect4b_plantingw3.dta"
//recode missing to 0 in s5q1 (0 mobile owned if missing)
recode s5q1 s4bq10  (.=0) //DYA.11.13.2020  adding s5q10 which is also relevant to mobile phone
gen  hh_number_mobile_owned_pp=s5q1 if item_cd==332 // number mobile phones owned post planting
gen  hh_number_mobile_owned_ph=s4bq10   // number mobile phones owned post harvest
recode hh_number_mobile_owned* (.=0)
gen mobile_owned=hh_number_mobile_owned_pp>0 |  hh_number_mobile_owned_ph>0
collapse (max) mobile_owned, by(hhid)


save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_mobile_own.dta", replace

********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect4a_plantingw3.dta", clear
append using "${Nigeria_GHS_W3_raw_data}/sect4b_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect4c1_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect4c2_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect4c3_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect9_harvestw3.dta"
gen use_bank_acount=s4aq1==1
gen use_bank_other=s4bq10b==1 | ((s9q17==1 |  s9q18==1) &( s9q19a==1 |  s9q19b==1))
gen use_saving=s4aq8==1 //ALT 03.25.20: Swapped out existing code with "did you use a cooperative?"
gen use_MM=s4bq10b==1  & s4bq10!=0 & s4bq10!=. 
gen formal_loan=1 if (s4cq2b==3 | s4cq2b==4) & s4cq8!=.
gen rec_loan=formal_loan==1
gen use_credit_selfemp= (s9q17==1 |  s9q18==1) &( s9q19a==1 |  s9q19b==1)
gen use_insur=s4aq16==1
gen use_fin_serv_bank= use_bank_acount==1
gen use_fin_serv_credit= use_credit_selfemp==1 | rec_loan==1   
gen use_fin_serv_insur= use_insur==1
gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= use_saving==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 |  use_fin_serv_others==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fin_serv.dta", replace 

 
********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_products", clear
keep if livestock_code == 1 & quantity_produced!=0
replace quantity_produced_unit = 3 if livestock_code==1 & (quantity_produced_unit==1 | quantity_produced_unit==70 | quantity_produced_unit==81  | quantity_produced_unit==80 | quantity_produced_unit==191)
replace quantity_produced = quantity_produced/100 if quantity_produced_unit==4
replace quantity_produced_unit = 3 if quantity_produced_unit==4
gen milk_quantity_produced = quantity_produced
gen milk_months_produced = months_produced
drop if quantity_produced_unit==.
replace milk_quantity_produced = milk_quantity_produced*50 if quantity_produced_unit==193	
drop if quantity_produced_unit==11 | quantity_produced_unit==30 | quantity_produced_unit==31 | quantity_produced_unit==71 | quantity_produced_unit==91 | quantity_produced_unit==150 //Odd units that we don't have a conversion factor for
collapse (sum) milk_months_produced milk_quantity_produced , by (hhid)
drop if hhid==170004 | hhid==310104 //ALT 02.18.21: With weights, these two households individually produced more milk than the rest of the country combined; probably an issue with units
la var milk_months_produced "Number of months that the household produced milk"		
la var milk_quantity_produced "Average quantity of milk produced per month - liters"		 
drop if milk_months_produced==0 | milk_quantity_produced==0
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_livestock_products", clear
keep if livestock_code==2 & quantity_produced!=0
replace quantity_produced_unit = 80 if livestock_code==2 & (quantity_produced_unit==70 | quantity_produced_unit==82 | quantity_produced_unit==90 | quantity_produced_unit==191 /*
*/ | quantity_produced_unit==141 | quantity_produced_unit==160 | quantity_produced_unit==3 | quantity_produced_unit==1)
gen eggs_quantity_produced = quantity_produced
gen eggs_months_produced = months_produced
drop if quantity_produced_unit==.
collapse (sum) eggs_months_produced eggs_quantity_produced, by (hhid)
drop if eggs_months_produced==0 | eggs_quantity_produced==0
*ren qty_animals poultry_owned // HKS 6.18.23: commenting out because it yields error; poultry_owned doesn't exist							 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_egg_animals.dta", replace


********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
*All the preprocessing is done in the crop expenses section
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid plot_id purestand field_size)
reshape long ha_, i(hhid plot_id purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(hhid plot_id dm_gender exp)
reshape wide cost_, i(hhid plot_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge 1:m hhid plot_id using `plot_areas', nogen keep(3)
//reshape long cost_, i(hhid plot_id dm_gender) j(exp) string
//replace cost_ = cost_/ha_
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(hhid dm_gender area_type)
gen dm_gender2="unknown"
replace dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(hhid dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropcosts.dta", replace

********************************************************************************
* RATE OF FERTILIZER APPLICATION *
********************************************************************************
//ALT 08.04.21: Added in org fert, herbicide, and pesticide; additional coding needed to integrate these into summary stats
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
collapse (sum) ha_planted, by(ea hhid plot_id dm_gender)
merge 1:1 ea hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_input_quantities.dta", nogen keep(1 3) //11 plots have expenses but don't show up in the all_plots roster.
drop if ha_planted==0
recode *kg (.=0)
//ren *_rate *_kg_
gen dm_gender2="unknown"
replace dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
unab vars : *_kg
ren *kg *kg_
ren ha_planted ha_planted_
reshape wide *_, i(hhid plot_id) j(dm_gender2) string
collapse (sum) *kg* ha_planted_*, by(hhid)

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}

//Some high inorg fert rates as a result of large tonnages on small plots. 
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
lab var npk_kg "NPK fertilizer (kgs) for household"
lab var n_kg "Units of Nitrogen (kgs) for household"
lab var p_kg "Units of Phosphorus (kgs) for household"
lab var k_kg "Units of Potassium (kgs) for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var urea_kg "Urea (kgs) for `i'-managed plots"
lab var npk_kg "NPK fertilizer (kgs) for `i'-managed plots"
lab var n_kg "Units of Nitrogen (kgs) for `i'-managed plots"
lab var p_kg "Units of Phosphorus (kgs) for `i'-managed plots"
lab var k_kg "Units of Potassium (kgs) for `i'-managed plots"
}

save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
* since the diet variable is available in both PP and PH datasets, we first append the two together
use "${Nigeria_GHS_W3_raw_data}/sect7b_plantingw3.dta" , clear
keep zone state lga sector ea hhid item_cd item_desc s7bq1
gen survey="PP"
preserve
use "${Nigeria_GHS_W3_raw_data}/sect10b_harvestw3.dta" , clear
keep zone state lga sector ea hhid item_cd item_desc s10bq1
ren  s10bq1  s7bq1 // ren the variable indicating household consumption of food items to harminize accross data set
gen survey="PH"
tempfile diet_ph
save `diet_ph'
restore 
append using `diet_ph'
* We recode food items to map to India food groups used as reference
recode item_cd 	    (10 11 13 14 16 19 20/23 25 28   		=1	"CEREALS")  ///
					(17 18 30/38    						=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")  ///
					(78  70/77 79	 						=3	"VEGETABLES")  ///
					( 60/69 145/147 601						=4	"FRUITS")  ///
					(80/82 90/96 29 						=5	"MEAT")  ///
					(83/85									=6	"EGGS")  ///
					(100/107  								=7  "FISH") ///
					(43/48 40/42   							=8  "LEGUMES, NUTS AND SEEDS") ///
					(110/115								=9	"MILK AND MILK PRODUCTS")  ///
					(50/56   								=10	"OILS AND FATS")  ///
					(26 27 130/133 121 152/155				=11	"SWEETS")  ///
					(76 77 140/144 120 122 150 151 160/164	=12	"SPICES, CONDIMENTS, BEVERAGES"	) ///
					(150 151 								=. ) ///
					,generate(Diet_ID)			
gen adiet_yes=(s7bq1==1)
ta Diet_ID   
** Now, we collapse to food group level assuming that if an a household consumes at least one food item in a food group,
* then he has consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(hhid survey Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid survey )
collapse (mean) adiet_yes, by(hhid )
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS. 
Can use either cut-off or 6 (=12/2) or cut-off=mean(socore) 
*/
ren adiet_yes number_foodgroup 
local cut_off1=6
sum number_foodgroup
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2') 
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week - average PP and PH"
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2PP' of the 12 food groups last week - average PP and PH"
label var number_foodgroup "Number of food groups individual consumed last week HDDS="
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_household_diet.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Inmost cases, NGA LSMS 3 lsit the first TWO decision makers.
*Indicator may be biased downward if some women would participate in decisions about the use of income
*but are not listed among the first two

/*
Areas of decision making to be considered
Decision-making areas
*	Control over crop production income
*	Control over livestock production income
*	Control over fish production income
*	Control over farm (all) production income
*	Control over wage income
*	Control over business income
*	Control over nonfarm (all) income
*	Control over (all) income
*/
* First append all files with information on who control various types of income
use "${Nigeria_GHS_W3_raw_data}/secta3i_harvestw3", clear
append using "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestw3"
append using "${Nigeria_GHS_W3_raw_data}/secta8_harvestw3"
append using "${Nigeria_GHS_W3_raw_data}/sect11k_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/secta8_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect11k_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect9_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect3_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect3_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect13_harvestw3.dta"
gen type_decision="" 
gen controller_income1=.
gen controller_income2=.
* control of harvest from annual crops
replace type_decision="control_annualharvest" if  !inlist( sa3iq6e1, .,0,99, 98) |  !inlist( sa3iq6e2, .,0,99, 98) 
replace controller_income1=sa3iq6e1 if !inlist(sa3iq6e1, .,0,99, 98)  
replace controller_income2=sa3iq6e2 if !inlist(sa3iq6e2, .,0,99, 98)
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( sa3iiq9a, .,0,99, 98) |  !inlist( sa3iiq9b, .,0,99, 98) 
replace controller_income1=sa3iiq9a if !inlist( sa3iiq9a, .,0,99, 98)  
replace controller_income2=sa3iiq9b if !inlist( sa3iiq9b, .,0,99, 98)
* append who controls earning from sale to customer 2
preserve
replace type_decision="control_annualsales" if  !inlist( sa3iiq23a, .,0,99, 98) |  !inlist( sa3iiq23b, .,0,99, 98) 
replace controller_income1=sa3iiq23a if !inlist( sa3iiq23a, .,0,99, 98)  
replace controller_income2=sa3iiq23b if !inlist( sa3iiq23b, .,0,99, 98)
keep if !inlist(sa3iiq23a, .,0,99, 98) |  !inlist(sa3iiq23b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_annualsales2
save `control_annualsales2'
restore
append using `control_annualsales2'  
* control_processedsales (both in PP and PH)
replace type_decision="control_processedsales" if ( !inlist( sa8q8a, .,0,99, 98) |  !inlist( sa8q8b, .,0,99, 98))   
replace controller_income1=sa8q8a if !inlist( sa8q8a, .,0,99, 98)  
replace controller_income2=sa8q8b if !inlist( sa8q8b, .,0,99, 98)  
* append who control earning from sales of processed crops PHs 
preserve
replace type_decision="control_processedsales" if ( !inlist( s11kq7a, .,0,99, 98) |  !inlist( s11kq7b, .,0,99, 98) )   
replace controller_income1=s11kq7a if !inlist( s11kq7a, .,0,99, 98)   
replace controller_income2=s11kq7b if !inlist( s11kq7b, .,0,99, 98)  
keep if (!inlist(s11kq7a, .,0,99, 98) |  !inlist(s11kq7b, .,0,99, 98)) 
keep hhid type_decision controller_income1 controller_income2
tempfile control_processedsales2
save `control_processedsales2'
restore
append using `control_processedsales2' 
* control_livestocksales
replace type_decision="control_livestocksales" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98) 
replace controller_income1=s11iq4a if !inlist(s11iq4a, .,0,99, 98)  
replace controller_income2=s11iq4b if !inlist(s11iq4b, .,0,99, 98)
* control_otherlivestock_sales (both in PP and PH)
replace type_decision="control_otherlivestock_sales" if ( !inlist( sa8q8a, .,0,99, 98) |  !inlist( sa8q8b, .,0,99, 98))  &  !inlist(byprod_cd, 6,7,8)
replace controller_income1=sa8q8a if !inlist( sa8q8a, .,0,99, 98)   &  !inlist(byprod_cd, 6,7,8)
replace controller_income2=sa8q8b if !inlist( sa8q8b, .,0,99, 98) &  !inlist(byprod_cd, 6,7,8)
* append who controle earning from sales of processed crops PHs 
preserve
replace type_decision="control_otherlivestock_sales" if ( !inlist( s11kq7a, .,0,99, 98) |  !inlist( s11kq7b, .,0,99, 98) )  &  !inlist(byprod_cd, 6,7,8)
replace controller_income1=s11kq7a if !inlist( s11kq7a, .,0,99, 98)   &  !inlist(byprod_cd, 6,7,8)
replace controller_income2=s11kq7b if !inlist( s11kq7b, .,0,99, 98)  &  !inlist(byprod_cd, 6,7,8)
keep if (!inlist(s11kq7a, .,0,99, 98) |  !inlist(s11kq7b, .,0,99, 98)) &  !inlist(byprod_cd, 6,7,8)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherlivestock_sales2
save `control_otherlivestock_sales2'
restore
append using `control_otherlivestock_sales2' 
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( s9q5a1, .,0,99, 98) |  !inlist( s9q5a2, .,0,99, 98) 
replace controller_income1=s9q5a1 if !inlist( s9q5a1, .,0,99, 98)  
replace controller_income2=s9q5a2 if !inlist( s9q5a2, .,0,99, 98)
* append who controle earning 
preserve
replace type_decision="control_businessincome" if  !inlist( s9q5b1, .,0,99, 98) |  !inlist( s9q5b2, .,0,99, 98) 
replace controller_income1=s9q5b1 if !inlist( s9q5b1, .,0,99, 98)  
replace controller_income2=s9q5b2 if !inlist( s9q5b2, .,0,99, 98)
keep if !inlist(s9q5b1, .,0,99, 98) |  !inlist(s9q5b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_businessincome2
save `control_businessincome2'
restore
append using `control_businessincome2' 
* control_wageincome
replace type_decision="control_wageincome" if  !inlist( s3q22a, .,0,99, 98) |  !inlist( s3q22b, .,0,99, 98) 
replace controller_income1=s3q22a if !inlist( s3q22a, .,0,99, 98)  
replace controller_income2=s3q22b if !inlist( s3q22b, .,0,99, 98)
* append who controle earning 
preserve
replace type_decision="control_wageincome" if  !inlist( s3q35a, .,0,99, 98) |  !inlist( s3q35b, .,0,99, 98) 
replace controller_income1=s3q35a if !inlist( s3q35a, .,0,99, 98)  
replace controller_income2=s3q35b if !inlist( s3q35b, .,0,99, 98)
keep if !inlist(s3q35a, .,0,99, 98) |  !inlist(s3q35b, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_wageincome2
save `control_wageincome2'
restore
append using `control_wageincome2'
* control_otherincome
replace type_decision="control_otherincome" if  !inlist( s13q2b1, .,0,99, 98) |  !inlist( s13q2b2, .,0,99, 98) 
replace controller_income1=s13q2b1 if !inlist( s13q2b1, .,0,99, 98)  
replace controller_income2=s13q2b2 if !inlist( s13q2b2, .,0,99, 98)
* append who controle other income 2 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q5b1, .,0,99, 98) |  !inlist( s13q5b2, .,0,99, 98) 
replace controller_income1=s13q5b1 if !inlist( s13q5b1, .,0,99, 98)  
replace controller_income2=s13q5b2 if !inlist( s13q5b2, .,0,99, 98)
keep if !inlist(s13q5b1, .,0,99, 98) |  !inlist(s13q5b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome2
save `control_otherincome2'
restore
* append who controle other income 3 
preserve
replace type_decision="control_otherincome" if  !inlist( s13q8b1, .,0,99, 98) |  !inlist( s13q8b2, .,0,99, 98) 
replace controller_income1=s13q8b1 if !inlist( s13q8b1, .,0,99, 98)  
replace controller_income2=s13q8b2 if !inlist( s13q8b2, .,0,99, 98)
keep if !inlist(s13q8b1, .,0,99, 98) |  !inlist(s13q8b2, .,0,99, 98)
keep hhid type_decision controller_income1 controller_income2
tempfile control_otherincome3
save `control_otherincome3'
restore
append using `control_otherincome2'
append using `control_otherincome3'
keep hhid type_decision controller_income1 controller_income2
preserve
keep hhid type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep hhid type_decision controller_income1
drop if controller_income1==.
ren controller_income1 controller_income
append using `controller_income2' 
* Create group
gen control_cropincome=1 if  type_decision=="control_harvest" ///
							| type_decision=="control_cropsales" ///
							| type_decision=="control_processedsales" 
recode 	control_cropincome (.=0)								
gen control_livestockincome=1 if  type_decision=="control_livestocksales" ///
							| type_decision=="control_otherlivestock_sales" 							
recode 	control_livestockincome (.=0)
gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)								
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)
													
gen control_wageincome=1 if  type_decision=="control_wageincome" 
recode 	control_wageincome (.=0)											
gen control_nonfarmincome=1 if  type_decision=="control_otherincome" ///
							  | control_businessincome== 1 | control_wageincome==1
recode 	control_nonfarmincome (.=0)															
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
* Now merge with member characteristics
* Using gender from planting and harvesting sections
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_control_income.dta", replace


********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
********************************************************************************
* Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
* can report on % of women who make decisions, taking total number of women HH members as denominator
* In most cases, NGA LSMS 3 lists the first TWO decision makers.
* Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
* planting_input	
use "${Nigeria_GHS_W3_raw_data}/sect11a1_plantingw3.dta", clear
append using "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta" 
append using "${Nigeria_GHS_W3_raw_data}/sect11e_plantingw3.dta" 
append using "${Nigeria_GHS_W3_raw_data}/secta1_harvestw3.dta" 
append using "${Nigeria_GHS_W3_raw_data}/secta11d_harvestw3.dta" 
append using "${Nigeria_GHS_W3_raw_data}/secta3i_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/secta3ii_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/secta8_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect11k_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/secta8_harvestw3.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
* planting_input - manage plot
replace type_decision="planting_input" if  !inlist( s11aq6a, .,0,99, 98) |  !inlist( s11aq6b, .,0,99, 98)   
replace decision_maker1=s11aq6a if !inlist( s11aq6a, .,0,99, 98)  
replace decision_maker2=s11aq6b if !inlist( s11aq6b, .,0,99, 98)
* append who make decision about plot
preserve
replace type_decision="planting_input" if  !inlist( s11b1q12a, .,0,99, 98) |  !inlist( s11b1q12b, .,0,99, 98) |  !inlist( s11b1q12c, .,0,99, 98) 
replace decision_maker1=s11b1q12a if !inlist( s11b1q12a, .,0,99, 98)  
replace decision_maker2=s11b1q12b if !inlist( s11b1q12b, .,0,99, 98)
replace decision_maker2=s11b1q12c if !inlist( s11b1q12c, .,0,99, 98)
keep if  !inlist( s11b1q12a, .,0,99, 98) |  !inlist( s11b1q12b, .,0,99, 98) |  !inlist( s11b1q12c, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input2
save `planting_input2'
restore
append using `planting_input2'  
* append who make decision about plot (others2)
preserve
replace type_decision="planting_input" if  !inlist( s11b1q16b1, .,0,99, 98) |  !inlist( s11b1q16b2, .,0,99, 98) 
replace decision_maker1=s11b1q16b1 if !inlist( s11b1q16b1, .,0,99, 98)  
replace decision_maker2=s11b1q16b2 if !inlist( s11b1q16b2, .,0,99, 98)
keep if  !inlist( s11b1q16b1, .,0,99, 98) |  !inlist( s11b1q16b2, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input3
save `planting_input3'
restore
append using `planting_input3'  
* append who make decision about input (chose seed)
preserve
replace type_decision="planting_input" if  !inlist( s11eq15a, .,0,99, 98) |  !inlist( s11eq15b, .,0,99, 98) 
replace decision_maker1=s11eq15a if !inlist( s11eq15a, .,0,99, 98)  
replace decision_maker2=s11eq15b if !inlist( s11eq15b, .,0,99, 98)
keep if  !inlist( s11eq15a, .,0,99, 98) |  !inlist( s11eq15b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input4
save `planting_input4'
restore
append using `planting_input4'  
* append who make decision about input (paid seed)
preserve
replace type_decision="planting_input" if  !inlist( s11eq27a, .,0,99, 98) |  !inlist( s11eq27b, .,0,99, 98) 
replace decision_maker1=s11eq27a if !inlist( s11eq27a, .,0,99, 98)  
replace decision_maker2=s11eq27b if !inlist( s11eq27b, .,0,99, 98)
keep if  !inlist( s11eq27a, .,0,99, 98) |  !inlist( s11eq27b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input5
save `planting_input5'
restore
append using `planting_input5'   
* append who make decision about input (manage plot)
preserve
replace type_decision="planting_input" if  !inlist( sa1q11, .,0,99, 98) |  !inlist( sa1q11b, .,0,99, 98) 
replace decision_maker1=sa1q11 if !inlist( sa1q11, .,0,99, 98)  
replace decision_maker2=sa1q11b if !inlist( sa1q11b, .,0,99, 98)
keep if  !inlist( sa1q11, .,0,99, 98) |  !inlist( sa1q11b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input6
save `planting_input6'
restore
append using `planting_input6'
* append who make decision about (owner plot)  
preserve
replace type_decision="planting_input" if  !inlist( sa1q14, .,0,99, 98) |  !inlist( sa1q14b, .,0,99, 98) 
replace decision_maker1=sa1q14 if !inlist( sa1q14, .,0,99, 98)  
replace decision_maker2=sa1q14b if !inlist( sa1q14b, .,0,99, 98)
keep if  !inlist( sa1q14, .,0,99, 98) |  !inlist( sa1q14b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input7
save `planting_input7'
restore
append using `planting_input7'
* append who make decision about plot (decsision maker)  
preserve
replace type_decision="planting_input" if  !inlist( sa1q22a, .,0,99, 98) |  !inlist( sa1q22b, .,0,99, 98)  |  !inlist( sa1q22c, .,0,99, 98) |  !inlist( sa1q22d, .,0,99, 98)
replace decision_maker1=sa1q22a if !inlist( sa1q22a, .,0,99, 98)  
replace decision_maker2=sa1q22b if !inlist( sa1q22b, .,0,99, 98)
replace decision_maker1=sa1q22c if !inlist( sa1q22c, .,0,99, 98)  
replace decision_maker2=sa1q22d if !inlist( sa1q22d, .,0,99, 98)
keep if  !inlist( sa1q22a, .,0,99, 98) |  !inlist( sa1q22b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input8
save `planting_input8'
restore
append using `planting_input8'
* append who make decision about plot (manage)
preserve
replace type_decision="planting_input" if  !inlist( sa1q24a, .,0,99, 98) |  !inlist( sa1q24b, .,0,99, 98) |  !inlist( sa1q24c, .,0,99, 98) 
replace decision_maker1=sa1q24a if !inlist( sa1q24a, .,0,99, 98)  
replace decision_maker2=sa1q24b if !inlist( sa1q24b, .,0,99, 98)
replace decision_maker2=sa1q24c if !inlist( sa1q24c, .,0,99, 98)
keep if  !inlist( sa1q24a, .,0,99, 98) |  !inlist( sa1q24b, .,0,99, 98) |  !inlist( sa1q24c, .,0,99, 98) 
keep hhid type_decision decision_maker*
tempfile planting_input9
save `planting_input9'
restore
append using `planting_input9'  
* append who make decision about input (fertilizer)  
preserve
replace type_decision="planting_input" if  !inlist( s11dq25a, .,0,99, 98) |  !inlist( s11dq25b, .,0,99, 98) 
replace decision_maker1=s11dq25a if !inlist( s11dq25a, .,0,99, 98)  
replace decision_maker2=s11dq25b if !inlist( s11dq25b, .,0,99, 98)
keep if  !inlist( s11dq25a, .,0,99, 98) |  !inlist( s11dq25b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile planting_input10
save `planting_input10'
restore
append using `planting_input10'
* sales_crop
replace type_decision="sales_crop" if  !inlist( sa3iiq8a, .,0,99, 98) |  !inlist( sa3iiq8b, .,0,99, 98)  
replace decision_maker1=sa3iiq8a if !inlist( sa3iiq8a, .,0,99, 98)  
replace decision_maker2=sa3iiq8b if !inlist( sa3iiq8b, .,0,99, 98)
* sales_processcrop
replace type_decision="sales_processcrop" if  (!inlist( sa8q7a, .,0,99, 98) |  !inlist( sa8q7b, .,0,99, 98))  & inlist(byprod_cd, 6,7,8)
replace decision_maker1=sa8q7a if !inlist( sa8q7a, .,0,99, 98)  & inlist(byprod_cd, 6,7,8) 
replace decision_maker2=sa8q7b if !inlist( sa8q7b, .,0,99, 98)  & inlist(byprod_cd, 6,7,8)
* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98)  
replace decision_maker1=s11iq4a if !inlist( s11iq4a, .,0,99, 98)  
replace decision_maker2=s11iq4b if !inlist( s11iq4b, .,0,99, 98)
* Append who make decision about plot
preserve
replace type_decision="livestockowners" if  !inlist( s11iq5a, .,0,99, 98) |  !inlist( s11iq5b, .,0,99, 98) 
replace decision_maker1=s11iq5a if !inlist( s11iq5a, .,0,99, 98)  
replace decision_maker2=s11iq5b if !inlist( s11iq5b, .,0,99, 98)
keep if  !inlist( s11iq5a, .,0,99, 98) |  !inlist( s11iq5b, .,0,99, 98)  
keep hhid type_decision decision_maker*
tempfile livestockowners2
save `livestockowners2'
restore
append using `livestockowners2'  
* otherlivestock_sales
replace type_decision="otherlivestock_sales" if  (!inlist( sa8q7a, .,0,99, 98) |  !inlist( sa8q7b, .,0,99, 98))  & !inlist(byprod_cd, 6,7,8)
replace decision_maker1=sa8q7a if !inlist( sa8q7a, .,0,99, 98)   & !inlist(byprod_cd, 6,7,8)
replace decision_maker2=sa8q7b if !inlist( sa8q7b, .,0,99, 98)  & !inlist(byprod_cd, 6,7,8)
keep hhid type_decision decision_maker1 decision_maker2  
preserve
keep hhid type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore
keep hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
*	Create group
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_crop" ///
							| type_decision=="sales_processcrop"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners" | type_decision=="otherlivestock_sales" 
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv 
*	Now merge with member characteristics
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", nogen
recode make_decision_* (.=0)
keep make_decision_crop make_decision_livestock make_decision_ag female age  hhid indiv
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_make_ag_decision.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* In most cases, NGA LSMS 3 as the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${Nigeria_GHS_W3_raw_data}/sect11b1_plantingw3.dta", clear
append using "${Nigeria_GHS_W3_raw_data}/sect11e_plantingw3.dta" 
append using "${Nigeria_GHS_W3_raw_data}/secta1_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect11i_plantingw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/secta4_harvestw3.dta"
append using "${Nigeria_GHS_W3_raw_data}/sect5_plantingw3.dta"
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=. 
gen asset_owner3=. 
gen asset_owner4=. 
* Ownership of land.
replace type_asset="landowners" if  !inlist( s11b1q6a, .,0,99, 98) |  !inlist( s11b1q6b, .,0,99, 98) 
replace asset_owner1=s11b1q6a if !inlist( s11b1q6a, .,0,99, 98)  
replace asset_owner2=s11b1q6b if !inlist( s11b1q6b, .,0,99, 98)
replace type_asset="landowners" if  !inlist( sa1q14, .,0,99, 98) |  !inlist( sa1q14b, .,0,99, 98) 
replace asset_owner1=sa1q14 if !inlist( sa1q14, .,0,99, 98)  
replace asset_owner2=sa1q14b if !inlist( sa1q14b, .,0,99, 98)
* append who hss right to sell or use
preserve
replace type_asset="landowners" if  !inlist( s11b1q22a, .,0,99, 98) |  !inlist( s11b1q22b, .,0,99, 98)  |  !inlist( s11b1q22c, .,0,99, 98)
replace asset_owner1=s11b1q22a if !inlist( s11b1q22a, .,0,99, 98)  
replace asset_owner2=s11b1q22b if !inlist( s11b1q22b, .,0,99, 98)
replace asset_owner3=s11b1q22c if !inlist( s11b1q22c, .,0,99, 98)
replace type_asset="landowners" if  !inlist( sa1q18a, .,0,99, 98) |  !inlist( sa1q18b, .,0,99, 98)  |  !inlist( sa1q18c, .,0,99, 98)
replace asset_owner1=sa1q18a if !inlist( sa1q18a, .,0,99, 98)  
replace asset_owner2=sa1q18b if !inlist( sa1q18b, .,0,99, 98)
replace asset_owner3=sa1q18c if !inlist( sa1q18c, .,0,99, 98)
keep if  !inlist( s11b1q22a, .,0,99, 98) |  !inlist( s11b1q22b, .,0,99, 98)  |  !inlist( s11b1q22c, .,0,99, 98) |  !inlist( sa1q18a, .,0,99, 98) |  !inlist( sa1q18b, .,0,99, 98)  |  !inlist( sa1q18c, .,0,99, 98)
keep hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  
* Append who has title
preserve
replace type_asset="landowners" if  !inlist( s11b1q8b1, .,0,99, 98) |  !inlist( s11b1q8b2, .,0,99, 98)  |  !inlist( s11b1q8b3, .,0,99, 98)
replace asset_owner1=s11b1q8b1 if !inlist( s11b1q8b1, .,0,99, 98)  
replace asset_owner2=s11b1q8b2 if !inlist( s11b1q8b2, .,0,99, 98)
replace asset_owner3=s11b1q8b3 if !inlist( s11b1q8b3, .,0,99, 98)
keep if !inlist( s11b1q8b1, .,0,99, 98) |  !inlist( s11b1q8b2, .,0,99, 98)  |  !inlist( s11b1q8b3, .,0,99, 98)
keep hhid type_asset asset_owner*
tempfile land3
save `land3'
restore
append using `land3' 
* Livestock owners
replace type_asset="livestockowners" if  !inlist( s11iq4a, .,0,99, 98) |  !inlist( s11iq4b, .,0,99, 98)  
replace asset_owner1=s11iq4a if !inlist( s11iq4a, .,0,99, 98)  
replace asset_owner2=s11iq4b if !inlist( s11iq4b, .,0,99, 98) 	
* AGRICULTURAL CAPITAL
replace type_asset="agcapialowner" if  !inlist( sa4q2a, .,0,99, 98) |  !inlist( sa4q2b, .,0,99, 98) |  !inlist( sa4q2c, .,0,99, 98) |  !inlist( sa4q2d, .,0,99, 98) 
replace asset_owner1=sa4q2a if !inlist( sa4q2a, .,0,99, 98)  
replace asset_owner2=sa4q2b if !inlist( sa4q2b, .,0,99, 98)
replace asset_owner3=sa4q2c if !inlist( sa4q2c, .,0,99, 98)  
replace asset_owner4=sa4q2d if !inlist( sa4q2d, .,0,99, 98)
* Non farm assets (equipment)
drop if inlist(item_cd, 301 , 302 , 303, 304 , 305 ,  306, 321,  322 , 323, 324, 326, 325,  327,  329)
replace type_asset="nonfarm_asset" if  !inlist( s5q2, .,0,99, 98) |  !inlist( s5q2b, .,0,99, 98)  
replace asset_owner1=s5q2 if !inlist( s5q2, .,0,99, 98)  
replace asset_owner2=s5q2b if !inlist( s5q2b, .,0,99, 98)	
keep hhid type_asset asset_owner1  asset_owner2 asset_owner3 asset_owner4  
preserve
keep hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
preserve
keep hhid type_asset asset_owner3
drop if asset_owner3==.
ren asset_owner3 asset_owner
tempfile asset_owner3
save `asset_owner3'
restore
preserve
keep hhid type_asset asset_owner4
drop if asset_owner4==.
ren asset_owner4 asset_owner
tempfile asset_owner4
save `asset_owner4'
restore
keep hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
append using `asset_owner3'
append using `asset_owner4'
gen own_asset=1
collapse (max) own_asset, by(hhid asset_owner)
ren asset_owner indiv
* Now merge with member characteristics
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_raw_data}/sect1_plantingw3.dta", nogen
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_raw_data}/sect1_harvestw3.dta"
gen female = s1q2 ==2
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ownasset.dta", replace


********************************************************************************
*CROP YIELDS
********************************************************************************
//ALT: This section is still here for legacy file compatibility; the data have already been generated by this point, it's just a matter of reshaping them into a format that later code will accept. With some modification to the final variables code, this section could be shortened significantly.
/*File structure:
	in hh_crop_area_plan.dta (by hhid crop_code):
		Prefixes:
			harvest (= kgs harvest??) 
			area_plan
			area_harv 
		Suffixes: (inter pure)x(male female mixed)
	in hh_area_planted_harvested_allcrops.dta:
		all_area_harvested (sum area_harv)
		all_area_planted (sum area_plan)
	in crop_harvest_area_yield.dta
		Same as crop_area_plan, filtered to the topcrops.
	in yield_hh_crop_level.dta:
		Prefixes: 
			harvest
			area_harv
			area_plan
		Suffixes: (inter pure)x(male female mixed)x(crop)
			total_planted_area 
			total_harv_area
			value_harv 
			value_sold 
			harvested 
			grew
			kgs_harvest 
		Suffixes: crop (only)
*/
/* no longer needed
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
gen number_trees_planted_banana = number_trees_planted if crop_code==2030 
gen number_trees_planted_cassava = number_trees_planted if crop_code==1020 
gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040
recode number_trees_planted_banana number_trees_planted_cassava number_trees_planted_cocoa (.=0) 
collapse (sum) number_trees_planted*, by(hhid)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_trees.dta", replace
*/


use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
gen grew_=1
gen harvested_ = (quant_harv_kg!=0 & quant_harv_kg!=.) | (ha_harvest!=0 & ha_harvest!=.)
collapse (max) grew_ harvested_, by(hhid crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropname_table.dta", nogen keep(3)
keep hhid crop_name grew_ harvested_
fillin hhid crop_name
drop _fillin
recode grew_ harvested_ (.=0)
reshape wide grew_ harvested_, i(hhid) j(crop_name) string
tempfile grew_crops
save `grew_crops'

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
ren quant_harv_kg harvest 
ren ha_plan_yld area_plan
ren ha_harv_yld area_harv 
gen mixed = "inter"  //Note to adjust this for lost crops 
replace mixed="pure" if purestand==1
gen dm_gender2="unknown"
replace dm_gender2="male" if dm_gender==1
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3

foreach i in harvest area_plan area_harv {	
	foreach j in inter pure {
		gen `i'_`j'=`i' if mixed == "`j'"
		foreach k in male female mixed {
			gen `i'_`j'_`k' = `i' if mixed=="`j'" & dm_gender2=="`k'"
			capture confirm var `i'_`k'
			if _rc {
				gen `i'_`k'=`i' if dm_gender2=="`k'"
			}
		}
	}
}

collapse (sum) harvest* area* (max) no_harvest, by(hhid crop_code)
unab vars : harvest* area*
foreach var in `vars' {
	replace `var' = . if `var'==0 & no_harvest==1
}

replace area_plan = . if area_plan==0
replace area_harv = . if area_plan==. | (area_harv==0 & no_harvest==1)
unab vars2 : area_plan_*
local suffix : subinstr local vars2 "area_plan_" "", all
foreach var in `suffix' {
	replace area_plan_`var' = . if area_plan_`var'==0
	replace harvest_`var'=. if area_plan_`var'==. | (harvest_`var'==0 & no_harvest==1)
	replace area_harv_`var'=. if area_plan_`var'==. | (area_harv_`var'==0 & no_harvest==1)
}
drop no_harvest
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_area_plan.dta", replace


*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_

drop crop_code
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string
//merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold*, by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*ren variable
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (Naira) (household)" 
	lab var value_sold_`p' "Value sold of `p' (Naira) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household) (summed accross all seasons)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (summed accross all seasons)" 
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household) (summed accross all seasons)" 
	lab var harvest_`p' "Quantity harvested of `p' (kgs) (household)" 
	lab var harvest_male_`p' "Quantity harvested of `p' (kgs) (male-managed plots)" 
	lab var harvest_female_`p' "Quantity harvested of `p' (kgs) (female-managed plots)" 
	lab var harvest_mixed_`p' "Quantity harvested of `p' (kgs) (mixed-managed plots)"
	lab var harvest_pure_`p' "Quantity harvested of `p' (kgs) - purestand (household)"
	lab var harvest_pure_male_`p'  "Quantity harvested of `p' (kgs) - purestand (male-managed plots)"
	lab var harvest_pure_female_`p'  "Quantity harvested of `p' (kgs) - purestand (female-managed plots)"
	lab var harvest_pure_mixed_`p'  "Quantity harvested of `p' (kgs) - purestand (mixed-managed plots)"
	lab var harvest_inter_`p' "Quantity harvested of `p' (kgs) - intercrop (household)"
	lab var harvest_inter_male_`p' "Quantity harvested of `p' (kgs) - intercrop (male-managed plots)" 
	lab var harvest_inter_female_`p' "Quantity harvested of `p' (kgs) - intercrop (female-managed plots)"
	lab var harvest_inter_mixed_`p' "Quantity harvested  of `p' (kgs) - intercrop (mixed-managed plots)" //ALT: Redundant?
	lab var area_harv_`p' "Area harvested of `p' (ha) (household)" 
	lab var area_harv_male_`p' "Area harvested of `p' (ha) (male-managed plots)" 
	lab var area_harv_female_`p' "Area harvested of `p' (ha) (female-managed plots)" 
	lab var area_harv_mixed_`p' "Area harvested of `p' (ha) (mixed-managed plots)"
	lab var area_harv_pure_`p' "Area harvested of `p' (ha) - purestand (household)"
	lab var area_harv_pure_male_`p'  "Area harvested of `p' (ha) - purestand (male-managed plots)"
	lab var area_harv_pure_female_`p'  "Area harvested of `p' (ha) - purestand (female-managed plots)"
	lab var area_harv_pure_mixed_`p'  "Area harvested of `p' (ha) - purestand (mixed-managed plots)"
	lab var area_harv_inter_`p' "Area harvested of `p' (ha) - intercrop (household)"
	lab var area_harv_inter_male_`p' "Area harvested of `p' (ha) - intercrop (male-managed plots)" 
	lab var area_harv_inter_female_`p' "Area harvested of `p' (ha) - intercrop (female-managed plots)"
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (ha) - intercrop (mixed-managed plots)"
	lab var area_plan_`p' "Area planted of `p' (ha) (household)" 
	lab var area_plan_male_`p' "Area planted of `p' (ha) (male-managed plots)" 
	lab var area_plan_female_`p' "Area planted of `p' (ha) (female-managed plots)" 
	lab var area_plan_mixed_`p' "Area planted of `p' (ha) (mixed-managed plots)"
	lab var area_plan_pure_`p' "Area planted of `p' (ha) - purestand (household)"
	lab var area_plan_pure_male_`p'  "Area planted of `p' (ha) - purestand (male-managed plots)"
	lab var area_plan_pure_female_`p'  "Area planted of `p' (ha) - purestand (female-managed plots)"
	lab var area_plan_pure_mixed_`p'  "Area planted of `p' (ha) - purestand (mixed-managed plots)"
	lab var area_plan_inter_`p' "Area planted of `p' (ha) - intercrop (household)"
	lab var area_plan_inter_male_`p' "Area planted of `p' (ha) - intercrop (male-managed plots)" 
	lab var area_plan_inter_female_`p' "Area planted of `p' (ha) - intercrop (female-managed plots)"
	lab var area_plan_inter_mixed_`p' "Area planted  of `p' (ha) - intercrop (mixed-managed plots)"
}

merge 1:1 hhid using `grew_crops', nogen
foreach p of global topcropname_area {
	//gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	//gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
/*
replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
*/
//drop harvest- harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_pure_mixed value_harv value_sold total_planted_area total_harv_area  
//ALT 08.16.21: No drops necessary; only variables here are the ones that are listed in the labeling block above.
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_yield_hh_crop_level.dta", replace




* VALUE OF CROP PRODUCTION  // using 335 output
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production.dta", clear
*Grouping following IMPACT categories but also mindful of the consumption categories.
gen crop_group=""
replace crop_group=	"Beans and cowpeas"	if crop_code==	1010
replace crop_group=	"Cassava"	if crop_code==	1020
replace crop_group=	"Cocoyam"	if crop_code==	1040
replace crop_group=	"Cotton"	if crop_code==	1050
replace crop_group=	"Cotton"	if crop_code==	1051
replace crop_group=	"Cotton"	if crop_code==	1053
replace crop_group=	"Groundnuts"	if crop_code==	1060
replace crop_group=	"Groundnuts"	if crop_code==	1061
replace crop_group=	"Groundnuts"	if crop_code==	1062
replace crop_group=	"Sorghum"	if crop_code==	1070
replace crop_group=	"Maize"	if crop_code==	1080
replace crop_group=	"Maize"	if crop_code==	1081
replace crop_group=	"Maize"	if crop_code==	1082
replace crop_group=	"Maize"	if crop_code==	1083
replace crop_group=	"Fruits"	if crop_code==	1090
replace crop_group=	"Fruits"	if crop_code==	1091
replace crop_group=	"Fruits"	if crop_code==	1093
replace crop_group=	"Millet"	if crop_code==	1100
replace crop_group=	"Rice"	if crop_code==	1110
replace crop_group=	"Rice"	if crop_code==	1111
replace crop_group=	"Rice"	if crop_code==	1112
replace crop_group=	"Yam"	if crop_code==	1120
replace crop_group=	"Yam"	if crop_code==	1121
replace crop_group=	"Yam"	if crop_code==	1122
replace crop_group=	"Yam"	if crop_code==	1123
replace crop_group=	"Yam"	if crop_code==	1124
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2010
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2020
replace crop_group=	"Bananas"	if crop_code==	2030
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2040
replace crop_group=	"Vegetables"	if crop_code==	2050
replace crop_group=	"Vegetables"	if crop_code==	2060
replace crop_group=	"Vegetables"	if crop_code==	2070
replace crop_group=	"Vegetables"	if crop_code==	2071
replace crop_group=	"Fruits"	if crop_code==	2080
replace crop_group=	"Spices"	if crop_code==	2100
replace crop_group=	"Other other"	if crop_code==	2110
replace crop_group=	"Vegetables"	if crop_code==	2120
replace crop_group=	"Vegetables"	if crop_code==	2130
replace crop_group=	"Vegetables"	if crop_code==	2140
replace crop_group=	"Vegetables"	if crop_code==	2141
replace crop_group=	"Vegetables"	if crop_code==	2142
replace crop_group=	"Other other"	if crop_code==	2143
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2150
replace crop_group=	"Fruits"	if crop_code==	2160
replace crop_group=	"Plantains"	if crop_code==	2170
replace crop_group=	"Potato"	if crop_code==	2180
replace crop_group=	"Sweet potato"	if crop_code==	2181
replace crop_group=	"Vegetables"	if crop_code==	2190
replace crop_group=	"Vegetables"	if crop_code==	2191
replace crop_group=	"Vegetables"	if crop_code==	2192
replace crop_group=	"Vegetables"	if crop_code==	2193
replace crop_group=	"Vegetables"	if crop_code==	2194
replace crop_group=	"Other other"	if crop_code==	2195
replace crop_group=	"Other roots and tubers"	if crop_code==	2200
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2210
replace crop_group=	"Soyabean"	if crop_code==	2220
replace crop_group=	"Sugar"	if crop_code==	2230
replace crop_group=	"Other other"	if crop_code==	2250
replace crop_group=	"Vegetables"	if crop_code==	2260
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2270
replace crop_group=	"Wheat"	if crop_code==	2280
replace crop_group=	"Other other"	if crop_code==	2290
replace crop_group=	"Other other"	if crop_code==	2291
replace crop_group=	"Fruits"	if crop_code==	3010
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3020
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3021
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3022
replace crop_group=	"Spices"	if crop_code==	3030
replace crop_group=	"Cocoa"	if crop_code==	3040
replace crop_group=	"Cocoa"	if crop_code==	3041
replace crop_group=	"Cocoa"	if crop_code==	3042
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3050
replace crop_group=	"Coffee"	if crop_code==	3060
replace crop_group=	"Fruits"	if crop_code==	3080
replace crop_group=	"Fruits"	if crop_code==	3090
replace crop_group=	"Other other"	if crop_code==	3100
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3110
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3111
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3112
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3113
replace crop_group=	"Fruits"	if crop_code==	3130
replace crop_group=	"Other other"	if crop_code==	3140
replace crop_group=	"Fruits"	if crop_code==	3150
replace crop_group=	"Fruits"	if crop_code==	3160
replace crop_group=	"Fruits"	if crop_code==	3170
replace crop_group=	"Oils and fats"	if crop_code==	3180
replace crop_group=	"Oils and fats"	if crop_code==	3183
replace crop_group=	"Oils and fats"	if crop_code==	3184
replace crop_group=	"Oils and fats"	if crop_code==	3190
replace crop_group=	"Oils and fats"	if crop_code==	3200
replace crop_group=	"Fruits"	if crop_code==	3210
replace crop_group=	"Fruits"	if crop_code==	3220
replace crop_group=	"Fruits"	if crop_code==	3221
replace crop_group=	"Other other"	if crop_code==	3230
replace crop_group=	"Fruits"	if crop_code==	3240
replace crop_group=	"Spices"	if crop_code==	3260
ren  crop_group commodity

*High/low value crops
gen type_commodity=""
/* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"Low"	if crop_code==	1010
replace type_commodity=	"Low"	if crop_code==	1020
replace type_commodity=	"Low"	if crop_code==	1040
replace type_commodity=	"High"	if crop_code==	1050
replace type_commodity=	"High"	if crop_code==	1051
replace type_commodity=	"High"	if crop_code==	1053
replace type_commodity=	"Low"	if crop_code==	1060
replace type_commodity=	"Low"	if crop_code==	1061
replace type_commodity=	"Low"	if crop_code==	1062
replace type_commodity=	"Low"	if crop_code==	1070
replace type_commodity=	"Low"	if crop_code==	1080
replace type_commodity=	"Low"	if crop_code==	1081
replace type_commodity=	"Low"	if crop_code==	1082
replace type_commodity=	"Low"	if crop_code==	1083
replace type_commodity=	"High"	if crop_code==	1090
replace type_commodity=	"High"	if crop_code==	1091
replace type_commodity=	"High"	if crop_code==	1093
replace type_commodity=	"Low"	if crop_code==	1100
replace type_commodity=	"Low"	if crop_code==	1110
replace type_commodity=	"Low"	if crop_code==	1111
replace type_commodity=	"Low"	if crop_code==	1112
replace type_commodity=	"Low"	if crop_code==	1120
replace type_commodity=	"Low"	if crop_code==	1121
replace type_commodity=	"Low"	if crop_code==	1122
replace type_commodity=	"Low"	if crop_code==	1123
replace type_commodity=	"Low"	if crop_code==	1124
replace type_commodity=	"Low"	if crop_code==	2010
replace type_commodity=	"Low"	if crop_code==	2020
replace type_commodity=	"High"	if crop_code==	2030
replace type_commodity=	"Low"	if crop_code==	2040
replace type_commodity=	"High"	if crop_code==	2050
replace type_commodity=	"High"	if crop_code==	2060
replace type_commodity=	"High"	if crop_code==	2070
replace type_commodity=	"High"	if crop_code==	2071
replace type_commodity=	"High"	if crop_code==	2080
replace type_commodity=	"High"	if crop_code==	2100
replace type_commodity=	"High"	if crop_code==	2110
replace type_commodity=	"High"	if crop_code==	2120
replace type_commodity=	"High"	if crop_code==	2130
replace type_commodity=	"High"	if crop_code==	2140
replace type_commodity=	"High"	if crop_code==	2141
replace type_commodity=	"High"	if crop_code==	2142
replace type_commodity=	"High"	if crop_code==	2143
replace type_commodity=	"Low"	if crop_code==	2150
replace type_commodity=	"High"	if crop_code==	2160
replace type_commodity=	"High"	if crop_code==	2170
replace type_commodity=	"High"	if crop_code==	2180
replace type_commodity=	"High"	if crop_code==	2181
replace type_commodity=	"High"	if crop_code==	2190
replace type_commodity=	"High"	if crop_code==	2191
replace type_commodity=	"High"	if crop_code==	2192
replace type_commodity=	"High"	if crop_code==	2193
replace type_commodity=	"High"	if crop_code==	2194
replace type_commodity=	"Low"	if crop_code==	2195
replace type_commodity=	"Low"	if crop_code==	2200
replace type_commodity=	"High"	if crop_code==	2210
replace type_commodity=	"High"	if crop_code==	2220
replace type_commodity=	"High"	if crop_code==	2230
replace type_commodity=	"High"	if crop_code==	2250
replace type_commodity=	"High"	if crop_code==	2260
replace type_commodity=	"High"	if crop_code==	2270
replace type_commodity=	"Low"	if crop_code==	2280
replace type_commodity=	"Low"	if crop_code==	2290
replace type_commodity=	"Low"	if crop_code==	2291
replace type_commodity=	"High"	if crop_code==	3010
replace type_commodity=	"High"	if crop_code==	3020
replace type_commodity=	"High"	if crop_code==	3021
replace type_commodity=	"High"	if crop_code==	3022
replace type_commodity=	"High"	if crop_code==	3030
replace type_commodity=	"High"	if crop_code==	3040
replace type_commodity=	"High"	if crop_code==	3041
replace type_commodity=	"High"	if crop_code==	3042
replace type_commodity=	"High"	if crop_code==	3050
replace type_commodity=	"High"	if crop_code==	3060
replace type_commodity=	"High"	if crop_code==	3080
replace type_commodity=	"High"	if crop_code==	3090
replace type_commodity=	"High"	if crop_code==	3100
replace type_commodity=	"High"	if crop_code==	3110
replace type_commodity=	"High"	if crop_code==	3111
replace type_commodity=	"High"	if crop_code==	3112
replace type_commodity=	"High"	if crop_code==	3113
replace type_commodity=	"High"	if crop_code==	3130
replace type_commodity=	"Low"	if crop_code==	3140
replace type_commodity=	"High"	if crop_code==	3150
replace type_commodity=	"High"	if crop_code==	3160
replace type_commodity=	"High"	if crop_code==	3170
replace type_commodity=	"High"	if crop_code==	3180
replace type_commodity=	"High"	if crop_code==	3183
replace type_commodity=	"High"	if crop_code==	3184
replace type_commodity=	"High"	if crop_code==	3190
replace type_commodity=	"High"	if crop_code==	3200
replace type_commodity=	"High"	if crop_code==	3210
replace type_commodity=	"High"	if crop_code==	3220
replace type_commodity=	"High"	if crop_code==	3221
replace type_commodity=	"High"	if crop_code==	3230
replace type_commodity=	"High"	if crop_code==	3240
replace type_commodity=	"High"	if crop_code==	3260
*/

* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"High"	if crop_code==	1010
replace type_commodity=	"Low"	if crop_code==	1020
replace type_commodity=	"Low"	if crop_code==	1040
replace type_commodity=	"Out"	if crop_code==	1050
replace type_commodity=	"Out"	if crop_code==	1051
replace type_commodity=	"Out"	if crop_code==	1053
replace type_commodity=	"High"	if crop_code==	1060
replace type_commodity=	"High"	if crop_code==	1061
replace type_commodity=	"High"	if crop_code==	1062
replace type_commodity=	"Low"	if crop_code==	1070
replace type_commodity=	"Low"	if crop_code==	1080
replace type_commodity=	"Low"	if crop_code==	1081
replace type_commodity=	"Low"	if crop_code==	1082
replace type_commodity=	"Low"	if crop_code==	1083
replace type_commodity=	"High"	if crop_code==	1090
replace type_commodity=	"High"	if crop_code==	1091
replace type_commodity=	"High"	if crop_code==	1093
replace type_commodity=	"Low"	if crop_code==	1100
replace type_commodity=	"High"	if crop_code==	1110
replace type_commodity=	"High"	if crop_code==	1111
replace type_commodity=	"High"	if crop_code==	1112
replace type_commodity=	"Low"	if crop_code==	1120
replace type_commodity=	"Low"	if crop_code==	1121
replace type_commodity=	"Low"	if crop_code==	1122
replace type_commodity=	"Low"	if crop_code==	1123
replace type_commodity=	"Low"	if crop_code==	1124
replace type_commodity=	"Low"	if crop_code==	2010
replace type_commodity=	"High"	if crop_code==	2020
replace type_commodity=	"Low"	if crop_code==	2030
replace type_commodity=	"High"	if crop_code==	2040
replace type_commodity=	"High"	if crop_code==	2050
replace type_commodity=	"High"	if crop_code==	2060
replace type_commodity=	"High"	if crop_code==	2070
replace type_commodity=	"High"	if crop_code==	2071
replace type_commodity=	"High"	if crop_code==	2080
replace type_commodity=	"High"	if crop_code==	2100
replace type_commodity=	"Out"	if crop_code==	2110
replace type_commodity=	"High"	if crop_code==	2120
replace type_commodity=	"High"	if crop_code==	2130
replace type_commodity=	"High"	if crop_code==	2140
replace type_commodity=	"High"	if crop_code==	2141
replace type_commodity=	"High"	if crop_code==	2142
replace type_commodity=	"Out"	if crop_code==	2143
replace type_commodity=	"High"	if crop_code==	2150
replace type_commodity=	"High"	if crop_code==	2160
replace type_commodity=	"Low"	if crop_code==	2170
replace type_commodity=	"Low"	if crop_code==	2180
replace type_commodity=	"Low"	if crop_code==	2181
replace type_commodity=	"High"	if crop_code==	2190
replace type_commodity=	"High"	if crop_code==	2191
replace type_commodity=	"High"	if crop_code==	2192
replace type_commodity=	"High"	if crop_code==	2193
replace type_commodity=	"High"	if crop_code==	2194
replace type_commodity=	"Out"	if crop_code==	2195
replace type_commodity=	"Out"	if crop_code==	2200
replace type_commodity=	"High"	if crop_code==	2210
replace type_commodity=	"High"	if crop_code==	2220
replace type_commodity=	"Out"	if crop_code==	2230
replace type_commodity=	"Out"	if crop_code==	2250
replace type_commodity=	"High"	if crop_code==	2260
replace type_commodity=	"High"	if crop_code==	2270
replace type_commodity=	"Low"	if crop_code==	2280
replace type_commodity=	"Out"	if crop_code==	2290
replace type_commodity=	"Out"	if crop_code==	2291
replace type_commodity=	"High"	if crop_code==	3010
replace type_commodity=	"High"	if crop_code==	3020
replace type_commodity=	"High"	if crop_code==	3021
replace type_commodity=	"High"	if crop_code==	3022
replace type_commodity=	"High"	if crop_code==	3030
replace type_commodity=	"High"	if crop_code==	3040
replace type_commodity=	"High"	if crop_code==	3041
replace type_commodity=	"High"	if crop_code==	3042
replace type_commodity=	"High"	if crop_code==	3050
replace type_commodity=	"High"	if crop_code==	3060
replace type_commodity=	"High"	if crop_code==	3080
replace type_commodity=	"High"	if crop_code==	3090
replace type_commodity=	"Out"	if crop_code==	3100
replace type_commodity=	"High"	if crop_code==	3110
replace type_commodity=	"High"	if crop_code==	3111
replace type_commodity=	"High"	if crop_code==	3112
replace type_commodity=	"High"	if crop_code==	3113
replace type_commodity=	"High"	if crop_code==	3130
replace type_commodity=	"High"	if crop_code==	3140
replace type_commodity=	"High"	if crop_code==	3150
replace type_commodity=	"High"	if crop_code==	3160
replace type_commodity=	"High"	if crop_code==	3170
replace type_commodity=	"Out"	if crop_code==	3180
replace type_commodity=	"Out"	if crop_code==	3183
replace type_commodity=	"Out"	if crop_code==	3184
replace type_commodity=	"High"	if crop_code==	3190
replace type_commodity=	"High"	if crop_code==	3200
replace type_commodity=	"High"	if crop_code==	3210
replace type_commodity=	"High"	if crop_code==	3220
replace type_commodity=	"High"	if crop_code==	3221
replace type_commodity=	"Out"	if crop_code==	3230
replace type_commodity=	"High"	if crop_code==	3240
replace type_commodity=	"High"	if crop_code==	3260
	
preserve
collapse (sum) value_crop_production value_crop_sales, by( hhid commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_bana
	ren value_`s'2 value_`s'_beanc
	ren value_`s'3 value_`s'_casav
	ren value_`s'4 value_`s'_cocoa
	ren value_`s'5 value_`s'_cyam
	ren value_`s'6 value_`s'_coton
	ren value_`s'7 value_`s'_fruit 
	ren value_`s'8 value_`s'_gdnut
	ren value_`s'9 value_`s'_maize 
	ren value_`s'10 value_`s'_mill 
	ren value_`s'11 value_`s'_oilc 
	ren value_`s'12 value_`s'_onuts
	ren value_`s'13 value_`s'_oths 
	ren value_`s'14 value_`s'_plant  
	ren value_`s'15 value_`s'_pota  
	ren value_`s'16 value_`s'_rice 
	ren value_`s'17 value_`s'_sorg 
	ren value_`s'18 value_`s'_sybea
	ren value_`s'19 value_`s'_spice
	ren value_`s'20 value_`s'_suga
	ren value_`s'21 value_`s'_spota
	ren value_`s'22 value_`s'_vegs
	ren value_`s'23 value_`s'_whea 
	ren value_`s'24 value_`s'_yam
} 

foreach x of varlist value_pro* {
	local l`x':var label `x'
	local l`x'= subinstr("`l`x''","value_pro, commodity == ","Value of production, ",.) 
	lab var `x' "`l`x''"
}
foreach x of varlist value_sal* {
	local l`x':var label `x'
	local l`x'= subinstr("`l`x''","value_sal, commodity == ","Value of sales, ",.) 
	lab var `x' "`l`x''"
}

qui recode value_* (.=0)
foreach x of varlist value_* {
	local l`x':var label `x'
}
collapse (sum) value_*, by(hhid)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by( hhid type_commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(type_commodity)
separate value_sal, by(type_commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_high
	ren value_`s'2 value_`s'_low
	/*DYA.10.30.2020*/ ren value_`s'3 value_`s'_other
} 
foreach x of varlist value_pro* {
	local l`x':var label `x'
	local l`x'= subinstr("`l`x''","value_pro, type_commodity == ","Value of production, ",.) 
	lab var `x' "`l`x''"
}
foreach x of varlist value_sal* {
	local l`x':var label `x'
	local l`x'= subinstr("`l`x''","value_sal, type_commodity == ","Value of sales, ",.) 
	lab var `x' "`l`x''"
}

qui recode value_* (.=0)
foreach x of varlist value_* {
	local l`x':var label `x'
}

qui recode value_* (.=0)
collapse (sum) value_*, by(hhid)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}
drop value_pro value_sal
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production_type_crop.dta", replace
*End DYA 9.13.2020 


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_area_plan.dta", clear
/*gen area_plan = area_plan_pure_hh + area_plan_inter_hh
foreach i in male female mixed { 
	egen area_plan_`i' = rowtotal(area_plan_*_`i')
}
*/
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_area_plan_shannon.dta", nogen		//all matched
recode area_plan_female area_plan_male area_plan_female_hh area_plan_male_hh area_plan_mixed area_plan_mixed_hh (0=.)
gen prop_plan = area_plan/area_plan_hh
gen prop_plan_female=area_plan_female/area_plan_female_hh
gen prop_plan_male=area_plan_male/area_plan_male_hh
gen prop_plan_mixed=area_plan_mixed/area_plan_mixed_hh
gen sdi_crop = prop_plan*ln(prop_plan)
gen sdi_crop_female = prop_plan_female*ln(prop_plan_female)
gen sdi_crop_male = prop_plan_male*ln(prop_plan_male)
gen sdi_crop_mixed = prop_plan_mixed*ln(prop_plan_mixed)
*tagging those that are missing all values
bysort hhid (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort hhid (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort hhid (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort hhid crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(hhid)
la var sdi "Shannon diversity index"
la var sdi_female "Shannon diversity index on female managed plots"
la var sdi_male "Shannon diversity index on male managed plots"
la var sdi_mixed "Shannon diversity index on mixed managed plots"
replace sdi_female=. if allmissing_female==1
replace sdi_male=. if allmissing_male==1
replace sdi_mixed=. if allmissing_mixed==1
gen encs = exp(-sdi)
gen encs_female = exp(-sdi_female)
gen encs_male = exp(-sdi_male)
gen encs_mixed = exp(-sdi_mixed)
la var encs "Effective number of crop species per household"
la var encs_female "Effective number of crop species on female managed plots per household"
la var encs_male "Effective number of crop species on male managed plots per household"
la var encs_mixed "Effective number of crop species on mixed managed plots per household"
la var num_crops_hh "Number of crops grown by the household"
la var num_crops_female "Number of crops grown on female managed plots" 
la var num_crops_male "Number of crops grown on male managed plots"
la var num_crops_mixed "Number of crops grown on mixed managed plots"
gen multiple_crops = (num_crops_hh>1 & num_crops_hh!=.)
la var multiple_crops "Household grows more than one crop"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
********************************************************************************
*first get adult equivalent
use "${Nigeria_GHS_W3_raw_data}/PTrack.dta", clear
ren sex gender
gen adulteq=.
replace adulteq=0.4 if (age<3 & age>=0)
replace adulteq=0.48 if (age<5 & age>2)
replace adulteq=0.56 if (age<7 & age>4)
replace adulteq=0.64 if (age<9 & age>6)
replace adulteq=0.76 if (age<11 & age>8)
replace adulteq=0.80 if (age<=12 & age>10) & gender==1		//1=male, 2=female
replace adulteq=0.88 if (age<=12 & age>10) & gender==2 //ALT 01.04.21: Changed from <12 to <=12 because 12-year-olds were being excluded.
replace adulteq=1 if (age<15 & age>12)
replace adulteq=1.2 if (age<19 & age>14) & gender==1
replace adulteq=1 if (age<19 & age>14) & gender==2
replace adulteq=1 if (age<60 & age>18) & gender==1
replace adulteq=0.88 if (age<60 & age>18) & gender==2
replace adulteq=0.8 if (age>59 & age!=.) & gender==1
replace adulteq=0.72 if (age>59 & age!=.) & gender==2
replace adulteq=. if age==999
collapse (sum) adulteq, by(hhid)
lab var adulteq "Adult-Equivalent"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_adulteq.dta", replace


use "${Nigeria_GHS_W3_raw_data}/cons_agg_wave3_visit1.dta", clear
ren  totcons totcons_v1
merge 1:1 hhid using "${Nigeria_GHS_W3_raw_data}/cons_agg_wave3_visit2.dta", nogen
ren  totcons totcons_v2
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_adulteq.dta"
*Per the Nigeria BID in Wave 2, we should average the consumption aggregat for the tow visits
egen totcons=rowmean(totcons_v1 totcons_v2)  
gen percapita_cons = totcons
gen daily_percap_cons = percapita_cons/365
gen total_cons = (totcons *hhsize)
gen peraeq_cons = total_cons/adulteq
gen daily_peraeq_cons = peraeq_cons/365
la var percapita_cons "Yearly HH consumption per person"	
la var total_cons "Total yearly HH consumption - averaged over two visits"								
la var peraeq_cons "Yearly HH consumption per adult equivalent"				
la var daily_peraeq_cons "Daily HH consumption per adult equivalent"		
la var daily_percap_cons "Daily HH consumption per person" 		
keep hhid adulteq totcons percapita_cons daily_percap_cons total_cons peraeq_cons daily_peraeq_cons 
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_consumption.dta", replace

********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect12_harvestw3.dta", clear
foreach i in a b c d e f{
	gen food_insecurity_`i' = (s12q6`i'!=.)
}
egen months_food_insec = rowtotal (food_insecurity_*) 
lab var months_food_insec "Number of months where the household experienced any food insecurity" 
keep hhid months_food_insec
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_insecurity.dta", replace

*****************************************************************************
/* For comparison with the WB-issued files.
use "${Nigeria_GHS_W3_raw_data}/food_conv_w3.dta", clear
drop if unit_cd == 900
ren conv*1 conv1
ren conv*2 conv2
ren conv*3 conv3
ren conv*4 conv4
ren conv*5 conv5
ren conv*6 conv6
keep unit_cd item_cd conv*
ren conv_national nat_conv
reshape long conv, i(unit_cd item_cd nat_conv) j(zone)
tempfile fdcons
save `fdcons' 

use "${Nigeria_GHS_W3_raw_data}/sect10b_harvestw3.dta", clear
gen obs = s10bq3a != .
ren s10bq3a qty_bought 
ren s10bq3b unit_cd

merge m:1 item_cd unit_cd zone using `fdcons', keep(1 3) nogen
gen kg_bought = qty_bought*conv
replace kg_bought = qty_bought*nat_conv if kg_bought ==. 
gen price_kg = s10bq4/kg_bought
//ALT 01.25.21: I've tested this with weighted/unweighted and kg vs unit-based pricing.
//It seems like weighted average per-kgs are producing the most reasonable results, but it is a value judgment.

merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(3) keepusing(weight_pop_rururb)
foreach i in ea lga state zone {
	preserve
	bys `i' item_cd : egen obs_`i' = total(obs)
	collapse (median) price_`i' = price_kg [aw=weight_pop_rururb], by(item_cd `i' obs_`i')
	tempfile food_`i'
	save `food_`i''
	restore
	merge m:1 item_cd `i' using `food_`i'', nogen
}

preserve
collapse (median) price_kg [aw=weight_pop_rururb], by(item_cd)
keep item_cd price_kg
ren price_kg price_country
tempfile food_country
save `food_country'
restore

merge m:1 item_cd using `food_country', nogen

replace price_kg = price_lga if price_kg==. & obs_lga > 9
replace price_kg = price_state if price_kg==. & obs_state > 9
replace price_kg = price_zone if price_kg==. & obs_zone > 9
replace price_kg = price_country if price_kg==.

gen qty_purch = s10bq2_cvn * s10bq5a 
gen qty_own = s10bq2_cvn * (s10bq6a+s10bq7a)
//Getting per-day consumption
gen purch_ = qty_purch*price_kg/7
gen own_ = qty_own*price_kg/7
keep hhid item_cd purch_ own_
reshape wide purch_ own_, i(hhid) j(item_cd)
recode purch_* own_* (.=0)

//Needed for water section
preserve
gen purch_water_ph = purch_151 + purch_150
gen own_water_ph = own_151 + own_150
keep hhid purch_water_ph own_water_ph 
tempfile water_ph
save `water_ph'
restore
ren purch_10 fdsorby
ren purch_11 fdmilby
gen fdmaizby = purch_16+purch_20+purch_22
gen fdriceby = purch_13+purch_14
gen fdyamby = purch_17+purch_31 
gen fdcasby = purch_18+purch_30+purch_32+purch_33 
gen fdcereby = purch_23+purch_19
gen fdbrdby = purch_25+purch_26+purch_27+purch_28
gen fdtubby = purch_34+purch_35+purch_36+purch_37+purch_38+purch_60 
gen fdpoulby = purch_80+purch_81+purch_82
gen fdmeatby = purch_29+purch_90+purch_91+purch_92+purch_93+purch_94+purch_96
gen fdfishby = purch_100+purch_101+purch_102+purch_103+purch_104+purch_105+purch_106+purch_107
gen fddairby = purch_83+purch_84+purch_110+purch_111+purch_112+purch_113+purch_114+purch_115
gen fdfatsby = purch_46+purch_47+purch_48+purch_50+purch_51+purch_52+purch_53+purch_56+purch_63+purch_43+purch_44
gen fdfrutby = purch_61+purch_62+purch_64+purch_65+purch_66+purch_67+purch_68+purch_69+purch_70+purch_71+purch_601
gen fdvegby = purch_72+purch_73+purch_74+purch_75+purch_76+purch_77+purch_78+purch_79
gen fdbeanby = purch_40+purch_41+purch_42+purch_45
gen fdswtby = purch_130+purch_132+purch_133
gen fdbevby2 = purch_120+purch_121+purch_122+purch_150+purch_151+purch_152+purch_153+purch_154+purch_155
gen fdalcby2 = purch_160+purch_161+purch_162+purch_163+purch_164
gen fdothby2 = purch_142+purch_143
gen fdspiceby = purch_141+purch_144+purch_148+purch_145+purch_146+purch_147

ren own_10 fdsorpr
ren own_11 fdmilpr
gen fdmaizpr = own_16+own_20+own_22
gen fdricepr = own_13+own_14
gen fdyampr = own_17+own_31 
gen fdcaspr = own_18+own_30+own_32+own_33 
gen fdcerepr = own_23+own_19
gen fdbrdpr = own_25+own_26+own_27+own_28
gen fdtubpr = own_34+own_35+own_36+own_37+own_38+own_60 
gen fdpoulpr = own_80+own_81+own_82
gen fdmeatpr = own_29+own_90+own_91+own_92+own_93+own_94+own_96
gen fdfishpr = own_100+own_101+own_102+own_103+own_104+own_105+own_106+own_107
gen fddairpr = own_83+own_84+own_110+own_111+own_112+own_113+own_114+own_115
gen fdfatspr = own_46+own_47+own_48+own_50+own_51+own_52+own_53+own_56+own_63+own_145+own_146+own_147+own_43+own_44
gen fdfrutpr = own_61+own_62+own_64+own_65+own_66+own_67+own_68+own_69+own_70+own_71+own_601
gen fdvegpr = own_72+own_73+own_74+own_75+own_76+own_77+own_78+own_79
gen fdbeanpr = own_40+own_41+own_42+own_45
gen fdswtpr = own_130+own_132+own_133
gen fdbevpr = own_120+own_121+own_122+own_150+own_151+own_152+own_153+own_154+own_155
gen fdalcpr = own_160+own_161+own_162+own_163+own_164
gen fdothpr = own_142+own_143
gen fdspicepr = own_141+own_144+own_148+own_145+own_146+own_147

drop purch_* own_*

merge 1:1 hhid using `prepfoods', nogen
gen fdothby = fdothby1+fdothby2
gen fdbevby = fdbevby1+fdbevby2 
gen fdalcby = fdalcby1+fdalcby2 
drop fdothby1 fdothby2 fdbevby1 fdbevby2 fdalcby1 fdalcby2 

la var fdsorby "Sorghum purchased"
la var fdmilby "Millet purchased"
la var fdmaizby "Maize grain and flours purchased"
la var fdriceby "Rice in all forms purchased"
la var fdyamby "Yam roots and flour purchased"
la var fdcasby "Cassava-gari, roots, and flour purchased"
la var fdcereby "Other cereals purchased"
la var fdbrdby "Bread and the like purchased"
la var fdtubby "Bananas & tubers purchased"
la var fdpoulby "Poultry purchased"
la var fdmeatby "Meat purchased"
la var fdfishby "Fish & seafood purchased"
la var fddairby "Milk, cheese, and eggs purchased"
la var fdfatsby "Oils, fats, & oil-rich nuts purchased"
la var fdfrutby "Fruits purchased"
la var fdvegby "Vegetables excluding pulses purchased"
la var fdbeanby "Pulses (beans, peas, and groundnuts) purchased"
la var fdswtby "Sugar, jam, honey, chocolate & confectionary purchased"
la var fdbevby "Non-alcoholic purchased"
la var fdalcby "Alcoholic beverages purchased"
la var fdrestby "Food consumed in restaurants & canteens purchased"
la var fdspiceby "Spices and condiments purchased"
la var fdothby "Food items not mentioned above purchased"

la var fdsorpr "Sorghum auto-consumption"
la var fdmilpr "Millet auto-consumption"
la var fdmaizpr "Maize grain and flours auto-consumption"
la var fdricepr "Rice in all forms auto-consumption"
la var fdyampr "Yam roots and flour auto-consumption"
la var fdcaspr "Cassava-gari, roots, and flour auto-consumption"
la var fdcerepr "Other cereals auto-consumption"
la var fdbrdpr "Bread and the like auto-consumption"
la var fdtubpr "Bananas & tubers auto-consumption"
la var fdpoulpr "Poultry auto-consumption"
la var fdmeatpr "Meat auto-consumption"
la var fdfishpr "Fish & seafood auto-consumption"
la var fddairpr "Milk, cheese, and eggs auto-consumption"
la var fdfatspr "Oils, fats, & oil-rich nuts auto-consumption"
la var fdfrutpr "Fruits auto-consumption"
la var fdvegpr "Vegetables excluding pulses auto-consumption"
la var fdbeanpr "Pulses (beans, peas, and groundnuts) auto-consumption"
la var fdswtpr "Sugar, jam, honey, chocolate & confectionary auto-consumption"
la var fdbevpr "Non-alcoholic auto-consumption"
la var fdalcpr "Alcoholic beverages auto-consumption"
la var fdspiceby "Spices and condiments auto-consumption"
la var fdothpr "Food items not mentioned above auto-consumption"

merge 1:1 hhid using `hhexp', nogen
egen totcons = rowtotal(fdsorby-nfdhealth)
*/
	*********************************
	*		FOOD SECURITY			*
	*********************************
**Part of poverty estimation, imported from W4
**# Bookmark #1

use "${Nigeria_GHS_W3_raw_data}/cons_agg_wave3_visit1.dta", clear
drop totcons
egen fdconstot = rowtotal(fd*)
keep hhid fd*
ren fd* fd*_pp
tempfile visit1
save `visit1'
use "${Nigeria_GHS_W3_raw_data}/cons_agg_wave3_visit2.dta",	clear
drop totcons
egen fdconstot = rowtotal(fd*)
keep hhid fd* 
ren fd* fd*_ph
merge 1:1 hhid using `visit1', nogen
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_adulteq.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(1 3)
replace fdconstot_ph = fdconstot_pp if fdconstot_ph == . | fdconstot_ph==0
drop if adulteq==.
recode fdconstot_pp fdconstot_ph (0=.)
reshape long fdconstot_, i(hhid) j(season) string
ren fdconstot_ fdconstot
gen daily_peraeq_fdcons = fdconstot/adulteq /365
gen daily_percap_fdcons = fdconstot/hh_members/365
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_cons.dta", replace
keep hhid daily* season
ren daily* daily*_ 
reshape wide daily*_, i(hhid) j(season) string
//drop if daily_peraeq_fdcons_ph > 7000 | daily_peraeq_fdcons_pp > 7000 //Outliers.
tempfile fdcons
save `fdcons'
	
use "${Nigeria_GHS_W3_raw_data}/sect9_plantingw3.dta", clear
//drop s9q8a
recode s9q1* s9q5 (.=0) (2=0) 
egen dep_food = rowmax(s9q1* s9q5) 
egen total_dep_food = rowtotal(s9q1* s9q5)
gen calor_insuf = s9q1d==1 | s9q1e == 1 | s9q1f == 1 | s9q1g == 1 | s9q1h == 1 | s9q1i == 1 | s9q5==1
gen nutr_insuf = calor_insuf==0 & (s9q1b==1 | s9q1c==1)
gen precarious = nutr_insuf == 0 & calor_insuf==0 & (s9q1a==1)
gen secure=precarious==0 & calor_insuf==0 & nutr_insuf==0

keep hhid dep_food total_dep_food calor_insuf nutr_insuf precarious secure
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_insecurity.dta", nogen
merge 1:1 hhid using `fdcons', nogen
drop if daily_peraeq_fdcons_pp==. //Not sure what the missing values here signify.
egen min_fdcons = rowmin(daily_peraeq_fdcons_*) //Get lowest
egen max_fdcons = rowmax(daily_peraeq_fdcons_*) 
gen avg_fdcons = (daily_peraeq_fdcons_ph + daily_peraeq_fdcons_pp)/2
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_dep.dta", replace

use "${Nigeria_GHS_W3_raw_data}/sect9_plantingw3.dta", clear
recode s9q1* (2=0)
gen rCSI = s9q1a + s9q1b + s9q1c + s9q1d + s9q1e*3 + s9q1f * 4 + s9q1g*4 + s9q1h * 3 + s9q1i*2
//Max score is 20, 50th percentile among scores > 0 is 9
gen nofoodinsec = rCSI <= 3
gen highfoodinsec = rCSI >= 12
keep state hhid rCSI nofoodinsec highfoodinsec
tempfile rCSI
save `rCSI'
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_dep.dta", clear
merge 1:1 hhid using `rCSI', nogen
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keepusing(hh_members weight_pop_rururb)
//collapse (mean) dep_food total_dep_food calor_insuf nutr_insuf precarious secure months* min_fdcons max_fdcons avg_fdcons rCSI nofoodinsec highfoodinsec hh_members [aw=weight_pop_rururb], by(state)
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_dep_ext.dta", replace



********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${Nigeria_GHS_W3_raw_data}/sect5_plantingw3.dta", clear
ren s5q4 value_today
ren s5q1 number_items_owned
ren s5q3 age_item
gen value_assets = value_today*number_items_owned
collapse (sum) value_assets /*=value_today*/, by(hhid) //ALT 11.21.23: Bug fix
la var value_assets "Value of household assets"
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_assets.dta", replace 

	
********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
global empty_vars ""
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", clear
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income 
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

*Start DYA 9.13.2020 
* Production by group and type of crops
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
*End DYA 9.13.2020 
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_cost_inputs.dta", nogen

*Crop costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_`c'_monocrop_hh_area.dta",nogen
}

foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 

*disaggregate by gender of plot manager
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(val_anml_`c'_`i' val_mech_`c'_`i' val_labor_`c'_`i' val_herb_`c'_`i' val_inorg_`c'_`i' val_orgfert_`c'_`i' val_plotrent_`c'_`i' val_seeds_`c'_`i' val_transfert_`c'_`i' val_seedtrans_`c'_`i') //These are already narrowed to explicit costs
	if strmatch("`i'", "hh") { 
		ren `c'_exp_`i' `c'_exp
		lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
		la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 
	}
	else lab var  `c'_exp_`i'  "Crop production expenditures (explicit) - Monocropped `c' `i' managed plots"	
}
replace `c'_exp = . if `c'_monocrop_ha==.			// set to missing if the household does not have any monocropped maize plots
foreach i in male female mixed{
	replace `c'_exp_`i' = . if `c'_monocrop_ha_`i'==.
	}
}
//drop rental_cost_land* cost_seed* value_fertilizer* cost_trans_fert* value_herbicide* value_pesticide* value_manure_purch* cost_trans_manure*
drop val_anml* val_mech* val_labor* val_herb* val_inorg* val_orgfert* val_plotrent* val_seeds* val_transfert* val_seedtrans* //
*Land rights
merge 1:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish income
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fish_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fishing_expenses_1.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fishing_expenses_2.dta", nogen keep(1 3)
gen fish_income_fishfarm = value_fish_harvest - fish_expenses_1 - fish_expenses_2
gen fish_income_fishing = value_fish_caught - fish_expenses_1 - fish_expenses_2
gen fishing_income = fish_income_fishing
recode fishing_income fish_income_fishing fish_income_fishfarm (.=0)
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

*Livestock income
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_products.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_herd_characteristics.dta", nogen keep(1 3)
*merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_TLU_Coefficients.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_TLU_Coefficients.dta", nogen keep (1 3) // HKS 6.16.23

lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced value_other_produced fish_income_fishfarm  cost_*livestock (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced + value_other_produced) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock) + fish_income_fishfarm
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
ren cost_vaccines_livestock ls_exp_vac 
gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced + value_other_produced)
lab var livestock_product_revenue "Gross revenue from sale of livestock products"
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
gen animals_lost12months =0 
gen mean_12months=0
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
gen any_imp_herd_all = . 
foreach v in ls_exp_vac any_imp_herd{
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*

*Self-employment income
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_self_employment_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_agproduct_income.dta", nogen keep(1 3)
egen self_employment_income = rowtotal(profit_processed_crop_sold annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_agwage_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_other_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_remittance_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_other_income.dta", nogen keep(1 3)
egen transfers_income = rowtotal (remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income rental_income_buildings other_income  rental_income_assets)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm size
merge 1:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_size.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_size_all.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_size_total.dta", nogen
recode land_size (.=0)
recode farm_size_agland (.=0)
gen  farm_size_0_0=farm_size_agland==0
gen  farm_size_0_1=farm_size_agland>0 & farm_size_agland<=1
gen  farm_size_1_2=farm_size_agland>1 & farm_size_agland<=2
gen  farm_size_2_4=farm_size_agland>2 & farm_size_agland<=4
gen  farm_size_4_more=farm_size_agland>4
lab var farm_size_0_0 "1=Household has no farm"
lab var farm_size_0_1 "1=Household farm size > 0 Ha and <=1 Ha"
lab var farm_size_1_2 "1=Household farm size > 1 Ha and <=2 Ha"
lab var farm_size_2_4 "1=Household farm size > 2 Ha and <=4 Ha"
lab var farm_size_4_more "1=Household farm size > 4 Ha"

*Labor
//Fix
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 hhid using  "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(1 3)
 
*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_vaccine.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fert_use.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_input_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_any_ext.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fin_serv.dta", nogen keep(1 3)
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use																										   							   
recode use_fin_serv* ext_reach* use_inorg_fert /*use_imprv_seed*/ imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_milk_animals.dta", nogen keep(1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
la var costs_dairy "Dairy production cost (explicit)"
la var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen liters_per_cow = . 
gen liters_per_buffalo = . 
gen share_imp_dairy = . 
gen milk_animals = . 
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy *liters_per_cow *liters_per_buffalo milk_animals

*Egg productivity
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_egg_animals.dta", nogen keep(1 3)
gen liters_milk_produced = milk_months_produced * milk_quantity_produced
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . //ALT: NOTE TO UPDATE THIS 06.01.23
global empty_vars $empty_vars 

*Costs of crop production per hectare
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)
 
*Household diet
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_household_diet.dta", nogen keep(1 3)

*consumption 
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Livestock health
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_livestock_diseases.dta", nogen keep(1 3)

*livestock feeding, water, and housing
*cannot construct 
gen feed_grazing = . 
gen water_source_nat = . 
gen water_source_const = . 
gen water_source_cover = . 
gen lvstck_housed = . 
foreach v in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
global empty_vars $empty_vars feed_grazing* water_source* lvstck_housed*

*Shannon Diversity index
merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
egen value_farm_production = rowtotal(value_crop_production value_livestock_products value_slaughtered value_lvstck_sold)
egen value_farm_prod_sold = rowtotal(value_crop_sales sales_livestock_products value_livestock_sales)
lab var value_farm_production "Total value of farm production (crops + livestock products)"
lab var value_farm_prod_sold "Total value of farm production that is sold" 


*Agricultural households
recode value_crop_production crop_income livestock_income farm_area tlu_today land_size farm_size_agland value_farm_prod_sold (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
replace value_farm_production=. if ag_hh==0
replace value_farm_prod_sold =. if ag_hh==0
recode nb* tlu* *tlu (.=0) if ag_hh==1 //ALT 10.08.24: Issue causing SSP to be too low; consider other variables if needed
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

*household with egg-producing animals  
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Households engaged in ag activities including working in paid ag jobs
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Creating crop households and livestock households
gen crop_hh = (value_crop_production!=0  | farm_area!=0)
lab var crop_hh "1= Household has some land cultivated or some crop income"
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
lab  var livestock_hh "1= Household has some livestock or some livestock income"
recode farm_size_agland (.=0) if crop_hh==0 & livestock_hh==1 //Livestock-only households. 
recode fishing_income (.=0)
gen fishing_hh = (fishing_income!=0)
lab  var fishing_hh "1= Household has some fishing income"

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0		
*all rural households 
recode /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed" //ALT 08.04.21
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh //ALT 08.04.21: Kludge til I get names fully consistent
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg org_fert_kg n_kg p_kg k_kg npk_kg urea_kg herb_kg pest_kg wage_paid_aglabor  

foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
	}
}

drop *wage_paid_aglabor_mixed
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`llabor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  /* we want to keep actual zeros */
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top and bottom 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace w_`v'_`g'= r(r1) if w_`v'_`g' < r(r1) & w_`v'_`g'!=. & w_`v'_`g'!=0  /* we want to keep actual zeros */
			replace w_`v'_`g'= r(r2) if  w_`v'_`g' > r(r2)  & w_`v'_`g'!=.		
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top and bottom 1%"		
		}		
	}
}

*Winsorizing variables that go into yield at the top and bottom 5% //IHS 10.2.19
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 	
levelsof zone, local(list_levels)
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		gen w_`v'_`c'=`v'_`c'
		_pctile `v'_`c'  [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres) 
		scalar p1_nat=r(r1)
		scalar p2_nat=r(r2)	
		foreach r of local list_levels {
			_pctile `v'_`c' [aw=weight_pop_rururb] if zone==`r', p($wins_lower_thres $wins_upper_thres)  
			scalar p1_lev_`r'=r(r1)
			scalar p2_lev_`r'=r(r2)
			replace  w_`v'_`c' = max(p1_lev_`r',p1_nat) if zone==`r' & w_`v'_`c' < max(p1_lev_`r',p1_nat) &  w_`v'_`c'!=.
			replace w_`v'_`c'=  min(p2_lev_`r',p2_nat) if zone==`r' & w_`v'_`c' >  min(p2_lev_`r',p2_nat)  & w_`v'_`c'!=.		
		}		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 1%"
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			foreach r of local list_levels {
				replace w_`v'_`g'_`c' = max(p1_lev_`r',p1_nat) if zone==`r' & w_`v'_`g'_`c' < max(p1_lev_`r',p1_nat) &  w_`v'_`g'_`c'!=0 
				replace w_`v'_`g'_`c' =  min(p2_lev_`r',p2_nat) if zone==`r' & (w_`v'_`g'_`c' >  min(p2_lev_`r',p2_nat) & w_`v'_`g'_`c' !=.) 
			}
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 1%"
			
		}
	}
}


*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
foreach v in inorg_fert org_fert n p k herb pest urea npk {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
}
}

gen cost_total_ha=w_cost_total/w_ha_planted //ALT 05.04.23: removed "_hh" - no longer necessary?
gen cost_expli_ha=w_cost_expli/w_ha_planted				
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
foreach g of global gender {
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household)"
lab var k_rate "Rate of postassium application (kgs/ha) (household)"
lab var p_rate "Rate of phosphorus appliction (kgs/ha) (household)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household)"
lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
lab var urea_rate "Rate of urea application (kgs/ha) (household)"
lab var npk_rate "Rate of NPK fertilizer application (kgs/ha) (household)" 

foreach g in $gender {
lab var inorg_fert_rate_`g' "Rate of fertilizer application (kgs/ha) (`g'-managed crops)"
lab var cost_total_ha_`g' "Explicit + implicit costs (per ha) of crop production (`g'-managed plots)"
lab var cost_expli_ha_`g' "Explicit costs (per ha) of crop production (`g'-managed plots)"
lab var org_fert_rate_`g' "Rate of organic fertilizer application (kgs/ha) (`g'-managed plots)"
lab var n_rate_`g' "Rate of nitrogen application (kgs/ha) (`g'-managed plots)"
lab var k_rate_`g' "Rate of postassium application (kgs/ha) (`g'-managed plots)"
lab var p_rate_`g' "Rate of phosphorus appliction (kgs/ha) (`g'-managed plots)"
lab var pest_rate_`g' "Rate of pesticide application (kgs/ha) (`g'-managed plots)"
lab var herb_rate_`g' "Rate of herbicide application (kgs/ha) (`g'-managed plots)"
lab var urea_rate_`g' "Rate of urea application (kgs/ha) (`g'-managed plots)"
lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
}

lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"


*Estimate variables that are ratios then winsorize top 1% and bottom 1% of the ratios (do not replace 0 by the percentitles)
*generate yield and weights for yields  using winsorized values 
*Yield by Area Planted
foreach c of global topcropname_area {
	gen yield_pl_`c'=w_harvest_`c'/w_area_plan_`c'
	lab var  yield_pl_`c' "Yield by area planted of `c' (kgs/ha) (household)" 
	gen ar_pl_wgt_`c' =  weight*w_area_plan_`c'		
	lab var ar_pl_wgt_`c' "Planted area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_pl_`g'_`c'=w_harvest_`g'_`c'/w_area_plan_`g'_`c'
		lab var  yield_pl_`g'_`c'  "Yield  by area planted of `c' -  (kgs/ha) (`g')" 
		gen ar_pl_wgt_`g'_`c' =  weight*w_area_plan_`g'_`c'
		lab var ar_pl_wgt_`g'_`c' "Harvested area-adjusted weight for `c' (`g')"
	}
}
 
 *Yield by Area Harvested
foreach c of global topcropname_area {
	gen yield_hv_`c'=w_harvest_`c'/w_area_harv_`c'
	lab var  yield_hv_`c' "Yield by area harvested of `c' (kgs/ha) (household)" 
	gen ar_h_wgt_`c' =  weight*w_area_harv_`c'
	lab var ar_h_wgt_`c' "Harvested area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_hv_`g'_`c'=w_harvest_`g'_`c'/w_area_harv_`g'_`c'
		lab var  yield_hv_`g'_`c'  "Yield by area harvested of `c' -  (kgs/ha) (`g')" 
		gen ar_h_wgt_`g'_`c' =  weight*w_area_harv_`g'_`c'
		lab var ar_h_wgt_`g'_`c' "Harvested area-adjusted weight for `c' (`g')"
	}
}


*mortality rate
global animal_species lrum srum pigs equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost_agseas_`s'/mean_agseas_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*generating top crop expenses using winsoried values (monocropped)
foreach c in $topcropname_area{		
	gen `c'_exp_ha =w_`c'_exp /w_`c'_monocrop_ha
	la var `c'_exp_ha "Costs per hectare - Monocropped `c' plots"
	foreach  g of global gender{
		gen `c'_exp_ha_`g' =w_`c'_exp_`g'/w_`c'_monocrop_ha
		la var `c'_exp_ha_`g' "Costs per hectare - Monocropped `c' `g' managed plots"		
	}
}

/*DYA.10.26.2020*/ 
*Hours per capita using winsorized version off_farm_hours 
foreach x in ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}
**# Bookmark #2
 
*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh / w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*milk productivity
gen liters_per_largeruminant= .
la var liters_per_largeruminant "Average quantity (liters) per year (household)"
global empty_vars $empty_vars liters_per_largeruminant		

*crop value sold
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold > 1 & w_proportion_cropvalue_sold != .
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*livestock value sold 
gen w_share_livestock_prod_sold = w_sales_livestock_products / w_value_livestock_products
replace w_share_livestock_prod_sold = 1 if w_share_livestock_prod_sold>1 & w_share_livestock_prod_sold!=.
lab var w_share_livestock_prod_sold "Percent of production of livestock products (winsorized) that is sold"

*Propotion of farm production sold
gen w_prop_farm_prod_sold = w_value_farm_prod_sold / w_value_farm_production
replace w_prop_farm_prod_sold = 1 if w_prop_farm_prod_sold>1 & w_prop_farm_prod_sold!=.
lab var w_prop_farm_prod_sold "Proportion of farm production (winsorized) that has been sold"

*unit cost of production
*all top crops
foreach c in $topcropname_area{
	gen `c'_exp_kg = w_`c'_exp /w_kgs_harv_mono_`c' 
	la var `c'_exp_kg "Costs per kg - Monocropped `c' plots"
	foreach g of global gender {
		gen `c'_exp_kg_`g'=w_`c'_exp_`g'/ w_kgs_harv_mono_`c'_`g' 
		la var `c'_exp_kg_`g' "Costs per kg - Monocropped `c' `g' managed plots"		 
	}
}

*dairy
gen cost_per_lit_milk = costs_dairy/w_liters_milk_produced
la var cost_per_lit_milk "Dairy production cost per liter"
global empty_vars $empty_vars cost_per_lit_milk

*****getting correct subpopulations***
*all rural housseholds engaged in crop production 
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}
*all rural households 
recode /*DYA.10.26.2020*/ hrs_*_pc_all (.=0)  
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'==1 
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'==0 
}
*all rural households harvesting specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
}
*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'==0 | w_area_plan_pure_`cn'==.  
}

*households engaged in dairy production  
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1				
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0		

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top 1%"
		}	
	}
}

*winsorizing top crop ratios
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'_exp_ha=`v'_exp_ha
	replace  w_`v'_exp_ha = r(r1) if  w_`v'_exp_ha > r(r1) &  w_`v'_exp_ha!=.
	local l`v'_exp_ha : var lab `v'_exp_ha
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha_`g' : var lab `v'_exp_ha_`g'
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha_`g'' - winsorized top 1%"
	}
	*winsorizing cost per kilogram
	_pctile `v'_exp_kg [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'_exp_kg=`v'_exp_kg
	replace  w_`v'_exp_kg = r(r1) if  w_`v'_exp_kg > r(r1) &  w_`v'_exp_kg!=.
	local l`v'_exp_kg : var lab `v'_exp_kg
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_kg_`g'= `v'_exp_kg_`g'
		replace w_`v'_exp_kg_`g' = r(r1) if w_`v'_exp_kg_`g' > r(r1) & w_`v'_exp_kg_`g'!=.
		local l`v'_exp_kg_`g' : var lab `v'_exp_kg_`g'
		lab var w_`v'_exp_kg_`g' "`l`v'_exp_kg_`g'' - winsorized top 1%"
	}
}

*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight_pop_rururb] ,  p(95)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winzorized top 5%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winzorized top 5%"
		}
	}
}
 /* ALT: Now handled above
 ***DYA 12.06.19 Because of the use of odd area units in Nigeria, we have many tiny plots. We are reporting yield when area_plan>0.1ha
foreach c of global topcropname_area {
	replace w_yield_pl_`c'=. if w_area_plan_`c'<0.05
	replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
	}
}
*/
*Create final income variables using un_winzorized and un_winzorized values
egen total_income = rowtotal(crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income)
egen nonfarm_income = rowtotal(fishing_income self_employment_income nonagwage_income transfers_income all_other_income)
egen farm_income = rowtotal(crop_income livestock_income agwage_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"
egen w_total_income = rowtotal(w_crop_income w_livestock_income w_fishing_income w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)
egen w_nonfarm_income = rowtotal(w_fishing_income w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"
global income_vars crop livestock fishing self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
	gen `p'_income_s = `p'_income
	replace `p'_income_s = 0 if `p'_income_s < 0
	gen w_`p'_income_s = w_`p'_income
	replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}
egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s w_fishing_income_s w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)
foreach p of global income_vars {
	gen w_share_`p' = w_`p'_income_s / w_total_income_s
	lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}
egen w_nonfarm_income_s = rowtotal(w_fishing_income_s w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
	drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
//ALT 08.16.21: Kludge for imprv seed use - for consistency, it should really be use_imprv_seed 
recode w_total_income w_percapita_income w_crop_income w_livestock_income w_fishing_income w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_fishing w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all  months_food_insec w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
}
*all rural households that harvested specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0
}

*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}

*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 					
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0			
*all rural households eith egg-producing animals
recode w_eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0
  
*Identify smallholder farmers (RULIS definition)
global small_farmer_vars land_size tlu_today total_income 
foreach p of global small_farmer_vars {
	gen `p'_aghh = `p' if ag_hh==1
	_pctile `p'_aghh  [aw=weight_pop_rururb] , p(40) 
	gen small_`p' = (`p' <= r(r1))
	replace small_`p' = . if ag_hh!=1
}
gen small_farm_household = (small_land_size==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 
drop land_size_aghh small_land_size tlu_today_aghh small_tlu_today total_income_aghh small_total_income   
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"

*create different weights 
gen w_labor_weight=weight_pop_rururb*w_labor_total
lab var w_labor_weight "labor-adjusted household weights"
gen w_land_weight=weight_pop_rururb*w_farm_area
lab var w_land_weight "land-adjusted household weights"
gen w_aglabor_weight_all=w_labor_hired*weight_pop_rururb
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=. // cannot create in this instrument  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=. // cannot create in this instrument 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"
gen poultry_owned=. // SRK 8.8.24 - just to make code run thru end of hh var section
//gen weight_milk = milk_animals*weight
//gen weight_egg = poultry_owned*weight
*generate area weights for monocropped plots
foreach cn in $topcropname_area {
	gen ar_pl_mono_wgt_`cn'_all = weight*`cn'_monocrop_ha
	gen kgs_harv_wgt_`cn'_all = weight*kgs_harv_mono_`cn'
	foreach g in male female mixed {
		gen ar_pl_mono_wgt_`cn'_`g' = weight*`cn'_monocrop_ha_`g'
		gen kgs_harv_wgt_`cn'_`g' = weight*kgs_harv_mono_`cn'_`g'
	}
}
gen w_ha_planted_all = ha_planted 
foreach  g in all female male mixed {
	gen area_weight_`g'=weight_pop_rururb*w_ha_planted_`g'
}
gen w_ha_planted_weight=w_ha_planted_all*weight_pop_rururb
drop w_ha_planted_all
gen individual_weight=hh_members*weight_pop_rururb
gen adulteq_weight=adulteq*weight_pop_rururb

*Rural poverty headcount ratio
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 79.531 = 151.1089  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(134.925 - 110.84)/110.84 = 1.6587243	
	// 151.1089* 1.6587243 = 250.648 N
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

//ALT Update START
gen ccf_loc = (1/$Nigeria_GHS_W3_inflation) 
lab var ccf_loc "currency conversion factor - 2021 $NGN"
gen ccf_usd = ccf_loc/$Nigeria_GHS_W3_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Nigeria_GHS_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Nigeria_GHS_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

gen poverty_under_190 = daily_percap_cons < $Nigeria_GHS_W3_poverty_190
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $Nigeria_GHS_W3_poverty_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W3_poverty_npl		
la var poverty_under_npl "Household per-capita consumption is below the 2019 national poverty line."
gen poverty_under_300 = daily_percap_cons < $Nigeria_GHS_W3_poverty_300
la var poverty_under_300 "Household per-capita consumption is below $3.00 in 2021 $PPP"
																	
//ALT Update END																											  
*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*First, generating variable that reports the individuals in the bottom 40% of rural consumption expenditures
*By per capita consumption
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1


*generating clusterid and strataid
gen clusterid=ea
gen strataid=state
/*
*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in wheat beans {
		gen `x'_x = .
		ren *maize*_x *`c'*
	}
}

global empty_vars $empty_vars *wheat* *beans* 
*/
*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* zone state lga ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *n_kg* *p_kg* *k_kg* *inorg_fert* *org_fert* *herb* *pest* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today *sales_livestock_products nb_cows_today lvstck_holding_srum  nb_smallrum_today nb_chickens_today /*
*/ nb_poultry_today nb_largerum_today nb_smallrum_today nb_chickens_t bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* area_harv*  *value_pro* *value_sal* *inter* // SRK 8.8.24 - just to make code run thru end of hh var section

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_largerum_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) & ag_hh==1 // HKS 6.16.23
ren weight weight_sample 
la var weight_sample "Original survey sampling weight"
ren weight_pop_rururb weight
la var weight "Weight adjusted by rural and urban population"
//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria" 
gen survey = "LSMS-ISA" 
gen year = "2015-16" 
gen instrument = 33 
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2" 
label values instrument instrument	
saveold "${Nigeria_GHS_W3_final_data}/Nigeria_GHS_W3_household_variables.dta", replace // HKS 6.16.23


********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_person_ids.dta", clear
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep (1 3) 
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_hhids.dta", nogen keep (1 3)

*Land rights
merge 1:1 hhid indiv using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Nigeria_GHS_W3_final_data}/Nigeria_GHS_W3_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)

replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.
foreach c in wheat beans {
	gen all_imprv_seed_`c' = .
	gen all_hybrid_seed_`c' = .
	gen `c'_farmer = .
}

*Set improved seed adoption to missing if household is not growing crop
foreach v in $topcropname_area {
	replace all_imprv_seed_`v' =. if `v'_farmer==0 | `v'_farmer==.
	recode all_imprv_seed_`v' (.=0) if `v'_farmer==1
	replace all_hybrid_seed_`v' =. if  `v'_farmer==0 | `v'_farmer==.
	recode all_hybrid_seed_`v' (.=0) if `v'_farmer==1
	gen female_imprv_seed_`v'=all_imprv_seed_`v' if female==1
	gen male_imprv_seed_`v'=all_imprv_seed_`v' if female==0
	gen female_hybrid_seed_`v'=all_hybrid_seed_`v' if female==1
	gen male_hybrid_seed_`v'=all_hybrid_seed_`v' if female==0
}
/*
*generate missings
foreach g in all male female{
	foreach c in wheat beans{
	gen `g'_imprv_seed_`c' = .
	gen `g'_hybrid_seed_`c' = .
	}
}
*/
gen female_use_inorg_fert=all_use_inorg_fert if female==1
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var male_imprv_seed_use "1 = Individual male farmer (plot manager) uses improved seeds" 
lab var female_imprv_seed_use "1 = Individual female farmer (plot manager) uses improved seeds"

gen female_vac_animal=all_vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"


*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

ren weight weight_sample 
la var weight_sample "Original survey sampling weight"
ren weight_pop_rururb weight
la var weight "Weight adjusted by rural and urban population"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren indiv indid
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria" 
gen survey = "LSMS-ISA" 
gen year = "2015-16" 
gen instrument = 33 
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
gen strataid=state
gen clusterid=ea
saveold "${Nigeria_GHS_W3_final_data}/Nigeria_GHS_W3_individual_variables.dta", replace


********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
collapse (sum) plot_value_harvest = value_harvest, by(hhid plot_id)
tempfile crop_values 
save `crop_values'

use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_areas.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using `crop_values', nogen keep(1 3)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_decision_makers", keep (1 3) nogen // Bring in the gender file
//merge 1:1 plot_id hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_farmlabor_postharvest.dta", keep (1 3) nogen
//Replaced by below.
merge 1:1 plot_id  hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_plot_labor_days.dta", keep (1 3) nogen

/*DYA.12.2.2020*/ merge m:1 hhid using "${Nigeria_GHS_W3_final_data}/Nigeria_GHS_W3_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

keep if cultivate==1
ren field_size  area_meas_hectares
egen labor_total = rowtotal(labor_family labor_hired labor_nonhired) 
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight_pop_rururb] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}

_pctile plot_value_harvest  [aw=weight_pop_rururb] , p($wins_upper_thres)  
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"

*Productivity at the plot level
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight_pop_rururb 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	
	
/* ALT Update START
*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = (1) * `p' / $Nigeria_GHS_W3_cons_ppp_dollar
	gen `p'_2ppp = (1) * `p' / $Nigeria_GHS_W3_gdp_ppp_dollar
	gen `p'_usd = (1) * `p' / $Nigeria_GHS_W3_exchange_rate 
	gen `p'_loc = (1) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' 2016 (NGN)"  
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = (1) * w_`p' / $Nigeria_GHS_W3_cons_ppp_dollar
	gen w_`p'_2ppp = (1) * w_`p' / $Nigeria_GHS_W3_gdp_ppp_dollar
	gen w_`p'_usd = (1) * w_`p' / $Nigeria_GHS_W3_exchange_rate
	gen w_`p'_loc = (1) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' 2106 (NGN)"
	lab var w_`p' "`lw_`p'' (NGN)" 
}
*/

gen ccf_loc = (1/$Nigeria_GHS_W3_inflation) 
lab var ccf_loc "currency conversion factor - 2021 $NGN"
gen ccf_usd = ccf_loc/$Nigeria_GHS_W3_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Nigeria_GHS_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Nigeria_GHS_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = `p' * ccf_1ppp
	gen `p'_2ppp = `p' * ccf_2ppp
	gen `p'_usd = `p' * ccf_usd 
	gen `p'_loc =  `p' * ccf_loc 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2021 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2021 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2021 $ USD)"
	lab var `p'_loc "`l`p'' (2021 NGN)" 
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = w_`p' * ccf_1ppp
	gen w_`p'_2ppp = w_`p' * ccf_2ppp
	gen w_`p'_usd = w_`p' * ccf_usd
	gen w_`p'_loc = w_`p' * ccf_loc
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2021 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2021 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2021 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2021 NGN)" 
	lab var w_`p' "`lw_`p'' (NGN)" 
}

 
//ALT Update END

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
gen clusterid=ea
gen strataid=state
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean

* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a  here we first take to log of plot productivity. This allows the distribution to be less skewed and less sensitive to extreme values

gen lplot_productivity_usd=ln(plot_productivity_usd) 
lab var lplot_productivity_usd "Log Value of crop production per hectare"
gen larea_meas_hectares=ln(area_meas_hectares)
lab var larea_meas_hectares "Log plot area hectare"
svy, subpop(if rural==1): reg  lplot_productivity_usd male_dummy   
matrix b1a=e(b)
gen gender_prod_gap1a=100*el(b1a,1,1)
sum gender_prod_gap1a
lab var gender_prod_gap1a "Gender productivity gap (%) - regression in logs with no controls"
matrix V1a=e(V)
gen segender_prod_gap1a= 100*sqrt(el(V1a,1,1)) 
sum segender_prod_gap1a
lab var segender_prod_gap1a "SE Gender productivity gap (%) - regression in logs with no controls"

*Gender-gap 1b
svy, subpop(if rural==1) : reg  lplot_productivity_usd male_dummy larea_meas_hectares i.state  
matrix b1b=e(b)
gen gender_prod_gap1b=100*el(b1b,1,1)
sum gender_prod_gap1b
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls"
matrix V1b=e(V)
gen segender_prod_gap1b= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b
lab var segender_prod_gap1b "SE Gender productivity gap (%) - regression in logs with controls"

/*DYA.12.2.2020 - Begin*/ 
*SSP
svy, subpop(  if rural==1 & rural_ssp==1): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.state
matrix b1b=e(b)
gen gender_prod_gap1b_ssp=100*el(b1b,1,1)
sum gender_prod_gap1b_ssp
lab var gender_prod_gap1b_ssp "Gender productivity gap (%) - regression in logs with controls - SSP"
matrix V1b=e(V)
gen segender_prod_gap1b_ssp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_ssp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - SSP"


*LS_SSP
svy, subpop(  if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.state
matrix b1b=e(b)
gen gender_prod_gap1b_lsp=100*el(b1b,1,1)
sum gender_prod_gap1b_lsp
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls - LSP"
matrix V1b=e(V)
gen segender_prod_gap1b_lsp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_lsp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - LSP"
/*DYA.12.2.2020 - End*/ 


//*BET.12.4.2020 - START*/ 


* creating shares of plot managers by gender or mixed
tab dm_gender if rural_ssp==1, generate(manager_gender_ssp)

	rename manager_gender_ssp1 manager_male_ssp
	rename manager_gender_ssp2 manager_female_ssp
	rename manager_gender_ssp3 manager_mixed_ssp

	label variable manager_male_ssp "Male only decision-maker - ssp"
	label variable manager_female_ssp "Female only decision-maker - ssp"
	label variable manager_mixed_ssp "Mixed gender decision-maker - ssp"

tab dm_gender if rural_ssp==0, generate(manager_gender_lsp)

	rename manager_gender_lsp1 manager_male_lsp
	rename manager_gender_lsp2 manager_female_lsp
	rename manager_gender_lsp3 manager_mixed_lsp

	label variable manager_male_lsp "Male only decision-maker - lsp"
	label variable  manager_female_lsp "Female only decision-maker - lsp"
	label variable manager_mixed_lsp "Mixed gender decision-maker - lsp"
	
global gen_gaps gender_prod_gap1b segender_prod_gap1b gender_prod_gap1b_ssp segender_prod_gap1b_ssp gender_prod_gap1b_lsp segender_prod_gap1b_lsp manager_male* manager_female* manager_mixed*

* preserving variable labels
foreach v of var $gen_gaps {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
local l`v' "`v'"
	}
 }

 
preserve
collapse (mean) $gen_gaps

* adding back in variable labels
foreach v of var * {
label var `v' "`l`v''"
}
 
xpose, varname clear
order _varname v1
rename v1 NGA_wave3

save   "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_gendergap.dta", replace
restore
/*BET.12.4.2020 - END*/ 

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight_pop_rururb

ren weight weight_sample 
la var weight_sample "Original survey sampling weight"
ren weight_pop_rururb weight
la var weight "Weight adjusted by rural and urban population"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria" 
gen survey = "LSMS-ISA" 
gen year = "2015-16" 
gen instrument = 33 
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument		
saveold "${Nigeria_GHS_W3_final_data}/Nigeria_GHS_W3_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters

global list_instruments  "Nigeria_GHS_W3"
do "$summary_stats" 


										
