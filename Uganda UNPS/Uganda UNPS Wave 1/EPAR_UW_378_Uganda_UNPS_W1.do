/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 1 (2009-10)
*Author(s)		: Didier Alia, David Coomes, Elan Ebeling, Nina Forbes, Nida Haroon
				  Muel Kiel, Anu Sidhu, Isabella Sun, Emma Weaver, Ayala Wineman, 
				  C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 3 February 2023

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*W1_EPAR_UW_378_Uganda_EFW_1.22.19_CH_2.4.20CJS.do
*Data source
*----------------------------------------------------------------------------
*The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period 2009 - 2010. //EFW 1.22.19 Which months?
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1001

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "Uganda UNPS - LSMS-ISA - Wave 1 (2009-10)" folder within the "Raw DTA files" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "/Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)/TZA_W4_created_data" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file paths. Double check with Leigh et al. that OK to change
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file path 

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Uganda_NPS_LSMS_ISA_W1_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //EFW 1.22.19 Update this with new file paths
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_LSMS_ISA_W1_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_LSMS_ISA_W1_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_LSMS_ISA_W1_hhsize.dta
*PARCEL AREAS						Uganda_NPS_LSMS_ISA_W1_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Uganda_NPS_LSMS_ISA_W1_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_LSMS_ISA_W1_tempcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W1_tempcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W1_permcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W1_permcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W1_hh_crop_production.dta
									Uganda_NPS_LSMS_ISA_W1_plot_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W1_parcel_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W1_crop_residues.dta
									Uganda_NPS_LSMS_ISA_W1_hh_crop_prices.dta
									Uganda_NPS_LSMS_ISA_W1_crop_losses.dta
*CROP EXPENSES						Uganda_NPS_LSMS_ISA_W1_wages_mainseason.dta
									Uganda_NPS_LSMS_ISA_W1_wages_shortseason.dta
									
									Uganda_NPS_LSMS_ISA_W1_fertilizer_costs.dta
									Uganda_NPS_LSMS_ISA_W1_seed_costs.dta
									Uganda_NPS_LSMS_ISA_W1_land_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W1_asset_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W1_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_LSMS_ISA_W1_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_LSMS_ISA_W1_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W1_livestock_expenses.dta
									Uganda_NPS_LSMS_ISA_W1_hh_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W1_livestock_sales.dta
									Uganda_NPS_LSMS_ISA_W1_TLU.dta
									Uganda_NPS_LSMS_ISA_W1_livestock_income.dta

*FISH INCOME						Uganda_NPS_LSMS_ISA_W1_fishing_expenses_1.dta
									Uganda_NPS_LSMS_ISA_W1_fishing_expenses_2.dta
									Uganda_NPS_LSMS_ISA_W1_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_LSMS_ISA_W1_self_employment_income.dta
									Uganda_NPS_LSMS_ISA_W1_agproducts_profits.dta
									Uganda_NPS_LSMS_ISA_W1_fish_trading_revenue.dta
									Uganda_NPS_LSMS_ISA_W1_fish_trading_other_costs.dta
									Uganda_NPS_LSMS_ISA_W1_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_LSMS_ISA_W1_wage_income.dta
									Uganda_NPS_LSMS_ISA_W1_agwage_income.dta
*OTHER INCOME						Uganda_NPS_LSMS_ISA_W1_other_income.dta
									Uganda_NPS_LSMS_ISA_W1_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_LSMS_ISA_W1_land_size.dta
									Uganda_NPS_LSMS_ISA_W1_farmsize_all_agland.dta
									Uganda_NPS_LSMS_ISA_W1_land_size_all.dta
*FARM LABOR							Uganda_NPS_LSMS_ISA_W1_farmlabor_mainseason.dta
									Uganda_NPS_LSMS_ISA_W1_farmlabor_shortseason.dta
									Uganda_NPS_LSMS_ISA_W1_family_hired_labor.dta
*VACCINE USAGE						Uganda_NPS_LSMS_ISA_W1_vaccine.dta
*USE OF INORGANIC FERTILIZER		Uganda_NPS_LSMS_ISA_W1_fert_use.dta
*USE OF IMPROVED SEED				Uganda_NPS_LSMS_ISA_W1_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_LSMS_ISA_W1_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_LSMS_ISA_W1_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_LSMS_ISA_W1_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W1_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W1_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_LSMS_ISA_W1_hh_cost_land.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs_lrs.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_inputs_srs.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_seed_lrs.dta
									Uganda_NPS_LSMS_ISA_W1_hh_cost_seed_srs.dta		
									Uganda_NPS_LSMS_ISA_W1_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_LSMS_ISA_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_LSMS_ISA_W1_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_LSMS_ISA_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_LSMS_ISA_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_LSMS_ISA_W1_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_LSMS_ISA_W1_ag_wage.dta
*CROP YIELDS						Uganda_NPS_LSMS_ISA_W1_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_LSMS_ISA_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_LSMS_ISA_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_LSMS_ISA_W1_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_LSMS_ISA_W1_summary_stats.xlsx
*/

clear
set more off
clear matrix
clear mata
*set maxvar 8000 
ssc install findname

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global root_folder "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave1-2009-10"
*global root_folder "/Volumes/wfs/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave1-2009-10" 
*global root_folder "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave1-2009-10" 

global UGS_W1_raw_data 	"${root_folder}/raw_data"
global UGS_W1_created_data "${root_folder}/temp"
global UGS_W1_final_data  "${root_folder}/outputs"


****************************
*EXCHANGE RATE AND INFLATION
****************************
global NPS_LSMS_ISA_W1_exchange_rate 3690.85
global NPS_LSMS_ISA_W1_gdp_ppp_dollar 1098.23    // https://data.worldbank.org/indicator/PA.NUS.PPP //updated 6.6.19
global NPS_LSMS_ISA_W1_cons_ppp_dollar 1206.87	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP //updated 6.6.19
global NPS_LSMS_ISA_W1_inflation  0.58 // (158-100)/100 https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2010

********Currency Conversion Factors*********



/*
********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

*/


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************

/*how to determine "top 10"? "by area planted per instrument?" - will come back to this later (need to update entire section) CJS 2.4.20

*maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana

//List of crops for this instrument - including 12 priority and any additional crops from the top 10

/*
maize
rice 
wheat
sorghum
finger millet
cowpea 
groundnut
beans
yam
sweet potato
cassava 
banana (food)
*top 10...?
*/
 
*Enter the 12 priority crops here, plus any crop in the top ten that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum fmill cowpea grdnt beans yam swtptt cassav banana"
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"
*/


***************
*HOUSEHOLD IDS*
***************
use "${UGS_W1_raw_data}/2009_GSEC1.dta", clear
ren h1aq1 district
ren h1aq2 county
ren h1aq2b county_name
ren h1aq3 subcounty
ren h1aq3b subcounty_name 
ren h1aq4 parish
ren h1aq4b parish_name
ren comm ea
ren wgt09 weight //includes split off households
gen rural=urban==0
keep region district county county_name subcounty subcounty_name parish parish_name ea HHID rural stratum weight
lab var rural "1 = Household lives in rural area"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhid.dta", replace

****************
*INDIVIDUAL IDS*
****************
use "${UGS_W1_raw_data}/2009_GSEC2.dta", clear
gen female=h2q3==2
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "Individual age"
gen hh_head=h2q4==1
lab var hh_head "1= individual is household head"
 
ren h2q1 individ //2009/10 roster number 
keep HHID PID female age hh_head individ

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", replace


****************
*HOUSEHOLD SIZE*
****************
use "${UGS_W1_raw_data}/2009_GSEC2.dta", clear
gen hh_members = 1
ren h2q4 relhead
ren h2q3 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (HHID)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhsize.dta", replace

 
************
*PLOT AREAS*
************
use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id==.
gen area_acres_est = A2aq5
replace area_acres_est = A2bq5 if area_acres_est == .
gen area_acres_meas = A2aq4
replace area_acres_meas = A2bq4 if area_acres_meas == .
*keep if area_acres_est !=.
drop if area_acres_est==. & area_acres_meas==. 
keep HHID parcel_id area_acres_est area_acres_meas
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot area in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", replace


**********************
*PLOT DECISION MAKERS*
**********************
use "${UGS_W1_raw_data}/2009_GSEC2.dta", clear
ren h2q1 personid  //this ID combined with the HHID is the unique person identifier
gen relhead=h2q4 
gen female=h2q3==2
gen age=h2q8
gen head = h2q4==1 if h2q4!=.
keep personid female age HHID head relhead PID
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_gender_merge.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear //land household owns
*count if a2aq2 == . //0 observations
gen cultivated = (A2aq13a==1 | A2aq13a==2) //first cropping season
replace cultivated = 1 if (A2aq13b==1 | A2aq13b==2) //second cropping season
ren A2aq2 plotnum

append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta" //land household has user rights to
replace plotnum = A2bq2 if plotnum == .
drop if plotnum == .
ren Hhid HHID
replace cultivated = 1 if (A2bq15a==1 | A2bq15a==2 | A2bq15b==1 | A2bq15b==2) //first & second cropping season

*Gender/age variables
gen personid = A2aq27a //"Who usually (mainly) works on this parcel?" //Decided to NOT use "Who managed/controls the output from this parcel?" because less similar to questions in 
replace personid = A2bq25a if personid == . & A2bq25a!=.
merge m:1 HHID personid using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_gender_merge.dta", gen(dm1_merge) keep(1 3) //Dropping unmatched from using

*first decision-maker variable
gen dm1_female = female
drop female personid

