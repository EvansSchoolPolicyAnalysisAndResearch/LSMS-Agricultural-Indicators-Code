/*
--------------------------------------------------------------------------------------
*Title/Purpose: Agricultural Development Indicators for the LSMS-ISA, Uganda National Panel Survey (UNPS) LSMS-ISA Wave 2 (2010-11)

*Author(s): Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu
															  
*Date : September 5th, 2025

*Dataset Version: UGA_2010_UNPS_v03_M
--------------------------------------------------------------------------------------*/



*Data source
*-----------
* The Uganda National Panel Survey was collected by the Uganda Bureau of 
* Statistics (UBOS) and the World Bank's Living Standards Measurement Study -
* Integrated Surveys on Agriculture(LSMS - ISA)
* The data were collected over the period November 2010 - October 2011. 
* All the raw data, questionnaires, and basic information documents are
* available for downloading free of charge at the following link
* http://microdata.worldbank.org/index.php/catalog/2166

* Throughout the do-file, we sometimes use the shorthand LSMS to refer to the
* Uganda National Panel Survey.



*Summary of Executing the Master do.file
*-----------
* This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
* Using data files from within the "Raw DTA Files" folder, the do.file first constructs common and intermediate variables, 
* saving dtafiles when appropriate in the folder "Final DTA Files/created_data" 
*
* These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available in the
* folder "Final DTA Files/final_data". 


* The processed files include all households, individuals, and plots in the sample. Toward the end of the do.file, a block of code estimates summary 
* statistics (mean, standard error of the mean, minimum, first quartile, 
* median, third quartile, maximum) of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.

* The results are saved in the excel file "Uganda_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "Final DTA Files/final_data" folder. 



/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W2_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W2_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W2_hhsize.dta
*PLOT AREAS							Uganda_NPS_W2_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W2_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Uganda_NPS_W2_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W2_tempcrop_harvest.dta
									Uganda_NPS_W2_tempcrop_sales.dta
									Uganda_NPS_W2_permcrop_harvest.dta
									Uganda_NPS_W2_permcrop_sales.dta
									Uganda_NPS_W2_hh_crop_production.dta
									Uganda_NPS_W2_plot_cropvalue.dta
									Uganda_NPS_W2_parcel_cropvalue.dta
									Uganda_NPS_W2_crop_residues.dta
									Uganda_NPS_W2_hh_crop_prices.dta
									Uganda_NPS_W2_crop_losses.dta
*CROP EXPENSES						Uganda_NPS_W2_wages_mainseason.dta
									Uganda_NPS_W2_wages_shortseason.dta
									
									Uganda_NPS_W2_fertilizer_costs.dta
									Uganda_NPS_W2_seed_costs.dta
									Uganda_NPS_W2_land_rental_costs.dta
									Uganda_NPS_W2_asset_rental_costs.dta
									Uganda_NPS_W2_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W2_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W2_livestock_products.dta
									Uganda_NPS_W2_livestock_expenses.dta
									Uganda_NPS_W2_hh_livestock_products.dta
									Uganda_NPS_W2_livestock_sales.dta
									Uganda_NPS_W2_TLU.dta
									Uganda_NPS_W2_livestock_income.dta

*FISH INCOME						Uganda_NPS_W2_fishing_expenses_1.dta
									Uganda_NPS_W2_fishing_expenses_2.dta
									Uganda_NPS_W2_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W2_self_employment_income.dta
									Uganda_NPS_W2_agproducts_profits.dta
									Uganda_NPS_W2_fish_trading_revenue.dta
									Uganda_NPS_W2_fish_trading_other_costs.dta
									Uganda_NPS_W2_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_W2_wage_income.dta
									Uganda_NPS_W2_agwage_income.dta
*OTHER INCOME						Uganda_NPS_W2_other_income.dta
									Uganda_NPS_W2_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_W2_land_size.dta
									Uganda_NPS_W2_farmsize_all_agland.dta
									Uganda_NPS_W2_land_size_all.dta
*FARM LABOR							Uganda_NPS_W2_farmlabor_mainseason.dta
									Uganda_NPS_W2_farmlabor_shortseason.dta
									Uganda_NPS_W2_family_hired_labor.dta
*VACCINE USAGE						Uganda_NPS_W2_vaccine.dta
*USE OF INORGANIC FERTILIZER		Uganda_NPS_W2_fert_use.dta
*USE OF IMPROVED SEED				Uganda_NPS_W2_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W2_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W2_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_W2_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_W2_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W2_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W2_hh_cost_land.dta
									Uganda_NPS_W2_hh_cost_inputs_lrs.dta
									Uganda_NPS_W2_hh_cost_inputs_srs.dta
									Uganda_NPS_W2_hh_cost_seed_lrs.dta
									Uganda_NPS_W2_hh_cost_seed_srs.dta		
									Uganda_NPS_W2_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W2_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W2_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W2_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W2_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W2_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_W2_ag_wage.dta
*CROP YIELDS						Uganda_NPS_W2_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W2_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W2_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W2_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_W2_summary_stats.xlsx
*/
	
clear
clear matrix
clear mata
set more off
set maxvar 8000

// set directories
* These paths correspond to the folders where the raw data files are located 
* and where the created data and final data will be stored.
global directory "../.."
global Uganda_NPS_W2_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 2/Raw DTA Files"
global Uganda_NPS_W2_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 2/Final DTA Files/created_data"
global Uganda_NPS_W2_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 2/Final DTA Files/final_data"
global Uganda_NPS_conv_factors "$directory/Uganda UNPS/Nonstandard Unit Conversion Factors"
global summary_stats "$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do"

*Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Uganda_NPS_W2_pop_tot 34273295
global Uganda_NPS_W2_pop_rur 27273317
global Uganda_NPS_W2_pop_urb 6999978

* Some other useful local variables
local genders "male female mixed"
local gender_len : list sizeof genders


* Get the length of the crop list. 
local crop_len : list sizeof global(topcropname_area)

* Create data for the species data
local species_list "lrum srum pigs equine poultry"
local species_len : list sizeof local(species_list)

* Define labels for our species categories
label define species 	1 "Large ruminants (cows, buffalos)"	/*
					*/	2 "Small ruminants (sheep, goats)"		/*
					*/	3 "Pigs"								/*
					*/	4 "Equine (horses, donkeys)"			/*
					*/	5 "Poultry (including rabbits)"

********************************************************************************
*                          EXCHANGE RATE AND INFLATION                         *
********************************************************************************
global Uganda_NPS_W2_exchange_rate  3690.85
global Uganda_NPS_W2_gdp_ppp_dollar 1203.16 // 1251.63 was the value in 2017
//https://data.worldbank.org/indicator/PA.NUS.PPP // UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Uganda_NPS_W2_cons_ppp_dollar 1315.27 // 1219.19 was the value in 2017
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2011 // UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Uganda_NPS_W2_inflation (116.6/185.9) // .69904077 was the infl rate in 2017. Data was collected during 2010-2011. Base year should be 2024 and is available as of the most recent update. As of 2025, we want to adjust the value to 2021 // I = CPI_Survey_Year/CPI_2021 = CPI_2011/CPI_2021 = (116.6/185.9)  https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2011 
global Uganda_NPS_W2_poverty_190 (1.9 * 944.26 * (116.6/116.6))  //Calculation for WB's previous $1.90 (PPP) poverty threshold. This controls the indicator poverty_under_190; change the 1.9 to get results for a different threshold. Note this is based on the 2011 PPP conversion. Since the survey was conducted in 2010-2011, we deflate/inflate based on CPI (2011)/CPI (2011)
//Previous international extreme poverty line
global Uganda_NPS_W2_poverty_nbs (3880.75 *(1.108)) //2009-2010 poverty line //New 2017 poverty line - 124.68 UGX
global Uganda_NPS_W2_poverty_215 (2.15 * 1219.19 * (116.6/166.8)) //$2.15 was the poverty line in 2017. 1219.19 was the PPP in 2017 so we deflate based on CPI (2011)/CPI (2017) since that is the year we're adjusting for. 
global Uganda_NPS_W2_poverty_300 (3.00 * $Uganda_NPS_W2_inflation * $Uganda_NPS_W2_cons_ppp_dollar )  //New 2017 poverty line - 124.68 UGX //$3.00 is new poverty line in international PPP dollars which has been updated to 2021. 

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables
global wins_5_thres 5								//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_95_thres 95								//Threshold for winzorization at the top of the distribution of continous variables
********************************************************************************
*GLOBALS OF PRIORITY CROPS 
*******************************************************************************
*CPK: updated this to match main crops in UGA W2.
* Priority Crops (crop code)
//Banana is divided into three categories Banana food 
// (741), Banana beer(742), and Banana sweet (744). For this analysis only 
// Banana Food is used

global topcropname_area "simsim fnmill sorgum grdnt coffee swtptt cassav beans maize banana"
global topcrop_area "340 141 150 310 810 620 630 210 130 740"
global comma_topcrop_area "340, 141, 150, 310, 810, 620, 630, 210, 130, 740"

global nb_topcrops : list sizeof global(topcropname_area) 
display "$nb_topcrops"
set obs $nb_topcrops //Update if number of crops changes
egen rnum = seq(), f(1) t($nb_topcrops)
gen crop_code = .
gen crop_name = ""
forvalues k = 1 (1) $nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area 
	replace crop_code = `c' if rnum == `k'
	replace crop_name = "`cn'" if rnum == `k'
}
drop rnum
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_cropname_table.dta", replace //This gets used to generate the monocrop files.

********************************************************************************
*                                HOUSEHOLD  IDS                                *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC1.dta", clear

* Rename variables to EPAR standard
rename HHID hhid
rename h1aq1 district
rename h1aq2b county
rename h1aq3b subcounty
rename h1aq4b parish
rename stratum strataid
rename wgt10 weight // Includes split off households
// SAK NOTE 20190124_1: All of the numeric codes have been removed from this
// version of the survey.
gen rural = urban==0
rename comm ea

keep hhid region district county subcounty parish ea rural weight strataid
lab var rural "1=Household lives in a rural area"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", replace

********************************************************************************
*WEIGHTS*
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC1.dta", clear
rename HHID hhid
rename wgt10 weight //  SAW using panel weight for round 3 (only weight available) 2850 households total
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta"
keep hhid weight rural
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", replace


********************************************************************************
*                                INDIVIDUAL IDS                                *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC2.dta", clear
rename HHID hhid
keep hhid PID h2q1 h2q3 h2q4 h2q8

rename h2q1 personid
* Fixing errors in transcription for PID/personid
replace personid = 5			if PID == "102100060805"
replace personid = 11			if PID == "103300030411"
replace PID = "10330005110202" 	if PID == "1033000511020"
replace personid = 3			if PID == "10330005110203"
replace personid = 8			if PID == "104300080608"
replace personid = 10			if PID == "105300080810"
replace personid = 5			if PID == "108300270905"
replace personid = 11			if PID == "109300040911"
replace personid = 13			if PID == "112100011013"
replace personid = 6			if PID == "11530004040206"
replace personid = 8			if PID == "11530004040208"
replace personid = 9			if PID == "11530004040209"
replace personid = 7			if PID == "302300051007"
replace personid = 5			if PID == "307300220105"
replace personid = 8			if PID == "320300270708"
replace personid = 4			if PID == "321300280804"
* Dropping duplicate entries
drop if PID == "40230025056"
drop if PID == "11310004095"
* is needed for this analysis
drop if hhid == "1053003307" & personid != 1

* Create female dummy variable and drop the gender variable
gen female = h2q3==0
lab var female "1= indidividual is female"
drop h2q3

* Create head of household dummy variable and drop relationship to hh
gen hh_head = h2q4==1
lab var hh_head "1= individual is household head"
drop h2q4

* Set Age to EPAR standard label
rename h2q8 age
lab var age "Individual age"

* Save data to temp folder
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids.dta", replace


********************************************************************************
*                                HOUSEHOLD SIZE                                *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC2.dta", clear
rename HHID hhid

* Create female-headed household dummy variable 1 if person is head of 
* household and female
gen fhh = (h2q4==1 & h2q3==0)

* Combine all the members of a househould into one entry to get size of 
* household and whether or not the househould is headed by a female.
gen hh_members = 1

collapse (sum) hh_members (max) fhh, by (hhid)

* Label the created variables
lab var fhh "1= Female-headed househould"
lab var hh_members "Number of househould members"

*CPK: 10.23.23 Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Uganda_NPS_W2_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Uganda_NPS_W2_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Uganda_NPS_W2_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhsize.dta", replace

merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", nogen
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", replace


********************************************************************************
*                                  PLOT AREA                                  *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W2_raw_data}/AGSEC4B.dta"	
replace season=2 if season==.
rename HHID hhid
//sniping a few repeated observations 
duplicates drop 
drop if prcid==01 & hhid=="2113000702" & a4aq9==.
drop if prcid==01 & hhid=="3101000109" & pltid==3
drop if prcid==01 & hhid=="1123000308" & pltid==1 & a4bq9==15
replace a4bq9=25 if prcid==01 & hhid=="1123000308" & pltid==1 & cropID==630 //Combining the duplicate area planted
label var season "Season = 1 if 1st cropping season of 2010, 2 if 2nd cropping season of 2010"
rename prcid parcel_id
ren pltid plot_id
ren cropID crop_code
drop if crop_code == .

gen planted_area = a4aq8
replace planted_area = a4bq8 if planted_area==.
recode planted_area (.=0)
bys hhid plot_id parcel_id : egen max_planted_area = max(planted_area) //should be total area planted by plot
//assert max_planted_area==planted_area //3846 contradictions
replace planted_area=max_planted_area
replace planted_area = planted_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen percent_field = a4aq9/100 
replace percent_field =a4bq9/100 if percent_field==.
bys hhid parcel_id plot_id season : gen ncrops=_N
replace percent_field = 1 if percent_field==. & ncrops==1

bys hhid parcel_id plot_id season : egen total_percent_field = sum(percent_field) //generate variable for total percent of a plot that is planted (all crops)
gen missing_ratio=percent_field==.
bys hhid parcel_id plot_id season : egen tot_miss = sum(missing_ratio)
replace percent_field = percent_field/total_percent_field if total_percent_field > 1
replace percent_field = 1/tot_miss if missing_ratio & tot_miss==ncrops
replace percent_field = (1-total_percent_field)/tot_miss if missing_ratio & tot_miss < ncrops & total_percent_field < 1

preserve 
gen use_imprv_seed = (a4aq13==2) if a4aq13!=.
replace use_imprv_seed= (a4bq13==2) if use_imprv_seed==. & a4bq13!=.
keep hhid hhid parcel_id plot_id crop_code percent_field season use_imprv_seed
tempfile crop_area
save `crop_area' 
restore

preserve 
use "${Uganda_NPS_W2_raw_data}/AGSEC2A.dta", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B.dta"
ren prcid parcel_id 
ren HHID hhid
tempfile parcels
save `parcels'
restore

collapse (sum) percent_field, by(hhid parcel_id plot_id season planted_area)
merge m:1 hhid parcel_id using `parcels', nogen keep(1 3)
gen plot_area = planted_area / percent_field
bys hhid parcel_id season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
gen parcel_area = a2aq4 
replace parcel_area=a2bq4 if parcel_area==.
replace parcel_area=a2aq5 if parcel_area==.
replace parcel_area=a2bq5 if parcel_area==.
gen parcel_ha=0.404686*parcel_area
replace parcel_ha=total_plot_area if parcel_ha==.
*Creating it again since helps with mergers later 
gen field_size = plot_area_pct*parcel_ha if total_plot_area > parcel_ha //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size=planted_area if field_size==.
keep hhid parcel_id plot_id season field_size plot_area parcel_area planted_area parcel_ha 
drop if field_size == .
label var field_size "Area of plot (ha)"
label var hhid "Household identifier"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", replace


