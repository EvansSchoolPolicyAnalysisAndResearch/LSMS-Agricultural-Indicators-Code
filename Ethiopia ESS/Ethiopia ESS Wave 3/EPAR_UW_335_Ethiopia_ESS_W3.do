
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 3 (2015-16)
*Author(s)		: Didier Alia, David Coomes, Jack Knauer, Josh Merfeld, Isabella Sun, Emma Weaver, Ayala Wineman, Pierre Biscaye, Jacob Wall, C. Leigh Anderson, Travis Reynolds, Joaquin Mayorga

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - 19 September 2023
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Ethiopia Socioeconomic Survey was collected by the Ethiopia Central Statistical Agency (CSA) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period September - November 2015, and February - April 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2783

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Ethiopia Socioeconomic Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Ethiopia ESS data set.
*Using data files from within the "Raw DTA files" folder within the "Ethiopia ESS Wave 3" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Ethiopia_ESS_W3_summary_stats.rtf" in the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*
	
*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD-LEVEL VARIABLES			Ethiopia_ESS_W3_household_variables.dta
*FIELD-LEVEL VARIABLES				Ethiopia_ESS_W3_field_plot_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Ethiopia_ESS_W3_individual_variables.dta	
*SUMMARY STATISTICS					Ethiopia_ESS_W3_summary_stats.xlsx

*/


clear
clear matrix
clear mata
set more off
set maxvar 10000		
ssc install findname  // need this user-written ado file for some commands to work	

*Set location of raw data and output
global directory 					"//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves"
*global directory					"/Volumes/wfs/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves" // Mac 
*global directory					"/Volumes/EvansEPAR-1/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves" // Mac 
*global directory "/Volumes/EvansEPAR/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves" // Mac with R Drive
*global directory "/Volumes/EvansEPAR/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves" // Mac with R Drive
*Set directories
global Ethiopia_ESS_W3_raw_data			"$directory/Ethiopia ESS/Ethiopia ESS Wave 3/Raw DTA Files/ETH_2015_ESS_v02_M_STATA8"
global Ethiopia_ESS_W3_created_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 3/Final DTA Files - JM/created_data"
global Ethiopia_ESS_W3_final_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 3/Final DTA Files - JM/final_data" 


********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD IDS
********************************************************************************
global Ethiopia_ESS_W3_exchange_rate 21.2389	// https://www.bloomberg.com/quote/USDETB:CUR
global Ethiopia_ESS_W3_gdp_ppp_dollar 8.668 	// https://data.worldbank.org/indicator/PA.NUS.PPP
global Ethiopia_ESS_W3_cons_ppp_dollar 8.674	// https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
global Ethiopia_ESS_W3_inflation 0

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables



*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Ethiopia_ESS_W3_pop_tot 100835458
global Ethiopia_ESS_W3_pop_rur 81245145
global Ethiopia_ESS_W3_pop_urb 19590313

********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 

global topcropname_area "maize rice wheat sorgum millet grdnt beans swtptt cassav banana teff barley coffee sesame hsbean nueg"		
global topcrop_area "2 5 8 6 3 24 12 62 10 42 7 1 72 27 13 25"
global comma_topcrop_area "2, 5, 8, 6, 3, 24, 12, 62, 10, 42, 7, 1, 72, 27, 13, 25"
global topcropname_full "maize rice wheat sorghum millet groundnut beans sweetpotato cassava banana teff barley coffee sesame horsebean nueg"
global nb_topcrops : word count $topcrop_area

*******************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect_cover_hh_w3.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq04 town
ren saq05 subcity
ren saq06 kebele
ren saq07 ea
ren saq08 hhid
ren pw_w3 weight
ren rural rural2
gen rural = (rural2==1)
lab var rural "1=Rural"
keep region zone woreda town subcity kebele ea hhid rural household_id2 weight
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", replace

********************************************************************************
*WEIGHTS // Joaquin 04.05.23: Added to generate weights.dta to be used in the part of all_fields.dta
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect1_hh_w3.dta", clear 
gen rural1 = (rural==1)
drop rural 
rename rural1 rural 
label var rural "1= Rural"
keep household_id household_id2 pw_w3
codebook household_id
codebook household_id2
collapse (first) pw_w3, by(household_id household_id2)
rename pw_w3 weight
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_weights.dta", replace 

********************************************************************************
* INDIVIDUAL IDS * // JM 11.1.23: Q for Andrew, what to do with the duplicates here?
********************************************************************************
*KEF Added this section per Andrew's guidance. Needed to make a person_id file that was comparable to NGA and TZA. 1/11/22
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect1_pp_w3.dta", clear
keep household_id household_id2 pp_s1q00 pp_s1q02 pp_s1q03
codebook pp_s1q03
gen female = pp_s1q03 == 2
replace female = . if pp_s1q03 > 2
replace female = . if pp_s1q03 == .
replace female = . if pp_s1q03 == 0
lab var female "1 = individual is female"
rename pp_s1q00 personid
rename pp_s1q02 age
rename pp_s1q03 sex
*Household_id2 is the variable that includes the unique identifiers for households added in the urban supplement of Wave 2 (these households were new after Wave 1). These households will not have a household_id because they were not part of Wave 1. 
bysort household_id2 personid: gen dup = cond(_N==1,0,_n)
tab dup 
drop if dup>=2
drop dup 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_person_ids.dta", replace 

********************************************************************************
*INDIVIDUAL GENDER
********************************************************************************
*Using gender from planting and harvesting
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect1_ph_w3.dta", clear
gen personid = ph_s1q00
gen female = ph_s1q03==2	// NOTE: Assuming missings are MALE
replace female =. if ph_s1q03==.
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop household_id2 personid, force
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_ph.dta", replace		

*Planting
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect1_pp_w3.dta", clear
ren pp_s1q00 personid
gen female = pp_s1q03==2	// NOTE: Assuming missings are MALE
replace female =. if pp_s1q03==.
duplicates drop household_id2 personid, force
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_ph.dta", nogen 		
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", replace

*Using household roster for missing gender 
use "$Ethiopia_ESS_W3_raw_data/Household/sect1_hh_w3.dta", clear
ren hh_s1q00 personid
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta"	// 5,474 were in roster but not planting/harvesting modules
duplicates drop household_id2 personid, force			//no duplicates
replace female = hh_s1q03==2 if female==.
*Assuming missings are male
recode female (.=0)		// no changes
duplicates drop individual_id2, force
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", replace

********************************************************************************
* HOUSEHOLD SIZE * // Joaquin 04.05.2023: Added based on *WEIGHTS AND GENDER OF HEAD
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect1_hh_w3.dta", clear // 04.04.2023: Some household_id2 in post-planting are not in post-harvesting 
ren saq08 hhid 
gen fhh = hh_s1q03==2 if hh_s1q02==1		// assuming missing is male - 1 if hh_s1q03==2 and 0 otherwise 
											/* numlabel, add tab hh_s1q02 tab hh_s1q03 tab hh_s1q04a tab fhh tab saq01 tab rural */
*We need to change the strata based on sampling methodology (see BID for more information)
gen clusterid = ea_id2
gen strataid=saq01 if rural==1 //assign region as strataid to rural respondents; regions from from 1 to 7 and then 12 to 15
gen stratum_id=.
replace stratum_id=16 if rural==2 & saq01==1 	//Tigray, small town
replace stratum_id=17 if rural==2 & saq01==3 	//Amhara, small town
replace stratum_id=18 if rural==2 & saq01==4 	//Oromiya, small town
replace stratum_id=19 if rural==2 & saq01==7 	//SNNP, small town
replace stratum_id=20 if rural==2 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, small town
replace stratum_id=21 if rural==3 & saq01==1 	//Tigray, large town
replace stratum_id=22 if rural==3 & saq01==3 	//Amhara, large town
replace stratum_id=23 if rural==3 & saq01==4 	//Oromiya, large town
replace stratum_id=24 if rural==3 & saq01==7 	//SNNP, large town
replace stratum_id=25 if rural==3 & saq01==14 	//Addis Ababa, large town
replace stratum_id=26 if rural==3 & (saq01==2 | saq01==5 | saq01==6 | saq01==12 | saq01==13 | saq01==15) //Other regions, large town
replace strataid=stratum_id if rural!=1 		//assign new strata IDs to urban respondents, stratified by region and small or large towns
gen hh_members = 1 
gen hh_women = hh_s1q03==2
gen hh_adult_women = (hh_women==1 & hh_s1q04a>14 & hh_s1q04a<65)			//Adult women from 15-64 (inclusive)
gen hh_youngadult_women = (hh_women==1 & hh_s1q04a>14 & hh_s1q04a<25) 		//Adult women from 15-24 (inclusive) 
collapse (max) fhh (firstnm) pw_w3 clusterid strataid (sum) hh_members, by(household_id2)
lab var hh_members "Number of household members"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw_w3 "Household weight"
 
*Re-scaling survey weights to match population estimates
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", nogen
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Ethiopia_ESS_W3_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Ethiopia_ESS_W3_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Ethiopia_ESS_W3_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhsize.dta", replace 

********************************************************************************
* FIELD AREAS * // Joaquin 03.14.2023: Need to add 
********************************************************************************


********************************************************************************
*PLOT DECISION-MAKERS
********************************************************************************
*Gender/age variables
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen cultivated = pp_s3q03==1			// if plot was cultivated
*First owner/decision maker 
gen personid = substr(holder_id,-2,.) if pp_s3q10a==. // Joaquin 04.04.23: We use the holder_id's personid to fill missing values 
destring personid, replace 
replace personid = pp_s3q10a if pp_s3q10a!=. 
//gen personid = pp_s3q10a if pp_s3q10a!=. 
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(dm1_merge) keep(1 3)			
*128 not matched from master 
*33177 matched with imputation (23,248 matched without imputation)  
tab dm1_merge cultivate		// If we use don't use holder_id for imputation, almost all unmatched observations are due to field not being cultivated. However, not using holder_id causes issues in the crop expenses part. 
*First decision-maker variables
gen dm1_female = female
drop female personid
*Second owner/decision maker
gen personid = pp_s3q10c_a
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(dm2_merge) keep(1 3)			
*17,293 not matched from master
*16,012 matched
gen dm2_female = female
drop female personid
*Third owner/decision maker
gen personid = pp_s3q10c_b
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(dm3_merge) keep(1 3)			
*29,644 not matched from master
*3,661 matched
gen dm3_female = female
drop female personid
*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
tab dm_gender
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
tab dm_gender 
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender" 4 "NA (HH is in pp but not in ph or hh modules)" // Joaquin 04.06.23: Added label for 4 to account for 15 households present in pp but nor hh or ph modules. This will be helpful in CROP EXPENSES/Labor. 
la val dm_gender dm_gender
lab var dm_gender "Gender of decision-maker(s)"
keep dm_gender holder_id household_id2 field_id parcel_id
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhsize.dta", nogen keep(1 3) keepusing(fhh)
replace dm_gender=1 if missing(dm_gender) & fhh==0 
replace dm_gender=2 if missing(dm_gender) & fhh==1 
drop fhh 
codebook dm_gender 
//browse if dm_gender==.  
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers.dta", replace // Joaquin 03.16.23: Changed name to fit Nigeria W3 do file 

********************************************************************************
* ALL AREA CONSTRUCTION //ALT: Double check with Kelsey to see where this is at
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear

preserve // Joaquin 04.04.2023: preserve/restore checks that holder_id matches the person_id of the manager
	gen holderidnum = substr(holder_id,-2,.)
	destring holderidnum, replace 
	gen equal = holderidnum==pp_s3q10a
	replace equal = . if pp_s3q10a==. 
	tab equal 
restore 

gen cultivated = pp_s3q03==1			// if plot was cultivated
*Generating some conversion factors
gen area = pp_s3q02_a 
gen local_unit = pp_s3q02_c
gen area_sqmeters_gps = pp_s3q05_a
replace area_sqmeters_gps = . if area_sqmeters_gps<0
*Constructing geographic medians for local unit per square meter ratios
preserve
	keep household_id2 holder_id parcel_id field_id area local_unit area_sqmeters_gps // Joaquin 04.04.23: Added holder_id
	merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
	ren sqmeters_per_unit sqmeters_per_unit_zone 
	ren observations obs_zone
	lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_area_lookup_zone.dta", replace
restore
preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
	ren sqmeters_per_unit sqmeters_per_unit_region
	ren observations obs_region
	lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_area_lookup_region.dta", replace
restore
preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep household_id2 parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta"
	drop if _merge==2
	drop _merge
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
	ren sqmeters_per_unit sqmeters_per_unit_country
	ren observations obs_country
	lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_area_lookup_country.dta", replace
restore

*Now creating area - starting with sq meters
gen area_meas_hectares = pp_s3q02_a*10000 if pp_s3q02_c==1			// hectares to sq m
replace area_meas_hectares = pp_s3q02_a if pp_s3q02_c==2			// already in sq m

*For rest of units, we need to use the conversion factors
gen region = saq01
gen zone = saq02
gen woreda = saq03
merge m:1 region zone woreda local_unit using "$Ethiopia_ESS_W3_raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)	// 66 not matched from using, dropped
*20,826 not matched from master
*12,479 matched
replace area_meas_hectares = pp_s3q02_a*conversion if !inlist(pp_s3q02_c,1,2) & pp_s3q02_c!=.			// non-traditional units
*Field area is currently farmer reported - replacing with GPS area when available
replace area_meas_hectares = pp_s3q05_a if pp_s3q05_a!=. & pp_s3q05_a>0			// 32,205 changes
replace area_meas_hectares = area_meas_hectares*0.0001						// Changing back into hectares
*Using our own created conversion factors for still missings observations
merge m:1 region zone local_unit using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_area_lookup_zone.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_meas_hectares==. & obs_zone>=10		
merge m:1 region local_unit using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_area_lookup_region.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_meas_hectares==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_area_lookup_country.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_meas_hectares==.
count if area!=. & area_meas_hectares==.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers.dta", nogen
gen area_meas_hectares_male = area_meas_hectares if dm_gender==1
gen area_meas_hectares_female = area_meas_hectares if dm_gender==2
gen area_meas_hectares_mixed = area_meas_hectares if dm_gender==3

gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)

bysort holder_id household_id2 parcel_id field_id: gen dup = cond(_N==1,0,_n)
tab dup 
//collapse (max) agland cultivated area_meas_hectares*, by(holder_id household_id2 parcel_id field_id) // added 1.20.22
keep household_id2 holder_id parcel_id field_id agland cultivated area_meas_hectares* pp_s3q10a pp_s3q10b  pp_s3q10c_a pp_s3q10c_b
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", replace

*Parcel Area
collapse (sum) land_size = area_meas_hectares area_meas_hectares, by(household_id holder_id parcel_id)
lab var land_size "Parcel area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcel_area.dta", replace

*Household Area
collapse (sum) area_meas_hectares_hh = land_size, by(household_id)
lab var area_meas_hectares_hh "Total area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_household_area.dta", replace

*Cultivated (HH) area
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", clear
keep if cultivated==1
collapse (sum) farm_area = area_meas_hectares, by (household_id)
lab var farm_area "Land size, all cultivated plots (denominator for land productivitiy), in hectares" 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farm_area.dta", replace

*Agricultural land summary and area
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", clear

keep if agland==1
keep household_id2 parcel_id field_id holder_id agland area_meas_hectares
ren area_meas_hectares farm_size_agland_field
lab var farm_size_agland "Field size in hectares, including all plots cultivated, fallow, or pastureland"
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_agland.dta", replace

*Agricultural land area household
collapse (sum) farm_size_agland = farm_size_agland_field, by (household_id2)
lab var farm_size_agland "Total land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmsize_all_agland.dta", replace

***Conversion Factors***
//ALT: Relocated this up from line ~3000 ish; it's needed to run the next section and would cause an error on a fresh run of the code.
*Before harvest, need to prepare the conversion factors
use "$Ethiopia_ESS_W3_raw_data/Food and Crop Conversion Factors/Crop_CF_Wave3.dta", clear
ren mean_cf_nat mean_cf100
sort crop_code unit_cd mean_cf100
duplicates drop crop_code unit_cd, force
reshape long mean_cf, i(crop_code unit_cd) j(region)
recode region (99=5)
ren mean_cf conversion
drop if region==100 //ALT: we'd only ever need the national rate if the regional rate was missing, and there are no missing values here. Small housekeeping step to reduce clutter downstream; not significant.
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cf.dta", replace


*****************************************
*ALL PLOTS (new!) - JW // Joaquin 0.3.16: This section generates all_fields.dta. 
*****************************************
	***************************
	*Crop Values - JW
	***************************
	use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq04 kebele
	ren saq05 ea
	//ren saq06 household_id2 //weight uses household_id2 but is this the correct merge? 

	keep if ph_s11q01==1 
	ren ph_s11q03_a qty
	// do we need condition or unit or size for this section? 
	ren ph_s11q03_b unit_cd
	ren ph_s11q04 value
	//Check and see what this does
	ren ph_s11q22_e percent_sold
	drop if value==0 | value==.
	keep region zone woreda kebele ea household_id2 crop_code qty unit_cd rural value   
	//unit conversion 
	merge m:1 ea household_id2 kebele woreda rural zone region using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", nogen keepusing(weight) keep(1 3) // household_id2 is not unique so merged with other variables 
	//bys ea household_id2 kebele woreda rural zone region : gen temp_household_id2 = _n //bandaid fix for now
	collapse (sum) value qty , by(household_id2 region zone woreda kebele ea crop_code unit_cd weight)
	gen price_unit = value/qty
	gen obs=price_unit!=.
		foreach i in region zone woreda kebele ea household_id2 {
			preserve
			bys `i' crop_code unit_cd : egen obs_`i'_price = sum(obs)
			collapse (median) price_unit_`i'=price_unit [aw=weight], by (`i' unit_cd crop_code obs_`i'_price)
			tempfile price_unit_`i'_median
			save `price_unit_`i'_median'
			restore
		}
	preserve 
		collapse (median) price_unit_country = price_unit (sum) obs_country_price=obs [aw=weight], by(crop_code unit_cd)
		tempfile price_unit_country_median
		save `price_unit_country_median'
	restore

	merge m:1 crop_code unit_cd region using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cf.dta" , nogen keep(1 3)
	gen qty_kg = qty*conversion //8,658 missing values //ALT: Down to 115
	gen price_kg = value/qty_kg 
	drop if price_kg == .
	replace obs=1
	foreach i in region zone woreda kebele ea household_id2 {
			preserve
			bys `i' crop_code : egen obs_`i'_pkg = sum(obs)
			collapse (median) price_kg_`i'=price_kg [aw=weight], by (`i' crop_code obs_`i'_pkg)
			tempfile price_kg_`i'_median
			save `price_kg_`i'_median'
			restore
		}
		preserve
		bys crop_code : egen obs_country_pkg = sum(obs)
		collapse (median) price_kg_country = price_kg [aw=weight], by(crop_code obs_country_pkg)
		tempfile price_kg_country_median
		save `price_kg_country_median'
		restore
	collapse (sum) qty value, by(household_id2 crop_code unit_cd) // Joaquin 03.16.23: Added unit_cd to by() 
	la var qty "Quantity harvested" // Joaquin 03.16.23: Added label to avoid confusion with qty_harvest below 
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_vals_hhids.dta" , replace
		
	***Value harvest using Uganda W8 as a model code*****

	use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect9_ph_w3" , clear
	merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares) // 1 not matched from master ren saq01 region
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq04 kebele
	ren saq05 ea
	ren ph_s9q04_b unit_cd	
	merge m:1 crop_code unit_cd region using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cf.dta", gen(cf_merge) 
	*8,658 not matched
	*21,664 matched
	//ALT excluding missing unit code, 4260; excluding kg, 3794
	bys crop_code unit_cd: egen national_conv = median(conversion)
	replace conversion = national_conv if conversion==.			// replacing with median if missing -- 1,517
	bys unit_cd region: egen national_conv_unit = median(conversion)
	replace conversion = national_conv_unit if conversion==. & unit_cd!=900		// Not for "other" ones -- 2,105 changes
	tab unit_cd			// 0.43 percent (111) of field-crop observations are reported with "other" units
	tab crop_name ph_s9qo4_b_other if unit_cd==900
	*None of the "other" units are for cereal crops so will skip adding in those food conversion factors
	gen qty_kg_harvest = ph_s9q04_a*conversion
	replace qty_kg_harvest = ph_s9q05 if qty_kg_harvest ==.
	keep household_id2 holder_id parcel_id field_id crop_code qty* unit* conv* region zone woreda kebele ea 

	foreach i in region zone woreda kebele ea household_id2 {
		merge m:1 `i' unit_cd crop_code using `price_unit_`i'_median' , nogen keep(1 3)
		merge m:1 `i' crop_code using `price_kg_`i'_median', nogen keep(1 3)
	}
		merge m:1 unit_cd crop_code using `price_unit_country_median', nogen keep(1 3)
		merge m:1 crop_code using `price_kg_country_median', nogen keep(1 3)
	gen value_harvest = .
	*CPK: this should be imputing over price_kg because harvest is already in kg.
	
			replace value_harvest = qty_kg_harvest * price_kg_household_id2
			//replace value_harvest = qty_harvest * price_kg_hhid if value_harvest == .
	foreach i in ea kebele woreda zone region {
		
		replace value_harvest = qty_kg_harvest * price_kg_`i' if value_harvest == . & obs_`i'_price > 9
	*		replace value_harvest = qty_harvest * price_unit_`i' if value_harvest == . & obs_`i'_price > 9
	}
/*
	foreach i in  ea kebele woreda zone region {
		replace value_harvest = qty_harvest * price_kg_`i' if value_harvest ==. & obs_`i'_pkg > 9
	} 
*/
	//replace qty_harvest = qty_harvest * conv_fact 
	collapse (sum) qty_kg_harvest value_harvest, by(household_id2 holder_id parcel_id field_id crop_code)
	//ren parcelID parcel_id
	//ren pltid plot_id 
	la var qty_kg_harvest "Quantity harvested, kg dry/shelled equivalent"

	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_harvvals_hhids.dta", replace  

	***************************
	*Plot variables - JW // Joaquin 03.16: This genereates all_fields.dta. Variables by field-crop: area planted, area harvested, qty harvested, value of qty harvested  
	***************************	

