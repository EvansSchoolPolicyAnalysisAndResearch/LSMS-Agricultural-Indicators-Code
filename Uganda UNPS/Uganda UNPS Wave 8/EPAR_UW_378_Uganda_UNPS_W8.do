
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 8 (2019-20).
*Author(s)		: Didier Alia, Peter Agamile, Andrew Tomes, & C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of Pierre Biscaye, David Coomes, Rebecca Hsu, Jack Knauer, Lucero Marquez, Josh Merfeld, Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, Travis Reynolds members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This  Version - 01 February 2023 // update
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source // update
*-----------
*The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period February 2019 - February 2020.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*https://microdata.worldbank.org/index.php/catalog/3902

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda NPS data set.
*Using data files from within the "Raw DTA files" folder within the "Uganda NPS Wave 8" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "\Uganda NPS - LSMS-ISA - Wave 8 (2019-20)\Uganda_NPS_w8_created_data" within the "Final DTA files" folder. // update
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Uganda NPS - LSMS-ISA - Wave 8 (2019-20)" within the "Final DTA files" folder. // update

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager or farm size.
*The results are outputted in the excel file "Uganda_NPS_w8_summary_stats.xlsx" in the "Uganda NPS - LSMS-ISA - Wave 8 (2019-20)" within the "Final DTA files" folder. // update
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.
					 					
 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W8_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W8_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W8_hhsize.dta
*PLOT AREAS							Uganda_NPS_W8_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W8_plot_decision_makers.dta

*MONOCROPPED PLOTS					Uganda_NPS_w8_[CROP]_monocrop_hh_area.dta
									
*TLU (Tropical Livestock Units)		Uganda_NPS_w8_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_w8_tempcrop_harvest.dta
									Uganda_NPS_w8_tempcrop_sales.dta
									Uganda_NPS_w8_permcrop_harvest.dta
									Uganda_NPS_w8_permcrop_sales.dta
									Uganda_NPS_w8_hh_crop_production.dta
									Uganda_NPS_w8_plot_cropvalue.dta
									Uganda_NPS_w8_crop_residues.dta
									Uganda_NPS_w8_hh_crop_prices.dta
									Uganda_NPS_w8_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_w8_wages_mainseason.dta
									Uganda_NPS_w8_wages_shortseason.dta
									Uganda_NPS_w8_fertilizer_costs.dta
									Uganda_NPS_w8_seed_costs.dta
									Uganda_NPS_w8_land_rental_costs.dta
									Uganda_NPS_w8_asset_rental_costs.dta
									Uganda_NPS_w8_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_w8_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_w8_livestock_expenses.dta
									Uganda_NPS_w8_hh_livestock_products.dta
									Uganda_NPS_w8_dung.dta
									Uganda_NPS_w8_livestock_sales.dta
									Uganda_NPS_w8_TLU.dta
									Uganda_NPS_w8_livestock_income.dta

*FISH INCOME						Uganda_NPS_w8_fishing_expenses_1.dta
									Uganda_NPS_w8_fishing_expenses_2.dta
									Uganda_NPS_w8_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_w8_self_employment_income.dta
									Uganda_NPS_w8_agproducts_profits.dta
									Uganda_NPS_w8_fish_trading_revenue.dta
									Uganda_NPS_w8_fish_trading_other_costs.dta
									Uganda_NPS_w8_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_w8_wage_income.dta
									Uganda_NPS_w8_agwage_income.dta

*OTHER INCOME						Uganda_NPS_w8_other_income.dta
									Uganda_NPS_w8_land_rental_income.dta
									
*FARM SIZE / LAND SIZE				Uganda_NPS_w8_land_size.dta
									Uganda_NPS_w8_farmsize_all_agland.dta
									Uganda_NPS_w8_land_size_all.dta
									Uganda_NPS_w8_land_size_total.dta

*OFF-FARM HOURS						Uganda_NPS_w8_off_farm_hours.dta

*FARM LABOR							Uganda_NPS_w8_farmlabor_mainseason.dta
									Uganda_NPS_w8_farmlabor_shortseason.dta
									Uganda_NPS_w8_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_w8_vaccine.dta
									Uganda_NPS_w8_farmer_vaccine.dta
									
*ANIMAL HEALTH						Uganda_NPS_w8_livestock_diseases.dta
									Uganda_NPS_w8_livestock_feed_water_house.dta

*USE OF INORGANIC FERTILIZER		Uganda_NPS_w8_fert_use.dta
									Uganda_NPS_w8_farmer_fert_use.dta

*USE OF IMPROVED SEED				Uganda_NPS_w8_improvedseed_use.dta
									Uganda_NPS_w8_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_w8_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_w8_fin_serv.dta
*MILK PRODUCTIVITY					Uganda_NPS_w8_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_w8_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_w8_hh_rental_rate.dta
									Uganda_NPS_w8_hh_cost_land.dta
									Uganda_NPS_w8_hh_cost_inputs_lrs.dta
									Uganda_NPS_w8_hh_cost_inputs_srs.dta
									Uganda_NPS_w8_hh_cost_seed_lrs.dta
									Uganda_NPS_w8_hh_cost_seed_srs.dta
									Uganda_NPS_w8_asset_rental_costs.dta
									Uganda_NPS_w8_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Uganda_NPS_w8_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_w8_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_w8_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_w8_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_w8_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_w8_ownasset.dta

*CROP YIELDS						Uganda_NPS_w8_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_w8_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_w8_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_w8_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_w8_hh_assets.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_w8_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_w8_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_w8_field_plot_variables.dta
*SUMMARY STATISTICS					Uganda_NPS_w8_summary_stats.xlsx
*/

 
clear	
set more off
clear matrix	
clear mata	
set maxvar 8000	
ssc install findname  // need this user-written ado file for some commands to work

// set directories
* These paths correspond to the folders where the raw data files are located 
* and where the created data and final data will be stored.
global directory "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave8-2019-20"
//set directories: These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Uganda_NPS_w8_raw_data 			"$directory\raw_data\UGA_2019_UNPS_v01_M_STATA14"
global Uganda_NPS_w8_created_data 		"$directory\Final DTA Files\created_data"
global Uganda_NPS_w8_final_data  		"$directory\Final DTA Files\final_data"

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
//global Uganda_NPS_w8_exchange_rate 3376.4246		// Rate of Jan 1, 2015 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2016.html (Can we get historical rate from bloomberg?) // RH: average exchrt for 2019 was 3704.5036 UGX. Use that instead of Jan 1,2015?

global Uganda_NPS_w8_exchange_rate 3704.5036		// Average rate of 2019 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2019.html

global Uganda_NPS_w8_gdp_ppp_dollar 1270.608398 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PPP
global Uganda_NPS_w8_cons_ppp_dollar 1221.087646 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
global Uganda_NPS_w8_inflation 1.09056114201 //CPI_SURVEY_YEAR/CPI_2017 -> CPI_2020/CPI_2017 -> 181.882451/166.7787747 The data were collected over the period February 2019 - February 2020.

global Uganda_NPS_w8_poverty_threshold (1.90*83.58) //Calculation for WB's previous $1.90 (PPP) poverty threshold, 158 N. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. Note this is based on the 2011 PPP conversion!
global Uganda_NPS_w8_poverty_nbs 151 *(1.108) //2009-2010 poverty line from https://nigerianstat.gov.ng/elibrary/read/544 adjusted to 2011
global Uganda_NPS_w8_poverty_215 2.15 * $Uganda_NPS_w8_inflation * $Uganda_NPS_w8_cons_ppp_dollar  //New 2017 poverty line - 124.68 N

//Updated 11.15.23 - Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
*Using 2020 numbers
global Uganda_NPS_W8_pop_tot 44404611
global Uganda_NPS_W8_pop_rur 33323884
global Uganda_NPS_W8_pop_urb 11080727


********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************

*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "130 120 111 150 141 222 310 210 640 620 630 740 520 330 223"
global comma_topcrop_area "130, 120, 111, 150, 141, 222, 310, 210, 640, 620, 630, 740, 520, 330, 223"
//global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
//global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_cropname_table.dta", replace

*********************************************************************** *********
*HOUSEHOLD IDS
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec1", clear
ren wgt weight
gen rural = urban==0
gen strataid = region
ren district district_name
ren s1aq02a county
ren cc_2018 county_code
ren s1aq03a subcounty_name
ren sc_2018 subcounty_code
ren s1aq04a parish_name
ren pc_2018 parish_code
keep hhid region district district_name county county_code subcounty_code subcounty_name parish_code parish_name rural weight strataid // ea and village variables missing in this section
label var rural "1 = Household lives in a rural area"
recast str32 hhid

//side quest to add gender and age
/*
preserve
use "${Uganda_NPS_w8_raw_data}/HH/gsec2.dta", clear
gen male = h2q3 == 1
gen age = h2q8
recast str32 hhid
tostring pid, format(%19.0f) replace
keep hhid pid age male
isid hhid pid
tempfile demo
save `demo', replace
restore

merge m:1 hhid using `demo', nogen keep(1 3) */

save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", replace

********************************************************************************
*WEIGHTS* - LM added 7/11/23
********************************************************************************
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", clear
recast str32 hhid
tempfile recast
save `recast'

use "${Uganda_NPS_w8_raw_data}\HH\gsec1", clear
recast str32 hhid
ren wgt weight
merge m:1 hhid using `recast', nogen
keep hhid weight rural
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_weights.dta", replace

********************************************************************************
*INDIVIDUAL IDS - RH complete 10/21/21// 12/23 note -- need to check if update is needed, see commented code
//LM - updated 7/11/23
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec2", clear
destring pid, gen(indiv) ignore ("P" "-")
/*
ren HHID hhid
//PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P0" and the "-"
destring PID, gen(indiv) ignore ("P" "-") 
*/
gen female = h2q3==2
label var female "1= individual is female"
gen age=h2q8
lab var age "Individual age"
gen hh_head=h2q4==1 
lab var hh_head "1= individual is household head"
ren pid ind
tostring ind, gen (individ)

*clean up and save data
label var indiv "Personal identification"
label var individ "Roster number (identifier within household)"
keep hhid indiv individ female age hh_head
recast str32 hhid
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", replace
 
********************************************************************************
*HOUSEHOLD SIZE - RH complete 10/21/21 - LM checked 7/11/23
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/HH/gsec2.dta", clear
*ren hhid HHID // using hhid
gen hh_members = 1
rename h2q4 relhead //relationship to HH head
rename h2q3 gender
recast str32 hhid
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", replace

//Weight update
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Uganda_NPS_W8_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Uganda_NPS_W8_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1
total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Uganda_NPS_W8_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0
egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", replace
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_weights.dta", nogen
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_weights.dta", replace

********************************************************************************
** GEOVARIABLES ** *LM 7/11/23 Updates based on CSIRO data request.
********************************************************************************
//could not find a raw data file with geovariable information. Coming back to assess later.

****************************************************************
*PARCEL AREAS -- LM question - is this section still needed?
****************************************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a.dta", clear
gen season=1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b.dta"
replace season=2 if season==. //We won't keep these
//only one plot has a duplicate observation when monocropping was reported.
gen field_size = s4aq07 
replace field_size = s4bq07 if s4aq07 == . | s4aq07==0
replace s4aq09 = 100 if s4aq08 == 1
replace s4bq09 = 100 if s4bq08 == 1
gen pct_planted = s4aq09
replace pct_planted = s4bq09 if pct_planted==. 
collapse (max) field_size (sum) pct_planted, by(hhid parcelID pltid season)
//Testing
//bys hhid parcelID pltid : egen field_size_max = max(field_size)
//assert field_size==field_size_max  //4k obs, equal most, but there's 261 with up to 3.85 acre differences. Yikes.
collapse (max) field_size pct_planted, by(hhid parcelID pltid)
replace field_size = field_size/min(pct_planted, 100)*100 if pct_planted != 0 | pct_planted != .
recast str32 hhid
tempfile plot_estimates
save `plot_estimates'
 
use "${Uganda_NPS_w8_raw_data}/Agric/agsec3b.dta", clear
recast str32 hhid
tempfile sec3b
save `sec3b'
 
//ALT 04.13.22: So there's ~7500 unique plot identifiers but only 2753 have measurements. This is going to make crop area estimation a pain in the bidinski. 
use "${Uganda_NPS_w8_raw_data}/Agric/agsec3a.dta", clear
//generate season = 1
recast str32 hhid
merge 1:1 hhid parcelID pltid using `sec3b', nogen
merge 1:1 hhid parcelID pltid using `plot_estimates', nogen
generate plot_area = s2aq04_1 // "Size of this plot in acres? GPS with 2 decimal pts"
replace plot_area = s2aq04_1_1 if plot_area==.
replace plot_area = field_size if plot_area == .
//Over half of plot areas come from field_size
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
ren pltid plotID
//collapse (sum) plot_area, by(hhid parcelID plotID /*season*/) //Aggregate plots by household and by parcel within household AND by season, this results in more observations than if just aggregated up to the household level
bys hhid parcelID /*season*/ : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep hhid parcelID plotID /*season*/ plot_area total_plot_area plot_area_pct
tempfile plot_area
save `plot_area'
//gen parcel_id = parcelID
//gen plot_id = plotID
//save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace

use "${Uganda_NPS_w8_raw_data}/Agric/agsec2a.dta", clear 
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec2b.dta"
//no plot id in agsec2
recast str32 hhid
merge 1:m hhid parcelID using `plot_area', nogen keep (1 3) // 879 not matched from master //ALT 4.13: down to 392; we have reported areas for 328. Are they not cultivated?

// RH FLAG: Renamed variables to specify parcel and plot 
*bys hhid parcelID plot_id: egen parcel_area = sum(plot_area)
  // RH FLAG: For comparison with measured and estimated parcel area?
ren parcelID parcel_id 
gen parcel_area_acres_est = s2aq5 // in agsec2b - size of parcel in acres to 2 decimal pts (estimated)
replace parcel_area_acres_est = s2aq05 if s2aq5 ==.
gen parcel_area_acres_meas = s2aq4 // size of parcel in acres to 2 decimal pts (measured)
replace parcel_area_acres_meas = s2aq04 if s2aq4 ==.
*keep if parcel_area_acres_est !=.
ren plot_area plot_area_acres_meas
//compare parcel_area area_acres_est // avg difference of ~2 acres, 1476/6172 same ALT: 2 acres is huge.

keep hhid parcel_id plotID parcel_area_acres_est parcel_area_acres_meas plot_area_acres_meas plot_area_pct /*season*/
*lab var parcel_area "Parcel area summed from plot area in acres"
lab var parcel_area_acres_meas "Parcel area in acres (GPSd)"
lab var parcel_area_acres_est "Parcel area in acres (estimated)"
gen parcel_area_est_hectares=parcel_area_acres_est* (1/2.47105)  
gen parcel_area_meas_hectares= parcel_area_acres_meas* (1/2.47105)
lab var parcel_area_meas_hectares "Parcel area in hectares (GPSd)"
lab var parcel_area_est_hectares "Parcel area in hectares (estimated)"
gen plot_area_meas_hectares = plot_area_acres_meas * (1/2.47105)
lab var plot_area_meas_hectares "Plot area in hectares (GPSd)"

*generating field_size
generate parcel_area = parcel_area_acres_meas //JHG 10_27_21: Used GPS estimation here to get parcel size in acres if we have it, but many parcels do not have GPS estimation
replace parcel_area = parcel_area_acres_est if parcel_area == .
gen field_size = plot_area_pct*parcel_area //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size/2.471 //convert acres to hectares


*cleaning up and saving the data
rename plotID plot_id
*rename parcelID parcel_id
keep hhid parcel_id plot_id /*season*/ field_size parcel_area_acres_meas parcel_area_acres_est parcel_area_meas_hectares parcel_area_est_hectares
drop if field_size == .
label var field_size "Area of plot (ha)"
label var hhid "Household identifier"
save "${Uganda_NPS_w8_created_data}\Uganda_NPS_w8_parcel_areas.dta", replace

****************************************************************
*PLOT AREA* //LM 4.10.23 - update 7/11/23
****************************************************************
tempfile file1 file2
use "${Uganda_NPS_w8_raw_data}/Agric/agsec2a.dta", clear
recast str32 hhid
save `file1'

use "${Uganda_NPS_w8_raw_data}/Agric/agsec2b.dta", clear
recast str32 hhid
save `file2'

use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a.dta", clear
gen season=1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b.dta", generate(last)
recast str32 hhid
replace season=2 if last==1
label var season "Season = 1 if 1st cropping season of 2018, 2 if 2nd cropping season of 2018"
gen plot_area=s4aq07 //values are in acres (Total area of plot planted) a4aq9 percentage of crop planted in the plot area 
replace plot_area = s4bq07 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
rename plot_area ha_planted

gen percent_planted = s4aq09/100
replace percent_planted = s4bq09/100 if percent_planted==.
bys hhid parcelID pltid season : egen total_percent_planted = sum(percent_planted) //generate variable for total percent of a plot that is planted (all crops)
duplicates tag hhid parcelID pltid season, g(dupes) //generate a duplicates ratio to check for all crops on a specific plot. the number in dupes indicates all of the crops on a plot minus one (the "original")
gen missing_ratios = dupes > 0 & percent_planted == . //now use that duplicate variable to find crops that don't have any indication of how much a plot they take up, even though there are multiple crops on that plot (otherwise, duplicates would equal 0)
bys hhid parcelID pltid season : egen total_missing = sum(missing_ratios) //generate a count, per plot, of how many crops do not have a percentage planted value.
gen remaining_land = 1 - total_percent_planted if total_percent_planted < 1 //calculate the amount of remaining land on a plot (that can be divided up amongst crops with no percentage planted) if it doesn't add up to 100%
bys hhid parcelID pltid season : egen any_missing = max(missing_ratios)
*Fix monocropped plots
replace percent_planted = 1 if percent_planted == . & any_missing == 0 //monocropped plots are marked with a percentage of 100% - impacts 5,244 crops
*Fix plots with or without missing percentages that add up to 100% or more
replace percent_planted = 1/(dupes + 1) if any_missing == 1 & total_percent_planted >= 1 //If there are any missing percentages and plot is at or above 100%, everything on the plot is equally divided (as dupes indicates the number of crops on that plot minus one) - this impacts 9 crops
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1 //some crops still add up to over 100%, but these ones aren't missing percentages. So we need to reduce them all proportionally so they add up to 100% but don't lose their relative importance.
*Fix plots that add up to less than 100% and have missing percentages
replace percent_planted = remaining_land/total_missing if missing_ratios == 1 & percent_planted == . & total_percent_planted < 1 //if any plots are missing a percentage but are below 100%, the remaining land is subdivided amonst the number of crops missing a percentage - impacts 205 crops

*Bring everything together
collapse (max) ha_planted (sum) percent_planted, by(hhid parcelID pltid season)
gen plot_area = ha_planted / percent_planted
bys hhid parcelID season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep hhid parcelID pltid season plot_area total_plot_area plot_area_pct ha_planted

merge m:1 hhid parcelID using `file1', nogen
merge m:1 hhid parcelID using `file2'

*generating field_size
generate parcel_acre = s2aq04 //JHG 10_27_21: Used GPS estimation here to get parcel size in acres if we have it, but many parcels do not have GPS estimation
replace parcel_acre = s2aq4 if parcel_acre == . 
replace parcel_acre = s2aq05 if parcel_acre == . //JHG 10_27_21: replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres)
replace parcel_acre = s2aq5 if parcel_acre == . //JHG 10_27_21: see above
gen field_size = plot_area_pct*parcel_acre //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen parcel_ha = parcel_acre * 0.404686
*cleaning up and saving the data
rename pltid plot_id
rename parcelID parcel_id
keep hhid parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size==.
label var field_size "Area of plot (ha)"
label var hhid "household identifier"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace 

****************************************************************
*AREA PLANTED* - LM added 7/11/23 from W7 - LM question, is this section needed?
****************************************************************
/*use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a.dta", clear
gen season=1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b.dta", generate(last)
recast str32 hhid
replace season = 2 if season == .
ren cropID crop_code
ren parcelID parcel_id
ren pltid plot_id

gen plot_ha_planted = s4aq07*(1/2.47105)
replace plot_ha_planted = s4bq07*(1/2.47105) if plot_ha_planted==.

* introduce area in ha 
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3)

*Adjust for inter-cropping
gen per_intercropped=s4aq09
replace per_intercropped=s4bq09 if per_intercropped==.  

gen  is_plot_intercropped=s4aq08==2 | s4bq08==2
replace is_plot_intercropped=1 if per_intercropped!=.  

*Scale down percentage
bys  hhid parcel_id plot_id   : egen total_percent_planted = total(per_intercropped) if is_plot_intercropped==1 
replace plot_ha_planted=plot_ha_planted if is_plot_intercropped==0
replace plot_ha_planted=plot_ha_planted*(per_intercropped/total_percent_planted) if is_plot_intercropped==1 
*Now sum area planted for sub-plots should not exceed field size. If so rescal proportionally including for monocrops
bys  hhid parcel_id  : egen total_ha_planted = total(plot_ha_planted)

replace plot_ha_planted=plot_ha_planted*(field_size/total_ha_planted) if total_ha_planted>field_size & total_ha_planted!=.
gen  ha_planted=plot_ha_planted 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_area_planted_temp.dta", replace 
*/


****************************************************************
*PLOT DECISION MAKERS -- RH complete 2/16/22 - LM 7/13/23 (similar to W3 - not W7)
****************************************************************
**GENDER MERGE**
use "${Uganda_NPS_w8_raw_data}\HH\gsec2.dta", clear
*tostring PID, gen(personid) format(%18.0f)			// personid is the roster number, combination of household_id2 and personid are unique id for this wave
ren pid indiv
gen female =h2q3==2
label var female "1 = individual is female"
gen age = h2q8
label var age "Individual age"
gen hh_head = h2q4==1 if h2q4!=.
label var hh_head "1 = individual is household head"
keep hhid indiv female age hh_head
*need to convert StrL to Str32 for merging
recast str32 hhid // converting from strL to STR# so we can use HHID as merge variable
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", replace

*Decision makers asked about at PLOT level
use "${Uganda_NPS_w8_raw_data}\Agric\agsec3a.dta", clear // OWNED PLOTS
gen season=1
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec3b.dta" // NON-OWNED PLOTS
replace season=2 if season==.
ren parcelID parcel_id
ren pltid plot_id
drop if parcel_id==.

recast str32 hhid

*First decision-maker variables 
gen indiv = s3aq03_3
replace indiv = s3bq03_3 if indiv == . & s3bq03_3 != .
merge m:1 hhid indiv using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", gen(dm1_merge) keep(1 3) //6969 not matched
gen dm1_female = female
drop female indiv

*Second decision-maker variables
gen indiv = s3aq03_4b
replace indiv = s3bq03_4b if indiv == . &  s3bq03_4b != .
merge m:1 hhid indiv using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", gen(dm2_merge) keep(1 3)		// 6,149 unmatched from master. 
gen dm2_female = female
drop female indiv

*JHG 12_28_21: They only collected information on two decision-makers per plot - no 3rd decision maker.

collapse (max) dm1_female dm2_female, by (hhid parcel_id plot_id season)

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep hhid parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & (dm2_female == 0 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & (dm2_female == 1 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 3 if dm_gender == . & !(dm1_female == . & dm2_female == .) //no mixed-gender managed plots
label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", nogen //593 not matched
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . //593 dropped
drop if parcel_id==.
duplicates report hhid plot_id season
keep hhid parcel_id plot_id season dm_gender fhh //***cultivated, also plotname was here but is not a variable in this wave
***lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", replace

****************************
*AREA PLANTED* LM 4.26.23... 9/2/2023 - Is this section still needed?
****************************
/*use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b.dta"
gen str strhhid = hhid
replace hhid = ""
compress hhid
replace hhid = strhhid
drop strhhid
replace season = 2 if season == .
ren cropID crop_code
ren parcelID parcel_id
ren pltid plot_id

// check variable for cultivated
gen plot_ha_planted = s4aq07*(1/2.47105)
replace plot_ha_planted = s4bq07*(1/2.47105) if plot_ha_planted==.


* introduce area in ha 
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3)
			
*Adjust for inter-croppinp
gen per_intercropped=s4aq09
replace per_intercropped=s4bq09 if per_intercropped==.  // ta a4bq9  - no obs. No intercropping in second season/visit? 

gen  is_plot_intercropped=s4aq08==2 | s4bq08==2
replace is_plot_intercropped=1 if per_intercropped!=.  // 11 changes //EFW 6.2.19 0 changes in this code. Why 11 in Didier code??
*Scale down percentage
bys  hhid parcel_id plot_id   : egen total_percent_planted = total(per_intercropped) if is_plot_intercropped==1 
replace plot_ha_planted=plot_ha_planted if is_plot_intercropped==0
replace plot_ha_planted=plot_ha_planted*(per_intercropped/total_percent_planted) if is_plot_intercropped==1 
*Now sum area planted for sub-plots should not exceed field size. If so rescal proportionally including for monocrops
bys  hhid parcel_id  : egen total_ha_planted = total(plot_ha_planted)

replace plot_ha_planted=plot_ha_planted*(field_size/total_ha_planted) if total_ha_planted>field_size & total_ha_planted!=.
gen  ha_planted=plot_ha_planted 

save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_area_planted_temp.dta", replace*/

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec2a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec2b.dta"
replace season = 2 if season ==.
recast str32 hhid
gen formal_land_rights = 1 if s2aq23<4
replace formal_land_rights = 0 if s2aq23==4 

*Starting with first owner
preserve
rename s2aq24__0 indivi
tostring indivi, gen(individ)
merge m:1 hhid individ using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", nogen keep(3)		// keep only matched
keep hhid individ female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve
ren s2aq24__1 indivi
tostring indivi, gen(individ)
merge m:1 hhid individ using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", nogen keep(3)	
keep hhid individ female
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid individ)		
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rights_ind.dta", replace
restore	

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rights_hh.dta", replace
restore

********************************************************************************
** 								ALL PLOTS									  ** LM 9/15/23
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
1. Variables created: Time of crop planting (year and month), permanent crop, purestand, monocrop/intercrop indicator, 

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.
*/

**********************************
** Crop Values **
**********************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec5a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec5b.dta"
replace season = 2 if season ==.
recast str32 hhid
ren cropID crop_code
ren parcelID parcel_id
ren pltid plot_id
gen full_harvest = 0
replace full_harvest = 1 if harvest == 1 & harvest_b == 1
gen part_harvest = 0
replace part_harvest = 1 if harvest == 2 & harvest1 == 1 & harvest_b == 2
//Isolating the variables
/* CATEGORIES
1 = 2018, full harvest, condition 1
2 = 2018, full harvest, condition 2
3 = 2018, part harvest, condition 1
4 = 2018, part harvest, condition 2
5 = 2019, condition 1
6 = 2019, condition 2
*/
gen condition_harv1 = s5aq06c_1
gen condition_sold1 = s5aq07b_1
gen condition_harv2 = s5aq06c_2
gen condition_sold2 = s5aq07b_2
gen condition_harv3 = s5aq06c_11
gen condition_sold3 = s5aq07b_11
gen condition_harv4 = s5aq06c_21
gen condition_sold4 = s5aq07b_21
gen condition_harv5 = s5bq06c_1
gen condition_sold5 = s5bq07b_1
gen condition_harv6 = s5bq06c_2
gen condition_sold6 = s5bq07b_2
gen quantity_harv1 = s5aq06a_1
gen sold_qty1 = s5aq07a_1
gen quantity_harv2 = s5aq06a_2
gen sold_qty2 = s5aq07a_2
gen quantity_harv3 = s5aq06a_11
gen sold_qty3 = s5aq07a_11
gen quantity_harv4 = s5aq06a_21
gen sold_qty4 = s5aq07a_21
gen quantity_harv5 = s5bq06a_1
gen sold_qty5 = s5bq07a_1
gen quantity_harv6 = s5bq06a_2
gen sold_qty6 = s5bq07a_2
gen unit_code_harv1 = s5aq06b_1
gen sold_unit_code1 = s5aq07c_1
gen unit_code_harv2 = s5aq06b_2
gen sold_unit_code2 = s5aq07c_2
gen unit_code_harv3 = s5aq06b_11
gen sold_unit_code3 = s5aq07c_11
gen unit_code_harv4 = s5aq06b_21
gen sold_unit_code4 = s5aq07c_21
gen unit_code_harv5 = s5bq06b_1
gen sold_unit_code5 = s5bq07c_1
gen unit_code_harv6 = s5bq06b_2
gen sold_unit_code6 = s5bq07c_2
gen conv_factor_sold1 = s5aq06d_1
gen conv_factor_sold2 = s5aq06d_2
gen conv_factor_sold3 = s5aq06d_11
gen conv_factor_sold4 = s5aq06d_21
gen conv_factor_sold5 = s5bq06d_1
gen conv_factor_sold6 = s5bq06d_2
gen conv_factor_harv1 = s5aq06d_1
gen conv_factor_harv2 = s5aq06d_2
gen conv_factor_harv3 = s5aq06d_11
gen conv_factor_harv4 = s5aq06d_21
gen conv_factor_harv5 = s5bq06d_1
gen conv_factor_harv6 = s5bq06d_2
gen sold_value1 = s5aq08_1
gen sold_value2 = s5aq08_2
gen sold_value3 = s5aq08_11
gen sold_value4 = s5aq08_21
gen sold_value5 = s5bq08_1
gen sold_value6 = s5bq08_2
gen month_harv_date1 = s5aq06e_1
gen month_harv_date2 = s5aq06e_2
gen month_harv_date3 = s5aq06e_11
gen month_harv_date4 = s5aq06e_21
gen month_harv_date5 = s5bq06e_1
gen month_harv_date6 = s5bq06e_2
gen year_harv_date1 = s5aq06e_1_1
gen year_harv_date2 = s5aq06e_1_2
gen year_harv_date3 = s5aq06e_1_11
gen year_harv_date4 = s5aq06e_1_21
gen year_harv_date5 = s5bq06e_1_1
gen year_harv_date6 = s5bq06e_1_2
gen month_harv_end1 = s5aq06f_1
gen month_harv_end2 = s5aq06f_2
gen month_harv_end3 = s5aq06f_11
gen month_harv_end4 = s5aq06f_21
gen month_harv_end5 = s5bq06f_1
gen month_harv_end6 = s5bq06f_2
gen year_harv_end1 = s5aq06f_1_1
gen year_harv_end2 = s5aq06f_1_2
gen year_harv_end3 = s5aq06f_1_11
gen year_harv_end4 = s5aq06f_1_21
gen year_harv_end5 = s5bq06f_1_1
gen year_harv_end6 = s5bq06f_1_2
gen loss1 = s5aq17_1
gen loss2 = s5aq17_2
gen loss3 = s5aq17_11
gen loss4 = s5aq17_21
gen loss5 = s5bq17_1
gen loss6 = s5bq17_2

reshape long condition_harv condition_sold quantity_harv sold_qty unit_code_harv sold_unit_code conv_factor_sold conv_factor_harv sold_value month_harv_date year_harv_date month_harv_end year_harv_end loss, i(hhid parcel_id plot_id crop_code season) j(category)

replace conv_factor_harv = 1 if unit_code_harv==1
replace conv_factor_sold = 1 if sold_unit_code==1
gen quant_sold_kg = sold_qty*conv_factor_sold 

merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keepusing (region district_name county subcounty_name parish_name weight) keep(1 3)
recode crop_code  (741 742 744 = 740)  //  Same for bananas (740)
label define crop_code 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code //apply crop labels to crop_code_master

**********************************
** Standard Conversion Factor Table **
**********************************
*This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold.
 *Standard Conversion Factor Table: By using All 7 Available Uganda waves we calculated the median conversion factors at the crop-unit-regional level for both sold and harvested crops. For  crops-unit-region conversion factors that were missing observations, information we imputed the conversion factors at the crop-unit-national level values. 
*This Standard coversion factor table will be used across all Uganda waves to estimate kilogram harvested, and price per kilogram median values. 

preserve
use "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table_w8.dta", replace

use "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table_national.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table_national_w8.dta", replace
restore

***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table_w8.dta", keep(1 3) nogen

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for hhid with missiong regional information. 
merge m:1 crop_code sold_unit_code using "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table_national_w8.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. // We merge the national standard conversion factor for those HHID with missing regional info. 
gen s_quant_sold_kg = sold_qty*s_conv_factor_sold
replace s_quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen s_price_unit = sold_value/s_quant_sold_kg 
gen obs1 = s_price_unit!=.

ren district_name district
ren subcounty_name subcounty
ren parish_name parish

// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standard conversion factor table)
	foreach i in region district county subcounty parish hhid {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen s_obs_`i'_price = sum(obs1)
		collapse (median) s_price_unit_`i' = s_price_unit [aw=weight], by /*(`i' sold_unit_code crop_ode obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' s_obs_`i'_price)
		tempfile s_price_unit_`i'_median
		save `s_price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) s_price_unit_country = s_price_unit (sum) s_obs_country_price = obs1 [aw=weight], by(crop_code /*sold_unit_code*/)
	tempfile s_price_unit_country_median
	save `s_price_unit_country_median'
	restore

preserve
use "${Uganda_NPS_w8_created_data}/UG_Conv_fact_harvest_table.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_w8_created_data}/UG_Conv_fact_harvest_table_w8.dta", replace

use "${Uganda_NPS_w8_created_data}/UG_Conv_fact_harvest_table_national.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_w8_created_data}/UG_Conv_fact_harvest_table_national_w8.dta", replace
restore

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
merge m:1 crop_code unit_code region using "${Uganda_NPS_w8_created_data}/UG_Conv_fact_harvest_table_w8.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${Uganda_NPS_w8_created_data}/UG_Conv_fact_harvest_table_national_w8.dta", keep(1 3) nogen 
*This is for hhid that are missing regional information

*From Conversion factor section to calculate medians
gen quant_harv_kg = quantity_harv*conv_factor_harv
replace s_conv_factor_harv = sn_conv_factor_harv if region!=. // We merge the national standard conversion factor for those HHID with missing regional info.
gen s_quant_harv_kg = quantity_harv*s_conv_factor_harv 

*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg  that using the WB conversion factors -though there are many cases that standard qty harvested is smaller than the WB qty harvested. 
*Notes: Should we winsorize the sold qty ($) prior to calculating the price per kg giventhis variable is also driving the variation and has many outliers. Though, it won't affect themedian price per kg it will affect the  price per unit for all the observations that do have sold harvested affecting the value of harvest. 

**********************************
* Update: Standard Conversion Factor Table END **
**********************************
//LM 9.29.23 Okay but W8 does have information about the year of harvest... approaching these next few lines of code differently given the change in W8 compared to W3
gen harv_date = ym(year_harv_date, month_harv_date)
format harv_date %tm
label var harv_date "Harvest start date"

gen harv_end = ym(year_harv_end, month_harv_end)
format harv_end %tm
label var harv_end "Harvest end date"

*Create Price unit for converted sold quantity (kgs)
gen price_unit=sold_value/(quant_sold_kg)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=.
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_crop_value.dta", replace 

*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested*/

//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.
foreach i in region district county subcounty parish hhid {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' obs_`i'_price)
		*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code /*sold_unit_code*/)
	*rename sold_unit_code unit_code_harv //needs to be done for a merge near the end of the all_plots indicator
	tempfile price_unit_country_median
	save `price_unit_country_median'
	restore

**********************************
** [Harvest and Sold] Crop Unit Conversion Factors  **
**********************************
*Notes: This section was used to calculate the median crop unit conversion factors for harvest and sold variables. Now, we will use the raw variable from the World bank.

**********************************
** Plot Variables **
**********************************
*Clean up file and combine both seasons
preserve
use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b.dta"
recast str32 hhid
replace season = 2 if season ==.
rename pltid plot_id
rename parcelID parcel_id
rename cropID crop_code_plant //crop codes for what was planted
drop if crop_code_plant==.
clonevar crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
recode crop_code_master  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define L_CROP_LIST 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code_master L_CROP_LIST //apply crop labels to crop_code_master
//tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3)

*Creating time variables (month planted, harvested, and length of time grown)
* month planted
gen month_planted = s4aq09_1
replace month_planted = s4bq09_1 if season == 2 
* year planted
gen year_planted = 2019 if s4aq09_2==2019 | s4bq09_2==2019
replace year_planted = 2018 if s4aq09_2==2018 | s4bq09_2==2018 
gen plant_date = ym(year_planted, month_planted)
/*replace year_planted1 = 9999 if year_planted1==9998 | year_planted1<2018 // set year for perennial crops
gen year_planted2 = s4bq09_2
replace year_planted2 = 9999 if year_planted2==9998 | year_planted2<2018
gen year_planted = year_planted1
replace year_planted = year_planted2 if year_planted==.*/
lab var month_planted "Month of planting relative to December 2018 (both cropping seasons)"
lab var year_planted "Year of planting"
format plant_date %tm
label var plant_date "Plantation start date"
//merge m:m hhid parcel_id plot_id crop_code season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_vals_hhids.dta", nogen
clonevar crop_code =  crop_code_master 
gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?
duplicates drop hhid parcel_id plot_id crop_code season, force
//gen dups = _n
tempfile plotplanted
save `plotplanted'
restore
merge m:1 hhid parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3)

