/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 4 (2013-14)

*Author(s)		: Didier Alia, David Coomes, Elan Ebeling, Nina Forbes, Nida
				  Haroon, Conor Hennessy, Marina Kaminsky, Sammi Kiel, Carly 
				  Schmidt, Anu Sidhu, Isabella Sun, Andrew Tomes, Emma Weaver,
				  Ayala Wineman, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the
				  World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI,
				  IRRI, and the Bill & Melinda Gates Foundation Agricultural
				  Development Data and Policy team in discussing indicator
				  construction decisions. 
				  All coding errors remain ours alone.

*Date			: 01 January 2020

----------------------------------------------------------------------------------------------------------------------------------------------------*/


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
* Using data files from within the "\data\uganda-wave4-2013-14-unps" folder, the do.file first constructs common and intermediate variables, 
* saving dtafiles when appropriate in the folder "\output\uganda-wave4-2013-14-unps\temp" 
*
* These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available in the
* folder "\output\uganda-wave4-2013-14-unps". 


* The processed files include all households, individuals, and plots in the sample. Toward the end of the do.file, a block of code estimates summary 
* statistics (mean, standard error of the mean, minimum, first quartile, 
* median, third quartile, maximum) of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.

* The results are outputted in the excel file "Uganda_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "\output\uganda-wave4-2013-14-unps" folder. 


* It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary 
* statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_LSMS_ISA_W4_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_LSMS_ISA_W4_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_LSMS_ISA_W4_hhsize.dta
*PARCEL AREAS						Uganda_NPS_LSMS_ISA_W4_parcel_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W4_plot_decision_makers.dta

*MONOCROPPED PLOTS					Uganda_NPS_LSMS_ISA_W4_[CROP]_monocrop_hh_area.dta					
*TLU (Tropical Livestock Units)		Uganda_NPS_LSMS_ISA_W4_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_LSMS_ISA_W4_tempcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W4_tempcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W4_permcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W4_permcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W4_hh_crop_production.dta
									Uganda_NPS_LSMS_ISA_W4_plot_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W4_parcel_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W4_crop_residues.dta
									Uganda_NPS_LSMS_ISA_W4_hh_crop_prices.dta
									Uganda_NPS_LSMS_ISA_W4_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_LSMS_ISA_W4_wages_mainseason.dta
									Uganda_NPS_LSMS_ISA_W4_wages_shortseason.dta
									Uganda_NPS_LSMS_ISA_W4_fertilizer_costs.dta
									Uganda_NPS_LSMS_ISA_W4_seed_costs.dta
									Uganda_NPS_LSMS_ISA_W4_land_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W4_asset_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W4_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_LSMS_ISA_W4_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_LSMS_ISA_W4_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W4_livestock_expenses.dta
									Uganda_NPS_LSMS_ISA_W4_hh_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W4_livestock_sales.dta
									Uganda_NPS_LSMS_ISA_W4_TLU.dta
									Uganda_NPS_LSMS_ISA_W4_livestock_income.dta

*FISH INCOME						n/a
																	
*SELF-EMPLOYMENT INCOME				n/a

									
*WAGE INCOME						Uganda_NPS_LSMS_ISA_W4_wage_income.dta
									Uganda_NPS_LSMS_ISA_W4_agwage_income.dta					

*OTHER INCOME						Uganda_NPS_LSMS_ISA_W4_other_income.dta
									Uganda_NPS_LSMS_ISA_W4_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_LSMS_ISA_W4_land_size.dta
									Uganda_NPS_LSMS_ISA_W4_farmsize_all_agland.dta
									Uganda_NPS_LSMS_ISA_W4_land_size_all.dta
									Uganda_NPS_LSMS_ISA_W4_land_size_total.dta					

*FARM LABOR							Uganda_NPS_LSMS_ISA_W4_farmlabor_mainseason.dta
									Uganda_NPS_LSMS_ISA_W4_farmlabor_shortseason.dta
									Uganda_NPS_LSMS_ISA_W4_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_LSMS_ISA_W4_vaccine.dta
									Uganda_NPS_LSMS_ISA_W4_farmer_vaccine.dta					//NEW//
							
*ANIMAL HEALTH						Uganda_NPS_LSMS_ISA_W4_livestock_diseases.dta				//NEW//
									Uganda_NPS_LSMS_ISA_W4_livestock_feed_water_house.dta		//NEW//

*USE OF INORGANIC FERTILIZER		Uganda_NPS_LSMS_ISA_W4_fert_use.dta
									Uganda_NPS_LSMS_ISA_W4_farmer_fert_use.dta							//NEW//

*USE OF IMPROVED SEED				Uganda_NPS_LSMS_ISA_W4_improvedseed_use.dta
									Uganda_NPS_LSMS_ISA_W4_farmer_improvedseed_use.dta			//NEW//

*REACHED BY AG EXTENSION			Uganda_NPS_LSMS_ISA_W4_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_LSMS_ISA_W4_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_LSMS_ISA_W4_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W4_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W4_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_LSMS_ISA_W4_hh_rental_rate.dta 			//NEW//
									Uganda_NPS_LSMS_ISA_W4_hh_cost_land.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_inputs_fcs.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_inputs_scs.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_seed_fcs.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_seed_scs.dta	
									Uganda_NPS_LSMS_ISA_W4_asset_rental_costs.dta 			//NEW//
									Uganda_NPS_LSMS_ISA_W4_cropcosts_total.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_LSMS_ISA_W4_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_LSMS_ISA_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_LSMS_ISA_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_LSMS_ISA_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_LSMS_ISA_W4_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_LSMS_ISA_W4_ag_wage.dta					// DOES THIS STILL EXIST?? NOT IN NEWER TZ FILE
*CROP YIELDS						Uganda_NPS_LSMS_ISA_W4_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_LSMS_ISA_W4_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_LSMS_ISA_W4_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_LSMS_ISA_W4_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_LSMS_ISA_W4_hh_assets.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_LSMS_ISA_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_LSMS_ISA_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_LSMS_ISA_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_LSMS_ISA_W4_summary_stats.xlsx
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
global root_folder "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14"
global Uganda_NPS_W4_raw_data "${root_folder}\raw_data"
global Uganda_NPS_W4_created_data "${root_folder}\temp"
global Uganda_NPS_W4_final_data "${root_folder}\outputs"


********************************************************************************
*           EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS              *
********************************************************************************
global UGA_W4_exchange_rate 3689.75      // https://www.bloomberg.com/quote/USDUGX:CUR 										// NKF 12.30.19 - What year? Present?
global UGA_W4_gdp_ppp_dollar 1270.608398 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PPP?locations=UG 
global UGA_W4_cons_ppp_dollar 1221.087646 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG // for 2014 
global UGA_W4_inflation 0.8515721875 //CPI_SURVEY_YEAR/CPI_2017 -> CPI_2014/CPI_2017 ->  142.024166/166.7787747 from https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG  //The data were collected over the period November 2013 - October 2014

global UGA_W4_poverty_threshold (1.90*944.255*(1+(142.024166-116.6)/116.6)) 
global UGA_W4_poverty_threshold (1.90*944.255*142.024166/116.6)

*SAW Notes:  Calculation for WB' previous $1.90 (PPP) poverty threshold, 2185.2775 Uganda Shilling UGX. This is calculated as the following: PovertyLine x PPP conversion factor (private consumption)t=2011 (reference year of PL, therefore 2011. This is fixed across waves so no need to change it) x Inflation(from t=2011 to t+1=last year survey was implemented). Inflation is calculated as the following: CPI Uganda inflation from 2011 (baseline year) to 2014 (last survey year) Inflation = Inflation (t=last survey year =2014)/Inflation (t= baseline year of PL =2011) https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG&name_desc=false and https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG

global UGA_W4_poverty_215 2.15*($UGA_W4_inflation) * $UGA_W4_cons_ppp_dollar
 
*SAW Now: The $2.15 Poverty line ($US) is converted to Uganda Shillings using the PPP Conversion Factor, Consumption of 2017 (so we get the value in UGX 2017) and then we deflate this value to the last year of the survey implementation 2014. Thr 2.15 PL is 2235.6652 UGX (2017) Notes: This time we had to deflate since our cpp was in 2017 but the last year of the survey was 2014, for the 2011 1.90 poverty line we had to inflate given that the baseline year was 2011 but the last year of the survey was 2012. 

*The national poverty line is merged later since it's already provided by the raw data (Also there npl has variation across regions so it's not a single number)


********************************************************************************
*					THRESHOLDS FOR WINSORIZATION							   *
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
 * RE-SCALING SURVEY WEIGHTS TO MATH POPULATION ESTIMATES *
********************************************************************************
/*
*1.5.23 SAW Might need to do this at some point. Below NGA Wave 3 Reference. 
*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Nigeria_GHS_W3_pop_tot 181137448
global Nigeria_GHS_W3_pop_rur 94484916
global Nigeria_GHS_W3_pop_urb 86652532
*/

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
*SAW 6.15.22 All cropID match with UG w5 except for banana which has 3 different typesof crops banana food 741 banana beer 742 banana 744. Need to compile all 3 into one category.

********************************************************************************
*                                HOUSEHOLD IDS                                 *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC1.dta", clear
*gen hhid=substr(hh, 1, 6) + substr(hh, 11, 2)
ren h1aq1a district 
ren h1aq3a county
ren h1aq3b county_name
ren h1aq4a parish
ren h1aq4b parish_name 
ren wgt_X weight //wgt_X  is cross-sectional weight for UNPS 2013-2014, applies to all respondents, alternative variable wgt only applies to those interviewed in previous waves
gen rural=urban==0
keep HHID region sregion district county county_name parish parish_name ea weight rural
lab var rural "1=Household lives in a rural area"
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta", replace

********************************************************************************
*WEIGHTS*
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC1.dta", clear
ren wgt_X weight
merge m:1 HHID using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta"
keep HHID weight rural
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_weights.dta", replace

********************************************************************************
*								INDIVIDUAL IDS								   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC2.dta", clear

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
keep indiv HHID female age hh_head individ PID
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_person_ids.dta", replace

********************************************************************************
*								HOUSEHOLD SIZE								   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\hh\GSEC2.dta", clear
gen hh_members = 1
ren h2q4 relhead 
ren h2q3 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (HHID)	
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhsize.dta", replace

********************************************************************************
** GEOVARIABLES **
********************************************************************************
*SAW 4/24/23 Updates based on CSIRO data request.
*SAW 7/31/23 No geovariables currently available. Must redownload World Bank data to check whether it's been updated. 

********************************************************************************
*PLOT AREA* (Wave 3 Version)
********************************************************************************
*SW: We create Plot Area based on Uganda Wave 3 to be able to use this section on later sections easily. 
*SAW 7/31/23 Notes: There is no need to estimate plot size since information is plot size is already available (in contrast to wave 3)
*Final Dataset: Plot season level information. 
*List of variables we need: HHID parcel_id plot_id season ha_planted plot_area total_plot_area parcel_acre field_size (parcel_ha = parcel_area not sure if it the same)
*Missing: ha_planted parcel_acre 
/* Plot Area Section: The purpose of this section is to estimate field size at the plot level - right now, we have estimates of field size at the parcel level (2A and 2B). We calculate the plot area planted as as percentage of total area planted at the parcel level, and we use those percentages to estimate the field size at the plot level. */

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta", generate(last)		
replace season=2 if season==.
label var season "Season = 1 if 1st cropping season of 2011, 2 if 2nd cropping season of 2011"
rename HHID hhid2
rename hh HHID
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
bys HHID parcelID plotID season : egen total_percent_planted = sum(percent_planted) //generate variable for total percent of a plot that is planted (all crops)
duplicates tag HHID parcelID plotID season, g(dupes) //generate a duplicates ratio to check for all crops on a specific plot. the number in dupes indicates all of the crops on a plot minus one (the "original")
gen missing_ratios = dupes > 0 & percent_planted == . //now use that duplicate variable to find crops that don't have any indication of how much a plot they take up, even though there are multiple crops on that plot (otherwise, duplicates would equal 0)
bys HHID parcelID plotID season : egen total_missing = sum(missing_ratios) //generate a count, per plot, of how many crops do not have a percentage planted value.
gen remaining_land = 1 - total_percent_planted if total_percent_planted < 1 //calculate the amount of remaining land on a plot (that can be divided up amongst crops with no percentage planted) if it doesn't add up to 100%
bys HHID parcelID plotID season : egen any_missing = max(missing_ratios)
*Fix monocropped plots
replace percent_planted = 1 if percent_planted == . & any_missing == 0 //monocropped plots are marked with a percentage of 100% - impacts 5,244 crops
*Fix plots with or without missing percentages that add up to 100% or more
replace percent_planted = 1/(dupes + 1) if any_missing == 1 & total_percent_planted >= 1 //If there are any missing percentages and plot is at or above 100%, everything on the plot is equally divided (as dupes indicates the number of crops on that plot minus one) - this impacts 9 crops
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1 //some crops still add up to over 100%, but these ones aren't missing percentages. So we need to reduce them all proportionally so they add up to 100% but don't lose their relative importance.
*Fix plots that add up to less than 100% and have missing percentages
replace percent_planted = remaining_land/total_missing if missing_ratios == 1 & percent_planted == . & total_percent_planted < 1 //if any plots are missing a percentage but are below 100%, the remaining land is subdivided amonst the number of crops missing a percentage - impacts 205 crops

*Bring everything together
collapse (max) ha_planted (sum) percent_planted, by(HHID parcelID plotID season)
gen plot_area = ha_planted / percent_planted
bys HHID parcelID season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep HHID parcelID plotID season plot_area total_plot_area plot_area_pct ha_planted
rename HHID hh
merge m:1 hh parcelID using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", nogen
merge m:1 hh parcelID using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta"
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
rename HHID hhid2
rename hh HHID
keep HHID parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size == .
label var field_size "Area of plot (ha)"
label var HHID "Household identifier"
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_plot_areas.dta", replace