use "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect4_pp_w3.dta", clear
	merge 1:1 household_id2 holder_id parcel_id field_id crop_code using "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect9_ph_w3"
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq04 kebele
	ren saq05 ea
	rename ph_s9q04_b unit_cd
	la def cropcode 1 "barley" 2 "maize" 3 "millet" 4 "oats" 5 "rice" 6 "sorghum" 7 "teff" 8 "wheat" 9 "mung bean" 10 "cassava" 11 "chick peas" 12 "haricot beans" 13 "horse beans" /*=fava bean*/ 14 "lentils" 15 "field peas" 16 "vetch" /*ALT: not a food crop*/ 17 "gibto" /*ALT: White lupin*/ 18 "soybeans" 19 "kidney beans" 20 "fennel" 21 "castor beans" 22 "cottonseed" 23 "flaxseed" 24 "groundnuts" 25 "nueg" /*Nyjerseed, feed crop*/ 26 "rapeseed" /*i.e. canola*/ 27 "sesame" 28 "sunflower" 29 "mego" 30 "savory" 31 "black cumin" /*Nigella*/ 32 "black pepper" 33 "cardamom" 34 "chili pepper" 35 "cinnamon" 36 "fenugreek" 37 "ginger" 38 "red pepper" 39 "tumeric" 40 "white lupin" /*ALT: This is the same as 17, does the separate cropcode imply it's being used as livestock forage or cover? */  41 "apples" 42 "bananas" 43 "grapes" 44 "lemons" 45 "mandarins" 46 "mangos" 47 "oranges" 48 "papaya" 49 "pineapple" 50 "citron" 51 "beer root" /*ALT: I cannot find any English-language references to this outside of LSMS - is it supposed to be beetroot? */ 52 "cabbage" 53 "carrot" 54 "cauliflower" 55 "garlic" 56 "kale" 57 "lettuce" 58 "onion" 59 "green pepper" 60 "potatoes" 61 "pumpkin" 62 "sweet potato" 63 "tomatoes" 64 "godere" /*ALT: Likely taro, should update crop codes to reduce regional variants like this one */ 65 "guava" 66 "peach" 67 "mustard" 68 "feto" /*garden cress?*/ 69 "spinach" 70 "green beans" 71 "chat" 72 "coffee" 73 "cotton" 74 "enset" 75 "gesho" /*buckthorn*/ 76 "sugarcane" 77 "tea" 78 "tobacco" 79 "coriander" 80 "sacred basil" /* tulsi */ 81 "rue" 82 "gishita" /*soursop*/ 83 "watermelon" 84 "avocado" 85 "forage" /*clarifying this from "Grazing land" */ 86 "temporary gr" /*Temporary forage? Not clear what this is*/ 97 "pijapin" /*Doesn't appear outside of LSMS, no obs */ 98 "other root crop" /*Cut off by char limit?*/ 99 "other land" 108 "amboshika" /*skipping 100-112, no obs, no idea what some of these are. Couldn't find any database entries with NL20F. */ 112 "kazmir" /*white sapote*/ 113 "strawberry" 114 "shiferaw" /*moringa*/ 115 "other fruit" 116 "timez kimem" /*Spice?*/ 117 "other spices" 118 "other pulses" 119 "other oilseed" 120 "other cereal" 121 "other case crop" /*=cover crop?*/ 123 "other vegetable"
	la val crop_code cropcode 
	rename pp_s4q14 number_trees_planted
	merge m:1 crop_code unit_cd region using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cf.dta", nogen keep(1 3)
	//End ALT edit
	collapse (max) pp_s4q03 pp_s4q02 number_trees_planted, by(household_id2 holder_id parcel_id field_id crop_code)
	merge m:1 household_id2 holder_id parcel_id field_id  using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares) // 4 not matched from master 
	gen ha_planted = area_meas_hectares * pp_s4q03 / 100 
	replace ha_planted = area_meas_hectares if pp_s4q02 == 1 & ha_planted == .
	collapse (sum) ha_planted number_trees_planted, by(household_id2 holder_id parcel_id field_id crop_code) // Joaquin 03.16: No changes in obs #. Equivalent to keeping ids and ha_planted. 
	tempfile planting_area
	save `planting_area'

	use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect9_ph_w3" , clear
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq04 kebele
	ren saq05 ea

	merge 1:1 household_id2 holder_id parcel_id field_id crop_code using "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect4_pp_w3" , nogen keep(1 3) // 5 not matched 
	gen crop_code_master = crop_code 
	
	gen perm_tree = inlist(crop_code_master, 10, 35, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 65, 66, 72, 74, 75, 76, 82, 84, 112, 115) // getting an error "unknown function()" //ALT: Cannot reproduce error - fixed?
	lab var perm_tree "1 = Tree or permanent crop"

	gen month_planted = pp_s4q12_a 
	gen year_planted = pp_s4q12_b 
	replace month_planted = month_planted + 13 if year_planted == 2008 //13 months in Ethiopia
	gen month_harvest = ph_s9q07_b + 13 // all harvest occured in 2008 
	//ALT: need to account for missings here
	recode month_planted (.=0)
	recode month_harvest (.=999)
	recode month_planted month_harvest (0 999 = .)
	gen months_grown = month_harvest - month_planted if perm_tree == 0
	replace months_grown = . if months_grown < 1 | month_planted == . | month_harvest == .
	
	gen reason_loss = ph_s9q10_a // why was the area harvested less than the area planted (1st reason)
	replace reason_loss = ph_s9q10_b if reason_loss == . // why was the area harvested less than the area planted (2nd reason)
	gen lost_crop = inrange(reason_loss,1,7) //1-7 include reasons for crop loss besides "other"
	bys household_id2 holder_id parcel_id field_id : egen max_lost = max(lost_crop)

	preserve
		gen obs1 = 1
		replace obs1 = 0 if inrange(reason_loss,1,15) //obs1 = 0 if crop was lost for some reason like security problems, flooding, pests, rain, etc. // Joaquin 03.16: changed obs to obs1 because obs already exists in Post-Harvest/sect9_ph_w3
		collapse (sum) crops_plot = obs1, by(household_id2 holder_id parcel_id field_id)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 household_id2 holder_id parcel_id field_id using `ncrops' , nogen 

	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //808 observations dropped...is that ok? Should these be dropped? //ALT: I think we run the risk of over-estimating planted area for certain variables if we include crops that were lost and replaced. Should take this up with Didier. 
	
	*Generating monocropped plot variables (Part 1)
	bys household_id2 holder_id parcel_id field_id: egen crops_avg = mean(crop_code_master) // checks for different versions of the same crop in the same plot 
**# Bookmark #4
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	//edit household_id2 holder_id parcel_id field_id crop_code crops_plot purestand pp_s4q02 reason_loss if household_id2=="041904088800101095"
	
	bys household_id2 holder_id parcel_id field_id : 				egen permax = max(perm_tree)
	bys household_id2 holder_id parcel_id field_id pp_s4q12_a : 	gen plant_date_unique = _n
	bys household_id2 holder_id parcel_id field_id month_harvest : 	gen harv_date_unique = _n
	bys household_id2 holder_id parcel_id field_id : 				egen plant_dates = max(plant_date_unique)
	bys household_id2 holder_id parcel_id field_id : 				egen harv_dates = max(harv_date_unique)
	
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) // JM 8.17: 8821 changes

	*Generating mixed stand plot variables (Part 2)
	gen any_mixed = (pp_s4q02 == 2)
	bys household_id2 holder_id parcel_id field_id : egen any_mixed_max = max(any_mixed)
	// replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & any_mixed_max == 0 /
	// Made to changes in 2 changes in household_id2=="030308088801617151", parcel_id==3, field_id==1. This field has two crops on purestand. Looks like we consider purestand those fields where the entire are is planted with one single crop. 
	
	gen contradict_mono = pp_s4q02 == 1 & crops_plot > 1
	gen contradict_inter = crops_plot == 1 & (ph_s9q01 == 2 | pp_s4q02 ==2)
	
	bys household_id2 holder_id parcel_id field_id : egen max_mo_planted = max(month_planted)
	bys household_id2 holder_id parcel_id field_id : egen min_mo_harvest = min(month_harvest)

	gen relay = max_mo_planted > min_mo_harvest // ALT: 35.7% of crops were relayed. Does this seem reasonable? JM 08.17.23: relay definition is different in Nigeria W3 code; seems ok. 
	replace purestand = 1 if crop_code_master == crops_avg 
	replace purestand = 0 if purestand == .
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"

	//edit household_id2 holder_id parcel_id field_id crop_code crop_code_master crops_avg  crops_plot purestand if household_id2=="030308088801617151"
		
	merge 1:1 household_id2 holder_id parcel_id field_id crop_code  using `planting_area', nogen keep(1 3)           //5 not matched , 5 from master // Joaquin 03.16: due to "drop if replanted == 1 & lost_crop == 1", all in master are matched 
	merge m:1 household_id2 holder_id parcel_id field_id  using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3)  // Joaquin 03.16: 1 not matched, 1 from master //5 not matched , 5 from master
	
	gen ha_harvest = ha_planted if ph_s9q08 == 2 //was area planted less than area harvested? 2=no // 
	replace ha_harvest = ph_s9q09 / 100 * area_meas_hectares if ph_s9q08 == 1 // harvest area was less than planted area 
	replace ha_harvest = 0 if ha_harvest==.
	replace ha_harvest = ha_planted if ha_harvest > ha_planted //764 changes 

	gen percent_field = ha_planted/area_meas_hectares 
	bys household_id2 holder_id parcel_id field_id : egen total_percent = total(percent_field) // 373 plots have a total intercropped sum greater than 1
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	
	
	replace ha_planted = percent_field*area_meas_hectares // Joaquin 03.16 (9,338 real changes made, 30 to missing)
	replace ha_harvest = ha_planted if ha_harvest > ha_planted // Joaquin 03.16: (487 real changes made)
	
	merge m:1 household_id2 holder_id parcel_id field_id crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_harvvals_hhids.dta" , nogen keep(1 3) // All matche. Joaquin 03.16.12: Use file above to get qty harvested 
	
	// Joaquin 03.16.23: Now we match with cf.dta and weights.dta. Goal is to create hh_crop_prices_for_wages.dta
	rename ph_s9q04_b unit_cd 
	merge m:1 crop_code unit_cd region /*saq02: zone*/ using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cf.dta", nogen keep(1 3) // 8421 not matched from master 
	merge m:1 household_id2  using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_weights.dta", nogen keep(1 3) // 8421 not matched from master 
	gen fieldweight = ha_planted * weight 
	gen yield = qty_kg_harvest / ha_planted // Joaquin 03.16.23: Need to check if yield values are reasonable 
	
	foreach i in region zone woreda kebele ea {
		merge m:1 `i' unit_cd crop_code using `price_unit_`i'_median', nogen keep(1 3)
		merge m:1 `i' crop_code using `price_kg_`i'_median', nogen keep(1 3)
}
	merge m:1 unit_cd crop_code using `price_unit_country_median', nogen keep(1 3)
	merge m:1 crop_code using `price_kg_country_median', nogen keep(1 3)

	gen price_unit = . 
	gen price_kg = .
	foreach i in country region zone woreda kebele ea { // 
		replace price_unit = price_unit_`i' if obs_`i'_price>9 & obs_`i'_price != .
		replace price_kg = price_kg_`i' if obs_`i'_pkg>9 & obs_`i'_price != .
}	
	gen val_unit = price_kg if unit_cd==1 
	replace val_unit = price_unit if unit_cd>=2 

	merge m:1 household_id2 crop_code unit_cd using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_vals_hhids.dta", nogen keep(1 3)
	replace val_unit = value / qty if val_unit ==. 
	
preserve
	ren unit_cd unit
	collapse (mean) val_unit, by (household_id2 crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_prices_for_wages.dta", replace
restore
	
	
	keep holder_id val* qty* crop_code ha_planted number_trees_planted percent_field months_grown household_id2 parcel_id field_id crop_code_master crops_plot reason_loss purestand relay area_meas_hectares cultivate

	sort household_id2 holder_id parcel_id field_id crop_code_master 
	quietly by household_id2 holder_id parcel_id field_id crop_code_master: gen dup = cond(_N==1,0,_n)
	tab dup
	drop if dup > 1 //81 observations dropped //ALT 12.27: updated from 0 to 1 - we should keep the original. We should check if this is an issue with the raw dta files or if there's a weird merge result here. // Joaquin 03.16: No dups 
	drop if qty_kg_harvest ==.
	ren qty_kg_harvest quant_harv_kg

	merge m:1 household_id2 holder_id parcel_id field_id crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_harvvals_hhids.dta" , nogen keep(1 3) // 
	
	merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares cultivated) // Joaquin 8.17: 1 not matched from master ren saq01 region

	keep holder_id val* quant* crop_code cultivated ha_planted number_trees_planted percent_field months_grown household_id2 parcel_id field_id crop_code_master purestand relay crops_plot reason_loss area_meas_hectares

	//not uniquely identifying 
	*report duplicates //113 dups
	sort household_id2 holder_id parcel_id field_id crop_code_master 
	quietly by household_id2 holder_id parcel_id field_id crop_code_master: gen dup = cond(_N==1,0,_n)
	tab dup
	drop if dup > 1 // Joaquin 8.17.23: No observation is dropped. 
	drop dup 
	drop if household_id2 =="" // Joaquin 03.16: One obs deleted 
	
	*AgQuery
		collapse (sum) quant_harv_kg value_harvest ha_planted percent_field number_trees_planted (max) months_grown cultivate (first) crops_plot reason_loss, by(/*region zone woreda town subcity kebele ea*/ household_id2 holder_id parcel_id field_id crop_code_master purestand relay area_meas_hectares)
		bys household_id2 holder_id parcel_id field_id : egen percent_area = sum(percent_field)
		bys household_id2 holder_id parcel_id field_id : gen percent_inputs = percent_field / percent_area
		drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
		
	bysort household_id2 holder_id parcel_id field_id: gen dup=cond(_N==1,0,_n)
	tab dup 
	drop dup 
	gen ha_harvest = ha_planted
	drop if parcel_id == . //ALT: few blank entries here - check merges.
	merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	
	bysort household_id2 holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
	drop dup 
**#
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", replace

********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
// Joaquin 2.3.23: Changed Nigeria W3 do file to use Ethiopia files.  
// Joaquin 3.16.23: Moved from below to match order of Nigeria W3 do file 
*Generating Value of crop sales

use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect11_ph_w3.dta", clear
//ren cropcode crop_code 
ren saq01 region 
ren ph_s11q04 sales_value
recode sales_value (.=0)
ren ph_s11q03_a quantity_sold
ren ph_s11q03_b unit_quantity_sold
*renaming unit code for merge 
ren unit_quantity_sold unit_cd
*merging in conversion factors
merge m:1 crop_code unit_cd region using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cf.dta", gen(cf_merge)
gen kgs_sold= quantity_sold*conversion
collapse (sum) sales_value kgs_sold, by (household_id2 crop_code)
lab var sales_value "Value of sales of this crop"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropsales_value.dta", replace 

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
ren crop_code_master crop_code
//ren val_harv value_harvest 
collapse (sum) value_harvest , by (household_id2 crop_code) 
merge 1:1 household_id crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropsales_value.dta"
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
recode  value_harvest value_crop_sales  (.=0)
collapse (sum) value_harvest value_crop_sales, by (household_id2 crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production.dta", replace 
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (household_id2)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect11_ph_w3.dta", clear
merge m:1 household_id2 crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production.dta", nogen keep(1 3)
foreach var in ph_s11q15_1 ph_s11q15_2 ph_s11q15_4 {
	summ `var',d 
}
ren ph_s11q15_4 share_lost
recode share_lost (.=0)
gen crop_value_lost = value_crop_production * (share_lost/100)
ren ph_s11q09 value_transport_cropsales
recode value_transport_cropsales (.=0)
collapse (sum) crop_value_lost value_transport_cropsales, by (household_id2)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_losses.dta", replace



********************************************************************************
* CROP EXPENSES *
********************************************************************************
**# Bookmark Labor

	*********************************
	* 			LABOR				*
	*********************************
	// Joaquin 03.14.2023: Adapting to Nigeria. This is useful for merges below. Goal is to generate hh_cost_labor.dta 
	
use "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect3_pp_w3.dta", clear // hired labor post planting 
	ren pp_s3q28_a numberhiredmale
	ren pp_s3q28_d numberhiredfemale
	ren pp_s3q28_g numberhiredchild
	ren pp_s3q28_b dayshiredmale
	ren pp_s3q28_e dayshiredfemale
	ren pp_s3q28_h dayshiredchild
	ren pp_s3q28_c wagehiredmale
	ren pp_s3q28_f wagehiredfemale
	ren pp_s3q28_i wagehiredchild 
	ren pp_s3q29_a numbernonhiredmale
	ren pp_s3q29_c numbernonhiredfemale
	ren pp_s3q29_e numbernonhiredchild
	ren pp_s3q29_b daysnonhiredmale
	ren pp_s3q29_d daysnonhiredfemale
	ren pp_s3q29_f daysnonhiredchild
	ren saq01 region 
	ren saq02 zone 
	ren saq03 woreda 
	ren saq04 kebele 
	ren saq05 ea 
	keep household_id2 holder_id parcel_id field_id *hired* // Joaquin 03.21.23: Changed household_id to household_id2
	gen season="pp"
tempfile postplanting_hired
save `postplanting_hired'

use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect10_ph_w3.dta" , clear // hired labor post harvest 
	ren ph_s10q01_a numberhiredmale 
	ren ph_s10q01_b dayshiredmale
	ren ph_s10q01_c wagehiredmale //Wage per person/per day
	ren ph_s10q01_d numberhiredfemale
	ren ph_s10q01_e dayshiredfemale
	ren ph_s10q01_f wagehiredfemale
	ren ph_s10q01_g numberhiredchild
	ren ph_s10q01_h dayshiredchild
	ren ph_s10q01_i wagehiredchild
	ren ph_s10q03_a numbernonhiredmale
	ren ph_s10q03_b daysnonhiredmale
	ren ph_s10q03_c numbernonhiredfemale
	ren ph_s10q03_d daysnonhiredfemale
	ren ph_s10q03_e numbernonhiredchild
	ren ph_s10q03_f daysnonhiredchild
	ren saq01 region 
	ren saq02 zone 
	ren saq03 woreda 
	ren saq04 kebele 
	ren saq05 ea 
	keep region zone woreda kebele ea household_id2 holder_id parcel_id field_id *hired*  // Joaquin 03.21.23: Changed household_id to household_id2. Nigeria W3 do file keeps crop_code because of in-kin payments. No in-kind payments here.  
	collapse (sum) *hired*, by(region zone woreda kebele ea household_id holder_id parcel_id field_id)
	gen season="ph"
	tempfile postharvesting_hired
	preserve 	
		sort region zone woreda kebele ea household_id holder_id parcel_id field_id season
		quietly by region zone woreda kebele ea household_id holder_id parcel_id field_id season:  gen dup = cond(_N==1,0,_n)
		tab dup 
	restore 
save `postharvesting_hired'
	
append using `postplanting_hired' // at field level 

// Joaquin 03.20.23: Need to merge with hhid to get household_id2 and be able to merge with created datasets 

unab vars : *female
local stubs : subinstr local vars "female" "", all
display "`stubs'"

reshape long `stubs', i(region zone woreda kebele ea household_id2 holder_id parcel_id field_id season) j(gender) string
	sort region zone woreda kebele ea household_id2 holder_id parcel_id field_id season
reshape long number days wage, i(household_id2 holder_id parcel_id field_id gender season) j(labor_type) string 
	gen val = days*number*wage

// Joaquin 03.16.23: Generate "median wages": `wage_`i'_median', `wage_country_median', `all_hired'

merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares)
gen fieldweight = weight*area_meas_hectares
recode wage (0=.)
gen obs=wage!=.
*Median wages

foreach i in region zone woreda kebele ea household_id2 {
preserve
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i'=wage [aw=fieldweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
}
preserve
collapse (median) wage_country = wage (sum) obs_country=obs [aw=fieldweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore

drop obs fieldweight wage 
tempfile all_hired
save `all_hired'

// Family labor 
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear 
	ren pp_s3q27_a pid1
	ren pp_s3q27_e pid2 
	ren pp_s3q27_i pid3 
	ren pp_s3q27_m pid4
	ren pp_s3q27_b weeks_worked1 
	ren pp_s3q27_f weeks_worked2 
	ren pp_s3q27_j weeks_worked3 
	ren pp_s3q27_n weeks_worked4
	ren pp_s3q27_c days_week1
	ren pp_s3q27_g days_week2 
	ren pp_s3q27_k days_week3 
	ren pp_s3q27_o days_week4
keep household_id2 holder_id parcel_id field_id pid* weeks_worked* days_week*
preserve
	bysort household_id2 holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
gen season="pp"
tempfile postplanting_family
save `postplanting_family'

use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect10_ph_w3.dta" , clear // Joaquin 04.03.23: Data is at crop level. Collapse at field level?  
	ren ph_s10q02_a pid1
	ren ph_s10q02_b weeks_worked1 
	ren ph_s10q02_c days_week1
	ren ph_s10q02_e pid2 
	ren ph_s10q02_f weeks_worked2 
	ren ph_s10q02_g days_week2 
	ren ph_s10q02_i pid3 
	ren ph_s10q02_j weeks_worked3
	ren ph_s10q02_k days_week3 
	ren ph_s10q02_m pid4
	ren ph_s10q02_n weeks_worked4
	ren ph_s10q02_o days_week4
	
keep household_id2 holder_id parcel_id field_id pid* weeks_worked* days_week*
preserve
	bysort household_id2 holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
collapse pid* weeks_worked* days_week*, by(household_id2 holder_id parcel_id field_id)
gen season="ph"
tempfile postharvesting_family
save `postharvesting_family'

// Other labor 
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear // Joaquin 03.24.23: Data is at field level 
	ren pp_s3q29_a numberothermale
	ren pp_s3q29_b daysothermale
	ren pp_s3q29_c numberotherfemale
	ren pp_s3q29_d daysotherfemale
	ren pp_s3q29_e numberotherchild
	ren pp_s3q29_f daysotherchild
keep household_id2 holder_id parcel_id field_id number* days* 
gen season = "pp"
tempfile postplanting_other 
preserve
	bysort household_id2 holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
save `postplanting_other'

use "${Ethiopia_ESS_W3_raw_data}/Post-Harvest/sect10_ph_w3.dta" , clear // Joaquin 03.24.23: Data is at crop level. Collapse at field level?  
	ren ph_s10q03_a numberothermale
	ren ph_s10q03_b daysothermale
	ren ph_s10q03_c numberotherfemale
	ren ph_s10q03_d daysotherfemale
	ren ph_s10q03_e numberotherchild
	ren ph_s10q03_f daysotherchild
keep household_id2 holder_id parcel_id field_id number* days* 
collapse number* days*, by(household_id2 holder_id parcel_id field_id)
preserve
	bysort household_id2 holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
gen season = "ph"
tempfile postharvesting_other 
save `postharvesting_other'

// Members 
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect1_pp_w3.dta", clear
	ren pp_s1q00 pid
	drop if pid==.
	preserve 
		bysort household_id2 pid: gen dup=cond(_N==1,0,_n)
		tab dup 
		bysort household_id2 pid: egen obs_num = sum(1) 
		tab obs_num 
		tab obs_num dup // Joaquin 04.03.24: Every duplicate is associated with only one person. 
	restore
	ren pp_s1q02 age
	gen male = pp_s1q03==1
	rename saq01 region 
	rename saq02 zone
	rename saq03 woreda
	rename saq04 kebele
	rename saq05 ea
	keep region zone woreda kebele ea household_id2 pid age male
	collapse (first) age male, by(region zone woreda kebele ea household_id2 pid)
	codebook male 
tempfile members
save `members', replace 

// Generate long files 
// Joaquin 03.16.23: Use all above labor tempfiles to generate:  plot_labor_long.dta, plot_labor.dta, hh_cost_labor.dta
use `postplanting_family', clear 
append using `postharvesting_family'
preserve 
	bysort household_id2 holder_id parcel_id field_id season: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
reshape long pid weeks_worked days_week, i(household_id2 holder_id parcel_id field_id season) j(colid) string 
gen days=weeks_worked*days_week
drop if days==.
merge m:1 household_id2 pid using `members', nogen keep(1 3)
gen gender="child" if age<16
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
keep region zone woreda kebele ea household_id2 holder_id parcel_id field_id season gender days labor_type
// Joaquin 034.03.23: The is no *exchange labor* in ETH W3. 
foreach i in region zone woreda kebele ea household_id2 {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) // 
	gen wage=wage_household_id2
foreach i in region zone woreda kebele ea {
	replace wage = wage_`i' if obs_`i' > 9
}
egen wage_sd = sd(wage_household_id2), by(gender season)
egen mean_wage = mean(wage_household_id2), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 14 stdevs above the mean while the min is only 1.15 below. 
*/
replace wage=wage_household_id2 if wage_household_id2 !=. & abs(wage_household_id2-mean_wage)/wage_sd <3 //Using household wage when available, but omitting implausibly high or low values. Trims about 5,000 hh obs, max goes from 80,000->35,000; mean 3,300 -> 2,600

