
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: Agricultural Development Indicators for the LSMS-ISA,e Ethiopia Socioeconomic Survey (ESS) LSMS-ISA Wave 4 (2018-19)

*Author(s)		: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu
				  
*Date			: March 31st, 20254
*Dataset Version	: ETH_2018_ESS_v02_M_Stata
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
global directory 				"../.." //Update this to match your local repo location


*Set directories
global Ethiopia_ESS_W4_raw_data			"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Raw DTA Files"
global Ethiopia_ESS_W4_temp_data 		"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Final Dta Files/temp_data"
global Ethiopia_ESS_W4_created_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Final DTA Files/created_data"
global Ethiopia_ESS_W4_final_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Final DTA Files/final_data" 


********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD IDS
********************************************************************************
global Ethiopia_ESS_W4_exchange_rate 23.8661	// https://www.bloomberg.com/quote/USDETB:CUR //2017
global Ethiopia_ESS_W4_gdp_ppp_dollar 8.34 	// https://data.worldbank.org/indicator/PA.NUS.PPP //2017
global Ethiopia_ESS_W4_cons_ppp_dollar 8.21	// https://data.worldbank.org/indicator/PA.NUS.PPP //2017
global Ethiopia_ESS_W4_inflation 1.31848 // inflation rate 2017-2019. Data was collected during 2018-2019. We want to adjust value to 2017. CPI_2019 = 322.52 / CPI_2017 = 244.65

global Ethiopia_ESS_W4_poverty_190 (1.90*5.5747*244.6/133.25) //see calculation below
* WB's previous (PPP) poverty threshold is $1.90. (established in 2011)
* Multiplied by 5.5747 - 2011 PPP conversion factor, private consumption (LCU per international $) - Ethiopia
		* https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=ET
* Multiplied by 244.6 - 2017 Consumer price index (2010 = 100)
		* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=ET&start=2011
* Divided by 133.25 - 2011 Consumer price index (2010 = 100)
		* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=ET&start=2011
global Ethiopia_ESS_W4_poverty_npl (7184*244.6/221.028/365) //see calculation and sources below
* 7184 Birr is the Ethiopian National Poverty Line in 2015/2016
		* Mekasha, T. J., & Tarp, F. (2021). Understanding poverty dynamics in Ethiopia: Implications for the likely impact of 	COVID-19. Review of Development Economics, 25(4), 1838–1868. https://doi.org/10.1111/rode.12841
* Multiplied by 244.6 - 2017 Consumer price index (2010 = 100)
		* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=ET&start=2011
* Divided by 221.028 - 2016 Consumer price index (2010 = 100)
	* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=ET&start=2011
* Divided  by # of days in year (365) to get daily amount
global Ethiopia_ESS_W4_poverty_215 (2.15* $Ethiopia_ESS_W4_inflation * $Ethiopia_ESS_W4_cons_ppp_dollar)  
* WB's new (PPP) poverty threshold of $2.15 multiplied by globals


********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


*Note Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators# for 2019 (most recent year)
global Ethiopia_ESS_W4_pop_tot 111129438 			
global Ethiopia_ESS_W4_pop_rur 88055633				//79% of total
global Ethiopia_ESS_W4_pop_urb 23073805				//21% of total


********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "teff maize wheat sorgum coffee barley enset hsbean millet rice soy nueg sesame banana swtptt tomato onion mango avocad" // teff - hsbean are in the top 10 by area, other crops are of additional interest
global topcrop_area      "7 2 8 6 72 1 74 13 3 5 18 25 27 42 62 63 58 46 84" 
global comma_topcrop_area "7, 2, 8, 6, 72, 1, 74, 13, 3, 5, 18, 25, 27, 42, 62, 63, 58, 46, 84" 
global topcropname_full "teff maize wheat sorghum coffee barley enset horsebeans millet rice soybeans nueg sesame banana sweetpotato tomato onion mango avocado"
global nb_topcrops : word count $topcrop_area

/* MGM 5.18.2024 (W5): keeping this here for reference - these are the ATA specific crops of interest - added these to the globals above
*ATA Top Crops
global topcropname_ata "barley maize teff wheat tomato onion banana mango avocad"
global topcrop_ata "1 2 7 8 63 58 42 46 84"
global comma_topcrop_ata "1, 2, 7, 8, 63, 58, 42, 46, 84"
global topcropname_full_ata "barley maize teff wheat tomato onion banana mango avocado"
global nb_topcrops_ata : word count $topcrop_ata
*/

set obs $nb_topcrops //Update if number of crops changes
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropname_table.dta", replace 


********************************************************************************
*CROP UNIT CONVERSION FACTOR FILE PROCESSING
********************************************************************************
// crop unit conversion factor file is not present in all waves' raw data downloads.
// the GitHub folder referenced below contains a master cf.dta that is standardized across waves
/*
use "$directory/Ethiopia ESS/Conversion Factors/crop_cf.dta", clear
save "$Ethiopia_ESS_W4_raw_data/Crop_CF_Wave4.dta", replace
*/

********************************************************************************
* UNIQUELY IDENTIFIABLE GEOGRAPHIES AND PLOTS - note that without this code, collapsing by [zone, woreda, kebele, ea] using raw data (as we do to get median prices) will result in inaccurate medians. We need to create unique identifiers to collapse on!
* UNIQUELY IDENTIFIABLE PARCELS AND FIELDS AT THE HOUSEHOLD LEVEL (for AqQuery+)

* STEPS:
* Create a "temp_data" folder in the "Final DTA Files" folder, similar to "created_data" and "final_data"
* Create a Global for temp_data (e.g. global Ethiopia_ESS_W5_temp_data		"$directory/Ethiopia ESS/Ethiopia ESS Wave 4/Final DTA Files/temp_data")
********************************************************************************
capture confirm file "$Ethiopia_ESS_W4_temp_data/sect_cover_hh_w4.dta" //Simple check for an output file; this block only needed one time, so code will only run the code if it's missing from the temp_data folder. Delete it to make the code re-run.
if(_rc){
local directory_raw $Ethiopia_ESS_W4_raw_data
local directory_temp $Ethiopia_ESS_W4_temp_data

local raw_files : dir "`directory_raw'" files "*.dta", respectcase

foreach file of local raw_files {
    use "`directory_raw'/`file'", clear 
  
		
		// REGION
		capture confirm variable saq01
		if(!_rc) {
		tostring saq01, gen(region)
		replace region = "0" + region if length(region) == 1
		}
  
		// ZONE
		capture confirm variable saq02 
		if(!_rc) {
		tostring saq02, replace
        egen zone = concat(region saq02)
		drop region // We just used this variable to create a unique string for zone - now we prefer saq01 (region in byte form)
		assert zone != "" if saq02 != ""
        drop saq02
        rename zone saq02
		lab var saq02 "Zone"
		order saq01 saq02
        }
		
		// WOREDA
		capture confirm variable saq03
		if(!_rc) {
		tostring saq03, replace
        egen woreda = concat(saq02 saq03) // Just need saq02 and 03 because 02 was already concat. with saq01
		assert woreda != "" if saq03 != ""
        drop saq03
        rename woreda saq03
		lab var saq03 "Woreda"
		order saq01 saq02 saq03
        }
		
		/*
		// CITY
		capture confirm variable saq04
		if(!_rc) {
		tostring saq04, replace
		replace saq04 = "0" + saq04 if length(saq04) == 1
        egen city = concat(saq03 saq04) 
		assert city != "" if saq04 != ""
        drop saq04
        rename city saq04
		lab var saq04 "City"
		order saq01 saq02 saq03 saq04
        }
		
		// SUBCITY
		capture confirm variable saq05
		if(!_rc) {
		tostring saq05, replace
		replace saq05 = "0" + saq05 if length(saq05) == 1
        egen subcity = concat(saq04 saq05) 
		assert subcity != "" if saq05 != ""
        drop saq05
        rename subcity saq05
		lab var saq05 "Sub City"
		order saq01 saq02 saq03 saq04 saq05
        }
		*/
		
		// KEBELE
		capture confirm variable saq06
		if(!_rc) {
		tostring saq06, replace
        egen kebele = concat(saq05 saq06) // Adding in city and subcity just so it matches how hhid and holder_id are stylized
		assert kebele != "" if saq06 != ""
        drop saq06
        rename kebele saq06
		lab var saq06 "Kebele"
		order saq01 saq02 saq03 saq04 saq05 saq06
        }
    
        // EA
		capture confirm variable saq07
		if(!_rc) {
		tostring saq07, replace
        egen ea = concat(saq06 saq07)
		assert ea != "" if saq07 != ""
        drop saq07
        rename ea saq07
		lab var saq07 "Enumeration Area"
		// destring saq01 saq02 saq03 saq04 saq05 saq06 saq07, replace
		order saq01 saq02 saq03 saq04 saq05 saq06 saq07
        }
		
		// HHID - changing household_id to hhid - unique HHID in W4
		capture confirm variable household_id
		if(!_rc) {
		ren household_id hhid
        }
	
		// PARCEL_ID - creating a unique parcel identifier
		capture confirm variable saq09
			if(!_rc) {
			capture confirm variable parcel_id
				if(!_rc) {
				tostring saq09, replace
				tostring parcel_id, replace
				egen parcel_id_2 = concat(saq09 parcel_id)
				assert parcel_id_2 != "" if parcel_id != ""
				drop parcel_id
				rename parcel_id_2 parcel_id
				lab var parcel_id "Unique Parcel ID"
				order saq01 saq02 saq03 saq04 saq05 saq06 saq07 hhid holder_id parcel_id 
				}
			}
		
		// FIELD_ID - creating a unique field identifier
		capture confirm variable parcel_id
			if(!_rc) {
			capture confirm variable field_id
				if(!_rc) {
				tostring field_id, replace
				egen field_id_2 = concat(parcel_id field_id)
				assert field_id_2 != "" if field_id != ""
				drop field_id
				rename field_id_2 field_id
				lab var field_id "Unique Field ID"
				//order saq01 saq02 saq03 saq04 saq05 saq06 saq07 saq08 saq09 hhid holder_id parcel_id field_id
				}
			}
	save "`directory_temp'/`file'", replace
}

* MISCELLANEOUS: CFs, Geovars, Etc.
local raw_cf : dir "`directory_raw'" files "*CF*.dta", respectcase
local raw_geo : dir "`directory_raw'" files "*Geovar*.dta", respectcase
local raw_misc : dir "`directory_raw'" files "*cons_agg*.dta", respectcase
local raw_files "`raw_cf' `raw_geo' `raw_misc'"

foreach file of local raw_files {
use "`directory_raw'/`file'", clear 
capture confirm var household_id 
if !_rc {
		ren household_id hhid
}
save "`directory_temp'/`file'", replace

}

}

* LAND AREA CONVERSION FACTORS - one additional file needs to get modified
use "${Ethiopia_ESS_W4_raw_data}/ET_local_area_unit_conversion.dta", clear
tostring region, g(region2)
tostring zone, replace
tostring woreda, replace
replace region2 = "0"+region2 if length(region2)==1
replace zone = "0"+zone if length(zone)==1
replace woreda = "0"+woreda if length(woreda)==1
egen zone2 = concat(region zone)
egen woreda2 = concat(zone woreda)

drop region2 zone woreda
ren *2 *
save "${Ethiopia_ESS_W4_temp_data}/ET_local_area_unit_conversion.dta", replace


********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "$Ethiopia_ESS_W4_temp_data/sect_cover_hh_W4.dta", clear
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
keep region zone woreda city subcity kebele ea household weight rural hhid
/*DYA.7.27.2021 VERY important to use weight. It is seems that urban houseold are oversampled (NEED TO CHECK WHY)
ta rural //--> 46.01%
ta rural [aw=weight_pop_rururb]  //--> 67.54% more in line with W3
*/
//destring region zone woreda, replace
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", replace



********************************************************************************
*WEIGHTS AND GENDER OF HEAD
********************************************************************************
use "$Ethiopia_ESS_W4_temp_data/sect1_hh_W4.dta", clear
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
replace stratum_id=17 if rural==0 & saq01==2	//Afar, urban
replace stratum_id=18 if rural==0 & saq01==3 	//Amhara, urban
replace stratum_id=19 if rural==0 & saq01==4 	//Oromiya, urban
replace stratum_id=20 if rural==0 & saq01==5	//Somali, urban
replace stratum_id=21 if rural==0 & saq01==6	//Benishangul Gumuz, urban
replace stratum_id=22 if rural==0 & saq01==7 	//SNNP, urban
replace stratum_id=23 if rural==0 & saq01==12	//Gambela, urban
replace stratum_id=24 if rural==0 & saq01==13 	//Harar, urban
replace stratum_id=25 if rural==0 & saq01==14 	//Addis Ababa, urban MGM 8.14.2024: Addis Ababa is only urban, no rural respondents
replace stratum_id=26 if rural==0 & saq01==15 	//Dire Dawa, urban
replace strataid=stratum_id if rural==0 		//assign new strata IDs to urban respondents, stratified by region and urban
drop if s1q05==2 //DYA limiting this to only individual still in the households
gen hh_members = 1 
gen hh_work_age = (s1q03a>14 & s1q03a<65)
gen hh_women = s1q02==2
gen hh_adult_women = (hh_women==1 & s1q03a>14 & s1q03a<65)			//Adult women from 15-64 (inclusive)
gen hh_youngadult_women = (hh_women==1 & s1q03a>14 & s1q03a<25) 		//Adult women from 15-24 (inclusive) 
collapse (max) fhh (firstnm) pw_w4 clusterid strataid (sum) hh_members hh_work_age hh_women hh_adult_women, by(hhid)	//removes duplicate values, now 6,770 observations instead of 
lab var hh_members "Number of household members"
lab var hh_work_age "Number of household members of working age"
lab var hh_women "Number of women in household"
lab var hh_adult_women "Number of women in household of working age"
lab var fhh "1=Female-headed household"
lab var strataid "Strata ID (updated) for svyset"
lab var clusterid "Cluster ID for svyset"
lab var pw_w4 "Household weight"
*Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen 
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
* drop weight_pop_rur weight_pop_urb

save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", replace



********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
*DYA 7.3.2023 /; This should have been the household roster and not the post-planting files
*KEF Added this section per Andrew's guidance. Needed to make a person_id file that was comparable to NGA and TZA. 1/11/22
*use "$Ethiopia_ESS_W4_temp_data/sect1_pp_w4.dta", clear
use "$Ethiopia_ESS_W4_temp_data/sect1_hh_w4.dta", clear
keep hhid individual_id s1q02 s1q03a
gen female = s1q02 == 2 // No missings.
lab var female "1 = individual is female"
rename individual_id indiv
rename s1q02 sex
rename s1q03a age
gen personid=indiv
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_person_ids.dta", replace


*********************************************************************************
*INDIVIDUAL GENDER
********************************************************************************
*Using gender from planting and harvesting
*Harvest
use "$Ethiopia_ESS_W4_temp_data/sect1_ph_W4.dta", clear
ren s1q00 personid
gen female_ph = s1q03==2	// NOTE: Assuming missings are MALE
replace female_ph =. if s1q03==.
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop hhid personid, force
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_ph.dta", replace		

*Planting
use "$Ethiopia_ESS_W4_temp_data/sect1_pp_W4.dta", clear
ren s1q00 personid
gen female_pp = s1q03==2	// NOTE: Assuming missings are MALE
replace female_pp =. if s1q03==.
*dropping duplicates (data is at holder level so some individuals are listed multiple times, we only need one record for each)
duplicates drop hhid personid, force
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_ph.dta", nogen 		
*DYA.07.27.2021 Test if gender of individual changes between pp and ph. If so, keep the pp value (ACTION: Modify this is earlier waves)
gen test_female=female_pp -female_ph
ta test_female  //18 individuals with different change
gen female=female_pp
replace female=female_ph if female_pp==.
duplicates drop hhid personid, force			//no duplicates
replace female = s1q03==2 if female==.
*Assuming missings are male
recode female (.=0)		// no changes
tostring personid, replace
gen individual_id = hhid + "0" + personid
encode personid, gen(personid2)
drop personid
ren personid2 personid
duplicates drop individual_id, force
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", replace

********************************************************************************
*PLOT DECISION-MAKERS
********************************************************************************
*Gender/age variables
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_W4.dta", clear
gen cultivated = s3q03==1			// if plot was cultivated
gen personid1 = s3q13 
gen personid2 = s3q15_1 
gen personid3 = s3q15_2 
//keep if cultivated == 1
keep hhid personid* parcel_id  field_id holder_id cultivated
reshape long personid, i(hhid parcel_id field_id holder_id cultivated) j(dm_no)
//gen dm_ID = personid if dm_no == personid 
drop if personid==.
merge m:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen keep(1 3)	 
gen dm1_gender = female+1 if personid==1
collapse (mean) female (firstnm) dm1_gender, by(hhid parcel_id field_id holder_id cultivated)
gen dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
replace dm_gender = 3 if dm_gender==. & female!=.
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var dm_gender "Gender of decision-maker(s)"
keep dm* holder_id hhid field_id parcel_id cultivated // FJT 7.25.23
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers.dta", replace