merge 1:m hhid parcel_id plot_id season using `crop_area'
recode crop_code  (741 742 744 = 740)
label define cropID 740 "BANANAS", modify
gen ha_planted=percent_field*planted_area 
	collapse (sum) ha_planted percent_field (max) use_imprv_seed, by(hhid parcel_id plot_id season crop_code field_size)
	bys hhid parcel_id plot_id season : gen n_crops=_N
	gen purestand=n_crops==1
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_areas.dta", replace

collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_planted_area.dta", replace

********************************************************************************
*                             PLOT DECISION MAKERS                             *
********************************************************************************

use "${Uganda_NPS_W2_raw_data}/AGSEC2A.dta", clear 
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B.dta" 
rename HHID hhid
ren prcid parcel_id
gen formal_land_rights = (a2aq25==1 | a2aq25==2 | a2aq25==3) //Short season parcels appear to be rented-in only.
*First decision-maker variables 
gen personid1 = a2aq28a
replace personid1=a2bq26a if personid1==.   
gen personid2=a2aq28b
replace personid2=a2bq26b if personid2==.
keep hhid /*plot_id*/ parcel_id  personid* formal_land_rights
reshape long personid, i(hhid parcel_id formal_land_rights) j(id_no)                                                          
merge m:1 hhid personid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen keep(1 3) //Dropping unmatched from using
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_dm_ids.dta", replace
preserve 
gen formal_land_rights_f=formal_land_rights if female==1
collapse (max) formal_land_rights_f, by(hhid personid) 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_rights_ind.dta", replace
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid) 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_rights_hh.dta", replace
restore
gen dm1_gender=female+1 if id_no==1
collapse (mean) female (firstnm) dm1_gender, by(hhid parcel_id)
gen dm_gender=3 if female!=.
replace dm_gender=1 if female==0
replace dm_gender=2 if female==1
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", nogen keepusing(fhh) keep(1 3)
*Replacing observations without gender of plot manager with gender of HOH
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
replace dm1_gender=dm_gender if dm_gender < 3 & dm1_gender==.
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
la val dm1_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"
drop female fhh
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", replace 

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
*see above
 
********************************************************************************
*                                  AREA PLANTED                                *
********************************************************************************
*see plot areas

********************************************************************************
*                        ALL PLOTS		
********************************************************************************
**********************************
** Crop Values **
**********************************
//CPK: Updating this section to match Seb's Uganda Wave 3 - 10.9.23
use "${Uganda_NPS_W2_raw_data}/AGSEC5A.dta", clear
gen season=1
append using "${Uganda_NPS_W2_raw_data}/AGSEC5B.dta"
replace season=2 if season==.
* Unit of Crop Harvested 
clonevar condition_harv = a5aq6b
replace condition_harv = a5bq6b if season==2
clonevar unit_code_harv=a5aq6c
replace unit_code_harv=a5bq6c if unit_code==.

*Unit of Crop Sold
gen value_sales=a5aq8
replace value_sales=a5bq8 if value_sales==.
clonevar sold_unit_code =a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
*CPK: some cells are missing unit codes but there is a sold value so I took the unit code from regular unit code 
replace sold_unit_code = unit_code if (value_sales != . & value_sales != 0 & missing(sold_unit_code))
gen sold_qty=a5aq7a
replace sold_qty=a5bq7a if sold_qty==.

rename HHID hhid
tostring hhid, format(%18.0f) replace
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
rename pltid plot_id
rename prcid parcel_id
rename cropID crop_code
merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

**We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. // We merge the national standard conversion factor for those HHID with missing regional info. 
gen quant_sold_kg = sold_qty*s_conv_factor_sold
replace quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen price_unit = value_sales/quant_sold_kg 
gen obs = price_unit!=.


// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standard conversion factor table)
foreach i in region district county subcounty parish ea {
		preserve
		collapse (median) price_unit_`i' = price_unit (rawsum) obs_`i'=obs [aw=weight], by(`i' crop_code)
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (rawsum) obs_country_price = obs [aw=weight], by(crop_code)
	tempfile price_unit_country_median
	save `price_unit_country_median'
	restore
	
clonevar  unit_code= unit_code_harv
merge m:1 crop_code unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
*This is for hhid that are missing regional information
//710 obs for "other" that we can't fill in because no specification is given. 
*From Conversion factor section to calculate medians
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity_harv==. 
replace s_conv_factor_harv = sn_conv_factor_harv if s_conv_factor_harv==. // We merge the national standard conversion factor for those HHID with missing regional info.
gen quant_harv_kg = quantity_harv*s_conv_factor_harv 


ren price_unit price_unit_hh
gen price_unit=.

foreach i in country region district county parish ea {
	if "`i'"=="country" {
		merge m:1 crop_code using `price_unit_`i'_median', nogen
	} 
	else {
	merge m:1 `i' crop_code using `price_unit_`i'_median', nogen
	}
	recode obs_`i' (.=0)
	replace price_unit=price_unit_`i' if obs_`i' > 9
}

replace price_unit_hh=price_unit if price_unit_hh==.
replace price_unit=price_unit_hh if price_unit==.
gen value_harvest=price_unit*quant_harv_kg
gen value_harvest_hh=price_unit_hh * quant_harv_kg


gen month_harv_date = a5aq6e
replace month_harv_date = a5bq6e if season==2
gen harv_date = ym(2010,month_harv_date)
format harv_date %tm
label var harv_date "Harvest start date"

gen month_harv_end = a5aq6f
replace month_harv_end = a5bq6f
gen harv_end = ym(2010,month_harv_end) if month_harv_end>month_harv_date
replace harv_end = ym(2011,month_harv_end) if month_harv_end<month_harv_date
format harv_end %tm
label var harv_end "Harvest end date" 

*Date/month is not there 
label var price_unit "Average sold value per kg of harvest sold"
preserve
	ren unit_code_harv unit
	collapse (mean) val_unit=price_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_prices_for_wages.dta", replace
restore
gen pct_lost=a5aq16/100
replace pct_lost = a5bq16/100 if pct_lost==.
gen quant_lost_kg =  quant_harv_kg*pct_lost 
gen value_lost=quant_lost_kg*price_unit
gen no_harvest=quantity_harv==. //Assuming missing values means the crop wasn't harvested. (52 obs of month harvest begins out of 2,286 missing; majority of obs are either cassava, coffee, fallow, or trees.)
recode crop_code  (741 742 744 = 740)
label define cropID 740 "BANANAS", modify
collapse (sum) quant_harv_kg quant_sold_kg quant_lost_kg value* (mean) price_unit (max) no_harvest, by(hhid parcel_id plot_id crop_code season)
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_value.dta", replace 

**********************************
** Plot Variables **
**********************************
	use  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_areas.dta", clear
	merge m:1 hhid parcel_id using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", nogen keep(1 3)
	merge 1:1 hhid parcel_id plot_id crop_code season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_value.dta", nogen keep(1 3)
	merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", nogen keep(1 3) keepusing(region ea district county subcounty parish rural)
	gen ha_harvest=ha_planted if !no_harvest
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", replace

********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************	
********************************************************************************
*                              GROSS CROP REVENUE                              *
********************************************************************************

use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_value.dta", clear
collapse (sum) value_sales value_harvest, by (hhid crop_code)
ren value_sales value_crop_sales 
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production.dta", replace
collapse (sum) value_crop_production value_crop_sales, by (hhid)
replace value_crop_production=value_crop_sales if value_crop_production < value_crop_sales //Use sales when available.
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_production.dta", replace

*Crops lost post-harvest //Legacy
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_value.dta", clear
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_losses.dta", replace


********************************************************************************
*                                 CROP EXPENSES                                *
********************************************************************************
 
 /*******************/
 /* Expenses: Labor */
/*******************/

use "${Uganda_NPS_W2_raw_data}/AGSEC3A.dta", clear 
gen season = 1
append using "${Uganda_NPS_W2_raw_data}/AGSEC3B.dta" 
replace season = 2 if season == .
ren pltid plot_id
rename prcid parcel_id
ren a3aq42a dayshiredmale
replace dayshiredmale = a3bq42a if dayshiredmale == .
replace dayshiredmale = . if dayshiredmale == 0

ren a3aq42b dayshiredfemale
replace dayshiredfemale = a3bq42b if dayshiredfemale == .
replace dayshiredfemale = . if dayshiredfemale == 0

ren a3aq42c dayshiredchild
replace dayshiredchild = a3bq42c if dayshiredchild == .
replace dayshiredchild = . if dayshiredchild == 0
	
ren a3aq43 wagehired
replace wagehired = a3bq43 if wagehired == .
gen wagehiredmale = wagehired if dayshiredmale != .
gen wagehiredfemale = wagehired if dayshiredfemale != .
gen wagehiredchild = wagehired if dayshiredchild != .

recode dayshired* (.=0)
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild

replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal
replace wagehiredchild = wagehiredchild/dayshiredtotal
ren HHID hhid
keep hhid parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

*duplicates drop HHID parcel_id plot_id season, force
reshape long dayshired wagehired, i(hhid parcel_id plot_id season) j(gender) string
reshape long days wage, i(hhid parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0

gen val = wage*days
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district county subcounty parish ea hhid {
preserve
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i' = wage [aw = plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
}
preserve
collapse (median) wage_country = wage (sum) obs_country = obs [aw = plotweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore

drop obs plotweight wage rural
tempfile all_hired
save `all_hired'

******************************  FAMILY LABOR   *********************************

use "${Uganda_NPS_W2_raw_data}/AGSEC3A", clear 
gen season = 1
append using "${Uganda_NPS_W2_raw_data}/AGSEC3B"
replace season = 2 if season == .
ren pltid plot_id
ren prcid parcel_id 
ren a3aq39 days
ren HHID hhid
rename a3aq38 fam_worker_count
ren a3aq40* PID_* 
keep hhid parcel_id plot_id season PID* days fam_worker_count

preserve
use "${Uganda_NPS_W2_raw_data}/GSEC2", clear 
*the PID I want is the individual person ID, I dropped the long-form PID so I can continue to merge using the PID in the other sections
*gen PID2 = substr(PID,-2,.)
drop PID
rename h2q1 PID
gen male = h2q3 == 1
gen age = h2q8
keep HHID PID age male
*rename HHId hhid
duplicates list HHID PID
duplicates drop  HHID PID, force // Is this allowed? otherwise I can't do the rest of this haha - 20 deleted
isid HHID PID 
ren HHID hhid
tempfile members
save `members', replace
restore

reshape long PID, i(hhid parcel_id plot_id season) j(colid) string
drop if days == .
tostring hhid, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
merge m:1 hhid PID using `members', nogen keep(1 3) 
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & male == 1
replace gender = "female" if strmatch(gender, "") & male == 0 
replace gender = "unknown" if strmatch(gender, "") & male == .
gen labor_type = "family"
drop if gender == "unknown"
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county subcounty parish ea hhid parcel_id plot_id season gender days labor_type fam_worker_count

foreach i in region district county subcounty parish ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) 

	gen wage = wage_hhid
	*recode wage (.=0)
foreach i in country region district county subcounty parish ea {
	replace wage = wage_`i' if obs_`i' > 9
	} //Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in gaps of implicit labor value.

/*
by hhid parcel_id plot_id season, sort: egen numworkers = count(_n)
replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
*/

gen val = wage * days
append using `all_hired'
keep region district county subcounty parish ea hhid parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 hhid parcel_id using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(hhid parcel_id plot_id season labor_type gender dm_gender) 
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (hhid parcel_id plot_id labor_type season)
reshape wide labor_, i(hhid parcel_id plot_id season) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_labor_days.dta", replace
restore

preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(hhid parcel_id plot_id exp dm_gender season) 
	gen input = "labor"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_labor.dta", replace
restore	
//And now we go back to wide
collapse (sum) val, by(hhid parcel_id plot_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(hhid parcel_id plot_id dm_gender) j(season)
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
drop dm_gender
ren val* val*_
drop if dm_gender2 == ""
reshape wide val*, i(hhid parcel_id plot_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_cost_labor.dta", replace

***************************    LAND RENTALS   **********************************
//Get parcel rent data
use "${Uganda_NPS_W2_raw_data}/AGSEC2B", clear 
ren prcid parcel_id
ren a2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring HHID, format(%18.0f) replace
ren HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", replace
merge m:1 hhid parcel_id using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_rental.dta", nogen keep (3)
gen qtyparcelrentexp = parcel_ha if valparcelrentexp > 0 & valparcelrentexp != .
gen qtyparcelrentimp = parcel_ha if qtyparcelrentexp == . //this land does not have an agreement with owner, but is rented

//Estimate rented plot value, using percentage of parcel 
gen plot_percent = field_size / parcel_ha
gen valplotrentexp = plot_percent * valparcelrentexp
gen qtyplotrentexp = qtyparcelrentexp * plot_percent
gen qtyplotrentimp = qtyparcelrentimp * plot_percent //quantity of "imp" land is that which is not rented

//Clean-up data
keep hhid parcel_id plot_id season qtyparcelrent* valplotrent* qtyplotrent* 

	preserve //this section creates a variable, duplicate, which can tell if a plot was rented over two seasons. This way, rent is disaggregated by plot and by season.
	keep hhid parcel_id season 
	duplicates drop
	collapse (count) numseas=season, by(hhid parcel_id)
	tempfile parcel_rent
	save `parcel_rent'
	restore

merge m:1 hhid parcel_id using `parcel_rent', nogen 
*by hhid parcel_id plot_id : egen dumseason = total(season) if duplicate == 1
reshape long valparcelrent qtyparcelrent valplotrent qtyplotrent, i(hhid parcel_id plot_id season numseas) j(exp) string
reshape long val qty, i(hhid parcel_id plot_id season exp numseas) j(input) string
replace val=val/numseas
gen unit = 1 //dummy var
gen itemcode = 1 //dummy var
tempfile plotrents
save `plotrents'

***************************    SEEDS   **********************************
use "${Uganda_NPS_W2_raw_data}/AGSEC4A.dta", clear
gen season = 1
append using "${Uganda_NPS_W2_raw_data}/AGSEC4B.dta"
replace season = 2 if season == .
ren pltid plot_id
ren prcid parcel_id
ren cropID crop_code
gen purestand = a4aq7 if a4aq7==1
replace purestand = a4bq7 if a4bq7 == 1 & purestand != 1
*CPK: No question that gets at how much seed was used for the crop 
*ren a4aq11a qtyseeds //includes all types of seeds (purchased, left-over, free, etc.)
*replace qtyseeds = a4bq11a if qtyseeds == . //add second season
*CPK: No question that gets at unit
*ren a4aq11b unitseeds //includes all types of seeds (purchased, left-over, free, etc.)
*replace unitseeds = a4bq11b if unitseeds == . //add second season
ren a4aq11 valseeds //only value for purchased seeds. There is no quantity for purchased seeds, so one cannot calculate per kg value of seeds.
replace valseeds = a4bq11 if valseeds == . //add second season

keep val* purestand HHID parcel_id plot_id crop_code season
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates, similar process as above for fertilizers
drop dummya
reshape long qty unit val, i(HHID parcel_id plot_id season dummyb) j(input) string
collapse (sum) val, by(HHID parcel_id plot_id season input crop_code purestand)
*ren unit unit_code
*drop if qty == 0
*drop input //there is only purchased value, none of it is implicit (free, left over, etc.)

ren crop_code itemcode
ren HHID hhid
collapse (sum) val, by(hhid parcel_id plot_id season input itemcode) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for. JHG 7_5_22: all this code does is drop variables, it doesn't actually collapse anything
gen exp = "exp"
tempfile seeds
save `seeds'

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.
**********************    PESTICIDES/HERBICIDES   ******************************

  /********************/
 /* Expenses: Inputs */
/********************/

*FORMALIZED LAND RIGHTS
************************
*Cut, see plot areas. 

  /************************************************/
 /* Expenses: fertilizer and pesticide purchase   /
/************************************************/
*/
use "${Uganda_NPS_W2_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W2_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
ren pltid plot_id
ren prcid parcel_id
ren HHID hhid
tostring hhid, format(%18.0f) replace
//Not a whole lot of detail on what input was used 
ren a3aq27 itemcodepest
ren a3aq28a unitpest //unit code for total pesticides used, first planting season (kg = 1, litres = 2)
ren a3aq28b qtypest //quantity of unit for total pesticides used, first planting season
replace unitpest = a3bq28a if unitpest == . //add second planting season
replace qtypest = a3bq28b if qtypest == . //add second planting season
replace itemcodepest=a3bq27 if itemcodepest==.
ren a3aq30 qtypestexp //amount of total pesticide that is purchased
replace qtypestexp = a3bq30 if qtypestexp == . //add second planting season
replace qtypest = qtypestexp if qtypestexp > qtypest & qtypestexp!=.
gen qtypestimp = qtypest - qtypestexp //this calculates the non-purchased amount of pesticides used	
ren a3aq31 valpestexp
replace valpestexp = a3bq31 if valpestexp == .	
gen valpestimp = qtypestimp*valpestexp/qtypestexp
rename unitpest unitpestexp
gen unitpestimp = unitpestexp
drop qtypest

gen qtyanmlexp = .
gen qtyanmlimp = .
gen unitanmlexp = .
gen unitanmlimp = .
gen valanmlexp = .
gen valanmlimp = .


********** Inorganic Fertilizer ********** 

gen itemcodeinorgexp = a3aq15 
replace itemcodeinorgexp=a3bq15 if itemcodeinorgexp==.
gen itemcodeinorgimp=itemcodeinorgexp 
gen qtyinorg = a3aq16
replace qtyinorg = a3bq16 if qtyinorg==.

gen qtyinorgexp = a3aq18 
replace qtyinorgexp = a3bq18 if qtyinorgexp == . 
replace qtyinorg = qtyinorgexp if qtyinorg < qtyinorgexp & qtyinorgexp!=.
gen valinorgexp = a3aq19
replace valinorgexp = a3bq19
gen qtyinorgimp = qtyinorg - qtyinorgexp // imputed Kg
drop qtyinorg
gen valinorgimp= valinorgexp/qtyinorgexp*qtyinorgexp

********** Organic Fertilizer ********** 

// Organic fertilizer for two seasons
gen qtyorgfert =a3aq5 
replace qtyorgfert= a3bq5 if qtyorgfert==.
gen qtyorgfertexp=a3aq7 
replace qtyorgfertexp=a3bq7 if qtyorgfertexp==.
replace qtyorgfert = qtyorgfertexp if qtyorgfert < qtyorgfertexp & qtyorgfertexp!=.
gen valorgfertexp=a3aq8
replace valorgfertexp=a3bq8 if valorgfertexp==.
gen qtyorgfertimp = qtyorgfert - qtyorgfertexp 
drop qtyorgfert
gen valorgfertimp = valorgfertexp/qtyorgfertexp*qtyorgfertimp 
gen itemcodeorgfertimp=5 //Using a separate itemcode from fertilizers. 
gen itemcodeorgfertexp=5

*************************    MACHINERY INPUTS   ********************************
preserve //This section creates raw data on value of machinery/tools
use "${Uganda_NPS_W2_raw_data}/AGSEC10", clear 
*drop if own_implement == 2 //2 = no farm implement owned, rented, or used (separated by implement)
ren a10q1 qtymechimp //number of owned machinery/tools
ren a10q2 valmechimp //total value of owned machinery/tools, not per-item
ren a10q7 qtymechexp //number of rented machinery/tools
ren a10q8 valmechexp //total value of rented machinery/tools, not per-item
ren itmcd itemcode
tostring HHID, format(%18.0f) replace
ren HHID hhid
tempfile rawmechexpense
save `rawmechexpense', replace
restore

preserve
//Assume mechanical implements are used equally over the household area. 
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", clear
bys hhid season : egen tot_ha_planted=sum(planted_area)
gen planted_percent = planted_area/tot_ha_planted 
keep hhid parcel_id plot_id season planted_percent
merge m:m hhid using `rawmechexpense', nogen
replace valmechexp = valmechexp * planted_percent //replace total with plot and season specific value of rented machinery/tools
replace valmechimp = valmechimp * planted_percent
replace qtymechimp = qtymechimp * planted_percent 
replace qtymechexp = qtymechexp * planted_percent
keep hhid parcel_id plot_id season itemcode val* qty* 
gen dummy=_n
reshape long qtymech valmech, i(hhid parcel_id plot_id season itemcode dummy) j(exp) string
replace dummy=_n
reshape long qty val, i(hhid parcel_id plot_id season itemcode exp dummy) j(input) string
drop dummy
tempfile mechexpenses
save `mechexpenses'
restore 

//Now to reshape long and get all the medians at once.
keep hhid parcel_id plot_id season qty* val* unit* itemcode*
unab vars : *exp //create a local macro called vars out of every variable that ends with exp
local stubs : subinstr local vars "exp" "", all //create another local called stubs with exp at the end, with "exp" removed. This is for the reshape below
reshape long `stubs', i(hhid parcel_id plot_id season) j(exp) string
reshape long val qty unit, i(hhid parcel_id plot_id season exp) j(input) string
append using `mechexpenses'
append using `seeds'
append using `plotrents'
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", nogen keep(1 3)
drop weight 
ren weight_pop_rururb weight
tempfile plotinputs 
save `plotinputs'
gen price = val/qty 
keep if price!=.  & exp=="exp" //Avoiding duplicate observations for implicit inputs already valued

foreach i in country region district county subcounty parish ea {
preserve
	if "`i'" == "country" {
		collapse (median) price_`i'=price (count) obs_`i' = price, by(input itemcode)
	}
	else {
	collapse (median) price_`i'=price (count) obs_`i' = price, by(`i' input itemcode)		
	}

tempfile input_prices_`i'
save `input_prices_`i''
restore
}

use `plotinputs', clear
gen input_price=.
foreach i in country region district county subcounty parish ea {
if "`i'" == "country" {
	merge m:1 input itemcode using `input_prices_`i'', nogen
} 
else {
	merge m:1 `i' input itemcode using `input_prices_`i'', nogen
}
recode obs_`i' (.=0)
replace input_price = price_`i' if obs_`i' > 9
}

replace val = input_price*qty if val==. 
drop if val==. & qty==. 

preserve
keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"pest") //would also have herbicide here if Uganda tracked herbicide separately of pesticides
		gen n_kg =qty*itemcode==1
		gen p_kg = qty*itemcode==2
		gen k_kg = qty*itemcode==3
		gen pest_kg = qty*strmatch(input, "pest")
		gen inorg_fert_kg = qty*strmatch(input, "inorg")
		gen org_fert_kg = qty if itemcode >=5 & itemcode!=.
		collapse (sum) *kg, by(hhid parcel_id plot_id season)
		la var inorg_fert_kg "Kg inorganic fertilizer used"
		la var org_fert_kg "Kg organic fertilizer used"
		la var n_kg "Kg of nitrogen applied"
		la var p_kg "Kg of phosphorus applied"
		la var k_kg "Kg of potassium applied"	
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_input_quantities.dta", replace
restore

merge m:1 hhid parcel_id using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", nogen keepusing(dm_gender)
append using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_labor.dta"
drop if plot_id==.
collapse (sum) val, by (hhid parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_long.dta", replace

preserve
collapse (sum) val, by(hhid exp input)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_cost_inputs_long.dta", replace
restore

preserve
collapse (sum) val_ = val, by(hhid parcel_id plot_id season exp dm_gender)
reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs.dta", replace //This gets used below.
restore

//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
ren val val_ 
reshape wide val_, i(hhid parcel_id plot_id season exp dm_gender) j(input) string
ren val* val*_
reshape wide val*, i(hhid parcel_id plot_id season dm_gender) j(exp) string
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
replace dm_gender2 = "unknown" if dm_gender == . 
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
collapse (sum) val*, by(hhid)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}
egen val_exp_hh = rowtotal(*_exp_hh)
egen val_imp_hh = rowtotal(*_imp_hh)
drop val_mech_imp* 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_cost_inputs_verbose.dta", replace 


//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", replace 
collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_long.dta", clear
//back to wide
drop input
collapse (sum) val, by(hhid parcel_id plot_id season exp dm_gender)
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
replace dm_gender2 = "unknown" if dm_gender == . 
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid parcel_id plot_id season dm_gender2) j(exp) string
ren val* val*_
*destring hhid, replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
*tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid) //JHG 7_5_22: double-check this section to make sure there is now weirdness with summing up to household level when there are multiple seasons - was too tired when coding this to go back and check
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_cost_inputs.dta", replace 