gen val = wage*days
append using `all_hired'
keep household_id2 holder_id parcel_id field_id season days val labor_type gender number
drop if val==.&days==.
merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers", nogen keep(1 3) keepusing(dm_gender)
codebook dm_gender // 458 missing values for dm_gender.
preserve // Joaquin 04.05.23: preserve-restore checks if the hhs with missing dm_gender are part of the hh module 
	keep if dm_gender==.  
	recode dm_gender (.=4) 
	collapse (first) dm_gender, by(household_id2)
	tab dm_gender 
	merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta" // Joaquin 04.05.23: HHs with dm_gender missing are not part of the hh module.   
restore 

replace dm_gender = 1 if dm_gender==. // Joaquin 07.07.23: Imputing male for dm_gender missing values 

collapse (sum) number val days, by(household_id2 holder_id parcel_id field_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor_long.dta",replace

preserve
	collapse (sum) labor_=days, by (household_id2 holder_id parcel_id field_id labor_type)
	reshape wide labor_, i(household_id2 holder_id parcel_id field_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor_days.dta",replace //AgQuery
restore

preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	//append using `inkind_payments'
	collapse (sum) val, by(household_id2 holder_id parcel_id field_id exp dm_gender)
	codebook dm_gender 
	gen input="labor"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor.dta", replace //this gets used below.
restore	

//And now we go back to wide
collapse (sum) val, by(household_id2 holder_id parcel_id field_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(household_id2 holder_id parcel_id field_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(household_id2 holder_id parcel_id field_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
codebook dm_gender2 
ren val* val*_
reshape wide val*, i(household_id2 holder_id parcel_id field_id) j(dm_gender2) string
collapse (sum) val*, by(household_id2)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_cost_labor.dta", replace

****************************************************** ***************************
* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES * // Added Joaquin 03.14.2023
****************************************************** ***************************
**# Plot inputs 
	*** Pesticides/Herbicides/Animals/Machines
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear // Joaquin 04.06.23: This module contains pesticide, herbicide, fungicide info. For these inputs, we only have dummy information, while Nigeria W3 has value and quantity info.
// Joaquin 5.17.23: Completed code for field-level dummies 
	
	// 5/3/2023 Only dummy variables 
	// Modify the code 
	// 420 Folder /  AgQury + Compilation code 

	rename	pp_s4q05 usepestexp // Pesticide dummy 
	rename	pp_s4q07 usefungexp // Fungicide dummy 
	rename	pp_s4q06 useherbexp  // Herbicide dummy 

	keep holder_id household_id2 parcel_id field_id crop_code use* 

	unab vars : *exp
	local stubs : subinstr local vars "exp" "", all
	display "`stubs'"
	gen dummya = 1
	gen dummyb = sum(dummya)
	drop dummya
	reshape long `stubs', i(household_id2 holder_id parcel_id field_id crop_code dummyb) j(exp) string
	gen dummyc = sum(dummyb)
	drop dummyb 
	reshape long use, i(household_id2 holder_id parcel_id field_id crop_code dummyc) j(input) string
	recode use (2=.)
	collapse (sum) use, by(household_id2 holder_id parcel_id field_id input exp)
	replace use = 1 if use>=2 
	//gen itemcode = 1 // Dummy variable 
	gen qty = .  // JM 09.11.23: The module does not have information on quantity used 
	gen unit = . // JM 09.11.23: The module does not have information on quantity used 
	tempfile field_inputs
	save `field_inputs'

		** plot_inputs 
	
	***Fertilizer
	
		** phys_unouts 
**# Bookmark #1
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear // Joaquin 04.06.23: This module contains fertilizer info. 

	// NGA and ETH both have info at plot level. 

	// Joaquin 04.26: List of relevant variables 
		// Urea:  pp_s3q15 pp_s3q16 pp_s3q16b pp_s3q16c pp_s3q16d pp_s3q17_a pp_s3q17_b
		// DAP:  pp_s3q18 pp_s3q19 pp_s3q19b pp_s3q19c pp_s3q19d pp_s3q20_a pp_s3q20_b
		// NPS:  pp_s3q20a_1 pp_s3q20a_2 pp_s3q20a_3 pp_s3q20a_4 pp_s3q20a_5 pp_s3q20a_6_a pp_s3q20a_6_b
		// Other:  pp_s3q20a pp_s3q20a_7 pp_s3q20b pp_s3q20b_1 pp_s3q20c pp_s3q20d_a pp_s3q20d_b
		// Manure:  pp_s3q21 pp_s3q22_a pp_s3q22_b
		// Compost:  pp_s3q23 pp_s3q24_a pp_s3q24_b
		// Other organic:  pp_s3q25 pp_s3q26_a pp_s3q26_b

	// Joaquin 04.26: Nigeria uses postharvest module. 
	// Joaquin 04.26: Nigeria Item codes: 1 NPK, 2 Urea, 4 Other. 
	// Joaquin 04.26: No quantity information for manure, compost, other inorganic 
	// Joaquin 04.26: There are no transportation costs 
	// Joaquin 04.26: No variables on use of left-over fertilizer, so no "imp" variables and no "exp" reshape. 

	// Urea
	gen usefertexp1 = 1 if pp_s3q15==1 
	//gen itemcodefertexp = 1 if usefertexp1 == 1 
	gen qtyfertexp1 = pp_s3q16
	gen unitfertexp1 = 1 if pp_s3q15==1 // Qty is in kilos 
	gen valfertexp1 = pp_s3q16d if pp_s3q15==1

	// DAP 
	gen usefertexp2 = 1 if pp_s3q18==1 
	//gen itemcodefertexpexp = 2 if usefertexpexp2 == 1 
	gen qtyfertexp2 = pp_s3q19
	gen unitfertexp2 = 1 if pp_s3q18==1 // Qty is in kilos 
	gen valfertexp2 = pp_s3q19d if pp_s3q18==1 

	// NPS
	gen usefertexp3 = 1 if pp_s3q20a_1==1 
	//gen itemcodefertexpexp = 3 if usefertexpexp3 == 1 
	gen qtyfertexp3 = pp_s3q20a_2
	gen unitfertexp3 = 1 if pp_s3q20a_1==1 // Qty is in kilos 
	gen valfertexp3 = pp_s3q20a_5 if pp_s3q20a_1==1 

	// Other inorganic fertexpilizer  
	gen usefertexp4 = 1 if pp_s3q20a==1 
	//gen itemcodefertexpexp = 4 if usefertexpexp4 == 1 
	gen qtyfertexp4 = pp_s3q20a_7
	gen unitfertexp4 = 1 if pp_s3q20a==1 // Qty is in kilos 
	gen valfertexp4 = pp_s3q20c if pp_s3q20a==1 

	// Manure
	gen usefertexp5 = 1 if pp_s3q21==1 // No qty. Just dummy 
	//gen itemcodefertexpexp = 5 if usefertexpexp5 == 1 

	// Compost
	gen usefertexp6 = 1 if pp_s3q23==1 
	//gen itemcodefertexpexp = 6 if usefertexpexp6 == 1 

	// Other organic 
	gen usefertexp7 = 1 if pp_s3q25==1 
	//gen itemcodefertexpexp = 7 if usefertexpexp7 == 1 

	/*
	label var itemcodefertexp1 "Urea"
	label var itemcodefertexp2 "DAP"
	label var itemcodefertexp3 "NPS"
	label var itemcodefertexp4 "Other inorganic"
	label var itemcodefertexp5 "Manure"
	label var itemcodefertexp6 "Compost"
	label var itemcodefertexp7 "Other organic"
	*/ 
	
	keep use* qty* unit* val* household_id2 holder_id parcel_id field_id
	gen dummya=1
	gen dummyb=sum(dummya) //dummy id for duplicates
	drop dummya
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	display "`stubs'"
	reshape long `stubs', i(household_id2 holder_id parcel_id field_id dummyb) j(itemcode)
	drop if (usefertexp==.) 
	gen dummyc=sum(dummyb)
	drop dummyb
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	display "`stubs2'"
	reshape long `stubs2', i(household_id2 holder_id parcel_id field_id itemcode dummyc) j(exp) string 	
	gen dummyd = sum(dummyc)
	drop dummyc
	reshape long use qty unit val, i(household_id2 holder_id parcel_id field_id itemcode exp dummyd) j(input) string
	//collapse (sum) qty* val*, by(household_id2 holder_id parcel_id field_id itemcode use)
	drop dummyd 
	label define itemcodefert 1 "Urea" 2 "DAP" 3 "NPS" 4 "Other inorganic" 5 "Manure" 6 "Compost" 7 "Other organic"
	label values itemcode itermcodefert 
	replace input = "inorg" if itemcode>=1 & itemcode<=4 
	replace input = "orgfert" if itemcode>=5 & itemcode<=7 
	//replace unit=0 if unit==. // unit==1 <=> kg 
	tempfile phys_inputs
	save `phys_inputs'

		** fieldrents 
	use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear 	
	sort household_id2 holder_id parcel_id field_id 	
	bysort household_id2 holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	collapse (first) area_meas_hectares ha_planted (sum) value_harvest, by(household_id2 holder_id parcel_id field_id)	
	merge 1:1 household_id2 holder_id parcel_id field_id  using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", keep(1 3) keepusing(cultivated) nogen 

	preserve 
		use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
		// Joaquin 04.26: NGA at plot level, ETH is parcel level. We need field-level data. 
		// Joaquin 04.26: Perhaps distribute price evenly across fields? Ask what to do about this.
		// Andrew 5/3/2023 : Imputations  
		egen valparrentexp = rowtotal(pp_s2q07_a pp_s2q07_b)
		// Joaquin 05.24.23: Need to add the share of payments 
		keep household_id2 holder_id parcel_id valparrentexp pp_s2q07_c
		tempfile parcelrents 
		save `parcelrents', replace 
		gen rental_cost_land = valparrentexp
		drop valparrentexp pp_s2q07_c
		save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_rental_parcel.dta", replace 
	restore 

	merge m:1 household_id2 holder_id parcel_id using `parcelrents', nogen 
	bysort household_id2 holder_id parcel_id: egen area_meas_hectares_parcel = sum(area_meas_hectares)
	gen qtyfieldrentexp= area_meas_hectares if (valparrentexp>0 & valparrentexp!=.) | (pp_s2q07_c>0 & pp_s2q07_c!=.)
	gen valfieldrentexp = (area_meas_hectares/area_meas_hectares_parcel)*valparrentexp if valparrentexp>0 & valparrentexp!=. 
	replace valfieldrentexp = valfieldrentexp + (pp_s2q07_c/100)*value_harvest if valfieldrentexp!=. & pp_s2q07_c!=. & value_harvest!=. 
	replace valfieldrentexp = (pp_s2q07_c/100)*value_harvest if valfieldrentexp==. & pp_s2q07_c!=. & value_harvest!=. 
	
	gen qtyfieldrentimp = area_meas_hectares if qtyfieldrentexp==.
	replace qtyfieldrentimp = ha_planted if qtyfieldrentimp==. & qtyfieldrentexp==.

	keep if cultivate==1 //No need for uncultivated plots
	keep household_id2 holder_id parcel_id field_id qtyfieldrentexp* valfieldrentexp*
	
	gen usefieldrentexp = (qtyfieldrentexp>0 & qtyfieldrentexp!=.)
	
	reshape long usefieldrent valfieldrent qtyfieldrent, i(household_id2 holder_id parcel_id field_id) j(exp) string
	reshape long use val qty, i(household_id2 holder_id parcel_id field_id exp) j(input) string
	
	gen unit=(qty!=. & val!=.) 
	gen itemcode=1 //dummy var
	tempfile fieldrents
	save `fieldrents'
	
		** seeds // JM 06.04.23: We will just generate the necessary variables with missing values. We will use "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect4_pp_w3.dta" to get use_imprv_seed for person_ids. 

	use "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect4_pp_w3.dta", clear // Joaquin 04.06.23: This module contains seed info. Seed use at field level. Only seed use. 
	// Andrew 5/3/2023: AgQuery+ does not track seed expenses 
	// Generate varaibles with missing for where infromation is missing 
	// We care about improved seed 
	gen itemcode = pp_s4q11 // traditional==1, improved==2
	gen exp = "exp" if itemcode==2 
	replace exp = "imp" if itemcode==1
	gen use = (itemcode!=.)
	gen qty = pp_s4q11b_a if pp_s4q11b_a!=. & pp_s4q11b_b==. 
	replace qty = pp_s4q11b_b/1000 if pp_s4q11b_a==. & pp_s4q11b_b!=. 
	replace qty = pp_s4q11b_a + pp_s4q11b_b/1000 if pp_s4q11b_a!=. & pp_s4q11b_b!=. 
	gen unit = 1 if qty!=. // 1 == kg 
	gen val = pp_s4q11c // JM 09.11.23: Value is available ONLY for improved seeds 
	gen input = "seeds" if use==1 
	collapse (sum) use val qty, by(household_id2 holder_id parcel_id field_id exp input itemcode unit)
	replace qty = . if qty==0 & use==1 
	replace val = . if exp!="exp" // JM 09.11.23: Value is available ONLY for improved seeds 
	drop if itemcode ==. 
	//recode val (.=0) // Joaquin 6.12.23: Added this line-faq
	
	* Append // Joaquin 6.12.23: Added this sub-subsection
	
	append using `fieldrents'
	append using `field_inputs'
	append using `phys_inputs'

**# Bookmark Merging plot inputs 
	
	merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_weights.dta",nogen keep(1 3) keepusing(weight)
	merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares)
	merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers",nogen keep(1 3) keepusing(dm_gender)
	replace dm_gender = 1 if dm_gender == . // Joaquin 7.7.23: Obs are not presenst in field_decision_maker
	tempfile all_field_inputs
	merge m:1  household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", nogen keep(1 3) keepusing(region zone woreda kebele ea) // Joaquin 7.6.23: Added to get variables: region zone woreda kebele ea	
**#
	preserve
		keep use unit val qty weight area_meas_hectares dm_gender region zone woreda kebele ea
		save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_use_dummies.dta", replace
	restore

	tempfile all_field_inputs 
	save `all_field_inputs' //Woo, now we have 53k unique entries and can estimate vals.

	keep if strmatch(exp,"exp") // & qty!=. //Now for geographic medians
	gen fieldweight = weight*area_meas_hectares // Joaquin 6.12.23: Q for Andrew: use weight or weight_pop_rururb?
	//recode val (0=.) // JM 09.11.23: Most of our use variables are binary. doing the recode would erase most of them.  
	//drop if unit==0 //Remove things with unknown units.
	gen price = val/qty if val!=. & qty!=. & qty>0 
	drop if price==.
	gen obs=1
	
	foreach i in region zone woreda kebele ea household_id2 {
	preserve
		bys `i' input unit itemcode : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price [aw=fieldweight], by (`i' input unit itemcode obs_`i')
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}

	preserve
		bys input unit itemcode : egen obs_country = sum(obs)
		collapse (median) price_country = price [aw=fieldweight], by(input unit itemcode obs_country)
		tempfile price_country_median
		save `price_country_median'
	restore

	use `all_field_inputs',clear
	foreach i in region zone woreda kebele ea household_id2 {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		recode price_household_id2 (.=0)
		gen price=price_household_id2
	foreach i in country region zone woreda kebele ea household_id2 {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=. 
	}
	//Default to household prices when available
	replace price = price_household_id2 if price_household_id2>0
	//replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
	//recode val qty (.=0)
	//drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0 & qty!=. & qty>0 
	//replace input = "orgfert" if input=="" itemcode>=5 & itemcode<=7 // JM 7.6.23: Look for itemcode for organic fertilizer
	//replace input = "inorg" if strmatch(input,"fert")
	tab input
	preserve
		//Need this for quantities and not sure where it should go.
		keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"herb") | strmatch(input,"pest") | strmatch(input,"fung")
		//Unfortunately we have to compress liters and kg here, which isn't ideal.
		collapse (sum) use_=use qty_=qty, by(household_id2 holder_id parcel_id field_id input)
		reshape wide use_ qty_, i(household_id2 holder_id parcel_id field_id) j(input) string
		ren qty_inorg inorg_fert_rate
		ren qty_orgfert org_fert_rate
		//ren qty_herb herb_rate
		//ren qty_pest pest_rate
		la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
		la var org_fert_rate "Qty organic fertilizer used (kg)"
		//a var herb_rate "Qty of herbicide used (kg/L)"
		//la var pest_rate "Qty of pesticide used (kg/L)"
		save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_quantities.dta", replace
		/*
		use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_quantities.dta", clear
		JM 09.11.23: Need to create "use_input" variables as dummies. qty_input does not account for bin ary information. 
		*/
	restore
	
	/*
	use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_quantities.dta", clear 
	*/
	
	append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor.dta"
	collapse (sum) val, by (household_id2 holder_id parcel_id field_id exp input dm_gender)
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_cost_inputs_long.dta",replace 
	
	preserve
		collapse (sum) val, by(household_id2 exp input) 
		save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_cost_inputs_long.dta", replace //ALT 02.07.2022: Holdover from W4.
	restore

	preserve
		collapse (sum) val_=val, by(household_id2 holder_id parcel_id field_id exp dm_gender)
		reshape wide val_, i(household_id2 holder_id parcel_id field_id dm_gender) j(exp) string
		save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_cost_inputs.dta", replace //This gets used below.
	restore
		
	//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
	ren val val_ 
	reshape wide val_, i(household_id2 holder_id parcel_id field_id exp dm_gender) j(input) string
	ren val* val*_
	reshape wide val*, i(household_id2 holder_id parcel_id field_id dm_gender) j(exp) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	ren val* val*_
	reshape wide val*, i(household_id2 holder_id parcel_id field_id) j(dm_gender2) string
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_cost_inputs_wide.dta", replace //Used for monocrop plots
	collapse (sum) val*, by(household_id2)

	unab vars3 : *_exp_male //just get stubs from one
	local stubs3 : subinstr local vars3 "_exp_male" "", all
	foreach i in `stubs3' {
		egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
		egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
	}
	egen val_exp_hh=rowtotal(*_exp_hh)
	egen val_imp_hh=rowtotal(*_imp_hh)
	//drop /*val_mech_imp**/ val_seedtrans_imp* val_transfert_imp* val_feedanml_imp* //Not going to have any data
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_cost_inputs_verbose.dta", replace


	//We can do this more simply by:
	use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_cost_inputs_long.dta", clear
	//back to wide
	drop input
	codebook dm_gender
	collapse (sum) val, by(household_id2 holder_id parcel_id field_id exp dm_gender)
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	codebook dm_gender2 
	ren val* val*_
	reshape wide val*, i(household_id2 holder_id parcel_id field_id dm_gender2) j(exp) string
	ren val* val*_
	
	preserve // Get planted area 
		use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta",clear
		collapse (sum) ha_planted, by(household_id2 holder_id parcel_id field_id)
		tempfile planted_area
		save `planted_area' 
	restore 
	
	merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares) //do per-ha expenses at the same time
	merge 1:1 household_id2 holder_id parcel_id field_id using `planted_area', nogen keep(1 3)
	reshape wide val*, i(household_id2 holder_id parcel_id field_id) j(dm_gender2) string
	collapse (sum) val* area_meas_hectares ha_planted*, by(household_id2)
	//Renaming variables to plug into later steps
	foreach i in male female mixed {
	gen cost_expli_`i' = val_exp_`i'
	egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
	}
	egen cost_expli_hh = rowtotal(val_exp*)
	egen cost_total_hh = rowtotal(val*)
	drop val*
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_cost_inputs.dta", replace

*******************
*MONOCROPPED CROPS* // JM 11.1.23: Updated to match NGA W3. Questions for Andrew: What to do about the 5 duplicates? 
*******************

// Joaquin 03.14.2023: This section should start with: 
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
	keep if purestand==1 & relay!=1 //For now, omitting relay crops.
	ren crop_code_master cropcode
save "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_monocrop_plots.dta", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
	keep if purestand==1 & relay!=1 //For now, omitting relay crops.
	//File now has 2550 unique entries after omitting the crops that were "replaced" - it should be noted that some these were grown in mixed plots and only one crop was lost. Which is confusing.
	bysort household_id2 holder_id parcel_id field_id: gen dup=cond(_N==1,0,_n)
	tab dup
	drop if dup>=2
	drop dup 
	merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren crop_code_master cropcode
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono

	
forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	keep if cropcode==`c'			
	ren monocrop_ha `cn'_monocrop_ha
	drop if `cn'_monocrop_ha==0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (Naira)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	collapse (sum) *monocrop* kgs_harv* val_harv*, by(household_id2)
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`cn'_monocrop_hh_area.dta", replace
restore
}	
	

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(household_id2 holder_id parcel_id field_id dm_gender) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	reshape wide val*, i(household_id2 holder_id parcel_id field_id) j(dm_gender2) string
	merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(household_id2)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_inputs_`cn'.dta", replace
restore
}
	
//global nb_topcrops : word count $topcrop_area

forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	use "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect4_pp_w3.dta", clear
	drop crop_code
	ren pp_s4q01_b crop_code
	*recoding common beans to a single category
	recode crop_code (19=12)
	xi i.crop_code, noomit
	egen crop_count = rowtotal(_Icrop_code_*)
	gen percent_`cn'=1 if pp_s4q02==1 & crop_code==`c'
	replace percent_`cn' = pp_s4q03/100 if pp_s4q02==2 & pp_s4q03!=. & crop_code==`c'		
	collapse (max) percent_`cn' _Icrop_code_*, by(household_id2 parcel_id field_id holder_id)
	egen crop_count = rowtotal(_Icrop_code_*)
	keep if _Icrop_code_`c'==1 & crop_count==1
	*merging in plot areas
	* Joaquin: add next line to get dm_gender variable 
	merge m:1 household_id2 holder_id field_id parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", nogen keep(1 3)
	merge m:1 household_id2 holder_id field_id parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers.dta", nogen keep(1 3)
	gen `cn'_monocrop_ha= area_meas_hectares*percent_`cn'
	gen `cn'_monocrop_ha_female = area_meas_hectares*percent_`cn' if dm_gender==2
	gen `cn'_monocrop_ha_male = area_meas_hectares*percent_`cn' if dm_gender==1
	gen `cn'_monocrop_ha_mixed = area_meas_hectares*percent_`cn' if dm_gender==3
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`cn'_monocrop.dta", replace
	collapse (sum) `cn'_monocrop_ha*, by(household_id2)
	gen `cn'_monocrop=1 
	lab var `cn'_monocrop "1=hh has monocropped `cn' plots"
	recode `cn'_monocrop_ha* (0=.)
	lab var `cn'_monocrop_ha "monocropped `cnfull' area(ha) planted"
	foreach i in male female mixed {
		local l`cn'_monocrop_ha : var lab `cn'_monocrop_ha
		la var `cn'_monocrop_ha_`i' "`l`cn'_monocrop_ha' - `i' managed plots"
	}
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`cn'_monocrop_hh_area.dta", replace
}

// Joaquin 03.14.2023: Changing to adapt to Nigeria W3. Moving this section up to below *LABOR*
********************************************************************************
*CROP EXPENSES
********************************************************************************

********************************************************************************
* TLU (Tropical Livestock Units) * // Added Joaquin: 03.16.2023 
********************************************************************************


********************************************************************************
*LIVESTOCK INCOME
********************************************************************************

*Expenses
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_4_ls_w3.dta", clear
append using "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_5_ls_w3.dta"
append using  "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_3_ls_w3.dta"
ren ls_sec_8_4q05 cost_water_livestock
ren ls_sec_8_4q08 cost_fodder_livestock
ren ls_sec_8_5q05 cost_vaccines_livestock
ren ls_sec_8_5q07 cost_treatment_livestock
ren ls_sec_8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)

*Dairy costs
preserve
keep if ls_sec_8_type_code == 1
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id2)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock)
keep household_id2 cost_lrum
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_lrum_expenses", replace
restore 

preserve
ren ls_sec_8_type_code livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry"
la val species species
collapse (sum) cost_vaccines_livestock cost_treatment_livestock, by (household_id2 species) 
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
foreach i in ls_exp_vac{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (firstnm) *lrum *srum *pigs *equine *poultry, by(household_id2)

foreach i in ls_exp_vac{
	gen `i' = .
}
la var ls_exp_vac "Cost for vaccines and veterinary treatment for livestock"

