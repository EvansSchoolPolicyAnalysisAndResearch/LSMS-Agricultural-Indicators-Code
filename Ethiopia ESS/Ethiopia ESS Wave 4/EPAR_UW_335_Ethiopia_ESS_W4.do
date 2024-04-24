
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 4 (2018-19)
*Author(s)		: Didier Alia, Andrew Tomes, & C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of David Coomes, Kelsey Figone, Helen Ippolito, Jack Knauer, Josh Merfeld, Isabella Sun, Rebecca Toole, Emma Weaver, Ayala Wineman, 
				  Pierre Biscaye, Travis Reynolds and members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - 03 Feb 2023
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Ethiopia Socioeconomic Survey was collected by the Ethiopia Central Statistical Agency (CSA) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period September - October 2018, February - March 2019, and June - August 2019.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*https://microdata.worldbank.org/index.php/catalog/3823

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Ethiopia Socioeconomic Survey. In addition, we sometimes use Wave 4 to refer to this instance of the survey, although this is a new panel and not a follow-up of previous ESS waves. 

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Ethiopia ESS data set.
*Using data files from within the "Raw DTA files" folder within the "Ethiopia ESS Wave 4" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Ethiopia_ESS_W4_summary_stats.rtf" in the folder "final_dta" within the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*
	
*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD-LEVEL VARIABLES			Ethiopia_ESS_W4_household_variables.dta
*FIELD-LEVEL VARIABLES				Ethiopia_ESS_W4_field_plot_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Ethiopia_ESS_W4_individual_variables.dta	
*SUMMARY STATISTICS					Ethiopia_ESS_W4_summary_stats.xlsx

*/


clear
clear matrix
clear mata
set more off
set maxvar 10000		
ssc install findname  // need this user-written ado file for some commands to work	

*Set location of raw data and output
global directory 					"//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves"
*global directory					"/Volumes/wfs/Project/EPAR/Working Files/335 - Ag Team Data Support/Waves"

*Set directories
global Ethiopia_ESS_W4_raw_data			"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Raw DTA Files"
global Ethiopia_ESS_W4_created_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Final DTA Files/created_data"
global Ethiopia_ESS_W4_final_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Final DTA Files/final_data" 


********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD IDS
********************************************************************************
global Ethiopia_ESS_W4_exchange_rate 21.2389 /*39.3988*/	// https://www.bloomberg.com/quote/USDETB:CUR
global Ethiopia_ESS_W4_gdp_ppp_dollar 8.668  /*10.35*/ 	// https://data.worldbank.org/indicator/PA.NUS.PPP
global Ethiopia_ESS_W4_cons_ppp_dollar 8.674 /*10.74*/	// https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
/*DYA.7.27.2021 These should the 2016 values and we then use the inflation rate to bring every monetary value in 2016 values before converting into PPP or USD
it this note that some of these values has slightly changed since the last time we use them*/ 
global Ethiopia_ESS_W4_inflation -.20628477 // /*DYA.7.27.2021*/ Inflation between 2019 and 2016  di (218.586-275.396)/275.396

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


*Note Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators# for 2019 (most recent year)
global Ethiopia_ESS_W4_pop_tot 112078730 			
global Ethiopia_ESS_W4_pop_rur 88542197				//79% of total
global Ethiopia_ESS_W4_pop_urb 23536533				//21% of total


********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 

global topcropname_area "maize rice wheat sorgum millet grdnt beans swtptt cassav banana teff barley coffee sesame hsbean nueg"		
global topcrop_area "2 5 8 6 3 24 12 62 10 42 7 1 72 27 13 25"
global comma_topcrop_area "2, 5, 8, 6, 3, 24, 12, 62, 10, 42, 7, 1, 72, 27, 13, 25"
global topcropname_full "maize rice wheat sorghum millet groundnut beans sweetpotato cassava banana teff barley coffee sesame horsebean nueg"
global nb_topcrops : word count $topcrop_area


********************************************************************************
* CROP CONVERSION FACTOR ADJUSTMENT
********************************************************************************
// W4 raw data file Crop_CF_Wave4.dta has duplicate observations for crop_code=74, unit_cd=62. Based on W3 data, we have chosen to retain cf=4.34 (and drop cf=6.125) for continuity. 
use "$Ethiopia_ESS_W4_raw_data/Food and Crop Conversion Factors/Crop_CF_Wave4.dta", clear
drop if crop_code==74 & unit_cd==62 & mean_cf_nat==6.125
save "${Ethiopia_ESS_W4_created_data}/Crop_CF_Wave4_adj.dta", replace


********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Household/sect_cover_hh_W4.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq04 city
ren saq05 subcity
ren saq06 kebele
ren saq07 ea
ren saq08 household
ren pw_w4 weight
ren saq14 rural
gen rural2=.
replace rural2=1 if rural==1
replace rural2=0 if rural==2
ren rural old_rural
ren rural2 rural
lab var rural "Rural/Urban"
keep region zone woreda city subcity kebele ea household weight rural household_id
/*DYA.7.27.2021 VERY important to use weight. It is seems that urban houseold are oversampled (NEED TO CHECK WHY)
ta rural //--> 46.01%
ta rural [aw=weight]  //--> 67.54% more in line with W3
*/
destring region zone woreda, replace
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", replace



********************************************************************************
*WEIGHTS AND GENDER OF HEAD
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Household/sect1_hh_W4.dta", clear
gen fhh = s1q02==2 if s1q01==1	 

*Unlike W3 we do not need to change the strata significantly, as all regions and urban/rural stratification are representative (see BID for more information). Remember, W4 is an entirely new sample. 
gen clusterid = ea_id
gen personid = individual_id
ren saq14 rural
gen rural2=.
replace rural2=1 if rural==1
replace rural2=0 if rural==2
ren rural old_rural
ren rural2 rural
lab var rural "Rural/Urban"
gen strataid=saq01 if rural==1 //assign region as strataid to rural respondents; regions from 1 to 7 and then 12 to 15
gen stratum_id=. 
replace stratum_id=16 if rural==0 & saq01==1 	//Tigray, urban
replace stratum_id=17 if rural==0 & saq01==2	//Afar, urban	KEF 2.4.21: Does it matter if in W1-W3, stratumid 17 was associated with Amhara, and now it's associated with Afar?
replace stratum_id=18 if rural==0 & saq01==3 	//Amhara, urban
replace stratum_id=19 if rural==0 & saq01==4 	//Oromiya, urban
replace stratum_id=20 if rural==0 & saq01==5	//Somali, urban
replace stratum_id=21 if rural==0 & saq01==6	//Benishangul Gumuz, urban
replace stratum_id=22 if rural==0 & saq01==7 	//SNNP, urban
replace stratum_id=23 if rural==0 & saq01==12	//Gambela, urban
replace stratum_id=24 if rural==0 & saq01==13 	//Harar, urban
replace stratum_id=25 if rural==0 & saq01==14 	//Addis Ababa, urban KEF 2.4.21: Addis Ababa is only urban, no rural respondents
replace stratum_id=26 if rural==0 & saq01==15 	//Dire Dawa, urban
replace strataid=stratum_id if rural==0 		//assign new strata IDs to urban respondents, stratified by region and urban

gen hh_members = 1 
gen hh_women = s1q02==2
gen hh_adult_women = (hh_women==1 & s1q03a>14 & s1q03a<65)			//Adult women from 15-64 (inclusive)
gen hh_youngadult_women = (hh_women==1 & s1q03a>14 & s1q03a<25) 		//Adult women from 15-24 (inclusive) 
collapse (max) fhh (firstnm) pw_w4 clusterid strataid (sum) hh_members, by(household_id)	//removes duplicate values, now 6,770 observations instead of 
lab var hh_members "Number of household members"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw_w4 "Household weight"
*Re-scaling survey weights to match population estimates
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen 
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Ethiopia_ESS_W4_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Ethiopia_ESS_W4_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Ethiopia_ESS_W4_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
destring region zone woreda, replace
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_male_head.dta", replace


********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
*KEF Added this section per Andrew's guidance. Needed to make a person_id file that was comparable to NGA and TZA. 1/11/22
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect1_pp_w4.dta", clear
keep household_id s1q00 s1q02 s1q03
gen female = s1q03 == 2 // No missings.
lab var female "1 = individual is female"
rename s1q00 indiv
rename s1q03 sex
rename s1q02 age
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_person_ids.dta", replace


********************************************************************************
*INDIVIDUAL GENDER
********************************************************************************
*Using gender from planting and harvesting
*Harvest
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect1_ph_W4.dta", clear
ren s1q00 personid
gen female_ph = s1q03==2	// NOTE: Assuming missings are MALE
replace female_ph =. if s1q03==.
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop household_id personid, force
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_ph.dta", replace		

*Planting
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect1_pp_W4.dta", clear
ren s1q00 personid
gen female_pp = s1q03==2	// NOTE: Assuming missings are MALE
replace female_pp =. if s1q03==.
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop household_id personid, force
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_ph.dta", nogen 		
*DYA.07.27.2021 Test if gender of individual changes between pp and ph. If so, keep the pp value (ACTION: Modify this is earlier waves)
gen test_female=female_pp -female_ph
ta test_female  //18 individuals with different change
gen female=female_pp
replace female=female_ph if female_pp==.
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", replace

*Using household roster for missing gender 
use "$Ethiopia_ESS_W4_raw_data/Household/sect1_hh_W4.dta", clear
ren individual_id personid		//NOTE: s1q00 is the name of the HH member in this file. Therefore, we are using individual_id here since it correlates to the household member ID that hh_s1q00 references in W3. 
*ren household_id hhid //Keeping this as household_id
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", clear
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen	// All were matched.
duplicates drop household_id personid, force			//no duplicates
replace female = s1q03==2 if female==.	 //*DYA.07.27.2021  change s1q02 (age) to s1q03 (gender) but no change
*Assuming missings are male
recode female (.=0)		// no changes
egen individual_id = concat(household_id personid) //KEF 2.22.21: had to generate an individual id because no unique identifier per person.
lab var personid "HH Member ID Code"
lab var individual_id "Individual ID"
duplicates drop individual_id, force
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", replace

********************************************************************************
*PLOT DECISION-MAKERS
********************************************************************************
*Gender/age variables
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
gen cultivated = s3q03==1			// if plot was cultivated

*First owner/decision maker
gen personid = s3q13
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(dm1_merge) keep(1 3)			
*5,964 not matched from master
*13,375 matched
tab dm1_merge cultivate		// All but two unmatched observations are due to field not being cultivated
*First decision-maker variables
gen dm1_female = female
drop female personid
*Second owner/decision maker
gen personid = s3q15_1
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(dm2_merge) keep(1 3)			
*10,027 not matched from master
*9,312 matched
gen dm2_female = female
drop female personid
*Third owner/decision maker
gen personid = s3q15_2
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(dm3_merge) keep(1 3)		
*16,617 not matched from master
*2,722 matched
gen dm3_female = female
drop female personid
*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var dm_gender "Gender of decision-maker(s)"
keep dm_gender holder_id household_id field_id parcel_id
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", replace

********************************************************************************
* ALL AREA CONSTRUCTION
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
gen cultivated = s3q03==1			// if plot was cultivated
*Generating some conversion factors
gen area = s3q02a 
gen local_unit = s3q02b
gen area_sqmeters_gps = s3q08
replace area_sqmeters_gps = . if area_sqmeters_gps<0
*Constructing geographic medians for local unit per square meter ratios
preserve
*ren household_id hhid // Keeping this as household_id
keep household_id parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta" // 4,651 not matched, 18,699 matched
// BET 08.06.2021 this leaves us with all rural households 
drop if _merge==2 // 4,011 obs deleted
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area // 101 missing vars generated
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
ren sqmeters_per_unit sqmeters_per_unit_zone 
ren observations obs_zone
destring region zone, replace
lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", replace
restore
preserve
replace area_sqmeters_gps=. if area_sqmeters_gps<0
*ren household_id hhid // keeping this as household_id
keep household_id parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
ren sqmeters_per_unit sqmeters_per_unit_region
ren observations obs_region
destring region, replace
lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", replace
restore
preserve
replace area_sqmeters_gps=. if area_sqmeters_gps<0
*ren household_id hhid // Keeping this as household_id
keep household_id parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
ren sqmeters_per_unit sqmeters_per_unit_country
ren observations obs_country
lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", replace
restore



*Now creating area - starting with sq meters
gen area_meas_hectares = s3q02a*10000 if s3q02b==1			// hectares to sq m
replace area_meas_hectares = s3q02a if s3q02b==2			// already in sq m

*For rest of units, we need to use the conversion factors
gen region = saq01
gen zone = saq02
gen woreda = saq03
destring region zone woreda, replace
merge m:1 region zone woreda local_unit using "$Ethiopia_ESS_W4_raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)	// 195 not matched from using, dropped
*16,983 not matched from master
*2,356 matched
replace area_meas_hectares = s3q02a*conversion if !inlist(s3q02b,1,2) & s3q02b!=.			// non-traditional units
*Field area is currently farmer reported - replacing with GPS area when available
replace area_meas_hectares = s3q08 if s3q08!=. & s3q08>0			// 32,205 changes
replace area_meas_hectares = area_meas_hectares*0.0001						// Changing back into hectares
*Using our own created conversion factors for still missings observations
merge m:1 region zone local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_meas_hectares==. & obs_zone>=10		
merge m:1 region local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_meas_hectares==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_meas_hectares==.
count if area!=. & area_meas_hectares==.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
gen area_meas_hectares_male = area_meas_hectares if dm_gender==1
gen area_meas_hectares_female = area_meas_hectares if dm_gender==2
gen area_meas_hectares_mixed = area_meas_hectares if dm_gender==3
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", replace




/****

*KEF 5.20.21 The following code is a holdover from W4. In W4, 98/19,339 observations are measured with GPS or compass and rope in sq. m., so the following conversions from local units is no longer necessary.
/*Now creating area - starting with sq meters
gen area_meas_hectares = s3q02a*10000 if s3q02b==1			// hectares to sq m
replace area_meas_hectares = s3q02a if s3q02b==2			// those fields already in sq m
/*For rest of units, we need to use the conversion factors
gen region = saq01
gen zone = saq02
gen woreda = saq03
merge m:1 region zone woreda local_unit using "$Ethiopia_ESS_W4_raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)	// KEF 5.2.21 This is giving me an error because this .dta file does not exist in the raw .dta files. It is not a created .dta file and the next time it is in the file is in line 1765. Looking into the BIDs between waves 3 and 4, it seems that in the previous wave there was some self-reporting of land size/area; not all land was GPS-measured. In this wave, enumerator measured all fields using gps or compass if the field were small. It seems that none of the areas were self-reported by the holder. 
/*66 not matched from using, dropped
*20,826 not matched from master
*12,479 matched*/
replace area_meas_hectares = s3q02a*conversion if !inlist(s3q02b,1,2) & s3q02b!=.			//KEF 5.2.21 This does not run; conversion not found. non-traditional units
*/
replace area_meas_hectares = s3q08 if s3q08!=. & s3q08>0			// 18,529 changes
replace area_meas_hectares = area_meas_hectares*0.0001						// Changing back into hectares
*/

*Creating new code to convert area from square meters to hectares. 
gen area_meas_hectares = s3q08/10000

*Using our own created conversion factors for still missing observations
ren saq01 region
ren saq02 zone
merge m:1 region zone local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_meas_hectares==. & obs_zone>=10		
merge m:1 region local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_meas_hectares==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", nogen
replace area_meas_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_meas_hectares==.
count if area!=. & area_meas_hectares==.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
gen area_meas_hectares_male = area_meas_hectares if dm_gender==1
gen area_meas_hectares_female = area_meas_hectares if dm_gender==2
gen area_meas_hectares_mixed = area_meas_hectares if dm_gender==3
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", replace
*/


*Parcel Area
collapse (sum) land_size = area_meas_hectares area_meas_hectares, by(household_id holder_id parcel_id)
lab var land_size "Parcel area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcel_area.dta", replace

*Household Area
collapse (sum) area_meas_hectares_hh = land_size, by(household_id)
lab var area_meas_hectares_hh "Total area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_area.dta", replace

*Cultivated (HH) area
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", clear
keep if cultivated==1
collapse (sum) farm_area = area_meas_hectares, by (household_id)
lab var farm_area "Land size, all cultivated plots (denominator for land productivitiy), in hectares" 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farm_area.dta", replace

*Agricultural land summary and area
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", clear
gen agland = (s3q03==1 | s3q03==2 | s3q03==3 | s3q03==5) // Cultivated, pasture, fallow, or prepared for Belg season. Excludes forest, home/homestead and "other" (which includes everything from "eucalyptus tree" to storage and land "used for belge")
keep if agland==1
keep household_id parcel_id field_id holder_id agland area_meas_hectares
ren area_meas_hectares farm_size_agland_field
lab var farm_size_agland "Field size in hectares, including all plots cultivated, fallow, or pastureland"
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fields_agland.dta", replace

*Agricultural land area household
collapse (sum) farm_size_agland = farm_size_agland_field, by (household_id)
lab var farm_size_agland "Total land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmsize_all_agland.dta", replace

********************************************************************************
*MONOCROPPED CROPS*
********************************************************************************
global nb_topcrops : word count $topcrop_area

use "${Ethiopia_ESS_W4_raw_data}/Post-Planting/sect4_pp_W4.dta", clear
	ren s4q01b crop_code
	*recoding common beans to a single category
	recode crop_code (19=12)
	xi i.crop_code, noomit
	egen crop_count = rowtotal(_Icrop_code_*)

forvalues k=1(1)$nb_topcrops {
	preserve
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	gen percent_`cn'=1 if s4q02==1 & crop_code==`c'
	replace percent_`cn' = s4q03/100 if s4q02==2 & s4q03!=. & crop_code==`c'		
	collapse (max) percent_`cn' _Icrop_code_*, by(household_id parcel_id field_id holder_id)
	egen crop_count = rowtotal(_Icrop_code_*)
	keep if _Icrop_code_`c'==1 & crop_count==1
	*merging in plot areas
	merge m:1 field_id parcel_id household_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3)
	gen `cn'_monocrop_ha= area_meas_hectares*percent_`cn'
	gen `cn'_monocrop_ha_female = area_meas_hectares*percent_`cn' if dm_gender==2
	gen `cn'_monocrop_ha_male = area_meas_hectares*percent_`cn' if dm_gender==1
	gen `cn'_monocrop_ha_mixed = area_meas_hectares*percent_`cn' if dm_gender==3
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", replace
	collapse (sum) `cn'_monocrop_ha*, by(household_id)
	gen `cn'_monocrop=1 
	lab var `cn'_monocrop "1=hh has monocropped `cn' plots"
	recode `cn'_monocrop_ha* (0=.)
	lab var `cn'_monocrop_ha "monocropped `cnfull' area(ha) planted"
	foreach i in male female mixed {
		local l`cn'_monocrop_ha : var lab `cn'_monocrop_ha
		la var `cn'_monocrop_ha_`i' "`l`cn'_monocrop_ha' - `i' managed plots"
	}
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop_hh_area.dta", replace
	restore
}

********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
*Crops including tree crops, vegetables, root crops 
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect11_ph_W4.dta", clear
ren saq01 region
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
ren saq07 ea
ren saq08 household
ren s11q01 crop_code
ren s11q07 sell_yesno
ren s11q11a quantity_sold
ren s11q11b quantity_sold_unit
gen unit_cd = quantity_sold_unit
ren s11q12 value_sold
ren s11q27a percent_sold // KEF: The way this question is asked in W4 is not really comparable to W3. W4 puts much more emphasis on stored v. unstored crops.
keep if sell_yesno==1
drop if value_sold==0 | value_sold==.
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales_1.dta", replace

/* KEF: Old code. There is no section 12 in W4. It seems like there is no distinguishing between tree crops/veggie/root crops like there was in the previous waves. 
ren saq01 region
*Tree crops, vegetables, root crops
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect12_ph_W4.dta", clear 
ren saq02 zone
ren saq03 woreda
ren saq06 kebele
ren saq07 ea
ren saq08 household
ren ph_s12q06 sell_yesno
ren ph_s12q07 quantity_sold
ren ph_s12q0b quantity_sold_unit
gen unit_cd = quantity_sold_unit
ren ph_s12q08 value_sold
ren ph_s12q19_f percent_sold
keep if sell_yesno==1 
drop if value_sold==0 | value_sold==.
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales_2.dta", replace
*/

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales_1.dta", clear
//append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales_2.dta" KEF: unnecessary from old code
merge m:1 crop_code unit_cd using "${Ethiopia_ESS_W4_created_data}/Crop_CF_Wave4_adj.dta", nogen keep(1 3) // KEF: Created a dummy as a unique identifier, thus used this in place of the original conversion factors. 378 not matched, maybe because not all of the conversion factors existed. 

gen kgs_sold = quantity_sold * mean_cf_nat /* Here, if conversion value is missing, this will be a missing observation in the imputed median price estimation. */
collapse (sum) kgs_sold value_sold (max) percent_sold, by (household_id crop_code) /* For duplicated obs, we'll take the maximum reported % sold. */
gen price_kg = value_sold / kgs_sold
lab var price_kg "Price received per kgs sold"
drop if price_kg==. | price_kg==0
keep household_id crop_code price_kg value_sold percent_sold kgs_sold
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
*replace crop_code=6 if household_id=="030101088800204020" & crop_code==1 /* Typo, crops mismatched between files on production and sales */ //KEF How do I know if there is a crop mismatch here?
destring region zone woreda, replace
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", replace 

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", clear
gen observation = 1
bys region zone woreda kebele ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda kebele ea crop_code obs_ea)
ren price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_ea.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", clear
gen observation = 1
bys region zone woreda kebele crop_code: egen obs_kebele = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda kebele crop_code obs_kebele)
ren price_kg price_kg_median_kebele
lab var price_kg_median_kebele "Median price per kg for this crop in the kebele"
lab var obs_kebele "Number of sales observations for this crop in the kebele"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_kebele.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", clear
gen observation = 1
bys region zone woreda crop_code: egen obs_woreda = count(observation)
collapse (median) price_kg [aw=weight], by (region zone woreda crop_code obs_woreda)
ren price_kg price_kg_median_woreda
lab var price_kg_median_woreda "Median price per kg for this crop in the woreda"
lab var obs_woreda "Number of sales observations for this crop in the woreda"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_woreda.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", clear
gen observation = 1
bys region zone crop_code: egen obs_zone = count(observation)
collapse (median) price_kg [aw=weight], by (region zone crop_code obs_zone)
ren price_kg price_kg_median_zone
lab var price_kg_median_zone "Median price per kg for this crop in the zone"
lab var obs_zone "Number of sales observations for this crop in the zone"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_zone.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
ren price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_region.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
ren price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_country.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect9_ph_W4.dta", clear 
ren s9q06 kgs_harvest

***************
//DYA 8.10.2021 
ta  kgs_harvest  // some of the values of ESTIMATED kgs harvest are extremely larger. We will use values reported in conventional unit as much as possible and complement with estimates only when missings. 
gen unit_cd= s9q05b 
ren s9q00b crop_code
merge m:1 crop_code unit_cd using "${Ethiopia_ESS_W4_created_data}/Crop_CF_Wave4_adj.dta", nogen keep(1 3) // KEF: 
ren s9q05a harvest_reported 
ren s9q05b harvest_reported_unit
replace kgs_harvest = harvest_reported * mean_cf_nat 
replace kgs_harvest=harvest_reported if harvest_reported_unit==1 //Kg
replace kgs_harvest=harvest_reported/1000 if harvest_reported_unit==2  //gram
replace kgs_harvest=harvest_reported*100 if harvest_reported_unit==3 //Quintal
******************

decode crop_code, gen(crop_name)			
keep household_id crop_name crop_code kgs_harvest
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3) //KEF: 446 not matched.
collapse (sum) kgs_harvest, by (household_id region zone woreda kebele ea crop_code)
merge 1:1 household_id crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", nogen //KEF: 8,109 not matched