**********************************
** Plot Variables After Merge **
**********************************
* Update 
gen months_grown1 = harv_date - plant_date if perm_tree==0
replace harv_date = ym(2019,month_harv_date) if months_grown1<=0
gen months_grown = harv_date - plant_date if perm_tree==0

*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if loss!=.
		collapse (sum) crops_plot = obs2, by(hhid parcel_id plot_id season)
		tempfile ncrops
		save `ncrops'
	restore
	merge m:1 hhid parcel_id plot_id season using `ncrops', nogen
	gen contradict_mono = 1 if s4aq09 == 100 | s4bq09 == 100 & crops_plot > 1
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if s4aq09 == 100 | s4aq08 == 1 | s4bq09 == 100 | s4bq08 == 1
	
*Generate variables around lost and replanted crops
	gen lost_crop = loss!=.
	bys hhid parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 
	
*Generating monocropped plot variables (Part 1)
	bys hhid parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys hhid parcel_id plot_id season : egen permax = max(perm_tree)
	bys hhid parcel_id plot_id season month_planted year_planted : gen plant_date_unique = _n
	bys hhid parcel_id plot_id season month_harv_date : gen harv_date_unique = _n 
	bys hhid parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys hhid parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (s4aq08 == 2 | s4bq08 == 2)
	bys hhid parcel_id plot_id season : egen mixed_max = max(mixed)
	replace purestand = 1 if crop_code_master == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	

	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys hhid parcel_id plot_id season: egen total_percent = total(percent_field)
	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	replace ha_planted = percent_field*field_size
	
**********************************
** Crop Harvest Value **
**********************************
*Update Incorporating median price per kg to calculate Value of Harvest ($) -using WB Conversion factors 
foreach i in region district county subcounty parish hhid {	
	merge m:1 `i' /*unit_code*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_code*/ crop_code using `price_unit_country_median', nogen keep(1 3)
}
rename price_unit val_unit

*SAW 7/24/23 Update: Incorporating median standard price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors 
foreach i in region district county subcounty parish hhid {	
	merge m:1 `i' /*unit_code*/ crop_code using `s_price_unit_`i'_median', nogen keep(1 3)
	merge m:1 /*unit_code*/ crop_code using `s_price_unit_country_median', nogen keep(1 3)
}
rename s_price_unit s_val_unit

*Generate a definitive list of value variables
// We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
recode obs_* (.=0) //ALT 
foreach i in region district county subcounty parish {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_hhid if price_unit_hhid != .
gen value_harvest = val_unit*quant_harv_kg 

*  Generate a definitive list of value variables: Same as above but using the standard price per kg instead of the wb price per kg
recode s_obs_* (.=0) //ALT 
foreach i in region district county subcounty parish {
	replace s_val_unit = s_price_unit_`i' if s_obs_`i'_price > 9
}
	gen s_val_missing = s_val_unit == .
	replace s_val_unit = s_price_unit_hhid if s_price_unit_hhid != .

gen s_value_harvest = s_val_unit*s_quant_harv_kg 

preserve
	ren unit_code_harv unit
	collapse (mean) val_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_crop_prices_for_wages2.dta", replace
	restore	

*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field s_quant_harv_kg s_value_harvest (max) months_grown plant_date harv_date harv_end, by(region district county subcounty parish hhid parcel_id plot_id season crop_code_master purestand field_size /*month_planted month_harvest*/)
	bys hhid parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys hhid parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_all_plots.dta", replace

********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************
//Delete this next part? I think this is old All Plots code
/*
recast str32 hhid 
tempfile harvestvals
save `harvestvals'

//Planting is agsec4a, agsec4b -- first and second visits
*Clean up file and combine both seasons	
use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b.dta"
replace season = 2 if season ==.
recast str32 hhid
merge 1:1 hhid parcelID pltid cropID season using `harvestvals', nogen
	ren parcelID parcel_id
	ren pltid plot_id

append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_vals_hhids.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_allplots_temp.dta" 
// combined agsec5a and b-  crop harvest, sales - still need planting 

	replace crop_code = cropID if crop_code==.
	*rename cropID crop_code //_plant //crop codes for what was planted
	drop if crop_code == . //_plant == .

	gen crop_code_master = crop_code //_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
	recode crop_code_master (811 812 = 810) (741 742 744 = 740) (221 222 223 224 = 220) //810 is coffee, which is being reduced from different types to just coffee. Same for bananas (740) and peas (220).
	label define cropID 810 "Coffee" 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
	label values crop_code_master cropID //apply crop labels to crop_code_master
	
	*Create area variables
	//ALT note: you shouldn't need to do _s1 and _s2 because the season variable contains that information. Using append rather than merge ensures we'll never have more than than one of s4aq07/s4bq07 per line (which is how we like it)
	//s4aq07 and s4bq07 refer to total area of [PLOT] planted
	rename s4aq07 acre_planted  //s1 = season 1
	replace acre_planted = s4bq07 if season==2
	gen ha_planted = acre_planted * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
	label var ha_planted "Hectares planted per-plot" // in the last cropping season of 2019"
	//rename s4bq07 acre_planted_s2 //s2 = season 2
	//gen ha_planted_s2 = acre_planted_s2 * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
	//label var ha_planted_s2 "Hectares planted per-plot in the first cropping season of 2020"
	
//come back here, need to see if can add plot id to plot areas; fixing plot areas
	merge m:1 hhid parcel_id plot_id /*season*/ using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta", nogen keep(1 3)
	//5,066 not matched, why? 12,719 matched
	//with season included 11.652 , 6133 matched
	//ALT: post update, 128 not matched. The majority of these numbers come from grower estimates, however. 
	
	//ALT 04.14.21: It looks like some of these changes result in crazy departures from the initial estimate. We should revisit plot size estimation 
	replace ha_planted = field_size * s4aq09 / 100 if s4aq09 != . & s4aq09 != 0 & field_size !=. //Preferring percentage estimates over area estimates when we have both. JHG 12_31_21: This results in a mean ~40% below where it was and a max value nearly three times as large. Seems abnormal. Checked Andrew's Nigeria W3 code and his max declined by 850(!!!) while the mean decline by ~30%. Shows how different farmer estimates can be.
	replace ha_planted = field_size * s4bq09 /100 if s4bq09 != . & s4bq09 != 0 & field_size !=. //JHG 12_31_21: max value doesn't change here but similar change with mean value declining, albeit more significantly here.
 	//gen ha_planted = ha_planted_s1
	//replace ha_planted = ha_planted_s2 if ha_planted == . //combine both cropping seasons/*replaced with code below
	*Creating time variables (month planted, harvested, and length of time grown)
	gen month_planted = s4aq09_1
	replace month_planted = s4bq09_1 if season == 2 
	*replace month_planted = . if s4aq09_1 == 99 //have to remove permanent crops/trees like coffee and bananas
	*replace month_planted = . if s4bq09_1 == 99
	lab var month_planted "Month of planting (both cropping seasons)"
	*gen crop_code = crop_code_master
	*merge m:m hhid parcel_id plot_id /*crop_code*/ season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_vals_hhids.dta", nogen 
	
	merge m:1 hhid crop_code season parcel_id plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_vals_hhids.dta", nogen 
	//13,208 matched, 17,785 unmatched // do we still want to merge if this is already appended??
	// do we need to merge with crop code? fewer matches
	//rename crop_code_plant crop_code_harvest
	*drop if crop_code_harvest == . //10 observations dropped
	
//RH 4/19 flag: Temporal variables section - finish and finish monocrop/ intercrop sections	

/*ALT 04.18.22: The purpose of this section is to weed out plots that were planted with multiple crops but not at the same time due to either crop losses or relay cropping.
The basic workflow looks like this:
	Get month planted/harvested for each crop (s4a/bq09_1 and s5a/bq06e_2)
	Check to see if any crops were lost (s5a/bq17_1) :
		If a crop losses resulted in harvest for only 1 crop, count as purestand
		If a crop was harvested before another crop was planted in same season, count as mixed (for now; we can't assign inputs) 
	Some example code*/
		*gen month_planted = s4aq09_1
		*replace month_planted=  s4bq09_1 if month_planted==. //already done above
		gen year_planted = s4aq09_2
		replace year_planted =s4bq09_2 if year_planted == .
		replace year_planted = . if year_planted == 9998 
		replace month_planted = month_planted+12 if year_planted == 2020 //Count Jan 2019 as origin. (Data collection started feb 2019)
		bys hhid parcel_id plot_id season : egen max_mo_planted = max(month_planted)
		gen month_harvest = s5aq06e_1
		replace month_harvest = s5bq06e_1 if month_harvest == .
		gen year_harvest = s5aq06e_1_1 
		replace year_harvest = s5bq06e_1_1 if year_harvest == .
		replace month_harvest = month_harvest + 12 if year_harvest == 2019
		replace month_harvest = month_harvest - 12 if year_harvest == 2017
		bys hhid parcel_id plot_id season : egen min_mo_harvest = min(month_harvest)
		gen relay = max_mo_planted > min_mo_harvest //Some 16% of crops were relayed?
		// RH 7.29.22 now seems to be mean .286 - is this reasonable?
	
	gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order
	replace perm_tree = 0 if perm_tree == .
	lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?
	//ALT 04.15.22: Starchy tubers like sweet potato, cocoyam/taro, cassava, enset, etc, are most accurately defined as multi-season crops. I treat cassava like a permanent crop in NGA but for the remainder it's sometimes difficult to tell how long the crop has been there or when intended harvest will occur. Definitely an area with potential for improvements.
	gen months_grown = month_harvest - month_planted if perm_tree == 0 //If statement removes permanent crops from consideration. JHG 12_31_21: results in some negative values. These likely are typos (putting the wrong year) because the timeline would lineup correctly based on the crop if the years were 2015 instead of 2014 for harvesting. Attempt to fix above corrected some entries but not all. Rest are removed in next line.
	replace months_grown = . if months_grown < 1 | month_planted == . | month_harvest == .
	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	gen reason_loss = s5aq17_1
	replace reason_loss = s5aq17_2 if reason_loss==.
	replace reason_loss = s5aq17_11 if reason_loss==.
	replace reason_loss = s5aq17_21 if reason_loss==.
	replace reason_loss = s5bq17_1 if reason_loss==.
	replace reason_loss = s5bq17_2 if reason_loss==.
	
	preserve
		gen obs = 1
		replace obs = 0 if inrange(reason_loss,1,4) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc.
		//a5aq17 - what was the reason for the loss?
		collapse (sum) crops_plot = obs, by(hhid parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 hhid parcel_id plot_id season using `ncrops', nogen
	/*drop if hh_agric == . what is this? From w5 code*/
	gen contradict_mono = 1 if s4aq09 == 100 | s4bq09 == 100 & crops_plot > 1 //816 plots have >1 crop but list monocropping
	// a4aq9 = approx what percentage of the plot area was under this crop? (100 = 100%)
	//a4aq8 = what type of crop stand was on the plot (1 = pure stand, 2 = mixed)
	//no observations
	
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if s4aq09 == 100 | s4aq08 == 1 | s4bq09 == 100 | s4bq08 == 1 //meanwhile 173 list intercropping or mixed cropping but only report one crop
	//s4aq09, b9 = what percentage of plot (100% = pure stand); s4aq08 = what kind of crop stand (1=purestand)
	
	*Generate variables around lost and replanted crops
	gen lost_crop = inrange(reason_loss,1,4)
	//1-4 includes all reasons for crop loss besides "other"
	
	bys hhid parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	/*gen month_lost = month_planted if lost_crop==1 
	gen month_kept = month_planted if lost_crop==0
	bys hhid plot_id : egen max_month_lost = max(month_lost)
	bys hhid plot_id : egen min_month_kept = min(month_kept)
	gen replanted = (max_lost==1 & crops_plot>0 & min_month_kept>max_month_lost)*/ //Gotta filter out interplanted. //JHG 1_7_22: should I keep this code that's been edited out from Nigeria code?
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.
	
	
	
	*Generating monocropped plot variables (Part 1)
	bys hhid parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys hhid parcel_id plot_id season : egen permax = max(perm_tree)
	bys hhid parcel_id plot_id season s4aq09_1 s4bq09_1 : gen plant_date_unique = _n
	//month crop planted
	*replace plant_date_unique = . if s4aq9_1 == 99 | s4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis
	// w8 doesn't have that 99 code
	bys hhid parcel_id plot_id season month_harvest : gen harv_date_unique = _n
	//in what month did the harvest begin?
	bys hhid parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys hhid parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop.
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (s4aq08 == 2 | s4bq08 == 2)
	//crop stand
	bys hhid parcel_id plot_id season : egen mixed_max = max(mixed)
	replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 //JHG 1_14_22: 8 replacements, all of which report missing crop_code values. Should all missing crop_code values be dropped? If so, this should be done at an early stage.
	//now 4036 changes
	*gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 */ -- relay already created above
	replace purestand = 1 if crop_code_master == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	/*JHG 1_14_22: Can't do this section because no ha_harvest information. 1,598 plots have ha_planted > field_size
	Okay, now we should be able to relatively accurately rescale plots.
	replace ha_planted = ha_harvest if ha_planted == . //X # of changes
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. //X# of changes */
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys hhid parcel_id plot_id season: egen total_percent = total(percent_field)
//about 51% of plots have a total intercropped sum greater than 1
//about 26% of plots have a total monocropped sum greater than 1

	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	//8568 changes made
	replace ha_planted = percent_field*field_size
	merge m:1 hhid plot_id crop_code parcel_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_harvvals_hhids.dta"
	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey
	
	
//ALT 04.18.22: No longer necessary 
	/*	
	//RH this may be in file already
	*Renaming variables for merge to work //JHG 1/20/2022: section is unnecessary if we can't get conversion factors to work
	ren qty_harvest quantity_harvested
	//how much did you harvest during the [season]
	drop crop_code_harvest // already have crop_code
	*ren crop_code_harvest crop_code
	recode crop_code (811 812 = 810) (741 742 744 = 740) (221 222 223 224 = 220) //810 is coffee, which is being reduced from different types to just coffee. Same for bananas (740) and peas (220).
	label define cropID 810 "Coffee" 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
	label values crop_code cropID //apply crop labels to crop_code
	rename cond_harv condition
	lab var condition "condition at harvest"
	//harvest condition
	//JHG 1/20/2022: can't do any conversion without conversion factors, there are currently no good substitutes for what they provide and that is very inconsistent within units (different conversion factors for same unit and crop). To get around this, we decided to use median values by crop, condition, and unit given what the survey provides.	
	

	*merging in conversion factors and generating value of harvest variables
	//merge m:m crop_code condition unit_harvest using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_conv_fact.dta", keep(1 3) gen(cf_merge) // FLAG need to add unit harvest to conv fact; MAKE SURE CONV FACT IS STILL REFERRING TO RIGHT THING (harvest vs sold) IN OTHER REFERENCE SECTIONS
	//8644 unmatched, 9947 matched
	gen quant_harv_kg = quantity_harvested * conv_fact_median
	ren val_sold value_harvest
	*replace value_harvest = a5bq8 if value_harvest == .
	// what was this -- removed line above for now, see if can figure out later
	gen val_unit = value_harvest/quantity_harvested
	gen val_kg = value_harvest/quant_harv_kg
	
	*Generating plot weights, then generating value of both permanently saved and temporarily stored for later use
	merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen /*keepusing(weight)*/ keep(1 3)
	gen plotweight = ha_planted * weight

	gen obs = quantity_harvested > 0 & quantity_harvested != .

	foreach i in region district_code county_code scounty_code parish_code ea hhid { //JHG 1_28_22: scounty_code and parish_code are not currently labeled, just numerical
	preserve
	bys crop_code `i' : egen obs_`i'_kg = sum(obs)
	collapse (median) val_kg_`i' = val_kg  [aw = plotweight], by (`i' crop_code obs_`i'_kg)
	*tempfile val_kg_`i'_median
	*save `val_kg_`i'_median'
	save "${Uganda_NPS_w8_created_data}/temp/val_kg_`i'_median", replace
	restore
}

preserve
	collapse (median) val_kg_country = val_kg (sum) obs_country_kg = obs [aw = plotweight], by(crop_code)
	
	*tempfile val_kg_country_median 
	*save `val_kg_country_median' // RH: w5 used tempfiles but for some reason this kept breaking (invalid file specification), so just creating files to finish this section. FLAG if someone else can fix
	save "${Uganda_NPS_w8_created_data}/temp/val_kg_country_median", replace
restore


foreach i in region district_code county_code scounty_code parish_code ea hhid { 
	//RH FLAG: using unit sold but should it be unit harvest?
	//WHY is this breaking (invalid file specification for the tempfile )
	preserve
	bys `i' crop_code unit_sold : egen obs_`i'_unit = sum(obs)
	collapse (median) val_unit_`i' = val_unit [aw = plotweight], by (`i'  unit_sold crop_code obs_`i'_unit) // why is it losing unit harvest??
	*tempfile val_unit_`i'_median
	*save `val_unit_`i'_median'
	save "${Uganda_NPS_w8_created_data}/temp/val_unit_`i'_median", replace
	restore

	//rh: changed to many to many merge because this doesn't uniquely identify obs in using data
	//in w5 it merges by unit_code which we don't have here. Should that be created?
	//unitcode is sold_unit_code in w5
	merge m:m `i' unit_sold crop_code using "${Uganda_NPS_w8_created_data}/temp/price_unit_`i'_median", nogen keep(1 3) 
	merge m:m `i' unit_sold crop_code using "${Uganda_NPS_w8_created_data}/temp/val_unit_`i'_median", nogen keep(1 3)
	
	merge m:m `i' crop_code using "${Uganda_NPS_w8_created_data}/temp/val_kg_`i'_median", nogen keep(1 3)

}

preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit = obs [aw = plotweight], by(crop_code unit_sold)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore

merge m:m unit_sold crop_code using "${Uganda_NPS_w8_created_data}/temp/price_unit_country_median", nogen keep(1 3)
merge m:m unit_sold crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_median_country.dta", nogen keep(1 3)
merge m:m crop_code using "${Uganda_NPS_w8_created_data}/temp/val_kg_country_median", nogen keep(1 3)

/*
foreach i in region district_code county_code scounty_code parish_code ea hhid { 
	preserve
	use "${Uganda_NPS_w8_created_data}/temp/val_unit_`i'_median", clear
	merge m:1 unit_harvest crop_code using "${Uganda_NPS_w8_created_data}/temp/price_unit_`i'_median", nogen keep(1 3)
	merge m:1 `i' unit_harvest crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
	restore}
	//RH FLAG: issue is with this merge piece (invalid file specification) . I've tried running whole section multiple tmes; so issue isn't that the file is specified in a diff section. Could be the `i' in the merge for loop? 
	//Maybe need to just save dtas and give up on the temp files so this section can at least be drafted
*/	


*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
foreach i in country region district_code county_code scounty_code parish_code ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_hhid if price_unit_hhid != .

foreach i in country region district_code county_code scounty_code parish_code ea { //JHG 1_28_22: is this filling in empty variables with other geographic levels?
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_hhid if val_unit_hhid != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_hhid if val_kg_hhid != . //Preferring household values where available.
*/	

//All that for these two lines that generate actual harvest values:

//FLAG 7.29.22 - stopped here, have to reshape val sold

ren cf_*h* conv_fact_sold**
ren *q06d_* conv_fact_harv**
ren *q06b_* unit**

*ren *q06a_* qty_harvest**
*ren *q06c_* condition**
*ren *q06d_* conv_fact**

//vars needed from here: conv_fact_sold (uses different variables than previous section, cf_**h* instead of s5aq06d_**, val_sold, val_harv, qty_harvest, unit_sold, unit_harvest (is this the same as val_unit?), hhid, crop_code, [unit?], [to create: quant_harv_kg] ha_planted percent_field (max) months_grown, by(region district_code county_code scounty_code parish_code [need to merge in: ea?] hhid parcel_id plot_id season crop_code_master purestand field_size [region etc not in yet, need to merge in]

keep conv_fact_sold* conv_fact_harv* val_sold* val_harv qty_harvest /*qty_harvest*?*/ unit_sold* unit_harvest* unit* crop_code ha_planted percent_field months_grown hhid parcel_id plot_id season crop_code_master purestand field_size

//not uniquely identifying 
*report duplicates //113 dups
sort hhid parcel_id plot_id crop_code_master season
quietly by hhid parcel_id plot_id crop_code_master season: gen dup = cond(_N==1,0,_n)
tab dup
drop if dup >0 // drop 17,337 obs (going to have to go back and figure out why there are so many dups in the first place)

reshape long conv_fact_sold conv_fact_harv val_sold unit_sold unit_harvest, i(hhid parcel_id plot_id crop_code_master season /*flag val_harv qty_harvest*/ crop_code /*ha_planted percent_field months_grown purestand field_size*/) j(cond_no) string //J var gets dropped because it doesn't contain any necessary info.

*reshape long qty_harvest condition unit conv_fact, i(hhid cropID season parcelID pltid) j(cond_no) string //J var gets dropped because it doesn't contain any necessary info.
replace conv_fact_sold = 1 if unit_sold==1
drop if qty_harvest ==. 
drop cond_no

// 1) multiply val sold by conv fact to find val_kg. need to figure out which conv fact to use for val_sold:  

gen qty_harvest_kg = .
replace qty_harvest_kg = qty_harvest * conv_fact_harv if qty_harvest !=.

/*
gen val_sold = .

foreach var in val_sold_18fh1 val_sold_18fh2 val_sold_18ph1 val_sold_18ph2 val_sold_19fh1 {
	replace val_sold = `var' if (val_sold ==.)
}

gen conv_fact =.
foreach v in cf_18fh1 cf_18fh2 cf_18ph1 cf_18ph2 cf_19fh1 cf_19fh2 {
	replace conv_fact = `v' if (conv_fact ==.)
}
*/

	replace val_harv = val_sold * qty_harvest if val_harv == .
	*replace val_harv = val_kg * quant_harv_kg if val_harv == . //don't have val_kg 
//XXX real changes total. But note we can also subsitute local values for households with weird prices, which might work better than winsorizing.
	//Replacing conversions for unknown units
	gen val_unit = unit_harvest // FLAG: is this the right referent??
	replace val_unit = val_harv / qty_harvest if val_unit == .
preserve
	ren unit_sold unit
	collapse (mean) val_unit, by (hhid crop_code unit) 
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_prices_for_wages.dta", replace
restore
		
		
	//JHG 1_28_22: I don't need this section because I don't have expected harvest
		/*//still-to-harvest value
	gen same_unit = unit_code == sa3iq6d2

	//ALT 05.12.21: I feel like we should include the expected harvest.
	drop unit_cd quantity_harvested *conv* cf_merge
	ren sa3iq6d2 unit_cd
	ren sa3iq6d1 quantity_harvested
	merge m:1 crop_code unit_cd zone using "${Nigeria_GHS_W3_created_data}/Nigeria_GHS_W3_ng3_cf.dta", nogen keep(1 3)
	gen quant_harv_kg2= quantity_harvested*conv_fact
	gen val_harv2 = 0
	recode quant_harv_kg2 quantity_harvested (.=0)
foreach i in country zone state lga ea {
	replace val_harv2=quantity_harvested*val_unit_`i' if same_unit==1 & obs_`i'_unit>9 & val_unit_`i'!=.
	replace val_harv2=quant_harv_kg2*val_kg_`i' if same_unit==0 & obs_`i'_kg >9 & val_kg_`i'!=.
}
	replace val_harv2=quantity_harvested*val_unit_hhid if same_unit==1 & val_unit_hhid!=.
	replace val_harv2=quant_harv_kg2*val_kg_hhid if same_unit==0 & val_kg_hhid != . 
//The few that don't have the same units are in somewhat suspicious units. (I'm pretty sure you can't measure bananas in liters)
	recode quant_harv* (.=0)
	replace quant_harv_kg = quant_harv_kg+quant_harv_kg2
	replace value_harvest = value_harvest+val_harv2
	//Only affects 966 obs 
	drop val_harv2 quant_harv_kg2 val_* obs*
		*/
		
*FLAG: Need to merge in region, district_code, county_code scounty_code parish_code, ea

merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta"

drop if hhid ==""
	
	
*AgQuery
	collapse (sum) qty_harvest_kg val_harv ha_planted percent_field (max) months_grown, by(region district_code county_code scounty_code parish_code ea hhid parcel_id plot_id season crop_code_master purestand field_size)
	bys hhid parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys hhid parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) // 31 unmatched
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_all_plots.dta", replace

//08.01.22 RH: FINALLY runs through, but definitely needs to be checked/ cleaned up
	
	
//04.18.22 RH Note: Section drafted, but outputs need to be checked
//Need to clean up any sections in the main 'All Plots' module that are now covered by the crop valuation module, fill in finish section (permanent, multiseason crops)
*/
*************************************************************************
*GROSS CROP REVENUE - rh complete, but values/ conversion factors should be checked - LM must be a better way for this. Do we still need this?
*************************************************************************
//Purpose: Generate value of crops sold and amount (in kg) of crops sold. Complicated by the need for conversions of nonstandard units into kgs.
//ref: uga w7 - PA
//Delete this section too?
/*
*Temporary crops (both seasons)

use "${Uganda_NPS_w8_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season ==.
recast str32 hhid
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code

//section below from all plots code, reshaping bc of condition weirdness
**# Bookmark #1
//ALT: There's an easier way to do this with reshape to reduce the amount of work you need to do - note that the numerical suffixes in this case are irrelevant because there is a condition column for each crop.
ren *q06a_* harvest_amount** //qty harvested
ren *q07a_* amount_sold** //qty sold
ren *q07b_* condition**
ren *q07c_* unit**
ren *q08_* value_sold**
ren *q06d_* conv_fact**
keep hhid parcel_id plot_id crop_code harvest_amount* amount_sold* condition* unit* value_sold* conv_fact* season
reshape long harvest_amount amount_sold condition unit value_sold conv_fact, i(hhid crop_code parcel_id plot_id season) j(cond_no) string //J var gets dropped because it doesn't contain any necessary info.
drop cond_no
replace conv_fact = 1 if unit == 1 //Sometimes the kg conversion was omitted.

/* from allplots, redundant with code below
collapse (sum) qty* val, by(hhid parcelID pltid cropID season unit condition conv_fact)
gen qty_kg_sold = qty_sold*conv_fact 
*gen qty_kg_harvest = qty_harvest * conv_fact
gen price_unit = val/qty_sold 
gen price_kg = val/qty_kg_sold
ren cropID crop_code 
drop if qty_sold == . | qty_sold == 0 | val==. | val==0
gen obs=1
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen /*keepusing(weight)*/ keep(1 3)
*/


//below: new code from w7
* harvest (2nd season in 2017 & 1st season in 2018)

//ah yes - conversion factors are messy bc they're by condition. May want to recycle all plots reshape to get the conversion factors

/*Variables needed for reshape:
hhid, crop_code, plot_id, condition, season
s5aq06d_1 conversion harvest (and conversion sold)
s5aq06a_* harvest amount --> harvest quantity?
**Does the conversion factor actually change it to kgs? -- CHECK

s5aq08* value sold
s5bq08* (value sold season 2)
s5*q08* qty sold

*/

*ren a5aq6d conversion_harvest
*replace conversion_harvest = a5bq6d if conversion_harvest == . 
*ren s5aq06a_1 harvest_amount 
*replace harvest_amount = s5bq06a_1 if harvest_amount == . 
gen kgs_harvest = harvest_amount * conv_fact 

collapse (sum) kgs_harvest, by (hhid crop_code plot_id)
replace kgs_harvest = . if kgs_harvest == 0
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_harvest.dta", replace 

* value sold

use "${Uganda_NPS_w8_raw_data}/Agric/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/AGSEC5B.dta"
replace season = 2 if season ==.
*use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_vals_hhids.dta", clear
recast str32 hhid
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code

ren *q06a_* harvest_amount** //qty harvested
ren *q07a_* amount_sold** //qty sold
ren *q07b_* condition**
ren *q07c_* unit**
ren *q08_* value_sold**
ren *q06d_* conv_fact**
keep hhid parcel_id plot_id crop_code harvest_amount* amount_sold* condition* unit* value_sold* conv_fact* season
reshape long harvest_amount amount_sold condition unit value_sold conv_fact, i(hhid crop_code parcel_id plot_id season) j(cond_no) string //J var gets dropped because it doesn't contain any necessary info.
drop cond_no
replace conv_fact = 1 if unit == 1 //Sometimes the kg conversion was omitted.

gen kgs_sold = amount_sold * conv_fact
collapse(sum) value_sold kgs_sold, by (hhid crop_code) 
replace value_sold = . if value_sold == 0
replace kgs_sold = . if kgs_sold == 0

lab var kgs_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / kgs_sold
lab var price_kg "Price per kg sold"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_sales.dta", replace
 
/*Old code
ren s5aq05_2 harvest_yesno //question "is crop still immature?"(unready to be sold) or not, most crops are not  1 = yes, 2 = no
replace harvest_yesno = s5bq05_2 if harvest_yesno==. //combine first season crops with second season crops

ren cf conversion_harvest
gen kgs_harvest = qty_harvest * conversion_harvest

*w8 has no value harvested, will use value sold instead
*no conversion factor for kgs sold in w8, merging in median harvest conversion factor (but this may not really work since conditions at harvest are not the same as conditions sold)


gen condition = cond_harvest

merge m:m crop_code unit_harvest condition harv_cond using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_conv_fact.dta"

*First creating conversion factor for sold that is same as conversion factor median IF the units and conditions are the same at harvest and when sold:

*Testing to see if unit harvested is different from unit sold
*assert unit_harvest == unit_sold // 1451 contradictions in 8092 observations
*assert condition /*harvest*/ == cond_sold // 1913 contradictions

gen conv_sold = conv_fact_median if unit_harvest == unit_sold & condition == cond_sold
//4568 missing values generated/ 8,092

*RH FLAG: What should we do for remaining 4568 obs? 
*what if we looked at kg amount harvested/ original amt harvested = proxy conversion ratio, then multiplied the amt sold by that? Does that work?
*Leaving missing for now, come back to this question

gen kgs_sold = qty_sold * conv_sold


replace kgs_harvest = 0 if harvest_yesno==2
replace value_harvest = 0 if harvest_yesno==2

collapse(sum) val_sold kgs_sold kgs_harvest, by (hhid crop_code harvest_yesno)
replace val_sold = . if val_sold == 0
replace kgs_sold = . if kgs_sold == 0
replace kgs_harvest = . if kgs_harvest == 0