foreach i in ls_exp_vac{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
drop ls_exp_vac
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_expenses_animal", replace
restore 

collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id2)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_expenses", replace
*Note that costs for hired labor are not captured.

*Livestock products
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_6_ls_w3.dta", clear
ren ls_code livestock_code 
ren ls_sec_8_6aq01 animals_milked
ren ls_sec_8_6aq02 months_milked
ren ls_sec_8_6aq04 liters_per_day /* Based on values, I assume this is per cow */
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
ren ls_sec_8_6aq10 earnings_milk_week
ren ls_sec_8_6aq09 liters_sold_week
ren ls_sec_8_6aq12 earnings_milk_products /* Note that we can't value the milk inputs here. They'll get double-counted as income */
gen price_per_liter = earnings_milk_week / liters_sold_week
ren ls_sec_8_6bq16 egg_laying_hens
ren ls_sec_8_6bq14 clutching_periods
ren ls_sec_8_6bq15 eggs_per_clutching_period
recode egg_laying_hens clutching_periods eggs_per_clutching_period (.=0)
gen eggs_produced = (egg_laying_hens * clutching_periods * eggs_per_clutching_period)
ren ls_sec_8_6bq18 eggs_sold
ren ls_sec_8_6bq19 earnings_egg_sales
gen price_per_egg = earnings_egg_sales / eggs_sold
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", nogen keep(1 3)
keep household_id2 weight region zone woreda kebele ea livestock_code milk_liters_produced price_per_liter eggs_produced price_per_egg earnings_milk_products /*
	*/earnings_milk_week months_milked earnings_egg_sales liters_sold_week eggs_sold
gen price_per_unit = price_per_liter
replace price_per_unit = price_per_egg if price_per_unit==.
recode price_per_unit (0=.)
gen earnings_milk_year = earnings_milk_week*4*months_milked		//assuming 4 weeks per month
gen liters_sold_year = liters_sold_week*4*months_milked
gen eggs_sold_year = eggs_sold
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
ren price_per_unit price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock product in the kebele"
lab var obs_kebele "Number of sales observations for this livestock product in the kebele"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_kebele.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda livestock_code obs_woreda)
ren price_per_unit price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock product in the woreda"
lab var obs_woreda "Number of sales observations for this livestock product in the woreda"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_woreda.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone livestock_code obs_zone)
ren price_per_unit price_median_zone
lab var price_median_zone "Median price per unit for this livestock product in the zone"
lab var obs_zone "Number of sales observations for this livestock product in the zone"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_zone.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_region.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_country.dta", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_products", clear
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_kebele if price_per_unit==. & obs_kebele >= 10
replace price_per_unit = price_median_woreda if price_per_unit==. & obs_woreda >= 10
replace price_per_unit = price_median_zone if price_per_unit==. & obs_zone >= 10
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10
replace price_per_unit = price_median_country if price_per_unit==. 
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = eggs_produced * price_per_unit
gen value_milk_sold = liters_sold_year * price_per_unit
gen value_eggs_sold = eggs_sold_year * price_per_unit
recode earnings_milk_products (.=0)

egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
egen sales_livestock_products = rowtotal(value_milk_sold value_eggs_sold)

collapse (sum) value_milk_produced value_eggs_produced earnings_milk_products value_livestock_products sales_livestock_products, by (household_id2)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production; going to cap these at one
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 

lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var earnings_milk_products "Earnings from milk products sold (gross earnings only)"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products", replace

*Sales (live animals)
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_2_ls_w3.dta", clear
ren ls_code livestock_code
ren ls_sec_8_2aq13 number_sold 
ren ls_sec_8_2aq14 income_live_sales 
ren ls_sec_8_2aq16 number_slaughtered 
ren ls_sec_8_2aq18 income_slaughtered 
ren ls_sec_8_2aq05 value_livestock_purchases
ren ls_sec_8_2aq04 number_purchased 
*We can't estimate the value of animals slaughtered because we don't know the number of slaughtered animals that were sold.
*Although we might be able to estimate the value as though they were live sales.	
replace number_purchased = income_live_sales if number_purchased > income_live_sales
replace number_purchased = 0 if number_purchased >= 1000 & value_livestock_purchases ==.
recode number_sold number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta"
drop if _merge==2
drop _merge
keep household_id2 weight region zone woreda kebele ea livestock_code number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal value_livestock_purchases
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", replace

*Implicit prices
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
ren price_per_animal price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock in the kebele"
lab var obs_kebele "Number of sales observations for this livestock in the kebele"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_kebele.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda livestock_code obs_woreda)
ren price_per_animal price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock in the woreda"
lab var obs_woreda "Number of sales observations for this livestock in the woreda"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_woreda.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone livestock_code obs_zone)
ren price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_zone.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_region.dta", replace
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_country.dta", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_livestock_sales", clear
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"

gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
*replace value_slaughtered = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 & income_slaughtered!=. /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
gen value_slaughtered_sold = income_slaughtered
gen value_livestock_sales = value_lvstck_sold + value_slaughtered_sold
collapse (sum) value_livestock_sales value_livestock_purchases value_slaughtered value_lvstck_sold, by (household_id2)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_2_ls_w3.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.7 if (ls_code==13|ls_code==14|ls_code==15)
replace tlu=0.01 if (ls_code==16|ls_code==17|ls_code==18|ls_code==19)
replace tlu=0.5 if (ls_code==20)
replace tlu=0.6 if (ls_code==21)
replace tlu=0.3 if (ls_code==22)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
gen lvstckid=ls_code
gen cattle=inrange(lvstckid,1,6)
gen smallrum=inrange(lvstckid,7, 12)
gen poultry=inrange(lvstckid,16,19)
gen other_ls=inlist(lvstckid,13, 14, 15,20,21, 21, 23)
gen cows=inrange(lvstckid,3,3)
gen chickens=inrange(lvstckid,16,19)
ren ls_sec_8_2aq01 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
ren ls_sec_8_2aq02 nb_ls_born 
ren ls_sec_8_2aq04 nb_ls_purchased 
ren ls_sec_8_2aq07 nb_ls_gifts_received 
ren ls_sec_8_2aq09 nb_ls_gifts_given 
ren ls_sec_8_2aq11 nb_ls_lost 
ren ls_sec_8_2aq13 nb_ls_sold 
ren ls_sec_8_2aq16 nb_ls_slaughtered
ren ls_sec_8_2aq14 value_sold
replace nb_ls_sold = value_sold if nb_ls_sold > value_sold /* columns seem to be switched */
ren ls_sec_8_2aq05 value_purchased 
replace nb_ls_purchased = value_purchased if nb_ls_purchased > value_purchased
replace nb_ls_purchased = 0 if nb_ls_purchased >= 1000 & value_purchased ==.
replace nb_ls_gifts_received = 0 if nb_ls_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace nb_ls_born = 0 if nb_ls_born >= 1000
recode nb_ls_1yearago nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered (.=0)
replace nb_ls_slaughtered = 0 if nb_ls_slaughtered > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
replace nb_ls_sold = 0 if nb_ls_sold > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
gen nb_ls_today = nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received - nb_ls_gifts_given - nb_ls_lost - nb_ls_sold - nb_ls_slaughtered
replace nb_ls_today = 0 if nb_ls_today < 0 /* My best effort to clean this up */
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
collapse (sum) tlu_* nb_*  , by (household_id2)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_TLU_Coefficients.dta", replace 

*TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_2_ls_w3.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8|ls_code==9|ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.7 if (ls_code==13|ls_code==14|ls_code==15)
replace tlu=0.01 if (ls_code==16|ls_code==17|ls_code==18|ls_code==19)
replace tlu=0.5 if (ls_code==20)
replace tlu=0.6 if (ls_code==21)
replace tlu=0.3 if (ls_code==22)
lab var tlu "Tropical Livestock Unit coefficient"
ren ls_code livestock_code
ren tlu tlu_coefficient
ren ls_sec_8_2aq01 number_1yearago
ren ls_sec_8_2aq02 number_born 
ren ls_sec_8_2aq04 number_purchased 
ren ls_sec_8_2aq07 number_gifts_received 
ren ls_sec_8_2aq09 number_gifts_given 
ren ls_sec_8_2aq11 animals_lost12months
ren ls_sec_8_2aq13 number_sold 
ren ls_sec_8_2aq16 number_slaughtered
ren ls_sec_8_2aq14 value_sold
replace number_sold = value_sold if number_sold > value_sold /* columns seem to be switched */
ren ls_sec_8_2aq05 value_purchased 
replace number_purchased = value_purchased if number_purchased > value_purchased
replace number_purchased = 0 if number_purchased >= 1000 & value_purchased ==.
replace number_gifts_received = 0 if number_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace number_born = 0 if number_born >= 1000
recode number_1yearago number_born number_purchased number_gifts_received number_gifts_given animals_lost12months number_sold number_slaughtered (.=0)
replace number_slaughtered = 0 if number_slaughtered > (number_1yearago + number_born + number_purchased + number_gifts_received)
replace number_sold = 0 if number_sold > (number_1yearago + number_born + number_purchased + number_gifts_received)
gen number_today = number_1yearago + number_born + number_purchased + number_gifts_received - number_gifts_given - animals_lost12months - number_sold - number_slaughtered
replace number_today = 0 if number_today < 0 
gen tlu_1yearago = number_1yearago * tlu_coefficient

*Livestock mortality rate
ren livestock_code ls_code
merge m:1 ls_code household_id2 holder_id using "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_1_ls_w3.dta", nogen
ren ls_code livestock_code
replace number_today = ls_sec_8_1q01
gen tlu_today = number_today * tlu_coefficient
egen mean_12months = rowmean(number_today number_1yearago)
ren ls_sec_8_1q02 number_today_exotic 
gen share_imp_herd_cows = number_today_exotic/number_today if livestock_code==1
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8,9,10,11,12)) + 3*(inlist(livestock_code,13,14,15)) + 4*(inlist(livestock_code,20,21,22)) + 5*(inlist(livestock_code,16,17,18,19))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species