/*CPK: 5.15.23 this is bad code etiquette but I am going back and annualizing cost_inputs_long at the end so I don't need to change what comes after... 
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_long.dta", clear
collapse (sum) val, by (HHID parcel_id plot_id exp input dm_gender)
drop if plot_id ==.
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_long.dta", replace
*/


********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************p
*/
*Purpose: Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots

use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", replace
keep if purestand == 1 
ren ha_planted monocrop_ha
ren quant_harv_kg kgs_harv_mono
ren value_harvest val_harv_mono

*This loop creates 17 values using the nb_topcrops global (as that is the number of priority crops), then generates two .dtas for each priority crop that contains household level variables (split by season). You can change which priority crops it uses by adjusting the priority crops global section near the top of this code.
forvalues k = 1(1)$nb_topcrops  {		
preserve	
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
local cn_full : word `k' of $topcropname_area_full
keep if crop_code == `c'			
ren monocrop_ha `cn'_monocrop_ha
drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==.  		
ren kgs_harv_mono kgs_harv_mono_`cn'
ren val_harv_mono val_harv_mono_`cn'
gen `cn'_monocrop = 1
la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop.dta", replace
	
foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
gen `i'_male = `i' if dm_gender == 1
gen `i'_female = `i' if dm_gender == 2
gen `i'_mixed = `i' if dm_gender == 3
}
	
la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
la var `cn'_monocrop "Household has at least one `cn' monocrop"
la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
la var val_harv_mono_`cn' "Value of harvested `cn' (UGSH)"
foreach g in male female mixed {		
la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
}
collapse (sum) *monocrop* kgs_harv* val_harv*, by(hhid /*season*/)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop_hh_area.dta", replace
restore
}

*CPK: to do - figure out where Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_long was created and how to do it in W2
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid parcel_id plot_id dm_gender season) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	drop if dm_gender2 =="" // SAW 1.5.23 drop close to 200 observations with no gender information so reshape runs
	reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
	merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_inputs_`cn'.dta", replace
restore
}


********************************************************************************
*                                 LIVESTOCK  + TLUs                            *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/AGSEC6A.dta", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC6B.dta"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6C.dta"
drop if HHID == ""

  /********/
 /* TLUs */
/********/
gen lvstckid = a6aq3
replace lvstckid = a6bq3 if missing(lvstckid) & ~missing(a6bq3)
replace lvstckid = a6cq3 if missing(lvstckid) & ~missing(a6cq3)

* Generate the TLU Coefficient based on the animal type
*Indigenous and Exotic Cattle represented in 1-10
gen tlu_coefficient 	= 0.5 if inrange(lvstckid, 1, 10)

* Donkeys
replace tlu_coefficient = .3 if lvstckid == 11

* No Horse mule disaggregation using the average of the two tlu's
replace tlu_coefficient = .55 if lvstckid == 12

* Indigeneous and exotic goats and sheep, male and female represented in 13-20
replace tlu_coefficient = .10 if inrange(lvstckid, 13, 20)

* Pigs
replace tlu_coefficient = .20 if lvstckid == 21

* Rabbits, backyard chicken, parent stock for broilers, parent stock for layers
* layers, pullet chicks, growers, broilers, turkeys, ducks, and geese and other
* birds represented in 31-41
replace tlu_coefficient = .01 if inrange(lvstckid, 31, 41)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
  /*******************/
 /* Owned Livestock */
/*******************/
* Create dummy variables for our categories of livestock
* Cattle or large ruminants (Calves, Bulls, Oxen, Heifer, and Cows) 1-10
gen cattle 		= inrange(lvstckid, 1, 10)

* Small ruminants (Goats and Sheep) 13-20 
gen smallrum	= inrange(lvstckid, 13, 20)

* Poultry (Chicken, Turkeys, Geese) 32-41
gen poultry		= inrange(lvstckid, 32, 41)

* Other Livestock (Donkeys, Horses/Mules, Pigs, Rabbits) 11, 12, 21, 31
gen other_ls 	= inlist(lvstckid, 11, 12, 21, 31)

* Cows (Exotic and Indigeneous) 5, 10
gen cows		= inlist(lvstckid, 5, 10)

* Chickens or poultry (Backyard chicken, Parent stock for broilers, Parent Stock for 
* layers, Pullet Chicks, Growers, Broilers) 32-38
gen chicken		= inrange(lvstckid, 32, 38)

/* Livestock Holdings 1 year ago */
* There are only livestock holdings from 1 year ago for cattle
gen nb_ls_1yearago		= a6aq7

* Assign the amount of livestock owned 1 year ago to the various categories
gen nb_cattle_1yearago		= nb_ls_1yearago	if cattle == 1
gen nb_cows_1yearago		= nb_ls_1yearago	if cows == 1
gen tlu_1yearago			= nb_ls_1yearago * tlu_coefficient

* For small ruminants there is no data from 1 year ago, only 6 months ago. 
* Created as missing for compatibility
gen nb_smallrum_1yearago	= . 

* For Poulty data is for 3 months ago, created as missing for compatibility.
gen nb_poultry_1yearago		= . 
gen nb_chickens_1yearago	= . 

* Other cuts across the different data files and therefore some elements have
* one year ago, some 6 months and some 3 months. Created as missing for
* compatibility
gen nb_other_ls_1yearago	= .

/* Current Livestock Holdings */
* Combine ownership numbers from all of the different livestock subsections
egen nb_ls_today = rowtotal(a6aq5a a6bq5a a6cq5a) if lvstckid != 42

* Assign the amount of livestock owned today to the various categories
gen nb_cattle_today		= nb_ls_today	if cattle == 1
gen nb_smallrum_today	= nb_ls_today	if smallrum == 1
gen nb_poultry_today	= nb_ls_today	if poultry == 1
gen nb_other_ls_today	= nb_ls_today 	if other_ls == 1
gen nb_cows_today		= nb_ls_today	if cows == 1
gen nb_chickens_today	= nb_ls_today	if chicken == 1
gen tlu_today			= nb_ls_today * tlu_coefficient

* Collapse to the household level
recode tlu_* nb_* (. = 0)
ren HHID hhid
collapse (sum) tlu_* nb_*, by (hhid)


* Label the newly created variables (today)
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminants owned as of the time of survey"
lab var nb_poultry_today "Number of poultry owned as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (donkey, horse/mule, pigs, and rabbits) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"

* Label the newly created variables (1 year ago)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var nb_smallrum_1yearago /*
	*/ "Number of small ruminants owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago /*
	*/ "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"

* Get rid of the TLU coefficient
drop tlu_coefficient
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_TLU_Coefficients.dta", /*
	*/ replace

/*
  /***************************/
 /* Crops Lost Post Harvest */
/***************************/
use "${Uganda_NPS_W2_raw_data}/AGSEC5A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC5B.dta"

* Drop observations without a plot id or a parcel id
drop if missing(pltid) | missing(prcid)

* Standardizing major variable names across waves/files
rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

* Unify the first and second season responses into one variable
rename a5aq6a qty_harvest
replace qty_harvest =  a5bq6a 	if missing(qty_harvest)

rename a5aq6d conversion
replace conversion = a5bq6d 	if missing(conversion)

rename a5aq16 percent_lost
replace percent_lost = a5bq16	if missing(percent_lost)

* Some of the entries have percent lost from 1-100 rather than 0-1
replace percent_lost = percent_lost / 100 if percent_lost > 1 & /*
		*/ ~missing(percent_lost)

* KGs harvested = quantity harvested times conversion factor
gen kgs_harvest = qty_harvest * conversion

* Calculate the Kgs Lost
gen kgs_lost = kgs_harvest * percent_lost

* merge in price per kg data. 
merge m:1 HHID parcel_id plot_id crop_code using /*
	*/ "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_values_temp.dta", /*
	*/ keep(1 3)

* Multiple kgs lost by price per kg (imputed) to 
gen crop_value_lost = kgs_lost * price_kg

* Sum losses for the entire household. 
collapse (sum) crop_value_lost, by(HHID)
label variable crop_value_lost /*
	*/ "Value of crop production which had been lost by the time of the survey"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_losses.dta", replace


*/
********************************************************************************
*                               LIVESTOCK INCOME                               *
********************************************************************************

  /**********************/
 /* Livestock Expenses */
/**********************/
* Load the data
use "${Uganda_NPS_W2_raw_data}/AGSEC7", clear

* Place livestock costs into categories
generate cost_hired_labor_livestock	= a7q4 	if a7q2 == 1
generate cost_fodder_livestock		= a7q4	if a7q2 == 2
generate cost_vaccines_livestock	= a7q4	if a7q2 == 3
generate cost_other_livestock		= a7q4	if a7q2 == 4
* Water costs are not captured outside of "other"
generate cost_water_livestock		= 0
rename HHID hhid
recode cost_* (.=0)
preserve
	* Species is not captured for livestock costs, and so this disaggregation
	* is impossible. Created for conformity with other waves
	gen cost_lrum = .
	keep hhid cost_lrum
	label variable cost_lrum "Livestock expenses for large ruminants"
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_lrum_expenses", replace
restore

* Collapse Livestock costs to the household level
collapse (sum) cost_*, by(hhid)

label variable cost_water_livestock			"Cost for water for livestock"
label variable cost_fodder_livestock 		"Cost for fodder for livestock"
label variable cost_vaccines_livestock 		/*
	*/ "Cost for vaccines and veterinary treatment for livestock"
label variable cost_hired_labor_livestock	"Cost for hired labor for livestock"

* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_expenses.dta", /*
	*/ replace


  /**********************/
 /* Livestock Products */
/**********************/
****************************************************************************
***********************************************************************

* new livestock products - CPK
use "${Uganda_NPS_W2_raw_data}/AGSEC8", clear
rename a8q2 livestock_code
*CPK: dropping unnecessary variables for coding ease
drop a8q8 a8q9a a8q9b a8q10 
*CPK: dropping anything that is not milk, ghee or eggs
drop if inlist(livestock_code,6,7,8,9,10,11,12,13,14,15)
ren a8q4 prod_permonth
drop if prod_permonth==.
ren a8q5 unit_prod
* Trays of eggs to numbers of eggs
replace prod_permonth 	= prod_permonth * 30 if livestock_code == 5 & unit_prod == 3
ren a8q3 prod_months
gen qty_produced = prod_months*prod_permonth
lab var qty_produced "Production in past 12 months"
ren a8q6 qty_sold 
*CPK: original code didn't change quantity sold from trays to numbers! 
replace qty_sold 	= qty_sold * 30 if livestock_code == 5 & unit_prod == 3
replace unit			= 4 				  if livestock_code == 5 & unit_prod == 3
gen earnings_sales = a8q7*prod_months 
lab var earnings_sales "Earnings in past 12 months"
drop a8q7
*CPK: I don't think it makes sense to reshape here based on how I did this!
*gen dummy = _n
*reshape long prod_permonth qty_produced qty_sold earnings_sales dummy, i(HHID livestock_code) j(product, string)
*drop dummy
gen price_unit = earnings_sales/qty_sold
ren HHID hhid
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_livestock_products.dta", replace

* Price Imputation * 
********************
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_livestock_products.dta", clear
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", keep(1 3) nogen
collapse (median) price_unit [aw=weight], by (livestock_code)
ren price_unit price_unit_median_country
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_products_prices_country.dta", replace

* Livestock Products * 
********************
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_livestock_products.dta", clear
merge m:1 livestock_code using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_products_prices_country.dta", nogen keep(1 3)
keep if qty_produced !=0
gen value_produced = price_unit * qty_produced * prod_months
replace value_produced = price_unit_median_country * qty_produced * prod_months if value_produced==.
*CPK: not sure why the below line is in the code? 
replace value_produced = earnings_sales if value_produced==.
lab var price_unit "Price per liter kgs or egg using local median prices if household did not sell"
gen value_milk_produced = qty_produced * price_unit * prod_months if livestock_code==1 |livestock_code==2|livestock_code==3
replace value_milk_produced = qty_produced * price_unit_median_country * prod_months if livestock_code==1 |livestock_code==2|livestock_code==3 & value_milk_produced==.
gen value_eggs_produced = qty_produced * price_unit * prod_months if livestock_code==5
replace value_eggs_produced = qty_produced * price_unit_median_country * prod_months if livestock_code==5 & value_eggs_produced==.
gen value_ghee_produced = qty_produced * price_unit * prod_months if livestock_code==4
replace value_ghee_produced = qty_produced * price_unit_median_country * prod_months if livestock_code==4 & value_ghee_produced==.
*Share of total production sold
gen sales_livestock_products = earnings_sales	
gen sales_milk = earnings_sales if livestock_code==1 |livestock_code==2|livestock_code==3
gen sales_eggs = earnings_sales if livestock_code==5
gen sales_ghee = earnings_sales if livestock_code==4
collapse (sum) value_milk_produced value_eggs_produced value_ghee_produced sales_livestock_products /*agquery*/ sales_milk sales_eggs sales_ghee, by (hhid)
**
*Share of production sold
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_ghee_produced)
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of livestock products that is sold" 
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_products.dta", replace

****************************************************************************
*LIVESTOCK SOLD (LIVE)*  
***************************************************************************
*look at individual created data for this  - something is weird
use "${Uganda_NPS_W2_raw_data}/AGSEC6A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC6B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6C"

* Rename key variables for consistency across instruments
rename a6aq3 livestock_code
replace livestock_code = a6bq3	if missing(livestock_code)
replace livestock_code = a6cq3	if missing(livestock_code)

* Get rid of observations missing a livestock_code
drop if missing(livestock_code)

* Combine value labels for livestock_codes from the three files
* From Small Animals (Goat, sheep, pigs)
levelsof a6bq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6bq3) `v''", add
}

* From Poultry/Rabbits/etc.
levelsof a6cq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6cq3) `v''", add
}

* Combine number sold from three different files 
// NOTE: For small animals the amount is for the last 6 months and for Poultry
// and others the amount is the last 3 months. These are multiplied by 2 and 4 
// respectively to estimate the number for the last 12 months.
gen number_sold 			= a6aq14
replace number_sold			= a6bq14 * 2	if missing(number_sold)
replace number_sold			= a6cq14 * 4	if missing(number_sold)

* Combine income live sales from the three different files
// NOTE: see above for explanation of the multiplication for small animals and 
// poultry
gen income_live_sales		= a6aq15
replace income_live_sales	= a6bq15 * 2	if missing(income_live_sales)
replace income_live_sales	= a6cq15 * 4	if missing(income_live_sales)

* Combine number slaughtered from the three different files.
// NOTE: see above for explanation of the multiplication for small animals and 
// poultry
gen number_slaughtered		= a6aq16
replace number_slaughtered	= a6bq16 * 2	if missing(number_slaughtered)
replace number_slaughtered	= a6cq16 * 4	if missing(number_slaughtered)

* Combine value of livestock purchases from the three different files
gen value_livestock_purchases		= a6aq13
replace value_livestock_purchases	= a6bq13 * 2 /*
		*/ if missing(value_livestock_purchases)
replace value_livestock_purchases	= a6cq13 * 4 /*
		*/ if missing(value_livestock_purchases)

* Calculate the price per live animal sold
gen price_per_animal		= income_live_sales / number_sold
lab var price_per_animal "Price of live animal sold" 
ren HHID hhid
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids", nogen keep(1 3) 

keep hhid region rural weight district county subcounty parish ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_livestock_sales", replace

use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_livestock_sales", clear
gen obs = 1
foreach i in region district county subcounty parish ea {
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

foreach i in region district county subcounty parish ea country {
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
*gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
gen value_livestock_sales = value_lvstck_sold + value_slaughtered // SAW Not sure about this, just following methodology of older UG w3 version (in this case,this inlclues the value of slaughtered animals for sales and own consumption)
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01value_slaughtered_sold*/, by (hhid)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
*lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.0 gen prop_meat_sold = value_slaughtered_sold/value_slaughtered*/ // SAW We don't have slaughtered sold in this section. We do potentially have it in the 8C section though..... Actually this variable is available in the 8C - meat sold - subsection in earlier code.
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_sales", replace
 
********************************************************************************
**           TLU  		         	         	      **
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/AGSEC6A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC6B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6C"

* Rename key variables for consistency across instruments
rename a6aq3 livestock_code
rename HHID hhid
replace livestock_code = a6bq3	if missing(livestock_code)
replace livestock_code = a6cq3	if missing(livestock_code)

* Get rid of observations missing a livestock_code
drop if missing(livestock_code)

//Making sure value labels for 6B and 6C get carried over.

label define a6aq3 13 "Exotic/Cross - Male Goats"/*
						*/ 14 "Exotic/Cross - Female Goats"/*
						*/ 15 "Exotic/Cross - Male Sheep"/*
						*/ 16 "Exotic/Cross - Female Sheep"/*
						*/ 17 "Indigenous - Male Goats"/*
						*/ 18 "Indigenous - Female Goats"/*
						*/ 19 "Indigenous - Male Sheep"/*
						*/ 20 "Indigenous - Female Sheep"/*
						*/ 21 "Indigenous - Pigs"/*
						*/ 31 "Indigenous - Rabbits"/*
						*/ 32 "Indigenous - Backyard chicken)"/*
						*/ 33 "Indigenous - Parent stock for broilers"/*
						*/ 34 "Indigenous - Parent stock for layers"/*
						*/ 35 "Indigenous - Layers"/*
						*/ 36 "Indigenous - Pullet Chicken"/*
						*/ 37 "Indigenous - Growers"/*
						*/ 38 "Indigenous - Broilers"/*
						*/ 39 "Indigenous - Turkeys"/*
						*/ 40 "Indigenous - Ducks"/*
						*/ 41 "Indigenous - Geese and other birds"/*
						*/ 42 "Indigenous - Beehives", add
						
* Generate the TLU Coefficient based on the animal type
*Indigenous and Exotic Cattle represented in 1-10
gen tlu_coefficient 	= 0.5 if inrange(livestock_code, 1, 10)

* Donkeys
replace tlu_coefficient = .3 if livestock_code == 11

* No Horse mule disaggregation using the average of the two tlu's
replace tlu_coefficient = .55 if livestock_code == 12

* Indigeneous and exotic goats and sheep, male and female represented in 13-20
replace tlu_coefficient = .10 if inrange(livestock_code, 13, 20)

* Pigs
replace tlu_coefficient = .20 if livestock_code == 21

* Rabbits, backyard chicken, parent stock for broilers, parent stock for layers
* layers, pullet chicks, growers, broilers, turkeys, ducks, and geese and other
* birds represented in 31-41
replace tlu_coefficient = .01 if inrange(livestock_code, 31, 41)

/*
* Combine value labels for livestock_codes from the three files
* From Small Animals (Goat, sheep, pigs)
levelsof a6bq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6bq3) `v''", add
}