gen soldmorethanharvest = 1 if kgs_sold > kgs_harvest
//1931 observations where the kgs sold was more than the kgs harvested. However, mean kgs_harvest (1390) > mean kgs_sold (808) 
replace soldmorethanharvest = 0 if kgs_sold <= kgs_harvest & kgs_sold !=. & kgs_harvest != .
//2416 obs with a kgs_harvest and kgs_sold value where harvest is greater than or equal to the quantity sold 

collapse (sum) kgs_harvest value_harvest, by (HHID crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
lab var value_harvest "Value harvested of this crop, summed over main and short season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_harvest.dta", replace

use "${Uganda_NPS_w8_raw_data}/ag_sec_5a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_5b.dta"
drop if zaocode==.
ren zaocode crop_code
ren zaoname crop_name
ren ag5a_01 sell_yesno
replace sell_yesno = ag5b_01 if sell_yesno==.
ren ag5a_02 quantity_sold
replace quantity_sold = ag5b_02 if quantity_sold==.
ren ag5a_03 value_sold
replace value_sold = ag5b_03 if value_sold==.
keep if sell_yesno==1
replace crop_code = 31 if HHID=="5985-001" & crop_code==32 /* This is a typo, crops didn't match across production and sales files */
collapse (sum) quantity_sold value_sold, by (HHID crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_sales.dta", replace

*Permanent and tree crops

gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order
	//cassava, tea, vanilla are perm crops - but does it matter it's not a tree?
	replace perm_tree = 0 if perm_tree == .
	lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?

use "${Uganda_NPS_w8_raw_data}/ag_sec_6a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_6b.dta"
drop if plotnum==""
ren zaocode crop_code
ren zaoname crop_name
ren ag6a_09 kgs_harvest
ren plotnum plot_id
replace kgs_harvest = ag6b_09 if kgs_harvest==.
replace kgs_harvest = 115 if HHID=="1230-001" & crop_code==71 /* Typo */
collapse (sum) kgs_harvest, by (HHID crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_permcrop_harvest.dta", replace

use "${Uganda_NPS_w8_raw_data}/ag_sec_7a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_7b.dta"
drop if zaocode==.
ren zaocode crop_code
ren zaoname crop_name
ren ag7a_02 sell_yesno
replace sell_yesno = ag7b_02 if sell_yesno==.
ren ag7a_03 quantity_sold
replace quantity_sold = ag7b_03 if quantity_sold==.
ren ag7a_04 value_sold
replace value_sold = ag7b_04 if value_sold==.
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (HHID crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_permcrop_sales.dta", replace

*Prices of permanent and tree crops need to be imputed from sales.
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_permcrop_sales.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_sales.dta"
recode price_kg (0=.)
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta"
drop if _merge==2
drop _merge
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", replace

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", clear
gen observation = 1
bys region district ward ea crop_code: egen obs_ea = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward ea crop_code obs_ea)
ren price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_ea.dta", replace
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", clear
gen observation = 1
bys region district ward crop_code: egen obs_ward = count(observation)
collapse (median) price_kg [aw=weight], by (region district ward crop_code obs_ward)
ren price_kg price_kg_median_ward
lab var price_kg_median_ward "Median price per kg for this crop in the ward"
lab var obs_ward "Number of sales observations for this crop in the ward"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_ward.dta", replace
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", clear
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
ren price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_district.dta", replace
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
ren price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_region.dta", replace
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
ren price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_harvest.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_permcrop_harvest.dta"
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
merge m:1 HHID crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", nogen
merge m:1 region district ward ea crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_ea.dta", nogen
merge m:1 region district ward crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_ward.dta", nogen
merge m:1 region district crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_country.dta", nogen
gen price_kg_hh = price_kg
lab var price_kg_hh "Price per kg, with missing values imputed using local median values"
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
lab var value_harvest_imputed "Imputed value of crop production"
replace value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. /* Use observed hh price if it exists */
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_values_tempfile.dta", replace 

preserve
	recode  value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
	collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (HHID crop_code)
	ren value_harvest_imputed value_crop_production
	lab var value_crop_production "Gross value of crop production, summed over main and short season"
	ren value_sold value_crop_sales
	lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
	lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
	ren quantity_sold kgs_sold
	lab var kgs_sold "Kgs sold of this crop, summed over main and short season"
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_values_production.dta", replace
restore
*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested,  

collapse (sum) value_harvest_imputed value_sold, by (HHID)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_production.dta", replace
 
*Plot value of crop production
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (HHID plot_id)
ren value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cropvalue.dta", replace

*Crop residues (captured only in Tanzania) 
use "${Uganda_NPS_w8_raw_data}/ag_sec_5a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_5b.dta"
gen residue_sold_yesno = (ag5a_33==7) /* Just 3 observations of sales of crop residue */
ren ag5a_35 value_cropresidue_sales
recode value_cropresidue_sales (.=0)
collapse (sum) value_cropresidue_sales, by (HHID)
lab var value_cropresidue_sales "Value of sales of crop residue (considered an agricultural byproduct)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_residues.dta", replace


*Crop values for inputs in agricultural product processing (self-employment)
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_tempcrop_harvest.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_permcrop_harvest.dta"
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
merge m:1 HHID crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_sales.dta", nogen
merge m:1 region district ward ea crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_ea.dta", nogen
merge m:1 region district ward crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_ward.dta", nogen
merge m:1 region district crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_region.dta", nogen
merge m:1 crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_prices_country.dta", nogen
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=998 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_ward if price_kg==. & obs_ward >= 10 & crop_code!=998
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=998
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=998
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=998 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = value_harvest
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = value_harvest if value_harvest_imputed==. & crop_code==998 /* "Other" */
replace value_harvest_imputed = 0 if value_harvest_imputed==.
keep HHID crop_code price_kg 
duplicates drop
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_prices.dta", replace

*Crops lost post-harvest
use "${Uganda_NPS_w8_raw_data}/ag_sec_7a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_7b.dta"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_5a.dta"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_5b.dta" 
drop if zaocode==.
ren zaocode crop_code
ren ag7a_16 value_lost
replace value_lost = ag7b_16 if value_lost==.
replace value_lost = ag5a_32 if value_lost==.
replace value_lost = ag5b_32 if value_lost==.
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID crop_code)
merge 1:1 HHID crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_values_production.dta"
drop if _merge==2
replace value_lost = value_crop_production if value_lost > value_crop_production
collapse (sum) value_lost, by (HHID)
ren value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_losses.dta", replace
*/
*/
********************************************************************************
** 								GROSS CROP REVENUE							  ** LM 10/12/2023
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec5a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec5b.dta"
replace season = 2 if season ==.
recast str32 hhid
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code 
recode crop_code (741 742 744 = 740)
drop if plot_id == .
gen full_harvest = 0
replace full_harvest = 1 if harvest == 1 & harvest_b == 1
gen part_harvest = 0
replace part_harvest = 1 if harvest == 2 & harvest1 == 1 & harvest_b == 2
//Isolating the variables
/* CATEGORIES
1 = 2018, full harvest, condition 1
2 = 2018, full harvest, condition 2
3 = 2018, part harvest, condition 1
4 = 2018, part harvest, condition 2
5 = 2019, condition 1
6 = 2019, condition 2
*/
gen condition_harv1 = s5aq06c_1
gen condition_sold1 = s5aq07b_1
gen condition_harv2 = s5aq06c_2
gen condition_sold2 = s5aq07b_2
gen condition_harv3 = s5aq06c_11
gen condition_sold3 = s5aq07b_11
gen condition_harv4 = s5aq06c_21
gen condition_sold4 = s5aq07b_21
gen condition_harv5 = s5bq06c_1
gen condition_sold5 = s5bq07b_1
gen condition_harv6 = s5bq06c_2
gen condition_sold6 = s5bq07b_2
gen quantity_harv1 = s5aq06a_1
gen sold_qty1 = s5aq07a_1
gen quantity_harv2 = s5aq06a_2
gen sold_qty2 = s5aq07a_2
gen quantity_harv3 = s5aq06a_11
gen sold_qty3 = s5aq07a_11
gen quantity_harv4 = s5aq06a_21
gen sold_qty4 = s5aq07a_21
gen quantity_harv5 = s5bq06a_1
gen sold_qty5 = s5bq07a_1
gen quantity_harv6 = s5bq06a_2
gen sold_qty6 = s5bq07a_2
gen unit_code_harv1 = s5aq06b_1
gen sold_unit_code1 = s5aq07c_1
gen unit_code_harv2 = s5aq06b_2
gen sold_unit_code2 = s5aq07c_2
gen unit_code_harv3 = s5aq06b_11
gen sold_unit_code3 = s5aq07c_11
gen unit_code_harv4 = s5aq06b_21
gen sold_unit_code4 = s5aq07c_21
gen unit_code_harv5 = s5bq06b_1
gen sold_unit_code5 = s5bq07c_1
gen unit_code_harv6 = s5bq06b_2
gen sold_unit_code6 = s5bq07c_2
gen conv_factor_sold1 = s5aq06d_1
gen conv_factor_sold2 = s5aq06d_2
gen conv_factor_sold3 = s5aq06d_11
gen conv_factor_sold4 = s5aq06d_21
gen conv_factor_sold5 = s5bq06d_1
gen conv_factor_sold6 = s5bq06d_2
gen conv_factor_harv1 = s5aq06d_1
gen conv_factor_harv2 = s5aq06d_2
gen conv_factor_harv3 = s5aq06d_11
gen conv_factor_harv4 = s5aq06d_21
gen conv_factor_harv5 = s5bq06d_1
gen conv_factor_harv6 = s5bq06d_2
gen sold_value1 = s5aq08_1
gen sold_value2 = s5aq08_2
gen sold_value3 = s5aq08_11
gen sold_value4 = s5aq08_21
gen sold_value5 = s5bq08_1
gen sold_value6 = s5bq08_2
gen month_harv_date1 = s5aq06e_1
gen month_harv_date2 = s5aq06e_2
gen month_harv_date3 = s5aq06e_11
gen month_harv_date4 = s5aq06e_21
gen month_harv_date5 = s5bq06e_1
gen month_harv_date6 = s5bq06e_2
gen year_harv_date1 = s5aq06e_1_1
gen year_harv_date2 = s5aq06e_1_2
gen year_harv_date3 = s5aq06e_1_11
gen year_harv_date4 = s5aq06e_1_21
gen year_harv_date5 = s5bq06e_1_1
gen year_harv_date6 = s5bq06e_1_2
gen month_harv_end1 = s5aq06f_1
gen month_harv_end2 = s5aq06f_2
gen month_harv_end3 = s5aq06f_11
gen month_harv_end4 = s5aq06f_21
gen month_harv_end5 = s5bq06f_1
gen month_harv_end6 = s5bq06f_2
gen year_harv_end1 = s5aq06f_1_1
gen year_harv_end2 = s5aq06f_1_2
gen year_harv_end3 = s5aq06f_1_11
gen year_harv_end4 = s5aq06f_1_21
gen year_harv_end5 = s5bq06f_1_1
gen year_harv_end6 = s5bq06f_1_2
gen loss1 = s5aq17_1
gen loss2 = s5aq17_2
gen loss3 = s5aq17_11
gen loss4 = s5aq17_21
gen loss5 = s5bq17_1
gen loss6 = s5bq17_2
gen dummy = _n

reshape long condition_harv condition_sold quantity_harv sold_qty unit_code_harv sold_unit_code conv_factor_sold conv_factor_harv sold_value month_harv_date year_harv_date month_harv_end year_harv_end loss, i(hhid parcel_id plot_id crop_code season dummy) j(category)

recode sold_value (.=0)

merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keepusing(region district_name county subcounty_name parish_name)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code using "${Uganda_NPS_w8_created_data}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = sold_qty*s_conv_factor_sold
recode crop_code  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
collapse (sum) sold_value kgs_sold, by (hhid crop_code)
lab var sold_value "Value of sales of this crop"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_cropsales_value.dta", replace

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_all_plots.dta", clear
ren crop_code_master crop_code
collapse (sum) value_harvest quant_harv_kg  , by (hhid crop_code) // Update: We start using the standarized version of value harvested and kg harvested
merge 1:1 hhid crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_cropsales_value.dta"
replace value_harvest = sold_value if sold_value>value_harvest & sold_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sold_value value_crop_sales
recode value_harvest value_crop_sales (.=0)
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_values_production.dta", replace
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Uganda_NPS_w8_raw_data}/Agric/agsec5a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec5b.dta"
replace season = 2 if season ==.
recast str32 hhid
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code 
recode crop_code (741 742 744 = 740)
drop if crop_code==.
//Isolating the variables
/* CATEGORIES
1 = 2018, full harvest, condition 1
2 = 2018, full harvest, condition 2
3 = 2018, part harvest, condition 1
4 = 2018, part harvest, condition 2
5 = 2019, condition 1
6 = 2019, condition 2
*/
gen percent_lost1 = s5aq16_1
gen percent_lost2 = s5aq16_2
gen percent_lost3 = s5aq16_11
gen percent_lost4 = s5aq16_21
gen percent_lost5 = s5bq16_1
gen percent_lost6 = s5bq16_2
gen dummy = _n

reshape long percent_lost, i(hhid parcel_id plot_id crop_code season dummy) j(category)

merge m:1 hhid crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by(hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_losses.dta", replace

********************************************************************************
*CROP EXPENSES - LM 7/28/23
******************************************************************************** 
*Expenses: Hired labor
use "${Uganda_NPS_w8_raw_data}/Agric/agsec3a.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec3b.dta"
replace season = 2 if season == .
recast str32 hhid 
ren pltid plot_id
ren parcelID parcel_id
ren s3aq35a dayshiredmale
replace dayshiredmale = s3bq35a if dayshiredmale == .
replace dayshiredmale = . if dayshiredmale == 0

ren s3aq35b dayshiredfemale
replace dayshiredfemale = s3bq35b if dayshiredfemale == .
replace dayshiredfemale	 = . if dayshiredfemale == 0

ren s3aq35c dayshiredchild
replace dayshiredchild = s3bq35c if dayshiredchild == .
replace dayshiredchild = . if dayshiredchild == 0

ren s3aq36 wagehired
replace wagehired = s3bq36 if wagehired == .
gen wagehiredmale = wagehired if dayshiredmale != .
gen wagehiredfemale = wagehired if dayshiredfemale != .
gen wagehiredchild = wagehired if dayshiredchild != .

recode dayshired* (.=0)
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild

replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal
replace wagehiredchild = wagehiredchild/dayshiredtotal

keep hhid parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

reshape long dayshired wagehired, i(hhid parcel_id plot_id season) j(gender) string
reshape long days wage, i(hhid parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0

gen val = wage*days
tostring hhid, format(%18.0f) replace

merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district_name county subcounty_name parish_name hhid {
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
use "${Uganda_NPS_w8_raw_data}/Agric/AGSEC3A_1.dta", clear
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/AGSEC3B_1.dta"
replace season = 2 if season == .
recast str32 hhid 
ren pltid plot_id
ren parcelID parcel_id
ren fam_labour__id pid
replace pid = fam_labour_3b__id if pid == .
ren s3aq33_1 days
replace days = s3bq33_1 if days == .
ren s3aq33 fam_worker_count
replace fam_worker_count = s3bq33 if fam_worker_count == .
keep hhid parcel_id plot_id season pid days fam_worker_count

preserve
use "${Uganda_NPS_w8_raw_data}/HH/gsec2.dta", clear
gen male = h2q3 == 1
gen age = h2q8
recast str32 hhid
tostring pid, format(%19.0f) replace
keep hhid pid age male
isid hhid pid
tempfile members
save `members', replace
restore

duplicates drop hhid parcel_id plot_id season, force
drop if days == .
tostring hhid, format(%18.0f) replace
tostring pid, format(%18.0f) replace
merge m:1 hhid pid using `members', nogen keep(1 3) 
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & male == 1
replace gender = "female" if strmatch(gender, "") & male == 0 
replace gender = "unknown" if strmatch(gender, "") & male == .
gen labor_type = "family"
drop if gender == "unknown"
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
keep region district_name county subcounty_name parish_name hhid parcel_id plot_id season gender days labor_type fam_worker_count pid


foreach i in region district_name county subcounty_name parish_name hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3)
	}	
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) 

	gen wage = wage_hhid
	*recode wage (.=0)
foreach i in country region district_name county subcounty_name parish {
	replace wage = wage_`i' if obs_`i' > 9
	} //Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in gaps of implicit labor value.

egen wage_sd = sd(wage_hhid), by(gender season)
egen mean_wage = mean(wage_hhid), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
*/
replace wage = wage_hhid if wage_hhid != . & abs(wage_hhid - mean_wage) / wage_sd < 3 //Using household wage when available, but omitting implausibly high or low values. Changed about 6,700 hh obs, max goes from 500,000->500,000; mean 45,000 -> 41,000; min 10,000 -> 2,000
//JHG 5_18_22: double-check with Andrew about the code above because the max did not change. Also I ran the Nigeria code and this text (the version there) didn't match what happened for wage or wage_hhid
* SAW Because he got total days of work for family labor but not for each individual on the hhhd we need to divide total days by number of  subgroups of gender that were included as workers in the farm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective ofgender)
by hhid parcel_id plot_id season, sort: egen numworkers = count(_n)
replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days
append using `all_hired'
keep region district_name county subcounty_name parish_name hhid parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(hhid parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (hhid parcel_id plot_id labor_type)
reshape wide labor_, i(hhid parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_labor_days.dta", replace
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(hhid parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_labor.dta", replace
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_labor.dta", replace



******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES ** 9/2/23 LM (need to run the whole section to work)
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.
**********************    PESTICIDES/HERBICIDES   ******************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec3a", clear 
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec3b"
replace season = 2 if season == .
recast str32 hhid 
ren pltid plot_id
ren parcelID parcel_id
ren s3aq24a unitpest //unit code for total pesticides used, first planting season (kg = 1, litres = 2)
ren s3aq24b qtypest //quantity of unit for total pesticides used, first planting season
replace unitpest = s3bq24a if unitpest == . //add second planting season
replace qtypest = s3bq24b if qtypest == . //add second planting season
ren s3aq26 qtypestexp //amount of total pesticide that is purchased
replace qtypestexp = s3bq26 if qtypestexp == . //add second planting season
gen qtypestimp = qtypest - qtypestexp //this calculates the non-purchased amount of pesticides used	
ren s3aq27 valpestexp
replace valpestexp = s3bq27 if valpestexp == .	
gen valpestimp= .
rename unitpest unitpestexp
gen unitpestimp = unitpestexp
drop qtypest

//Notes: barely any information collected on livestock inputs to crop agriculture. There are binary variables as to whether a house used their own livestock on their fields, but no collection of data about renting animal labor for a household. Some information (Section 11 in ag survey, question 5) about income from renting out their own animals is asked, but this is not pertinent to crop expenses. Animal labor can be a big expense, so we are creating explicit and implicit cost variables below but filling them with empty values.
gen qtyanmlexp = .
gen qtyanmlimp = .
gen unitanmlexp = .
gen unitanmlimp = .
gen valanmlexp = .
gen valanmlimp = .

*************************    MACHINERY INPUTS   ********************************
preserve //This section creates raw data on value of machinery/tools
use "${Uganda_NPS_w8_raw_data}/Agric/agsec10", clear 
ren s10q01a qtymechimp //number of owned machinery/tools
ren s10q02a valmechimp //total value of owned machinery/tools, not per-item
ren s10q07aa qtymechexp //number of rented machinery/tools
ren s10q08a valmechexp //total value of rented machinery/tools, not per-item
collapse (sum) valmechimp valmechexp, by(hhid) //combine values for all tools, don't combine quantities since there are many varying types of tools 
isid hhid //check for duplicate hhids, which there shouldn't be after the collapse
recast str32 hhid
tempfile rawmechexpense
save `rawmechexpense', replace
restore

preserve
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", clear
collapse (sum) ha_planted, by(hhid)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore

preserve
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", clear
merge m:1 hhid using `ha_planted_total', nogen
gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted / SAW ha_planted_total its total area planted for both seasons per HHID 
tempfile planted_percent
save `planted_percent'
restore

merge m:1 hhid parcel_id plot_id season using `planted_percent', nogen
merge m:1 hhid using `rawmechexpense', nogen
replace valmechexp = valmechexp * planted_percent //replace total with plot and season specific value of rented machinery/tools

//Now to reshape long and get all the medians at once.
keep hhid parcel_id plot_id season qty* val* unit*
unab vars : *exp //create a local macro called vars out of every variable that ends with exp
local stubs : subinstr local vars "exp" "", all //create another local called stubs with exp at the end, with "exp" removed. This is for the reshape below
duplicates drop hhid parcel_id plot_id season, force // we need to drop duplicates so reshape can run
reshape long `stubs', i(hhid parcel_id plot_id season) j(exp) string
reshape long val qty unit, i(hhid parcel_id plot_id season exp) j(input) string
gen itemcode=1
tempfile plot_inputs
tostring hhid, format(%18.0f) replace
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
save `plot_inputs'

******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec3a", clear 
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec3b"
replace season = 2 if season == .
recast str32 hhid 
ren pltid plot_id
ren parcelID parcel_id

************************    INORGANIC FERTILIZER   ****************************** 
ren s3aq14 itemcodefert //what type of inorganic fertilizer (1 = nitrate, 2 = phosphate, 3 = potash, 4 = mixed); this can be used for purchased and non-purchased amounts
replace itemcodefert = s3bq14 if itemcodefert == . //add second season
//There is a unit called "lts" from s3aq14a
ren s3aq15 qtyferttotal1 //quantity of inorganic fertilizer used
replace qtyferttotal1 = s3bq15 if qtyferttotal1 == . //add second season
ren s3aq17 qtyfertexp1 //quantity of purchased inorganic fertilizer used
replace qtyfertexp1 = s3bq17 if qtyfertexp1 == . //add second season
ren s3aq18 valfertexp1 //value of purchased inorganic fertilizer used, not all fertilizer
replace valfertexp1 = s3bq18 if valfertexp1 == . //add second season
gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1

*************************    ORGANIC FERTILIZER   *******************************
ren s3aq05 qtyferttotal2 //quantity of organic fertilizer used
//also in this section, there's another unit besides kgs (lts)
replace qtyferttotal2 = s3bq05 if qtyferttotal2 == . //add second season
ren s3aq07 qtyfertexp2 //quantity of purchased organic fertilizer used; only measured in kg
replace qtyfertexp2 = s3bq07 if qtyfertexp2 == . //add second season
replace itemcodefert = 5 if qtyferttotal2 != . //Current codes are 1-4; we'll add 5 as a temporary label for organic
label define fertcode 1 "Nitrate" 2 "Phosphate" 3 "Potash" 4 "Mixed" 5 "Organic" , modify //need to add new codes to the value label, fertcode
label values itemcodefert fertcode //apply organic label to itemcodefert
ren s3aq08 valfertexp2 //value of purchased organic fertilizer, not all fertilizer
replace valfertexp2 = s3bq08 if valfertexp2 == . //add second season 
gen qtyfertimp2 = qtyferttotal2 - qtyfertexp2
recast str32 hhid

//Clean-up data
keep item* qty* val* hhid parcel_id plot_id season
drop if itemcodefert == .
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates
drop dummya
duplicates drop hhid parcel_id plot_id season, force // we need to  drop duplicates so reshape can run
unab vars : *2 
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(hhid parcel_id plot_id season) j(entry_no) string
drop entry_no
drop if (qtyferttotal == . & qtyfertexp == .)
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
gen dummyc = sum(dummyb) //This process of creating dummies and summing them was done to create individual IDs for each row 
drop dummyb
reshape long `stubs2', i(hhid parcel_id plot_id season dummyc) j(exp) string
gen dummyd = sum(dummyc)
drop dummyc
reshape long qty val itemcode, i(hhid parcel_id plot_id season exp dummyd) j(input) string
recode qty val (. = 0)
collapse (sum) qty* val*, by(hhid parcel_id plot_id season exp input itemcode)
tempfile phys_inputs
save `phys_inputs'

***************************    LAND RENTALS   **********************************

//Get parcel rent data
use "${Uganda_NPS_w8_raw_data}/Agric/agsec2b", clear 
ren parcelID parcel_id
ren a2bq09 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
recast str32 hhid
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace
merge m:1 hhid parcel_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_rental.dta", nogen keep (3)
gen qtyparcelrentexp = parcel_ha if valparcelrentexp > 0 & valparcelrentexp != .
gen qtyparcelrentimp = parcel_ha if qtyparcelrentexp == . //this land does not have an agreement with owner, but is rented

//Estimate rented plot value, using percentage of parcel 
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

******************************
*SEEDS   
**************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec4a", clear 
gen season = 1
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec4b"
replace season = 2 if season == .
recast str32 hhid 
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code
ren s4aq08 purestand
replace purestand = s4bq08 if purestand==.
ren s4aq11a qtyseeds
replace qtyseeds = s4bq11a if qtyseeds==.
ren s4aq11b unitseeds
replace unitseeds = s4bq11b if unitseeds==.
ren s4aq15 valseeds
replace valseeds = s4bq15 if valseeds==.

keep unit* qty* val* purestand hhid parcel_id plot_id crop_code season
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates, similar process as above for fertilizers
drop dummya
reshape long qty unit val, i(hhid parcel_id plot_id season dummyb) j(input) string
collapse (sum) val qty, by(hhid parcel_id plot_id season unit input crop_code purestand)
ren unit unit_code
drop if qty == 0
*drop input //there is only purchased value, none of it is implicit (free, left over, etc.)

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
collapse (sum) val qty, by(hhid parcel_id plot_id season input itemcode unit) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for. JHG 7_5_22: all this code does is drop variables, it doesn't actually collapse anything
gen exp = "exp"
tostring hhid, format(%18.0f) replace

//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
drop region district_name county county_code subcounty_name subcounty_code parish_name parish_code weight rural 
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep (1 3) //merge in regional data
tempfile all_plot_inputs
save `all_plot_inputs' //Woo, now we can estimate values

//Calculating geographic medians
keep if strmatch(exp,"exp") & qty != . //Keep only explicit prices with actual values for quantity
recode val (0 = .)
drop if unit == 0 //Remove things with unknown units.
gen price = val/qty
drop if price == . //6,246 observations now remaining
gen obs = 1
gen plotweight = weight*field_size

foreach i in region district_name county subcounty_name parish_name hhid {
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
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep (1 3) //merge in regional data
*drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district_name county subcounty_name parish_name hhid {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_hhid (. = 0)
	gen price = price_hhid
foreach i in region district_name county subcounty_name parish_name {
	replace price = price_`i' if obs_`i' > 9 & obs_`i' != .
}

replace price = price_hhid if price_hhid > 0
replace qty = 0 if qty < 0 //2 households reporting negative quantities
recode val qty (. = 0)
drop if val == 0 & qty == 0 //Dropping unnecessary observations.
replace val = qty*price if val == 0 //9942 estimates created
replace input = "orgfert" if itemcode == 5
replace input = "inorg" if strmatch(input,"fert")

preserve 
keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"pest") //would also have herbicide here if Uganda tracked herbicide separately of pesticides
collapse (sum) qty_ = qty, by(hhid parcel_id plot_id season input)
reshape wide qty_, i(hhid parcel_id plot_id season) j(input) string
ren qty_inorg inorg_fert_rate
ren qty_orgfert org_fert_rate
ren qty_pest pest_rate
la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
la var org_fert_rate "Qty organic fertilizer used (kg)"
la var pest_rate "Qty of pesticide used (kg)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_input_quantities.dta", replace
restore

append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_labor.dta"
collapse (sum) val, by (hhid parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cost_inputs_long.dta", replace

preserve
collapse (sum) val, by(hhid exp input) 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_long.dta", replace
restore

preserve
collapse (sum) val_ = val, by(hhid parcel_id plot_id season exp dm_gender)
reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cost_inputs.dta", replace //This gets used below.
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
collapse (sum) val*, by(hhid)

unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female /*`i'_exp_mixed*/)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female /*`i'_imp_mixed*/)
}
egen val_exp_hh = rowtotal(*_exp_hh)
egen val_imp_hh = rowtotal(*_imp_hh)
drop val_mech_imp* // JHG 7_5_22: need to revisit owned machinery values, I don't think that was ever dealt with.
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_verbose.dta", replace 