preserve
*Now to household level
*First, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(household_id2 species)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camel = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *camel *equine *poultry share_imp_herd_cows, by(household_id2)
gen any_imp_herd = number_today_exotic!=0 if number_today!=0
drop number_today_exotic number_today
foreach i in lvstck_holding animals_lost12months mean_12months {
	gen `i' = .
}
la var lvstck_holding "Total number of livestock holdings (# of animals)"
la var any_imp_herd "At least one improved animal in herd"
la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
lab var animals_lost12months  "Total number of livestock  lost to disease"
lab var  mean_12months  "Average number of livestock  today and 1 year ago"
foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camel "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
la var any_imp_herd "At least one improved animal in herd - all animals"
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
*any improved large ruminants, small ruminants, or poultry
gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
lab var any_imp_herd_all "1=hh has any improved lrum, srum, or poultry"
recode lvstck_holding* (.=0)
*Now dropping these missing variables, which we only used to construct the labels above
drop lvstck_holding /*animals_lost12months*/ mean_12months
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_herd_characteristics", replace
restore

*Bee colonies not captured in TLU.
gen price_per_animal = value_sold / number_sold
recode price_per_animal (0=.)
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (household_id2)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_TLU.dta", replace


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect11b_hh_w3.dta", clear
ren hh_s11bq09 months_activ  
ren hh_s11bq13 avg_monthly_sales
egen monthly_expenses = rowtotal(hh_s11bq14_a- hh_s11bq14_e)
*2 observations with positive expenses but missing info on business income. These won't be considered at all.		
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (household_id2)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_self_employment_income.dta", replace

*Female non-farm business owners
use "$Ethiopia_ESS_W3_raw_data/Household/sect11b_hh_w3.dta", clear
ren hh_s11bq09 months_activ  
ren hh_s11bq13 avg_monthly_sales
egen monthly_expenses = rowtotal(hh_s11bq14_a- hh_s11bq14_e)
*2 observations with positive expenses but missing info on business income. These won't be considered at all.		
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
local busowners "hh_s11bq03_a hh_s11bq03_b"
foreach v of local busowners {
	preserve
	keep household_id2 `v'
	ren `v' bus_owner
	drop if bus_owner==. | bus_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `hh_s11bq03_a', clear
foreach v of local busowners {
	if "`v'"!="`hh_s11bq03_a'" {
		append using ``v''
	}
}
duplicates drop
gen business_owner=1 if bus_owner!=.
ren bus_owner personid
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_business_owners_ind.dta", replace


********************************************************************************
*WAGE INCOME
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect4_hh_w3.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
ren hh_s4q09 mainwage_yesno
ren hh_s4q13 mainwage_number_months
ren hh_s4q14 mainwage_number_weeks
ren hh_s4q15 mainwage_number_hours
ren hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2		
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
ren hh_s4q28 secwage_payment_period
local vars main sec
foreach p of local vars {
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	recode `p'wage_salary_cash (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash
}
ren hh_s4q33 income_psnp
recode mainwage_annual_salary secwage_annual_salary income_psnp (.=0)
gen annual_salary = mainwage_annual_salary + secwage_annual_salary + income_psnp		

*Individual agwage earners
preserve
ren hh_s4q00 personid
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", nogen
gen wage_worker = (annual_salary!=0 & annual_salary!=.)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_wage_worker.dta", replace
restore
collapse (sum) annual_salary, by (household_id2)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_wage_income.dta", replace
*Occupation = Ag or Industry = Ag or Fisheries.

*Agwage
use "$Ethiopia_ESS_W3_raw_data/Household/sect4_hh_w3.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
ren hh_s4q09 mainwage_yesno
ren hh_s4q13 mainwage_number_months
ren hh_s4q14 mainwage_number_weeks
ren hh_s4q15 mainwage_number_hours
ren hh_s4q16 mainwage_recent_payment
replace mainwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
ren hh_s4q28 secwage_payment_period
local vars main sec
foreach p of local vars {
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = (`p'wage_number_months*(`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	recode `p'wage_salary_cash (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash
}
recode mainwage_annual_salary secwage_annual_salary (.=0)
gen annual_salary_agwage = mainwage_annual_salary + secwage_annual_salary

*Individual agwage earners
preserve
ren hh_s4q00 personid
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", nogen
gen agworker = (annual_salary_agwage!=0 & annual_salary_agwage!=.)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_agworker.dta", replace
restore

collapse (sum) annual_salary_agwage, by (household_id2)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect12_hh_w3.dta", clear
ren hh_s12q02 amount_received
gen transfer_income = amount_received if hh_s12q00==101|hh_s12q00==102|hh_s12q00==103 /* cash, food, other in-kind transfers */
gen investment_income = amount_received if hh_s12q00==104
gen pension_income = amount_received if hh_s12q00==105
gen rental_income = amount_received if hh_s12q00==106|hh_s12q00==107|hh_s12q00==108|hh_s12q00==109
gen sales_income = amount_received if hh_s12q00==110|hh_s12q00==111|hh_s12q00==112
gen inheritance_income = amount_received if hh_s12q00==113
recode transfer_income pension_income investment_income sales_income inheritance_income (.=0)
collapse (sum) transfer_income pension_income investment_income rental_income sales_income inheritance_income, by (household_id2)
lab var transfer_income "Estimated income from cash, food, or other in-kind gifts/transfers over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months"
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var sales_income "Estimated income from sales of real estate or other assets over previous 12 months"
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var inheritance_income "Estimated income from cinheritance over previous 12 months"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_other_income.dta", replace

use "$Ethiopia_ESS_W3_raw_data/Household/sect13_hh_w3.dta", clear
ren hh_s13q00 assistance_code
ren hh_s13q03 amount_received 
gen psnp_income = amount_received if assistance_code=="A"			
gen assistance_income = amount_received if assistance_code=="B"|assistance_code=="C"|assistance_code=="D"|assistance_code=="E"
recode psnp_income assistance_income (.=0)
collapse (sum) psnp_income assistance_income, by (household_id2)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_assistance_income.dta", replace

use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
ren pp_s2q13_a land_rental_income_cash
ren pp_s2q13_b land_rental_income_inkind
ren pp_s2q13_c land_rental_income_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
collapse (sum) land_rental_income_upfront, by (household_id2)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_rental_income.dta", replace


/*DYA.10.26.2020 OLD
********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W3_raw_data}/Household/sect4_hh_w3.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
gen primary_hours = hh_s4q15 if occupation_code!=6 | industry_code!=1 | industry_code!=2
gen secondary_hours = hh_s4q26 if occupation_code!=6 | industry_code!=1 | industry_code!=2
*Instrument doesn't ask about the number of hours worked for own business or PSNP
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(household_id2)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_off_farm_hours.dta", replace
*/


/*DYA.10.26.2020 NEW*/
********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W3_raw_data}/Household/sect4_hh_w3.dta", clear
gen  hrs_main_wage_off_farm=hh_s4q15 if (hh_s4q11_b>2 & hh_s4q11_b!=.)		// hh_s4q11_b 1 to 2 is agriculture  (exclude mining)  //DYA.10.26.2020  I think this is limited to only 
gen  hrs_sec_wage_off_farm= hh_s4q26 if (hh_s4q21_b>2 & hh_s4q21_b!=.)		// hh_e21_2 1 to 2 is agriculture  
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm) 
gen  hrs_main_wage_on_farm=hh_s4q15 if (hh_s4q11_b<=2 & hh_s4q11_b!=.)		 
gen  hrs_sec_wage_on_farm= hh_s4q26 if (hh_s4q21_b<=2 & hh_s4q21_b!=.)	 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm) 
drop *main* *sec*
ren hh_s4q08 hrs_unpaid_off_farm
recode  hh_s4q02_a hh_s4q02_b hh_s4q03_a hh_s4q03_b (.=0)
gen hrs_domest_fire_fuel=(hh_s4q02_a+ hh_s4q02_b/60+hh_s4q03_a+hh_s4q03_b/60)*7  // hours worked just yesterday
ren  hh_s4q04 hrs_ag_activ
ren  hh_s4q05 hrs_self_off_farm
egen hrs_off_farm=rowtotal(hrs_wage_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
egen hrs_domest_all=rowtotal(hrs_domest_fire_fuel)
egen hrs_other_all=rowtotal(hrs_unpaid_off_farm)

foreach v of varlist hrs_* {
	local l`v'=subinstr("`v'", "hrs", "nworker",.)
	gen  `l`v''=`v'!=0
} 
gen member_count = 1
collapse (sum) nworker_* hrs_*  member_count, by(household_id2)
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
la var nworker_unpaid_off_farm  "Number of HH members with positve hours - unpaid activities"
la var nworker_ag_activ "Number of HH members with positve hours - agricultural activities"
la var nworker_wage_off_farm "Number of HH members with positve hours - wage off-farm"
la var nworker_wage_on_farm  "Number of HH members with positve hours - wage on-farm"
la var nworker_domest_fire_fuel  "Number of HH members with positve hours - collecting fuel and making fire"
la var nworker_off_farm  "Number of HH members with positve hours - work off-farm"
la var nworker_on_farm  "Number of HH members with positve hours - work on-farm"
la var nworker_domest_all  "Number of HH members with positve hours - domestic activities"
la var nworker_other_all "Number of HH members with positve hours - other activities"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_off_farm_hours.dta", replace

********************************************************************************
*FARM LABOR
********************************************************************************
//ALT 12.27.22 update this to match ETH
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor_long.dta", clear
drop if strmatch(gender,"all")
rename labor_type type
replace type="family" if type=="nonhired"
ren days labor_
collapse (sum) labor_, by(household_id2 type gender)
reshape wide labor_, i(household_id2 gender) j(type) string
drop if strmatch(gender,"")
ren labor* labor*_
reshape wide labor*, i(household_id2) j(gender) string
egen labor_total=rowtotal(labor*)
egen labor_hired = rowtotal(labor_hired*)
egen labor_family = rowtotal(labor_family*)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"		
lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"		
keep household_id2 labor_total labor_hired labor_family labor_hired_male labor_hired_female
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_family_hired_labor.dta", replace



//ALT: OLD CODE
********************************************************************************
*FARM SIZE // JM 10.30.23L: Updated for caompatibility with HOUSEHOLD VARIABLES 
********************************************************************************
//ALT 12.27.22: Some of this is redundant with the work done in the plot area section; streamlining would be a good idea to reduce the risk of this section becoming inconsistent as revisions get made above.
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
*All parcels here (which are subdivided into fields) were cultivated, whether in the belg or meher season.
gen cultivated=1

*Including area of permanent crops
preserve
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen cultivated = 1 if (pp_s4q17!=0 & pp_s4q17!=.) // 	pp_s4q17: how many trees were planted?	// not including any harvest because not separated out for tree crops in ETH
collapse (max) cultivated, by (household_id2 holder_id parcel_id field_id)
tempfile tree
save `tree', replace
restore
append using `tree'
collapse (max) cultivated, by (household_id2 holder_id parcel_id field_id)
lab var cultivated "1= Field was cultivated in this data set"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fields_cultivated.dta", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_areas.dta", clear 
merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fields_cultivated.dta"
keep if cultivated==1 
ren area_meas_hectares field_size
collapse (sum) field_size, by (household_id2 holder_id parcel_id field_id)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_sizes.dta", replace
collapse (sum) field_size, by (household_id2 holder_id parcel_id)
ren field_size parcel_size 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcel_sizes.dta", replace

collapse (sum) field_size, by (household_id2)
ren field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_size.dta", replace

*All Agricultural Land
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen agland = (pp_s3q03==1 | pp_s3q03==2 | pp_s3q03==3 | pp_s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)
*Including area of permanent crops
preserve
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen cultivated = 1 if (pp_s4q17!=0 & pp_s4q17!=.)		 //not including any harvest because not separated out for tree crops in ETH
collapse (max) cultivated, by (household_id2 holder_id parcel_id field_id)
tempfile tree
save `tree', replace
restore
append using `tree'
merge m:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fields_cultivated.dta", nogen keep(1 3)
replace agland=1 if cultivated==1
keep if agland==1
collapse (max) agland, by(household_id2 holder_id parcel_id field_id) // JMG: Changed keep with collapse to delete duplicates. 
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fields_agland.dta", replace
collapse (max) agland, by(household_id2 holder_id parcel_id field_id) 
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fields_agland.dta", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_sizes.dta", clear
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_agland.dta", keep(1 3) nogen
keep if agland==1
collapse (sum) field_size, by (household_id2)
ren field_size farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmsize_all_agland.dta", replace 

*Rented In/Borrow/Other not own 
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_sizes.dta", clear
collapse (sum) field_size, by(household_id2)
ren field_size land_size_total
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_size_total.dta", replace

/*
collapse (sum) area_meas_hectares, by( holder_id household_id2 parcel_id)
tempfile parcel_area
save `parcel_area', replace 
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
gen rented_in = (pp_s2q03==3 | pp_s2q03==6)
gen plot_not_owned = ( pp_s2q03==3 | pp_s2q03==4 | pp_s2q03==5 | pp_s2q03==6 ) 
gen plot_owned = (pp_s2q03==1 | pp_s2q03==2 | pp_s2q03==7 | pp_s2q03==8)
gen rented_out= (pp_s2q10==1)
keep if pp_s2q01b==1
merge 1:1 household_id2 holder_id parcel_id using `parcel_area' 
gen land_size = area_meas_hectares
collapse (max) rented_in rented_out plot_not_owned plot_owned land_size area_meas_hectares, by (holder_id household_id2 parcel_id)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcel_area.dta", replace // JM 10.27.23: Added 
/*
bysort holder_id household_id2 parcel_id field_id: gen dup = cond(_N==1,0,_n)
tab dup 
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcels_agland.dta", clear 
bysort holder_id household_id2 parcel_id field_id: gen dup = cond(_N==1,0,_n)
tab dup 
*/
merge 1:1 holder_id household_id2 parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcel_agland.dta", nogen 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_owenership.dta", replace
merge 1:1 holder_id household_id2 parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcel_area.dta", nogen keep (3)
gen not_own_area  = area_meas_hectares if plot_not_owned == 1
gen rent_out_area = area_meas_hectares if rented_out ==1 
collapse (sum) not_own_area rent_out_area area_meas_hectares (max) rented_in plot_not_owned plot_owned rented_out agland, by (household_id2 )
gen prop_area_not_own = not_own_area/area_meas_hectares
gen prop_area_rent = rent_out_area/area_meas_hectares
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_ownership.dta", replace
// JM: What is the goal of this part? 
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", keep (3)
gen only_unown = (plot_not_owned==1 & plot_owned==0) 
tabstat only_unown [aw=weight]
tabstat prop_area_not_own [aw=weight] if plot_not_owned==1
gen only_rent_out = (rented_out==1 & (agland==0 |plot_not_owned==1) ) 
tabstat only_rent_out rented_out [aw=weight]
tabstat prop_area_rent [aw=weight] if rented_out==1
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
*/

********************************************************************************
*LAND SIZE // JM 10.30.23L: JM 10.30.23L: Updated for caompatibility with HOUSEHOLD VARIABLES 
********************************************************************************

use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
gen rented_in = (pp_s2q03==3 | pp_s2q03==6)
gen plot_not_owned = ( pp_s2q03==3 | pp_s2q03==4 | pp_s2q03==5 | pp_s2q03==6 ) 
gen plot_owned = (pp_s2q03==1 | pp_s2q03==2 | pp_s2q03==7 | pp_s2q03==8)
gen rented_out= (pp_s2q10==1)
drop if rented_out==1
keep if pp_s2q01b==1
gen parcel_held = 1 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcels_held.dta", replace // JM 10.27.23: Added 

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_areas.dta", clear
collapse (sum) area_meas_hectares, by (household_id2 holder_id parcel_id)
merge 1:1 household_id2 holder_id parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcels_held.dta", nogen keep(1 3)
keep if parcel_held==1 
collapse (sum) area_meas_hectares, by(household_id2)
ren area_meas_hectares land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_size_all.dta", replace



********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_5_ls_w3.dta", clear
gen vac_animal=.
replace vac_animal=1 if ls_sec_8_5q01==1
replace vac_animal=0 if ls_sec_8_5q01==2
replace vac_animal=. if ls_sec_8_5q01==3
*Disagregating vaccine use by animal type
ren ls_sec_8_type_code livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry"
la val species species
*Creating species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camels = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) vac_animal*, by (household_id2)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camels "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_vaccine.dta", replace

*Vaccine use livestock keeper (holder)
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_5_ls_w3.dta", clear
ren pp_saq07 farmerid 
gen all_vac_animal=.
replace all_vac_animal=1 if ls_sec_8_5q01==1
replace all_vac_animal=0 if ls_sec_8_5q01==2
replace all_vac_animal=. if ls_sec_8_5q01==3
collapse (max) all_vac_animal , by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop household_id- pp_s1q05 ph_saq07- f_merge
gen female_vac_animal=all_vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
**cannot construct in this instrument



********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_4_ls_w3.dta", clear
gen feed_grazing_dry = (ls_sec_8_4q06a==1 | ls_sec_8_4q06a==2)
gen feed_grazing_rainy = (ls_sec_8_4q06b==1 | ls_sec_8_4q06b==2)
lab var feed_grazing_dry "1=HH feeds only or mainly by grazing  in the dry season"
lab var feed_grazing_rainy "1=HH feeds only or mainly by grazing  in the rainy season"
gen feed_grazing = (feed_grazing_dry==1 & feed_grazing_rainy==1)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat_dry = (ls_sec_8_4q03a == 4 )
gen water_source_nat_rainy = (ls_sec_8_4q03b == 4 )
gen water_source_const_dry = (ls_sec_8_4q03a == 1 | ls_sec_8_4q03a == 2 | ls_sec_8_4q03a == 3 | ls_sec_8_4q03a == 5)
gen water_source_const_rainy = (ls_sec_8_4q03b == 1 | ls_sec_8_4q03b == 2 | ls_sec_8_4q03b == 3 | ls_sec_8_4q03b == 5)
gen water_source_cover_dry = (ls_sec_8_4q03a == 1 )
gen water_source_cover_rainy = (ls_sec_8_4q03b == 1 )
gen water_source_nat = (water_source_nat_dry==1 | water_source_nat_rainy==1)
gen water_source_const = (water_source_const_dry==1 | water_source_const_rainy==1)
gen water_source_cover = (water_source_cover_dry==1 | water_source_cover_rainy==1) 
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
gen lvstck_housed = (ls_sec_8_4q01==2 | ls_sec_8_4q01==3 | ls_sec_8_4q01==4 | ls_sec_8_4q01==5 | ls_sec_8_4q01==6 )
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
ren ls_sec_8_type_code livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry"
la val species species
*A loop to create species variables
foreach i in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) feed_grazing* water_source* lvstck_housed*, by (household_id2)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
foreach i in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_feed_water_house.dta", replace



********************************************************************************
* PLOT MANAGERS *
********************************************************************************
// JMG 02.23: Working on it. There's some overlap between the output of adapting the pasted Nigeria code and other Ethiopia sections. 
//ALT 12.27.22: Update this to match ETH; replaces two sections below it.
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
// JM 10/19/23: Complete

use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen use_imprv_seed = (pp_s4q11 == 2)
recode crop_code (19=12)
recode crop_code (1053=1050) (1061 1062 = 1060) (1081 1082=1080) (1091 1092 1093 = 1090) (1111=1110) (2191 2192 2193=2190) /*Counting this generically as pumpkin, but it is different commodities
	*/				 (3181 3182 3183 3184 = 3180) (2170=2030) (3113 3112 3111 = 3110) (3022=3020) (2142 2141 = 2140) (1121 1122 1123 1124=1120) // JM 091123: Added 
collapse (max) use_imprv_seed, by(household_id2 holder_id parcel_id field_id crop_code)
tempfile imprv_seed
save `imprv_seed'

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area.dta", clear 
ren pp_s3q10a pid1
ren  pp_s3q10c_a pid2 
keep household_id2 holder_id parcel_id field_id pid*
reshape long pid, i( household_id2 holder_id parcel_id field_id) j(pidno)
drop pidno
drop if pid==.
ren pid personid 
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", nogen keep(1 3)
tempfile personids
save `personids'

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_quantities.dta", clear
rename use_inorg use_inorg_fert
rename use_org use_org_fert
collapse (max) use_org_fert use_inorg_fert use_fung use_herb use_pest, by(household_id2 holder_id parcel_id field_id)
merge 1:m household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", nogen keep(1 3) keepusing(crop_code_master)
ren crop_code_master crop_code
collapse (max) use*, by(household_id2 holder_id parcel_id field_id crop_code)
merge 1:1 household_id2 holder_id parcel_id field_id crop_code using `imprv_seed', nogen 
recode use* (.=0)
preserve 
keep household_id2 holder_id parcel_id field_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(household_id2 crop_code)
merge m:1 crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(household_id2) j(crop_name) string
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_imprvseed_crop.dta",replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore 


merge m:m household_id2 holder_id parcel_id field_id using `personids', nogen keep(1 3)
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(household_id2 personid female crop_code)
merge m:1 crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
/*
bysort household_id2 holder_id parcel_id field_id individual_id2 female crop_name: gen dup = cond(_N==1,0,_n)
tab dup 
*/
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(household_id2 personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
bysort household_id2 personid: gen dup=cond(_N==1,0,_n)
tab dup 
drop dup 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_improvedseed_use.dta", replace
restore

collapse (max) use_*, by(household_id2 personid female)
gen all_imprv_seed_use = use_imprv_seed //Legacy
//Temp code to get the values out faster
/*	collapse (max) use_*, by(hhid)
	merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_weights.dta", nogen keep(3)
	recode use* (.=0)
	collapse (mean) use* [aw=weight] */
//Legacy files, replacing the code below.

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest use_herb use_fung, by (household_id2)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_herb "1 = household uses herbicide"
	la var use_fung "1 = household uses fungicide" 
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if !missing(personid)
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore


********************************************************************************
* INORGANIC FERTILIZER USE *
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen use_inorg_fert=0
replace use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a_1==1 | pp_s3q20a==1
replace use_inorg_fert=0 if pp_s3q14==2 | pp_s3q15==2 & pp_s3q18==2 & pp_s3q20a_1==2 & pp_s3q20a==2
replace use_inorg_fert=. if pp_s3q14==1 & pp_s3q15==. & pp_s3q18==. & pp_s3q20a_1==. & pp_s3q20a==.
collapse (max) use_inorg_fert, by (household_id2)
lab var use_inorg_fert "1= Household uses inorganic fertilizer"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)

/*
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
gen all_use_inorg_fert=0
replace all_use_inorg_fert=1 if pp_s3q15==1 | pp_s3q18==1 | pp_s3q20a_1==1 | pp_s3q20a==1
replace all_use_inorg_fert=0 if pp_s3q14==2 | pp_s3q15==2 & pp_s3q18==2 & pp_s3q20a_1==2 & pp_s3q20a==2
replace all_use_inorg_fert=. if pp_s3q14==1 & pp_s3q15==. & pp_s3q18==. & pp_s3q20a_1==. & pp_s3q20a==.
ren pp_saq07 farmerid 
collapse (max) all_use_inorg_fert , by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop household_id- pp_s1q05 ph_saq07- f_merge
gen female_use_inorg_fert=all_use_inorg_fert if female==1
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_fert_use.dta", replace
*/

//ALT: Legacy 
********************************************************************************
* IMPROVED SEED USE *
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen imprv_seed_use=.
replace imprv_seed_use=1 if pp_s4q11==2
replace imprv_seed_use=0 if pp_s4q11==1
replace imprv_seed_use=. if pp_s4q11==.
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area	
	local cn: word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
	gen hybrid_seed_`cn'=.		//instrument doesn't ask about hybrid seeds
}
collapse (max) imprv_seed_* hybrid_seed_*, by(household_id2)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	lab var imprv_seed_`cn' "1= Household uses improved `cnfull' seed"
	lab var hybrid_seed_`cn' "1= Household uses hybrid `cnfull' seed"
}
lab var imprv_seed_use "1= Household uses improved seed"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_improvedseed_use.dta", replace

*Seed adoption by farmers (a farmer is an individual listed as plot manager)

/*
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use=1 if pp_s4q11==2
replace all_imprv_seed_use=0 if pp_s4q11==1
replace all_imprv_seed_use=. if pp_s4q11==.
ren pp_saq07 farmerid
collapse (max) all_imprv_seed_use, by(household_id2 farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
drop household_id- pp_s1q05 ph_saq07- f_merge
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
lab var male_imprv_seed_use "1 = Individual male farmers (plot manager) uses improved seeds"
lab var female_imprv_seed_use "1 = Individual female farmers (plot manager) uses improved seeds"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_improvedseed_use.dta", replace
*/
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect4_pp_w3.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use=1 if pp_s4q11==2
replace all_imprv_seed_use=0 if pp_s4q11==1
replace all_imprv_seed_use=. if pp_s4q11==.
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
	gen all_imprv_seed_`cn'=all_imprv_seed_use if crop_code==`c'
	gen all_hybrid_seed_`cn'=.		//Doesn't ask about hybrid seeds
	ren pp_saq07 farmerid
	gen `cn'_farmer= crop_code==`c' 
	collapse (max) all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer, by(household_id2 farmerid)
	gen personid=farmerid
	drop if personid==.
	merge m:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
	drop household_id- pp_s1q05 ph_saq07- f_merge
	gen female_imprv_seed_`cn'=all_imprv_seed_`cn' if female==1
	gen male_imprv_seed_`cn'=all_imprv_seed_`cn' if female==0
	lab var all_imprv_seed_`cn' "1 = Individual farmer (plot manager) uses improved `cnfull' seeds"
	lab var male_imprv_seed_`cn' "1 = Individual male farmers (plot manager) uses improved `cnfull' seeds"
	lab var female_imprv_seed_`cn' "1 = Individual female farmers (plot manager) uses improved `cnfull' seeds"
	gen farm_manager=1 if farmerid!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_improvedseed_use_`cn'.dta", replace
	restore
}


********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
use "${Ethiopia_ESS_W3_raw_data}/Post-Planting/sect3_pp_w3.dta", clear
merge m:m household_id using "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect5_pp_w3.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect7_pp_w3.dta", nogen
gen ext_reach_all=0
*DYA.03.17.2021 old definition replace ext_reach_all=1 if pp_s3q11==1 | pp_s7q04==1 | pp_s5q02==4

// *DYA.03.17.2021 updating accroding the broad definition of reach to add in advice from input supplies and fellow farmer  (seed var pp_s5q02= 5 or 6)
replace ext_reach_all=1 if pp_s3q11==1 | pp_s7q04==1 | pp_s5q02==4 | pp_s5q02==5 | pp_s5q02==6

*Source of extension is not asked
gen advice_gov = .
gen advice_ngo = .
gen advice_coop = .
gen advice_farmer = .
gen advice_radio = .
gen advice_pub = .
gen advice_neigh = .
gen advice_other = . 
gen ext_reach_public = .
gen ext_reach_private = .
gen ext_reach_ict = .
collapse (max) ext_reach*, by (household_id2)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources" 
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_any_ext.dta", replace


********************************************************************************
* MOBILE OWNERSHIP *
********************************************************************************
use "${Ethiopia_ESS_W3_raw_data}/Household/sect10_hh_w3.dta", clear
//DYA.11.13.2020 recode missing to 0 in hh_s10q01 (0 mobile owned if missing)
recode hh_s10q01 (.=0)
gen  hh_number_mobile_owned=hh_s10q01 if hh_s10q00==8
recode hh_number_mobile_owned (.=0) //DYA.11.13.2020 recode missing to 0
gen mobile_owned= hh_number_mobile_owned>0 //DYA.11.13.2020 
collapse (max) mobile_owned, by(household_id2)
keep household_id2 mobile_owned
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_2016_mobile_own", replace

********************************************************************************
* FORMAL FINANCIAL SERVICES USE *
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect4b_hh_w3.dta", clear
merge m:m household_id2 using "$Ethiopia_ESS_W3_raw_data/Household/sect11b_hh_w3.dta", nogen
gen borrow_bank = hh_s4bq03a==1 | hh_s4bq03b==1 | hh_s4bq09a==1 | hh_s4bq09b==1 | hh_s11bq04e_1==1 | hh_s11bq04e_2==1
gen borrow_micro = hh_s4bq03c==1 | hh_s4bq09c==1
gen borrow_mortgage = .
gen borrow_insurance = hh_s4bq15==1
gen borrow_other_fin = hh_s4bq03e==1 | hh_s4bq09e==1
gen borrow_neigh = hh_s4bq11a==1 | hh_s11bq04e_1==5 | hh_s11bq04e_2==5
gen borrow_merch = .
gen borrow_lender = hh_s11bq04e_1==2 | hh_s11bq04e_2==2
gen borrow_employer = .
gen borrow_relig = .
gen borrow_ngo = .
gen borrow_group = hh_s4bq03d==1 | hh_s4bq09d==1 | hh_s4bq11c==1 | hh_s11bq04e_1==4 | hh_s11bq04e_2==4
gen borrow_other = inlist(hh_s11bq04e_1,3,6) | inlist(hh_s11bq04e_2,3,6)
gen use_bank_acount = hh_s4bq02==1
gen use_MM = hh_s4bq04b==1 | hh_s4bq04c==1		// counting "online banking" and "mobile banking"
* Credit, Saving, Insurance, Bank account, Digital
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit = borrow_mortgage==1 | borrow_bank==1 
gen use_fin_serv_insur = borrow_insurance==1
gen use_fin_serv_digital = use_MM==1
gen use_fin_serv_all = use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 | borrow_other_fin==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (household_id2)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
gen use_fin_serv_savings = .			
lab var use_fin_serv_savings "1= Household uses formal financial services - savings" 
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fin_serv.dta", replace


********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_6_ls_w3.dta", clear
gen cows = ls_code==3
keep if cows
gen milk_animals = ls_sec_8_6aq01			// number of livestock milked (by holder)
gen months_milked = ls_sec_8_6aq02			// average months milked in last year (by holder)
gen liters_day = ls_sec_8_6aq04				// average quantity (liters) per day
gen liters_per_cow = (liters_day*365*(months_milked/12))	// liters per day times 365 (for yearly total) times milk animals to get TOTAL across all animals times months milked over 12 to scale down to actual amount
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_cow "average quantity (liters) per year (household)"
collapse (sum) milk_animals liters_per_cow, by(household_id2)
keep if milk_animals!=0
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_milk_animals.dta", replace

********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_6_ls_w3.dta", clear
gen clutching_periods = ls_sec_8_6bq14		// number of clutching periods per hen in last 12 months
gen eggs_clutch = ls_sec_8_6bq15			// number of eggs per clutch
gen hen_total = ls_sec_8_6bq16				// total laying hens
gen eggs_total_year = clutching_periods*eggs_clutch*hen_total		// total eggs in last 12 months (clutches per hen times eggs per clutch times number of hens)
collapse (sum) eggs_total_year hen_total, by(household_id2)
keep if hen_total!=0
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var hen_total "Total number of laying hens"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_eggs_animals.dta", replace



********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
//ALT 12.27.22: Update this to match ETH
//JM 10.09.23: Update complete 
*All the preprocessing is done in the crop expenses section
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
collapse (sum) ha_planted ha_harvest, by(household_id2 holder_id parcel_id field_id purestand area_meas_hectares)
reshape long ha_, i(household_id2 holder_id parcel_id field_id purestand area_meas_hectares) j(area_type) string
tempfile field_areas
save `field_areas'