* From Poultry/Rabbits/etc.
levelsof a6cq3, local(levs)
foreach v of local levs {
	label define a6aq3 `v' "`: label (a6cq3) `v''", add
}
*/
* Combine the number of animals from the three different subsections
* into the same variable name
gen 	number_today 			= a6aq5a
replace number_today 			= a6bq5a		if missing(number_today)
replace number_today			= a6cq5a		if missing(number_today)

* Same for the number of animals one year ago.
gen 	number_1yearago			= a6aq7
replace number_1yearago			= a6bq7			if missing(number_1yearago)
replace number_1yearago			= a6cq7			if missing(number_1yearago)

* And animals died in the last 12 months
gen 	animals_died			= a6aq10a
replace animals_died			= a6bq10a * 2	if missing(animals_died)
replace animals_died			= a6bq10b * 4	if missing(animals_died)

* And animals which have been 'lost' in the last 12 months
gen 	animals_lost			= a6aq10b
replace animals_lost			= a6bq10b * 2	if missing(animals_lost)
replace animals_lost			= a6cq10b * 4	if missing(animals_lost)

* And income from live sales over the last 12 months
gen 	income_live_sales		= a6aq15
replace income_live_sales		= a6bq15 * 2	if missing(income_live_sales)
replace income_live_sales		= a6cq15 * 4	if missing(income_live_sales)

* And the number sold over the last 12 months
gen 	number_sold				= a6aq14
replace number_sold				= a6bq14 * 2	if missing(number_sold)
replace number_sold				= a6cq14 * 4	if missing(number_sold)


* Calculate  the number of animals lost in the last 12 months and the mean 
* number between 1 year ago and today (at time of survey)
gen 	animals_lost12months	= animals_died + animals_lost		
egen 	mean_12months			= rowmean(number_today number_1yearago)
* Disaggregate live animals
gen 	number_today_exotic		= number_today	if /*
		*/ inrange(livestock_code, 1, 5) | inrange(livestock_code, 13, 16)
recode	number_today_exotic 	(.=0)



* Calculate the TLUs
gen 	tlu_today				= number_today * tlu_coefficient
gen 	tlu_1yearago			= number_1yearago * tlu_coefficient

preserve
	* Only keep the cows
	keep if livestock_code == 5 | livestock_code == 10
	* Collapse to the household level, requires you to have separated out
	* number_today_exotic 
	bysort hhid : egen herd_cows_tot = sum(number_today)
	
	* Calculate the percentage of cows which are improved
	gen share_imp_herd_cows	= number_today_exotic / herd_cows_tot
	* collapse to household to deal with differences between exotic and 
	* indigenous observations
	collapse (max) share_imp_herd_cows, by (hhid)
	tempfile cows
	save `cows', replace
restore

merge m:1 hhid using `cows', nogen

* Break into our species rather than instrument's livestock code
gen species	= 			1 * (inrange(livestock_code, 1, 10)) 	+ /*
					*/	2 * (inrange(livestock_code, 11, 12))	+ /*
					*/	3 * (livestock_code == 21) 				+ /*
					*/	4 * (inrange(livestock_code, 13, 20))	+ /*
					*/	5 * (inrange(livestock_code, 31, 41))
					
label value species species

preserve
	* Collapse to the species level
	collapse (firstnm) share_imp_herd_cows (sum) number_1yearago	/*
		*/ animals_lost12months number_today_exotic 				/*
		*/ lvstck_holding = number_today, by(hhid species)
	* Recalculate the mean number of animals for the last 12 months at the 
	* collapsed level
	egen mean_12months	= rowmean(lvstck_holding number_1yearago)
	* Are there any improved animals of this species
	gen any_imp_herd	= number_today_exotic != 0	& /*
		*/ ~missing(number_today_exotic) & lvstck_holding != 0 &  /*
		*/ ~missing(lvstck_holding)
	* Create a local for the repeated variables - Leaves out any_imp_herd 
	* because it is not used in all the loops/places that the others are
	local ls_vars lvstck_holding mean_12months animals_lost12months 

	* Disaggregate by species
	foreach i in `ls_vars' any_imp_herd {
		* Use a loop to reshape the data
		forvalues k=1(1)`species_len' {
			local s	: word `k' of `species_list'
			gen `i'_`s' = `i' if species == `k'
		}
	}
	* Collapse again to the household level
	collapse (max) any_imp_herd (firstnm) *_lrum *_srum /*
		*/ *_pigs *_equine *_poultry share_imp_herd_cows, by(hhid)

	* Check if there are any improved large ruminants, small ruminants, or
	* poultry.
	egen any_imp_herd_all 	= rowmax(any_imp_herd_lrum any_imp_herd_srum /*
		*/ any_imp_herd_poultry)
	* Sum the large ruminants, small ruminants and poultry
	egen lvstck_holding_all = rowtotal(lvstck_holding_lrum 	/*
		*/ lvstck_holding_srum lvstck_holding_poultry)

	* Gen blank versions of the name livestock variables for labeling. This
	* way we can create the base labels then modify them for each species 
	* in a loop rather than having to label each of these as at the species
	* level by hand
	foreach i in `ls_vars' {
		gen `i' = .
	}	

	* Create the base labels
	label variable lvstck_holding /*
		*/"Total number of livestock holdings (# of animals)"
	label variable any_imp_herd "At least one improved animal in herd"
	label variable share_imp_herd_cows /*
		*/ "Share of improved animals in total herd - Cows only"
	label variable animals_lost12months /*
		*/ "Total number of livestock lost to disease or injury"
	label variable mean_12months /*
		*/"Average number of livestock today and one year ago"
	label variable lvstck_holding_all /*
		*/ "Total number of livestock holdings (# of animals) - large ruminants small ruminants, poultry"
	label variable any_imp_herd_all /*
		*/ "1=hh has any improved lrum, srum or poultry"

	foreach i in `ls_vars' any_imp_herd {
		* Capture the value of current variables label
		local l : var lab `i'
		* Append species info and apply label to species
		lab var `i'_lrum 	"`l' - large ruminants"
		lab var `i'_srum 	"`l' - small ruminants"
		lab var `i'_pigs 	"`l' - pigs"
		lab var `i'_equine	"`l' - equine"
		lab var `i'_poultry	"`l' - poultry"
	}
	* Relabling any_imp_herd to reflect it is all animals
	label variable any_imp_herd /*
		*/ "At least one improved animal in herd - all animals"
	* Drop the variables created solely for labeling purposes
	drop `ls_vars'

	* Households which report missing numbers for some types of livestock should
	* be counted as having no livestock
	recode lvstck_holding* (.=0)
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_herd_characteristics",/*
		*/ replace

restore
* Calculate the per animal price for live animals
gen 	price_per_animal		= income_live_sales / number_sold

*cpk new below 10/2/23
merge m:1 livestock_code using `livestock_prices_country', nogen keep(1 3)