//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_all_plots.dta", replace 
collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cost_inputs_long.dta", clear
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
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
*tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid) //JHG 7_5_22: double-check this section to make sure there is now weirdness with summing up to household level when there are multiple seasons - was too tired when coding this to go back and check
//Renaming variables to plug into later steps
//check for mixed?
foreach i in male female /*mixed*/ {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs.dta", replace

********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************
*Purpose: Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots

//Setting things up for AgQuery first
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_all_plots.dta", replace
keep if purestand == 1
ren crop_code cropcode
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_monocrop_plots.dta", replace

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_all_plots.dta", replace
keep if purestand == 1
ren crop_code cropcode
ren ha_planted monocrop_ha 
ren quant_harv_kg kgs_harv_mono // We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
ren value_harvest val_harv_mono // We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
*This loop creates 17 values using the nb_topcrops global (as that is the number of priority crops), then generates two .dtas for each priority crop that contains household level variables (split by season). You can change which priority crops it uses by adjusting the priority crops global section near the top of this code
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_`cn'_monocrop.dta", replace
	
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_`cn'_monocrop_hh_area.dta", replace
restore
}

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cost_inputs_long.dta", clear
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
	replace dm_gender2 = "mixed" if dm_gender==3 | dm_gender==.
	drop dm_gender
	reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
	merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_inputs_`cn'.dta", replace
restore
}
*Notes: Final datasets are sum of all cost at the household level for specific crops. 

********************************************************************************
*TLU (Tropical Livestock Units) // LM - 11.29.23
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
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a.dta", clear // livestock - large ruminants
rename LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_livestock.dta", replace

*For small animals
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6b.dta", clear 
rename ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6c.dta", clear
rename APCode livestockid
gen tlu_coefficient = 0.01 if (livestockid == 23 | livestockid == 24 | livestockid == 25 | livestockid == 26 | livestockid == 27) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_poultry_misc.dta", replace

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_livestock.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_small_animals.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_poultry_misc.dta"
label define livestockid 1 "EXOTIC/CROSS - Calves" 2 "EXOTIC/CROSS - Bulls" 3 "EXOTIC/CROSS - Oxen" 4 "EXOTIC/CROSS - Heifers" 5 "EXOTIC/CROSS - Cows" 6 "INDIGENOUS - Calves" 7 "INDIGENOUS - Bulls" 8 "INDIGENOUS - Oxen" 9 "INDIGENOUS - Heifers" 10 "INDIGENOUS - Cows" 11 "INDIGENOUS - Donkeys/mules" 12 "INDIGENOUS - Horses" 13 "EXOTIC/CROSS - Male goats" 14 "EXOTIC/CROSS - Female goats" 15 "EXOTIC/CROSS - Male sheep" 16 "EXOTIC/CROSS - Female sheep" 17 "EXOTIC/CROSS - Pigs" 18 "INDIGENOUS - Male goats" 19 "INDIGENOUS - Female goats" 20 "INDIGENOUS - Male sheep" 21 "INDIGENOUS - Female sheep" 22 "INDIGENOUS - Pigs" 23 "Indigenous dual-purpose chicken" 24 "Layers (exotic/cross chicken)" 25 "Broilers (Exotic/cross chicken)" 26 "Other poultry and birds (turkeys / ducks / geese)" 27 "Rabbits" 
label val livestockid livestockid 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_all_animals.dta", replace

**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine hhid and livestock data into a single sheet
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a.dta", clear // livestock - large ruminants
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b.dta" // small ruminants
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c.dta" // poultry
gen livestockid = LiveStockID
merge m:m livestockid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
sort hhid livestockid //Put back in order

*Generate ownership dummy variables for livestock categories: cattle (& cows alone), small ruminants, poultry (& chickens alone), & other
gen cattle = inrange(livestockid, 1, 10) //calves, bulls, oxen, heifer, and cows
gen cows = inlist(livestockid, 5, 10) //just cows
gen smallrum = inlist(livestockid, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 27) //goats, sheep, pigs, and rabbits
gen poultry = inrange(livestockid, 23, 26) //chicken, turkey, ducks, and geese
gen chickens = inrange(livestockid, 23, 25) //just chicken (all kinds)
gen otherlivestock = inlist(livestockid, 11, 12) //donkeys/mules and horses

*Generate "number of animals" variable per livestock category and household (Time of Survey)
rename s6aq01 ls_ownership_now
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
rename s6bq01 sa_ownership_now
drop if sa_ownership == 2 //2 = see above
rename s6cq01 po_ownership_now
drop if po_ownership == 2 //2 = see above

rename s6aq03a ls_number_now
rename s6bq03a sa_number_now
rename s6cq03a po_number_now
gen livestock_number_now = ls_number_now
replace livestock_number_now = sa_number_now if livestock_number_now == .
replace livestock_number_now = po_number_now if livestock_number_now == .
lab var livestock_number_now "Number of animals owned at time of survey (see livestockid for type)"

gen num_cattle_now = livestock_number_now if cattle == 1
gen num_cows_now = livestock_number_now if cows == 1
gen num_smallrum_now = livestock_number_now if smallrum == 1
gen num_poultry_now = livestock_number_now if poultry == 1
gen num_chickens_now = livestock_number_now if chickens == 1
gen num_other_now = livestock_number_now if otherlivestock == 1
gen num_tlu_now = livestock_number_now * tlu_coefficient

*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
rename s6aq06 ls_number_past
rename s6bq06 sa_number_past
rename s6cq06 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)" 
*Though, s6Xq06 refers to different types of animals the time of ownership asked in each question is different (12 months for livestock, 6 months for small animals, and 3 motnhs for poultry)

gen num_cattle_past = livestock_number_past if cattle == 1
gen num_cows_past = livestock_number_past if cows == 1
gen num_smallrum_past = livestock_number_past if smallrum == 1
gen num_poultry_past = livestock_number_past if poultry == 1
gen num_chickens_past = livestock_number_past if chickens == 1
gen num_other_past = livestock_number_past if otherlivestock == 1
gen num_tlu_past = livestock_number_past * tlu_coefficient

//Step 3: Generate animal sales variables (sold alive)
rename s6aq14a num_ls_sold
rename s6aq14b ls_avgvalue
rename s6bq14a num_sa_sold
rename s6bq14b sa_avgvalue
rename s6cq14a num_po_sold
rename s6cq14b po_avgvalue

gen num_totalvalue = ls_avgvalue * num_ls_sold
replace num_totalvalue = sa_avgvalue * num_sa_sold if num_totalvalue == .
replace num_totalvalue = po_avgvalue * num_po_sold if num_totalvalue == .

lab var ls_avgvalue "Avg value of each sold animal (livestock)"
lab var sa_avgvalue "Avg value of each sold animal (small animals)"
lab var po_avgvalue "Avg value of each sold animal (poultry)"
lab var num_ls_sold "Number of animals sold alive (livestock)"
lab var num_sa_sold "Number of animals sold alive (small animals)"
lab var num_po_sold "Number of animals sold alive (poultry)"
lab var num_totalvalue "Total value of animals sold alive"

recode num_* (. = 0) //replace all null values for number variables with 0

//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) num*, by (hhid)
lab var num_ls_sold "Number of animals sold alive (livestock)"
lab var num_sa_sold "Number of animals sold alive (small animals)"
lab var num_po_sold "Number of animals sold alive (poultry)"
lab var num_totalvalue "Total value of animals sold alive"
lab var num_cattle_now "Number of cattle owned at time of survey"
lab var num_cows_now "Number of cows owned at time of survey"
lab var num_smallrum_now "Number of small ruminants owned at time of survey"
lab var num_poultry_now "Number of poultry owned at time of survey"
lab var num_chickens_now "Number of chickens owned at time of survey"
lab var num_other_now "Number of other livestock (donkeys/mules & horses) owned at time of survey"
lab var num_tlu_now "Number of Tropical Livestock Units at time of survey"
lab var num_cattle_past "Number of cattle owned 12 months before survey"
lab var num_cows_past "Number of cows owned 12 months before survey"
lab var num_smallrum_past "Number of small ruminants owned 12 months before survey"
lab var num_poultry_past "Number of poultry owned 12 months before survey"
lab var num_chickens_past "Number of chickens owned 12 months before survey"
lab var num_other_past "Number of other livestock (donkeys/mules & horses) owned 12 months before survey"
lab var num_tlu_past "Number of Tropical Livestock Units 12 months before survey"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_TLU_Coefficients.dta", replace

********************************************************************************
**                           LIVESTOCK INCOME       		         		  **
********************************************************************************

*****************************    EXPENSES        *******************************
  
*************************************************************************
*LIVESTOCK INCOME // LM 12.5.23, not checked
*************************************************************************
//BID Notes:
*Sections 6A, 6B, 6C: Livestock ownership
***dynamics of ownership, earnings from sales, expenditures on animal purchases
*Section 7: Livestock inputs
*Section 8: Livestock products 
//BID Notes:
*Sections 6A, 6B, 6C: Livestock ownership
***dynamics of ownership, earnings from sales, expenditures on animal purchases
*Section 7: Livestock inputs
*Section 8: Livestock products 

*Expenses
use "${Uganda_NPS_w8_raw_data}\Agric\agsec7.dta", clear
ren s7q02e cost_fodder_livestock // "How much has this household paid to feed the [livestock] in [reference period]"
ren s7q03f cost_water_livestock // "Amount paid to access the main water sources for [livestock] in [ref period]"
ren s7q05d cost_vaccines_livestock /* Includes vaccine and professional fees */
ren s7q06c cost_deworm_livestock /* Includes cost of deworming and professional fees*/
ren s7q07c cost_ticks_livestock /*What was the total cost of the treatment of [...] against ticks, including cost of drugs and professional fee?*/
ren s7q08c cost_hired_labor_livestock // total cost of curative treatment
collapse (sum) cost*, by(hhid)
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_expenses.dta", replace
reshape long cost_, i(hhid) j(input) string
rename cost_ val_total
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_expenses_long.dta", replace // In case is needed for AgQuery


/*
recode cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock (.=0)

*Livestock expenses for large ruminants
preserve
rename AGroup_ID lvstckcat
keep if lvstckcat == 1 | lvstckcat == 105 /* These are both Large Ruminants; Exotic/Cross and Indigenous are separate variables in W3. */
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock, by (hhid)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock)
keep hhid cost_lrum
lab var cost_lrum "Livestock expenses for large ruminants"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_lrum_expenses", replace
restore 


*Vaccine expenses by livestock type
preserve 
	ren AGroup_ID livestock_code //ALT: Why do we use different names for this? KEF: agreed? //
	gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,103,107)) + 4*(inlist(livestock_code,104,108)) 
	recode species (0=.)
	la def species 1 "Large ruminants (Exotic/Cross, Indigenous)" 2 "Small ruminants (Exotic/Cross, Indigenous)" 3 "Poultry (Exotic/Cross, Indigenous)" 4 "Pigs(Exotic/Cross, Indigenous)"
	la val species species 

collapse (sum) cost_vaccines_livestock, by (hhid species) 
	rename cost_vaccines_livestock ls_exp_vac
		foreach i in ls_exp_vac{
			gen `i'_lrum = `i' if species==1
			gen `i'_srum = `i' if species==2
			gen `i'_poultry = `i' if species==3
			gen `i'_pigs = `i' if species==4			
		}
		

collapse (firstnm) *lrum *srum *poultry *pigs, by(hhid)

foreach i in ls_exp_vac{
	gen `i' = .
}
	la var ls_exp_vac "Cost for vaccines and veterinary treatment for livestock"

	foreach i in ls_exp_vac{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_poultry "`l`i'' - poultry"
		lab var `i'_pigs "`l`i'' - pigs"
	}
	drop ls_exp_vac
	save"${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_expenses_animal", replace
restore 

collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock, by (hhid)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
recast str32 hhid, force
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_expenses", replace*/

*****************************    LIVESTOCK PRODUCTS        *******************************
*1. Milk
// liters for all questions
//reference period = 12 mos large ruminants, 6mos small ruminants
use "${Uganda_NPS_w8_raw_data}\Agric\agsec8b.dta", clear
ren AGroup_ID livestock_code 
gen livestock_code2="1. Milk"
keep if livestock_code==101 | livestock_code==105 // Exotic + Indigenous large ruminants. 
rename s8bq01 animals_milked // 12 months
ren s8bq02 months_milked //Doesn't have total days milked like w3
gen days_milked = months_milked*30
rename s8bq03 liters_perday_peranimal // avg milk production per day per animal milked
recode animals_milked months_milked days_milked liters_perday_peranimal (.=0)

gen milk_liters_produced = animals_milked*liters_perday_peranimal*days_milked
lab var milk_liters_produced "Liters of milk produced in past 12 months"

// Question: During this period (1 yr) how much did you sell per day. (Unit is liters/day). Multiply by 365 to get year? // However, only 45 responses, 38/45 = 0. 1 response is 10,000, so may be total year instead of per day over year (drop?) 
gen liters_sold_per_year = s8bq07*365 
ren s8bq07 liters_sold_per_day 

rename s8bq06 liters_per_day_to_dairy // RH 1.3.21: "processed dairy" instead of cheese //RH: Q asks for liters/day. What is reasonable? 10-30 possible for per day? 720 is not (cheese in day units)
gen liters_per_year_to_dairy = liters_per_day_to_dairy*365
rename s8bq09 earnings_sales // milk and dairy products// In questionnaire: How much earned over 12 mos, not day (milk in year units)

recode liters_sold_per_year liters_per_year_to_dairy (.=0)
gen price_per_liter = earnings_sales / liters_sold_per_year
gen price_per_unit = price_per_liter  
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
keep hhid livestock_code livestock_code2  milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_sales
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_sales "Total earnings of sale of milk produced"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products_milk.dta", replace


*2. Eggs
use "${Uganda_NPS_w8_raw_data}\Agric\agsec8c.dta", clear
ren AGroup_ID livestock_code
// Time period = Over 3 months; code based on UGA w3
ren s8cq01 months_produced // how many poultry laid eggs in the last 3 months (qs diff from TNPS)
ren s8cq02 quantity_month // what quantity of eggs were produced in the last 3 mos
recode months_produced quantity_month (.=0)
gen quantity_produced = quantity_month * 4 // Var = est. of eggs produced in last year. Extrapolating from 3 months (reported in survey)
lab var quantity_produced "Quantity of this product produced in past year"
ren s8cq03 sales_quantity // eggs sold in the last 3 months
ren s8cq05 earnings_sales

recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
//units not included
gen livestock_code2 = "2. Eggs"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products_other", replace


*3. Meat - here if we want it but commenting it out for now
/*use "${Uganda_NPS_w8_raw_data}\Agric\agsec8a.dta", clear
rename AGroup_ID livestock_code
gen livestock_code2 = "3. Meat"
ren s8aq01 number_slaught
ren s8aq02 meat_mean
gen quantity_produced = number_slaught*meat_mean
label var quantity_produced "Total live meat slaughtered (kg) in the past 12 months"
ren s8aq03 sales_quantity
ren s8aq05 earnings_sales
gen price_per_unit = earnings_sales/sales_quantity
keep hhid livestock_code sales_quantity earnings_sales livestock_code2 quantity_produced price_per_unit number_slaught meat_mean
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products_meat.dta", replace*/


*We append the 3 subsection of livestock earnings
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products_milk.dta"
recast str32 hhid
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products.dta", replace

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products.dta", replace
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_weights.dta", nogen keep(1 3)
collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code)
ren price_per_unit price_unit_median_country
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products_prices_country.dta", replace
* Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products.dta", replace
merge m:1 livestock_code2 livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products_prices_country.dta", nogen keep(1 3)
keep if quantity_produced!=0
gen value_produced = price_per_unit * quantity_produced 
replace value_produced = price_unit_median_country * quantity_produced if value_produced==.
replace value_produced = value_produced*4 if livestock_code2=="2. Eggs" //  Eggs sales is for the past 3 months we need to extrapolate for the whole year.
lab var price_unit_median_country "Price per liter (milk) or per egg/liter/container honey or palm wine, imputed with local median prices if household did not sell"
gen value_milk_produced = price_per_unit * quantity_produced if livestock_code2=="1. Milk"
replace value_milk_produced = quantity_produced * price_unit_median_country if livestock_code2=="1. Milk" & value_milk_produced==.
gen value_eggs_produced = price_per_unit * quantity_produced if livestock_code2=="2. Eggs"
replace value_eggs_produced = quantity_produced * price_unit_median_country if livestock_code2=="2. Eggs" & value_eggs_produced==.

*Share of total production sold
gen sales_livestock_products = earnings_sales	
/*Agquery 12.01*/
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
gen prop_dairy_sold = sales_milk / value_milk_produced // There's some issues with some values>1 - the milk dataset does not make a lot of sense.
gen prop_eggs_sold = sales_eggs / value_eggs_produced
*gen prop_meat_sold = sales_meat / value_meat_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
*lab var value_meat_produced "Value of meat produced"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_LSMS_ISA_W8_livestock_products.dta", replace

*****************************    LIVESTOCK SOLD (LIVE)       *******************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a", clear
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b"
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c"
recast str32 hhid

ren LiveStockID livestock_code
replace livestock_code = ALiveStock_Small_ID if livestock_code == . & ALiveStock_Small_ID!=.
replace livestock_code = APCode if livestock_code==. & APCode!=.
label define livestock_code 1 "Exotic/Cross - Calves" /*
						*/	2 "Exotic/Cross - Bulls" /*
						*/	3 "Exotic/Cross - Oxen"/*
						*/	4 "Exotic/Cross - Heifers" /*
						*/	5 "Exotic/ Cross - Cows" /*
						*/  6 "Indigenous - Calves" /*
						*/  7 "Indigenous - Bulls" /*
						*/  8 "Indigenous - Oxen" /*
						*/  9 "Indigenous - Heifers" /*
						*/ 10 "Indigenous - Cows" /*
						*/ 11 "Indigenous - Donkeys/mules" /*
						*/ 12 "Indigenous - Horses" /*
						*/ 13 "Exotic/Cross - Male Goats"/*
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
						*/ 27 "Rabbits",  add
ren s6aq01 animal_owned
replace animal_owned=s6bq01 if animal_owned==. & s6bq01 !=.
replace animal_owned=s6cq01 if animal_owned==. & s6cq01 !=.
keep if animal_owned==1

//Time periods differ across livestock type: Cattle & pack animals (12 months), small animals (6 months), poultry (3 months)
//Adjust time periods below to 12 month
ren s6aq14a number_sold  // large ruminants (12mos)
replace number_sold = 2*s6bq14a if number_sold==. & s6bq14a!=. // small ruminants (6mos)
replace number_sold = 4*s6cq14a if number_sold==. & s6cq14a!=. // poultry (3mos)

ren s6aq14b value_sold
replace value_sold=s6bq14b if value_sold==.
replace value_sold=s6cq14b if value_sold==.

gen income_live_sales = value_sold*number_sold //total sales value of all sold

ren s6aq15 number_slaughtered
replace number_slaughtered = 2*s6bq15 if number_slaughtered==. & s6bq15!=.
replace number_slaughtered = 4*s6cq15 if number_slaughtered==. & s6cq15!=.

ren s6aq13a number_livestock_purchases
replace number_livestock_purchases = 2*s6bq13a if number_livestock_purchases==.
replace number_livestock_purchases = 4*s6cq13a if number_livestock_purchases==.

ren s6aq13b price_livestock
replace price_livestock = s6bq13b if price_livestock==.
replace price_livestock = s6cq13b if price_livestock==.

gen value_livestock_purchases = number_livestock_purchases*price_livestock
recode number_sold income_live_sales number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = value_sold
lab var price_per_animal "Price of live animal sold" //ALT: Not sure why we wouldn't include prices of animals bought also
recode price_per_animal (0=.)
//recast str32 hhid, force
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3) 
//keep hhid region rural weight district_code county_code scounty_code parish_code ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_hh_livestock_sales.dta", replace