*Kebele and ea are the same thing. KEF: These are NOT the same thing in W4. Help in looking at this section and if it is necessary?
merge m:1 region zone woreda kebele crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_kebele.dta", nogen //KEF: 6,124 not matched.
merge m:1 region zone woreda crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_woreda.dta", nogen //KEF: 5,639 not matched.
merge m:1 region zone crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_zone.dta", nogen //KEF: 4,110 not matched.
merge m:1 region crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_region.dta", nogen //KEF: 1,446 not matched.
merge m:1 crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_country.dta", nogen //KEF: 220 not matched.
ren price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kgs_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are at least categorized as being legumes, cereals, etc. So we will take the median per-kg price to value these crops.KEF: need to check that this is true.
count if value_harvest==. /* 231 household-crop observations can't be valued. Assume value is zero for now. */
replace value_harvest = value_sold if percent_sold==100 /* If the household sold 100% of this crop, then that is the value of production, even if odd units had been reported. */
replace value_harvest = value_sold if (kgs_harvest==0 | kgs_harvest==.) & value_sold>0 & value_sold!=.
replace value_harvest = value_sold if value_sold>value_harvest & value_sold!=. & value_harvest!=. /* In a few cases, the kgs sold exceeds the kgs harvested KEF: doublecheck this*/	
replace value_harvest=0 if value_harvest==.		
collapse (sum) value_harvest kgs_harvest value_sold kgs_sold, by (household_id crop_code)
gen value_crop_production = value_harvest
lab var value_crop_production "Gross value of crop production, summed over main and short season"
gen value_crop_sales = value_sold
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"

save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta", replace
collapse (sum) value_harvest value_sold, by (household_id)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using local median values of observed sales in which the sales unit is also found in the conversion table.
*For "Other" crops,these are valued as though "other spice", "other cereal" is its own crop code. KEF: check this
**If a crop is never, ever sold, it receives a value of zero using this method.
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
drop if household_id==""
save  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_production.dta", replace

*Value crop production by parcel
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect9_ph_W4.dta", clear
ren s9q06 kgs_harvest


***************
//DYA 8.10.2021 
ta  kgs_harvest  // some of the values of ESTIMATED kgs harvest are extremely larger. We will use values reported in conventional unit as much as possible and complement with estimates only when missings. 
gen unit_cd= s9q05b 
ren s9q00b crop_code
merge m:1 crop_code unit_cd using "${Ethiopia_ESS_W4_created_data}/Crop_CF_Wave4_adj.dta", nogen keep(1 3) // KEF: 
ren s9q05a harvest_reported 
ren s9q05b harvest_reported_unit
replace kgs_harvest = harvest_reported * mean_cf_nat 
replace kgs_harvest=harvest_reported if harvest_reported_unit==1 //Kg
replace kgs_harvest=harvest_reported/1000 if harvest_reported_unit==2  //gram
replace kgs_harvest=harvest_reported*100 if harvest_reported_unit==3 //Quintal
******************

 
decode crop_code, gen(crop_name)		
keep household_id crop_name crop_code kgs_harvest parcel_id field_id holder_id
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3) //KEF: 446 not matched again.
collapse (sum) kgs_harvest, by (household_id region zone woreda kebele ea crop_code parcel_id field_id holder_id)
merge m:1 household_id crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", nogen //KEF: 12,212 not matched. 
merge m:1 region zone woreda kebele crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_kebele.dta", nogen //KEF: 8,971 not matched. 
merge m:1 region zone woreda crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_woreda.dta", nogen //KEF: 8,196 not matched
merge m:1 region zone crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_zone.dta", nogen //KEF: 5,807 not matched. 
merge m:1 region crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_region.dta", nogen //KEF: 1,995 not matched.
merge m:1 crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_country.dta", nogen //KEF: 263 still not matched.
ren price_kg price_kg_hh
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
gen value_harvest = kgs_harvest * price_kg
lab var value_harvest "Value of harvest"
*For Ethiopia LSMS, "other" crops are at least categorized as being legumes, cereals, etc. 
*So we will take the median per-kg price to value these crops.
count if value_harvest==. /* 274 household-crop observations can't be valued. Assume value is zero for now. */
replace value_harvest=0 if value_harvest==.
preserve
collapse (sum) value_harvest, by (household_id holder_id parcel_id)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production for this parcel"
drop if household_id==""
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_parcel.dta", replace
*9,700 parcels cultivated //KEF: How do they know this?
restore
collapse (sum) value_harvest kgs_harvest, by (household_id holder_id parcel_id field_id)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production"
drop if household_id==""
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_field.dta", replace

merge 1:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen keep(1 3) //KEF: 17 not matched.
gen value_harvest_male = value_crop_production if dm_gender==1
gen value_harvest_female = value_crop_production if dm_gender==2
gen value_harvest_mixed = value_crop_production if dm_gender==3
collapse (sum) value_harvest* value_crop_production kgs_harvest, by (household_id)
lab var value_crop_production "Gross value of crop production"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_household.dta", replace

*Crop losses and value of consumption
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect11_ph_W4.dta", clear
ren s11q21a1 quantity_lost
ren s11q21a2 quantity_lost_units /* We can't value this for now KEF: why not? There are also 14 responses using other units. */
ren s11q21a3 percent_lost
ren s11q01 crop_code
/*KEF: There is no section 12 in the W4 questionnaire.
append using "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect12_ph_W4.dta"
ren ph_s12q12 share_lost
ren ph_s12q13 value_lost /* It's not clear why different types of crops were valued so differently. */
replace percent_lost = share_lost if percent_lost==.*/
merge m:1 household_id crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta" //KEF: 1,148 not matched. 
drop if _merge==2
drop _merge
*It is evident that sometimes crops were harvested but then the module on sales was not asked.
*498 cases where the amount lost was reported in quantity (crop-units) but no percent lost is given.
*Use conversion file to get from units to kgs, then use the price files to get from kgs to monetary values.
ren quantity_lost_units unit_cd
merge m:1 crop_code unit_cd using "${Ethiopia_ESS_W4_created_data}/Crop_CF_Wave4_adj.dta", nogen keep(1 3) //KEF: used the dummy version of the conversion factors again (see beginning of this section) since these did not uniquely identify observations in the raw conversion factors. 
gen kgs_lost = quantity_lost * mean_cf_nat
sum kgs_lost if percent_lost==0 /* If both a quantity and share lost were given, we'll take the share to be consistent with section 12. */
lab var kgs_lost "Estimated number of kgs of this crop that were lost post-harvest"
merge m:1 household_id crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", nogen //KEF: 7,111 not matched
merge m:1 region zone woreda kebele crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_kebele.dta", nogen
merge m:1 region zone woreda crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_woreda.dta", nogen
merge m:1 region zone crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_zone.dta", nogen
merge m:1 region crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_prices_country.dta", nogen
ren price_kg price_kg_hh //KEF: 162 not matched.
gen price_kg = price_kg_hh
replace price_kg = price_kg_median_kebele if price_kg==. & obs_kebele >= 10
replace price_kg = price_kg_median_woreda if price_kg==. & obs_woreda >= 10
replace price_kg = price_kg_median_zone if price_kg==. & obs_zone >= 10
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10
replace price_kg = price_kg_median_country if price_kg==. 
lab var price_kg "Price per kg, with all values imputed using local median values of observed sales"
count if (kgs_lost>0 & kgs_lost!=.) | (percent_lost>0 & percent_lost!=.)
replace kgs_lost = 0 if percent_lost!=0 & percent_lost!=.
recode kgs_lost percent_lost (.=0)
gen value_quantity_lost = kgs_lost * price_kg
/*If the estimated value lost (just 10 obs) exceeds the value produced (We're relying on kg-estimates to value harvest, 
and the units reported can also differ across files), then we'll cap the losses at the value of production */
replace value_quantity_lost = value_crop_production if value_quantity_lost > value_crop_production & value_quantity_lost!=.
gen crop_value_lost = (value_crop_production * (percent_lost/100)) + value_quantity_lost
recode crop_value_lost (.=0)
*Also including transport costs for crop sales here
ren s11q17 value_transport_cropsales
recode value_transport_cropsales (.=0)
collapse (sum) crop_value_lost value_transport_cropsales, by (household_id)
lab var crop_value_lost "Value of crop losses"
lab var value_transport_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_losses.dta", replace

********************************************************************************
*CROP EXPENSES
********************************************************************************
*Expenses: Hired labor
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q30a number_men
ren s3q30b number_days_men
ren s3q30c wage_perday_men
ren s3q30d number_women
ren s3q30e number_days_women
ren s3q30f wage_perday_women
ren s3q30g number_children
ren s3q30h number_days_children
ren s3q30i wage_perday_children
gen wages_paid_men = number_days_men * wage_perday_men
gen wages_paid_women = number_days_women * wage_perday_women 
gen wages_paid_children = number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postplant =  wages_paid_men + wages_paid_women + wages_paid_children		
*Top crops
foreach cn in $topcropname_area {
	preserve
	merge 1:1 household_id parcel_id field_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	// only in master and matched; keeping only matched, because these are the monocropped plots
	collapse (sum) wg_paid_aglabor_postplant_`cn' = wages_paid_aglabor_postplant, by(household_id)		//renaming all to crop suffix
	lab var wg_paid_aglabor_postplant_`cn' "Wages paid for hired labor (crops) - Monocropped `cn' plots only, as captured in post-planting survey"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wages_postplanting_`cn'.dta", replace
	restore
}
collapse (sum) wages_paid_aglabor_postplant, by (household_id)
lab var wages_paid_aglabor_postplant "Wages paid for hired labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wages_postplanting.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect10_ph_W4.dta", clear
ren s10q01a number_men
ren s10q01b number_days_men
ren s10q01c wage_perday_men
ren s10q01d number_women
ren s10q01e number_days_women
ren s10q01f wage_perday_women
ren s10q01g number_children
ren s10q01h number_days_children
ren s10q01i wage_perday_children
gen wages_paid_men = number_days_men * wage_perday_men
gen wages_paid_women = number_days_women * wage_perday_women 
gen wages_paid_children = number_days_children * wage_perday_children
recode wages_paid_men wages_paid_women wages_paid_children (.=0)
gen wages_paid_aglabor_postharvest =  wages_paid_men + wages_paid_women + wages_paid_children

*Top crops
foreach cn in $topcropname_area {
	preserve 
	merge m:1 household_id parcel_id field_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	// only in master and matched; keeping only matched, because these are the monocropped plots
	collapse wg_paid_aglabor_postharv_`cn' = wages_paid_aglabor_postharvest, by(household_id)
	lab var wg_paid_aglabor_postharv_`cn' "Wages paid for hired labor (crops) - Monocropped `cn' plots only, as captured in post-harvest survey"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wages_postharvest_`cn'.dta", replace
	restore
}

collapse (sum) wages_paid_aglabor_postharvest, by (household_id)
lab var wages_paid_aglabor_postharvest "Wages paid for hired labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wages_postharvest.dta", replace

*Expenses: Inputs
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q21d value_urea
ren s3q22d value_DAP
ren s3q23d value_NPS
ren s3q24d value_other_chemicals //KEF: ESS 4 specifically states "blended chemical fertilizer"
encode value_urea, generate(value_urea2) //KEF value_urea is incorrectly coded as a string type.
ren value_urea value_ureaold
ren value_urea2 value_urea
recode value_urea value_DAP value_NPS value_other_chemicals (.=0)

*Top crops
foreach cn in $topcropname_area {
	preserve
	merge m:1 household_id parcel_id field_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)
	gen value_urea_`cn' = value_urea
	gen value_DAP_`cn' = value_DAP 
	gen value_NPS_`cn' = value_NPS
	gen value_other_chem_`cn' = value_other_chemicals
	lab var value_urea_`cn' "Value of urea used on the farm - Monocropped `cn' plots"
	lab var value_DAP_`cn' "Value of DAP used on the farm - Monocropped `cn' plots"
	lab var value_other_chem_`cn' "Value of any other chemicals used on the farm - Monocropped `cn' plots"
	egen value_fertilizer_`cn' = rowtotal(value_urea_`cn' value_DAP_`cn' value_NPS_`cn' value_other_chem_`cn')
	la var value_fertilizer_`cn' "Value of all fertilizer on `cn' monocropped plots"
	merge 1:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen keep(3)
	gen value_fertilizer_`cn'_male = value_fertilizer_`cn' if dm_gender==1
	gen value_fertilizer_`cn'_female = value_fertilizer_`cn' if dm_gender==2
	gen value_fertilizer_`cn'_mixed = value_fertilizer_`cn' if dm_gender==3
	collapse (sum) value_fertilizer_`cn'*, by(household_id)
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fertilizer_costs_`cn'.dta", replace
	restore
}

collapse (sum) value_urea value_DAP value_NPS value_other_chemicals, by (household_id)
lab var value_urea "Value of urea used on the farm"
lab var value_DAP "Value of DAP used on the farm"
lab var value_NPS "Value of NPS used on the farm"
lab var value_other_chemicals "Value of blended chemical fertilizer used on the farm"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fertilizer_costs.dta", replace

*Other chemicals, manure (Values not captured for Ethiopia ESS)

*Seeds
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect5_pp_W4.dta", clear
ren s5q06 cost_transport_purchased_seed
ren s5q07 value_purchased_seed
ren s5q15 cost_transport_free_seed
recode value_purchased_seed cost_transport_purchased_seed cost_transport_free_seed (.=0)
collapse (sum) value_purchased_seed cost_transport_purchased_seed cost_transport_free_seed , by (household_id)
lab var value_purchased_seed "Value of purchased seed"
lab var cost_transport_purchased_seed "Cost of transport for purchased seed"
lab var cost_transport_free_seed "Cost of transport for free seed"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_seed_costs.dta", replace
*Value of seed purchased (not just improved seed) is also captured here.

*Land rental
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", clear
gen rented_plot = (s2q05==3)
ren s2q10a rental_cost_cash
ren s2q10b rental_cost_inkind
ren s2q10c rental_cost_share /* This will have to be picked up after we've valued the plot harvest. */
gen formal_land_rights = s2q03==1

*Individual level (for women)
*starting with first owner through fourth owner // KEF this is not necessarily the owner, but the person in possession of said documents. ESS W4 has up to two documents listed with four potential "owners" per document. 
preserve
ren s2q04b_1 personid1
ren s2q04b_2 personid2
ren s2q04b_3 personid3
ren s2q04b_4 personid4
keep personid* household_id formal_land_rights parcel_id
gen dummy1=1
gen dummy2=sum(dummy1)
drop dummy1
reshape long personid, i (household_id formal_land_rights parcel_id dummy2) j(idno)
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen keep(3) //keep only matched
keep household_id personid female formal_land_rights parcel_id
gen formal_land_rights_f = formal_land_rights==1 & female==1
collapse (max) formal_land_rights_f, by(household_id personid parcel_id)
* BET 07.20.21 PLEASE CHECK: was having issues with a merge because this was at a parcel level not individual level so i have addded an additional collapse
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_parcel.dta", replace
collapse (max) formal_land_rights_f, by(household_id personid)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_ind.dta", replace
collapse (max) formal_land_rights_hh= formal_land_rights, by(household_id)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_hh.dta", replace
restore

merge 1:1 household_id holder_id parcel_id using"${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_parcel.dta", nogen keep(1 3) 
replace rental_cost_cash = rental_cost_share if rental_cost_share>100 & rental_cost_share!=. /* These two columns seem to be switched for a few parcels */
replace rental_cost_share = 0 if rental_cost_share>100 & rental_cost_share!=.
gen rental_cost_sharecrop = value_crop_production * (rental_cost_share/100)
recode rental_cost_cash rental_cost_inkind rental_cost_sharecrop (.=0)
gen rental_cost_land =  rental_cost_cash + rental_cost_inkind + rental_cost_sharecrop
collapse (sum) rental_cost_land, by (household_id)
lab var rental_cost_land "Rental costs for land(paid in cash and in kind or paid as sharecrop)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rental_costs.dta", replace
*Rental of agricultural tools, machines = Not captured.

*Transport costs for crop sales
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect11_ph_W4.dta", clear
ren s11q17 transport_costs_cropsales
recode transport_costs_cropsales (.=0)
collapse (sum) transport_costs_cropsales, by (household_id)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_transportation_cropsales.dta", replace


********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*BET 05.26.2021
*Expenses
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_w4.dta", clear
append using "$Ethiopia_ESS_W4_raw_data/sect8_3_ls_w4.dta"
append using "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_w4.dta"
ren ls_s8_3q11 cost_water_livestock
ren ls_s8_3q14 cost_fodder_livestock
ren ls_s8_3q22 cost_vaccines_livestock
ren ls_s8_3q24 cost_treatment_livestock
ren ls_s8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)

*Dairy costs
preserve
keep if ls_type == 1
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock)
keep household_id cost_lrum
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_lrum_expenses", replace
restore 

preserve
ren ls_type livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry"
la val species species
collapse (sum) cost_vaccines_livestock cost_treatment_livestock, by (household_id species) 
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
foreach i in ls_exp_vac{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (firstnm) *lrum *srum *pigs *equine *poultry, by(household_id)

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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_animal", replace
restore 

collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses", replace
*Note that costs for hired labor are not captured.

*Livestock products
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_w4.dta", clear

ren ls_code livestock_code 
ren ls_s8_4_q02 animals_milked
ren ls_s8_4q03 months_milked
ren ls_s8_4q04 liters_per_day 
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
ren ls_s8_4q10 earnings_milk_week
ren ls_s8_4q09 liters_sold_week 
ren ls_s8_4q12 earnings_milk_products /* Note that we can't value the milk inputs here. They'll get double-counted as income */
gen price_per_liter = earnings_milk_week / liters_sold_week

// BET 05.26.2021 egg production is reported over 12 months, but egg sales are reported over 3 months
ren ls_s8_4q16 egg_laying_hens
ren ls_s8_4q14 clutching_periods
ren ls_s8_4q15 eggs_per_clutching_period
ren ls_s8_4q18 eggs_sold
recode egg_laying_hens clutching_periods eggs_per_clutching_period (.=0)
gen eggs_produced = (egg_laying_hens * clutching_periods * eggs_per_clutching_period) // BET 05.26.21 recall period for eggs produced in 12 months
ren ls_s8_4q19 earnings_egg_sales
gen price_per_egg = earnings_egg_sales / eggs_sold

merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
keep household_id weight region zone woreda kebele ea livestock_code milk_liters_produced price_per_liter eggs_produced price_per_egg earnings_milk_products /*
	*/earnings_milk_week months_milked earnings_egg_sales liters_sold_week eggs_sold
gen price_per_unit = price_per_liter
replace price_per_unit = price_per_egg if price_per_unit==.
recode price_per_unit (0=.)
gen earnings_milk_year = earnings_milk_week*4*months_milked		//assuming 4 weeks per month
gen liters_sold_year = liters_sold_week*4*months_milked
gen earnings_egg_sales_year = earnings_egg_sales*4 // BET 05.26.21 recall period for eggs sold is 3 months.  this should be multiplied by 4
gen eggs_sold_year = eggs_sold*4 // BET 05.26.21 recall period for eggs sold is 3 months.  this should be multiplied by 4
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
ren price_per_unit price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock product in the kebele"
lab var obs_kebele "Number of sales observations for this livestock product in the kebele"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_kebele.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda livestock_code obs_woreda)
ren price_per_unit price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock product in the woreda"
lab var obs_woreda "Number of sales observations for this livestock product in the woreda"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_woreda.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone livestock_code obs_zone)
ren price_per_unit price_median_zone
lab var price_median_zone "Median price per unit for this livestock product in the zone"
lab var obs_zone "Number of sales observations for this livestock product in the zone"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_zone.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_region.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_country.dta", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_country.dta", nogen
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

collapse (sum) value_milk_produced value_eggs_produced earnings_milk_products value_livestock_products sales_livestock_products, by(household_id)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production; going to cap these at one
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 

lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var earnings_milk_products "Earnings from milk products sold (gross earnings only)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products", replace

*Sales (live animals)
use "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_w4.dta", clear
ren ls_code livestock_code
ren ls_s8_2q13 number_sold 
ren ls_s8_2q14 income_live_sales 
ren ls_s8_2q16 number_slaughtered 
ren ls_s8_2q18 income_slaughtered 
ren ls_s8_2q05 value_livestock_purchases
ren ls_s8_2q04 number_purchased 
*We can't estimate the value of animals slaughtered because we don't know the number of slaughtered animals that were sold, just the number slaughtered and the value of sales of slaughtered animals. 
*Although we might be able to estimate the value as though they were live sales.	


replace number_purchased = value_livestock_purchases if number_purchased > value_livestock_purchases 
replace number_sold = income_live_sales if number_sold > income_live_sales 
recode number_sold number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)

merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta"
drop if _merge==2
drop _merge
keep household_id weight region zone woreda kebele ea livestock_code number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal value_livestock_purchase
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", replace

*Implicit prices
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
ren price_per_animal price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock in the kebele"
lab var obs_kebele "Number of sales observations for this livestock in the kebele"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_kebele.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda livestock_code obs_woreda)
ren price_per_animal price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock in the woreda"
lab var obs_woreda "Number of sales observations for this livestock in the woreda"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_woreda.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone livestock_code obs_zone)
ren price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_zone.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_region.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_country.dta", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", clear
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_country.dta", nogen
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
collapse (sum) value_livestock_sales value_livestock_purchases value_slaughtered value_lvstck_sold, by(household_id)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricultural season, not the year)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_W4.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8)
replace tlu=0.7 if (ls_code==9)
replace tlu=0.01 if (ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.5 if (ls_code==13)
replace tlu=0.6 if (ls_code==14)
replace tlu=0.3 if (ls_code==15)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
gen lvstckid=ls_code
gen cattle=inrange(lvstckid,1,6)
gen smallrum=inrange(lvstckid,7, 8)
gen poultry=inrange(lvstckid,10,12)
gen other_ls=inlist(lvstckid,9, 13, 16)
gen cows=inrange(lvstckid,3,3)
gen chickens=inrange(lvstckid,10,12)
ren ls_s8_2q01 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
ren ls_s8_2q02 nb_ls_born 
ren ls_s8_2q04 nb_ls_purchased 
ren ls_s8_2q07 nb_ls_gifts_received 
ren ls_s8_2q09 nb_ls_gifts_given 
ren ls_s8_2q11 nb_ls_lost 
ren ls_s8_2q13 nb_ls_sold 
ren ls_s8_2q16 nb_ls_slaughtered
ren ls_s8_2q14 value_soldsum
ren ls_s8_2q05 value_purchased 

replace nb_ls_purchased = value_purchased if nb_ls_purchased > value_purchased
replace nb_ls_purchased = 0 if nb_ls_purchased >= 1000 & value_purchased ==.
replace nb_ls_gifts_received = 0 if nb_ls_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace nb_ls_born = 0 if nb_ls_born >= 1000
recode nb_ls_1yearago nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered (.=0)
replace nb_ls_slaughtered = 0 if nb_ls_slaughtered > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
replace nb_ls_sold = 0 if nb_ls_sold > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
gen nb_ls_today = nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received - nb_ls_gifts_given - nb_ls_lost - nb_ls_sold - nb_ls_slaughtered
replace nb_ls_today = 0 if nb_ls_today < 0 
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
collapse (sum) tlu_* nb_*  , by (household_id)
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_Coefficients.dta", replace 

*TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_W4.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8)
replace tlu=0.7 if (ls_code==9)
replace tlu=0.01 if (ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.5 if (ls_code==13)
replace tlu=0.6 if (ls_code==14)
replace tlu=0.3 if (ls_code==15)
lab var tlu "Tropical Livestock Unit coefficient"
ren ls_code livestock_code
ren tlu tlu_coefficient
ren ls_s8_2q01 number_1yearago
ren ls_s8_2q02 number_born 
ren ls_s8_2q04 number_purchased 
ren ls_s8_2q07 number_gifts_received 
ren ls_s8_2q09 number_gifts_given 
ren ls_s8_2q11 animals_lost12months
ren ls_s8_2q13 number_sold 
ren ls_s8_2q16 number_slaughtered
ren ls_s8_2q14 value_sold
* replace number_sold = value_sold if number_sold > value_sold /* columns seem to be switched */
ren ls_s8_2q05 value_purchased 
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
merge m:1 ls_code household_id holder_id using "$Ethiopia_ESS_W4_raw_data/sect8_1_ls_W4.dta", nogen
ren ls_code livestock_code
replace number_today = ls_s8_1q01
gen tlu_today = number_today * tlu_coefficient
egen mean_12months = rowmean(number_today number_1yearago)
ren ls_s8_1q03 number_today_exotic 
gen share_imp_herd_cows = number_today_exotic/number_today if livestock_code==3 // should this be all large ruminants or just cows?
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(inlist(livestock_code,9)) + 4*(inlist(livestock_code,10,11,12)) + 5*(inlist(livestock_code,13,14,15))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species

preserve
*Now to household level
*First, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(household_id species)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camel = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *camel *equine *poultry share_imp_herd_cows, by(household_id)
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
drop lvstck_holding animals_lost12months mean_12months
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_herd_characteristics", replace
restore

*Bee colonies not captured in TLU.
gen price_per_animal = value_sold / number_sold
recode price_per_animal (0=.)

merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_kebele.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_woreda.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_zone.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by(household_id)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU.dta", replace

********************************************************************************
*LIVESTOCK INCOME - Long format recode (HI 7.14.22)
********************************************************************************
// EXPENSES
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_w4.dta", clear // at ls_code level 
append using "$Ethiopia_ESS_W4_raw_data/sect8_3_ls_w4.dta"  // at ls_type level
append using "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_w4.dta" // at ls_code level
ren ls_s8_3q11 cost_water_livestock
ren ls_s8_3q14 cost_fodder_livestock
ren ls_s8_3q22 cost_vaccines_livestock
ren ls_s8_3q24 cost_treatment_livestock
ren ls_s8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)
replace ls_type=1 if inrange(ls_code, 1,6) & ls_type==. // assigning ls_code for obs from first appended file. File also contains obs with ls_type and without ls_code - can't assign species. -HI 7/12/22 