* Merge in Imputed prices for missing values
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ keep(1 3) nogen
foreach i in region district county subcounty parish ea {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

	
*CPK: realized this was redundant and using something that was replaced by a cleaner loop. 10/2/23
/* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
*/ using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea", /*
*/ nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
*/using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish", /*
*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
*/using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty", /*
*/ nogen
* County
merge m:1 region district county livestock_code using /*
*/ "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_county", /*
*/ nogen

* District
merge m:1 region district livestock_code using /*
*/ "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_district", /*
*/ nogen
* Region
merge m:1 region livestock_code using /*
*/ "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_region", /*
*/ nogen
* Country
merge m:1 livestock_code using /*
*/ "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_prices_country", /*
*/ nogen

* Replace missing prices with imputed prices
replace price_per_animal = price_median_ea			if price_per_animal == . &/*
	*/ obs_ea		>= 10
replace price_per_animal = price_median_parish		if price_per_animal == . &/*
	*/ obs_parish	>= 10
replace price_per_animal = price_median_sub 		if price_per_animal == . &/*
	*/ obs_sub		>= 10
replace price_per_animal = price_median_county 		if price_per_animal == . &/*
	*/ obs_county	>= 10
replace price_per_animal = price_median_district	if price_per_animal == . &/*
	*/ obs_district	>= 10
replace price_per_animal = price_median_region		if price_per_animal == . &/*
	*/ obs_region	>= 10
replace price_per_animal = price_median_country		if price_per_animal == . &/*
	*/ obs_country	>= 10 
*/
* Calculate the value of the herd today and 1 year ago
gen value_1yearago	= number_1yearago * price_per_animal
gen value_today		= number_today * price_per_animal

* Collapse TLUs and livestock holdings values to the household level
collapse (sum) tlu_today tlu_1yearago value_*, by(hhid)
drop if hhid == ""

* I really don't know why we do it, but for conformity:
gen lvstck_holding_tlu = tlu_today

* Label constructed variables
label variable tlu_1yearago	"Tropical Livestock Units as of 12 months ago"
label variable tlu_today	"Tropical Livestock Units as of the time of survey"
label variable lvstck_holding_tlu	"Total HH livestock holdings, TLU"
label variable value_1yearago	"Value of livestock holdings from one year ago"
label variable value_today		"Vazlue of livestock holdings today"

* Save data to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_TLU", replace


********************************************************************************
*                                 FISH  INCOME                                 *
********************************************************************************
* Fishing section of survey was removed in wave 2 None of this can be
* constructed

********************************************************************************
*                            SELF-EMPLOYMENT INCOME                            *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC12", clear

* Rename key variables to make them easier to work with
rename	h12q12 months_activ
rename	h12q13 monthly_income
rename	h12q15 monthly_wages
rename	h12q16 monthly_materials
rename	h12q17 monthly_other_expenses
rename  HHID hhid
* Fix invalid values. (Number of months greater than 12)
recode months_activ (12/max = 12)

* Calculate the profit
gen		annual_selfemp_profit = months_activ * (monthly_income - monthly_wages/*
		*/ - monthly_materials - monthly_other_expenses)
recode	annual_selfemp_profit (.=0)
// 90 Enterprises are reported as unprofitable

* Collapse to the household level
collapse (sum) annual_selfemp_p, by (hhid)
* Recode responses whrofit, by(hhid)
// 78 households are reported to be engaged in unprofitable enterprise
* Label constructed variables
label variable annual_selfemp_profit /*
	*/"Estimated annual net profit from self-employment over previous 12 months"

* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_self_employment_income", /*
	*/ replace

  /*******************/
 /* Processed Crops */
/*******************/
* Not applicable for this Instrument

  /****************/
 /* Fish Trading */
/****************/
* Not applicable for this instrument

********************************************************************************
*                                    INCOME                                    *
********************************************************************************
  /**********************/
 /* Non-Ag Wage Income */
/**********************/

* Load data from disk (Household section 8)
use "${Uganda_NPS_W2_raw_data}/GSEC8", clear

* Set variable names to cross-wave standard
rename	h8q30	num_months
rename	h8q30b	num_weeks
rename 	h8q31c	pay_period
rename 	HHID hhid
* Combine cash and non-cash payments into one variable
gen		most_recent_payment	= h8q31a + h8q31b

egen	num_hours			= rowtotal(h8q36*)
* Note this is necessary to improve the accuracy of the rowmean function
recode	h8q36*			(0=.)
egen	avg_hrs_per_day		= rowmean(h8q36*)
recode	h8q36*			(.=0)

gen		hrs_worked_annual	= num_hours * num_weeks * num_months

* Calculate the hourly wage by dividing most recent payment by the number of 
* hours - which varies based on the payment period
gen 	hourly_wage			= most_recent_payment / ( 1 * (pay_period == 1) + /*
	*/	avg_hrs_per_day * (pay_period == 2) + num_hours * (pay_period == 3) + /*
	*/ 	num_hours * num_weeks * (pay_period == 4))

* if we decided to include wages from secondary jobs uncomment this section
* rename	h8q44	sec_months
* rename	h8q44_1	sec_weeks
* rename 	h8q45c	sec_period
* rename	h8q43	sec_hours

* gen		sec_payment			= h8q45a + h8q45b

* gen		hrs_worked_sec		= sec_hours * sec_weeks * sec_months
* gen 	hourly_wage_sec		= sec_payment / ( 1 * (sec_period == 1) + /*
* 	*/	8 * (sec_period == 2) + sec_hours * (pay_period == 3) + /*
* 	*/	sec_hours * sec_weeks * (sec_period == 4))

* Everything up to this point is the same regardless of ag or non-ag wage so 
* preserve here, do the non-ag wage calculation then restore and do the ag wage
* calculation
preserve
	* Calculate the annual salary if it was earned in a non-ag job
	gen annual_salary 			= hourly_wage * hrs_worked_annual if /*
		*/	~inlist(h8q19a, 611, 612, 613, 614, 621, 921)

	* Collapse to the household level
	collapse (sum) annual_salary, by(hhid)

	* Label the created variable
	lab var annual_salary "Annual earnings from non-agricultural wage"

	* Save data to disk.
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_wage_income", replace
restore

  /******************/
 /* Ag Wage Income */
/******************/
* Calculate the annual salary if it was earned in a non-ag job
gen annual_salary_agwage 			= hourly_wage * hrs_worked_annual if /*
	*/	~inlist(h8q19a, 611, 612, 613, 614, 621, 921)

* Collapse to the household level
collapse (sum) annual_salary, by(hhid)

* Label the created variable
lab var annual_salary "Annual earnings from agricultural wage"

* Save data to disk.
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_agwage_income", replace

  /****************/
 /* Other Income */
/****************/
* Load data from disk
use "${Uganda_NPS_W2_raw_data}/GSEC11", clear

* Rename key variables for easier use
rename	h11q2	income_code
rename	h11q5	cash_pay
rename	h11q6	inkind_pay
rename 	HHID hhid
* Disaggregate by income type and add together inkind and cash payments
gen		rental_income		= cash_pay + inkind_pay	if /*
	*/	inrange(income_code, 21, 23)

* For pension income inkind pay is not supposed to be recorded
gen		pension_income		= cash_pay				if /*
	*/	income_code ==  41

gen		remittance_income	= cash_pay + inkind_pay	if /*
	*/	inlist(income_code, 42, 43) 

gen 	other_income		= cash_pay + inkind_pay if /*
	*/	inlist(income_code, 44, 45) | inrange(income_code, 23, 36)

* Set missing values to 0 (assuming the respondent did not have any income from
* that source)
recode *_income (.=0)

* Collapse disaggregated income to the household level
collapse (sum) *_income, by(hhid)

* Label the disaggregated income variables
label variable rental_income /*
	*/	"Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
label variable pension_income /*
	*/	"Estimated income from a pension over previous 12 months" 
label variable remittance_income /*
	*/	"Estimated income from remittances over previous 12 months"
label variable other_income /*
	*/	"Estimated income from any OTHER source over previous 12 months"

* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_other_income", replace

* Land Rental Income *
**********************
* Load land rental data
use "${Uganda_NPS_W2_raw_data}/AGSEC2A", clear

* Rename key variable to cross instrument standard
rename a2aq16 land_rental_income
rename 	HHID hhid
* Set missing values to 0 (assuming the respondent did not have any income from
* that source)
recode land_rental_income (.=0)

* Collapse to the household level
collapse (sum) land_rental_income, by(hhid)

* Label newly created variable
label variable land_rental_income /*
	*/ "Estimated income from renting out land over previous 12 months"

* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_rental_income", replace

********************************************************************************
*                             FARM SIZE / LAND SIZE                            *
********************************************************************************
  /***************/
 /* Crops Grown */
/***************/
* Load data from disk First season
use "${Uganda_NPS_W2_raw_data}/AGSEC4A", clear
* Append data from second season
append using "${Uganda_NPS_W2_raw_data}/AGSEC4B"

* Drop incomplete entries
drop if missing(cropID, prcid, pltid)

* Rename key variables for cross file compatibility
rename pltid plot_id
rename prcid parcel_id
rename cropID crop_code
rename HHID hhid
* Create a crop grown variable for any remaining observations
gen crop_grown = 1

* Collapse to the parcel level
collapse (max) crop_grown, by(hhid parcel_id)

* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crops_grown", replace

  /*******************/
 /* Plot Cultivated */
/*******************/
* Load data from disk
use "${Uganda_NPS_W2_raw_data}/AGSEC2A", clear
gen season = 1
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B"
replace season = 2 if season == .
* Rename key variables for cross file compatibility
rename prcid parcel_id
rename 	HHID hhid

* Create a boolean, was the parcel cultivated
gen	cultivated	= inlist(a2aq13a, 1, 2) | inlist(a2aq13b, 1, 2) | /*
	*/	inlist(a2bq15a, 1, 2) | inlist(a2bq15b, 1, 2)

* Collapse to the parcel level
collapse (max) cultivated, by(hhid parcel_id)

* Label newly created variable
label variable cultivated "1= Parcel was cultivated in this data set"
* Save data to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_parcels_cultivated", replace

  /*************/
 /* Farm Area */
/*************/
use "${Uganda_NPS_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B.dta" 
replace season = 2 if season == .
ren prcid parcel_id
gen	cultivated	= inlist(a2aq13a, 1, 2) | inlist(a2aq13b, 1, 2) | /*
	*/	inlist(a2bq15a, 1, 2) | inlist(a2bq15b, 1, 2)
gen area_acres_meas=a2aq5 if (a2aq5!=. & a2aq5!=0)
replace area_acres_meas=a2aq4 if area_acres_meas==. & (a2aq4!=. & a2aq4!=0)
replace area_acres_meas=a2bq5 if area_acres_meas==. & (a2bq5!=. & a2bq5!=0)
replace area_acres_meas=a2bq4 if area_acres_meas==. & (a2bq4!=. & a2bq4!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
rename 	HHID hhid
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size", replace


  /*************************/
 /* All Agricultural Land */
/*************************/
use "${Uganda_NPS_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B.dta" 
replace season = 2 if season == .
ren prcid parcel_id
gen		rented_out = inlist(a2aq13a, 3, 4) | inlist(a2aq13b, 3, 4)
replace rented_out=. if rented_out==0  & (a2aq13a==. & a2aq13b==. & a2bq15a==. & a2bq15b==.)
drop if rented_out==1
* Check the use of the land is agricultural and drop it if it is not
gen		agland = inlist(a2aq13a, 1, 2, 5, 6) | inlist(a2aq13b, 1, 2, 5, 6)
drop if	agland != 1 
collapse (max) agland, by (HHID)
rename 	HHID hhid
merge 1:m hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crops_grown.dta"
drop if _m!=3
drop _m crop_grown
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_parcels_agland.dta", replace



use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size.dta", clear
merge 1:m hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_parcels_agland.dta"
collapse (mean) farm_area, by (hhid)
ren farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmsize_all_agland.dta", replace


  /*************/
 /* Land Size */
/*************/
* Load data from disk
use "${Uganda_NPS_W2_raw_data}/AGSEC2A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B"

* Rename key variables for cross file compatibility
rename	prcid parcel_id

* Drop incomplete entries
drop if	missing(parcel_id, HHID)

* Check if the plot was rented out in both seasons
gen		rented_out = inlist(a2aq13a, 3, 4) & inlist(a2aq13b, 3, 4)
* If it was rented out get rid of it
drop if	rented_out
* Create a new variable to mark the plot as one which was not rented out
gen 	plot_held = 1

* Collapse to the parcel level
collapse (max) plot_held, by(HHID parcel_id)

* Label the newly created variable
label variable plot_held "1= Parcel was NOT rented out in both seasons"
rename 	HHID hhid
* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_parcels_held", replace


use "${Uganda_NPS_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B.dta" 
replace season = 2 if season == .
ren prcid parcel_id
gen		rented_out = inlist(a2aq13a, 3, 4) & inlist(a2aq13b, 3, 4)
* If it was rented out get rid of it
drop if	rented_out
gen area_acres_meas=a2aq5 if (a2aq5!=. & a2aq5!=0)
replace area_acres_meas=a2aq4 if area_acres_meas==. & (a2aq4!=. & a2aq4!=0)
replace area_acres_meas=a2bq5 if area_acres_meas==. & (a2bq5!=. & a2bq5!=0)
replace area_acres_meas=a2bq4 if area_acres_meas==. & (a2bq4!=. & a2bq4!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size
rename 	HHID hhid
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size_all.dta", replace

/*CPK: Old all agland code that wasn't working
* And load it from disk (again) *facepalm*
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_parcels_held", clear
merge 1:1 HHID parcel_id using /*
	*/	"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas", keep(1 3)

* Make area_meas_hectares the best possible estimate of the land size
replace	area_meas_hectares	= . if area_meas_hectares < 0
replace	area_meas_hectares	= area_est_hectares if /*
	*/	missing(area_meas_hectares)	| (area_meas_hectares == 0 & /*
	*/	area_est_hectares > 0 		& ~missing(area_est_hectares))

* Collapse to the household level to get total farm size
collapse (sum) land_size = area_meas_hectares, by(HHID)
* Label the newly created variable
label variable land_size /*
	*/ "Land size in hectares, including all plots listed by the household except those rented out"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size_all", replace
*/

  /***********************/
 /* Total Land Holdings */
/***********************/

use "${Uganda_NPS_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B.dta" 
replace season = 2 if season == .
ren prcid parcel_id
gen area_acres_meas=a2aq5 if (a2aq5!=. & a2aq5!=0)
replace area_acres_meas=a2aq4 if area_acres_meas==. & (a2aq4!=. & a2aq4!=0)
replace area_acres_meas=a2bq5 if area_acres_meas==. & (a2bq5!=. & a2bq5!=0)
replace area_acres_meas=a2bq4 if area_acres_meas==. & (a2bq4!=. & a2bq4!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size_total
rename 	HHID hhid
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size_total.dta", replace


/*CPK: Old all agland code that wasn't working
use "${Uganda_NPS_W2_raw_data}/AGSEC2A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B"

* Rename key variables for cross file compatibility
rename	prcid parcel_id

* Drop incomplete entries
drop if	missing(parcel_id, HHID)
merge 1:1 HHID parcel_id using /*
	*/	"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas", keep(1 3)

* Make area_meas_hectares the best possible estimate of the land size
replace	area_meas_hectares	= . if area_meas_hectares < 0
replace	area_meas_hectares	= area_est_hectares if /*
	*/	missing(area_meas_hectares)	| (area_meas_hectares == 0 & /*
	*/	area_est_hectares > 0 		& ~missing(area_est_hectares))
* Deal with duplicated parcel data by collapsing -max- to the parcel level 
collapse (max) area_meas_hectares, by(HHID parcel_id)

* Collapse -sum- to the household level to get total farm size
collapse (sum) land_size_total = area_meas_hectares, by(HHID)

* Label the newly created variable
label variable land_size_total /*
	*/ "Total land size in hectares, including rented in and rented out plots" 

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size_total", replace
*/
********************************************************************************
*                                OFF-FARM HOURS                                *
********************************************************************************

* Load data from disk (Household section 8)
use "${Uganda_NPS_W2_raw_data}/GSEC8", clear

* Add up hours spent for each hh member for non-agricultural work.
* h8q36* adds up all parts of h8q36 (e.g. h8q36a + h8q36b + ...)
* h8q19b divides jobs into broad categories, 6 is ag and fisheries
* h8q19a provides a more specific job, 921 is "Agricultural, Fishery and 
* Related laborers"
egen primary_hours	= rowtotal(h8q36*)	if h8q19b != 6	&	h8q19a !=921

* Same as above for secondary hours except hours are reported as a weekly total
gen secondary_hours	= h8q43				if h8q38b != 6	&	h8q38a != 921

* Add up primary and secondary hours
* NOTE use egen rowtotal as a simple + equals missing if either primary or 
* secondary hours is missing
egen off_farm_hours = rowtotal(primary_hours secondary_hours)

* Create variable equal to 1 if the hh member worked more than 0 hours off farm 
gen off_farm_any_count	= off_farm_hours > 0 & ~missing(off_farm_hours)
gen member_count 		= 1

* Collapse to the household level
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
label variable member_count		"Number of HH members age 5 or above"
label variable off_farm_hours	"Total household off-farm hours"
label variable off_farm_any_count	/*
	*/	"Number of HH members with positive off-farm hours"
rename 	HHID hhid
* Save the data
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_off_farm_hours.dta", replace

********************************************************************************
*                                  FARM LABOR                                  *
********************************************************************************

* NOTE: Uganda does not have a main season and a short season. For cross 
* country compatibility this section codes the first visit as "the long season"
* and the second visit as "the short season" as Uganda provides little data
* beyond those two categories

  /***************/
 /* Main Season */
/***************/
* Load AgSec3a (Agricultural Inputs and Labor First Visit) from disk
use "${Uganda_NPS_W2_raw_data}/AGSEC3A", clear

* Standardize the names of key variables
rename prcid parcel_id

* Uganda provides family days of labor worked as single aggregate number
rename a3aq39 days_famlabor_mainseason 

* Uganda only differentiates hired labor by man, woman and child. Combining them
* all at once rather than renaming then recoding
egen days_hired_mainseason = rowtotal(a3aq42*)

* Recode missings for the newly created variables to 0
recode days_*_mainseason (.=0)

* Collapse everything to the plot (parcel) level
collapse (sum) days_*_mainseason, by(HHID parcel_id)

* Label the newly created variables
label variable days_hired_mainseason /*
	*/	"Workdays for hired labor (crops) in main growing season"
label variable days_famlabor_mainseason /*
	*/	"Workdays for family labor (crops) in main growing season"
rename 	HHID hhid
* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmlabor_mainseason", /*
	*/	replace


  /****************/
 /* Short Season */
/****************/
* Load AgSec3B (Agricultural Inputs and Labor Second Visit) from disk
use "${Uganda_NPS_W2_raw_data}/AGSEC3B", clear

* Uganda provides family days of labor worked as single aggregate number
rename a3bq39 days_famlabor_shortseason 
ren prcid parcel_id
ren pltid plot_id
* Uganda only differentiates hired labor by man, woman and child. Combining them
* all at once rather than renaming then recoding
egen days_hired_shortseason = rowtotal(a3bq42*)

* Recode missings for the newly created variables to 0
recode days_*_shortseason (.=0)

* Collapse the two created variables to the parcel level to stay consistent with
* other data
collapse (sum) days_*_shortseason, by(HHID parcel_id)

* Label the newly created variables
label variable days_hired_shortseason /*
	*/	"Workdays for hired labor (crops) in short growing season"
label variable days_famlabor_shortseason /*
	*/	"Workdays for family labor (crops) in short growing season"
rename 	HHID hhid
* Save to disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmlabor_shortseason", /*
	*/	replace


  /***************/
 /* All Seasons/Hired Labor */
/***************/

* Load/Merge the two newly created files
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmlabor_mainseason", clear

merge 1:1 hhid parcel_id using /*
	*/ "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmlabor_shortseason", /*
	*/ nogen

* Sum days labor by type across seasons
egen labor_hired	= rowtotal(days_hired_*)
egen labor_family	= rowtotal(days_famlabor_*)

* Calculate total amount of labor used at the parcel level
egen labor_total	= rowtotal(labor_*)

* Label the newly created variables
label variable labor_hired	"Total labor days (hired) allocated to the farm"
label variable labor_family	"Total labor days (family) allocated to the farm"
label variable labor_total	/*
	*/	"Total labor days (family, hired, other) allocated to the farm"

* Save the Parcel level data to the disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_family_hired_labor", /*
	*/	replace

* Collapse labor variables to the household level
collapse  (sum) labor_*, by(hhid)

* Relabel the variables to get rid of the junk added by collapse
label variable labor_hired	"Total labor days (hired) allocated to the farm"
label variable labor_family	"Total labor days (family) allocated to the farm"
label variable labor_total 	/*
	*/	"Total labor days (family, hired, or other) allocated to the farm"

* Save household level data to the disk
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_family_hired_labor", replace

********************************************************************************
*                                VACCINE  USAGE                                *
********************************************************************************
/*	Only Large Ruminants and Equines have data on 
 *	vaccines. The Sheep, goats, pigs module and the poultry/rabbit module
 *	do not include data on vaccine usage.
 */

* 	Load Agricultural Section 6A - Livestock Ownership: Cattle and Pack Animals
* 	dta from Disk
use "${Uganda_NPS_W2_raw_data}/AGSEC6A", clear

* Standardize key variables across waves
rename	a6aq3 livestock_code
/*	__NOTE: a6aq18 response of 1 means all animals are 
 *	vaccinated, response of 2 is some animals vaccinated
 */
gen		vac_animal	= inlist(a6aq18, 1, 2)

gen		species = 	inrange(livestock_code, 1, 10) + /*
				*/	4*(inlist(livestock_code, 11, 12))	
* Don't use data if no species is specified
recode species (0=.)

* Set the value labels based on the species value labels created earlier
label values species species
disp "`species_len'"
* Use a loop to reshape the data
forvalues k=1(1)`species_len' {
	local s	: word `k' of `species_list'
	gen vac_animal_`s' = vac_animal if species == `k'
}
* Finish the reshape by collapsing species to the household level
*ren HHId hhid
collapse (max) vac_animal*, by(HHID)
*ren HHId hhid
* Label the new variables
lab var vac_animal "1= Household has an animal vaccinated"
* Label the animal category specific dummy variables
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}

* Save the Vaccine dummies to disk
ren HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_vaccine", replace

* Load AgSec 6A, B, and C: Livestock Ownership. (contains vaccine data)
use "${Uganda_NPS_W2_raw_data}/AGSEC6A", replace
append using "${Uganda_NPS_W2_raw_data}/AGSEC6B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6C"

* Create a dummy variable of "livestock keeper uses vaccines" across all animals
gen all_vac_animal = inlist(a6aq18, 1, 2)
* Set to missing if they don't own any of the animal in question
replace all_vac_animal = . if missing(a6aq18) | a6aq4 != 1
* Rename farmer id
rename a6aq17a personid1
rename a6aq17b personid2

replace personid1 = a6bq17a if missing(personid1)
replace personid2 = a6bq17b if missing(personid2)

replace personid1 = a6cq17a if missing(personid1)
replace personid2 = a6cq17b if missing(personid2)

rename a6aq3 lvstckid  

replace lvstckid = a6bq3 if missing(lvstckid)
replace lvstckid = a6cq3 if missing(lvstckid)


* Only keep the relevant variables a6aq3 is needed for the reshape
keep HHID lvstckid all_vac_animal personid*

* Drop entries with no livestock keeper listed
drop if missing(personid1) & missing(personid2)

* DO NOT DUPLICATE
* There are duplicate entries in agsec6b and agsec6c, since this data is only
* used for livestock keeper information, this sorting then dropping duplicates
* method insures that entries with missing second farmers are below ones with
* both farmers meaning all data is preserved. There are no instances in this 
* data where one farmer is in the entry with one farmer and not also in the 
* other entry (whether it has one or two farmers).
sort HHID lvstckid personid1 personid2
duplicates drop HHID lvstckid, force
* END DO NOT DUPLICATE

* Reshaping data to create a file at the livestock-keeper unit of analysis 
* rather than the livestock species unit of analysis. 
reshape long personid, i(HHID lvstckid) j(_)

* Get rid of any entries which are missing a personid
drop if missing(personid)

* Condense down to one entry per livestock keeper. 
collapse (max) all_vac_animal, by(HHID personid)


* Mark all of the remaining people as livestock-keepers with a dummy variable
gen livestock_keeper = 1
rename HHID hhid
* Merge in gender data for later gender disaggregation of proportions
merge 1:1 hhid personid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids", nogen

* Any people which were not part of the data before the merge should be set as
* not being livestock keepers
recode livestock_keeper (.=0)

* Label newly created variables
label variable all_vac_animal /*
	*/	"1= Individual farmer (livestock keeper) uses vaccines"
label variable livestock_keeper /*
	*/	"1= Individual is listed as a livestock keeper (at least one type of livestock)"
duplicates drop PID hhid, force
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_vaccine", replace
********************************************************************************
*                           ANIMAL HEALTH - DISEASES                           *
********************************************************************************

  /***************************************************************************/
 /* Cannot Construct in this Instrument. No questions about animal diseases */
/***************************************************************************/


********************************************************************************
*                    LIVESTOCK WATER, FEEDING, AND HOUSING                     *
********************************************************************************
  /*********************************************************************/
 /* Cannot Construct in this Instrument. No questions on these topics */
/*********************************************************************/


********************************************************************************
*                             USE OF IMPROVED SEED                             *
********************************************************************************
  /*******************/
 /* Household Level */
/*******************/
**CPK: adding the below line because the code kept getting stuck here without it. 
local crop_len : list sizeof global(topcropname_area)

* Load "Crops Grown and Types of Seed Used" first and second visit data
use "${Uganda_NPS_W2_raw_data}/AGSEC4A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC4B", gen(season)

* recode and combine improved seed variables
recode	a4aq13 a4bq13 		(1=0) (2=1) (.=0)
egen 	imprv_seed_use	= 	rowmax(a4aq13 a4bq13)

* Loop through the list of Gates Priority Crops and create dummy variables for
* whether or not the plot was planted with improved seed of each crop
forvalues k=1(1)`crop_len' {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area

	* Create the improved seed by crop dummy
	gen imprv_seed_`cn'		=	imprv_seed_use 	if cropID	==	`c'
	* there is no hybrid seed question so set it to missing.
	gen hybrid_seed_`cn'	=	.
}

* by preserving before the collapse you don't need to create new dummy variables
* for each crop later, we will have them at the plot-crop level when we evaluate
* the data at the individual level. 
preserve
	* Collapse to the household level
	collapse (max) imprv_seed_* hybrid_seed_*, by(HHID)

	* Label the newly created variables
	label variable imprv_seed_use "1= Household uses improved seed"

	* Loop through all of the top crops and label the crop specific version of 
	* the dummy.
	foreach cn in $topcropname_area {
		label variable imprv_seed_`cn' 	"1= Household uses improved `cn' seed"
		label variable hybrid_seed_`cn'	"1= Household uses hybrid `cn' seed"
	}
rename HHID hhid
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_improvedseed_use", replace
restore

  /********************/
 /* Individual level */
/********************/
* Merge in data on the parcel managers AGSEC2A - Owned Parcels; AGSEC2B - 
* Rented Parcels
merge m:1 HHID prcid using "${Uganda_NPS_W2_raw_data}/AGSEC2A", keep(1 3) nogen
merge m:1 HHID prcid using "${Uganda_NPS_W2_raw_data}/AGSEC2B", keep(1 3) nogen

* Combine the plot manager variables from the owned dta (AGSEC2A) with the 
* and the rented dta (AGSEC2B)
egen personid1	=	rowfirst(a2aq27a a2bq25a)
egen personid2	= 	rowfirst(a2aq27b a2bq25b)

* reshape date from crop plot level to farmer crop plot level
gen index = _n
reshape long personid, i(index) j(_)

* Drop all the entries created with a missing person id (i.e. the second entry
* for parcels with only one parcel manager)
drop if missing(personid)

* Rename all of the variables to the individual level version (add all_ to the
* front of the variable name)
foreach v in imprv_seed_* hybrid_seed_* {
	rename `v' all_`v'
}

* Collapse to the farmer level
collapse (max) all_imprv_seed_* all_hybrid_seed_*, by(HHID personid)

* Any person who hasn't been removed at this point is a farm manager and should
* be marked before merging in the gender data.
gen farm_manager	= 	1

*Label relevant variables
label variable all_imprv_seed_use /*
	*/	"1= Individual farmer (plot manager) uses improved seed"
label variable farm_manager /*
	*/	"1= Individual is listed as a manager for at least one plot"

* label crop specific versions of the all_imprv_seed and all_hybrid_seed.
* Also create and label the farmer dummy for all farmers of 
foreach cn in $topcropname_area {
	* If the value of all_imprv_seed and all_hybrid_seed is missing then the
	* farm manager did not grow this particular crop
	gen `cn'_farmer 	= 	~missing(all_imprv_seed_`cn') 	| /*
		*/	~missing(all_hybrid_seed_`cn')

	label variable all_imprv_seed_`cn' /*
		*/	"1= Individual Farmer (plot manager) uses improved seeds - `cn'"
	label variable all_hybrid_seed_`cn' /*
		*/	"1= Individual Farmer (plot manager) uses hybrid seed - `cn'"
	label variable `cn'_farmer "1= Individual farmer (plot manager) grows `cn'"
}
rename HHID hhid
* Merge in the gender data
merge 1:1 hhid personid using /*
	*/	"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids", nogen
* Set the value of Farm manager to 0 for people who did not show up prior to the
* merge of gender data and therefore have farm_manager == .
recode farm_manager (.=0)
duplicates drop hhid PID, force /*1 duplicate dropped*/
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_improved_seed_use", replace
//Continue

********************************************************************************
**                             PLOT MANAGER        	                          **
********************************************************************************
**# Bookmark #2

use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_input_quantities.dta", clear
foreach i in inorg_fert org_fert pest /*herb*/ {
	recode `i'_kg (.=0)
	replace `i'_kg=1 if `i'_kg >0 
	ren `i'_kg use_`i'
	/*recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'*/
}
collapse (max) use_*, by(hhid parcel_id plot_id season)
merge 1:m hhid parcel_id plot_id season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", nogen keep(1 3) keepusing(crop_code use_imprv_seed)
collapse (max) use*, by(hhid parcel_id plot_id crop_code season)
recode use* (.=0)
preserve 
keep hhid parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_cropname_table.dta", nogen keep(3)
drop crop_code	
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_imprvseed_crop.dta", replace 

restore

merge m:m hhid parcel_id using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_dm_ids.dta", nogen keep(1 3) // SAW personids is at the plot season level while input quantities at the plot level
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid personid female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_cropname_table.dta", nogen keep(3)
*decode crop_code, gen(crop_name)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_improvedseed_use.dta", replace
restore


collapse (max) use_*, by(hhid personid PID female)
gen all_imprv_seed_use = use_imprv_seed //Legacy

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest /*use_herb*/, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	*la var use_herb "1 = household uses herbicide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_input_use.dta", replace
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	tostring personid, format(%19.0f) replace
	gen farm_manager=1 if personid!=""
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
drop personid
	save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_fert_use.dta", replace 
restore


********************************************************************************
*                           REACHED BY AG EXTENSION                            *
********************************************************************************

*use "${Uganda_NPS_W2_raw_data}/AGSEC9.dta", clear
use "${Uganda_NPS_W2_raw_data}/AGSEC9", clear
*rename HHID hhid
ta a9q2, gen(newvar)
gen ext_reach_public=(newvar4==1)
gen ext_reach_private=(newvar1==1 | newvar2==1 | newvar3==1 | newvar5==1)
gen ext_reach_unspecified=(newvar6==1)
*gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (HHID)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
rename HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_any_ext.dta", replace

********************************************************************************
*								HOUSEHOLD ASSETS							   *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC14.dta", clear
ren h14q5 value_today
ren h14q4 num_items
*dropping items if hh doesnt report owning them 
tostring h14q3, gen(asset)
drop if asset=="0"
collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets"
rename HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_W2_hh_assets.dta", replace 

********************************************************************************
*                      USE OF FORMAL FINANCIAL SERVICES                       *
********************************************************************************
//CPK: Different options than those in wave 7. Couldn't make certain categories that were present in that wave. Disregarded relative/friend.There was also no NGO category, generated this but left it empty. 

use "${Uganda_NPS_W2_raw_data}/GSEC13A.dta", clear
ta h13q16, gen (borrow)

rename borrow1 borrow_bank
rename borrow10 borrow_other_fin
gen borrow_micro= borrow3==1 | borrow4==1 | borrow6==1 | borrow8==1 | borrow9==1 
gen use_fin_serv_credit= borrow_bank==1 | borrow_micro==1  | borrow_other_fin==1
gen borrow_NGO = 0
//CPK: No information on saving in the data even though this was included in the survey. Generated these but left them empty. This means the only variable with data in the final variables was use_fin_serv_all and use_fin_serv_credit
gen use_fin_serv_bank=h13q19==1 | h13q20==1 // if they have an account with a bank and non formal institution 
gen use_fin_serv_digital= .
gen use_fin_serv_others=h13q25==1
gen use_fin_serv_insur= h13q21==1 | h13q22==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_digital==1 | use_fin_serv_others==1 | use_fin_serv_insur==1  
collapse (max) use_fin_serv_*, by (HHID)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
rename HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_fin_serv.dta", replace
********************************************************************************

********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
*CPK: can't really follow this section with the instrument questions. Did my best...
use "${Uganda_NPS_W2_raw_data}/AGSEC8", clear
keep if a8q2==1 | a8q2==2 | a8q2==3 // keeping only milk - don't have information on ruminants in this wave
gen milk_permonth = a8q4
gen milk_production = a8q3
*drop if milk_production ==0
gen liters_milk_produced = milk_permonth*milk_production
label variable liters_milk_produced "Average quantity (liters) per year per household"
collapse (sum) liters_milk_produced, by(HHID)
rename HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_milk_animals.dta", replace
*/

********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/AGSEC6C", clear
rename a6cq3 livestock_code
gen poultry_owned = a6cq5a if (livestock_code==32 | livestock_code==35 | livestock_code==38 | livestock_code==33|livestock_code==34| livestock_code==36 | livestock_code==37)
collapse (sum) poultry_owned, by(HHID)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W2_raw_data}/AGSEC8", clear
gen eggs_months = a8q3 if a8q2==5 
gen eggs_per_month = a8q4 if a8q2==5 
collapse (sum) eggs_months eggs_per_month, by(HHID)
*drop if eggs_months==0
gen eggs_total_year = eggs_per_month*eggs_months // multiply to get the annual total 
merge m:1 HHID using  `eggs_animals_hh', nogen keep(1 3)			
lab var eggs_months " How many months poultry laid eggs in the last year"
lab var eggs_per_month "Total number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in the year(household)"
lab var poultry_owned "Total number of poulty owned (household)"
rename HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_eggs_animals.dta", replace

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/AGSEC3A.dta", clear
ren prcid parcel_id
ren pltid plot_id
gen season=1 
append using "${Uganda_NPS_W2_raw_data}/AGSEC3B.dta"
replace season=2 if season==.


drop if plot_id==.


*Hired wages:
gen hired_wage = a3aq43 // wage paid is not reported in season 2

*Hired costs
gen hired_labor_costs = a3aq43
gen wage_paid_aglabor = hired_labor_costs
*Constructing a household-specific wage
collapse (sum) wage_paid_aglabor, by(HHID)										
recode wage* (0=.)	
keep HHID wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
rename HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_ag_wage.dta", replace

********************************************************************************
**                      CROP PRODUCTION COSTS PER HECTARE                      **
********************************************************************************
*All the preprocessing is done in the crop expenses section */

use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by (hhid parcel_id plot_id purestand field_size season)    
ren ha_harvest ha_harvested //Legacy   
duplicates report hhid parcel_id plot_id season
reshape long ha_, i(hhid parcel_id plot_id season purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_cost_inputs_long.dta", replace
collapse (sum) cost_=val, by(hhid parcel_id plot_id season dm_gender exp)  
reshape wide cost_, i(hhid parcel_id plot_id season dm_gender) j(exp) string  
recode cost_exp cost_imp (.=0)
*drop cost_total
gen cost_total=cost_imp+cost_exp
drop cost_imp
drop if plot_id ==.

merge m:m hhid parcel_id plot_id season using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
replace dm_gender=1 if dm_gender==.
collapse (mean) cost*ha_ [aw=field_size], by(hhid season dm_gender area_type)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender 

reshape wide cost*_, i(hhid dm_gender2 season) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid season) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
//AT To revisit to see if we want only lrs for this; for now, we'll combine.
collapse (sum) cost*, by(hhid)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_cropcosts.dta", replace


********************************************************************************
* RATE OF FERTILIZER APPLICATION * PA Done
********************************************************************************
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", clear
collapse (sum) ha_planted, by(hhid parcel_id plot_id season dm_gender)
merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_input_quantities.dta", nogen keep(1 3) //11 plots have expenses but don't show up in the all_plots roster.
drop if ha_planted==0
recode *kg (.=0)
//ren *_rate *_kg_
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
unab vars : *_kg
ren *kg *kg_
ren ha_planted ha_planted_
collapse (sum) *kg* ha_planted*, by(hhid dm_gender2)
reshape wide *_, i(hhid) j(dm_gender2) string

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}

//Some high inorg fert rates as a result of large tonnages on small plots. 
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var n_kg "Units of Nitrogen (kgs) for household"
lab var p_kg "Units of Phosphorus (kgs) for household"
lab var k_kg "Units of Potassium (kgs) for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var n_kg "Units of Nitrogen (kgs) for `i'-managed plots"
lab var p_kg "Units of Phosphorus (kgs) for `i'-managed plots"
lab var k_kg "Units of Potassium (kgs) for `i'-managed plots"
}

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY
*******************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
*No available data to construct rCSI module.
*Constructing FCS
use "${Uganda_NPS_W2_raw_data}/GSEC15B", clear
rename hh hhid
tostring hhid, format(%18.0f) replace
ren h15bq3b days
recode days (8=7)
recode days (.=0)