*Implicit prices (shorter)
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
gen obs = 1
foreach i in region district_name county subcounty_name parish_name {
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

foreach i in region district_name county subcounty_name parish_name country {
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
/* AgQuery 12.0 gen prop_meat_sold = value_slaughtered_sold/value_slaughtered*/ // 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_livestock_sales.dta", replace


//Old livestock code, may be helpful later?
/*
bys region district_name county_code subcounty_code parish_code livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district_code county_code scounty_code parish_code ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_ea.dta", replace

//median price at the parish level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district_code county_code scounty_code parish_code livestock_code: egen obs_parish = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district_code county_code scounty_code parish_code livestock_code obs_parish)
ren price_per_animal price_median_parish
lab var price_median_parish "Median price per unit for this livestock in the parish"
lab var obs_parish "Number of sales observations for this livestock in the parish"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_parish.dta", replace


//median price at the subcounty level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district_code county_code scounty_code livestock_code: egen obs_sub = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district_code county_code scounty_code livestock_code obs_sub)
rename price_per_animal price_median_sub

lab var price_median_sub "Median price per unit for this livestock in the subcounty"
lab var obs_sub "Number of sales observations for this livestock in the subcounty"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_livestock_prices_subcounty.dta", replace


//median price at the county level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district_code county_code livestock_code: egen obs_county = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district_code county_code livestock_code obs_county)
rename price_per_animal price_median_county

lab var price_median_county "Median price per unit for this livestock in the county"
lab var obs_county "Number of sales observations for this livestock in the county"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_livestock_prices_county.dta", replace

//median price at the district level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district_code livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district_code livestock_code obs_district)
ren price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_district.dta", replace

//median price at the region level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_region.dta", replace

//median price at the country level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_country.dta", replace


use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
merge m:1 region district_code county_code scounty_code parish_code ea livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_ea.dta", nogen
merge m:1 region district_code county_code scounty_code parish_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_parish.dta", nogen
merge m:1 region district_code county_code scounty_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_subcounty.dta", nogen
merge m:1 region district_code county_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_county.dta", nogen
merge m:1 region district_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_country.dta", nogen

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
//EFW 6.10.19 Don't have value slaughtered so just value with the live animal price (see construction decisions) -- UGA w3
gen value_livestock_sales = value_lvstck_sold + value_slaughtered

collapse (sum) value_livestock_sales value_lvstck_sold value_slaughtered value_livestock_purchases, by (hhid)
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_sales", replace*/
 
********************************************************************************
**                                 TLU    		         	         	      **
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a", clear
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b"
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c"
recast str32 hhid

gen livestock_code = LiveStockID
replace livestock_code = ALiveStock_Small_ID if livestock_code == . & ALiveStock_Small_ID!=.
replace livestock_code = APCode if livestock_code==. & APCode!=.
label define livestock_code 1 "Exotic/Cross - Calves" /*
						*/	2 "Exotic/Cross - Bulls" /*
						*/	3 "Exotic/Cross - Oxen"/*
						*/	4 "Exotic/Cross - Heifers" /*
						*/	5 "Exotic/ Cross - Cows" /*
						*/  6 "Indigenous - Calves" /*
						*/  7 "Indigenous - Bulls" /*
						*/  8 "Indigenous - Oxen" /*
						*/  9 "Indigenous - Heifers" /*
						*/ 10 "Indigenous - Cows" /*
						*/ 11 "Indigenous - Donkeys/mules" /*
						*/ 12 "Indigenous - Horses" /*
						*/ 13 "Exotic/Cross - Male Goats"/*
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
						*/ 27 "Rabbits",  add

ren s6aq01 animal_owned
replace animal_owned=s6bq01 if animal_owned==.
replace animal_owned=s6cq01 if animal_owned==.

keep if animal_owned > 0 // no binary animal owned variable. Asks how many animals were owned

gen tlu_coefficient =  0.5 if inrange(livestock_code, 1, 10) //Bulls, oxen, calves, heifer and cows
replace tlu_coefficient = 0.55 if livestock_code==12 //(horses = 0.5 and mules = 0.6), separates donkeys/mules from horses in w8
replace tlu_coefficient = 0.45 if livestock_code==11 //donkeys/mules - average coeff of donkeys and mules. donkey coeff = .3, mule = .6; using .45 
replace tlu_coefficient = 0.2 if livestock_code==17 | livestock_code==22 //pigs
replace tlu_coefficient = 0.1 if inrange(livestock_code, 13,16) | inrange(livestock_code, 18,21) //female & male goats & sheep
replace tlu_coefficient = 0.01 if inrange(livestock_code, 23,27) //rabbits, ducks, turkeys 
//geese and other birds, backyard chicken, parent stock for broilers, parents stock for layers, layers, pullet chicks, growers, broilers; beehives not included
//ALT: Changed from 0.1 to 0.01, assuming 0.1 is a coding error
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

gen number_1yearago = s6aq06
replace number_1yearago = s6bq06 if number_1yearago==.
replace number_1yearago = s6cq06 if number_1yearago==.

gen number_today= s6aq03a
replace number_today = s6bq03a if number_today==. 
replace number_today = s6cq03a if number_today==. 

gen number_today_exotic = number_today if inlist(livestock_code,1,2,3,4,5,13,14,15,16,17)

gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
gen income_live_sales = s6aq14b // this is avg value of livestock type sold
replace income_live_sales = s6bq14b if income_live_sales==. & s6bq14b!=. 
replace income_live_sales = s6cq14b if income_live_sales==. & s6cq14b!=. 
gen number_sold = s6aq14a
replace number_sold = s6bq14a*2 if number_sold==. & s6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace number_sold = s6cq14a*4 if number_sold==. & s6bq14a!=. //EFW 8.26.19 multiply by 4 because question asks in last 3 months


//How many animals lost to theft
gen lost_theft = s6aq10
replace lost_theft = s6bq10*2 if lost_theft==. & s6bq10!=. // over 6 mos
replace lost_theft = s6cq10*4 if lost_theft==. & s6cq10!=. // over 3 mos

//How many animals lost to accident or injury
gen lost_other = s6aq11
replace lost_other = s6bq11*2 if lost_other==. & s6bq11!=.
replace lost_other = s6cq11*4 if lost_other==. & s6cq11!=.

// How many animals lost to disease
gen lost_disease = s6aq12 //includes animals died or lost
replace lost_disease = s6bq12*2 if lost_disease==. & s6bq12!=. 
replace lost_disease = s6cq12*4 if lost_disease==. & s6cq12!=.
 
//Total lost in last 12 months 
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
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3) 
foreach i in region district_name county subcounty_name parish_name {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

*gen value_start_agseas = number_start_agseas * price_per_animal
gen value_today = number_today * price_per_animal
gen value_1yearago = number_1yearago * price_per_animal
*gen value_today_est = number_today * price_per_animal_est

collapse (sum) number_today number_1yearago lost_theft lost_other lost_disease animals_lost lvstck_holding=number_today value* tlu*, by(hhid species)
egen mean_12months=rowmean(number_today number_1yearago)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_herd_characteristics_long.dta", replace //AgQuery

preserve
keep hhid species number_today number_1yearago /*animals_lost*/ lost_disease lost_other lost_theft lvstck_holding mean_12months
global lvstck_vars number_today number_1yearago lost_other lost_theft lost_disease lvstck_holding mean_12months
foreach i in $lvstck_vars {
	ren `i' `i'_
}
reshape wide $lvstck_vars, i(hhid) j(species) string
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
//drop lvstck_holding animals_lost_agseas mean_agseas lost_disease //No longer needed 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_herd_characteristics.dta", replace
restore

collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of one year ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_TLU.dta", replace


//Old TLU code
/*
gen herd_cows_indigenous = number_today if inrange(livestock_code,6,10)
gen herd_cows_exotic = number_today if inrange(livestock_code,1,5)
egen herd_cows_tot = rowtotal(herd_cows_indigenous herd_cows_exotic)
gen share_imp_herd_cows = herd_cows_exotic / herd_cows_tot

*rename lvstckid livestock_code

gen species = (inrange(livestock_code,1,10) + 2*(inlist(livestock_code,13,14,15,16,18,19,20,21)) + 3*(inlist(livestock_code,17,22)) + 4*(inlist(livestock_code,11,12)) + 5*(inrange(livestock_code,23,27)))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species


preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(hhid species) //EFW 6.9.19 doesn't include lost to disease or injury disaggregated (just died/lost) SW I changed that variable including those lost to disease and injury not sure if its good
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
	collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(hhid)

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
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold // this should be the same as income_live_value 
recast str32 hhid, force
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_hhids.dta"
drop if _merge==2
drop _merge

merge m:1 region district_code county_code scounty_code parish_code ea livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_ea.dta", nogen
merge m:1 region district_code county_code scounty_code parish_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_parish.dta", nogen
merge m:1 region district_code county_code scounty_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_subcounty.dta", nogen
merge m:1 region district_code county_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_county.dta", nogen
merge m:1 region district_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_prices_country.dta", nogen 
recode price_per_animal (0=.)

replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal  = price_median_parish if price_per_animal==. & obs_parish >= 10 
replace price_per_animal  = price_median_sub if price_per_animal==. & obs_sub >= 10 
replace price_per_animal  = price_median_county if price_per_animal==. & obs_county >= 10 
replace price_per_animal  = price_median_district if price_per_animal==. & obs_district >= 10 
replace price_per_animal  = price_median_region if price_per_animal==. & obs_region >= 10 
replace price_per_animal  = price_median_country if price_per_animal==. & obs_country >= 10 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_TLU.dta", replace

*Livestock income
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_sales", clear
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_products", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_expenses", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_TLU.dta", nogen

gen livestock_income = value_lvstck_sold + value_slaughtered - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced)- (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock)
lab var livestock_income "Net livestock income"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_income", replace
*/

 
*************************************************************************
*FISH INCOME - // Not included in this instrument
*************************************************************************
*No Fish Income data collected in Uganda w3. (Similar to other Uganda waves)
********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/HH/gsec12_2.dta", clear
recast str32 hhid
ren h12q09 months_activ // how many months did the business operate
replace months_activ = 12 if months_activ > 12 & months_activ!=. //1 change made
ren h12q10 monthly_revenue // avg monthly gross revenues when active
ren h12q12 wage_expense // avg expenditure on wages
ren h12q13 materials_expense // avg expenditures on raw materials
ren h12q14 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (.=0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit!=. //W8 has many hhs with negative profit (52)

gen annual_selfemp_profit = monthly_profit * months_activ
count if annual_selfemp_profit<0 & annual_selfemp_profit!=. //52
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by(hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "$Uganda_NPS_w8_created_data}/Uganda_NPS_W8_self_employment_income.dta", replace

*Processed crops 
//RH 1/4/21: Not captured in w8 instrument (or other UGA waves)

*Fish trading
//RH 1/4/21: Not captured in w8 instrument (or other UGA waves)



********************************************************************************
**                             OFF-FARM HOURS      	    	                  **
********************************************************************************
//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs)
use "${Uganda_NPS_w8_raw_data}\HH\gsec8.dta", clear
recast str32 hhid
egen primary_hours = rowtotal (s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if (s8q04==1 | s8q06==1 | s8q08==1 | s8q10==1) & s8q22!=6 // includes work for someone else, work without payment for the house, apprentice etc. for all work MAIN JOB excluding "Working on the household farm or with household livestock.." Last 7 days total hours worked per person
egen secondary_hours =  rowtotal (s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g) //not sure if there needs to be an "if" statement here... W3 suggests it but s8q38a is strL
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours, for the past 7 days"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_off_farm_hours.dta", replace


*************************************************************************
*NON-AG WAGE INCOME -- RH complete 12/26/21, not checked
*************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec8.dta", clear
recast str32 hhid
ren s8q04 wage_yesno // Did [NAME] work for wage, salary, commission or any payment in kind? [w4 used q05, but that wasn't available in w8. -- did any wage work in the last 12 months y/n]
ren s8q30 number_months // months worked for main job
ren s8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12

egen hours_pastweek = rowtotal(s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g)
gen number_hours = hours_pastweek*number_weeks

gen most_recent_payment = s8q31a // what is the set rate you are paid [w4 - cash and in-kind payments]
*gen most_recent_payment_other = h8q31b // not in w8
ren s8q31c payment_period 
ren s8q37 secwage_yesno // did they have a secondary wage?
ren s8q45b secwage_most_recent_payment
ren s8q45c secwage_payment_period

egen secwage_hours_pastweek = rowtotal(s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g)

gen annual_salary_cash = (number_months*most_recent_payment) if payment_period==4 // month
replace annual_salary_cash = (number_weeks*most_recent_payment) if payment_period==3 // week
replace annual_salary_cash = ((number_hours/8)*most_recent_payment) if payment_period==2 // hour; assuming 8 hour workdays 
replace annual_salary_cash = (number_hours*most_recent_payment) if payment_period==1

gen second_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace second_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace second_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace second_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

recode annual_salary_cash second_salary_cash (.=0)
gen annual_salary = annual_salary_cash + second_salary_cash
tab secwage_payment_period
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wage_income.dta", replace


************************************************************************
*AG WAGE INCOME - RH complete 12/26/21, not checked
************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec8.dta", clear
recast str32 hhid
ren s8q04 wage_yesno // Did [NAME] work for wage, salary, commission or any payment in kind? [w4 used q05, but that wasn't available in w8. -- did any wage work in the last 12 months y/n]
ren s8q30 number_months // months worked for main job
ren s8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12

egen hours_pastweek = rowtotal(s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g)
gen number_hours = hours_pastweek*number_weeks

gen agwage = 1 if ((h8q19b_twoDigit>=61 & h8q19b_twoDigit<=63) | (h8q19b_twoDigit==92))	//Based on ISCO classifications used in Basic Information Document used for Wave 4; 61-63 are "Skilled Agricultural, Forestry, Fishery Labourers"; 92 is "Elementary Occupations, Agricultural, Forestry, Fishery Labourers"
gen secagwage = 1 if ((h8q38b_twoDigit>=61 & h8q38b_twoDigit<=63) | (h8q38b_twoDigit==92))	//Based on ISCO classifications used in Basic Information Document used for Wave 4

gen most_recent_payment = s8q31a
replace most_recent_payment = . if agwage!=1
ren s8q31c payment_period
ren s8q37 secondary_wage_yesno
ren s8q45b secwage_most_recent_payment
replace secwage_most_recent_payment = . if secagwage!=1
ren s8q45c secwage_payment_period
egen secwage_hours_pastweek = rowtotal(s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g)

gen annual_salary_cash = (number_months*most_recent_payment) if payment_period==4 // month
replace annual_salary_cash = (number_weeks*most_recent_payment) if payment_period==3 // week
replace annual_salary_cash = ((number_hours/8)*most_recent_payment) if payment_period==2 // hour; assuming 8 hour workdays 
replace annual_salary_cash = (number_hours*most_recent_payment) if payment_period==1

gen second_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace second_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace second_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace second_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

recode annual_salary_cash second_salary_cash (.=0)
gen annual_salary = annual_salary_cash + second_salary_cash
collapse (sum) annual_salary, by (hhid)
ren annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_agwage_income.dta", replace

********************************************************************************
**                               OTHER INCOME 	        	    	          **
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec7_2.dta", clear
recast str32 hhid
gen rental_income_cash = s11q05 if (IncomeSource==21 | IncomeSource==22 | IncomeSource==23) //net rent from buildings/property; net rent from land; royalties. 
gen rental_income_inkind = s11q06 if (IncomeSource==21 | IncomeSource==22 | IncomeSource==23) //net rent from buildings/property; net rent from land; royalties. 
gen pension_income_cash = s11q05 if IncomeSource==41 // pension and life annuity 
gen pension_income_inkind = s11q06 if IncomeSource==41 // pension and life annuity 

gen other_income_cash = s11q05 if (IncomeSource==45 | IncomeSource==44 | IncomeSource==36 | IncomeSource==35 | IncomeSource==34 | IncomeSource==33 | IncomeSource==32 | IncomeSource==31) 
gen other_income_inkind = s11q06 if (IncomeSource==45 | IncomeSource==44 | IncomeSource==36 | IncomeSource==35 | IncomeSource==34 | IncomeSource==33 | IncomeSource==32 | IncomeSource==31)
//other income includes: other; income from sale of assets excluding livestock; payments from treasury bills; payments from bonds; dividends; interest from shares; interest from other type of account; interest from current account
// RH FLAG: Other income- removed 41 - pension, bc accounted for in pension_income*. Should this be removed from UGA w4 too?; Should 48 - Family grants under SAGE be added to other_income?

gen remittance_cash = s11q05 if IncomeSource==42 | IncomeSource==43
gen remittance_inkind = s11q06 if IncomeSource==42 | IncomeSource==43
recode rental_income_cash rental_income_inkind pension_income_cash pension_income_inkind other_income_cash other_income_inkind remittance_cash remittance_inkind (.=0)
gen rental_income = rental_income_cash + rental_income_inkind
gen pension_income = pension_income_cash + pension_income_inkind
gen other_income = other_income_cash + other_income_inkind
gen remittance_income = remittance_cash + remittance_inkind
collapse (sum) rental_income pension_income other_income remittance_income, by (hhid)

lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension AND INTEREST over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
//assistance_income not in UGA W4. Should this be added with 48, family grants under SAGE?

save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_other_income.dta", replace

********************************************************************************
**                           LAND RENTAL INCOME        	    	              **
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta", clear
recast str32 hhid
ren s2aq14 land_rental_income
recode land_rental_income (.=0)
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rental_income.dta", replace


********************************************************************************
*FARM SIZE / LAND SIZE -- 12/27/21 RH FLAG: need to figure out "cultivated", (see Flags) complete besides that
//Cultivated Questions: is cultivated same for all sections? Does cultivated include 2018 and 2019? Is it both annual and perennial (for both time periods?)

*2/16/22 - complete minus cultivated flag
********************************************************************************
*Determining whether crops were grown on a plot
use "${Uganda_NPS_w8_raw_data}\Agric\agsec4a.dta", clear
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec4b.dta"
ren parcelID parcel_id
drop if parcel_id==.
ren pltid plot_id
drop if plot_id==.
ren cropID crop_code
drop if crop_code==.
gen crop_grown = 1 
recast str32 hhid, force 
collapse (max) crop_grown, by(hhid parcel_id)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crops_grown.dta", replace

**

use "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec2b.dta"
gen cultivated = (s2aq11a==1 | s2aq11b==1)
//RH FLAG: This only includes cultivated for annual crops. Should we include perennial crops as well? [2]
ren parcelID parcel_id
collapse (max) cultivated, by (hhid parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcels_cultivated.dta", replace

**
//RH FLAG: uses plot_areas code which may be rename to parcel_areas. Also need to re-run this section after plot_areas code is fixed.
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcels_cultivated.dta", clear
recast str32 hhid, force 
merge 1:m hhid parcel_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta" // 3,741 not matched from master
drop if _merge==2
keep if cultivated==1
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0 
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
collapse (sum) parcel_area_acres_meas, by (hhid)
ren parcel_area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_size.dta", replace

**

*All agricultural land
use "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec2b.dta"
ren parcelID parcel_id
*drop if plot_id==.

recast str32 hhid 
merge m:1 hhid parcel_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crops_grown.dta", nogen
*4,945 matched
*420 not matched (from master)
gen rented_out = (s2aq11a==3 | s2aq11b ==3) // what was or is the primary use of the parcel during the cropping season
//RH flag - what is difference between s2 and a2
gen cultivated_short = (s2aq11a==1 | s2aq11a==2 | s2aq11b ==1 | s2aq11b ==2) // own cultivated annual and perennial crops.
//RH FLAG: should this be for both 2018 and 2019 seasons?

bys hhid parcel_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
*39 obs dropped
gen agland = s2aq11a==1 | s2aq11a==2 | s2aq11a==5 | s2aq11a==6| s2aq11b==1 | s2aq11b==2 | s2aq11b==5 | s2aq11b==6 // includes cultivated, fallow, pasture

drop if agland!=1 & crop_grown==.
*143 obs dropped
collapse (max) agland, by (hhid parcel_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcels_agland.dta", replace

**
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcels_agland.dta", clear
merge 1:m hhid parcel_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta"
drop if _merge==2
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==0 & (parcel_area_acres_est>0 & parcel_area_acres_est!=.)	
collapse (sum) parcel_area_acres_meas, by (hhid)
ren parcel_area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmsize_all_agland.dta", replace

**
use "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec2b.dta"
ren parcelID parcel_id
drop if parcel_id==.
gen rented_out = (s2aq11a==3 | s2aq11b==3) 
gen cultivated_short = (s2aq11b==1 | s2aq11b==2) // is this supposed to be short season only? 
//RH FLAG: should this be for both 2018 and 2019 seasons?

bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen parcel_held = 1
collapse (max) parcel_held, by (hhid parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcels_held.dta", replace

**
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcels_held.dta", clear
recast str32 hhid
merge 1:m hhid parcel_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta"
drop if _merge==2
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
collapse (sum) parcel_area_acres_meas, by (hhid)
ren parcel_area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_size_all.dta", replace

**
*Total land holding including cultivated and rented out
use "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta"
ren parcelID parcel_id
drop if parcel_id==.
recast str32 hhid
merge m:m hhid parcel_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta", nogen keep(1 3)
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==0 & (parcel_area_acres_est>0 & parcel_area_acres_est!=.)	
collapse (max) parcel_area_acres_meas, by(hhid parcel_id)
ren parcel_area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_size_total.dta", replace

//IHS 10/11/19 END

********************************************************************************
*OFF-FARM HOURS - RH complete 12/27/21, not checked
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec8.dta", clear
*Use ISIC codes for non-farm activities
egen primary_hours = rowtotal (s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if (h8q19b_twoDigit<61 | (h8q19b_twoDigit>63 & h8q19b_twoDigit<92) | h8q19b_twoDigit>92) //Based on ISCO classifications used in Basic Information Document used for Wave 8
egen secondary_hours = rowtotal (s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g) if (h8q19b_twoDigit<61 | (h8q19b_twoDigit>63 & h8q19b_twoDigit<92) | h8q19b_twoDigit>92) //Based on ISCO classifications used in Basic Information Document used for Wave 8

egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)

la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_off_farm_hours.dta", replace

//IHS 10/11/19 START
********************************************************************************
*FARM LABOR - ip
********************************************************************************
/*
*will also need agsec3a_1 for family labor
*w3 code
use "${Uganda_NPS_w8_raw_data}/Agric/agsec3a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec3a_1.dta"
recast str32 hhid
ren parcelID parcel_id 
ren pltid plot_id
*ren A3aq39 days_famlabor_mainseason //person days: reflects both size of team & number of days spent // not in w8
ren s3aq35a days_hired_men
ren s3aq35b days_hired_women
ren s3aq35c days_hired_child
egen days_hired_2018 = rowtotal(days_hired_men days_hired_women days_hired_child)
recode /*days_famlabor_mainseason*/ days_hired_mainseason (.=0)
collapse (sum) days_famlabor_mainseason days_hired_2018, by (hhid parcel_id plot_id) //EFW 7.19.19 correct level??
lab var days_hired_2018  "Workdays for hired labor (crops) in 2018"
*lab var days_famlabor_2018  "Workdays for family labor (crops) in main growing season"

*fam labor - merge hhids to get gender, but can't get children days. personid

save "${Uganda_w8_created_data}/Uganda_NPS_w8_farmlabor_2018.dta", replace

use "${UGS_W3_raw_data}/AGSEC3B.dta", clear
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_shortseason.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_mainseason.dta", clear
merge 1:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_shortseason.dta"
drop _merge
recode days* (.=0)
collapse (sum) days*, by (HHID parcel_id plot_id)
egen labor_hired = rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family = rowtotal(days_famlabor_mainseason days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_hired_shortseason days_famlabor_mainseason days_famlabor_shortseason) 
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by (HHID)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_family_hired_labor.dta", replace






*Family labor
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
//agsec3a only has hired labor questions, number of days - not tasks
//agsec3a_1 has id in farm labor - how many days did id work (will have to merge with HHID)

ren ag3a_74_1 landprep_women 
ren ag3a_74_2 landprep_men 
ren ag3a_74_3 landprep_child 
ren ag3a_74_5 weeding_men 
ren ag3a_74_6 weeding_women 
ren ag3a_74_7 weeding_child 
ren ag3a_74_13 harvest_men 
ren ag3a_74_14 harvest_women 
ren ag3a_74_15 harvest_child
recode landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_mainseason = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child) 
recode ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ag3a_72_5 ag3a_72_6 (.=0)
egen days_flab_landprep = rowtotal(ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ag3a_72_5 ag3a_72_6)
recode ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ag3a_72_11 ag3a_72_12 (.=0)
egen days_flab_weeding = rowtotal(ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ag3a_72_11 ag3a_72_12)
recode ag3a_72_13 ag3a_72_14 ag3a_72_15 ag3a_72_16 ag3a_72_17 ag3a_72_18 (.=0)
egen days_flab_harvest = rowtotal(ag3a_72_13 ag3a_72_14 ag3a_72_15 ag3a_72_16 ag3a_72_17 ag3a_72_18)
gen days_famlabor_mainseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotnum plot_id
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (HHID plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_farmlabor_mainseason.dta", replace

use "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta", clear
ren ag3b_74_1 landprep_women 
ren ag3b_74_2 landprep_men 
ren ag3b_74_3 landprep_child 
ren ag3b_74_5 weeding_men 
ren ag3b_74_6 weeding_women 
ren ag3b_74_7 weeding_child 
ren ag3b_74_13 harvest_men 
ren ag3b_74_14 harvest_women 
ren ag3b_74_15 harvest_child
recode landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_shortseason = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child) 
recode ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ag3b_72_6 (.=0)
egen days_flab_landprep = rowtotal(ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ag3b_72_6)
recode ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12 (.=0)
egen days_flab_weeding = rowtotal(ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12)
recode ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18 (.=0)
egen days_flab_harvest = rowtotal(ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18)
gen days_famlabor_shortseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotnum plot_id
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (HHID plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_farmlabor_shortseason.dta", replace

*Hired Labor
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_farmlabor_mainseason.dta", clear
merge 1:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_farmlabor_shortseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(HHID plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(HHID)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_family_hired_labor.dta", replace

*/
************************************************************************
*VACCINE USAGE - RH complete 5/11/22, not checked
************************************************************************
*Reference code for drafting: TZA w5 (primarily), UGA w4
use "${Uganda_NPS_w8_raw_data}/Agric/agsec7", clear
// vaccines now only in livestock inputs section

recast str32 hhid, force // for merge
gen livestock_code = AGroup_ID // should this have a different name from other livestock_code vars? (specific animal codes vs categories like large/small ruminants) this is categories 

//RH FLAG 05.09.22: Change to lvstckcat? Or match for later merge? Use species to create lvstckcat?

gen vac_animal = s7q05a==1 | s7q05a==2 // all animals vaccinated and some animals vaccinated (by livestock category)
//s7q05a "Has this household vaccinated any %rostertitle% in [REF PERIOD]?"
//(1) Yes, all animals at least once
//(2) Some, some animals

gen species = (inlist(livestock_code, 101, 105)) + 2 * (inlist(livestock_code, 102, 106)) + 3* (inlist(livestock_code, 104, 108)) + 5*(inlist(livestock_code,103,107))
//1 = Large ruminants; 2 = Small ruminants; 3 = Pigs; 5 = Poultry
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants" 3 "Pigs" /*4 "Equine (horses, donkeys)" - no horses in w8 */ 5 "Poultry" 
la val species species

*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	*gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) vac_animal*, by (hhid)
lab var vac_animal "1= Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		*lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_vaccine.dta", replace
/*
// w4 code
*vaccine use livestock keeper
//creating farmerid to merge into section on vaccines// NKF 10.09.2019
// I don't think I did this right. Had to combine farmerid from one section and vaccine usage from another
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a.dta", clear //large ruminants
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b.dta" //small ruminants
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c.dta" //poultry
preserve
keep hhid s6aq03b s6bq03b s6cq03b 
ren s6aq03b farmerid //Who owns the [animal]?
replace farmerid = s6bq03b if farmerid==. & s6bq03b!=.
replace farmerid = s6cq03b if farmerid==. & s6cq03b!=.
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid s6aq03c s6bq03c s6cq03c 
ren s6aq03c farmerid
replace farmerid = s6bq03c if farmerid==. & s6bq03c!=.
replace farmerid = s6cq03c if farmerid==. & s6cq03c!=.
tempfile farmer2
save `farmer2'
restore
recast str32 hhid, force
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmerid.dta", replace
  
use "${Uganda_NPS_w8_raw_data}/Agric/agsec7.dta", clear
recast str32 hhid, force
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmerid.dta"

gen all_vac_animal= s7q05a==1 | s7q05a==2
replace all_vac_animal = . if s7q05a==3 | a7q05a==. //missing if the household did not own any of these types of animals 
keep hhid all_vac_animal farmerid
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 hhid personid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_gender_merge.dta", nogen
//970 matched
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen personid=farmerid
drop if personid==.
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${UGA_W4_created_data}/Uganda_NPS__LSMS_ISA_W4_farmer_vaccine.dta", replace

w3 code - copied 05.09.22
use "${UGS_W3_raw_data}/AGSEC6A", clear
ren Hhid HHID
*append using "${UGS_W3_raw_data}/AGSEC6B" //EFW 7.24.29 vaccine usage only included in large animal file
*append using "${UGS_W3_raw_data}/AGSEC6C" //EFW 7.24.19 vaccine usage only included in large animal file

gen livestock_code = A6aq3
/*
destring a6bq3 a6cq3, replace
replace lvstckid = a6bq3 if lvstckid ==. & a6bq3!=.
replace lvstckid = a6cq3 if lvstckid ==. & a6cq3!=.
*/
gen vac_animal=A6aq18==1 | A6aq18==2 //EFW 7.19.19 only included in dta file for large animals (large ruminants and equine)
//missing if the household did now own any of these types of animals 
replace vac_animal = . if A6aq4==2 | A6aq4==. 

gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 4*(inlist(livestock_code,7,8))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 4 "Equine (horses, donkeys)" 
la val species species

*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	*gen `i'_srum = `i' if species==2
	*gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	*gen `i'_poultry = `i' if species==5
}

collapse (max) vac_animal*, by (HHID)
lab var vac_animal "1= Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		*lab var `i'_srum "`l`i'' - small ruminants"
		*lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		*lab var `i'_poultry "`l`i'' - poultry"
	}
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_vaccine.dta", replace

*vaccine use livestock keeper 
use "${UGS_W3_raw_data}/AGSEC6A", clear
ren Hhid HHID
*append using "${UGS_W3_raw_data}/AGSEC6B" //EFW 7.24.29 vaccine usage only included in large animal file
*append using "${UGS_W3_raw_data}/AGSEC6C" //EFW 7.24.19 vaccine usage only included in large animal file

gen livestock_code = A6aq3
/*
destring a6bq3 a6cq3, replace
replace lvstckid = a6bq3 if lvstckid ==. & a6bq3!=.
replace lvstckid = a6cq3 if lvstckid ==. & a6cq3!=.
*/
gen all_vac_animal=A6aq18==1 | A6aq18==2 //EFW 7.19.19 only included in dta file for large animals (large ruminants and equine)
//missing if the household did now own any of these types of animals 
replace all_vac_animal = . if A6aq4==2 | A6aq4==. 
preserve 
keep HHID all_vac_animal A6aq17a
ren A6aq17a farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep HHID all_vac_animal A6aq17b 
ren A6aq17b farmerid
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'

collapse (max) all_vac_animal , by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", nogen //99 unmatched from master, 17,764 unmatched from using
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_vaccine.dta", replace


*/

*vaccine use livestock keeper
*this section of the code identifies livestock keepers, and whether the livestock keeper uses vaccines (merged with gender)  

*agsec6* has the livestock keepers, but files are split by livestock category (a is large ruminants, b is small ruminants, c is poultry, no file for pigs)
*s6cq03d: who keeps the %rostertitle% that your household owns (PID1)
*s6cq03e: who keeps the %rostertitle% that your household owns (PID2)
//maybe need to append all agsec6* files into one and create a lvstckcat variable for the merge with agsec7

use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a.dta", clear
gen lvstckcat =.
replace lvstckcat = 101 if (LiveStockID == 1|LiveStockID==2|LiveStockID==3|LiveStockID==4|LiveStockID==5) // 101 = Exotic/Cross Large Rums
replace lvstckcat = 105 if (LiveStockID == 6|LiveStockID==7|LiveStockID==8|LiveStockID==9|LiveStockID==10|LiveStockID==11|LiveStockID==12) // 105 = indigenous large rums
gen farmerid1 = s6aq03b if s6aq03b!=. // who keeps the rostertitle PID1 
gen farmerid2 = s6aq03c if s6aq03c!=. // who keeps the rostertitle PID1
*replace farmerid1 

append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b.dta"
replace lvstckcat = 102 if (ALiveStock_Small_ID == 13|ALiveStock_Small_ID==14|ALiveStock_Small_ID==15|ALiveStock_Small_ID==16|ALiveStock_Small_ID==17) // exotic/cross small rums
replace lvstckcat = 106 if (ALiveStock_Small_ID == 18|ALiveStock_Small_ID==19|ALiveStock_Small_ID==20|ALiveStock_Small_ID==21|ALiveStock_Small_ID==22) // indigenous small rums
replace farmerid1 = s6bq03b if farmerid1==. & s6bq03b!=. // who keeps the rostertitle PID1 
replace farmerid2 = s6bq03c if farmerid2==. & s6bq03c!=. // who keeps the rostertitle PID1


append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c.dta"
replace lvstckcat = 103 if (APCode == 24|APCode==25) // Exotic.cross - poultry
replace lvstckcat = 107 if (APCode == 23|APCode==26|APCode==27) // indigenous - poultry
replace farmerid1 = s6cq03b if farmerid1==. & s6cq03b!=. // who keeps the rostertitle PID1 
replace farmerid2 = s6bq03c if farmerid2==. & s6bq03c!=. // who keeps the rostertitle PID1

recast str32 hhid
tempfile temp_agsec6
save `temp_agsec6' 

use "${Uganda_NPS_w8_raw_data}/Agric/agsec7.dta", clear
ren AGroup_ID lvstckcat
recast str32 hhid

merge 1:m hhid lvstckcat using `temp_agsec6', nogen keep (1 3) // not matched = 484, matched = 5540

*"${Uganda_NPS_w8_raw_data}/lf_sec_05.dta", nogen keep (1 3)

gen all_vac_animal= s7q05a==1 | s7q05a==2 // Has this household vaccinated any [ANIMAL] in [REF PERIOD] (1= all, 2= some)
*replace all_vac_animal = . if lf03_01 ==2 | lf03_01==. //missing if the household did now own any of these types of animals  (question is, refer to section 1 question 1: did the household own any of these types of animals) 
*replace all_vac_animal = . if lvstckcat==6 // all lvstckcats except dogs (large rum, small rum, pigs, poultry, donkeys)  // no dogs in uga w8
preserve
keep hhid farmerid1 all_vac_animal // keeping hhid, who is responsible for keeping animal (farmer 1) all_vac animal
ren farmerid1 farmerid // who is responsible for keeping animal
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid farmerid2  all_vac_animal //second farmer
ren farmerid2 farmerid
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"

//2528 matched, 13528 not matched from using (check number in master)

*ren personid indidy4 // rh flag - personid to PID?
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_vaccine.dta", replace

//IHS 10/11/19 END

********************************************************************************
*ANIMAL HEALTH - DISEASES - LM updated to ALT request 11/15
********************************************************************************
*Can't construct - instrument does not collect types of disease 
/*
use "${Uganda_NPS_w8_raw_data}/lf_sec_03.dta", clear
gen disease_animal = 1 if (lf03_02_1!=22 | lf03_02_2!=22 | lf03_02_3!=22 | lf03_02_4!=22) 
replace disease_animal = 0 if (lf03_02_1==22)
replace disease_animal = . if (lf03_02_1==. & lf03_02_2==. & lf03_02_3==. & lf03_02_4==.) 
gen disease_fmd = (lf03_02_1==7 | lf03_02_2==7 | lf03_02_3==7 | lf03_02_4==7 )
gen disease_lump = (lf03_02_1==3 | lf03_02_2==3 | lf03_02_3==3 | lf03_02_4==3 )
gen disease_bruc = (lf03_02_1==1 | lf03_02_2==1 | lf03_02_3==1 | lf03_02_4==1 )
gen disease_cbpp = (lf03_02_1==2 | lf03_02_2==2 | lf03_02_3==2 | lf03_02_4==2 )
gen disease_bq = (lf03_02_1==9 | lf03_02_2==9 | lf03_02_3==9 | lf03_02_4==9 )
ren lvstckcat livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_diseases.dta", replace
*/

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING - not started
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/lf_sec_04.dta", clear
gen feed_grazing = (lf04_01_1==1 | lf04_01_1==2)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat = (lf04_06_1==5 | lf04_06_1==6 | lf04_06_1==7)
gen water_source_const = (lf04_06_1==1 | lf04_06_1==2 | lf04_06_1==3 | lf04_06_1==4 | lf04_06_1==8 | lf04_06_1==9 | lf04_06_1==10)
gen water_source_cover = (lf04_06_1==1 | lf04_06_1==2 )
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
gen lvstck_housed = (lf04_11==2 | lf04_11==3 | lf04_11==4 | lf04_11==5 | lf04_11==6 )
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
ren lvstckcat livestock_code
gen species = (inlist(livestock_code,1)) + 2*(inlist(livestock_code,2)) + 3*(livestock_code==3) + 4*(livestock_code==5) + 5*(inlist(livestock_code,4))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

*A loop to create species variables
foreach i in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
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
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_feed_water_house.dta", replace

//IHS 10/11/19 START
********************************************************************************
*USE OF INORGANIC FERTILIZER - RH IP - 
********************************************************************************

//UGA w2 - based on PA code
* Load data on Agricultural and Labor Inputs (first and second visit)
use "${Uganda_NPS_w8_raw_data}\Agric\agsec3a.dta", clear
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec3b.dta" 

* Make 1 = to yes and 0= no on inorganic fertilizer use questions and assume 
* missing answers are no inorganic fertilizer
recode s3aq13 s3bq13 (2=0) (.=0) 

* Combine the inorganic fertilizer question from both seasons into 1 variable
egen use_inorg_fert = rowmax(s3aq13 s3bq13)

* Perserve before collapsing to the household level (prevents duplicating work)
preserve
	collapse (max) use_inorg_fert, by(hhid)
	label variable use_inorg_fert "1 = Household uses inorganic fertilizer"
	recast str32 hhid
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_s8_fert_use.dta", replace
restore

//RH complete through here 8/22
* Parcel manager level *
************************
* Rename to the individual level variable name
rename use_inorg_fert all_use_inorg_fert

* Plot managers are only at the parcel level
collapse (max) all_use_inorg_fert, by(hhid parcelID)

//flag come back to here to add in new dta files -- need to figure out who should be assigned as parcel manager
//should we use plot decision maker? "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta"

* Merge in plot manager details from land holdings data
merge 1:1 hhid parcelID using "${UGA_W2_raw_data}/AGSEC2A", nogen keep(1 3)
merge 1:1 hhid parcelID using "${UGA_W2_raw_data}/AGSEC2B", nogen keep(1 3)

* Set the values for the two plot managers
egen personid1 = rowfirst(a2aq27a a2bq25a)
egen personid2 = rowfirst(a2aq27b a2bq25b)

* reshape data so each row has a single personid
reshape long personid, i(hhid parcelID)

* drop the missing people created by the reshape
drop if missing(personid)

* Collapse to the individual level
collapse (max) all_use_inorg_fert, by(hhid parcelID)

* Mark existing individuals as farm manager
gen farm_manager	= 1
* create a farmer id for consistency
gen farmerid		= personid

* Merge in data on farmer's gender from created gender merge file
merge 1:1 hhid personid using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen
* Set in new entries (i.e. those with no entry before the merge) as non farm 
* managers
recode farm_manager (.=0)

* Label the newly created variables
label variable farm_manager /*
	*/	"1= Individual is listed as a manager for at least one plot"
label variable all_use_inorg_fert /*
	*/	"1= Individual farmer (plot manager) uses inorganic fertilizer"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_fert_use", /*
	*/	replace

/* TZA code
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=0 if ag3a_47==2 | ag3b_47==2 | ag3a_54==2 | ag3b_54==2 
replace use_inorg_fert=1 if ag3a_47==1 | ag3b_47==1 | ag3a_54==1 | ag3b_54==1  
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (HHID)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fert_use.dta", replace
  
*Fertilizer use by farmers ( a farmer is an individual listed as plot manager)
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta" 
gen all_use_inorg_fert=(ag3a_47==1 | ag3b_47==1 | ag3a_54==1 | ag3b_54==1 )
preserve
keep HHID ag3a_08_1 ag3b_08_1 all_use_inorg_fert 
ren ag3a_08_1 farmerid
replace farmerid= ag3b_08_1 if farmerid==.
tempfile farmer1
save `farmer1'
restore
preserve
keep HHID ag3a_08_2 ag3b_08_2  all_use_inorg_fert 
ren ag3a_08_2 farmerid
replace farmerid= ag3b_08_2 if farmerid==.
tempfile farmer2
save `farmer2'
restore
preserve
keep HHID ag3a_08_3 ag3b_08_3 all_use_inorg_fert 
ren ag3a_08_3 farmerid
replace farmerid= ag3b_08_3 if farmerid==.		
tempfile farmer3
save `farmer3'
restore
use   `farmer1', replace
append using  `farmer2'
append using  `farmer3'
collapse (max) all_use_inorg_fert , by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", nogen
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren personid indidy4
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_fert_use.dta", replace
*/

********************************************************************************
*USE OF IMPROVED SEED - not started
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/ag_sec_4a.dta", clear 
append using "${Uganda_NPS_w8_raw_data}/ag_sec_4b.dta" 
gen imprv_seed_new=.
replace imprv_seed_new=1 if ag4a_08==1 | ag4a_08==3 | ag4b_08==1 | ag4b_08==3 
replace imprv_seed_new=0 if ag4a_08==2 | ag4a_08==4 | ag4b_08==2 | ag4b_08==4 
gen imprv_seed_old=.
replace imprv_seed_old=1 if ag4a_10b==1 | ag4a_10b==3 | ag4b_10b==1 | ag4a_10b==3
replace imprv_seed_old=0 if ag4a_10b==2 | ag4a_10b==4 | ag4b_10b==2 | ag4b_10b==4
replace imprv_seed_old=. if ag4a_10b==. | ag4b_10b==. 
gen imprv_seed_use=.
replace imprv_seed_use=1 if imprv_seed_new==1 | imprv_seed_old==1
replace imprv_seed_use=0 if imprv_seed_new==0 & imprv_seed_old==0 
recode imprv_seed_use (.=0)
*Use of seed by crop
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if zaocode==`c'
	gen hybrid_seed_`cn'=.
}
collapse (max) imprv_seed_* hybrid_seed_*, by(HHID)
lab var imprv_seed_use "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops 
replace imprv_seed_cassav = . 
replace imprv_seed_banana = . 
drop imprv_seed_new imprv_seed_old
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_improvedseed_use.dta", replace
  
*Seed adoption by farmers ( a farmer is an individual listed as plot manager)
use "${Uganda_NPS_w8_raw_data}/ag_sec_4a.dta", clear 
merge m:1 HHID plotnum using  "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", nogen keep(1 3)
preserve
use "${Uganda_NPS_w8_raw_data}/ag_sec_4b.dta" , clear
merge m:1 HHID plotnum using  "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta", nogen keep(1 3)
tempfile seedb
save `seedb'
restore
append using `seedb' 
gen imprv_seed_new=.
replace imprv_seed_new=1 if ag4a_08==1 | ag4a_08==3 | ag4b_08==1 | ag4b_08==3 
replace imprv_seed_new=0 if ag4a_08==2 | ag4a_08==4 | ag4b_08==2 | ag4b_08==4 
gen imprv_seed_old=.
replace imprv_seed_old=1 if ag4a_10b==1 | ag4a_10b==3 | ag4b_10b==1 | ag4a_10b==3
replace imprv_seed_old=0 if ag4a_10b==2 | ag4a_10b==4 | ag4b_10b==2 | ag4b_10b==4
replace imprv_seed_old=. if ag4a_10b==. | ag4b_10b==. 
gen imprv_seed_use=.
replace imprv_seed_use=1 if imprv_seed_new==1 | imprv_seed_old==1
replace imprv_seed_use=0 if imprv_seed_new==0 & imprv_seed_old==0 
recode imprv_seed_use (.=0)
ren imprv_seed_use all_imprv_seed_use
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_improvedseed_use_temp.dta", replace

*Use of seed by crop
forvalues k=1/$nb_topcrops {
	use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=all_imprv_seed_use if zaocode==`c'  
	gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= zaocode==`c' 
	preserve
	keep HHID ag3a_08_1 ag3b_08_1 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer  
	ren ag3a_08_1 farmerid
	replace farmerid= ag3b_08_1 if farmerid==.
	tempfile farmer1
	save `farmer1'
	restore
	preserve
	keep HHID ag3a_08_2 ag3b_08_2 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer  
	ren ag3a_08_2 farmerid
	replace farmerid= ag3b_08_2 if farmerid==.
	tempfile farmer2
	save `farmer2'
	restore
	preserve
	keep HHID ag3a_08_3 ag3b_08_3 all_imprv_seed_use all_imprv_seed_`cn' all_hybrid_seed_`cn' `cn'_farmer  
	ren ag3a_08_3 farmerid
	replace farmerid= ag3b_08_3 if farmerid==.		 
	tempfile farmer3
	save `farmer3'
	restore

	use   `farmer1', replace
	append using  `farmer2'
	append using  `farmer3'
	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (HHID farmerid)
	save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_improvedseed_use_temp_`cn'.dta", replace
}

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 HHID farmerid all_imprv_seed_use using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_improvedseed_use_temp_`v'.dta", nogen
}	 
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}
ren personid indidy4
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops
replace all_imprv_seed_cassav = . 
replace all_imprv_seed_banana = . 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_improvedseed_use.dta", replace
//IHS 10/11/19 END
*/

********************************************************************************
*REACHED BY AG EXTENSION // RH complete 10/27/21 
* QUESTION: is operation wealth creation unspecified, private or public?
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\Agric\agsec9b", clear // agsec9a and 9b
append using "${Uganda_NPS_w8_raw_data}\Agric\agsec9a"

/*Believe this file only includes hhs that received advice, no received advice var*/
**Government Extension
gen advice_gov = (source_ID==1) // "National Agricultural Advisory"
**Input Supplier
gen advice_input = (source_ID==2) // "input supplier"
**NGO
gen advice_ngo = (source_ID==3) // "ngo"
**Cooperative/ Farmer Association
gen advice_coop = (source_ID==4)  // "COOPERATIVE/FARMER'S ASSOCIATION"
**Large Scale Farmer
gen advice_farmer =(source_ID==5) // "LARGE SCALE FARMER"

**Other
gen advice_other = (source_ID==6) // "OTHER (SPECIFY)"

**Operation Wealth Creation
gen advice_OWC = (source_ID==7) // "OPERATION WEALTH CREATION"


**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified. "ext_reach_ict" not availabe in UGA w8 
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1| advice_input==1)
gen ext_reach_unspecified=( advice_other==1 | advice_OWC==1) //operation wealth creation here or public?
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_any_ext.dta", replace


********************************************************************************
* MOBILE OWNERSHIP * // RH complete 10/27/21
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec14.dta", clear

gen number_mobile_owned = h14q04 if h14q02 == 16
recode number_mobile_owned (.=0) 
gen mobile_owned = 1 if number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0

collapse (max) mobile_owned, by(hhid)
save "${Uganda_NPS_w8_created_data}\Uganda_NPS_w8_mobile_own.dta", replace 
 
//IHS 10/11/19 START
********************************************************************************
*USE OF FORMAL FINANCIAL SERVICES // RH complete 10/27/21 - check request for categories
********************************************************************************
//Household Questionnaire Section 13: Financial Services Use, is missing in W4, so can't construct this section
//For w8 also missing. Can it be constructed with a different file? 

/* possibilities
Sources of income, financial decisions - GSEC7_2.dta
Loans, credit and borrowing - GSEC7_4.dta */

/*use "${Uganda_NPS_w8_raw_data}/hh_sec_p.dta", clear
append using "${Uganda_NPS_w8_raw_data}/hh_sec_q1.dta" */

use "${Uganda_NPS_w8_raw_data}/HH/gsec7_4.dta", clear
append using "${Uganda_NPS_w8_raw_data}/HH/gsec7_1.dta"

//"Source of current loan/savings: ... "
/*Sources listed in dta file:
burial societies, commercial bank, ASCAs (accumulating savings and credit association - informal microfinance group) , MFIs (Microfinance Institutions), VSLAs (village savings and loan associations, standardized ASCAs), Mobile Money, Shop (?), Savings Club, Credit Institutions
ROSCAs (rotating savings and credit association - peer to peer banking and lending (is this microfinance?)) , MDI (Microfinance Deposit-accepting Institution), Welfare Fund, SACCOs (Savings and credit Cooperative Societies), investment club, NGOs, Others, None */

gen borrow_bank= CB16__1==1 // "commercial bank"; add credit institutions? (CB16__3) 
gen borrow_micro= CB16__11==1|CB16__12==1 |CB16__13==1|CB16__4==1|CB16__5==1 // MFIs, ASCAs, VSLAs, ROSCAs, MDI -- others?
*gen borrow_mortgage=hh_p03==3 // no mortgage?
*gen borrow_insurance=hh_p03==4 // no insurance?
gen borrow_other_fin=CB16__96==1 // "Others", add other institutions?
*gen borrow_neigh=hh_p03==6
*gen borrow_employer=hh_p03==9 (add shop..?)
gen borrow_credit= CB16__3==1 //"Credit institutions"
gen borrow_ngo=CB16__9==1 // "NGOs"
gen borrow_MM = CB16__14==1 // "Mobile Money"

//Not yet coded for: burial societies, Shop, Savings Club, Credit Institutions, Welfare Fund, Investment club, None

//Don't see a single bank question - using credit and saving instead
gen use_bank_acount=borrow_bank ==1| CB06B==1

//use any MM services
gen use_MM=borrow_MM==1| CB24A==1 | CB24B==1 | CB24C == 1 | CB24D == 1| CB24E == 1| CB24F==1 | CB24G == 1| CB24H == 1| CB24I ==1| CB24J==1| CB24K==1| CB24M==1| CB24X==1 | CB06E==1


gen use_fin_serv_bank= use_bank_acount==1
gen use_fin_serv_credit= /*borrow_mortgage==1 |*/ borrow_bank==1  | borrow_other_fin==1 | borrow_credit==1
*gen use_fin_serv_insur= borrow_insurance==1 //not in w8?
gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1 | CB06X == 1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | /*use_fin_serv_insur==1 |*/ use_fin_serv_digital==1 |  use_fin_serv_others==1  

recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)

lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
*lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fin_serv.dta", replace


************************************************************************
*MILK PRODUCTIVITY // RH Complete 1/5/21, not checked
************************************************************************
*Total production
** Adapted from Uga w3 code

use "${Uganda_NPS_w8_raw_data}/Agric/agsec8b.dta", clear
keep if AGroup_ID==101 | AGroup_ID==105
* SW We keep only large ruminants(exotic/cross & Indigenous)
*SW we remove outliers in variable a8bq1 (Do we keep outliers until winzorization?)
replace s8bq01=. if s8bq01>1000
gen milk_animals = s8bq01
*SW Not able to consider only Cow milk, it will consider all milk from large ruminants.
*gen days_milked = s8bq03 // per day per milked animal
*This won't consider HH that had large ruminant but did not used them to get milk.
gen months_milked = s8bq02 // number of months milked
gen days_milked= months_milked * 30.5 // no days milked, but can create est.
gen liters_day_perlargeruminant = s8bq03 // avg milk prod. per day per animal
gen liters_year_perlargeruminant = liters_day_perlargeruminant * days_milked // getting estimated total milk production over a year per animal. 
// Do we want total milk production too?
gen liters_year_tot = liters_year_perlargeruminant * milk_animals // total liters produced over a year
keep hhid milk_animals months_milked days_milked liters_year_perlargeruminant liters_day_perlargeruminant liters_year_tot
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day_perlargeruminant "Average milk production  (liters) per day per milked animal"
label variable liters_year_perlargeruminant "Average quantity (liters) per year per milked animal (household)"
label variable liters_year_tot "Average quantity (liters) per year (household)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_milk_animals.dta", replace
/*Notes: Not sure if it is possible to dissagregate this indicator by type of large ruminant(cows etc.). 


//w3 notes below: indicator mean liters_year_perlargeruminant = 1282 vs Tanzania wave 4 indicator is 1123.2  - similar*/
*SW Check for outliers in milk animals(a8bq1)

********************************************************************************
*EGG PRODUCTIVITY //RH complete 10/27 - request check. Do we want eggs per year if it's just multiplying eggs per 3mos by 4? (estimate, not measured total)
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6c", clear
egen poultry_owned = rowtotal(s6cq03a) if inlist(APCode,23,24,25,26)
collapse (sum) poultry_owned, by(hhid)
*gen len = length(hhid)
*summ len // 32


recast str32 hhid, force // converting from strL to STR# so we can use HHID as merge variable

tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_w8_raw_data}/Agric/agsec8c.dta", clear
recast str32 hhid, force // converting from strL to STR# so we can use HHID as merge variable
*keep if productid==1			
*gen eggs_months = 		
gen eggs_per_3months = s8cq02 // "How many eggs did you produce in the last 3 months"		
collapse (sum) eggs_per_3months, by(hhid)
gen eggs_total_year_est = eggs_per_3months*4 // we have eggs per 3 months but not months producing. Estimate of 3 months times 4, but assumes same rate of egg production throughout the year

merge 1:1 hhid using `eggs_animals_hh', nogen keep(1 3)			
keep hhid /*eggs_months*/ eggs_per_3months eggs_total_year_est poultry_owned 
*lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_3months "Number of months eggs that were produced per 3 months (household)"
lab var eggs_total_year_est "Estimated total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_eggs_animals.dta", replace


********************************************************************************
*LAND RENTAL  - not started
********************************************************************************
/*
* LRS *
use "${Uganda_NPS_w8_raw_data}/ag_sec_2a.dta", clear
drop if plotnum==""
gen plot_ha = ag2a_09/2.47105						
replace plot_ha = ag2a_04/2.47105 if plot_ha==.			
keep plot_ha plotnum HHID
ren plotnum plot_id
lab var plot_ha "Plot area in hectare" 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_lrs.dta", replace
*Getting plot rental rate
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
ren plotnum plot_id
merge 1:1 plot_id HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_lrs.dta" , nogen		
drop if plot_id==""
gen cultivated = ag3a_03==1
merge m:1 HHID plot_id using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", nogen keep (1 3)
tab ag3a_34_1 ag3a_34_2, nol
gen plot_rental_rate = ag3a_33*(12/ag3a_34_1) if ag3a_34_2==1		
replace plot_rental_rate = ag3a_33*(1/ag3a_34_1) if ag3a_34_2==2	
recode plot_rental_rate (0=.) 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", replace					

preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(HHID)
lab var value_rented_land_male "Value of rented land (male-managed plot)
lab var value_rented_land_female "Value of rented land (female-managed plot)
lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rental_rate_lrs.dta", replace
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0			
collapse (sum) plot_rental_rate plot_ha, by(HHID)		
gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				
keep ha_rental_hh_lrs HHID
lab var ha_rental_hh_lrs "Area of rented plot during the long run season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_hhid_lrs.dta", replace
restore

*Merging in geographic variables
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)	
*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_count_vil = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_rate_vil = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_vil if ha_rental_count_vil>=10		
replace ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a)
lab var ha_rental_rate "Land rental rate per ha"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_lrs.dta", replace

*  SRS  *
use "${Uganda_NPS_w8_raw_data}/ag_sec_2b.dta", clear
drop if plotnum==""
gen plot_ha = ag2b_20/2.47105						
replace plot_ha = ag2b_15/2.47105 if plot_ha==.		
keep plot_ha plotnum HHID
ren plotnum plot_id
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_srs.dta", replace
*Getting plot rental rate
use "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta", clear
drop if plotnum==""
gen cultivated = ag3b_03==1
ren  plotnum plot_id
merge m:1 HHID plot_id using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", nogen 
merge 1:1 plot_id HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_lrs.dta", nogen					
merge 1:1 plot_id HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_srs.dta", nogen update replace		
*Total rent - rescaling to a YEARLY value
tab ag3b_34_1 ag3b_34_2, nol					
gen plot_rental_rate = ag3b_33*(12/ag3b_34_1) if ag3b_34_2==1			
replace plot_rental_rate = ag3b_33*(1/ag3b_34_1) if ag3b_34_2==2		
recode plot_rental_rate (0=.) 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_srs.dta", replace
preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
lab var value_rented_land_male "Value of rented land (male-managed plot)
lab var value_rented_land_female "Value of rented land (female-managed plot)
lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)	
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(HHID)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rental_rate_srs.dta", replace
restore
gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0			
collapse (sum) plot_rental_rate plot_ha, by(HHID)		
gen ha_rental_hh_srs = plot_rental_rate/plot_ha				
keep ha_rental_hh_srs HHID
lab var ha_rental_hh_srs "Area of rented plot during the short run season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_hhid_srs.dta", replace
restore
*Merging in geographic variables
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)		
*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_count_vil = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen ha_rental_rate_vil = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys hh_a01_1 hh_a02_1: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys hh_a01_1: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_vil if ha_rental_count_vil>=10		
replace ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate_srs = ha_rental_rate, by(hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a)
lab var ha_rental_rate "Land rental rate per ha in the short run season"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_srs.dta", replace

*Now getting total ha of all plots that were cultivated at least once
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_srs.dta"
collapse (max) cultivated plot_ha, by(HHID plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = plot_ha if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(HHID)				// total ha of all plots that were cultivated in at least one season
lab var ha_cultivated_plots "Area of cultivated plots (ha)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cultivated_plots_ha.dta", replace

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rental_rate_lrs.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rental_rate_srs.dta"
collapse (sum) value_rented_land*, by(HHID)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rental_rate.dta", replace

*Now getting area planted
*  LRS  *
use "${Uganda_NPS_w8_raw_data}/ag_sec_4a.dta", clear
drop if plotnum==""
ren  plotnum plot_id
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*First rescaling
gen percent_plot = 0.25*(ag4a_02==1) + 0.5*(ag4a_02==2) + 0.75*(ag4a_02==3)
replace percent_plot = 1 if ag4a_01==1
bys HHID plot_id: egen total_percent_plot = total(percent_plot)		
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	
*Merging in total plot area from previous module
merge m:1 plot_id HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_lrs", nogen assert(2 3) keep(3)			
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)			
*Now merging in aggregate rental costs
merge m:1 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_lrs", nogen assert(2 3) keep(3)			
*Now merging in rental costs of individual plots
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_hhid_lrs.dta", nogen keep(1 3)
gen value_owned_land = ha_planted*ha_rental_rate if ag3a_33==0 | ag3a_33==.		
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.)		
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(HHID plot_id)			// summing ha_planted across crops on same plot
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed)"
lab var value_owned_land_female "Value of owned land (female-managed)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed)"
lab var ha_planted_female "Area planted (female-managed)"
lab var ha_planted_mixed "Area planted (mixed-managed)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_land_lrs.dta", replace

*  SRS  *
*Now getting area planted
use "${Uganda_NPS_w8_raw_data}/ag_sec_4b.dta", clear
drop if plotnum==""
ren plotnum plot_id 
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_srs.dta", nogen keep(1 3) keepusing(dm_gender) update
*First rescaling
gen percent_plot = 0.25*(ag4b_02==1) + 0.5*(ag4b_02==2) + 0.75*(ag4b_02==3)
replace percent_plot = 1 if ag4b_01==1
bys HHID plot_id: egen total_percent_plot = total(percent_plot)
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	
*3,044 changes (55 percent of observations)!
*Merging in total plot area
merge m:1 plot_id HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_lrs", nogen keep(1 3) keepusing(plot_ha)						
merge m:1 plot_id HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_area_srs", nogen keepusing(plot_ha) update							
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
*Merging in geographic variables
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)			
*Now merging in rental costs
merge m:1 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_lrs", nogen assert(2 3) keep(3)			
*Now merging in rental costs actually incurred by household
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_hhid_lrs.dta", nogen keep(1 3)		
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_rental_rate_hhid_srs.dta", nogen	update			
gen value_owned_land = ha_planted*ha_rental_rate if ag3a_33==0 | ag3a_33==.		
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.)		
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==1
replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==2
replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (ag3a_33==0 | ag3a_33==.) & dm_gender==3
replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(HHID plot_id)			
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_land_lrs.dta"						

preserve
collapse (sum) ha_planted*, by(HHID)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_ha_planted_total.dta", replace
restore
collapse (sum) ha_planted* value_owned_land*, by(HHID plot_id)			// taking max area planted (and value owned) by plot so as to not double count plots that were planted in both seasons
collapse (sum) ha_planted* value_owned_land*, by(HHID)					// now summing to household
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_land.dta", replace



********************************************************************************
*INPUT COST * - not started
********************************************************************************
*  LRS  *
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
drop if plotnum==""			
*Merging in geographic variables first (for constructing prices)
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)		
*Gender variables
ren  plotnum plot_id
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
egen value_inorg_fert_lrs = rowtotal(ag3a_51 ag3a_58)			
egen value_herb_pest_lrs = rowtotal(ag3a_63 ag3a_65c)			
gen value_org_purchased_lrs = ag3a_45						

preserve
gen fert_org_kg = ag3a_42		
egen fert_inorg_kg = rowtotal(ag3a_49 ag3a_56)		
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
collapse (sum) fert_org_kg fert_inorg_kg*, by(HHID)
lab var fert_org_kg "Organic fertilizer (kgs)"
lab var fert_inorg_kg "Inorganic fertilizer (kgs)"	
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed crops"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed crops"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed crops"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_fert_lrs.dta", replace
restore

recode ag3a_42 ag3a_44 (.=0)						
gen org_fert_notpurchased = ag3a_42-ag3a_44			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = ag3a_44					
gen org_fert_price = ag3a_45/org_fert_purchased		
recode org_fert_price (0=.) 

*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		
collapse (sum) org_fert_purchased ag3a_45, by(HHID)		
gen org_fert_price_hh = ag3a_45/org_fert_purchased
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_org_fert_lrs.dta", replace
restore
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_org_fert_lrs.dta", nogen

*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_count_vil = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_vil = median(org_fert_price) 
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_count_ward = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_ward = median(org_fert_price) 
bys hh_a01_1 hh_a02_1: egen org_price_count_dist = count(org_fert_price)
bys hh_a01_1 hh_a02_1: egen org_price_dist = median(org_fert_price) 
bys hh_a01_1: egen org_price_count_reg = count(org_fert_price)
bys hh_a01_1: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_vil if org_price_count_vil>=10
replace org_fert_price = org_price_ward if org_price_count_ward>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		
gen value_org_notpurchased_lrs = org_fert_price*org_fert_notpurchased						
*Hired labor
egen prep_labor = rowtotal(ag3a_74_1 ag3a_74_2 ag3a_74_3)		
egen weed_labor = rowtotal(ag3a_74_5 ag3a_74_6 ag3a_74_7)		
egen harv_labor = rowtotal(ag3a_74_13 ag3a_74_14 ag3a_74_15)	
*Hired wages:
gen prep_wage = ag3a_74_4/prep_labor
gen weed_wage = ag3a_74_8/weed_labor
gen harv_wage = ag3a_74_16/harv_labor
*Hired costs
gen prep_labor_costs = ag3a_74_4
gen weed_labor_costs = ag3a_74_8
gen harv_labor_costs = ag3a_74_16
egen value_hired_labor_prep_lrs = rowtotal(*_labor_costs)
*Constructing a household-specific wage
preserve
collapse (sum) prep_labor weed_labor harv_labor *labor_costs, by(HHID)		
gen prep_wage_hh = prep_labor_costs/prep_labor									
gen weed_wage_hh = weed_labor_costs/weed_labor
gen harv_wage_hh = harv_labor_costs/harv_labor
recode *wage* (0=.)			
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_hh_lrs.dta", replace
restore
*Merging right back in
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_hh_lrs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed harv{
	recode `i'_wage (0=.) 
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_count_vil = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_price_vil = median(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_count_ward = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_price_ward = median(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_count_dist = count(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_price_dist = median(`i'_wage)
	bys hh_a01_1: egen `i'_wage_count_reg = count(`i'_wage)
	bys hh_a01_1: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_vil if `i'_wage_count_vil>=10
	replace `i'_wage_rate = `i'_wage_price_ward if `i'_wage_count_ward>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}

*prep
egen prep_fam_labor_tot = rowtotal(ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ag3a_72_5 ag3a_72_6)
*weed
egen weed_fam_labor_tot = rowtotal(ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ag3a_72_11 ag3a_72_12)
*prep
egen harv_fam_labor_tot = rowtotal(ag3a_72_13 ag3a_72_14 ag3a_72_15 ag3a_72_16 ag3a_72_17 ag3a_72_18)
*Generating family values for each activity
gen fam_prep_val = prep_fam_labor_tot*prep_wage_rate											
replace fam_prep_val = prep_fam_labor_tot*prep_wage_hh if prep_wage_hh!=0 & prep_wage_hh!=.		
gen fam_weed_val = weed_fam_labor_tot*weed_wage_rate
replace fam_weed_val = weed_fam_labor_tot*weed_wage_hh if weed_wage_hh!=0 & weed_wage_hh!=.
gen fam_harv_val = harv_fam_labor_tot*harv_wage_rate
replace fam_harv_val = harv_fam_labor_tot*harv_wage_hh if harv_wage_hh!=0 & harv_wage_hh!=.
*Summing at the plot level
egen value_fam_labor_lrs = rowtotal(fam_prep_val fam_weed_val fam_harv_val)
*Renaming (dropping lrs)
ren *_lrs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor_prep value_fam_labor{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(HHID)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_lrs.dta", replace


*  SRS  *
use "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta", clear
drop if plotnum==""			
*Merging in geographic variables first (for constructing prices)
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)		
*Gender variables
ren plotnum plot_id
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
egen value_inorg_fert_srs = rowtotal(ag3b_51 ag3b_58)
egen value_herb_pest_srs = rowtotal(ag3b_63 ag3b_65c)
gen value_org_purchased_srs = ag3b_45
preserve
gen fert_org_kg = ag3b_42
egen fert_inorg_kg = rowtotal(ag3b_49 ag3b_56)
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
collapse (sum) fert_org_kg fert_inorg_kg*, by(HHID)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_fert_srs.dta", replace
restore
recode ag3b_42 ag3b_44 (.=0)
gen org_fert_notpurchased = ag3b_42-ag3b_44			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = ag3b_44					
gen org_fert_price = ag3b_45/org_fert_purchased		
recode org_fert_price (0=.)

*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		
collapse (sum) org_fert_purchased ag3b_45, by(HHID)		
gen org_fert_price_hh = ag3b_45/org_fert_purchased
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_org_fert_srs.dta", replace
restore
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_org_fert_srs.dta", nogen
*Geographic medians
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_count_vil = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen org_price_vil = median(org_fert_price) 
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_count_ward = count(org_fert_price)
bys hh_a01_1 hh_a02_1 hh_a03_1: egen org_price_ward = median(org_fert_price) 
bys hh_a01_1 hh_a02_1: egen org_price_count_dist = count(org_fert_price)
bys hh_a01_1 hh_a02_1: egen org_price_dist = median(org_fert_price) 
bys hh_a01_1: egen org_price_count_reg = count(org_fert_price)
bys hh_a01_1: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_vil if org_price_count_vil>=10
replace org_fert_price = org_price_ward if org_price_count_ward>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		
gen value_org_notpurchased_srs = org_fert_price*org_fert_notpurchased						
*Hired labor
egen prep_labor = rowtotal(ag3b_74_1 ag3b_74_2 ag3b_74_3)		
egen weed_labor = rowtotal(ag3b_74_5 ag3b_74_6 ag3b_74_7)		
egen harv_labor = rowtotal(ag3b_74_13 ag3b_74_14 ag3b_74_15)	
*Hired wages:
gen prep_wage = ag3b_74_4/prep_labor
gen weed_wage = ag3b_74_8/weed_labor
gen harv_wage = ag3b_74_16/harv_labor
*Hired costs
gen prep_labor_costs = prep_labor*prep_wage
gen weed_labor_costs = weed_labor*weed_wage
gen harv_labor_costs = harv_labor*harv_wage
egen value_hired_labor_prep_srs = rowtotal(*_labor_costs)

*Constructing a household-specific wage
preserve
collapse (sum) prep_labor weed_labor harv_labor *labor_costs, by(HHID)
gen prep_wage_hh = prep_labor_costs/prep_labor			
gen weed_wage_hh = weed_labor_costs/weed_labor
gen harv_wage_hh = harv_labor_costs/harv_labor
recode *wage* (0=.)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_hh_srs.dta", replace
restore
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_hh_srs.dta", nogen
*construct wages separately for each type
*Constructing for each labor type
foreach i in prep weed harv{
	recode `i'_wage (0=.) 
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_count_vil = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen `i'_wage_price_vil = median(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_count_ward = count(`i'_wage)
	bys hh_a01_1 hh_a02_1 hh_a03_1: egen `i'_wage_price_ward = median(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_count_dist = count(`i'_wage)
	bys hh_a01_1 hh_a02_1: egen `i'_wage_price_dist = median(`i'_wage)
	bys hh_a01_1: egen `i'_wage_count_reg = count(`i'_wage)
	bys hh_a01_1: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_vil if `i'_wage_count_vil>=10
	replace `i'_wage_rate = `i'_wage_price_ward if `i'_wage_count_ward>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}
*prep
egen prep_fam_labor_tot = rowtotal(ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ag3b_72_6)
*weed
egen weed_fam_labor_tot = rowtotal(ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12)
*prep
egen harv_fam_labor_tot = rowtotal(ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18)
*Generating family values for each activity
gen fam_prep_val = prep_fam_labor_tot*prep_wage_rate										
replace fam_prep_val = prep_fam_labor_tot*prep_wage_hh if prep_wage_hh!=0 & prep_wage_hh!=.		
gen fam_weed_val = weed_fam_labor_tot*weed_wage_rate
replace fam_weed_val = weed_fam_labor_tot*weed_wage_hh if weed_wage_hh!=0 & weed_wage_hh!=.
gen fam_harv_val = harv_fam_labor_tot*harv_wage_rate
replace fam_harv_val = harv_fam_labor_tot*harv_wage_hh if harv_wage_hh!=0 & harv_wage_hh!=.
egen value_fam_labor_srs = rowtotal(fam_prep_val fam_weed_val fam_harv_val)
ren *_srs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor_prep value_fam_labor{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(HHID)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_srs.dta", replace

use  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_lrs.dta", clear
append using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_srs.dta"
collapse (sum) value_*, by(HHID)
foreach v of varlist *prep*  {
	local l`v' = subinstr("`v'","_prep","",1)
	ren `v' `l`v''
}


********************************************************************************
* SEED COST * - not started
********************************************************************************
*  LRS  *
use "${Uganda_NPS_w8_raw_data}/ag_sec_4a.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
tab ag4a_10_2 ag4a_10c_2		

gen seeds_not_purchased = ag4a_10_1 - ag4a_10c_1					
replace seeds_not_purchased = 0 if seeds_not_purchased<0			
replace seeds_not_purchased = ag4a_10_1 if seeds_not_purchased==.	
gen seeds_purchased = ag4a_10c_1									
gen seed_price_hh = ag4a_12/ag4a_10c_1			
recode seed_price_hh (0=.) 
*Household-specific values
preserve
drop if ag4a_12==0 | ag4a_12==.				
collapse (sum) ag4a_12 ag4a_10c_1, by(HHID zaocode)
gen seed_price_hh_crop = ag4a_12/ag4a_10c_1
recode seed_price_hh_crop (0=.) 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_seeds_hh_lrs.dta", replace
restore
merge m:1 HHID zaocode using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_seeds_hh_lrs.dta", nogen

*Geographically
*Merging in geographic variables first
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_count_vil = count(seed_price_hh)		
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_price_vil = median(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_count_ward = count(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_price_ward = median(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1: egen seed_count_dist = count(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1 hh_a02_1: egen seed_price_dist = median(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1: egen seed_count_reg = count(seed_price_hh)
bys zaocode ag4a_10_2 hh_a01_1: egen seed_price_reg = median(seed_price_hh)
bys zaocode ag4a_10_2: egen seed_price_nat = median(seed_price_hh)
gen seed_price = seed_price_vil if seed_count_vil>=10
replace seed_price = seed_price_ward if seed_count_ward>=10 & seed_price==.
replace seed_price = seed_price_dist if seed_count_dist>=10 & seed_price==.
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.			
gen value_seeds_not_purchased_lrs = seeds_not_purchased*seed_price			
replace value_seeds_not_purchased_lrs = seeds_not_purchased*seed_price_hh_crop if seed_price_hh_crop!=. & seed_price_hh_crop!=0			
gen value_seeds_purchased_lrs = ag4a_12
ren *_lrs *
foreach i in value_seeds_purchased value_seeds_not_purchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_* , by(HHID)
sum value_seeds_purchased, d
sum value_seeds_not_purchased, d
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_seed_lrs.dta", replace

 
*  SRS  *
use "${Uganda_NPS_w8_raw_data}/ag_sec_4b.dta", clear
drop if plotnum==""
ren plotnum plot_id
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)		
gen seeds_not_purchased = ag4b_10_1 - ag4b_10c_1				
replace seeds_not_purchased = 0 if seeds_not_purchased<0			
replace seeds_not_purchased = ag4b_10_1 if seeds_not_purchased==.	
gen seeds_purchased = ag4b_10c_1									
gen seed_price_hh = ag4b_12/ag4b_10c_1			
*Household-specific values
preserve
drop if ag4b_12==0 | ag4b_12==.				
collapse (sum) ag4b_12 ag4b_10c_1, by(HHID zaocode)
gen seed_price_hh_crop = ag4b_12/ag4b_10c_1
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_seeds_hh_srs.dta", replace
restore
merge m:1 HHID zaocode using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_seeds_hh_srs.dta", nogen
*Geographically
*Merging in geographic variables first
merge m:1 HHID using "${Uganda_NPS_w8_raw_data}/hh_sec_a.dta", nogen assert(2 3) keep(3)
recode seed_price_hh (0=.)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_count_vil = count(seed_price_hh)		
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1 hh_a03_3a: egen seed_price_vil = median(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_count_ward = count(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1 hh_a03_1: egen seed_price_ward = median(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1: egen seed_count_dist = count(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1 hh_a02_1: egen seed_price_dist = median(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1: egen seed_count_reg = count(seed_price_hh)
bys zaocode ag4b_10_2 hh_a01_1: egen seed_price_reg = median(seed_price_hh)
bys zaocode ag4b_10_2: egen seed_price_nat = median(seed_price_hh)
gen seed_price = seed_price_vil if seed_count_vil>=10
replace seed_price = seed_price_ward if seed_count_ward>=10 & seed_price==.
replace seed_price = seed_price_dist if seed_count_dist>=10 & seed_price==.
replace seed_price = seed_price_reg if seed_count_reg>=10 & seed_price==.
replace seed_price = seed_price_nat if seed_price==.
gen value_seeds_not_purchased_srs = seeds_not_purchased*seed_price		
replace value_seeds_not_purchased_srs = seeds_not_purchased*seed_price_hh_crop if seed_price_hh_crop!=. & seed_price_hh_crop!=0			
gen value_seeds_purchased_srs = ag4b_12
ren *_srs *
foreach i in value_seeds_purchased value_seeds_not_purchased{
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_* , by(HHID)
sum value_seeds_purchased, d
sum value_seeds_not_purchased, d
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_seed_srs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${Uganda_NPS_w8_raw_data}/ag_sec_11.dta", clear
gen animal_traction = (itemid>=3 & itemid<=5)
gen ag_asset = (itemid<3 | itemid>8)
gen tractor = (itemid>=6 & itemid<=8)
ren ag11_09 rental_cost
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (HHID)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
egen value_ag_rentals = rowtotal(rental_cost_*)
lab var value_ag_rentals "Value of rented equipment (household level"
 save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_asset_rental_costs.dta", replace

* merging cost variable together
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_land.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_rental_rate.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_lrs.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_inputs_srs.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_seed_lrs.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_seed_srs.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_asset_rental_costs.dta"
collapse (sum) value_* ha_planted*, by(HHID)
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var value_rented_land "Value of rented land that was cultivated (household)"
lab var value_rented_land_male "Value of rented land (male-managed plots)"
lab var value_rented_land_female "Value of rented land (female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
lab var value_seeds_not_purchased "Value of seeds not purchased (household)"
lab var value_seeds_not_purchased_male "Value of seeds not purchased (male-managed plots)"
lab var value_seeds_not_purchased_female "Value of seeds not purchased (female-managed plots)"
lab var value_seeds_not_purchased_mixed "Value of seeds not purchased (mixed-managed plots)"
lab var value_seeds_purchased "Value of seeds purchased (household)"
lab var value_seeds_purchased_male "Value of seeds purchased (male-managed plots)"
lab var value_seeds_purchased_female "Value of seeds purchased (female-managed plots)"
lab var value_seeds_purchased_mixed "Value of seeds purchased (mixed-managed plots)"
lab var value_herb_pest "Value of herbicide_pesticide (household)"
lab var value_herb_pest_male "Value of herbicide_pesticide (male-managed plots)"
lab var value_herb_pest_female "Value of herbicide_pesticide (female-managed plots)"
lab var value_herb_pest_mixed "Value of herbicide_pesticide (mixed-managed plots)"
lab var value_inorg_fert "Value of inorganic fertilizer (household)"
lab var value_inorg_fert_male "Value of inorganic fertilizer (male-managed plots)"
lab var value_inorg_fert_female "Value of inorganic fertilizer female-managed plots)"
lab var value_inorg_fert_mixed "Value of inorganic fertilizer (mixed-managed plots)"
lab var value_org_purchased "Value organic fertilizer purchased (household)"
lab var value_org_purchased_male "Value organic fertilizer purchased (male-managed plots)"
lab var value_org_purchased_female "Value organic fertilizer purchased (female-managed plots)"
lab var value_org_purchased_mixed "Value organic fertilizer purchased (mixed-managed plots)"
lab var value_org_notpurchased "Value organic fertilizer not purchased (household)"
lab var value_org_notpurchased_male "Value organic fertilizer not purchased (male-managed plots)"
lab var value_org_notpurchased_female "Value organic fertilizer not purchased (female-managed plots)"
lab var value_org_notpurchased_mixed "Value organic fertilizer not purchased (mixed-managed plots)"
foreach v of varlist *prep*  {
	local l`v' = subinstr("`v'","_prep","",1)
	ren `v' `l`v''
}
lab var value_hired_labor "Value of hired labor (household)"
lab var value_hired_labor_male "Value of hired labor (male-managed crops)"
lab var value_hired_labor_female "Value of hired labor (female-managed crops)"
lab var value_hired_labor_mixed "Value of hired labor (mixed-managed crops)"
lab var value_fam_labor "Value of family labor (household)"
lab var value_fam_labor_male "Value of family labor (male-managed crops)"
lab var value_fam_labor_female "Value of family labor (female-managed crops)"
lab var value_fam_labor_mixed "Value of family labor (mixed-managed crops)"
lab var value_ag_rentals "Value of rented equipment (household level"
recode ha_planted* (0=.)
*Explicit and implicit costs at the plot level
egen cost_total =rowtotal(value_owned_land value_rented_land value_inorg_fert value_herb_pest value_org_purchased ///
	value_org_notpurchased value_hired_labor value_fam_labor value_seeds_not_purchased value_seeds_purchased)
lab var cost_total "Explicit + implicit costs of crop production (plot level)" 
*Creating total costs by gender (NOTE: excludes ag_rentals because those are at the household level)
foreach i in male female mixed{
	egen cost_total_`i' = rowtotal(value_owned_land_`i' value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' ///
	value_org_notpurchased_`i' value_hired_labor_`i' value_fam_labor_`i' value_seeds_not_purchased_`i' value_seeds_purchased_`i')
}
lab var cost_total_male "Explicit + implicit costs of crop production (male-managed plots)" 
lab var cost_total_female "Explicit + implicit costs of crop production (female-managed plots)"
lab var cost_total_mixed "Explicit + implicit costs of crop production (mixed-managed plots)"
*Explicit costs at the plot level 
egen cost_expli =rowtotal(value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
lab var cost_expli "Explicit costs of crop production (plot level)" 
*Creating explicit costs by gender
foreach i in male female mixed{
	egen cost_expli_`i' = rowtotal( value_rented_land_`i' value_inorg_fert_`i' value_herb_pest_`i' value_org_purchased_`i' value_hired_labor_`i' value_seeds_purchased_`i')
}
lab var cost_expli_male "Explicit costs of crop production (male-managed plots)" 
lab var cost_expli_female "Explicit costs of crop production (female-managed plots)" 
lab var cost_expli_mixed "Explicit costs of crop production (mixed-managed plots)" 
*Explicit costs at the household level
egen cost_expli_hh = rowtotal(value_ag_rentals value_rented_land value_inorg_fert value_herb_pest value_org_purchased value_hired_labor value_seeds_purchased)
lab var cost_expli_hh "Total explicit crop production (household level)" 
count if cost_expli_hh==0
*Recoding zeros as missings
recode cost_total* (0=.)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_cropcosts_total.dta", replace
//IHS 10/11/19 END


********************************************************************************
*AGRICULTURAL WAGES - not started
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta"
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode ag3a_74_* ag3a_74_* (0=.)
ren ag3a_74_2 hired_male_lanprep
replace hired_male_lanprep = ag3b_74_2 if hired_male_lanprep==.
ren ag3a_74_1 hired_female_lanprep
replace hired_female_lanprep = ag3b_74_1 if hired_female_lanprep==.
ren ag3a_74_4 hlabor_paid_lanprep
replace hlabor_paid_lanprep = ag3b_74_4 if hlabor_paid_lanprep==.
ren ag3a_74_5 hired_male_weedingothers
replace hired_male_weedingothers = ag3b_74_5 if hired_male_weedingothers==.
ren ag3a_74_6 hired_female_weedingothers
replace hired_female_weedingothers = ag3b_74_6 if hired_female_weedingothers==.
ren ag3a_74_8 hlabor_paid_weedingothers
replace hlabor_paid_weedingothers = ag3b_74_8 if hlabor_paid_weedingothers==.
ren ag3a_74_14 hired_male_harvest
replace hired_male_harvest = ag3b_74_14 if hired_male_harvest==.
ren ag3a_74_13 hired_female_harvest
replace hired_female_harvest = ag3b_74_13 if hired_female_harvest==.
ren ag3a_74_16 hlabor_paid_harvest
replace hlabor_paid_harvest = ag3b_74_16 if hlabor_paid_harvest==.
recode hired* hlabor* (.=0)
*first collapse accross plot  to houshold level
collapse (sum) hired* hlabor*, by(HHID)
gen hirelabor_lanprep=(hired_male_lanprep+hired_female_lanprep)
gen wage_lanprep=hlabor_paid_lanprep/hirelabor_lanprep
gen hirelabor_weedingothers=(hired_male_weedingothers+hired_female_weedingothers)
gen wage_weedingothers=hlabor_paid_weedingothers/hirelabor_weedingothers
gen hirelabor_harvest=(hired_male_harvest+hired_female_harvest)
gen wage_harvest=hlabor_paid_harvest/hirelabor_harvest
recode wage_lanprep hirelabor_lanprep wage_weedingothers hirelabor_weedingothers  wage_harvest hirelabor_harvest (.=0)
* get weighted average average accross group of activities to get paid wage at household level
gen wage_paid_aglabor=(wage_lanprep*hirelabor_lanprep+wage_weedingothers*hirelabor_weedingothers+wage_harvest*hirelabor_harvest)/ (hirelabor_lanprep+hirelabor_harvest+hirelabor_harvest)
*later will use hired_labor*weight for the summary stats on wage 
keep HHID wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_ag_wage.dta", replace

//IHS 10/11/19 START

********************************************************************************
*RATE OF FERTILIZER APPLICATION - not started
********************************************************************************
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_cost_land.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_fert_lrs.dta"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(HHID)
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", keep (1 3) nogen
drop ha_planted*
lab var fert_inorg_kg "Quantity of fertilizer applied (kgs) (household level)"
lab var fert_inorg_kg_male "Quantity of fertilizer applied (kgs) (male-managed plots)"
lab var fert_inorg_kg_female "Quantity of fertilizer applied (kgs) (female-managed plots)"
lab var fert_inorg_kg_mixed "Quantity of fertilizer applied (kgs) (mixed-managed plots)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fertilizer_application.dta", replace


********************************************************************************
*WOMEN'S DIET QUALITY - not started
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
* TZA LSMS 4 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of householdd eating nutritious food can be estimated
use "${Uganda_NPS_w8_raw_data}/hh_sec_j1.dta" , clear
* recode food items to map HDDS food categories
recode itemcode 	(101/112 1081 1082 				=1	"CEREALS" )  //// 
					(201/207    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(602 601 603	 				=3	"VEGETABLES"	)  ////	
					(703 701 702					=4	"FRUITS"	)  ////	
					(801/806 						=5	"MEAT"	)  ////					
					(807							=6	"EGGS"	)  ////
					(808/810 						=7  "FISH") ///
					(401  501/504					=8	"LEGUMES, NUTS AND SEEDS") ///
					(901/903						=9	"MILK AND MILK PRODUCTS")  ////
					(1001 1002   					=10	"OILS AND FATS"	)  ////
					(301/303 704 1104 				=11	"SWEETS"	)  //// 
					(1003 1004 1101/1103 1105/1108 =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)		
gen adiet_yes=(hh_j01==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(HHID   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(HHID )
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_household_diet.dta", replace
 
*/
 
********************************************************************************
*WOMEN'S CONTROL OVER INCOME - not started
********************************************************************************
/*
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Inmost cases, TZA LSMS 4 lsit the first TWO decision makers.
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
use "${Uganda_NPS_w8_raw_data}/AGSEC5A", clear   	// use of crop sales earnings
append using "${Uganda_NPS_w8_raw_data}/AGSEC5B" 	// use of crop sales earnings
append using "${Uganda_NPS_w8_raw_data}/AGSEC6A" 	//owns cattle & pack animals
append using "${Uganda_NPS_w8_raw_data}/AGSEC6B" 	//owns small animals
append using "${Uganda_NPS_w8_raw_data}/AGSEC6C" 	//owns poultry
append using "${Uganda_NPS_w8_raw_data}/AGSEC8A" 	// meat production - who controls the revenue
append using "${Uganda_NPS_w8_raw_data}/AGSEC8B" 	// milk production - who controls the revenue
append using "${Uganda_NPS_w8_raw_data}/AGSEC8C" 	// egg production - who controls the revenue
ren HHID hhid
append using "${Uganda_NPS_w8_raw_data}/gsec8"	// wage control for last 7 days? (31D 31E and 45D 45E for secondary) for last 12 months (53D 53E and 58D 58E for secondary job)
append using "${Uganda_NPS_w8_raw_data}/gsec11_2" //other hh income who controls 6a and 6b
//append using "${UGA_W4_raw_data}/GSEC11B" //other hh income who controls 6a and 6b
// MEK: I don't think that W5 has a second dataset of this kind.
append using "${Uganda_NPS_w8_raw_data}/gsec12_2" //Non-Agricultural Household Enterprises/Activities - who decides on earning use 8a 8b
ren hhid HHID 

gen type_decision="" 
gen controller_income1=.
gen controller_income2=. 


* Control Over Harvest from Crops *
replace type_decision="control_harvest" if  !inlist(a5aq6a_2, .,0,99) |  !inlist(a5aq6a_3, .,0,99) |  !inlist(a5aq6a_4, .,0,99) // first cropping season
replace controller_income1=a5aq6a_2 if !inlist(a5aq6a_2, .,0,99) // primary controller
replace controller_income2=a5aq6a_3 if !inlist(a5aq6a_3, .,0,99) // 2 controllers, first listed
replace controller_income2=a5aq6a_4 if controller_income2==. & !inlist(a5aq6a_4, .,0,99) // 2 controllers, second listed

replace type_decision="control_harvest" if  !inlist(a5bq6a_2, .,0,99) |  !inlist(a5bq6a_3, .,0,99) |  !inlist(a5bq6a_4, .,0,99) // second cropping season
replace controller_income1=a5bq6a_2 if !inlist(a5bq6a_2, .,0,99) // primary controller
replace controller_income2=a5bq6a_3 if !inlist(a5bq6a_3, .,0,99) // 2 controllers, first listed
replace controller_income2=a5bq6a_4 if controller_income2==. & !inlist(a5bq6a_4, .,0,99) // 2 controllers, second listed

* Control Over Sales Income *
replace type_decision="control_sales" if  !inlist(a5aq11f, .,0,99) |  !inlist(a5aq11g, .,0,99) |  !inlist(a5aq11h, .,0,99) // first cropping season
replace controller_income1=a5aq11f if !inlist(a5aq11f, .,0,99)  
replace controller_income2=a5aq11g if !inlist(a5aq11g, .,0,99)
replace controller_income2=a5aq11h if controller_income2==. & !inlist(a5aq11h, .,0,99)
replace type_decision="control_sales" if  !inlist(a5bq11f, .,0,99) |  !inlist(a5bq11g, .,0,99) |  !inlist(a5bq11h, .,0,99) // second cropping season
replace controller_income1=a5bq11f if !inlist(a5bq11f, .,0,99)  
replace controller_income2=a5bq11g if !inlist(a5bq11g, .,0,99)
replace controller_income2=a5bq11h if controller_income2==. & !inlist(a5bq11h, .,0,99)

* Control Over Income from Slaughtered Livestock Sales * 			// NKF 12.19.19 no information available for live sales
replace type_decision="control_livestocksales" if  !inlist(a8aq6a, .,0,99) |  !inlist(a8aq6b, .,0,99) 
replace controller_income1=a8aq6a if !inlist(a8aq6a, .,0,99)  
replace controller_income2=a8aq6b if !inlist(a8aq6b, .,0,99)

* Control Over Income from Milk Sales *
replace type_decision="control_milksales" if  !inlist(a8bq10a, .,0,99) |  !inlist(a8bq10b, .,0,99) 
replace controller_income1=a8bq10a if !inlist(a8bq10a, .,0,99)  
replace controller_income2=a8bq10b if !inlist(a8bq10b, .,0,99)

* Control Over Income from Other Livestock Sales *
replace type_decision="control_otherlivestock_sales" if  !inlist(a8cq6a, .,0,99) |  !inlist(a8cq6b, .,0,99) 
replace controller_income1=a8cq6a if !inlist(a8cq6a, .,0,99)  
replace controller_income2=a8cq6a if !inlist(a8cq6b, .,0,99)

* Fish Production Income *
//Fish production not included in UGA LSMS W5

* Business Income *
replace type_decision="control_businessincome" if  !inlist(h12q8a, .,0,99) | !inlist(h12q8b, .,0,99) 
replace controller_income1=h12q8a if !inlist(h12q8a, .,0,99)  
replace controller_income2=h12q8b if !inlist(h12q8b, .,0,99)

// wage control for last for last 12 months (53D 53E and 58D 58E for secondary job)

* Wage Income *
// NKF 12.20.19 Even though there is a question in the instrument about control of income for primary job, those variables do not appear in the dta file (gsec8 h8q53d h8q53e)
// Below, we only use the variables for control of income for secondary job (gsec h8q58D  h8q58E)
replace type_decision="control_wageincome" if !inlist(h8q58D, .,0,99) | !inlist(h8q58E, .,0,99) //using question regardinhg wages over last 12 months, not last 7 days
replace controller_income1=h8q58D if !inlist(h8q58D, .,0,99)  
replace controller_income2=h8q58E if !inlist(h8q58E, .,0,99)

* Control Over Remittances
//MEK verify that this is how this should be done. Compare to W4 dta files, beca
//use NFK found that some data in W4 were missing, but seem to have what we need
//in W5?
replace type_decision="control_remittance" if s11q3 == 42 | s11q3 == 43 //MEK: 
//does this seem right?
replace controller_income1= s11q6a if !inlist(s11q6a, .,0,99)  
replace controller_income2=s11q6b if !inlist(s11q6b, .,0,99)

* Append Control Over In-Kind Remittances *
// Not included in this instrument as distinct from regular remittances

* Control Over Assistance Income
//MEK verify that this is how this should be done. Compare to W4 dta files, beca
//use NFK found that some data in W4 were missing, but seem to have what we need
//in W5?
replace type_decision="control_assistance" if s11q3 == 41 //MEK: does this seem right?
replace controller_income1= s11q6a if !inlist(s11q6a, .,0,99)  
replace controller_income2=s11q6b if !inlist(s11q6b, .,0,99)

keep hhid type_decision controller_income1 controller_income2
rename hhid HHID

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

/// NKF 12.20.19 WHY DOESN'T WAGE INCOME APPEAR IN THE SECTON BELOW?????


* create group
gen control_cropincome=1 if  type_decision=="control_harvest" ///
							| type_decision=="control_sales"
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
																
collapse (max) control_* , by(HHID controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
//MEK: Why is this not control_farmincome== 1 & control_nonfarmincome==1 (to get
// total)?
recode 	control_all_income (.=0)															
ren controller_income indiv

*Now merge with member characteristics
merge 1:1 HHID indiv using  "${UGA_w8_created_data}/Uganda_NPS_LSMS_ISA_w8_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
xxxxxx



* control of harvest from annual crops
replace type_decision="control_annualharvest" if  !inlist( ag4a_30_1, .,0,99) |  !inlist( ag4a_30_2, .,0,99) 
replace controller_income1=ag4a_30_1 if !inlist( ag4a_30_1, .,0,99)  
replace controller_income2=ag4a_30_2 if !inlist( ag4a_30_2, .,0,99)
replace type_decision="control_annualharvest" if  !inlist( ag4b_30_1, .,0,99) |  !inlist( ag4b_30_2, .,0,99) 
replace controller_income1=ag4b_30_1 if !inlist( ag4b_30_1, .,0,99)  
replace controller_income2=ag4b_30_2 if !inlist( ag4b_30_2, .,0,99)
* control of harvest from permanent crops
replace type_decision="control_permharvest" if  !inlist( ag6a_08_1, .,0,99) |  !inlist( ag6a_08_2, .,0,99) 
replace controller_income1=ag6a_08_1 if !inlist( ag6a_08_1, .,0,99)  
replace controller_income2=ag6a_08_2 if !inlist( ag6a_08_2, .,0,99)
replace type_decision="control_permharvest" if  !inlist( ag6b_08_1, .,0,99) |  !inlist( ag6b_08_2, .,0,99) 
replace controller_income1=ag6b_08_1 if !inlist( ag6b_08_1, .,0,99)  
replace controller_income2=ag6b_08_2 if !inlist( ag6b_08_2, .,0,99)
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( ag5a_10_1, .,0,99) |  !inlist( ag5a_10_2, .,0,99) 
replace controller_income1=ag5a_10_1 if !inlist( ag5a_10_1, .,0,99)  
replace controller_income2=ag5a_10_2 if !inlist( ag5a_10_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_10_1, .,0,99) |  !inlist( ag5b_10_2, .,0,99) 
replace controller_income1=ag5b_10_1 if !inlist( ag5b_10_1, .,0,99)  
replace controller_income2=ag5b_10_2 if !inlist( ag5b_10_2, .,0,99)
* append who controle earning from sale to customer 2
preserve
replace type_decision="control_annualsales" if  !inlist( ag5a_17_1, .,0,99) |  !inlist( ag5a_17_2, .,0,99) 
replace controller_income1=ag5a_17_1 if !inlist( ag5a_17_1, .,0,99)  
replace controller_income2=ag5a_17_2 if !inlist( ag5a_17_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_17_1, .,0,99) |  !inlist( ag5b_17_2, .,0,99) 
replace controller_income1=ag5b_17_1 if !inlist( ag5b_17_1, .,0,99)  
replace controller_income2=ag5b_17_2 if !inlist( ag5b_17_2, .,0,99)
keep if !inlist( ag5a_17_1, .,0,99) |  !inlist( ag5a_17_2, .,0,99)  | !inlist( ag5b_17_1, .,0,99) |  !inlist( ag5b_17_2, .,0,99) 
keep HHID type_decision controller_income1 controller_income2
tempfile saletocustomer2
save `saletocustomer2'
restore
append using `saletocustomer2'  
* control_permsales
replace type_decision="control_permsales" if  !inlist( ag7a_06_1, .,0,99) |  !inlist( ag7a_06_2, .,0,99) 
replace controller_income1=ag7a_06_1 if !inlist( ag7a_06_1, .,0,99)  
replace controller_income2=ag7a_06_2 if !inlist( ag7a_06_2, .,0,99)
replace type_decision="control_permsales" if  !inlist( ag7b_06_1, .,0,99) |  !inlist( ag7b_06_2, .,0,99) 
replace controller_income1=ag7b_06_1 if !inlist( ag7b_06_1, .,0,99)  
replace controller_income2=ag7b_06_2 if !inlist( ag7b_06_2, .,0,99)
* control_processedsales
replace type_decision="control_processedsales" if  !inlist( ag10_10_1, .,0,99) |  !inlist( ag10_10_2, .,0,99) 
replace controller_income1=ag10_10_1 if !inlist( ag10_10_1, .,0,99)  
replace controller_income2=ag10_10_2 if !inlist( ag10_10_2, .,0,99)
* livestock_sales (live)
replace type_decision="control_livestocksales" if  !inlist( lf02_27_1, .,0,99) |  !inlist( lf02_27_2, .,0,99) 
replace controller_income1=lf02_27_1 if !inlist( lf02_27_1, .,0,99)  
replace controller_income2=lf02_27_2 if !inlist( lf02_27_2, .,0,99)
* append who controle earning from livestock_sales (slaughtered)
preserve
replace type_decision="control_livestocksales" if  !inlist( lf02_35_1, .,0,99) |  !inlist( lf02_35_2, .,0,99) 
replace controller_income1=lf02_35_1 if !inlist( lf02_35_1, .,0,99)  
replace controller_income2=lf02_35_2 if !inlist( lf02_35_2, .,0,99)
keep if  !inlist( lf02_35_1, .,0,99) |  !inlist( lf02_35_2, .,0,99) 
keep HHID type_decision controller_income1 controller_income2
tempfile control_livestocksales2
save `control_livestocksales2'
restore
append using `control_livestocksales2' 
* control milk_sales
replace type_decision="control_milksales" if  !inlist( lf06_13_1, .,0,99) |  !inlist( lf06_13_2, .,0,99) 
replace controller_income1=lf06_13_1 if !inlist( lf06_13_1, .,0,99)  
replace controller_income2=lf06_13_2 if !inlist( lf06_13_2, .,0,99)
* control control_otherlivestock_sales
replace type_decision="control_otherlivestock_sales" if  !inlist( lf08_08_1, .,0,99) |  !inlist( lf08_08_2, .,0,99) 
replace controller_income1=lf08_08_1 if !inlist( lf08_08_1, .,0,99)  
replace controller_income2=lf08_08_2 if !inlist( lf08_08_2, .,0,99)
* Fish production income 
*No information available

* Business income 
* Tanzania LSMS 4 did not ask directly about of who control Business Income
* We are making the assumption that whoever owns the business might have some sort of control over the income generated by the business.
* We don't think that the business manager have control of the business income. If she does, she is probaly listed as owner
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( hh_n05_1, .,0,99) |  !inlist( hh_n05_2, .,0,99) 
replace controller_income1=hh_n05_1 if !inlist( hh_n05_1, .,0,99)  
replace controller_income2=hh_n05_2 if !inlist( hh_n05_2, .,0,99)

** --- Wage income --- *
* There is no question in Tanzania LSMS on who controls wage earnings
* and we can't assume that the wage earner always controls the wage income

* control_remittance
replace type_decision="control_remittance" if  !inlist( hh_q25_1, .,0,99) |  !inlist( hh_q25_2, .,0,99) 
replace controller_income1=hh_q25_1 if !inlist( hh_q25_1, .,0,99)  
replace controller_income2=hh_q25_2 if !inlist( hh_q25_2, .,0,99)
* append who controls in-kind remittances
preserve
replace type_decision="control_remittance" if  !inlist( hh_q27_1, .,0,99) |  !inlist( hh_q27_2, .,0,99) 
replace controller_income1=hh_q27_1 if !inlist( hh_q27_1, .,0,99)  
replace controller_income2=hh_q27_2 if !inlist( hh_q27_2, .,0,99)
keep if  !inlist( hh_q27_1, .,0,99) |  !inlist( hh_q27_2, .,0,99) 
keep HHID type_decision controller_income1 controller_income2
tempfile control_remittance2
save `control_remittance2'
restore
append using `control_remittance2'
* control_assistance income
replace type_decision="control_assistance" if  !inlist( hh_o07_1, .,0,99) |  !inlist( hh_o07_2, .,0,99) 
replace controller_income1=hh_o07_1 if !inlist( hh_o07_1, .,0,99)  
replace controller_income2=hh_o07_2 if !inlist( hh_o07_2, .,0,99)
keep HHID type_decision controller_income1 controller_income2
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
							| type_decision=="control_permharvest" ///
							| type_decision=="control_annualsales" ///
							| type_decision=="control_permsales" ///
							| type_decision=="control_processedsales"
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
collapse (max) control_* , by(HHID controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indidy4
*	Now merge with member characteristics
merge 1:1 HHID indidy4  using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_control_income.dta", replace

********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING - Not started
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	In most cases, TZA LSMS 4 lists the first TWO decision makers.
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_3b"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_4a"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_4b"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_5a"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_5b"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_6a"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_6b"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_7a"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_7b"
append using "${Uganda_NPS_w8_raw_data}/ag_sec_10"
append using "${Uganda_NPS_w8_raw_data}/lf_sec_02.dta"
append using "${Uganda_NPS_w8_raw_data}/lf_sec_05.dta"
append using "${Uganda_NPS_w8_raw_data}/lf_sec_06.dta"
append using "${Uganda_NPS_w8_raw_data}/lf_sec_08.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.
* planting_input
replace type_decision="planting_input" if  !inlist( ag3a_08_1, .,0,99) |  !inlist( ag3a_08_2, .,0,99) |  !inlist( ag3a_08_3, .,0,99) 
replace decision_maker1=ag3a_08_1 if !inlist( ag3a_08_1, .,0,99)  
replace decision_maker2=ag3a_08_2 if !inlist( ag3a_08_2, .,0,99)
replace decision_maker3=ag3a_08_2 if !inlist( ag3a_08_3, .,0,99)
replace type_decision="planting_input" if  !inlist( ag3b_08_1, .,0,99) |  !inlist( ag3b_08_2, .,0,99) |  !inlist( ag3b_08_3, .,0,99) 
replace decision_maker2=ag3b_08_1 if !inlist( ag3b_08_1, .,0,99)  
replace decision_maker2=ag3b_08_2 if !inlist( ag3b_08_2, .,0,99)
replace decision_maker3=ag3b_08_3 if !inlist( ag3b_08_3, .,0,99)
* append who make decision about input use
preserve
replace type_decision="planting_input" if  !inlist( ag3a_09_1, .,0,99) |  !inlist( ag3a_09_2, .,0,99) |  !inlist( ag3a_09_3, .,0,99) 
replace decision_maker1=ag3a_09_1 if !inlist( ag3a_09_1, .,0,99)  
replace decision_maker2=ag3a_09_2 if !inlist( ag3a_09_2, .,0,99)
replace decision_maker3=ag3a_09_2 if !inlist( ag3a_09_3, .,0,99)
replace type_decision="planting_input" if  !inlist( ag3b_09_1, .,0,99) |  !inlist( ag3b_09_2, .,0,99) |  !inlist( ag3b_09_3, .,0,99) 
replace decision_maker2=ag3b_09_1 if !inlist( ag3b_09_1, .,0,99)  
replace decision_maker2=ag3b_09_2 if !inlist( ag3b_09_2, .,0,99)
replace decision_maker3=ag3b_09_3 if !inlist( ag3b_09_3, .,0,99)                        
keep if !inlist( ag3a_09_1, .,0,99) |  !inlist( ag3a_09_2, .,0,99) |  !inlist( ag3a_09_3, .,0,99) |  !inlist( ag3b_09_1, .,0,99) |  !inlist( ag3b_09_2, .,0,99) |  !inlist( ag3b_09_3, .,0,99) 
keep HHID type_decision decision_maker*
tempfile planting_input2
save `planting_input2'
restore
* harvest
replace type_decision="harvest" if  !inlist( ag4a_30_1, .,0,99) |  !inlist( ag4a_30_2, .,0,99)  
replace decision_maker1=ag4a_30_1 if !inlist( ag4a_30_1, .,0,99)  
replace decision_maker2=ag4a_30_2 if !inlist( ag4a_30_2, .,0,99)
replace type_decision="harvest" if  !inlist( ag4b_30_1, .,0,99) |  !inlist( ag4b_30_2, .,0,99)  
replace decision_maker1=ag4b_30_1 if !inlist( ag4b_30_1, .,0,99)  
replace decision_maker2=ag4b_30_2 if !inlist( ag4b_30_2, .,0,99)
* sales_annualcrop
replace type_decision="sales_annualcrop" if  !inlist( ag5a_09_1, .,0,99) |  !inlist( ag5a_09_2, .,0,99) 
replace decision_maker1=ag5a_09_1 if !inlist( ag5a_09_1, .,0,99)  
replace decision_maker2=ag5a_09_2 if !inlist( ag5a_09_2, .,0,99)
replace type_decision="sales_annualcrop" if  !inlist( ag5b_09_1, .,0,99) |  !inlist( ag5b_09_2, .,0,99) 
replace decision_maker1=ag5b_09_1 if !inlist( ag5b_09_1, .,0,99)  
replace decision_maker2=ag5b_09_2 if !inlist( ag5b_09_2, .,0,99)
* append who make negotiate sale to custumer 2
preserve
replace type_decision="sales_annualcrop" if  !inlist( ag5a_16_1, .,0,99) |  !inlist( ag5a_16_2, .,0,99) 
replace decision_maker1=ag5a_16_1 if !inlist( ag5a_16_1, .,0,99)  
replace decision_maker2=ag5a_16_2 if !inlist( ag5a_16_2, .,0,99)
replace type_decision="sales_annualcrop" if  !inlist( ag5b_16_1, .,0,99) |  !inlist( ag5b_16_2, .,0,99) 
replace decision_maker1=ag5b_16_1 if !inlist( ag5b_16_1, .,0,99)  
replace decision_maker2=ag5b_16_2 if !inlist( ag5b_16_2, .,0,99)
keep if !inlist( ag5a_16_1, .,0,99) |  !inlist( ag5a_16_2, .,0,99) | !inlist( ag5b_16_1, .,0,99) |  !inlist( ag5b_16_2, .,0,99)
keep HHID type_decision decision_maker*
tempfile sales_annualcrop2
save `sales_annualcrop2'
restore
append using `sales_annualcrop2'  
* sales_permcrop
replace type_decision="sales_permcrop" if  !inlist( ag7a_05_1, .,0,99) |  !inlist( ag7a_05_2, .,0,99)  
replace decision_maker1=ag7a_05_1 if !inlist( ag7a_05_1, .,0,99)  
replace decision_maker2=ag7a_05_2 if !inlist( ag7a_05_2, .,0,99)
replace type_decision="sales_permcrop" if  !inlist( ag7b_05_1, .,0,99) |  !inlist( ag7b_05_2, .,0,99)  
replace decision_maker1=ag7b_05_1 if !inlist( ag7b_05_1, .,0,99)  
replace decision_maker2=ag7b_05_2 if !inlist( ag7b_05_2, .,0,99)
* sales_processcrop
replace type_decision="sales_processcrop" if  !inlist( ag10_09_1, .,0,99) |  !inlist( ag10_09_2, .,0,99)  
replace decision_maker1=ag10_09_1 if !inlist( ag10_09_1, .,0,99)  
replace decision_maker2=ag10_09_2 if !inlist( ag10_09_2, .,0,99)
* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( lf05_01_1, .,0,99) |  !inlist( lf05_01_2, .,0,99)  
replace decision_maker1=lf05_01_1 if !inlist( lf05_01_1, .,0,99)  
replace decision_maker2=lf05_01_2 if !inlist( lf05_01_2, .,0,99)
keep HHID type_decision decision_maker1 decision_maker2 decision_maker3
preserve
keep HHID type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore
preserve
keep HHID type_decision decision_maker3
drop if decision_maker3==.
ren decision_maker3 decision_maker
tempfile decision_maker3
save `decision_maker3'
restore
keep HHID type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
append using `decision_maker3'
* number of time appears as decision maker
bysort HHID decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							| type_decision=="sales_annualcrop" ///
							| type_decision=="sales_permcrop" ///
							| type_decision=="sales_processcrop"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(HHID decision_maker )  //any decision
ren decision_maker indidy4 
* Now merge with member characteristics
merge 1:1 HHID indidy4  using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", nogen 
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_make_ag_decision.dta", replace

 
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS - Not started
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* In most cases, TZA LSMS 4 as the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${Uganda_NPS_w8_raw_data}/ag_sec_3a.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_3b.dta" 
append using "${Uganda_NPS_w8_raw_data}/lf_sec_05.dta"
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.
* Ownership of land.
replace type_asset="landowners" if  !inlist( ag3a_29_1, .,0,99) |  !inlist( ag3a_29_2, .,0,99) 
replace asset_owner1=ag3a_29_1 if !inlist( ag3a_29_1, .,0,99)  
replace asset_owner2=ag3a_29_1 if !inlist( ag3a_29_2, .,0,99)
replace type_asset="landowners" if  !inlist( ag3b_29_1, .,0,99) |  !inlist( ag3b_29_2, .,0,99) 
replace asset_owner1=ag3b_29_1 if !inlist( ag3b_29_1, .,0,99)  
replace asset_owner2=ag3b_29_1 if !inlist( ag3b_29_2, .,0,99)
* append who hss right to sell or use
preserve
replace type_asset="landowners" if  !inlist( ag3a_31_1, .,0,99) |  !inlist( ag3a_31_2, .,0,99) 
replace asset_owner1=ag3a_31_1 if !inlist( ag3a_31_1, .,0,99)  
replace asset_owner2=ag3a_31_2 if !inlist( ag3a_31_2, .,0,99)
replace type_asset="landowners" if  !inlist( ag3b_31_1, .,0,99) |  !inlist( ag3b_31_2, .,0,99) 
replace asset_owner1=ag3b_31_1 if !inlist( ag3b_31_1, .,0,99)  
replace asset_owner2=ag3b_31_2 if !inlist( ag3b_31_2, .,0,99)
keep if !inlist( ag3a_31_1, .,0,99) |  !inlist( ag3a_31_2, .,0,99)   | !inlist( ag3b_31_1, .,0,99) |  !inlist( ag3b_31_2, .,0,99) 
keep HHID type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  
*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( lf05_01_1, .,0,99) |  !inlist( lf05_01_2, .,0,99)  
replace asset_owner1=lf05_01_1 if !inlist( lf05_01_1, .,0,99)  
replace asset_owner2=lf05_01_2 if !inlist( lf05_01_2, .,0,99)
* non-farm equipment,  large durables/appliances, mobile phone
* SECTION M: HOUSEHOLD ASSETS - does not report who in the household own them) 
* No ownership of non-farm equipment,  large durables/appliances, mobile phone
keep HHID type_asset asset_owner1 asset_owner2  
preserve
keep HHID type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
keep HHID type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
gen own_asset=1 
collapse (max) own_asset, by(HHID asset_owner)
ren asset_owner indidy4
* Now merge with member characteristics
merge 1:1 HHID indidy4  using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_ownasset.dta", replace
 

********************************************************************************
*CROP YIELDS - Not started
********************************************************************************
* crops
use "${Uganda_NPS_w8_raw_data}/ag_sec_4a.dta", clear
* Percent of area
gen pure_stand = ag4a_04==2 
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if ag4a_02==1
replace percent_field = 0.50 if ag4a_02==2
replace percent_field = 0.75 if ag4a_02==3
replace percent_field = 1 if ag4a_01==1
duplicates report HHID plotnum zaocode 	
duplicates drop HHID plotnum zaocode, force		
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta" , nogen keep(1 3)  
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.
gen intercropped_yn = (ag4a_04==1) //See EPAR Technical Report #354 "Crop Yield Measurement on Multi-Cropped Plots" 
replace intercropped_yn = . if ag4a_04==. //replace intercropped variable with missing if we do not know that it was or was not intercropped 
gen mono_field = percent_field if intercropped_yn==0 //not intercropped 
gen int_field = percent_field if intercropped_yn==1 
*Generating total percent of purestand and monocropped on a field
bys HHID plot_id: egen total_percent_int_sum = total(int_field) 
bys HHID plot_id: egen total_percent_mono = total(mono_field) 
//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
gen oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 
bys HHID plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1
replace total_percent_mono = 1 if total_percent_mono>1 
gen total_percent_inter = 1-total_percent_mono 
bys HHID plot_id: egen inter_crop_number = total(intercropped_yn) 
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter = int_field if total_percent_field<=1		
replace percent_inter = percent_field if oversize_plot ==1 & intercropped_yn==1
ren cultivated field_cultivated  
gen field_area_cultivated = field_area if field_cultivated==1
gen crop_area_planted = percent_field*field_area_cultivated  if intercropped_yn == 0 
replace crop_area_planted = percent_inter*field_area_cultivated  if intercropped_yn == 1 
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 
keep crop_area_planted* HHID plot_id zaocode dm_* any_* pure_stand dm_gender  field_area us* area_est_hectares area_meas_hectares 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_crop_area.dta", replace


*Now to harvest
use "${Uganda_NPS_w8_raw_data}/ag_sec_4a.dta", clear
gen kg_harvest = ag4a_28
ren ag4a_22 harv_less_plant			//yes if they harvested less than they planted
ren ag4a_19 no_harv
replace kg_harvest = 0 if ag4a_20==3
replace kg_harvest =. if ag4a_20==1 | ag4a_20==2 | ag4a_20==4		
drop if kg_harvest==.							
gen area_harv_ha= ag4a_21*0.404686						
keep HHID plotnum zaocode kg_harvest area_harv_ha harv_less_plant no_harv
ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 HHID plot_id zaocode using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_crop_area.dta", nogen /*keep(1 3)*/ // we still want to keep those that report an area planted but no harvest		
//Add production of permanent crops (cassava and banana)
preserve
use "${Uganda_NPS_w8_raw_data}/ag_sec_6b.dta", clear
append using "${Uganda_NPS_w8_raw_data}/ag_sec_6a.dta"		// include fruit crops 
gen kg_harvest = ag6b_09
replace kg_harvest = ag6a_09 if kg_harvest==.				
gen pure_stand = ag6b_05==2
replace pure_stand = ag6a_05==2 if pure_stand==. 				
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
ren plotnum plot_id
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta", nogen keep(1 3)	              
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers" , nogen keep(1 3) 
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.
ren ag6b_02 number_trees_planted
keep HHID plot_id zaocode kg_harvest number_trees_planted pure_stand any_pure any_mixed field_area dm_gender 
tempfile  cassava
save `cassava', replace
restore 
append using `cassava'
ren crop_area_planted area_plan
//Capping Code:
gen over_harvest = area_harv_ha>field_area & area_harv_ha!=. & area_meas_hectares!=.	
gen over_harvest_scaling = field_area/area_harv_ha if over_harvest == 1
bys HHID plot_id: egen mean_harvest_scaling = mean(over_harvest_scaling)
replace mean_harvest_scaling =1 if missing(mean_harvest_scaling)
replace area_harv_ha = field_area if over_harvest == 1
replace area_harv_ha = area_harv_ha*mean_harvest_scaling if over_harvest == 0
//Intercropping Scaling Code:
bys HHID plot_id: egen over_harv_plot = max(over_harvest)
gen intercropped_yn = pure_stand !=1 
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys HHID plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys HHID plot_id: egen total_area_hv = total(area_harv_ha)
replace us_total_area_planted = total_area_hv if over_harv_plot ==1
replace us_inter_area_planted = total_area_int_sum_hv if over_harv_plot ==1
drop intercropped_yn int_f_harv total_area_int_sum_hv total_area_hv
gen intercropped_yn = pure_stand !=1 
gen mono_f_harv = area_harv_ha if intercropped_yn==0
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys HHID plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys HHID plot_id: egen total_area_mono_hv = total(mono_f_harv)
//Oversize Plots
gen oversize_plot = total_area_mono_hv > field_area & total_area_mono_hv!=. 	
replace oversize_plot = 1 if total_area_mono_hv >= field_area & total_area_int_sum_hv>0 & total_area_mono_hv!=.
gen percent_harvest = area_harv_ha/field_area
bys HHID plot_id: egen total_percent_harvest = total(percent_harvest)
//using this in the construction of area_harv_ha below
bys HHID plot_id: egen total_area_harv = total(area_harv_ha)	
replace area_harv_ha = (area_harv_ha/us_total_area_planted)*field_area if oversize_plot ==1 
gen total_area_int_hv = field_area - total_area_mono_hv
replace area_harv_ha = (int_f_harv/us_inter_area_planted)*total_area_int_hv if intercropped_yn==1 & oversize_plot !=1 & total_percent_harv>1 
//3,060 changes with rescaling up
//2,138 changes without rescaling up
replace area_harv_ha=. if area_harv_ha==0 //11 to missing
replace area_plan=area_harv_ha if area_plan==. & area_harv_ha!=.
*Cap area harvested at area planted (area harvested should not be greater than the area planted)
count if area_harv_ha>area_plan & area_harv_ha!=. //832 observations where area harvested is greater than area planted 
replace area_harv_ha = area_plan if area_harv_ha>area_plan & area_harv_ha!=.

*Creating area and quantity variables by decision-maker and type of planting
ren kg_harvest harvest 
ren area_harv_ha area_harv 
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
gen area_plan_male = area_plan if dm_gender==1
gen area_plan_female = area_plan if dm_gender==2
gen area_plan_mixed = area_plan if dm_gender==3
gen area_plan_inter= area_plan if inter==1
gen area_plan_pure= area_plan if inter==0
gen area_plan_inter_male= area_plan if dm_gender==1 & inter==1
gen area_plan_pure_male= area_plan if dm_gender==1 & inter==0
gen area_plan_inter_female= area_plan if dm_gender==2 & inter==1
gen area_plan_pure_female= area_plan if dm_gender==2 & inter==0
gen area_plan_inter_mixed= area_plan if dm_gender==3 & inter==1
gen area_plan_pure_mixed= area_plan if dm_gender==3 & inter==0
recode number_trees_planted (.=0)
collapse (sum) area_harv* harvest* area_plan* number_trees_planted , by (HHID zaocode)
*merging survey weights
merge m:1 HHID using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
*Saving area planted for Shannon diversity index
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_area_plan_LRS.dta", replace

*Adding here total planted and harvested area all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(HHID)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_area_planted_harvested_allcrops_LRS.dta", replace
restore
keep if inlist(zaocode, $comma_topcrop_area)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_harvest_area_yield_LRS.dta", replace

/////Generating yield variables for short rainy season////
* crops
use "${Uganda_NPS_w8_raw_data}/ag_sec_4b.dta", clear
* Percent of area
gen pure_stand = ag4b_04==2
gen any_pure = pure_stand==1
gen any_mixed = pure_stand==0
gen percent_field = 0.25 if ag4b_02==1
replace percent_field = 0.50 if ag4b_02==2
replace percent_field = 0.75 if ag4b_02==3
replace percent_field = 1 if ag4b_01==1
duplicates report HHID plotnum zaocode		
duplicates drop HHID plotnum zaocode, force	
drop if plotnum==""
ren plotnum plot_id 
*Merging in variables from tzn4_field
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta" , nogen keep(1 3)    
merge m:1 HHID plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers" , nogen keep(1 3)
gen field_area =  area_meas_hectares
replace field_area= area_est_hectares if field_area==.
//See EPAR Technical Report #354 "Crop Yield Measurement on Multi-Cropped Plots" 
gen intercropped_yn = (ag4b_04==1) 
replace intercropped_yn = . if ag4b_04==. 
gen mono_field = percent_field if intercropped_yn==0 //not intercropped 
gen int_field = percent_field if intercropped_yn==1 
bys HHID plot_id: egen total_percent_mono = total(mono_field)
bys HHID plot_id: egen total_percent_int_sum = total(int_field) 
//Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and till has intercropping to add
gen oversize_plot = (total_percent_mono >1)
replace oversize_plot = 1 if total_percent_mono >=1 & total_percent_int_sum >0 
bys HHID plot_id: egen total_percent_field = total(percent_field)			            
replace percent_field = percent_field/total_percent_field if total_percent_field>1 & oversize_plot ==1		//17 changes made
replace total_percent_mono = 1 if total_percent_mono>1 
gen total_percent_inter = 1-total_percent_mono
bys HHID plot_id: egen inter_crop_number = total(intercropped_yn) 
gen percent_inter = (int_field/total_percent_int_sum)*total_percent_inter if total_percent_field >1 
replace percent_inter=int_field if total_percent_field<=1
replace percent_inter = percent_field if oversize_plot ==1 & intercropped_yn==1 
ren cultivated field_cultivated  
gen field_area_cultivated = field_area if field_cultivated==1
gen crop_area_planted = percent_field*field_area_cultivated  if intercropped_yn == 0
replace crop_area_planted = percent_inter*field_area_cultivated  if intercropped_yn == 1
gen us_total_area_planted = total_percent_field*field_area_cultivated 
gen us_inter_area_planted = total_percent_int_sum*field_area_cultivated 
keep crop_area_planted* HHID plot_id zaocode dm_* any_* pure_stand dm_gender  field_area us* area_meas_hectares area_est_hectares 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_crop_area_SRS.dta", replace

*Now to harvest
use "${Uganda_NPS_w8_raw_data}/ag_sec_4b.dta", clear
gen kg_harvest = ag4b_28
ren ag4b_22 harv_less_plant			//yes if they harvested less than they planted
ren ag4b_19 no_harv
replace kg_harvest = 0 if ag4b_20==3
replace kg_harvest =. if ag4b_20==1 | ag4b_20==2 | ag4b_20==4	
drop if kg_harvest==.							
gen area_harv_ha= ag4b_21*0.404686						
keep HHID plotnum zaocode kg_harvest area_harv_ha harv_less_plant no_harv
ren plotnum plot_id 
*Merging decision maker and intercropping variables
merge m:1 HHID plot_id zaocode using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_crop_area_SRS.dta", nogen /*keep(1 3)*/ //we still want to keep those that report an area planted but no harvest			
//Capping Code:
gen over_harvest = area_harv_ha>field_area & area_harv_ha!=. & area_meas_hectares!=.	
gen over_harvest_scaling = field_area/area_harv_ha if over_harvest == 1
bys HHID plot_id: egen mean_harvest_scaling = mean(over_harvest_scaling)
replace mean_harvest_scaling =1 if missing(mean_harvest_scaling)
replace area_harv_ha = field_area if over_harvest == 1
replace area_harv_ha = area_harv_ha*mean_harvest_scaling if over_harvest == 0 

//Intercropping Scaling Code (Method 4):
bys HHID plot_id: egen over_harv_plot = max(over_harvest)
gen intercropped_yn = pure_stand !=1 
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys HHID plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys HHID plot_id: egen total_area_hv = total(area_harv_ha)
replace us_total_area_planted = total_area_hv if over_harv_plot ==1
replace us_inter_area_planted = total_area_int_sum_hv if over_harv_plot ==1
drop intercropped_yn int_f_harv total_area_int_sum_hv total_area_hv

// Adding Method 4 to Area Harvested
gen intercropped_yn = pure_stand !=1 
gen mono_f_harv = area_harv_ha if intercropped_yn==0
gen int_f_harv = area_harv_ha if intercropped_yn==1
bys HHID plot_id: egen total_area_int_sum_hv = total(int_f_harv)
bys HHID plot_id: egen total_area_mono_hv = total(mono_f_harv)
//Oversize Plots
gen oversize_plot = total_area_mono_hv > field_area
replace oversize_plot = 1 if total_area_mono_hv >=1 & total_area_int_sum_hv >0 
bys HHID plot_id: egen total_area_harv = total(area_harv_ha)	
replace area_harv_ha = (area_harv_ha/us_total_area_planted)*field_area if oversize_plot ==1 
gen total_area_int_hv = field_area - total_area_mono_hv
replace area_harv_ha = (int_f_harv/us_inter_area_planted)*total_area_int_hv if intercropped_yn==1 & oversize_plot !=1 
*rescaling area harvested to area planted if area harvested > area planted
ren crop_area_planted area_plan
replace area_harv_ha=. if area_harv_ha==0 //11 to missing
replace area_plan=area_harv_ha if area_plan==. & area_harv_ha!=.
*Capping area harvested at area planted
count if area_harv_ha>area_plan & area_harv_ha!=. //228 observations where area harvested is greater than area planted 
replace area_harv_ha = area_plan if area_harv_ha>area_plan & area_harv_ha!=.

*Creating area and quantity variables by decision-maker and type of planting
ren kg_harvest harvest 
ren area_harv_ha area_harv 
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
gen area_plan_male = area_plan if dm_gender==1
gen area_plan_female = area_plan if dm_gender==2
gen area_plan_mixed = area_plan if dm_gender==3
gen area_plan_inter= area_plan if inter==1
gen area_plan_pure= area_plan if inter==0
gen area_plan_inter_male= area_plan if dm_gender==1 & inter==1
gen area_plan_pure_male= area_plan if dm_gender==1 & inter==0
gen area_plan_inter_female= area_plan if dm_gender==2 & inter==1
gen area_plan_pure_female= area_plan if dm_gender==2 & inter==0
gen area_plan_inter_mixed= area_plan if dm_gender==3 & inter==1
gen area_plan_pure_mixed= area_plan if dm_gender==3 & inter==0
collapse (sum) area_harv* harvest* area_plan*, by (HHID zaocode)
*Adding here total planted and harvested area summed accross all plots, crops, and seasons.
*Saving area planted for Shannon diversity index
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_area_plan_SRS.dta", replace


preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(HHID)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_area_planted_harvested_allcrops_SRS.dta", replace
*Append LRS
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_area_planted_harvested_allcrops_LRS.dta"
recode all_area_harvested all_area_planted (.=0)
collapse (sum) all_area_harvested all_area_planted, by(HHID)
lab var all_area_planted "Total area planted, all plots, crops, and seasons"
lab var all_area_harvested "Total area harvested, all plots, crops, and seasons"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_area_planted_harvested_allcrops.dta", replace
restore

*merging survey weights
merge m:1 HHID using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep(1 3)
keep if inlist(zaocode, $comma_topcrop_area)
gen season="SRS"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_harvest_area_yield_SRS.dta", replace

*Yield at the household level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_harvest_area_yield_LRS.dta", clear
preserve
gen season="LRS"
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_harvest_area_yield_SRS.dta"
recode area_plan area_harv (.=0)
collapse (sum)area_plan area_harv, by(HHID zaocode)
ren area_plan total_planted_area
ren area_harv total_harv_area 
tempfile area_allseasons
save `area_allseasons'
restore
merge 1:1 HHID zaocode using `area_allseasons', nogen
ren  zaocode crop_code
*Adding value of crop production
merge 1:1 HHID crop_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv
ren value_crop_sales value_sold
local ncrop : word count $topcropname_area
foreach v of varlist  harvest*  area_harv* area_plan* total_planted_area total_harv_area kgs_harvest* kgs_sold* value_harv value_sold {
	separate `v', by(crop_code)
	forvalues i=1(1)`ncrop' {
		local p : word `i' of  $topcrop_area
		local np : word `i' of  $topcropname_area
		local `v'`p' = subinstr("`v'`p'","`p'","_`np'",1)	
		ren `v'`p'  ``v'`p''
	}	
}
gen number_trees_planted_cassava=number_trees_planted if crop_code==21
gen number_trees_planted_banana=number_trees_planted if crop_code==71
recode number_trees_planted_cassava number_trees_planted_banana (.=0) 	
collapse (firstnm) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*  kgs_sold*  value_harv* value_sold* (sum) number_trees_planted_*, by(HHID)
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* kgs_sold*  value_harv* value_sold* (0=.)
lab var kgs_harvest "Kgs harvested (household) (all seasons)"
lab var kgs_sold "Kgs sold (household) (all seasons)"
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (household)" 
	lab var value_sold_`p' "Value sold of `p' (household)" 
	lab var kgs_harvest_`p'  "Harvest of `p' (kgs) (household) (all seasons)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household) (all seasons)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (all seasons)" 
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household) (all seasons)" 
	lab var harvest_`p' "Harvest of `p' (kgs) (household) - LRS" 
	lab var harvest_male_`p' "Harvest of `p' (kgs) (male-managed plots) - LRS" 
	lab var harvest_female_`p' "Harvest of `p' (kgs) (female-managed plots) - LRS" 
	lab var harvest_mixed_`p' "Harvest of `p' (kgs) (mixed-managed plots) - LRS"
	lab var harvest_pure_`p' "Harvest of `p' (kgs) - purestand (household) - LRS"
	lab var harvest_pure_male_`p'  "Harvest of `p' (kgs) - purestand (male-managed plots) - LRS"
	lab var harvest_pure_female_`p'  "Harvest of `p' (kgs) - purestand (female-managed plots) - LRS"
	lab var harvest_pure_mixed_`p'  "Harvest of `p' (kgs) - purestand (mixed-managed plots) - LRS"
	lab var harvest_inter_`p' "Harvest of `p' (kgs) - intercrop (household) - LRS"
	lab var harvest_inter_male_`p' "Harvest of `p' (kgs) - intercrop (male-managed plots) - LRS" 
	lab var harvest_inter_female_`p' "Harvest of `p' (kgs) - intercrop (female-managed plots) - LRS"
	lab var harvest_inter_mixed_`p' "Harvest  of `p' (kgs) - intercrop (mixed-managed plots) - LRS"
	lab var area_harv_`p' "Area harvested of `p' (ha) (household) - LRS" 
	lab var area_harv_male_`p' "Area harvested of `p' (ha) (male-managed plots) - LRS" 
	lab var area_harv_female_`p' "Area harvested of `p' (ha) (female-managed plots) - LRS" 
	lab var area_harv_mixed_`p' "Area harvested of `p' (ha) (mixed-managed plots) - LRS"
	lab var area_harv_pure_`p' "Area harvested of `p' (ha) - purestand (household) - LRS"
	lab var area_harv_pure_male_`p'  "Area harvested of `p' (ha) - purestand (male-managed plots) - LRS"
	lab var area_harv_pure_female_`p'  "Area harvested of `p' (ha) - purestand (female-managed plots) - LRS"
	lab var area_harv_pure_mixed_`p'  "Area harvested of `p' (ha) - purestand (mixed-managed plots) - LRS"
	lab var area_harv_inter_`p' "Area harvested of `p' (ha) - intercrop (household) - LRS"
	lab var area_harv_inter_male_`p' "Area harvested of `p' (ha) - intercrop (male-managed plots) - LRS" 
	lab var area_harv_inter_female_`p' "Area harvested of `p' (ha) - intercrop (female-managed plots) - LRS"
	lab var area_harv_inter_mixed_`p' "Area harvested  of `p' (ha) - intercrop (mixed-managed plots - LRS)"
	lab var area_plan_`p' "Area planted of `p' (ha) (household) - LRS" 
	lab var area_plan_male_`p' "Area planted of `p' (ha) (male-managed plots) - LRS" 
	lab var area_plan_female_`p' "Area planted of `p' (ha) (female-managed plots) - LRS" 
	lab var area_plan_mixed_`p' "Area planted of `p' (ha) (mixed-managed plots) - LRS"
	lab var area_plan_pure_`p' "Area planted of `p' (ha) - purestand (household) - LRS"
	lab var area_plan_pure_male_`p'  "Area planted of `p' (ha) - purestand (male-managed plots) - LRS"
	lab var area_plan_pure_female_`p'  "Area planted of `p' (ha) - purestand (female-managed plots) - LRS"
	lab var area_plan_pure_mixed_`p'  "Area planted of `p' (ha) - purestand (mixed-managed plots) - LRS"
	lab var area_plan_inter_`p' "Area planted of `p' (ha) - intercrop (household) - LRS"
	lab var area_plan_inter_male_`p' "Area planted of `p' (ha) - intercrop (male-managed plots) - LRS" 
	lab var area_plan_inter_female_`p' "Area planted of `p' (ha) - intercrop (female-managed plots) - LRS"
	lab var area_plan_inter_mixed_`p' "Area planted  of `p' (ha) - intercrop (mixed-managed plots) - LRS"
}
*Household grew crop
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
foreach p in cassav banana { //tree/permanent crops have no area in this instrument 
	replace grew_`p' = 1 if number_trees_planted_`p'!=0 & number_trees_planted_`p'!=.
}

*Household grew crop in the LRS
foreach p of global topcropname_area {
	gen grew_`p'_lrs=(area_harv_`p'!=. & area_harv_`p'!=.0 ) | (area_plan_`p'!=. & area_plan_`p'!=.0)
	lab var grew_`p'_lrs "1=Household grew `p' in the long rainy season" 
	gen harvested_`p'_lrs= (area_harv_`p'!=. & area_harv_`p'!=.0 )
	lab var harvested_`p'_lrs "1= Household harvested `p' in the long rainy season"
}

foreach p of global topcropname_area {
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}
drop harvest- harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_pure_mixed value_harv value_sold total_planted_area total_harv_area number_trees_planted_*
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_yield_hh_crop_level.dta", replace

//IHS 10/11/19 END

 
********************************************************************************
*SHANNON DIVERSITY INDEX - Not started
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_area_plan_LRS.dta", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_area_plan_SRS.dta"
//we don't want to count crops that are grown in the SRS and LRS as different.
collapse (sum) area_plan*, by(HHID zaocode)
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
*drop if area_plan==0
drop if zaocode==.
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(HHID)
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 HHID using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
bysort HHID zaocode : gen nvals_tot = _n==1
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_shannon_diversity_index.dta", replace

*/
//IHS 10/11/19 START
********************************************************************************
*CONSUMPTION - RH Complete with flagged question 8/22/22
******************************************************************************** 
use "${Uganda_NPS_w8_raw_data}/consagg_pov2019_20.dta", clear
ren nrrexp30 mon_total_cons // using real consumption-adjusted for region price disparities // RH Flag: This variable is monthly household expenditures in nominal prices. Should it be in 2009/10 constant prices? -- this is monthly in UGA w8, so multiply to get yearly est.
gen total_cons = mon_total_cons*12 // annual
gen peraeq_cons = (total_cons / equiv) //equiv = adult equivalence scale
gen percapita_cons = (total_cons / hsize) // divided by household size
gen daily_peraeq_cons = peraeq_cons/365 
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total annual HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons equiv
recast str32 hhid
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_consumption.dta", replace

********************************************************************************
*HOUSEHOLD FOOD PROVISION* - RH complete 8/22/22
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec17_1.dta", clear
egen months_food_insec = rowtotal(s17q10*) 
* replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep hhid months_food_insec
recast str32 hhid
lab var months_food_insec "Number of months of inadequate food provision"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_food_insecurity.dta", replace

/* old
forvalues k=1/36 {
	gen food_insecurity_`k' = (hh_h09_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
* replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep HHID months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_food_insecurity.dta", replace
*/

********************************************************************************
*HOUSEHOLD ASSETS* - RH complete 10/27/21
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec14.dta", clear
*ren hh_m03 price_purch // not available UGA w8
ren h14q05 value_today
*ren hh_m02 age_item // not available UGA w8
ren h14q04 num_items
*dropping items that don't report prices
*drop if itemcode==413 | itemcode==414 | itemcode==416 | itemcode==424 | itemcode==436 | itemcode==440 // From previous code. Are there asset types to exclude for UGA?
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_assets.dta", replace 


********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument

 
 /*
//IHS 10/11/19 START
********************************************************************************
*HOUSEHOLD VARIABLES - not started
********************************************************************************
global empty_vars ""
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", clear

*Gross crop income 
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_crop_production.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)
*Variables: value_crop_production crop_value_lost

*Crop costs
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_asset_rental_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rental_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_seed_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fertilizer_costs.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_shortseason.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_mainseason.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_transportation_cropsales.dta", nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue"

*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rental_costs_`c'.dta", nogen
	merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fertilizer_costs_`c'.dta", nogen
	merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_`c'_monocrop_hh_area.dta", nogen
}
*top crop costs that are only present in short season
foreach c in $topcropname_short{
	merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_shortseason_`c'.dta", nogen
}
*costs that only include annual crops (seed costs and mainseason wages)
foreach c in $topcropname_annual {
	merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_seed_costs_`c'.dta", nogen
	merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wages_mainseason_`c'.dta", nogen
}

*generate missing vars to run code that collapses all costs
global missing_vars wages_paid_short_sunflr wages_paid_short_pigpea wages_paid_short_wheat wages_paid_short_pmill cost_seed_cassav cost_seed_banana wages_paid_main_cassav wages_paid_main_banana
foreach v in $missing_vars{
	gen `v' = . 
	foreach i in male female mixed{
		gen `v'_`i' = .
	}
}
foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	egen `c'_exp = rowtotal(rental_cost_land_`c' cost_seed_`c' value_fertilizer_`c' value_herbicide_`c' value_pesticide_`c' wages_paid_short_`c' wages_paid_main_`c')
	lab var `c'_exp "Crop production costs(explicit)-Monocrop `c' plots only"
	la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household"		
	*disaggregate by gender of plot manager
	foreach i in male female mixed{
		egen `c'_exp_`i' = rowtotal(rental_cost_land_`c'_`i' cost_seed_`c'_`i' value_fertilizer_`c'_`i' value_herbicide_`c'_`i' value_pesticide_`c'_`i' wages_paid_short_`c'_`i' wages_paid_main_`c'_`i')
		local l`c'_exp : var lab `c'_exp
		la var `c'_exp_`i' "`l`c'_exp' - `i' managed plots"
	}
	replace `c'_exp = . if `c'_monocrop_ha==.			// set to missing if the household does not have any monocropped plots
	foreach i in male female mixed{
		replace `c'_exp_`i' = . if `c'_monocrop_ha_`i'==.
	}
}

*land rights
merge 1:1 hhid using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rights_hh.dta", nogen
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_sales", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_products", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_dung.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_expenses", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_TLU.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_herd_characteristics", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_TLU_Coefficients.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_expenses_animal.dta", nogen 
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /* 
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock)
lab var livestock_income "Net livestock income"
gen livestock_expenses = cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock
ren cost_vaccines_livestock ls_exp_vac  
drop value_livestock_purchases value_other_produced sales_dung cost_hired_labor_livestock cost_fodder_livestock cost_water_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"
*Fish income
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fish_income.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fishing_expenses_1.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fishing_expenses_2.dta", nogen
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid
lab var fishing_income "Net fish income"
drop cost_fuel rental_costs_fishing cost_paid

*Self-employment income
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_self_employment_income.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fish_trading_income.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_agproducts_profits.dta", nogen
egen self_employment_income = rowtotal(annual_selfemp_profit fish_trading_income byproduct_profits)
lab var self_employment_income "Income from self-employment"
drop annual_selfemp_profit fish_trading_income byproduct_profits 

*Wage income
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_wage_income.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_agwage_income.dta", nogen
recode annual_salary annual_salary_agwage(.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_off_farm_hours.dta", nogen

*Other income
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_other_income.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rental_income.dta", nogen
egen transfers_income = rowtotal (pension_income remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income  land_rental_income)
lab var all_other_income "Income from all other revenue"
drop pension_income remittance_income assistance_income rental_income other_income land_rental_income

*Farm size
merge 1:1 hhid using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_size.dta", nogen
merge 1:1 hhid using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_size_all.dta", nogen
merge 1:1 hhid using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmsize_all_agland.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_size_total.dta", nogen
recode land_size (.=0)

*Add farm size categories
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
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_family_hired_labor.dta", nogen
recode   labor_hired labor_family (.=0)
  
*Household size
merge 1:1 hhid using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", nogen

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_vaccine.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fert_use.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_improvedseed_use.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_any_ext.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fin_serv.dta", nogen
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. 
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.
global empty_vars $empty_vars imprv_seed_cassav imprv_seed_banana hybrid_seed_*

*Milk productivity
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_milk_animals.dta", nogen
gen liters_milk_produced=liters_per_largeruminant * milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_largeruminant
gen liters_per_cow = . 
gen liters_per_buffalo = . 

*Dairy costs 
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_lrum_expenses", nogen
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
lab var avg_cost_lrum "Average cost per large ruminant"
gen costs_dairy = avg_cost_lrum*milk_animals 
*gen costs_dairy_percow == avg_cost_lrum
gen costs_dairy_percow=. 
drop avg_cost_lrum cost_lrum
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen share_imp_dairy = . 

*Egg productivity
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_eggs_animals.dta", nogen
gen egg_poultry_year = . 
global empty_vars $empty_vars *liters_per_cow *liters_per_buffalo *costs_dairy_percow* share_imp_dairy *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_cropcosts_total.dta", nogen

*Rate of fertilizer application 
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_fertilizer_application.dta", nogen

*Agricultural wage rate
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_ag_wage.dta", nogen

*Crop yields 
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_yield_hh_crop_level.dta", nogen

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_area_planted_harvested_allcrops.dta", nogen

*Household diet
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_household_diet.dta", nogen

*Consumption
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_consumption.dta", nogen

*Household assets
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_assets.dta", nogen

*Food insecurity
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_food_insecurity.dta", nogen
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Livestock health
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_diseases.dta", nogen

*livestock feeding, water, and housing
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_feed_water_house.dta", nogen
 
*Shannon diversity index
merge 1:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_shannon_diversity_index.dta", nogen
 
*Farm Production 
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | crop_income!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

*households engaged in egg production 
gen egg_hh = (value_eggs_produced>0 & value_eggs_produced!=.)
lab var egg_hh "1=Household engaged in egg production"
*household engaged in dairy production
gen dairy_hh = (value_milk_produced>0 & value_milk_produced!=.)
lab var dairy_hh "1= Household engaged in dairy production" 

*Household engage in ag activities including working in paid ag jobs
gen agactivities_hh =ag_hh==1 | (agwage_income!=0 & agwage_income!=.)
lab var agactivities_hh "1=Household has some land cultivated, livestock, crop income, livestock income, or ag wage income"

*Creating crop household and livestock household
gen crop_hh = (value_crop_production!=0  | farm_area!=0)
lab var crop_hh "1= Household has some land cultivated or some crop income"
gen livestock_hh = (livestock_income!=0 | tlu_today!=0)
lab  var livestock_hh "1= Household has some livestock or some livestock income"
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

 *households engaged in monocropped production of specific crops
 foreach cn in $topcropname_area {
	recode `cn'_monocrop (.=0)
	foreach g in male female mixed {
		recode `cn'_monocrop_`g' (.=0)
	}
}
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_monocrop_ha (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_monocrop_ha (nonmissing=.) if `cn'_monocrop==0
	foreach g in male female mixed {
			recode `cn'_exp_`g' `cn'_monocrop_ha_`g' (.=0) if `cn'_monocrop_`g'==1
			recode `cn'_exp_`g' `cn'_monocrop_ha_`g' (nonmissing=.) if `cn'_monocrop_`g'==0
	}
}
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
 
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
 
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0
 
*all rural households 
recode off_farm_hours crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed"
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months* mean_12months* lost_disease* /* 
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced egg_poultry_year /*
*/ off_farm_hours crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac*  sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold 

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
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor
gen wage_paid_aglabor_female=. 
gen wage_paid_aglabor_male=.
gen wage_paid_aglabor_mixed=. 
lab var wage_paid_aglabor_female "Daily wage in agricuture - female workers"
lab var wage_paid_aglabor_male "Daily wage in agricuture - male workers"

global empty_vars $empty_vars *wage_paid_aglabor_female* *wage_paid_aglabor_male* 
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
* gen labor_total  as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`llabor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p($wins_lower_thres $wins_upper_thres) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  /* we want to keep actual zeros */
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top and bottom 1%"
	*some vriables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
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

*area_harv  and area_plan are also winsorized both at the top 1% and bottom 1% because we need to treat at the crop level 
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
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
 
*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
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

*mortality rate
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
		gen `c'_exp_ha_`g' =w_`c'_exp_`g'/w_`c'_monocrop_ha_`g'	
		local l`c'_exp_ha : var lab `c'_exp_ha
		lab var `c'_exp_ha_`g'  "`l`c'_exp_ha'- `g' managed plots"
	}
}

*Off farm hours per capita using winsorized version off_farm_hours 
gen off_farm_hours_pc_all = w_off_farm_hours/member_count					
gen off_farm_hours_pc_any = w_off_farm_hours/off_farm_any_count			
la var off_farm_hours_pc_all "Off-farm hours per capita, all members>5 years"
la var off_farm_hours_pc_any "Off-farm hours per capita, only members>5 years workings"

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh / w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*milk productivity
gen liters_per_largeruminant= w_liters_milk_produced/milk_animals 
lab var liters_per_largeruminant "Average quantity (liters) per year (household)"

*crop value sold
gen w_proportion_cropvalue_sold = w_value_crop_sales /  w_value_crop_production
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
		local l`c'_exp_kg : var lab `c'_exp_kg
		lab var `c'_exp_kg_`g'  "`l`c'_exp_kg'- `g' managed plots"
	}
}