*DYA 7.3.2023: Adding this here to create a single file containing individuals who are plot manager_female*
********************************************************************************
*INDIVIDUAL ENGAGEMENT IN ECONOMIC ACTIVITIES (plot manager, business owner, business manager, livestock keep, nonagwage_worker, agwage_worker)
********************************************************************************
* Plot managers
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_W4.dta", clear
gen plot_manager_1=s3q13
gen plot_manager_2=s3q15_1
gen plot_manager_3=s3q15_2
gen cultivated = s3q03==1
drop if cultivated==0 // drop non cultivated field
forvalue j=1(1)3 {
	preserve
	keep hhid parcel_id field_id plot_manager_`j'
	drop if plot_manager_`j'==. | plot_manager_`j'==0  // from observations with no reported manager
	gen field_managed=1
	collapse (sum) field_managed, by(hhid plot_manager_`j')
	ren plot_manager_`j' plot_manager_id
	tempfile plot_manager_`j'
	save `plot_manager_`j''
	restore    
}

use `plot_manager_1', clear
append using `plot_manager_2'
append using `plot_manager_3'
collapse(sum)  field_managed, by(hhid plot_manager)
drop field_managed 
gen farm_manager=1
ren plot_manager personid
gen dm_ID= personid // FJT 7.25.23
save  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_plotmanager.dta", replace




********************************************************************************
* ALL AREA CONSTRUCTION
********************************************************************************

*combained land size and farm area 
use "$Ethiopia_ESS_W4_temp_data/sect2_pp_w4.dta", clear
merge 1:m hhid holder_id parcel_id using "${Ethiopia_ESS_W4_temp_data}/sect3_pp_w4.dta", nogen
//drop if pp_s2q01b == 2 //Parcel no longer owned or rented in. //question not asked in W4
gen rented_in = s2q05==3
gen plot_not_owned = ( s2q05==3 | s2q05==4 | s2q05==5 ) // rent, borrowed free, squat
gen plot_owned = (s2q05==1 | s2q05==2 | s2q05==7 ) // granted, inherited // no values for "purchased" (see other waves)
gen rented_out= (s2q13==1 | s2q13==2) // all rented out, all sharecropped out
//Rented out parcels are not measured

ren saq01 region 
ren saq02 zone 
ren saq03 woreda
gen cultivated = s3q03==1

gen agland = (s3q03==1 | s3q03==2 | s3q03==3 | s3q03==5 ) // Cultivated, pasture, prepared for Belg season, or fallow. Excludes forest, home/homestead, and "other"
replace agland=1 if cultivated==1 //59 changes

*Generating some conversion factors
gen area = s3q02a
gen local_unit = s3q02b
gen area_sqmeters_gps = s3q08
replace area_sqmeters_gps = . if area_sqmeters_gps<0

*Constructing geographic medians for local unit per square meter ratios
preserve
	keep hhid parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", keep(1 3) nogen
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight_pop_rururb], by (region zone local_unit)
	ren sqmeters_per_unit sqmeters_per_unit_zone 
	ren observations obs_zone
	lab var sqmeters_per_unit_zone "Square meters per local unit (median value for this region and zone)"
	drop if local_unit==.
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", replace
restore

preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep hhid parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", nogen keep(1 3)
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight_pop_rururb], by (region local_unit)
	ren sqmeters_per_unit sqmeters_per_unit_region
	ren observations obs_region
	lab var sqmeters_per_unit_region "Square meters per local unit (median value for this region)"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", replace
restore

preserve
	replace area_sqmeters_gps=. if area_sqmeters_gps<0
	keep hhid parcel_id field_id area local_unit area_sqmeters_gps
	merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", nogen keep(1 3)
	gen sqmeters_per_unit = area_sqmeters_gps/area
	gen observations = 1
	collapse (median) sqmeters_per_unit (count) observations [aw=weight_pop_rururb], by (local_unit)
	ren sqmeters_per_unit sqmeters_per_unit_country
	ren observations obs_country
	lab var sqmeters_per_unit_country "Square meters per local unit (median value for the country)"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", replace
restore

*Now creating area - starting with sq meters
gen area_meas_hectares = area_sqmeters_gps/10000
recode area_meas_hectares (0=.)
gen gps_meas=area_meas_hectares!=.
gen field_size=area_meas_hectares 

*For rest of units, we need to use the conversion factors
merge m:1 region zone woreda local_unit using "$Ethiopia_ESS_W4_temp_data/ET_local_area_unit_conversion.dta", gen(conversion_merge) keep(1 3)
replace field_size = area if local_unit==1 & field_size==.
replace field_size = area/10000 if local_unit==2 & field_size==. 
replace field_size = area*conversion/10000 if !inlist(local_unit,1,2) & conversion != . & field_size==. 

*Using our own created conversion factors for still missings observations
merge m:1 region zone local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_zone.dta", nogen
replace field_size = (area*(sqmeters_per_unit_zone/10000)) if local_unit!=11 & field_size==. & obs_zone>=10		
merge m:1 region local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_region.dta", nogen
replace field_size = (area*(sqmeters_per_unit_region/10000)) if local_unit!=11 & field_size==. & obs_region>=10
merge m:1 local_unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_area_lookup_country.dta", nogen
replace field_size = (area*(sqmeters_per_unit_country/10000)) if local_unit!=11 & field_size==.
count if area!=. & field_size==.
lab var area_meas_hectares "Field area measured in hectares, with missing obs imputed using local median per-unit values"
lab var field_size "Field area measured in hectares, with missing replaced with farmer reported area, some imputed using local median per-unit values"
drop if hhid == ""
merge 1:1 holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers.dta", nogen
gen field_size_male = field_size if dm_gender==1
gen field_size_female = field_size if dm_gender==2
gen field_size_mixed = field_size if dm_gender==3

preserve
bysort holder_id hhid parcel_id field_id: gen dup = cond(_N==1,0,_n)
tab dup 
keep hhid holder_id parcel_id field_id agland cultivated field_size area_meas_hectares* gps_meas s3q04
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", replace
restore

/* Land Size Denominators: Several in use depending on measurement 
parcel_area.dta:	Total area @ parcel level  //Not used, but left in for reference.
farm_area: 			Sum of all cultivated parcels 
land_size:		Sum of all cultivated parcels (the same as farm_area, dropped)
fields_agland: 		Cultivated, prepared for Belg, pasture, or fallow; 
					NOT forest, homestead, and other/rented out (field level)  //Not used, dropped
farmsize_all_agland: As above, household level
land_size_total:	All land owned or used, including rented in/out parcels (household level)
*/

*Parcel Area
preserve
keep cultivated field_size hhid holder_id parcel_id field_id //we should be at unique fields at this point, but if not. 
keep if cultivated==1
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_sizes.dta", replace
lab var cultivated "1= Field was cultivated in this data set"
collapse (sum) parcel_size = field_size, by(hhid holder_id parcel_id)
lab var parcel_size "Parcel area measured in hectares with GPS, with missing replaced with farmer reported area"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_parcel_area.dta", replace //This is never used for anything but we have it if we want it
restore 

gen farm_area = field_size * cultivated 
gen farm_size_agland = field_size*agland
collapse (sum) farm_area farm_size_agland land_size_total = field_size, by(hhid)
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
lab var land_size_total "Total land size in hectares, including forests, pastures, and homesteads" //Notably, this should include rented out plots but because we don't have measurements, they're not included. 
//assert farm_size_agland==land_size_total  //Mainly greater due to counting homesteads in the latter 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_size.dta", replace

//Files farmsize_all_agland, land_size_total, and land_size_all are no longer needed 


****Conversion Factors 
capture confirm file "$Ethiopia_ESS_W4_temp_data/Crop_CF_Wave4.dta"
	if !_rc {
	use "$Ethiopia_ESS_W4_temp_data/Crop_CF_Wave4.dta", clear
	ren unit_cd unit
	ren mean_cf_nat nat_cf
	gen mean_cf5 = mean_cf99
	la var mean_cf5 "CONVERSION FACTOR - SOMALIE"
	gen mean_cf13 = mean_cf99
	la var mean_cf5 "CONVERSION FACTOR - HARARI"
	gen mean_cf15 = mean_cf99
	la var mean_cf5 "CONVERSION FACTOR - DIRE DAWA"
	drop mean_cf99
	reshape long mean_cf, i(crop_code unit note nat_cf) j(region)
	ren mean_cf conversion
	preserve 
	keep if unit==51 | unit==53 
	collapse (mean) conversion nat_cf, by(crop_code region)
	gen unit=52
	tempfile med_chinet
	save `med_chinet'
	restore
	
	append using `med_chinet'
	preserve
	collapse (mean) gen_conversion=conversion, by(unit region) //this isn't perfect but it's a rough estimate of the capacity of the unit when the crop code is unknown
	tempfile generic_units
	save `generic_units'
	restore
	fillin crop_code unit region
	ren _fillin est_cf //use this to control whether you use the unit conversions from the estimated conversion factors. 
	merge m:1 unit region using `generic_units', nogen
	replace conversion = gen_conversion if conversion==.
	drop gen_conversion
	order region crop_code unit nat_cf conversion note
	duplicates tag region crop_code unit, gen(dups)
	drop if crop_code==74 & unit==62 & conversion>5 //8 observations deleted
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cf.dta" , replace
	}
	
	else {
	di as error "Crop conversion factor file not present; retrieve from WB download or use a crop conversion factor file from another ESS survey wave."
	}

	