/*
use "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid plot_id purestand field_size)
reshape long ha_, i(hhid plot_id purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
*/

**# Bookmark #1
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(household_id2 holder_id parcel_id field_id dm_gender exp)
reshape wide cost_, i(household_id2 holder_id parcel_id field_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge 1:m household_id2 holder_id parcel_id field_id using `field_areas', nogen keep(3)
//reshape long cost_, i(hhid plot_id dm_gender) j(exp) string
//replace cost_ = cost_/ha_
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=area_meas_hectares], by(household_id2 dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(household_id2 dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(household_id2) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropcosts.dta", replace

********************************************************************************
* ADDED 02.23 (C&P from commented-out lines below)
********************************************************************************


*Land value - rented land
*Starting at field area
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_area", clear
*Merging in gender
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers.dta", nogen
*Merging in rental costs paid
merge m:1 household_id2 holder_id parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_rental_parcel.dta", nogen	
*Merging in parcel area ("land_size")
merge m:1 household_id2 holder_id parcel_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_parcel_area.dta", nogen
gen percent_field = area_meas_hectares/land_size			
gen value_rented_land = rental_cost_land			
*Note that rent is at the parcel level, but decision-maker is at the field level (below parcel).
*Allocating rental costs based on percent of parcel taken up by field
gen value_rented_land_male = value_rented_land*percent_field if dm_gender==1			
gen value_rented_land_female = value_rented_land*percent_field if dm_gender==2
gen value_rented_land_mixed = value_rented_land*percent_field if dm_gender==3
*Value of rented land for monocropped top crop plots
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
	merge 1:1 household_id2 parcel_id field_id holder_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen value_rented_land_`cn' = value_rented_land
	gen value_rented_land_`cn'_male = value_rented_land_male
	gen value_rented_land_`cn'_female = value_rented_land_female
	gen value_rented_land_`cn'_mixed = value_rented_land_mixed
	collapse (sum) value_rented_land_`cn'*, by(household_id2)
	lab var value_rented_land_`cn' "Value of rented land (household expenditures) - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_male "Value of rented land (household expenditures) for male-managed plots - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_female "Value of rented land (household expenditures) for female-managed plots - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_mixed "Value of rented land (household expenditures) for mixed-managed plots - `cnfull' monocropped plots only"
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_rental_value_`cn'.dta", replace
	restore
}
collapse (sum) value_rented_*, by(household_id2)				// total rental costs at the household level
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures) for male-managed plots"
lab var value_rented_land_female "Value of rented land (household expenditures) for female-managed plots"
lab var value_rented_land_mixed "Value of rented land (household expenditures) for mixed-managed plots"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_rental_value.dta", replace
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_rental_rate.dta", replace


********************************************************************************
* RATE OF FERTILIZER APPLICATION *
********************************************************************************
//ALT 12.27.22: Update to match ETH
//ALSO NOTE to follow up with Didier - are we using Winsorization or MAD to trim outliers for this section?
//ALT 08.04.21: Added in org fert, herbicide, and pesticide; additional coding needed to integrate these into summary stats
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
collapse (sum) ha_planted, by(household_id2 holder_id parcel_id field_id dm_gender)
merge 1:1 household_id2 holder_id parcel_id field_id using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_quantities.dta", nogen keep(1 3) //11 plots have expenses but don't show up in the all_plots roster.
codebook dm_gender
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "mixed" if dm_gender==. // JM 10/9/23: Ask Andrew about this imputation. 
drop dm_gender
ren ha_planted ha_planted_
ren inorg_fert_rate fert_inorg_kg_ 
ren org_fert_rate fert_org_kg_ 
//ren pest_rate pest_kg_ // JM 10.9.23: No pest_rate for ETH W3
//ren herb_rate herb_kg_ // JM 10.9.23: No herb_rate for ETH W3
reshape wide ha_planted_ fert_inorg_kg_ fert_org_kg_ /*pest_kg_ herb_kg_*/, i(household_id2 holder_id parcel_id field_id) j(dm_gender2) string
collapse (sum) *male *mixed, by(household_id2)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg fert_org_kg /*pest_kg_ herb_kg_*/ {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 household_id2 using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed {
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for household"
lab var fert_org_kg "Organic fertilizer (kgs) for household" 
//lab var pest_kg "Pesticide (kgs) for household"
//lab var herb_kg "Herbicide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var fert_inorg_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var fert_org_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
//lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
//lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
}
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fertilizer_application.dta", replace



********************************************************************************
* WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
* DIETARY DIVERSITY
********************************************************************************
use "$Ethiopia_ESS_W3_raw_data/Household/sect5a_hh_w3.dta" , clear
* We recode food items to map HDD food categories
ta item_cd_cf
#delimit ;
recode item_cd_cf 	(1 2 3 4 5 6 60 195 196 197 901 				=1	"CEREALS")  
					(16 17 170 171 172 173 174    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")
					(14 144 145 915 909	910 912 913 143 908			=3	"VEGETABLES")
					(907 15 151 152 906					 			=4	"FRUITS")
					(180 181 182									=5	"MEAT")
					(21												=6	"EGGS")
					(183 											=7  "FISH")
					(7/13  110 111 131 902 903 904 905	  			=8	"LEGUMES, NUTS AND SEEDS")
					(19 20											=9	"MILK AND MILK PRODUCTS")
					(201 202    									=10	"OILS AND FATS")
					(22	204							  				=11	"SWEETS")
					(23/26 141 142	911	198 203 205 206 905 914		=12	"SPICES, CONDIMENTS, BEVERAGES")
					, generate(Diet_ID)
					;
#delimit cr
* generate a dummy variable indicating whether the respondent or other member of the household has consumed a food item during the past 7 days 			
gen adiet_yes=(hh_s5aq01==1)
ta adiet_yes   
** Now, we collapse to food group level assuming that if a person consumes at least one food item in a food group, then they have consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(household_id2 Diet_ID) 
count // nb of obs = 54,494 remaining
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(household_id2)
count  // 4,954 obs remaining
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS and WDDS. Because of
this it is recommended to use the mean score or distribution of scores for analytical
purposes and to set programme targets or goals.
*/
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
compress
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_household_diet.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* FEMALE LAND OWNERSHIP
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect2_pp_w3.dta", clear
*Female asset ownership
local landowners "pp_s2q03c_a pp_s2q03c_b pp_s2q06_a pp_s2q06_b pp_s2q08a_a pp_s2q08a_b"
keep household_id2  `landowners' 	// keep relevant variable
*transform data into long form
foreach v of local landowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `pp_s2q03c_a', clear
foreach v of local landowners   {
	if "`v'"!="`pp_s2q03c_a'" {
		append using ``v''
	}
}
** remove duplicates by collapse (if a hh member appears at least one time, she/he own/control land)
duplicates drop 
gen type_asset="land"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_land_owner.dta", replace

*FEMALE LIVESTOCK OWNERSHIP
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_1_ls_w3.dta", clear
*Remove poultry-livestocks
drop if inlist(ls_sec_8_type_code,4,5,6,.)
local livestockowners "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `livestockowners' 	// keep relevant variables
*Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `ls_sec_8_1q03_a', clear
foreach v of local landowners   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
*remove duplicates  (if a hh member appears at least one time, she/he owns livestock)
duplicates drop 
gen type_asset="livestock"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_livestock_owner.dta", replace

* FEMALE OTHER ASSETS
use "$Ethiopia_ESS_W3_raw_data/Household/sect10_hh_w3.dta", clear
*keep only productive assets
drop if inlist(hh_s10q00, 4,5,6,9, 11, 13, 16, 26, 27)
local otherassetowners "hh_s10q02_a hh_s10q02_b"
keep household_id2  `otherassetowners'
*Transform the data into long form  
foreach v of local otherassetowners   {
	preserve
	keep household_id2  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `hh_s10q02_a', clear
foreach v of local landowners   {
	if "`v'"!="`hh_s10q02_a'" {
		append using ``v''
	}
}
*remove duplicates  (if a hh member appears at least one time, she/he owns a non-agricultural asset)
duplicates drop 
gen type_asset="otherasset"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_otherasset_owner.dta", replace

* Construct asset ownership variable
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_land_owner.dta", clear
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_livestock_owner.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_otherasset_owner.dta"
gen own_asset=1 

collapse (max) own_asset, by(household_id2 asset_owner)
gen hh_s1q00=asset_owner
*Own any asset
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00  using   "$Ethiopia_ESS_W3_raw_data/Household/sect1_hh_w3.dta"
gen personid = hh_s1q00
drop _m hh_s1q00 individual_id ea_id ea_id2 saq03- hh_s1q02 hh_s1q04b- obs
ren hh_s1q03 mem_gender 
ren hh_s1q04a age 
gen female = mem_gender==2
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
drop if mem_gender==1
drop if age<18 & mem_gender==2
compress
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_ownasset.dta", replace


********************************************************************************
*WOMEN'S AG DECISION-MAKING
********************************************************************************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "$Ethiopia_ESS_W3_raw_data/Post-Planting/sect3_pp_w3.dta", clear
*Women's decision-making in ag
local planting_input "pp_saq07 pp_s3q10a pp_s3q10c_a pp_s3q10c_b"
keep household_id2 `planting_input' 	// keep relevant variables
* Transform the data into long form  
foreach v of local planting_input   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `pp_saq07', clear
foreach v of local planting_input   {
	if "`v'"!="`pp_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make ag decisions)
duplicates drop 
gen type_decision="planting_input"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_planting_input.dta", replace

*SALES DECISION-MAKERS - ANNUAL SALES
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
local control_annualsales "ph_s11q05_a ph_s11q05_b"
keep household_id2 `control_annualsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_annualsales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s11q05_a', clear
foreach v of local control_annualsales   {
	if "`v'"!="`ph_s11q05_a'" {
		append using ``v''
	}
}
** Remove duplicates (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="control_annualsales"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_annualsales.dta", replace

*SALES DECISION-MAKERS - ANNUAL CROP
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect11_ph_w3.dta", clear
local sales_annualcrop "ph_saq07 ph_s11q01b_1 ph_s11q01b_2 ph_s11q01c_1 ph_s11q01c_2 ph_s11q05_a ph_s11q05_b"
keep household_id2 `sales_annualcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_annualcrop   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_saq07', clear
foreach v of local sales_annualcrop   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="sales_annualcrop"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_sales_annualcrop.dta", replace

*SALES DECISION-MAKERS - PERM SALES
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect12_ph_w3.dta", clear
local control_permsales "ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `control_permsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_permsales   {	
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s12q08a_1', clear
foreach v of local control_permsales   {
	if "`v'"!="`ph_s12q08a_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="control_permsales"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_permsales.dta", replace

*SALES DECISION-MAKERS - PERM CROP
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect12_ph_w3.dta", clear
local sales_permcrop "ph_saq07 ph_s12q08a_1 ph_s12q08a_2"
keep household_id2 `sales_permcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_permcrop   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_saq07', clear
foreach v of local sales_permcrop   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="sales_permcrop"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_sales_permcrop.dta", replace

*SALES DECISION-MAKERS - HARVEST
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
local harvest "ph_saq07 ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `harvest' 	// keep relevant variables
* Transform the data into long form  
foreach v of local harvest   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}	
use `ph_saq07', clear
foreach v of local harvest   {
	if "`v'"!="`ph_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="harvest"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_harvest.dta", replace

*SALES DECISION-MAKERS - ANNUAL HARVEST
use "$Ethiopia_ESS_W3_raw_data/Post-Harvest/sect9_ph_w3.dta", clear
local control_annualharvest "ph_s9q07a_1 ph_s9q07a_2"
keep household_id2 `control_annualharvest' // keep relevant variables
* Transform the data into long form  
foreach v of local control_annualharvest   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ph_s9q07a_1', clear
foreach v of local control_annualharvest   {
	if "`v'"!="`ph_s9q07a_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he controls harvest)
duplicates drop 
gen type_decision="control_annualharvest"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_annualharvest.dta", replace

* FEMALE LIVESTOCK DECISION-MAKING - MANAGEMENT
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_1_ls_w3.dta", clear
local livestockowners "pp_saq07  ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `livestockowners' 	// keep relevant variables
* Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id2  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `pp_saq07', clear
foreach v of local livestockowners   {
	if "`v'"!="`pp_saq07'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he manages livestock)
duplicates drop 
gen type_decision="manage_livestock"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_manage_livestock.dta", replace

* Constructing decision-making ag variable *
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_planting_input.dta", clear
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_harvest.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_sales_annualcrop.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_sales_permcrop.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_manage_livestock.dta"
bysort household_id2 decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
*Create group
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_annualcrop" ///
							| type_decision=="sales_permcrop" 
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="manage_livestock"
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(household_id2 decision_maker )  //any decision
ren decision_maker hh_s1q00 
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "$Ethiopia_ESS_W3_raw_data/Household/sect1_hh_w3.dta"
* 107 member ID in decision files not in member list
drop household_id- hh_s1q02 hh_s1q04b- _merge
recode make_decision_* (.=0)
*Generate women participation in Ag decision
ren hh_s1q03 mem_gender 
ren hh_s1q04a age 
gen female = mem_gender==2
drop if mem_gender==1
drop if age<18 & mem_gender==2
*Generate women control over income
local allactivity crop  livestock  ag
foreach v of local allactivity {
	gen women_decision_`v'= make_decision_`v'==1 & mem_gender==2
	lab var women_decision_`v' "Women make decision abour `v' activities"
	lab var make_decision_`v' "HH member involed in `v' activities"
} 
collapse (max) make_decision* women_decision*, by(household_id2 hh_s1q00)
gen personid = hh_s1q00
compress
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_make_ag_decision.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "$Ethiopia_ESS_W3_raw_data/Livestock/sect8_1_ls_w3.dta", clear
local control_livestocksales "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id2 `control_livestocksales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_sec_8_1q03_a', clear
foreach v of local control_livestocksales   {
	if "`v'"!="`ls_sec_8_1q03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he controls livestock sales)
duplicates drop 
gen type_decision="control_livestocksales"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_livestocksales.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF BUSINESS INCOME
use "$Ethiopia_ESS_W3_raw_data/Household/sect11b_hh_w3.dta", clear
local control_businessincome "hh_s11bq03_a hh_s11bq03_b hh_s11bq03d_1 hh_s11bq03d_2"
keep household_id2 `control_businessincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_businessincome   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `hh_s11bq03_a', clear
foreach v of local control_businessincome   {
	if "`v'"!="`hh_s11bq03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, controls business income)
duplicates drop 
gen type_decision="control_businessincome"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_businessincome.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF OTHER INCOME
use "$Ethiopia_ESS_W3_raw_data/Household/sect12_hh_w3.dta", clear
local control_otherincome "hh_s12q03_a hh_s12q03_b"
keep household_id2 `control_otherincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_otherincome   {
	preserve
	keep household_id2  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `hh_s12q03_a', clear
foreach v of local control_otherincome   {
	if "`v'"!="`hh_s12q03_a'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, controls other income)
duplicates drop 
gen type_decision="control_otherincome"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_otherincome.dta", replace

*Constructing decision-making final variable 
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_annualharvest.dta", clear
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_annualsales.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_permsales.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_livestocksales.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_businessincome.dta"
append using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_women_control_otherincome.dta"

*Create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							| type_decision=="control_annualsales" ///
							| type_decision=="control_permsales" 
recode 	control_cropincome (.=0)									
gen control_livestockincome=1 if  type_decision=="control_livestocksales"  
recode 	control_livestockincome (.=0)
gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)									
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																										
gen control_nonfarmincome=1 if  type_decision=="control_otherincome" ///							 
	| control_businessincome== 1
recode 	control_nonfarmincome (.=0)															
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)																					
collapse (max) control_* , by(household_id2 controller_income )  //any decision
preserve
	*	We also need a variable that indicates if a source of income is applicable to a household
	*	and use it to condition the statistics on household with the type of income
	collapse (max) control_*, by(household_id2) 
	foreach v of varlist control_cropincome- control_all_income {
		local t`v'=subinstr("`v'",  "control", "hh_has", 1)
		ren `v'   `t`v''
	} 
	tempfile hh_has_income
	save `hh_has_income'
restore
merge m:1 household_id2 using `hh_has_income'
drop _m
ren controller_income hh_s1q00
*Now merge with member characteristics
merge 1:1 household_id2 hh_s1q00   using   "$Ethiopia_ESS_W3_raw_data/Household/sect1_hh_w3.dta"
* 107 member ID in decision files not in member list
drop household_id- hh_s1q02 hh_s1q04b- _merge
ren hh_s1q03 mem_gender 
ren hh_s1q04a age 
gen female = mem_gender==2
recode control_* (.=0)
gen women_control_all_income= control_all_income==1 
gen personid = hh_s1q00
compress
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_control_income.dta", replace

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
*All preprocessing done in ag expenses
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor_long.dta", clear
keep if strmatch(labor_type,"hired") & (strmatch(gender,"male") | strmatch(gender,"female"))
collapse (sum) wage_paid_aglabor_=val hired_=number, by(household_id2 gender)
reshape wide wage_paid_aglabor_ hired_, i(household_id2) j(gender) string
egen wage_paid_aglabor = rowtotal(wage*)
egen hired_all = rowtotal(hired*)
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers(local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
lab var hired_all "Total hired labor (number of persons)"
lab var hired_female "Total hired labor (number of persons) -female workers"
lab var hired_male "Total hired labor (number of persons) -male workers"
//keep hhid wage_paid_aglabor wage_paid_aglabor_female wage_paid_aglabor_male //Why did we get number of persons only to drop it at the end?
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_ag_wage.dta", replace


//ALT 12.27.22: Check and see if this is already taken care of above. I made some small changes in NGA to avoid the reprocessing of the raw DTAs that could be incorporated here if we need it.
********************************************************************************
*CROP YIELDS 
********************************************************************************
// JM 10.27.23: Completed

**************** JM 10.19.23: New code based on Nigeria
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear // JM 10.19.23: Need to add trees information for all_fields. 
ren crop_code_master crop_code
gen number_trees_planted_banana = number_trees_planted if crop_code==2030 
gen number_trees_planted_cassava = number_trees_planted if crop_code==1020 
gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040
recode number_trees_planted_banana number_trees_planted_cassava number_trees_planted_cocoa (.=0) 
collapse (sum) number_trees_planted*, by(household_id2)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_trees.dta", replace
**************** JM 10.19.23: End of new code based on Nigeria

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
ren crop_code_master crop_code
//Legacy stuff- agquery gets handled above.
collapse (sum) area_harv_=ha_harvest area_plan_=ha_planted harvest_=quant_harv_kg, by(household_id2 dm_gender purestand crop_code)
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
reshape wide harvest_ area_harv_ area_plan_, i(household_id2 dm_gender2 crop_code) j(mixed) string
ren area* area*_
ren harvest* harvest*_
reshape wide harvest* area*, i(household_id2 crop_code) j(dm_gender2) string
foreach i in harvest area_plan area_harv {
	egen `i' = rowtotal (`i'_*)
	foreach j in inter pure {
		egen `i'_`j' = rowtotal(`i'_`j'_*) 
	}
	foreach k in male female mixed {
		egen `i'_`k' = rowtotal(`i'_*_`k')
	}
	
}
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(household_id2)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_harvest_area_yield.dta", replace

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropname_table.dta", nogen keep(1 3)
merge 1:1 household_id2 crop_code using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production.dta", nogen keep(1 3)
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
reshape wide `vars', i(household_id2) j(crop_name) string
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold* number_trees_planted*  , by(household_id2) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*label variables
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (ETB) (household)" 
	lab var value_sold_`p' "Value sold of `p' (ETB) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household)" 
	//lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household)" 	
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household)" 
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
	lab var harvest_inter_mixed_`p' "Quantity harvested  of `p' (kgs) - intercrop (mixed-managed plots)"
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

drop if household_id2=="2030406088800801079" | household_id2=="030406088800801079" //not cultivated/agland but reports area planted/harvested
*Indicator variable for whether a household grew each crop
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=0)
	lab var grew_`p' "1=Household grew `p'"
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}

replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
foreach p of global cropname {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}	
//drop harvest-harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_inter_mixed value_harv kgs_harvest kgs_sold value_sold total_planted_area total_harv_area number_trees_planted_* 
//drop ha_planted // AYW 12.10.19
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_yield_hh_crop_level.dta", replace