*Dairy costs
preserve
keep if ls_type == 1
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id ls_code)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock)
keep household_id ls_code cost_lrum
ren ls_code livestock_code
la var cost_lrum "Fodder, water, vaccines, treatment, and breeding costs for large ruminants"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_lrum_expenses_long", replace 
restore

preserve
gen species = (inlist(ls_type,1)) + 2*(inlist(ls_type,2)) + 3*(ls_type==3) + 4*(ls_type==5) + 5*(inlist(ls_type,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry" // no bees
la val species species
collapse (sum) cost_vaccines_livestock cost_treatment_livestock, by (household_id ls_code) 
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
la var ls_exp_vac "Cost for vaccines and veterinary treatment for livestock"
drop cost_vaccines_livestock cost_treatment_livestock
ren ls_code livestock_code
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_animal_long", replace
restore

collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (household_id ls_code)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
ren ls_code livestock_code
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_long", replace
*Note that costs for hired labor are not captured.

// LIVESTOCK PRODUCTS
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_w4.dta", clear

ren ls_code livestock_code 
ren ls_s8_4_q02 animals_milked
ren ls_s8_4q03 months_milked
ren ls_s8_4q04 liters_per_day 
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
ren ls_s8_4q10 earnings_milk_week
ren ls_s8_4q09 liters_sold_week 
ren ls_s8_4q12 earnings_milk_products /* Note that we can't value the milk inputs here. They'll get double-counted as income */
gen price_per_liter = earnings_milk_week / liters_sold_week

*BET 05.26.2021 egg production is reported over 12 months, but egg sales are reported over 3 months
ren ls_s8_4q16 egg_laying_hens
ren ls_s8_4q14 clutching_periods
ren ls_s8_4q15 eggs_per_clutching_period
ren ls_s8_4q18 eggs_sold
recode egg_laying_hens clutching_periods eggs_per_clutching_period (.=0)
gen eggs_produced = (egg_laying_hens * clutching_periods * eggs_per_clutching_period) // BET 05.26.21 recall period for eggs produced in 12 months
ren ls_s8_4q19 earnings_egg_sales
gen price_per_egg = earnings_egg_sales / eggs_sold

merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
keep household_id weight region zone woreda kebele ea livestock_code milk_liters_produced price_per_liter eggs_produced price_per_egg earnings_milk_products earnings_milk_week months_milked earnings_egg_sales liters_sold_week eggs_sold
/*gen price_per_unit = price_per_liter
replace price_per_unit = price_per_egg if price_per_unit==.
recode price_per_unit (0=.) */
gen earnings_milk_year = earnings_milk_week*4*months_milked	//assuming 4 weeks per month
gen liters_sold_year = liters_sold_week*4*months_milked
gen earnings_egg_sales_year = earnings_egg_sales*4 // BET 05.26.21 recall period for eggs sold is 3 months.  this should be multiplied by 4
gen eggs_sold_year = eggs_sold*4 // BET 05.26.21 recall period for eggs sold is 3 months.  this should be multiplied by 4

collapse (sum) months_milked liters_sold_week earnings_milk_week earnings_milk_products eggs_sold earnings_egg_sales milk_liters_produced eggs_produced earnings_milk_year liters_sold_year earnings_egg_sales_year eggs_sold_year (mean) price_per_liter price_per_egg, by(household_id livestock_code weight region zone woreda kebele ea) // collapsing milk/egg variables for all land holders in each household
replace months_milked = 12 if months_milked>12 // standardizing milking months within last year to 12 for households with multiple land holders who milked for a total of <12 months (HI 2.24.22)
ren milk_liters_produced produced1
ren eggs_produced produced2
ren price_per_liter price_per1
ren price_per_egg price_per2
ren earnings_milk_year earnings_year1
ren earnings_egg_sales_year earnings_year2
ren liters_sold_year sold_year1
ren eggs_sold_year sold_year2

reshape long produced price_per earnings_year sold_year, i(household_id livestock_code) j(livestock_product) //cannot collapse earnings_milk_products and earnings_egg_sales - different time frames for each. HI 3.3.22
la def livestock_product 1 "Milk" 2 "Eggs"
la val livestock_product livestock_product
replace months_milked =. if livestock_product==2 | inlist(livestock_code,1,2,4,6)  | inrange(livestock_code,9,16)
replace liters_sold_week =. if livestock_product==2 | inlist(livestock_code,1,2,4,6)  | inrange(livestock_code,9,16)
replace earnings_milk_week =. if livestock_product==2 | inlist(livestock_code,1,2,4,6)  | inrange(livestock_code,9,16)
replace earnings_milk_products =. if livestock_product==2 | inlist(livestock_code,1,2,4,6)  | inrange(livestock_code,9,16)
replace earnings_egg_sales =. if livestock_product==1 | livestock_code!=11
replace eggs_sold =. if livestock_product==1 | livestock_code!=11

ren price_per price_per_unit
lab var produced "Liters of milk or number of eggs produced in last year"
lab var earnings_year "Annual earnings from milk/eggs"
lab var sold_year "Liters of milk or number of eggs sold in last year"
lab var price_per_unit "Price per liter of milk or per egg"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda kebele livestock_code livestock_product obs_kebele)
ren price_per_unit price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock product in the kebele"
lab var obs_kebele "Number of sales observations for this livestock product in the kebele"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_kebele_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone woreda livestock_code livestock_product obs_woreda)
ren price_per_unit price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock product in the woreda"
lab var obs_woreda "Number of sales observations for this livestock product in the woreda"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_woreda_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_unit [aw=weight], by (region zone livestock_code livestock_product obs_zone)
ren price_per_unit price_median_zone
lab var price_median_zone "Median price per unit for this livestock product in the zone"
lab var obs_zone "Number of sales observations for this livestock product in the zone"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_zone_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code livestock_product obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_region_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code livestock_product obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_country_long.dta", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", clear
merge m:1 region zone woreda kebele livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_kebele_long.dta", nogen
merge m:1 region zone woreda livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_woreda_long.dta", nogen
merge m:1 region zone livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_zone_long.dta", nogen
merge m:1 region livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_region_long.dta", nogen
merge m:1 livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_country_long.dta", nogen
replace price_per_unit = price_median_kebele if price_per_unit==. & obs_kebele >= 10
replace price_per_unit = price_median_woreda if price_per_unit==. & obs_woreda >= 10
replace price_per_unit = price_median_zone if price_per_unit==. & obs_zone >= 10
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10
replace price_per_unit = price_median_country if price_per_unit==. 
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_produced = produced * price_per_unit 
gen value_sold = sold_year * price_per_unit
recode earnings_milk_products (.=0) if livestock_product==2 | inlist(livestock_code,1,2,4,6) | inrange(livestock_code,9,16)
 
ren value_produced value_livestock_products
ren value_sold sales_livestock_products

collapse (sum) value_livestock_products earnings_milk_products sales_livestock_products, by(household_id livestock_code livestock_product)
recode value_livestock_products earnings_milk_products sales_livestock_products (0=.) if livestock_product==1 & (inlist(livestock_code,1,2,4,6) | inrange(livestock_code,9,16))
recode value_livestock_products earnings_milk_products sales_livestock_products (0=.) if livestock_product==2 & (livestock_code!=11)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production; going to cap these at one. N = 463 of 737 non-zero obs. 
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 

lab var value_livestock_products "Value of milk/eggs produced"
lab var earnings_milk_products "Earnings from milk products sold (gross earnings only)"
lab var sales_livestock_products "Value of milk/eggs sold"

save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_long.dta", replace

// SALES (live animals)
use "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_w4.dta", clear
ren ls_code livestock_code
ren ls_s8_2q13 number_sold 
ren ls_s8_2q14 income_live_sales 
ren ls_s8_2q16 number_slaughtered 
ren ls_s8_2q18 income_slaughtered 
ren ls_s8_2q05 value_livestock_purchases
ren ls_s8_2q04 number_purchased 
*We can't estimate the value of animals slaughtered because we don't know the number of slaughtered animals that were sold, just the number slaughtered and the value of sales of slaughtered animals. 
*Although we might be able to estimate the value as though they were live sales.	

replace number_purchased = value_livestock_purchases if number_purchased > value_livestock_purchases 
replace number_sold = income_live_sales if number_sold > income_live_sales 
recode number_sold number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)

merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta"
drop if _merge==2
drop _merge
collapse (sum) number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal value_livestock_purchase, by(household_id weight region zone woreda kebele ea livestock_code) // collapsing income/costs across all land holders per household. 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", replace //note: long formatted live animals sales code is identical to orginal section. Copied here to retain code if wide format section is deleted eventually. HI 3.2.22  

// IMPLICIT PRICES
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda kebele livestock_code: egen obs_kebele = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda kebele livestock_code obs_kebele)
ren price_per_animal price_median_kebele
lab var price_median_kebele "Median price per unit for this livestock in the kebele"
lab var obs_kebele "Number of sales observations for this livestock in the kebele"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_kebele_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone woreda livestock_code: egen obs_woreda = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone woreda livestock_code obs_woreda)
ren price_per_animal price_median_woreda
lab var price_median_woreda "Median price per unit for this livestock in the woreda"
lab var obs_woreda "Number of sales observations for this livestock in the woreda"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_woreda_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", clear
keep if price_per_animal !=.
gen observation = 1
bys region zone livestock_code: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight], by (region zone livestock_code obs_zone)
ren price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_zone_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_region_long.dta", replace
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_country_long.dta", replace
*note: long formatted implicit prices code is identical to orginal section. Copied here to retain code if wide format section is deleted eventually. HI 3.2.22  

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", clear
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_kebele_long.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_woreda_long.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_zone_long.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_region_long.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_country_long.dta", nogen
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
collapse (sum) value_livestock_sales value_livestock_purchases value_slaughtered value_lvstck_sold, by(household_id livestock_code)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricultural season, not the year)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_sales_long", replace

// TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_W4.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8)
replace tlu=0.7 if (ls_code==9)
replace tlu=0.01 if (ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.5 if (ls_code==13)
replace tlu=0.6 if (ls_code==14)
replace tlu=0.3 if (ls_code==15)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
ren ls_s8_2q01 nb_ls_1yearago
ren ls_s8_2q02 nb_ls_born 
ren ls_s8_2q04 nb_ls_purchased 
ren ls_s8_2q07 nb_ls_gifts_received 
ren ls_s8_2q09 nb_ls_gifts_given 
ren ls_s8_2q11 nb_ls_lost 
ren ls_s8_2q13 nb_ls_sold 
ren ls_s8_2q16 nb_ls_slaughtered
ren ls_s8_2q14 value_soldsum
ren ls_s8_2q05 value_purchased 

replace nb_ls_purchased = value_purchased if nb_ls_purchased > value_purchased
replace nb_ls_purchased = 0 if nb_ls_purchased >= 1000 & value_purchased ==.
replace nb_ls_gifts_received = 0 if nb_ls_gifts_received >= 1000 /* Seem to have reported value of gifts, not number of animals */
replace nb_ls_born = 0 if nb_ls_born >= 1000
recode nb_ls_1yearago nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered (.=0)
replace nb_ls_slaughtered = 0 if nb_ls_slaughtered > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
replace nb_ls_sold = 0 if nb_ls_sold > (nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received)
gen nb_ls_today = nb_ls_1yearago + nb_ls_born + nb_ls_purchased + nb_ls_gifts_received - nb_ls_gifts_given - nb_ls_lost - nb_ls_sold - nb_ls_slaughtered
replace nb_ls_today = 0 if nb_ls_today < 0 

gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient //in long format up to this point
collapse (sum) tlu_* nb_*  , by (household_id ls_code)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient nb_ls_born nb_ls_purchased nb_ls_gifts_received nb_ls_gifts_given nb_ls_lost nb_ls_sold nb_ls_slaughtered 
rename ls_code livestock_code
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_Coefficients_long.dta", replace 

*TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W4_raw_data/sect8_2_ls_W4.dta", clear
gen tlu=0.5 if (ls_code==1|ls_code==2|ls_code==3|ls_code==4|ls_code==5|ls_code==6)
replace tlu=0.1 if (ls_code==7|ls_code==8)
replace tlu=0.7 if (ls_code==9)
replace tlu=0.01 if (ls_code==10|ls_code==11|ls_code==12)
replace tlu=0.5 if (ls_code==13)
replace tlu=0.6 if (ls_code==14)
replace tlu=0.3 if (ls_code==15)
lab var tlu "Tropical Livestock Unit coefficient"
ren ls_code livestock_code
ren tlu tlu_coefficient
ren ls_s8_2q01 number_1yearago
ren ls_s8_2q02 number_born 
ren ls_s8_2q04 number_purchased 
ren ls_s8_2q07 number_gifts_received 
ren ls_s8_2q09 number_gifts_given 
ren ls_s8_2q11 animals_lost12months
ren ls_s8_2q13 number_sold 
ren ls_s8_2q16 number_slaughtered
ren ls_s8_2q14 value_sold
* replace number_sold = value_sold if number_sold > value_sold /* columns seem to be switched */
ren ls_s8_2q05 value_purchased 
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
merge m:1 ls_code household_id holder_id using "$Ethiopia_ESS_W4_raw_data/sect8_1_ls_W4.dta", nogen
ren ls_code livestock_code
replace number_today = ls_s8_1q01
gen tlu_today = number_today * tlu_coefficient
egen mean_12months = rowmean(number_today number_1yearago)
ren ls_s8_1q03 number_today_exotic 
gen share_imp_herd_cows = number_today_exotic/number_today if livestock_code==3 // should this be all large ruminants or just cows?
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(inlist(livestock_code,9)) + 4*(inlist(livestock_code,10,11,12)) + 5*(inlist(livestock_code,13,14,15))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Camels" 4 "Equine (horses, donkies, mules)" 5 "Poultry"
la val species species

preserve
*Now to household level
*First, generating these values by livestock code
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(household_id livestock_code)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
drop number_today_exotic number_today

la var lvstck_holding "Total number of livestock holdings (# of animals)"
la var any_imp_herd "At least one improved animal in herd"
la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
lab var animals_lost12months  "Total number of livestock  lost to disease"
lab var  mean_12months  "Average number of livestock  today and 1 year ago"

*Now dropping these missing variables, which we only used to construct the labels above
drop number_1yearago
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_herd_characteristics_long.dta", replace
restore

*Bee colonies not captured in TLU.
gen price_per_animal = value_sold / number_sold
recode price_per_animal (0=.)

merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
merge m:1 region zone woreda kebele livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_kebele_long.dta", nogen
merge m:1 region zone woreda livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_woreda_long.dta", nogen
merge m:1 region zone livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_zone_long.dta", nogen
merge m:1 region livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_region_long.dta", nogen
merge m:1 livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_country_long.dta", nogen
replace price_per_animal = price_median_kebele if price_per_animal==. & obs_kebele >= 10
replace price_per_animal = price_median_woreda if price_per_animal==. & obs_woreda >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by(household_id livestock_code)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_long.dta", replace

// ALL LIVESTOCK
*Assembling individual costs into single file with all costs/associated variables by hhid, livestock_code. 
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", clear
merge 1:m household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_lrum_expenses_long", nogen // ISSUE WITH MISSING LIVESTOCK CODES. File merged in at Line 1453 has data at ls_type level, not at species level (livestock_code). 728 obs not matched by HHID and lack weight/other geographic columns, but have livestock_code and household_id. 104 obs without household/geographic data or livestock_code (just have household_id and cost_lrum) - may need to drop since other sections won't be able to be matched to these.
merge 1:m household_id livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_long", nogen // has some missing . livestock code obs
merge 1:m household_id livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales_long", nogen
merge 1:m household_id livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_sales_long", nogen
merge 1:m household_id livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_Coefficients_long.dta", nogen
merge 1:m household_id livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_herd_characteristics_long.dta", nogen 
merge 1:m household_id livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_long.dta", nogen 

*Filling in missing geographic/weight fields
foreach var in weight region zone woreda city subcity household rural {
	bysort household_id (`var'): replace `var' = `var'[1] if `var'==.
}
bysort household_id: replace kebele = kebele[1] if kebele==""
bysort household_id: replace ea = ea[1] if ea==""
gsort household_id livestock_code

*Tried building loop that operates over all geo variables...doesn't work for string variables kebele and ea.
/*
foreach var in weight region zone woreda city subcity kebele ea household rural {
	local vartype: type `var'
	if substr("`vartype'",1,3)=="str" {
		bysort household_id (`var'): replace `var' = `var'[1] if `var'==""
	} 
	else {
		bysort household_id (`var'): replace `var' = `var'[1] if `var'==.
	}
}
*/

*Prep dataset for merging livestock product data
gen livestock_product1 = 1 
gen livestock_product2 = 2
reshape long livestock_product, i(household_id livestock_code) j(lsprod_id)
drop lsprod_id
la def livestock_product 1 "Milk" 2 "Eggs"
la val livestock_product livestock_product

*Merge livestock product data
merge m:1 household_id livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products_long", nogen //livestock_code, livestock_product (2 rows per hhid/livestock_code)
merge m:1 household_id livestock_code livestock_product using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_long", nogen //livestock_code, livestock_product (2 rows per hhid/livestock_code)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_livestock.dta", replace


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
* BET 05.05.2021
use "$Ethiopia_ESS_W4_raw_data/Household/sect12b1_hh_W4.dta", clear
ren s12bq12 months_active  
* four hh operated more than 12 months
replace months_active = 12 if months_active>12  // capping months operating at 12
ren s12bq16 avg_monthly_sales
egen monthly_expenses = rowtotal(s12bq17a- s12bq17e)
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
* many biz with negative profits, more than 25% of all biz
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (household_id)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_self_employment_income.dta", replace

*Female non-farm business owners // seems like the owner is identified but 
use "$Ethiopia_ESS_W4_raw_data/Household/sect12b1_hh_W4.dta", clear
ren s12bq12 months_active  
* four hh operated more than 12 months
replace months_active = 12 if months_active>12  // capping months operating at 12
ren s12bq16 avg_monthly_sales
egen monthly_expenses = rowtotal(s12bq17a- s12bq17e)
* 671 biz with negative profits
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
local busowners "s12bq03_1 s12bq03_2"
foreach v of local busowners {
	preserve
	keep household_id `v'
	ren `v' bus_owner
	drop if bus_owner==. | bus_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `s12bq03_1', clear
foreach v of local busowners {
	if "`v'"!="`s12bq03_1'" {
		append using ``v''
	}
}
duplicates drop
gen business_owner=1 if bus_owner!=.
ren bus_owner personid
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_business_owners_ind.dta", replace


********************************************************************************
*WAGE INCOME
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Household/sect4_hh_W4.dta", clear
ren s4q34b occupation_code 
ren s4q34d industry_code 
gen mainwage_yesno=0 
replace mainwage_yesno=1 if s4q33==1 | s4q33b==1

// Note: questionnaire and data conflict on questions 38 -44 BET 05.06.2021
ren s4q37 mainwage_number_months
ren s4q38 mainwage_number_weeks
ren s4q39 mainwage_number_hours
ren s4q40 mainwage_recent_payment 
replace mainwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2		// removing ag related jobs / industry
ren s4q41 mainwage_payment_period
// no secondary job questions in W4 BET 05.06.2021
/*
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code==6 | industry_code==1 | industry_code==2
ren hh_s4q28 secwage_payment_period
*/
local vars main 
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
ren s4q47 income_psnp
recode mainwage_annual_salary  income_psnp (.=0)
gen annual_salary = mainwage_annual_salary  + income_psnp		



*Individual agwage earners
preserve
ren individual_id personid
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen
gen wage_worker = (annual_salary!=0 & annual_salary!=.)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_worker.dta", replace
restore
collapse (sum) annual_salary, by (household_id)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_income.dta", replace
*Occupation = Ag or Industry = Ag or Fisheries.

*Agwage
use "$Ethiopia_ESS_W4_raw_data/Household/sect4_hh_W4.dta", clear
ren s4q34b occupation_code 
ren s4q34d industry_code 
gen mainwage_yesno=0 
replace mainwage_yesno=1 if s4q33==1 | s4q33b==1

// Note: questionnaire and data conflict on questions 38 -44 BET 05.06.2021
ren s4q37 mainwage_number_months
ren s4q38 mainwage_number_weeks
ren s4q39 mainwage_number_hours
ren s4q40 mainwage_recent_payment 
replace mainwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
ren s4q41 mainwage_payment_period
/* secondary jobs are not asked about in questionnaire, removing BET 05.13.2021
ren hh_s4q17 mainwage_payment_period
ren hh_s4q20 secwage_yesno
ren hh_s4q24 secwage_number_months
ren hh_s4q25 secwage_number_weeks
ren hh_s4q26 secwage_number_hours
ren hh_s4q27 secwage_recent_payment
replace secwage_recent_payment = . if occupation_code!=6  & industry_code!=1 & industry_code!=2
ren hh_s4q28 secwage_payment_period
*/
local vars main
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
recode mainwage_annual_salary  (.=0)
gen annual_salary_agwage = mainwage_annual_salary 

*Individual agwage earners
preserve
ren individual_id personid
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen
gen agworker = (annual_salary_agwage!=0 & annual_salary_agwage!=.)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agworker.dta", replace
restore

collapse (sum) annual_salary_agwage, by (household_id)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Household/sect13_hh_W4_v2.dta", clear
ren s13q02 amount_received
gen transfer_income = amount_received if source_cd==101|source_cd==102|source_cd==103 /* cash, food, other in-kind transfers */
gen investment_income = amount_received if source_cd==104
gen pension_income = amount_received if source_cd==105
gen rental_income = amount_received if source_cd==106|source_cd==107|source_cd==108|source_cd==109
gen sales_income = amount_received if source_cd==110|source_cd==111|source_cd==112| source_cd==113
gen inheritance_income = amount_received if source_cd==114
recode transfer_income pension_income investment_income sales_income inheritance_income (.=0)
collapse (sum) transfer_income pension_income investment_income rental_income sales_income inheritance_income, by (household_id)
lab var transfer_income "Estimated income from cash, food, or other in-kind gifts/transfers over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months"
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var sales_income "Estimated income from sales of real estate or other assets over previous 12 months"
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var inheritance_income "Estimated income from cinheritance over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_other_income.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Household/sect14_hh_W4.dta", clear
* BET 05.13.2021  W4 makes the distinction between cash, inkind, or food transfers 
rename assistance_cd assistance_code
rename s14q03 cash_received
rename s14q05 foodvalue_received
rename s14q06 inkind_received
recode cash_received foodvalue_received inkind_received (.=0)
gen amount_received =  cash_received + foodvalue_received + inkind_received

gen psnp_income = amount_received if assistance_code==1			
gen assistance_income = amount_received if assistance_code==2|assistance_code==3 

collapse (sum) psnp_income assistance_income, by (household_id)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_assistance_income.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", clear
ren s2q15a land_rental_income_cash
ren s2q15b land_rental_income_inkind
ren s2q15c land_rental_income_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
collapse (sum) land_rental_income_upfront, by (household_id)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rental_income.dta", replace


/*DYA.10.26.2020 OLD
********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W4_raw_data}/Household/sect4_hh_W4.dta", clear
ren hh_s4q10_b occupation_code 
ren hh_s4q11_b industry_code 
gen primary_hours = hh_s4q15 if occupation_code!=6 | industry_code!=1 | industry_code!=2
gen secondary_hours = hh_s4q26 if occupation_code!=6 | industry_code!=1 | industry_code!=2
*Instrument doesn't ask about the number of hours worked for own business or PSNP
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(household_id)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_off_farm_hours.dta", replace
*/


/*DYA.10.26.2020 NEW*/ // UPDATED BY BET 05.14.2021 and 6.10.2021
********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W4_raw_data}/Household/sect4_hh_W4.dta", clear
// BET 05.14.2021 questionnaire and dta files differ in question numbers / text
// W4 questionnaire askes about wage hours in two places Q13 and Q39, using question attached to main job over last 12 months
gen  hrs_main_wage_off_farm=s4q39 if (s4q34d>2 & s4q34d!=.)		// s4q34d 1 to 2 is agriculture  (exclude mining)  //DYA.10.26.2020  I think this is limited to only 
// no secondary wage is asked in W4 gen  hrs_sec_wage_off_farm= hh_s4q26 if (hh_s4q21_b>2 & hh_s4q21_b!=.)		// hh_e21_2 1 to 2 is agriculture  
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm) 
gen  hrs_main_wage_on_farm=s4q39 if (s4q34d<=2 & s4q34d!=.)		 
// no secondary wage is asked in W4 gen  hrs_sec_wage_on_farm= hh_s4q26 if (hh_s4q21_b<=2 & hh_s4q21_b!=.)	 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm) 
drop *main* 
ren s4q15 hrs_unpaid_off_farm
recode  s4q03a s4q03b s4q04a s4q04b (.=0)
replace  s4q03a = 12 if  s4q03a>12 
replace  s4q04a = 12 if  s4q04a>12 
gen hrs_domest_fire_fuel=(s4q03a+ s4q03b/60+s4q04a+s4q04b/60)*7  // hours worked just yesterday
replace hrs_domest_fire_fuel = 168 if hrs_domest_fire_fuel>168
ren  s4q06 hrs_ag_activ
ren  s4q09 hrs_self_off_farm
egen hrs_off_farm=rowtotal(hrs_wage_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
egen hrs_domest_all=rowtotal(hrs_domest_fire_fuel)
egen hrs_other_all=rowtotal(hrs_unpaid_off_farm)

foreach v of varlist hrs_* {
	local l`v'=subinstr("`v'", "hrs", "nworker",.)
	gen  `l`v''=`v'!=0
} 
gen member_count = 1
collapse (sum) nworker_* hrs_*  member_count, by(household_id)
la var member_count "Number of HH members age 7 or above"
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_off_farm_hours.dta", replace



********************************************************************************
*FARM LABOR
********************************************************************************
*Farm labor
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q30a number_men
ren s3q30b number_days_men
ren s3q30d number_women
ren s3q30e number_days_women
ren s3q30g number_children
ren s3q30h number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postplant =  days_men + days_women + days_children
ren days_men days_hired_male_postplant
ren days_women days_hired_female_postplant
ren s3q29b weeks_1 
ren s3q29c days_week_1 
ren s3q29f weeks_2
ren s3q29g days_week_2
ren s3q29j weeks_3
ren s3q29k days_week_3
ren s3q29n weeks_4
ren s3q29o days_week_4
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postplant = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
ren s3q31a number_men_other
ren s3q31b days_men_other
ren s3q31c number_women_other
ren s3q31d days_women_other
ren s3q31e number_child_other
ren s3q31f days_child_other
recode number_men_other days_men_other number_women_other days_women_other number_child_other days_child_other (.=0)
gen days_otherlabor_postplant = (number_men_other * days_men_other) + (number_women_other * days_women_other) + (number_child_other * days_child_other)

*Labor productivity at the plot level 
collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_male_postplant days_hired_female_postplant, by (holder_id household_id parcel_id field_id)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_farmlabor_postplanting.dta", replace
collapse (sum) days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_male_postplant days_hired_female_postplant, by (household_id)
lab var days_famlabor_postplant "Workdays for family labor (crops), as captured in post-planting survey"
lab var days_hired_postplant "Workdays for hired labor (crops), as captured in post-planting survey"
lab var days_otherlabor_postplant "Workdays for other labor (crops), as captured in post-planting survey"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmlabor_postplanting.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect10_ph_W4.dta", clear
ren s10q01a number_men
ren s10q01b number_days_men
ren s10q01d number_women
ren s10q01e number_days_women
ren s10q01g number_children
ren s10q01h number_days_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
recode days_men days_women days_children (.=0)
gen days_hired_postharvest =  days_men + days_women + days_children
ren days_men days_hired_male_postharvest
ren days_women days_hired_female_postharvest
ren s10q02b weeks_1 
ren s10q02c days_week_1 
ren s10q02f weeks_2
ren s10q02g days_week_2
ren s10q02j weeks_3
ren s10q02k days_week_3
ren s10q02n weeks_4
ren s10q02o days_week_4
recode weeks_1 days_week_1 weeks_2 days_week_2 weeks_3 days_week_3 weeks_4 days_week_4 (.=0)
gen days_famlabor_postharvest = (weeks_1 * days_week_1) + (weeks_2 * days_week_2) + (weeks_3 * days_week_3) + (weeks_4 * days_week_4)
ren s10q03a number_men_other
ren s10q03b days_men_other
ren s10q03c number_women_other
ren s10q03d days_women_other
ren s10q03e number_child_other
ren s10q03f days_child_other
recode number_men_other days_men_other number_women_other days_women_other number_child_other days_child_other (.=0)
gen days_otherlabor_postharvest = (number_men_other * days_men_other) + (number_women_other * days_women_other) + (number_child_other * days_child_other)

*Labor productivity at the plot level 
collapse (sum) days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest days_hired_male_postharvest days_hired_female_postharvest, by (holder_id household_id parcel_id field_id)
lab var days_hired_postharvest "Workdays for hired labor (crops), as captured in post-harvest survey"
lab var days_famlabor_postharvest "Workdays for family labor (crops), as captured in post-harvest survey"
lab var days_otherlabor_postharvest "Workdays for other labor (crops), as captured in post-harvest survey"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_farmlabor_postharvest.dta", replace

*Labor productivity at the plot level = total labor
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_farmlabor_postplanting.dta"
egen labor_hired =rowtotal(days_hired_postharvest days_hired_postplant)
egen labor_family = rowtotal(days_famlabor_postharvest days_famlabor_postplant)
egen labor_other =  rowtotal(days_otherlabor_postharvest days_otherlabor_postplant) 
egen labor_total = rowtotal(days_famlabor_postharvest days_famlabor_postplant days_otherlabor_postharvest days_otherlabor_postplant days_hired_postharvest days_hired_postplant)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
collapse (sum) labor_*, by (household_id parcel_id field_id holder_id) 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by (household_id)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_other "Total labor days (other/gang/communal) allocated to the farm in the past year"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmlabor_all.dta", replace


********************************************************************************
*FARM SIZE
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect9_ph_W4.dta", clear
*All parcels here (which are subdivided into fields) were cultivated, whether in the belg or meher season.
gen cultivated=1

*Including area of permanent crops
preserve
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
gen cultivated = 1 if (s4q19!=0 & s4q19!=.) 		// not including any harvest because not separated out for tree crops in ETH (KEF:???)
collapse (max) cultivated, by (household_id parcel_id field_id)
tempfile tree
save `tree', replace
restore
append using `tree'
collapse (max) cultivated, by (household_id parcel_id field_id)
lab var cultivated "1= Field was cultivated in this data set"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcels_cultivated.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q02a area 
ren s3q02b local_unit 
ren s3q08 area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
replace area_sqmeters_gps=. if area_sqmeters_gps==0  		
keep household_id parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region zone local_unit)
ren sqmeters_per_unit sqmeters_per_unit_zone 
ren observations obs_zone
lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", replace
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q02a area 
ren s3q02b local_unit 
ren s3q08 area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (region local_unit)
ren sqmeters_per_unit sqmeters_per_unit_region
ren observations obs_region
lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", replace
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q02a area 
ren s3q02b local_unit 
ren s3q08 area_sqmeters_gps 
replace area_sqmeters_gps=. if area_sqmeters_gps<0
keep household_id parcel_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta"
drop if _merge==2
drop _merge
gen sqmeters_per_unit = area_sqmeters_gps/area
gen observations = 1
collapse (median) sqmeters_per_unit (count) observations [aw=weight], by (local_unit)
ren sqmeters_per_unit sqmeters_per_unit_country
ren observations obs_country
lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
ren s3q02a area 
ren s3q02b local_unit 
ren s3q08 area_sqmeters_gps
replace area_sqmeters_gps=. if area_sqmeters_gps<0
replace area_sqmeters_gps=. if area_sqmeters_gps==0			
keep household_id parcel_id holder_id field_id area local_unit area_sqmeters_gps
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
//DYA: 8.10.2021
//KEF: problem here that local area unit uses bytes instead of strings for zones and woredas. Created string version in the created data folder.
preserve
use "$Ethiopia_ESS_W4_raw_data/Land Area Conversion Factor/ET_local_area_unit_conversion.dta", clear
destring region zone woreda, replace
tempfile ET_local_area_unit_conversion
save `ET_local_area_unit_conversion'
restore
merge m:1 region zone woreda local_unit using `ET_local_area_unit_conversion', nogen keep(1 3)  
gen area_est_hectares = area if local_unit==1
replace area_est_hectares = (area/10000) if local_unit==2
replace area_est_hectares = (area*conversion/10000) if (local_unit!=1 & local_unit!=2 & local_unit!=11)
merge m:1 region zone local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", nogen
replace area_est_hectares = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & area_est_hectares==. & obs_zone>=10
merge m:1 region local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", nogen
replace area_est_hectares = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & area_est_hectares==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", nogen
replace area_est_hectares = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & area_est_hectares==.
gen area_meas_hectares = (area_sqmeters_gps/10000)
replace area_meas_hectares = area_est_hectares if area_meas_hectares==.
count if area!=. & area_meas_hectares==.
replace area_meas_hectares = 0 if area_meas_hectares == .
lab var area_meas_hectares "Area measured in hectares, with missing obs imputed using local median per-unit values"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_sizes.dta", replace
merge m:1 household_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) area_meas_hectares, by (household_id)
ren area_meas_hectares farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_size.dta", replace


*All Agricultural Land
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
gen agland = (s3q03==1 | s3q03==2 | s3q03==3 | s3q03==5) // Cultivated, prepared for Belg season, pasture, or fallow. Excludes forest and "other" (which seems to include rented-out)

*Including area of permanent crops
preserve
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
gen cultivated = 1 if (s4q19!=0 & s4q19!=.)		 //not including any harvest because not separated out for tree crops in ETH
collapse (max) cultivated, by (household_id parcel_id field_id)
tempfile tree
save `tree', replace
restore
append using `tree'
merge m:1 household_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcels_cultivated.dta", nogen keep(1 3)
replace agland=1 if cultivated==1
keep if agland==1
keep household_id parcel_id field_id holder_id agland
lab var agland "1= Plot was used for cultivated, pasture, or fallow"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcels_agland.dta", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_sizes.dta", clear
merge 1:1 household_id parcel_id holder_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcels_agland.dta"
drop if _merge==1
collapse (sum) area_meas_hectares, by (household_id)
ren area_meas_hectares farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmsize_all_agland.dta", replace

/*KEF: Not sure why the following is excluded.
Rented In/Borrow/Other not own 
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_sizes.dta", clear
collapse (sum) area_meas_hectares, by( holder_id household_id parcel_id parcel_id)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcel_area.dta",replace 
*/

use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", clear
gen rented_in = (s2q05==3 | s2q05==6)
gen plot_not_owned = (s2q05==3 | s2q05==4 | s2q05==5 | s2q05==6 ) 
gen plot_owned = (s2q05==1 | s2q05==2 | s2q05==7 | s2q05==8) //KEF: should we include 8 (Other) here?  It doesn't necessarily mean owned.
gen rented_out = (s2q13==1 | s2q13==2 | s2q13==3) //KEF: In W4 they expanded the responses here from Yes/No to include 1 (Yes, all in all rent)  2 (Yes, all in all share) and 3 (Yes, all free). 
*keep if pp_s2q01b==1 //KEF: got rid of this "Is this parcel still owned or rented in by the holder" since this is the first survey for this sample. 
collapse (max) rented_in rented_out plot_not_owned plot_owned, by (holder_id household_id parcel_id)
preserve 
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcels_agland.dta", clear
collapse (max) agland, by (holder_id household_id parcel_id) 
tempfile agland
save `agland', replace	
restore 
merge 1:1 holder_id household_id parcel_id using `agland', nogen 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_ownership.dta", replace
merge 1:1 holder_id household_id parcel_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcel_area.dta", nogen keep (3) //KEF: Somewhere in these two lines, rented_out suddenly loses all of its 516 affirmative values. Which results in an error in line 1905. In line 1892, rented_out still has values. 
gen not_own_area  = area_meas_hectares if plot_not_owned==1
gen rent_out_area = area_meas_hectares if rented_out==1 
collapse (sum) not_own_area rent_out_area area_meas_hectares (max) rented_in plot_not_owned plot_owned rented_out agland, by (household_id)
gen prop_area_not_own = not_own_area/area_meas_hectares
gen prop_area_rent = rent_out_area/area_meas_hectares
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_plot_ownership.dta", replace

merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", keep (3)
gen only_unown = (plot_not_owned==1 & plot_owned==0) 
tabstat only_unown [aw=weight]
*tabstat prop_area_not_own [aw=weight] if plot_not_owned==1 //KEF: Error here, no observations.
gen only_rent_out = (rented_out==1 & (agland==0 |plot_not_owned==1) ) 
tabstat only_rent_out rented_out [aw=weight]
*tabstat prop_area_rent [aw=weight] if rented_out==1
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", clear


********************************************************************************
*LAND SIZE
********************************************************************************
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_sizes.dta", clear
collapse (sum) area_meas_hectares, by (household_id)
ren area_meas_hectares land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)" /* Uses measures */
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_size_all.dta", replace


********************************************************************************
* VACCINE USAGE *
********************************************************************************
* UPDATED BY BT 05.14.2021
use "$Ethiopia_ESS_W4_raw_data/sect8_3_ls_w4.dta", clear
gen vac_animal=.
replace vac_animal=1 if ls_s8_3q18==1
replace vac_animal=0 if ls_s8_3q18==2
replace vac_animal=. if ls_s8_3q18==.
*Disagregating vaccine use by animal type
ren ls_type livestock_code
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
collapse (max) vac_animal*, by (household_id)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_camels "`l`i'' - camels"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_vaccine.dta", replace

*Vaccine use livestock keeper (holder)
use "$Ethiopia_ESS_W4_raw_data/sect8_3_ls_w4.dta", clear
ren saq09 farmerid 

gen all_vac_animal=.
replace all_vac_animal=1 if ls_s8_3q18==1
replace all_vac_animal=0 if ls_s8_3q18==2
replace all_vac_animal=. if ls_s8_3q18==.
collapse (max) all_vac_animal , by(household_id farmerid)
gen personid=farmerid 
drop if personid==.
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)	
keep household_id personid	holder_id all_vac 	female
gen female_vac_animal=all_vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
gen livestock_keeper=1 if personid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
**cannot construct in this instrument



********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************

use "$Ethiopia_ESS_W4_raw_data/sect8_3_ls_w4.dta", clear
// data labels do not indicate which question corresponds to rainy vs dry season. assuming that _1 "Feed 1" corresponds to the dry and _2 "Feed 2" corresponds to the rainy, based on questionnaire order BET 05.14.2021
gen feed_grazing_dry = (ls_s8_3q12_1==1 | ls_s8_3q12_1==2)
gen feed_grazing_rainy = (ls_s8_3q12_2==1 | ls_s8_3q12_2==2)
lab var feed_grazing_dry "1=HH feeds only or mainly by grazing in the dry season"
lab var feed_grazing_rainy "1=HH feeds only or mainly by grazing in the rainy season"
gen feed_grazing = (feed_grazing_dry==1 & feed_grazing_rainy==1)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat_dry = (ls_s8_3q09_1 == 4 )
gen water_source_nat_rainy = (ls_s8_3q09_2 == 4 )
gen water_source_const_dry = (ls_s8_3q09_1 == 1 | ls_s8_3q09_1 == 2 | ls_s8_3q09_1 == 3 | ls_s8_3q09_1 == 5)
gen water_source_const_rainy = (ls_s8_3q09_2 == 1 | ls_s8_3q09_2 == 2 | ls_s8_3q09_2 == 3 | ls_s8_3q09_2 == 5)
gen water_source_cover_dry = (ls_s8_3q09_1 == 1 )
gen water_source_cover_rainy = (ls_s8_3q09_2 == 1 )
gen water_source_nat = (water_source_nat_dry==1 | water_source_nat_rainy==1)
gen water_source_const = (water_source_const_dry==1 | water_source_const_rainy==1)
gen water_source_cover = (water_source_cover_dry==1 | water_source_cover_rainy==1) 
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
gen lvstck_housed = (ls_s8_3q07==2 | ls_s8_3q07==3 | ls_s8_3q07==4 | ls_s8_3q07==5 | ls_s8_3q07==6 )
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
ren ls_type livestock_code
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
collapse (max) feed_grazing* water_source* lvstck_housed*, by (household_id)
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_feed_water_house.dta", replace


********************************************************************************
* INORGANIC FERTILIZER USE *
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
gen use_inorg_fert=0
replace use_inorg_fert=1 if s3q21==1 | s3q22==1 | s3q23==1 | s3q24==1
replace use_inorg_fert=0 if s3q21==2 & s3q22==2 & s3q23==2 & s3q24==2
replace use_inorg_fert=. if s3q21==. & s3q22==. & s3q23==. & s3q24==.
collapse (max) use_inorg_fert, by (household_id)
lab var use_inorg_fert "1= Household uses inorganic fertilizer"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
gen all_use_inorg_fert=0
replace all_use_inorg_fert=1 if s3q21==1 | s3q22==1 | s3q23==1 | s3q24==1
replace all_use_inorg_fert=0 if s3q21==2 & s3q22==2 & s3q23==2 & s3q24==2
replace all_use_inorg_fert=. if s3q21==. & s3q22==. & s3q23==. & s3q24==.
ren saq09 farmerid //KEF Why do these holder_ids range so high? i.e. it skips from 82 to 100, for example.
collapse (max) all_use_inorg_fert , by(household_id farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)
keep household_id personid all_use_inorg_fert female			
gen female_use_inorg_fert = all_use_inorg_fert if female==1 
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if personid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_fert_use.dta", replace


********************************************************************************
* IMPROVED SEED USE *
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
gen imprv_seed_use=.
replace imprv_seed_use=1 if s4q11==2 | s4q11==3 | s4q11==4 //KEF: W4 has more disaggregation for "improved", including Improved/New, Improved/Recycled, and Improved/Leftover. However, the numbering of this disaggregation in Stata is different than how it is listed in the instrument, so these may not line up correctly.
replace imprv_seed_use=0 if s4q11==1
replace imprv_seed_use=. if s4q11==.
ren s4q01b crop_code
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area	
	local cn: word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
	gen hybrid_seed_`cn'=.		//instrument doesn't ask about hybrid seeds KEF: need to check if this is true
}
collapse (max) imprv_seed_* hybrid_seed_*, by(household_id)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	lab var imprv_seed_`cn' "1= Household uses improved `cnfull' seed"
	lab var hybrid_seed_`cn' "1= Household uses hybrid `cnfull' seed"
}
lab var imprv_seed_use "1= Household uses improved seed"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_improvedseed_use.dta", replace

*Seed adoption by farmers (a farmer is an individual listed as plot manager)
*KEF: The following is Andrew's new code for this section, to avoid challenges with "wide" data encoding. 
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
ren s4q01b crop_code
gen all_imprv_seed_use = (s4q11==2 | s4q11==3 | s4q11==4) //KEF: Same issue as in line 2084. Andrew recommended to change this to imprv_seed_use since it makes things below slightly easier, however all other sections used this nomenclature so decided to keep the "all" in there. 
replace all_imprv_seed_use=. if s4q11==.
gen all_hybrid_seed_use=. //KEF: Doesn't ask about hybrid seeds, but want to avoid a missing variable error later in the summary stats.
ren saq09 personid
gen farm_manager=1
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen keep(1 3)
recode farm_manager (.=0)
//First part
preserve
	collapse (max) all_imprv_seed_use all_hybrid_seed_use farm_manager, by(household_id personid female) //This takes care of dropping extraneous variables. If we want hybrid seed use to be in here, it should be consistent and include it throughout to increase code portability as well in case hybrid seeds are added in later versions.
	gen female_imprv_seed_use = all_imprv_seed_use==1 if female==1 
	gen female_hybrid_seed_use = all_hybrid_seed_use==1 if female==1
	gen male_imprv_seed_use = all_imprv_seed_use==1 if female==0
	gen male_hybrid_seed_use = all_hybrid_seed_use==1 if female==0
	lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
	lab var male_imprv_seed_use "1 = Individual male farmers (plot manager) uses improved seeds"
	lab var female_imprv_seed_use "1 = Individual female farmers (plot manager) uses improved seeds"
	lab var farm_manager "1 = Individual is listed as a manager for at least one plot"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use.dta", replace
restore

//Now for monocropped plots
ren all_imprv_seed_use all_imprv_seed_ //Since "use" in the same file with `cn' implies that "use" is a member of the top crops.
ren all_hybrid_seed_use all_hybrid_seed_
collapse (max) all_imprv_seed_ all_hybrid_seed_, by(household_id personid farm_manager female crop_code) 
gen farmer_ = 1
gen crop=""
forvalues k=1(1)$nb_topcrops {
    local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	replace crop = "`cn'" if crop_code==`c'
}
/*We could use this to code additional crops, but we need abbreviations for them because the existing labels/names are too verbose.
decode crop_code, g(crops) //If we don't have an official abbr
replace crop=crops if crop==""
drop crops*/ 
drop crop_code
drop if crop==""
//ALT: This is where I would stop
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(household_id personid farm_manager female) j(crop) string //Now we have all crops, not just the BMGF ones. //KEF error here, option i not allowed
	ren farmer_* *_farmer // Andrew suggested to switch these around, not best practice.
	recode *_farmer (.=0)
	lab var farm_manager "1 = Individual is listed as a manager for at least one plot"

forvalues k=1(1)$nb_topcrops {
    local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_ull
preserve	
	keep *`cn'* household_id personid farm_manager female
	gen female_imprv_seed_`cn'=all_imprv_seed_`cn' if female==1
	gen male_imprv_seed_`cn' = all_imprv_seed_`cn' if female==0
	recode male* female* (.=0)
	lab var all_imprv_seed_`cn' "1 = Individual farmer (plot manager) uses improved `cnfull' seeds"
	lab var male_imprv_seed_`cn' "1 = Individual male farmers (plot manager) uses improved `cnfull' seeds"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use_`cn'.dta", replace
restore // This should run much more quickly than the old code because we're minimizing the repeat operations. 
}