*****************************************
*ALL PLOTS
*****************************************
	***************************
	*Crop Values 
	***************************
	* Section 11 includes perm crops
	use "${Ethiopia_ESS_W4_temp_data}/sect11_ph_w4.dta", clear 
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq06 kebele
	ren saq07 ea
	ren saq14 rural
	
	* Note that variable names are inconsistent in number and name between ESS Waves
	ren s11q01 crop_code
	keep if s11q07==1 // Did you sell any crop? Interested in the value of quantity sold.
	ren s11q03a1 qty_harv
	ren s11q03a2 unit_harv
	ren s11q11a qty_sold
	ren s11q11b unit //unit sold
	drop if unit == . // 6 obs dropped
	replace unit = unit_harv if hhid=="070205088801202011" & crop_code==72 //One apparent typo
	// ren s11q11b_os unit_os // MGM 4.1.2024: 69 o/s obs - can backfill later
	ren s11q12 val_sold // actual value received for qty/unit of crop
	ren s11q27a percent_sold // question phrased differently in W4/W5. "proportion of stored crop will be saved for sale"
	drop if val_sold==0 | val_sold==. // 23 observations dropped

	keep hhid region zone woreda kebele ea rural crop_code qty_sold unit val_sold qty_harv unit_harv
	
	merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", nogen keepusing(weight*) keep(1 3) // MGM 4.1.2024: all 2,743 observations matched

	//bys ea hhid kebele woreda rural zone region : gen temp_hhid = _n //bandaid fix for now
	collapse (sum) val_sold qty_sold qty_harv, by(hhid region zone woreda kebele ea crop_code unit unit_harv weight*)
	gen price_unit = val_sold/qty_sold
	gen obs=price_unit!=.
	
	foreach i in region zone woreda kebele ea hhid {
		preserve
		collapse (median) price_unit_`i'=price_unit (rawsum) obs_`i'_price=obs [aw=weight_pop_rururb], by (`i' unit crop_code)
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	
	preserve 
		collapse (median) price_unit_country = price_unit (rawsum) obs_country_price=obs [aw=weight_pop_rururb], by(crop_code unit)
		tempfile price_unit_country_median
		save `price_unit_country_median'
	restore

	merge m:1 region crop_code unit using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cf.dta", keep (1 3)
	replace conversion=1 if unit==1 // kgs
	replace conversion=100 if unit==3 & _merge==1
	gen qty_kg = qty_sold*conversion
	gen price_kg = val_sold/qty_kg
	drop if price_kg==.
	
	foreach i in region zone woreda kebele ea hhid {
		preserve
		collapse (median) price_kg_`i'=price_kg (rawsum) obs_`i'_pkg=obs [aw=weight_pop_rururb], by (`i' crop_code)
		tempfile price_kg_`i'_median
		save `price_kg_`i'_median'
		restore
	}
	
	preserve
		collapse (median) price_kg_country = price_kg (rawsum) obs_country_pkg=obs [aw=weight_pop_rururb], by(crop_code)
		tempfile price_kg_country_median
		save `price_kg_country_median'
	restore
	
	collapse (sum) qty_harv qty_sold val_sold, by(hhid crop_code unit unit_harv)
	la var qty_harv "Quantity Harvested" 
	la var qty_sold "Quantity Sold" 
	la var val_sold "Value of Quantity Sold"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_vals_hhids.dta" , replace 
	
	***************************
	*Plot Variables 
	***************************		
	use "${Ethiopia_ESS_W4_temp_data}/sect9_ph_w4", clear //renaming variables to make merge work (below)
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq06 kebele
	ren saq07 ea
	ren s9q01 crop_name
	ren s9q00b crop_code
	gen season_ph=1
	tempfile sect9_ph_w4
	save `sect9_ph_w4'

	use "${Ethiopia_ESS_W4_temp_data}/sect4_pp_w4.dta", clear
	ren saq01 region
	ren saq02 zone
	ren saq03 woreda
	ren saq06 kebele
	ren saq07 ea
	ren s4q01a crop_name1
	ren s4q01b crop_code1 //crop_code1 for now - checking for problems with upcoming merge
	gen season_pp=1
	
	merge 1:1 hhid holder_id parcel_id field_id crop_id using `sect9_ph_w4', nogen	
	gen use_imprv_seed = (s4q11 == 2) | (s4q11 == 3) //2=improved/new; 3=improved from prev year; 4=improved/recycled

	//Reconciling a few cases where crop_codes are not consistent across pp and ph data
	gen mismatch = crop_code!=crop_code1
	replace crop_code=crop_code1 if crop_code==. & mismatch==1 //630 changes
	replace crop_code1=crop_code if crop_code1==. & mismatch==1 //163 changes
	gen crop_code_r=. //crop_code fix
	replace crop_code_r = min(crop_code1, crop_code) if (crop_code1 > 97 | crop_code > 97) & mismatch==1 //52 occurences where "OTHER CROP" was listed in either ph or pp but not the other
	replace crop_code=crop_code_r if crop_code>97 & crop_code_r!=. //8 changes
	replace crop_code1=crop_code_r if crop_code1>97 & crop_code_r!=. //19 changes
	*Kariya is a jalapeno
	replace crop_code1=59 if strpos(crop_name1, "ariya") & mismatch==1 //4 changes
	replace crop_code=59 if strpos(crop_name, "ariya") & mismatch==1 //0 changes
	*Buna is coffee
	replace crop_code1=72 if strmatch(crop_name1, "buna") & mismatch==1 //3 changes
	replace crop_code=72 if strmatch(crop_name, "buna") & mismatch==1 //0 changes
	*Muz is banana
	replace crop_code1=42 if strmatch(crop_name1, "muz") & mismatch==1 //1 change
	replace crop_code=42 if strmatch(crop_name, "muz") & mismatch==1 //0 change
	replace mismatch=0 if crop_code==crop_code1 //826 real changes
	drop if mismatch==1 //58 observations deleted - WB needs to fix cases where crop_name and crop_code are mislabeled or crop_ids swap between pp and ph (MAIZE CHAT) (HORSEBEANS PUMPKINS) (RED PEPPER GREEN PEPPER) (PAPAYA MANGO)
	drop crop_code1
	
	*Fix crop_code labels
	la def crop_code_lab 1 "barley" 2 "maize" 3 "millet" 4 "oats" 5 "rice" 6 "sorghum" 7 "teff" 8 "wheat" 9 "mung bean" 10 "cassava" 11 "chick peas" 12 "haricot beans" 13 "horse beans" /*=fava bean*/ 14 "lentils" 15 "field peas" 16 "vetch" /*ALT: not a food crop*/ 17 "gibto" /*ALT: White lupin*/ 18 "soybeans" 19 "kidney beans" 20 "fennel" 21 "castor beans" 22 "cottonseed" 23 "flaxseed" 24 "groundnuts" 25 "nueg" /*Nyjerseed, feed crop*/ 26 "rapeseed" /*i.e. canola*/ 27 "sesame" 28 "sunflower" 29 "mego" 30 "savory" 31 "black cumin" /*Nigella*/ 32 "black pepper" 33 "cardamom" 34 "chili pepper" 35 "cinnamon" 36 "fenugreek" 37 "ginger" 38 "red pepper" 39 "tumeric" 40 "white cumin"  41 "apples" 42 "bananas" 43 "grapes" 44 "lemons" 45 "mandarins" 46 "mangos" 47 "oranges" 48 "papaya" 49 "pineapple" 50 "citron" 51 "beer root" /*I cannot find any English-language references to this outside of LSMS - is it supposed to be beetroot? */ 52 "cabbage" 53 "carrot" 54 "cauliflower" 55 "garlic" 56 "kale" 57 "lettuce" 58 "onion" 59 "green pepper" 60 "potatoes" 61 "pumpkin" 62 "sweet potato" 63 "tomatoes" 64 "godere" /*ALT: Likely taro, should update crop codes to reduce regional variants like this one */ 65 "guava" 66 "peach" 67 "mustard" 68 "feto" /*garden cress?*/ 69 "spinach" 70 "green beans" 71 "chat" 72 "coffee" 73 "cotton" 74 "enset" 75 "gesho" /*buckthorn*/ 76 "sugarcane" 77 "tea" 78 "tobacco" 79 "coriander" 80 "sacred basil" /* tulsi */ 81 "rue" 82 "gishita" /*soursop*/ 83 "watermelon" 84 "avocado" 85 "forage" /*clarifying this from "Grazing land" */ 86 "temporary gr" /*Temporary forage? Not clear what this is*/ 97 "pijapin" /*Doesn't appear outside of LSMS, no obs */ 98 "other root crop" /*Cut off by char limit?*/ 99 "other land" 108 "amboshika" /*skipping 100-112, no obs, no idea what some of these are. Couldn't find any database entries with NL20F. */ 112 "kazmir" /*white sapote*/ 113 "strawberry" 114 "shiferaw" /*moringa*/ 115 "other fruit" 116 "timez kimem" /*Spice?*/ 117 "other spices" 118 "other pulses" 119 "other oilseed" 120 "other cereal" 121 "other case crop" /*=cover crop?*/ 123 "other vegetable"
la val crop_code crop_code_lab 

	* GENERATE PURESTAND
	ren s4q02 crop_stand_pp
	ren s9q02 crop_stand_ph
	gen perm_tree = inlist(crop_code, 10, 35, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 65, 66, 72, 74, 75, 76, 82, 84, 112, 115) //MGM 4.11.2024: why are we classifying other spices as perm_tree? 
	lab var perm_tree "1 = Tree or permanent crop"
	
	gen month_planted = s4q13a
	gen year_planted = s4q13b 
	//ALT: Some reports of planting in ETH calendar year 2011 after postplanting survey, which ended in month 2
	replace month_planted = . if year_planted==2011 & month_planted > 2 
	
 	replace month_planted = month_planted + 13 if year_planted == 2006 //13 months in Ethiopia 
	replace month_planted = 0 if year_planted > 2005 // to account for crops planted before 2005 season 
	gen month_harvest = s9q08b + 13 // all harvest occured in 2006
	// need to account for missings here
	recode month_planted (.=0)
	recode month_harvest (.=999)
	gen months_grown = month_harvest - month_planted if perm_tree == 0
	replace months_grown = . if months_grown < 1 | month_planted == . | month_harvest == .

	gen lost_drought = s9q14==2 //too little rain
	replace lost_drought = 1 if lost_drought == 0 & s4q09 == 2 //too little rain 
	gen lost_flood = s9q14==1 | s9q14==7 //too much rain, floods
	replace lost_flood = 1 if lost_flood == 0 & (s4q09 == 1 | s4q09 == 8) //too much rain, floods
	gen lost_crop = (s9q15==100 | s4q10 ==100)
	
	gen reason_loss = s9q14 // What was the main cause of the damag
	bys hhid holder_id parcel_id field_id : gen n_crops=_N
	gen purestand=n_crops==1
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"

	* MONTHS_GROWN, HA_PLANTED, HA_HARVEST, AND NUMBER_TREES_PLANTED (PER CROP PER FIELD)
	ren s4q03 perc_planted_pp
	ren s9q03 perc_planted_ph
	ren s9q11 perc_plant_harv // what percent of the planted area has been harvested?
	* Backfilling some missing perc_planted data
	recode perc_planted_pp perc_planted_ph (0=.)
	replace perc_planted_pp=perc_planted_ph if perc_planted_pp==. & perc_planted_ph!=. // 82 real changes
	gen percent_field=perc_planted_pp/100
	replace perc_planted_pp=1 if perc_planted_pp==. & purestand==1
	* MGM 5.1.2024: Noting that roughly 20% of observations have discrepancies between percent planted reported in pp vs. ph. Whether or not a plot had damage was equally distributed across all categories (pp<ph, pp=ph, and pp>pp). Also, there did not seem to be a relationship between % damage and difference in reported perc_planted across pp and ph data. This indicates that there is no particular bias... so we are choosing to use pp on the premise that it may be more reliable than ph. 
	ren s9q10 less_than_plant // was area planted less than area harvested?
	rename s4q16 number_trees_planted //this var name feels like a misnomer because they exist but were not necessarily planted that year
	gen pct_harvest=perc_plant_harv/100
	replace pct_harvest = 1 if less_than_plant==2
	replace pct_harvest=. if s9q04==2  //Not really possible to tell whether the crop was not harvested because it was lost or because it wasn't harvest season. 
	merge m:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3) keepusing(field_size cultivated gps_meas) // 25 not matched from master 
	bys hhid holder_id parcel_id field_id : egen total_percent = total(percent_field)
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0 // 192 changes
	replace percent_field = 1 if percent_field > 1 & purestand == 1 // 63 changes
	
	gen ha_planted=field_size*percent_field 
	gen ha_harvest= ha_planted*pct_harvest
	
* GENERATE QUANT_HARV_KG, VALUE_HARVEST (PER CROP PER FIELD)
	* CROP PRICES / VALUES
	ren s9q05a qty_harv
	ren s9q05b unit //2,767 obs have missing unit information
	ren s9q06 kg_est
	replace qty_harv=kg_est if (qty_harv==. | unit==.) & kg_est!=. // 5 changes
	replace unit=1 if (qty_harv==. | unit==.) & kg_est!=. // 4 changes
	replace unit=142 if s9q05b_os=="Piece/number"
	replace unit=143 if s9q05b_os=="Piece/number large"
	replace unit=72 if s9q05b_os=="Festal" | s9q05b_os=="Festal Meduim" 
	replace unit=73 if s9q05b_os=="Festal Large"
	replace unit=71 if s9q05b_os=="Festal Small"
	replace unit=102 if s9q05b_os=="Kubaya/Cup" | s9q05b_os=="Kubaya/Cup Medium"
	replace unit=103 if s9q05b_os=="Kubaya/Cup large"
	replace unit=101 if s9q05b_os=="Kubaya/Cup Small"
	replace unit=32 if s9q05b_os=="Birchiko"
	replace unit=33 if s9q05b_os=="Birchiko Large"
	// keep region zone woreda kebele ea hhid holder_id parcel_id field_id crop_code s4q21a qty_harv unit kg_est

	merge m:1 crop_code unit region using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cf.dta", nogen keep(1 3)
	replace conversion = 1 if conversion==. & unit==1
	replace conversion= 100 if conversion==3 & unit==3 
	replace conversion = 25 if conversion == . & unit == 121 // madaberias (small)
	replace conversion = 50 if conversion == . & unit == 122 // madaberias (medium)
	replace conversion = 100 if conversion == . & unit == 123 // madaberias (large)
	
	* Merge in price per unit and price per kg - generated from S11
	foreach i in region zone woreda kebele ea hhid {
		merge m:1 `i' crop_code unit using `price_unit_`i'_median', nogen keep(1 3)
		merge m:1 `i' crop_code using `price_kg_`i'_median', nogen keep(1 3)
	}
	merge m:1 unit crop_code using `price_unit_country_median', nogen keep(1 3)
	merge m:1 crop_code using `price_kg_country_median', nogen keep(1 3)
	
	gen price_unit = . 
	gen price_kg = .
	
	foreach i in region zone woreda kebele ea {  
		replace price_unit = price_unit_`i' if obs_`i'_price>9 & price_unit_`i'!=.
		replace price_kg = price_kg_`i' if obs_`i'_pkg>9 & price_kg_`i' != .
		
	}
	
	replace price_unit=price_unit_country if price_unit==.	
	replace price_kg=price_kg_country if price_kg==.
	ren price_unit_hhid price_unit_hh 
	ren price_kg_hhid price_kg_hh 
	replace price_unit_hh=price_unit if price_unit_hh==.
	replace price_kg_hh=price_kg if price_kg_hh==.
	
	* QTY KGS
	gen quant_harv_kg = qty_harv if unit == 1
	replace quant_harv_kg = qty_harv * conversion if unit > 1
	
	* VALUE HARVEST
	gen value_harvest_hh = qty_harv*price_unit_hh
	replace value_harvest_hh =quant_harv_kg*price_kg_hh if value_harvest_hh==.
	gen value_harvest = qty_harv*price_unit if value_harvest==. & unit > 1
	replace value_harvest = quant_harv_kg*price_kg if value_harvest==.
	//still missing a fair few obs from the os units column. 
	
	collapse (sum) val* quant* ha_planted ha_harvest number_trees_planted percent_field (max) months_grown lost*, by(region zone woreda kebele ea hhid holder_id parcel_id field_id purestand  /*crops_plot*/ crop_code cultivated field_size gps_meas use_imprv_seed)
	
	*AgQuery
		bys hhid holder_id parcel_id field_id : egen percent_area = sum(percent_field)
		bys hhid holder_id parcel_id field_id : gen percent_inputs = percent_field / percent_area
		drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
		
	merge m:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers.dta", nogen keep(1 3) keepusing(dm*) // 11 not matched

	order region zone woreda kebele ea hhid holder_id parcel_id field_id crop_code
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", replace

	//AT: moving this up here and making it its own file because we use it often below
	collapse (sum) ha_planted, by(hhid holder_id parcel_id field_id) //Use planted area for hh-level expenses 
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_planted_area.dta", replace

	/*
	*CODE USED TO DETERMINE THE TOP CROPS
	use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
	merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", keep(1 3) // 75 HHs not matched
	gen area= ha_planted*weight_pop_rururb 
	collapse (sum) area, by (crop_code)
	*/

********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
use "${Ethiopia_ESS_W4_temp_data}/sect11_ph_W4.dta", clear
ren saq01 region
ren s11q01 crop_code
ren s11q12 sales_value
recode sales_value (.=0)
ren s11q11a quantity_sold
ren s11q11b unit_quantity_sold
*renaming unit code for merge 
ren unit_quantity_sold unit
*merging in conversion factors
merge m:1 crop_code unit region using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cf.dta", gen(cf_merge)
gen kgs_sold= quantity_sold*conversion
collapse (sum) sales_value kgs_sold, by (hhid crop_code)
lab var sales_value "Value of sales of this crop"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropsales_value.dta", replace 

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
collapse (sum) value_harvest , by (hhid crop_code) 
merge 1:1 hhid crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropsales_value.dta"
recode  value_harvest sales_value  (.=0) // go back and just call this value_cropsales from the start
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
collapse (sum) value_harvest value_crop_sales, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta", replace 
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Ethiopia_ESS_W4_temp_data}/sect11_ph_W4.dta", clear
ren s11q01 crop_code
merge m:1 hhid crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta", nogen keep(1 3)
foreach var in s11q21a1 s11q21a2 s11q21a3 {
	summ `var',d 
}
ren s11q21a3 share_lost
recode share_lost (.=0)
gen crop_value_lost = value_crop_production * (share_lost/100)
ren s11q17 value_transport_cropsales
recode value_transport_cropsales (.=0)
collapse (sum) crop_value_lost value_transport_cropsales, by (hhid)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_losses.dta", replace

********************************************************************************
* CROP EXPENSES  
********************************************************************************

	*********************************
	* 			LABOR				*
	*********************************
	// Joaquin 03.14.2023: Adapting to Nigeria. This is useful for merges below. Goal is to generate hh_cost_labor.dta 
	
use "${Ethiopia_ESS_W4_temp_data}/sect3_pp_w4.dta", clear // hired labor post planting 
	ren s3q30a numberhiredmale
	ren s3q30d numberhiredfemale
	ren s3q30g numberhiredchild
	ren s3q30b dayshiredmale
	ren s3q30e dayshiredfemale
	ren s3q30h dayshiredchild
	ren s3q30c wagehiredmale
	ren s3q30f wagehiredfemale
	ren s3q30i wagehiredchild 
	ren s3q31a numbernonhiredmale
	ren s3q31c numbernonhiredfemale
	ren s3q31e numbernonhiredchild
	ren s3q31b daysnonhiredmale
	ren s3q31d daysnonhiredfemale
	ren s3q31f daysnonhiredchild
	ren saq01 region 
	ren saq02 zone 
	ren saq03 woreda 
	ren saq06 kebele 
	ren saq07 ea 							
	keep hhid holder_id parcel_id field_id *hired* 
	gen season="pp"
tempfile postplanting_hired
save `postplanting_hired'

use "${Ethiopia_ESS_W4_temp_data}/sect10_ph_w4.dta" , clear // hired labor post harvest 
	ren s10q01a numberhiredmale 
	ren s10q01b dayshiredmale
	ren s10q01c wagehiredmale //Wage per person/per day
	ren s10q01d numberhiredfemale
	ren s10q01e dayshiredfemale
	ren s10q01f wagehiredfemale
	ren s10q01g numberhiredchild
	ren s10q01h dayshiredchild
	ren s10q01i wagehiredchild
	ren s10q03a numbernonhiredmale
	ren s10q03b daysnonhiredmale
	ren s10q03c numbernonhiredfemale
	ren s10q03d daysnonhiredfemale
	ren s10q03e numbernonhiredchild
	ren s10q03f daysnonhiredchild
	ren saq01 region 
	ren saq02 zone 
	ren saq03 woreda 
	ren saq06 kebele 
	ren saq07 ea 
	keep region zone woreda kebele ea hhid holder_id parcel_id field_id *hired*  // Nigeria W3 do file keeps crop_code because of in-kin payments. No in-kind payments here.  
	collapse (sum) *hired*, by(region zone woreda kebele ea hhid holder_id parcel_id field_id)
	gen season="ph"
	tempfile postharvesting_hired
	preserve 	
		sort region zone woreda kebele ea hhid holder_id parcel_id field_id season
		quietly by region zone woreda kebele ea hhid holder_id parcel_id field_id season:  gen dup = cond(_N==1,0,_n)
		tab dup 
	restore 
save `postharvesting_hired'
	
append using `postplanting_hired' // at field level 

unab vars : *female
local stubs : subinstr local vars "female" "", all
display "`stubs'"

reshape long `stubs', i(region zone woreda kebele ea hhid holder_id parcel_id field_id season) j(gender) string
	sort region zone woreda kebele ea hhid holder_id parcel_id field_id season
reshape long number days wage, i(hhid holder_id parcel_id field_id gender season) j(labor_type) string 
	gen val = days*number*wage

merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", nogen keep(1 3) keepusing(weight*)
merge m:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares)
gen fieldweight = weight_pop_rururb*area_meas_hectares
recode wage (0=.)
gen obs=wage!=.

*Median wages
**# Bookmark #1
foreach i in region zone woreda kebele ea hhid {
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
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_w4.dta", clear 
	ren s3q29a pid1
	ren s3q29e pid2 
	ren s3q29i pid3 
	ren s3q29m pid4
	ren s3q29b weeks_worked1 
	ren s3q29f weeks_worked2 
	ren s3q29j weeks_worked3 
	ren s3q29n weeks_worked4
	ren s3q29c days_week1
	ren s3q29g days_week2 
	ren s3q29k days_week3 
	ren s3q29o days_week4
keep hhid holder_id parcel_id field_id pid* weeks_worked* days_week*
preserve
	bysort hhid holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
gen season="pp"
tempfile postplanting_family
save `postplanting_family'

use "${Ethiopia_ESS_W4_temp_data}/Sect10_ph_w4.dta" , clear // Joaquin 04.03.23: Data is at crop level. Collapse at field level?  
	ren s10q02a pid1
	ren s10q02b weeks_worked1 
	ren s10q02c days_week1
	ren s10q02e pid2 
	ren s10q02f weeks_worked2 
	ren s10q02g days_week2 
	ren s10q02i pid3 
	ren s10q02j weeks_worked3
	ren s10q02k days_week3 
	ren s10q02m pid4
	ren s10q02n weeks_worked4
	ren s10q02o days_week4

	keep hhid holder_id parcel_id field_id pid* weeks_worked* days_week*
preserve
	bysort hhid holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
collapse pid* weeks_worked* days_week*, by(hhid holder_id parcel_id field_id)
gen season="ph"
tempfile postharvesting_family
save `postharvesting_family'

// Other labor 
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_w4.dta", clear // Joaquin 03.24.23: Data is at field level 
	ren s3q31a numberothermale
	ren s3q31b daysothermale
	ren s3q31c numberotherfemale
	ren s3q31d daysotherfemale
	ren s3q31e numberotherchild
	ren s3q31f daysotherchild
keep hhid holder_id parcel_id field_id number* days* 
gen season = "pp"
tempfile postplanting_other 
preserve
	bysort hhid holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
save `postplanting_other'

use "${Ethiopia_ESS_W4_temp_data}/sect10_ph_w4.dta" , clear // Joaquin 03.24.23: Data is at crop level. Collapse at field level?  
	ren s10q03a numberothermale
	ren s10q03b daysothermale
	ren s10q03c numberotherfemale
	ren s10q03d daysotherfemale
	ren s10q03e numberotherchild
	ren s10q03f daysotherchild
keep hhid holder_id parcel_id field_id number* days* 
collapse number* days*, by(hhid holder_id parcel_id field_id)
preserve
	bysort hhid holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