*second decision-maker
gen personid = A2aq27b //"Who usually (mainly) works on this parcel?" //Decided to NOT use "Who managed/controls the output from this parcel?" because less similar to questions in 
replace personid = A2bq25b if personid == . & A2bq25b!=.                                                                
merge m:1 HHID personid using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_gender_merge.dta", gen(dm2_merge) keep(1 3) //Dropping unmatched from using
gen dm2_female = female
drop female personid

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & !(dm1_female==. & dm2_female==.)		
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & !(dm1_female==. & dm2_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhsize.dta", nogen 								
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
ren plotnum parcel_id 
drop if  parcel_id==.
keep HHID parcel_id dm_gender  cultivated  
lab var cultivated "1=Plot has been cultivated"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta", replace


*Notes: Renaming variables in 5A/5B related to area planted to can merge in below in monocropped plots
**************
*AREA PLANTED*
**************
use "${UGS_W1_raw_data}/2009_AGSEC4A", clear
gen season = 1
append using "${UGS_W1_raw_data}/2009_AGSEC4b"
replace season = 2 if season == .
ren Hhid HHID
ren A4aq1 cultivated
replace cultivated = A4bq1 if cultivated==. & A4bq1!=.
ren A4aq2 parcel_id
replace parcel_id = A4bq2 if parcel_id==. & A4bq2!=.
ren A4aq4 plot_id
replace plot_id = A4bq4 if plot_id==. & A4bq4!=.
ren A4aq6 cropcode 
replace cropcode = A4bq6 if cropcode==. & A4bq6!=.

gen plot_ha_planted = A4aq8*(1/2.47105)
replace plot_ha_planted = A4bq8*(1/2.47105) if plot_ha_planted==. 

merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta", nogen keep(1 3)			//1,258 unmatched from master
*Adjust for inter-cropping
gen per_intercropped=A4aq9 
replace per_intercropped=A4bq9 if per_intercropped==.  // ta a4bq9  - no obs. No intercropping in second season/visit? 
replace  per_intercropped=50 if per_intercropped==500 // this is clearly a typo and I am guessing the value is  50%
replace per_intercropped=per_intercropped/100
recode per_intercropped (0=.)
gen  is_plot_intercropped=A4aq7==2 | A4bq7==2
replace is_plot_intercropped=1 if per_intercropped!=.  // 31 changes
*Scale down percentage
bys  HHID parcel_id plot_id   : egen total_percent_planted = total(per_intercropped)		if 	is_plot_intercropped==1
replace plot_ha_planted=plot_ha_planted if is_plot_intercropped==0
replace plot_ha_planted=plot_ha_planted*(per_intercropped/total_percent_planted) if is_plot_intercropped==1
*Now sum area planted for sub-plots should not exceed field size. If so rescal proportionally including for monocrops
bys  HHID parcel_id  : egen total_ha_planted = total(plot_ha_planted)
replace plot_ha_planted=plot_ha_planted*(area_meas_hectares/total_ha_planted) if  	total_ha_planted>area_meas_hectares & total_ha_planted!=.
gen  ha_planted =plot_ha_planted 

keep HHID parcel_id plot_id cropcode season ha_planted

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_area_planted_temp.dta", replace


*******************
*MONOCROPPED PLOTS*
*******************

//12 priority crops
* maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana

global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana" // "finger millet" included as pmill; "banana food" included, did not include "banana beer" and " banana sweet"
global topcrop_area "130 120 111 150 141 222 310 210 640 620 630 741"
global comma_topcrop_area "130, 120, 111, 150, 141, 222, 310, 210, 640, 620, 630, 741"
global len : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$len"

*Generating area harvested and kilograms harvested
forvalues k=1(1)$len  {
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${UGS_W1_raw_data}/2009_AGSEC5A", clear
gen season = 1
append using "${UGS_W1_raw_data}/2009_AGSEC5b"
replace season = 2 if season == .
ren Hhid HHID

ren A5aq1 parcel_id 
replace parcel_id = A5bq1 if parcel_id==. & A5bq1!=.
drop if parcel_id==.
ren A5aq3 plot_id
replace plot_id = A5bq3 if plot_id==. & A5bq3!=.

ren A5aq5 cropcode
replace cropcode = A5bq5 if cropcode==. & A5bq5!=.
ren A5aq6d conversion
replace conversion = A5bq6d if conversion==. & A5bq6d!=.
ren A5aq6a qty_harvest
replace qty_harvest = A5bq6a if qty_harvest==. & A5bq6a!=.

gen kgs_harv_mono_`cn' = qty_harvest*conversion if cropcode==`c'

recode kgs_harv_mono_`cn' (.=0) //EFW 6.6.19

collapse (sum) kgs_harv_mono_`cn', by(HHID parcel_id plot_id cropcode season)
//Notes: There are >5k duplicates based on HHID parcel_id plot_id cropcode. Collapse for simplification, but double check duplicate observations/redownload data?

*merge in area planted
merge 1:1 HHID parcel_id plot_id cropcode season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_area_planted_temp.dta" 

xi i.cropcode, noomit
collapse (sum) kgs_harv_mono_`cn' ha_planted (max) _Icropcode_*, by(HHID parcel_id season) // collapse to parcel_id level since only available level in Wave 4
egen crop_count = rowtotal(_Icropcode_*)
keep if crop_count==1 & _Icropcode_`c'==1
duplicates report HHID parcel_id

gen `cn'_monocrop_ha=ha_planted
drop if `cn'_monocrop_ha==0 									 
gen `cn'_monocrop=1

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", replace
}

*Adding in gender of plot manager
forvalues k=1(1)$len  {
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", clear
merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta"

foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' { 
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
	replace `i'_male = . if dm_gender!=1
	replace `i'_female = . if dm_gender!=2
	replace `i'_mixed = . if dm_gender!=3
}

gen `cn'_monocrop_male = 0 
replace `cn'_monocrop_male=1 if dm_gender==1
gen `cn'_monocrop_female = 0 
replace `cn'_monocrop_female=1 if dm_gender==2
gen `cn'_monocrop_mixed = 0 
replace `cn'_monocrop_mixed=1 if dm_gender==3

*And now this code will indicate whether the HOUSEHOLD has at least one of these plots and the total area of monocropped plots
collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed `cn'_monocrop = _Icropcode_`c', by(HHID) 

foreach i in male female mixed {
	replace `cn'_monocrop_ha = . if `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if  `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_`i'==0
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_ha_`i'==0
	replace kgs_harv_mono_`cn' = . if `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if  `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_`i'==0 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_ha_`i'==0 
}


save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop_hh_area.dta", replace

}


********************************
*TLU (Tropical Livestock Units)*
********************************
use "${UGS_W1_raw_data}/2009_AGSEC6A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC6B"
append using "${UGS_W1_raw_data}/2009_AGSEC6C"
ren Hhid HHID

gen lvstckid = A6aq3
destring A6bq3 A6cq3, replace
replace lvstckid = A6bq3 if lvstckid ==. & A6bq3!=.
replace lvstckid = A6cq3 if lvstckid ==. & A6cq3!=.

gen lvstckname = A6aq2
replace lvstckname = A6bq2 if lvstckname =="" & A6bq2!=""
replace lvstckname = A6cq2 if lvstckname =="" & A6cq2!=""

gen tlu_coefficient =  0.5 if (lvstckid==1 | lvstckid==2 | lvstckid==3 | lvstckid==4 | lvstckid==5 | lvstckid==6) //Bulls and oxen, calves, heifer and cows
replace tlu_coefficient = 0.55 if lvstckid==8 //mules/horses; average of the two (horses = 0.5 and mules = 0.6)
replace tlu_coefficient = 0.3 if lvstckid==7 //donkeys
replace tlu_coefficient = 0.2 if lvstckid==21 //pigs
replace tlu_coefficient = 0.1 if (lvstckid==13 | lvstckid==14 | lvstckid==15 | lvstckid==16 | lvstckid==17 | lvstckid==18 | lvstckid==19 | lvstckid==20) //female & male goats & sheep
replace tlu_coefficient = 0.01 if (lvstckid==31 | lvstckid==32 | lvstckid==33 | lvstckid==34 | lvstckid==35 | lvstckid==36 | lvstckid==37 | lvstckid==38 | lvstckid==39 | lvstckid==40 |lvstckid==41) //rabbits, ducks, turkeys SW 7/30/21 changes tlu_coefficient to 0.01
//geese and other birds, backyard chicken, parent stock for broilers, parents stock for layers, layers, pullet chicks, growers, broilers; beehives not included

lab var tlu_coefficient "Tropical Livestock Unit coefficient"

gen cattle=inrange(lvstckid,1,6)
gen smallrum=inrange(lvstckid,13,21)
gen poultry=inrange(lvstckid,31,41)
gen other_ls=inlist(lvstckid,7,8)
gen cows=inlist(lvstckid,3,6)
gen chickens=inlist(lvstckid,32,35,36,37,38)
//Notes: survey asks questions for different time period for cattle & pack animals (12 months), small animals (6 months), and poultry & other animals (3 months).
//Currently convert all but "how many did you own (x time period) ago? since that does not logically scale
*Notes: drop some big outliers in (A6aq7, a6bq7, A6cq7) from the analysis since indicators were off the charts relative to UG w3, w2 and TZN W4

gen nb_ls_1yearago = A6aq7
replace nb_ls_1yearago = A6bq7 if nb_ls_1yearago==. & A6bq7!=. 
replace nb_ls_1yearago = A6cq7 if nb_ls_1yearago==. & A6cq7!=.
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
gen nb_ls_today= A6aq5
replace nb_ls_today = A6bq5 if nb_ls_today==. & A6bq5!=.
replace nb_ls_today = A6cq5 if nb_ls_today==. & A6cq5!=.
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
gen income_live_sales = A6aq15
replace income_live_sales = 2*A6bq15 if income_live_sales==. & A6bq15!=.
replace income_live_sales = 4*A6cq15 if income_live_sales==. & A6cq15!=.
gen number_sold = A6aq14
replace number_sold = 2*A6bq14 if number_sold==. & A6bq14!=.
replace number_sold = 4*A6cq14 if number_sold==. & A6cq14!=.
ren lvstckid livestock_code
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*, by(HHID)
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
drop tlu_coefficient
drop if HHID==""
*Notes: In the construction of this indicator there are big outliers in the variables used to construct TLU coefficients. Not sure how to proceed (eliminate them now or wait until winzorization).
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_TLU_Coefficients.dta", replace

************************
*GROSS CROP REVENUE
************************
use "${UGS_W1_raw_data}/2009_AGSEC5A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC5B"
ren Hhid HHID
ren A5aq1 parcel_id
replace parcel_id = A5bq1 if parcel_id==. & A5bq1!=.
ren A5aq3 plot_id
replace plot_id = A5bq3 if plot_id==. & A5bq3!=.
ren A5aq4 crop_name
replace crop_name = A5bq4 if crop_name=="" & A5bq4!="" 
ren A5aq5 crop_code
replace crop_code = A5bq5 if crop_code==. & A5bq5!=.

drop if plot_id == . //2,422 observations deleted

ren A5aq6a qty_harvest
replace qty_harvest = A5bq7a if qty_harvest==. & A5bq7a!=.
ren A5aq6d conversion
replace conversion = A5bq6d if conversion==. & A5bq6d!=.

gen kgs_harvest = qty_harvest * conversion

ren A5aq7a qty_sold
replace qty_sold = A5bq7a if qty_sold==. & A5bq7a!=. 
ren A5aq7c unit_sold
replace unit_sold = A5bq7c if unit_sold==. & A5bq7c!=.
ren A5aq7b condition_sold 
replace condition_sold = A5bq7b if condition_sold==. & A5bq7b!=.

*rename condition and unit of harvest for comparison & conversion below
ren A5aq6b condition_harv
replace condition_harv = A5bq6b
ren A5aq6c unit_harv
replace unit_harv = A5bq6c

*Convert qty_sold to kgs_sold
gen kgs_sold = qty_sold * conversion if (condition_sold == condition_harv) & (unit_sold == unit_harv) //use qty_harvest conversion factor where unit and condition are the same; 18,576
count if kgs_sold == . & (qty_sold !=0 & qty_sold !=.) //3,987 observations
replace kgs_sold = qty_sold if (unit_sold==1 | unit_sold==50 | unit_sold==41) & kgs_sold==. //kilogram (kg), packet (1 kg), loaf (1 kg) units; 853 changes made
replace kgs_sold = qty_sold*2 if (unit_sold==49 | unit_sold==40) & kgs_sold==. //packet (2kgs) and basket (2kgs); 14 changes made
replace kgs_sold = qty_sold*120 if unit_sold==9 & kgs_sold==. //sack (120 kgs); 173 changes made
replace kgs_sold = qty_sold*100 if unit_sold==10 & kgs_sold==. //sack (100 kgs); 792 changes made
replace kgs_sold = qty_sold*80 if unit_sold==11 & kgs_sold==. //sack (80 kgs); 57 changes made
replace kgs_sold = qty_sold*50 if unit_sold==12 & kgs_sold==. //sack (50 kgs); 98 changes made
replace kgs_sold = qty_sold*20 if unit_sold==37 & kgs_sold==. //basket (20 kgs); 14 changes made
replace kgs_sold = qty_sold*10 if unit_sold==38 & kgs_sold==. //basket (10 kgs); 14 changes made
replace kgs_sold = qty_sold*5 if unit_sold==39 & kgs_sold==. //sack (5 kgs); 8 changes made

count if (condition_harv==. & unit_harv ==. & conversion!=.) & (kgs_sold == . & (qty_sold !=0 & qty_sold !=.)) //1,719
*Assume unit & condition sold same as harvest if harvest condition & unit missing 
replace kgs_sold = qty_sold * conversion if condition_harv==. & unit_harv ==. & conversion!=. & qty_sold!=0 & qty_sold!=. & kgs_sold==. //1,719 changes made

count if kgs_sold == . & (qty_sold !=0 & qty_sold !=.) //247 observations
replace kgs_sold = qty_sold * conversion if unit_sold==unit_harv & kgs_sold==. //81 changes made; in remaining observations conversion is the same for same unit_harv with different condition
count if kgs_sold == . & (qty_sold !=0 & qty_sold !=.) //185 observations; EFW 4.30.19 not sure what to do about these remaining observations...

ren A5aq8 value_sold // Unclear if this is the value sold (but assume that it is). Question is "what was the value?" and comes after question on value sold, so assume it is value sold

recode kgs_harvest kgs_sold value_sold qty_sold (.=0) //EFW 6.6.19 correct?

collapse (sum) kgs_harvest kgs_sold value_sold qty_sold, by (HHID parcel_id plot_id crop_code)

lab var kgs_harvest "Kgs harvest of this crop"
lab var kgs_sold "Kgs sold of this crop"
lab var value_sold "Value sold of this crop"

*Price per kg
gen price_kg = value_sold/kgs_sold
lab var price_kg "price per kg sold"

recode price_kg (0=.)
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2 //638 observations not matched from using
drop _merge

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", replace


*Impute crop prices from sales
//median price at the ea level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district county subcounty parish ea crop_code: egen obs_ea = count (observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty parish ea crop_code obs_ea)
rename price_kg price_kg_median_ea

lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_ea.dta", replace 

//median price at the parish level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district county subcounty parish crop_code: egen obs_parish = count (observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty parish crop_code obs_parish)
rename price_kg price_kg_median_parish

lab var price_kg_median_parish "Median price per kg for this crop in the parish"
lab var obs_parish "Number of sales observations for this crop in the parish"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_parish.dta", replace

//median price at the subcounty level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district county subcounty crop_code: egen obs_sub = count (observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty crop_code obs_sub)
rename price_kg price_kg_median_sub

lab var price_kg_median_sub "Median price per kg for this crop in the subcounty"
lab var obs_sub "Number of sales observations for this crop in the subcounty"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", replace

//median price at the county level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district county crop_code: egen obs_county = count (observation)
collapse (median) price_kg [aw=weight], by (region district county crop_code obs_county)
rename price_kg price_kg_median_county

lab var price_kg_median_county "Median price per kg for this crop in the county"
lab var obs_county "Number of sales observations for this crop in the county"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_county.dta", replace

//median price at the district level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region district crop_code: egen obs_district = count (observation)
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district

lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_district.dta", replace

//median price at the region level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count (observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region

lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_region.dta", replace

//median price at the country level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count (observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country

lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_country.dta", replace


*Pull prices into harvest estimates
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
merge m:1 region district county subcounty parish ea crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_ea.dta", nogen
merge m:1 region district county subcounty parish crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_parish.dta", nogen
merge m:1 region district county subcounty crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", nogen
merge m:1 region district county crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_county.dta", nogen
merge m:1 region district crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_country.dta", nogen

gen price_kg_hh = price_kg

//Impute prices based on local median values
replace price_kg  = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 //Don't impute prices for "other" crops
replace price_kg  = price_kg_median_parish if price_kg==. & obs_parish >= 10 & crop_code!=890
replace price_kg  = price_kg_median_sub if price_kg==. & obs_sub >= 10 & crop_code!=890
replace price_kg  = price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg  = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890
replace price_kg  = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=890
replace price_kg  = price_kg_median_country if price_kg==. & obs_country >= 10 & crop_code!=890
lab var price_kg "Price per kg, with missing values imputed using local median values"

// Since we don't have value harvest for this instrument computing value harvest as price_kg * kgs_harvest for everything. 
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=.  // This instrument doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_values_tempfile.dta", replace

preserve
// qty_sold is not kgs for uganda wave 1 and 2 replacing qty_sold
// with kgs_sold
recode value_harvest_imputed value_sold kgs_harvest kgs_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest kgs_sold, by(HHID crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production"
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
lab var kgs_harvest "Kgs harvested of this crop"
// end SAK
lab var kgs_sold "Kgs sold of this crop"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_values_production.dta", replace
restore
*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested,  

collapse (sum) value_harvest_imputed value_sold, by (HHID)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. //17 changes made
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household responses for value of crop production sold. This is used to calculate a price per kg and then multiplied by the kgs harvested.
*Prices are imputed using local median values when there are no sales.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_production.dta", replace 

*Plot value of crop production
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (HHID parcel_id plot_id) // double check that this is the correct level
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_cropvalue.dta", replace

*Crop values for inputs in agricultural product processing (self-employment)
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_sales.dta", clear
merge m:1 region district county subcounty parish ea crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_ea.dta", nogen
merge m:1 region district county subcounty parish crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_parish.dta", nogen
merge m:1 region district county subcounty crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_subcounty.dta", nogen
merge m:1 region district county crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_county.dta", nogen
merge m:1 region district crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_prices_country.dta", nogen
replace price_kg  = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 //Don't impute prices for "other" crops
replace price_kg  = price_kg_median_parish if price_kg==. & obs_parish >= 10 & crop_code!=890
replace price_kg  = price_kg_median_sub if price_kg==. & obs_sub >= 10 & crop_code!=890
replace price_kg  = price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg  = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890
replace price_kg  = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=890
replace price_kg  = price_kg_median_country if price_kg==. & obs_country >= 10 & crop_code!=890 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=.  // This instrument doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
*keep HHID crop_code price_kg
*duplicates drop 
//Price information in this wave is at the plot-crop level, not the hh-crop level. Collapse (mean) to the hh-crop level? 
recode price_kg (.=0)
collapse (mean) price_kg, by (HHID crop_code) //when summarize the data the 1% is higher, but 50% is similar; when just drop duplicates it is closer to the full data summarized. Look into.
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_prices.dta", replace

*Crops lost post-harvest //EFW 5.8.19 construct this as value crop production * percent lost similar to Ethiopia waves
use "${UGS_W1_raw_data}/2009_AGSEC5A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC5B"
ren Hhid HHID
ren A5aq1 parcel_id
replace parcel_id = A5bq1 if parcel_id==. & A5bq1!=.
ren A5aq3 plot_id
replace plot_id = A5bq3 if plot_id==. & A5bq3!=.
ren A5aq4 crop_name
replace crop_name = A5bq4 if crop_name=="" & A5bq4!="" 
ren A5aq5 crop_code
replace crop_code = A5bq5 if crop_code==. & A5bq5!=.

drop if crop_code==. //3,471 observations dropped

rename A5aq16 percent_lost
replace percent_lost = A5bq16 if percent_lost==. & A5bq16!=.

replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. //33 changes made

merge m:1 HHID crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_crop_values_production.dta"
drop if _merge==2

gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0) 
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_losses.dta", replace


************************
*CROP EXPENSES
************************ 
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear
ren Hhid HHID
*rename parcel, plot ids
rename A3aq1 parcel_id
rename A3aq3 plot_id

*Expenses: Hired labor
rename A3aq43 wages_paid_main

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_mainseason_temp.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC5A", clear
ren Hhid HHID
rename A5aq1 parcel_id
rename A5aq3 plot_id

merge m:1 HHID parcel_id plot_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_mainseason_temp.dta", nogen 

*Monocropped plots
foreach cn in $topcropname_area {
preserve
	gen season = 1
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
	foreach i in wages_paid_main {
		gen `i'_`cn' = `i'
		gen `i'_`cn'_male = `i' if dm_gender==1 
		gen `i'_`cn'_female = `i' if dm_gender==2 
		gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	
	*merge in monocropped plots
	merge m:1 HHID parcel_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) wages_paid_main_`cn'*, by(HHID)
	lab var wages_paid_main_`cn' "Wages for hired labor in main growing season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_main_`cn'_`g' "Wages for hired labor in main growing season - Monocropped `g' `cn' plots"
	}
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_mainseason_`cn'.dta", replace
	
restore
}

collapse(sum) wages_paid_main, by(HHID)
lab var wages_paid_main  "Wages paid for hired labor (crops) in main growing season"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_mainseason.dta", replace


use "${UGS_W1_raw_data}/2009_AGSEC3B", clear
*rename parcel, plot ids
rename a3bq1 parcel_id
rename a3bq3 plot_id

*Expenses: Hired labor
rename a3bq43 wages_paid_short

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_shortseason_temp.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC5B", clear
ren Hhid HHID
rename A5bq1 parcel_id
rename A5bq3 plot_id 

merge m:1 HHID parcel_id plot_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_shortseason_temp.dta", nogen  

*Monocropped plots
foreach cn in $topcropname_area {
preserve
	gen season = 2
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta"
	foreach i in wages_paid_short {
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	
	*merge in monocropped plots
	merge m:1 HHID parcel_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) wages_paid_short_`cn'*, by(HHID)
	lab var wages_paid_short_`cn' "Wages for hired labor in short growing season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_short_`cn'_`g' "Wages for hired labor in short growing season - Monocropped `g' `cn' plots"
	}
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_shortseason_`cn'.dta", replace
	
restore
}

collapse (sum) wages_paid_short, by (HHID)
lab var wages_paid_short "Wages paid for hired labor (crops) in short growing season"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_shortseason.dta", replace


*Formalized Land Rights
use "${UGS_W1_raw_data}/2009_AGSEC2A", clear //current land holdings
* Don't include section 2b: land that household has access through use rights. No question about formal certificate or title, just "How did you acquire this parcel? 1=agreement with land/use rights owner; 2=Without agreement with land/use rights owner
ren Hhid HHID
gen formal_land_rights = A2aq25!=4

*individual level (for women)
*starting with the first owner
preserve
	ren A2aq26a individ
	merge m:1 HHID individ using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", nogen keep(3)
	keep HHID individ female formal_land_rights
	tempfile p1
	save `p1', replace