/* Old code
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
gen all_imprv_seed_use = (s4q11==2 | s4q11==3 | s4q11==4) //KEF: Same issue as in line 2084. Andrew recommended to change this to imprv_seed_use since it makes things below slightly easier, however all other sections used this nomenclature so decided to keep the "all" in there. 
replace all_imprv_seed_use=. if s4q11==.
ren saq09 farmerid
collapse (max) all_imprv_seed_use, by(household_id farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
//drop household_id- s1q05 saq09- f_merge KEF: error here, this just drops everything. Replacing with the line below.
keep farmerid all_imprv_seed_use female household_id
gen female_imprv_seed_use=all_imprv_seed_use if female==1
gen male_imprv_seed_use=all_imprv_seed_use if female==0
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
lab var male_imprv_seed_use "1 = Individual male farmers (plot manager) uses improved seeds"
lab var female_imprv_seed_use "1 = Individual female farmers (plot manager) uses improved seeds"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use.dta", replace

use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
gen all_imprv_seed_use=.
replace all_imprv_seed_use=1 if s4q11==2 | s4q11==3 | s4q11==4 //KEF: Same issue as in line 2084.
replace all_imprv_seed_use=0 if s4q11==1
replace all_imprv_seed_use=. if s4q11==.
ren s4q01b crop_code
forvalues k=1(1)$nb_topcrops {
	local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	preserve
	gen all_imprv_seed_`cn'=all_imprv_seed_use if crop_code==`c'
	gen all_hybrid_seed_`cn'=.		//Doesn't ask about hybrid seeds
	ren saq09 farmerid
	gen `cn'_farmer= crop_code==`c' 
	collapse (max) all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer, by(household_id farmerid)
	gen personid=farmerid
	drop if personid==.
	merge m:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
	// drop household_id- pp_s1q05 ph_saq07- f_merge KEF: Presuming error here again. Replacing with line below.
	keep all_imprv_seed_`cn' farmerid female household_id
	gen female_imprv_seed_`cn'=all_imprv_seed_`cn' if female==1
	gen male_imprv_seed_`cn'=all_imprv_seed_`cn' if female==0
	lab var all_imprv_seed_`cn' "1 = Individual farmer (plot manager) uses improved `cnfull' seeds"
	lab var male_imprv_seed_`cn' "1 = Individual male farmers (plot manager) uses improved `cnfull' seeds"
	lab var female_imprv_seed_`cn' "1 = Individual female farmers (plot manager) uses improved `cnfull' seeds"
	gen farm_manager=1 if farmerid!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use_`cn'.dta", replace
	restore
}

*/



********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
*BET 05.05.21
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect7_pp_W4.dta", nogen
gen ext_reach_all=0
replace ext_reach_all=1 if s3q16==1 | s7q04==1 | s7q09==1

*Source of extension is not asked; source of seed is not asked, but source of fertilizer is asked (govt is answer) CHECK 
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
collapse (max) ext_reach*, by (household_id)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources" 
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_any_ext.dta", replace


********************************************************************************
* MOBILE OWNERSHIP*
********************************************************************************
*BET 05.04.21
use "${Ethiopia_ESS_W4_raw_data}/Household/sect10a_hh_w4.dta", clear
recode s10aq41 (.=0)
gen mobile_owned=s10aq41==1
preserve

use "${Ethiopia_ESS_W4_raw_data}/Household/sect11b1_hh_w4.dta", clear
recode s11b_ind_01 s11b_ind_02 (.=0) 
gen mobile_owned=s11b_ind_01==1 
gen idv_number_mobile_owned = s11b_ind_02
replace mobile_owned=1 if idv_number_mobile_owned>0
tempfile num_mobile 
save `num_mobile'

restore
append using `num_mobile'

collapse (max) mobile_owned, by(household_id)
keep household_id mobile_owned
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_2018_mobile_own", replace


********************************************************************************
* FORMAL FINANCIAL SERVICES USE *
********************************************************************************
* BET 05.05.21 - CHECK CONFIRM THAT USE QUESTIONS SHOULD MERGE IN ANY QUESTION ABOUT USE OF ACCOUNTS 
use "$Ethiopia_ESS_W4_raw_data/Household/sect5a_hh_W4.dta", clear
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect5b1_hh_W4.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect5b2_hh_W4.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect11b2_hh_W4.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect12b1_hh_W4.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect13_hh_W4_v2.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect4_hh_W4.dta", nogen
merge m:m household_id using "$Ethiopia_ESS_W4_raw_data/Household/sect15b_hh_W4.dta", nogen
gen borrow_bank = s15q02b==9 | s12bq07_1 ==6 | s12bq07_2 == 6  
gen borrow_micro =  s12bq07_1 ==9 | s12bq07_2 == 9 | s15q02b == 7  // other uses s5aq06__3==1 | s5aq11__3==1 | (s5bq01 == 1 & asset_type ==3) |
gen borrow_mortgage = .
gen borrow_insurance = .
gen borrow_other_fin = . 
gen borrow_neigh = s12bq07_1 ==7 | s12bq07_2 == 7 | s15q02b == 1 | s15q02b ==2
gen borrow_merch = .
gen borrow_lender = s12bq07_1 ==8 | s12bq07_2 ==8 | s15q02b==4
gen borrow_employer = s15q02b==5
gen borrow_relig = s15q02b==6
gen borrow_ngo = s15q02b ==9 
gen borrow_group =(s5bq01 == 1 & asset_type ==4) | s15q02b ==10  // other uses of group  s5aq13__3==1 | s5aq11__4==1 | s5aq06__4==1 | 
gen borrow_other = (s5bq01 == 1 & asset_type ==5) | s12bq07_1 ==10 | s12bq07_2 == 10 | s15q02b ==11
gen use_bank_acount = s5aq06__1==1|  s5aq06__2==1 | s13q05 ==2 | s4q42==2 | s5aq11__1==1 | s5aq11__2==1 | (s5bq01 == 1 & asset_type ==1) | (s5bq01 == 1 & asset_type ==2) | s12bq07_1==6 | s12bq07_2==6
gen use_MM = s5bq07b==1 | s5bq07b==2 | s11b_ind_07==1	| s13q05 ==3 | s4q42==4	// counting "online banking" and "mobile banking"
* Credit, Saving, Insurance, Bank account, Digital
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit = borrow_mortgage==1 | borrow_bank==1 
gen use_fin_serv_insur = s5aq18==1 
gen use_fin_serv_digital = use_MM==1
gen use_fin_serv_savings = s5aq11__1 ==1 | s5aq11__2 ==1 | s5aq11__3==1 |  s5aq11__4 ==1 
gen use_fin_serv_all = use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 | borrow_other_fin==1 | use_fin_serv_savings==1
	
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (household_id)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"		
lab var use_fin_serv_savings "1= Household uses formal financial services - savings" 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fin_serv.dta", replace


********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
* BET 05.14.2021
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_w4.dta", clear
gen cows = ls_code==3
keep if cows
gen milk_animals = ls_s8_4_q02			// number of livestock milked (by holder) in last year
gen months_milked = ls_s8_4q03			// average months milked in last year (by holder)
gen liters_day = ls_s8_4q04				// average quantity (liters) per day per cow
gen liters_per_cow = (liters_day*365*(months_milked/12))	// liters per day times 365 (for yearly total) times milk animals to get TOTAL across all animals times months milked over 12 to scale down to actual amount
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_cow "average quantity (liters) per year (household)"
collapse (sum) milk_animals liters_per_cow, by(household_id)
keep if milk_animals!=0
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
* BET 05.14.2021
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_w4.dta", clear
gen clutching_periods = ls_s8_4q14		// number of clutching periods per hen in last 12 months
gen eggs_clutch = ls_s8_4q15			// number of eggs per clutch
gen hen_total = ls_s8_4q16				// total laying hens
gen eggs_total_year = clutching_periods*eggs_clutch*hen_total		// total eggs in last 12 months (clutches per hen times eggs per clutch times number of hens)
collapse (sum) eggs_total_year hen_total, by(household_id)
keep if hen_total!=0
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var hen_total "Total number of laying hens"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_eggs_animals.dta", replace



********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
//KEF 7.15.21
*Land rental rates
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", clear
//drop if pp_s2q01b==2	KEF: Getting rid of this line (parcel no longer owned or rented) since this is the first wave in the new survey stream.
ren s2q15a land_rental_income_cash
ren s2q15b land_rental_income_inkind
ren s2q15c land_rental_income_share
ren s2q10a rental_cost_cash
ren s2q10b rental_cost_inkind
ren s2q10c rental_cost_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
gen rented_plot = (s2q05==3)
*Need to merge in value harvested here
merge 1:1 household_id holder_id parcel_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_parcel.dta", nogen keep(1 3) 
*Now merging in area of PARCEL (the area this dataset is at); "land_size" is area variable
merge 1:1 holder_id parcel_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcel_area.dta", nogen keep(1 3)
replace rental_cost_cash = rental_cost_share if rental_cost_share>100 & rental_cost_share!=. /* KEF: Just a gut check from the last code, this wave doesn't seem to have any accidental switches between the columns. 0 changes. */
replace rental_cost_share = 0 if rental_cost_share>100 & rental_cost_share!=.
gen rental_cost_sharecrop = value_crop_production * (rental_cost_share/100)
recode rental_cost_cash rental_cost_inkind rental_cost_sharecrop (.=0)
gen rental_cost_land = rental_cost_cash + rental_cost_inkind + rental_cost_sharecrop
*Saving at parcel level with rental costs
preserve
keep rental_cost_land holder_id parcel_id 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_parcel.dta", replace
restore
gen any_rent = rented_plot!=0 & rented_plot!=.
gen plot_rental_rate = rental_cost_land/land_size							// at the parcel level; rent divided by rented acres (birr per ha)
recode plot_rental_rate (0=.)												// we don't want to count zeros as valid observations
gen area_meas_hectares_parcel_rental = land_size if rented_plot==1

*Getting a household-level "average" rental rate
bys household_id: egen plot_rental_total = total(rental_cost_land)
bys household_id: egen plot_rental_total_area = total(area_meas_hectares_parcel_rental)
gen hh_rental_rate = plot_rental_total/plot_rental_total_area				// total divided by area for birr per ha for households that paid any
recode hh_rental_rate (0=.)					

*Creating geographic medians
*By EA
bys saq01 saq02 saq03 saq06 saq07: egen ha_rental_count_ea = count(plot_rental_rate)	//KEF: saq04 and saq05 are City and Sub-City codes. These are Region, Zone, Woreda, Kebele, and EA codes respectively.	
bys saq01 saq02 saq03 saq06 saq07: egen ha_rental_price_ea = median(plot_rental_rate)
*By kebele
bys saq01 saq02 saq03 saq06: egen ha_rental_count_keb = count(plot_rental_rate)
bys saq01 saq02 saq03 saq06: egen ha_rental_price_keb = median(plot_rental_rate)
*By woreda
bys saq01 saq02 saq03: egen ha_rental_count_wor = count(plot_rental_rate)
bys saq01 saq02 saq03: egen ha_rental_price_wor = median(plot_rental_rate)
*By zone
bys saq01 saq02: egen ha_rental_count_zone = count(plot_rental_rate)
bys saq01 saq02: egen ha_rental_price_zone = median(plot_rental_rate)
*By region
bys saq01: egen ha_rental_count_reg = count(plot_rental_rate)
bys saq01: egen ha_rental_price_reg = median(plot_rental_rate)
*National
egen ha_rental_price_nat = median(plot_rental_rate)
*Generating rental rate per hectare
gen ha_rental_rate = hh_rental_rate			// using household value when available
replace ha_rental_rate = ha_rental_price_ea if ha_rental_count_ea>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_keb if ha_rental_count_keb>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_wor if ha_rental_count_wor>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_zone if ha_rental_count_zone>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_reg if ha_rental_count_reg>=10 & ha_rental_rate==.
replace ha_rental_rate = ha_rental_price_nat if ha_rental_rate==.
collapse (sum) land_rental_income_upfront (firstnm) ha_rental_rate, by(household_id)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
lab var ha_rental_rate "Household's `average' rental rate per hectare"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_rate.dta", replace

*Land value - rented land
*Starting at field area
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area", clear
*Merging in gender
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
*Merging in rental costs paid
merge m:1 holder_id parcel_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_parcel.dta", nogen	
*Merging in parcel area ("land_size")
merge m:1 household_id holder_id parcel_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcel_area.dta", nogen
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
	merge 1:1 household_id parcel_id field_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen value_rented_land_`cn' = value_rented_land
	gen value_rented_land_`cn'_male = value_rented_land_male
	gen value_rented_land_`cn'_female = value_rented_land_female
	gen value_rented_land_`cn'_mixed = value_rented_land_mixed
	collapse (sum) value_rented_land_`cn'*, by(household_id)
	lab var value_rented_land_`cn' "Value of rented land (household expenditures) - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_male "Value of rented land (household expenditures) for male-managed plots - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_female "Value of rented land (household expenditures) for female-managed plots - `cnfull' monocropped plots only"
	lab var value_rented_land_`cn'_mixed "Value of rented land (household expenditures) for mixed-managed plots - `cnfull' monocropped plots only"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_value_`cn'.dta", replace
	restore
}
collapse (sum) value_rented_*, by(household_id)				// total rental costs at the household level
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures) for male-managed plots"
lab var value_rented_land_female "Value of rented land (household expenditures) for female-managed plots"
lab var value_rented_land_mixed "Value of rented land (household expenditures) for mixed-managed plots"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_value.dta", replace

*Value of area planted
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_W4.dta", clear
gen pure_stand = s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = s4q03/100
replace percent_field = 1 if pure_stand==1
*Merging in area
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area", nogen keep(1 3)	
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
*KEF: 0 not matched from master, 5,967 from using
*16,913 matched
*NOTE: we will create ha_planted here but we won't save it in the datafile. We had to construct ha_planted above 
*for use in the crop production do-file, but we needed the crop production data for value. Therefore, we have to
*construct area_planted and value separately
/*
gen area_plan = percent_field*area_meas_hectares
gen area_plan_male = percent_field*area_meas_hectares if dm_gender==1
gen area_plan_female = percent_field*area_meas_hectares if dm_gender==2
gen area_plan_mixed = percent_field*area_meas_hectares if dm_gender==3
gen area_plan_pure = percent_field*area_meas_hectares if any_pure==1
gen area_plan_inter = percent_field*area_meas_hectares if any_mixed==1
gen area_plan_pure_male = percent_field*area_meas_hectares if dm_gender==1 & any_pure==1
gen area_plan_pure_female = percent_field*area_meas_hectares if dm_gender==2 & any_pure==1
gen area_plan_pure_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_pure==1
gen area_plan_inter_male = percent_field*area_meas_hectares if dm_gender==1 & any_mixed==1
gen area_plan_inter_female = percent_field*area_meas_hectares if dm_gender==2 & any_mixed==1
gen area_plan_inter_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_mixed==1
*/
gen ha_planted = percent_field*area_meas_hectares  // AYW 12.10.19
gen ha_planted_male = percent_field*area_meas_hectares if dm_gender==1
gen ha_planted_female = percent_field*area_meas_hectares if dm_gender==2
gen ha_planted_mixed = percent_field*area_meas_hectares if dm_gender==3
gen ha_planted_purestand = percent_field*area_meas_hectares if any_pure==1
gen ha_planted_mixedstand = percent_field*area_meas_hectares if any_mixed==1
gen ha_planted_male_pure = percent_field*area_meas_hectares if dm_gender==1 & any_pure==1
gen ha_planted_female_pure = percent_field*area_meas_hectares if dm_gender==2 & any_pure==1
gen ha_planted_mixed_pure = percent_field*area_meas_hectares if dm_gender==3 & any_pure==1
gen ha_planted_male_mixed = percent_field*area_meas_hectares if dm_gender==1 & any_mixed==1
gen ha_planted_female_mixed = percent_field*area_meas_hectares if dm_gender==2 & any_mixed==1
gen ha_planted_mixed_mixed = percent_field*area_meas_hectares if dm_gender==3 & any_mixed==1

*Merging in sect2 for rental variables
merge m:1 holder_id parcel_id using "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", gen(sect2_merge) keep(1 3)		// 173 not matched from master
*Merging in rental rate
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_rate.dta", nogen keep(1 3) keepusing(ha_rental_rate)
*Value of all OWNED (that is, not rented) land
/*
gen value_owned_land = ha_rental_rate*area_plan if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)	// cash AND in kind AND share must be zero or missing
gen value_owned_land_male = ha_rental_rate*area_plan_male if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_female = ha_rental_rate*area_plan_female if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
gen value_owned_land_mixed = ha_rental_rate*area_plan_mixed if (pp_s2q07_a==. | pp_s2q07_a==0) & (pp_s2q07_b==. | pp_s2q07_b==0) & (pp_s2q07_c==. | pp_s2q07_c==0)
*/
gen value_owned_land = ha_rental_rate*ha_planted if (s2q10a==. | s2q10a==0) & (s2q10b==. | s2q10b==0) & (s2q10c==. | s2q10c==0)	// cash AND in kind AND share must be zero or missing
gen value_owned_land_male = ha_rental_rate*ha_planted_male if (s2q10a==. | s2q10a==0) & (s2q10b==. | s2q10b==0) & (s2q10c==. | s2q10c==0)
gen value_owned_land_female = ha_rental_rate*ha_planted_female if (s2q10a==. | s2q10a==0) & (s2q10b==. | s2q10b==0) & (s2q10c==. | s2q10c==0)
gen value_owned_land_mixed = ha_rental_rate*ha_planted_mixed if (s2q10a==. | s2q10a==0) & (s2q10b==. | s2q10b==0) & (s2q10c==. | s2q10c==0)
ren s4q01b crop_code
*collapse (sum) value_owned_land*, by(household_id)
collapse (sum) value_owned_land* ha_planted*, by(household_id)  // AYW 12.10.19
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land that was cultivated (male-managed)"
lab var value_owned_land_female "Value of owned land that was cultivated (female-managed)"
lab var value_owned_land_mixed "Value of owned land that was cultivated (mixed-managed)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_land.dta", replace

*Post planting expenses - implicit and explicit
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
*Fertilizer expenses (EXPLICIT)
ren s3q21d value_urea
ren s3q22d value_DAP
ren s3q23d value_NPS
ren s3q24d value_other_chemicals // All other "inorganic fertilizer"
encode value_urea, generate(value_urea2)
ren value_urea value_urea_old
ren value_urea2 value_urea
egen value_fert = rowtotal(value_urea value_DAP value_NPS value_other_chemicals) 
*Hired Labor
ren s3q30a number_men
ren s3q30b number_days_men
ren s3q30c wage_perday_men
ren s3q30d number_women
ren s3q30e number_days_women
ren s3q30f wage_perday_women
ren s3q30g number_children
ren s3q30h number_days_children
ren s3q30i wage_perday_children
gen wage_male = wage_perday_men/number_men				// wage per day for a single man
gen wage_female = wage_perday_women/number_women		// wage per day for a single woman
gen wage_child = wage_perday_child/number_children					// wage per day for a single child
recode wage_male wage_female wage_child (0=.)		// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
*Getting household-level wage rate by taking a simple mean across crops and activities
preserve
	recode wage_male number_days_men wage_female number_days_women (.=0) // set missing to zero to count observation with no male hired labor or with no female hired labor
	gen all_wage = (wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)	// weighted average at the HOUSEHOLD level
	recode wage_male number_days_men wage_female number_days_women (0=.) 
	* get average wage accross all plots and crops to obtain wage at household level by  activities
	ren saq14 rural
	collapse (mean) wage_male wage_female all_wage,by(rural saq01 saq02 saq03 saq06 saq07 household_id)		
	lab var all_wage "Daily agricultural wage (local currency)"
	lab var wage_male "Daily male agricultural wage (local currency)"
	lab var wage_female "Daily female agricultural wage (local currency)"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_eth_labor_group1", replace
restore
*Geographic medians of wages
foreach i in male female child{			// constructing for male, female, and child separately
	recode wage_`i' (0=.)
	*By EA
	bys saq01 saq02 saq03 saq06 saq07: egen `i'_count_ea = count(wage_`i')		// ea
	bys saq01 saq02 saq03 saq06 saq07: egen `i'_price_ea = median(wage_`i')
	*By kebele
	bys saq01 saq02 saq03 saq06: egen `i'_count_keb = count(wage_`i')			// kebele
	bys saq01 saq02 saq03 saq06: egen `i'_price_keb = median(wage_`i')
	*By woreda
	bys saq01 saq02 saq03: egen `i'_count_wor = count(wage_`i')					// woreda
	bys saq01 saq02 saq03: egen `i'_price_wor = median(wage_`i')
	*By zone
	bys saq01 saq02: egen `i'_count_zone = count(wage_`i')						// zoner
	bys saq01 saq02: egen `i'_price_zone = median(wage_`i')
	*By region
	bys saq01: egen `i'_count_reg = count(wage_`i')								// region
	bys saq01: egen `i'_price_reg = median(wage_`i')
	*National
	egen `i'_price_nat = median(wage_`i')
	*Generating wage
	gen `i'_wage_rate = `i'_price_ea if `i'_count_ea>=10			// by counstruction, there are no missing counts
	replace `i'_wage_rate = `i'_price_keb if `i'_count_keb>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_wor if `i'_count_wor>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_reg if `i'_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}