gen season = "ph"
tempfile postharvesting_other 
save `postharvesting_other'

// Members 
use "$Ethiopia_ESS_W4_temp_data/sect1_pp_w4.dta", clear
	ren s1q00 pid
	drop if pid==.
	preserve 
		bysort hhid pid: gen dup=cond(_N==1,0,_n)
		tab dup 
		bysort hhid pid: egen obs_num = sum(1) 
		tab obs_num 
		tab obs_num dup // Joaquin 04.03.24: Every duplicate is associated with only one person. 
	restore
	ren s1q02 age
	gen male = s1q03==1
	rename saq01 region 
	rename saq02 zone
	rename saq03 woreda
	rename saq06 kebele
	rename saq07 ea
	keep region zone woreda kebele ea hhid pid age male
	collapse (first) age male, by(region zone woreda kebele ea hhid pid)
	codebook male 
tempfile members
save `members', replace 

// Generate long files 
// Joaquin 03.16.23: Use all above labor tempfiles to generate:  plot_labor_long.dta, plot_labor.dta, hh_cost_labor.dta
use `postplanting_family', clear 
append using `postharvesting_family'
preserve 
	bysort hhid holder_id parcel_id field_id season: gen dup = cond(_N==1,0,_n)
	tab dup 
restore 
reshape long pid weeks_worked days_week, i(hhid holder_id parcel_id field_id season) j(colid) string 
gen days=weeks_worked*days_week
drop if days==.
merge m:1 hhid pid using `members', nogen keep(1 3)
gen gender="child" if age<16
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
keep region zone woreda kebele ea hhid holder_id parcel_id field_id season gender days labor_type
// Joaquin 034.03.23: The is no *exchange labor* in ETH W3. 
foreach i in region zone woreda kebele ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) // 
	gen wage=wage_hhid
foreach i in region zone woreda kebele ea {
	replace wage = wage_`i' if obs_`i' > 9
}

gen val = wage*days
append using `all_hired'
keep hhid holder_id parcel_id field_id season days val labor_type gender number
drop if val==.&days==.
merge m:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers", nogen keep(1 3) keepusing(dm_gender)
codebook dm_gender // No missing values for dm_gender.
// APN 05.02.24: No missing values for dm_gender. Commenting out the codes the preserve-restore checks if the hhs with missing dm_gender are part of the hh module.
/*	keep if dm_gender==.  
	recode dm_gender (.=4) 
	collapse (first) dm_gender, by(hhid)
	tab dm_gender 
	merge 1:1 hhid using "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_hhids.dta" // Joaquin 04.05.23: HHs with dm_gender missing are not part of the hh module.   
restore 
*/
replace dm_gender = 1 if dm_gender==. // Joaquin 07.07.23: Imputing male for dm_gender missing values 

collapse (sum) number val days, by(hhid holder_id parcel_id field_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Birr)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_labor_long.dta",replace

preserve
	collapse (sum) labor_=days, by (hhid holder_id parcel_id field_id labor_type)
	reshape wide labor_, i(hhid holder_id parcel_id field_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_labor_days.dta",replace //AgQuery
restore

preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	//append using `inkind_payments'
	collapse (sum) val, by(hhid holder_id parcel_id field_id exp dm_gender)
	codebook dm_gender 
	gen input="labor"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_labor.dta", replace //this gets used below.
restore	

//And now we go back to wide
collapse (sum) val, by(hhid holder_id parcel_id field_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid holder_id parcel_id field_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(hhid holder_id parcel_id field_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
codebook dm_gender2 
ren val* val*_
reshape wide val*, i(hhid holder_id parcel_id field_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_labor.dta", replace

****************************************************** ***************************
* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES * // Added Joaquin 03.14.2023
****************************************************** ***************************
* rental costs not included; survey does not ask for plough spending

	*** Pesticides/Herbicides/Animals/Machines
use "$Ethiopia_ESS_W4_temp_data/sect4_pp_w4.dta", clear 
	rename saq01 region 
	rename saq02 zone
	rename saq03 woreda
	rename saq06 kebele
	rename saq07 ea
	
	ren s4q01b crop_code
	rename	s4q05 usepestexp // Pesticide dummy 
	rename	s4q07 usefungexp // Fungicide dummy 
	rename	s4q06 useherbexp  // Herbicide dummy 

	ren s4q05a qtypestexp
	ren s4q05b unitpestexp
	ren s4q06a qtyherbexp
	ren s4q06b unitherbexp
	ren s4q07a qtyfungexp
	ren s4q7b unitfungexp

	foreach i in herbexp pestexp fungexp {
		replace qty`i'=qty`i'/1000 if unit`i'==3 & qty`i'>9 
		replace unit`i'=1 if unit`i'==3
	}
	
	keep crop_code region zone woreda kebele ea hhid holder_id parcel_id field_id *exp
	
	duplicates drop region zone kebele ea hhid holder_id parcel_id field_id qtypestexp qtyherbexp qtyfungexp, force
	collapse (sum) qty* (min) unit*, by(region zone kebele ea hhid holder_id parcel_id field_id) //preferring kg over grams and liters in instances of conflict. (126 obs compressed here)
	
	
	foreach i in herbexp pestexp fungexp {
		replace qty`i'=qty`i'/1000 if unit`i'==3 & qty`i'>9 //Many people reporting 1-5 grams of pesticide/herbicide on their plot - assuming this is likely a typo (and values bear this out) //APN 05. 08. 2024 - Lots of respondents also reporting 0.25 - 8 grams of pesticide/herbicide in ESS W5 too. 
		replace unit`i'=1 if unit`i'==3
	}
	
	unab vars : *exp
	local stubs : subinstr local vars "exp" "", all
	display "`stubs'"
	reshape long `stubs', i(hhid holder_id parcel_id field_id) j(exp) string
	reshape long qty unit, i(hhid holder_id parcel_id field_id) j(input) string
	tempfile field_inputs
	save `field_inputs'
	
	***Fertilizer
	use "$Ethiopia_ESS_W4_temp_data/sect3_pp_w4.dta", clear // Joaquin 04.06.23: This module contains fertilizer info. 

	preserve
	// Urea
	gen usefertexp1 = 1 if s3q21==1 
	//gen itemcodefertexp = 1 if usefertexp1 == 1 
	gen qtyfertexp1 = s3q21a
	gen unitfertexp1 = 1 if s3q21==1 // Qty is in kilos 
	gen valfertexp1 = s3q21d if s3q21==1
	replace valfertexp1 = subinstr(valfertexp1, ",", ".", 1)
	replace valfertexp1 = subinstr(valfertexp1, "o", "0", 1)
	destring valfertexp1, replace

	// DAP 
	gen usefertexp2 = 1 if s3q22==1 
	gen qtyfertexp2 = s3q22a
	gen unitfertexp2 = 1 if s3q22==1 // Qty is in kilos 
	gen valfertexp2 = s3q22d if s3q22==1 

	// NPS
	gen usefertexp3 = 1 if s3q23==1 
	gen qtyfertexp3 = s3q23a
	gen unitfertexp3 = 1 if s3q23==1 // Qty is in kilos 
	gen valfertexp3 = s3q23d if s3q23==1 

	// Other inorganic fertexpilizer  
	gen usefertexp4 = 1 if s3q24==1 
	gen qtyfertexp4 = s3q24a
	gen unitfertexp4 = 1 if s3q24==1 // Qty is in kilos 
	gen valfertexp4 = s3q24d if s3q24==1 

	// no org fert qty available
	// Manure
	gen usefertexp5 = 1 if s3q25==1 // No qty. Just dummy 
	
	// Compost
	gen usefertexp6 = 1 if s3q26==1 
	
	// Other organic 
	gen usefertexp7 = 1 if s3q27==1 
	
	keep use* qty* unit* val* hhid holder_id parcel_id field_id
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	display "`stubs'"
	reshape long `stubs', i(hhid holder_id parcel_id field_id) j(itemcode)
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	display "`stubs2'"
	reshape long `stubs2', i(hhid holder_id parcel_id field_id itemcode) j(exp) string 	
	reshape long use qty unit val, i(hhid holder_id parcel_id field_id itemcode exp) j(input) string
	//collapse (sum) qty* val*, by(hhid holder_id parcel_id field_id itemcode use)
	label define itemcodefert 1 "Urea" 2 "DAP" 3 "NPS" 4 "Other inorganic" 5 "Manure" 6 "Compost" 7 "Other organic"
	label values itemcode itermcodefert 
	replace input = "inorg" if itemcode>=1 & itemcode<=4 
	replace input = "orgfert" if itemcode>=5 & itemcode<=7 
	tempfile phys_inputs
	save `phys_inputs'
	restore
	
	*Irrigation and Tractor
	//the following section is mostly commented out, as W2 does not ask questions related to field-planting preparation (section 3 post planting w5) and irrigation is handled in "plot managers"
	//merge m:1 hhid holder_id using `rental_costs', nogen keep(1 3)
	//gen use_irrigation = pp_s3q12==1 //irrigation dummy
	gen use_mech_own  = s3q35==1
	gen use_mech_rent = s3q35==2
	gen use_hoe = s3q35==5
	gen use_anml_own = s3q35==3 //Counting own and borrowed livestock together for the purpose of explicit expenses. 
	gen use_anml_rent = s3q35==4
	/*merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W1_created_data}/Ethiopia_ESS_W1_planted_area.dta", nogen keep(1 3)
	//Values will be in rent/machine/hectare so we generate quantity = area
	gen qtymechexp = ha_planted if use_mech_rent ==1
	gen qtymechimp = ha_planted if use_mech_own  ==1
	gen qtyanmlimp = ha_planted if use_anml_own  ==1
	gen qtyanmlexp = ha_planted if use_anml_rent ==1
	gen qtyhoeexp = ha_planted if use_hoe == 1 
	//recode valirrigexp=0 if valirrigexp==.
	
	//gen qtyirrigexp = ha_planted if use_irrigation==1 & valirrigexp != 0 //"qty" for irrigation is planted area irrigated. 
	//gen qtyirrigimp = ha_planted if use_irrigation==1 & valirrigexp==0
	//Several instances of households reporting irrigation expenses but not reporting any plots under irrigation, about 291 plots that were irrigated without reported irrigation expenses. 
	gen qtyhoeimp = ha_planted if use_hoe == 1 & (valhoerent==0 | valhoerent==.) //difficult to fully impute here because we don't have any info on the relative proportion of owned/rented hoes. 

	foreach i in anml mech hoe /*irrig*/ {
		bys hhid : gen total_area_plan_`i' = sum(qty`i'exp)
			gen prop_`i'=qty`i'exp/total_area_plan_`i'
		}
		gen valanmlexp = prop_anml * valanmlrent 
		gen valmechexp = prop_mech * valmechrent 
		//gen valmechmaintexp = prop_mech * valmechmaint	
		gen valhoeexp = prop_hoe * valhoerent  
	
	drop valanmlrent valmechrent valmechmaint valhoerent 
	reshape long valmech valanml valhoe qtyanml qtymech qtyhoe, i(hhid holder_id parcel_id field_id) j(exp) string
	reshape long val qty, i(hhid holder_id parcel_id field_id exp) j(input) string
	gen itemcode=1 //irrelevant here.
	gen unit=1
	*/
	tempfile mech_inputs
	save `mech_inputs'
	
	** fieldrents 
	use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear 	
	//sort hhid holder_id parcel_id field_id 	
	//bysort hhid holder_id parcel_id field_id: gen dup = cond(_N==1,0,_n)
	collapse (first) field_size (sum) ha_planted value_harvest, by(hhid holder_id parcel_id field_id)	//APN 05.02.2024: using field_size instead of area_meas_hectares - Field area measured in hectares
	*ren field_size area_meas_hectares // APN.05.3.2024 Changing field size to area_meas_hectares
	//merge 1:1 hhid holder_id parcel_id field_id  using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", keep(1 3) keepusing(cultivated) nogen 

	preserve 
		use "$Ethiopia_ESS_W4_temp_data/sect2_pp_w4.dta", clear
		// Joaquin 04.26: NGA at plot level, ETH is parcel level. We need field-level data. 
		// Joaquin 04.26: Perhaps distribute price evenly across fields? Ask what to do about this.
		// Andrew 5/3/2023 : Imputations  
		egen valparrentexp = rowtotal(s2q10a s2q10b)
		// Joaquin 05.24.23: Need to add the share of payments 
		keep hhid holder_id parcel_id valparrentexp s2q10c
		tempfile parcelrents 
		save `parcelrents', replace 
		gen rental_cost_land = valparrentexp
		drop valparrentexp s2q10c
		save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_rental_parcel.dta", replace 
	restore 

	merge m:1 hhid holder_id parcel_id using `parcelrents', nogen 
	
	bysort hhid holder_id parcel_id: egen area_meas_hectares_parcel = sum(field_size)
	gen qtyfieldrentexp= field_size if (valparrentexp>0 & valparrentexp!=.) | (s2q10c>0 & s2q10c!=.)
	gen valfieldrentexp = (field_size/area_meas_hectares_parcel)*valparrentexp if valparrentexp>0 & valparrentexp!=. 
	replace valfieldrentexp = valfieldrentexp + (s2q10c/100)*value_harvest if valfieldrentexp!=. & s2q10c!=. & value_harvest!=. 
	replace valfieldrentexp = (s2q10c/100)*value_harvest if valfieldrentexp==. & s2q10c!=. & value_harvest!=. 
	
	gen qtyfieldrentimp = field_size if qtyfieldrentexp==.
	replace qtyfieldrentimp = ha_planted if qtyfieldrentimp==. & qtyfieldrentexp==.

	//keep if cultivate==1 //No need for uncultivated plots
	keep hhid holder_id parcel_id field_id qtyfieldrentexp* valfieldrentexp*
	
	gen usefieldrentexp = (qtyfieldrentexp>0 & qtyfieldrentexp!=.)
	
	reshape long usefieldrent valfieldrent qtyfieldrent, i(hhid holder_id parcel_id field_id) j(exp) string
	reshape long use val qty, i(hhid holder_id parcel_id field_id exp) j(input) string
	
	gen unit=(qty!=. & val!=.) 
	gen itemcode=1 //dummy var
	tempfile fieldrents
	save `fieldrents'
	
		** seeds // JM 06.04.23: We will just generate the necessary variables with missing values. We will use "${Ethiopia_ESS_W3_temp_data}/Post-Planting/sect4_pp_w4.dta" to get use_imprv_seed for person_ids. 

	use "${Ethiopia_ESS_W4_temp_data}/sect4_pp_w4.dta", clear // Joaquin 04.06.23: This module contains seed info. Seed use at field level. Only seed use. 
	// Andrew 5/3/2023: AgQuery+ does not track seed expenses 
	// Generate variables with missing for where infromation is missing 
	// We care about improved seed 
	gen itemcode = s4q11 // APN.05.03.2024 - traditional==1, improved==2 new, 3==improved saved from last year, 4==improved from last year production I will code options 2 - 4 as improved seeds.
	drop if itemcode==.
	gen exp = "exp" if itemcode==1 | itemcode==2 
	replace exp = "imp" if itemcode==3 | itemcode==4
	gen use = (itemcode!=.)
	gen qty = s4q11a if s4q11a!=. /*& s4q11b==.*/ //APN.05.03.2024 - ESS W5 collected quantity of improved seeds only in kilograms
*	replace qty = pp_s4q11b_b/1000 if pp_s4q11b_a==. & pp_s4q11b_b!=. 
*	replace qty = pp_s4q11b_a + pp_s4q11b_b/1000 if pp_s4q11b_a!=. & pp_s4q11b_b!=. 
	gen unit = 1 if qty!=. // 1 == kg 
	gen val = s4q12 // JM 09.11.23: Value is available ONLY for improved seeds 
	gen input = "seeds" if use==1 
	collapse (sum) use val qty, by(hhid holder_id parcel_id field_id exp input itemcode unit)
	replace qty = . if qty==0 & use==1 
	replace val = . if exp!="exp"  
	drop if itemcode ==. 
	//recode val (.=0) // Joaquin 6.12.23: Added this line-faq
	
	* Append // Joaquin 6.12.23: Added this sub-subsection
	
	append using `fieldrents'
	gen source_file = "fieldrents"
	append using `field_inputs'
	replace source_file = "field_inputs" if source_file == ""
	append using `phys_inputs'
	replace source_file = "phys_inputs" if source_file == ""
	append using `mech_inputs'
	replace source_file = "mech_inputs" if source_file == ""

	
	merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta",nogen keep(1 3) keepusing(weight*)
	merge m:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares)
	merge m:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers",nogen keep(1 3) keepusing(dm_gender)
	replace dm_gender = 1 if dm_gender == . // Joaquin 7.7.23: Obs are not presenst in field_decision_maker
	tempfile all_field_inputs
	merge m:1  hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3) keepusing(region zone woreda kebele ea) // Joaquin 7.6.23: Added to get variables: region zone woreda kebele ea	
	preserve
	//Need this for quantities and not sure where it should go.
	keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"herb") | strmatch(input,"pest") | strmatch(input,"fung") 
	 
	//label define itemcodefert 1 "Urea" 2 "DAP" 3 "NPS" 4 "Other inorganic" 5 "Manure" 6 "Compost" 7 "Other organic"
	gen urea_kg =qty*itemcode==1
	gen dap_kg = qty*itemcode==2
	gen nps_kg = qty*itemcode==3
	gen n_kg = urea_kg * 0.46 + dap_kg * 0.18 + nps_kg * 0.19
	gen p_kg = dap_kg * 0.46 + nps_kg * 0.38
	gen k_kg = 0 
	gen herb_kg = qty*strmatch(input, "herb")
	gen pest_kg = qty*strmatch(input, "pest")
	gen fung_kg = qty*strmatch(input, "fung")
	gen inorg_fert_kg = qty*strmatch(input, "inorg")
	gen org_fert_kg = qty if itemcode >=5 & itemcode!=.
	collapse (sum) *kg, by(hhid holder_id parcel_id field_id)
	//collapse (max) use_irrigation (sum) *kg, by(hhid holder_id parcel_id field_id)
	la var inorg_fert_kg "Kg inorganic fertilizer used"
	la var org_fert_kg "Kg organic fertilizer used"
	la var herb_kg "Kg of herbicide used"
	la var pest_kg "Kg of pesticide used"
	la var fung_kg "Kg of fungicide used"
	la var urea_kg "Kg of urea applied"
	la var dap_kg "Kg of DAP applied"
	la var nps_kg "Kg of NPS applied"
	la var n_kg "Kg of nitrogen applied"
	la var p_kg "Kg of phosphorus applied"
	la var k_kg "Kg of potassium applied"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_input_quantities.dta", replace
	/*
	use "${Ethiopia_ESS_W3_created_data}/Ethiopia_ESS_W3_input_quantities.dta", clear
	JM 09.11.23: Need to create "use_input" variables as dummies. qty_input does not account for bin ary information. 
	*/
	restore

	tempfile all_field_inputs 
	save `all_field_inputs' 

	keep if strmatch(exp,"exp") // & qty!=. //Now for geographic medians
	gen fieldweight = weight_pop_rururb*area_meas_hectares // Joaquin 6.12.23: Q for Andrew: use weight or weight_pop_rururb?
	//recode val (0=.) // JM 09.11.23: Most of our use variables are binary. doing the recode would erase most of them.  
	//drop if unit==0 //Remove things with unknown units.
	gen price = val/qty if val!=. & qty!=. & qty>0 
	drop if price==.
	gen obs=1
	
	foreach i in region zone woreda kebele ea hhid {
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
	foreach i in region zone woreda kebele ea hhid {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		*recode hhid (.=0)
		gen price=price_hhid
	foreach i in country region zone woreda kebele ea hhid {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=. 
	}
	//Default to household prices when available
	replace price = price_hhid if price_hhid>0
	//replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
	//recode val qty (.=0)
	//drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0 & qty!=. & qty>0 
	//replace input = "orgfert" if input=="" itemcode>=5 & itemcode<=7 // JM 7.6.23: Look for itemcode for organic fertilizer
	//replace input = "inorg" if strmatch(input,"fert")
	tab input
	drop if exp==""
		
	/*
	use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_input_quantities.dta", clear 
	*/
	
	append using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_labor.dta"
	collapse (sum) val, by (hhid holder_id parcel_id field_id exp input dm_gender)
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_cost_inputs_long.dta",replace 
	
	preserve
		collapse (sum) val, by(hhid exp input) 
		save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_inputs_long.dta", replace //ALT 02.07.2022: Holdover from W4.
	restore

	preserve
		collapse (sum) val_=val, by(hhid holder_id parcel_id field_id exp dm_gender)
		drop if exp=="" //CHECK - APN 05.03.2024 :Dropped missing values for exp
		reshape wide val_, i(hhid holder_id parcel_id field_id dm_gender) j(exp) string
		save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_cost_inputs.dta", replace //This gets used below.
	restore
		
	//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
	ren val val_ 
	reshape wide val_, i(hhid holder_id parcel_id field_id exp dm_gender) j(input) string
	ren val* val*_
	reshape wide val*, i(hhid holder_id parcel_id field_id dm_gender) j(exp) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	ren val* val*_
	reshape wide val*, i(hhid holder_id parcel_id field_id) j(dm_gender2) string
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_cost_inputs_wide.dta", replace //Used for monocrop plots
	collapse (sum) val*, by(hhid)

	unab vars3 : *_exp_male //just get stubs from one
	local stubs3 : subinstr local vars3 "_exp_male" "", all
	foreach i in `stubs3' {
		egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
		egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
	}
	egen val_exp_hh=rowtotal(*_exp_hh)
	egen val_imp_hh=rowtotal(*_imp_hh)
	//drop /*val_mech_imp**/ val_seedtrans_imp* val_transfert_imp* val_feedanml_imp* //Not going to have any data
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_inputs_verbose.dta", replace


	//We can do this more simply by:
	use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_cost_inputs_long.dta", clear
	//back to wide
	drop input
	codebook dm_gender
	drop if exp==""
	collapse (sum) val, by(hhid holder_id parcel_id field_id exp dm_gender)
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	codebook dm_gender2 
	ren val* val*_
	reshape wide val*, i(hhid holder_id parcel_id field_id dm_gender2) j(exp) string
	ren val* val*_
	
	preserve // Get planted area 
		use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta",clear
		collapse (sum) ha_planted, by(hhid holder_id parcel_id field_id)
		tempfile planted_area
		save `planted_area' 
	restore 
	
	merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", nogen keep(1 3) keepusing(area_meas_hectares) //do per-ha expenses at the same time
	merge 1:1 hhid holder_id parcel_id field_id using `planted_area', nogen keep(1 3)
	reshape wide val*, i(hhid holder_id parcel_id field_id) j(dm_gender2) string
	collapse (sum) val* area_meas_hectares ha_planted*, by(hhid)
	//Renaming variables to plug into later steps
	foreach i in male female mixed {
	gen cost_expli_`i' = val_exp_`i'
	egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
	}
	egen cost_expli_hh = rowtotal(val_exp*)
	egen cost_total_hh = rowtotal(val*)
	drop val*
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_inputs.dta", replace


