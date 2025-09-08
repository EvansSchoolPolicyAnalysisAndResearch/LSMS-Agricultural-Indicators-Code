/*
--------------------------------------------------------------------------------------
*Title/Purpose: Agricultural Development Indicators for the LSMS-ISA, Uganda National Panel Survey (UNPS) LSMS-ISA Wave 4 (2013-14)

*Author(s): Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu
															  
*Date : September 5th, 2025

*Dataset Version: UGA_2013_UNPS_v03_M
--------------------------------------------------------------------------------------*/



*Data source
*-----------
* The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
* and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
* The data were collected over the period November 2013 - October 2014. 
* All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
* http://microdata.worldbank.org/index.php/catalog/2663

* Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


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

* The results are saved in the excel file "Uganda_NPS_W4_summary_stats.xlsx" in the "Final DTA Files/final_data" folder. 


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W4_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W4_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W4_weights.dta
*PARCEL AREAS						Uganda_NPS_W4_parcel_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W4_plot_decision_makers.dta

*MONOCROPPED PLOTS					Uganda_NPS_W4_[CROP]_monocrop_hh_area.dta					
*TLU (Tropical Livestock Units)		Uganda_NPS_W4_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W4_tempcrop_harvest.dta
									Uganda_NPS_W4_tempcrop_sales.dta
									Uganda_NPS_W4_permcrop_harvest.dta
									Uganda_NPS_W4_permcrop_sales.dta
									Uganda_NPS_W4_hh_crop_production.dta
									Uganda_NPS_W4_plot_cropvalue.dta
									Uganda_NPS_W4_parcel_cropvalue.dta
									Uganda_NPS_W4_crop_residues.dta
									Uganda_NPS_W4_hh_crop_prices.dta
									Uganda_NPS_W4_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_W4_wages_mainseason.dta
									Uganda_NPS_W4_wages_shortseason.dta
									Uganda_NPS_W4_fertilizer_costs.dta
									Uganda_NPS_W4_seed_costs.dta
									Uganda_NPS_W4_land_rental_costs.dta
									Uganda_NPS_W4_asset_rental_costs.dta
									Uganda_NPS_W4_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W4_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W4_livestock_products.dta
									Uganda_NPS_W4_livestock_expenses.dta
									Uganda_NPS_W4_hh_livestock_products.dta
									Uganda_NPS_W4_livestock_sales.dta
									Uganda_NPS_W4_TLU.dta
									Uganda_NPS_W4_livestock_income.dta

*FISH INCOME						n/a
																	
*SELF-EMPLOYMENT INCOME				n/a

									
*WAGE INCOME						Uganda_NPS_W4_wage_income.dta
									Uganda_NPS_W4_agwage_income.dta					

*OTHER INCOME						Uganda_NPS_W4_other_income.dta
									Uganda_NPS_W4_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_W4_land_size.dta
									Uganda_NPS_W4_farmsize_all_agland.dta
									Uganda_NPS_W4_land_size_all.dta
									Uganda_NPS_W4_land_size_total.dta					

*FARM LABOR							Uganda_NPS_W4_farmlabor_mainseason.dta
									Uganda_NPS_W4_farmlabor_shortseason.dta
									Uganda_NPS_W4_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_W4_vaccine.dta
									Uganda_NPS_W4_farmer_vaccine.dta					//NEW//
							
*ANIMAL HEALTH						Uganda_NPS_W4_livestock_diseases.dta				//NEW//
									Uganda_NPS_W4_livestock_feed_water_house.dta		//NEW//

*USE OF INORGANIC FERTILIZER		Uganda_NPS_W4_fert_use.dta
									Uganda_NPS_W4_farmer_fert_use.dta					//NEW//

*USE OF IMPROVED SEED				Uganda_NPS_W4_improvedseed_use.dta
									Uganda_NPS_W4_farmer_improvedseed_use.dta			//NEW//

*REACHED BY AG EXTENSION			Uganda_NPS_W4_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W4_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_W4_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_W4_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W4_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W4_hh_rental_rate.dta 					//NEW//
									Uganda_NPS_W4_hh_cost_land.dta
									Uganda_NPS_W4_hh_cost_inputs_fcs.dta
									Uganda_NPS_W4_hh_cost_inputs_scs.dta
									Uganda_NPS_W4_hh_cost_seed_fcs.dta
									Uganda_NPS_W4_hh_cost_seed_scs.dta	
									Uganda_NPS_W4_asset_rental_costs.dta 				//NEW//
									Uganda_NPS_W4_cropcosts_total.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W4_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W4_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_W4_ag_wage.dta					
*CROP YIELDS						Uganda_NPS_W4_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_W4_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_W4_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_W4_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_W4_hh_assets.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_W4_summary_stats.xlsx
*/

clear
clear matrix
clear mata
set more off
set maxvar 8000
ssc install findname  // need this user-written ado file for some commands to work

// set directories
* These paths correspond to the folders where the raw data files are located 
* and where the created data and final data will be stored.

global directory "../.."
global Uganda_NPS_W4_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 4/Raw DTA Files"
global Uganda_NPS_W4_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 4/Final DTA Files/created_data"
global Uganda_NPS_W4_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 4/Final DTA Files/final_data"     
global Uganda_NPS_conv_factors "$directory/Uganda UNPS/Nonstandard Unit Conversion Factors"
global summary_stats "$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do" //Path to the summary statistics file. This can take a long time to run, so comment out if you don't need it. The do file will end with an error.


********************************************************************************
*           EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS              *
********************************************************************************
global Uganda_NPS_W4_exchange_rate 3689.75      // https://www.bloomberg.com/quote/USDUGX:CUR // NKF 12.30.19 - What year? Present?
global Uganda_NPS_W4_gdp_ppp_dollar 1203.16 // 1251.63 was the value in 2017 https://data.worldbank.org/indicator/PA.NUS.PPP?locations=UG // UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Uganda_NPS_W4_cons_ppp_dollar 1315.27 // 1219.19 was the value in 2017  https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Uganda_NPS_W4_inflation (142/185.9) // 0.8515721875 was the infl rate in 2017. Data was collected during 2013-2014. Base year should be 2024 and is available as of the most recent update. As of 2025, we want to adjust the value to 2021 // I = CPI_SURVEY_YEAR/CPI_2021 -> CPI_2014/CPI_2021 -> (142/185.9) from https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG 
global Uganda_NPS_W4_poverty_threshold (1.90*944.26*(142.024166/116.6)) //$1.90 was the poverty line in 2011. 944.26 was the PPP in 2011. Since the survey was conducted in 2013-2014, we inflate based on CPI (2014)/CPI (2011).

* Notes:  Calculation for WB' previous $1.90 (PPP) poverty threshold, 2185.2775 Uganda Shilling UGX. This is calculated as the following: PovertyLine x PPP conversion factor (private consumption)t=2011 (reference year of PL, therefore 2011. This is fixed across waves so no need to change it) x Inflation(from t=2011 to t+1=last year survey was implemented). Inflation is calculated as the following: CPI Uganda inflation from 2011 (baseline year) to 2014 (last survey year) Inflation = Inflation (t=last survey year =2014)/Inflation (t= baseline year of PL =2011) https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG&name_desc=false and https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG

global Uganda_NPS_W4_poverty_215 (2.15 * 1219.19 * (142/166.8)) //$2.15 was the poverty line in 2017. 1219.19 was the PPP in 2017 so we deflate based on CPI (2014)/CPI (2017) since that is the year we're adjusting for. 
 
*SAW Now: The $2.15 Poverty line ($US) is converted to Uganda Shillings using the PPP Conversion Factor, Consumption of 2017 (so we get the value in UGX 2017) and then we deflate this value to the last year of the survey implementation 2014. Thr 2.15 PL is 2235.6652 UGX (2017) Notes: This time we had to deflate since our cpp was in 2017 but the last year of the survey was 2014, for the 2011 1.90 poverty line we had to inflate given that the baseline year was 2011 but the last year of the survey was 2012. 

*The national poverty line is merged later since it's already provided by the raw data (Also there npl has variation across regions so it's not a single number)

global Uganda_NPS_W4_poverty_300 (3.00 * $Uganda_NPS_W4_inflation * $Uganda_NPS_W4_cons_ppp_dollar )

********************************************************************************
*					THRESHOLDS FOR WINSORIZATION							   *
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
 * RE-SCALING SURVEY WEIGHTS TO MATH POPULATION ESTIMATES *
********************************************************************************
*Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Uganda_NPS_W4_pop_tot  36336539
global Uganda_NPS_W4_pop_rur  28522730
global Uganda_NPS_W4_pop_urb   7813809

********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
//Purpose: Generate a crop .dta file that only contains the priority crops. This is used in for a couple of other indicators down the line. You can edit this section to change which crops you are examining.

*Enter the 12 priority crops here (maize cassava beans fieldpeas sweetpotato fingermillet soyabeans banana coffee groundnut sorghum)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize cassav beans fldpea swtptt fmillt sybea banana coffee grdnt sorgum"
global topcrop_area "130 630 210 221 620 141 320 740 810 310 150"
global comma_topcrop_area "130, 630, 210, 221, 620, 141, 320, 740, 810, 310, 150"
global topcropname_area_full "maize cassava beans fieldpeas sweetpotato fingermillet soyabeans banana coffee groundnut sorghum"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area"
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
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_cropname_table.dta", replace
 //This gets used to generate the monocrop files.


********************************************************************************
*                                HOUSEHOLD IDS                                 *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\GSEC1.dta", clear
ren HHID hhid
*gen hhid=substr(hh, 1, 6) + substr(hh, 11, 2)
ren h1aq1a district 
ren h1aq3a county
ren h1aq3b county_name
ren h1aq4a parish
ren h1aq4b parish_name 
ren wgt_X weight //wgt_X  is cross-sectional weight for UNPS 2013-2014, applies to all respondents, alternative variable wgt only applies to those interviewed in previous waves
gen rural=urban==0
keep hhid region sregion district county county_name parish parish_name ea weight rural
lab var rural "1=Household lives in a rural area"
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta", replace

********************************************************************************
*	Individual ID, Household Head Gender, and Weights						   * //AT eliminated some redundancies with previous sections.
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\GSEC2.dta", clear
ren HHID hhid
//PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P0" and the "-"
destring PID, gen(indiv) ignore ("P" "-") 
gen female=h2q3==2 
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "indivdual age"
gen hh_head=h2q4==1 // SAK 2019-07-08: There is one Household with two heads. As
					// a group we need to decide how to handle this.
lab var hh_head "1= individual is household head"
ren h2q1 individ //2013/14 roster number // need the roster number for formal land rights 
keep indiv hhid female age hh_head individ PID
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_person_ids.dta", replace
gen hh_members = 1
gen fhh = (hh_head & female==1)
collapse (sum) hh_members (max) fhh, by (hhid)	
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
*SAW: 10.23.23 Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Uganda_NPS_W4_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Uganda_NPS_W4_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1
total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Uganda_NPS_W4_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0
egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_weights.dta", replace

********************************************************************************
** GEOVARIABLES **
********************************************************************************
*SAW 4/24/23 Updates based on CSIRO data request.
*SAW 7/31/23 No geovariables currently available. Must redownload World Bank data to check whether it's been updated. 

********************************************************************************
*PLOT AREA* 
********************************************************************************

/* Plot Area Section: The purpose of this section is to estimate field size at the plot level - right now, we have estimates of field size at the parcel level (2A and 2B). We calculate the plot area planted as as percentage of total area planted at the parcel level, and we use those percentages to estimate the field size at the plot level. */

use "${Uganda_NPS_W4_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC4B.dta", generate(last)		
replace season=2 if season==.
label var season "Season = 1 if 1st cropping season of 2011, 2 if 2nd cropping season of 2011"
drop HHID
ren hh hhid
*ren parcelID parcel_id
*ren plotID plot_id
drop if parcelID==.| plotID==.
ren cropID crop_code_master
drop if crop_code_master == .
gen cropcode = crop_code_master 
recode cropcode (811 812 = 810) (741 742 744 = 740) (224 = 223)
gen plot_area = a4aq7  //values are in acres
replace plot_area = a4bq7 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
rename plot_area ha_planted

*Now, generate variables to fix issues with the percentage of a plot that crops are planted on not adding up to 100 (both above and below). This is complicated so each line below explains the procedure
gen percent_planted = a4aq9/100
replace percent_planted = a4bq9/100 if percent_planted==.
bys hhid parcelID plotID season : egen total_percent_planted = sum(percent_planted) //generate variable for total percent of a plot that is planted (all crops)
duplicates tag hhid parcelID plotID season, g(dupes) //generate a duplicates ratio to check for all crops on a specific plot. the number in dupes indicates all of the crops on a plot minus one (the "original")
gen missing_ratios = dupes > 0 & percent_planted == . //now use that duplicate variable to find crops that don't have any indication of how much a plot they take up, even though there are multiple crops on that plot (otherwise, duplicates would equal 0)
bys hhid parcelID plotID season : egen total_missing = sum(missing_ratios) //generate a count, per plot, of how many crops do not have a percentage planted value.
gen remaining_land = 1 - total_percent_planted if total_percent_planted < 1 //calculate the amount of remaining land on a plot (that can be divided up amongst crops with no percentage planted) if it doesn't add up to 100%
bys hhid parcelID plotID season : egen any_missing = max(missing_ratios)
*Fix monocropped plots
replace percent_planted = 1 if percent_planted == . & any_missing == 0 //monocropped plots are marked with a percentage of 100% - impacts 5,244 crops
*Fix plots with or without missing percentages that add up to 100% or more
replace percent_planted = 1/(dupes + 1) if any_missing == 1 & total_percent_planted >= 1 //If there are any missing percentages and plot is at or above 100%, everything on the plot is equally divided (as dupes indicates the number of crops on that plot minus one) - this impacts 9 crops
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1 //some crops still add up to over 100%, but these ones aren't missing percentages. So we need to reduce them all proportionally so they add up to 100% but don't lose their relative importance.
*Fix plots that add up to less than 100% and have missing percentages
replace percent_planted = remaining_land/total_missing if missing_ratios == 1 & percent_planted == . & total_percent_planted < 1 //if any plots are missing a percentage but are below 100%, the remaining land is subdivided amonst the number of crops missing a percentage - impacts 205 crops

*Bring everything together
collapse (max) ha_planted (sum) percent_planted, by(hhid parcelID plotID season)
gen plot_area = ha_planted / percent_planted
bys hhid parcelID season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep hhid parcelID plotID season plot_area total_plot_area plot_area_pct ha_planted
rename hhid hh
merge m:1 hh parcelID using "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", nogen
merge m:1 hh parcelID using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
ren hh hhid
*generating field_size
generate parcel_acre = a2aq4 //JHG 10_27_21: Used GPS estimation here to get parcel size in acres if we have it, but many parcels do not have GPS estimation
replace parcel_acre = a2bq4 if parcel_acre == . 
replace parcel_acre = a2aq5 if parcel_acre == . //JHG 10_27_21: replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres)
replace parcel_acre = a2bq5 if parcel_acre == . //JHG 10_27_21: see above
gen field_size = plot_area_pct*parcel_acre //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen parcel_ha = parcel_acre * 0.404686
*cleaning up and saving the data
rename plotID plot_id
rename parcelID parcel_id
keep hhid parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size == .
label var field_size "Area of plot (ha)"
label var hhid "Household identifier"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", replace

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta" 
replace season = 2 if season == .
drop HHID
ren hh hhid
ren parcelID parcel_id
ren plotID plot_id

*First decision-maker variables 
ren a3aq3_3 indiv1
replace indiv1=a3bq3_3 if indiv1==.
replace indiv1=a3aq3_4a if indiv1==.
replace indiv1=a3bq3_4a if indiv1==.
ren a3aq3_4b indiv2
replace indiv2=a3bq3_4b if indiv2==.
keep hhid parcel_id plot_id season indiv*
reshape long indiv, i(hhid parcel_id plot_id season) j(id_no)
drop if indiv==. | plot_id==.
merge m:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen keep(1 3) 		//993 unmatched. 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_dm_ids.dta", replace
gen dm1_gender=female+1 if id_no==1
collapse (mean) female (firstnm) dm1_gender, by(hhid parcel_id plot_id season)
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen //These files should get organized.
gen dm_gender=3 if female!=.
replace dm_gender=1 if female==0
replace dm_gender=2 if female==1
*Replacing observations without gender of plot manager with gender of HOH
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
replace dm1_gender = dm_gender if dm1_gender==. & dm_gender <3
keep hhid parcel_id plot_id season dm* fhh 
label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"
la val dm1_gender dm_gender 
la var dm1_gender "Gender of main plot manager"
//duplicates drop hhid season parcel_id, force //ALT - Why is this drop here?
***lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS*
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
drop HHID
    ren hh hhid
    ren parcelID parcel_id
    drop if parcel_id==.
gen formal_land_rights=(a2aq23==1 | a2aq23==2 | a2aq23==3) //hh has certificate/ title, certificate of customary ownership, or certificate of occupancy