*Value of hired labor (EXPLICIT)
gen value_male_hired = wage_perday_men*number_days_men			// average wage times number of days
gen value_female_hired = wage_perday_women*number_days_women
gen value_child_hired = wage_perday_children*number_days_children
*Days of hired labor
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_pp =  rowtotal(days_men days_women days_children)
*Value of family labor (IMPLICIT)
preserve
*To do family labor, we first need to merge in individual gender
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect1_pp_W4.dta", clear
ren s1q00 pid
drop if pid==.
isid holder_id pid				// check 
ren s1q02 age
gen male = s1q03==1
keep holder_id pid age male
tempfile members
save `members', replace			// will use this temp file to merge in genders (and ages)
restore
*Starting with "member 1"
gen pid = s3q29a				// PID for member 1
merge m:1 holder_id pid using `members', gen(fam_merge1) keep(1 3)		// many not matched from master 
tab s3q29a fam_merge1, m											// most are due to household id=0 or missing in MASTER (0 means nobody engaged)
count if fam_merge1==1 & s3q29c!=. & s3q29c!=0					// just 30 observations
ren male male1		// renaming in order to merge again
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = s3q29e				// PID for member 2
merge m:1 holder_id pid using `members', gen(fam_merge2) keep(1 3)		// many not matched from master 
ren male male2		// renaming in order to merge again
ren pid pid12
ren age age2
*Now "member 3"
gen pid = s3q29i				// PID for member 3
merge m:1 holder_id pid using `members', gen(fam_merge3) keep(1 3)		// many not matched from master 
ren male male3		// renaming in order to merge again
ren pid pid13
ren age age3
*Now "member 4"
gen pid = s3q29m				// PID for member 4
merge m:1 holder_id pid using `members', gen(fam_merge4) keep(1 3)		// many not matched from master 
ren male male4		// renaming in order to merge again
ren pid pid14
ren age age4
recode male1 male2 male3 male4 (.=1)			// NOTE: Assuming male if missing (there are a couple dozen)
gen male_fam_days1 = s3q29b*s3q29c if male1 & age1>=15		// if male and older than 15 or age is missing; NOTE: Assuming missing ages are adults
gen male_fam_days2 = s3q29f*s3q29g if male2 & age2>=15
gen male_fam_days3 = s3q29j*s3q29k if male3 & age3>=15
gen male_fam_days4 = s3q29n*s3q29o if male4 & age4>=15
gen female_fam_days1 = s3q29b*s3q29c if !male1 & age1>=15	//  NOTE: Assuming missing ages are adults
gen female_fam_days2 = s3q29f*s3q29g if !male2 & age2>=15
gen female_fam_days3 = s3q29j*s3q29k if !male3 & age3>=15
gen female_fam_days4 = s3q29n*s3q29o if !male4 & age4>=15
gen child_fam_days1 = s3q29b*s3q29c if age1<15
gen child_fam_days2 = s3q29f*s3q29g if age2<15
gen child_fam_days3 = s3q29j*s3q29k if age3<15
gen child_fam_days4 = s3q29n*s3q29o if age4<15
egen total_male_fam_days = rowtotal(male_fam_days*)					// total male family days
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)
*"Free" labor days (IMPLICIT)
recode s3q31* (.=0)
gen total_male_free_days = s3q31a*s3q31b
gen total_female_free_days = s3q31c*s3q31d
gen total_child_free_days = s3q31e*s3q31f
*Here are the total non-hired days (family plus free)
egen total_male_nonhired_days = rowtotal(total_male_fam_days total_male_free_days)		// family days plus "free" labor
egen total_female_nonhired_days = rowtotal(total_female_fam_days total_female_free_days)
egen total_child_nonhired_days = rowtotal(total_child_fam_days total_child_free_days)
egen days_nonhired_pp = rowtotal(total_male_nonhired_days total_female_nonhired_days total_child_nonhired_days)	
*And here are the total costs using geographically constructed wage rates
gen value_male_nonhired = total_male_nonhired_days*male_wage_rate
gen value_female_nonhired = total_female_nonhired_days*female_wage_rate
gen value_child_nonhired = total_child_nonhired_days*child_wage_rate
*Replacing with own wage rate where available
*First, getting wage at the HOUSEHOLD level	
bys household_id: egen male_wage_tot = total(value_male_hired)			
bys household_id: egen male_days_tot = total(number_days_men)			
bys household_id: egen female_wage_tot = total(value_female_hired)		
bys household_id: egen female_days_tot = total(number_days_women)		
bys household_id: egen child_wage_tot = total(value_child_hired)		
bys household_id: egen child_days_tot = total(number_days_children)	
gen wage_male_hh = male_wage_tot/male_days_tot					
gen wage_female_hh = female_wage_tot/female_days_tot			
gen wage_child_hh = child_wage_tot/child_days_tot				
recode wage_*_hh (0=.)											
sum wage_*_hh			// no zeros
*Now, replacing when household-level wage not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.
egen value_hired_prep_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_prep_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)
*Generating gender variables 
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
*Fertilizer value
gen value_fert_male = value_fert if dm_gender==1
gen value_fert_female = value_fert if dm_gender==2
gen value_fert_mixed = value_fert if dm_gender==3
*Hired labor
gen value_hired_prep_labor_male = value_hired_prep_labor if dm_gender==1
gen value_hired_prep_labor_female = value_hired_prep_labor if dm_gender==2
gen value_hired_prep_labor_mixed = value_hired_prep_labor if dm_gender==3
gen days_hired_pp_male = days_hired_pp if dm_gender==1
gen days_hired_pp_female = days_hired_pp if dm_gender==2
gen days_hired_pp_mixed = days_hired_pp if dm_gender==3
*Hired labor expenses for top crops
foreach cn in $topcropname_area {
	preserve
	merge 1:1 household_id parcel_id field_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen val_hire_prep_`cn' = value_hired_prep_labor
	gen val_hire_prep_`cn'_male = value_hired_prep_labor_male
	gen val_hire_prep_`cn'_female = value_hired_prep_labor_female
	gen val_hire_prep_`cn'_mixed = value_hired_prep_labor_mixed
	collapse (sum) val_hire_prep_`cn'*, by(household_id)
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_pp_inputs_value_`cn'.dta", replace
	restore
}
*Family labor
gen value_fam_prep_labor_male = value_fam_prep_labor if dm_gender==1
gen value_fam_prep_labor_female = value_fam_prep_labor if dm_gender==2
gen value_fam_prep_labor_mixed = value_fam_prep_labor if dm_gender==3
gen days_nonhired_pp_male = days_nonhired_pp if dm_gender==1
gen days_nonhired_pp_female = days_nonhired_pp if dm_gender==2
gen days_nonhired_pp_mixed = days_nonhired_pp if dm_gender==3
*Collapsing to household-level input costs (explicit - value hired prep labor and value fert; implicit - value fam prep labor)
collapse (sum) value_hired* value_fam* value_fert* days_hired_pp* days_nonhired*, by(household_id)
lab var value_hired_prep_labor "Wages paid for hired labor (crops), as captured in post-planting survey"
sum value_*
lab var value_hired_prep_labor "Value of all pre-harvest hired labor used on the farm"
lab var value_hired_prep_labor_male "Value of all pre-harvest hired labor used on male-managed plots"
lab var value_hired_prep_labor_female "Value of all pre-harvest hired labor used on female-managed plots"
lab var value_hired_prep_labor_mixed "Value of all pre-harvest hired labor used on mixed-managed plots"
lab var value_fam_prep_labor "Value of all pre-harvest non-hired labor used on the farm"
lab var value_fam_prep_labor_male "Value of all pre-harvest non-hired labor used on male-managed plots"
lab var value_fam_prep_labor_female "Value of all pre-harvest non-hired labor used on female-managed plots"
lab var value_fam_prep_labor_mixed "Value of all pre-harvest non-hired labor used on mixed-managed plots"
lab var value_fert "Value of all fertilizer used on the farm"
lab var value_fert_male "Value of all fertilizer used on male-managed plots"
lab var value_fert_female "Value of all fertilizer used on female-managed plots"
lab var value_fert_mixed "Value of all fertilizer used on mixed-managed plots"
lab var days_hired_pp "Days of pre-harvest hired labor used on farm"
lab var days_hired_pp_male "Days of pre-harvest hired labor used on male_managed-plots"
lab var days_hired_pp_female "Days of pre-harvest hired labor used on female_managed-plots"
lab var days_hired_pp_mixed "Days of pre-harvest hired labor used on mixed_managed-plots"
lab var days_nonhired_pp "Days of pre-harvest non-hired labor used on farm"
lab var days_nonhired_pp_male "Days of pre-harvest non-hired labor used on male_managed-plots"
lab var days_nonhired_pp_female "Days of pre-harvest non-hired labor used on female_managed-plots"
lab var days_nonhired_pp_mixed "Days of pre-harvest non-hired labor used on mixed_managed-plots"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_pp_inputs_value.dta", replace

*Harvest labor costs
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect10_ph_W4.dta", clear		
*Hired labor (EXPLICIT)
ren s10q01a number_men
ren s10q01b number_days_men
ren s10q01c wage_perday_men
ren s10q01d number_women
ren s10q01e number_days_women
ren s10q01f wage_perday_women
ren s10q01g number_children
ren s10q01h number_days_children
ren s10q01i wage_perday_children
gen wage_male = wage_perday_men/number_men							// wage per day for a single man
gen wage_female = wage_perday_women/number_women					// wage per day for a single woman
gen wage_child = wage_perday_child/number_children					// wage per day for a single child
recode wage_male wage_female wage_child (0=.)						// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
preserve
recode wage_male number_days_men wage_female number_days_women (.=0) 			// set missing to zero to count observation with no male hired labor or with no female hired labor
gen all_wage=(wage_male*number_days_men + wage_female*number_days_women)/(number_days_men + number_days_women)
recode wage_male number_days_men wage_female number_days_women (0=.) 
* get average wage accross all plots and crops to obtain wage at household level by  activities
ren saq14 rural
collapse (mean) wage_male wage_female all_wage, by(rural saq01 saq02 saq03 saq06 saq07 household_id)
lab var all_wage "Daily agricultural wage (local currency)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_eth_labor_group2", replace
restore
gen value_male_hired = number_days_men * wage_perday_men
gen value_female_hired = number_days_women * wage_perday_women 
gen value_child_hired = number_days_children * wage_perday_children
gen days_men = number_men * number_days_men 
gen days_women = number_women * number_days_women  
gen days_children = number_children * number_days_children 
egen days_hired_harv =  rowtotal(days_men days_women days_children)
*Geographic medians
foreach i in male female child{
	recode wage_`i' (0=.)
	*By EA
	bys saq01 saq02 saq03 saq06 saq07: egen `i'_count_ea = count(wage_`i')
	bys saq01 saq02 saq03 saq06 saq07: egen `i'_price_ea = median(wage_`i')
	*By kebele
	bys saq01 saq02 saq03 saq06: egen `i'_count_keb = count(wage_`i')
	bys saq01 saq02 saq03 saq06: egen `i'_price_keb = median(wage_`i')
	*By woreda
	bys saq01 saq02 saq03: egen `i'_count_wor = count(wage_`i')
	bys saq01 saq02 saq03: egen `i'_price_wor = median(wage_`i')
	*By zone
	bys saq01 saq02: egen `i'_count_zone = count(wage_`i')
	bys saq01 saq02: egen `i'_price_zone = median(wage_`i')
	*By region
	bys saq01: egen `i'_count_reg = count(wage_`i')
	bys saq01: egen `i'_price_reg = median(wage_`i')
	*National
	egen `i'_price_nat = median(wage_`i')
	*Generating wage
	gen `i'_wage_rate = `i'_price_ea if `i'_count_ea>=10
	replace `i'_wage_rate = `i'_price_keb if `i'_count_keb>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_wor if `i'_count_wor>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_zone if `i'_count_zone>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_reg if `i'_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_price_nat if `i'_wage_rate==.
}
*To do family labor, we first need to merge in individual gender
preserve
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect1_ph_W4.dta", clear
ren s1q00 pid
drop if pid==.
isid holder_id pid				// check 
ren s1q02 age
gen male = s1q03==1
keep holder_id pid age male
tempfile members
save `members', replace
restore
*Starting with "member 1"
gen pid = s10q02a
merge m:1 holder_id pid using `members', gen(fam_merge1) keep(1 3)		// many not matched from master 
tab s10q02a fam_merge1, m											// most are due to household id=0 or missing in MASTER (0 means nobody engaged)
count if fam_merge==1 & s10q02c!=0 & s10q02c!=.					// just 17 observations with positive days that were not merged.
ren male male1
ren pid pid1 
ren age age1
*Now "member 2"
gen pid = s10q02e
merge m:1 holder_id pid using `members', gen(fam_merge2) keep(1 3)		// many not matched from master 
ren male male2
ren pid pid12
ren age age2
*Now "member 3"
gen pid = s10q02i
merge m:1 holder_id pid using `members', gen(fam_merge3) keep(1 3)		// many not matched from master 
ren male male3
ren pid pid13
ren age age3
*Now "member 4"
gen pid = s10q02m
merge m:1 holder_id pid using `members', gen(fam_merge4) keep(1 3)		// many not matched from master 
ren male male4
ren pid pid14
ren age age4
*Family labor (IMPLICIT)
recode male1 male2 male3 male4 (.=1)									// NOTE: Assuming male if missing (there are only a couple in post-harvest)
gen male_fam_days1 = s10q02b*s10q02c if male1 & age1>=15		// NOTE: Assuming missing ages are adults
gen male_fam_days2 = s10q02f*s10q02g if male2 & age2>=15
gen male_fam_days3 = s10q02j*s10q02k if male3 & age3>=15
gen male_fam_days4 = s10q02n*s10q02o if male4 & age4>=15
gen female_fam_days1 = s10q02b*s10q02c if !male1 & age1>=15
gen female_fam_days2 = s10q02f*s10q02g if !male2 & age2>=15
gen female_fam_days3 = s10q02j*s10q02k if !male3 & age3>=15
gen female_fam_days4 = s10q02n*s10q02o if !male4 & age4>=15
gen child_fam_days1 = s10q02b*s10q02c if age1<15
gen child_fam_days2 = s10q02f*s10q02g if age2<15
gen child_fam_days3 = s10q02j*s10q02k if age3<15
gen child_fam_days4 = s10q02n*s10q02o if age4<15
egen total_male_fam_days = rowtotal(male_fam_days*)				
egen total_female_fam_days = rowtotal(female_fam_days*)
egen total_child_fam_days = rowtotal(child_fam_days*)
*Also including "free" labor as priced (IMPLICIT)
recode s10q03* (.=0)
gen total_male_free_days = s10q03a*s10q03b
gen total_female_free_days = s10q03c*s10q03d
gen total_child_free_days = s10q03e*s10q03f
*Here are the total days
egen total_male_nonhired_days = rowtotal(total_male_fam_days total_male_free_days)		// family days plus "free" labor
egen total_female_nonhired_days = rowtotal(total_female_fam_days total_female_free_days)
egen total_child_nonhired_days = rowtotal(total_child_fam_days total_child_free_days)
egen days_nonhired_harv = rowtotal(total_male_nonhired_days total_female_nonhired_days total_child_nonhired_days)	
*And here are the total costs using geographically constructed wage rates
gen value_male_nonhired = total_male_nonhired_days*male_wage_rate
gen value_female_nonhired = total_female_nonhired_days*female_wage_rate
gen value_child_nonhired = total_child_nonhired_days*child_wage_rate
*Replacing with own wage rate where available
*First, creating household average wage
bys household_id: egen male_wage_tot = total(value_male_hired)	
bys household_id: egen male_days_tot = total(number_days_men)		
bys household_id: egen female_wage_tot = total(value_female_hired)		
bys household_id: egen female_days_tot = total(number_days_women)				
bys household_id: egen child_wage_tot = total(value_child_hired)		
bys household_id: egen child_days_tot = total(number_days_children)				
gen wage_male_hh = male_wage_tot/male_days_tot					
gen wage_female_hh = female_wage_tot/female_days_tot			
gen wage_child_hh = child_wage_tot/child_days_tot				
recode wage_*_hh (0=.)											
sum wage_*_hh			// no zeros
*Now, replacing when not missing
replace value_male_nonhired = total_male_nonhired_days*wage_male_hh if wage_male_hh!=.
replace value_female_nonhired = total_female_nonhired_days*wage_female_hh if wage_female_hh!=.
replace value_child_nonhired = total_child_nonhired_days*wage_child_hh if wage_child_hh!=.
egen value_hired_harv_labor = rowtotal(value_male_hired value_female_hired value_child_hired)
egen value_fam_harv_labor = rowtotal(value_male_nonhired value_female_nonhired value_child_nonhired)		// note that "fam" labor includes free labor
*Generating gender variables 
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
gen value_hired_harv_labor_male = value_hired_harv_labor if dm_gender==1
gen value_hired_harv_labor_female = value_hired_harv_labor if dm_gender==2
gen value_hired_harv_labor_mixed = value_hired_harv_labor if dm_gender==3
gen days_hired_harv_male = days_hired_harv if dm_gender==1
gen days_hired_harv_female = days_hired_harv if dm_gender==2
gen days_hired_harv_mixed = days_hired_harv if dm_gender==3
gen value_fam_harv_labor_male = value_fam_harv_labor if dm_gender==1
gen value_fam_harv_labor_female = value_fam_harv_labor if dm_gender==2
gen value_fam_harv_labor_mixed = value_fam_harv_labor if dm_gender==3
gen days_nonhired_harv_male = days_nonhired_harv if dm_gender==1
gen days_nonhired_harv_female = days_nonhired_harv if dm_gender==2
gen days_nonhired_harv_mixed = days_nonhired_harv if dm_gender==3
*Harvest labor costs for top crops
foreach cn in $topcropname_area {
	preserve
	collapse (sum) value_hired_harv_labor*, by(household_id parcel_id field_id holder_id)
	merge 1:1 household_id parcel_id field_id holder_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)	
	gen val_hire_harv_`cn' = value_hired_harv_labor
	gen val_hire_harv_`cn'_male = value_hired_harv_labor_male
	gen val_hire_harv_`cn'_female = value_hired_harv_labor_female
	gen val_hire_harv_`cn'_mixed = value_hired_harv_labor_mixed
	collapse (sum) val_hire_harv_`cn'*, by(household_id)
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_harv_labor_`cn'.dta", replace
	restore
}
collapse (sum) value_hired* days_hired* value_fam* days_nonhired*, by(household_id)
sum value_*
lab var value_hired_harv_labor "Value of all harvest hired labor used on the farm"
lab var value_hired_harv_labor_male "Value of all harvest hired labor used on male-managed plots"
lab var value_hired_harv_labor_female "Value of all harvest hired labor used on female-managed plots"
lab var value_hired_harv_labor_mixed "Value of all harvest hired labor used on mixed-managed plots"
lab var value_fam_harv_labor "Value of all harvest non-hired labor used on the farm"
lab var value_fam_harv_labor_male "Value of all harvest non-hired labor used on male-managed plots"
lab var value_fam_harv_labor_female "Value of all harvest non-hired labor used on female-managed plots"
lab var value_fam_harv_labor_mixed "Value of all harvest non-hired labor used on mixed-managed plots"
lab var days_hired_harv "Days of harvest hired labor used on farm"
lab var days_hired_harv_male "Days of harvest hired labor used on male_managed-plots"
lab var days_hired_harv_female "Days of harvest hired labor used on female_managed-plots"
lab var days_hired_harv_mixed "Days of harvest hired labor used on mixed_managed-plots"
lab var days_nonhired_harv "Days of harvest non-hired labor used on farm"
lab var days_nonhired_harv_male "Days of harvest non-hired labor used on male_managed-plots"
lab var days_nonhired_harv_female "Days of harvest non-hired labor used on female_managed-plots"
lab var days_nonhired_harv_mixed "Days of harvest non-hired labor used on mixed_managed-plots"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_harv_labor.dta", replace

*Cost of seeds
*Purchased, free, and left-over seeds are all seeds used (see question 19 in section 5)
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect5_pp_W4.dta", clear
recode s5q04 s5q13 s5q17 (.=0)
*gen kg_seed_purchased = pp_s5q05_a + pp_s5q05_b/1000		// kg + g/1000 KEF: Unnecessary because already in kg. 
gen kg_seed_purchased = s5q04
gen seed_value = s5q07
ren s5q06 value_transport_purchased_seed
ren s5q15 value_transport_free_seed
gen kg_seed_free = s5q13
gen kg_seed_own = s5q17
*Seed not purchased
egen kg_seed_not_purchased = rowtotal(kg_seed_free kg_seed_own)
*Constructing prices
gen seed_price_hh = seed_value/kg_seed_purchased			// value per kg
recode seed_price_hh (0=.)									// don't want to count zero as a "valid" price observation
*Geographic medians
ren s5q0B crop_code //KEF: This is really the "seed code", but the data doesn't have a separate crop_code as a var.
bys crop_code saq01 saq02 saq03 saq06 saq07: egen seed_count_ea = count(seed_price_hh)		
bys crop_code saq01 saq02 saq03 saq06 saq07: egen seed_price_ea = median(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq06: egen seed_count_keb = count(seed_price_hh)
bys crop_code saq01 saq02 saq03 saq06: egen seed_price_keb = median(seed_price_hh)
bys crop_code saq01 saq02 saq03: egen seed_count_wor = count(seed_price_hh)
bys crop_code saq01 saq02 saq03: egen seed_price_wor = median(seed_price_hh)
bys crop_code saq01 saq02: egen seed_count_zone = count(seed_price_hh)
bys crop_code saq01 saq02: egen seed_price_zone = median(seed_price_hh)
bys crop_code saq01: egen seed_count_reg = count(seed_price_hh)
bys crop_code saq01: egen seed_price_reg = median(seed_price_hh)
bys crop_code: egen seed_price_nat = median(seed_price_hh)
*A lot will be at higher levels of aggregation (region and national) due to lack of observations for many crops
gen seed_price = seed_price_ea if seed_count_ea>=10							
replace seed_price = seed_price_keb if seed_count_keb>=10 & seed_price==.	
replace seed_price = seed_price_wor if seed_count_wor>=10 & seed_price==.	
replace seed_price = seed_price_zone if seed_count_zone>=10 & seed_price==.	
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.						
gen value_purchased_seed = seed_value
gen value_non_purchased_seed = seed_price*kg_seed_not_purchased
*Now, replacing with household price when available
*First, constructing "price" at the household level
bys household_id crop_code: egen seed_value_hh = total(seed_value)						// summing total value of seed to household
bys household_id crop_code: egen kg_seed_purchased_hh = total(kg_seed_purchased)		// summing total value of seed purchased to household
gen seed_price_hh_non = seed_value_hh/kg_seed_purchased_hh
*Now, replacing when household price is not missing
replace value_non_purchased_seed = (seed_price_hh_non)*kg_seed_not_purchased if seed_price_hh_non!=. & seed_price_hh_non!=0
*NOTE: We cannot appropriately value seeds by gender because seed module is at the holder-crop level, not field level.
collapse (sum) value_purchased_seed value_non_purchased_seed value_transport*, by(household_id)		
lab var value_purchased_seed "Value of purchased seed"
lab var value_transport_purchased_seed "Cost of transport for purchased seed"
lab var value_transport_free_seed "Cost of transport for free seed"
lab var value_purchased_seed "Value of seed purchased (household)"
lab var value_non_purchased_seed "Value of seed not purchased (household)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_seed.dta", replace


********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Ethiopia_ESS_W4_raw_data}/Post-Planting/sect3_pp_W4.dta", clear
append using "${Ethiopia_ESS_W4_raw_data}/Post-Harvest/sect10_ph_W4.dta"
*Hired Labor post-planting
ren s3q30a number_men_pp
ren s3q30b number_days_men_pp
ren s3q30c wage_perday_men_pp
ren s3q30d number_women_pp
ren s3q30e number_days_women_pp
ren s3q30f wage_perday_women_pp
ren s3q30g number_child_pp
ren s3q30h number_days_child_pp
ren s3q30i wage_perday_child_pp
*Hired labor post-harvest
ren s10q01a number_men_ph
ren s10q01b number_days_men_ph
ren s10q01c wage_perday_men_ph
ren s10q01d number_women_ph
ren s10q01e number_days_women_ph
ren s10q01f wage_perday_women_ph
ren s10q01g number_child_ph
ren s10q01h number_days_child_ph
ren s10q01i wage_perday_child_ph
collapse (sum) wage* number*, by(household_id)
gen wage_male_pp = wage_perday_men_pp/number_men_pp						// wage per day for a single man
gen wage_female_pp = wage_perday_women_pp/number_women_pp				// wage per day for a single woman
gen wage_child_pp = wage_perday_child_pp/number_child_pp				// wage per day for a single child
recode wage_male_pp wage_female_pp wage_child_pp number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
gen wage_male_ph = wage_perday_men_ph/number_men_ph						// wage per day for a single man
gen wage_female_ph = wage_perday_women_ph/number_women_ph				// wage per day for a single woman
gen wage_child_ph = wage_perday_child_ph/number_child_ph				// wage per day for a single child
recode wage_male_ph wage_female_ph wage_child_ph number* (.=0)			// if they are "hired" but don't get paid, we don't want to consider that a wage observation below
*getting weighted average across group of activities to get wage paid at HH level
gen wage_paid_aglabor = (wage_male_pp*number_men_pp+wage_female_pp*number_women_pp+wage_child_pp*number_child_pp+wage_male_ph*number_men_ph+wage_female_ph*number_women_ph+wage_child_ph*number_child_ph)/(number_men_pp+number_women_pp+number_child_pp+number_men_ph+number_women_ph+number_child_ph)
gen wage_paid_aglabor_male = (wage_male_pp*number_men_pp+wage_male_ph*number_men_ph)/(number_men_pp+number_men_ph)
gen wage_paid_aglabor_female = (wage_female_pp*number_women_pp+wage_female_ph*number_women_ph)/(number_women_pp+number_women_ph)
keep household_id wage_paid_aglabor*
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for female hired labor (local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for male hired labor (local currency)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_wage.dta", replace 


********************************************************************************
* FERTILIZER APPLICATION (KG)
********************************************************************************
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
*Merging in gender
merge m:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen
*For fertilizer 
*Identify outliers (AYW 12.10.19)
encode s3q21d, generate (s3q21d_new)
ren s3q21d s3q21d_old
ren s3q21d_new s3q21d
gen price_per_kg_urea = s3q21d / s3q21c
egen price_urea_med = median(price_per_kg_urea) if price_per_kg_urea != .
gen absdev_urea_median = abs(price_per_kg_urea - price_urea_med)
egen median_absdev_urea= median(absdev_urea_median) if absdev_urea_median != .
gen medians_away = (absdev_urea_median / median_absdev_urea)
replace s3q21a = s3q21a / 10 if s3q21a > 1000 & medians_away > 10 & (price_per_kg_urea - price_urea_med) < 0
drop price_urea_med absdev_urea_median medians_away 

gen price_per_kg_dap = s3q22d / s3q22c
egen price_dap_med = median(price_per_kg_dap) if price_per_kg_dap != .
gen absdev_dap_median = abs(price_per_kg_dap - price_dap_med)
egen median_absdev_dap = median(absdev_dap_median) if absdev_dap_median != .
gen medians_away = (absdev_dap_median / median_absdev_dap)
replace s3q22a = s3q22a / 10 if s3q22a > 1000 & medians_away > 10 & (price_per_kg_dap - price_dap_med) < 0
drop price_dap_med absdev_dap_median medians_away

gen price_per_kg_nps = s3q23d /s3q23c
egen price_nps_med = median(price_per_kg_nps) if price_per_kg_nps != .
gen absdev_nps_median = abs(price_per_kg_nps - price_nps_med)
egen median_absdev_nps = median(absdev_nps_median) if absdev_nps_median != .
gen medians_away = (absdev_nps_median / median_absdev_nps)
replace s3q23a = s3q23a / 10 if s3q23a > 1000 & medians_away > 10 & (price_per_kg_nps - price_nps_med) < 0
drop price_nps_med absdev_nps_median medians_away

egen fert_inorg_kg = rowtotal(s3q21a s3q22a s3q23a s3q24a)	
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
gen use_inorg_fert = 0
replace use_inorg_fert = 1 if s3q21==1 | s3q22==1 | s3q23==1 | s3q24==1
replace use_inorg_fert = 0 if s3q21==2 & s3q22==2 & s3q23==2 & s3q24==2
replace use_inorg_fert = . if s3q21==. & s3q22==. & s3q23==. & s3q24==.
recode fert_inorg_kg* (.=0)
collapse (sum) fert_inorg_kg* (max) use_inorg_fert, by(household_id)
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for all plots"
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed plots"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed plots"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed plots"
lab var use_inorg_fert "Household uses any inorganic fertilizer"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available: data collected only at hh level


********************************************************************************
* DIETARY DIVERSITY
********************************************************************************
// updated for W4 by BET 05.04.2021
use "$Ethiopia_ESS_W4_raw_data/Household/sect6a_hh_W4.dta" , clear

* We recode food items to map HDD food categories CHECK

ta item_cd
#delimit ;
recode item_cd	    (101/109 901/903								=1	"CEREALS")  
					(601/607 610  									=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES") // not including carrots and beets BET 05.04.2021
					(401/408 608/609								=3	"VEGETABLES") // including carrots and beets here BET 05.04.2021
					(501/506							 			=4	"FRUITS")
					(701/703										=5	"MEAT")
					(709											=6	"EGGS")
					(704 											=7  "FISH")
					(201/211 301/305  								=8	"LEGUMES, NUTS AND SEEDS")
					(705/706										=9	"MILK AND MILK PRODUCTS") // not including butter as a milk product; just as a fat BET 05.04.2021
					(707/708 										=10	"OILS AND FATS") 
					(710 711 803						  			=11	"SWEETS") // sugar honey soda
					(801 802 804/807 712 713						=12	"SPICES, CONDIMENTS, BEVERAGES")
					, generate(Diet_ID)
					;
#delimit cr
* generate a dummy variable indicating whether the respondent or other member of the household has consumed a food item during the past 7 days 			
gen adiet_yes=(s6aq01==1)
ta adiet_yes   
** Now, we collapse to food group level assuming that if a household consumes at least one food item in a food group, then they have consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(household_id Diet_ID) 
count // nb of obs = 54,494 remaining
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by the household
collapse (sum) adiet_yes, by(household_id)

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
label var number_foodgroup "Number of food groups household consumed last week HDDS"
compress
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_diet.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* FEMALE LAND OWNERSHIP
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect2_pp_W4.dta", clear
*Female asset ownership
local landowners "s2q07_1 s2q07_2 s2q09_1 s2q09_2" // sell, collateral, or bequeath. cannot answer gender of owner for rented land, because does not use network roster BET 05.04.2021
keep household_id  `landowners' 	// keep relevant variable
*transform data into long form
foreach v of local landowners   {
	preserve
	keep household_id `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `s2q07_1', clear
foreach v of local landowners   {
	if "`v'"!="`s2q07_1'" {
		append using ``v''
	}
}
** remove duplicates by collapse (if a hh member appears at least one time, she/he own/control land)
duplicates drop 
gen type_asset="land"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_land_owner.dta", replace