********************************************************************************
*MONOCROPPED PLOTS*
********************************************************************************
**# Bookmark #3

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
	keep if purestand==1 
	// merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) // MGM 4.30.2024: I already have dm_gender in my all fields.
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
	drop if `cn'_monocrop_ha==0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (Birr)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	collapse (sum) *monocrop* (sum) kgs_harv* val_harv*, by(hhid)
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop_hh_area.dta", replace
restore
}	
	

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid holder_id parcel_id field_id dm_gender) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	reshape wide val*, i(hhid holder_id parcel_id field_id) j(dm_gender2) string
	merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_inputs_`cn'.dta", replace
restore
}

********************************************************************************
*FARM SIZE *
********************************************************************************
//ALT: 10.29.24: Moved up to plot areas and simplified.

********************************************************************************
*LAND SIZE *
********************************************************************************
//ALT: As above

********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*BET 05.26.2021
*Expenses
use "$Ethiopia_ESS_W4_temp_data/sect8_4_ls_w4.dta", clear
append using "$Ethiopia_ESS_W4_temp_data/sect8_3_ls_w4.dta"
append using "$Ethiopia_ESS_W4_temp_data/sect8_2_ls_w4.dta"
ren ls_s8_3q11 cost_water_livestock
ren ls_s8_3q14 cost_fodder_livestock
ren ls_s8_3q22 cost_vaccines_livestock
ren ls_s8_3q24 cost_treatment_livestock
ren ls_s8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)

*Dairy costs
preserve
keep if ls_type == 1
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (hhid)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock)
keep hhid cost_lrum
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_lrum_expenses", replace
restore 

preserve
ren ls_type livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry"
la val species species
collapse (sum) cost_vaccines_livestock cost_treatment_livestock, by (hhid species) 
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
foreach i in ls_exp_vac{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (firstnm) *lrum *srum *pigs *equine *poultry, by(hhid)

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

collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (hhid)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses", replace
*Note that costs for hired labor are not captured.

*Livestock products
use "$Ethiopia_ESS_W4_temp_data/sect8_4_ls_w4.dta", clear
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

merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", nogen keep(1 3)
keep hhid weight_pop_rururb region zone woreda kebele ea livestock_code milk_liters_produced price_per_liter eggs_produced price_per_egg earnings_milk_products /*
	*/earnings_milk_week months_milked earnings_egg_sales liters_sold_week eggs_sold
gen price_per_unit = price_per_liter
replace price_per_unit = price_per_egg if price_per_unit==.
recode price_per_unit (0=.)
gen earnings_milk_year = earnings_milk_week*4*months_milked		//assuming 4 weeks per month
gen liters_sold_year = liters_sold_week*4*months_milked
gen earnings_egg_sales_year = earnings_egg_sales*4 // BET 05.26.21 recall period for eggs sold is 3 months.  this should be multiplied by 4
gen eggs_sold_year = eggs_sold*4 // BET 05.26.21 recall period for eggs sold is 3 months.  this should be multiplied by 4
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", replace

* creating aggregate prices for livestock
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_products", clear
gen country = "ETH" //makes the loop work better
keep if price_per_unit !=.
gen observation = 1
foreach i in kebele woreda zone region country {
	preserve
	collapse (median) price_median_`i'=price_per_unit (rawsum) obs_`i'=obs [aw=weight], by(livestock_code `i')
	la var price_median_`i' "Median price per unit for this livestock product in the `i'"
	la var obs_`i' "Number of sales observations for this livestock product in the`i'"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_`i'.dta", replace
	restore
}

gen price_missing = price_per_unit==.
foreach i in country region zone woreda kebele { 
merge m:1 `i' livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products_prices_`i'.dta", nogen
replace price_per_unit = price_median_`i' if obs_`i' > 9 & price_missing==1
} //This runs in descending order of adm_level size, so it'll naturally end up on the smallest one with observations.
 
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = eggs_produced * price_per_unit
gen value_milk_sold = liters_sold_year * price_per_unit
gen value_eggs_sold = eggs_sold_year * price_per_unit
recode earnings_milk_products (.=0)

egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
egen sales_livestock_products = rowtotal(value_milk_sold value_eggs_sold)

collapse (sum) value_milk_produced value_eggs_produced earnings_milk_products value_livestock_products sales_livestock_products, by(hhid)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
*NOTE: there are quite a few that seem to have higher sales than production; going to cap these at one
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 

lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var earnings_milk_products "Earnings from milk products sold (gross earnings only)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products", replace

*Sales (live animals)
use "$Ethiopia_ESS_W4_temp_data/sect8_2_ls_w4.dta", clear
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
merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta"
drop if _merge==2
drop _merge
keep hhid weight_pop_rururb region zone woreda kebele ea livestock_code number_sold income_live_sales number_slaughtered income_slaughtered price_per_animal value_livestock_purchase
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_livestock_sales", replace

*Implicit prices
gen obs=1
gen country = "ETH" //makes the loop simpler
foreach i in kebele woreda zone region country {
preserve
	collapse (median) price_median_`i'=price_per_animal (rawsum) obs_`i'=obs [aw=weight_pop_rururb], by(livestock_code `i')
	la var price_median_`i' "Median price per unit for this animal in the `i'"
	la var obs_`i' "Number of sales observations for this animal in the`i'"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_`i'.dta", replace
restore
}

gen price_missing = price_per_animal==.

foreach i in country region zone woreda kebele { 
merge m:1 `i' livestock_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_`i'.dta", nogen
replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_missing==1
} //This runs in descending order of adm_level size, so it'll naturally end up on the smallest one with observations.
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"

gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
*replace value_slaughtered = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 & income_slaughtered!=. /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
gen value_slaughtered_sold = income_slaughtered
gen value_livestock_sales = value_lvstck_sold + value_slaughtered_sold
collapse (sum) value_livestock_sales value_livestock_purchases value_slaughtered value_lvstck_sold, by(hhid)
lab var value_livestock_sales "Value of livestock sold and slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricultural season, not the year)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "$Ethiopia_ESS_W4_temp_data/sect8_2_ls_W4.dta", clear
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
gen largerum=inrange(lvstckid,1,6)
gen smallrum=inrange(lvstckid,7, 8)
gen poultry=inrange(lvstckid,10,12)
gen other_ls=inlist(lvstckid,9, 13, 16)
gen cows=inrange(lvstckid,3,3)
gen chickens=inrange(lvstckid,10,12)
ren ls_s8_2q01 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_largerum_1yearago=nb_ls_1yearago if largerum==1 
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
gen nb_largerum_today=nb_ls_today if largerum==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_largerum_1yearago "Number of large ruminant owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_largerum_today "Number of cattle owned as of the time of survey"
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
use "$Ethiopia_ESS_W4_temp_data/sect8_2_ls_W4.dta", clear
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
merge m:1 ls_code hhid holder_id using "$Ethiopia_ESS_W4_temp_data/sect8_1_ls_W4.dta", nogen
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
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(hhid species)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_camel = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *camel *equine *poultry share_imp_herd_cows, by(hhid)
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

merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen keep(1 3)
gen country="ETH"
foreach i in kebele woreda zone region country {
	merge m:1 `i' livestock_code using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_prices_`i'.dta", nogen
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
} 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_today = number_today * price_per_animal
collapse (sum) tlu_today value_today, by (hhid)
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_today "Value of livestock holdings today"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU.dta", replace

/* ALT to review
********************************************************************************
*LIVESTOCK INCOME - Long format recode (HI 2.22.22)
********************************************************************************
*Expenses
use "$Ethiopia_ESS_W4_temp_data/sect8_4_ls_w4.dta", clear
append using "$Ethiopia_ESS_W4_temp_data/sect8_3_ls_w4.dta"
append using "$Ethiopia_ESS_W4_temp_data/sect8_2_ls_w4.dta"
ren ls_s8_3q11 cost_water_livestock
ren ls_s8_3q14 cost_fodder_livestock
ren ls_s8_3q22 cost_vaccines_livestock
ren ls_s8_3q24 cost_treatment_livestock
ren ls_s8_3q04 cost_breeding_livestock
recode cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock (.=0)

*Dairy costs
preserve
keep if ls_type == 1
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (hhid ls_type)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock)
foreach i in lrum {
	gen cost = cost_`i'
} 
keep hhid ls_type cost
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_lrum_expenses_long", replace 
restore

preserve
ren ls_type livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants" 2 "Small ruminants" 3 "Camels" 4 "Equine" 5 "Poultry" // no bees
la val species species
collapse (sum) cost_vaccines_livestock cost_treatment_livestock, by (hhid species) 
gen ls_exp_vac = cost_vaccines_livestock + cost_treatment_livestock
la var ls_exp_vac "Cost for vaccines and veterinary treatment for livestock"
drop cost_vaccines_livestock cost_treatment_livestock
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_animal_long", replace
restore

collapse (sum) cost_water_livestock cost_fodder_livestock cost_vaccines_livestock cost_treatment_livestock cost_breeding_livestock, by (hhid ls_code)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_treatment_livestock "Cost for veterinary treatment for livestock"
lab var cost_breeding_livestock "Cost for breeding (insemination?) for livestock"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses_long", replace
*Note that costs for hired labor are not captured.
*/

********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
* BET 05.05.2021
use "$Ethiopia_ESS_W4_temp_data/sect12b1_hh_W4.dta", clear
ren s12bq12 months_active  
* four hh operated more than 12 months
replace months_active = 12 if months_active>12  // capping months operating at 12
ren s12bq16 avg_monthly_sales
egen monthly_expenses = rowtotal(s12bq17a- s12bq17f) // MGM 8.14.2024: added f (from e) because there are additional expenses captured in W4 and W5 that brings the total number of columns up!
recode avg_monthly_sales monthly_expenses (.=0)
gen monthly_profit = (avg_monthly_sales - monthly_expenses)
* many biz with negative profits, more than 25% of all biz
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_self_employment_income.dta", replace