*Starting with first owner
preserve
	ren a2aq26a indiv
	merge m:1 hhid indiv using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_person_ids.dta" //, nogen keep(3) //keep only matched
	keep hhid indiv female formal_land_rights
	tempfile p1
	save `p1', replace
restore

*Now second owner
preserve
	ren a2aq26b indiv
	recode indiv (99999999=.)
	merge m:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta" //, nogen keep(3)	//keep only matched 
	keep hhid indiv female formal_land_rights
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 if female==1
	collapse (max) formal_land_rights_f, by(hhid indiv)		
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_ind.dta", replace
restore	

preserve
	collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)	// taking max at household level; equals one if they have official documentation for at least one plot
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_hh.dta", replace
restore

********************************************************************************
** 								ALL PLOTS 					  **
********************************************************************************
/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.
*/

**********************************
** Crop Values **
**********************************
use "${Uganda_NPS_W4_raw_data}/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/AGSEC5B.dta"
replace season = 2 if season == .
gen condition_harv=a5aq6b
replace condition_harv =  a5bq6b if condition_harv==.
gen unit_code_harv=a5aq6c
replace unit_code_harv = a5bq6c if unit_code_harv==.


*Unit of crop Sold
gen sold_unit_code=a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
gen sold_value = a5aq8
replace sold_value=a5bq8 if sold_value==.

gen sold_qty=a5aq7a
replace sold_qty=a5bq7a if sold_qty==.
drop HHID
ren hh hhid
merge m:1 hhid using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code

**********************************
** Standard Conversion Factor Table **
**********************************
*This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold 

***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
*merge m:1 crop_code sold_unit_code region using "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_sold_table.dta", keep(1 3) nogen 
merge m:1 crop_code sold_unit_code region using  "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 *We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen quant_sold_kg = sold_qty*s_conv_factor_sold
replace quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen price_unit = sold_value/quant_sold_kg 
gen obs1 = price_unit!=.


// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standard conversion factor table)
	foreach i in region district county county_name parish ea hhid {
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

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
*merge m:1 crop_code unit_code region using "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 
merge m:1 crop_code unit_code region using "${Uganda_NPS_conv_factors}\UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 


***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${Uganda_NPS_conv_factors}\UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
*This is for HHID that are missing regional information


*SAW 5/23/23 From Conversion factor section to calculate medians
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity_harv==.
*gen quant_harv_kg = quantity_harv*conv_factor_harv 
replace s_conv_factor_harv = sn_conv_factor_harv if region==. //  SAW 7/25/23 We merge the national standard conversion factor for those HHID with missing regional info.
gen quant_harv_kg = quantity_harv*s_conv_factor_harv 

*Notes: There are many observations who harvested but do not have s_conversion factors harvest given that they are missing the region variable (Need to fix this) One option would be to calculate national level median conversion factors -both harvested and sold - and assign those values to HHID with missing region information.

*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg  that using the WB conversion factors -though there are many cases that standard qty harvested is smaller than the WB qty harvested. 
*Notes: Should we winsorize the sold qty ($) prior to calculating the price per kg giventhis variable is also driving the variation and has many outliers. Though, it won't affect themedian price per kg it will affect the  price per unit for all the observations that do have sold harvested affecting the value of harvest. 

**********************************
**  Update: Standard Conversion Factor Table END **
**********************************
 * We do not have information about the year of harvest. Questionnaire references the variable to year 2011 and we have information on month of harvest start and month of harvest end.
gen month_harv_date = a5aq6e
replace month_harv_date = a5bq6e if season==2
gen year_harv_date = a5aq6e_1
replace year_harv_date = a5bq6e_1
gen harv_date = ym(year_harv_date,month_harv_date)
format harv_date %tm
label var harv_date "Harvest start date"

gen month_harv_end = a5aq6f
replace month_harv_end = a5bq6f
gen year_harv_end = a5aq6f_1
replace year_harv_end = a5bq6f_1 if year_harv_end==.
gen harv_end = ym(year_harv_end,month_harv_end)
format harv_end %tm
label var harv_end "Harvest end date"

* Create Price unit for converted sold quantity (kgs)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=.
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
	
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_value.dta", replace
*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested*/

**********************************
** Plot Variables **
**********************************
* Only focus on the following Variables that we can construct with 4A and 4B only that we are looking for: Date planted, permanent crops,  intercropped/monocropped, purestand, just focus on those.
preserve	
use "${Uganda_NPS_W4_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC4B.dta"
replace season=2 if season==.
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code_plant //crop codes for what was planted
drop if crop_code_plant == .
clonevar crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
drop HHID
ren hh hhid
*Merge area variables (now calculated in plot areas section earlier)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3)	
gen use_imprv_seed = (a4aq13==2) if a4aq13!=.
replace use_imprv_seed= (a4bq13==2) if use_imprv_seed==. & a4bq13!=.

*Creating time variables (month planted, harvested, and length of time grown)
gen month_planted = a4aq9_1
replace month_planted =a4bq9_1 if month_planted==.
clonevar year_planted1 =a4aq9_2
replace year_planted1= a4bq9_2 if  year_planted==.
decode year_planted1, gen(year_planted)
replace year_planted="2000" if year_planted=="2000 or earlier"
destring year_planted, replace
gen plant_date = ym(year_planted,month_planted)
format plant_date %tm
label var plant_date "Plantation start date"
clonevar crop_code =  crop_code_master 

gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 741, 742, 744, 740, 750, 760, 770, 780, 810, 811, 812, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?
duplicates drop hhid parcel_id plot_id crop_code season, force
tempfile plotplanted
save `plotplanted'
restore
merge m:1 hhid parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3)

**********************************
** Plot Variables After Merge **
**********************************
/*
gen months_grown1 = harv_date - plant_date if perm_tree==0
gen months_grown = harv_date - plant_date if perm_tree==0

*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(a5aq17,1,5) | inrange(a5bq17,1,5) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
		collapse (sum) crops_plot = obs2, by(hhid parcel_id plot_id season)
		replace crops_plot=1 if crops_plot > 1 & crops_plot!=.
		collapse (sum) crops_plot, by(hhid parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 hhid parcel_id plot_id season using `ncrops', nogen
	*drop if hh_agric == .
	gen contradict_mono = 1 if a4aq9 == 100 | a4bq9 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if a4aq9 == 100 | a4aq8 == 1 | a4bq9 == 100 | a4bq8 == 1 //meanwhile 145 list intercropping or mixed cropping but only report one crop

*Generate variables around lost and replanted crops
	gen lost_crop = inrange(a5aq17,1,5) | inrange(a5bq17,1,5) // SAW I think it should be intange(var,1,5) why not include "other"
	bys hhid parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	gen replanted = (max_lost == 1 & crops_plot > 0)
	preserve 
	keep if replanted==1 & lost_crop==1 
	tempfile lostcrops
	save `lostcrops'
	restore
	gen purestand=crops_plot==1
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.

	*Generating monocropped plot variables (Part 1)
	bys hhid parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys hhid parcel_id plot_id season : egen permax = max(perm_tree)
	bys hhid parcel_id plot_id season a5aq6e a5aq6e_1 a5bq6e a5bq6e_1 : gen plant_date_unique = _n
	*replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis SAW No Unknow planting dates
	bys hhid parcel_id plot_id season a5aq6e a5bq6e : gen harv_date_unique = _n // SAW harvest was all in the same year (2011)
	bys hhid parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys hhid parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (a4aq8 == 2 | a4bq8 == 2)
	bys hhid parcel_id plot_id season : egen mixed_max = max(mixed)
	/*replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 //JHG 1_14_22: 8 replacements, all of which report missing crop_code values. Should all missing crop_code values be dropped? If so, this should be done at an early stage.
	//I dropped the values after the latest merge above, and there were zero replacements for this line of code. No relay cropping?
	gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 */
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 SAW Should we assume null values are intercropped?  or maybe missing information??
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	*/
	bys hhid parcel_id plot_id season : gen n_crops=_N
	gen purestand=n_crops==1
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys hhid parcel_id plot_id season: egen total_percent = total(percent_field)
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	replace ha_planted = percent_field*field_size
	gen pct_harvest=1-(a5aq16/100)
	replace pct_harvest=1-(a5bq16/100) if pct_harvest==.
	gen ha_harvest=ha_planted*pct_harvest 
	
**********************************
** Crop Harvest Value **
**********************************
*SAW 6/27/23 Update Incorporating median price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors 
replace price_unit=. //Scrapping observed prices to fill in with geographic medians, using household median for the household level.
foreach i in  region district county county_name parish ea hhid {	
	merge m:1 `i' /*unit_code*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
	recode obs_`i' (.=0)
	replace price_unit= price_unit_`i' if obs_`i' > 9
}
	merge m:1 /*unit_code*/ crop_code using `price_unit_country_median', nogen keep(1 3)
	recode obs_country (.=0)
	replace price_unit=price_unit_country if obs_country > 9
	replace price_unit=price_unit_hhid if price_unit==.
	replace price_unit_hhid = price_unit if price_unit_hhid == .
gen value_harvest =price_unit*quant_harv_kg 
gen value_harvest_hh=price_unit_hhid*quant_harv_kg

preserve
	ren unit_code_harv unit
	collapse (mean) val_unit=price_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_for_wages.dta", replace
restore

*Combining Banana crops in one category, and coffee arabica and robusta into one coffee category. Update
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master

gen no_harvest = ha_harvest == .

collapse (sum) quant_harv_kg value_harvest ha_planted ha_harvest percent_field ///
         (max) use_imprv_seed no_harvest /*months_grown plant_date harv_date harv_end no_harvest*/ ///
         , by(region district county parish ea hhid parcel_id plot_id season crop_code purestand field_size)

recode ha_planted (0 = .)

replace ha_harvest = . if (ha_harvest == 0 & no_harvest == 1) | ///
                         (ha_harvest == 0 & quant_harv_kg > 0 & quant_harv_kg != .)

replace quant_harv_kg = . if quant_harv_kg == 0 & no_harvest == 1
replace value_harvest = . if value_harvest == 0 & no_harvest == 1

drop no_harvest
	bys hhid parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys hhid parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm*)
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace
	
	
********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************


********************************************************************************
** 								GROSS CROP REVENUE	 				  **
********************************************************************************
* This Gross Crop Revenue section is coded based on most updated version of Uganda Wave 3 which uses the Prices per kg Methodology with Standardized conversion factor tables.
*Temporary crops (both seasons)
use "${Uganda_NPS_W4_raw_data}/AGSEC5A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC5B.dta"
rename parcelID parcel_id
rename plotID plot_id
ren cropID crop_code 
drop HHID
ren hh hhid
drop if plot_id == . 
ren a5aq8 value_sold
replace value_sold = a5bq8 if value_sold == . 
recode value_sold (.=0)
ren a5aq7a qty_sold 
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 
gen sold_unit_code=a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using  "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 
*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = qty_sold*s_conv_factor_sold
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
collapse (sum) value_sold kgs_sold, by (hhid crop_code)
lab var value_sold "Value of sales of this crop"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropsales_value.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace
*ren crop_code_master crop_code
collapse (sum) value_harvest quant_harv_kg , by (hhid crop_code) 
merge 1:1 hhid crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropsales_value.dta"
recode value_harvest value_sold (.=0)
replace value_harvest = value_sold if value_sold>value_harvest & value_sold!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value_sold value_crop_sales 
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", replace

//Legacy code 
collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Uganda_NPS_W4_raw_data}/AGSEC5A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC5B.dta"
rename parcelID parcel_id
rename plotID plot_id
ren cropID crop_code 
drop HHID
ren hh hhid
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
drop if crop_code==.
rename a5aq16 percent_lost
replace percent_lost = a5bq16 if percent_lost==. & a5bq16!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
merge m:1 hhid crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_losses.dta", replace

********************************************************************************
** 								CROP EXPENSES								  **
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
	//Purpose: This section will develop indicators around inputs related to crops, such as labor (hired and family), pesticides/herbicides, animal power (not measured for Uganda), machinery/tools, fertilizer, land rent, and seeds. //JHG 5_3_22: edit this description later


*********************************
* 		 HIRED LABOR			*
*********************************

use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
drop HHID
ren hh hhid
ren plotID plot_id
ren parcelID parcel_id
ren a3aq35a dayshiredmale
replace dayshiredmale = a3bq35a if dayshiredmale == .
replace dayshiredmale = . if dayshiredmale == 0

ren a3aq35b dayshiredfemale
replace dayshiredfemale = a3bq35b if dayshiredfemale == .
replace dayshiredfemale = . if dayshiredfemale == 0
ren a3aq35c dayshiredchild
replace dayshiredchild = a3bq35c if dayshiredchild == .
replace dayshiredchild = . if dayshiredchild == 0	

ren a3aq36 wagehired
replace wagehired = a3bq36 if wagehired == .
gen wagehiredmale = wagehired if dayshiredmale != .
gen wagehiredfemale = wagehired if dayshiredfemale != .
gen wagehiredchild = wagehired if dayshiredchild != .
//
recode dayshired* (.=0)
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild 
replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal
replace wagehiredchild = wagehiredchild/dayshiredtotal

keep hhid parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

* 6.30.22 SAW We need to drop duplicates in order to conduct the following code reshape 6 observations droped
duplicates drop hhid parcel_id plot_id season, force
reshape long dayshired wagehired, i(hhid parcel_id plot_id season) j(gender) string
reshape long days wage, i(hhid parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0
/*replace wage = wage/number //ALT 08.16.21: The question is "How much did you pay in total per day to the hired <laborers>." For getting median wages for implicit values, we need the wage/person/day*/
* 6.30.22 SAW  "How much did you pay including the value of in-kind payments for these days of labor?" Not 100% sure this is the same as what is mentioned above. Maybe the variable wagehired is for total? Might want to check Uganda wages to see if it's payment per day per perosn or for the total number of days... 
gen val = wage*days
tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district county /*subcounty*/ parish ea hhid {
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
*SAW: I need to make whether we want to include children labor in our calculations.... (ethical reasons?) What is the standard? (include/not include?)

*********************************
* 		 FAMILY LABOR			*
*********************************
*SAW 1/3/23  I will do Family Labor based on the updates on Hired labor. 
*This section combines both seasons and renames variables to be more useful
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
drop HHID
ren hh hhid
ren plotID plot_id
ren parcelID parcel_id
rename a3aq33* indiv_* //indiv
rename indiv_*_* days_*
keep hhid parcel_id plot_id season indiv_* days_* /*days fam_worker_count*/

duplicates drop hhid parcel_id plot_id season, force // SAW 3 observations deleted 
reshape long indiv days, i(hhid parcel_id plot_id season) j(colid) string
drop if days == .
*tostring hhid, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
merge m:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen keep(1 3) 
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & female == 0
replace gender = "female" if strmatch(gender, "") & female == 1 
replace gender = "unknown" if strmatch(gender, "") & female == .
gen labor_type = "family"
drop if gender == "unknown"

merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county /*subcounty*/ parish ea hhid parcel_id plot_id season gender days labor_type /*fam_worker_count*/

gen wage=.
foreach i in region district county /*subcounty*/ parish ea /*hhid*/ { //skipping household-level wages to conform to crop_code. 
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
	replace wage=wage_`i' if wage==. & obs_`i' >9
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //JHG 5_12_22: 1,692 with missing vals b/c they don't have matches on pid, see code above
	replace wage=wage_country if wage==.

by hhid parcel_id plot_id season, sort: egen numworkers = count(_n)
replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days
append using `all_hired'
keep region district county /*subcounty*/ parish ea hhid parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(hhid parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (hhid parcel_id plot_id labor_type)
reshape wide labor_, i(hhid parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_days.dta", replace

restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(hhid parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor.dta", replace

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
drop if dm_gender2 == "" //JHG 5_18_22: 169 observations lost, due to missing values in both plot decision makers and gender of head of hh. Looked into it but couldn't find a way to fill these gaps, although I did minimize them.
reshape wide val*, i(hhid parcel_id plot_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_labor.dta", replace

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.

**********************    PESTICIDES/HERBICIDES   ******************************
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
drop HHID
ren hh hhid
ren plotID plot_id
ren parcelID parcel_id
ren a3aq24a unitpest //unit code for total pesticides used, first planting season (kg = 1, litres = 2)
ren a3aq24b qtypest //quantity of unit for total pesticides used, first planting season
replace unitpest = a3bq24a if unitpest == . //add second planting season
replace qtypest = a3bq24b if qtypest == . //add second planting season
ren a3aq26 qtypestexp //amount of total pesticide that is purchased
replace qtypestexp = a3bq26 if qtypestexp == . //add second planting season
gen qtypestimp = qtypest - qtypestexp //this calculates the non-purchased amount of pesticides used	
ren a3aq27 valpestexp
replace valpestexp = a3bq27 if valpestexp == .	
*********** SAW 7.1.22 Might want to fix future reshape
gen valpestimp= .
rename unitpest unitpestexp
gen unitpestimp = unitpestexp
drop qtypest

//JHG 6_14_22: barely any information collected on livestock inputs to crop agriculture. There are binary variables as to whether a house used their own livestock on their fields, but no collection of data about renting animal labor for a household. Some information (Section 11 in ag survey, question 5) about income from renting out their own animals is asked, but this is not pertinent to crop expenses. Animal labor can be a big expense, so we are creating explicit and implicit cost variables below but filling them with empty values.
gen qtyanmlexp = .
gen qtyanmlimp = .
gen unitanmlexp = .
gen unitanmlimp = .
gen valanmlexp = .
gen valanmlimp = .
tostring hhid, format(%18.0f) replace
tempfile pestherb
save `pestherb', replace
*************************    MACHINERY INPUTS   ********************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", clear

//JHG 6_14_22: Information was collected on machinery inputs for crop expenses in section 10, but was only done at the household level. Other inputs are at the plot level. Ask Didier about machinery that is owned.
preserve //This section creates raw data on value of machinery/tools
use "${Uganda_NPS_W4_raw_data}/AGSEC10.dta", clear
drop HHID
ren hh hhid
drop if  Farm_Implement == 2 //2 = no farm implement owned, rented, or used (separated by implement)
ren a10q1 qtymechimp //number of owned machinery/tools
ren a10q2 valmechimp //total value of owned machinery/tools, not per-item
ren a10q7 qtymechexp //number of rented machinery/tools
ren a10q8 valmechexp //total value of rented machinery/tools, not per-item
collapse (sum) valmechimp valmechexp, by(hhid) //combine values for all tools, don't combine quantities since there are many varying types of tools 
 //check for duplicate hhids, which there shouldn't be after the collapse
*tostring hhid, format(%18.0f) replace
tempfile rawmechexpense
save `rawmechexpense', replace
restore

collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
bys hhid : egen ha_planted_total = sum(ha_planted)
gen planted_percent = ha_planted/ha_planted_total
merge m:1 hhid using `rawmechexpense', nogen keep (1 3)
merge 1:m hhid parcel_id plot_id season using `pestherb', nogen keep (1 3)
replace valmechexp = valmechexp * planted_percent //replace total with plot and season specific value of rented machinery/tools

//Now to reshape long and get all the medians at once.
keep hhid parcel_id plot_id season qty* val* unit*
unab vars : *exp //create a local macro called vars out of every variable that ends with exp
local stubs : subinstr local vars "exp" "", all //create another local called stubs with exp at the end, with "exp" removed. This is for the reshape below
duplicates drop hhid parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
*rename qtypest qtypesticide
reshape long `stubs', i(hhid parcel_id plot_id season) j(exp) string
reshape long val qty unit, i(hhid parcel_id plot_id season exp) j(input) string
gen itemcode=1
tempfile plot_inputs
tostring hhid, format(%18.0f) replace

merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
save `plot_inputs'

******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
*SAW Using Josh Code as reference which uses Nigeria W3 Code.
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
drop HHID
ren hh hhid
ren plotID plot_id
ren parcelID parcel_id


* NEE 1/21/2024 referencing Ethiopia W5 - issue#442
	
********** Inorganic Fertilizer ********** 

// Nitrate
gen usefertexp1 = 1 if a3bq14 == 1 | a3bq14 == 1
gen qtyferttotal1 = a3bq15 if a3bq14 == 1
replace qtyferttotal1 = a3bq15 if qtyferttotal1 == . & a3bq14 == 1
gen unitfertexp1 = 1 if a3bq14 == 1 | a3bq14 == 1 // quantity in Kg 
gen qtyfertexp1 = a3aq17 if a3bq14 == 1 // purchased in Kg
replace qtyfertexp1 = a3bq17 if qtyfertexp1 == . & a3bq14 == 1
gen valfertexp1 = a3aq18 if a3bq14 == 1 // purchased in UShs
replace valfertexp1 = a3bq18 if valfertexp1 == . & a3bq14 == 1
gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1 // imputed Kg

// Phosphate
gen usefertexp2 = 1 if a3bq14 == 2 | a3bq14 == 2
gen qtyferttotal2 = a3bq15 if a3bq14 == 2
replace qtyferttotal2 = a3bq15 if qtyferttotal2 == . & a3bq14 == 2
gen unitfertexp2 = 1 if a3bq14 == 2 | a3bq14 == 2
gen qtyfertexp2 = a3aq17 if a3bq14 == 2
replace qtyfertexp2 = a3bq17 if qtyfertexp2 == . & a3bq14 == 2
gen valfertexp2 = a3aq18 if a3bq14 == 2
replace valfertexp2 = a3bq18 if valfertexp2 == . & a3bq14 == 2
gen qtyfertimp2 = qtyferttotal2 - qtyfertexp2

// Potash
gen usefertexp3 = 1 if a3bq14 == 3 | a3bq14 == 3
gen qtyferttotal3 = a3bq15 if a3bq14 == 3
replace qtyferttotal3 = a3bq15 if qtyferttotal3 == . & a3bq14 == 3
gen unitfertexp3 = 1 if a3bq14 == 3 | a3bq14 == 3
gen qtyfertexp3 = a3aq17 if a3bq14 == 3
replace qtyfertexp3 = a3bq17 if qtyfertexp3 == . & a3bq14 == 3
gen valfertexp3 = a3aq18 if a3bq14 == 3
replace valfertexp3 = a3bq18 if valfertexp3 == . & a3bq14 == 3
gen qtyfertimp3 = qtyferttotal3 - qtyfertexp3

// Mixed
gen usefertexp4 = 1 if a3bq14 == 4 | a3bq14 == 4
gen qtyferttotal4 = a3bq15 if a3bq14 == 4
replace qtyferttotal4 = a3bq15 if qtyferttotal4 == . & a3bq14 == 4
gen unitfertexp4 = 1 if a3bq14 == 4 | a3bq14 == 4
gen qtyfertexp4 = a3aq17 if a3bq14 == 4
replace qtyfertexp4 = a3bq17 if qtyfertexp4 == . & a3bq14 == 4
gen valfertexp4 = a3aq18 if a3bq14 == 4
replace valfertexp4 = a3bq18 if valfertexp4 == . & a3bq14 == 4
gen qtyfertimp4 = qtyferttotal4 - qtyfertexp4


********** Organic Fertilizer ********** 

// Organic fertilizer for two seasons
gen usefertexp5 = 1 if a3aq5 != . | a3bq5 != .
gen qtyfertexp5 = a3aq5 if a3aq5 != .
replace qtyfertexp5 = a3bq5 if qtyfertexp5 == . & a3bq5 != .
gen unitfertexp5 = 1 if a3aq5 != . | a3bq5 != .
gen valfertexp5 = a3aq8 if a3aq5 != .
replace valfertexp5 = a3bq8 if valfertexp5 == . & a3bq5 != .

********** Labels & Grouping ********** 

gen itemcode = .
replace itemcode = 1 if usefertexp1 == 1 // Nitrate 	- n_kg
replace itemcode = 2 if usefertexp2 == 1 // Phosphate 	- p_kg
replace itemcode = 3 if usefertexp3 == 1 // Potash		- k_kg
replace itemcode = 4 if usefertexp4 == 1 // Mixed
replace itemcode = 5 if usefertexp5 == 1 // Organic

label define itemcodefert 1 "Nitrate" 2 "Phosphate" 3 "Potash" 4 "Mixed" 5 "Organic"
label values itemcode itemcodefert

keep use* qty* unit* val* hhid parcel_id plot_id season
unab vars : *1
local stubs : subinstr local vars "1" "", all
display "`stubs'"
reshape long `stubs', i(hhid parcel_id plot_id season) j(itemcode)

unab vars2 : *exp*
local stubs2 : subinstr local vars2 "exp" "", all
display "`stubs2'"
reshape long `stubs2', i(hhid parcel_id plot_id season itemcode) j(exp) string 

reshape long use qty unit val, i(hhid parcel_id plot_id season itemcode exp) j(input) string
collapse (sum) qty* val*, by(hhid parcel_id plot_id season exp itemcode use)

gen input = ""
replace input = "inorg" if  itemcode>=1 & itemcode<=4 
replace input = "orgfert" if itemcode == 5 
/*
label define inputgroup 1 "inorg" 2 "orgfert" 
*label define inputgroup "inorg" = 1 "orgfert" = 2
*replace input = "inorg" if itemcode <= 4
*replace input = "orgfert" if itemcode == 5
replace input = 1 if itemcode <= 4 
replace input = 2 if itemcode == 5 
label values input inputgroup 


********** Clean-Up Data **********
drop if missing(itemcode)
drop if missing(exp)
drop if missing(input)
*duplicates drop hhid parcel_id plot_id season itemcode, force
recode qty (. = 0)
recode val (. = 0)
collapse (sum) qty val, by(hhid parcel_id plot_id season itemcode exp input)
*/

duplicates drop hhid parcel_id plot_id season itemcode, force
tempfile phys_inputs
save `phys_inputs'	

/*
************************    INORGANIC FERTILIZER   ****************************** 
//(all variables have "1" suffix) 7.1.22 SAW Not sure why the 1 suffix? might create trouble in the reshape code (if theres any)
ren a3aq14 itemcodefert //what type of inorganic fertilizer (1 = nitrate, 2 = phosphate, 3 = potash, 4 = mixed); this can be used for purchased and non-purchased amounts
replace itemcodefert = a3bq14 if itemcodefert == . //add second season
ren a3aq15 qtyferttotal1 //quantity of inorganic fertilizer used; thankfully, only measured in kgs
replace qtyferttotal1 = a3bq15 if qtyferttotal1 == . //add second season
ren a3aq17 qtyfertexp1 //quantity of purchased inorganic fertilizer used; only measured in kgs
replace qtyfertexp1 = a3bq17 if qtyfertexp1 == . //add second season
ren a3aq18 valfertexp1 //value of purchased inorganic fertilizer used, not all fertilizer
replace valfertexp1 = a3bq18 if valfertexp1 == . //add second season
gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1

*************************    ORGANIC FERTILIZER   *******************************
ren a3aq5 qtyferttotal2 //quantity of organic fertilizer used; only measured in kg
replace qtyferttotal2 = a3bq5 if qtyferttotal2 == . //add second season
ren a3aq7 qtyfertexp2 //quantity of purchased organic fertilizer used; only measured in kg
replace qtyfertexp2 = a3bq7 if qtyfertexp2 == . //add second season
replace itemcodefert = 5 if qtyferttotal2 != . //Current codes are 1-4; we'll add 5 as a temporary label for organic
label define fertcode 1 "Nitrate" 2 "Phosphate" 3 "Potash" 4 "Mixed" 5 "Organic" , modify //need to add new codes to the value label, fertcode
label values itemcodefert fertcode //apply organic label to itemcodefert
ren a3aq8 valfertexp2 //value of purchased organic fertilizer, not all fertilizer
replace valfertexp2 = a3bq8 if valfertexp2 == . //add second season 
gen qtyfertimp2 = qtyferttotal2 - qtyfertexp2
tostring hhid, format(%18.0f) replace
//JHG 6_15_22: no transportation costs are given; no subsidized fertilizer

//Clean-up data
keep item* qty* val* HHID parcel_id plot_id season
drop if itemcodefert == .
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates
drop dummya
duplicates drop hhid parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
unab vars : *2 
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(hhid parcel_id plot_id season) j(entry_no) string //JHG 6_15_22: Nigeria code had regional variables here (zone, state, etc.) but they aren't included in the raw data we used here for Uganda. We would need to append them in. Is that necessary? If so, apply to reshapes and collapse below also - don't need now, include later when calculating geographic medians
drop entry_no
drop if (qtyferttotal == . & qtyfertexp == .)
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
gen dummyc = sum(dummyb) //This process of creating dummies and summing them was done to create individual IDs for each row (can just use _n command, but we weren't aware at the time)
drop dummyb
reshape long `stubs2', i(hhid parcel_id plot_id season dummyc) j(exp) string
gen dummyd = sum(dummyc)
drop dummyc
reshape long qty val itemcode, i(hhid parcel_id plot_id season exp dummyd) j(input) string
recode qty val (. = 0)
collapse (sum) qty* val*, by(hhid parcel_id plot_id season exp input itemcode)
tempfile phys_inputs
save `phys_inputs'
*/

******************************************************************************
****************************     LAND RENTAL   ********************************** 
******************************************************************************
//Get parcel rent data
use "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta", clear
ren parcelID parcel_id
drop HHID
ren hh hhid
ren a2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", replace
merge m:1 hhid parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_rental.dta", nogen keep (3)
gen qtyparcelrentexp = parcel_ha if valparcelrentexp > 0 & valparcelrentexp != .
gen qtyparcelrentimp = parcel_ha if qtyparcelrentexp == . //this land does not have an agreement with owner, but is rented

//Estimate rented plot value, using percentage of parcel 
*JHG 6_15_22: had to add this section (relative to Nigeria code) as Uganda does not ask about rental at a plot level, just a parcel level
gen plot_percent = field_size / parcel_ha
gen valplotrentexp = plot_percent * valparcelrentexp
gen qtyplotrentexp = qtyparcelrentexp * plot_percent
gen qtyplotrentimp = qtyparcelrentimp * plot_percent //quantity of "imp" land is that which is not rented

//Clean-up data
keep hhid parcel_id plot_id season valparcelrent* qtyparcelrent* valplotrent* qtyplotrent* 

	preserve //this section creates a variable, duplicate, which can tell if a plot was rented over two seasons. This way, rent is disaggregated by plot and by season.
	collapse (sum) plot_id, by(hhid parcel_id season)
	duplicates tag hhid parcel_id, generate(duplicate) 
	drop plot_id
	collapse (max) duplicate, by(hhid parcel_id)
	tempfile parcel_rent
	save `parcel_rent'
	restore

merge m:1 hhid parcel_id using `parcel_rent', nogen 
sort hhid parcel_id plot_id
reshape long valparcelrent qtyparcelrent valplotrent qtyplotrent, i(hhid parcel_id plot_id season) j(exp) string
reshape long val qty, i(hhid parcel_id plot_id season exp) j(input) string
gen valseason = val / 2 if duplicate == 1
drop duplicate
gen unit = 1 //dummy var
gen itemcode = 1 //dummy var
tempfile plotrents
save `plotrents'

******************************************************************************
****************************    SEEDS   ********************************** 
******************************************************************************
//Clean up raw data and generate initial estimates	
use "${Uganda_NPS_W4_raw_data}/AGSEC4A.dta", clear
gen season=1 
append using "${Uganda_NPS_W4_raw_data}/AGSEC4B.dta"
replace season=2 if season==.
drop HHID
ren hh hhid
rename plotID plot_id
rename parcelID parcel_id
ren cropID crop_code
ren a4aq8 purestand 
replace purestand = a4bq8 if purestand==.
ren a4aq11a qtyseeds //includes all types of seeds (purchased, left-over, free, etc.)
replace qtyseeds = a4bq11a if qtyseeds == . //add second season
ren a4aq11b unitseeds //includes all types of seeds (purchased, left-over, free, etc.)
replace unitseeds = a4bq11b if unitseeds == . //add second season
ren a4aq15	valseeds //only value for purchased seeds. There is no quantity for purchased seeds, so one cannot calculate per kg value of seeds.
replace valseeds = a4bq15 if valseeds == . //add second season

keep unit* qty* val* purestand hhid parcel_id plot_id crop_code season
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates, similar process as above for fertilizers
drop dummya
reshape long qty unit val, i(hhid parcel_id plot_id season dummyb) j(input) string
collapse (sum) val qty, by(hhid parcel_id plot_id season unit input crop_code purestand)
ren unit unit_code
drop if qty == 0
*drop input //there is only purchased value, none of it is implicit (free, left over, etc.)

//Convert quantities into kilograms
replace qty = qty * 2 if unit_code == 40 //Basket (2kgs):   
replace qty = qty * 120 if unit_code == 9 //Sack (120kgs):  
replace qty = qty * 20 if unit_code == 37 //Basket (20kgs):   
replace qty = qty * 10 if unit_code == 38 //Basket (10kgs):  
replace qty = qty / 1000 if unit_code == 2 //Gram:  
replace qty = qty * 5 if unit_code == 39 //Basket (5kgs):  
replace qty = qty * 100 if unit_code == 10 //Sack (100kgs): 
replace qty = qty * 80 if unit_code == 11 //Sack (80kgs):  
replace qty = qty * 50 if unit_code == 12 //Sack (50kgs):  
replace qty = qty * 2 if unit_code == 29 //Kimbo/Cowboy/Blueband Tin (2kgs): 
replace qty = qty * 0.5 if unit_code == 31 //Kimbo/Cowboy/Blueband Tin (0.5kgs): 477 
replace unit_code = 1 if inlist(unit_code, 2, 9, 10, 11, 12, 29, 31, 37, 38, 39, 40) //label them as kgs now	
*SAW What should we do with Tin (20 and 5 lts) and plastic bins (15lts), assume 1lt = 1kg? 
//replace qty = qty * 20 if unit_code == 20 //Tin (20lts):
//replace qty = qty * 5 if unit_code == 21 //Tin (5kgs):  
//replace qty = qty * 15 if unit_code == 22 //Plastic Bin (15 lts):  

//JHG 6_27_22: no conversion factors (or even units for the last two) for Tin (20 lts) [1.94%] {code is 20}, Tin (5 lts) [0.34%] {code is 21}, Plastic basin (15 lts) [5.53%] {code is 22}, Bundle (6.7%) {code is 66}, Number of Units (General) [1.04%] {code is 85}, or Other Units (Specify) [4.16%] {code is 99}. This means a total of 19.71% of observations cannot be converted into kilograms. We can't use conversion factors from crops as seeds have different densities. Need input on what to do with these remaining conversions

//JHG 6_27_22: Unsure of what to do with this section of code, so it is commented out. It seems to mark bundles and pieces (Nigerian units) and just have a special variable for them. There are bundles in Ugandan units as well but they are likely not the same. Perhaps this is how I can treat the unconvertible amounts. I don't have a conversion variable though. I made my owne version below
*gen unit = 1 if inlist(unit_cd,160,161,162,80,81,82) //pieces
*replace unit = 2 if unit == . //Weight, meaningless for transportation
*replace unit = 0 if conversion == . //useless for price calculations
gen unit = 1 if unit_code == 1
replace unit = 2 if unit == .
replace unit = 0 if inlist(unit_code, 20, 21, 22, 66, 85, 99) //the units above that could not be converted will not be useful for price calculations

ren crop_code itemcode
collapse (sum) val qty, by(hhid parcel_id plot_id season input itemcode unit) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for. JHG 7_5_22: all this code does is drop variables, it doesn't actually collapse anything
gen exp = "exp"

//Combining and getting prices.
append using `plotrents'
*tostring hhid, format(%18.0f) replace
append using `plot_inputs'
*destring HHID, replace
append using `phys_inputs'
*tostring hhid, format(%18.0f) replace
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3) keepusing(weight)

*destring HHID, replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)

*tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)

drop region sregion district county county_name parish parish_name ea weight rural
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)

tempfile all_plot_inputs
save `all_plot_inputs' //Woo, now we can estimate values.

//Calculating geographic medians
keep if strmatch(exp,"exp") & qty != . //Keep only explicit prices with actual values for quantity
recode val (0 = .)
drop if unit == 0 //Remove things with unknown units.
gen price = val/qty
drop if price == . //6,246 observations now remaining
gen obs = 1
gen plotweight = weight*field_size

*drop rural plotweight parish subcounty district
foreach i in region /*sregion*/ district county parish ea hhid {
preserve
	bys `i' input unit itemcode : egen obs_`i' = sum(obs)
	collapse (median) price_`i' = price [aw = plotweight], by (`i' input unit itemcode obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
} //this loop generates a temporary file for prices at the different geographic levels specified in the first line of the loop (region, district, etc.)