*FEMALE LIVESTOCK OWNERSHIP
use "$Ethiopia_ESS_W4_raw_data/sect8_1_ls_W4.dta", clear
*Remove poultry-livestocks--cocks, hens, chicks
drop if inlist(ls_code,10,11,12,.)
local livestockowners "ls_s8_1q04_1 ls_s8_1q04_2"
keep household_id `livestockowners' 	// keep relevant variables
*Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `ls_s8_1q04_1', clear
foreach v of local livestockowners   {
	if "`v'"!="`ls_s8_1q04_1'" {
		append using ``v''
	}
}
*remove duplicates  (if a hh member appears at least one time, she/he owns livestock)
duplicates drop 
gen type_asset="livestock"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_livestock_owner.dta", replace

* FEMALE OTHER ASSETS
use "$Ethiopia_ESS_W4_raw_data/Household/sect11_hh_W4.dta", clear
*keep only productive assets
drop if inlist(asset_cd,4,5,6,7,8,9,10,11,12,23,24,25,26.) //exclude blanket, mattress, watches, sofa, handcart,  jewelry. What about radio/TV/CD/satellite? BET 05.04.2021 CHECK 
local otherassetowners "s11q02_1 s11q02_2 s11q02_3 s11q02_4 s11q02_5 s11q02_6 s11q02_7 s11q02_8 s11q02_9 s11q02_10 s11q02_11 s11q02_12"
keep household_id  `otherassetowners'
*Transform the data into long form  
foreach v of local otherassetowners   {
	preserve
	keep household_id  `v'
	ren `v'  asset_owner
	drop if asset_owner==. | asset_owner==0
	tempfile `v'
	save ``v''
	restore
}
use `s11q02_1', clear
foreach v of local otherassetowners  {
	if "`v'"!="`s11q02_1'" {
		append using ``v''
	}
}
*remove duplicates  (if a hh member appears at least one time, she/he owns a non-agricultural asset)
duplicates drop 
gen type_asset="otherasset"
label variable asset_owner "asset owner"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_otherasset_owner.dta", replace

* Construct asset ownership variable
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_land_owner.dta", clear
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_livestock_owner.dta"
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_otherasset_owner.dta"
gen own_asset=1 

collapse (max) own_asset, by(household_id asset_owner)
gen individual_id =asset_owner
*Own any asset
*Now merge with member characteristics
merge 1:1 household_id individual_id  using   "$Ethiopia_ESS_W4_raw_data/Household/sect1_hh_W4.dta"
keep  household_id individual_id own_asset asset_owner ea_id saq14 pw_w4 saq01 saq02 saq03 saq04 saq05 saq06 saq07 saq08 s1q01 s1q02 s1q03a
ren s1q02 mem_gender 
ren s1q03a age 
gen female = mem_gender==2
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
drop if mem_gender==1
drop if age<18 & mem_gender==2
gen personid= individual_id 
compress
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_asset.dta", replace


********************************************************************************
*WOMEN'S AG DECISION-MAKING
********************************************************************************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect3_pp_W4.dta", clear
*Women's decision-making in ag
local planting_input "s3q13 s3q15_1 s3q15_2" 
keep household_id saq09 `planting_input' 	// keep relevant variables
* Transform the data into long form  
foreach v of local planting_input   {
	preserve
	keep household_id  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `s3q13', clear
foreach v of local planting_input   {
	if "`v'"!="`s3q13'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make ag decisions)
duplicates drop 
gen type_decision="planting_input"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_planting_input.dta", replace

*SALES DECISION-MAKERS - ANNUAL SALES -- "Who in HH decided what to do with earnings for field crop"
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect11_ph_W4.dta", clear
local control_annualsales "s11q13_1 s11q13_2"
keep household_id saq09 `control_annualsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_annualsales   {
	preserve
	keep household_id  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `s11q13_1', clear
foreach v of local control_annualsales   {
	if "`v'"!="`s11q13_1'" {
		append using ``v''
	}
}
** Remove duplicates (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="control_annualsales"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_annualsales.dta", replace

*SALES DECISION-MAKERS - ANNUAL CROP -- "Who in HH made decisions about selling"
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect11_ph_W4.dta", clear
local sales_annualcrop "s11q08_1 s11q08_2"
keep household_id saq09 `sales_annualcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_annualcrop   {
	preserve
	keep household_id  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `s11q08_1', clear
foreach v of local sales_annualcrop   {
	if "`v'"!="`s11q08_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="sales_annualcrop"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_sales_annualcrop.dta", replace


 /* no section on perm crops, trees and roots include in previous section
*SALES DECISION-MAKERS - PERM SALES (TREES/FRUIT/VEG) --"Who in HH decided what to do with earnings"
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect12_ph_W4.dta", clear
local control_permsales "ph_s12q08a_1 ph_s12q08a_2"
keep household_id saq09 `control_permsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_permsales   {	
	preserve
	keep household_id  `v'
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_permsales.dta", replace

*SALES DECISION-MAKERS - PERM CROP
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect12_ph_W4.dta", clear
local sales_permcrop "ph_saq07 ph_s12q08a_1 ph_s12q08a_2"
keep household_id saq09  `sales_permcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_permcrop   {
	preserve
	keep household_id  `v'
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_sales_permcrop.dta", replace
*/

*SALES DECISION-MAKERS - HARVEST
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect9_ph_W4.dta", clear
local harvest "s9q09_1 s9q09_2"
keep household_id saq09 `harvest' 	// keep relevant variables
* Transform the data into long form  
foreach v of local harvest   {
	preserve
	keep household_id  `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}	
use `s9q09_1', clear
foreach v of local harvest   {
	if "`v'"!="`s9q09_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he make sales decisions)
duplicates drop 
gen type_decision="harvest"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_harvest.dta", replace

*SALES DECISION-MAKERS - ANNUAL HARVEST
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect9_ph_W4.dta", clear
local control_annualharvest "s9q09_1 s9q09_2"
keep household_id saq09 `control_annualharvest' // keep relevant variables
* Transform the data into long form  
foreach v of local control_annualharvest   {
	preserve
	keep household_id `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `s9q09_1', clear
foreach v of local control_annualharvest   {
	if "`v'"!="`s9q09_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, she/he controls harvest)
duplicates drop 
gen type_decision="control_annualharvest"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_annualharvest.dta", replace

* FEMALE LIVESTOCK DECISION-MAKING - MANAGEMENT
use "$Ethiopia_ESS_W4_raw_data/sect8_1_ls_W4.dta", clear
local livestockowners "ls_s8_1q05_1 ls_s8_1q05_2"
keep household_id saq09 `livestockowners' 	// keep relevant variables
* Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep household_id `v'
	ren `v'  decision_maker
	drop if decision_maker==. | decision_maker==0 | decision_maker==99
	tempfile `v'
	save ``v''
	restore
}
use `ls_s8_1q05_1', clear
foreach v of local livestockowners   {
	if "`v'"!="`ls_s8_1q05_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hhmember appears at least one time, she/he manages livestock)
duplicates drop 
gen type_decision="manage_livestock"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_manage_livestock.dta", replace

* Constructing decision-making ag variable *
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_planting_input.dta", clear
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_harvest.dta"
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_sales_annualcrop.dta"
*append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_sales_permcrop.dta"
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_manage_livestock.dta"
bysort household_id decision_maker : egen nb_decision_participation=count(decision_maker)
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
collapse (max) make_decision_* , by(household_id decision_maker )  //any decision
ren decision_maker individual_id 

*Now merge with member characteristics
merge 1:1 household_id individual_id   using   "$Ethiopia_ESS_W4_raw_data/Household/sect1_hh_W4.dta"

drop s1q03b- _merge
recode make_decision_* (.=0)
*Generate women participation in Ag decision
ren s1q02 mem_gender 
ren s1q03a age 
gen female = mem_gender==2
drop if mem_gender==1
drop if age<18 & mem_gender==2
*Generate women control over income
local allactivity crop  livestock  ag
foreach v of local allactivity {
	gen women_decision_`v'= make_decision_`v'==1 & mem_gender==2
	lab var women_decision_`v' "Women make decision about `v' activities"
	lab var make_decision_`v' "HH member involved in `v' activities"
} 
collapse (max) make_decision* women_decision*, by(household_id individual_id)
gen personid = individual_id
compress
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_decision.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
/*
* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "$Ethiopia_ESS_W4_raw_data/sect8_4_ls_W4.dta", clear
local control_livestocksales "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep household_id saq09  `control_livestocksales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep household_id saq09   `v'
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_livestocksales.dta", replace
*/

* FEMALE DECISION-MAKING - CONTROL OF BUSINESS INCOME
use "$Ethiopia_ESS_W4_raw_data/Household/sect12b1_hh_W4.dta", clear
local control_businessincome "s12bq06_1 s12bq06_2"
keep household_id `control_businessincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_businessincome   {
	preserve
	keep household_id  `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `s12bq06_1', clear
foreach v of local control_businessincome   {
	if "`v'"!="`s12bq06_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, controls business income)
duplicates drop 
gen type_decision="control_businessincome"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_businessincome.dta", replace

* FEMALE DECISION-MAKING - CONTROL OF OTHER INCOME
use "$Ethiopia_ESS_W4_raw_data/Household/sect13_hh_W4_v2.dta", clear
local control_otherincome "s13q03_1 s13q03_2"
keep household_id `control_otherincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_otherincome   {
	preserve
	keep household_id `v'
	ren `v'  controller_income
	drop if controller_income==. | controller_income==0 | controller_income==99
	tempfile `v'
	save ``v''
	restore
}
use `s13q03_1', clear
foreach v of local control_otherincome   {
	if "`v'"!="`s13q03_1'" {
		append using ``v''
	}
}
** remove duplicates  (if a hh member appears at least one time, controls other income)
duplicates drop 
gen type_decision="control_otherincome"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_otherincome.dta", replace

*Constructing decision-making final variable 
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_annualharvest.dta", clear
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_annualsales.dta"
*append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_permsales.dta"
*append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_livestocksales.dta"
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_businessincome.dta"
append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_control_otherincome.dta"

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
collapse (max) control_* , by(household_id controller_income )  //any decision
preserve
	*	We also need a variable that indicates if a source of income is applicable to a household
	*	and use it to condition the statistics on household with the type of income
	collapse (max) control_*, by(household_id) 
	foreach v of varlist control_cropincome- control_all_income {
		local t`v'=subinstr("`v'",  "control", "hh_has", 1)
		ren `v'   `t`v''
	} 
	tempfile hh_has_income
	save `hh_has_income'
restore
merge m:1 household_id using `hh_has_income'
drop _m
ren controller_income individual_id

*Now merge with member characteristics
merge 1:1 household_id individual_id   using   "$Ethiopia_ESS_W4_raw_data/Household/sect1_hh_W4.dta"
drop s1q03b-_merge
ren s1q02 mem_gender 
ren s1q03a age 
gen female = mem_gender==2
drop if mem_gender==1
drop if age<18 & mem_gender==2
recode control_* (.=0)
gen women_control_all_income= control_all_income==1 
gen personid = individual_id
compress
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_control_income.dta", replace


********************************************************************************
*CROP YIELDS
********************************************************************************
*BET 07.16.2021
*Starting with crops
use "$Ethiopia_ESS_W4_raw_data/Post-Planting/sect4_pp_w4.dta", clear
*Percent of area
gen pure_stand = s4q02==1
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = s4q03/100
replace percent_field = 1 if pure_stand==1 // 20 changes made
*Merging in area from et4_field
merge m:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3)	// dropping those only in using
*16,913 matched, 0 unmatched BET
gen dm_male= dm_gender==1
gen dm_female= dm_gender==2
gen dm_mixed= dm_gender==3
//adding for method 4 intercropping
gen intercropped_yn = 1 if ~missing(s4q02) 
replace intercropped_yn = 0 if s4q02 == 1 
gen mono_field = percent_field if intercropped_yn==0 		//not intercropped 
gen int_field = percent_field if intercropped_yn==1 		//intercropped 
bys household_id holder_id parcel_id field_id: egen total_percent_int_sum = total(int_field)	
bys household_id holder_id parcel_id field_id: egen total_percent_mono = total(mono_field)		
replace total_percent_mono = 1 if total_percent_mono>1 
//129 changes made.
//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
generate oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 		
* BET 07.16.2021 186 plots oversized  
bys household_id holder_id parcel_id field_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1
gen total_percent_inter = 1-total_percent_mono 
bys household_id holder_id parcel_id field_id: egen inter_crop_number = total(intercropped_yn)
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter=int_field if total_percent_field<=1
replace percent_inter = percent_field if oversize_plot ==1
gen ha_planted = percent_field*area_meas_hectares  if intercropped_yn == 0 
replace ha_planted = percent_inter*area_meas_hectares  if intercropped_yn == 1 
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
gen ha_planted_purestand = ha_planted if any_pure==1
gen ha_planted_mixedstand = ha_planted if any_pure==0
gen ha_planted_male_pure = ha_planted if dm_gender==1 & any_pure==1
gen ha_planted_female_pure = ha_planted if dm_gender==2 & any_pure==1
gen ha_planted_mixed_pure = ha_planted if dm_gender==3 & any_pure==1
gen ha_planted_male_mixed = ha_planted if dm_gender==1 & any_mixed==1
gen ha_planted_female_mixed = ha_planted if dm_gender==2 & any_mixed==1
gen ha_planted_mixed_mixed = ha_planted if dm_gender==3 & any_mixed==1
ren s4q19 number_trees_planted 
keep ha_planted* holder_id parcel_id field_id household_id crop_id dm_* any_* number_trees_planted intercropped_yn
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_planted.dta", replace

*Before harvest, need to prepare the conversion factors
use "${Ethiopia_ESS_W4_created_data}/Crop_CF_Wave4_adj.dta", clear
ren mean_cf_nat mean_cf100
sort crop_code unit_cd mean_cf100
duplicates drop crop_code unit_cd, force
*BET 07.16.2021 CHECK HERE: there are two regions that appear in PH files that do not appear in the conversion files (13. Harar, 15. Dire Dawa) but these use the same conversion factor as Somalie which is recoded to 5
gen mean_cf13= mean_cf99 //
gen mean_cf15 = mean_cf99
reshape long mean_cf, i(crop_code unit_cd) j(region)
recode region (99=5) 
ren mean_cf conversion
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cf.dta", replace

*Now to harvest
use "$Ethiopia_ESS_W4_raw_data/Post-Harvest/sect9_ph_w4.dta", clear
ren saq01 region  
ren s9q00b crop_code
ren s9q05b unit_cd		
gen percent_area_harv = s9q11/100 if s9q10==1
replace percent_area_harv = 1 if s9q10==2	
merge m:1 crop_code unit_cd region using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cf.dta", gen(cf_merge) 
*15,482 not matched; 12,149 matched BET 07.19.2021 seems  high. I think part of this is that the CF dat includes units that are not included in the post-harvest module. but otherwises not seeing any clear pattern in crops or region in the unmatched data
bys crop_code unit_cd: egen national_conv = median(conversion)
replace conversion = national_conv if conversion==.			// replacing with median if missing BET 07.19.2021 not sure why we need this median CF when we have national conversion rates provided in the data (code is 100)
bys unit_cd region: egen national_conv_unit = median(conversion)
replace conversion = national_conv_unit if conversion==. & unit_cd!=900		// Not for "other" ones -- 1136 changes
tab unit_cd			// BET 07.19.2021 2.5 percent (666) of field-crop observations are reported with "other" units, but does not seem to be entry errors. most common other unites are piece/number, kubaya/cup, madiga, zenbil, which do not appear in either ph module or cf module 
tab  s9q05b_os crop_code if unit_cd==900
*COMMENT FROM W3: None of the "other" units are for cereal crops so will skip adding in those food conversion factors. But this doesn't seem to be the case for W4. Not sure how to address this BET 07.19.2021
gen kgs_harvest = s9q05a*conversion
replace kgs_harvest = s9q06 if kgs_harvest==.
drop if kgs_harvest==.							// dropping those with missing kg
*recoding common beans to all one category
recode crop_code (19=12) 
*kgs harvest by crop for monocropped plots
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	preserve
	merge m:1 household_id parcel_id field_id holder_id  using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen keep(3)
	gen kgs_harv_mono_`cn' = kgs_harvest 
	merge m:1 household_id parcel_id field_id holder_id  using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen keep(3)
	gen kgs_harv_mono_`cn'_male= kgs_harv_mono_`cn' if dm_gender==1
	gen kgs_harv_mono_`cn'_female= kgs_harv_mono_`cn' if dm_gender==2
	gen kgs_harv_mono_`cn'_mixed= kgs_harv_mono_`cn' if dm_gender==3
	collapse (sum) kgs_harv_mono_`cn'*, by(household_id)
	lab var kgs_harv_mono_`cn' "monocropped `cn' harvested(kg)"
	foreach i in male female mixed {
		local lkgs_harv_mono_`cn' : var lab kgs_harv_mono_`cn'
		la var kgs_harv_mono_`cn'_`i' "`lkgs_harv_mono_`cn'' - `i' managed plots"
	}
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_harvest_monocrop", replace
	restore
}
keep crop_code crop_id holder_id parcel_id field_id kgs_harvest s9q08* s9q09* percent_area_harv
*Merging area
merge m:1 holder_id parcel_id field_id crop_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_planted", nogen 
*23 not matched from master
*14,079 matched
*renaming area planted variables to keep for analysis
gen area_plan = ha_planted
gen area_plan_male = ha_planted_male 
gen area_plan_female = ha_planted_female 
gen area_plan_mixed = ha_planted_mixed 
gen area_plan_pure = ha_planted_purestand 
gen area_plan_inter = ha_planted_mixedstand 
gen area_plan_pure_male = ha_planted_male_pure 
gen area_plan_pure_female = ha_planted_female_pure 
gen area_plan_pure_mixed = ha_planted_mixed_pure
gen area_plan_inter_male = ha_planted_male_mixed 
gen area_plan_inter_female = ha_planted_female_mixed 
gen area_plan_inter_mixed = ha_planted_mixed_mixed 
gen area_harv = area_plan*percent_area_harv

replace area_harv=. if area_harv==0 //46 to missing
replace area_plan=area_harv if area_plan==. & area_harv!=.
replace area_harv = area_plan if area_harv>area_plan & area_harv!=.

*Creating area and quantity variables by decision-maker and type of planting
gen harvest = kgs_harvest
ren any_mixed inter
gen harvest_male = harvest if dm_gender==1
gen area_harv_male = area_harv if dm_gender==1
gen harvest_female = harvest if dm_gender==2
gen area_harv_female = area_harv if dm_gender==2
gen harvest_mixed = harvest if dm_gender==3
gen area_harv_mixed = area_harv if dm_gender==3
gen area_harv_inter= area_harv if inter==1
gen area_harv_pure= area_harv if inter==0
gen harvest_inter= harvest if inter==1
gen harvest_pure= harvest if inter==0
gen harvest_inter_male= harvest if dm_gender==1 & inter==1
gen harvest_pure_male= harvest if dm_gender==1 & inter==0
gen harvest_inter_female= harvest if dm_gender==2 & inter==1
gen harvest_pure_female= harvest if dm_gender==2 & inter==0
gen harvest_inter_mixed= harvest if dm_gender==3 & inter==1
gen harvest_pure_mixed= harvest if dm_gender==3 & inter==0
gen area_harv_inter_male= area_harv if dm_gender==1 & inter==1
gen area_harv_pure_male= area_harv if dm_gender==1 & inter==0
gen area_harv_inter_female= area_harv if dm_gender==2 & inter==1
gen area_harv_pure_female= area_harv if dm_gender==2 & inter==0
gen area_harv_inter_mixed= area_harv if dm_gender==3 & inter==1
gen area_harv_pure_mixed= area_harv if dm_gender==3 & inter==0
*Collapsing to household-crop level
collapse (sum) harvest* area_harv* area_plan* kgs_harvest ha_planted* (max) dm_*  any_* number_trees_planted, by(household_id crop_code)	
*Saving area planted for Shannon diversity index
save "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan_SDI.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(household_id)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
lab var all_area_planted "Total area planted, all plots, crops, and seasons"
lab var all_area_harvested "Total area harvested, all plots, crops, and seasons"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_area_planted_harvested_allcrops.dta", replace
restore 
keep if inlist(crop_code, $comma_topcrop_area)
*Merging weights and survey variables
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
*3 not matched from master
*15,656 matched
*ren pw_w3 weight
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_harvest_area_yield.dta", clear
gen total_planted_area = area_plan		
gen total_harv_area = area_harv	
merge 1:1 household_id crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta", nogen keep(1 3)
merge 1:1 household_id crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_sales.dta", nogen keep(1 3)
ren value_crop_production value_harv
drop value_harvest
local ncrop : word count $topcrop_area
foreach v of varlist  harvest*  area_harv* area_plan* total_planted_area total_harv_area kgs_harvest* kgs_sold* value_harv value_sold {
	separate `v', by(crop_code)
	forvalues i=1(1)`ncrop' {
		local p : word `i' of  $topcrop_area
		local np : word `i' of  $topcropname_area
		local `v'`p' = subinstr("`v'`p'","`p'","_`np'",1)	
		ren `v'`p'  ``v'`p''
	}
}
gen number_trees_planted_banana = number_trees_planted if crop_code==42 
recode number_trees_planted_banana (.=0) 
collapse (firstnm) harvest* area_harv*  area_plan*  total_planted_area* total_harv_area* kgs_harvest*  kgs_sold*  value_harv* value_sold* ha_planted* (sum) number_trees_planted_*, by(household_id)
recode area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* kgs_sold*  value_harv* value_sold ha_planted* (0=.)
lab var kgs_harvest "Kgs harvested (household) (all seasons)"
lab var kgs_sold "Kgs sold (household) (all seasons)"
*label variables
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (ETB) (household)" 
	lab var value_sold_`p' "Value sold of `p' (ETB) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household)" 
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
drop harvest-harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_inter_mixed value_harv kgs_harvest kgs_sold value_sold total_planted_area total_harv_area number_trees_planted_* 
drop ha_planted // AYW 12.10.19
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_yield_hh_level.dta", replace