restore

*Now second owner
preserve
	ren A2aq26b individ
	merge m:1 HHID individ using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", nogen keep(3)
	keep HHID PID female
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 & female==1
	collapse(max) formal_land_rights_f, by(HHID individ)
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rights_ind.dta", replace
restore

collapse (max) formal_land_rights_hh = formal_land_rights, by(HHID)
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rights_hh.dta", replace


*Expenses: Inputs
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear
gen season = 1
ren Hhid HHID
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
replace season = 2 if season == .

ren A3aq1 parcel_id
replace parcel_id = a3bq1 if parcel_id==. & a3bq1!=.
ren A3aq3 plot_id
replace plot_id = a3bq3 if plot_id==. & a3bq3!=.

gen value_fertilizer = A3aq19 //value of fertilizer purchased
replace value_fertilizer = a3bq19 if value_fertilizer == .
gen value_pesticide = A3aq31
replace value_pesticide = a3bq31 if value_pesticide == . //value of pesticide purchased

recode value_fertilizer value_pesticide (.=0) 

*Monocropped plots
foreach cn in $topcropname_area {					
preserve
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta" 
	*merge in monocropped plots
	merge m:1 HHID parcel_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3) //no error here
	foreach i in value_fertilizer value_pesticide {
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1
	gen `i'_`cn'_female = `i' if dm_gender==2
	gen `i'_`cn'_mixed = `i' if dm_gender==3
}
	collapse(sum) value_fertilizer_`cn'* value_pesticide_`cn'*, by(HHID)
	lab var value_fertilizer_`cn' "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	lab var value_pesticide_`cn' "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_fertilizer_costs_`cn'.dta", replace