*Female non-farm business owners // seems like the owner is identified but 
use "$Ethiopia_ESS_W4_temp_data/sect12b1_hh_W4.dta", clear
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
	keep hhid `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect4_hh_W4.dta", clear
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
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_person_ids.dta", nogen //DYA; 7.3.2023: Here we are using Ethiopia_ESS_W4_person_ids which include the gender of everyone
gen wage_worker = (annual_salary!=0 & annual_salary!=.)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_worker.dta", replace
restore
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_income.dta", replace
*Occupation = Ag or Industry = Ag or Fisheries.

*Agwage
use "$Ethiopia_ESS_W4_temp_data/sect4_hh_W4.dta", clear
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
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_person_ids.dta", nogen //DYA; 7.3.2023: Here we are using Ethiopia_ESS_W4_person_ids which include the gender of everyone
gen agworker = (annual_salary_agwage!=0 & annual_salary_agwage!=.)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agworker.dta", replace
restore

collapse (sum) annual_salary_agwage, by (hhid)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "$Ethiopia_ESS_W4_temp_data/sect13_hh_W4_v2.dta", clear
ren s13q02 amount_received
gen transfer_income = amount_received if source_cd==101|source_cd==102|source_cd==103 /* cash, food, other in-kind transfers */
gen investment_income = amount_received if source_cd==104
gen pension_income = amount_received if source_cd==105
gen rental_income = amount_received if source_cd==106|source_cd==107|source_cd==108|source_cd==109
gen sales_income = amount_received if source_cd==110|source_cd==111|source_cd==112| source_cd==113
gen inheritance_income = amount_received if source_cd==114
recode transfer_income pension_income investment_income sales_income inheritance_income (.=0)
collapse (sum) transfer_income pension_income investment_income rental_income sales_income inheritance_income, by (hhid)
lab var transfer_income "Estimated income from cash, food, or other in-kind gifts/transfers over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months"
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var sales_income "Estimated income from sales of real estate or other assets over previous 12 months"
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var inheritance_income "Estimated income from cinheritance over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_other_income.dta", replace

use "$Ethiopia_ESS_W4_temp_data/sect14_hh_W4.dta", clear
* BET 05.13.2021  W4 makes the distinction between cash, inkind, or food transfers 
rename assistance_cd assistance_code
rename s14q03 cash_received
rename s14q05 foodvalue_received
rename s14q06 inkind_received
recode cash_received foodvalue_received inkind_received (.=0)
gen amount_received =  cash_received + foodvalue_received + inkind_received

gen psnp_income = amount_received if assistance_code==1			
gen assistance_income = amount_received if assistance_code==2|assistance_code==3 

collapse (sum) psnp_income assistance_income, by (hhid)
lab var psnp_income "Estimated income from a PSNP over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_assistance_income.dta", replace

use "$Ethiopia_ESS_W4_temp_data/sect2_pp_W4.dta", clear
ren s2q15a land_rental_income_cash
ren s2q15b land_rental_income_inkind
ren s2q15c land_rental_income_share
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income_upfront = land_rental_income_cash + land_rental_income_inkind
collapse (sum) land_rental_income_upfront, by (hhid)
lab var land_rental_income_upfront "Estimated income from renting out land over previous 12 months (upfront payments only)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rental_income.dta", replace


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Ethiopia_ESS_W4_temp_data}/sect4_hh_W4.dta", clear
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
collapse (sum) nworker_* hrs_*  member_count, by(hhid)
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
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_labor_long.dta", clear
// drop if strmatch(gender,"all") *Not relevant to ETH
rename labor_type type
replace type="family" if type=="nonhired"
ren days labor_
collapse (sum) labor_, by(hhid type gender)
reshape wide labor_, i(hhid gender) j(type) string
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_family_hired_labor.dta", replace


********************************************************************************
* VACCINE USAGE *
********************************************************************************
* UPDATED BY BT 05.14.2021
use "$Ethiopia_ESS_W4_temp_data/sect8_3_ls_W4.dta", clear
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
collapse (max) vac_animal*, by (hhid)
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
use "$Ethiopia_ESS_W4_temp_data/sect8_3_ls_W4.dta", clear
ren saq09 farmerid 

gen all_vac_animal=.
replace all_vac_animal=1 if ls_s8_3q18==1
replace all_vac_animal=0 if ls_s8_3q18==2
replace all_vac_animal=. if ls_s8_3q18==.
collapse (max) all_vac_animal , by(hhid farmerid)
gen personid=farmerid 
drop if personid==.
merge m:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_person_ids.dta", gen(f_merge)   keep(1 3) //DYA; 7.3.2023: Here we are using Ethiopia_ESS_W4_person_ids which include the gender of everyone 	
keep hhid personid all_vac 	female
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
* PLOT MANAGERS *
********************************************************************************
/*
use "$Ethiopia_ESS_W4_temp_data/sect4_pp_W4.dta", clear
ren s4q01b crop_code
gen use_imprv_seed = (s4q11 == 2) | (s4q11 == 3) //2=improved/new; 3=improved from prev year; 4=improved/recycled
collapse (max) use_imprv_seed, by(hhid holder_id parcel_id field_id crop_code)
tempfile imprv_seed
save `imprv_seed'
*/
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", clear 
//ren s3q13 pid1
//ren  s3q15_1 pid2 
//ren s3q15_2 pid3
keep hhid holder_id parcel_id field_id //pid*
//reshape long pid, i( hhid holder_id parcel_id field_id) j(pidno)
//drop pidno
//drop if pid==.
ren holder_id individual_id
merge m:1 hhid individual_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen keep(1 3)
tempfile personids
save `personids'

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_input_quantities.dta", clear
merge 1:1 hhid parcel_id field_id using "${Ethiopia_ESS_W4_temp_data}/sect3_pp_w4.dta", nogen keepusing(s3q17)
merge 1:m hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", nogen keepusing(crop_code use_imprv_seed) 
gen use_irr = s3q17==1
foreach i in inorg_fert org_fert pest herb fung {
	recode `i'_kg (.=0)
	gen use_`i'= `i'_kg > 0
}

collapse (max) use*, by(hhid holder_id parcel_id field_id crop_code)
recode use* (.=0)
preserve 
keep hhid holder_id parcel_id field_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropname_table.dta", nogen keep(3) 
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_imprvseed_crop.dta", replace 
restore 

merge m:m hhid holder_id parcel_id field_id using `personids', keep(1 3)
drop if personid == .
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid personid female crop_code)
merge m:1 crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
/*
bysort hhid holder_id parcel_id field_id individual_id2 female crop_name: gen dup = cond(_N==1,0,_n)
tab dup 
*/
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use.dta", replace
restore

collapse (max) use_*, by(hhid personid female)
gen all_imprv_seed_use = use_imprv_seed //Legacy
preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest use_herb use_fung use_irr, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_herb "1 = household uses herbicide"
	la var use_fung "1 = household uses fungicide" 
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	la var use_irr "1=household uses irrigation"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	
	gen farm_manager=1
	recode farm_manager (.=0)
	lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
**cannot construct in this instrument



********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************

use "$Ethiopia_ESS_W4_temp_data/sect8_3_ls_W4.dta", clear
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
collapse (max) feed_grazing* water_source* lvstck_housed*, by (hhid)
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

/*
//ALT Not old? We should review this vis a vis the individual variables 
********************************************************************************
* INORGANIC FERTILIZER USE *
********************************************************************************
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_W4.dta", clear
gen use_inorg_fert=0
replace use_inorg_fert=1 if s3q21==1 | s3q22==1 | s3q23==1 | s3q24==1
replace use_inorg_fert=0 if s3q21==2 & s3q22==2 & s3q23==2 & s3q24==2
replace use_inorg_fert=. if s3q21==. & s3q22==. & s3q23==. & s3q24==.
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1= Household uses inorganic fertilizer"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_W4.dta", clear
gen all_use_inorg_fert=0
replace all_use_inorg_fert=1 if s3q21==1 | s3q22==1 | s3q23==1 | s3q24==1
replace all_use_inorg_fert=0 if s3q21==2 & s3q22==2 & s3q23==2 & s3q24==2
replace all_use_inorg_fert=. if s3q21==. & s3q22==. & s3q23==. & s3q24==.
ren saq09 farmerid //KEF Why do these holder_ids range so high? i.e. it skips from 82 to 100, for example.
collapse (max) all_use_inorg_fert , by(hhid farmerid)
gen personid=farmerid
destring personid, replace
drop if personid==.
merge m:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)
keep hhid personid all_use_inorg_fert female			
gen female_use_inorg_fert = all_use_inorg_fert if female==1 
gen male_use_inorg_fert=all_use_inorg_fert if female==0
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
lab var male_use_inorg_fert "1 = Individual male farmers (plot manager) uses inorganic fertilizer"
lab var female_use_inorg_fert "1 = Individual female farmers (plot manager) uses inorganic fertilizer"
*gen farm_manager=1 if personid!=.
*recode farm_manager (.=0)
*lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_fert_use.dta", replace
*/
/*
********************************************************************************
* IMPROVED SEED USE *
********************************************************************************
use "$Ethiopia_ESS_W4_temp_data/sect4_pp_W4.dta", clear
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
collapse (max) imprv_seed_* hybrid_seed_*, by(hhid)
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
use "$Ethiopia_ESS_W4_temp_data/sect4_pp_W4.dta", clear
ren s4q01b crop_code
gen all_imprv_seed_use = (s4q11==2 | s4q11==3 | s4q11==4) //KEF: Same issue as in line 2084. Andrew recommended to change this to imprv_seed_use since it makes things below slightly easier, however all other sections used this nomenclature so decided to keep the "all" in there. 
replace all_imprv_seed_use=. if s4q11==.
gen all_hybrid_seed_use=. //KEF: Doesn't ask about hybrid seeds, but want to avoid a missing variable error later in the summary stats.
ren saq09 personid
destring personid, replace
*gen farm_manager=1
merge m:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", nogen keep(1 3)
*recode farm_manager (.=0)
//First part
preserve
	collapse (max) all_imprv_seed_use all_hybrid_seed_use /*farm_manager*/, by(hhid personid female) //This takes care of dropping extraneous variables. If we want hybrid seed use to be in here, it should be consistent and include it throughout to increase code portability as well in case hybrid seeds are added in later versions.
	gen female_imprv_seed_use = all_imprv_seed_use==1 if female==1 
	gen female_hybrid_seed_use = all_hybrid_seed_use==1 if female==1
	gen male_imprv_seed_use = all_imprv_seed_use==1 if female==0
	gen male_hybrid_seed_use = all_hybrid_seed_use==1 if female==0
	lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
	lab var male_imprv_seed_use "1 = Individual male farmers (plot manager) uses improved seeds"
	lab var female_imprv_seed_use "1 = Individual female farmers (plot manager) uses improved seeds"
	*lab var farm_manager "1 = Individual is listed as a manager for at least one plot"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use.dta", replace
restore

//Now for monocropped plots
ren all_imprv_seed_use all_imprv_seed_ //Since "use" in the same file with `cn' implies that "use" is a member of the top crops.
ren all_hybrid_seed_use all_hybrid_seed_
collapse (max) all_imprv_seed_ all_hybrid_seed_, by(hhid personid /*farm_manager*/ female crop_code) 
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
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid personid /*farm_manager*/ female) j(crop) string //Now we have all crops, not just the BMGF ones. //KEF error here, option i not allowed
	ren farmer_* *_farmer // Andrew suggested to switch these around, not best practice.
	recode *_farmer (.=0)
	*lab var farm_manager "1 = Individual is listed as a manager for at least one plot"

forvalues k=1(1)$nb_topcrops {
    local c: word `k' of $topcrop_area
	local cn: word `k' of $topcropname_area
	local cnfull: word `k' of $topcropname_full
preserve	
	keep *`cn'* hhid personid /*farm_manager*/ female
	gen female_imprv_seed_`cn'=all_imprv_seed_`cn' if female==1
	gen male_imprv_seed_`cn' = all_imprv_seed_`cn' if female==0
	recode male* female* (.=0)
	lab var all_imprv_seed_`cn' "1 = Individual farmer (plot manager) uses improved `cnfull' seeds"
	lab var male_imprv_seed_`cn' "1 = Individual male farmers (plot manager) uses improved `cnfull' seeds"
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use_`cn'.dta", replace
restore // This should run much more quickly than the old code because we're minimizing the repeat operations. 
}
*/
/* Old code
use "$Ethiopia_ESS_W4_temp_data/sect4_pp_W4.dta", clear
gen all_imprv_seed_use = (s4q11==2 | s4q11==3 | s4q11==4) //KEF: Same issue as in line 2084. Andrew recommended to change this to imprv_seed_use since it makes things below slightly easier, however all other sections used this nomenclature so decided to keep the "all" in there. 
replace all_imprv_seed_use=. if s4q11==.
ren saq09 farmerid
collapse (max) all_imprv_seed_use, by(hhid farmerid)
gen personid=farmerid
drop if personid==.
merge m:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
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

use "$Ethiopia_ESS_W4_temp_data/sect4_pp_W4.dta", clear
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
	collapse (max) all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer, by(hhid farmerid)
	gen personid=farmerid
	drop if personid==.
	merge m:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_gender_merge_both.dta", gen(f_merge)   keep(1 3)			
	// drop household_id- pp_s1q05 ph_saq07- f_merge KEF: Presuming error here again. Replacing with line below.
	keep all_imprv_seed_`cn' farmerid female hhid
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
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_w4.dta", clear
//merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect5_pp_w4.dta", nogen force 
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect7_pp_w4.dta", nogen force //saq09 mismatch data type
gen ext_reach_all=0 //misnomer, really "any" i.e. ext_reach_any (note for future)
replace ext_reach_all=1 if s3q16==1 | s7q04==1 | s7q09==1
//s7q09 syntax is a bit confusing: "do you not get advisory services?" Yes=1; no question on seed selection - section 5 in previous waves

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
collapse (max) ext_reach*, by (hhid)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources" 
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_any_ext.dta", replace


********************************************************************************
* MOBILE OWNERSHIP*
********************************************************************************
*BET 05.04.21
use "${Ethiopia_ESS_W4_temp_data}/sect10a_hh_W4.dta", clear
recode s10aq41 (.=0)
gen mobile_owned=s10aq41==1
preserve

use "${Ethiopia_ESS_W4_temp_data}/sect11b1_hh_W4.dta", clear
recode s11b_ind_01 s11b_ind_02 (.=0) 
gen mobile_owned=s11b_ind_01==1 
gen idv_number_mobile_owned = s11b_ind_02
replace mobile_owned=1 if idv_number_mobile_owned>0
tempfile num_mobile 
save `num_mobile'

restore
append using `num_mobile'

collapse (max) mobile_owned, by(hhid)
keep hhid mobile_owned
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_2018_mobile_own", replace

********************************************************************************
* IRRIGATION *
********************************************************************************
//Moved to plot inputs


********************************************************************************
* FORMAL FINANCIAL SERVICES USE *
********************************************************************************
* BET 05.05.21 - CHECK CONFIRM THAT USE QUESTIONS SHOULD MERGE IN ANY QUESTION ABOUT USE OF ACCOUNTS 
use "$Ethiopia_ESS_W4_temp_data/sect5a_hh_W4.dta", clear
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect5b1_hh_W4.dta", nogen
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect5b2_hh_W4.dta", nogen
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect11b2_hh_W4.dta", nogen
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect12b1_hh_W4.dta", nogen
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect13_hh_W4_v2.dta", nogen
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect4_hh_W4.dta", nogen
merge m:m hhid using "$Ethiopia_ESS_W4_temp_data/sect15b_hh_W4.dta", nogen
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
collapse (max) use_fin_serv_*, by (hhid)
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
use "$Ethiopia_ESS_W4_temp_data/sect8_4_ls_W4.dta", clear
gen cows = ls_code==3
keep if cows
gen milk_animals = ls_s8_4_q02			// number of livestock milked (by holder) in last year
gen months_milked = ls_s8_4q03			// average months milked in last year (by holder)
gen liters_day = ls_s8_4q04				// average quantity (liters) per day per cow
gen liters_per_cow = (liters_day*365*(months_milked/12))	// liters per day times 365 (for yearly total) times milk animals to get TOTAL across all animals times months milked over 12 to scale down to actual amount
lab var milk_animals "Number of large ruminants that were milked (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_cow "average quantity (liters) per year (household)"
collapse (sum) milk_animals liters_per_cow, by(hhid)
keep if milk_animals!=0
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
* BET 05.14.2021
use "$Ethiopia_ESS_W4_temp_data/sect8_4_ls_W4.dta", clear
gen clutching_periods = ls_s8_4q14		// number of clutching periods per hen in last 12 months
gen eggs_clutch = ls_s8_4q15			// number of eggs per clutch
gen hen_total = ls_s8_4q16				// total laying hens
gen eggs_total_year = clutching_periods*eggs_clutch*hen_total		// total eggs in last 12 months (clutches per hen times eggs per clutch times number of hens)
collapse (sum) eggs_total_year hen_total, by(hhid)
keep if hen_total!=0
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var hen_total "Total number of laying hens"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_eggs_animals.dta", replace


********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
*All the preprocessing is done in the crop expenses section
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid holder_id parcel_id field_id purestand field_size)
reshape long ha_, i(hhid holder_id parcel_id field_id purestand field_size) j(area_type) string
tempfile field_areas
save `field_areas'

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(hhid holder_id parcel_id field_id dm_gender exp)
reshape wide cost_, i(hhid holder_id parcel_id field_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge 1:m hhid holder_id parcel_id field_id using `field_areas', nogen keep(3)
//reshape long cost_, i(hhid plot_id dm_gender) j(exp) string
//replace cost_ = cost_/ha_
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(hhid dm_gender area_type) 
gen dm_gender2 = "male" //No missings here, so this should be fine.
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropcosts.dta", replace


********************************************************************************
* RATE OF FERTILIZER APPLICATION *
********************************************************************************
// note that application rates get calculated during winsorization; this is just predefinition work.