********************************************************************************
*PLOT AREAS // need to separate plot area from parcel area
********************************************************************************
*SAW: Old Version of PLot Area (Keeping it here for future reference or if we need to go back)
/*
* plot area cultivated
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta", gen (last)		
replace season = 2 if last==1
label var season "Season = 1 if 2nd cropping season of 2012, 2 if 1st cropping season of 2013" // need to check again

ren HHID hhid
ren hh HHID
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==.| plot_id==.
ren cropID crop_code_master
drop if crop_code_master == .
gen cropcode = crop_code_master 
recode cropcode (811 812 = 810) (741 742 744 = 740) (221 = 222) (224 = 223)
gen plot_area = a4aq7  //values are in acres
replace plot_area = a4bq7 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
collapse (sum) plot_area, by (HHID parcel_id plot_id season)
bys HHID parcel_id season : egen total_plot_area = sum(plot_area)
gen plot_area_pct = plot_area/total_plot_area
keep HHID parcel_id plot_id season plot_area total_plot_area plot_area_pct
tempfile plarea
save `plarea'

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta", gen (last)		
replace season = 2 if last==1
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
merge 1:m HHID parcel_id season using `plarea', nogen
drop if plot_id==.

*generating field_size
gen parcel_area = a2aq4  
replace parcel_area = a2bq4 if parcel_area == . 
replace parcel_area = a2aq5 if parcel_area == . // 966 values input from farmer estimates (introduces noise in later analysis)
replace parcel_area = a2bq5 if parcel_area == . // 538 changes
gen field_size = plot_area_pct*parcel_area //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size/2.471 //convert acres to hectares

*cleaning up and saving the data
*keep HHID parcel_id plot_id season field_size
drop if field_size == .
label var field_size "Area of plot (ha)"
label var HHID "Household identifier"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", replace

* create hh total parcel size 
ren field_size area_acres_meas
collapse (sum) area_acres_meas, by (HHID parcel_id)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", replace

**************
*AREA PLANTED*
**************
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A", clear 
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B"
replace season = 2 if season == .
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==.| plot_id==.
ren cropID crop_code_master
	drop if crop_code_master == .
	gen cropcode = crop_code_master 
	recode cropcode (811 812 = 810) (741 742 744 = 740) (221 = 222) (224 = 223)
drop if parcel_id == .| plot_id ==. 
	bys HHID cropcode parcel_id plot_id season: gen nobs=_N
	quietly by HHID cropcode parcel_id plot_id season: gen dup=cond(_N==1,0,_n)
	drop if dup>1
	drop nobs dup 
// check variable for cultivated
gen plot_ha_planted = a4aq7*(1/2.47105)
replace plot_ha_planted = a4bq7*(1/2.47105) if plot_ha_planted==.

* introduce area in ha 
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3)
			   
*Adjust for inter-croppinp
gen per_intercropped=a4aq9
replace per_intercropped=a4bq9 if per_intercropped==.  // ta a4bq9  - no obs. No intercropping in second season/visit? 
gen  is_plot_intercropped=a4aq8==2 | a4bq8==2
replace is_plot_intercropped=1 if per_intercropped!=.  // 11 changes //EFW 6.2.19 0 changes in this code. Why 11 in Didier code??
*Scale down percentage
bys  HHID parcel_id plot_id: egen total_percent_planted = total(per_intercropped) if is_plot_intercropped==1 
replace plot_ha_planted=plot_ha_planted if is_plot_intercropped==0
replace plot_ha_planted=plot_ha_planted*(per_intercropped/total_percent_planted) if is_plot_intercropped==1 
*Now sum area planted for sub-plots should not exceed field size. If so rescal proportionally including for monocrops
bys  HHID parcel_id: egen total_ha_planted = total(plot_ha_planted)
replace plot_ha_planted=plot_ha_planted*(field_size/total_ha_planted) if total_ha_planted>field_size & total_ha_planted!=.
gen  ha_planted=plot_ha_planted 
keep HHID parcel_id plot_id crop_code_master season cropcode plot_ha_planted field_size per_intercropped is_plot_intercropped total_ha_planted ha_planted
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_area_planted_temp.dta", replace
*/
********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC2.dta", clear
//PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P0" and the "-"
destring PID, gen(personid) ignore ("P" "-") 
gen female=h2q3==2 
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "indivdual age"
gen head=h2q4==1 // SAK 2019-07-08: There is one Household with two heads. As
					// a group we need to decide how to handle this.
lab var head "1= individual is household head"
ren h2q1 individ //2013/14 roster number // need the roster number for formal land rights 
keep personid female age HHID head individ
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_gender_merge.dta", replace

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta" 
replace season = 2 if season == .
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
ren plotID plot_id

***drop if ag3b_03==. & ag3a_03==. 
***replace cultivated = 1 if  ag3b_03==1 

*First decision-maker variables 
gen indiv = a3aq3_3
replace indiv = a3aq3_4a if indiv ==. & a3aq3_4a!=.
replace indiv=a3bq3_3 if indiv ==. & a3bq3_3!=.
replace indiv=a3bq3_4a if indiv ==. & a3bq3_4a!=.

merge m:1 HHID indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", gen(dm1_merge) keep(1 3) 		// Dropping unmatched from using
gen dm1_female = female
drop female indiv

* multiple decision makers // a3aq3_2, 
gen dm_gendermult=a3aq3_2==2
replace dm_gendermult=a3bq3_2==2 if dm_gendermult==0

*Second decision-maker variables // ,    
gen indiv = a3aq3_4b
replace indiv = a3bq3_4b if indiv == . &  a3bq3_4b != .
merge m:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using
gen dm2_female = female
drop female indiv

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep HHID parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 3 if dm_gender == . & dm1_female == . & dm_gendermult==1 //no mixed-gender managed plots
label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhsize.dta", nogen
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . 
keep HHID parcel_id plot_id season dm_gender fhh //***cultivated, also plotname was here but is not a variable in this wave
***lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS*
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
ren HHID hhid
    ren hh HHID
    ren parcelID parcel_id
    drop if parcel_id==.
gen formal_land_rights=(a2aq23==1 | a2aq23==2 | a2aq23==3) //hh has certificate/ title, certificate of customary ownership, or certificate of occupancy


*Starting with first owner
preserve
	ren a2aq26a indiv
	merge m:1 HHID indiv using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_person_ids.dta" //, nogen keep(3) //keep only matched
	keep HHID indiv female formal_land_rights
	tempfile p1
	save `p1', replace
restore

*Now second owner
preserve
	ren a2aq26b indiv
	recode indiv (99999999=.)
	merge m:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta" //, nogen keep(3)	//keep only matched 
	keep HHID indiv female formal_land_rights
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 if female==1
	collapse (max) formal_land_rights_f, by(HHID indiv)		
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_ind.dta", replace
restore	

preserve
	collapse (max) formal_land_rights_hh=formal_land_rights, by(HHID)	// taking max at household level; equals one if they have official documentation for at least one plot
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_hh.dta", replace
restore

********************************************************************************
** 								ALL PLOTS 2.0 Version						  **
********************************************************************************
/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Sebastian Idea of All Plots:
Using : 5A and 5B Quantification of production 
**Section 1: Crop Value **
1. We calculate the Price Unit variable (Average sold value per kg of harvest sold) ($Sold value/Crop sold converted to kgs = sold_value/(sold_qty*conv_factor_sold)) by using the Sold conversion factor (Raw variable not the calculated median), sold quantity, and value of crop sold.
1.1 [/Uganda_NPS_LSMS_ISA_W3_crop_value.dta] Variables created: A) Crop Harvest: Condition crop harvested, unit code of crop harvested, conversion factor of crop harvested.
B) Crop Sold: Unit code of crop sold, conversion factor crop sold (No information on condition crop sold)
C) Price unit ($Sold value/Crop sold converted to kgs = sold_value/(sold_qty*conv_factor_sold)).
D) Median Price Unit: For each crop for each geographic location: region, district, county, subcounty, parish, ea, and HHID, and national level (Not including the Unit code of crop sold given that crops are already comparable using the raw sold conversion factor (not the median sold conversion factor))

**Section 2: Plot Variables **
Using : 4A and 4B Quantification of production 
1. Plot Variables:[This old section is very messy, need to work on it] 
2. Variables created: Time of crop planting (year and month), permanent crop, purestand, monocrop/intercrop indicator, 

C) Unit of analysis: crop value dataset is at the plot crop type, condition and unit type season level.
2. We calculate the median Price Unit for each crop for each geographic location: region, district, county, subcounty, parish, ea, and HHID, and national level
3. We calculate the median crop conversion factor for by crop, condition of crop harvested, and unit code of crop harvested. 
4. We calculate the median value of supplied conversion factor by crop type sold, and unit code of crop sold (condition of crop sold not available). The missing condition of crop sold might explain the differences in conversion factors for same crop type and sold unit code. Then, why would we calculate the median after using the sold conversion factors to calculate the price unit? 
Using : 4A and 4B Quantification of production 
5. Plot Variables:[This old section is very messy, need to work on it] Time of crop planting (year and month), permanent crop, purestand, monocrop/intercrop indicator, 
6. Estimating Area planted at the plot level (only available at the parcel level) by using 

*Meeting with Peter: We need to use the actual conversion factor sold and conversion factor harvest variables instead of the MEDIAN conversion factors (both sold and harvested)

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.
*/

**********************************
** Crop Values **
**********************************
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season == .
gen condition_harv=a5aq6b
replace condition_harv =  a5bq6b if condition_harv==.
gen unit_code_harv=a5aq6c
replace unit_code_harv = a5bq6c if unit_code_harv==.
gen conv_factor_harv=a5aq6d
replace conv_factor_harv=a5bq6d if conv_factor_harv==.
replace conv_factor_harv = 1 if unit_code_harv==1

*Unit of crop Sold
gen sold_unit_code=a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
gen sold_value = a5aq8
replace sold_value=a5bq8 if sold_value==.
clonevar conv_factor_sold = a5aq7d
replace conv_factor_sold=a5bq7d if conv_factor_sold==.
gen sold_qty=a5aq7a
replace sold_qty=a5bq7a if sold_qty==.
gen quant_sold_kg = sold_qty*conv_factor_sold 


*Notes: We do have condition/state and unit code of crop harvest, but we only have Unit of crop sold (no condition_sold) and kg conversion factor for sold quantities. 
*Notes: Checking for consistency of conversion factors for crop harvested: (There are some differences per same crop condition_harv, and unit_code_harv)
*Notes: Checking for consistency of conversion factors for crop sold: (There are some differences per same crop type, and unit_code_harv) same if we include condition_harvested. This variation might be explained by the missingi information on condition crop sold. 
rename HHID Hhid
rename hh HHID
*tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
*rename HHID hhid
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master

**********************************
** Standard Conversion Factor Table **
**********************************
*SAW: 7.24.23 This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold 
*rename cropID crop_code_harvest
*clonevar  unit_code= unit_code_harv
*clonevar crop_code = cropID

***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
*merge m:1 crop_code sold_unit_code region using "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_sold_table.dta", keep(1 3) nogen 
merge m:1 crop_code sold_unit_code region using  "${Uganda_NPS_W4_created_data}\UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
*merge m:1 crop_code sold_unit_code  using "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_W4_created_data}\UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 *We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. // SAW 7/25/23 We merge the national standard conversion factor for those HHID with missing regional info. 
gen s_quant_sold_kg = sold_qty*s_conv_factor_sold
replace s_quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen s_price_unit = sold_value/s_quant_sold_kg 
gen obs1 = s_price_unit!=.


//SAW 7/24/23 Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standar conversion factor table)
	foreach i in region district county /*subcounty*/ parish ea HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen s_obs_`i'_price = sum(obs1)
		collapse (median) s_price_unit_`i' = s_price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' s_obs_`i'_price)
		*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
		tempfile s_price_unit_`i'_median
		save `s_price_unit_`i'_median'
		*save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\Price per kg methodology\s_price_kg_`i'_median.dta", replace
		restore
	}
	preserve
	collapse (median) s_price_unit_country = s_price_unit (sum) s_obs_country_price = obs1 [aw=weight], by(crop_code /*sold_unit_code*/)
	*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
	tempfile s_price_unit_country_median
	save `s_price_unit_country_median'
	*save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\Price per kg methodology\s_price_kg_national_median.dta", replace
	restore

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
*merge m:1 crop_code unit_code region using "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 
merge m:1 crop_code unit_code region using "${Uganda_NPS_W4_created_data}\UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 


***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
*merge m:1 crop_code unit_code using "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
merge m:1 crop_code unit_code using "${Uganda_NPS_W4_created_data}\UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
*This is for HHID that are missing regional information


*SAW 5/23/23 From Conversion factor section to calculate medians
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity_harv==.
gen quant_harv_kg = quantity_harv*conv_factor_harv 
replace s_conv_factor_harv = sn_conv_factor_harv if region!=. //  SAW 7/25/23 We merge the national standard conversion factor for those HHID with missing regional info.
gen s_quant_harv_kg = quantity_harv*s_conv_factor_harv 

*Notes: There are many observations who harvested but do not have s_conversion factors harvest given that they are missing the region variable (Need to fix this) One option would be to calculate national level median conversion factors -both harvested and sold - and assign those values to HHID with missing region information.

*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg  that using the WB conversion factors -though there are many cases that standard qty harvested is smaller than the WB qty harvested. 
*Notes: Should we winsorize the sold qty ($) prior to calculating the price per kg giventhis variable is also driving the variation and has many outliers. Though, it won't affect themedian price per kg it will affect the  price per unit for all the observations that do have sold harvested affecting the value of harvest. 

**********************************
**  SAW 7.24.23 Update: Standard Conversion Factor Table END **
**********************************
 *SAW 4/10/23: We do not have information about the year of harvest. Questionnaire references the variable to year 2011 and we have information on month of harvest start and month of harvest end.
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

*SAW 5/19/23 Create Price unit for converted sold quantity (kgs)
gen price_unit=sold_value/(quant_sold_kg)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=.
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
	
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_value.dta", replace
*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested*/

//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.

	foreach i in region district county /*subcounty*/ parish ea HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' obs_`i'_price)
		*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		*save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\Price per kg methodology\price_kg_`i'_median.dta", replace
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code /*sold_unit_code*/)
	*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
	tempfile price_unit_country_median
	save `price_unit_country_median'
	*save "R:\Project\EPAR\Working Files\RA Working Folders\Sebastian\Uganda Conversion Factor\Price per kg methodology\price_kg_national_median.dta", replace
	restore

**********************************
** [Harvest and Sold] Crop Unit Conversion Factors  **
**********************************
*Notes: This section was used to calculate the median crop unit conversion factors for harvest and sold variables. Now, we will use the raw variable from the World bank.
*SAW:  Methodological decisions NOTES: Should we create the Price Unit - and the median price units by location - by converting the Sold quantities to kg units using the median conversion factor sold instead of the Given values for each observation (which we know have variation across same unit of analysis (crop type and unit code sold))

**********************************
** Plot Variables **
**********************************
*SW 28.06.22 
*SAW: Onlys focus on the following Variables that we can construct with 4A and 4B only that we are looking for: Date planted, permanent crops,  intercropped/monocropped, purestand, just focus on those.
preserve	
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta"
replace season=2 if season==.
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code_plant //crop codes for what was planted
drop if crop_code_plant == .
clonevar crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
recode crop_code_master (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code_master cropID //apply crop labels to crop_code_master
rename HHID Hhid
rename hh HHID
*Merge area variables (now calculated in plot areas section earlier)
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3)	

*Creating time variables (month planted, harvested, and length of time grown)
*gen month_planted = Crop_Planted_Month 
*gen year_planted = 2010 if Crop_Planted_Year==1 | (Crop_Planted_Year2==1 & season==2)
*replace year_planted= 2011 if Crop_Planted_Year==2 | (Crop_Planted_Year2==2 & season==2)

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

gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?
duplicates drop HHID parcel_id plot_id crop_code season, force
tempfile plotplanted
save `plotplanted'
restore
merge m:1 HHID parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3)

**********************************
** Plot Variables After Merge **
**********************************
*SAW 4/24/23 Update 
gen months_grown1 = harv_date - plant_date if perm_tree==0
*replace harv_date = ym(2012,month_harv_date) if months_grown1<=0
gen months_grown = harv_date - plant_date if perm_tree==0

*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(a5aq17,1,5) | inrange(a5bq17,1,5) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
		collapse (sum) crops_plot = obs2, by(HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen
	*drop if hh_agric == .
	gen contradict_mono = 1 if a4aq9 == 100 | a4bq9 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if a4aq9 == 100 | a4aq8 == 1 | a4bq9 == 100 | a4bq8 == 1 //meanwhile 145 list intercropping or mixed cropping but only report one crop

*Generate variables around lost and replanted crops
	gen lost_crop = inrange(a5aq17,1,5) | inrange(a5bq17,1,5) // SAW I think it should be intange(var,1,5) why not include "other"
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	/*gen month_lost = month_planted if lost_crop==1 
	gen month_kept = month_planted if lost_crop==0
	bys hhid plot_id : egen max_month_lost = max(month_lost)
	bys hhid plot_id : egen min_month_kept = min(month_kept)
	gen replanted = (max_lost==1 & crops_plot>0 & min_month_kept>max_month_lost)*/ //Gotta filter out interplanted. //JHG 1_7_22: should I keep this code that's been edited out from Nigeria code?
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.

	*Generating monocropped plot variables (Part 1)
	bys HHID parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys HHID parcel_id plot_id season : egen permax = max(perm_tree)
	bys HHID parcel_id plot_id season a5aq6e a5aq6e_1 a5bq6e a5bq6e_1 : gen plant_date_unique = _n
	*replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis SAW No Unknow planting dates
	bys HHID parcel_id plot_id season a5aq6e a5bq6e : gen harv_date_unique = _n // SAW harvest was all in the same year (2011)
	bys HHID parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys HHID parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (a4aq8 == 2 | a4bq8 == 2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	/*replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 //JHG 1_14_22: 8 replacements, all of which report missing crop_code values. Should all missing crop_code values be dropped? If so, this should be done at an early stage.
	//I dropped the values after the latest merge above, and there were zero replacements for this line of code. No relay cropping?
	gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 */
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 SAW Should we assume null values are intercropped?  or maybe missing information??
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	*NEW SAW 8/1/23 START 
/*
*Create area variables
	ren a4aq7 acre_planted_s1  //s1 = season 1
	gen ha_planted_s1 = acre_planted_s1 * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
	label var ha_planted_s1 "Hectares planted per-plot in the last cropping season of 2014"
	ren a4bq7 acre_planted_s2 //s2 = season 2
	gen ha_planted_s2 = acre_planted_s2 * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
	label var ha_planted_s2 "Hectares planted per-plot in the first cropping season of 2015"
	merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) // terrible merge, only 1325 matched
	replace ha_planted_s1 = field_size * a4aq9 / 100 if a4aq9 != . & a4aq9 != 0  
	replace ha_planted_s2 = field_size * a4bq9 /100 if a4bq9 != . & a4bq9 != 0 
 	gen ha_planted = ha_planted_s1
	replace ha_planted = ha_planted_s2 if ha_planted == . 
	*NEW SAW 8/1/23 END
*/	
		/*JHG 1_14_22: Can't do this section because no ha_harvest information. 1,598 plots have ha_planted > field_size
	Okay, now we should be able to relatively accurately rescale plots.
	replace ha_planted = ha_harvest if ha_planted == . //X # of changes
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. //X# of changes */
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys HHID parcel_id plot_id season: egen total_percent = total(percent_field)
//about 25% of plots have a total intercropped sum greater than 1
//about 265 of plots have a total monocropped sum greater than 1

	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
		replace ha_planted = percent_field*field_size
		
	//8568 changes made

	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey
**********************************
** Crop Harvest Value **
**********************************
*SAW 6/27/23 Update Incorporating median price per kg to calculate Value of Harvest ($) -using WB Conversion factors 
foreach i in  region district county /*subcounty*/ parish ea HHID {	
	merge m:1 `i' /*unit_code*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_code*/ crop_code using `price_unit_country_median', nogen keep(1 3)
}
rename price_unit val_unit

*SAW 7/24/23 Update: Incorporating median standard price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors 
foreach i in  region district county /*subcounty*/ parish ea HHID {	
	merge m:1 `i' /*unit_code*/ crop_code using `s_price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_code*/ crop_code using `s_price_unit_country_median', nogen keep(1 3)
}
rename s_price_unit s_val_unit

*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
recode obs_* (.=0) //ALT 
foreach i in country region district county /*subcounty*/ parish ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	*replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .
/*
foreach i in country region district county subcounty parish ea { //JHG 1_28_22: is this filling in empty variables with other geographic levels?
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_HHID if val_unit_HHID != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_HHID if val_kg_HHID != . //Preferring household values where available.
*/
gen value_harvest = val_unit*quant_harv_kg 
*SAW 7/19/23 Checking the difference in price unit at the crop-unit level for different methodologies. 
*collapse (mean) mean_val_unit = val_unit mean_value_harvest = value_harvest mean_quant_harv_kg = quant_harv_kg (median) median_val_unit = val_unit median_value_harvest = value_harvest median_quant_harv_kg = quant_harv_kg, by(crop_code unit_code_harv)

* SAW 7/24/23 Generate a definitive list of value variables: Same as above but using the standard price per kg instead of the wb price per kg
recode s_obs_* (.=0) //ALT 
foreach i in country region district county /*subcounty*/ parish ea {
	replace s_val_unit = s_price_unit_`i' if s_obs_`i'_price > 9
	*replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen s_val_missing = s_val_unit == .
	replace s_val_unit = s_price_unit_HHID if s_price_unit_HHID != .

gen s_value_harvest = s_val_unit*s_quant_harv_kg 


preserve
	ren unit_code_harv unit
	collapse (mean) val_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_for_wages.dta", replace
restore

*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field s_quant_harv_kg s_value_harvest (max) months_grown plant_date harv_date harv_end, by(region district county /*subcounty*/ parish ea HHID parcel_id plot_id season crop_code_master purestand field_size /*month_planted month_harvest*/)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace
********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************

********************************************************************************
** 								GROSS CROP REVENUE (OLD)			          **
********************************************************************************
**Crop Sales**
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season == .
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==.| plot_id==.
ren cropID crop_code_master
drop if crop_code_master == .
recode crop_code_master (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).

rename a5aq6a qty_harvest 
replace qty_harvest = a5bq6a if qty_harvest==. 
rename a5aq6d conversion
replace conversion = a5bq6d if conversion==. & a5bq6d!=.
gen kgs_harvest = qty_harvest * conversion

ren a5aq7a qty_sold 
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 

*Calculate kgs sold 
ren a5aq7d conversion_sold
replace conversion_sold = a5bq7d if conversion_sold == . 
gen kgs_sold = qty_sold * conversion_sold
ren a5aq8 value_sold
replace value_sold = a5bq8 if value_sold == . 
collapse (sum) kgs_harvest kgs_sold value_sold qty_sold, by (HHID parcel_id plot_id crop_code)
lab var kgs_harvest "Kgs harvest of this crop"
lab var kgs_sold "Kgs sold of this crop"
lab var value_sold "Value sold of this crop"

*Price per kg
gen price_kg = value_sold/kgs_sold
lab var price_kg "price per kg sold"
recode price_kg (0=.)
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_sales.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_sales.dta", clear
gen observation = 1
*bys region district county subcounty parish ea crop_code: egen obs_ea = count (observation)
 
	foreach i in region district county /*subcounty*/ parish ea HHID {
bys `i' crop_code: egen obs_`i'=count(observation)
preserve
collapse (median) price_kg_median_`i' = price_kg [aw=weight], by (`i' crop_code obs_`i')
lab var price_kg_median_`i' "Median price per kg for this crop in the `i'"
lab var obs_`i' "Number of sales observations for this crop in the `i'  area"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_`i'.dta", replace

restore
	}
	bys crop_code: egen obs_country = count (observation)
collapse (median) price_kg_median_country = price_kg [aw=weight], by(crop_code obs_country)
lab var price_kg_median_country "Median price per kg for this crop in the country"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_sales.dta", clear
	foreach i in region district county /*subcounty*/ parish ea HHID {
merge m:1 `i' crop_code using"${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_`i'.dta", nogen
	}	
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_country.dta", nogen
gen price_kg_hh = price_kg

	foreach i in HHID ea parish /*subcounty*/ county district region country {
replace price_kg = price_kg_median_`i' if price_kg==. & obs_`i'>=10 & crop_code!=890
lab var price_kg "Price per kg, with missing values imputed using local median values"
	}

//Computing value harvest as price_kg * kgs_harvest as done in Ethiopia baseline
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=.  //This instrument doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_values_tempfile.dta", replace