preserve
bysort input unit itemcode : egen obs_country = sum(obs)
collapse (median) price_country = price [aw = plotweight], by(input unit itemcode obs_country)
tempfile price_country_median
save `price_country_median'
restore

//Combine all price information into one variable, using household level prices where available in enough quantities but replacing with the medians from larger and larger geographic areas to fill in gaps, up to the national level
use `all_plot_inputs', clear
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
*drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district county parish ea hhid {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_hhid (. = 0)
	gen price = price_hhid
foreach i in country region district county parish ea {
	replace price = price_`i' if obs_`i' > 9 & obs_`i' != .
}

replace price = price_hhid if price_hhid > 0
replace qty = 0 if qty < 0 //2 households reporting negative quantities
recode val qty (. = 0)
drop if val == 0 & qty == 0 //Dropping unnecessary observations.
replace val = qty*price if val == 0 //11,258 estimates created
replace input = "orgfert" if itemcode == 5
replace input = "inorg" if strmatch(input,"fert")

//Need this for quantities and not sure where it should go.
preserve 
keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"pest") //would also have herbicide here if Uganda tracked herbicide separately of pesticides

		gen n_kg =qty*itemcode==1
		gen p_kg = qty*itemcode==2
		gen k_kg = qty*itemcode==3
		gen pest_kg = qty*strmatch(input, "pest")
		gen inorg_fert_kg = qty*strmatch(input, "inorg")
		gen org_fert_kg = qty if itemcode >=5 & itemcode!=.
		collapse (sum) qty (sum) *kg, by(hhid parcel_id plot_id season input)
		//reshape wide *kg, i(hhid parcel_id plot_id season) j(input) string
		la var inorg_fert_kg "Kg inorganic fertilizer used"
		la var org_fert_kg "Kg organic fertilizer used"
		la var n_kg "Kg of nitrogen applied"
		la var p_kg "Kg of phosphorus applied"
		la var k_kg "Kg of potassium applied"	

/*
collapse (sum) qty_ = qty, by(hhid parcel_id plot_id season input)
reshape wide qty_, i(hhid parcel_id plot_id season) j(input) string
ren qty_inorg inorg_fert_rate
ren qty_orgfert org_fert_rate
ren qty_pest pest_rate
la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
la var org_fert_rate "Qty organic fertilizer used (kg)"
la var pest_rate "Qty of pesticide used (kg)"
*/

save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_quantities.dta", replace 
restore

append using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor.dta"

collapse (sum) val, by (hhid parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", replace 

preserve
collapse (sum) val, by(hhid exp input) //JHG 7_5_22: includes both seasons, is that okay?
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_inputs_long.dta", replace 

restore

preserve
collapse (sum) val_ = val, by(hhid parcel_id plot_id season exp dm_gender)
reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs.dta", replace //This gets used below.
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
collapse (sum) val*, by(hhid)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}
egen val_exp_hh = rowtotal(*_exp_hh)
egen val_imp_hh = rowtotal(*_imp_hh)
drop val_mech_imp* // JHG 7_5_22: need to revisit owned machinery values, I don't think that was ever dealt with.
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_inputs_verbose.dta", replace 

//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 

collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", clear

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
*destring HHID, replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time

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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_inputs.dta", replace 

********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************
*Purpose: Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots

//Setting things up for AgQuery first
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
keep if purestand == 1 //1 = monocropped
ren crop_code cropcode
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_monocrop_plots.dta", replace 

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
keep if purestand == 1 //1 = monocropped //File now has 6801 unique entries - it should be noted that some these were grown in mixed plots.

*merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
ren crop_code cropcode
ren ha_planted monocrop_ha
ren quant_harv_kg kgs_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
ren value_harvest val_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
*This loop creates 17 values using the nb_topcrops global (as that is the number of priority crops), then generates two .dtas for each priority crop that contains household level variables (split by season). You can change which priority crops it uses by adjusting the priority crops global section near the top of this code.
forvalues k = 1(1)$nb_topcrops  {		
preserve	
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
local cn_full : word `k' of $topcropname_area_full

keep if cropcode == `c'			
ren monocrop_ha `cn'_monocrop_ha
drop if `cn'_monocrop_ha == 0 | `cn'_monocrop_ha==. 		
ren kgs_harv_mono kgs_harv_mono_`cn'
ren val_harv_mono val_harv_mono_`cn'
gen `cn'_monocrop = 1
la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_`cn'_monocrop.dta", replace

	
foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
gen `i'_male = `i' if dm_gender == 1
gen `i'_female = `i' if dm_gender == 2
gen `i'_mixed = `i' if dm_gender == 3
}

gen dm_male = dm_gender==1 
gen dm_female = dm_gender==2
gen dm_mixed = dm_gender==3

la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
la var `cn'_monocrop "Household has at least one `cn' monocrop"
la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
la var val_harv_mono_`cn' "Value of harvested `cn' (UGSH)"
foreach g in male female mixed {		
la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
}

collapse (sum) *monocrop* kgs_harv* val_harv* (max) dm*, by(hhid /*season*/)

foreach i in kgs_harv_mono_`cn' val_harv_mono_`cn' {
foreach j in male female mixed {
replace `i'_`j' = . if dm_`j'==0
}
}
recode `cn'_monocrop_ha* (0=.)
drop dm*

save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_`cn'_monocrop_hh_area.dta", replace
restore
}

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", clear

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
	merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_inputs_`cn'.dta", replace
restore
}
*use "${UGS_W3_created_data}/Uganda_NPS_W3_inputs_cassav.dta", replace // SAW 1.5.23 Checking how the new datasets look like
*Notes: Final datasets are sum of all cost at the household level for specific crops. 

********************************************************************************
**                     TLU (TROPICAL LIVESTOCK UNITS)       				  **
********************************************************************************
/*
Purpose: 
1. Generate coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kg of meat) [JHG 12_30_21: double-check the units after recoding].

2. Generate variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc. Convert into TLUs

3. Grab information on livestock sold alive and calculate total value.
*/


***************************    TLU COEFFICENTS   *******************************
//Step 1: Create three TLU coefficient .dta files for later use, stripped of HHIDs

*For livestock
use "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta", clear
rename LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, largerum, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta", clear
rename ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta", clear
rename APCode livestockid
gen tlu_coefficient = 0.01 if (livestockid == 23 | livestockid == 24 | livestockid == 25 | livestockid == 26 | livestockid == 27) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_poultry_misc.dta", replace
*NOTES:  SAW: There's an additional categoty of beehives (==28) that we are not currently adding to any tlu_coefficient. Did not find it in another survey.

*Combine 3 TLU .dtas into a single .dta
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_livestock.dta", clear
append using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_small_animals.dta"
append using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_poultry_misc.dta"
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - largerum" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - largerum" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid //JHG 12_30_21: have to reassign labels to values after append (possibly unnecessary since this is an intermediate step, don't delete code though because it is necessary)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_all_animals.dta", replace

**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta"
append using "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta"
drop HHID
ren hh hhid
gen livestockid = LiveStockID
replace livestockid = ALiveStock_Small_ID if livestockid==.
replace livestockid = APCode if livestockid==.
merge m:1 livestockid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
*sort HHID livestockid //Put back in order

*Generate ownership dummy variables for livestock categories: cattle (& largerum alone), small ruminants, poultry (& chickens alone), & other
gen cattle = inrange(livestockid, 1, 10) //calves, bulls, oxen, heifer, and largerum
gen cows = inlist(livestockid, 5, 10) //just cows
gen largerum = inlist(livestockid, 5, 10) //just largerum
gen smallrum = inlist(livestockid, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 27) //goats, sheep, pigs, and rabbits
gen poultry = inrange(livestockid, 23, 26) //chicken, turkey, ducks, and geese
gen chickens = inrange(livestockid, 23, 25) //just chicken (all kinds)
gen otherlivestock = inlist(livestockid, 11, 12) //donkeys/mules and horses

*Generate "number of animals" variable per livestock category and household (Time of Survey)
rename a6aq2 ls_ownership_today
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
rename a6bq2 sa_ownership_today
drop if sa_ownership == 2 //2 = see above
rename a6cq2 po_ownership_today
drop if po_ownership == 2 //2 = see above

rename a6aq3a ls_number_today
rename a6bq3a sa_number_today
rename a6cq3a po_number_today 
gen livestock_number_today = ls_number_today
replace livestock_number_today = sa_number_today if livestock_number_today == .
replace livestock_number_today = po_number_today if livestock_number_today == .
lab var livestock_number_today "Number of animals owned at time of survey (see livestockid for type)"

foreach i in cattle largerum smallrum poultry chickens otherlivestock  {
gen nb_`i'_today = livestock_number_today if `i'==1
}
gen nb_tlu_today = livestock_number_today * tlu_coefficient
gen nb_cows_today = livestock_number_today if cows == 1

*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
rename a6aq6 ls_number_past
rename a6bq6 sa_number_past
rename a6cq6 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)" 
*SAW 7.5.22 Though, a6Xq6 refers to different types of animals the time of ownership asked in each question is different (12 months for livestock, 6 months for small animals, and 3 motnhs for poultry)

foreach i in cattle largerum smallrum poultry chickens otherlivestock  {
gen nb_`i'_past = livestock_number_past if `i'==1
}
gen nb_tlu_past = livestock_number_past * tlu_coefficient
gen nb_cows_past = livestock_number_past if cows == 1

//Step 3: Generate animal sales variables (sold alive)
rename a6aq14b ls_avgvalue
rename a6bq14b sa_avgvalue
rename a6cq14b po_avgvalue
rename a6aq14a nb_ls_sold
rename a6bq14a nb_sa_sold
rename a6cq14a nb_po_sold

gen nb_totalvalue = ls_avgvalue * nb_ls_sold
replace nb_totalvalue = sa_avgvalue * nb_sa_sold if nb_totalvalue == .
replace nb_totalvalue = po_avgvalue * nb_po_sold if nb_totalvalue == .

recode nb_* (. = 0) //replace all null values for number variables with 0

//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) nb*, by (hhid)
foreach i in ls sa po {
lab var nb_`i'_sold "Number of animals sold alive (`i')"
}
rename nb_otherlivestock_today nb_other_today
rename nb_otherlivestock_past nb_other_past
foreach i in cattle largerum smallrum poultry chickens other tlu {
lab var nb_`i'_today "Number of `i' owned at time of survey"
lab var nb_`i'_past "Number of `i' (donkeys/mules & horses) owned 12 months before survey"
}
lab var nb_totalvalue "Total value of animals sold alive"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU_Coefficients.dta", replace

********************************************************************************
**                           LIVESTOCK INCOME       		         		  **
********************************************************************************
*SAW 7.5.22 We will use Nigeria Wave 3 as reference to write this section. This section was previously written in older version of Uganda W3 with different format.

use "${Uganda_NPS_W4_raw_data}/AGSEC7.dta", clear
*append using "${Uganda_NPS_W4_raw_data}/AGSEC7B.dta"
drop HHID
ren hh hhid
rename a7bq2e cost_fodder_livestock
rename a7bq3f cost_water_livestock
rename a7bq5d cost_vaccines_livestock
rename a7bq6c cost_deworm_livestock
rename a7bq7c cost_ticks_livestock
rename a7bq8c cost_hired_labor_livestock
collapse (sum) cost*, by(hhid)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_expenses.dta", replace
reshape long cost_, i(hhid) j(input) string
rename cost_ val_total
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_expenses_long.dta", replace // SAW In case is needed for AgQuery

*****************************    LIVESTOCK PRODUCTS        *******************************
*1. Milk
/*SW: 8/21/23 The Questionnaire is different than Uganda wave 3, therefore the indicators might be hard to compare over time. 
For example: (1) Earning sales are reported as total from milk and dairy sold - in contrast to wave 3 that earnings are from milk only.
-Not sure if we can compute price per unit or liters, since it incorporates dairy and liters of milk sold. (Should we add liters of milk and dairy sold to compute price per unit?)
This section needs to be reviewed and sorted out how to proceed. 
SW: Decided to use Uganda wave 7 as reference since the questionnaires are similar in contrast to wave 3. 
We still need to figure out the unit of some variables that might be reported as (liters/days) in the questionnaire but might be liters/year). This will substantially change results.
*/
use "${Uganda_NPS_W4_raw_data}/AGSEC8B.dta", clear
drop HHID
ren hh hhid
rename AGroup_ID livestock_code
gen livestock_code2="1. Milk"
keep if livestock_code==101 | livestock_code==102 //Exotic+Indigenous large ruminants. Leaving out small ruminants because small ruminant milk accounts only for 0.04% of total production, and there's no price information
ren a8bq1 animals_milked
gen months_milked = a8bq2 // Need review: In contrast to wave 3 that asked how many days in the year livestock were milked , wave 4 asked how many months in the year livestock were milked.
rename a8bq3 liters_perday
recode animals_milked months_milked liters_perday (.=0)
gen milk_liters_produced = animals_milked*liters_perday*months_milked*30.5
lab var milk_liters_produced "Liters of milk produced in past 12 months"
gen liters_sold_per_day = a8bq5_1
gen liters_sold_per_year = a8bq5_1*30.5*a8bq2 //SW: The question asks how many liters did you sell per day (liters/days). Earning sales are reported 
ren a8bq6 liters_perday_to_cheese 
ren a8bq9 earnings_per_day_milk

recode liters_sold_per_day liters_perday_to_cheese (.=0)
gen liters_sold_day = liters_sold_per_day + liters_perday_to_cheese 
gen price_per_liter = earnings_per_day_milk / liters_sold_day
gen price_per_unit = price_per_liter
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
gen earnings_sales = earnings_per_day_milk*months_milked*30		
keep hhid livestock_code livestock_code2 milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_sales
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_sales "Total earnings of sale of milk produced"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_milk.dta", replace 

*2. Eggs
use "${Uganda_NPS_W4_raw_data}/AGSEC8C.dta", clear
drop HHID
ren hh hhid
ren AGroup_ID livestock_code 
rename a8cq1 months_produced
rename a8cq2 quantity_month
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month // Units are pieces for eggs & skin, liters for honey. SW: Uganda wave 3 is quantity_month*4 why?
lab var quantity_produced "Quantity of this product produed in past year"
rename a8cq3 sales_quantity
rename a8cq5 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of egg per unit sold"
lab var price_per_unit_hh "Price of egg per unit sold at household level"
gen livestock_code2 = "2. Eggs"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_other.dta", replace 

*We append the 3 subsection of livestock earnings
append using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_milk.dta"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", keep(1 3) nogen

collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code) //Nigeria also uses by quantity_sol_season_unit but UGanda does not have that information, though units should be the same within livestock_code2 (product type). Also, we could include by livestock_code (type of animal)
ren price_per_unit price_unit_median_country
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_country.dta", replace 
*SAW Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 
merge m:1 livestock_code2 livestock_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_country.dta", nogen keep(1 3) //SAW We have an issue with price units for some types of meat products and specific animal tpye. I assign those price_unit values for the missing based on similar types of animals with information.
keep if quantity_produced!=0
gen value_produced = price_per_unit * quantity_produced 
replace value_produced = price_unit_median_country * quantity_produced if value_produced==.
*replace value_produced = value_produced*4 if livestock_code2=="2. Eggs" // SAW Like we said earlier, eggs sales is for the past 3 months we need to extrapolate for the whole year.
lab var price_unit_median_country "Price per liter (milk) or per egg/liter/container honey or palm wine, imputed with local median prices if household did not sell"
gen value_milk_produced = price_per_unit * quantity_produced if livestock_code2=="1. Milk"
replace value_milk_produced = quantity_produced * price_unit_median_country if livestock_code2=="1. Milk" & value_milk_produced==.
gen value_eggs_produced = price_per_unit * quantity_produced if livestock_code2=="2. Eggs"
replace value_eggs_produced = quantity_produced * price_unit_median_country if livestock_code2=="2. Eggs" & value_eggs_produced==.

*Share of total production sold
gen sales_livestock_products = earnings_sales	
/*Agquery 12.01*/
//No way to limit this to just cows and chickens b/c the actual livestock code is missing.
gen sales_milk = earnings_sales if livestock_code2=="1. Milk"
gen sales_eggs = earnings_sales if livestock_code2=="2. Eggs"
*gen sales_meat = earnings_sales if livestock_code2=="3. Meat"
collapse (sum) value_milk_produced value_eggs_produced /*value_meat_produced*/ sales_livestock_products /*agquery*/ sales_milk sales_eggs /*sales_meat*/, by (hhid)
*Share of production sold
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced /*value_meat_produced*/)
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced // There;s some issues with some values>1 - the milk dataset does not make a lot of sense.
gen prop_eggs_sold = sales_eggs / value_eggs_produced
*gen prop_meat_sold = sales_meat / value_meat_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
*lab var value_meat_produced "Value of meat produced"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 

*****************************    LIVESTOCK SOLD (LIVE)       *******************************
use "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta", clear
append using  "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta"
append using  "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta"
//Making sure value labels for 6B and 6C get carried over. Just in case.
rename HHID hhid2
ren hh hhid
label define LiveStockID 13 "Exotic/Cross - Male Goats"/*
						*/ 14 "Exotic/Cross - Female Goats"/*
						*/ 15 "Exotic/Cross - Male Sheep"/*
						*/ 16 "Exotic/Cross - Female Sheep"/*
						*/ 17 "Exotic/Cross - Pigs"/*
						*/ 18 "Indigenous - Male Goats"/*
						*/ 19 "Indigenous - Female Goats"/*
						*/ 20 "Indigenous - Male Sheep"/*
						*/ 21 "Indigenous - Female Sheep"/*
						*/ 22 "Indigenous - Pigs"/*
						*/ 23 "Indigenous dual-purpose chicken"/*
						*/ 24 "Layers (exotic/cross chicken)"/*
						*/ 25 "Broilers (exotic/cross chicken)"/*
						*/ 26 "Other poultry and birds (turkeys/ducks/geese)"/*
						*/ 27 "Rabbits"/*
						*/ 28 "Beehives", add
replace LiveStockID = ALiveStock_Small_ID if LiveStockID==.
replace LiveStockID = APCode if LiveStockID==.
ren LiveStockID livestock_code

ren a6aq2 animal_owned // Have you owned in the past 12 months?
replace animal_owned=a6bq2 if animal_owned==. // Have you owned in the past 6 months?
replace animal_owned=a6cq2 if animal_owned==. // Have you owned in the past 3 months?
keep if animal_owned==1
ren a6aq14a number_sold // a6aq14a a6bq14a a6cq14a
replace number_sold = 2*a6bq14a if number_sold==. & a6bq14a!=. // SW Should it just be multiplied by 1? The selling number is for the past 12 months just like a6aq14a
replace number_sold = 4*a6cq14a if number_sold==. & a6cq14a!=.
ren a6aq14b value_sold
replace value_sold=a6bq14b if value_sold==.
replace value_sold=a6cq14b if value_sold==.
gen income_live_sales = value_sold*number_sold //total sales value of all sold