*dairy
gen cost_per_lit_milk = w_costs_dairy/w_liters_milk_produced 
lab var cost_per_lit_milk "dairy production cost per liter"

*****getting correct subpopulations***
*all rural households engaged in crop production 
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}

*all rural households 
recode off_farm_hours_pc_all (.=0)
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
		foreach g in male female mixed { 
		recode `cn'_exp_`g' `cn'_exp_ha_`g' `cn'_exp_kg_`g' (.=0) if `cn'_monocrop_`g'==1
		recode `cn'_exp_`g' `cn'_exp_ha_`g' `cn'_exp_kg_`g' (nonmissing=.) if `cn'_monocrop_`g'==0
		}
}

*all rural households growing specific crops (in the long rainy season) 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'_lrs==1 //only reporting LRS yield so only replace if grew in LRS
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'_lrs==0 
}
*all rural households harvesting specific crops (in the long rainy season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'_lrs==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'_lrs==0 
}

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'_lrs==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'_lrs==0 | w_area_plan_pure_`cn'==.  
}
*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'_lrs==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'_lrs==0 | w_area_plan_pure_`cn'==.  
}

*households engaged in dairy production 
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate /*
*/ cost_total_ha cost_expli_ha cost_expli_hh_ha /*
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant costs_dairy_percow liters_per_cow liters_per_buffalo /*
*/ off_farm_hours_pc_all off_farm_hours_pc_any cost_per_lit_milk 	

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"

	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha"  {
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
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha' - Winzorized top 1%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha : var lab `v'_exp_ha
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha' - winsorized top 1%"
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
		local l`v'_exp_kg : var lab `v'_exp_kg
		lab var w_`v'_exp_kg_`g' "`l`v'_exp_kg' - winsorized top 1%"
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
 