preserve
recode value_harvest_imputed value_sold kgs_harvest qty_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest qty_sold, by(HHID crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production"
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
lab var kgs_harvest "Kgs harvested of this crop"
ren qty_sold kgs_sold
lab var kgs_sold "Kgs sold of this crop"
tostring HHID, format(%18.0f) replace
clonevar crop_code = crop_code_master 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", replace
restore

*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested  
collapse (sum) value_harvest_imputed value_sold, by (HHID)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. //changes made
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household responses for value of crop production sold. This is used to calculate a price per kg and then multiplied by the kgs harvested.
*Prices are imputed using local median values when there are no sales.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_production.dta", replace

*Plot value of crop production
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_values_tempfile.dta", replace
collapse (sum) value_harvest_imputed, by (HHID parcel_id plot_id) 
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cropvalue.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_sales.dta", clear

foreach i in region district county /*subcounty*/ parish ea HHID {
merge m:1 `i' crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_`i'.dta", nogen
	}
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_country.dta", nogen

	foreach i in ea parish /*subcounty*/ county district region country HHID {
replace price_kg = price_kg_median_`i' if price_kg==. & obs_`i'>=10 & crop_code!=890
lab var price_kg "Price per kg, with missing values imputed using local median values"
	}
gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=.  //This instrument doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
*keep HHID crop_code price_kg
*duplicates drop 
recode price_kg (.=0)
collapse (mean) price_kg, by (HHID crop_code) 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_prices.dta", replace

*Crops lost post-harvest // Construct this as value crop production * percent lost similar to Ethiopia waves
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season == .
ren parcelID parcel_id
ren plotID plot_id
clonevar crop_code_master=cropID
drop if crop_code==.
rename HHID Hhid
rename hh HHID
rename a5aq16 percent_lost
replace percent_lost = a5bq16 if percent_lost==. & a5bq16!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
tostring HHID, format(%18.0f) replace
merge m:1 HHID crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_losses.dta", replace

********************************************************************************
** 								GROSS CROP REVENUE	 (NEW)						  **
********************************************************************************
*SW 10.9.23 This Gross Crop Revenue section is coded based on most updated version of Uganda Wave 3 which uses the Prices per kg Methodology with Standardized conversion factor tables.
*Temporary crops (both seasons)
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B.dta"
rename parcelID parcel_id
rename plotID plot_id
ren cropID crop_code 
rename HHID hhid2
rename hh HHID
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
drop if plot_id == . 
ren a5aq8 value_sold
replace value_sold = a5bq8 if value_sold == . 
recode value_sold (.=0)
ren a5aq7a qty_sold 
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 
gen sold_unit_code=a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using  "${Uganda_NPS_W4_created_data}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_W4_created_data}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 
*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = qty_sold*s_conv_factor_sold
collapse (sum) value_sold kgs_sold, by (HHID crop_code)
lab var value_sold "Value of sales of this crop"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropsales_value.dta", replace


use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace
ren crop_code_master crop_code
collapse (sum) s_value_harvest s_quant_harv_kg quant_harv_kg , by (HHID crop_code) 
merge 1:1 HHID crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropsales_value.dta"
replace s_value_harvest = value_sold if value_sold>s_value_harvest & value_sold!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value_sold value_crop_sales 
recode  s_value_harvest value_crop_sales  (.=0)
collapse (sum) s_value_harvest value_crop_sales kgs_sold s_quant_harv_kg quant_harv_kg, by (HHID crop_code)
ren s_value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", replace

//Legacy code 
collapse (sum) value_crop_production value_crop_sales, by (HHID)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B.dta"
rename parcelID parcel_id
rename plotID plot_id
ren cropID crop_code 
rename HHID hhid2
rename hh HHID
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
drop if crop_code==.
rename a5aq16 percent_lost
replace percent_lost = a5bq16 if percent_lost==. & a5bq16!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
merge m:1 HHID crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_losses.dta", replace

********************************************************************************
** 								CROP EXPENSES								  **
******************************************************************************** 
*SAW 30.6.22 The old version of Uganda W3 does not seem to have anything similar to what Crop Expenses section should look like. We will use Josh coding as reference - that uses Nieria Wave 3 as reference itself. 

*JHG 5_3_22: I am going to copy in chunks of Nigeria W3 code at a time and work on them. It is waaaaaay longer than the code that was originally here, so I'm not sure all of it will be relevant. We'll see. Anyways, this is the beginning of the Nigeria W3 code.

//ALT 05.05.21: New labor module. The old one was unwieldy and I'm pretty sure values were still getting dropped. This is better. And I need it for agquery.
//New file structure (transformed into whatever we need for the rest of the code to run using reshape wide) | hhid | plotid | dm_gender | season | labor type | worker gender | days worked | price of labor | value of labor |
//This cuts down 400+ lines into ~100 lines and saves repetition of labor variables elsewhere.
//ALT 05.07.21: Now new module for all crop expenses.

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
/*
*SAW 1/3/23 I will do Hired Labor again given that wagehired gives the total wages payed for the total number of days worked hired and not wages per day for each men, women, or children. Notes: 1. I created a variable of total persondays hired by adding dayshiredmale, dayshiredfemale and dayshiredchild. 2. I created a variable of wages per person per day by dividing the wageshired variable -which represent the total amount of hired labored payed for all person-days irrespective of the gender - by totaldayshired. 3. I assigned the new wages per person-day to each gender that worked in that particular household, so if both women and men work in that particular hh, parcel, plot they will be assigned the same wage, since we cannot differentiate between the wages payed for each particular gender. 
*NOTE: OLD VERSION OF HIRED LABOR CAN BE FOUND IN OLDER DO-FILES. */

*********************************
* 		 HIRED LABOR			*
*********************************

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
rename HHID Hhid
rename hh HHID
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

keep HHID parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

* 6.30.22 SAW We need to drop duplicates in order to conduct the following code reshape 6 observations droped
duplicates drop HHID parcel_id plot_id season, force
reshape long dayshired wagehired, i(HHID parcel_id plot_id season) j(gender) string
reshape long days wage, i(HHID parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0
/*replace wage = wage/number //ALT 08.16.21: The question is "How much did you pay in total per day to the hired <laborers>." For getting median wages for implicit values, we need the wage/person/day*/
* 6.30.22 SAW  "How much did you pay including the value of in-kind payments for these days of labor?" Not 100% sure this is the same as what is mentioned above. Maybe the variable wagehired is for total? Might want to check Uganda wages to see if it's payment per day per perosn or for the total number of days... 
gen val = wage*days
tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district county /*subcounty*/ parish ea HHID {
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
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
rename HHID Hhid
rename hh HHID
ren plotID plot_id
ren parcelID parcel_id
rename a3aq33* indiv_* //indiv
rename indiv_*_* days_*
keep HHID parcel_id plot_id season indiv_* days_* /*days fam_worker_count*/

preserve 
use "${Uganda_NPS_W4_raw_data}\HH\GSEC2.dta", clear
destring PID, gen(indiv) ignore ("P" "-") 
gen male = h2q3==1
gen age = h2q8
keep HHID PID age male indiv
isid HHID PID
tempfile members
save `members', replace
restore

duplicates drop  HHID parcel_id plot_id season, force // SAW 3 observations deleted 
reshape long indiv days, i(HHID parcel_id plot_id season) j(colid) string
drop if days == .
*tostring HHID, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
merge m:1 HHID indiv using `members', nogen keep(1 3) 
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & male == 1
replace gender = "female" if strmatch(gender, "") & male == 0 
replace gender = "unknown" if strmatch(gender, "") & male == .
gen labor_type = "family"
drop if gender == "unknown"

merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county /*subcounty*/ parish ea HHID parcel_id plot_id season gender days labor_type /*fam_worker_count*/

foreach i in region district county /*subcounty*/ parish ea HHID {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //JHG 5_12_22: 1,692 with missing vals b/c they don't have matches on pid, see code above

	gen wage = wage_HHID
	*recode wage (.=0)
foreach i in country region district county /*subcounty*/ parish ea {
	replace wage = wage_`i' if obs_`i' > 9
	} //Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in gaps of implicit labor value.


egen wage_sd = sd(wage_HHID), by(gender season)
egen mean_wage = mean(wage_HHID), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 7.5 stdevs above the mean while the min is only 0.58 below. 
JHG 5_18_22: double-check with Andrew about percentiles in above text
*/
replace wage = wage_HHID if wage_HHID != . & abs(wage_HHID - mean_wage) / wage_sd < 3 //Using household wage when available, but omitting implausibly high or low values. Changed about 6,700 hh obs, max goes from 500,000->500,000; mean 45,000 -> 41,000; min 10,000 -> 2,000
//JHG 5_18_22: double-check with Andrew about the code above because the max did not change. Also I ran the Nigeria code and this text (the version there) didn't match what happened for wage or wage_hhid
* SAW Because he got total days of work for family labor but not for each individual on the hhhd we need to divide total days by number of  subgroups of gender that were included as workers in the farm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective ofgender)
by HHID parcel_id plot_id season, sort: egen numworkers = count(_n)
replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days
append using `all_hired'
keep region district county /*subcounty*/ parish ea HHID parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(HHID parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (HHID parcel_id plot_id labor_type)
reshape wide labor_, i(HHID parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_days.dta", replace

restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(HHID parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor.dta", replace

restore	
//And now we go back to wide
collapse (sum) val, by(HHID parcel_id plot_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(HHID parcel_id plot_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id dm_gender) j(season)
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
drop dm_gender
ren val* val*_
drop if dm_gender2 == "" //JHG 5_18_22: 169 observations lost, due to missing values in both plot decision makers and gender of head of hh. Looked into it but couldn't find a way to fill these gaps, although I did minimize them.
reshape wide val*, i(HHID parcel_id plot_id) j(dm_gender2) string
collapse (sum) val*, by(HHID)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_labor.dta", replace

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.

**********************    PESTICIDES/HERBICIDES   ******************************
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
rename HHID Hhid
rename hh HHID
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
tostring HHID, format(%18.0f) replace

*************************    MACHINERY INPUTS   ********************************

//JHG 6_14_22: Information was collected on machinery inputs for crop expenses in section 10, but was only done at the household level. Other inputs are at the plot level. Ask Didier about machinery that is owned.
preserve //This section creates raw data on value of machinery/tools
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC10.dta", clear
rename HHID Hhid
rename hh HHID
drop if  Farm_Implement == 2 //2 = no farm implement owned, rented, or used (separated by implement)
ren a10q1 qtymechimp //number of owned machinery/tools
ren a10q2 valmechimp //total value of owned machinery/tools, not per-item
ren a10q7 qtymechexp //number of rented machinery/tools
ren a10q8 valmechexp //total value of rented machinery/tools, not per-item
collapse (sum) valmechimp valmechexp, by(HHID) //combine values for all tools, don't combine quantities since there are many varying types of tools 
isid HHID //check for duplicate hhids, which there shouldn't be after the collapse
*tostring HHID, format(%18.0f) replace
tempfile rawmechexpense
save `rawmechexpense', replace
restore

preserve
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", replace
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_area_planted_temp.dta", replace
collapse (sum) ha_planted, by(HHID)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore
	
preserve
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", replace
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_area_planted_temp.dta", replace
merge m:1 HHID using `ha_planted_total', nogen
gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted / SAW ha_planted_total its total area planted for both seasons per HHID 
collapse planted_percent, by(HHID parcel_id plot_id season)
tempfile planted_percent
save `planted_percent'
restore

merge m:1 HHID parcel_id plot_id season using `planted_percent', nogen
merge m:1 HHID using `rawmechexpense', nogen
replace valmechexp = valmechexp * planted_percent //replace total with plot and season specific value of rented machinery/tools

//Now to reshape long and get all the medians at once.
keep HHID parcel_id plot_id season qty* val* unit*
unab vars : *exp //create a local macro called vars out of every variable that ends with exp
local stubs : subinstr local vars "exp" "", all //create another local called stubs with exp at the end, with "exp" removed. This is for the reshape below
duplicates drop HHID parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
*rename qtypest qtypesticide
reshape long `stubs', i(HHID parcel_id plot_id season) j(exp) string
reshape long val qty unit, i(HHID parcel_id plot_id season exp) j(input) string
gen itemcode=1
tempfile plot_inputs
tostring HHID, format(%18.0f) replace

merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3)
save `plot_inputs'
* Notes: SAW 7.1.22 I was able to to fix the reshape problem ... NGA W3 version includes State ea etc... might include now 
*Notes: Does the quantity for machinery matters here? Right now we haven't constructed a qtymechimp qtymechexp variable so quantity var for mech is always missing. Let Josh now so he can update UG W5.

******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
*SAW Using Josh Code as reference which uses Nigeria W3 Code.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
rename HHID Hhid
rename hh HHID
ren plotID plot_id
ren parcelID parcel_id

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
*SAW Will add the following code for potential problem with further code reshape problem like the section before
/*rename itemcodeifert itemcodeifertexp
gen itemcodeifertimp = itemcodeifertexp
drop qtyiferttotal */

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
tostring HHID, format(%18.0f) replace

*SAW Additional changes like we did for inorganic ferilizer section
*rename itemcodeifert itemcodeifertexp
*gen itemcodeifertimp = itemcodeifertexp
*drop qtyoferttotal

//JHG 6_15_22: no transportation costs are given; no subsidized fertilizer

//Clean-up data
keep item* qty* val* HHID parcel_id plot_id season
drop if itemcodefert == .
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates
drop dummya
duplicates drop HHID parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
unab vars : *2 
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(HHID parcel_id plot_id season) j(entry_no) string //JHG 6_15_22: Nigeria code had regional variables here (zone, state, etc.) but they aren't included in the raw data we used here for Uganda. We would need to append them in. Is that necessary? If so, apply to reshapes and collapse below also - don't need now, include later when calculating geographic medians
drop entry_no
drop if (qtyferttotal == . & qtyfertexp == .)
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
gen dummyc = sum(dummyb) //This process of creating dummies and summing them was done to create individual IDs for each row (can just use _n command, but we weren't aware at the time)
drop dummyb
reshape long `stubs2', i(HHID parcel_id plot_id season dummyc) j(exp) string
gen dummyd = sum(dummyc)
drop dummyc
reshape long qty val itemcode, i(HHID parcel_id plot_id season exp dummyd) j(input) string
recode qty val (. = 0)
collapse (sum) qty* val*, by(HHID parcel_id plot_id season exp input itemcode)
tempfile phys_inputs
save `phys_inputs'
*use `phys_inputs'

*SAW 4.7.11 Notes: Fertilizers - The section runs and the final dataset looks fine. Issue: Observations for var exp=="total" show the total qty (exp+imp) but w/o total values. Also, sometimes we have a tottal qty but w/o any imp/exp value - should they always be total = imp+exp?  UGANDA W5 has the same issue might want to talk with Josh about it

******************************************************************************
****************************     LAND RENTAL   ********************************** 
******************************************************************************
//Get parcel rent data
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta", clear
ren parcelID parcel_id
rename HHID Hhid
rename hh HHID
ren a2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring HHID, format(%18.0f) replace
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", replace
merge m:1 HHID parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_rental.dta", nogen keep (3)
gen qtyparcelrentexp = parcel_ha if valparcelrentexp > 0 & valparcelrentexp != .
gen qtyparcelrentimp = parcel_ha if qtyparcelrentexp == . //this land does not have an agreement with owner, but is rented

//Estimate rented plot value, using percentage of parcel 
*JHG 6_15_22: had to add this section (relative to Nigeria code) as Uganda does not ask about rental at a plot level, just a parcel level
gen plot_percent = field_size / parcel_ha
gen valplotrentexp = plot_percent * valparcelrentexp
gen qtyplotrentexp = qtyparcelrentexp * plot_percent
gen qtyplotrentimp = qtyparcelrentimp * plot_percent //quantity of "imp" land is that which is not rented

//Clean-up data
keep HHID parcel_id plot_id season valparcelrent* qtyparcelrent* valplotrent* qtyplotrent* 

	preserve //this section creates a variable, duplicate, which can tell if a plot was rented over two seasons. This way, rent is disaggregated by plot and by season.
	collapse (sum) plot_id, by(HHID parcel_id season)
	duplicates tag HHID parcel_id, generate(duplicate) 
	drop plot_id
	collapse (max) duplicate, by(HHID parcel_id)
	tempfile parcel_rent
	save `parcel_rent'
	restore

merge m:1 HHID parcel_id using `parcel_rent', nogen 
sort HHID parcel_id plot_id
*by hhid parcel_id plot_id : egen dumseason = total(season) if duplicate == 1
reshape long valparcelrent qtyparcelrent valplotrent qtyplotrent, i(HHID parcel_id plot_id season) j(exp) string
reshape long val qty, i(HHID parcel_id plot_id season exp) j(input) string
gen valseason = val / 2 if duplicate == 1
drop duplicate
gen unit = 1 //dummy var
gen itemcode = 1 //dummy var
tempfile plotrents
save `plotrents'

******************************************************************************
****************************    SEEDS   ********************************** 
******************************************************************************
*SAW 1.3.23 I will use Josh code as reference (UG w5) that uses NGA wave 3 as reference itself.
//Clean up raw data and generate initial estimates	
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season=1 
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta"
replace season=2 if season==.
rename HHID hhid2
rename hh HHID
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

keep unit* qty* val* purestand HHID parcel_id plot_id crop_code season
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates, similar process as above for fertilizers
drop dummya
reshape long qty unit val, i(HHID parcel_id plot_id season dummyb) j(input) string
collapse (sum) val qty, by(HHID parcel_id plot_id season unit input crop_code purestand)
ren unit unit_code
drop if qty == 0
*drop input //there is only purchased value, none of it is implicit (free, left over, etc.)

//Convert quantities into kilograms
replace qty = qty * 2 if unit_code == 40 //Basket (2kgs):  changes CHECKED 
replace qty = qty * 120 if unit_code == 9 //Sack (120kgs): changes CHECKED 
replace qty = qty * 20 if unit_code == 37 //Basket (20kgs):  changes CHECKED 
replace qty = qty * 10 if unit_code == 38 //Basket (10kgs):  changes CHECKED 
replace qty = qty / 1000 if unit_code == 2 //Gram:  changes CHECKED 
replace qty = qty * 5 if unit_code == 39 //Basket (5kgs):  changes CHECKED 
replace qty = qty * 100 if unit_code == 10 //Sack (100kgs):  changes CHECKED
replace qty = qty * 80 if unit_code == 11 //Sack (80kgs):  changes CHECKED
replace qty = qty * 50 if unit_code == 12 //Sack (50kgs):  changes CHECKED
replace qty = qty * 2 if unit_code == 29 //Kimbo/Cowboy/Blueband Tin (2kgs): changes CHECKED
replace qty = qty * 0.5 if unit_code == 31 //Kimbo/Cowboy/Blueband Tin (0.5kgs): 477 changes CHECKED
replace unit_code = 1 if inlist(unit_code, 2, 9, 10, 11, 12, 29, 31, 37, 38, 39, 40) //label them as kgs now	
*SAW What should we do with Tin (20 and 5 lts) and plastic bins (15lts), assume 1lt = 1kg? 
//replace qty = qty * 20 if unit_code == 20 //Tin (20lts):  changes CHECKED 
//replace qty = qty * 5 if unit_code == 21 //Tin (5kgs): changes CHECKED 
//replace qty = qty * 15 if unit_code == 22 //Plastic Bin (15 lts):  changes CHECKED 

//JHG 6_27_22: no conversion factors (or even units for the last two) for Tin (20 lts) [1.94%] {code is 20}, Tin (5 lts) [0.34%] {code is 21}, Plastic basin (15 lts) [5.53%] {code is 22}, Bundle (6.7%) {code is 66}, Number of Units (General) [1.04%] {code is 85}, or Other Units (Specify) [4.16%] {code is 99}. This means a total of 19.71% of observations cannot be converted into kilograms. We can't use conversion factors from crops as seeds have different densities. Need input on what to do with these remaining conversions

//JHG 6_27_22: Unsure of what to do with this section of code, so it is commented out. It seems to mark bundles and pieces (Nigerian units) and just have a special variable for them. There are bundles in Ugandan units as well but they are likely not the same. Perhaps this is how I can treat the unconvertible amounts. I don't have a conversion variable though. I made my owne version below
*gen unit = 1 if inlist(unit_cd,160,161,162,80,81,82) //pieces
*replace unit = 2 if unit == . //Weight, meaningless for transportation
*replace unit = 0 if conversion == . //useless for price calculations
gen unit = 1 if unit_code == 1
replace unit = 2 if unit == .
replace unit = 0 if inlist(unit_code, 20, 21, 22, 66, 85, 99) //the units above that could not be converted will not be useful for price calculations

ren crop_code itemcode
collapse (sum) val qty, by(HHID parcel_id plot_id season input itemcode unit) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for. JHG 7_5_22: all this code does is drop variables, it doesn't actually collapse anything
gen exp = "exp"

//Combining and getting prices.
append using `plotrents'
*tostring HHID, format(%18.0f) replace
append using `plot_inputs'
*destring HHID, replace
append using `phys_inputs'
*tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", nogen keep(1 3) keepusing(weight)

*destring HHID, replace
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)

*tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)

drop region sregion district county county_name parish parish_name ea weight rural
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)

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
foreach i in region /*sregion*/ district county parish ea HHID {
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
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
*drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district county parish ea HHID {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_HHID (. = 0)
	gen price = price_HHID
foreach i in country region district county parish ea {
	replace price = price_`i' if obs_`i' > 9 & obs_`i' != .
}

replace price = price_HHID if price_HHID > 0
replace qty = 0 if qty < 0 //2 households reporting negative quantities
recode val qty (. = 0)
drop if val == 0 & qty == 0 //Dropping unnecessary observations.
replace val = qty*price if val == 0 //11,258 estimates created
replace input = "orgfert" if itemcode == 5
replace input = "inorg" if strmatch(input,"fert")

//Need this for quantities and not sure where it should go.
preserve 
keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"pest") //would also have herbicide here if Uganda tracked herbicide separately of pesticides
collapse (sum) qty_ = qty, by(HHID parcel_id plot_id season input)
reshape wide qty_, i(HHID parcel_id plot_id season) j(input) string
ren qty_inorg inorg_fert_rate
ren qty_orgfert org_fert_rate
ren qty_pest pest_rate
la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
la var org_fert_rate "Qty organic fertilizer used (kg)"
la var pest_rate "Qty of pesticide used (kg)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_quantities.dta", replace 
restore

append using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor.dta"

collapse (sum) val, by (HHID parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", replace 

preserve
collapse (sum) val, by(HHID exp input) //JHG 7_5_22: includes both seasons, is that okay?
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_inputs_long.dta", replace 

restore

preserve
collapse (sum) val_ = val, by(HHID parcel_id plot_id season exp dm_gender)
reshape wide val_, i(HHID parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs.dta", replace //This gets used below.
restore

//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
ren val val_ 
reshape wide val_, i(HHID parcel_id plot_id season exp dm_gender) j(input) string
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id season dm_gender) j(exp) string
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
replace dm_gender2 = "unknown" if dm_gender == . 
drop dm_gender
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
collapse (sum) val*, by(HHID)

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

collapse (sum) ha_planted, by(HHID parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", clear

//back to wide
drop input
collapse (sum) val, by(HHID parcel_id plot_id season exp dm_gender)
gen dm_gender2 = "male" if dm_gender == 1
replace dm_gender2 = "female" if dm_gender == 2
replace dm_gender2 = "mixed" if dm_gender == 3
replace dm_gender2 = "unknown" if dm_gender == . 
drop dm_gender
ren val* val*_
reshape wide val*, i(HHID parcel_id plot_id season dm_gender2) j(exp) string
ren val* val*_
*destring HHID, replace
merge m:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time

*tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(HHID) //JHG 7_5_22: double-check this section to make sure there is now weirdness with summing up to household level when there are multiple seasons - was too tired when coding this to go back and check
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
ren crop_code_master cropcode
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_monocrop_plots.dta", replace 

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
keep if purestand == 1 //1 = monocropped //File now has 6801 unique entries - it should be noted that some these were grown in mixed plots.

merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
ren crop_code_master cropcode
ren ha_planted monocrop_ha
ren s_quant_harv_kg kgs_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
ren s_value_harvest val_harv_mono // SAW: We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
*This loop creates 17 values using the nb_topcrops global (as that is the number of priority crops), then generates two .dtas for each priority crop that contains household level variables (split by season). You can change which priority crops it uses by adjusting the priority crops global section near the top of this code.
forvalues k = 1(1)$nb_topcrops  {		
preserve	
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
local cn_full : word `k' of $topcropname_area_full
keep if cropcode == `c'			
ren monocrop_ha `cn'_monocrop_ha
drop if `cn'_monocrop_ha == 0 		
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
	
la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
la var `cn'_monocrop "Household has at least one `cn' monocrop"
la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
la var val_harv_mono_`cn' "Value of harvested `cn' (UGSH)"
foreach g in male female mixed {		
la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
}
collapse (sum) *monocrop* kgs_harv* val_harv*, by(HHID /*season*/)
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
	reshape wide val_, i(HHID parcel_id plot_id dm_gender season) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	drop if dm_gender2 =="" // SAW 1.5.23 drop close to 200 observations with no gender information so reshape runs
	reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
	merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(HHID)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_inputs_`cn'.dta", replace
restore
}
*use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_inputs_cassav.dta", replace // SAW 1.5.23 Checking how the new datasets look like
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
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta", clear
rename LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta", clear
rename ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta", clear
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
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - Cows" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid //JHG 12_30_21: have to reassign labels to values after append (possibly unnecessary since this is an intermediate step, don't delete code though because it is necessary)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_all_animals.dta", replace

**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta"
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta"
rename HHID hhid2
rename hh HHID
gen livestockid = LiveStockID
replace livestockid = ALiveStock_Small_ID if livestockid==.
replace livestockid = APCode if livestockid==.
merge m:1 livestockid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
*sort HHID livestockid //Put back in order

*Generate ownership dummy variables for livestock categories: cattle (& cows alone), small ruminants, poultry (& chickens alone), & other
gen cattle = inrange(livestockid, 1, 10) //calves, bulls, oxen, heifer, and cows
gen cows = inlist(livestockid, 5, 10) //just cows
gen smallrum = inlist(livestockid, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 27) //goats, sheep, pigs, and rabbits
gen poultry = inrange(livestockid, 23, 26) //chicken, turkey, ducks, and geese
gen chickens = inrange(livestockid, 23, 25) //just chicken (all kinds)
gen otherlivestock = inlist(livestockid, 11, 12) //donkeys/mules and horses

*Generate "number of animals" variable per livestock category and household (Time of Survey)
rename a6aq2 ls_ownership_now
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
rename a6bq2 sa_ownership_now
drop if sa_ownership == 2 //2 = see above
rename a6cq2 po_ownership_now
drop if po_ownership == 2 //2 = see above

rename a6aq3a ls_number_now
rename a6bq3a sa_number_now
rename a6cq3a po_number_now 
gen livestock_number_now = ls_number_now
replace livestock_number_now = sa_number_now if livestock_number_now == .
replace livestock_number_now = po_number_now if livestock_number_now == .
lab var livestock_number_now "Number of animals owned at time of survey (see livestockid for type)"

foreach i in cattle cows smallrum poultry chickens otherlivestock  {
gen num_`i'_now = livestock_number_now if `i'==1
}
gen num_tlu_now = livestock_number_now * tlu_coefficient

*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
rename a6aq6 ls_number_past
rename a6bq6 sa_number_past
rename a6cq6 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)" 
*SAW 7.5.22 Though, a6Xq6 refers to different types of animals the time of ownership asked in each question is different (12 months for livestock, 6 months for small animals, and 3 motnhs for poultry)

foreach i in cattle cows smallrum poultry chickens otherlivestock  {
gen num_`i'_past = livestock_number_past if `i'==1
}
gen num_tlu_past = livestock_number_past * tlu_coefficient

//Step 3: Generate animal sales variables (sold alive)
rename a6aq14b ls_avgvalue
rename a6bq14b sa_avgvalue
rename a6cq14b po_avgvalue
rename a6aq14a num_ls_sold
rename a6bq14a num_sa_sold
rename a6cq14a num_po_sold

gen num_totalvalue = ls_avgvalue * num_ls_sold
replace num_totalvalue = sa_avgvalue * num_sa_sold if num_totalvalue == .
replace num_totalvalue = po_avgvalue * num_po_sold if num_totalvalue == .

recode num_* (. = 0) //replace all null values for number variables with 0

//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) num*, by (HHID)
foreach i in ls sa po {
lab var num_`i'_sold "Number of animals sold alive (`i')"
}
rename num_otherlivestock_now num_other_now
rename num_otherlivestock_past num_other_past
foreach i in cattle cows smallrum poultry chickens other tlu {
lab var num_`i'_now "Number of `i' owned at time of survey"
lab var num_`i'_past "Number of `i' (donkeys/mules & horses) owned 12 months before survey"
}
lab var num_totalvalue "Total value of animals sold alive"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU_Coefficients.dta", replace

********************************************************************************
**                           LIVESTOCK INCOME       		         		  **
********************************************************************************
*SAW 7.5.22 We will use Nigeria Wave 3 as reference to write this section. This section was previously written in older version of Uganda W3 with different format.

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC7.dta", clear
*append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC7B.dta"
rename HHID hhid2
rename hh HHID
rename a7bq2e cost_fodder_livestock
rename a7bq3f cost_water_livestock
rename a7bq5d cost_vaccines_livestock
rename a7bq6c cost_deworm_livestock
rename a7bq7c cost_ticks_livestock
rename a7bq8c cost_hired_labor_livestock
collapse (sum) cost*, by(HHID)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_expenses.dta", replace
reshape long cost_, i(HHID) j(input) string
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
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8B.dta", clear
rename HHID hhid2
rename hh HHID
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
keep HHID livestock_code livestock_code2 milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_sales
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_sales "Total earnings of sale of milk produced"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_milk.dta", replace 

*2. Eggs
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8C.dta", clear
rename HHID hhid2
rename hh HHID
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
keep HHID livestock_code quantity_produced price_per_unit earnings_sales
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of egg per unit sold"
lab var price_per_unit_hh "Price of egg per unit sold at household level"
gen livestock_code2 = "2. Eggs"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_other.dta", replace 

*SW START This section below follow Uganda wave 3: 
*We append the 3 subsection of livestock earnings
append using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_milk.dta"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", keep(1 3) nogen

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
collapse (sum) value_milk_produced value_eggs_produced /*value_meat_produced*/ sales_livestock_products /*agquery*/ sales_milk sales_eggs /*sales_meat*/, by (HHID)
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
* SW END OF FINAL SECTION WAVE 3 AS REFERENCE 

/* Uganda Wave 7 Version of Final Part of Livestock Income - Might need some changes with loops and reporting of eggs and livestock sales on final dataset. 
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_milk.dta", replace 
append using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_other.dta"
recode price_per_unit (0=.)
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", keep(1 3)
recode price_per_unit (0=.)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", replace 

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_district.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_region.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_country.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products", clear
merge m:1 region district livestock_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen price_cowmilk_med = price_median_country if livestock_code==1
egen price_cowmilk = max(price_cowmilk_med)
replace price_per_unit = price_cowmilk if livestock_code==2
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==21
gen value_other_produced = quantity_produced * price_per_unit if livestock_code==22 | livestock_code==23
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		

collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (HHID)
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livesotck prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_livestock_products", replace
*/

*****************************    LIVESTOCK SOLD (LIVE)       *******************************
*SAW 9.25.23 From -> SW 7.12.22 Unlike Nigeria, Uganda has a section on meat production coming from slaughtered animals and their corresponding earning sales, which means we do not need to predict price values for slaughtered animals using live aninmals sold prices like Nigeria did. Though, we do need prices and earnings coming from sales of live animals but we already have earning coming from slaughtered animals.
*Notes: I will construct this section like Nigeria did - including values for slaughted animals using inputed median prices from live animals sales - and will ask Andres what to do with the livestock production coming from meat production. The only issue I see it is we might be double counting income from meat production and in this ssection inputed income from slaughtered animals. Code was taken from older version of Uganda w3.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta", clear
append using  "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta"
append using  "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta"
//Making sure value labels for 6B and 6C get carried over. Just in case.
rename HHID hhid2
rename hh HHID
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
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //106 missing from master
keep HHID region sregion rural weight district county county_name parish parish_name ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_livestock_sales.dta", replace
*Notes: SW Need to decide how to compute yearly values of livestock sold and slaughtered for livestock questions that refer to 3 or 6 months. It seems that  for 6B it refers to 12 months yet we multiply by 2. 


*SAW 7.12.22 This section is coming from the NGA w3 coding which uses a loop instead of longer code.
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
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01value_slaughtered_sold*/, by (HHID)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
*lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.0 gen prop_meat_sold = value_slaughtered_sold/value_slaughtered*/ // SAW We don't have slaughtered sold in this section. We do potentially have it in the 8C section though..... Actually this variable is available in the 8C - meat sold - subsection in earlier code.
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_sales.dta", replace

********************************************************************************
**                                 TLU    		         	         	      **
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta", clear
append using  "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta"
append using  "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta"
//Making sure value labels for 6B and 6C get carried over. Just in case.
rename HHID hhid2
rename hh HHID
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
gen tlu_coefficient =  0.5 if inrange(livestock_code, 1, 10) //Bulls and oxen, calves, heifer and cows
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
gen number_today= a6aq3a
replace number_today = a6bq3a if number_today==. 
replace number_today = a6bq3a if number_today==. //No estimated price value by farmers questions or owned  at the start of the ag season like Nigeria_GHS_W3_raw_data
gen number_today_exotic = number_today if inlist(livestock_code,1,2,3,4,5,13,14,15,16,17)
//ALT 12.05.19: End of work. Be sure to update the variables below because they don't match up between waves.

//SW 7.22.21 Continue working updating the variables below since they don't seem to work.
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
gen income_live_sales = a6aq14b // Value of each animal sold on average
*replace income_live_sales = a6bq14b*2 if income_live_sales==. & a6bq14b!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
*replace income_live_sales = a6cq14b*4 if income_live_sales==. & a6cq14b!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months
*Notes: SW 9.25.23 If questions a6aq14b provide value of each animal sold on average why are we multiplying by 2 and 4? It should be just the value per capita. 
replace income_live_sales = a6bq14b*1 if income_live_sales==. & a6bq14b!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace income_live_sales = a6cq14b*1 if income_live_sales==. & a6cq14b!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months

gen number_sold = a6aq14a
*replace number_sold = a6bq14a*2 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace number_sold = a6bq14a*1 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace number_sold = a6cq14a*4 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months
*SW Notes: Again, for a6bq14a it asks in the last 12 months, it should not be multiplied by 2.

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
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keep(1 3) //106 missing from master
foreach i in region district county /*subcounty*/ parish ea {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

*gen value_start_agseas = number_start_agseas * price_per_animal
gen value_today = number_today * price_per_animal
gen value_1yearago = number_1yearago * price_per_animal
*gen value_today_est = number_today * price_per_animal_est

collapse (sum) number_today number_1yearago lost_theft lost_other lost_disease animals_lost lvstck_holding=number_today value* tlu*, by(HHID species)
egen mean_12months=rowmean(number_today number_1yearago)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_herd_characteristics_long.dta", replace //AgQuery

preserve
keep HHID species number_today number_1yearago /*animals_lost*/ lost_disease lost_other lost_theft  lvstck_holding mean_12months
global lvstck_vars number_today number_1yearago lost_other lost_theft lost_disease lvstck_holding mean_12months
foreach i in $lvstck_vars {
	ren `i' `i'_
}
reshape wide $lvstck_vars, i(HHID) j(species) string
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
//drop lvstck_holding animals_lost_agseas mean_agseas lost_disease //No longer needed 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_herd_characteristics.dta", replace 
restore

collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (HHID)
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
*SAW 9.25.23 No Fish Income data collected in Uganda w4. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
//Purpose: This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. This includes profit from business... SAW Check for other sources of self-employment income
*Generate profit from business activities (revenue net of operating costs)
use "${Uganda_NPS_W4_raw_data}/HH/gsec12.dta", clear
rename hhid HHID
*use "${Uganda_NPS_W4_raw_data}/HH/GSEC12_1.dta", clear
ren h12q12 months_activ // how many months did the business operate
ren h12q13 monthly_revenue //  avg monthly gross revenues when active
ren h12q15 wage_expense // avg expenditure on wages // SAW Check if its av expen on wage per individual or total (since we got an indicator for number of people hired)
ren h12q16 materials_expense // avg expenditures on raw materials
ren h12q17 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (. = 0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit != . // W3 has some hhs with negative profit (56)
gen annual_selfemp_profit = monthly_profit * months_activ
collapse (sum) annual_selfemp_profit, by (HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_self_employment_income.dta", replace 
*SAW: There are some HHs with considerate negative outcomes (Should we winsorize this VAR prior to add it to total income?)

*Processed crops
//Not captured in w5 instrument (or other UGA waves)

*Fish trading
//It is captured in the GSEC12 section (already included)

********************************************************************************
**                             OFF-FARM HOURS      	    	                  **
********************************************************************************
*SAW 9.20.22 Using Peter's code as reference (Uganda wave 7)
//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs).
use "${Uganda_NPS_W4_raw_data}/HH/GSEC8_1.dta", clear
*Use ISIC codes for non-farm activities (For wave 3 we have a 1 digit ISCO variable ~ [0,9] that we can use, same as wave 7)
egen primary_hours = rowtotal (h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) if (h8q4==1 | h8q6==1 | h8q8==1 | h8q10==1) & h8q22!=6 // includes work for someone else, work without payment for the house, apprentice etc. for all work MAIN JOB excluding "Working on the household farm or with household livestock.." Last 7 days total hours worked per person
gen secondary_hours =  h8q43 if  h8q41!=6 &  h8q41!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours, for the past 7 days"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_off_farm_hours.dta", replace 
*Notes:  SAW 9.20.22 We have information about the total weeks and months worked for Main job and Secondary Job, should we aim to construct a off-farm hours worked for the year and not only for the past 7 days? Similar to what we did for Agricultural hours worked section.

********************************************************************************
*							 WAGE INCOME (AG & NON-AG)			 		  			*
********************************************************************************
*SW 9.25.23  Notes: There's no need to estimate the average number of weeks worked per months since that information is provided - in contrast to wave 3. Also, we combined Wage income Ag and Non-ag sections into only one section to reduce lines of code. Numbers differ widely to wave 3. Must be checked. 
use "${Uganda_NPS_W4_raw_data}/HH/GSEC8_1.dta", clear
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
collapse (sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from non-agricultural wage (both Main and Secondary Job)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_wage_income.dta", replace
restore
*SW Ag Wages
recode annual_salary_cash  annual_salary_in_kind (nonmissing=0) if main_job_ag==0
recode second_salary_cash  second_salary_in_kind (nonmissing=0) if sec_job_ag==0
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from agricultural wage (both Main and Secondary Job)"
rename annual_salary annual_salary_agwage
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_agwage_income.dta", replace

********************************************************************************
**                               OTHER INCOME 	        	    	          **
********************************************************************************
*SAW Using Earlier UG w3 code plus some adjustments 
use "${Uganda_NPS_W4_raw_data}/HH/GSEC11A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/HH/GSEC11B.dta"
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
collapse (sum) remittance_income pension_income rental_income other_income, by(HHID)
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension over previous 12 months" 
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months" //EFW 7.17.19 don't have this in this instrument
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_other_income.dta", replace
*Notes: SAW Would Wage employment h11q1==3 be double counting sources of income( we already calculated wage incomes earlier). We are currently excluding h11q2== 11, 12, and 13. Maybe include it in other sources of income indicators??? This are crop farming entreprises, other agricultural enterprises, and non-agricultural enterprises. They might be excluded since they could be counted in other sections.. 

********************************************************************************
**                           LAND RENTAL INCOME        	    	              **
********************************************************************************
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
rename HHID hhid2
rename hh HHID
rename a2aq14 land_rental_income
recode land_rental_income (.=0)
collapse(sum) land_rental_income, by(HHID)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rental_income.dta", replace
* 9.19.22 SAW Updated this small section since it was not running wrong names of vars... etc Double check if we are not coding this section better. (Very few observations have land rental income)

********************************************************************************
*								FARM SIZE / LAND SIZE				  		   *
********************************************************************************
*Determining whether crops were grown on a plot
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta"
replace season =2 if season == . 
ren HHID hhid
    ren hh HHID
   
ren parcelID parcel_id
ren plotID plot_id
drop if parcel_id==. | plot_id==.
ren ACropCode crop_code
replace crop_code= ACrop2_ID if crop_code==.
drop if crop_code==.
gen crop_grown = 1 
collapse (max) crop_grown, by(HHID parcel_id)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crops_grown.dta", replace

**
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta"
replace season =2 if season == . 
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated= (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if cultivated==.

collapse (max) cultivated, by (HHID parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_cultivated.dta", replace

**
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_cultivated.dta", clear
merge 1:1 HHID parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", nogen keep (1 3)


keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size.dta", replace

*All agricultural land
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta"
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
drop if parcel_id==.
merge 1:1 HHID parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crops_grown.dta", nogen


gen rented_out = (a2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2 | a2bq12b==1 | a2bq12b==2) //own cultivated annual and perennial crops
bys HHID parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
gen agland = a2aq11a==1 | a2aq11a==2 | a2aq11a==5 | a2aq11a==6| a2bq12a==1 | a2bq12a==2 | a2bq12a==5 | a2bq12a==6 // includes cultivated, fallow, pasture
drop if agland!=1 & crop_grown==.
collapse (max) agland, by (HHID parcel_id)
lab var agland "1= Parcel was used for crop cultivation or pasture or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_agland.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_agland.dta", clear
merge 1:1 HHID parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
*replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmsize_all_agland.dta", replace

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta"
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
drop if parcel_id==.
gen rented_out = (a2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2 | a2bq12b==1 | a2bq12b==2) 
bys HHID parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1
drop if rented_out==1
gen parcel_held = 1
collapse (max) parcel_held, by (HHID parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_held.dta", replace

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcels_held.dta", clear
merge 1:1 HHID parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all parcels listed by the household except those rented out" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2B.dta"
ren HHID hhid
ren hh HHID
ren parcelID parcel_id
drop if parcel_id==.
merge 1:1 HHID parcel_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
*replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (max) area_acres_meas, by(HHID parcel_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(HHID)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_total.dta", replace

********************************************************************************
*									FARM LABOR								   *
********************************************************************************
*Long Season
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
ren HHID hhid
ren hh HHID
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
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (HHID plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_mainseason.dta", replace

*Short Season
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta", clear
ren HHID hhid
ren hh HHID
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
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (HHID plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_shortseason.dta", replace

*Hired Labor and Family Labor
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_mainseason.dta", clear
merge 1:1 HHID plot_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_farmlabor_shortseason.dta", nogen
recode days*  (.=0)
collapse (sum) days*, by(HHID plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(HHID)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_family_hired_labor.dta", replace

********************************************************************************
*							VACCINE USAGE									   *
********************************************************************************
*SAW 9.22.22 Using Nigeria Wave 3 as reference (And Uganda Wave 3), since there is no code available for other Uganda Waves. Migh want to let other uganda coders about this so they code this section.

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC7.dta", clear
ren HHID hhid
    ren hh HHID
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
collapse (max) vac_animal*, by (HHID)
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
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC7.dta", clear
preserve
ren HHID hhid
    ren hh HHID
ren AGroup_ID livestock_code
gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,104,108)) + 4*(inlist(livestock_code,109,110)) + 5*(inlist(livestock_code,103,107))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species
gen vac_animal=a7abq5a==1 | a7abq5a==2
gen all_vac_animal=a7abq5a<=2
keep HHID species vac_animal  all_vac_animal
tempfile vaccines
save `vaccines'
restore
preserve
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta"
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta"
gen double farmerid = a6aq3d // SAW: When creating PID variable we need to add double because before it was saving it as float and the PID where being modified which affected the later mege (farmeid example 3604033)
rename HHID hhid
rename hh HHID
replace farmerid = a6bq3d if farmerid==.
replace farmerid = a6cq3d if farmerid==.
keep HHID farmerid LiveStockID
tempfile farmer1
save `farmer1'
restore
preserve
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta"
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta"
rename HHID hhid
rename hh HHID
gen double farmerid = a6aq3e
replace farmerid = a6bq3e if farmerid==.
replace farmerid = a6cq3e if farmerid==.
keep HHID farmerid LiveStockID
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
*SAW We need to create from livestockid to AgroupID categories variables so the merge can occur. SAW I'll use species since it's easier
gen species = (inlist(LiveStockID,1,2,3,4,5,6,7,8,9,10,11,12)) + 2*(inlist(LiveStockID,13,14,15,16,18,19,20,21)) + 3*(inlist(LiveStockID,17,22)) + 4*(inlist(LiveStockID,23,24,25,26,27,28))
*la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Poultry"
*la val species species
merge m:m HHID species using `vaccines' 
collapse (max) vac_animal all_vac_animal , by(HHID farmerid)
gen double  indiv=farmerid // SAW again using gen double so PID values do not get different values 
drop if indiv==.
tostring HHID, format(%18.0f) replace
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen // SAW 9.26.23 The only difference with UG wave 3 is the keep(1 3)
keep HHID farmerid vac_animal age female hh_head indiv all_vac_animal
lab var vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_vaccine.dta", replace

********************************************************************************
**                        ANIMAL HEALTH - DISEASES     	    	              **
********************************************************************************
*26.09.22 SAW This is a first attempt to code this section in Uganda (Not coded before for earlier waves). Using NGA w3 as reference 
*Comments: No information available on types of diseases suffered by [livestock_id], we only have information on which types of diseases hhid vaccineted for.

********************************************************************************
*					LIVESTOCK WATER, FEEDING, AND HOUSING 					   *
********************************************************************************
*SAW 26.09.22 SAW This section has not been coded for any Uganda wave yet. Also, not available for NGA w3. We will use as reference old code from Uganda w5 that does not run but gives an idea of the final indicators that we are looking for. 
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC7.dta", clear
rename HHID hhid
rename hh HHID
keep if a7aq1==1
gen feed_grazing = ( a7bq2a==1 |  a7bq2a==2 |  a7bq2b==1 |  a7bq2b==2) 
*SAW Difference between Uganda wave 3 and Wave 4 is that the latter ask about the 2 main feeding practices while wave 3 only ask for 1 main practice.
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat = (a7bq3b==5 | a7bq3b==6 | a7bq3b==7 | a7bq3b==9 | a7bq3c==5 | a7bq3c==6 | a7bq3c==7 | a7bq3c==9) 
gen water_source_const = (a7bq3b==1 | a7bq3b==2 | a7bq3b==3 | a7bq3b==9 | a7bq3c==1 | a7bq3c==2 | a7bq3c==3 | a7bq3c==9)
gen water_source_cover = (a7bq3b==4 | a7bq3b==8 | a7bq3b==10 | a7bq3c==4 | a7bq3c==8 | a7bq3c==10) 
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
*SAW Notes: Similar to feeding practices, wave 4 asks about the 2 main X practices for watering - in contrast, to wave 3 which only asked about the main practice. 
*Comments: Water systems 1 tap water, 2 borehole, 3 dam, 4 well, 5 river, 6 spring, 7 stream, 8 constructed water points, 9 rainwater harvesting, 10 other. Here's the list of water systems not sure where to include each of those so might need to change later. 
gen lvstck_housed = (a7abq4==2 | a7abq4==3 | a7abq4==4 | a7abq4==5 | a7abq4==6 | a7abq4==6==7) // SAW Includes: Confined in sheds, paddocks, fences, cages, baskets, and others
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
collapse (max) feed_grazing* water_source* lvstck_housed*, by (HHID)
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
*SW: Double check in which categories each sources of water, housing, and feeding was added to.  I'm not entirely sure what they exactly mean (Only issue quick to solve)
*SW: 8/8/23 Coded based on Uganda wave 3. 

********************************************************************************
*					USE OF INORGANIC FERTILIZER								   *
********************************************************************************
*SW 8.8.29 Using UG Wave 3 as reference.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season =1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season=2 if season==.
rename HHID hhid
rename hh HHID
rename parcelID parcel_id
rename plotID plot_id
gen use_inorg_fert=(a3aq13==1 | a3bq13==1) if (a3aq13!=. | a3bq13!=.)
collapse (max) use_inorg_fert, by (HHID /*season*/)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fert_use.dta", replace
*SW Notes: Household uses inorganic fertilizer in at least of season. (Should we make this at the seasonal level?)

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season =1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season=2 if season==.
rename HHID hhid
rename hh HHID
rename parcelID parcel_id
rename plotID plot_id
gen all_use_inorg_fert=(a3aq13==1 | a3bq13==1) if (a3aq13!=. | a3bq13!=.)
preserve
tempfile farmer1
gen double farmerid = a3aq3_3 if a3aq3_2==1 // only single decision-makers
replace farmerid = a3aq3_4a if a3aq3_2==2 & farmerid==.
replace farmerid = a3bq3_3 if a3bq3_2==1 & farmerid==.
replace farmerid = a3bq3_4a if a3bq3_2==2 & farmerid==.
keep HHID farmerid all_use_inorg_fert
save `farmer1'
restore
preserve
tempfile farmer2
gen double farmerid = a3aq3_4b if a3aq3_2==2
replace farmerid =  a3bq3_4b if a3bq3_2==2
keep HHID farmerid all_use_inorg_fert
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_use_inorg_fert, by(HHID farmerid)
gen double  indiv=farmerid // SAW again using gen double so individ values do not get different values 
drop if indiv==.
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", keep(1 3) nogen
keep HHID indiv all_use_inorg_fert
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if indiv!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_fert_use.dta", replace


********************************************************************************
*						USE OF IMPROVED SEED								   *
********************************************************************************
*SW 8.8.29 Using UG Wave 3 as reference.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season =1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta"
replace season=2 if season==.
rename HHID hhid
rename hh HHID
rename parcelID parcel_id
rename plotID plot_id
gen imprv_seed_use = (a4aq13==2) if a4aq13!=.
replace imprv_seed_use= (a4bq13==2) if imprv_seed_use==. & a4bq13!=.
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master

*Use of seed by type of crop
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	
	gen imprv_seed_`cn'=imprv_seed_use if cropID==`c'
	gen hybrid_seed_`cn'=.
}
collapse (max) imprv_seed_* /*hybrid_seed_**/, by(HHID)
lab var imprv_seed_use "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	*lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
*SAW No information found on hybrid seeds.
*replace imprv_seed_cassav = . // not sure why?
*replace imprv_seed_banana = . // This might be due to the need to regroup distinct banana crops into one umbrella term. Righ (need to update this to wave 3)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_improvedseed_use.dta", replace

*Seed adoption by farmers ( a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season =1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta"
replace season=2 if season==.
rename HHID hhid
rename hh HHID
rename parcelID parcel_id
rename plotID plot_id
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
gen all_imprv_seed_use = (a4aq13==2) if a4aq13!=.
replace all_imprv_seed_use= (a4bq13==2) if all_imprv_seed_use==. & a4bq13!=.
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use_temp.dta", replace

*Use of seed by crops
forvalues k=1/$nb_topcrops {
	use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=all_imprv_seed_use if cropID==`c'  
	*gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= cropID==`c' 
	gen double indiv = a4aq6_1
	replace indiv= a4bq6_1 if indiv==.
	*tostring HHID, format(%18.0f) replace
    *tostring PID, format(%18.0f) replace
	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' /*all_hybrid_seed_`cn'*/  `cn'_farmer, by (HHID indiv)
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use_temp_`cn'.dta", replace // Would it be helpful to save this as tempfile? 
}

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 HHID indiv all_imprv_seed_use using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use_temp_`v'.dta", nogen 
}	 
drop if indiv==.
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	*lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

gen farm_manager=1 if indiv!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" // 
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use.dta", replace 

*SAW Comments :In this case, Section 4A and 4B does not provide information on who is responsible for the crop only who is respondent for the crop on the questionnaire not sure if they are the same thing. For example, for other sections using 3A and 3B they do explicitly ask who is decision makers of the plot etc. 
*SAW: 5.1.23 Nigeria Wave 3 Has a PLOT MANAGER section that includes fertlizer use, improved seed into one section - might want to update the sections above to reduce number of lines of code.

********************************************************************************
**                             PLOT MANAGER        	                          **
********************************************************************************
*SAW 2.20.23 I will construct this section using Nigeria Wave 3 as reference.
*SAW: 5.1.23 Nigeria Wave 3 Has a PLOT MANAGER section that includes fertlizer use, improved seed into one section - might want to update the sections above to reduce number of lines of code.
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC4B.dta"
replace season = 2 if season == .
rename HHID hhid2
rename hh HHID
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223) //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
gen use_imprv_seed = (a4aq13==2) if a4aq13!=.
replace use_imprv_seed= (a4bq13==2) if use_imprv_seed==. & a4bq13!=.
*Crop Recode (Must check if applies for Uganda)
collapse (max) use_imprv_seed, by(HHID parcelID plotID cropID) //SAW Potentially we could do it by season. 
rename parcelID parcel_id
rename plotID plot_id
rename cropID crop_code
tempfile imprv_seed
save `imprv_seed'

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A.dta", clear
gen season=1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B.dta"
replace season = 2 if season == .
rename HHID hhid2
rename hh HHID
clonevar PID1 = a3aq3_3
replace PID1 = a3aq3_4a if a3aq3_2==2
replace PID1 = a3bq3_3 if PID1==.
replace PID1 = a3bq3_4a if PID1==. & a3bq3_2==2
clonevar PID2 = a3aq3_4b
replace PID2 = a3bq3_4b if PID2==. & a3bq3_2==2
keep HHID parcelID plotID PID* season
duplicates drop HHID parcelID plotID season, force // 3 obs deleted
reshape long PID, i(HHID parcelID plotID season) j(pidno)
drop pidno
drop if PID==.
clonevar personid = PID
merge m:1 HHID personid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_gender_merge.dta", nogen keep(1 3)
rename plotID plot_id
rename parcelID parcel_id
tempfile personids
save `personids'

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_quantities.dta", clear
foreach i in inorg_fert org_fert pest /*herb*/ {
	recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'
}
collapse (max) use_*, by(HHID parcel_id plot_id) // SAW If in at least one season it used any of i it is coded as 1. 
merge 1:m HHID parcel_id plot_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", nogen keep(1 3) keepusing(crop_code_master)
ren crop_code_master crop_code
collapse (max) use*, by(HHID parcel_id plot_id crop_code)
merge 1:1 HHID parcel_id plot_id crop_code using `imprv_seed',nogen keep(1 3)
recode use* (.=0)
preserve 
keep HHID parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(HHID crop_code)
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropname_table.dta", nogen keep(3)
drop crop_code	
reshape wide imprv_seed_ hybrid_seed_, i(HHID) j(crop_name) string
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_imprvseed_crop.dta", replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore

merge m:m HHID parcel_id plot_id using `personids', nogen keep(1 3) // SAW personids is at the plot season level while input quantities at the plot level
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(HHID personid female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropname_table.dta", nogen keep(3)
*decode crop_code, gen(crop_name)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(HHID personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
*clonevar PID = personid // SAW 15/3/23 I need this for individual summary stats
clonevar indiv = personid 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use.dta", replace 
restore


collapse (max) use_*, by(HHID personid female)
gen all_imprv_seed_use = use_imprv_seed //Legacy

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest /*use_herb*/, by (HHID)
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
*	clonevar PID = personid // SAW 15/3/23 I need this for individual summary stats
	clonevar indiv = personid 
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_fert_use.dta", replace //This is currently used for AgQuery
restore

*Notes: 2.20.23 SAW If this works I might be able to get rid of Improved seeds and Fertilizers use (sections on top) to reduce lines of code. It ended up being almost same lines of code than just doing them separetely. 

********************************************************************************
*							REACHED BY AG EXTENSION							   *
********************************************************************************
*SW 8.8.29 Using UG Wave 3 as reference.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC9.dta", clear
rename HHID hhid
ren hh HHID
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
collapse (max) ext_reach_* , by (HHID)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_any_ext.dta", replace 
*SAW Comments: We could specify the advice on prices from extension if required (we got the data for that and other types of advise). Right now, we are not worring about which type of advise is given (e.g. ag production, ag prices, ag processing, crop marketing, fish production, livestock production, livestock diseases etc.)

********************************************************************************
**                         MOBILE PHONE OWNERSHIP                             **
********************************************************************************
*SAW 1.5.23 CODED using Nigeria wave 3 as reference. This section has not been coded for other Uganda waves. 
use "${Uganda_NPS_W4_raw_data}/HH/GSEC14A.dta", clear
*append using "${Uganda_NPS_W4_raw_data}/HH/GSEC14B.dta"
recode h14q4 (.=0)
gen hh_number_mobile_owned=h14q4 if h14q2==16 // number mobile phones owned by household today
recode hh_number_mobile_owned (.=0)
gen mobile_owned=hh_number_mobile_owned>0
collapse (max) mobile_owned, by(HHID)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_mobile_own.dta", replace 

********************************************************************************
*					USE OF FORMAL FINANCIAL SERVICES						   *
********************************************************************************
//Household Questionnaire Section 13: Financial Services Use, is missing in W4, so can't construct this section

********************************************************************************
*								MILK PRODUCTIVITY	(NEED CHECKING)			   *
********************************************************************************
*SW 8.8.23 Coded using wave 7 as reference. Must revisit since there are relevant differences with Uganda wave 3. 
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8B.dta", clear
rename HHID hhid
rename hh HHID
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==102 // SW: Why do we exclude indigenous large and small ruminants? 
ren a8bq1 milk_animals
ren a8bq2 months_milked
ren a8bq3 liters_day 
gen liters_per_largeruminant = (liters_day*365*(months_milked/12))	
keep if milk_animals!=0 & milk_animals!=.
drop if liters_per_largeruminant==.
keep HHID milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_milk_animals.dta", replace 
*Notes: We need to figure out which ruminants we want to include in the indicator. 

********************************************************************************
*								EGG PRODUCTIVITY							   *
********************************************************************************
*SW 8.8.23 Coded using Uganda wave 7 as reference.
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta", clear
rename HHID hhid
rename hh HHID
gen poultry_owned = a6cq3a if (APCode==23 | APCode==24 | APCode==25 | APCode==26) // SAW It includes   Indigenous dual-purpose chicken, Layers (exotic/cross chicken),   Broilers (exotic/cross chicken), ther poultry and birds (turkeys/ducks)
collapse (sum) poultry_owned, by(HHID)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8C.dta", clear
rename HHID hhid
rename hh HHID
gen eggs_months = a8cq1/3	// number of layers was reported for the last three months thus the need to divide by 3 to get monthly total				
gen eggs_per_month = a8cq2/3	// number of eggs laid was reported for the last three months thus the need to divide by 3 to get monthly total			
collapse (sum) eggs_months eggs_per_month, by(HHID)
gen eggs_total_year = eggs_month*eggs_per_month*12 // multiply by 12 to get the annual total 
merge 1:1 HHID using  `eggs_animals_hh', nogen keep(1 3)			
keep HHID eggs_months eggs_per_month eggs_total_year poultry_owned 
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_eggs_animals.dta", replace 
*Notes: Must revisit since wave 3 has very different means than wave 4 and 7.


********************************************************************************
**                      CROP PRODUCTION COSTS PER HECTARE                      **
********************************************************************************
*SAW 9.26.23 Using Uganda wave 3 as reference.
/*SAW Comments: This section is much different than older versions of uganda and uganda wave 7. I will currently use NGA wave 3 as reference, since it was also used as reference for the ALL PlOTS section which is used as input for this section.
*All the preprocessing is done in the crop expenses section */
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
replace dm_gender = 3 if dm_gender==.
collapse (sum) ha_planted /*ha_harvest*/, by(HHID parcel_id plot_id /*season*/ purestand field_size) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
duplicates drop HHID parcel_id plot_id /*season*/, force
reshape long ha_, i(HHID parcel_id plot_id /*season*/ purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_cost_inputs_long.dta", replace 
replace dm_gender = 3 if dm_gender==.
collapse (sum) cost_=val, by(HHID parcel_id plot_id /*season*/ dm_gender exp)
reshape wide cost_, i(HHID parcel_id plot_id  /*season*/ dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
drop cost_total
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge m:1 HHID parcel_id plot_id /*season*/ using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(HHID /*season*/ dm_gender area_type)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
*replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(HHID /*season*/ dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(HHID /*season*/) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted /*harvested*/ {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropcosts.dta", replace 
*SAW we need to complete Crop expenses section first, since its used as input for this section. Once completed go back to NGA w3 to code this section.
*Notes: For Crop production costs per hectare we are adding all costs and area planted across both seasons at the plot level. 
*SAW: 5/1/23 Season added in green in case we want to compute this section at the household season level. 

********************************************************************************
                    * RATE OF FERTILIZER APPLICATION *
********************************************************************************
*SAW 1.6.23 Available in Uganda wave 7, Not in old Uganda wave 3. Best option is to use NGA wave 3 as reference since it uses previous sections that used same code as reference. 
*SAW 1.9.23 Using Nigeria Wave 3 as reference:
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace 
collapse (sum) ha_planted /*ha_harvest*/, by(HHID parcel_id plot_id season/*season*/ dm_gender) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_quantities.dta", keep(1 3) nogen
collapse (sum) ha_planted /*ha_harvest*/ inorg_fert_rate org_fert_rate pest_rate, by(HHID parcel_id plot_id /*season*/ dm_gender) // at the plot level for both seasons
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren ha_planted ha_planted_
ren inorg_fert_rate fert_inorg_kg_ 
ren org_fert_rate fert_org_kg_ 
ren pest_rate pest_kg_
*ren herb_rate herb_kg_ // SAW no herb information
drop if dm_gender2=="" // SAW might be a better way to allow reshape work without losing this info. 
reshape wide ha_planted_ fert_inorg_kg_ fert_org_kg_ pest_kg_ /*herb_kg_*/, i(HHID parcel_id plot_id) j(dm_gender2) string
collapse (sum) *male *mixed, by(HHID)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg fert_org_kg pest_kg /*herb_kg*/ {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 HHID using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", keep (1 3) nogen
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
}
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
use "${Uganda_NPS_W4_raw_data}/HH/GSEC15B.dta", clear
ren HHID hhid
rename hh HHID
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
collapse (max) adiet_yes, by(HHID Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(HHID)
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
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A.dta", clear
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B.dta"
*append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A.dta"
*append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B.dta"
*append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C.dta"
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8A.dta"
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8B.dta"
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC8C.dta"
rename HHID hhid
rename hh HHID
*append using "${Uganda_NPS_W4_raw_data}/HH/GSEC8_1.dta"
*append using "${Uganda_NPS_W4_raw_data}/HH/GSEC7_1.dta" // SAW Dataset not available. 

append using "${Uganda_NPS_W4_raw_data}/HH/GSEC12_1.dta" // OR
*append using "${Uganda_NPS_W4_raw_data}/HH/gsec12.dta"

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
*NOTES: NEED TO FIX THE ISSUE BETWEEN CONTROL_ANNUALHARVEST AND CONTROL_ANNUAL SALES SINCE THEY COME FROM THE SAME DATASET THEY ARE BEING WRITTEN OM TOP OF THE OTHER.
*NOTES: CHECK IT'S NOT HAPPENING WITH OTHER SUBSECTIONS. -> Preserve tempfile  append  might do it

*Control over livestock sales 
replace type_decision="control_livestocksales" if !missing(a8aq6a) | !missing(a8aq6b)
replace controller_income1=a8aq6a if controller_income1==.
replace controller_income2=a8aq6b if controller_income2==.
*SW Notes: There are only 11 & 6 observations respectively. It seems like not many HH sell meat
*Control over milk sales
replace type_decision="control_milksales" if !missing(a8bq10a) | !missing(a8bq10b)
replace controller_income1=a8bq10a if controller_income1==.
replace controller_income2=a8bq10b if controller_income2==.
*Control over eggs_sales
 replace type_decision="control_otherlivestock_sales" if !missing(a8cq6a) | !missing(a8cq6b)
replace controller_income1=a8cq6a if controller_income1==.
replace controller_income2=a8cq6b if controller_income2==.

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
collapse (max) control_* , by(HHID controller_income)  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*	Now merge with member characteristics
*tostring HHID, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen
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
*SW: This section is coded using Uganda wave 3  as reference. 
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making

use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3A", clear // planting input decision maker - s3aq03_3
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC3B" // s3bq03_3
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5A" // s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC5B" // s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
rename HHID hhid2
rename hh  HHID
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

keep HHID type_decision decision_maker1 decision_maker2 /*decision_maker3*/
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
gen make_decision_crop=1 if  type_decision=="planting_input" | type_decision=="harvest" 

recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(HHID decision_maker )  //any decision
ren decision_maker indiv
*Now merge with member characteristics
merge 1:1 HHID indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_make_ag_decision.dta", replace

********************************************************************************
*							WOMEN'S OWNERSHIP OF ASSETS						   *
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
use "${Uganda_NPS_W4_raw_data}/Agric/AGSEC2A", clear // land ownership 
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W4_raw_data}/Agric/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
rename HHID hhid2
rename hh HHID
append using "${Uganda_NPS_W4_raw_data}/HH/GSEC14A"
*append using "${Uganda_NPS_W4_raw_data}/HH/GSEC14B"

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
keep HHID type_asset asset_owner*
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

keep HHID type_asset asset_owner*
*  2nd Owner *
preserve
keep HHID type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
* 1st Owner *
preserve
keep HHID type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
tempfile asset_owner1
save `asset_owner1'
restore 
* We create dataset with 2nd Owners (PID style different) *
preserve 
keep HHID type_asset asset_owner1_2
drop if asset_owner1_2==.
ren asset_owner1_2 asset_owner
tempfile asset_owner1_2
save `asset_owner1_2'
restore 
* We create dataset with 1nd decision makers (PID style different)
keep HHID type_asset asset_owner1_1
drop if asset_owner1_1==.
ren asset_owner1_1 asset_owner
append using `asset_owner2'
append using `asset_owner1'
append using `asset_owner1_2'

gen own_asset=1 
clonevar individ = asset_owner

*Now merge with member characteristics
preserve
merge m:1 HHID individ using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen keep(3) // asset_owner as individ style
tempfile individ_data
save `individ_data'
restore
clonevar  indiv = asset_owner 
merge m:1 HHID indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen keep(3) // asset_owner as indiv style (from HH Datasets)
append using `individ_data'
collapse (max) own_asset , by(HHID indiv)  //any decision
merge 1:1 HHID indiv using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", nogen // Controller_income as indiv style
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ownasset.dta", replace

********************************************************************************
                          * AGRICULTURAL WAGES *
********************************************************************************
*SAW 1.9.23 New version using Nigeria Wave 3 as reference. Might be better for Agquery+
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_long.dta", replace // at the plot season level
keep if strmatch(labor_type,"hired") & (strmatch(gender,"male") | strmatch(gender,"female"))
collapse (sum) wage_paid_aglabor_=val hired_=days, by(HHID gender)
reshape wide wage_paid_aglabor_ hired_, i(HHID) j(gender) string
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
*SAW 1.9.23 Using Nigeria Wave 3 as reference, since it uses All Plots sections to construct crop yields.
/* use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
ren crop_code_master crop_code
gen number_trees_planted_banana = number_trees_planted if crop_code==2030 
gen number_trees_planted_cassava = number_trees_planted if crop_code==1020 
gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040
recode number_trees_planted_banana number_trees_planted_cassava number_trees_planted_cocoa (.=0) 
collapse (sum) number_trees_planted*, by(HHID)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_trees.dta", replace */
*SAW 1.9.23 All Plots dta missing number_trees_planted need go back to all plots to construct it if available. No information on number of trees planted or owned in Uganda wave 3.
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace // at the plot season level
ren crop_code_master crop_code
//Legacy stuff- agquery gets handled above.
replace dm_gender = 3 if dm_gender==.
collapse (sum) /*area_harv_=ha_harvest*/ area_plan_=ha_planted harvest_=s_quant_harv_kg, by(HHID dm_gender purestand crop_code) // SAW 10.9.23 I use s_quant_harv_kg instead of quant_harv_kg
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
reshape wide harvest_ /*area_harv_*/ area_plan_, i(HHID dm_gender2 crop_code) j(mixed) string
ren area* area*_
ren harvest* harvest*_
reshape wide harvest* area*, i(HHID crop_code) j(dm_gender2) string
foreach i in harvest area_plan /*area_harv*/ {
	egen `i' = rowtotal (`i'_*)
	foreach j in inter pure {
		egen `i'_`j' = rowtotal(`i'_`j'_*) 
	}
	foreach k in male female mixed {
		egen `i'_`k' = rowtotal(`i'_*_`k')
	}
	
}
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) /*all_area_harvested=area_harv*/ all_area_planted=area_plan, by(HHID)
*replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropname_table.dta", nogen keep(1 3)
merge 1:1 HHID crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
*gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_
drop crop_code kgs_sold s_quant_harv_kg quant_harv_kg  // SAW 1.9.23 need to drop this 2 vars to make reshape possible
unab vars : *_
reshape wide `vars', i(HHID) j(crop_name) string
*merge 1:1 HHID using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_trees.dta"
collapse (sum) harvest* /*area_harv**/  area_plan* total_planted_area* /*total_harv_area**/ kgs_harvest* value_harv* value_sold* /*number_trees_planted**/  , by(HHID) 
recode harvest*   /*area_harv**/ area_plan* kgs_harvest* total_planted_area* /*total_harv_area**/ value_harv* value_sold* (0=.)
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
	/*lab var area_harv_`p' "Area harvested of `p' (ha) (household)" 
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
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (ha) - intercrop (mixed-managed plots)" */
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
*SAW 3/13/23 Updated harvested_`p' if household has kgs harvested of topcropname_area (need this for future household summary stats).
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production.dta", replace
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
*SAW 1.10.23 wheat tea vanilla sunflower simsim tobacco Need to add to type of commodity revising commodity high/low classification and 811 812 and 840 

preserve
collapse (sum) value_crop_production value_crop_sales, by(HHID commodity) 
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
collapse (sum) value_*, by(HHID)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}

drop value_pro value_sal
save "${Uganda_NPS_W4_created_data}//Uganda_NPS_W4_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by(HHID type_commodity) 
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
collapse (sum) value_*, by(HHID)
foreach x of varlist value_* {
	lab var `x' "`l`x''"
}
drop value_pro value_sal
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
                          * SHANNON DIVERSITY INDEX *
********************************************************************************
*SAW 9.27.23 This section is written using Uganda Wave 3 as reference. It replaces the old version of this section in Uganda wave 4 old do-file. 
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan.dta", replace
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0 
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(HHID)
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
bysort HHID (sdi_crop_female) : gen allmissing_female = mi(sdi_crop_female[1])
bysort HHID (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort HHID (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort HHID crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female ///
num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(HHID)
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
*SW 9.27.23 This section is written using Uganda Wave 3  as reference. 
use "${Uganda_NPS_W4_raw_data}/HH/pov2013_14", clear 
duplicates drop HHID, force // 1 observation deleted
ren cpexp30 total_cons // 
ren equiv adulteq
ren welfare peraeq_cons
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhsize.dta", nogen keep(1 3)
gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30
gen daily_percap_cons = percapita_cons/30  
lab var total_cons "Total HH consumption, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var peraeq_cons "Consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var percapita_cons "Consumption per capita, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var daily_peraeq_cons "Daily consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 13/14"
lab var daily_percap_cons "Daily consumption per capita, in 05/06 prices, spatially and temporally adjusted in 13/14" 
keep HHID total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq poor_13
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_consumption.dta", replace
*SAW: There no Connsumption document to reference whether consumption measure were spatially and temporally deflated. 

**We create an adulteq dataset for summary statistics sections
use "${Uganda_NPS_W4_raw_data}/HH/pov2013_14", clear 
duplicates drop HHID, force // 1 observation deleted
rename equiv adulteq
keep HHID adulteq
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_adulteq.dta", replace


********************************************************************************
                          * FOOD SECURITY *
********************************************************************************
*SW 9.27.23 This section is written using Uganda wave 3 as reference. (Not available for Uganda old wave 3, wave 5, and 7)
use "${Uganda_NPS_W4_raw_data}/HH/GSEC15B", clear 
rename h15bq5 fd_home
rename h15bq7 fd_awayhome
rename h15bq9 fd_ownp
rename h15bq11 fd_gift
egen food_total = rowtotal(fd*) 
* SAW This includes food purchased at home, away from home, own production, and gifts.
*rename h15bq15 fd_total
collapse (sum) fd* food_total, by(HHID)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_adulteq.dta", nogen keep(1 3)
*merge 1:1 HHID using "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhsize.dta", nogen keep(1 3)
drop if adulteq ==.
recode fd* food_total (0=.)
gen daily_peraeq_fdcons = food_total/adulteq /365 
*SAW I think this is consumption for the last 7 days, might want to multiply by 52? 
gen daily_percap_fdcons = food_total/hh_members/365
*SAW I think this is consumption for the last 7 days, might want to multiply by 52?  Need to get a sense of the poverty line for this year to see if numbers make sense. 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_food_cons.dta", replace
*SAW : Not sure if we can construct food consumption indicators at the season level to track intrayearly food insecurity. 

********************************************************************************
                          * FOOD PROVISION *
********************************************************************************
*SW 9.27.23 This section is written using Uganda wave 3 as reference. (Not available for Uganda old wave 3, wave 5, and 7)
*use "${UGS_W3_raw_data}/GSEC17A", clear //SAW  Have you been faced with a situation when you did not have enough food to feed in the last 12 months Yes/No answer? Maybe this works? The questionnaire includes months when this happened but the actual dataset does not. 
use "${Uganda_NPS_W4_raw_data}/HH/GSEC17_2", clear 
gen food_insecurity = 1 if h17q10a==1
replace food_insecurity = 0 if food_insecurity==.
collapse (sum) months_food_insec= food_insecurity, by(HHID)
lab var months_food_insec "Number of months where the household experienced any food insecurity" 
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_food_insecurity.dta", replace
*Notes: SAW This dataset only includes households that answered in GSEC17A question h17q9 "Have you been faced with a situation when you did not have enough food to feed the lasth 12 months" as Yes, any household that answered as No, it is not in this final dataset but the values would be equal to 0. ------> after merging recode months_food_insec (.=0)

********************************************************************************
                          *HOUSEHOLD ASSETS*
********************************************************************************
*SW 9.27.23 This section is written using Nigeria Wave 3 as reference. (Available for Uganda wave 7 as well)
use "${Uganda_NPS_W4_raw_data}/HH/GSEC14A", clear 
rename h14q5 value_today
rename h14q4 num_items
*dropping items if hh doesnt report owning them 
keep if h14q3==1
collapse (sum) value_assets=value_today, by(HHID)
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
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production_grouped.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_values_production_type_crop.dta", nogen keep(1 3)
recode value_pro* value_sal* (.=0)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_cost_inputs.dta", nogen keep(1 3)

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_inputs_`c'.dta", nogen
	merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_`c'_monocrop_hh_area.dta", nogen
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
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_hh.dta", nogen keep(1 3)
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
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_sales.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_products.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_TLU_Coefficients.dta", nogen keep(1 3)
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
*SAW 3/14/23 Notes: We do have information for mean_12months and animals_lost12months by type of livestock but not for household level maybe we can add it. We can calculate mean_12months and animals_lost12months (in uganda the variable is named lost_disease_*) at the household level for all livestock (if thats what we are looking for)

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*

*Self-employment income
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta", nogen keep(1 3)
*SAW: This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is already part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_agwage_income.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_other_income.dta", nogen keep(1 3)
*SAW: Remittance income is already included in the other income dataset. (Need to check why)
egen transfers_income = rowtotal (remittance_income pension_income)
*SAW There is a confusion between remittance income and assistance income in the UGanda Other Income section that needs to be revised.
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm Size
merge 1:1 HHID using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_all.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 HHID using  "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_size_total.dta", nogen keep(1 3)
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
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_vaccine.dta", nogen keep(1 3)
*merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fert_use.dta", nogen keep(1 3)
*merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_input_use.dta", nogen keep(1 3)
*SAW: This Input Use dataset comes from the Plot Manager section that is constructed in the Nigeria Wave 3 do file which includes fert use and improved seed use along pesticides and fertilizers into one single dataset. We might want to construct this section in Uganda for fewer lines of code in the future. (It comes adter the Fertilizer Use and Improved Seed sections in Uganda)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_any_ext.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fin_serv.dta", nogen keep(1 3) // SAW Not Available for Uganda Wave 3 dta missing
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode /*use_fin_serv**/ ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_milk_animals.dta", nogen keep(1 3)
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
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
*gen liters_milk_produced = milk_months_produced * milk_quantity_produced // SAW 2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)
 
*Household diet
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_household_diet.dta", nogen keep(1 3)

*consumption 
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_food_insecurity.dta", nogen keep(1 3)
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
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_livestock_feed_water_house.dta", nogen keep(1 3)

*Shannon Diversity index
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_shannon_diversity_index.dta", nogen keep(1 3)

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
*recode fishing_income (.=0)
*gen fishing_hh = (fishing_income!=0)
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
rename liters_per_largeruminant liters_milk_produced
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
gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha = w_cost_total / w_ha_planted
gen cost_expli_ha = w_cost_expli / w_ha_planted 

foreach g of global gender {
	gen inorg_fert_rate_`g'=w_fert_inorg_kg_`g'/ w_ha_planted_`g'
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
*/ /*use_fin_serv*/ use_inorg_fert imprv_seed_use /*
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
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested*/ (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested*/ (nonmissing= . ) if crop_hh==0
	
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
*SAW 3/13/23 Here, we could do it with w_yield_planted_cn.

*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}

*all rural households engaged in dairy production
*rename liters_per_largeruminant liters_milk_produced
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


/* SAW Old Version of Poverty Indicators 
*Rural poverty headcount ratio
*First, we convert $1.90/day (2011 $PPP) to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 79.531 = 151.1089  OLDER
	// 1.90 * 944.26 = 1794.094  NEW (Uganda 2011 Private Consumption, PPP)
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(134.925 - 110.84)/110.84 = 1.6587243	OLD
	// 151.1089* 1.6587243 = 250.648 N OLD
	// 1+(131.3-116.6)/116.6 = 1.126072 // CPI Uganda inflation from 2011 (baseline year) to 2012 (survey year)
	// 1794.094*1.126072 = 2020.279
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out
gen poverty_under_1_9 = (daily_percap_cons<2020.279)		 
la var poverty_under_1_9 "Household has a percapita consumption of under $1.90 in 2011 $ PPP)"
*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*First, generating variable that reports the individuals in the bottom 40% of rural consumption expenditures
*By per capita consumption
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1


*Rural poverty headcount ratio (with new updated $2.15 poverty line in 2017 baseline year)
*First, we convert $2.15/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2020&locations=UG&start=1993
	// 2.15 * 1221.09 = 2625.3435 NEW (Uganda 2017 Private Consumption, PPP)
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $2.15/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we deflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
     // 1+(166.8-131.2)/131.2 = 1.2713415 // We deflate using CPI Uganda 2017 (166.8) and CPI Uganda CPI 2012 (131.2) last year of survey
     // 2625.3435/ 1.2713415 = 2065.0183
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out
gen poverty_under_2_15 = (daily_percap_cons<2065.0183)		 
la var poverty_under_2_15 "Household has a percapita consumption of under $2.15 in 2017 $ PPP)"
*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution

*SAW 3.14.23 Notes: I am not sure how to calculate this section with the new $2.15 poverty line and change in baseline year (also other waves are confusing in the way this section is calculated with different methodologies)

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1


****Currency Conversion Factors***
gen ccf_loc = 1 
lab var ccf_loc "currency conversion factor - 2017 $NGN"
gen ccf_usd = 1/$NPS_LSMS_ISA_W3_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = 1/ $NPS_LSMS_ISA_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = 1/ $NPS_LSMS_ISA_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"
/*
*SAW Notes: $NPS_LSMS_ISA_W3_cons_ppp_dollar is for 2012 (last year of the survey values not 2017 not sure what we are trying to achieve here).
*Rural poverty headcount ratio (with new updated $2.15 poverty line in 2017 baseline year)
gen poverty_under_2_15check = daily_percap_cons < 2.15/ccf_1ppp
*/
*/

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
gen ccf_loc = (1/$UGA_W4_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$UGA_W4_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$UGA_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$UGA_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

*Poverty indicators 
gen poverty_under_1_9 = (daily_percap_cons < $UGA_W4_poverty_threshold)
la var poverty_under_1_9 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_2_15 = (daily_percap_cons < $UGA_W4_poverty_215)
la var poverty_under_2_15 "Household per-capita consumption is below $2.15 in 2017 $ PPP"

* Need to figure out National poverty lines for Uganda wave 4
*We merge the national poverty line provided by the World bank "${UGS_W3_raw_data}/AGSEC9"
*merge 1:1 HHID using "${Uganda_NPS_W4_raw_data}/HH/pov2013_14", keep(1 3) nogen
merge 1:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_consumption.dta", keep(1 3) nogen
*gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W1_poverty_nbs
rename poor_13 poverty_under_npl
la var poverty_under_npl "Household per-capita consumption is below national poverty line in 05/06 PPP prices"
*/
*generating clusterid and strataid
gen clusterid=ea
gen strataid=region

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
keep HHID fhh clusterid strataid *weight* *wgt* region region sregion district county county_name parish parish_name ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* /**total_harv_area**/ /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh /*fishing_hh*/ *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* /*nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* /*area_harv**/  *value_pro* *value_sal*
*SAW 3/14/23 Need to check for the ones available in Uganda but not in Nigeria.
*What about harvested_*, 

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = HHID 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
la var geography "Location of survey"
gen survey = "LSMS-ISA"
la var survey "Survey type (LSMS or AgDev)"
gen year = "2013-14"
la var year "Year survey was carried out"
gen instrument = 26
la var instrument "Wave and location of survey"
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" /*
    */ 25 "Uganda NPS Wave 3" 26 "Uganda NPS Wave 4"
label values instrument instrument	
*SAW Notes: We need an actual number for Uganda waves. 
saveold "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_household_variables.dta", replace

*SAW 3/14/23 Notes: Check the numbers, add variables that are available in Uganda but not in Nigeria, update the poverty line ($1.90 to $2.15) with correct estimation.

********************************************************************************
                          *INDIVIDUAL-LEVEL VARIABLES*
********************************************************************************
*SAW 9/29/23 This section uses Uganda Wave 3 as reference
use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_person_ids.dta", clear
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_control_income.dta", keep(1 3) nogen
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_make_ag_decision.dta", keep(1 3) nogen // How are we computing percentages? Do we include all individuals or only the ones that responded the survey section? 
merge 1:1 HHID PID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_ownasset.dta", keep(1 3) nogen
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhsize.dta", keep(1 3) nogen
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_fert_use.dta", keep(1 3) nogen
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_improvedseed_use.dta", keep(1 3) nogen
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_farmer_vaccine.dta", keep(1 3) nogen
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", keep(1 3) nogen

*Land rights
merge 1:1 HHID indiv using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_land_rights_ind.dta", nogen keep(1 3)
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_household_variables.dta", clear
keep HHID ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 HHID using `ag_hh', nogen keep (1 3)
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

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = HHID 
lab var hhid_panel "panel hh identifier" 
ren PID indid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2013-14"
gen instrument = 26
capture label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)"  /*
	*/ 25 "Uganda Wave 3" 26 "Uganda NPS Wave 4" 

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
collapse (sum) plot_value_harvest = s_value_harvest, by(HHID parcel_id plot_id season)
tempfile crop_values 
save `crop_values' // season level

use "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", clear // plot-season level
merge m:1 HHID using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_weights.dta", keep (1 3) nogen // hh level
merge 1:1 HHID parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge 1:1 HHID parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", keep (1 3) nogen //  plot-season level
merge m:1 HHID parcel_id plot_id using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_labor_days.dta", keep (1 3) nogen  // plot level

/*DYA.12.2.2020*/ merge m:1 HHID using  "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region ea)
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

*SAW 4/20/23 Update
****Currency Conversion Factors***
gen ccf_loc = (1/$UGA_W4_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$UGA_W4_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$UGA_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$UGA_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

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
rename v1 UGA_wave3
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_gendergap.dta", replace

restore

/*BET.12.4.2020 - END*/ 


foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen HHID_panel = HHID 
lab var HHID_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2013-14"
gen instrument = 26
capture label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)"   /*
	*/ 25 "Uganda Wave 3" 26 "Uganda NPS Wave 4"
label values instrument instrument		
saveold "${Uganda_NPS_W4_final_data}/Uganda_NPS_W4_field_plot_variables.dta", replace

*SAW Notes: I still need to figure out if we want data at the plot-season level or at the plot-year level, then I will need to update the subsections that are merged in this section 

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
do "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\_SUMMARY_STATS\378_Uganda_Wave4_summarystats_SAW10.03.23.do"
*do "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\335 - Ag Team Data Support\Waves\_Summary_statistics\EPAR_UW_335_SUMMARY_STATISTICS_01.17.2020_alt.do" 
*Sebastian notes: We have created this folder in 378.
*Just addding comment to make sur Github commit and push work.



************************************ STOP ************************************