recode itmcd 		(110/116  					=1	"CEREALS" )  								//// A
					(101/109    				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	) 	//// B
					(140/146					=3	"LEGUMES, NUTS AND SEEDS" ) 				//// C
					(135/139	 				=4	"VEGETABLES"	)  							//// D
					(117/124 					=5	"MEAT, EGGS, FISH"	)                       //// E
					(130/134					=6	"FRUITS"	)  							    //// F
					(125						=7	"MILK AND MILK PRODUCTS" )					//// G
					(127/129   					=8	"OILS AND FATS"	)							//// H
					(147 151 154 				=9	"SWEETS"	) 								//// I
					(148/150 152 153 160		=10 "SPICES, CONDIMENTS, BEVERAGES"	)			//// J
					,generate(foodgroup)
keep if foodgroup<10

keep foodgroup hhid days
collapse (sum) days, by(hhid foodgroup)
reshape wide days, i(hhid) j(foodgroup)
gen max_days = max(days1, days2)
gen min_days = min(days1, days2)
gen sum_days = days1+days2
gen fcs_a =.
replace fcs_a =7 if max_days==7
replace fcs_a=max_days if min_days==0
replace fcs_a=((max_days+min_days)/2) if sum_days>7
drop days1 days2 /*days10*/ *_days
ren fcs_a days1
reshape long days, i(hhid) j(foodgroup)
gen weight = .
replace weight = 2 if foodgroup==1 							// max of A and B 
replace weight = 3 if foodgroup == 3 						// C
replace weight = 1 if foodgroup == 4 | foodgroup == 6 		// D & F
replace weight = 4 if foodgroup == 5 | foodgroup == 7   	// E & G
replace weight = 0.5 if foodgroup == 8 | foodgroup == 9 	// H & I
gen fcs =. 
replace fcs = days*weight
collapse (sum) fcs, by (hhid)
label var fcs "Food Consumption Score"
gen fcs_poor = (fcs <= 21)
gen fcs_borderline = (fcs > 21 & fcs <= 35)
gen fcs_acceptable = (fcs > 35)
label var fcs_poor "1 = Household has poor Food Consumption Score (0-21)"
label var fcs_borderline "1 = Household has borderline Food Consumption Score (21.5 - 35)"
label var fcs_acceptable "1 = Household has acceptable Food Consumption Score (> 35)"

*merge 1:1 HHID using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_household_diet.dta", nogen 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_fcs.dta", replace

*Constructing HDDS
use "${Uganda_NPS_W2_raw_data}/GSEC15B", clear
rename hh hhid
tostring hhid, format(%18.0f) replace
recode itmcd 	(110/116  				=1	"CEREALS" )  //// 
					(101/109    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(135/139	 				=3	"VEGETABLES"	)  ////	
					(130/134					=4	"FRUITS"	)  ////	
					(117/121 						=5	"MEAT"	)  ////					
					(124							=6	"EGGS"	)  ////
					(122 123 						=7  "FISH") ///
					(140/146					=8	"LEGUMES, NUTS AND SEEDS") ///
					(125						=9	"MILK AND MILK PRODUCTS")  ////
					(127/129   					=10	"OILS AND FATS"	)  ////
					(147 151 154 				=11	"SWEETS"	)  //// 
					(148/150 152 153 160 =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)
keep if Diet_ID<15
*Notes There are some food itmcd that dont fit into any DIET_ID category, those food itmc are droped from the analysis (The excluded items that dont fit are Infant formula food 126, Cigarretes 155, Other Tobacco 156, Expenditure in restaurants on Food, Soda, Beer 157-159  Other fooods 161. In white roots.. category we include 4 types of matooke items. In legumes.. we include sim sim item. Other juice 160 is included in beverages category
gen adiet_yes=(h15bq3a==1)
ta Diet_ID
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid)
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"

merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_fcs.dta", nogen 
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_household_diet.dta", replace

/*
use "${Uganda_NPS_W2_raw_data}/GSEC15B", clear
rename hh hhid
tostring hhid, format(%18.0f) replace
recode itmcd 	(110/116  				=1	"CEREALS" )  //// 
					(101/109    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(135/139	 				=3	"VEGETABLES"	)  ////	
					(130/134					=4	"FRUITS"	)  ////	
					(117/121 						=5	"MEAT"	)  ////					
					(124							=6	"EGGS"	)  ////
					(122 123 						=7  "FISH") ///
					(140/146					=8	"LEGUMES, NUTS AND SEEDS") ///
					(125						=9	"MILK AND MILK PRODUCTS")  ////
					(127/129   					=10	"OILS AND FATS"	)  ////
					(147 151 154 				=11	"SWEETS"	)  //// 
					(148/150 152 153 160 =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)
keep if Diet_ID<15
*Notes There are some food itmcd that dont fit into any DIET_ID category, those food itmc are droped from the analysis (The excluded items that dont fit are Infant formula food 126, Cigarretes 155, Other Tobacco 156, Expenditure in restaurants on Food, Soda, Beer 157-159  Other fooods 161. In white roots.. category we include 4 types of matooke items. In legumes.. we include sim sim item. Other juice 160 is included in beverages category
gen adiet_yes=(h15bq3a==1)
ta Diet_ID
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid)
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_household_diet.dta", replace
*/
********************************************************************************
                     * WOMEN'S CONTROL OVER INCOME *
********************************************************************************
*CPK: this is definitely wrong... Don't know what to do about the most definitely wrong PersonIDs from enterprise income!
* First append all files with information on who control various types of income
use "${Uganda_NPS_W2_raw_data}/AGSEC5A", clear
append using  "${Uganda_NPS_W2_raw_data}/AGSEC5B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6A" 
append using "${Uganda_NPS_W2_raw_data}/AGSEC6B" 	
append using "${Uganda_NPS_W2_raw_data}/AGSEC6C" 	
append using  "${Uganda_NPS_W2_raw_data}/AGSEC8"
*CPK: what about the below sections?
*append using  "${Uganda_NPS_W2_raw_data}/AGSEC2A" 
*append using "${Uganda_NPS_W2_raw_data}/AGSEC2B"- this has a question that says "who manages/controls the output from this parcel among household members"

append using "${Uganda_NPS_W2_raw_data}/GSEC12" //  //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b
gen type_decision="" 
gen double controller_income1=.
gen double controller_income2=.
* control of harvest from annual crops, CPK: I don't see anything for person #2...?
replace type_decision="control_annualharvest" if  !inlist( a5aq11, .,0,99) |  !inlist( a5bq11, .,0,99) 
replace controller_income1=a5aq11 if !inlist( a5aq11, .,0,99)  
replace controller_income1=a5bq11 if !inlist( a5bq11, .,0,99)
replace type_decision="control_livestocksales" if  !inlist( a8q9a, .,0,99) |  !inlist( a8q9b, .,0,99) 
replace controller_income1=a8q9a if !inlist( a8q9a, .,0,99)  
replace controller_income2=a8q9b if !inlist( a8q9b, .,0,99)
*CPK: this section is difficult! Who knows. Basically this question is recorded on the PersonID level but there are multiple -long format - per HHID, parcelid, plotid and cropID and you can't reshape because there are duplicate values across these variables - not unique values. Can't reshape and can't really use the enterprise decison maker question. 
gen h12q5aa = substr(h12q5a,-2,.)
destring h12q5aa, replace 
gen h12q5bb = substr(h12q5b,-2,.)
destring h12q5bb, replace 
rename h12q5a enterprise1
rename h12q5b enterprise2
*reshape long enterprise, i(HHID pltid prcid cropID)
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( h12q5aa, .,0,99) |  !inlist( h12q5bb, .,0,99) 
replace controller_income1=h12q5aa if !inlist( h12q5aa, .,0,99)  
replace controller_income2=h12q5bb if !inlist( h12q5bb, .,0,99)

preserve
keep HHID type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep HHID type_decision controller_income1
drop if controller_income1==.
ren controller_income1 controller_income
append using `controller_income2'
* create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							*| type_decision=="control_permharvest" ///
							*| type_decision=="control_annualsales" ///
							*| type_decision=="control_permsales" ///
							*| type_decision=="control_processedsales"
recode 	control_cropincome (.=0)								
gen control_livestockincome=1 if  type_decision=="control_livestocksales" ///
							*| type_decision=="control_milksales" ///
							*| type_decision=="control_otherlivestock_sales"				
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																					
gen control_nonfarmincome=1 if  control_businessincome== 1 
							  *| type_decision=="control_assistance" ///
							  *| type_decision=="control_remittance" ///
recode control_nonfarmincome (.=0)																		
collapse (max) control_* , by(HHID controller_income)  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income personid
ren HHID hhid
*	Now merge with member characteristics
*tostring HHID, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
merge m:1 hhid personid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business) income"
lab var control_all_income "1=invidual has control over at least one type of income"

*CPK: 5/23/23 needed to deal with the blank personids... not sure if this is accurate 
tostring personid, gen(personid2) format(%18.0f) 
replace PID = hhid + personid2 if PID == ""
drop personid2

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_control_income.dta", replace


********************************************************************************
            * WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING *
********************************************************************************
*CPK: Bah! This section is really challenging because there are hardly any questions concerning control or decision makers... 
use "${Uganda_NPS_W2_raw_data}/AGSEC3A", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC3B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC5A"
append using "${Uganda_NPS_W2_raw_data}/AGSEC5B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6A"
gen type_decision=""
gen double decision_maker1=.
gen double decision_maker2=.
*Decisions concerning the timing of cropping activities, crop choice and input use on the [PLOT]
/*
replace type_decision="planting_input" if !missing(a3aq3_3) | !missing(a3aq3_4a) | !missing(a3aq3_4b)
replace decision_maker1=a3aq3_3
replace decision_maker1=a3aq3_4a if decision_maker1==.
replace decision_maker2=a3aq3_4b
*We do the same for 2nd cropping season (2nd visit)
replace type_decision="planting_input" if !missing(a3bq3_3) | !missing(a3bq3_4a) | !missing(a3bq3_4b)
replace decision_maker1=a3bq3_3 if decision_maker1==.
replace decision_maker1=a3bq3_4a if decision_maker1==.
replace decision_maker2=a3bq3_4b if decision_maker2==.
*Decisions concerning harvested crop 1st visit
replace type_decision="harvest" if !missing(A5AQ6A_2) | !missing(A5AQ6A_3) | !missing(A5AQ6A_4)
replace decision_maker1=A5AQ6A_2 if decision_maker1==.
replace decision_maker1=A5AQ6A_3 if decision_maker1==.
replace decision_maker2=A5AQ6A_4 if decision_maker2==.
*We do the same for 2nd cropping season (2nd visit)
replace type_decision="harvest" if !missing(A5BQ6A_2) | !missing(A5BQ6A_3) | !missing(A5BQ6A_4)
replace decision_maker1=A5BQ6A_2 if decision_maker1==.
replace decision_maker1=A5BQ6A_3 if decision_maker1==.
replace decision_maker2=A5BQ6A_4 if decision_maker2==.
replace type_decision="livestockowners" if !missing(a6aq3b) | !missing(a6aq3c)
replace decision_maker1=a6aq3b if decision_maker1==.
replace decision_maker2=a6aq3c if decision_maker2==.
* SW This time we only use ownership of livestock. Maybe add the mentioned variables?
*Now we start creating a single variable for Decision makers
keep HHID type_decision decision_maker1 decision_maker2
preserve
keep HHID type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore
keep HHID type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
* number of time appears as decision maker
bysort HHID decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							*| type_decision=="sales_annualcrop" ///
							*| type_decision=="sales_permcrop" ///
							*| type_decision=="sales_processcrop"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(HHID decision_maker )  //any decision
ren decision_maker PID
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
ren HHID hhid
* Now merge with member characteristics
merge 1:1 hhid PID  using  "${Uganda_NPS_W3_created_data}/Uganda_NPS_W2_person_ids.dta", nogen 
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_make_ag_decision.dta", replace
*/ 

// NEE double checked this chapter if raw data is available but there is not such data to create this section in W1 and W2 //


********************************************************************************
                      * WOMEN'S OWNERSHIP OF ASSETS *
********************************************************************************
*/
use "${Uganda_NPS_W2_raw_data}/AGSEC2", clear
append using "${Uganda_NPS_W2_raw_data}/AGSEC2A"
append using "${Uganda_NPS_W2_raw_data}/AGSEC2B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6A"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6B"
append using "${Uganda_NPS_W2_raw_data}/AGSEC6C"
rename HHID hhid
gen type_asset=""
gen double asset_owner1=.
gen double asset_owner2=.
replace type_asset="landowners" if !missing(a2bq24a) | !missing(a2bq24b)
replace asset_owner1=a2bq24a 
replace asset_owner2=a2bq24b
*append who has right to sell or use
*preserve
replace type_asset="landowners" if !missing(a2aq26a) | !missing(a2aq26b)
replace asset_owner1=a2aq26a if asset_owner1==.
replace asset_owner2=a2aq26b if asset_owner2==.
*Ownership of Livestock(Cattle and pack animals)
replace type_asset="livestockowners" if !missing(a6aq17a) | !missing(a6aq17b)
replace asset_owner1=a6aq17a if asset_owner1==.
replace asset_owner2=a6aq17b if asset_owner2==.
*Ownership of small animals 
replace type_asset="livestockowners" if !missing(a6bq17a) | !missing(a6bq17b)
replace asset_owner1=a6bq17a if asset_owner1==.
replace asset_owner2=a6bq17b if asset_owner2==.
*Ownership of Poultry and others
replace type_asset="livestockowners" if !missing(a6cq17a) | !missing(a6cq17b)
replace asset_owner1=a6cq17a if asset_owner1==.
replace asset_owner2=a6cq17b if asset_owner2==.
keep hhid type_asset asset_owner1 asset_owner2  
preserve
keep hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
keep hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
gen own_asset=1 
collapse (max) own_asset, by(hhid asset_owner)
ren asset_owner personid
*ren hhid hhid
*tostring hhid, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
* Now merge with member characteristics
merge 1:1 hhid personid  using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
drop if PID == ""/*19 observations deleted*/
duplicates drop PID, force /*1 observation deleted*/
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_ownasset.dta", replace
********************************************************************************
                          * AGRICULTURAL WAGES **
********************************************************************************
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_labor_long.dta", clear // at the plot season level
keep if strmatch(labor_type,"hired") & (strmatch(gender,"male") | strmatch(gender,"female"))
collapse (sum) wage_paid_aglabor_=val hired_=days, by(hhid gender)
reshape wide wage_paid_aglabor_ hired_, i(hhid) j(gender) string
egen wage_paid_aglabor = rowtotal(wage*)
egen hired_all = rowtotal(hired*)
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers(local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
lab var hired_all "Total hired labor (number of persons days)"
lab var hired_female "Total hired labor (number of persons days) -female workers"
lab var hired_male "Total hired labor (number of persons days) -male workers"
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_ag_wage.dta", replace

********************************************************************************
                          * CROP YIELDS *
*******************************************************************************
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", clear
gen area_plan = ha_planted
gen area_harv = ha_harvest
gen harvest = quant_harv_kg

gen mixed = "inter"
replace mixed = "pure" if purestand == 1

gen dm_gender2 = "unknown"
replace dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3

foreach i in harvest area_plan area_harv {	
	foreach j in inter pure {
		gen `i'_`j' = `i' if mixed == "`j'"
		foreach k in male female mixed {
			gen `i'_`j'_`k' = `i' if mixed == "`j'" & dm_gender2 == "`k'"
			capture confirm var `i'_`k'
			if _rc {
				gen `i'_`k' = `i' if dm_gender2 == "`k'"
			}
		}
	}
}