restore
}

collapse (sum) value_fertilizer value_pesticide, by (HHID) 
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons" 
lab var value_pesticide "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_fertilizer_costs.dta", replace

*Seed
use "${UGS_W1_raw_data}/2009_AGSEC4A", clear
gen season = 1
append using "${UGS_W1_raw_data}/2009_AGSEC4B"
replace season = 2 if season ==.
ren Hhid HHID
ren A4aq2 parcel_id
replace parcel_id = A4bq2 if parcel_id==. & A4bq2!=.
ren A4aq4 plot_id
replace plot_id = A4bq4 if plot_id==. & A4bq4!=.

gen cost_seed = A4aq11
replace cost_seed = A4bq11 if cost_seed==. 
recode cost_seed (.=0)

*Monocropped plots
foreach cn in $topcropname_area {
preserve 
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta" 
	gen cost_seed_male=cost_seed if dm_gender==1
	gen cost_seed_female=cost_seed if dm_gender==2
	gen cost_seed_mixed=cost_seed if dm_gender==3
	*merge in monocropped plots
	merge m:1 HHID parcel_id season using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3) //no error here
	collapse (sum) cost_seed_`cn' = cost_seed cost_seed_`cn'_male = cost_seed_male cost_seed_`cn'_female = cost_seed_female cost_seed_`cn'_mixed = cost_seed_mixed, by(HHID)		// renaming all to "_`cn'" suffix
	lab var cost_seed_`cn' "Expenditures on seed for temporary crops - Monocropped `cn' plots only"
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_seed_costs_`cn'.dta", replace
restore
}

collapse(sum) cost_seed, by(HHID)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_seed_costs.dta", replace


*Land rental
use "${UGS_W1_raw_data}/2009_AGSEC2B", clear // information on land rental costs only included in "land that hh has use rights to" section
ren Hhid HHID
*rename parcel ID (no plot id in this section)
ren A2bq2 parcel_id
 
gen rental_cost_land = A2bq9 //how much rent did you or will you pay during the two cropping seasons?
recode rental_cost_land (.=0)

*Monocropped plots
foreach cn in $topcropname_area {
preserve
	*disaggregate by gender of plot manager
	merge 1:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_decision_makers.dta" 
	*merge in monocropped plots
	merge 1:m HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)
	gen rental_cost_land_`cn'=rental_cost_land
	gen rental_cost_land_`cn'_male=rental_cost_land if dm_gender==1
	gen rental_cost_land_`cn'_female=rental_cost_land if dm_gender==2
	gen rental_cost_land_`cn'_mixed=rental_cost_land if dm_gender==3
	*collapse(sum) rental_cost_land_`cn'* , by(HHID)	 // removed so don't double count rental costs for plots
	lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rental_costs_`cn'.dta", replace
restore
}

collapse(sum) rental_cost_land, by (HHID)
lab var rental_cost_land "Rental costs paid for land"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
// Costs not included in this instrument

*Transport costs for crop sales
use "${UGS_W1_raw_data}/2009_AGSEC5A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC5B"
ren Hhid HHID
rename A5aq10 transport_costs_cropsales
replace transport_costs_cropsales = A5bq10 if transport_costs_cropsales==.
recode transport_costs_cropsales (.=0)

collapse(sum) transport_costs_cropsales, by(HHID)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_transportation_cropsales.dta", replace

*Crop costs
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rental_costs.dta", clear
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_seed_costs.dta", nogen
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_fertilizer_costs.dta", nogen
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_shortseason.dta", nogen
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wages_mainseason.dta", nogen
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_transportation_cropsales.dta",nogen
recode rental_cost_land cost_seed value_fertilizer  /*
*/ value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_land cost_seed value_fertilizer /*
*/ value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crop_income.dta", replace

******************
*LIVESTOCK INCOME*
******************
*Expenses
use "${UGS_W1_raw_data}/2009_AGSEC7.dta", clear 
ren Hhid HHID
gen cost_fodder_livestock = A7q4 if A7q2==2 //"Livestock/poultry feed"
gen cost_hired_labor_livestock = A7q4 if A7q2==1 //"Hired labor for herding"
gen cost_vaccines_livestock = A7q4 if A7q2==3 //"Veterinary services/medicine" // Unsure if this should be included in other instead? Most other "veterinary services" costs are included with vaccines in other waves
gen cost_other_livestock = A7q4 if A7q2==4 //"Other expenses"
*Cannot disaggregate by species
recode cost_* (.=0)

collapse (sum) cost_*, by(HHID)

lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for veterinary services and medicine for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_expenses.dta", replace

*Livestock products
use "${UGS_W1_raw_data}/2009_AGSEC8.dta", clear 
ren Hhid HHID
rename A8q2 livestock_code
keep if livestock_code!=. //492 observations deleted. // some observations with values but with livestock_code missing
rename A8q3 months_produced
rename A8q4 quantity_month //average production per month
rename A8q5 quantity_month_unit
recode months_produced (12/max=12) //4 changes
*Standardize units 
replace quantity_month_unit	= 4 					if livestock_code == 5 & /*
	*/ quantity_month_unit == 3
replace quantity_month 		= quantity_month * 30	if livestock_code == 5 & /*
 	*/ quantity_month_unit == 3

gen quantity_produced = months_produced * quantity_month
la var quantity_produced "Quantity of this product produced in the past year"
rename A8q6 quantity_sold //average sales per month
rename A8q7 earnings_month //average sales per month
// Assume unit produced and unit sold are the same
gen price_per_unit = earnings_month/quantity_sold
recode price_per_unit (0=.)
/*
/Notes: no sales unit so cannot construct price per unit or value produced. Should we assumed unit produced is unit sold (e.g. unit produced for milk almost always liter)???
gen sales_milk = earnings_sales * months_produced if (livestock_code == 1 | livestock_code == 2 | livestock_code == 3)
gen sales_eggs = earnings_sales * months_produced if livestock_code == 5missign
gen sales_other = earnings_sales * months_produced if (livestock_code != 1 & livestock_code!=2 & livestock_code!=3 & livestock_code!=5)

recode sales_milk sales_eggs sales_other (.=0)

collapse (sum) sales_milk sales_eggs sales_other, by(HHID)
*/
gen earnings_milk_year = earnings_month * months_produced if (livestock_code == 1 | livestock_code == 2 | livestock_code == 3)
gen earnings_egg_year = earnings_month * months_produced if livestock_code == 5
gen earnings_sales = earnings_month * months_produced

keep HHID livestock_code price_per_unit quantity_produced quantity_sold earnings_milk_year earnings_egg_year earnings_sales

lab var price_per_unit "Price of livestock product per unit sold"
lab var quantity_produced "Quantity of livestock product produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
lab var earnings_egg_year "Total earnings of sale of eggs produced"

merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3)

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", replace

//median price at the ea level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district county subcounty parish ea livestock_code: egen obs_ea = count (observation)
collapse (median) price_per_unit [aw=weight], by (region district county subcounty parish ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_ea.dta", replace

//median price at the parish level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district county subcounty parish livestock_code: egen obs_parish = count (observation)
collapse (median) price_per_unit [aw=weight], by (region district county subcounty parish livestock_code obs_parish)
rename price_per_unit price_median_parish

lab var price_median_parish "Median price per unit for this livestock product in the parish"
lab var obs_parish "Number of sales observations for this livestock product in the parish"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_parish.dta", replace

//median price at the subcounty level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district county subcounty livestock_code: egen obs_sub = count (observation)
collapse (median) price_per_unit [aw=weight], by (region district county subcounty livestock_code obs_sub)
rename price_per_unit price_median_sub

lab var price_median_sub "Median price per unit for this livestock product in the subcounty"
lab var obs_sub "Number of sales observations for this livestock product in the subcounty"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_subcounty.dta", replace

//median price at the county level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district county livestock_code: egen obs_county = count (observation)
collapse (median) price_per_unit [aw=weight], by (region district county livestock_code obs_county)
rename price_per_unit price_median_county

lab var price_median_county "Median price per unit for this livestock product in the county"
lab var obs_county "Number of sales observations for this livestock product in the county"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_county.dta", replace

//median price at the district level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count (observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district

lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_district.dta", replace

//median price at the region level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count (observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region

lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_region.dta", replace

//median price at the country level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count (observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country

lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_country.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products", clear
merge m:1 region district county subcounty parish ea livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_ea.dta", nogen
merge m:1 region district county subcounty parish livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_parish.dta", nogen
merge m:1 region district county subcounty livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_subcounty.dta", nogen
merge m:1 region district county livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_county.dta", nogen
merge m:1 region district livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_products_prices_country.dta", nogen
replace price_per_unit  = price_median_ea if price_per_unit==. & obs_ea >= 10 
replace price_per_unit  = price_median_parish if price_per_unit==. & obs_parish >= 10 
replace price_per_unit  = price_median_sub if price_per_unit==. & obs_sub >= 10 
replace price_per_unit  = price_median_county if price_per_unit==. & obs_county >= 10 
replace price_per_unit  = price_median_district if price_per_unit==. & obs_district >= 10 //21 changes made
replace price_per_unit  = price_median_region if price_per_unit==. & obs_region >= 10 //706 changes made
replace price_per_unit  = price_median_country if price_per_unit==. & obs_country >= 10 //611 changes made

gen value_milk_produced = quantity_produced * price_per_unit if (livestock_code == 1 | livestock_code == 2 | livestock_code == 3)
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code == 5
gen value_other_produced = quantity_produced * price_per_unit if (livestock_code != 1 & livestock_code!=2 & livestock_code!=3 & livestock_code!=5)
gen sales_livestock_products = earnings_sales

collapse(sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by(HHID)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livesotck prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=. //11 changes made
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey, hides and skins, blood, meat, ghee produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_products", replace

*Sales (live animals)
use "${UGS_W1_raw_data}/2009_AGSEC6A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC6B"
append using "${UGS_W1_raw_data}/2009_AGSEC6C"
ren Hhid HHID
//Time periods differ across livestock type: Cattle & pack animals (12 months), small animals (6 months), poultry (3 months)
//Adjust time periods below to 12 months 
gen lvstckid = A6aq3
destring A6bq3 A6cq3, replace
replace lvstckid = A6bq3 if lvstckid ==. & A6bq3!=.
replace lvstckid = A6cq3 if lvstckid ==. & A6cq3!=.

rename lvstckid livestock_code

gen lvstckname = A6aq2
replace lvstckname = A6bq2 if lvstckname =="" & A6bq2!=""
replace lvstckname = A6cq2 if lvstckname =="" & A6cq2!=""

gen number_sold = A6aq14
replace number_sold = 2*A6bq14 if number_sold==. & A6bq14!=.
replace number_sold = 4*A6cq14 if number_sold==. & A6cq14!=.

gen income_live_sales = A6aq15 //total sales value of all sold
replace income_live_sales = A6bq15 if income_live_sales==. & A6bq15!=.
replace income_live_sales = A6cq15 if income_live_sales==. & A6cq15!=.

gen number_slaughtered = A6aq16
replace number_slaughtered = 2*A6bq16 if number_slaughtered==. & A6bq16!=.
replace number_slaughtered = 4*A6cq16 if number_slaughtered==. & A6cq16!=.

gen value_livestock_purchases = A6aq13
replace value_livestock_purchases = 2*A6bq13 if value_livestock_purchases==. & A6bq13!=.
replace value_livestock_purchases = 4*A6cq13 if value_livestock_purchases==. & A6cq13!=.

recode number_sold income_live_sales number_slaughtered value_livestock_purchases (.=0)

gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animale sold"
recode price_per_animal (0=.)
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta", nogen keep(1 3)

keep HHID region stratum weight district county county_name subcounty subcounty_name parish parish_name ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", replace

*Implicit prices
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district county subcounty parish ea livestock_code: egen obs_ea = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county subcounty parish ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_ea.dta", replace 

//median price at the parish level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district county subcounty parish livestock_code: egen obs_parish = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county subcounty parish livestock_code obs_parish)
rename price_per_animal price_median_parish

lab var price_median_parish "Median price per unit for this livestock in the parish"
lab var obs_parish "Number of sales observations for this livestock in the parish"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_parish.dta", replace

//median price at the subcounty level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district county subcounty livestock_code: egen obs_sub = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county subcounty livestock_code obs_sub)
rename price_per_animal price_median_sub

lab var price_median_sub "Median price per unit for this livestock in the subcounty"
lab var obs_sub "Number of sales observations for this livestock in the subcounty"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_subcounty.dta", replace

//median price at the county level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
gen observation = 1
bys region district county livestock_code: egen obs_county = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county livestock_code obs_county)
rename price_per_animal price_median_county

lab var price_median_county "Median price per unit for this livestock in the county"
lab var obs_county "Number of sales observations for this livestock in the county"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_county.dta", replace

//median price at the district level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
gen observation = 1
bys region district livestock_code: egen obs_district = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district

lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_district.dta", replace

//median price at the region level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
gen observation = 1
bys region livestock_code: egen obs_region = count (observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region

lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_region.dta", replace

//median price at the country level
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales.dta", clear
gen observation = 1
bys livestock_code: egen obs_country = count (observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country

lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_country.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_sales", clear
merge m:1 region district county subcounty parish ea livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_ea.dta", nogen
merge m:1 region district county subcounty parish livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_parish.dta", nogen
merge m:1 region district county subcounty livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_subcounty.dta", nogen
merge m:1 region district county livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_county.dta", nogen
merge m:1 region district livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_country.dta", nogen
replace price_per_animal  = price_median_ea if price_per_animal==. & obs_ea >= 10 
replace price_per_animal  = price_median_parish if price_per_animal==. & obs_parish >= 10 
replace price_per_animal  = price_median_sub if price_per_animal==. & obs_sub >= 10 
replace price_per_animal  = price_median_county if price_per_animal==. & obs_county >= 10 
replace price_per_animal  = price_median_district if price_per_animal==. & obs_district >= 10 
replace price_per_animal  = price_median_region if price_per_animal==. & obs_region >= 10 
replace price_per_animal  = price_median_country if price_per_animal==. & obs_country >= 10 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
//EFW 6.10.19 Don't have value slaughtered so just value with the live animal price (see construction decisions)
gen value_livestock_sales = value_lvstck_sold + value_slaughtered
collapse (sum) value_livestock_sales value_lvstck_sold value_slaughtered value_livestock_purchases, by (HHID)
drop if HHID==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${UGS_W1_raw_data}/2009_AGSEC6A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC6B"
append using "${UGS_W1_raw_data}/2009_AGSEC6C"
ren Hhid HHID
gen lvstckid = A6aq3
destring A6bq3 A6cq3, replace
replace lvstckid = A6bq3 if lvstckid ==. & A6bq3!=.
replace lvstckid = A6cq3 if lvstckid ==. & A6cq3!=.

gen lvstckname = A6aq2
replace lvstckname = A6bq2 if lvstckname =="" & A6bq2!=""
replace lvstckname = A6cq2 if lvstckname =="" & A6cq2!=""

gen tlu_coefficient =  0.5 if (lvstckid==1 | lvstckid==2 | lvstckid==3 | lvstckid==4 | lvstckid==5 | lvstckid==6) //Bulls and oxen, calves, heifer and cows
replace tlu_coefficient = 0.55 if lvstckid==8 //mules/horses; average of the two (horses = 0.5 and mules = 0.6)
replace tlu_coefficient = 0.3 if lvstckid==7 //donkeys
replace tlu_coefficient = 0.2 if lvstckid==21 //pigs
replace tlu_coefficient = 0.1 if (lvstckid==13 | lvstckid==14 | lvstckid==15 | lvstckid==16 | lvstckid==17 | lvstckid==18 | lvstckid==19 | lvstckid==20) //female & male goats & sheep
replace tlu_coefficient = 0.01 if (lvstckid==31 | lvstckid==32 | lvstckid==33 | lvstckid==34 | lvstckid==35 | lvstckid==36 | lvstckid==37 | lvstckid==38 | lvstckid==39 | lvstckid==40 |lvstckid==41) //rabbits, ducks, turkeys  *SW 7/30/21 I believe this is 0.01
//geese and other birds, backyard chicken, parent stock for broilers, parents stock for layers, layers, pullet chicks, growers, broilers; beehives not included

lab var tlu_coefficient "Tropical Livestock Unit coefficient"
*replace A6aq7=. if A6aq7>5000
*replace A6bq7=. if A6bq7>5000
*replace A6cq7=. if A6cq7>5000
*replace A6aq5=. if A6aq5>5000
*replace A6bq5=. if A6bq5>5000
*replace A6cq5=. if A6cq5>5000
*replace A6aq15=. if A6aq15>5000000
*replace A6bq15=. if A6bq15>800000
*replace A6cq15=. if A6cq15>900000
*replace A6aq14=. if A6aq14>1000
*replace A6bq14=. if A6bq14>1000
*replace A6cq14=. if A6cq14>1000
gen number_1yearago = A6aq7
replace number_1yearago = A6bq7 if number_1yearago==. & A6bq7!=. 
replace number_1yearago = A6cq7 if number_1yearago==. & A6cq7!=.

gen number_today= A6aq5
replace number_today = A6bq5 if number_today==. & A6bq5!=.
replace number_today = A6cq5 if number_today==. & A6cq5!=.

gen number_today_exotic = number_today if inlist(lvstckid,1,2,3,13,14,15,16)


gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
gen income_live_sales = A6aq15
replace income_live_sales = A6bq15*2 if income_live_sales==. & A6bq15!=. // multiply by 2 because question asks in last 6 months
replace income_live_sales = A6cq15*4 if income_live_sales==. & A6cq15!=. // multiplu by 4 because question asks in last 3 months
gen number_sold = A6aq14
replace number_sold = A6bq14*2 if number_sold==. & A6bq14!=. // multiply by 2 because question asks in last 6 months
replace number_sold = A6cq14*4 if number_sold==. & A6cq14!=. // multiplu by 4 because question asks in last 3 months

egen mean_12months = rowmean(number_1yearago number_today)

gen animals_lost12months = A6aq10 //includes animals died or lost
replace animals_lost12months = A6bq10*2 if animals_lost12months==. & A6bq10!=. // multiply by 2 because question asks in last 6 months
replace animals_lost12months = A6cq10*4 if animals_lost12months==. & A6cq10!=. // multiplu by 4 because question asks in last 3 months

gen herd_cows_indigenous = number_today if lvstckid==6
gen herd_cows_exotic = number_today if lvstckid==3
gen herd_cows_total = herd_cows_indigenous + herd_cows_exotic
egen herd_cows_tot = rowtotal(herd_cows_indigenous herd_cows_exotic)
gen share_imp_herd_cows = herd_cows_exotic / herd_cows_tot

rename lvstckid livestock_code

gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,13,14,15,16,17,18,19,20)) + 3*(livestock_code==21) + 4*(inlist(livestock_code,7,8)) + 5*(inlist(livestock_code,31,32,33,34,35,36,37,38,39,40,41))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(HHID species) // doesn't include lost to disease or injury disaggregated (just died/lost)
	egen mean_12months = rowmean(number_today number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
	
	foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding {
		gen `i'_lrum = `i' if species==1
		gen `i'_srum = `i' if species==2
		gen `i'_pigs = `i' if species==3
		gen `i'_equine = `i' if species==4
		gen `i'_poultry = `i' if species==5
	}
	*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
	collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(HHID)

	*Overall any improved herd
	gen any_imp_herd = number_today_exotic!=0 if number_today!=0
	drop number_today_exotic number_today
	
	foreach i in lvstck_holding animals_lost12months mean_12months {
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost to disease or injury"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
	la var any_imp_herd "At least one improved animal in herd - all animals" 
	*Now dropping these missing variables, which I only used to construct the labels above
	
	*Total livestock holding for large ruminants, small ruminants, and poultry
	gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
	la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
	
	*any improved large ruminants, small ruminants, or poultry
	gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
	replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
	lab var any_imp_herd_all "1=hh has any improved lrum, srum, or poultry"
	
	recode lvstck_holding* (.=0)
	drop lvstck_holding animals_lost12months mean_12months
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
merge m:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district county subcounty parish ea livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_ea.dta", nogen
merge m:1 region district county subcounty parish livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_parish.dta", nogen
merge m:1 region district county subcounty livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_subcounty.dta", nogen
merge m:1 region district county livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_county.dta", nogen
merge m:1 region district livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_prices_country.dta", nogen 
recode price_per_animal (0=.)
replace price_per_animal  = price_median_ea if price_per_animal==. & obs_ea >= 10 
replace price_per_animal  = price_median_parish if price_per_animal==. & obs_parish >= 10 
replace price_per_animal  = price_median_sub if price_per_animal==. & obs_sub >= 10 
replace price_per_animal  = price_median_county if price_per_animal==. & obs_county >= 10 
replace price_per_animal  = price_median_district if price_per_animal==. & obs_district >= 10 
replace price_per_animal  = price_median_region if price_per_animal==. & obs_region >= 10 
replace price_per_animal  = price_median_country if price_per_animal==. & obs_country >= 10 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (HHID)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if HHID==""
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_TLU.dta", replace


*Livestock income
use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_sales", clear
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_hh_livestock_products"
drop _merge
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_expenses"
drop _merge
merge 1:1 HHID using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_TLU.dta"
drop _merge

gen livestock_income = value_lvstck_sold + value_slaughtered - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)