* VALUE OF CROP PRODUCTION  // using 335 output
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta", clear
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
replace crop_group=	"Yam"	if crop_code==	98 // CHECK 0720.2021 This is labeled as other root crop in data
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
collapse (sum) value_crop_production value_crop_sales, by( household_id commodity) 
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
collapse (sum) value_*, by(household_id)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by( household_id type_commodity) 
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
collapse (sum) value_*, by(household_id)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}
drop value_pro value_sal
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_type_crop.dta", replace
*End BET 07.19.2021


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
//KEF 7.19.21 /
*Bring in area planted
use "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan_SDI.dta", clear
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(household_id)
save "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 household_id using "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan_shannon.dta", nogen
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
bysort household_id (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort household_id (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort household_id (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort household_id crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(household_id)
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
save "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
******************************************************************************** 

*BET 05.26.2021, updated 7/20/2021
use "${Ethiopia_ESS_W4_raw_data}/Consumption Aggregate/cons_agg_W4.dta", clear
ren total_cons_ann total_cons
/*
/// CHECK BET 06.15.2021 there is no price index in wave 4, just an adj var for total consumption per AEQ, but also not clear whether it's only adjusting food prices or adjusting all. will back out using two methods
gen peraeq_cons = nom_totcons_aeq
gen price_index_hce = spat_totcons_aeq / nom_totcons_aeq
gen price_index_hce2 = (spat_totcons_aeq - ( nom_totcons_aeq - nom_foodcons_aeq))/ nom_foodcons_aeq // this is assuming that only food consumption is adjusted using index
* replace total_cons = total_cons * price_index_hce 	// Adjusting for price index // BET 05.26.2021 not seeing this in data
* replace peraeq_cons = peraeq_cons * price_index_hce // Adjusting for price index / BET 05.26.2021 not seeing this in data
*/
gen peraeq_cons = spat_totcons_aeq
la var peraeq_cons "Household consumption per adult equivalent per year"
gen daily_peraeq_cons = peraeq_cons/365
la var daily_peraeq_cons "Household consumption per adult equivalent per day"
gen percapita_cons = (total_cons / hh_size)
la var percapita_cons "Household consumption per household member per year"
gen daily_percap_cons = percapita_cons/365
la var daily_percap_cons "Household consumption per household member per day"
keep household_id adulteq total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_consumption.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Ethiopia_ESS_W4_raw_data}/Household/sect8_hh_W4.dta", clear
*BET 05.26.2021
/*
numlist "1/12"
forval k=1/12{
	local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_s7q07_`alph' hh_s7q07_`num'
}
*/
// BET 05.26.2021 14 months are asked about. taking last twelve months (july - june)
forval k=3/14 {
	gen food_insecurity_`k'= (s8q07__`k'==1)
}

egen months_food_insec = rowtotal(food_insecurity*) 
*replacing those that report over 12 months of food insecurity
replace months_food_insec = 12 if months_food_insec>12
lab var months_food_insec "Number of months of inadequate food provision"
keep household_id months_food_insec
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_food_insecurity.dta", replace


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
*Cannot calculate in this instrument - questionnaire doesn't ask value of HH assets


********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot calculate in this instrument

********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
global empty_vars ""
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_male_head.dta", clear	
drop pw_w4	
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)

*Area dta files
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_area.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farm_area.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)


*Rental value, rent paid, and value of owned land
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_rate.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_value.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_land.dta", nogen keep(1 3)

*Top crop costs
foreach cn in $topcropname_area {
	merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop_hh_area.dta", nogen keep(1 3) 
	merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_harvest_monocrop", nogen keep(1 3)
	merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fertilizer_costs_`cn'.dta", nogen keep(1 3)	
	merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_value_`cn'.dta", nogen keep(1 3)
	merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_pp_inputs_value_`cn'.dta", nogen keep(1 3)		
	merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_harv_labor_`cn'.dta", nogen keep(1 3)		
}

*Generating crop expenses for top crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
	recode `cn'_monocrop (.=0) 
	egen `cn'_exp = rowtotal(value_rented_land_`cn' value_fertilizer_`cn' val_hire_harv_`cn' val_hire_prep_`cn')
	replace `cn'_exp =. if `cn'_monocrop_ha==.
	la var `cn'_exp "Crop production expenditures (explicit) - Monocropped `cnfull' plots only"
	*disaggregate by gender of plot manager
	foreach i in male female mixed {
		egen `cn'_exp_`i' = rowtotal(value_rented_land_`cn'_`i' value_fertilizer_`cn'_`i' val_hire_harv_`cn'_`i' val_hire_prep_`cn'_`i')
		replace `cn'_exp_`i' =. if `cn'_monocrop_ha_`i'==.
		local l`cn': var lab `cn'_exp
		la var `cn'_exp_`i' "`l`cn'' - `i' managed plots"
	}
}

*Land rights
merge 1:1 household_id using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_hh.dta", nogen keep(1 3) 
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Crop yields 
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_yield_hh_level.dta", nogen keep(1 3)
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
drop ha_planted_purestand - ha_planted_mixed_mixed 
*Household diet
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_diet.dta", nogen keep(1 3)

*Post-planting inputs
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fertilizer_application.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_pp_inputs_value.dta", nogen keep(1 3)

*Post-harvest inputs
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_harv_labor.dta", nogen keep(1 3)

*Other inputs
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_seed.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmlabor_all.dta", nogen keep(1 3)

*Crop production and losses
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_losses.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_household.dta", nogen keep(1 3)


* Production by group and type of crops
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_grouped.dta", nogen
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_type_crop.dta", nogen
qui recode value_pro* value_sal* (.=0)



*Use variables
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_any_ext.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_vaccine.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fin_serv.dta", nogen keep(1 3)
recode ext_reach_all (.=0) 
gen use_fin_serv_others = .
global empty_vars $empty_vars use_fin_serv_others hybrid_seed* ext_reach_public ext_reach_private ext_reach_unspecified ext_reach_ict

*Livestock expenses and production
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_sales.dta", nogen keep(1 3) 
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_milk_animals.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_eggs_animals.dta", nogen keep(1 3)
merge 1:1 household_id using "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_Coefficients.dta", nogen keep(1 3)			
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_animal.dta", nogen keep(1 3)
gen lost_disease = . 
foreach i in lrum srum poultry{
	gen lost_disease_`i' = .
}
global empty_vars $empty_vars lost_disease*

*Non-agricultural income
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_income.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agwage_income.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_self_employment_income.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_other_income.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_assistance_income.dta", nogen keep(1 3)

*fish income 
gen fishing_income = . 
gen w_share_fishing = .
gen fishing_hh = .
global empty_vars $empty_vars *fishing_income* w_share_fishing fishing_hh


*Off-farm hours
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_off_farm_hours.dta", nogen keep(1 3)
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_wage.dta", nogen keep(1 3)

*Milk productivity
gen liters_milk_produced= liters_per_cow*milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_cow
gen liters_per_largeruminant = .
gen liters_per_buffalo = .
global empty_vars $empty_vars *liters_per_largeruminant *liters_per_buffalo

*Dairy costs 
merge 1:1 household_id using "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_lrum_expenses", nogen keep (1 3)
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

*Consumption
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_consumption.dta", nogen keep(1 3)

*Household assets
gen value_assets = .
global empty_vars $empty_vars *value_assets*

*Food security
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_shannon_diversity_index.dta", nogen

*Livestock health
*cannot construct in this instrument
gen disease_animal = . 
foreach i in lrum srum poultry{
	gen disease_animal_`i'=.
}
global empty_vars $empty_vars disease_animal disease_animal_lrum disease_animal_srum disease_animal_poultry
*livestock feeding, water, and housing
merge 1:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_feed_water_house.dta", nogen keep(1 3)

* recoding and creating new variables
gen annual_salary_aggregate = .
gen annual_salary_agwage_aggregate = .
recode annual_salary annual_salary_agwage annual_salary_aggregate annual_salary_agwage_aggregate (.=0)
ren annual_salary wage_income
ren annual_salary_agwage agwage_income
drop annual_salary_aggregate annual_salary_agwage_aggregate

*Crop income
recode value_crop_production crop_value_lost (.=0) 
replace crop_value_lost = 0 if crop_value_lost==. & value_crop_production!=.
replace value_crop_production = 0 if value_crop_production==. & crop_value_lost!=.
egen crop_production_expenses = rowtotal(value_rented_land value_transport_free_seed value_transport_purchased_seed value_purchased_seed value_fert value_hired_harv_labor value_hired_prep_labor value_transport_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Farm size
ren area_meas_hectares_hh land_size
recode land_size (.=0) /* If no farm, then no farm area */

*Livestock income
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

*Other income
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

*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)  
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"


*Ag activities
gen agactivities_hh = ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Crop household and livestock household
gen crop_hh = (value_crop_production!=0  | farm_area!=0 )  
lab var crop_hh "1= Household has some land cultivated or some crop income"
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
lab  var livestock_hh "1= Household has some livestock or some livestock income"
count if value_crop_production==. /* 15 don't have crop production. Were these only interviewed post-planting? */

*households engaged in egg production 
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Farm size categories
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

*Total costs (implicit + explicit)
egen cost_total_hh = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert value_purchased_seed value_non_purchased_seed value_transport_purchased_seed value_transport_free_seed)
lab var cost_total_hh "Explicit + implicit costs of crop production (household level)"
egen cost_total = rowtotal(value_owned_land value_rented_land value_hired_prep_labor value_fam_prep_labor value_hired_harv_labor value_fam_harv_labor value_fert) //excludes seed costs because we can't attribute this cost to plot managers   
lab var cost_total "Explicit + implicit costs of crop production that can be disaggregated at the plot manager level"
foreach i in male female mixed{
	egen cost_total_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_hired_prep_labor_`i' value_fam_prep_labor_`i' value_hired_harv_labor_`i' value_fam_harv_labor_`i' value_fert_`i')
	lab var cost_total_`i' "Explicit + implicit costs of crop production (`i'-managed plots)"
}

*Explicit costs only
egen cost_expli_hh = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert value_purchased_seed value_transport_purchased_seed value_transport_free_seed)
lab var cost_expli_hh "Total explicit crop production (household level)" 

*Creating explicit costs by gender (excludes seeds)
egen cost_expli = rowtotal(value_rented_land value_hired_prep_labor value_hired_harv_labor value_fert)
lab var cost_expli "Explicit costs of crop production that can be disaggregated at the plot manager level"
foreach i in male female mixed{
	egen cost_expli_`i' = rowtotal(value_rented_land_`i' value_hired_prep_labor_`i' value_hired_harv_labor_`i' value_fert_`i')
	lab var cost_expli_`i' "Crop production costs per hectare, explicit costs (`i'-managed plots)"
}
drop *value_owned_land* *value_rented_land* *value_hired_prep_labor* *value_fam_prep_labor* *value_hired_harv_labor* *value_fam_harv_labor* /*
*/  *value_fert* *value_purchased_seed* *value_non_purchased_seed* *value_transport_purchased_seed* *value_transport_free_seed* val_hire_* 


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
drop value_harvest*

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


gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
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
egen w_labor_total=rowtotal(w_labor_hired w_labor_family w_labor_other) 
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%"
*Variables winsorized both at the top 1% and bottom 1% 
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
*area_harv and area_plan are also winsorized both at the top 1% and bottom 1% because we need to analyze at the crop level 
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
*generate yield and weights for yields using winsorized values 
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
gen cost_total_ha=w_cost_total_hh/w_ha_planted
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

*mortality rate
global animal_species lrum srum camel equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}

*Generating crop expenses by hectare for top crops
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
		


/*DYA.10.26.2020*/ 
*Hours per capita using winsorized version off_farm_hours 
foreach x in ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}
 
*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh/w_ha_planted		
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*Milk productivity
gen liters_per_cow = w_liters_milk_produced/milk_animals		
lab var liters_per_cow "average quantity (liters) per day (household) - cow"

*Egg productivity
gen egg_poultry_year = eggs_total_year/hen_total
ren hen_total poultry_owned
lab var egg_poultry_year "average number of eggs per year per hen"

*Calculate proportion of crop value sold using winsorized values of value_crop_sales and value_crop_production
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
replace w_proportion_cropvalue_sold = 1 if w_proportion_cropvalue_sold>1 & w_proportion_cropvalue_sold!=.
lab var w_proportion_cropvalue_sold "Proportion of crop value produced (winsorized) that has been sold"

*livestock value sold 
gen w_share_livestock_prod_sold = w_sales_livestock_products / w_value_livestock_products
replace w_share_livestock_prod_sold = 1 if w_share_livestock_prod_sold>1 & w_share_livestock_prod_sold!=.
lab var w_share_livestock_prod_sold "Percent of production of livestock products (winsorized) that is sold"

*Propotion of farm production sold
gen w_prop_farm_prod_sold = w_value_farm_prod_sold / w_value_farm_production
replace w_prop_farm_prod_sold = 1 if w_prop_farm_prod_sold>1 & w_prop_farm_prod_sold!=.
lab var w_prop_farm_prod_sold "Proportion of farm production (winsorized) that has been sold"

*Unit cost of production
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

*dairy
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced  
lab var cost_per_lit_milk "dairy production cost per liter"

*****getting correct subpopulations***
*all rural housseholds engaged in crop production 
recode inorg_fert_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode inorg_fert_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (nonmissing=.) if crop_hh==0

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
recode cost_per_lit_milk liters_per_cow (.=0) if dairy_hh==1
recode cost_per_lit_milk liters_per_cow (nonmissing=.) if dairy_hh==0
*households with egg-producing animals
recode egg_poultry_year (.=0) if egg_hh==1 
recode egg_poultry_year (nonmissing=.) if egg_hh==0

*now winsorize ratios only at top 1% 
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

*Winsorizing top crop ratios
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

*now winsorize ratio only at top 1% - yield 
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
*Create final income variables using un_winzorized and winzorized values
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
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all  months_food_insec /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
*all rural households engaged in livestock production
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
		
*hh engaged in crop or livestock production
gen ext_reach_unspecified=0 
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

*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0

*** End outliers *** 

*create different weights 
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


*Rural poverty headcount ratio BET 07.20.2021
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=ET&start=1990
	// 1.90 * 5.57 = 10.583  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2019&locations=ET&start=2003
	// 1+(319.019- 132.015)/ 132.015= 2.416536
	// 10.583 * 2.416536 = 25.5742 ETB
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out
gen poverty_under_1_9 = (daily_percap_cons<25.5742)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"

*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*By per capita consumption
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

****Currency Conversion Factors*** 
gen ccf_loc = 1 
lab var ccf_loc "currency conversion factor - 2018 $ETB"
gen ccf_usd = 1 / $Ethiopia_ESS_W4_exchange_rate 
lab var ccf_usd "currency conversion factor - 2018 $USD"
gen ccf_1ppp = 1 / $Ethiopia_ESS_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2018 $Private Consumption PPP"
gen ccf_2ppp = 1 / $Ethiopia_ESS_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2018 $GDP PPP"

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

*Removing intermediate variables to get below 5,000 vars
keep household_id fhh clusterid strataid *weight* *wgt* region zone woreda  subcity kebele ea household rural farm_size* *total_income* /*
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
*/ /*DYA 10.6.2020*/ *value_livestock_sales*  *w_value_farm_production* *value_slaughtered* *value_lvstck_sold* *value_crop_sales* *sales_livestock_products* *value_livestock_sales*


/**create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in cowpea yam {
		gen `x'_xx = .
		ren *maize*_xx *`c'*
	}
}
global empty_vars $empty_vars *cowpea* *yam* 
*/
*replace empty vars with missing 
foreach v of varlist $empty_vars { 
	replace `v' = .
}

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren household_id hhid 
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2018-19" 
gen instrument = 24
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument
saveold "$Ethiopia_ESS_W4_final_data/Ethiopia_ESS_W4_household_variables.dta", replace


********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_control_income.dta", clear
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_decision.dta", nogen keep(1 3)
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_asset.dta", nogen keep(1 3)
destring region zone  , replace
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_male_head.dta", nogen keep(1 3)
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_diet.dta", nogen
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen
* BET 07.20 ISSUE HERE PLEASE CHECK:  land rights corresponed to parcel, so I modified that code to collapse at the person not parcel level
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1				// this line will set to zero for all women for whom it is missing (i.e. regardless of ownerhsip status)
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"
*/
*Adding individual economic activities

merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agworker.dta", nogen force
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_business_owners_ind.dta", nogen force
merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_worker.dta", nogen force
replace business_owner=0 if business_owner==.
preserve
gen farm_manager_female = farm_manager if mem_gender==2
gen farm_manager_female_adult = farm_manager_female if age>14 & age<65
gen livestock_keeper_female = livestock_keeper if mem_gender==2
gen livestock_keeper_female_adult = livestock_keeper_female if age>14 & age<65
gen agworker_female = agworker if mem_gender==2
gen agworker_female_adult = agworker_female if age>14 & age<65
gen business_owner_female = business_owner if mem_gender==2
gen business_owner_female_adult = business_owner_female if age>14 & age<65
gen wage_worker_female = wage_worker if mem_gender==2
gen wage_worker_female_adult = wage_worker_female if age>14 & age<65
ren household_id hhid
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_female_manager_individual.dta", replace
ren hhid household_id
collapse (sum) num_farm_manager_female=farm_manager_female num_livestock_keeper_female=livestock_keeper_female num_business_owner_female=business_owner_female num_agworker_female=agworker_female /*
*/ num_wage_worker_female=wage_worker_female num_farm_manager_female_ad=farm_manager_female_adult num_livestock_keeper_female_ad=livestock_keeper_female_adult num_business_owner_female_ad=business_owner_female_adult /*
*/ num_agworker_female_ad=agworker_female_adult num_wage_worker_female_ad= wage_worker_female_adult, by(household_id)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_female_manager.dta", replace
restore

*Adding improved seed use by crop 
foreach cn in $topcropname_area {
	merge 1:1 household_id personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use_`cn'.dta", nogen
}
lab var personid "Person ID"
lab var household_id "Household ID"
lab var region "Region"
lab var zone "Zone"
lab var woreda "Woreda"
gen town =.
lab var town "Town"
lab var subcity "Subcity"
lab var kebele "Kebele"
lab var ea "Enumeration area"
lab var rural "1= Rural"
lab var pw_w4 "Household weight"
lab var women_control_all_income "Invidual has control over at least one type of income"
lab var women_decision_ag "Invidual makes decision about livestock production activities"
lab var women_asset "Invidual owns an assets (land or livestock)"
replace all_imprv_seed_use=0 if all_imprv_seed_use==. & farm_manager==1
replace female_imprv_seed_use=0 if female_imprv_seed_use==. & farm_manager==1 & mem_gender==2
replace male_imprv_seed_use=0 if male_imprv_seed_use==. & farm_manager==1 & mem_gender==1
replace all_use_inorg_fert=0 if all_use_inorg_fert==. & farm_manager==1
replace female_use_inorg_fert=0 if female_use_inorg_fert==. & farm_manager==1 & mem_gender==2
replace male_use_inorg_fert=0 if male_use_inorg_fert==. & farm_manager==1 & mem_gender==1
replace all_vac_animal=0 if all_vac_animal==. & livestock_keeper==1
replace female_vac_animal=0 if female_vac_animal==. & livestock_keeper==1 & mem_gender==2
replace male_vac_animal=0 if male_vac_animal==. & livestock_keeper==1 & mem_gender==1

*Generating rural codes for individuals
bysort household_id: egen rural_temp= mean(rural)
replace rural= rural_temp if rural==.
drop rural_temp

*Merge in hh variable to determine ag household
preserve
use "${Ethiopia_ESS_W4_final_data}/Ethiopia_ESS_W4_household_variables.dta", clear
ren hhid household_id
keep household_id ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 household_id using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0
gen women_diet = . 

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren household_id hhid
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
ren personid indid
gen geography = "Ethiopia"
gen survey = "LSMS-ISA"
gen year = "2018-19"
gen instrument = 24
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
saveold "$Ethiopia_ESS_W4_final_data/Ethiopia_ESS_W4_individual_variables.dta", replace


********************************************************************************
//     FIELD LEVEL    

********************************************************************************

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_production_field.dta", clear
merge 1:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3)
merge 1:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_gender_dm.dta", nogen keep(1 3)
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_male_head.dta", nogen keep(1 3)		
merge m:1 household_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen
merge 1:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_farmlabor_postplanting.dta", keep (1 3) nogen
merge 1:1 household_id holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plot_farmlabor_postharvest.dta", keep (1 3) nogen
drop household ea_id local_unit area_sqmeters_gps sqmeters_per_unit_zone obs_zone sqmeters_per_unit_region obs_region obs_country sqmeters_per_unit_country
egen  labor_total =rowtotal(days_hired_postplant days_famlabor_postplant days_otherlabor_postplant days_hired_postharvest days_famlabor_postharvest days_otherlabor_postharvest)
ren value_crop_production plot_value_harvest
/*BET.12.03.020*/ gen hhid=household_id
/*BET.12.03.020*/ merge m:1 hhid using "${Ethiopia_ESS_W4_final_data}/Ethiopia_ESS_W4_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*BET.12.03.020*/ recode farm_size_agland (.=0) 
/*BET.12.03.020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1


*Winsorize area_meas_hectares and labor_total at top and bottom 1%
keep if cultivated==1
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)     
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}
 
*Winsorize plot_value_harvest at top  1% only 
_pctile plot_value_harvest  [aw=weight] , p($wins_upper_thres)  
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
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
	
*Convert monetary values into USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_usd= `p' / $Ethiopia_ESS_W4_exchange_rate
	gen `p'_1ppp= `p' / $Ethiopia_ESS_W4_cons_ppp_dollar
	gen `p'_2ppp= `p' / $Ethiopia_ESS_W4_gdp_ppp_dollar
	gen `p'_loc = `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2018 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2018 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2018 $ USD)"
	lab var `p'_loc "`l`p'' (2018 ETB)" 
	lab var `p' "`l`p'' (ETB)" 
	gen w_`p'_usd= w_`p' / $Ethiopia_ESS_W4_exchange_rate
	gen w_`p'_1ppp= w_`p' / $Ethiopia_ESS_W4_cons_ppp_dollar
	gen w_`p'_2ppp= w_`p' / $Ethiopia_ESS_W4_gdp_ppp_dollar
	gen w_`p'_loc = w_`p' 
	local lw_`p' : var lab w_`p' 
	lab var w_`p'_1ppp "`lw_`p'' (2018 $ Private Consumption  PPP)"
	lab var w_`p'_2ppp "`l`p'' (2018 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2018 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2018 ETB)"
	lab var w_`p' "`lw_`p'' (ETB)" 
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

rename v1 ETH_wave4

save   "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gendergap.dta", replace
restore

/*BET.12.3.2020 - END*/ 

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren household_id hhid
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
ren field_id plot_id
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2018-19" 
gen instrument = 24
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument

saveold "$Ethiopia_ESS_W4_final_data/Ethiopia_ESS_W4_field_plot_variables.dta", replace


********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Ethiopia_ESS_W4"
do "${directory}/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS_02.08.24.do" 