ren a6aq15 number_slaughtered
replace number_slaughtered = 2*a6bq15 if number_slaughtered==. & a6bq15!=.
replace number_slaughtered = 4*a6cq15 if number_slaughtered==. & a6cq15!=.

ren a6aq13a number_livestock_purchases
replace number_livestock_purchases = 2*a6bq13a if number_livestock_purchases==.
replace number_livestock_purchases = 4*a6cq13a if number_livestock_purchases==.

ren a6aq13b price_livestock
replace price_livestock = a6bq13b if price_livestock==.
replace price_livestock = a6cq13b if price_livestock==.

gen value_livestock_purchases = number_livestock_purchases*price_livestock
recode number_sold income_live_sales number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = value_sold
lab var price_per_animal "Price of live animal sold" //ALT: Not sure why we wouldn't include prices of animals bought also
recode price_per_animal (0=.)
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //106 missing from master
keep hhid region sregion rural weight district county county_name parish parish_name ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_livestock_sales.dta", replace


*Implicit prices (shorter)
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_livestock_sales.dta", clear
gen obs = 1
foreach i in region district county /*subcounty*/ parish ea {
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

foreach i in region district county /*subcounty*/ parish ea country {
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_sales.dta", replace

********************************************************************************
**                                 TLU    		         	         	      **
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta", clear
append using  "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta"
append using  "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta"
//Making sure value labels for 6B and 6C get carried over. Just in case.
rename HHID hhid2
ren hh hhid
label define LiveStockID 13 "Exotic/Cross - Male Goats"/*
						*/ 14 "Exotic/Cross - Female Goats"/*
						*/ 15 "Exotic/Cross - Male Sheep"/*
						*/ 16 "Exotic/Cross - Female Sheep"/*
						*/ 17 "Exotic/Cross - Pigs"/*
						*/ 18 "Indigenous - Male Goats"/*
						*/ 19 "Indigenous - Female Goats"/*
						*/ 20 "Indigenous - Male Sheep"/*
						*/ 21 "Indigenous - Female Sheep"/*
						*/ 22 "Indigenous - Pigs"/*
						*/ 23 "Indigenous dual-purpose chicken"/*
						*/ 24 "Layers (exotic/cross chicken)"/*
						*/ 25 "Broilers (exotic/cross chicken)"/*
						*/ 26 "Other poultry and birds (turkeys/ducks/geese)"/*
						*/ 27 "Rabbits"/*
						*/ 28 "Beehives", add
replace LiveStockID = ALiveStock_Small_ID if LiveStockID==.
replace LiveStockID = APCode if LiveStockID==.
ren LiveStockID livestock_code
ren a6aq2 animal_owned
replace animal_owned=a6bq2 if animal_owned==.
replace animal_owned=a6cq2 if animal_owned==.
gen tlu_coefficient =  0.5 if inrange(livestock_code, 1, 10) //Bulls and oxen, calves, heifer and largerum
replace tlu_coefficient = 0.55 if livestock_code==12 //mules/horses; average of the two (horses = 0.5 and mules = 0.6)
replace tlu_coefficient = 0.3 if livestock_code==11 //donkeys
replace tlu_coefficient = 0.2 if livestock_code==17 | livestock_code==22 //pigs
replace tlu_coefficient = 0.1 if inrange(livestock_code, 13,16) | inrange(livestock_code, 18,21) //female & male goats & sheep
replace tlu_coefficient = 0.01 if inrange(livestock_code, 23,27) //rabbits, ducks, turkeys 
//geese and other birds, backyard chicken, parent stock for broilers, parents stock for layers, layers, pullet chicks, growers, broilers; beehives not included
//ALT: Changed from 0.1 to 0.01, assuming 0.1 is a coding error
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

gen number_1yearago = a6aq6
replace number_1yearago = a6bq6 if number_1yearago==.
replace number_1yearago = a6cq6 if number_1yearago==. 
gen number_today_all= a6aq3a
replace number_today_all = a6bq3a if number_today_all==. 
replace number_today_all = a6bq3a if number_today_all==. //No estimated price value by farmers questions or owned  at the start of the ag season like Nigeria_GHS_W3_raw_data
gen number_today_exotic = number_today_all if inlist(livestock_code,1,2,3,4,5,13,14,15,16,17)
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_all * tlu_coefficient
gen income_live_sales = a6aq14b // Value of each animal sold on average
replace income_live_sales = a6bq14b*1 if income_live_sales==. & a6bq14b!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace income_live_sales = a6cq14b*1 if income_live_sales==. & a6cq14b!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months

gen number_sold = a6aq14a
replace number_sold = a6bq14a if number_sold==. & a6bq14a!=. //Annual
replace number_sold = a6cq14a*4 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months


gen lost_theft = a6aq10
replace lost_theft = a6bq10*2 if lost_theft==. & a6bq10!=.
replace lost_theft = a6cq10*4 if lost_theft==. & a6cq10!=.
gen lost_other = a6aq11 // animals lost to injury/accident/naturalcalamity 
replace lost_other = a6bq11*2 if lost_other==. & a6bq11!=.
replace lost_other = a6cq11*4 if lost_other==. & a6cq11!=.
gen lost_disease = a6aq12 //includes animals lost to disease
replace lost_disease = a6bq12*2 if lost_disease==. & a6bq12!=. 
replace lost_disease = a6cq12*4 if lost_disease==. & a6cq12!=.
gen animals_lost = lost_theft + lost_other + lost_disease //includes animals died or lost due to theft,injury accident natural calamity and disease


gen species = "lrum" if inlist(livestock_code,1,2,3,4,5,6,7,8,9,10)
replace species = "srum" if inlist(livestock_code,13,14,15,16,18,19,20,21)
replace species = "pigs" if inlist(livestock_code,17,22)
replace species = "equine" if inlist(livestock_code,11,12)
replace species = "poultry" if inlist(livestock_code,23,24,25,26)
drop if strmatch(species,"") //Omitting fish and rabbits; might be better to include these (not a large number of hh's, though)
rename income_live_sales price_per_animal // The variable it is already per animal sold units
recode price_per_animal (0=.)

merge m:1 livestock_code using `livestock_prices_country', nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //106 missing from master
foreach i in region district county /*subcounty*/ parish ea {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

gen value_today = number_today_all * price_per_animal
gen value_1yearago = number_1yearago * price_per_animal
collapse (sum) number_today_all number_today_exotic number_1yearago lost_theft lost_other lost_disease animals_lost lvstck_holding=number_today_all value* tlu*, by(hhid species)
egen mean_12months=rowmean(number_today_all number_1yearago)
gen 	animals_lost12months	= animals_lost	
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_herd_characteristics_long.dta", replace //AgQuery

preserve
keep hhid species number_today_exotic number_today_all animals_lost12months number_1yearago /*animals_lost*/ lost_disease lost_other lost_theft  lvstck_holding mean_12months
global lvstck_vars number_today_all number_today_exotic animals_lost12months number_1yearago lost_other lost_theft lost_disease lvstck_holding mean_12months
foreach i in $lvstck_vars {
	ren `i' `i'_
}
reshape wide $lvstck_vars, i(hhid) j(species) string
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_herd_characteristics.dta", replace 
restore 
preserve 
gen any_imp_herd = number_today_exotic != 0 if number_today_all != . & number_today_all != 0


foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease {
	gen `i'_lrum = `i' if species=="lrum"
	gen `i'_srum = `i' if species=="srum"
	gen `i'_pigs = `i' if species=="pigs"
	gen `i'_equine = `i' if species=="equine"
	gen `i'_poultry = `i' if species=="poultry"
}
collapse (sum)  mean_12months lvstck_holding animals_lost12months number_today_all number_today_exotic lost_disease (firstnm) *lrum *srum *pigs *equine *poultry any_imp_herd, by(hhid)
la var lvstck_holding "Total number of livestock holdings (# of animals)"
la var any_imp_herd "At least one improved animal in herd"
*la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
lab var animals_lost12months  "Total number of livestock  lost to disease or injury"
lab var  mean_12months  "Average number of livestock  today and 1  year ago"
lab var lost_disease "Total number of livestock lost to disease"
restore

collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of one year ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU.dta", replace 

********************************************************************************
**                                 FISH INCOME    		         	          **
********************************************************************************
* No Fish Income data collected in Uganda w4. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
//Purpose: This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. This includes profit from business... SAW Check for other sources of self-employment income
*Generate profit from business activities (revenue net of operating costs)
use "${Uganda_NPS_W4_raw_data}/gsec12.dta", clear
*use "${Uganda_NPS_W4_raw_data}/GSEC12_1.dta", clear
ren h12q12 months_activ // how many months did the business operate
ren h12q13 monthly_revenue //  avg monthly gross revenues when active
ren h12q15 wage_expense // avg expenditure on wages // SAW Check if its av expen on wage per individual or total (since we got an indicator for number of people hired)
ren h12q16 materials_expense // avg expenditures on raw materials
ren h12q17 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (. = 0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit != . // W3 has some hhs with negative profit (56)
gen annual_selfemp_profit = monthly_profit * months_activ
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_self_employment_income.dta", replace 

*Processed crops
//Not captured in w5 instrument (or other UGA waves)

*Fish trading
//It is captured in the GSEC12 section (already included)

********************************************************************************
**                             OFF-FARM HOURS      	    	                  **
********************************************************************************
//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs).
use "${Uganda_NPS_W4_raw_data}/GSEC8_1.dta", clear
ren HHID hhid
*Use ISIC codes for non-farm activities (For wave 3 we have a 1 digit ISCO variable ~ [0,9] that we can use, same as wave 7)
egen primary_hours = rowtotal (h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) if (h8q4==1 | h8q6==1 | h8q8==1 | h8q10==1) & h8q22!=6 // includes work for someone else, work without payment for the house, apprentice etc. for all work MAIN JOB excluding "Working on the household farm or with household livestock.." Last 7 days total hours worked per person
gen secondary_hours =  h8q43 if  h8q41!=6 &  h8q41!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours, for the past 7 days"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_off_farm_hours.dta", replace 
*Notes:  We have information about the total weeks and months worked for Main job and Secondary Job, should we aim to construct a off-farm hours worked for the year and not only for the past 7 days? Similar to what we did for Agricultural hours worked section.

********************************************************************************
*							 WAGE INCOME (AG & NON-AG)			 		  			*
********************************************************************************
*Notes: There's no need to estimate the average number of weeks worked per months since that information is provided - in contrast to wave 3. Also, we combined Wage income Ag and Non-ag sections into only one section to reduce lines of code. Numbers differ widely to wave 3. Must be checked. 
use "${Uganda_NPS_W4_raw_data}/GSEC8_1.dta", clear
ren HHID hhid
gen wage_yesno = h8q5==1 // did any wage work in the last 12 months y/n
ren h8q30a number_months // months worked for main job
ren h8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12
egen hours_pastweek = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) if h8q36a!=. | h8q36b!=. | h8q36c!=. | h8q36d!=. | h8q36e!=. | h8q36f!=. | h8q36g!=.
gen number_hours = hours_pastweek*number_weeks

gen most_recent_payment = h8q31a // cash and in-kind payments
gen most_recent_payment_other = h8q31b
ren h8q31c payment_period 
ren h8q37 secwage_yesno // did they have a secondary wage?
ren h8q45a secwage_most_recent_payment
ren h8q45b secwage_most_recent_pay_other
ren h8q45c secwage_payment_period
ren h8q43 secwage_hours_pastweek

gen annual_salary_cash = (number_months*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = ((number_hours/8)*most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace annual_salary_cash = (number_hours*most_recent_payment) if payment_period==1

gen second_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace second_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace second_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace second_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

gen annual_salary_in_kind = (number_months*most_recent_payment_other) if secwage_payment_period==4
replace annual_salary_in_kind = (number_weeks*most_recent_payment_other) if secwage_payment_period==3
replace annual_salary_in_kind = ((number_hours/8)*most_recent_payment_other) if secwage_payment_period==2 // assuming 8 hour workdays 
replace annual_salary_in_kind = (number_hours*most_recent_payment_other) if secwage_payment_period==1

gen second_salary_in_kind = (number_months*secwage_most_recent_pay_other) if secwage_payment_period==4
replace second_salary_in_kind = (number_weeks*secwage_most_recent_pay_other) if secwage_payment_period==3
replace second_salary_in_kind = ((number_hours/8)*secwage_most_recent_pay_other) if secwage_payment_period==2 // assuming 8 hour workdays 
replace second_salary_in_kind = (number_hours*secwage_most_recent_pay_other) if secwage_payment_period==1

recode annual_salary_cash second_salary_cash annual_salary_in_kind second_salary_in_kind (.=0)
gen main_job_ag= 1 if (h8q19B>=6111 & h8q19B<=6340) | (h8q19B>=9211 & h8q19B<=9216)
replace main_job_ag=0 if main_job_ag==.
destring h8q38B, replace
gen sec_job_ag = 1 if (h8q38B>=6111 & h8q38B<=6340) | (h8q38B>=9211 & h8q38B<=9216)
replace sec_job_ag=0 if sec_job_ag==.
*SW Non-Ag Wages
preserve
recode annual_salary_cash  annual_salary_in_kind (nonmissing=0) if main_job_ag==1
recode second_salary_cash  second_salary_in_kind (nonmissing=0) if sec_job_ag==1
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage (both Main and Secondary Job)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_wage_income.dta", replace
restore
*SW Ag Wages
recode annual_salary_cash  annual_salary_in_kind (nonmissing=0) if main_job_ag==0
recode second_salary_cash  second_salary_in_kind (nonmissing=0) if sec_job_ag==0
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from agricultural wage (both Main and Secondary Job)"
rename annual_salary annual_salary_agwage
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_agwage_income.dta", replace

********************************************************************************
**                               OTHER INCOME 	        	    	          **
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/GSEC11A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/GSEC11B.dta"
ren HHID hhid
gen rental_income_cash = h11q5 if ( h11q2==21 |  h11q2==22 |  h11q2==23) // SAW 9.19.22 Includes "Net actual rents received from building..", " Net rent received from land", and  Royalties.
gen rental_income_inkind = h11q6 if ( h11q2==21 |  h11q2==22 |  h11q2==23)
gen pension_income_cash = h11q5 if h11q2==41 // SAW Pension and life insurance annuity benefits
gen pension_income_inkind = h11q6 if h11q2==41
gen assistance_cash = h11q5 if (h11q2==42 | h11q2==43) // Remittances and assistance received locally and from outside
gen assistance_inkind = h11q6 if (h11q2==42 | h11q2==43)
gen other_income_cash = h11q5 if (h11q2==32 | h11q2==33 | h11q2==34 | h11q2==35 | h11q2==36 | h11q2==44 | h11q2==45) // SAW Excluded royalties since it was already include it in rental income. It includes many sources of income
gen other_income_inkind = h11q6 if (h11q2==32 | h11q2==33 | h11q2==34 | h11q2==35 | h11q2==36 | h11q2==44 | h11q2==45)
recode rental_income_cash rental_income_inkind pension_income_cash pension_income_inkind assistance_cash assistance_inkind other_income_cash other_income_inkind (.=0)
gen remittance_income = assistance_cash + assistance_inkind // NKF 9.30.19 wouldn't this be assistance_income?
gen pension_income = pension_income_cash + pension_income_inkind
gen rental_income = rental_income_cash + rental_income_inkind
gen other_income = other_income_cash + other_income_inkind
collapse (sum) remittance_income pension_income rental_income other_income, by(hhid)
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months" 
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months" //EFW 7.17.19 don't have this in this instrument
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_other_income.dta", replace

********************************************************************************
**                           LAND RENTAL INCOME        	    	              **
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
drop HHID
ren hh hhid
rename a2aq14 land_rental_income
recode land_rental_income (.=0)
collapse(sum) land_rental_income, by(hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rental_income.dta", replace

********************************************************************************
*								FARM SIZE / LAND SIZE				  		   *
********************************************************************************
*Determining whether crops were grown on a plot
use "${Uganda_NPS_W4_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC4B.dta"
replace season =2 if season == . 
drop HHID
    ren hh hhid
   
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==. | plot_id==.
ren ACropCode crop_code
replace crop_code= ACrop2_ID if crop_code==.
drop if crop_code==.
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid parcel_id)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crops_grown.dta", replace

use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
replace season =2 if season == . 
drop HHID
ren hh hhid
ren parcelID parcel_id
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated= (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if cultivated==.
replace cultivated=. if cultivated==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
collapse (max) cultivated, by (hhid parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_cultivated.dta", replace

use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
replace season =2 if season == . 
drop HHID
ren hh hhid 
ren parcelID parcel_id
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated = (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if (a2aq11a==. & a2aq11b==.)
*replace cultivated= (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if cultivated==.
replace cultivated=. if cultivated==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
keep if cultivated==1
*Get parcel acres size, I prioritize GPS measurement than farmer estimate (cases when we had both measures) contrary to wave 7 which does the opposite.
gen area_acres_meas = a2aq4
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size.dta", replace
*Notes: Land Size in hectares of all parcels in each household.

*All agricultural land
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
drop HHID
ren hh hhid
replace season = 2 if season == .
ren parcelID parcel_id
drop if parcel_id==.
merge 1:1 hhid parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crops_grown.dta", nogen
/*
gen rented_out = (a2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2 | a2bq12b==1 | a2bq12b==2) //own cultivated annual and perennial crops
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
gen agland = a2aq11a==1 | a2aq11a==2 | a2aq11a==5 | a2aq11a==6| a2bq12a==1 | a2bq12a==2 | a2bq12a==5 | a2bq12a==6 // includes cultivated, fallow, pasture
drop if agland!=1 & crop_grown==.
*/
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
gen other_land_use= (a2aq11a==7 | a2aq11a==96 | a2aq11b==7 | a2aq11b==96 | a2bq12a==6 | a2bq12a==96 | a2bq12b==6 | a2bq12b==96)
replace other_land_use=. if other_land_use==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
drop if rented_out==1 | other_land_use==1 | crop_grown==.
gen agland = a2aq11a==1 | a2aq11a==2 | a2aq11a==5 | a2aq11a==6| a2bq12a==1 | a2bq12a==2 | a2bq12a==5 | a2bq12a==6 // includes cultivated, fallow, pasture
drop if agland!=1
gen area_acres_meas = a2aq4
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
collapse (max) agland (sum) farm_area, by (hhid parcel_id)
lab var agland "1= Parcel was used for crop cultivation or pasture or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_agland.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_agland.dta", replace
collapse (sum) farm_area, by (hhid)
ren farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmsize_all_agland.dta", replace

use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
drop HHID
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
replace season = 2 if season == .
/*
gen rented_out = (a2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2 | a2bq12b==1 | a2bq12b==2) 
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1
*/
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
drop if rented_out==1 
gen parcel_held = 1  
collapse (max) parcel_held, by (hhid parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_held.dta", replace

use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
replace season =2 if season == . 
drop HHID
ren hh hhid 
ren parcelID parcel_id
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
drop if rented_out==1 
gen area_acres_meas = a2aq4 if (a2aq4!=. & a2aq4!=0)
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
collapse (sum) land_size, by (hhid)
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
drop HHID
ren hh hhid
ren parcelID parcel_id
/*
drop if parcel_id==.
gen area_acres_meas = a2aq4
*/
replace season = 2 if season == .
gen area_acres_meas = a2aq4 if (a2aq4!=. & a2aq4!=0)
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size_total
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_total.dta", replace

/*
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
replace season =2 if season == . 
drop HHID
ren hh hhid
ren parcelID parcel_id
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated= (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if cultivated==.
keep if cultivated==1
gen area_acres_meas = a2aq4
replace area_acres_meas=a2bq4 if area_acres_meas==.
replace area_acres_meas=. if area_acres_meas<0 
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size.dta", replace

*All agricultural land
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
drop HHID
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
merge 1:1 hhid parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crops_grown.dta", nogen


gen rented_out = (a2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2 | a2bq12b==1 | a2bq12b==2) //own cultivated annual and perennial crops
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
gen agland = a2aq11a==1 | a2aq11a==2 | a2aq11a==5 | a2aq11a==6| a2bq12a==1 | a2bq12a==2 | a2bq12a==5 | a2bq12a==6 // includes cultivated, fallow, pasture
drop if agland!=1 & crop_grown==.
collapse (max) agland, by (hhid parcel_id)
lab var agland "1= Parcel was used for crop cultivation or pasture or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_agland.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_agland.dta", clear
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size.dta", nogen keep(1 3)
replace farm_area=. if farm_area<0 
collapse (mean) farm_area, by(hhid)
rename farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmsize_all_agland.dta", replace

use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
drop HHID
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
gen rented_out = (a2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2 | a2bq12b==1 | a2bq12b==2) 
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1
drop if rented_out==1
gen parcel_held = 1
collapse (max) parcel_held, by (hhid parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_held.dta", replace

/*
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_held.dta", clear
merge 1:1 hhid parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all parcels listed by the household except those rented out" 
*/
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Uganda_NPS_W4_raw_data}/AGSEC2A.dta", clear
gen season =1 
append using "${Uganda_NPS_W4_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
ren parcelID parcel_id
duplicates drop hhid parcel_id, force // just 2 repeats
drop HHID
replace season = 2 if season == .
gen area_acres_meas = a2aq4 if (a2aq4!=. & a2aq4!=0)
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size_total
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
tostring hhid, format(%18.0f) replace
drop HHID
/*
drop HHID
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
merge 1:1 hhid parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
*replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (max) area_acres_meas, by(hhid parcel_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots" 
*/
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_total.dta", replace
*/
********************************************************************************
*									FARM LABOR								   *
********************************************************************************
*Long Season
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
drop HHID
ren hh hhid
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==. | plot_id==.
ren a3aq35b days_hired_women 
ren a3aq35a days_hired_men 
ren a3aq35c days_hired_child 
recode days_hired_women days_hired_men days_hired_child (.=0)
egen days_hired_mainseason = rowtotal(days_hired_women days_hired_men days_hired_child) 
recode a3aq33a_1 a3aq33b_1 a3aq33c_1 a3aq33d_1 a3aq33e_1 (.=0)
egen days_famlabor_mainseason = rowtotal (a3aq33a_1 a3aq33b_1 a3aq33c_1 a3aq33d_1 a3aq33e_1)
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (hhid plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_mainseason.dta", replace

*Short Season
use "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta", clear
drop HHID
ren hh hhid
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==. | plot_id==.
ren a3bq35b days_hired_women 
ren a3bq35a days_hired_men 
ren a3bq35c days_hired_child 
recode days_hired_women days_hired_men days_hired_child (.=0)
egen days_hired_shortseason = rowtotal(days_hired_women days_hired_men days_hired_child) 
recode a3bq33a_1 a3bq33b_1 a3bq33c_1 a3bq33d_1 a3bq33e_1 (.=0)
egen days_famlabor_shortseason = rowtotal (a3bq33a_1 a3bq33b_1 a3bq33c_1 a3bq33d_1 a3bq33e_1)
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (hhid plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_shortseason.dta", replace

*Hired Labor and Family Labor
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_mainseason.dta", clear
merge 1:1 hhid plot_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_shortseason.dta", nogen
recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_family_hired_labor.dta", replace

********************************************************************************
*							VACCINE USAGE									   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC7.dta", clear
drop HHID
    ren hh hhid
gen vac_animal=a7abq5a==1 | a7abq5a==2
replace vac_animal = . if a7abq5a==. //missing if the household did not own any of these types of animals 

*Disagregating vaccine usage by animal type 
ren AGroup_ID livestock_code
gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,104,108)) + 4*(inlist(livestock_code,109,110)) + 5*(inlist(livestock_code,103,107))
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_vaccine.dta", replace
 
*Individual farmers listed as farmer keeper that use vaccines SAW This is a crude attempt since it hasn't been done for Uganda before. (using NGA w3 as reference)
use "${Uganda_NPS_W4_raw_data}/AGSEC7.dta", clear
preserve
drop HHID
    ren hh hhid
ren AGroup_ID livestock_code
gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,104,108)) + 4*(inlist(livestock_code,109,110)) + 5*(inlist(livestock_code,103,107))
recode species (0=.)
la def species 1 "Large ruminants (largerum, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species
gen vac_animal=a7abq5a==1 | a7abq5a==2
gen all_vac_animal=a7abq5a<=2
keep hhid species vac_animal  all_vac_animal
tempfile vaccines
save `vaccines'
restore
preserve
use "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta"
append using "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta"
gen double farmerid = a6aq3d // SAW: When creating PID variable we need to add double because before it was saving it as float and the PID where being modified which affected the later mege (farmeid example 3604033)
ren hh hhid
replace farmerid = a6bq3d if farmerid==.
replace farmerid = a6cq3d if farmerid==.
keep hhid farmerid LiveStockID
tempfile farmer1
save `farmer1'
restore
preserve
use "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta"
append using "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta"
ren hh hhid
gen double farmerid = a6aq3e
replace farmerid = a6bq3e if farmerid==.
replace farmerid = a6cq3e if farmerid==.
keep hhid farmerid LiveStockID
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
gen species = (inlist(LiveStockID,1,2,3,4,5,6,7,8,9,10,11,12)) + 2*(inlist(LiveStockID,13,14,15,16,18,19,20,21)) + 3*(inlist(LiveStockID,17,22)) + 4*(inlist(LiveStockID,23,24,25,26,27,28))
merge m:m hhid species using `vaccines' 
collapse (max) vac_animal all_vac_animal , by(hhid farmerid)
gen double  indiv=farmerid // SAW again using gen double so PID values do not get different values 
drop if indiv==.
tostring hhid, format(%18.0f) replace
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen // SAW 9.26.23 The only difference with UG wave 3 is the keep(1 3)
keep hhid farmerid vac_animal age female hh_head indiv all_vac_animal
lab var vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_vaccine.dta", replace

********************************************************************************
**                        ANIMAL HEALTH - DISEASES     	    	              **
********************************************************************************
*Comments: No information available on types of diseases suffered by [livestock_id], we only have information on which types of diseases hhid vaccineted for.

********************************************************************************
*					LIVESTOCK WATER, FEEDING, AND HOUSING 					   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC7.dta", clear
ren hh hhid
keep if a7aq1==1
gen feed_grazing = ( a7bq2a==1 |  a7bq2a==2 |  a7bq2b==1 |  a7bq2b==2) 
* Difference between Uganda wave 3 and Wave 4 is that the latter ask about the 2 main feeding practices while wave 3 only ask for 1 main practice.
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat = (a7bq3b==5 | a7bq3b==6 | a7bq3b==7 | a7bq3b==9 | a7bq3c==5 | a7bq3c==6 | a7bq3c==7 | a7bq3c==9) 
gen water_source_const = (a7bq3b==1 | a7bq3b==2 | a7bq3b==3 | a7bq3b==9 | a7bq3c==1 | a7bq3c==2 | a7bq3c==3 | a7bq3c==9)
gen water_source_cover = (a7bq3b==4 | a7bq3b==8 | a7bq3b==10 | a7bq3c==4 | a7bq3c==8 | a7bq3c==10) 
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
* Notes: Similar to feeding practices, wave 4 asks about the 2 main X practices for watering - in contrast, to wave 3 which only asked about the main practice. 
*Comments: Water systems 1 tap water, 2 borehole, 3 dam, 4 well, 5 river, 6 spring, 7 stream, 8 constructed water points, 9 rainwater harvesting, 10 other. Here's the list of water systems not sure where to include each of those so might need to change later. 
gen lvstck_housed = (a7abq4==2 | a7abq4==3 | a7abq4==4 | a7abq4==5 | a7abq4==6 | a7abq4==6==7) // Includes: Confined in sheds, paddocks, fences, cages, baskets, and others
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
gen species = (inlist(AGroup_ID,101,105)) + 2*(inlist(AGroup_ID,102,106)) + 3*(inlist(AGroup_ID,104,108)) + 4*(inlist(AGroup_ID,103,107))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Poultry"
la val species species

*A loop to create species variables
foreach i in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_poultry = `i' if species==4
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
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_feed_water_house.dta", replace

********************************************************************************
*					USE OF INORGANIC FERTILIZER								   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
gen season =1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta"
replace season=2 if season==.
ren hh hhid
rename parcelID parcel_id
rename plotID plot_id
gen use_inorg_fert=(a3aq13==1 | a3bq13==1) if (a3aq13!=. | a3bq13!=.)
collapse (max) use_inorg_fert, by (hhid /*season*/)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W4_raw_data}/AGSEC3A.dta", clear
gen season =1
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B.dta"
replace season=2 if season==.
ren hh hhid
rename parcelID parcel_id
rename plotID plot_id
gen all_use_inorg_fert=(a3aq13==1 | a3bq13==1) if (a3aq13!=. | a3bq13!=.)
preserve
tempfile farmer1
gen double farmerid = a3aq3_3 if a3aq3_2==1 // only single decision-makers
replace farmerid = a3aq3_4a if a3aq3_2==2 & farmerid==.
replace farmerid = a3bq3_3 if a3bq3_2==1 & farmerid==.
replace farmerid = a3bq3_4a if a3bq3_2==2 & farmerid==.
keep hhid farmerid all_use_inorg_fert
save `farmer1'
restore
preserve
tempfile farmer2
gen double farmerid = a3aq3_4b if a3aq3_2==2
replace farmerid =  a3bq3_4b if a3bq3_2==2
keep hhid farmerid all_use_inorg_fert
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_use_inorg_fert, by(hhid farmerid)
gen double  indiv=farmerid // SAW again using gen double so individ values do not get different values 
drop if indiv==.
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", keep(1 3) nogen
keep hhid indiv all_use_inorg_fert
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if indiv!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_fert_use.dta", replace


********************************************************************************
*						USE OF IMPROVED SEED								   *
********************************************************************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta"

*Use of seed by type of crop
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	
	gen imprv_seed_`cn'= use_imprv_seed==1 & crop_code==`c'
	gen hybrid_seed_`cn'=.
}
preserve
collapse (max) *imprv* /*hybrid_seed_**/, by(hhid)
lab var use_imprv_seed "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	*lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
restore

save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_improvedseed_use.dta", replace
merge m:m hhid plot_id parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_dm_ids.dta"
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=use_imprv_seed if crop_code==`c'  
	*gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= crop_code==`c' 
	
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use_temp_`cn'.dta", replace // Would it be helpful to save this as tempfile? 
}

collapse (max) all_imprv_seed_use=use_imprv_seed  all_imprv_seed_*  *_farmer, by (hhid indiv)
gen farm_manager=1 if indiv!=.
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen
recode farm_manager (.=0)
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	*lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use.dta", replace 

********************************************************************************
**                             PLOT MANAGER        	                          **
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${Uganda_NPS_W4_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/AGSEC4B.dta"
replace season = 2 if season == .
rename HHID hhid2
ren hh hhid
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223) //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
gen use_imprv_seed = (a4aq13==2) if a4aq13!=.
replace use_imprv_seed= (a4bq13==2) if use_imprv_seed==. & a4bq13!=.
*Crop Recode (Must check if applies for Uganda)
collapse (max) use_imprv_seed, by(hhid parcelID plotID cropID season) //SAW Potentially we could do it by season. 
rename parcelID parcel_id
rename plotID plot_id
rename cropID crop_code
tempfile imprv_seed
save `imprv_seed'

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_quantities.dta", clear
foreach i in inorg_fert org_fert pest /*herb*/ {
	recode `i'_kg (.=0)
	replace `i'_kg=1 if `i'_kg >0 
	ren `i'_kg use_`i'
	/*recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'*/
}
 
collapse (max) use_*, by(hhid parcel_id plot_id season) // SAW If in at least one season it used any of i it is coded as 1. 
merge 1:m hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", nogen keep(1 3) keepusing(crop_code)
*ren crop_code_master crop_code
collapse (max) use*, by(hhid parcel_id plot_id crop_code season)
merge 1:1 hhid parcel_id plot_id crop_code season using `imprv_seed',nogen keep(1 3)
recode use* (.=0)
preserve 
keep hhid parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropname_table.dta", nogen keep(3)
drop crop_code	
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_imprvseed_crop.dta", replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore

merge m:m hhid parcel_id plot_id using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_dm_ids.dta", nogen keep(1 3) // SAW personids is at the plot season level while input quantities at the plot level
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid individ female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropname_table.dta", nogen keep(3)
*decode crop_code, gen(crop_name)
drop crop_code
gen farmer_=1
ren individ personid
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
clonevar indiv = personid 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use.dta", replace 
restore

ren individ personid 
collapse (max) use_*, by(hhid personid female)
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
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if personid!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	clonevar indiv = personid 
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_fert_use.dta", replace //This is currently used for AgQuery
restore

********************************************************************************
*							REACHED BY AG EXTENSION							   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC9.dta", clear
drop HHID
ren hh hhid
*Governmet Extension
gen advice_gov = (a9q3==1) if a9q2==1
*Input Supplier
gen advice_input_sup = (a9q3==1) if a9q2==2
*NGO 
gen advice_ngo =  (a9q3==1) if a9q2==3
*Cooperative / Farmer Association
gen advice_coop = (a9q3==1) if a9q2==4
*Larger Scale Farmer
gen advice_farmer = (a9q3==1) if a9q2==5
*Other
gen advice_other =  (a9q3==1) if a9q2==6

**advice on prices from extension // SAW Not neccesarily, could be other types of advices as well. Right now is not specified to be on prices.
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_input_sup==1 | advice_farmer==1)
gen ext_reach_unspecified=(advice_other==1)
*gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_any_ext.dta", replace 

********************************************************************************
**                         MOBILE PHONE OWNERSHIP                             **
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/GSEC14A.dta", clear
ren HHID hhid
*append using "${Uganda_NPS_W4_raw_data}/GSEC14B.dta"
recode h14q4 (.=0)
gen hh_number_mobile_owned=h14q4 if h14q2==16 // number mobile phones owned by household today
recode hh_number_mobile_owned (.=0)
gen mobile_owned=hh_number_mobile_owned>0
collapse (max) mobile_owned, by(hhid)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_mobile_own.dta", replace 

********************************************************************************
*					USE OF FORMAL FINANCIAL SERVICES						   *
********************************************************************************
//Household Questionnaire Section 13: Financial Services Use, is missing in W4, so can't construct this section

********************************************************************************
*								MILK PRODUCTIVITY			   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC8B.dta", clear
drop HHID
ren hh hhid
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==105 
gen milk_animals = a8bq1
gen days_milked = a8bq2
*This won't consider HH that had large ruminant but did not used them to get milk.
gen months_milked = days_milked/30.5
gen liters_day = a8bq3 
gen liters_per_largerruminant = days_milked*liters_day
gen liters_milk_produced = (milk_animals*365*(months_milked/12)*liters_day)
collapse (sum) milk_animals liters_milk_produced (mean) days_milked months_milked liters_day liters_per_largerruminant, by(hhid)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
keep hhid milk_animals months_milked liters_milk_produced days_milked liters_per_largerruminant liters_day
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_milk_animals.dta", replace 

********************************************************************************
*								EGG PRODUCTIVITY							   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta", clear
drop HHID
ren hh hhid
gen poultry_owned = a6cq3a if (APCode==23 | APCode==24 | APCode==25 | APCode==26) // SAW It includes   Indigenous dual-purpose chicken, Layers (exotic/cross chicken),   Broilers (exotic/cross chicken), ther poultry and birds (turkeys/ducks)
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W4_raw_data}/AGSEC8C.dta", clear
drop HHID
ren hh hhid
gen eggs_months = a8cq1/3	// number of layers was reported for the last three months thus the need to divide by 3 to get monthly total				
gen eggs_per_month = a8cq2/3	// number of eggs laid was reported for the last three months thus the need to divide by 3 to get monthly total			
collapse (sum) eggs_months eggs_per_month, by(hhid)
gen eggs_total_year = eggs_month*eggs_per_month*12 // multiply by 12 to get the annual total 
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months eggs_per_month eggs_total_year poultry_owned 
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_eggs_animals.dta", replace 
*Notes: Must revisit since wave 3 has very different means than wave 4 and 7.


********************************************************************************
**                      CROP PRODUCTION COSTS PER HECTARE                      **
********************************************************************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
replace dm_gender = 3 if dm_gender==.
collapse (sum) ha_planted /*ha_harvest*/, by(hhid parcel_id plot_id /*season*/ purestand field_size) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
duplicates drop hhid parcel_id plot_id /*season*/, force
reshape long ha_, i(hhid parcel_id plot_id /*season*/ purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", replace 
replace dm_gender = 3 if dm_gender==.
collapse (sum) cost_=val, by(hhid parcel_id plot_id /*season*/ dm_gender exp)
reshape wide cost_, i(hhid parcel_id plot_id  /*season*/ dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
*drop cost_total
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge m:1 hhid parcel_id plot_id /*season*/ using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(hhid /*season*/ dm_gender area_type)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
*replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(hhid /*season*/ dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid /*season*/) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted /*harvested*/ {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropcosts.dta", replace 
*Notes: For Crop production costs per hectare we are adding all costs and area planted across both seasons at the plot level. 
* Season added in green in case we want to compute this section at the household season level. 

********************************************************************************
                    * RATE OF FERTILIZER APPLICATION *
********************************************************************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
collapse (sum) ha_planted /*ha_harvest*/, by(hhid parcel_id plot_id season/*season*/ dm_gender) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
merge 1:m hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_quantities.dta", keep(1 3) nogen
*collapse (sum) ha_planted /*ha_harvest*/ /*inorg_fert_rate org_fert_rate pest_rate*/ inorg_fert_kg org_fert_kg pest_kg, by(hhid parcel_id plot_id /*season*/ dm_gender) // at the plot level for both seasons


collapse (sum) ha_planted /*ha_harvest*/ /*inorg_fert_rate org_fert_rate pest_rate*/ inorg_fert_kg org_fert_kg pest_kg n_kg p_kg k_kg, by(hhid parcel_id plot_id /*season*/ dm_gender) // at the plot level for both seasons

drop if ha_planted==0
unab vars : *kg 
local vars `vars' /*ha_irr*/ ha_planted
recode *kg (.=0)


gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren ha_planted ha_planted_

ren *kg *kg_

drop if dm_gender2=="" 

reshape wide *_, i(hhid parcel_id plot_id) j(dm_gender2) string
collapse (sum) *male *mixed /*ha_planted_* *kg**/, by(hhid)
recode ha_planted* (0=.)
foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 hhid using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed {
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household"
*lab var fert_inorg_kg "Inorganic fertilizer (kgs) for household"
*lab var fert_org_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
*lab var herb_kg "Herbicide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"
la var n_kg "Nitrogen from inorganic fertilizers (kg) for hh"
la var p_kg "Phosphorus from inorganic fertilizers (kg) for hh"
la var k_kg "Potassium from inorganic fertilizers (kg) for hh"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
*lab var fert_inorg_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
*lab var fert_org_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
*lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
la var n_kg_`i' "Inorganic N (kg) for `i'-managed plots"
la var p_kg_`i' "Inorganic P (kg) for `i'-managed plots"
la var k_kg_`i' "Inorganic K (kg) for `i'-managed plots"
}


/*
ren inorg_fert_kg fert_inorg_kg_ 
ren org_fert_kg fert_org_kg_ 
ren pest_kg pest_kg_
/*
ren inorg_fert_rate fert_inorg_kg_ 
ren org_fert_rate fert_org_kg_ 
ren pest_rate pest_kg_
*/
*ren herb_rate herb_kg_ // SAW no herb information
drop if dm_gender2=="" // SAW might be a better way to allow reshape work without losing this info. 
reshape wide ha_planted_ fert_inorg_kg_ fert_org_kg_ pest_kg_ /*herb_kg_*/, i(hhid parcel_id plot_id) j(dm_gender2) string
collapse (sum) *male *mixed, by(hhid)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg fert_org_kg pest_kg /*herb_kg*/ {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 hhid using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed {
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for household"
lab var fert_org_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var fert_inorg_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var fert_org_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
}*/
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fertilizer_application.dta", replace 

********************************************************************************
                    * WOMEN'S DIET QUALITY *
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available
*SW Need to find a good example on how to construct this variable. Not available in TZN W4, NGA wave 3, Any Uganda wave.

********************************************************************************
*						HOUSEHOLD'S DIET DIVERSITY SCORE					   *
********************************************************************************


* Uganda Wave 4 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of households eating nutritious food can be estimated
*No available data to construct rCSI module.
*Constructing FCS


use "${Uganda_NPS_W4_raw_data}/GSEC15B.dta", clear
ren HHID hhid
ren h15bq3b days
recode days (8=7)
recode days (.=0)

recode itmcd 		(110/116 190/191 					=1	"CEREALS" )  								//// A
					(101/109 180/182    				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	) 	//// B
					(140/146 162/163					=3	"LEGUMES, NUTS AND SEEDS" ) 				//// C
					(135/139 164/168	 				=4	"VEGETABLES"	)  							//// D
					(117/124 							=5	"MEAT, EGGS, FISH"	)                       //// E
					(130/134 169/174					=6	"FRUITS"	)  							    //// F
					(125/126							=7	"MILK AND MILK PRODUCTS" )					//// G
					(127/129   							=8	"OILS AND FATS"	)							//// H
					(147 /*151 154*/ 					=9	"SWEETS"	) 								//// I
					(148/154 160 175					=10 "SPICES, CONDIMENTS, BEVERAGES"	)			//// J
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
*rename hhid HHID
*merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_household_diet.dta", nogen 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fcs.dta", replace



use "${Uganda_NPS_W4_raw_data}/GSEC15B.dta", clear
ren HHID hhid
* recode food items to map HDDS food categories
recode itmcd 		(110/116 190/191				=1	"CEREALS" )  //// 
					(101/109 180/182   				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  //// NKF 12.18.19 Including "matooke" (starchy banana) here - is this right? Or is it fruit?
					(135/139 164/168				=3	"VEGETABLES"	)  ////	
					(130/134 169/174				=4	"FRUITS"	)  ////	
					(117/121 						=5	"MEAT"	)  ////					
					(124							=6	"EGGS"	)  ////
					(122/123 						=7  "FISH") ///
					(140/146 162/163				=8	"LEGUMES, NUTS AND SEEDS") ///
					(125/126						=9	"MILK AND MILK PRODUCTS")  //// NKF 12.18.19 Including "Infant formula foods" here, is this right?
					(127/129   						=10	"OILS AND FATS"	)  ////
					(147					 		=11	"SWEETS"	)  //// 
					(148/154 160 175				=14 "SPICES, CONDIMENTS, BEVERAGES"	)  //// SAW Excluded Other since its not included in other Uganda Waves.
					,generate(Diet_ID)					
keep if Diet_ID<15
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

merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fcs.dta", nogen 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_household_diet.dta", replace

/*
* Uganda Wave 4 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of households eating nutritious food can be estimated
use "${Uganda_NPS_W4_raw_data}/GSEC15B.dta", clear
drop HHID
ren hh hhid
* recode food items to map HDDS food categories
recode itmcd 		(110/116 190/191				=1	"CEREALS" )  //// 
					(101/109 180/182   				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  //// NKF 12.18.19 Including "matooke" (starchy banana) here - is this right? Or is it fruit?
					(135/139 164/168				=3	"VEGETABLES"	)  ////	
					(130/134 169/174				=4	"FRUITS"	)  ////	
					(117/121 						=5	"MEAT"	)  ////					
					(124							=6	"EGGS"	)  ////
					(122/123 						=7  "FISH") ///
					(140/146 162/163				=8	"LEGUMES, NUTS AND SEEDS") ///
					(125/126						=9	"MILK AND MILK PRODUCTS")  //// NKF 12.18.19 Including "Infant formula foods" here, is this right?
					(127/129   						=10	"OILS AND FATS"	)  ////
					(147					 		=11	"SWEETS"	)  //// 
					(148/154 160 175				=14 "SPICES, CONDIMENTS, BEVERAGES"	)  //// SAW Excluded Other since its not included in other Uganda Waves.
					,generate(Diet_ID)					
keep if Diet_ID<15
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_household_diet.dta", replace
*/

********************************************************************************
*							WOMEN'S CONTROL OVER INCOME			(W3 VERSION)			   *
********************************************************************************
*SAW NOTES: THIS VERSION IS CODED USING UGANDA WAVE 3.
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
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
use "${Uganda_NPS_W4_raw_data}/AGSEC5A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/AGSEC5B.dta"
*append using "${Uganda_NPS_W4_raw_data}/AGSEC6A.dta"
*append using "${Uganda_NPS_W4_raw_data}/AGSEC6B.dta"
*append using "${Uganda_NPS_W4_raw_data}/AGSEC6C.dta"
append using "${Uganda_NPS_W4_raw_data}/AGSEC8A.dta"
append using "${Uganda_NPS_W4_raw_data}/AGSEC8B.dta"
append using "${Uganda_NPS_W4_raw_data}/AGSEC8C.dta"
drop HHID
ren hh HHID

append using "${Uganda_NPS_W4_raw_data}/GSEC12_1.dta" // OR
*append using "${Uganda_NPS_W4_raw_data}/gsec12.dta"
ren HHID hhid
gen type_decision="" 
gen controller_income1=.
gen controller_income2=. 

* Control Over Harvest from Crops *
replace type_decision="control_annualharvest" if !missing(a5aq6a_2) | !missing(a5aq6a_3) | !missing(a5aq6a_4)
replace controller_income1=a5aq6a_2
replace controller_income1=a5aq6a_3 if controller_income1==.
replace controller_income2=a5aq6a_4
replace type_decision="control_annualharvest" if !missing(a5bq6a_2) | !missing(a5bq6a_3) | !missing(a5bq6a_4)
replace controller_income1=a5bq6a_2 if controller_income1==.
replace controller_income1=a5bq6a_3 if controller_income1==.
replace controller_income2=a5bq6a_4 if controller_income2==.

*Control over crop sales earnings *
preserve
replace type_decision="control_annualsales" if !missing(a5aq11f) | !missing(a5aq11g) | !missing(a5aq11h)
replace controller_income1=a5aq11f if controller_income1==.
replace controller_income1=a5aq11g if controller_income1==.
replace controller_income2=a5aq11h if controller_income2==.
replace type_decision="control_annualsales" if !missing(a5bq11f) | !missing(a5bq11g) | !missing(a5bq11h)
replace controller_income1=a5bq11f if controller_income1==.
replace controller_income1=a5bq11g if controller_income1==.
replace controller_income2=a5bq11h if controller_income2==.
tempfile sales
keep if type_decision=="control_annualsales"
save `sales'
restore
append using `sales'

*Control over livestock sales 
replace type_decision="control_livestocksales" if !missing(a8aq6a) | !missing(a8aq6b)
replace controller_income1=a8aq6a if controller_income1==.
replace controller_income2=a8aq6b if controller_income2==.
* Notes: There are only 11 & 6 observations respectively. It seems like not many HH sell meat
*Control over milk sales
replace type_decision="control_milksales" if !missing(a8bq10a) | !missing(a8bq10b)
replace controller_income1=a8bq10a if controller_income1==.
replace controller_income2=a8bq10b if controller_income2==.
*Control over eggs_sales
 replace type_decision="control_otherlivestock_sales" if !missing(a8cq6a) | !missing(a8cq6b)
replace controller_income1=a8cq6a if controller_income1==.
replace controller_income2=a8cq6b if controller_income2==.

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
* create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							*| type_decision=="control_permharvest" ///
							 | type_decision=="control_annualsales" ///
							*| type_decision=="control_permsales" ///
							*| type_decision=="control_processedsales"
recode 	control_cropincome (.=0)								
gen control_livestockincome=1 if  type_decision=="control_livestocksales" ///
							| type_decision=="control_milksales" ///
							| type_decision=="control_otherlivestock_sales"				
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																					
gen control_nonfarmincome=1 if  type_decision=="control_remittance" ///
							  | type_decision=="control_assistance" ///
							  | control_businessincome== 1 
recode 	control_nonfarmincome (.=0)																		
collapse (max) control_* , by(hhid controller_income)  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*	Now merge with member characteristics
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
*drop if PID==""
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_control_income.dta", replace

********************************************************************************
*				WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING	       *
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making

use "${Uganda_NPS_W4_raw_data}/AGSEC3A", clear // planting input decision maker - s3aq03_3
append using "${Uganda_NPS_W4_raw_data}/AGSEC3B" // s3bq03_3
append using "${Uganda_NPS_W4_raw_data}/AGSEC5A" // s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W4_raw_data}/AGSEC5B" // s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W4_raw_data}/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W4_raw_data}/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W4_raw_data}/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
rename HHID hhid2
rename hh  hhid
gen type_decision="" 
gen double decision_maker1=. // SW: The double is very important, otherwise it is created as float, thus many individ are lost and later merge becomes inaccurate.
gen double decision_maker2=.
gen double decision_maker3=.

* planting_input * 3A  : a3aq3_3 a3aq3_4a a3aq3_4b
replace type_decision="planting_input" if  !missing(a3aq3_3) | !missing(a3aq3_4a) | !missing(a3aq3_4b)
replace decision_maker1=a3aq3_3 
replace decision_maker1 = a3aq3_4a if decision_maker1==.
replace decision_maker2 = a3aq3_4b
*3B: 
replace type_decision="planting_input" if  !missing(a3bq3_3) | !missing(a3bq3_4a) | !missing(a3bq3_4b)
replace decision_maker1=a3bq3_3  if decision_maker1==.
replace decision_maker1 = a3bq3_4a if decision_maker1==.
replace decision_maker2 = a3bq3_4b if decision_maker2==.

 * harvest control * 3A a5aq6a_2 a5aq6a_3 a5aq6a_4
replace type_decision="harvest" if  !missing(a5aq6a_2) | !missing(a5aq6a_3) | !missing(a5aq6a_4)
replace decision_maker1=a5aq6a_2 if decision_maker1==.
replace decision_maker1 = a5aq6a_3 if decision_maker1==.
replace decision_maker2 = a5aq6a_4 if decision_maker2==.
*3B: a5bq6a_2 a5bq6a_3 a5bq6a_4
replace type_decision="harvest" if  !missing(a5bq6a_2) | !missing(a5bq6a_3) | !missing(a5bq6a_4)
replace decision_maker1=a5bq6a_2 if decision_maker1==.
replace decision_maker1 = a5bq6a_3 if decision_maker1==.
replace decision_maker2 = a5bq6a_4 if decision_maker2==.

* control livestock * a6aq3b a6aq3c // a6bq3b a6bq3c // a6cq3b a6cq3c
replace type_decision="livestockowners" if  !missing(a6aq3b) | !missing(a6aq3c)
replace decision_maker1=a6aq3b if decision_maker1==.
replace decision_maker2 = a6aq3c if decision_maker2==.

replace type_decision="livestockowners" if  !missing(a6bq3b) | !missing(a6bq3c)
replace decision_maker1=a6bq3b if decision_maker1==.
replace decision_maker2 = a6bq3c if decision_maker2==.

replace type_decision="livestockowners" if  !missing(a6cq3b) | !missing(a6cq3c)
replace decision_maker1=a6cq3b if decision_maker1==.
replace decision_maker2 = a6cq3c if decision_maker2==.

keep hhid type_decision decision_maker1 decision_maker2 /*decision_maker3*/
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
* number of time appears as decision maker
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input" | type_decision=="harvest" 

recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv
*Now merge with member characteristics
merge 1:1 hhid indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_make_ag_decision.dta", replace

********************************************************************************
*							WOMEN'S OWNERSHIP OF ASSETS						   *
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
use "${Uganda_NPS_W4_raw_data}/AGSEC2A", clear // land ownership 
append using "${Uganda_NPS_W4_raw_data}/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W4_raw_data}/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W4_raw_data}/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
drop HHID
ren hh HHID
append using "${Uganda_NPS_W4_raw_data}/GSEC14A"
ren HHID hhid
*append using "${Uganda_NPS_W4_raw_data}/GSEC14B"

gen type_asset=""
gen double asset_owner1=.
gen double asset_owner2=.

* Ownership of land * 
replace type_asset="landowners" if  !missing(a2aq24b)
replace asset_owner1=a2aq24b if asset_owner1==.
*replace asset_owner2=s2aq24__1 if !inlist(s2aq24__1, .,0,99) // Wave 4 only reports 1 owner

* append who hss right to sell or use a2aq27a a2aq27b
preserve
replace type_asset="landowners" if   !missing(a2aq27a) |  !missing(a2aq27b)
replace asset_owner1=a2aq27a if asset_owner1==. 
replace asset_owner2=a2aq27b if asset_owner2==.
* no hss right to sell or use recoded in season 2
keep if type_asset=="landowners"
keep hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  

*non-poultry livestock (keeps/manages) a6aq3b a6aq3c // a6bq3b a6bq3c
replace type_asset="livestockowners" if  !missing(a6aq3b) |  !missing(a6aq3c)
replace asset_owner1=a6aq3b if asset_owner1==.
replace asset_owner2=a6aq3c if asset_owner2==.
 
replace type_asset="livestockowners" if  !missing(a6bq3b) |  !missing(a6bq3c)
replace asset_owner1=a6bq3b if asset_owner1==.
replace asset_owner2=a6bq3c if asset_owner2==.

* household assets -   h14q3A h14q3B (PID IN DIFFERENT FORMAT)
replace type_asset="household_assets" if  !missing(h14q3A) |  !missing(h14q3B)
gen asset_owner1_1= substr(h14q3A,-1,1)
destring asset_owner1_1, replace
gen asset_owner1_2= substr(h14q3B,-1,1)
destring asset_owner1_2, replace

keep hhid type_asset asset_owner*
*  2nd Owner *
preserve
keep hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
* 1st Owner *
preserve
keep hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
tempfile asset_owner1
save `asset_owner1'
restore 
* We create dataset with 2nd Owners (PID style different) *
preserve 
keep hhid type_asset asset_owner1_2
drop if asset_owner1_2==.
ren asset_owner1_2 asset_owner
tempfile asset_owner1_2
save `asset_owner1_2'
restore 
* We create dataset with 1nd decision makers (PID style different)
keep hhid type_asset asset_owner1_1
drop if asset_owner1_1==.
ren asset_owner1_1 asset_owner
append using `asset_owner2'
append using `asset_owner1'
append using `asset_owner1_2'

gen own_asset=1 
clonevar individ = asset_owner

*Now merge with member characteristics
preserve
merge m:1 hhid individ using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen keep(3) // asset_owner as individ style
tempfile individ_data
save `individ_data'
restore
clonevar  indiv = asset_owner 
merge m:1 hhid indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen keep(3) // asset_owner as indiv style (from HH Datasets)
append using `individ_data'
collapse (max) own_asset , by(hhid indiv)  //any decision
merge 1:1 hhid indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen // Controller_income as indiv style
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ownasset.dta", replace

********************************************************************************
                          * AGRICULTURAL WAGES *
********************************************************************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_long.dta", replace // at the plot season level
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ag_wage.dta", replace

********************************************************************************
                          * CROP YIELDS *
********************************************************************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", clear

replace dm_gender = 3 if dm_gender == .

gen no_harvest = ha_harvest == .
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

save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan.dta", replace


/* 
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace // at the plot season level
//Legacy stuff- agquery gets handled above.
replace dm_gender = 3 if dm_gender==.
gen ha_harvest=ha_planted
collapse (sum) area_harv_=ha_harvest area_plan_=ha_planted harvest_=quant_harv_kg, by(hhid dm_gender purestand crop_code) // SAW 10.9.23 I use s_quant_harv_kg instead of quant_harv_kg
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
reshape wide harvest_ area_harv_ area_plan_, i(hhid dm_gender2 crop_code) j(mixed) string
ren area* area*_
ren harvest* harvest*_
reshape wide harvest* area*, i(hhid crop_code) j(dm_gender2) string
foreach i in harvest area_plan area_harv {
	egen `i' = rowtotal (`i'_*)
	foreach j in inter pure {
		egen `i'_`j' = rowtotal(`i'_`j'_*) 
	}
	foreach k in male female mixed {
		egen `i'_`k' = rowtotal(`i'_*_`k')
	}
	
}
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan.dta", replace
*/
*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_
drop crop_code kgs_sold quant_harv_kg  // need to drop this 2 vars to make reshape possible
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string
*merge 1:1 hhid using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest* value_harv* value_sold* /*number_trees_planted**/  , by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area*  total_harv_area* value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*ren variable
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (Naira) (household)" 
	lab var value_sold_`p' "Value sold of `p' (Naira) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household) (summed accross all seasons)" 
	*lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (summed accross all seasons)" 
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

foreach p of global topcropname_area {
	gen grew_`p'=(total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	*gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	*lab var harvested_`p' "1= Household harvested `p'"
	gen harvested_`p'= (harvest_`p'!=. & harvest_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
*Updated harvested_`p' if household has kgs harvested of topcropname_area (need this for future household summary stats).
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", replace
*Grouping following IMPACT categories but also mindful of the consumption categories.
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
					(741 742 744 740						=13	"Bananas")  ////  banana food, banana beer, banana swwet
					(410 420 430 440 450 460 470    					=14	"Vegetables"	)  ////  cabbage, tomatoes, onions, pumpkins, dodo, egglplants 
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
					(810 811 812 =24 "Coffee all"	)  //// 
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
* wheat tea vanilla sunflower simsim tobacco Need to add to type of commodity revising commodity high/low classification and 811 812 and 840 

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
save "${Uganda_NPS_W4_created_data}//Uganda_NPS_W4_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by(hhid type_commodity) 
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
                          * SHANNON DIVERSITY INDEX *
********************************************************************************
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan.dta", replace
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0 
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(hhid)
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_shannon_diversity_index.dta", replace


********************************************************************************
                          * CONSUMPTION *
********************************************************************************
* This section is written using Uganda Wave 3  as reference. 
use "${Uganda_NPS_W4_raw_data}/pov2013_14", clear 
ren HHID hhid
duplicates drop hhid, force // 1 observation deleted
ren nrrexp  total_cons 
*ren cpexp30  total_cons 
ren equiv adulteq
ren welfare peraeq_cons
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3)
gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30
gen daily_percap_cons = percapita_cons/30  

lab var total_cons "Total HH consumption, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var peraeq_cons "Consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var percapita_cons "Consumption per capita, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var daily_peraeq_cons "Daily consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var daily_percap_cons "Daily consumption per capita, in 05/06 prices, spatially and temporally adjusted in 13/14" 
keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq poor_13
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_consumption.dta", replace
*SAW: There no Connsumption document to reference whether consumption measure were spatially and temporally deflated. 

**We create an adulteq dataset for summary statistics sections
use "${Uganda_NPS_W4_raw_data}/pov2013_14", clear 
ren HHID hhid
duplicates drop hhid, force // 1 observation deleted
rename equiv adulteq
keep hhid adulteq
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_adulteq.dta", replace


********************************************************************************
                          * FOOD SECURITY *
********************************************************************************
*SW 9.27.23 This section is written using Uganda wave 3 as reference. (Not available for Uganda old wave 3, wave 5, and 7)
use "${Uganda_NPS_W4_raw_data}/GSEC15B", clear 
rename h15bq5 fd_home
rename h15bq7 fd_awayhome
rename h15bq9 fd_ownp
rename h15bq11 fd_gift
egen food_total = rowtotal(fd*) 
ren HHID hhid
* This includes food purchased at home, away from home, own production, and gifts.
collapse (sum) fd* food_total, by(hhid)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_adulteq.dta", nogen keep(1 3)
*merge 1:1 hhid using "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3)
drop if adulteq ==.
recode fd* food_total (0=.)
gen daily_peraeq_fdcons = (food_total*52)/adulteq /365 
gen daily_percap_fdcons = (food_total*52) /hh_members/365

save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_food_cons.dta", replace

********************************************************************************
                          * FOOD PROVISION *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/GSEC17_2", clear 
ren HHID hhid
gen food_insecurity = 1 if h17q10a==1
replace food_insecurity = 0 if food_insecurity==.
collapse (sum) months_food_insec= food_insecurity, by(hhid)
lab var months_food_insec "Number of months where the household experienced any food insecurity" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_food_insecurity.dta", replace

********************************************************************************
                          *HOUSEHOLD ASSETS*
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/GSEC14A", clear 
ren HHID hhid
rename h14q5 value_today
rename h14q4 nb_items
*dropping items if hh doesnt report owning them 
keep if h14q3==1
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets in Shs"
format value_assets %20.0g
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_assets.dta", replace

********************************************************************************
                         *DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument

********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************
*SAW 9.28.23 This section uses Uganda Wave 3 as reference. 
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
global empty_vars ""
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", clear
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production_grouped.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production_type_crop.dta", nogen keep(1 3)
recode value_pro* value_sal* (.=0)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_inputs.dta", nogen keep(1 3)

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_`c'_monocrop_hh_area.dta", nogen
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

drop /*val_anml**/ val_mech* val_labor* /*val_herb**/ val_inorg* val_orgfert* val_plotrent* val_seeds* /*val_transfert* val_seedtrans**/ val_pest* val_parcelrent* //

*Land rights
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish Income // SAW No fish income for Uganda wave 4
gen fish_income_fishfarm = 0
gen fish_income_fishing =0
gen fishing_income = 0
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars fish_income*

*Livestock income
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU_Coefficients.dta", nogen keep(1 3)
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced /*value_other_produced fish_income_fishfarm*/  cost_*livestock (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced/*value_other_produced*/) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_deworm_livestock + cost_ticks_livestock) /*fish_income_fishfarm*/
*Notes: SAW should we include value of livestock products here?
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
*gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
gen livestock_expenses = (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_deworm_livestock + cost_ticks_livestock)
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
gen any_imp_herd_all = . 
foreach v in ls_exp_vac any_imp_herd{
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
* Notes: We do have information for mean_12months and animals_lost12months by type of livestock but not for household level maybe we can add it. We can calculate mean_12months and animals_lost12months (in uganda the variable is named lost_disease_*) at the household level for all livestock (if thats what we are looking for)

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*

*Self-employment income
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_W3_agproducts_profits.dta", nogen keep(1 3)
*: This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is already part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_agwage_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_other_income.dta", nogen keep(1 3)
*SAW: Remittance income is already included in the other income dataset. (Need to check why)
egen transfers_income = rowtotal (remittance_income pension_income)
*SAW There is a confusion between remittance income and assistance income in the UGanda Other Income section that needs to be revised.
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm Size
merge 1:1 hhid using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_all.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_total.dta", nogen keep(1 3)
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
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_vaccine.dta", nogen keep(1 3)
*merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fert_use.dta", nogen keep(1 3)
*merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_use.dta", nogen keep(1 3)
*SAW: This Input Use dataset comes from the Plot Manager section that is constructed in the Nigeria Wave 3 do file which includes fert use and improved seed use along pesticides and fertilizers into one single dataset. We might want to construct this section in Uganda for fewer lines of code in the future. (It comes adter the Fertilizer Use and Improved Seed sections in Uganda)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_any_ext.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_W3_fin_serv.dta", nogen keep(1 3) // SAW Not Available for Uganda Wave 3 dta missing
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode /*use_fin_serv**/ ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_milk_animals.dta", nogen keep(1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
la var costs_dairy "Dairy production cost (explicit)"
la var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen liters_per_cow = . 
gen liters_per_buffalo = . 
gen share_imp_dairy = . 
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen milk_animals = . 
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy  /*liters_per_cow */

*Egg productivity
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
*gen liters_milk_produced = milk_months_produced * milk_quantity_produced // SAW 2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)
 
*Household diet
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_household_diet.dta", nogen keep(1 3)

*consumption 
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_food_insecurity.dta", nogen keep(1 3)
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

*livestock feeding, water, and housing
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_feed_water_house.dta", nogen keep(1 3)

*Shannon Diversity index
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_shannon_diversity_index.dta", nogen keep(1 3)

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
gen fishing_hh =.
global empty_vars $empty_vars fishing_hh fishing_income 
*lab  var fishing_hh "1= Household has some fishing income" // SAW Not Available

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' /*total_harv_area_`cn'*/ `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' /*total_harv_area_`cn'*/ `cn'_exp (nonmissing=.) if grew_`cn'==0
}

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry {
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i'*/ feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i'*/ feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland /*all_area_harvested*/ all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland /*all_area_harvested*/ all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0		

*all rural households 
recode /*DYA.10.26.2020*/ /*hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/ off_farm_hours off_farm_any_count crop_income livestock_income self_employment_income nonagwage_income agwage_income /*fishing_income*/ transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
*rename liters_per_largeruminant liters_milk_produced
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed" //ALT 08.04.21
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* /*total_harv_area*/ /*
*/ labor_hired labor_family /*
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020 hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/  off_farm_hours off_farm_any_count crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
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
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli /*fert_inorg_kg*/ inorg_fert_kg org_fert_kg n_kg p_kg k_kg pest_kg wage_paid_aglabor
*global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli /*fert_inorg_kg*/ inorg_fert_kg wage_paid_aglabor

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

drop *wage_paid_aglabor_mixed
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%"

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
*SAW 3/13/23 Here we can include the label var into the loop above to reduce number of lines.
*/

*mortality rate // SAW Might Want to go back to Livestock Income section and see if needs to be calculated (I believe this indicator can be constructed.)
global animal_species lrum srum pigs equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = lost_disease_`s'/mean_12months_`s'
	lab var mortality_rate_`s' "Mortality rate - `s'"
}
*SAw 3/13/23 There is an issue with the number_today_poultry variable (all zeros) that its affecting the calculation of mean_12_months_poultry and therefore the mortality rates for poultry. Needs to be checked in the Livestock income section. Also, it might be helpful to use the winsorized version of the variables that are available.
 
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
global empty_vars $empty_vars cost_per_lit_milk
* 3/13/23 SAW No information available, -though, variables have been created.


*****getting correct subpopulations***
*all rural housseholds engaged in crop production 
recode inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate org_fert_rate n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
*recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0

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
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	*if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {
	if inlist("`v'", "inorg_fert_rate",   "cost_total_ha", "cost_expli_ha", "n_rate", "p_rate") | inlist("`v'", "k_rate", "pest_rate") {
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
	_pctile `v'_exp_ha [aw=weight] , p($wins_upper_thres)  
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
	foreach i in yield_pl /*yield_hv*/{
		_pctile `i'_`c' [aw=weight] ,  p(95)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
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
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"
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
recode *proportion_cropvalue_sold *farm_size_agland *labor_family *labor_hired /*
*/ imprv_seed_use use_inorg_fert use_org_fert use_pest /*use_herb*/ *labor_productivity *land_productivity /*
*/ *inorg_fert_rate *org_fert_rate *n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ /*
*/ *cost_expli_hh *cost_expli_hh_ha *cost_expli_ha *cost_total_ha /*
*/ *value_crop_production *value_crop_sales *all_area_planted *all_area_harvested (.=0) if crop_hh==1

recode *proportion_cropvalue_sold *farm_size_agland *labor_family *labor_hired /*
*/ imprv_seed_use use_inorg_fert use_org_fert use_pest /*use_herb*/ *labor_productivity *land_productivity /*
*/ *inorg_fert_rate *org_fert_rate *n_rate p_rate k_rate /*herb_rate*/ pest_rate /*urea_rate npk_rate*/ /*
*/ *cost_expli_hh *cost_expli_hh_ha *cost_expli_ha *cost_total_ha /*
*/ *value_crop_production *value_crop_sales *all_area_planted *all_area_harvested (nonmissing= . ) if crop_hh==0

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
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' /*w_total_harv_area_`cn'*/ (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' /*w_total_harv_area_`cn'*/ (nonmissing=.) if grew_`cn'==0
}
/*
*all rural households that harvested specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0
}
*/

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


*SAW 4/20/23 Poverty Indicator Updates
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
gen ccf_loc = (1/$Uganda_NPS_W4_inflation) 
lab var ccf_loc "currency conversion factor - 2021 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W4_exchange_rate
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

*Poverty indicators 
gen poverty_under_190 = (daily_percap_cons < $Uganda_NPS_W4_poverty_threshold)
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = (daily_percap_cons < $Uganda_NPS_W4_poverty_215)
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_300 = (daily_percap_cons < $Uganda_NPS_W4_poverty_300)
la var poverty_under_300 "Household per-capita consumption is below $3.00 in 2021 $ PPP"

* Need to figure out National poverty lines for Uganda wave 4
*We merge the national poverty line provided by the World bank "${UGS_W3_raw_data}/AGSEC9"
*merge 1:1 hhid using "${Uganda_NPS_W4_raw_data}/pov2013_14", keep(1 3) nogen
merge 1:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_consumption.dta", keep(1 3) nogen
*gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W1_poverty_nbs
rename poor_13 poverty_under_npl
la var poverty_under_npl "Household per-capita consumption is below national poverty line in 05/06 PPP prices"
*/
*generating clusterid and strataid
gen clusterid=ea
gen strataid=region

*dropping unnecessary varables
//drop *_inter_*

*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh poverty* clusterid strataid *weight* *wgt* region region sregion district county county_name parish parish_name ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* /**total_harv_area**/ /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb* num_crops* /*nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* /*area_harv**/  *value_pro* *value_sal* *inter*
*SAW 3/14/23 Need to check for the ones available in Uganda but not in Nigeria.
*What about harvested_*, 


gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) if ag_hh==1
ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"


//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
//drop HHID
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2013-14" 
gen instrument = 54 
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
saveold "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_household_variables.dta", replace

********************************************************************************
                          *INDIVIDUAL-LEVEL VARIABLES*
********************************************************************************
*SAW 9/29/23 This section uses Uganda Wave 3 as reference
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", clear
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_control_income.dta", keep(1 3) nogen
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_make_ag_decision.dta", keep(1 3) nogen // How are we computing percentages? Do we include all individuals or only the ones that responded the survey section? 
merge 1:1 hhid PID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ownasset.dta", keep(1 3) nogen
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", keep(1 3) nogen
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_fert_use.dta", keep(1 3) nogen
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use.dta", keep(1 3) nogen
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_vaccine.dta", keep(1 3) nogen
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", keep(1 3) nogen

*Land rights
merge 1:1 hhid indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_ind.dta", nogen keep(1 3)
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

//drop HHID
*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.
*foreach c in wheat /*beans*/ {
*	gen all_imprv_seed_`c' = .
*	gen all_hybrid_seed_`c' = .
*	gen `c'_farmer = .
*}

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

gen female_vac_animal=vac_animal if female==1
gen male_vac_animal=all_vac_animal if female==0
lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"

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
ren PID indid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2013-14"
gen instrument = 54
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"

label values instrument instrument	
gen strataid=region
gen clusterid=ea
saveold "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_individual_variables.dta", replace

********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*SAW 10/03/23 This section uses Uganda Wave 3 as reference.
*GENDER PRODUCTIVITY GAP
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", clear
collapse (sum) plot_value_harvest = value_harvest, by(hhid parcel_id plot_id season)
tempfile crop_values 
save `crop_values' // season level

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", clear // plot-season level
merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", keep (1 3) nogen // hh level
merge 1:1 hhid parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", keep (1 3) nogen //  plot-season level
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_days.dta", keep (1 3) nogen  // plot level
//drop HHID 
/*DYA.12.2.2020*/ merge m:1 hhid using  "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region ea)
recode farm_size_agland (.=0) 
gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

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


****Currency Conversion Factors***
gen ccf_loc = (1/$Uganda_NPS_W4_inflation) 
lab var ccf_loc "currency conversion factor - 2021 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W4_exchange_rate
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W4_gdp_ppp_dollar
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
gen strataid=region
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
rename v1 UGA_wave4
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_gendergap.dta", replace

restore

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2013-14" 
gen instrument = 54 
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
saveold "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_field_plot_variables.dta", replace  

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Uganda_NPS_W4"
do "$summary_stats"

************************************ STOP ************************************