* AREA PLANTED IRRIGATED
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_planted_area.dta", clear
merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers.dta", nogen keep(1 3)
merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_temp_data}/sect3_pp_w4.dta", nogen keepusing(s3q17) keep(1 3)
merge 1:1 hhid holder_id parcel_id field_id using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_input_quantities.dta", nogen keep(1 3) //11 plots have expenses but don't show up in the all_plots roster. //MGM 5.18.2024: 80 not matched, 10,527 matched
drop if ha_planted==0
ren s3q17 plot_irr
recode plot_irr (2=0) // 2 is "No"
gen ha_irr_ = plot_irr * ha_planted
unab vars : *kg 
local vars `vars' ha_irr ha_planted
recode *kg (.=0)

gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "other" if dm_gender==. 
drop dm_gender
ren *kg *kg_
ren ha_planted ha_planted_

reshape wide *_, i(hhid holder_id parcel_id field_id) j(dm_gender2) string
collapse (sum) ha_planted* *kg* ha_irr_*, by(hhid)

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}
drop *other*
 //Need this for household totals but otherwise we don't track plots with unknown management
//Some high inorg fert rates as a result of large tonnages on small plots. 
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var fung_kg "Fungicide (kgs) for household"
lab var dap_kg "DAP (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
la var nps_kg "NPS fertilizer (kgs) for household"
la var n_kg "Nitrogen from inorganic fertilizers (kg) for hh"
la var p_kg "Phosphorus from inorganic fertilizers (kg) for hh"
la var k_kg "Potassium from inorganic fertilizers (kg) for hh"
la var ha_irr "Planted area under irrigation (ha) for hh"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var fung_kg_`i' "Fungicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
lab var dap_kg_`i' "DAP (kgs) for `i'-managed plots"
lab var urea_kg_`i' "Urea (kgs) for `i'-managed plots"
la var nps_kg_`i' "NPS fertilizer (kgs) for `i'-managed plots"
la var n_kg_`i' "Inorganic N (kg) for `i'-managed plots"
la var p_kg_`i' "Inorganic P (kg) for `i'-managed plots"
la var k_kg_`i' "Inorganic K (kg) for `i'-managed plots"
la var ha_irr_`i' "Planted hectares under irrigation for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, for `i'-managed plots"
}
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
use "$Ethiopia_ESS_W4_temp_data/sect6a_hh_W4.dta" , clear

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
collapse (max) adiet_yes, by(hhid Diet_ID) 
count // nb of obs = 54,494 remaining
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by the household
collapse (sum) adiet_yes, by(hhid)

/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS and WDDS. Because of
this it is recommended to use the mean score or distribution of scores for analytical
purposes and to set programme targets or goals.
*/
ren adiet_yes hdds 
sum hdds 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(hdds>=`cut_off1')
gen household_diet_cut_off2=(hdds>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var hdds "Number of food groups household consumed last week HDDS"
compress
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_diet.dta", replace

preserve 
use "${Ethiopia_ESS_W4_temp_data}/sect6b1_hh_w4.dta" , clear
ren s6bq02 days 
ren food_id item_id
drop s6bq01 

reshape wide days, i(hhid) j(item_id) 

gen max_127 = max(days1, days2, days4)
gen min_127 = min(days1, days2, days4)
egen sum_127 = rowtotal(days1 days2 days4)
gen fcs_A= 7 if  max_127==7 
replace fcs_A = sum_127 if min_127 ==0
replace fcs_A = (max_127+min((sum_127), 7))/2

gen max_36 = max(days3, days16)
gen min_36 = min(days3, days16)
egen sum_36 = rowtotal(days3 days16)
gen fcs_B= 7 if  max_36==7 
replace fcs_B = sum_36 if min_36 ==0
replace fcs_B = (max_36+min((sum_36), 7))/2

gen max_910 = max(days9, days10, days11, days12)
gen min_910 = min(days9, days10, days11, days12)
egen sum_910 = rowtotal(days9 days10 days11 days12)
gen fcs_C= 7 if  max_910==7 
replace fcs_C = sum_910 if min_910 ==0
replace fcs_C = (max_910+min((sum_910), 7))/2

drop days1 days2 days4 days3 days16 days9 days10 days11 days12 max_* min_* sum_* 
ren fcs_A days1
ren fcs_B days2
ren fcs_C days3 

reshape long days, i(hhid) j (item_id)
#delimit ;
recode item_id 	(1 2 4								=1	"CEREALS")  
					(3 16						  		=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")
					(6 									=3	"NUTS, BEANS AND LENTILS")
					(7								 	=4	"VEGETABLES")
					(9 10 11 12							=5	"MEAT, FISH, ANIMAL PRODUCTS")
					(8									=6	"FRUITS")
					(14									=7  "MILK AND MILK PRODUCTS")
					(13  								=8	"OIL AND FAT")
					(5									=9	"SUGAR AND SUGAR PRODUCTS")
					(15    								=10	"SPICES")
					, generate(item)
					;
#delimit cr

gen weight=.
replace weight = 2 if item == 1  // A
replace weight = 3 if item == 3  // C
replace weight = 1 if item == 4  // D
replace weight = 4 if item == 5  // E
replace weight = 1 if item == 6  // F
replace weight = 4 if item == 7  // G
replace weight = 0.5 if item == 8  // H
replace weight = 0.5 if item == 9  // I

gen fcs=days*weight
collapse (sum) fcs, by(hhid) 
label var fcs "Food Consumption Score"
gen fcs_poor = (fcs <= 21)
gen fcs_borderline = (fcs > 21 & fcs <= 35)
gen fcs_acceptable = (fcs > 35)
label var fcs_poor "1 = Household has poor Food Consumption Score (0-21)"
label var fcs_borderline "1 = Household has borderline Food Consumption Score (21.5 - 35)"
label var fcs_acceptable "1 = Household has acceptable Food Consumption Score (> 35)"
tempfile fcs_hhid
save `fcs_hhid'
restore


preserve 
use "${Ethiopia_ESS_W4_temp_data}/sect8_hh_w4.dta" , clear
keep s8q02* hhid  
gen rcsi= s8q02a + s8q02b + s8q02c + s8q02d + 4*s8q02e + s8q02f*2+s8q02h
label var rcsi "Reducing Coping Strategies Index, weighted total of the types of strategies a household uses to avoid insufficient food"
keep hhid rcsi 

gen rcsi_phase1 = (rcsi <= 3)
gen rcsi_phase2 = (rcsi > 3 & rcsi <= 18)
gen rcsi_phase3 = (rcsi > 19 & rcsi <= 42)
gen rcsi_phase4 = (rcsi > 42)
label var rcsi_phase1 "1 = Household rCSI score belongs to IPC Phase 1, minimal food insecurity (0-3)"
label var rcsi_phase2 "1 = Household rCSI score belongs to IPC Phase 2, stressed food insecurity (4 - 18)"
label var rcsi_phase3 "1 = Household rCSI score belongs to IPC Phase 3, crisis food insecurity (19 - 42)"
label var rcsi_phase4 "1 = Household rCSI score belongs to IPC Phase 4, emergency food insecurity (> 42)"
tempfile rcsi_hhid
save `rcsi_hhid' 
restore

merge 1:1 hhid using `rcsi_hhid', nogen 
merge 1:1 hhid using `fcs_hhid', nogen 
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_diet.dta", replace
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* FEMALE LAND OWNERSHIP
use "$Ethiopia_ESS_W4_temp_data/sect2_pp_W4.dta", clear
*Female asset ownership
local landowners "s2q07_1 s2q07_2 s2q09_1 s2q09_2" // sell, collateral, or bequeath. cannot answer gender of owner for rented land, because does not use network roster BET 05.04.2021
keep hhid  `landowners' 	// keep relevant variable
*transform data into long form
foreach v of local landowners   {
	preserve
	keep hhid `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect8_1_ls_W4.dta", clear
*Remove poultry-livestocks--cocks, hens, chicks
drop if inlist(ls_code,10,11,12,.)
local livestockowners "ls_s8_1q04_1 ls_s8_1q04_2"
keep hhid `livestockowners' 	// keep relevant variables
*Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect11_hh_W4.dta", clear
*keep only productive assets
drop if inlist(asset_cd,4,5,6,7,8,9,10,11,12,23,24,25,26.) //exclude blanket, mattress, watches, sofa, handcart,  jewelry. What about radio/TV/CD/satellite? BET 05.04.2021 CHECK 
local otherassetowners "s11q02_1 s11q02_2 s11q02_3 s11q02_4 s11q02_5 s11q02_6 s11q02_7 s11q02_8 s11q02_9 s11q02_10 s11q02_11 s11q02_12"
keep hhid  `otherassetowners'
*Transform the data into long form  
foreach v of local otherassetowners   {
	preserve
	keep hhid  `v'
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

collapse (max) own_asset, by(hhid asset_owner)
gen individual_id =asset_owner
*Own any asset
*Now merge with member characteristics
merge 1:1 hhid individual_id  using   "$Ethiopia_ESS_W4_temp_data/sect1_hh_W4.dta"
keep  hhid individual_id own_asset asset_owner ea_id saq14 pw_w4 saq01 saq02 saq03 saq04 saq05 saq06 saq07 saq08 s1q01 s1q02 s1q03a
ren s1q02 mem_gender 
ren s1q03a age 
gen female = mem_gender==2
ren saq01 region
ren saq02 zone
recode own_asset (.=0)
gen women_asset= own_asset==1 & mem_gender==2
lab  var women_asset "Women ownership of asset"
*drop if mem_gender==1
*drop if age<18 & mem_gender==2
gen personid= individual_id 
compress
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_asset.dta", replace


********************************************************************************
*WOMEN'S AG DECISION-MAKING
********************************************************************************
*SALES DECISION-MAKERS - INPUT DECISIONS
use "$Ethiopia_ESS_W4_temp_data/sect3_pp_W4.dta", clear
*Women's decision-making in ag
local planting_input "s3q13 s3q15_1 s3q15_2" 
keep hhid saq09 `planting_input' 	// keep relevant variables
* Transform the data into long form  
foreach v of local planting_input   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect11_ph_W4.dta", clear
local control_annualsales "s11q13_1 s11q13_2"
keep hhid saq09 `control_annualsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_annualsales   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect11_ph_W4.dta", clear
local sales_annualcrop "s11q08_1 s11q08_2"
keep hhid saq09 `sales_annualcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_annualcrop   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect12_ph_W4.dta", clear
local control_permsales "ph_s12q08a_1 ph_s12q08a_2"
keep hhid saq09 `control_permsales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_permsales   {	
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect12_ph_W4.dta", clear
local sales_permcrop "ph_saq07 ph_s12q08a_1 ph_s12q08a_2"
keep hhid saq09  `sales_permcrop' 	// keep relevant variables
* Transform the data into long form  
foreach v of local sales_permcrop   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect9_ph_W4.dta", clear
local harvest "s9q09_1 s9q09_2"
keep hhid saq09 `harvest' 	// keep relevant variables
* Transform the data into long form  
foreach v of local harvest   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect9_ph_W4.dta", clear
local control_annualharvest "s9q09_1 s9q09_2"
keep hhid saq09 `control_annualharvest' // keep relevant variables
* Transform the data into long form  
foreach v of local control_annualharvest   {
	preserve
	keep hhid `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect8_1_ls_W4.dta", clear
local livestockowners "ls_s8_1q05_1 ls_s8_1q05_2"
keep hhid saq09 `livestockowners' 	// keep relevant variables
* Transform the data into long form  
foreach v of local livestockowners   {
	preserve
	keep hhid `v'
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
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
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
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker individual_id 

*Now merge with member characteristics
merge 1:1 hhid individual_id   using   "$Ethiopia_ESS_W4_temp_data/sect1_hh_W4.dta"

drop s1q03b- _merge
recode make_decision_* (.=0)
*Generate women participation in Ag decision
ren s1q02 mem_gender 
ren s1q03a age 
gen female = mem_gender==2
*drop if mem_gender==1
*drop if age<18 & mem_gender==2
*Generate women control over income
local allactivity crop  livestock  ag
foreach v of local allactivity {
	gen women_decision_`v'= make_decision_`v'==1 & mem_gender==2
	lab var women_decision_`v' "Women make decision about `v' activities"
	lab var make_decision_`v' "HH member involved in `v' activities"
} 
collapse (max) make_decision* women_decision*, by(hhid individual_id)
gen personid = individual_id
compress
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_decision.dta", replace


********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
/*
* FEMALE LIVESTOCK DECISION-MAKING - SALES
use "$Ethiopia_ESS_W4_temp_data/sect8_4_ls_W4.dta", clear
local control_livestocksales "ls_sec_8_1q03_a ls_sec_8_1q03_b"
keep hhid saq09  `control_livestocksales' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_livestocksales   {
	preserve
	keep hhid saq09   `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect12b1_hh_W4.dta", clear
local control_businessincome "s12bq06_1 s12bq06_2"
keep hhid `control_businessincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_businessincome   {
	preserve
	keep hhid  `v'
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
use "$Ethiopia_ESS_W4_temp_data/sect13_hh_W4_v2.dta", clear
local control_otherincome "s13q03_1 s13q03_2"
keep hhid `control_otherincome' 	// keep relevant variables
* Transform the data into long form  
foreach v of local control_otherincome   {
	preserve
	keep hhid `v'
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
collapse (max) control_* , by(hhid controller_income )  //any decision
preserve
	*	We also need a variable that indicates if a source of income is applicable to a household
	*	and use it to condition the statistics on household with the type of income
	collapse (max) control_*, by(hhid) 
	foreach v of varlist control_cropincome- control_all_income {
		local t`v'=subinstr("`v'",  "control", "hh_has", 1)
		ren `v'   `t`v''
	} 
	tempfile hh_has_income
	save `hh_has_income'
restore
merge m:1 hhid using `hh_has_income'
drop _m
ren controller_income individual_id

*Now merge with member characteristics
merge 1:1 hhid individual_id   using   "$Ethiopia_ESS_W4_temp_data/sect1_hh_W4.dta"
drop s1q03b-_merge
ren s1q02 mem_gender 
ren s1q03a age 
gen female = mem_gender==2
*drop if mem_gender==1
*drop if age<18 & mem_gender==2
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
*AGRICULTURAL WAGES
********************************************************************************
use "${Ethiopia_ESS_W4_temp_data}/sect3_pp_W4.dta", clear
append using "${Ethiopia_ESS_W4_temp_data}/sect10_ph_W4.dta"
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
collapse (sum) wage* number*, by(hhid)
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
keep hhid wage_paid_aglabor*
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for female hired labor (local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for male hired labor (local currency)"
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_wage.dta", replace 


********************************************************************************
*CROP YIELDS 
********************************************************************************
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
gen number_trees_planted_banana = number_trees_planted if crop_code==42
gen number_trees_planted_cassava = number_trees_planted if crop_code==10
// gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040 *MGM 5.18.2024: cocoa is not in W4? Need to revisit this and see if cocoa is in tree crop codes in W4?
recode number_trees_planted_banana number_trees_planted_cassava /*number_trees_planted_cocoa*/ (.=0) 
collapse (sum) number_trees_planted*, by(hhid)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_trees.dta", replace

* MGM 5.20.2024: Note that I had to change this up a little bit from how it was done in Nigeria because we do not have dm_gender information for all plots! Output still looks identical. Mainly, the difference is that if you aggregate any variables using gender up to the hh level, you won't get the same number as hh total numbers for households with missing dm_gender on any plot.
**# Bookmark #2

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
//Legacy stuff- agquery gets handled above.
gen no_harvest=ha_harvest==.
ren quant_harv_kg harvest 
ren ha_planted area_plan
ren ha_harvest area_harv 
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed across all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_harvest_area_yield.dta", replace

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production.dta", nogen keep(1 3)
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
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold* number_trees_planted*  , by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed across all seasons)" 

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

save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_yield_hh_crop_level.dta", replace


* VALUE OF CROP PRODUCTION  // using 335 output
//ALT: This part stays in.
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
collapse (sum) value_crop_production value_crop_sales, by( hhid commodity) 
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
collapse (sum) value_*, by(hhid)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_grouped.dta", replace
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
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_type_crop.dta", replace



********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
//KEF 7.19.21 /
*Bring in area planted
use "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan.dta", clear
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_hh_crop_area_plan_shannon.dta", nogen
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
save "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
******************************************************************************** 

*BET 05.26.2021, updated 7/20/2021
use "${Ethiopia_ESS_W4_temp_data}/cons_agg_w4.dta", clear
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
keep hhid adulteq total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons
ren hhid hhid
save "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_consumption.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Ethiopia_ESS_W4_temp_data}/sect8_hh_W4.dta", clear
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
keep hhid months_food_insec
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
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", clear	
//drop pw_W4	
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhids.dta", nogen // all matched
//merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_hh_adulteq.dta", nogen keep(1 3)

*Gross crop income 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
*End DYA 9.13.2020 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_cost_inputs.dta", nogen

*Crop costs 
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*top crop costs by area planted 
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_`c'_monocrop_hh_area.dta",nogen
}

foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 

*disaggregate by gender of plot manager 
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

*Land rights 
//merge 1:1 hhid using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_hh.dta", nogen keep(1 3) //ALT 03.07.24: Module missing, for follow up
//la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)

* Fish income 
gen fishing_income = . 
gen w_share_fishing = .
gen fishing_hh=.
global empty_vars $empty_vars *fishing_income* w_share_fishing fishing_hh

*Livestock income 
replace hhid = hhid if hhid==""
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_products.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_TLU_Coefficients.dta", nogen keep(1 3)
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
gen animals_lost12months =0 
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

* Self employment income 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_self_employment_income.dta", nogen keep(1 3)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

* Wage income 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_wage_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_agwage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_off_farm_hours.dta", nogen keep(1 3)

*Other income 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_other_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_assistance_income.dta", nogen keep(1 3)
// JM 10.30.23: Add remmittances income 
egen transfers_income = rowtotal (/*remittance_income*/ assistance_income) // JM 10.30.23: Do we need to create remmittance_income? 
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income /*rental_income_buildings*/ /*other_income*/  /*rental_income_assets*/) // JM 10.30.23: Do we need to create the commented-out variables? 
lab var all_other_income "Income from other revenue streams not captured elsewhere"

* Farm size 
merge 1:1 hhid using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_size.dta", nogen keep(1 3)
//merge 1:1 hhid using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_size_all.dta", nogen keep(1 3)
//merge 1:1 hhid using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmsize_all_agland.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_size_total.dta", nogen
//ren area_meas_hectares land_size
recode farm_area (.=0) /* If no farm, then no farm area */
recode farm_area (.=0)
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
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

* Household size 
//merge 1:1 hhid using  "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc. 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_vaccine.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fert_use.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_input_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_any_ext.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_w4_irrigation.dta", nogen keep(1 3) keepusing(*irr*) // MGM 9.18.2024: added for ATA indicators
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fin_serv.dta", nogen keep(1 3) //MGM 5.21.2024 - this file does not exist for ETH W4 and cannot be constructed!
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode use_fin_serv* ext_reach* use_* imprv_seed_use vac_animal (.=0) // ALT: use_inorg_fert -> use*
replace vac_animal=. if tlu_today==0 
foreach var in use_inorg_fert use_org_fert use_pest use_herb use_fung use_irr {	
	replace `var' =. if farm_area==0 | farm_area==. // Area cultivated this year
}
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.
/* gen use_fin_serv_bank = .
gen use_fin_serv_credit = .
gen use_fin_serv_insur = .
gen use_fin_serv_digital = .
gen use_fin_serv_others = .
gen use_fin_serv_all = . */
global empty_vars $empty_vars

* Milk productivity 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_milk_animals.dta", nogen keep(1 3)
gen liters_milk_produced= liters_per_cow*milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_cow
gen liters_per_largeruminant = .
gen liters_per_buffalo = .
global empty_vars $empty_vars *liters_per_largeruminant *liters_per_buffalo

* Dairy costs 
merge 1:1 hhid using "$Ethiopia_ESS_W4_created_data/Ethiopia_ESS_W4_lrum_expenses", nogen keep (1 3)
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

* Egg productivity 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_eggs_animals.dta", nogen keep(1 3)
gen egg_poultry_year = eggs_total_year/hen_total
ren hen_total poultry_owned
lab var egg_poultry_year "average number of eggs per year per hen"

*Costs of crop production per hectare (new)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application (new)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate (new)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons (new)
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

*Household diet 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_household_diet.dta", nogen keep(1 3)
 
* Consumption 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_consumption.dta", nogen keep(1 3)

*Household assets (Title from NGA, content from ETH)
gen value_assets = .
global empty_vars $empty_vars *value_assets*

* Food insecurity 
* merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
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
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_livestock_feed_water_house.dta", nogen keep(1 3) 

*Shannon Diversity index 
merge 1:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

* Agricultural households 
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
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
recode fishing_income (.=0)
// gen fishing_hh = (fishing_income!=0)
// lab  var fishing_hh "1= Household has some fishing income"

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

****getting correct subpopulations*****  
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}
*all rural households engaged in livestock production of a given species
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