collapse (sum) harvest* area* (max) no_harvest, by(hhid crop_code)

unab vars : harvest* area*
foreach var in `vars' {
	replace `var' = . if `var' == 0 & no_harvest == 1
}

replace area_plan = . if area_plan == 0
replace area_harv = . if area_plan == . | (area_harv == 0 & no_harvest == 1)

unab vars2 : area_plan_*
local suffix : subinstr local vars2 "area_plan_" "", all
foreach var in `suffix' {
	replace area_plan_`var' = . if area_plan_`var' == 0
	replace harvest_`var' = . if area_plan_`var' == . | (harvest_`var' == 0 & no_harvest == 1)
	replace area_harv_`var' = . if area_plan_`var' == . | (area_harv_`var' == 0 & no_harvest == 1)
}

drop no_harvest

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_area_plan.dta", replace


*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_planted=area_plan, by(hhid)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_area_planted_harvested_allcrops.dta", replace
restore

keep if inlist(crop_code, $comma_topcrop_area)

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production.dta", nogen keep(1 3)
drop crop_code
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_
gen kgs_harvest_ = harvest_
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest* value_harv* value_sold* /*number_trees_planted**/  , by(hhid) 
recode harvest*  area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* value_harv* value_sold* (0=.)

*rename variables 
foreach p in $topcropname_area {
*foreach p of global topcropname_area if _N!=0 {
	di "`p'"
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
	lab var harvest_inter_mixed_`p' "Quantity harvested  of `p' (kgs) - intercrop (mixed-managed plots)" 
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

foreach p of global topcropname_area {
	gen grew_`p'=(total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}


save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production.dta", replace
*Grouping following IMPACT categories but also mindful of the consumption categories.
*SAW 1.9.23 I am using Nigeria wave 3 as reference but will try to use less lines of code. 
recode crop_code 	(210/222			=1	"Beans and Cowpeas" )  ////   Beans, ,Cow peas
					(630  					=2	"Cassava"	)  //// 630 Cassava, 
					(520	 				=3	"Cotton"	)  ////	
					(650					=4	"Coco yam"	)  ////	
					(310 						=5	"Groundnuts"	)  ////					
					(150							=6	"Sorgum"	)  ////
					(130						=7  "Maize") ///
					(700 710 720 750 760 770 780 					=8	"Fruits") /// oranges, paw paw, pineapples, mango, jackfruit, avocado, passion fruit 
					(141						=9	"Millet")  //// finger Millet
					(120   					=10	"Rice"	)  ////
					(640				=11	"Yam"	)  //// 
					(221 223 224 =12 "Other nuts,seeds, and pulses"	)  ////  221  223 224 field peas, pigeon peas, chick peas,
					(740 741 742 744						=13	"Bananas")  ////  banana food, banana beer, banana swwet
					(410 420 440 450 460 470   					=14	"Vegetables"	)  ////  cabbage, tomatoes, onions, pumpkins, dodo, egglplants 
					(890 =15 "Other"	)  //// 
					(610						=16	"Potato")  ////  
					(620 					=17	"Sweet Potato"	)  ////  
					(320				=18	"Soya beans"	)  //// 
					(510 =19 "Sugar"	)  //// 
					(111						=20	"Wheat")  ////  
					(820					=21	"Cocoa"	)  ////  
					(830					=22	"Tea"	)  ////  
					(870					=23	"Vanilla"	)  ////  
					(320				=11	"Oils and Fat"	)  //// 
					(810 =24 "Coffee all"	)  //// 
					(330 =25 "Sunflower"	)  //// 
					(340 =26 "Simsim"	)  //// 
					(530 =27 "Tobacco"	)  //// 
					,generate(commodity)

gen type_commodity=	""
replace type_commodity = "Low" if inlist(commodity, 13, 2, 4, 7, 9, 12, 16, 6, 17, 11) 
/// banans, cassava, cocoyam, maize, millet, other nuts and seeds, potato, sorghum , sweet potato, yam 
replace type_commodity = "High" if inlist(commodity, 1, 21, 8, 5, 10, 18, 14, 13) 
/// beans and cowpeas, cocoa, fruits, groundnuts, rice, soybeans vegetables, bananas, 
replace type_commodity = "Out" if inlist(commodity, 3, 11, 19) 
/// cotton, oils n fats, sugar

preserve
collapse (sum) value_crop_production value_crop_sales, by(hhid commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_beanc 
	ren value_`s'2 value_`s'_casav 
	ren value_`s'3 value_`s'_coton 
	ren value_`s'4 value_`s'_cyam 
	ren value_`s'5 value_`s'_gdnut 
	ren value_`s'6 value_`s'_sorg 
	ren value_`s'7 value_`s'_maize
	ren value_`s'8 value_`s'_fruit
	ren value_`s'9 value_`s'_mill 
	ren value_`s'10 value_`s'_rice
	ren value_`s'11 value_`s'_oilc
	ren value_`s'12 value_`s'_onuts 
	ren value_`s'13 value_`s'_bana
	ren value_`s'14 value_`s'_vegs
	ren value_`s'15 value_`s'_oths
	ren value_`s'16 value_`s'_pota 
	ren value_`s'17 value_`s'_spota
	ren value_`s'18 value_`s'_sybea
	ren value_`s'19 value_`s'_suga
	ren value_`s'20 value_`s'_whea
	ren value_`s'21 value_`s'_cocoa
	ren value_`s'22 value_`s'_tea 
	ren value_`s'23 value_`s'_vanil
	ren value_`s'24 value_`s'_coffe
	ren value_`s'25 value_`s'_sunfl
	ren value_`s'26 value_`s'_simsim
	ren value_`s'27 value_`s'_tobac
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
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production_grouped.dta", replace
restore

collapse (sum) value_crop_production value_crop_sales, by(hhid type_commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(type_commodity)
separate value_sal, by(type_commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_high
	ren value_`s'2 value_`s'_low
	ren value_`s'3 value_`s'_other
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
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
                          * SHANNON DIVERSITY INDEX *
*******************************************************************************
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_area_plan.dta", replace
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0 
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_shannon_diversity_index.dta", replace

********************************************************************************
                          * CONSUMPTION *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/UNPS 2011-12 Consumption Aggregate.dta", clear
*gen nrrexp = cpexp30 * (100.000000 / 66.67894615) // (CPI 2010&11 / CPI 2005&06) 2010/2005
gen nrrexp = cpexp30 * (116.5643496 / 71.55362795) // (CPI 2010&11 / CPI 2005&06) 2011/2006
ren nrrexp  total_cons 
*ren cpexp30  total_cons 
ren equiv adulteq
ren welfare peraeq_cons
ren HHID hhid
tostring hhid, format(%18.0f) replace
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhsize.dta", nogen keep(1 3)
gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30
gen daily_percap_cons = percapita_cons/30 // saw why 30? days in a month? 
lab var total_cons "Total HH consumption, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var peraeq_cons "Consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var percapita_cons "Consumption per capita, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var daily_peraeq_cons "Daily consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var daily_percap_cons "Daily consumption per capita, in 05/06 prices, spatially and temporally adjusted in 11/12" 

keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_consumption.dta", replace

**We create an adulteq dataset for summary statistics sections
use "${Uganda_NPS_W2_raw_data}/UNPS 2011-12 Consumption Aggregate.dta", clear
rename equiv adulteq
rename HHID hhid
keep hhid adulteq
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_adulteq.dta", replace

********************************************************************************
                          * FOOD SECURITY *
********************************************************************************

use "${Uganda_NPS_W2_raw_data}/GSEC15B", clear
rename hh HHID
rename h15bq5 fd_home
rename h15bq7 fd_awayhome
rename h15bq9 fd_ownp
rename h15bq11 fd_gift
egen food_total = rowtotal(fd*) 
collapse (sum) fd* food_total, by(HHID)
duplicates report HHID
tostring HHID, format(%18.0f) replace
merge 1:1 HHID using "${Uganda_NPS_W2_raw_data}/UNPS 2011-12 Consumption Aggregate.dta", nogen keep(1 3)
ren HHID hhid
tostring hhid, format(%18.0f) replace
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhsize.dta", nogen keep(1 3)
drop if equiv ==.
recode fd* food_total (0=.)
gen daily_peraeq_fdcons = food_total/equiv /365 
gen daily_percap_fdcons = food_total/hh_members/365
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_food_cons.dta", replace

********************************************************************************
                          * FOOD PROVISION *
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC17A", clear //Have you been faced with a situation when you did not have enough food to feed in the last 12 months Yes/No answer? Maybe this works? The questionnaire includes months when this happened but the actual dataset does not. 
*append using "${Uganda_NPS_W2_raw_data}/GSEC17B"
gen food_insecurity = 1 if h17q09==1
*CPK: months are in the survey but not in the data set - I redownlaoded it and it is still not there unfortunately
replace food_insecurity = 0 if food_insecurity==.
*collapse (sum) months_food_insec= food_insecurity, by(HHID)
gen months_food_insec = .
keep HHID food_insecurity months_food_insec
lab var months_food_insec "Number of months where the household experienced any food insecurity" 
ren HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_food_insecurity.dta", replace
*CPK: not sure how valuable this is without the months variable - created it anyway and left it blank
********************************************************************************
                          *HOUSEHOLD ASSETS*
********************************************************************************
use "${Uganda_NPS_W2_raw_data}/GSEC14", clear 
rename h14q5 value_today
rename h14q4 num_items
*dropping items if hh doesnt report owning them 
keep if h14q3==1
collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets in Shs"
format value_assets %20.0g
ren HHID hhid
save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_assets.dta", replace

********************************************************************************
                         *DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument

********************************************************************************



********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************
global empty_vars ""
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", clear
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_cost_inputs.dta", nogen

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_inputs_`c'.dta", nogen
	merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_`c'_monocrop_hh_area.dta", nogen
}

//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 
*disaggregate by gender of plot manager
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(/*val_anml_`c'_`i'*/ val_mech_`c'_`i' val_labor_`c'_`i' val_pest_`c'_`i' val_inorg_`c'_`i' val_orgfert_`c'_`i' val_plotrent_`c'_`i' val_seeds_`c'_`i' /*val_transfert_`c'_`i' val_seedtrans_`c'_`i'*/) //These are already narrowed to explicit costs
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
drop /*val_anml**/ val_mech* val_labor* /*val_herb**/ val_inorg* val_orgfert* val_plotrent* val_seeds* /*val_transfert* val_seedtrans**/ val_pest* val_parcelrent* //

*Land rights
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish Income // SAW No fish income for Uganda wave 3 
gen fish_income_fishfarm = 0
gen fish_income_fishing =0
gen fishing_income = 0
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars fish_income*

*Livestock income
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_products.dta", nogen keep(1 3)
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 hhid using"${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_TLU_Coefficients.dta", nogen keep(1 3)
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced /*value_other_produced fish_income_fishfarm*/  cost_*livestock (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced/*value_other_produced*/) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_other_livestock) /*fish_income_fishfarm*/
*Notes: SAW should we include value of livestock products here?
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
*gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
gen livestock_expenses = (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_other_livestock)
lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
ren cost_vaccines_livestock ls_exp_vac 
gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced /*value_other_produced*/)
lab var livestock_product_revenue "Gross revenue from sale of livestock products"
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
gen animals_lost12months =0 
gen mean_12months=0
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
*CPK: already have this variable defined?
*gen any_imp_herd_all = . 
foreach v in ls_exp_vac /*any_imp_herd*/{
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
*/
//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months /*ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*/

*Self-employment income
merge 1:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta", nogen keep(1 3)
*SAW: This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is already part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_agwage_income.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_other_income.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_remittance_income.dta", nogen keep(1 3)
*SAW: Remittance income is already included in the other income dataset. (Need to check why)
egen transfers_income = rowtotal (remittance_income pension_income)
*SAW There is a confusion between remittance income and assistance income in the UGanda Other Income section that needs to be revised.
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm Size
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size_all.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_size_total.dta", nogen keep(1 3)
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
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_vaccine.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fert_use.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_input_use.dta", nogen keep(1 3)
*SAW: This Input Use dataset comes from the Plot Manager section that is constructed in the Nigeria Wave 3 do file which includes fert use and improved seed use along pesticides and fertilizers into one single dataset. We might want to construct this section in Uganda for fewer lines of code in the future. (It comes adter the Fertilizer Use and Improved Seed sections in Uganda)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_any_ext.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fin_serv.dta", nogen keep(1 3) // SAW Not Available for Uganda Wave 3 dta missing
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode /*use_fin_serv**/ ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_milk_animals.dta", nogen keep(1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
la var costs_dairy "Dairy production cost (explicit)"
la var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen liters_per_cow = . 
gen liters_per_buffalo = . 
gen share_imp_dairy = . 
*gen milk_animals = . 
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy /*liters_per_cow *liters_per_largerruminant*/

*Egg productivity
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
*gen liters_milk_produced = milk_months_produced * milk_quantity_produced // SAW 2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year
*/

*Costs of crop production per hectare
merge 1:1 hhid  using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_fertilizer_application.dta", nogen keep(1 3)


*Agricultural wage rate
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_ag_wage.dta", nogen keep(1 3)


*Crop yields 
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_yield_hh_crop_level.dta", nogen keep(1 3)


*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

 
*Household diet
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_household_diet.dta", nogen keep(1 3)


*consumption 
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*SAW 3/14/23 The section Food Security and Food Consumption at the hh level has not been included yet in nigeria and uganda even though it is available. Any reasons why?

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health // cannot construct
gen disease_animal=. 
global empty_vars $empty_vars disease_animal* disease_*

*CPK: don't have livestock feeding, water, and housing section
*merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_livestock_feed_water_house.dta", nogen keep(1 3)

*Shannon Diversity index
merge 1:1 hhid using  "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
egen value_farm_production = rowtotal(value_crop_production value_livestock_products value_slaughtered value_lvstck_sold) 
lab var value_farm_production "Total value of farm production (crops + livestock products)"
egen value_farm_prod_sold = rowtotal(value_crop_sales sales_livestock_products value_livestock_sales) 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=. 

*Agricultural households
recode crop_income livestock_income farm_area tlu_today land_size farm_size_agland value_farm_prod_sold (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income !=0 | farm_area!=0 | tlu_today!=0)
recode value_farm_production value_farm_prod_sold value_crop_production value_livestock_products value_slaughtered value_lvstck_sold (0=.) if ag_hh==0
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"
replace value_farm_production=. if ag_hh==0


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
gen fishing_hh = (fishing_income!=0)
lab  var fishing_hh "1= Household has some fishing income" // SAW Not Available

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' /*total_harv_area_`cn'*/ `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' /*total_harv_area_`cn'*/ `cn'_exp (nonmissing=.) if grew_`cn'==0
}

*all rural households engaged in livestock production of a given species - CPK: don't have the Livestock Water, Feeding, and Housing section so can't do this loop
/*
foreach i in lrum srum poultry {
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i'*/ feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i'*/ feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*/
gen lvstck_housed_poultry=.
gen lvstck_housed_srum=.
gen lvstck_housed_lrum=.
gen feed_grazing_lrum=.
gen feed_grazing_poultry=.
gen feed_grazing_srum=.
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland /*all_area_harvested*/ all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland /*all_area_harvested*/ all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal /*feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed*/ (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal /*feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed*/ (nonmissing=.) if livestock_hh==0		

*all rural households 
recode /*DYA.10.26.2020*/ /*hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/ off_farm_hours off_farm_any_count crop_income livestock_income self_employment_income nonagwage_income agwage_income /*fishing_income*/ transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed" //ALT 08.04.21
*Variables winsorized at the top 1% only 

global wins_var_top1 value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* /*total_harv_area*/ labor_hired labor_family animals_lost12months mean_12months /*lost_disease*/ liters_milk_produced costs_dairy eggs_total_year value_eggs_produced value_milk_produced off_farm_hours off_farm_any_count crop_production_expenses value_assets cost_expli_hh livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh //ALT 08.04.21: Kludge til I get names fully consistent
*global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli /*fert_inorg_kg*/ inorg_fert_kg wage_paid_aglabor
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli /*fert_inorg_kg*/ inorg_fert_kg org_fert_kg n_kg p_kg k_kg pest_kg wage_paid_aglabor


foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
	
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top ${wins_upper_thres}%"
	}
}

drop *wage_paid_aglabor_mixed
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top ${wins_upper_thres}%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland /*all_area_harvested*/ all_area_planted ha_planted /*
*/ crop_income livestock_income /*fishing_income*/ self_employment_income nonagwage_income agwage_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* /*dist_agrodealer*/ land_size_total

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

*Winsorizing variables that go into yield at the top and bottom 5% //IHS 10.2.19
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 /*area_harv*/  area_plan harvest //ALT 08.04.21: Breaking here. To do: figure out where area_harv comes from.
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p(1 99)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0 
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 5%"	
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 5%"
			
		}
	}
}

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
 
  /*Yield by Area Harvested // SAW 2.20.23 Area Harvest not available 
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
} */

*generate inorg_fert_rate, costs_total_ha, and costs_explicit_ha using winsorized values
foreach v in inorg_fert org_fert n p k /*herb*/ pest /*urea npk*/ {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'	
	}
}

gen cost_total_ha=w_cost_total/w_ha_planted 
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
*lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
*lab var urea_rate "Rate of urea application (kgs/ha) (household)"
*lab var npk_rate "Rate of NPK fertilizer application (kgs/ha) (household)" 

foreach g in $gender {
lab var inorg_fert_rate_`g' "Rate of fertilizer application (kgs/ha) (`g'-managed crops)"
lab var cost_total_ha_`g' "Explicit  implicit costs (per ha) of crop production (`g'-managed plots)"
lab var cost_expli_ha_`g' "Explicit costs (per ha) of crop production (`g'-managed plots)"
lab var org_fert_rate_`g' "Rate of organic fertilizer application (kgs/ha) (`g'-managed plots)"
lab var n_rate_`g' "Rate of nitrogen application (kgs/ha) (`g'-managed plots)"
lab var k_rate_`g' "Rate of postassium application (kgs/ha) (`g'-managed plots)"
lab var p_rate_`g' "Rate of phosphorus appliction (kgs/ha) (`g'-managed plots)"
lab var pest_rate_`g' "Rate of pesticide application (kgs/ha) (`g'-managed plots)"
*lab var herb_rate_`g' "Rate of herbicide application (kgs/ha) (`g'-managed plots)"
*lab var urea_rate_`g' "Rate of urea application (kgs/ha) (`g'-managed plots)"
*lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
}

lab var cost_total_ha "Explicit  implicit costs (per ha) of crop production (household level)"		
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"


/*
*generate inorg_fert_rate, costs_total_ha, and costs_explicit_ha using winsorized values
gen inorg_fert_rate=w_inorg_fert_kg/w_ha_planted
*gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha = w_cost_total / w_ha_planted
gen cost_expli_ha = w_cost_expli / w_ha_planted 

foreach g of global gender {
	gen inorg_fert_rate_`g'=w_inorg_fert_kg_`g'/ w_ha_planted_`g'	
	*gen inorg_fert_rate_`g'=w_fert_inorg_kg_`g'/ w_ha_planted_`g'
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 		
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var inorg_fert_rate_male "Rate of fertilizer application (kgs/ha) (male-managed crops)"
lab var inorg_fert_rate_female "Rate of fertilizer application (kgs/ha) (female-managed crops)"
lab var inorg_fert_rate_mixed "Rate of fertilizer application (kgs/ha) (mixed-managed crops)"
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production costs that can be disaggregated at the plot manager level"
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production costs that can be disaggregated at the plot manager level"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"
*/


*animals_lost12months this is an empty var 
global animal_species lrum srum pigs equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
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

 *Hours per capita using winsorized version off_farm_hours 
 /*
foreach x in /*ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all*/ off_farm_hours /*off_farm_any_count*/ {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}
*/
gen hrs_off_farm_pc_all = off_farm_hours/member_count
lab var hrs_off_farm_pc_all "Per capita (all) Total hours Total household off-farm hours, for the past 7 days"
gen hrs_off_farm_pc_any = off_farm_hours/off_farm_any_count 
lab var hrs_off_farm_pc_any  "Per capita (only worker) Total hours Total household off-farm hours, for the past 7 days"
*SAW 3/13/23 Here, only worker represents the number of hh members with off farm work hours. In nigeria w3 nworker might represent something else. Nee to check. Notes: We don't havre information for the set of indicators shown in NGA w3 (e.g. unpaid_off_farm domes_fire_fuel domes_all etc.)

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh / w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"


*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

/*
*milk productivity
gen liters_per_largeruminant= .
la var liters_per_largeruminant "Average quantity (liters) per year (household)"
global empty_vars $empty_vars liters_per_largeruminant		
*/

*milk productivity
gen liters_per_largeruminant= w_liters_milk_produced
la var liters_per_largeruminant "Average quantity (liters) per year (household)"
*SAW 3/13/23 Not sure why Nga w3 does not calculate this.. what is the rationale for adding empty_vars when there's information available?

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
global empty_vars $empty_vars cost_per_lit_milk lvstck_housed* feed_grazing* months_food_insec
* 3/13/23 SAW No information available, -though, variables have been created.


*****getting correct subpopulations***
*all rural housseholds engaged in crop production 
recode inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
*recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0

*all rural households engaged in livestock production of a given species
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

/*
*all rural households harvesting specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}
*/
*SAW 3/13/23 No information on yield by area harvested (no info of harvested area.) We could calculate this indicators using area yield by area planted potentially. Check with Andrew/Didier.

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
}