*Create final income variables using winzorized and un_winzorized values
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
recode w_total_income w_percapita_income w_crop_income w_livestock_income w_fishing_income w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_fishing w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* /*
*/ formal_land_rights_hh w_off_farm_hours_pc_all months_food_insec w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses w_ls_exp_vac  any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses w_ls_exp_vac  any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
}
	
*all rural households growing specific crops (in the long rainy season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_pl_`cn' (.=0) if grew_`cn'_lrs==1
	recode w_yield_pl_`cn' (nonmissing=.) if grew_`cn'_lrs==0
}
*all rural households that harvested specific crops (in the long rainy season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'_lrs==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'_lrs==0
}
	
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode w_`cn'_exp w_`cn'_exp_ha w_`cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
}

*all rural households engaged in dairy production
recode costs_dairy  liters_milk_produced w_value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy  liters_milk_produced w_value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode w_eggs_total_year w_value_eggs_produced (.=0) if egg_hh==1
recode w_eggs_total_year w_value_eggs_produced (nonmissing=.) if egg_hh==0
 
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

************Rural poverty headcount ratio***************
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 585.52 = 1112.488  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(158.021 - 112.691)/ 112.691 = 1.4022504	
	// 1112.488* 1.4022504 = 1559.9867 TSH
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<1559.9867)
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