global gender "female male mixed" // 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /* //JM 11.1.23: Removed "w_labor_other" for consistency with NGA W4
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*



*** Begin addressing outliers  and estimating indicators that are ratios using winsorized values ***
global gender "female male mixed"
global wins_var_top1 /*
*/ cost_total_hh cost_expli_hh /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*labor_other*/ /* 
*/ animals_lost12months* mean_12months* lost_disease* /*
*/ liters_milk_produced costs_dairy eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  livestock_expenses ls_exp_vac* crop_production_expenses value_assets kgs_harv_mono* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold value_pro* value_sal* 


gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after 
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}

global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp  
}
gen cost_total = cost_total_hh //JM 11.1.23: Added this line for consistency with NGA W4
gen cost_expli = cost_expli_hh //JM 11.1.23: Added this line for consistency with NGA W4
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli wage_paid_aglabor inorg_fert_kg org_fert_kg n_kg p_kg k_kg urea_kg dap_kg nps_kg herb_kg pest_kg fung_kg ha_irr //winsorizing area irrigated 
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
global empty_vars $empty_vars w_lost_disease w_lost_disease_lrum w_lost_disease_srum w_lost_disease_poultry
drop *wage_paid_aglabor_mixed
*Generating labor_total as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family) //JM 11.1.23: Removed "w_labor_other" for consistency with NGA W4
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%" 

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer

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

*area_harv and area_plan are also winsorized both at the top 1% and bottom 1% because we need to analyze at the crop level 
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 	
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres) 
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
	gen ar_pl_wgt_`c' =  weight_pop_rururb*w_area_plan_`c'
	lab var ar_pl_wgt_`c' "Planted area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_pl_`g'_`c'=w_harvest_`g'_`c'/w_area_plan_`g'_`c'
		lab var  yield_pl_`g'_`c'  "Yield by area planted of `c' -  (kgs/ha) (`g')" 
		gen ar_pl_wgt_`g'_`c' =  weight_pop_rururb*w_area_plan_`g'_`c'
		lab var ar_pl_wgt_`g'_`c' "Planted area-adjusted weight for `c' (`g')"
	}
}

*generate yield and weights for yields using winsorized values 
*Yield by area harvested
foreach c of global topcropname_area {
	gen yield_hv_`c'=w_harvest_`c'/w_area_harv_`c'
	lab var  yield_hv_`c' "Yield by area harvested of `c' (kgs/ha) (household)" 
	gen ar_h_wgt_`c' =  weight_pop_rururb*w_area_harv_`c'
	lab var ar_h_wgt_`c' "Harvested area-adjusted weight for `c' (household)"
	foreach g of global allyield  {
		gen yield_hv_`g'_`c'=w_harvest_`g'_`c'/w_area_harv_`g'_`c'
		lab var  yield_hv_`g'_`c'  "Yield by area harvested of `c' -  (kgs/ha) (`g')" 
		gen ar_h_wgt_`g'_`c' =  weight_pop_rururb*w_area_harv_`g'_`c'
		lab var ar_h_wgt_`g'_`c' "Harvested area-adjusted weight for `c' (`g')"
	}
}

*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
//gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
foreach v in inorg_fert org_fert n p k herb pest fung urea nps dap {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
}
}

gen cost_total_ha=w_cost_total/w_ha_planted  // JM 11.1.23: Changed cost_total to cost_total_hh
gen cost_expli_ha=w_cost_expli/w_ha_planted				
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
gen irr_rate = w_ha_irr / w_ha_planted
foreach g of global gender {
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 
	gen irr_rate_`g' = ha_irr_`g' / ha_planted_`g'
}

//ALT: need to update documentation to note that this is winsorized.

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household)"
lab var k_rate "Rate of postassium application (kgs/ha) (household)"
lab var p_rate "Rate of phosphorus appliction (kgs/ha) (household)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household)"
lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
lab var urea_rate "Rate of urea application (kgs/ha) (household)"
lab var nps_rate "Rate of NPS fertilizer application (kgs/ha) (household)" 
lab var dap_rate "Rate of DAP fertilizer application (kgs/ha) (household)"
la var irr_rate "Proportion of planted area irrigated (household)"

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
la var liters_per_largeruminant "Average quantity (liters) per year (household)" // JM 11.1.23: Added for consistency with NGA W4 code. 
global empty_vars $empty_vars liters_per_largeruminant	 // JM 11.1.23: Added for consistency with NGA W4 code. 

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
global empty_vars $empty_vars cost_per_lit_milk

*****getting correct subpopulations*** 
*all rural housseholds engaged in crop production (ETH)
recode *inorg_fert_rate* *irr_rate* *n_rate* *p_rate* *k_rate* *urea_rate* *dap_rate* *nps_rate* /*org_fert_rate not calculable for W5*/ *pest_rate* *herb_rate* *fung_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode *inorg_fert_rate* /*org_fert_rate *pest_rate* *herb_rate* *fung_rate*  not calculable for W2*/ cost_total_ha* cost_expli_ha* cost_expli_hh_ha land_productivity labor_productivity /*
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
global wins_var_ratios_top1 cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ inorg_fert_rate n_rate p_rate k_rate urea_rate dap_rate nps_rate irr_rate fung_rate pest_rate herb_rate /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if  "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {		
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
	_pctile `v'_exp_ha [aw=weight_pop_rururb] , p($wins_upper_thres)  		
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
//ALT: Adjusting this to 95th 03.25.28
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight_pop_rururb] , p(95)  
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
*all rural households (ETH not in NGA)
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ /*formal_land_rights_hh*/  /*DYA.10.26.2020*/ *_hrs_*_pc_all  /*months_food_insec*/ /*
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
*/ *inorg_fert_rate* /*org_fert_rate *pest_rate* *herb_rate* *fung_rate*  not calculable for W2*/ w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert /*w_dist_agrodealer*/ w_labor_productivity w_land_productivity /*
*/ *_rate* /*org_fert_rate *pest_rate* *herb_rate* *fung_rate*  not calculable for W2*/ w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0

*hh engaged in crop or livestock production 
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

*all rural households engaged in dairy production 
recode costs_dairy liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals 
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0

*Identify smallholder farmers (RULIS definition) 
global small_farmer_vars farm_area tlu_today total_income 
foreach p of global small_farmer_vars {
	gen `p'_aghh = `p' if ag_hh==1
	_pctile `p'_aghh  [aw=weight_pop_rururb] , p(40) 
	gen small_`p' = (`p' <= r(r1))
	replace small_`p' = . if ag_hh!=1
}
gen small_farm_household = (small_farm_area==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 
drop farm_area_aghh small_farm_area tlu_today_aghh small_tlu_today total_income_aghh small_total_income   
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
gen weight_milk=milk_animals*weight_pop_rururb
gen weight_egg=poultry_owned*weight_pop_rururb
*generate area weights for monocropped plots
foreach cn in $topcropname_area {
	gen ar_pl_mono_wgt_`cn'_all = weight_pop_rururb*`cn'_monocrop_ha
	gen kgs_harv_wgt_`cn'_all = weight_pop_rururb*kgs_harv_mono_`cn'
	foreach g in male female mixed {
		gen ar_pl_mono_wgt_`cn'_`g' = weight_pop_rururb*`cn'_monocrop_ha_`g'
		gen kgs_harv_wgt_`cn'_`g' = weight_pop_rururb*kgs_harv_mono_`cn'_`g'
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
gen ccf_loc = 1 / $Ethiopia_ESS_W4_inflation
lab var ccf_loc "currency conversion factor - 2017 $ETB"
gen ccf_usd = ccf_loc / $Ethiopia_ESS_W4_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc / $Ethiopia_ESS_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc / $Ethiopia_ESS_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

gen poverty_under_190 = (daily_percap_cons < $Ethiopia_ESS_W4_poverty_190)
la var poverty_under_190 "Household per-capita consumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $Ethiopia_ESS_W4_poverty_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $Ethiopia_ESS_W4_poverty_npl

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop harvest_* w_harvest_*

*Removing intermediate variables to get below 5,000 vars 
keep hhid fhh clusterid strataid *weight* *wgt* region zone woreda city subcity kebele ea /*household*/ rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* /*formal_land_rights_hh ALT:MISSING*/ /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   /*months_food_insec*/ *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh* *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_largerum_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products   nb_cows_today lvstck_holding_srum  nb_smallrum_today nb_chickens_today  *value_pro* *value_sal* /*
*/ /*DYA 10.6.2020*/ *value_livestock_sales*  *w_value_farm_production* *value_slaughtered* *value_lvstck_sold* *value_crop_sales* *sales_livestock_products* *value_livestock_sales* animals_lost12months *_inter_* *_pure_* use_fin_serv* /*MGM 8.29.2024: adding in additional indicators for ATA estimates*/ hh_work_age hh_women hh_adult_women tlu_today use_* /*crop_rotation*/ *rate* hdds fcs rcsi 

/*
foreach v of varlist $empty_vars { 
	replace `v' = .
}
*/

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) // This line is for HH vars only; rest for all three
ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
* gen hhid = hhid 
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2018-19" 
gen instrument = 24
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS W5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
la val instrument instrument
saveold "$Ethiopia_ESS_W4_final_data/Ethiopia_ESS_W4_household_variables.dta", replace

********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_person_ids.dta", clear
//bysort hhid personid: gen dup = cond(_N==1,0,_n)
//tab dup 
//edit if dup>=1
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_control_income.dta", nogen keep(1 3) // 13 from using not matched
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_ag_decision.dta", nogen keep(1 3) // 10 for using not matched //ALT: Referred to as "make_ag_decision" in other waves.
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_women_asset.dta", nogen keep(1 3) // 20 for using not matched //ALT: Referred to as "own_asset"
// merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_hhsize.dta", nogen keep(1 3) // MGM 8.14.2024: redundant with weights.dta
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_fert_use.dta", nogen  keep(1 3) // 9 for using not matched
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_improvedseed_use.dta", nogen  keep(1 3) // 19 for using not matched
merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_farmer_vaccine.dta", nogen  keep(1 3) // 12 for using not matched
merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", nogen

* Land rights  ALT: Missing
//merge 1:1 hhid personid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_land_rights_ind.dta", nogen
//recode formal_land_rights_f (.=0) if female==1				// this line will set to zero for all women for whom it is missing (i.e. regardless of ownerhsip status)
//la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"
gen formal_land_rights_f=.

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Ethiopia_ESS_W4_final_data}/Ethiopia_ESS_W4_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)

replace   make_decision_ag =. if ag_hh==0

* NA in ETH_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.

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
/* MGM 5.23.2024: these variables were already created earlier!
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
*/

*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
ren indiv indid
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2018-19" 
gen instrument = 24
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS W5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
//gen strataid=state
//gen clusterid=ea
saveold "${Ethiopia_ESS_W4_final_data}/Ethiopia_ESS_W4_individual_variables.dta", replace


*stop
********************************************************************************
//     FIELD LEVEL    

********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_all_fields.dta", clear
collapse (sum) plot_value_harvest = value_harvest (max) cultivate lost*, by(hhid holder_id parcel_id field_id )
tempfile crop_values 
save `crop_values'

use "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_area.dta", clear
merge m:1 hhid using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_weights.dta", keep (1 3) nogen //hh_size.dta in other ETH waves, contains the same info
merge 1:1 hhid holder_id parcel_id field_id  using `crop_values', nogen keep(1 3)
merge 1:1 hhid holder_id parcel_id field_id  using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_decision_makers", keep (1 3) nogen // Bring in the gender file
merge 1:1 hhid holder_id parcel_id field_id  using "${Ethiopia_ESS_W4_created_data}/Ethiopia_ESS_W4_field_labor_days.dta", keep (1 3) nogen

merge m:1 hhid using "${Ethiopia_ESS_W4_final_data}/Ethiopia_ESS_W4_household_variables.dta", nogen keep (1 3) keepusing(region strataid clusterid hhid ag_hh fhh farm_size_agland rural)
recode farm_size_agland (.=0) 
gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

keep if cultivate==1
//ren field_size  area_meas_hectares
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
	
*Convert monetary values into USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_usd= `p' / $Ethiopia_ESS_W4_exchange_rate
	gen `p'_1ppp= `p' / $Ethiopia_ESS_W4_cons_ppp_dollar
	gen `p'_2ppp= `p' / $Ethiopia_ESS_W4_gdp_ppp_dollar
	gen `p'_loc = `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2017 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2017 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2017 $ USD)"
	lab var `p'_loc "`l`p'' (2017 ETB)" 
	lab var `p' "`l`p'' (ETB)" 
	gen w_`p'_usd= w_`p' / $Ethiopia_ESS_W4_exchange_rate
	gen w_`p'_1ppp= w_`p' / $Ethiopia_ESS_W4_cons_ppp_dollar
	gen w_`p'_2ppp= w_`p' / $Ethiopia_ESS_W4_gdp_ppp_dollar
	gen w_`p'_loc = w_`p' 
	local lw_`p' : var lab w_`p' 
	lab var w_`p'_1ppp "`lw_`p'' (2017 $ Private Consumption  PPP)"
	lab var w_`p'_2ppp "`l`p'' (2017 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2017 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2017 ETB)"
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

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen field_labor_weight= w_labor_total*weight_pop_rururb

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren hhid hhid
gen hhid_panel = hhid
lab var hhid_panel "Panel HH identifier" 
ren field_id plot_id
gen geography = "Ethiopia"
gen survey = "LSMS-ISA" 
gen year = "2018-19" 
gen instrument = 24
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS W5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
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
do "${directory}\_Summary_statistics\EPAR_UW_335_SUMMARY_STATISTICS.do"