* VALUE OF CROP PRODUCTION  // using 335 output
//ALT: This part stays in.
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production.dta", clear
*Grouping following IMPACT categories but also mindful of the consumption categories.
gen crop_group=""
replace crop_group=	"Barley"	if crop_code==	1
replace crop_group=	"Maize"	if crop_code==	2
replace crop_group=	"Millet"	if crop_code==	3
replace crop_group=	"Other cereals"	if crop_code==	4
replace crop_group=	"Other cereals"	if crop_code==	5
replace crop_group=	"Sorghum"	if crop_code==	6
replace crop_group=	"Teff"	if crop_code==	7
replace crop_group=	"Wheat"	if crop_code==	8
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	9
replace crop_group=	"Cassava"	if crop_code==	10
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	11
replace crop_group=	"Beans"	if crop_code==	12
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	13
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	14
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	15
replace crop_group=	"Other other"	if crop_code==	16
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	17
replace crop_group=	"Soyabeans"	if crop_code==	18
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	19
replace crop_group=	"Spices"	if crop_code==	20
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	21
replace crop_group=	"Cotton"	if crop_code==	22
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	23
replace crop_group=	"Groundnuts"	if crop_code==	24
replace crop_group=	"Spices"	if crop_code==	25
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	26
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	27
replace crop_group=	"Oils and fats"	if crop_code==	28
replace crop_group=	"Spices"	if crop_code==	29
replace crop_group=	"Spices"	if crop_code==	30
replace crop_group=	"Spices"	if crop_code==	31
replace crop_group=	"Spices"	if crop_code==	32
replace crop_group=	"Spices"	if crop_code==	33
replace crop_group=	"Spices"	if crop_code==	34
replace crop_group=	"Spices"	if crop_code==	35
replace crop_group=	"Spices"	if crop_code==	36
replace crop_group=	"Spices"	if crop_code==	37
replace crop_group=	"Spices"	if crop_code==	38
replace crop_group=	"Spices"	if crop_code==	39
replace crop_group=	"Spices"	if crop_code==	40
replace crop_group=	"Fruits"	if crop_code==	41
replace crop_group=	"Bananas and plantains"	if crop_code==	42
replace crop_group=	"Fruits"	if crop_code==	43
replace crop_group=	"Fruits"	if crop_code==	44
replace crop_group=	"Fruits"	if crop_code==	45
replace crop_group=	"Fruits"	if crop_code==	46
replace crop_group=	"Fruits"	if crop_code==	47
replace crop_group=	"Fruits"	if crop_code==	48
replace crop_group=	"Fruits"	if crop_code==	49
replace crop_group=	"Fruits"	if crop_code==	50
replace crop_group=	"Vegetables"	if crop_code==	51
replace crop_group=	"Vegetables"	if crop_code==	52
replace crop_group=	"Vegetables"	if crop_code==	53
replace crop_group=	"Vegetables"	if crop_code==	54
replace crop_group=	"Vegetables"	if crop_code==	55
replace crop_group=	"Vegetables"	if crop_code==	56
replace crop_group=	"Vegetables"	if crop_code==	57
replace crop_group=	"Onion"	if crop_code==	58
replace crop_group=	"Vegetables"	if crop_code==	59
replace crop_group=	"Potato"	if crop_code==	60
replace crop_group=	"Vegetables"	if crop_code==	61
replace crop_group=	"Sweet potato"	if crop_code==	62
replace crop_group=	"Vegetables"	if crop_code==	63
replace crop_group=	"Other roots and tubers"	if crop_code==	64
replace crop_group=	"Fruits"	if crop_code==	65
replace crop_group=	"Fruits"	if crop_code==	66
replace crop_group=	"Vegetables"	if crop_code==	67
replace crop_group=	"Vegetables"	if crop_code==	68
replace crop_group=	"Vegetables"	if crop_code==	69
replace crop_group=	"Vegetables"	if crop_code==	70
replace crop_group=	"Other other"	if crop_code==	71
replace crop_group=	"Coffee"	if crop_code==	72
replace crop_group=	"Cotton"	if crop_code==	73
replace crop_group=	"Other other"	if crop_code==	74
replace crop_group=	"Other other"	if crop_code==	75
replace crop_group=	"Sugar"	if crop_code==	76
replace crop_group=	"Tea"	if crop_code==	77
replace crop_group=	"Other other"	if crop_code==	78
replace crop_group=	"Spices"	if crop_code==	79
replace crop_group=	"Spices"	if crop_code==	80
replace crop_group=	"Spices"	if crop_code==	81
replace crop_group=	"Spices"	if crop_code==	82
replace crop_group=	"Fruits"	if crop_code==	83
replace crop_group=	"Fruits"	if crop_code==	84
replace crop_group=	"Other other"	if crop_code==	85
replace crop_group=	"Other other"	if crop_code==	86
replace crop_group=	"Other other"	if crop_code==	97
replace crop_group=	"Yam"	if crop_code==	98
replace crop_group=	"Other other"	if crop_code==	99
replace crop_group=	"Other other"	if crop_code==	100
replace crop_group=	"Other other"	if crop_code==	104
replace crop_group=	"Other other"	if crop_code==	108
replace crop_group=	"Other other"	if crop_code==	110
replace crop_group=	"Other other"	if crop_code==	112
replace crop_group=	"Fruits"	if crop_code==	113
replace crop_group=	"Other other"	if crop_code==	114
replace crop_group=	"Fruits"	if crop_code==	115
replace crop_group=	"Other other"	if crop_code==	116
replace crop_group=	"Spices"	if crop_code==	117
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	118
replace crop_group=	"Oils and fats"	if crop_code==	119
replace crop_group=	"Other cereals"	if crop_code==	120
replace crop_group=	"Other other"	if crop_code==	121
replace crop_group=	"Other other"	if crop_code==	122
replace crop_group=	"Vegetables"	if crop_code==	123
ren  crop_group commodity


*High/low value crops
gen type_commodity=""
/* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"Low"	if crop_code==	1
replace type_commodity=	"Low"	if crop_code==	2
replace type_commodity=	"Low"	if crop_code==	3
replace type_commodity=	"Low"	if crop_code==	4
replace type_commodity=	"Low"	if crop_code==	5
replace type_commodity=	"Low"	if crop_code==	6
replace type_commodity=	"Low"	if crop_code==	7
replace type_commodity=	"Low"	if crop_code==	8
replace type_commodity=	"Low"	if crop_code==	9
replace type_commodity=	"Low"	if crop_code==	10
replace type_commodity=	"Low"	if crop_code==	11
replace type_commodity=	"Low"	if crop_code==	12
replace type_commodity=	"Low"	if crop_code==	13
replace type_commodity=	"Low"	if crop_code==	14
replace type_commodity=	"Low"	if crop_code==	15
replace type_commodity=	"Low"	if crop_code==	16
replace type_commodity=	"Low"	if crop_code==	17
replace type_commodity=	"High"	if crop_code==	18
replace type_commodity=	"Low"	if crop_code==	19
replace type_commodity=	"High"	if crop_code==	20
replace type_commodity=	"Low"	if crop_code==	21
replace type_commodity=	"High"	if crop_code==	22
replace type_commodity=	"Low"	if crop_code==	23
replace type_commodity=	"Low"	if crop_code==	24
replace type_commodity=	"High"	if crop_code==	25
replace type_commodity=	"Low"	if crop_code==	26
replace type_commodity=	"Low"	if crop_code==	27
replace type_commodity=	"High"	if crop_code==	28
replace type_commodity=	"High"	if crop_code==	29
replace type_commodity=	"High"	if crop_code==	30
replace type_commodity=	"High"	if crop_code==	31
replace type_commodity=	"High"	if crop_code==	32
replace type_commodity=	"High"	if crop_code==	33
replace type_commodity=	"High"	if crop_code==	34
replace type_commodity=	"High"	if crop_code==	35
replace type_commodity=	"High"	if crop_code==	36
replace type_commodity=	"High"	if crop_code==	37
replace type_commodity=	"High"	if crop_code==	38
replace type_commodity=	"High"	if crop_code==	39
replace type_commodity=	"High"	if crop_code==	40
replace type_commodity=	"High"	if crop_code==	41
replace type_commodity=	"High"	if crop_code==	42
replace type_commodity=	"High"	if crop_code==	43
replace type_commodity=	"High"	if crop_code==	44
replace type_commodity=	"High"	if crop_code==	45
replace type_commodity=	"High"	if crop_code==	46
replace type_commodity=	"High"	if crop_code==	47
replace type_commodity=	"High"	if crop_code==	48
replace type_commodity=	"High"	if crop_code==	49
replace type_commodity=	"High"	if crop_code==	50
replace type_commodity=	"High"	if crop_code==	51
replace type_commodity=	"High"	if crop_code==	52
replace type_commodity=	"High"	if crop_code==	53
replace type_commodity=	"High"	if crop_code==	54
replace type_commodity=	"High"	if crop_code==	55
replace type_commodity=	"High"	if crop_code==	56
replace type_commodity=	"High"	if crop_code==	57
replace type_commodity=	"High"	if crop_code==	58
replace type_commodity=	"High"	if crop_code==	59
replace type_commodity=	"High"	if crop_code==	60
replace type_commodity=	"High"	if crop_code==	61
replace type_commodity=	"High"	if crop_code==	62
replace type_commodity=	"High"	if crop_code==	63
replace type_commodity=	"Low"	if crop_code==	64
replace type_commodity=	"High"	if crop_code==	65
replace type_commodity=	"High"	if crop_code==	66
replace type_commodity=	"High"	if crop_code==	67
replace type_commodity=	"High"	if crop_code==	68
replace type_commodity=	"High"	if crop_code==	69
replace type_commodity=	"High"	if crop_code==	70
replace type_commodity=	"High"	if crop_code==	71
replace type_commodity=	"High"	if crop_code==	72
replace type_commodity=	"High"	if crop_code==	73
replace type_commodity=	"High"	if crop_code==	74
replace type_commodity=	"High"	if crop_code==	75
replace type_commodity=	"High"	if crop_code==	76
replace type_commodity=	"High"	if crop_code==	77
replace type_commodity=	"High"	if crop_code==	78
replace type_commodity=	"High"	if crop_code==	79
replace type_commodity=	"High"	if crop_code==	80
replace type_commodity=	"High"	if crop_code==	81
replace type_commodity=	"High"	if crop_code==	82
replace type_commodity=	"High"	if crop_code==	83
replace type_commodity=	"High"	if crop_code==	84
replace type_commodity=	"Low"	if crop_code==	85
replace type_commodity=	"Low"	if crop_code==	86
replace type_commodity=	"Low"	if crop_code==	97
replace type_commodity=	"Low"	if crop_code==	98
replace type_commodity=	"Low"	if crop_code==	99
replace type_commodity=	"Low"	if crop_code==	100
replace type_commodity=	"Low"	if crop_code==	104
replace type_commodity=	"Low"	if crop_code==	108
replace type_commodity=	"Low"	if crop_code==	110
replace type_commodity=	"Low"	if crop_code==	112
replace type_commodity=	"High"	if crop_code==	113
replace type_commodity=	"High"	if crop_code==	114
replace type_commodity=	"High"	if crop_code==	115
replace type_commodity=	"High"	if crop_code==	116
replace type_commodity=	"High"	if crop_code==	117
replace type_commodity=	"Low"	if crop_code==	118
replace type_commodity=	"High"	if crop_code==	119
replace type_commodity=	"Low"	if crop_code==	120
replace type_commodity=	"High"	if crop_code==	121
replace type_commodity=	"Low"	if crop_code==	122
replace type_commodity=	"High"	if crop_code==	123
*/

* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"Low"	if crop_code==	1
replace type_commodity=	"Low"	if crop_code==	2
replace type_commodity=	"Low"	if crop_code==	3
replace type_commodity=	"Low"	if crop_code==	4
replace type_commodity=	"High"	if crop_code==	5
replace type_commodity=	"Low"	if crop_code==	6
replace type_commodity=	"Low"	if crop_code==	7
replace type_commodity=	"Low"	if crop_code==	8
replace type_commodity=	"High"	if crop_code==	9
replace type_commodity=	"Low"	if crop_code==	10
replace type_commodity=	"High"	if crop_code==	11
replace type_commodity=	"High"	if crop_code==	12
replace type_commodity=	"High"	if crop_code==	13
replace type_commodity=	"High"	if crop_code==	14
replace type_commodity=	"High"	if crop_code==	15
replace type_commodity=	"High"	if crop_code==	16
replace type_commodity=	"High"	if crop_code==	17
replace type_commodity=	"High"	if crop_code==	18
replace type_commodity=	"High"	if crop_code==	19
replace type_commodity=	"High"	if crop_code==	20
replace type_commodity=	"High"	if crop_code==	21
replace type_commodity=	"Out"	if crop_code==	22
replace type_commodity=	"High"	if crop_code==	23
replace type_commodity=	"High"	if crop_code==	24
replace type_commodity=	"High"	if crop_code==	25
replace type_commodity=	"High"	if crop_code==	26
replace type_commodity=	"High"	if crop_code==	27
replace type_commodity=	"High"	if crop_code==	28
replace type_commodity=	"High"	if crop_code==	29
replace type_commodity=	"High"	if crop_code==	30
replace type_commodity=	"High"	if crop_code==	31
replace type_commodity=	"High"	if crop_code==	32
replace type_commodity=	"High"	if crop_code==	33
replace type_commodity=	"High"	if crop_code==	34
replace type_commodity=	"High"	if crop_code==	35
replace type_commodity=	"High"	if crop_code==	36
replace type_commodity=	"High"	if crop_code==	37
replace type_commodity=	"High"	if crop_code==	38
replace type_commodity=	"High"	if crop_code==	39
replace type_commodity=	"High"	if crop_code==	40
replace type_commodity=	"High"	if crop_code==	41
replace type_commodity=	"Low"	if crop_code==	42
replace type_commodity=	"High"	if crop_code==	43
replace type_commodity=	"High"	if crop_code==	44
replace type_commodity=	"High"	if crop_code==	45
replace type_commodity=	"High"	if crop_code==	46
replace type_commodity=	"High"	if crop_code==	47
replace type_commodity=	"High"	if crop_code==	48
replace type_commodity=	"High"	if crop_code==	49
replace type_commodity=	"High"	if crop_code==	50
replace type_commodity=	"High"	if crop_code==	51
replace type_commodity=	"High"	if crop_code==	52
replace type_commodity=	"High"	if crop_code==	53
replace type_commodity=	"High"	if crop_code==	54
replace type_commodity=	"High"	if crop_code==	55
replace type_commodity=	"High"	if crop_code==	56
replace type_commodity=	"High"	if crop_code==	57
replace type_commodity=	"High"	if crop_code==	58
replace type_commodity=	"High"	if crop_code==	59
replace type_commodity=	"Low"	if crop_code==	60
replace type_commodity=	"High"	if crop_code==	61
replace type_commodity=	"Low"	if crop_code==	62
replace type_commodity=	"High"	if crop_code==	63
replace type_commodity=	"Low"	if crop_code==	64
replace type_commodity=	"High"	if crop_code==	65
replace type_commodity=	"High"	if crop_code==	66
replace type_commodity=	"High"	if crop_code==	67
replace type_commodity=	"High"	if crop_code==	68
replace type_commodity=	"High"	if crop_code==	69
replace type_commodity=	"High"	if crop_code==	70
replace type_commodity=	"Out"	if crop_code==	71
replace type_commodity=	"High"	if crop_code==	72
replace type_commodity=	"Out"	if crop_code==	73
replace type_commodity=	"Out"	if crop_code==	74
replace type_commodity=	"High"	if crop_code==	75
replace type_commodity=	"Out"	if crop_code==	76
replace type_commodity=	"Out"	if crop_code==	77
replace type_commodity=	"Out"	if crop_code==	78
replace type_commodity=	"High"	if crop_code==	79
replace type_commodity=	"High"	if crop_code==	80
replace type_commodity=	"High"	if crop_code==	81
replace type_commodity=	"High"	if crop_code==	82
replace type_commodity=	"High"	if crop_code==	83
replace type_commodity=	"High"	if crop_code==	84
replace type_commodity=	"Out"	if crop_code==	85
replace type_commodity=	"Out"	if crop_code==	86
replace type_commodity=	"Out"	if crop_code==	97
replace type_commodity=	"Low"	if crop_code==	98
replace type_commodity=	"Out"	if crop_code==	99
replace type_commodity=	"Out"	if crop_code==	100
replace type_commodity=	"Out"	if crop_code==	104
replace type_commodity=	"Out"	if crop_code==	108
replace type_commodity=	"Out"	if crop_code==	110
replace type_commodity=	"Out"	if crop_code==	112
replace type_commodity=	"High"	if crop_code==	113
replace type_commodity=	"Out"	if crop_code==	114
replace type_commodity=	"High"	if crop_code==	115
replace type_commodity=	"Out"	if crop_code==	116
replace type_commodity=	"High"	if crop_code==	117
replace type_commodity=	"High"	if crop_code==	118
replace type_commodity=	"High"	if crop_code==	119
replace type_commodity=	"Low"	if crop_code==	120
replace type_commodity=	"Out"	if crop_code==	121
replace type_commodity=	"Out"	if crop_code==	122
replace type_commodity=	"High"	if crop_code==	123
	