********Currency Conversion Factors*********
gen ccf_loc = (1+$Uganda_NPS_w8_inflation) 
lab var ccf_loc "currency conversion factor - 2016 $TSH"
gen ccf_usd = (1+$Uganda_NPS_w8_inflation) / $Uganda_NPS_w8_exchange_rate 
lab var ccf_usd "currency conversion factor - 2016 $USD"
gen ccf_1ppp = (1+$Uganda_NPS_w8_inflation) / $Uganda_NPS_w8_cons_ppp_dollar 
lab var ccf_1ppp "currency conversion factor - 2016 $Private Consumption PPP"
gen ccf_2ppp = (1+$Uganda_NPS_w8_inflation) / $Uganda_NPS_w8_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2016 $GDP PPP"

*replace vars that cannot be created with .
*empty crop vars (cassava and banana - no area information for permanent crops) 
global empty_vars $empty_vars *yield_*_cassav *yield_*_banana *total_planted_area_cassav *total_harv_area_cassav *total_planted_area_banana *total_harv_area_banana *cassav_exp_ha* *banana_exp_ha*

*replace empty vars with missing 
foreach v of varlist $empty_vars {
	replace `v' = .
}

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* region region_name district district_name ward ward_name village village_name ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold *off_farm_hours_pc* months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_1_9 *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren HHID hhid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2019-20"
/*To be updated
gen instrument = 4
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
*/

saveold "${Uganda_NPS_w8_final_data}/Uganda_NPS_w8_household_variables.dta", replace


********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES- not started
********************************************************************************
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", clear
merge m:1 hhid   using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_household_diet.dta", nogen
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", nogen keep (1 3)
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", nogen keep (1 3)

*land rights
merge 1:1 hhid indidy4 using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1		
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

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
foreach v of varlist *hybrid_seed*{
	replace `v' = .
}
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
*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0
* NA in TZA NPS_LSMS-ISA
gen women_diet=.
replace number_foodgroup=.

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren hhid hhid
ren indidy4 indid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2019-20"
/*to be updated
gen instrument = 4
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
*/

*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_w8_final_data}/Uganda_NPS_w8_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0
saveold "${Uganda_NPS_w8_final_data}/Uganda_NPS_w8_individual_variables.dta", replace


********************************************************************************
*PLOT -LEVEL VARIABLES - not started
********************************************************************************
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_cropvalue.dta", clear
merge 1:1 hhid plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_parcel_areas.dta", keep (1 3) nogen
merge 1:1 hhid plot_id  using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", keep (1 3) nogen
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_family_hired_labor.dta", keep (1 3) nogen
replace area_meas_hectares=area_est_hectares if area_meas_hectares==.
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
_pctile plot_value_harvest  [aw=weight] , p($wins_upper_thres) 
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"
gen plot_weight=w_area_meas_hectares*weight 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	
	
global monetary_val plot_value_harvest plot_productivity plot_labor_prod 
foreach p of varlist $monetary_val {
	gen `p'_1ppp = (1+$Uganda_NPS_w8_inflation) * `p' / $Uganda_NPS_w8_cons_ppp_dollar 
	gen `p'_2ppp = (1+$Uganda_NPS_w8_inflation) * `p' / $Uganda_NPS_w8_gdp_ppp_dollar 
	gen `p'_usd = (1+$Uganda_NPS_w8_inflation) * `p' / $Uganda_NPS_w8_exchange_rate
	gen `p'_loc = (1+$Uganda_NPS_w8_inflation) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2016 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2016 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2016 $ USD)"
	lab var `p'_loc "`l`p'' (2016 TSH)"  
	lab var `p' "`l`p'' (TSH)"  
	gen w_`p'_1ppp = (1+$Uganda_NPS_w8_inflation) * w_`p' / $Uganda_NPS_w8_cons_ppp_dollar 
	gen w_`p'_2ppp = (1+$Uganda_NPS_w8_inflation) * w_`p' / $Uganda_NPS_w8_gdp_ppp_dollar 
	gen w_`p'_usd = (1+$Uganda_NPS_w8_inflation) * w_`p' / $Uganda_NPS_w8_exchange_rate 
	gen w_`p'_loc = (1+$Uganda_NPS_w8_inflation) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2016 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2016 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2016 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2016 TSH)"
	lab var w_`p' "`lw_`p'' (TSH)"  
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) 
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

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
	}

foreach i in 1ppp 2ppp loc{
	gen w_plot_labor_prod_all_`i'=w_plot_labor_prod_`i'
	gen w_plot_labor_prod_female_`i'=w_plot_labor_prod_`i' if dm_gender==2
	gen w_plot_labor_prod_male_`i'=w_plot_labor_prod_`i' if dm_gender==1
	gen w_plot_labor_prod_mixed_`i'=w_plot_labor_prod_`i' if dm_gender==3
}

gen plot_labor_weight= w_labor_total*weight
//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren HHID hhid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2019-20"
/*to be updated
gen instrument = 4
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
	*/
label values instrument instrument	
saveold "${Uganda_NPS_w8_final_data}/Uganda_NPS_w8_field_plot_variables.dta", replace


********************************************************************************
*SUMMARY STATISTICS - not started
******************************************************************************** 
/* 
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Uganda_NPS_w8"
do "${directory}\EPAR_UW_335_SUMMARY_STATISTICS_01.17.2020.do" 
*/