lab var livestock_income "Net livestock income"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_livestock_income", replace

*************
*FISH INCOME*
*************
*Fishing expenses
use "${UGS_W1_raw_data}/2009_AGSEC9D.dta", clear
ren Hhid HHID
// all "fishing operation cost" included as one variable
rename A9q11b costs_fishing //includes labor on shore, labor in boat, fuel/oil, fish container, repair & maintenance, transportation of catch, rent of machinery, other
recode costs_fishing (.=0)
collapse(sum) costs_fishing, by(HHID)
la var costs_fishing "Costs for fishing expenses over the past year"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_fishing_expenses.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC9A.dta", clear
ren Hhid HHID
// should we restrict the file above to just fishing HHs since we do in this file??
drop if A9q1==2 | A9q1==. //answered "no" to "did anybody in the household practic fishing in the past 12 months" //EFW 6.11.19 used to mimic fish_code==. in TZ W4 code
ren A9q2 type_fishing
replace type_fishing="A" if type_fishing=="1"
replace type_fishing="B" if type_fishing=="2"
drop if type_fishing=="C" //artificial fish pond; 7 observations deleted
ren A9q8 quantity_sold //"How much, if any, of the daily catch did you sell, either as fresh fish or as smoked fish or dried fish?"
ren A9q9 value_sold //"How much did you and other members receive per day for the sale of fresh fish?"
ren A9q3 months_fished //"For how many months did you fish last year?"
ren A9q4 days_fished //"During those months how many days did your household fish on average?"
ren A9q5 fish_quantity_day //"what is your average quantity of daily catch during those months? (kg/day)"