preserve
collapse (sum) value_crop_production value_crop_sales, by( household_id2 commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_bana
	ren value_`s'2 value_`s'_barl
	ren value_`s'3 value_`s'_bean 
	ren value_`s'4 value_`s'_casav
	ren value_`s'5 value_`s'_coff
	ren value_`s'6 value_`s'_coton 
	ren value_`s'7 value_`s'_fruit 
	ren value_`s'8 value_`s'_gdnut
	ren value_`s'9 value_`s'_maize
	ren value_`s'10 value_`s'_mill
	ren value_`s'11 value_`s'_oilc
	ren value_`s'12 value_`s'_onio
	ren value_`s'13 value_`s'_ocer
	ren value_`s'14 value_`s'_onuts
	ren value_`s'15 value_`s'_oths
	ren value_`s'16 value_`s'_ortub
	ren value_`s'17 value_`s'_pota 
	ren value_`s'18 value_`s'_sorg 
	ren value_`s'19 value_`s'_sybea 
	ren value_`s'20 value_`s'_spice 
	ren value_`s'21 value_`s'_suga 
	ren value_`s'22 value_`s'_spota 
	ren value_`s'23 value_`s'_teff
	ren value_`s'24 value_`s'_vegs
	ren value_`s'25 value_`s'_whea
	ren value_`s'26 value_`s'_yam
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
collapse (sum) value_*, by(household_id2)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by( household_id2 type_commodity) 
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
collapse (sum) value_*, by(household_id2)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}
drop value_pro value_sal
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production_type_crop.dta", replace
*End DYA 9.13.2020 


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Bring in area planted
use "$Ethiopia_ESS_W3_created_data/Ethiopia_ESS_W3_hh_crop_area_plan_SDI.dta", clear
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(household_id2)
save "$Ethiopia_ESS_W3_created_data/Ethiopia_ESS_W3_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 household_id2 using "$Ethiopia_ESS_W3_created_data/Ethiopia_ESS_W3_hh_crop_area_plan_shannon.dta", nogen
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
bysort household_id2 (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort household_id2 (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort household_id2 (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort household_id2 crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(household_id2)
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
save "$Ethiopia_ESS_W3_created_data/Ethiopia_ESS_W3_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Ethiopia_ESS_W3_raw_data}/Consumption Aggregate/cons_agg_w3.dta", clear
ren total_cons_ann total_cons
gen peraeq_cons = nom_totcons_aeq
replace total_cons = total_cons * price_index_hce 	// Adjusting for price index 
replace peraeq_cons = peraeq_cons * price_index_hce // Adjusting for price index 
la var peraeq_cons "Household consumption per adult equivalent per year"
gen daily_peraeq_cons = peraeq_cons/365
la var daily_peraeq_cons "Household consumption per adult equivalent per day"
gen percapita_cons = (total_cons / hh_size)
la var percapita_cons "Household consumption per household member per year"
gen daily_percap_cons = percapita_cons/365
la var daily_percap_cons "Household consumption per household member per day"
keep household_id2 adulteq total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_consumption.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Ethiopia_ESS_W3_raw_data}/Household/sect7_hh_w3.dta", clear
numlist "1/12"
forval k=1/12{
	local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_s7q07_`alph' hh_s7q07_`num'
}
forval k=1/12 {
	gen food_insecurity_`k' = (hh_s7q07_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
*replacing those that report over 12 months of food insecurity
replace months_food_insec = 12 if months_food_insec>12
lab var months_food_insec "Number of months of inadequate food provision"
keep household_id2 months_food_insec
save "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_food_insecurity.dta", replace


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
*Cannot calculate in this instrument - questionnaire doesn't ask value of HH assets


********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument

 


 
 
********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
global empty_vars ""
//use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_male_head.dta", clear	
//drop pw_w3	
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", clear
//merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_hh_adulteq.dta", nogen keep(1 3)

*Gross crop income (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production_grouped.dta", nogen
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
*End DYA 9.13.2020 
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_cost_inputs.dta", nogen

*Crop costs (NGA)
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*top crop costs by area planted (NGA)
foreach c in $topcropname_area {
	merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_inputs_`c'.dta", nogen
	merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_`c'_monocrop_hh_area.dta",nogen
}

foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 

*disaggregate by gender of plot manager (NGA)
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(/*val_anml_`c'_`i' val_mech_`c'_`i'*/ val_labor_`c'_`i' /*val_herb_`c'_`i'*/ val_inorg_`c'_`i' /*val_orgfert_`c'_`i'*/ val_fieldrent_`c'_`i' val_seeds_`c'_`i' /*val_transfert_`c'_`i' val_seedtrans_`c'_`i'*/) //These are already narrowed to explicit costs
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
drop /*val_anml* val_mech*/ val_labor* /*val_herb*/ val_inorg* /*val_orgfert*/ val_fieldrent* val_seeds* /*val_transfert* val_seedtrans*/ //

*Land rights (NGA)
merge 1:1 household_id2 using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

* Fish income (ETH)
gen fishing_income = . 
gen w_share_fishing = .
global empty_vars $empty_vars *fishing_income* w_share_fishing fishing_hh

*Livestock income (ETH
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_sales.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_products.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_TLU.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_TLU_Coefficients.dta", nogen keep(1 3)
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced value_eggs_produced earnings_milk_products /*
*/ cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock tlu_today (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + earnings_milk_products) /*
*/ - (cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock)
recode value_milk_produced value_eggs_produced (0=.)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = cost_breeding_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_treatment_livestock + cost_water_livestock
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"
drop value_livestock_purchases earnings_milk_products cost_breeding_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_water_livestock
//gen animals_lost12months =0 
gen mean_12months=0
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
//gen any_imp_herd_all = . 
foreach v in ls_exp_vac /*any_imp_herd*/ {
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* /*any_imp_herd_*/

* Self employment income (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_self_employment_income.dta", nogen keep(1 3)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

* Wage income (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_wage_income.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_agwage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours (ETH)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_off_farm_hours.dta", nogen keep(1 3)

*Other income (ETH)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_other_income.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_assistance_income.dta", nogen keep(1 3)
// JM 10.30.23: Add remmittances income 
egen transfers_income = rowtotal (/*remittance_income*/ assistance_income) // JM 10.30.23: Do we need to create remmittance_income? 
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income /*rental_income_buildings*/ /*other_income*/  /*rental_income_assets*/) // JM 10.30.23: Do we need to create the commented-out variables? 
lab var all_other_income "Income from other revenue streams not captured elsewhere"

* Farm size (NGA)
merge 1:1 household_id2 using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_size.dta", nogen keep(1 3)
merge 1:1 household_id2 using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_size_all.dta", nogen keep(1 3)
merge 1:1 household_id2 using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_size_total.dta", nogen
//ren area_meas_hectares land_size
recode land_size (.=0) /* If no farm, then no farm area */
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

*Labor (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

* Household size (NGA)
merge 1:1 household_id2 using  "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc. (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_vaccine.dta", nogen keep(1 3)
//merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fert_use.dta", nogen keep(1 3)
//merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_use.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_any_ext.dta", nogen keep(1 3)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fin_serv.dta", nogen keep(1 3)
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

* Milk productivity (ETH)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_milk_animals.dta", nogen keep(1 3)
gen liters_milk_produced= liters_per_cow*milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_cow
gen liters_per_largeruminant = .
gen liters_per_buffalo = .
global empty_vars $empty_vars *liters_per_largeruminant *liters_per_buffalo

* Dairy costs (ETH)
merge 1:1 household_id2 using "$Ethiopia_ESS_W3_created_data/Ethiopia_ESS_W3_lrum_expenses", nogen keep (1 3)
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
gen costs_dairy = avg_cost_lrum*milk_animals 
lab var avg_cost_lrum "Average cost per large ruminant"
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var costs_dairy "Dairy production cost (explicit)"
gen costs_dairy_percow = .
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
drop avg_cost_lrum cost_lrum
gen share_imp_dairy = . 
global empty_vars $empty_vars share_imp_dairy *costs_dairy_percow*

* Egg productivity (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_eggs_animals.dta", nogen keep(1 3)
gen egg_poultry_year = eggs_total_year/hen_total
ren hen_total poultry_owned
lab var egg_poultry_year "average number of eggs per year per hen"

*Costs of crop production per hectare (new)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application (new)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate (new)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons (new)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

*Household diet (ETH)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_household_diet.dta", nogen keep(1 3)
 
* Consumption (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_consumption.dta", nogen keep(1 3)

*Household assets (Title from NGA, content from ETH)
gen value_assets = .
global empty_vars $empty_vars *value_assets*

* Food insecurity (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct (NGA)
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health (Title from NGA, content from ETH)
gen disease_animal = . // JM 11.1.23: Added this line for *correct subpopulations*
gen lost_disease = . 
foreach i in lrum srum poultry{
	gen disease_animal_`i' = . // JM 11.1.23: Added this line for *correct subpopulations* 
	gen lost_disease_`i' = .
}
global empty_vars $empty_vars lost_disease*

*livestock feeding, water, and housing (Title from NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_livestock_feed_water_house.dta", nogen keep(1 3) 

*Shannon Diversity index (NGA)
merge 1:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production (NGA)
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

* Agricultural households (NGA)
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

*household with egg-producing animals (NGA)
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production (NGA)
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Households engaged in ag activities including working in paid ag jobs (NGA)
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Creating crop households and livestock households
gen crop_hh = (value_crop_production!=0  | farm_area!=0)
lab var crop_hh "1= Household has some land cultivated or some crop income"
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
lab  var livestock_hh "1= Household has some livestock or some livestock income"
recode fishing_income (.=0)
gen fishing_hh = (fishing_income!=0)
lab  var fishing_hh "1= Household has some fishing income"

/*
recode annual_selfemp_profit wage_income agwage_income transfer_income pension_income investment_income rental_income sales_income inheritance_income /*
*/ psnp_income assistance_income land_rental_income_upfront (.=0)
gen fish_trading_income = .
egen self_employment_income = rowtotal(annual_selfemp_profit fish_trading_income)
ren wage_income nonagwage_income
lab var self_employment_income "Income from self-employment (business)"
egen transfers_income = rowtotal (transfer_income pension_income assistance_income psnp_income) 
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income rental_income sales_income land_rental_income_upfront inheritance_income )
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop annual_selfemp_profit fish_trading_income transfer_income pension_income assistance_income psnp_income investment_income rental_income sales_income land_rental_income_upfront inheritance_income 
*/

****getting correct subpopulations*****  (ETH)
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
	recode ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*households engaged in crop production
recode cost_expli* value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli* value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0
*all rural households 
recode /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0
//drop value_harv*

global gender "female male mixed" // (ETH)
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /* //JM 11.1.23: Removed "w_labor_other" for consistency with NGA W3
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*


/*
*** Begin addressing outliers  and estimating indicators that are ratios using winsorized values ***
global gender "female male mixed"
global wins_var_top1 /*
*/ cost_total_hh cost_expli_hh /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family labor_other /* 
*/ animals_lost12months* mean_12months* lost_disease* /*
*/ liters_milk_produced costs_dairy eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  livestock_expenses ls_exp_vac* crop_production_expenses value_assets kgs_harv_mono* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold value_pro* value_sal* 
*/

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after (ETH)
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}

global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp  
}
gen cost_total = cost_total_hh //JM 11.1.23: Added this line for consistency with NGA W3
gen cost_expli = cost_expli_hh //JM 11.1.23: Added this line for consistency with NGA W3
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor  
foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
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
global empty_vars $empty_vars w_lost_disease w_lost_disease_lrum w_lost_disease_srum w_lost_disease_poultry
drop *wage_paid_aglabor_mixed
*Generating labor_total as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family) //JM 11.1.23: Removed "w_labor_other" for consistency with NGA W3
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%" 

*Variables winsorized both at the top 1% and bottom 1% (ETH)
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p($wins_lower_thres $wins_upper_thres)  
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

*area_harv and area_plan are also winsorized both at the top 1% and bottom 1% because we need to analyze at the crop level (ETH)
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 	
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p($wins_lower_thres $wins_upper_thres) 
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0   
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 1%"
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 1%"
			
		}
	}
}

*Estimate variables that are ratios then winsorize top 1% and bottom 1% of the ratios (do not replace 0 by the percentitles)
*generate yield and weights for yields using winsorized values (ETH)
*Yield by Area Planted
foreach c of global topcropname_area {
	gen yield_pl_`c'=w_harvest_`c'/w_area_plan_`c'
	lab var  yield_pl_`c' "Yield by area planted of `c' (kgs/ha) (household)" 
	gen ar_pl_wgt_`c' =  weight*w_area_plan_`c'
	lab var ar_pl_wgt_`c' "Planted area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_pl_`g'_`c'=w_harvest_`g'_`c'/w_area_plan_`g'_`c'
		lab var  yield_pl_`g'_`c'  "Yield by area planted of `c' -  (kgs/ha) (`g')" 
		gen ar_pl_wgt_`g'_`c' =  weight*w_area_plan_`g'_`c'
		lab var ar_pl_wgt_`g'_`c' "Planted area-adjusted weight for `c' (`g')"
	}
}

*generate yield and weights for yields using winsorized values 
*Yield by area harvested
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

*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha=w_cost_total/w_ha_planted  // JM 11.1.23: Changed cost_total to cost_total_hh
gen cost_expli_ha=w_cost_expli/w_ha_planted				
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
foreach g of global gender {
	gen inorg_fert_rate_`g'=w_fert_inorg_kg_`g'/ w_ha_planted_`g'
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 			
}
lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"

*mortality rate (ETH)
global animal_species lrum srum camel equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*Generating crop expenses by hectare for top crops (ETH)
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen `cn'_exp_ha = w_`cn'_exp / w_`cn'_monocrop_ha			
	la var `cn'_exp_ha "Costs per hectare - Monocropped `cnfull' plots"
	foreach g of global gender {
		gen `cn'_exp_ha_`g' = w_`cn'_exp_`g'/w_`cn'_monocrop_ha_`g'		
		local l`cn': var lab `cn'_exp_ha
		la var `cn'_exp_ha_`g' "`l`cn'' - `g' managed plots"
	}
}

*Hours per capita using winsorized version off_farm_hours (ETH)
foreach x in ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}

*generating total crop production costs per hectare (ETH)
gen cost_expli_hh_ha = w_cost_expli_hh/w_ha_planted		
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity (ETH)
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*Milk productivity (ETH)
gen liters_per_cow = w_liters_milk_produced/milk_animals		
lab var liters_per_cow "average quantity (liters) per day (household) - cow"
la var liters_per_largeruminant "Average quantity (liters) per year (household)" // JM 11.1.23: Added for consistency with NGA W3 code. 
global empty_vars $empty_vars liters_per_largeruminant	 // JM 11.1.23: Added for consistency with NGA W3 code. 

*Calculate proportion of crop value sold using winsorized values of value_crop_sales and value_crop_production (ETH)
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold>1 & w_proportion_cropvalue_sold!=.
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*livestock value sold  (ETH)
gen w_share_livestock_prod_sold = w_sales_livestock_products / w_value_livestock_products
replace w_share_livestock_prod_sold = 1 if w_share_livestock_prod_sold>1 & w_share_livestock_prod_sold!=.
lab var w_share_livestock_prod_sold "Percent of production of livestock products (winsorized) that is sold"

*Propotion of farm production sold (ETH)
gen w_prop_farm_prod_sold = w_value_farm_prod_sold / w_value_farm_production
replace w_prop_farm_prod_sold = 1 if w_prop_farm_prod_sold>1 & w_prop_farm_prod_sold!=.
lab var w_prop_farm_prod_sold "Proportion of farm production (winsorized) that has been sold"

*Unit cost of production (ETH)
*top crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen `cn'_exp_kg = w_`cn'_exp / w_kgs_harv_mono_`cn'		
	la var `cn'_exp_kg "Costs per kilogram produced - `cnfull' monocropped plots"
	foreach g of global gender {
		gen `cn'_exp_kg_`g'= w_`cn'_exp_`g'/w_kgs_harv_mono_`cn'_`g'
		local l`cn': var lab `cn'_exp_kg
		la var `cn'_exp_kg_`g' "`l`cn'' - `g' mananged plots"
	}
}

*dairy (NGA)
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced  
lab var cost_per_lit_milk "dairy production cost per liter"
global empty_vars $empty_vars cost_per_lit_milk

*****getting correct subpopulations*** (ETH)
*all rural housseholds engaged in crop production (ETH)
recode inorg_fert_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode inorg_fert_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestcok production of a given species (ETH)
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}
*all rural households (ETH)
recode /*DYA.10.26.2020*/ hrs_*_pc_all (.=0)  
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}
*all rural households growing specific crops (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'==1 
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'==0 
}
*all rural households harvesting specific crops (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}

*households growing specific crops that have also purestand plots of that crop (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
}
*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots (ETH)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'==0 | w_area_plan_pure_`cn'==.  
}

*households engaged in dairy production (ETH)
recode cost_per_lit_milk liters_per_cow (.=0) if dairy_hh==1
recode cost_per_lit_milk liters_per_cow (nonmissing=.) if dairy_hh==0
*households with egg-producing animals (ETH)
recode egg_poultry_year (.=0) if egg_hh==1 
recode egg_poultry_year (nonmissing=.) if egg_hh==0

*now winsorize ratios only at top 1% (ETH)
global wins_var_ratios_top1 inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
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

*Winsorizing top crop ratios (ETH)
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight] , p($wins_upper_thres)  		
	gen w_`v'_exp_ha = `v'_exp_ha
	replace  w_`v'_exp_ha = r(r1) if  w_`v'_exp_ha > r(r1) &  w_`v'_exp_ha!=.
	local l`v'_exp_ha : var lab `v'_exp_ha
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha' - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha_`g' : var lab `v'_exp_ha_`g'
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha_`g'' - winsorized top 1%"
	}
	*winsorizing cost per kilogram
	_pctile `v'_exp_kg [aw=weight] , p($wins_upper_thres)  
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


*now winsorize ratio only at top 1% - yield (ETH)
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight] , p($wins_upper_thres)  
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winzorized top 1%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winzorized top 1%"
		}
	}
}

*Create final income variables using un_winzorized and winzorized values (ETH)
egen total_income = rowtotal(crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income)
egen nonfarm_income = rowtotal(self_employment_income nonagwage_income transfers_income all_other_income)
egen farm_income = rowtotal(crop_income livestock_income agwage_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"
egen w_total_income = rowtotal(w_crop_income w_livestock_income w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)
egen w_nonfarm_income = rowtotal(w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"
global income_vars crop livestock self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
	gen `p'_income_s = `p'_income
	replace `p'_income_s = 0 if `p'_income_s < 0
	gen w_`p'_income_s = w_`p'_income
	replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}
egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)
foreach p of global income_vars {
	gen w_share_`p' = w_`p'_income_s / w_total_income_s
	lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}
egen w_nonfarm_income_s = rowtotal(w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
	drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations 
*all rural households (ETH not in NGA)
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all  months_food_insec /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 

*all rural households engaged in livestock production (ETH)
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0

*hh engaged in crop or livestock production (ETH)
gen ext_reach_unspecified=0 // JM 11.1.23: This is not in NGA
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"

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

*all rural households engaged in dairy production (ETH)
recode costs_dairy liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals (ETH)
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0

*Identify smallholder farmers (RULIS definition) (NGA)
global small_farmer_vars land_size tlu_today total_income 
foreach p of global small_farmer_vars {
	gen `p'_aghh = `p' if ag_hh==1
	_pctile `p'_aghh  [aw=weight] , p(40) 
	gen small_`p' = (`p' <= r(r1))
	replace small_`p' = . if ag_hh!=1
}
gen small_farm_household = (small_land_size==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 
drop land_size_aghh small_land_size tlu_today_aghh small_tlu_today total_income_aghh small_total_income   
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"

*create different weights (ETH)
gen w_labor_weight=weight*w_labor_total
lab var w_labor_weight "labor-adjusted household weights"
gen w_land_weight=weight*w_farm_area
lab var w_land_weight "land-adjusted household weights"
gen w_aglabor_weight_all=w_labor_hired*weight
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=. // cannot create in this instrument  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=. // cannot create in this instrument 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"
gen weight_milk=milk_animals*weight
gen weight_egg=poultry_owned*weight
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
	gen area_weight_`g'=weight*w_ha_planted_`g'
}
gen w_ha_planted_weight=w_ha_planted_all*weight
drop w_ha_planted_all
gen individual_weight=hh_members*weight
gen adulteq_weight=adulteq*weight


*Rural poverty headcount ratio (ETH)
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 5.439 = 10.3341  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(226.759 - 133.25)/ 133.25 = 1.7017561	
	// 10.3341* 1.7017561 = 17.586118 ETB
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<17.586118)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"

*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*By per capita consumption (ETH)
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption (ETH)
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

****Currency Conversion Factors*** (ETH)
gen ccf_loc = 1 
lab var ccf_loc "currency conversion factor - 2016 $ETB"
gen ccf_usd = 1 / $Ethiopia_ESS_W3_exchange_rate 
lab var ccf_usd "currency conversion factor - 2016 $USD"
gen ccf_1ppp = 1 / $Ethiopia_ESS_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2016 $Private Consumption PPP"
gen ccf_2ppp = 1 / $Ethiopia_ESS_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2016 $GDP PPP"

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

*Removing intermediate variables to get below 5,000 vars (ETH)
keep household_id2 fhh clusterid strataid *weight* *wgt* region zone woreda town subcity kebele ea /*household*/ rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_1_9 *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products   nb_cows_today lvstck_holding_srum  nb_smallrum_today nb_chickens_today  *value_pro* *value_sal* /*
*/ /*DYA 10.6.2020*/ *value_livestock_sales*  *w_value_farm_production* *value_slaughtered* *value_lvstck_sold* *value_crop_sales* *sales_livestock_products* *value_livestock_sales* animals_lost12months

/*
foreach v of varlist $empty_vars { 
	replace `v' = .
}
*/

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid = household_id2 
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA"
gen year = "2015-16"
gen instrument = 7
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
saveold "$Ethiopia_ESS_W3_final_data/Ethiopia_ESS_W3_household_variables.dta", replace


Stop 

//use "$Ethiopia_ESS_W3_final_data/Ethiopia_ESS_W3_household_variables.dta", clear 

********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_person_ids.dta", clear
//bysort household_id2 personid: gen dup = cond(_N==1,0,_n)
//tab dup 
//edit if dup>=1
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_control_income.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_make_ag_decision.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_ownasset.dta", nogen keep(1 3)
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhsize.dta", nogen keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta", nogen

* Land rights 
merge 1:1 household_id2 personid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1				// this line will set to zero for all women for whom it is missing (i.e. regardless of ownerhsip status)
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Ethiopia_ESS_W3_final_data}/Ethiopia_ESS_W3_household_variables.dta", clear
keep household_id2 ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 household_id2 using `ag_hh', nogen keep (1 3)

replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.

/*
foreach c in wheat beans {
	gen all_imprv_seed_`c' = .
	gen all_hybrid_seed_`c' = .
	gen `c'_farmer = .
}
*/

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

gen female_use_inorg_fert=all_use_inorg_fert if female==1
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var male_imprv_seed_use "1 = Individual male farmer (plot manager) uses improved seeds" 
lab var female_imprv_seed_use "1 = Individual female farmer (plot manager) uses improved seeds"

lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"

*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
ren indiv indid
gen geography = "Nigeria"
gen survey = "LSMS-ISA"
gen year = "2015-16"
gen instrument = 10
capture label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
//gen strataid=state
//gen clusterid=ea
saveold "${Ethiopia_ESS_W3_final_data}/Ethiopia_ESS_W3_individual_variables.dta", replace

********************************************************************************
*FIELD-LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_all_fields.dta", clear
collapse (sum) plot_value_harvest = value_harvest (max) cultivate, by(household_id2 holder_id parcel_id field_id )
tempfile crop_values 
save `crop_values'

use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_areas.dta", clear
merge m:1 household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_weights.dta", keep (1 3) nogen
merge 1:1 household_id2 holder_id parcel_id field_id  using `crop_values', nogen keep(1 3)
merge 1:1 household_id2 holder_id parcel_id field_id  using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_decision_makers", keep (1 3) nogen // Bring in the gender file
//merge 1:1 holder_id parcel_id field_id  household_id2 using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_plot_farmlabor_postharvest.dta", keep (1 3) nogen
//Replaced by below.
merge 1:1 household_id2 holder_id parcel_id field_id  using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_field_labor_days.dta", keep (1 3) nogen

merge m:1 household_id2 using "${Ethiopia_ESS_W3_final_data}/Ethiopia_ESS_W3_household_variables.dta", nogen keep (1 3) keepusing(region strataid clusterid hhid ag_hh fhh farm_size_agland rural)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

keep if cultivate==1
//ren field_size  area_meas_hectares
egen labor_total = rowtotal(labor_family labor_hired labor_nonhired) 
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}

_pctile plot_value_harvest  [aw=weight] , p($wins_upper_thres)  
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
gen plot_weight=w_area_meas_hectares*weight 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	

*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = (1) * `p' / $Ethiopia_ESS_W3_cons_ppp_dollar
	gen `p'_2ppp = (1) * `p' / $Ethiopia_ESS_W3_gdp_ppp_dollar
	gen `p'_usd = (1) * `p' / $Ethiopia_ESS_W3_exchange_rate 
	gen `p'_loc = (1) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' 2016 (NGN)"  
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = (1) * w_`p' / $Ethiopia_ESS_W3_cons_ppp_dollar
	gen w_`p'_2ppp = (1) * w_`p' / $Ethiopia_ESS_W3_gdp_ppp_dollar
	gen w_`p'_usd = (1) * w_`p' / $Ethiopia_ESS_W3_exchange_rate
	gen w_`p'_loc = (1) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' 2106 (NGN)"
	lab var w_`p' "`lw_`p'' (NGN)" 
}

**************************************
* GENDER GAPS *
**************************************

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) 		// get standard errors of the mean

*SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) //use winsorize value for to report gender gap
gen larea_meas_hectares=ln(w_area_meas_hectares)
svy, subpop(  if rural==1 ): reg  lplot_productivity_usd male_dummy 
matrix b1a=e(b)
gen gender_prod_gap1a=100*el(b1a,1,1)
sum gender_prod_gap1a
lab var gender_prod_gap1a "Gender productivity gap (%) - regression in logs with no controls"
matrix V1a=e(V)
gen segender_prod_gap1a= 100*sqrt(el(V1a,1,1)) 
sum segender_prod_gap1a
lab var segender_prod_gap1a "SE Gender productivity gap (%) - regression in logs with no controls"

*Gender-gap 1b
svy, subpop(  if rural==1 ): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
matrix b1b=e(b)
gen gender_prod_gap1b=100*el(b1b,1,1)
sum gender_prod_gap1b
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls"
matrix V1b=e(V)
gen segender_prod_gap1b= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b
lab var segender_prod_gap1b "SE Gender productivity gap (%) - regression in logs with controls"
lab var lplot_productivity_usd "Log Value of crop production per hectare"



/*BET.12.3.2020 - Begin*/ 
*SSP
svy, subpop(  if rural==1 & rural_ssp==1): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
matrix b1b=e(b)
gen gender_prod_gap1b_ssp=100*el(b1b,1,1)
sum gender_prod_gap1b_ssp
lab var gender_prod_gap1b_ssp "Gender productivity gap (%) - regression in logs with controls - SSP"
matrix V1b=e(V)
gen segender_prod_gap1b_ssp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_ssp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - SSP"


*LS_SSP
svy, subpop(  if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
matrix b1b=e(b)
gen gender_prod_gap1b_lsp=100*el(b1b,1,1)
sum gender_prod_gap1b_lsp
lab var gender_prod_gap1b_lsp "Gender productivity gap (%) - regression in logs with controls - LSP"
matrix V1b=e(V)
gen segender_prod_gap1b_lsp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_lsp
lab var segender_prod_gap1b_lsp "SE Gender productivity gap (%) - regression in logs with controls - LSP"


/// *BT 12.3.2020

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

rename v1 ETH_wave3

save   "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_gendergap.dta", replace
restore

/*BET.12.3.2020 - END*/ 

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen field_labor_weight= w_labor_total*weight

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren household_id2 hhid
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
ren field_id plot_id
gen geography = "Ethiopia"
gen survey = "LSMS-ISA"
gen year = "2015-16"
gen instrument = 7
label define instrument7 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument7

saveold "$Ethiopia_ESS_W3_final_data/Ethiopia_ESS_W3_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Ethiopia_ESS_W3"
do "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\_Summary_statistics\EPAR_UW_335_SUMMARY_STATISTICS_01.17.2020_alt.do" 
 