/*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'==0 | w_area_plan_pure_`cn'==.  
}
*/
*SAW 3/13/23 No information on yield by area harvested (no info of harvested area.) We could calculate this indicators using area yield by area planted potentially. Check with Andrew/Didier.

*households engaged in dairy production  
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1				
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0		

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	*if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {
	if inlist("`v'", "inorg_fert_rate",   "cost_total_ha", "cost_expli_ha", "n_rate", "p_rate") | inlist("`v'", "k_rate", "pest_rate") {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top ${wins_upper_thres}%"
		}	
	}
}

*winsorizing top crop ratios
foreach v of global topcropname_area {
	*first winsorizing costs per hectare
	_pctile `v'_exp_ha [aw=weight] , p($wins_upper_thres)  
	gen w_`v'_exp_ha=`v'_exp_ha
	replace  w_`v'_exp_ha = r(r1) if  w_`v'_exp_ha > r(r1) &  w_`v'_exp_ha!=.
	local l`v'_exp_ha : var lab `v'_exp_ha
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha - Winzorized top ${wins_upper_thres}%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha_`g' : var lab `v'_exp_ha_`g'
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha_`g'' - Winzorized top ${wins_upper_thres}%"
	}

	*winsorizing cost per kilogram
	_pctile `v'_exp_kg [aw=weight] , p($wins_upper_thres)  
	gen w_`v'_exp_kg=`v'_exp_kg
	replace  w_`v'_exp_kg = r(r1) if  w_`v'_exp_kg > r(r1) &  w_`v'_exp_kg!=.
	local l`v'_exp_kg : var lab `v'_exp_kg
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winzorized top ${wins_upper_thres}%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_kg_`g'= `v'_exp_kg_`g'
		replace w_`v'_exp_kg_`g' = r(r1) if w_`v'_exp_kg_`g' > r(r1) & w_`v'_exp_kg_`g'!=.
		local l`v'_exp_kg_`g' : var lab `v'_exp_kg_`g'
		lab var w_`v'_exp_kg_`g' "`l`v'_exp_kg_`g'' - Winzorized top ${wins_upper_thres}%"
	}
}

*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl /*yield_hv*/{
		_pctile `i'_`c' [aw=weight] ,  p(95)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winzorized top ${wins_95_thres}% and bottom ${wins_5_thres}%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winzorized top ${wins_95_thres}% and bottom ${wins_5_thres}%"
		}
	}
}

***DYA 12.06.19 Because of the use of odd area units in Nigeria, we have many tiny plots. We are reporting yield when area_plan>0.1ha
foreach c of global topcropname_area {
	replace w_yield_pl_`c'=. if w_area_plan_`c'<0.05
	*replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		*replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
	}
}
*SAW 3/13/23 Not sure if this applies for Uganda, must check with Andrew/Didier

*Create final income variables using un_winzorized and un_winzorized values
egen total_income = rowtotal(crop_income livestock_income /*fishing_income*/ self_employment_income nonagwage_income agwage_income transfers_income all_other_income)

egen nonfarm_income = rowtotal(/*fishing_income*/ self_employment_income nonagwage_income transfers_income all_other_income)

egen farm_income = rowtotal(crop_income livestock_income agwage_income)

lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"

egen w_total_income = rowtotal(w_crop_income w_livestock_income /*w_fishing_income*/ w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)

egen w_nonfarm_income = rowtotal(/*w_fishing_income*/ w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top ${wins_upper_thres}%"
lab var w_farm_income "Farm income - Winzorized top ${wins_upper_thres}%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top ${wins_upper_thres}%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top ${wins_upper_thres}%"
global income_vars crop livestock /*fishing*/ self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
	gen `p'_income_s = `p'_income
	replace `p'_income_s = 0 if `p'_income_s < 0
	gen w_`p'_income_s = w_`p'_income
	replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}

egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s /*w_fishing_income_s*/ w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)

foreach p of global income_vars {
	gen w_share_`p' = w_`p'_income_s / w_total_income_s
	lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}
egen w_nonfarm_income_s = rowtotal(/*w_fishing_income_s*/ w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)

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
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income_s*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock /*w_share_fishing*/ w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ /*use_fin_serv*/ use_inorg_fert use_org_fert use_pest imprv_seed_use /*
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all   w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestock production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' animals_lost12months_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' animals_lost12months_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}
 
*households engaged in crop production
recode *proportion_cropvalue_sold *farm_size_agland *labor_family *labor_hired /*
*/ imprv_seed_use use_inorg_fert use_org_fert use_pest /*use_herb*/ *labor_productivity *land_productivity /*
*/ *inorg_fert_rate *org_fert_rate *n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ /*
*/ *cost_expli_hh *cost_expli_hh_ha *cost_expli_ha *cost_total_ha /*
*/ *value_crop_production *value_crop_sales *all_area_planted /**all_area_harvested*/ (.=0) if crop_hh==1

recode *proportion_cropvalue_sold *farm_size_agland *labor_family *labor_hired /*
*/ imprv_seed_use use_inorg_fert use_org_fert use_pest /*use_herb*/ *labor_productivity *land_productivity /*
*/ *inorg_fert_rate *org_fert_rate *n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ /*
*/ *cost_expli_hh *cost_expli_hh_ha *cost_expli_ha *cost_total_ha /*
*/ *value_crop_production *value_crop_sales *all_area_planted /**all_area_harvested*/ (nonmissing= . ) if crop_hh==0

/* 
*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested*/ (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested*/ (nonmissing= . ) if crop_hh==0
*/
	
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 

forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	local varlist "imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' w_yield_hv_`cn' w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg"
	foreach var in `varlist' {
		capture confirm var `var'
		if _rc {
			gen `var' = .
		} 
		else 
		{
			recode `var' (.=0) if grew_`cn'==1
			recode `var' (nonmissing=.) if grew_`cn'==0
		}
	}
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
	_pctile `p'_aghh  [aw=weight] , p(40) 
	gen small_`p' = (`p' <= r(r1))
	replace small_`p' = . if ag_hh!=1
}

gen small_farm_household = (small_land_size==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 
drop land_size_aghh small_land_size tlu_today_aghh small_tlu_today total_income_aghh small_total_income   
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"

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
gen weight_milk=. //cannot create in this instrument
gen weight_egg=. //cannot create in this instrument
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

* Poverty Indicator Updates
*Rural poverty headcount ratio
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


****Currency Conversion Factors***
gen ccf_loc = (1/$Uganda_NPS_W2_inflation) 
lab var ccf_loc "currency conversion factor - 2021 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W2_exchange_rate
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

/*gen ccf_loc = 1 
lab var ccf_loc "currency conversion factor - 2017 $NGN"
gen ccf_usd = 1/$Uganda_NPS_W2_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = 1/ $Uganda_NPS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = 1/ $Uganda_NPS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"
*/
*Poverty indicators 
gen poverty_under_190 = (daily_percap_cons < $Uganda_NPS_W2_poverty_190)
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = (daily_percap_cons < $Uganda_NPS_W2_poverty_215)
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_300 = (daily_percap_cons < $Uganda_NPS_W2_poverty_300)
la var poverty_under_300 "Household per-capita consumption is below $3.00 in 2021 $ PPP"

rename hhid HHID
*We merge the national poverty line provided by the World bank 
tostring HHID, format(%18.0f) replace
merge 1:1 HHID using "${Uganda_NPS_W2_raw_data}/UNPS 2011-12 Consumption Aggregate.dta", keep(1 3) nogen 
*gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W1_poverty_nbs
rename poor poverty_under_npl
rename HHID hhid
la var poverty_under_npl "Household per-capita consumption is below national poverty line in 05/06 PPP prices"

*generating clusterid and strataid
gen clusterid=ea
*gen strataid=region

*dropping unnecessary varables
drop *_inter_*

/*
*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in wheat beans {
		gen `x'_xx = .
		ren *maize*_xx *`c'*
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
keep hhid fhh poverty* clusterid strataid *weight* /*wgt*/ region /*regurb*/ district county subcounty parish ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ /*feed* water* lvstck_housed**/ ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* /*lost_disease*/ disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* /*milk_animals*/ poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* /**total_harv_area**/ /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb* /*nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* /*area_harv**/  *value_pro* *value_sal*
*SAW 3/14/23 Need to check for the ones available in Uganda but not in Nigeria.
*What about harvested_*, 

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) if ag_hh==1

ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren HHID hhid //hhid should be in lower case throughout for AgQuery+ compatibility
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2011-12" 
gen instrument = 53 
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
saveold "${Uganda_NPS_W2_final_data}/Uganda_NPS_W2_household_variables.dta", replace

********************************************************************************
                          *INDIVIDUAL-LEVEL VARIABLES*
********************************************************************************
//AT to address: PID |> personid
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_person_ids.dta", clear
merge 1:1 hhid PID using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_control_income.dta", nogen keep(1 3)
merge 1:1 hhid PID using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_ownasset.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhsize.dta", nogen keep(1 3)
merge 1:1 hhid PID using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_fert_use.dta", nogen keep(1 3) 
merge 1:1 hhid PID using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_improved_seed_use.dta", nogen keep(1 3)
merge 1:1 hhid PID using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_farmer_vaccine.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(1 3)

*Land rights
merge 1:1 hhid personid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_land_rights_ind.dta", nogen keep(1 3)
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income /*make_decision_ag*/ own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income /*make_decision_ag*/ own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_W2_final_data}/Uganda_NPS_W2_household_variables.dta", clear
keep hhid ag_hh
*ren hhid HHID
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
*replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.
foreach c in wheat /*beans*/ {
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

/*gen female_vac_animal=vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
*/

*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

gen clusterid = ea

ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren HHID hhid
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2011-12" 
gen instrument = 53 
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
saveold "${Uganda_NPS_W2_final_data}/Uganda_NPS_W2_individual_variables.dta", replace

********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*SAW 14/04/23 This section uses Nigeria Wave 3 as reference

*GENDER PRODUCTIVITY GAP
use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_all_plots.dta", replace
collapse (sum) plot_value_harvest = value_harvest, by(hhid parcel_id plot_id season)
tempfile crop_values 
save `crop_values' // season level

use "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", replace // plot-season level
merge m:1 hhid using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_weights.dta", keep (1 3) nogen // hh level
merge 1:1 hhid parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge m:1 hhid parcel_id using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", keep (1 3) nogen //  plot-season level
merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_plot_labor_days.dta", keep (1 3) nogen // plot level
*ren hhid hhid //ALT: Standard for AgQuery is lower case
/*DYA.12.2.2020*/ merge m:1 hhid using "${Uganda_NPS_W2_final_data}/Uganda_NPS_W2_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region ea)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

*keep if cultivate==1 // 3/15/23 We need to generate this indicator
ren field_size  area_meas_hectares
egen labor_total = rowtotal(labor_family labor_hired /*labor_nonhired*/) // labor_nonhired needs to be created too. 
global winsorize_vars area_meas_hectares  labor_total  
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"
}

_pctile plot_value_harvest  [aw=weight] , p($wins_upper_thres)  
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winzorized top ${wins_upper_thres}%"

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
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
}	

/* SAW 4/20/23 OLD VERSION 
*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = (1) * `p' / $NPS_LSMS_ISA_W3_cons_ppp_dollar
	gen `p'_2ppp = (1) * `p' / $NPS_LSMS_ISA_W3_gdp_ppp_dollar
	gen `p'_usd = (1) * `p' / $NPS_LSMS_ISA_W3_exchange_rate
	gen `p'_loc = (1) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' 2016 (NGN)"  
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = (1) * w_`p' / $NPS_LSMS_ISA_W3_cons_ppp_dollar
	gen w_`p'_2ppp = (1) * w_`p' / $NPS_LSMS_ISA_W3_gdp_ppp_dollar
	gen w_`p'_usd = (1) * w_`p' /  $NPS_LSMS_ISA_W3_exchange_rate
	gen w_`p'_loc = (1) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' 2106 (NGN)"
	lab var w_`p' "`lw_`p'' (NGN)" 
}
*/

****Currency Conversion Factors***
gen ccf_loc = (1/$Uganda_NPS_W2_inflation) 
lab var ccf_loc "currency conversion factor - 2021 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W2_exchange_rate
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"


global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = `p' * ccf_1ppp
	gen `p'_2ppp = `p' * ccf_2ppp
	gen `p'_usd = `p' * ccf_usd 
	gen `p'_loc =  `p' * ccf_loc 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2017 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2017 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2017$ USD)"
	lab var `p'_loc "`l`p'' (2017 UGX)" 
	lab var `p' "`l`p'' (UGX)"  
	gen w_`p'_1ppp = w_`p' * ccf_1ppp
	gen w_`p'_2ppp = w_`p' * ccf_2ppp
	gen w_`p'_usd = w_`p' * ccf_usd
	gen w_`p'_loc = w_`p' * ccf_loc
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2017 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2017 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2017 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2017 UGX)" 
	lab var w_`p' "`lw_`p'' (UGX)" 
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
gen clusterid=ea
*gen strataid=region
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
svy, subpop(if rural==1) : reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region  
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
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls - LSP"
matrix V1b=e(V)
gen segender_prod_gap1b_lsp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_lsp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - LSP"
/*DYA.12.2.2020 - End*/ 


/*BET.12.4.2020 - START*/ 


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
rename v1 UGA_wave2

save "${Uganda_NPS_W2_created_data}/Uganda_NPS_W2_gendergap.dta", replace 
restore

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight
ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"
//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments

gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2011-12" 
gen instrument = 53
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
saveold "${Uganda_NPS_W2_final_data}/Uganda_NPS_W2_field_plot_variables.dta", replace 

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters

global list_instruments "Uganda_NPS_W2"
do "$summary_stats"