gen price_per_unit = value_sold / quantity_sold

recode price_per_unit (0=.)
*impute prices to value fish not sold (by type of fishing) //EFW 6.11.19 added per Didier code
preserve
collapse (mean) price_per_unit, by(type_fishing)
tempfile price_type_fishing
ren price_per_unit price_per_unit_type
save `price_type_fishing'
restore
merge m:1 type_fishing using  `price_type_fishing', nogen

gen value_fish_harvest = fish_quantity_day * days_fished * months_fished * price_per_unit
replace value_fish_harvest = fish_quantity_day * days_fished * months_fished * price_per_unit_type if value_fish_harvest==.
gen income_fish_sales = value_sold * days_fished * months_fished

recode value_fish_harvest income_fish_sales (.=0)
collapse(sum) value_fish_harvest income_fish_sales, by(HHID)

lab var value_fish_harvest "Value of fish harvest (including what is sold)"
lab var income_fish_sales "Value of fish sales"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_fish_income.dta", replace // why are we calling this fish income?? It doesn't yet incorporate expenses (saved above)


************************
*SELF-EMPLOYMENT INCOME*
************************
use "${UGS_W1_raw_data}/2009_GSEC12.dta", clear
ren h12q12 months_activ
replace months_activ = 12 if months_activ > 12 & months_activ!=. //1 change made
ren h12q13 monthly_revenue
ren h12q15 wage_expense
ren h12q16 materials_expense
ren h12q17 operating_expense
recode monthly_revenue wage_expense materials_expense operating_expense (.=0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit <0 & monthly_profit!=. //156  What do we do with negatives profit, recode to zero?? check other code
gen annual_selfemp_profit = monthly_profit * months_activ
count if annual_selfemp_profit<0 & annual_selfemp_profit!=. //152
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by(HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_self_employment_income.dta", replace

*Processed crops
// Can't construct in this instrument; only includes question "how much of the [crop] harvested was used to produce processed food products for sale and for animal feed?"

*Fish trading
//EFW 7.10.19 not captured in this instrument


*************
*WAGE INCOME*
*************
/*
UGS Wave 1 did not capture number of weeks per month individual worked. 
We impute these using median values by industry and type of residence using UGS W2
see imputation below. This follows RIGA methods.
*/

global UGS_W2_raw_data 	"//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/raw_data"
global UGS_W2_created_data "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/temp"
global UGS_W2_final_data  "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11/outputs"

use "${UGS_W2_raw_data}/GSEC8.dta", clear
merge m:1 HHID using "${UGS_W2_raw_data}/GSEC1.dta"

g industry=1 if h8q20b<=2 //"agriculture, hunting and forestry" and "fishing"
replace industry=2 if h8q20b==3 //"mining and quarrying"
replace industry=3 if h8q20b==4 //"manufacturing"
replace industry=4 if h8q20b==5 //"electricity, gas, and water supply
replace industry=5 if h8q20b==6 //"construction"
replace industry=6 if h8q20b==7 //"sale, maintenance, and repair of motor vehicles, motorcycles and personal household goods"
replace industry=7 if h8q20b>=8 & h8q20b<=9 //"hotels and restaurants", "transport, storage and communications"
replace industry=8 if h8q20b>=10 & h8q20b<=11 //"financial intermediation", "real estate, renting and business activities"
replace industry=9 if h8q20b>=12 & h8q20b<=15 //"public administration and defence; compulsory social security", "education", "health and social work", "other community, social and personal service activities"
replace industry=10 if h8q20b>=16 & h8q20b<=17 //"private households with employed persons", "extra-territorial organizations and bodies"

label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry

// double check RIGA methodology to make sure industry codes are the same

//get median annual weeks worked for each industry
recode h8q30 h8q30b (.=0)
gen weeks = h8q30*h8q30b
replace weeks = h8q30 if h8q30b==0
replace weeks = 52 if weeks>=52 //2 obs where weeks==60
ren wgt10 weight

preserve
sort urban industry
collapse (median) weeks, by(urban industry)
sort urban industry 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_hours_imputation_urban.dta", replace
restore
sort industry
collapse(median) weeks, by(industry)
sort industry
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_hours_imputation.dta", replace

//use wave 1 income
use "${UGS_W1_raw_data}/2009_GSEC8.dta", clear
ren Hhid HHID
merge m:1 HHID using "${UGS_W1_raw_data}/2009_GSEC1.dta"
drop _merge
//Classification of Industry to get median wage for imputation, taken from r coding
gen industry=1 if H8q20b<=2
replace industry=2 if H8q20b>=131 & H8q20b<=142
replace industry=3 if H8q20b>=151 & H8q20b<=372
replace industry=4 if H8q20b>=401 & H8q20b<=410
replace industry=5 if H8q20b>=451 & H8q20b<=455
replace industry=6 if H8q20b>=501 & H8q20b<=526
replace industry=7 if H8q20b>=551 & H8q20b<=642
replace industry=8 if H8q20b>=651 & H8q20b<=749
replace industry=9 if H8q20b>=751 & H8q20b<=930
replace industry=10 if H8q20b>=950 & H8q20b<=990

label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry

*merge in median weeks worked
sort urban industry
merge m:1 urban industry using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_hours_imputation_urban.dta", nogen keep(1 3)
ren weeks weeks_urban

sort industry
merge m:1 industry using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_hours_imputation.dta", nogen keep (1 3)
ren weeks weeks_industry
gen weeks = weeks_urban
replace weeks = weeks_industry if weeks == .

//Wage Income
rename H8q30 number_months
egen number_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) //EFW 7.10.19 
rename H8q31a most_recent_payment
replace most_recent_payment = . if (H8q19b > 611 & H8q19b < 623) | H8q19b != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct?
rename H8q31c payment_period
rename H8q31b most_recent_payment_other
rename H8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if (H8q19b > 611 & H8q19b < 623) | H8q19b != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct?
rename H8q45c secwage_payment_period
rename H8q45b secwage_recent_payment_other
gen secwage_hours_pastweek = H8q43 

gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse(sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_income.dta", replace

//Ag Wage Income
use "${UGS_W1_raw_data}/2009_GSEC8.dta", clear
ren Hhid HHID
merge m:1 HHID using "${UGS_W1_raw_data}/2009_GSEC1.dta"
drop _merge
//Classification of Industry to get median wage for imputation, taken from r coding
gen industry=1 if H8q20b<=2
replace industry=2 if H8q20b>=131 & H8q20b<=142
replace industry=3 if H8q20b>=151 & H8q20b<=372
replace industry=4 if H8q20b>=401 & H8q20b<=410
replace industry=5 if H8q20b>=451 & H8q20b<=455
replace industry=6 if H8q20b>=501 & H8q20b<=526
replace industry=7 if H8q20b>=551 & H8q20b<=642
replace industry=8 if H8q20b>=651 & H8q20b<=749
replace industry=9 if H8q20b>=751 & H8q20b<=930
replace industry=10 if H8q20b>=950 & H8q20b<=990

label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry

*merge in median weeks worked
sort urban industry
merge m:1 urban industry using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_hours_imputation_urban.dta", nogen keep(1 3)
ren weeks weeks_urban

sort industry
merge m:1 industry using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_wage_hours_imputation.dta", nogen keep (1 3)
ren weeks weeks_industry
gen weeks = weeks_urban
replace weeks = weeks_industry if weeks == .

rename H8q30 number_months
egen number_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) //EFW 7.10.19 
rename H8q31a most_recent_payment
replace most_recent_payment = . if industry!=1
rename H8q31c payment_period
rename H8q31b most_recent_payment_other
rename H8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if industry!=1
rename H8q45c secwage_payment_period
rename H8q45b secwage_recent_payment_other
gen secwage_hours_pastweek = H8q43 

gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse(sum) annual_salary, by (HHID)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_agwage_income.dta", replace


**************
*OTHER INCOME*
**************
use "${UGS_W1_raw_data}/2009_GSEC11.dta", clear
gen rental_income_cash = h11aq05 if (h11aq03==21 | h11aq03==22 | h11aq03==23) //EFW 7.17.19 doesn't explicitly exclude agricultural land (as TZA W4 does)
gen rental_income_inkind = h11aq06 if (h11aq03==21 | h11aq03==22 | h11aq03==23)
gen pension_income_cash = h11aq05 if h11aq03==41
gen pension_income_inkind = h11aq06 if h11aq03==41
gen assistance_cash = h11aq05 if (h11aq03==42 | h11aq03==43)
gen assistance_inkind = h11aq06 if (h11aq03==42 | h11aq03==43)
gen other_income_cash = h11aq05 if (h11aq03==23 | h11aq03==32 | h11aq03==33 | h11aq03==34 | h11aq03==35 | h11aq03==36 | h11aq03==44 | h11aq03==45)
gen other_income_inkind = h11aq06 if (h11aq03==23 | h11aq03==32 | h11aq03==33 | h11aq03==34 | h11aq03==35 | h11aq03==36 | h11aq03==44 | h11aq03==45)
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
*lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months" // don't have this in this instrument

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_other_income.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear
ren Hhid HHID
rename A2aq16 land_rental_income
recode land_rental_income (.=0)
collapse(sum) land_rental_income, by(HHID)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_rental_income.dta", replace


***********************
*FARM SIZE / LAND SIZE*
***********************
use "${UGS_W1_raw_data}/2009_AGSEC4A.dta", clear
append using "${UGS_W1_raw_data}/2009_AGSEC4B.dta"
ren Hhid HHID
ren A4aq2 parcel_id
replace parcel_id = A4bq2 if parcel_id == .
ren A4aq4 plot_id
replace plot_id = A4bq4 if plot_id == .
ren A4aq6 crop_code
replace crop_code = A4bq6 if crop_code == .
drop if plot_id==.
drop if parcel_id==.
drop if crop_code == .
gen crop_grown = 1
collapse (max) crop_grown, by (HHID parcel_id) 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crops_grown.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC4A.dta", clear
append using "${UGS_W1_raw_data}/2009_AGSEC4B.dta"
ren Hhid HHID
ren A4aq2 parcel_id
replace parcel_id = A4bq2 if parcel_id == .
ren A4aq4 plot_id
replace plot_id = A4bq4 if plot_id == .
ren A4aq1 cultivated
replace cultivated = A4bq1 if cultivated == .
collapse (max) cultivated, by (HHID parcel_id) 
lab var cultivated "1= Parcel was cultivated in this data set"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_parcels_cultivated.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_parcels_cultivated.dta", clear
merge 1:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_size.dta", replace 

*All agricultural land
use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id == .
drop if parcel_id==.
merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_crops_grown.dta", nogen 
*5,202 matched
*623 not matched (from master)
gen rented_out = (A2aq13a==3 | A2aq13a==4 | A2aq13b==3 | A2aq13b==4) //rented out & cultivated by mailo tenant
//EFW 7.19.19 2nd cropping season is "short"
gen cultivated_short = (A2aq13b==1 | A2aq13b==2) //own cultivated annual and perennial crops
bys HHID parcel_id: egen plot_cult_short=max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
*8 changes made
drop if rented_out==1 & crop_grown!=1
*73 obs dropped
gen agland = (A2aq13a==1 | A2aq13a==2 | A2aq13a==5 | A2aq13a==6 | A2aq13b==1 | A2aq13b==2 | A2aq13b==5 | A2aq13b==6) //cultivated, fallow & pasture
drop if agland!=1 & crop_grown==.
*228 obs deleted
collapse (max) agland, by (HHID parcel_id) 
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_parcels_agland.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_parcels_agland.dta", clear
merge 1:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (sum) area_acres_meas, by (HHID)
rename area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmsize_all_agland.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id == .
drop if parcel_id==.
gen rented_out = (A2aq13a==3 | A2aq13a==4 | A2aq13b==3 | A2aq13b==4) //rented out & cultivated by mailo tenant
gen cultivated_short = (A2aq13b==1 | A2aq13b==2) //own cultivated annual and perennial crops
bys HHID parcel_id: egen plot_cult_short=max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (HHID parcel_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_parcels_held.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_parcels_held.dta", clear
merge 1:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
rename area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id == .
merge m:1 HHID parcel_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_areas.dta"
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (max) area_acres_meas, by(HHID parcel_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by (HHID)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_land_size_total.dta", replace

****************
*OFF-FARM HOURS*
****************
use "${UGS_W1_raw_data}/2009_GSEC8.dta", clear
ren Hhid HHID
//codes are not labeled so use (and assume) so use iternational standard classification of occupations (ISCO)
egen primary_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) if (H8q19b < 611 | H8q19b > 623) & H8q19b != 921
//92=agricultural, fishery and related laborers; section 6 = agricultural and fishery related workers
gen secondary_hours = H8q43 if (H8q38b < 611 | H8q38b > 623) & H8q38b != 921
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_off_farm_hours.dta", replace

************
*FARM LABOR*
************
use "${UGS_W1_raw_data}/2009_AGSEC3A.dta", clear
ren Hhid HHID
ren A3aq1 parcel_id 
ren A3aq3 plot_id
ren A3aq39 days_famlabor_mainseason //person days: reflects both size of team & number of days spent
ren A3aq42a days_hired_men
ren A3aq42b days_hired_women
ren A3aq42c days_hired_child
egen days_hired_mainseason = rowtotal(days_hired_men days_hired_women days_hired_child)
recode days_famlabor_mainseason days_hired_mainseason (.=0)
collapse (sum) days_famlabor_mainseason days_hired_mainseason, by (HHID parcel_id plot_id)  
// Since we do everything at the parcel level as that is the only
// feasible level for many of our key indicators I would say we should do 
// things at the parcel level 
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmlabor_mainseason.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC3B.dta", clear
ren a3bq1 parcel_id 
ren a3bq3 plot_id
ren a3bq39 days_famlabor_shortseason
ren a3bq42a days_hired_men
ren a3bq42b days_hired_women
ren a3bq42c days_hired_child
egen days_hired_shortseason = rowtotal(days_hired_men days_hired_women days_hired_child)
recode days_famlabor_shortseason days_hired_shortseason (.=0)
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (HHID parcel_id plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmlabor_shortseason.dta", replace

use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmlabor_mainseason.dta", clear
merge 1:1 HHID parcel_id plot_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmlabor_shortseason.dta"
drop _merge
recode days* (.=0)
collapse (sum) days*, by (HHID parcel_id plot_id)
egen labor_hired = rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family = rowtotal(days_famlabor_mainseason days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_hired_shortseason days_famlabor_mainseason days_famlabor_shortseason) 
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by (HHID)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_family_hired_labor.dta", replace


***************
*VACCINE USAGE*
***************

**************************
*ANIMAL HEALTH - DISEASES*
**************************
*can't construct in this instrument. doesn't include question on what diseases animals suffer


***************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING*
***************************************
*can't construct in this instrument. doesn't include question on feeding and watering practices


*****************************
*USE OF INORGANIC FERTILIZER*
*****************************
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear
ren Hhid HHID
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
gen use_inorg_fert=.
replace use_inorg_fert=0 if A3aq14==2 | a3bq14==2
replace use_inorg_fert=1 if A3aq14==1 | a3bq14==1
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (HHID)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_fert_use.dta", replace

*Fertilizer use by farmers ( a farmer is an individual listed as plot manager)
use "${UGS_W1_raw_data}/2009_AGSEC3A", clear
ren Hhid HHID
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
gen parcel_id = A3aq1
replace parcel_id = a3bq1 if parcel_id == .
gen plot_id = A3aq3
replace plot_id = a3bq3 if plot_id == .
gen all_use_inorg_fert=(A3aq14==1 | a3bq14==1)
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_fert_use_temp.dta", replace 

use "${UGS_W1_raw_data}/2009_AGSEC2A.dta", clear //land household owns
ren Hhid HHID
gen parcel_id = A2aq2
drop if parcel_id == .
gen plot_id = A2aq2
drop if plot_id == .
append using "${UGS_W1_raw_data}/2009_AGSEC2B.dta" //land household has user rights to
replace HHID=Hhid if HHID==""
replace parcel_id = A2bq2 if parcel_id == .
drop if parcel_id == .
replace plot_id = A2bq2 if plot_id == .
drop if plot_id == .

merge 1:m HHID parcel_id plot_id using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_fert_use_temp.dta" 

preserve
keep HHID all_use_inorg_fert A2aq27a A2bq25a //"Who usually (mainly) works on this parcel?" 
ren A2aq27a farmerid //"Who usually (mainly) works on this parcel?" 
replace farmerid = A2bq25a if farmerid == . & A2bq25a!=.
tempfile farmer1
save `farmer1'
restore
preserve
keep HHID all_use_inorg_fert A2aq27b A2bq25b
ren A2aq27b farmerid
replace farmerid = A2bq25b if farmerid == . & A2bq25b!=.
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'
collapse (max) all_use_inorg_fert, by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_fert_use.dta", replace


**********************
*USE OF IMPROVED SEED*
**********************
use "${UGS_W1_raw_data}/2009_AGSEC4A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC4B"
ren Hhid HHID
gen crop_code = A4aq6
replace crop_code = A4bq6 if crop_code==.

gen imprv_seed_use=.
replace imprv_seed_use=1 if (A4aq13==2 | A4bq13==2)
replace imprv_seed_use=0 if (A4aq13==1 | A4bq13==1)
recode imprv_seed_use (.=0)

*Use of seed by crop
forvalues k=1(1)$len {
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
gen hybrid_seed_`cn'=. //EFW 8.5.19 no question about hybrid seed in this instrument
}

collapse (max) imprv_seed_* hybrid_seed_*, by(HHID)
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_improvedseed_use.dta", replace

*Seed adoption by farmers (a farmer is an individual listed as plot manager)
// we use IDs from sections 2A and 2B for questions related to who manages the plot
//Section 5 includes "who controls the output from this crop?" which is at the crop level. Use here instead. Is this OK? This is a different definition of "plot manager"
//Should we revist earlier in the code and change that plot manager variable as well??
use "${UGS_W1_raw_data}/2009_AGSEC4A", clear
ren Hhid HHID
ren A4aq2 parcel_id
ren A4aq4 plot_id
ren A4aq6 crop_code

preserve
use "${UGS_W1_raw_data}/2009_AGSEC5A", clear
ren Hhid HHID
ren A5aq1 parcel_id 
ren A5aq3 plot_id
ren A5aq5 crop_code
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_improvedseed_use_temp1.dta", replace
restore

merge 1:m HHID parcel_id plot_id crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_improvedseed_use_temp1.dta"

preserve 
use "${UGS_W1_raw_data}/2009_AGSEC5B", clear
ren Hhid HHID
ren A5bq1 parcel_id 
ren A5bq3 plot_id 
ren A5bq5 crop_code
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_improvedseed_use_temp2.dta", replace

use "${UGS_W1_raw_data}/2009_AGSEC4B", clear
ren Hhid HHID
ren A4bq2 parcel_id 
ren A4bq4 plot_id 
ren A4bq6 crop_code
merge 1:m HHID parcel_id plot_id crop_code using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_improvedseed_use_temp2.dta"
tempfile seedb
save `seedb'
restore

append using `seedb'

gen imprv_seed_use=.
replace imprv_seed_use=1 if (A4aq13==2 | A4bq13==2)
replace imprv_seed_use=0 if (A4aq13==1 | A4bq13==1)
recode imprv_seed_use (.=0)

ren imprv_seed_use all_imprv_seed_use

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp.dta", replace

*Use of seed by crop
forvalues k=1(1)$len {
	use "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved seed
	gen all_imprv_seed_`cn'=all_imprv_seed_use if crop_code==`c'
	gen all_hybrid_seed_`cn'=. //EFW 8.5.19 no question about hybrid seed in this instrument
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= crop_code==`c'
	ren A5aq11 farmerid
	replace farmerid=A5bq11 if farmerid==.

	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (HHID farmerid)
	save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp_`cn'.dta", replace
}	

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 HHID farmerid all_imprv_seed_use using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_farmer_improvedseed_use_temp_`v'.dta", nogen
}

gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_gender_merge.dta", nogen //3,160 matched
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_improvedseed_use.dta", replace


*************************
*REACHED BY AG EXTENSION*
*************************
use "${UGS_W1_raw_data}/2009_AGSEC10", clear
ren Hhid HHID
// A10q3 (and A10q2) seems to be labeled incorrectly in the dta file. Responses are consisten with survey question.
gen receive_advice=.
replace receive_advice=1 if A10q3==1
replace receive_advice=0 if A10q3==2

*Government Extension
gen advice_gov = (A10q2=="NAADS" & receive_advice==1)
*NGO
gen advice_ngo = (A10q2=="NGO" & receive_advice==1)
**Cooperative/Farmer Association
gen advice_coop = (A10q2=="COOPERATIVE" & receive_advice==1)
*Large Scale Farmer
gen advice_farmer = (A10q2=="LARGE SCALE FARMER" & receive_advice==1)
*Input Supplier
gen advice_input = (A10q2=="INPUT SUPPLIER" & receive_advice==1)
*Other
gen advice_other = (A10q2=="OTHERS" & receive_advice==1)

gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_input==1)
gen ext_reach_unspecified=(advice_other==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
*can't construct ext_reach_ict
gen ext_reach_ict=.

collapse (max) ext_reach_*, by (HHID)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"

save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_any_ext.dta", replace


******************************************************************************************************
*USE OF FORMAL FINANCIAL SERVICES*
******************************************************************************************************
use "${UGS_W1_raw_data}/2009_GSEC13", clear
gen borrow_bank = h13q05 == 1 | h13q07 == 1
gen borrow_government = h13q06 == 1 // this variable added for Uganda, government is a formal financial service asked about in the Uganda survey
gen borrow_employer = h13q09 == 1
gen borrow_micro = h13q08 == 1
gen borrow_neigh =  h13q11 == 1 //using "borrowed money from a family member or friend"
gen borrow_other = h13q10 == 1 | h13q13 == 1 //using "borrowed money from a SACCOS or other informal savings club" and "borrowed money from a money lender"


//gen use_MM = 
gen use_bank_account = h13q01 == 1 | h13q19 == 1
gen use_fin_serv_bank = h13q20 == 1 | h13q01 == 1 
gen use_fin_serv_credit = borrow_bank == 1 | borrow_other == 1 |h13q18 == 1
gen use_fin_serv_insur = h13q21 == 1 | h13q22 == 1 | h13q23 == 1 | h13q24 == 1 | h13q25 == 1
//gen use_fin_serv_digital =

gen use_fin_serv_others = h13q02 == 1 | h13q03 == 1 //includes SACCOS or "other informal savings clubs"

gen use_fin_serv_all = use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_others==1 // | use_fin_serv_digital==1
recode use_fin_serv* (.=0)

lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
//lab var use_fin_serv_digital "1= Household uses formal financial services - digital" 
lab var use_fin_serv_others "1= Household uses financial services - others" //is this meant to be other formal?

collapse (max)use_fin_serv*, by (HHID)

save "${UGS_W1_created_data}/UGS_W1_fin_serv.dta", replace 


******************************************************************************************************
*MILK PRODUCTIVITY*
******************************************************************************************************
use "${UGS_W1_raw_data}/2009_AGSEC6A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC8"
ren Hhid HHID
gen ruminants_large =  A6aq3 == 1 | 2 | 3 | 4 | 5 | 6 
gen milk_animals = A6aq3 == 3 | 6 
gen is_cow_milk = A8q2 == 1 //only considering cow milk, not goat milk, sour milk, or ghee
gen months_milked = A8q3 * is_cow_milk
//gen kg_to_liters_conversion = (A8q5 == 1) * (1/1.03) is this line necessary, or do you assume liter == kg
gen liters_day = A8q4 * is_cow_milk * (1/30.5)
gen liters_per_largeruminant = (liters_day*365*(months_milked/12))
//keep if milk_animals!=0 & milk_animals!=.
//drop if liters_per_largeruminant==.
keep HHID milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${UGS_W1_created_data}/UGS_W1_milk_animals.dta", replace

* I will do milk productivity again since this one doesn't seem to work
* Milk Productivity (All types of milk)
use "${UGS_W1_raw_data}/2009_AGSEC8", clear
ren Hhid HHID
gen milk_animals = 1 if A8q2<=3
keep if milk_animals==1
gen months_milked = A8q3
keep if months_milked>=1
replace months_milked=. if months_milked>12
gen liters_day = A8q4/30.5
gen liters_per_largeruminant = liters_day*365*months_milked/12
keep HHID milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${UGS_W1_created_data}/UGS_W1_milk_animals.dta", replace
*  Milk productivity only cows
use "${UGS_W1_raw_data}/2009_AGSEC8", clear
ren Hhid HHID
gen milk_animals = 1 if A8q2==1
keep if milk_animals==1
gen months_milked = A8q3
keep if months_milked>=1
replace months_milked=. if months_milked>12
gen liters_day = A8q4/30.5
gen liters_per_largeruminant = liters_day*365*months_milked/12
keep HHID milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${UGS_W1_created_data}/UGS_W1_milk_animals.dta", replace
*Notes: There is no information about how many large ruminants were milked in each HH.(We can not construct milked_animals). Not sure if we need information for each type of ruminant(only cows or consider other types of milk)


******************************************************************************************************
*EGG PRODUCTIVITY*
******************************************************************************************************
use "${UGS_W1_raw_data}/2009_AGSEC6C", clear
append using "${UGS_W1_raw_data}/2009_AGSEC8"
gen has_backyard_chickens = A6cq3 == "32"
gen has_parent_stock_for_broilers = A6cq3 == "33"
gen has_parent_stock_for_layers = A6cq3 == "34"
gen has_layers = A6cq3 == "35"
gen has_pullet_chicks = A6cq3 == "36"
gen has_growers = A6cq3 == "37"
gen has_broilers = A6cq3 == "38"
gen has_turkeys = A6cq3 == "39"
gen has_ducks = A6cq3 == "40"
gen has_other_poultry = A6cq3 == "41"
gen has_any_poultry = has_backyard_chickens | has_parent_stock_for_broilers | has_parent_stock_for_layers | has_layers | has_pullet_chicks | has_growers | has_broilers | has_turkeys | has_ducks | has_other_poultry
gen poultry_owned = has_any_poultry * A6cq5
*gen eggs_months = (A8q2 == 5) * A8q3 It seems like eggs_months is conditional on having at least 1 month of production.
*gen eggs_months = (A8q2 == 5) * A8q3 if A8q3<=12 & A8q3>0
gen eggs_months = A8q3 if A8q3<=12 & A8q3>0 & A8q2==5
*gen eggs_per_month = (A8q2 == 5) * A8q4 //SW same for eggs_per_month. It should be only considering HH that produced eggs.
gen eggs_per_month = A8q4 if A8q2==5 & A8q4>0
gen eggs_total_year = eggs_months * eggs_per_month
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
*keep y4_hhid eggs_months eggs_per_month eggs_total_year poultry_owned 
keep Hhid eggs_months eggs_per_month eggs_total_year poultry_owned
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_eggs_animals.dta", replace

* Variable poultry_owned has some big outliers[A6cq5]. Variable A8q3 has outliers too should be ranged [0,12]
* variable eggs_months is incorrect too is considering 0 months for other products not related to eggs goes from [0,12] vs TZN W4 [1,12]




********Agricultural Wages***************

use "${UGS_W1_raw_data}/2009_AGSEC3A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC3B"
recode A3aq42* a3bq42* (0=.)
rename A3aq42a hired_male_lanprep
replace hired_male_lanprep = a3bq42a if hired_male_lanprep==.
rename A3aq42b hired_female_lanprep
replace hired_female_lanprep =  a3bq42b if hired_female_lanprep==.
rename A3aq43 hlabor_paid_lanprep
replace hlabor_paid_lanprep = a3bq43 if hlabor_paid_lanprep==.
recode hired* hlabor* (.=0)
collapse (sum) hired* hlabor*, by(HHID)
gen hirelabor_lanprep=(hired_male_lanprep+hired_female_lanprep)
gen wage_lanprep=hlabor_paid_lanprep/hirelabor_lanprep
recode  wage_lanprep hirelabor_lanprep (.=0)
keep HHID wage_lanprep
rename wage_lanprep wage_paid_aglabor
label var wage_paid_aglabor "Daily wage in agriculture"
save"${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_ag_wage.dta", replace

*******Rate of Fertilizer Application********


* We need Crop Production cost per hectare firstnm

************Women's Diet Quality*******************
* Need to find a good example on how to construct this variable. Not available in TZN W4

*****Household Diet Diversity Score****************

use "${UGS_W1_raw_data}/2009_GSEC15B", clear
recode h15bq2 	(110/116  				=1	"CEREALS" )  //// 
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
*Notes There are some food itmcd that dont fit into any DIET_ID category, those food itmc are droped from the analysis (The excluded items that dont fit are Infant formula food 126, Cigarretes 155, Other Tobacco 156, Expenditure in restaurants on Food, Soda, Beer 157-159 Other fooods 161. In white roots.. category we include 4 types of matooke items. In legumes.. we include sim sim item. Other juice 160 is included in beverages category
gen adiet_yes=1 if !missing(h15bq3b)
ta Diet_ID
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(HHID   Diet_ID) 
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
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_household_diet.dta", replace

*******Women;s ownership of assets******************
*It's already done in UG W3
******Women's Agricultural decision making*********

*********Women's control over income****************


use "${UGS_W1_raw_data}/2009_AGSEC2A", clear
append using "${UGS_W1_raw_data}/2009_AGSEC2B"
append using "${UGS_W1_raw_data}/2009_AGSEC5A"
append using "${UGS_W1_raw_data}/2009_AGSEC5B"
append using "${UGS_W1_raw_data}/2009_AGSEC8"
append using "${UGS_W1_raw_data}/2009_GSEC12"
*First there is a problem with Hhid in Agriculture Questionnaire vs HHID HH Questionnaire
replace Hhid= HHID if missing(Hhid)
gen type_decision="" 
gen double controller_income1=.
gen double controller_income2=.
*Control of harvest from annual crops 
replace type_decision="control_annualharvest" if !missing(A5aq11)
replace controller_income1=A5aq11
replace type_decision="control_annualharvest" if !missing(A5bq11)
replace controller_income1=A5bq11 if controller_income1==.
*Note: No information about control over annual crop earnings
*Control over livestock sales  A8q9a A8q9b
replace type_decision="control_livestocksales" if (!missing(A8q9a) | !missing(A8q9b)) &  (A8q2==7 |  A8q2==8 | A8q2==9)
replace controller_income1=A8q9a if controller_income1==.
replace controller_income2=A8q9b if controller_income2==.
preserve
*Control over milk sales
replace type_decision="control_milksales" if (!missing(A8q9a) | !missing(A8q9b)) & (A8q2==1 | A8q2==2 | A8q2==3)
replace controller_income1=A8q9a if controller_income1==.
replace controller_income2=A8q9b if controller_income2==.
keep if (!missing(controller_income1) | !missing(controller_income2)) & type_decision=="control_milksales"
keep Hhid type_decision controller_income1 controller_income2
tempfile control_milksales
save `control_milksales'
restore 
append using `control_milksales'
preserve
*Control over other incomes (eggs,honey, ghee)
replace type_decision="control_otherlivestock_sales" if (!missing(A8q9a) | !missing(A8q9b)) & (A8q2==4 | A8q2==5 | A8q2==6)
replace controller_income1=A8q9a if controller_income1==.
replace controller_income2=A8q9b if controller_income2==.
keep if (!missing(controller_income1) | !missing(controller_income2)) & type_decision=="control_otherlivestock_sales"
keep Hhid type_decision controller_income1 controller_income2
tempfile control_otherlivestock
save `control_otherlivestock'
restore 
append using `control_otherlivestock'
*Control over business income*
replace type_decision="control_businessincome" if !missing(h12q05a) | !missing(h12q05b)
replace controller_income1=h12q05a if controller_income1==.
replace controller_income2=h12q05b if controller_income2==.
keep Hhid type_decision controller_income1 controller_income2
preserve
keep Hhid type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep Hhid type_decision controller_income1
drop if controller_income1==.
ren controller_income1 controller_income
append using `controller_income2'
* create group
gen control_cropincome=1 if  type_decision=="control_annualharvest" ///
							*| type_decision=="control_permharvest" ///
							* | type_decision=="control_annualsales" ///
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
collapse (max) control_* , by(Hhid controller_income)  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)
ren controller_income individ
*	Now merge with member characteristics
*tostring Hhid, format(%18.0f) replace
*tostring individ, format(%18.0f) replace
rename Hhid HHID
merge 1:1 HHID individ  using  "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${UGS_W1_created_data}/Uganda_NPS_LSMS_ISA_W1_control_income.dta", replace



********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************
* This section and final summary statistics datasets are currently being coded. Please continue checking our EPAR Github for future updates.





