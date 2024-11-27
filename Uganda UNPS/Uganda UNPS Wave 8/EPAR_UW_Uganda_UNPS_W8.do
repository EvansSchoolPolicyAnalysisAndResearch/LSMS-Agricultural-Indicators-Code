
/*
--------------------------------------------------------------------------------------
*Title/Purpose: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) for the construction of a set of agricultural development indicators using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 8 (2019-20)

*Author(s): Didier Alia, Andrew Tomes, Peter Agamile & C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of Pierre Biscaye, David Coomes, Nina Forbes, Joshua Grandbouche, Basil Hariri, Conor Hennessy, Marina Kaminsky, Claire Kasinadhuni, Sammi Kiel, Jack Knauer, Josh Merfeld, Adam Porton, Ahana Raina, Nezih Evren, Travis Reynolds, Carly Schmidt, Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, and Sebastian Wood, members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions.
															 
*Date : 21st May 2024

*Dataset Version: UGA_2019_UNPS_v03_M 
--------------------------------------------------------------------------------------
*/

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
*in the folder "\Uganda NPS - LSMS-ISA - Wave 8 (2019-20)\Uganda_NPS_W8_created_data" within the "Final DTA files" folder. // update
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Uganda NPS - LSMS-ISA - Wave 8 (2019-20)" within the "Final DTA files" folder. // update

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager or farm size.
*The results are outputted in the excel file "Uganda_NPS_W8_summary_stats.xlsx" in the "Uganda NPS - LSMS-ISA - Wave 8 (2019-20)" within the "Final DTA files" folder. // update
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

*MONOCROPPED PLOTS					Uganda_NPS_W8_[CROP]_monocrop_hh_area.dta
									
*TLU (Tropical Livestock Units)		Uganda_NPS_W8_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W8_tempcrop_harvest.dta
									Uganda_NPS_W8_tempcrop_sales.dta
									Uganda_NPS_W8_permcrop_harvest.dta
									Uganda_NPS_W8_permcrop_sales.dta
									Uganda_NPS_W8_hh_crop_production.dta
									Uganda_NPS_W8_plot_cropvalue.dta
									Uganda_NPS_W8_crop_residues.dta
									Uganda_NPS_W8_hh_crop_prices.dta
									Uganda_NPS_W8_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_W8_wages_mainseason.dta
									Uganda_NPS_W8_wages_shortseason.dta
									Uganda_NPS_W8_fertilizer_costs.dta
									Uganda_NPS_W8_seed_costs.dta
									Uganda_NPS_W8_land_rental_costs.dta
									Uganda_NPS_W8_asset_rental_costs.dta
									Uganda_NPS_W8_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W8_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W8_livestock_expenses.dta
									Uganda_NPS_W8_hh_livestock_products.dta
									Uganda_NPS_W8_dung.dta
									Uganda_NPS_W8_livestock_sales.dta
									Uganda_NPS_W8_TLU.dta
									Uganda_NPS_W8_livestock_income.dta

*FISH INCOME						Uganda_NPS_W8_fishing_expenses_1.dta
									Uganda_NPS_W8_fishing_expenses_2.dta
									Uganda_NPS_W8_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W8_self_employment_income.dta
									Uganda_NPS_W8_agproducts_profits.dta
									Uganda_NPS_W8_fish_trading_revenue.dta
									Uganda_NPS_W8_fish_trading_other_costs.dta
									Uganda_NPS_W8_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_W8_wage_income.dta
									Uganda_NPS_W8_agwage_income.dta

*OTHER INCOME						Uganda_NPS_W8_other_income.dta
									Uganda_NPS_W8_land_rental_income.dta
									
*FARM SIZE / LAND SIZE				Uganda_NPS_W8_land_size.dta
									Uganda_NPS_W8_farmsize_all_agland.dta
									Uganda_NPS_W8_land_size_all.dta
									Uganda_NPS_W8_land_size_total.dta

*OFF-FARM HOURS						Uganda_NPS_W8_off_farm_hours.dta

*FARM LABOR							Uganda_NPS_W8_farmlabor_mainseason.dta
									Uganda_NPS_W8_farmlabor_shortseason.dta
									Uganda_NPS_W8_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_W8_vaccine.dta
									Uganda_NPS_W8_farmer_vaccine.dta
									
*ANIMAL HEALTH						Uganda_NPS_W8_livestock_diseases.dta
									Uganda_NPS_W8_livestock_feed_water_house.dta

*USE OF INORGANIC FERTILIZER		Uganda_NPS_W8_fert_use.dta
									Uganda_NPS_W8_farmer_fert_use.dta

*USE OF IMPROVED SEED				Uganda_NPS_W8_improvedseed_use.dta
									Uganda_NPS_W8_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W8_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W8_fin_serv.dta
*MILK PRODUCTIVITY					Uganda_NPS_W8_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W8_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W8_hh_rental_rate.dta
									Uganda_NPS_W8_hh_cost_land.dta
									Uganda_NPS_W8_hh_cost_inputs_lrs.dta
									Uganda_NPS_W8_hh_cost_inputs_srs.dta
									Uganda_NPS_W8_hh_cost_seed_lrs.dta
									Uganda_NPS_W8_hh_cost_seed_srs.dta
									Uganda_NPS_W8_asset_rental_costs.dta
									Uganda_NPS_W8_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Uganda_NPS_W8_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W8_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W8_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W8_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W8_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W8_ownasset.dta

*CROP YIELDS						Uganda_NPS_W8_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_W8_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_W8_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_W8_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_W8_hh_assets.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W8_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W8_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W8_field_plot_variables.dta
*SUMMARY STATISTICS					Uganda_NPS_W8_summary_stats.xlsx
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

global directory  "../.."
global Uganda_NPS_W8_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 8/Raw DTA Files"
global Uganda_NPS_W8_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 8/Final DTA Files/created_data"
global Uganda_NPS_W8_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 8/Final DTA Files/final_data"
global Uganda_NPS_conv_factors "$directory/Uganda UNPS/Nonstandard Unit Conversion Factors"
global summary_stats "$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do" //Path to the summary statistics file. This can take a long time to run, so comment out if you don't need it. The do file will end with an error.

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************

//global Uganda_NPS_W8_exchange_rate 3376.4246		// Rate of Jan 1, 2015 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2016.html (Can we get historical rate from bloomberg?) // RH: average exchrt for 2019 was 3704.5036 UGX. Use that instead of Jan 1,2015?
global Uganda_NPS_W8_exchange_rate 3704.5036		// Average rate of 2019 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2019.html
global Uganda_NPS_W8_gdp_ppp_dollar 1251.63  //1270.608398 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PPP
global Uganda_NPS_W8_cons_ppp_dollar 1219.19 //1221.087646 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP
global Uganda_NPS_W8_inflation 1.09056114201 //CPI_SURVEY_YEAR/CPI_2017 -> CPI_2020/CPI_2017 -> 181.882451/166.7787747 The data were collected over the period February 2019 - February 2020.
global Uganda_NPS_W8_poverty_190 ((1.90*944.255)*(181.882451/116.6))
global Uganda_NPS_W8_poverty_215 (2.15 * ($Uganda_NPS_W8_inflation) * $Uganda_NPS_W8_cons_ppp_dollar) 
*global Uganda_NPS_W8_poverty_npl (361*183.9/267.5) 
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
global topcropname_area  "maize cassav beans fldpea swtptt fmillt sybea banana coffee grdnt sorgum"
global topcrop_area "130 630 210 221 620 141 320 740 810 310 150"
global comma_topcrop_area "130, 630, 210, 221, 620, 141, 320, 740, 810, 310, 150"
global topcropname_area_full "maize cassava beans fieldpeas sweetpotato fingermillet soyabeans banana coffee groundnut sorghum"
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropname_table.dta", replace
********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "${Uganda_NPS_W8_raw_data}\HH\gsec1", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", replace

********************************************************************************
*WEIGHTS
********************************************************************************
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", clear
recast str32 hhid
tempfile recast
save `recast'
use "${Uganda_NPS_W8_raw_data}\HH\gsec1", clear
recast str32 hhid
ren wgt weight
merge m:1 hhid using `recast', nogen
keep hhid weight rural
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", replace

********************************************************************************
*INDIVIDUAL IDS
********************************************************************************
use "${Uganda_NPS_W8_raw_data}\HH\gsec2", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", replace
 
********************************************************************************
*HOUSEHOLD SIZE -
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/HH/gsec2.dta", clear

*ren hhid HHID // using hhid
gen hh_members = 1
rename h2q4 relhead //relationship to HH head
rename h2q3 gender
recast str32 hhid
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhsize.dta", replace

//Weight update
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(2 3)

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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhsize.dta", replace
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", nogen
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", replace

********************************************************************************
** GEOVARIABLES ** 
********************************************************************************
//could not find a raw data file with geovariable information. Coming back to assess later.

****************************************************************
*PARCEL AREAS -- 
****************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec4a.dta", clear
gen season=1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec4b.dta"
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
 
use "${Uganda_NPS_W8_raw_data}/Agric/agsec3b.dta", clear
recast str32 hhid
tempfile sec3b
save `sec3b'
 
//ALT 04.13.22: So there's ~7500 unique plot identifiers but only 2753 have measurements. This is going to make crop area estimation a pain in the bidinski. 
use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a.dta", clear
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
//save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace

use "${Uganda_NPS_W8_raw_data}/Agric/agsec2a.dta", clear 
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec2b.dta"
//no plot id in agsec2
recast str32 hhid
merge 1:m hhid parcelID using `plot_area', nogen keep (1 3) // 879 not matched from master //ALT 4.13: down to 392; we have reported areas for 328. Are they not cultivated?

*bys hhid parcelID plot_id: egen parcel_area = sum(plot_area)
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
save "${Uganda_NPS_W8_created_data}\Uganda_NPS_W8_parcel_areas.dta", replace

****************************************************************
*PLOT AREA 
****************************************************************
tempfile file1 file2
use "${Uganda_NPS_W8_raw_data}/Agric/agsec2a.dta", clear
recast str32 hhid
save `file1'

use "${Uganda_NPS_W8_raw_data}/Agric/agsec2b.dta", clear
recast str32 hhid
save `file2'

use "${Uganda_NPS_W8_raw_data}/Agric/agsec4a.dta", clear
gen season=1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec4b.dta", generate(last)
recast str32 hhid
replace season=2 if last==1
label var season "Season = 1 if 1st cropping season of 2018, 2 if 2nd cropping season of 2018"
gen plot_area=s4aq07 //values are in acres (Total area of plot planted) a4aq9 percentage of crop planted in the plot area 
replace plot_area = s4bq07 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
rename plot_area ha_planted

gen percent_planted = s4aq09/100
replace percent_planted = s4bq09/100 if percent_planted==.
replace percent_planted = 1 if percent_planted==.
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace 

****************************************************************
*PLOT DECISION MAKERS  
****************************************************************
**GENDER MERGE**
use "${Uganda_NPS_W8_raw_data}\HH\gsec2.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge.dta", replace

*Decision makers asked about at PLOT level
use "${Uganda_NPS_W8_raw_data}\Agric\agsec3a.dta", clear // OWNED PLOTS
gen season=1
append using "${Uganda_NPS_W8_raw_data}\Agric\agsec3b.dta" // NON-OWNED PLOTS
replace season=2 if season==.
ren parcelID parcel_id
ren pltid plot_id
drop if parcel_id==.

recast str32 hhid

*First decision-maker variables 
gen indiv1 = s3aq03_3
replace indiv1 = s3bq03_3 if indiv1 == . & s3bq03_3 != .
//merge m:1 hhid indiv using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge.dta", gen(dm1_merge) keep(1 3) //6969 not matched
//gen dm1_female = female
//drop female indiv

*Second decision-maker variables
gen indiv2 = s3aq03_4a
replace indiv2 = s3bq03_4a if indiv2 == . &  s3bq03_4a != .
gen indiv3 = s3aq03_4b
replace indiv3 = s3bq03_4b if indiv3 == . &  s3bq03_4b != .
keep hhid parcel_id plot_id season indiv* 
reshape long indiv, i(hhid parcel_id plot_id season) j(individ)
keep if indiv!=.
merge m:1 hhid indiv using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge.dta", gen(dm_merge) keep(1 3)	 

//drop female indiv

*They only collected information on two decision-makers per plot - no 3rd decision maker.
collapse (mean) female, by(hhid parcel_id plot_id season)
gen dm_gender = 1 + female
replace dm_gender = 3 if dm_gender!=1 & dm_gender!=2

*collapse (max) dm1_female dm2_female, by (hhid parcel_id plot_id season)

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
//keep hhid parcel_id plot_id season dm*
//gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & (dm2_female == 0 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
//replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & (dm2_female == 1 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
//replace dm_gender = 3 if dm_gender == . & !(dm1_female == . & dm2_female == .) //no mixed-gender managed plots
label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhsize.dta", nogen //593 not matched
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . //593 dropped
drop if parcel_id==.
duplicates report hhid plot_id season
keep hhid parcel_id plot_id season dm_gender fhh //***cultivated, also plotname was here but is not a variable in this wave
***lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec2a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec2b.dta"
replace season = 2 if season ==.
recast str32 hhid
gen formal_land_rights = 1 if s2aq23<4
replace formal_land_rights = 0 if s2aq23==4 

*Starting with first owner
preserve
rename s2aq24__0 indivi
tostring indivi, gen(individ)
merge m:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", nogen keep(3)		// keep only matched
keep hhid individ female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve
ren s2aq24__1 indivi
tostring indivi, gen(individ)
merge m:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", nogen keep(3)	
keep hhid individ female
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid individ)		
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_rights_ind.dta", replace
restore	

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_rights_hh.dta", replace
restore

********************************************************************************
** 								ALL PLOTS									  ** 
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
use "${Uganda_NPS_W8_raw_data}/Agric/agsec5a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec5b.dta"
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

merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keepusing (region district_name county subcounty_name parish_name weight) keep(1 3)
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
use "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", replace

use "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", replace
restore

***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for hhid with missiong regional information. 
merge m:1 crop_code sold_unit_code using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

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
use "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table.dta", replace

use "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table_national.dta", clear
ren crop_code crop_code
save "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table_national.dta", replace
restore

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
merge m:1 crop_code unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${Uganda_NPS_conv_factors}/UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_value.dta", replace 

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
use "${Uganda_NPS_W8_raw_data}/Agric/agsec4a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec4b.dta"
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
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3)

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
//merge m:m hhid parcel_id plot_id crop_code season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_vals_hhids.dta", nogen
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

* 7/24/23 Update: Incorporating median standard price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors 
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
	save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_prices_for_wages2.dta", replace
	restore	

*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field s_quant_harv_kg s_value_harvest (max) months_grown plant_date harv_date harv_end, by(region district county subcounty parish hhid parcel_id plot_id season crop_code_master purestand field_size /*month_planted month_harvest*/)
	bys hhid parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys hhid parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	ren crop_code_master crop_code
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace


********************************************************************************
** 								GROSS CROP REVENUE							  ** 
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec5a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec5b.dta"
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

merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keepusing(region district_name county subcounty_name parish_name)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code using "${Uganda_NPS_conv_factors}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = sold_qty*s_conv_factor_sold
recode crop_code  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
collapse (sum) sold_value kgs_sold, by (hhid crop_code)
lab var sold_value "Value of sales of this crop"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropsales_value.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", clear
*ren crop_code_master crop_code
collapse (sum) value_harvest quant_harv_kg  , by (hhid crop_code) // Update: We start using the standarized version of value harvested and kg harvested
merge 1:1 hhid crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropsales_value.dta"
recode value_harvest sold_value (.=0)
replace value_harvest = sold_value if sold_value>value_harvest & sold_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sold_value value_crop_sales
*recode value_harvest value_crop_sales (.=0)
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production.dta", replace
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Uganda_NPS_W8_raw_data}/Agric/agsec5a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec5b.dta"
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

merge m:1 hhid crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by(hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_losses.dta", replace

********************************************************************************
*CROP EXPENSES 
******************************************************************************** 
*Expenses: Hired labor
use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b.dta"
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

merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3)
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
use "${Uganda_NPS_W8_raw_data}/Agric/AGSEC3A_1.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/AGSEC3B_1.dta"
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
use "${Uganda_NPS_W8_raw_data}/HH/gsec2.dta", clear
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
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3)
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
*  Because he got total days of work for family labor but not for each individual on the hhhd we need to divide total days by number of  subgroups of gender that were included as workers in the farm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective ofgender)
*by hhid parcel_id plot_id season, sort: egen numworkers = count(_n)
*replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days 
append using `all_hired'
keep region district_name county subcounty_name parish_name hhid parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(hhid parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (UGX)"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (hhid parcel_id plot_id labor_type)
reshape wide labor_, i(hhid parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		*la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_labor_days.dta", replace
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(hhid parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_labor.dta", replace
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_cost_labor.dta", replace

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES ** 9/2/23 LM (need to run the whole section to work)
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.
**********************    PESTICIDES/HERBICIDES   ******************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a", clear 
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b"
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
use "${Uganda_NPS_W8_raw_data}/Agric/agsec10", clear 
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
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", clear
collapse (sum) ha_planted, by(hhid)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore

preserve
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", clear
merge m:1 hhid using `ha_planted_total', nogen
gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted /  ha_planted_total its total area planted for both seasons per HHID 
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
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3)
save `plot_inputs'

******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a", clear 
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b"
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
use "${Uganda_NPS_W8_raw_data}/Agric/agsec2b", clear 
ren parcelID parcel_id
ren a2bq09 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
recast str32 hhid
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace
merge m:1 hhid parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_rental.dta", nogen keep (3)
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


****************************     SEEDS      **********************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec4a", clear 
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec4b"
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
* What should we do with Tin (20 and 5 lts) and plastic bins (15lts), assume 1lt = 1kg? 
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
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
drop region district_name county county_code subcounty_name subcounty_code parish_name parish_code weight rural 
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep (1 3) //merge in regional data
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
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep (1 3) //merge in regional data
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_quantities.dta", replace
restore

append using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_labor.dta"
collapse (sum) val, by (hhid parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs_long.dta", replace

preserve
collapse (sum) val, by(hhid exp input) 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_cost_inputs_long.dta", replace
restore

preserve
collapse (sum) val_ = val, by(hhid parcel_id plot_id season exp dm_gender)
reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs.dta", replace //This gets used below.
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_cost_inputs_verbose.dta", replace 

//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace 
collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs_long.dta", clear
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
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
*tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid) //JHG 7_5_22: double-check this section to make sure there is now weirdness with summing up to household level when there are multiple seasons - was too tired when coding this to go back and check
//Renaming variables to plug into later steps
//check for mixed?
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_cost_inputs.dta", replace

********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************

*Purpose: Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots

//Setting things up for AgQuery first
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace
keep if purestand == 1
ren crop_code cropcode
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_monocrop_plots.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace
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
drop if `cn'_monocrop_ha == 0 | `cn'_monocrop_ha==.	
ren kgs_harv_mono kgs_harv_mono_`cn'
ren val_harv_mono val_harv_mono_`cn'
gen `cn'_monocrop = 1
la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_`cn'_monocrop.dta", replace
	
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

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_`cn'_monocrop_hh_area.dta", replace
restore
}
/*
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs_long.dta", clear
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
	merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_inputs_`cn'.dta", replace
restore
}
*/
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
    preserve
        keep if strmatch(exp, "exp")
        drop exp
        levelsof input, clean l(input_names)
        ren val val_
		
        gen dummy = _n

        reshape wide val_, i(hhid parcel_id plot_id dm_gender season dummy) j(input) string

        ren val* val*_`cn'_
        gen dm_gender2 = "male" if dm_gender==1
        replace dm_gender2 = "female" if dm_gender==2
        replace dm_gender2 = "mixed" if dm_gender==3 | dm_gender==.
        drop dm_gender
    
        reshape wide val*, i(hhid parcel_id plot_id season dummy) j(dm_gender2) string

        merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_`cn'_monocrop.dta", nogen keep(3)
        collapse (sum) val*, by(hhid)
        
        foreach i in `input_names' {
            egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
        }

        // To do: labels
        save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_inputs_`cn'.dta", replace
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
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6a.dta", clear // livestock - large ruminants
rename LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_livestock.dta", replace

*For small animals
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6b.dta", clear 
rename ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6c.dta", clear
rename APCode livestockid
gen tlu_coefficient = 0.01 if (livestockid == 23 | livestockid == 24 | livestockid == 25 | livestockid == 26 | livestockid == 27) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_poultry_misc.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_livestock.dta", clear
append using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_small_animals.dta"
append using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_poultry_misc.dta"
label define livestockid 1 "EXOTIC/CROSS - Calves" 2 "EXOTIC/CROSS - Bulls" 3 "EXOTIC/CROSS - Oxen" 4 "EXOTIC/CROSS - Heifers" 5 "EXOTIC/CROSS - Cows" 6 "INDIGENOUS - Calves" 7 "INDIGENOUS - Bulls" 8 "INDIGENOUS - Oxen" 9 "INDIGENOUS - Heifers" 10 "INDIGENOUS - Cows" 11 "INDIGENOUS - Donkeys/mules" 12 "INDIGENOUS - Horses" 13 "EXOTIC/CROSS - Male goats" 14 "EXOTIC/CROSS - Female goats" 15 "EXOTIC/CROSS - Male sheep" 16 "EXOTIC/CROSS - Female sheep" 17 "EXOTIC/CROSS - Pigs" 18 "INDIGENOUS - Male goats" 19 "INDIGENOUS - Female goats" 20 "INDIGENOUS - Male sheep" 21 "INDIGENOUS - Female sheep" 22 "INDIGENOUS - Pigs" 23 "Indigenous dual-purpose chicken" 24 "Layers (exotic/cross chicken)" 25 "Broilers (Exotic/cross chicken)" 26 "Other poultry and birds (turkeys / ducks / geese)" 27 "Rabbits" 
label val livestockid livestockid 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_all_animals.dta", replace

**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine hhid and livestock data into a single sheet
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6a.dta", clear // livestock - large ruminants
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b.dta" // small ruminants
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c.dta" // poultry
gen livestockid = LiveStockID
merge m:m livestockid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_tlu_all_animals.dta", nogen
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
rename s6aq01 ls_ownership_today
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
rename s6bq01 sa_ownership_today
drop if sa_ownership == 2 //2 = see above
rename s6cq01 po_ownership_today
drop if po_ownership == 2 //2 = see above

rename s6aq03a ls_number_today_all
rename s6bq03a sa_number_today_all
rename s6cq03a po_number_today_all
gen livestock_number_today_all = ls_number_today_all
replace livestock_number_today_all = sa_number_today_all if livestock_number_today_all == .
replace livestock_number_today_all = po_number_today_all if livestock_number_today_all == .
lab var livestock_number_today_all "Number of animals owned at time of survey (see livestockid for type)"

gen nb_cattle_today = livestock_number_today_all if cattle == 1
gen nb_cows_today = livestock_number_today_all if cows == 1
gen nb_smallrum_today = livestock_number_today_all if smallrum == 1
gen nb_poultry_today = livestock_number_today_all if poultry == 1
gen nb_chickens_today = livestock_number_today_all if chickens == 1
gen nb_other_today = livestock_number_today_all if otherlivestock == 1
gen nb_tlu_today = livestock_number_today_all * tlu_coefficient

*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
rename s6aq06 ls_number_past
rename s6bq06 sa_number_past
rename s6cq06 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)" 
*Though, s6Xq06 refers to different types of animals the time of ownership asked in each question is different (12 months for livestock, 6 months for small animals, and 3 motnhs for poultry)

gen nb_cattle_past = livestock_number_past if cattle == 1
gen nb_cows_past = livestock_number_past if cows == 1
gen nb_smallrum_past = livestock_number_past if smallrum == 1
gen nb_poultry_past = livestock_number_past if poultry == 1
gen nb_chickens_past = livestock_number_past if chickens == 1
gen nb_other_past = livestock_number_past if otherlivestock == 1
gen nb_tlu_past = livestock_number_past * tlu_coefficient

//Step 3: Generate animal sales variables (sold alive)
rename s6aq14a nb_ls_sold
rename s6aq14b ls_avgvalue
rename s6bq14a nb_sa_sold
rename s6bq14b sa_avgvalue
rename s6cq14a nb_po_sold
rename s6cq14b po_avgvalue

gen nb_totalvalue = ls_avgvalue * nb_ls_sold
replace nb_totalvalue = sa_avgvalue * nb_sa_sold if nb_totalvalue == .
replace nb_totalvalue = po_avgvalue * nb_po_sold if nb_totalvalue == .

lab var ls_avgvalue "Avg value of each sold animal (livestock)"
lab var sa_avgvalue "Avg value of each sold animal (small animals)"
lab var po_avgvalue "Avg value of each sold animal (poultry)"
lab var nb_ls_sold "Number of animals sold alive (livestock)"
lab var nb_sa_sold "Number of animals sold alive (small animals)"
lab var nb_po_sold "Number of animals sold alive (poultry)"
lab var nb_totalvalue "Total value of animals sold alive"

recode nb_* (. = 0) //replace all null values for number variables with 0

//Step 4: Aggregate to household level. Clean up and save data
collapse (sum) nb*, by (hhid)

recast str50 hhid, force

lab var nb_ls_sold "Number of animals sold alive (livestock)"
lab var nb_sa_sold "Number of animals sold alive (small animals)"
lab var nb_po_sold "Number of animals sold alive (poultry)"
lab var nb_totalvalue "Total value of animals sold alive"
lab var nb_cattle_today "Number of cattle owned at time of survey"
lab var nb_cows_today "Number of cows owned at time of survey"
lab var nb_smallrum_today "Number of small ruminants owned at time of survey"
lab var nb_poultry_today "Number of poultry owned at time of survey"
lab var nb_chickens_today "Number of chickens owned at time of survey"
lab var nb_other_today "Number of other livestock (donkeys/mules & horses) owned at time of survey"
lab var nb_tlu_today "Number of Tropical Livestock Units at time of survey"
lab var nb_cattle_past "Number of cattle owned 12 months before survey"
lab var nb_cows_past "Number of cows owned 12 months before survey"
lab var nb_smallrum_past "Number of small ruminants owned 12 months before survey"
lab var nb_poultry_past "Number of poultry owned 12 months before survey"
lab var nb_chickens_past "Number of chickens owned 12 months before survey"
lab var nb_other_past "Number of other livestock (donkeys/mules & horses) owned 12 months before survey"
lab var nb_tlu_past "Number of Tropical Livestock Units 12 months before survey"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_TLU_Coefficients.dta", replace

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
use "${Uganda_NPS_W8_raw_data}\Agric\agsec7.dta", clear
ren s7q02e cost_fodder_livestock // "How much has this household paid to feed the [livestock] in [reference period]"
ren s7q03f cost_water_livestock // "Amount paid to access the main water sources for [livestock] in [ref period]"
ren s7q05d cost_vaccines_livestock /* Includes vaccine and professional fees */
ren s7q06c cost_deworm_livestock /* Includes cost of deworming and professional fees*/
ren s7q07c cost_ticks_livestock /*What was the total cost of the treatment of [...] against ticks, including cost of drugs and professional fee?*/
ren s7q08c cost_hired_labor_livestock // total cost of curative treatment
collapse (sum) cost*, by(hhid)

recast str50 hhid, force

tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_expenses.dta", replace
reshape long cost_, i(hhid) j(input) string
rename cost_ val_total
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_expenses_long.dta", replace // In case is needed for AgQuery


*****************************    LIVESTOCK PRODUCTS        *******************************
*1. Milk
// liters for all questions
//reference period = 12 mos large ruminants, 6mos small ruminants
use "${Uganda_NPS_W8_raw_data}\Agric\agsec8b.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products_milk.dta", replace


*2. Eggs
use "${Uganda_NPS_W8_raw_data}\Agric\agsec8c.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products_other", replace


*3. Meat - here if we want it but commenting it out for now
/*use "${Uganda_NPS_W8_raw_data}\Agric\agsec8a.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products_meat.dta", replace*/


*We append the 3 subsection of livestock earnings
append using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products_milk.dta"
recast str32 hhid
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products.dta", replace
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", nogen keep(1 3)
collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code)
ren price_per_unit price_unit_median_country
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products_prices_country.dta", replace
* Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products.dta", replace
merge m:1 livestock_code2 livestock_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products_prices_country.dta", nogen keep(1 3)
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products.dta", replace

*****************************    LIVESTOCK SOLD (LIVE)       *******************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6a", clear
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b"
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c"
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
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3) 
//keep hhid region rural weight district_code county_code scounty_code parish_code ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_livestock_sales.dta", replace

*Implicit prices (shorter)
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_livestock_sales", clear
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
gen value_livestock_sales = value_lvstck_sold + value_slaughtered //  Not sure about this, just following methodology of older UG w3 version (in this case,this inlclues the value of slaughtered animals for sales and own consumption)
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01value_slaughtered_sold*/, by (hhid)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
*lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.0 gen prop_meat_sold = value_slaughtered_sold/value_slaughtered*/ // 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_sales.dta", replace

 
********************************************************************************
**                                 TLU    		         	         	      **
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6a", clear
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b"
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c"
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

gen number_today_all= s6aq03a
replace number_today_all = s6bq03a if number_today_all==. 
replace number_today_all = s6cq03a if number_today_all==. 

gen number_today_exotic = number_today_all if inlist(livestock_code,1,2,3,4,5,13,14,15,16,17)

gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_all * tlu_coefficient
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
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3) 
foreach i in region district_name county subcounty_name parish_name {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

*gen value_start_agseas = number_start_agseas * price_per_animal
gen value_today = number_today_all * price_per_animal
gen value_1yearago = number_1yearago * price_per_animal
*gen value_today_est = number_today_all * price_per_animal_est

collapse (sum) number_today_all number_today_exotic number_1yearago lost_theft lost_other lost_disease animals_lost lvstck_holding=number_today_all value* tlu*, by(hhid species)
egen mean_12months=rowmean(number_today_all number_1yearago)
gen 	animals_lost12months	= animals_lost	
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_herd_characteristics_long.dta", replace //AgQuery

preserve
keep hhid species number_today_all number_today_exotic animals_lost12months number_1yearago /*animals_lost*/ lost_disease lost_other lost_theft lvstck_holding mean_12months
global lvstck_vars number_today_all number_today_exotic animals_lost12months number_1yearago lost_other lost_theft lost_disease lvstck_holding mean_12months
foreach i in $lvstck_vars {
	ren `i' `i'_
}
reshape wide $lvstck_vars, i(hhid) j(species) string
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
//drop lvstck_holding animals_lost_agseas mean_agseas lost_disease //No longer needed 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_herd_characteristics.dta", replace
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_TLU.dta", replace

 
*************************************************************************
*FISH INCOME - // Not included in this instrument
*************************************************************************
*No Fish Income data collected in Uganda w8. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/HH/gsec12_2.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_self_employment_income.dta", replace

*Processed crops 
// Not captured in w8 instrument (or other UGA waves)

*Fish trading
// Not captured in w8 instrument (or other UGA waves)

********************************************************************************
*                              OFF-FARM HOURS      	    	                   *
********************************************************************************

//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs)
use "${Uganda_NPS_W8_raw_data}\HH\gsec8.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_off_farm_hours.dta", replace


*************************************************************************
*NON-AG WAGE INCOME 
*************************************************************************
use "${Uganda_NPS_W8_raw_data}\HH\gsec8.dta", clear
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_wage_income.dta", replace


************************************************************************
*AG WAGE INCOME
************************************************************************
use "${Uganda_NPS_W8_raw_data}\HH\gsec8.dta", clear
recast str32 hhid
ren s8q04 wage_yesno 
ren s8q30 number_months // months worked for main job
ren s8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12

egen hours_pastweek = rowtotal(s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g)
gen number_hours = hours_pastweek*number_weeks

gen agwage = 1 if ((h8q19b_twoDigit>=61 & h8q19b_twoDigit<=63) | (h8q19b_twoDigit==92))	//Based on ISCO classifications used in Basic Information Document used for Wave 4; 61-63 are "Skilled Agricultural, Forestry, Fishery Labourers"; 92 is "Elementary Occupations, Agricultural, Forestry, Fishery Labourers"
gen secagwage = 1 if ((h8q38b_twoDigit>=61 & h8q38b_twoDigit<=63) | (h8q38b_twoDigit==92))	

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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_agwage_income.dta", replace

********************************************************************************
*                                OTHER INCOME 	        	    	           *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}\HH\gsec7_2.dta", clear
recast str32 hhid
gen rental_income_cash = s11q05 if (IncomeSource==21 | IncomeSource==22 | IncomeSource==23) //net rent from buildings/property; net rent from land; royalties. 
gen rental_income_inkind = s11q06 if (IncomeSource==21 | IncomeSource==22 | IncomeSource==23) //net rent from buildings/property; net rent from land; royalties. 
gen pension_income_cash = s11q05 if IncomeSource==41 // pension and life annuity 
gen pension_income_inkind = s11q06 if IncomeSource==41 // pension and life annuity 

gen other_income_cash = s11q05 if (IncomeSource==45 | IncomeSource==44 | IncomeSource==36 | IncomeSource==35 | IncomeSource==34 | IncomeSource==33 | IncomeSource==32 | IncomeSource==31) 
gen other_income_inkind = s11q06 if (IncomeSource==45 | IncomeSource==44 | IncomeSource==36 | IncomeSource==35 | IncomeSource==34 | IncomeSource==33 | IncomeSource==32 | IncomeSource==31)
//other income includes: other; income from sale of assets excluding livestock; payments from treasury bills; payments from bonds; dividends; interest from shares; interest from other type of account; interest from current account

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

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_other_income.dta", replace

********************************************************************************
*                            LAND RENTAL INCOME        	    	               *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}\Agric\agsec2a.dta", clear
recast str32 hhid
ren s2aq14 land_rental_income
recode land_rental_income (.=0)
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_rental_income.dta", replace


********************************************************************************
*LAND SIZE / FARM SIZE  
********************************************************************************

*Determining whether crops were grown on a plot
use "${Uganda_NPS_W8_raw_data}\Agric\agsec4a.dta", clear
append using "${Uganda_NPS_W8_raw_data}\Agric\agsec4b.dta"
ren parcelID parcel_id
drop if parcel_id==.
ren pltid plot_id
drop if plot_id==.
ren cropID crop_code
drop if crop_code==.
gen crop_grown = 1 
recast str32 hhid, force 
collapse (max) crop_grown, by(hhid parcel_id)
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crops_grown.dta", replace

**

use "${Uganda_NPS_W8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_W8_raw_data}\Agric\agsec2b.dta"
gen cultivated = (s2aq11a==1 | s2aq11b==1)

ren parcelID parcel_id
collapse (max) cultivated, by (hhid parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcels_cultivated.dta", replace

**
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcels_cultivated.dta", clear
recast str32 hhid, force 
merge 1:m hhid parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcel_areas.dta" // 3,741 not matched from master
drop if _merge==2
keep if cultivated==1
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0 
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
collapse (sum) parcel_area_acres_meas, by (hhid)
ren parcel_area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_size.dta", replace

**

*All agricultural land
use "${Uganda_NPS_W8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_W8_raw_data}\Agric\agsec2b.dta"
ren parcelID parcel_id
*drop if plot_id==.

recast str32 hhid 
merge m:1 hhid parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crops_grown.dta", nogen
*4,945 matched
*420 not matched (from master)
gen rented_out = (s2aq11a==3 | s2aq11b ==3) // what was or is the primary use of the parcel during the cropping season
gen cultivated_short = (s2aq11a==1 | s2aq11a==2 | s2aq11b ==1 | s2aq11b ==2) // own cultivated annual and perennial crops.

bys hhid parcel_id: egen plot_cult_short = max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
*39 obs dropped
gen agland = s2aq11a==1 | s2aq11a==2 | s2aq11a==5 | s2aq11a==6| s2aq11b==1 | s2aq11b==2 | s2aq11b==5 | s2aq11b==6 // includes cultivated, fallow, pasture

drop if agland!=1 & crop_grown==.
*143 obs dropped
collapse (max) agland, by (hhid parcel_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcels_agland.dta", replace

**
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcels_agland.dta", clear
merge 1:m hhid parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcel_areas.dta"
drop if _merge==2
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==0 & (parcel_area_acres_est>0 & parcel_area_acres_est!=.)	
collapse (sum) parcel_area_acres_meas, by (hhid)
ren parcel_area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmsize_all_agland.dta", replace

**
use "${Uganda_NPS_W8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_W8_raw_data}\Agric\agsec2b.dta"
ren parcelID parcel_id
drop if parcel_id==.
gen rented_out = (s2aq11a==3 | s2aq11b==3) 
gen cultivated_short = (s2aq11b==1 | s2aq11b==2) // is this supposed to be short season only? 

bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen parcel_held = 1
collapse (max) parcel_held, by (hhid parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcels_held.dta", replace

**
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcels_held.dta", clear
recast str32 hhid
merge 1:m hhid parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcel_areas.dta"
drop if _merge==2
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
collapse (sum) parcel_area_acres_meas, by (hhid)
ren parcel_area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_size_all.dta", replace

**
*Total land holding including cultivated and rented out
use "${Uganda_NPS_W8_raw_data}\Agric\agsec2a.dta", clear
append using "${Uganda_NPS_W8_raw_data}\Agric\agsec2a.dta"
ren parcelID parcel_id
drop if parcel_id==.
recast str32 hhid
merge m:m hhid parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_parcel_areas.dta", nogen keep(1 3)
replace parcel_area_acres_meas=. if parcel_area_acres_meas<0
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==. 
replace parcel_area_acres_meas = parcel_area_acres_est if parcel_area_acres_meas==0 & (parcel_area_acres_est>0 & parcel_area_acres_est!=.)	
collapse (max) parcel_area_acres_meas, by(hhid parcel_id)
ren parcel_area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_size_total.dta", replace

********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Uganda_NPS_W8_raw_data}\HH\gsec8.dta", clear
*Use ISIC codes for non-farm activities
egen primary_hours = rowtotal (s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if (h8q19b_twoDigit<61 | (h8q19b_twoDigit>63 & h8q19b_twoDigit<92) | h8q19b_twoDigit>92) //Based on ISCO classifications used in Basic Information Document used for Wave 8
egen secondary_hours = rowtotal (s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g) if (h8q19b_twoDigit<61 | (h8q19b_twoDigit>63 & h8q19b_twoDigit<92) | h8q19b_twoDigit>92) //Based on ISCO classifications used in Basic Information Document used for Wave 8

egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)

recast str50 hhid, force

la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_off_farm_hours.dta", replace


********************************************************************************
*								FARM LABOR 							   *
********************************************************************************

//ALT: Plot level indicators are used, hh-level indicators are not.
//ALT: Replaced in crop expenses. This code here for legacy file compatibility.
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_labor_long.dta", clear

recast str50 hhid, force

drop if strmatch(gender,"all")
ren days labor_
preserve //ALT 02.07.22: quick 'n' dirty fix for individual section
collapse (sum) labor_total = labor_, by(hhid plot_id)
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_farmlabor.dta", replace
restore
collapse (sum) labor_, by(hhid labor_type gender)
reshape wide labor_, i(hhid gender) j(labor_type) string
drop if strmatch(gender,"")
ren labor* labor*_
reshape wide labor*, i(hhid) j(gender) string
egen labor_total=rowtotal(labor*)
egen labor_hired = rowtotal(labor_hired*)
egen labor_family = rowtotal(labor_family*)
*egen labor_nonhired = rowtotal(labor_nonhired*)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"		
lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"		
*lab var labor_nonhired "Total days for exchange labor in the past year."
keep hhid labor_total labor_hired labor_family labor_hired_male labor_hired_female /*labor_nonhired*/

recast str50 hhid, force

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_family_hired_labor.dta", replace


************************************************************************
*VACCINE USAGE 
************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec7", clear
// vaccines now only in livestock inputs section

recast str32 hhid, force // for merge
gen livestock_code = AGroup_ID // should this have a different name from other livestock_code vars? (specific animal codes vs categories like large/small ruminants) this is categories 


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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_vaccine.dta", replace


*vaccine use livestock keeper
*this section of the code identifies livestock keepers, and whether the livestock keeper uses vaccines (merged with gender)  

*agsec6* has the livestock keepers, but files are split by livestock category (a is large ruminants, b is small ruminants, c is poultry, no file for pigs)
*s6cq03d: who keeps the %rostertitle% that your household owns (PID1)
*s6cq03e: who keeps the %rostertitle% that your household owns (PID2)

use "${Uganda_NPS_W8_raw_data}/Agric/agsec6a.dta", clear
gen lvstckcat =.
replace lvstckcat = 101 if (LiveStockID == 1|LiveStockID==2|LiveStockID==3|LiveStockID==4|LiveStockID==5) // 101 = Exotic/Cross Large Rums
replace lvstckcat = 105 if (LiveStockID == 6|LiveStockID==7|LiveStockID==8|LiveStockID==9|LiveStockID==10|LiveStockID==11|LiveStockID==12) // 105 = indigenous large rums
gen farmerid1 = s6aq03b if s6aq03b!=. // who keeps the rostertitle PID1 
gen farmerid2 = s6aq03c if s6aq03c!=. // who keeps the rostertitle PID1
*replace farmerid1 

append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b.dta"
replace lvstckcat = 102 if (ALiveStock_Small_ID == 13|ALiveStock_Small_ID==14|ALiveStock_Small_ID==15|ALiveStock_Small_ID==16|ALiveStock_Small_ID==17) // exotic/cross small rums
replace lvstckcat = 106 if (ALiveStock_Small_ID == 18|ALiveStock_Small_ID==19|ALiveStock_Small_ID==20|ALiveStock_Small_ID==21|ALiveStock_Small_ID==22) // indigenous small rums
replace farmerid1 = s6bq03b if farmerid1==. & s6bq03b!=. // who keeps the rostertitle PID1 
replace farmerid2 = s6bq03c if farmerid2==. & s6bq03c!=. // who keeps the rostertitle PID1

append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c.dta"
replace lvstckcat = 103 if (APCode == 24|APCode==25) // Exotic.cross - poultry
replace lvstckcat = 107 if (APCode == 23|APCode==26|APCode==27) // indigenous - poultry
replace farmerid1 = s6cq03b if farmerid1==. & s6cq03b!=. // who keeps the rostertitle PID1 
replace farmerid2 = s6bq03c if farmerid2==. & s6bq03c!=. // who keeps the rostertitle PID1

recast str32 hhid
tempfile temp_agsec6
save `temp_agsec6' 

use "${Uganda_NPS_W8_raw_data}/Agric/agsec7.dta", clear
ren AGroup_ID lvstckcat
recast str32 hhid

merge 1:m hhid lvstckcat using `temp_agsec6', nogen keep (1 3) // not matched = 484, matched = 5540

*"${Uganda_NPS_W8_raw_data}/lf_sec_05.dta", nogen keep (1 3)

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
merge 1:1 hhid indiv using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"

*ren personid indidy4 // rh flag - personid to PID?
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_vaccine.dta", replace


********************************************************************************
*          ANIMAL HEALTH - DISEASES - LM updated to ALT request 11/15          *
********************************************************************************
*Can't construct - instrument does not collect types of disease 


********************************************************************************
*                  LIVESTOCK WATER, FEEDING, AND HOUSING                       *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6a.dta", clear
keep if s6aq01==1

use "${Uganda_NPS_W8_raw_data}/Agric/agsec7.dta", clear

gen feed_grazing = (s7q02a==1 |  s7q02a==2 |  s7q02b==1 |  s7q02b==2) 
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat = (s7q03b==5 | s7q03b==6 | s7q03b==7 | s7q03b==9 | s7q03c==5 | s7q03c==6 | s7q03c==7 | s7q03c==9) 
gen water_source_const = (s7q03b==1 | s7q03b==2 | s7q03b==3 | s7q03b==9 | s7q03c==1 | s7q03c==2 | s7q03c==3 | s7q03c==9)
gen water_source_cover = (s7q03b==4 | s7q03b==8 | s7q03b==10 | s7q03c==4 | s7q03c==8 | s7q03c==10) 
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
gen lvstck_housed = (s7q04==2 | s7q04==3 | s7q04==4 | s7q04==5 | s7q04==6 | s7q04==7)
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
recast str50 hhid, force

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_feed_water_house.dta", replace


********************************************************************************
*                  USE OF INORGANIC FERTILIZER                                 *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}\Agric\agsec3a.dta", clear
gen season = 1

append using "${Uganda_NPS_W8_raw_data}\Agric\agsec3b.dta"
replace season = 2 if missing(season)

ren parcelID parcel_id
ren pltid plot_id

gen use_inorg_fert = (s3aq13 == 1 | s3bq13 == 1) if (s3aq13 != . | s3bq13 != .)

collapse (max) use_inorg_fert, by(hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_fert_use.dta", replace

use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a.dta", clear
gen season = 1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b.dta"
replace season = 2 if missing(season)
ren parcelID parcel_id
ren pltid plot_id
drop if missing(plot_id)

gen all_use_inorg_fert = (s3aq13 == 1 | s3bq13 == 1) if (s3aq13 != . | s3bq13 != .)

ren s3aq03_3 farmerid3
tostring s3bq03_3, replace  
tostring farmerid3, replace
replace farmerid3 = s3bq03_3 if farmerid3 == ""

collapse (max) all_use_inorg_fert, by(hhid farmerid3)
drop if farmerid3 == ""
ren farmerid3 individ
recast str50 hhid, force
merge 1:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta"
drop if _merge == 2
drop _merge

keep hhid individ all_use_inorg_fert
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"

gen farm_manager = 1 if !missing(individ)
recode farm_manager (. = 0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot"

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_fert_use.dta", replace


********************************************************************************
*                             USE OF IMPROVED SEED                             *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec4a", clear
gen season=1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec4b"
replace season = 2 if season == .

* recode and combine improved seed variables
recode	s4aq13 s4bq13 		(1=0) (2=1) (.=0)
egen 	imprv_seed_use	= 	rowmax(s4aq13 s4bq13)
recode cropID  (741 742 744 = 740)
label define cropID 740 "BANANAS", modify
rename parcelID parcel_id
rename pltid plot_id
rename cropID crop_code
gen cropping_syst = s4aq07
replace cropping_syst = s4bq07 if cropping_syst ==.
collapse (max) imprv_seed_use, by(hhid parcel_id plot_id crop_code)
recast str50 hhid, force
tempfile imprv_seed
save `imprv_seed'

use "${Uganda_NPS_W8_raw_data}/Agric/agsec2a", clear
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec2b"
ren s2aq27__* indiv* 

rename parcelID parcel_id
drop if parcel_id==.
recast str32 hhid
keep indiv* hhid parcel_id

reshape long indiv, i(hhid parcel_id) j(indiv_number) string
drop if indiv==.
drop indiv_number
describe indiv
recast str50 hhid, force
merge m:1 hhid indiv using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge", nogen keep (1 3)

tempfile indivs
save `indivs'

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_quantities.dta", clear
foreach i in inorg_fert org_fert pest {
	recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'
}
collapse (max) use_*, by(hhid parcel_id plot_id)
merge 1:m hhid plot_id parcel_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", nogen keep(1 3) keepusing(crop_code)
*ren crop_code_master crop_code
collapse (max) use*, by(hhid plot_id parcel_id crop_code)
recast str50 hhid, force
merge 1:1 hhid parcel_id plot_id crop_code using `imprv_seed',nogen keep (1 3)
recode use* (.=0)
preserve 
keep hhid parcel_id plot_id crop_code imprv_seed_use
ren imprv_seed_use imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_imprvseed_crop.dta", replace 
restore 

merge m:m hhid parcel_id using `indivs', nogen keep(1 3)
preserve
ren imprv_seed_use all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_improvedseed_use_temp.dta", replace
restore

ren imprv_seed_use use_imprv_seed
collapse (max) use_*, by(hhid indiv female)
gen all_imprv_seed_use = use_imprv_seed 

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if indiv!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_fert_use.dta", replace 
restore


********************************************************************************
*                                PLOT MANAGERS        	                       *
********************************************************************************

//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${Uganda_NPS_W8_raw_data}/Agric/agsec4a", clear
gen season=1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec4b"
replace season = 2 if season == .
gen use_imprv_seed = (s4aq13==2) if s4aq13!=.
replace use_imprv_seed= (s4bq13==2) if use_imprv_seed==. & s4bq13!=.
*Crop Recode (Must check if applies for Uganda)
recode cropID  (741 742 744 = 740)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master

collapse (max) use_imprv_seed, by(hhid parcelID pltid cropID) 
rename parcelID parcel_id
rename pltid plot_id
rename cropID crop_code
tempfile imprv_seed
recast str50 hhid, force
*tostring hhid, format(%18.0f) replace
save `imprv_seed'

use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a", clear
gen season=1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b"
replace season = 2 if season == .
clonevar PID1 = s3aq03_3
replace PID1 = s3aq03_4a if s3aq03_2==2
replace PID1 = s3bq03_3 if PID1==.
replace PID1 = s3bq03_4a if PID1==. & s3bq03_2==2
clonevar PID2 = s3aq03_4b
replace PID2 = s3bq03_4b if PID2==. & s3bq03_2==2
keep hhid parcelID pltid PID* season
duplicates drop hhid parcelID pltid season, force 
reshape long PID, i(hhid parcelID pltid season) j(pidno)
drop pidno
drop if PID==.
tostring hhid, format(%18.0f) replace
*tostring PID, format(%19.0f) replace
*clonevar personid = PID
rename PID indiv
recast str50 hhid, force
merge m:1 hhid indiv using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge.dta", nogen keep(1 3)
*merge m:1 hhid personid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gender_merge.dta", nogen keep(1 3)
rename pltid plot_id
rename parcelID parcel_id
tempfile personids
save `personids'

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_quantities.dta", clear

foreach i in inorg_fert org_fert pest /*herb*/ {
	recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'
}
collapse (max) use_*, by(hhid parcel_id plot_id) // If in at least one season it used any of i it is coded as 1. 
merge 1:m hhid parcel_id plot_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", nogen keep(1 3) keepusing(crop_code)
collapse (max) use*, by(hhid parcel_id plot_id crop_code)

merge 1:1 hhid parcel_id plot_id crop_code using `imprv_seed',nogen keep(1 3)
recode use* (.=0)
preserve 
keep hhid parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
recast str50 hhid, force
merge m:1 crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropname_table.dta", nogen keep(3)
drop crop_code	
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_imprvseed_crop.dta", replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore
recast str50 hhid, force
merge m:m hhid parcel_id plot_id using `personids', nogen keep(1 3) // personids is at the plot season level while input quantities at the plot level
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropname_table.dta", nogen keep(3)
*decode crop_code, gen(crop_name)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
clonevar PID = indiv // need this for individual summary stats
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_improvedseed_use_temp.dta", replace
restore

collapse (max) use_*, by(hhid indiv female)
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
	save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_use.dta", replace
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if indiv!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	clonevar PID = indiv // need this for individual summary stats
	save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore

********************************************************************************
*                           REACHED BY AG EXTENSION                            *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec9b.dta", clear

gen receive_advice=(h9q03a__1==1 | h9q03a__2==1 | h9q03a__3==1 | h9q03a__4==1 | h9q03a__5==1 | h9q03a__7==1 | h9q03a__6==1) if (h9q03a__1!=. | h9q03a__2!=. | h9q03a__3!=. | h9q03a__4!=. | h9q03a__5!=. | h9q03a__7!=. | h9q03a__6!=.) // ag12b_08
preserve
use "${Uganda_NPS_W8_raw_data}/Agric/agsec9a.dta", clear
ren source_ID sourceid
tempfile UG_advice2
save `UG_advice2'
restore
append using  `UG_advice2' // why append?? these are not two seasons??

**Government Extension
gen advice_gov = (sourceid==1)
replace advice_gov = (sourceid==7) if advice_gov==0 

* Input supplier
gen advice_input_sup=(sourceid==2)
**NGO
gen advice_ngo = (sourceid==3)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==4)
**Large Scale Farmer
gen advice_farmer =(sourceid==5)
**Other
gen advice_other = (sourceid==6)

// not an option in UG data
/*
**Radio
gen advice_radio = (sourceid==5 & receive_advice==1)
**Publication 
gen advice_pub = (sourceid==6 & receive_advice==1)
**Neighbor
gen advice_neigh = (sourceid==7 & receive_advice==1)
*/

**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_input_sup==1 | advice_farmer==1)
gen ext_reach_unspecified=(advice_other==1)
*gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)

collapse (max) ext_reach_* advice_*, by(hhid)

lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"

recast str50 hhid, force

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_any_ext.dta", replace

********************************************************************************
*								HOUSEHOLD ASSETS							   *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/HH/gsec14.dta", clear
ren h14q05 value_today
ren h14q04 number_items_owned
*ren s5q3 age_item // UGA W8 does not have this raw data
gen value_assets = value_today*number_items_owned
//collapse (sum) value_assets=value_today, by(hhid)
collapse (sum) value_assets, by(hhid) //ALT 12.01.23: Bug fix
lab var value_assets "Value of household assets"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_assets.dta", replace 

********************************************************************************
*                      USE OF FORMAL FINANCIAL SERVICES                        * 
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/HH/gsec7_1", clear
append using "${Uganda_NPS_W8_raw_data}/HH/gsec7_4"

ta CB16__1, gen(bank)
ren bank2 borrow_bank

ta CB16__2, gen (micro1_)
ta CB16__3, gen (micro2_)
ta CB16__4, gen (micro3_)
ta CB16__5, gen (micro4_)
ta CB16__6, gen (micro5_)
ta CB16__7, gen (micro6_)
ta CB16__8, gen (micro7_)
ta CB16__10, gen (micro8_)
ta CB16__12, gen (micro10_)
ta CB16__13, gen (micro11_)
ta CB16__14, gen (micro12_)

egen borrow_micro = rowmax(micro1_2-micro12_2)
ta CB16__97, gen (fin1_)
ta CB16__96, gen (fin2_)
ren fin1_2 borrow_other_fin
replace borrow_other_fin=fin2_2 if borrow_other_fin==0 & fin2_2==1
ta CB16__9, gen(ngo)
ren ngo2 borrow_ngo
gen use_saving=0
foreach var of varlist CB06A CB06B CB06C CB06D CB06E CB06F CB06G CB06I CB06J{
	replace use_saving=1 if `var'==1
}

gen use_MM=CB06H==1
gen use_fin_serv_bank= CB06B==1
gen use_fin_serv_credit= borrow_bank==1 | borrow_micro==1 | borrow_ngo==1  | borrow_other_fin==1
gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= CB06X==1 
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_digital==1 | use_fin_serv_others==1  | use_fin_serv_credit==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
*lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_fin_serv.dta", replace


********************************************************************************
*                             MILK PRODUCTIVITY                                *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec8b.dta", clear
keep if AGroup_ID==101 | AGroup_ID==105 
gen milk_animals = s8bq01
gen days_milked = s8bq02*30.5
gen months_milked = s8bq02
*gen months_milked = round(days_milked/30.5)
gen liters_day = s8bq03 
gen liters_per_largerruminant = days_milked*liters_day
keep hhid milk_animals months_milked days_milked liters_per_largerruminant liters_day
label variable milk_animals "Number of large ruminants that were milked (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_milk_animals.dta", replace

gen liters_milk_produced = milk_animals*days_milked*liters_day
collapse (sum) milk_animals liters_milk_produced (mean) days_milked months_milked liters_day liters_per_largerruminant, by(hhid)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_milk_animals.dta", replace


********************************************************************************
*								EGG PRODUCTIVITY							   *
********************************************************************************

* First dataset
use "${Uganda_NPS_W8_raw_data}/Agric/agsec6c.dta", clear
gen poultry_owned = s6cq03a if (APCode==23 | APCode==24 | APCode==25) // Replaced with correct APcodes
*gen poultry_owned = s6cq03a if (APCode==1 | APCode==2 | APCode==3 | APCode==4)
collapse (sum) poultry_owned, by(hhid)

* Create a numeric identifier for hhid
egen hhid_num = group(hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

* Second dataset
use "${Uganda_NPS_W8_raw_data}/Agric/agsec8c.dta", clear
gen eggs_months = s8cq01/3        // number of layers was reported for the last three months thus the need to divide by 3 to get monthly total
gen eggs_per_month = s8cq02/3    // number of eggs laid was reported for the last three months thus the need to divide by 3 to get monthly total
collapse (sum) eggs_months eggs_per_month, by(hhid)
recast str50 hhid, force

* Create a numeric identifier for hhid
egen hhid_num = group(hhid)
recast str50 hhid, force
gen eggs_total_year = eggs_months*eggs_per_month*12     // multiply by 12 to get the annual total

* Merging datasets using the numeric identifier
merge 1:1 hhid_num using `eggs_animals_hh', nogen keep(1 3) 

* Keep and label necessary variables
keep hhid hhid_num eggs_months eggs_per_month eggs_total_year poultry_owned 
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poultry owned (household)"
recast str50 hhid, force

* Save the final dataset
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_eggs_animals.dta", replace


********************************************************************************
*                      CROP PRODUCTION COSTS PER HECTARE                       *
********************************************************************************

*All the preprocessing is done in the crop expenses section */
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace
replace dm_gender = 3 if dm_gender==.
collapse (sum) ha_planted /*area_plan*/ field_size, by(hhid parcel_id plot_id /*season purestand field_size*/) //  All plots section is unable to construct ha harvest variable (no information available)
duplicates drop hhid parcel_id plot_id /*season*/, force // 11 observations deleted
reshape long ha_, i(hhid parcel_id plot_id /*season purestand field_size*/) j(area_type) string
tempfile plot_areas
save `plot_areas' // Unit of Analysis: Plot - purestand level
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_cost_inputs_long.dta", replace
replace dm_gender = 3 if dm_gender==.
collapse (sum) cost_=val, by(hhid parcel_id plot_id /*season*/ dm_gender exp)
reshape wide cost_, i(hhid parcel_id plot_id  /*season*/ dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
drop cost_total
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropcosts.dta", replace

********************************************************************************
* 					    RATE OF FERTILIZER APPLICATION                         *
********************************************************************************
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace
collapse (sum) ha_planted /*area_plan*/, by(hhid parcel_id plot_id season/*season*/ dm_gender) // All plots section is unable to construct ha harvest variable
merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_quantities.dta", keep(1 3) nogen
collapse (sum) ha_planted /*area_plan*/ inorg_fert_rate org_fert_rate pest_rate, by(hhid parcel_id plot_id /*season*/ dm_gender) // at the plot level for both seasons
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==.
drop dm_gender
ren ha_planted ha_planted_
ren inorg_fert_rate fert_inorg_kg_ 
ren org_fert_rate fert_org_kg_ 
ren pest_rate pest_kg_
*ren herb_rate herb_kg_ // no herb information
drop if dm_gender2=="" 
reshape wide ha_planted_ fert_inorg_kg_ fert_org_kg_ pest_kg_ /*herb_kg_*/, i(hhid parcel_id plot_id) j(dm_gender2) string
collapse (sum) *male *mixed, by(hhid)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg fert_org_kg pest_kg /*herb_kg*/ {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", keep (1 3) nogen
_pctile ha_planted [aw=weight]  if ha_planted!=0 , p($wins_lower_thres $wins_upper_thres)
foreach x of varlist ha_planted ha_planted_male ha_planted_female ha_planted_mixed {
		replace `x' =r(r1) if `x' < r(r1)   & `x' !=. &  `x' !=0 
		replace `x' = r(r2) if  `x' > r(r2) & `x' !=.    
}
lab var fert_inorg_kg "Inorganic fertilizer (kgs) for household"
lab var fert_org_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
*lab var herb_kg "Herbicide (kgs) for household"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var fert_inorg_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var fert_org_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
*lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
}
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_fertilizer_application.dta", replace


********************************************************************************
* 						   WOMEN'S DIET QUALITY                                *
********************************************************************************
* Women's diet quality: proportion of women consuming nutrient-rich foods (%)
* Information not available

********************************************************************************
* 					HOUSEHOLD'S DIET DIVERSITY SCORE                           *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/HH/gsec15b", clear

* recode food items to map HDDS food categories
recode coicop_3 	(1111/1115				=1	"CEREALS" )  //// 
					(1175 1177 1179 		=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(1171/1174	 			=3	"VEGETABLES"	)  ////	
					(1161 1162 1165			=4	"FRUITS"	)  ////	
					(1121 1122 1125 		=5	"MEAT"	)  ////					
					(1148					=6	"EGGS"	)  ////
					(1131 1132 				=7  "FISH") ///
					(1168 1169 1176			=8	"LEGUMES, NUTS AND SEEDS") ///
					(1141 1143 1145 1146	=9	"MILK AND MILK PRODUCTS")  ////
					(1151/1153   			=10	"OILS AND FATS"	)  ////
					(1181 1184 1186 		=11	"SWEETS"	)  //// 
					(1193 1194              =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)		
gen adiet_yes=(CEB03==1)
ta Diet_ID  
drop if Diet_ID>14 
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid   Diet_ID) 

recast str50 hhid, force

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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_household_diet.dta", replace


********************************************************************************
*                       WOMEN'S CONTROL OVER INCOME                            *
********************************************************************************

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
use "${Uganda_NPS_W8_raw_data}/Agric/agsec5a", clear   	// use of crop sales earnings/output - s5aq11f_1 s5aq11g s5aq11h/ s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec5b" 	// use of crop sales earnings/output - s5bq11f_1 s5bq11g s5bq11h/ s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6a" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c" 	//owns poultry - s6cq03b s6cq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec8a" 	// meat production - who controls the revenue - s8aq06a s8aq06b
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec8b" 	// milk production - who controls the revenue - s8bq10a s8bq10b
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec8c" 	// egg production - who controls the revenue - s8cq6a s8cq6b
append using "${Uganda_NPS_W8_raw_data}/HH/gsec8"	// wage control (s8q31d1 s8q31d2 for primary) (s8q45d1 s8q45d2 for secondary)
append using "${Uganda_NPS_W8_raw_data}/HH/gsec7_1" //other hh income data does not contain explit identification of controller but decided to use the identity of "person responsible for the income section in the survey"

append using "${Uganda_NPS_W8_raw_data}/HH/gsec12_2" //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b
recast str50 hhid, force
gen type_decision="" 
gen controller_income1=.
gen controller_income2=. 

* Control Over Harvest from Crops *
/*rename s5aq06a_2_1, gen(s5aq06a_2)*/
replace type_decision="control_harvest" if  !inlist(s5aq06a_2_1, .,0,-99) |  !inlist(s5aq06a3_1, .,0,99) |  !inlist(s5aq06a4_1, .,0,99) // first cropping season
replace controller_income1=s5aq06a_2_1 if !inlist(s5aq06a_2_1, .,0,-99) // primary controller
replace controller_income2=s5aq06a3_1 if !inlist(s5aq06a3_1, .,0,99) // 2 controllers, first listed
replace controller_income2=s5aq06a4_1 if controller_income2==. & !inlist(s5aq06a4_1, .,0,99) // 2 controllers, second listed

/*destring s5bq06a_2_1, gen(s5bq06a2)*/
replace type_decision="control_harvest" if  !inlist(s5bq06a_2_1, .,0,-99) |  !inlist(s5bq06a3_1, .,0,99) |  !inlist(s5bq06a4_1, .,0,99) // second cropping season
replace controller_income1=s5bq06a_2_1 if !inlist(s5bq06a_2_1, .,0,99) // primary controller
replace controller_income2=s5bq06a3_1 if !inlist(s5bq06a3_1, .,0,99) // 2 controllers, first listed
replace controller_income2=s5bq06a4_1 if controller_income2==. & !inlist(s5bq06a4_1, .,0,99) // 2 controllers, second listed

* Control Over Sales Income *
/*destring s5aq11f_1, gen(s5aq11f1)*/
replace type_decision="control_sales" if  !inlist(s5aq11f_1, .,0,-99) |  !inlist(s5aq11g_1, .,0,99) |  !inlist(s5aq11h_1, .,0,99)  // first cropping season
replace controller_income1=s5aq11f_1 if !inlist(s5aq11f_1, .,0,-99)  
replace controller_income2=s5aq11h_1 if !inlist(s5aq11h_1, .,0,99)
replace controller_income2=s5aq11h_1 if controller_income2==. & !inlist(s5aq11h_1, .,0,99)

/*destring s5bq11f_1, gen(s5bq11f1)*/  
replace type_decision="control_sales" if  !inlist(s5bq11f_1, .,0,-99) |  !inlist(s5bq11g_1, .,0,99) |  !inlist(s5bq11h_1, .,0,99) // second cropping season
replace controller_income1=s5bq11f_1 if !inlist(s5bq11f_1, .,0,-99)  
replace controller_income2=s5bq11g_1 if !inlist(s5bq11g_1, .,0,99)
replace controller_income2=s5bq11h_1 if controller_income2==. & !inlist(s5bq11h_1, .,0,99)

* Control Over Income from Slaughtered Livestock Sales * 		 	
replace type_decision="control_livestocksales" if  !inlist(s8aq06a, .,0,99) |  !inlist(s8aq06b, .,0,99) 
replace controller_income1=s8aq06a if !inlist(s8aq06a, .,0,99)  
replace controller_income2=s8aq06b if !inlist(s8aq06b, .,0,99)

* Control Over Income from Milk Sales *  
replace type_decision="control_milksales" if  !inlist(s8bq10a, .,0,99) |  !inlist(s8bq10b, .,0,99) 
replace controller_income1=s8bq10a if !inlist(s8bq10a, .,0,99)  
replace controller_income2=s8bq10b if !inlist(s8bq10b, .,0,99)

* Control Over Income from Egg Sales *  
replace type_decision="control_egg_sales" if  !inlist(s8cq6a, .,0,99) |  !inlist(s8cq6b, .,0,99) 
replace controller_income1=s8cq6a if !inlist(s8cq6a, .,0,99)  
replace controller_income2=s8cq6b if !inlist(s8cq6b, .,0,99)

* Fish Production Income *
//Fish production not included in UGA LSMS W7

* Business Income *  
replace type_decision="control_businessincome" if  !inlist(h12q19a, .,0,99) | !inlist(h12q19b, .,0,99) 
replace controller_income1=h12q19a if !inlist(h12q19a, .,0,99)  
replace controller_income2=h12q19b if !inlist(h12q19b, .,0,99)

* Wage Income control * (s8q31d1 s8q31d2 for primary) (s8q45d1 s8q45d2 for secondary)
replace type_decision="control_wageincome" if !inlist(s8q31d1, .,0,99) | !inlist(s8q31d2, .,0,99) | !inlist(s8q45d1, .,0,99) | !inlist(s8q45d2, .,0,99) 
replace controller_income1=s8q31d1 if !inlist(s8q31d1, .,0,99) 
replace controller_income1=s8q45d1 if controller_income1==. & !inlist(s8q45d1, .,0,99) 
replace controller_income2=s8q31d2 if !inlist(s8q31d2, .,0,99) 
replace controller_income2=s8q45d2 if controller_income2==. & !inlist(s8q45d2, .,0,99) 

preserve
keep hhid type_decision controller_income2
recast str50 hhid, force
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep hhid type_decision controller_income1
recast str50 hhid, force
drop if controller_income1==.
ren controller_income1 controller_income
append using `controller_income2'

* create group
gen control_cropincome=1 if  type_decision=="control_harvest" | type_decision=="control_sales"					
recode 	control_cropincome (.=0)	
							
gen control_livestockincome=1 if  type_decision=="control_livestocksales" | type_decision=="control_milksales" | type_decision=="control_egg_sales"		
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)	
						
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)
																					
gen control_nonfarmincome=1 if  type_decision=="control_remittance" | type_decision=="control_assistance" | control_businessincome== 1					   
recode 	control_nonfarmincome (.=0)		
																
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1

recode 	control_all_income (.=0)															
ren controller_income ind
tostring ind, gen (individ)

*Now merge with member characteristics
merge 1:1 hhid individ using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", nogen keep(3)
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
recast str50 hhid, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_control_income.dta", replace

********************************************************************************
*          WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING               *
********************************************************************************

* Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
* can report on % of women who make decisions, taking total number of women HH members as denominator
* Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making

use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a", clear // planting input decision maker - s3aq03_3
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b" // s3bq03_3
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec5a" // s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec5b" // s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6a" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c" 	//owns poultry - s6cq03b s6cq03c
recast str50 hhid, force
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.

* planting_input
/*destring s3aq03_3, gen(s3aq033)*/
replace type_decision="planting_input" if  !inlist(s3aq03_3, .,0,99) 
replace decision_maker1=s3aq03_3 if !inlist(s3aq03_3, .,0,99)  

/*destring s3bq03_3, gen(s3bq033)*/
replace type_decision="planting_input" if  !inlist(s3bq03_3, .,0,99) 
replace decision_maker2=s3bq03_3 if !inlist(s3bq03_3, .,0,99)  

* harvest control 
/*destring s5aq06a_2_1, gen(s5aq06a2)*/
replace type_decision="harvest" if  !inlist(s5aq06a_2_1, .,0,-99) |  !inlist(s5aq06a3_1, .,0,99)  |  !inlist(s5aq06a4_1, .,0,99) 
replace decision_maker1=s5aq06a_2_1 if !inlist(s5aq06a_2_1, .,0,-99)  
replace decision_maker2=s5aq06a3_1 if !inlist(s5aq06a3_1, .,0,99)
replace decision_maker3=s5aq06a4_1 if !inlist(s5aq06a4_1, .,0,99)

/*destring s5bq06a_2_1, gen(s5bq06a2)*/
replace type_decision="harvest" if  !inlist(s5bq06a_2_1, .,0,-99) |  !inlist(s5bq06a3_1, .,0,99)  |  !inlist(s5bq06a4_1, .,0,99) 
replace decision_maker1=s5bq06a_2_1 if !inlist(s5bq06a_2_1, .,0,-99)  
replace decision_maker2=s5bq06a3_1 if !inlist(s5bq06a3_1, .,0,99)
replace decision_maker3=s5bq06a4_1 if !inlist(s5bq06a4_1, .,0,99)

* control livesock -  
replace type_decision="livestockowners" if  !inlist(s6aq03b, .,0,99) |  !inlist(s6aq03c, .,0,99)  
replace decision_maker1=s6aq03b if !inlist(s6aq03b, .,0,99)  
replace decision_maker2=s6aq03c if !inlist(s6aq03c, .,0,99)
 
replace type_decision="livestockowners" if  !inlist(s6bq03b, .,0,99) |  !inlist(s6bq03c, .,0,99)  
replace decision_maker1=s6bq03b if !inlist(s6bq03b, .,0,99)  
replace decision_maker2=s6bq03c if !inlist(s6bq03c, .,0,99)
 
replace type_decision="livestockowners" if  !inlist(s6cq03b, .,0,99) |  !inlist(s6cq03c, .,0,99)  
replace decision_maker1=s6cq03b if !inlist(s6cq03b, .,0,99)  
replace decision_maker2=s6cq03c if !inlist(s6cq03c, .,0,99)

keep hhid type_decision decision_maker1 decision_maker2 decision_maker3
preserve
keep hhid type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore
preserve
keep hhid type_decision decision_maker3
drop if decision_maker3==.
ren decision_maker3 decision_maker
tempfile decision_maker3
save `decision_maker3'
restore
keep hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
append using `decision_maker3'
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
ren decision_maker ind
tostring ind, gen (individ)
*Now merge with member characteristics
merge 1:1 hhid individ using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", nogen keep(3)
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
recast str50 hhid, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_make_ag_decision.dta", replace

 
********************************************************************************
*                       WOMEN'S OWNERSHIP OF ASSETS                            *
********************************************************************************

* Code as 1 if a woman is sole or joint owner of any specified productive asset;
use "${Uganda_NPS_W8_raw_data}/Agric/agsec2a", clear // land ownership 
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6a" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6b" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec6c" 	//owns poultry - s6cq03b s6cq03c
append using "${Uganda_NPS_W8_raw_data}/HH/gsec14"
*use "${Uganda_NPS_W8_raw_data}/HH/gsec14", clear
recast str50 hhid, force
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.

* Ownership of land
tostring s2aq24__0, gen(s2aq24_0)
destring s2aq24_0, gen(s2aq240)
replace type_asset="landowners" if  !inlist(s2aq240, .,0,99) |  !inlist(s2aq24__1, .,0,99) 
replace asset_owner1=s2aq240 if !inlist(s2aq240, .,0,99)  
replace asset_owner2=s2aq24__1 if !inlist(s2aq24__1, .,0,99)
* no land ownership reported in season 2 (which makes sense since land is not easily transferable except over long periods of time)

* append who hss right to sell or use
preserve
tostring s2aq27__0, gen(s2aq27_0)
destring s2aq27_0, gen(s2aq270)
replace type_asset="landowners" if  !inlist(s2aq270, .,0,99) |  !inlist(s2aq27__1, .,0,99) 
replace asset_owner1=s2aq270 if !inlist(s2aq270, .,0,99)  
replace asset_owner2=s2aq27__1 if !inlist(s2aq27__1, .,0,99)
* no hss right to sell or use recoded in season 2
keep if !inlist(s2aq270, .,0,99) |  !inlist(s2aq27__1, .,0,99)   
keep hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  

*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist(s6aq03b, .,0,99) |  !inlist(s6aq03c, .,0,99)  
replace asset_owner1=s6aq03b if !inlist(s6aq03b, .,0,99)  
replace asset_owner2=s6aq03c if !inlist(s6aq03c, .,0,99)
 
replace type_asset="livestockowners" if  !inlist(s6bq03b, .,0,99) |  !inlist(s6bq03c, .,0,99)  
replace asset_owner1=s6bq03b if !inlist(s6bq03b, .,0,99)  
replace asset_owner2=s6bq03c if !inlist(s6bq03c, .,0,99)

* household assets -  
replace type_asset="household_assets" if  !inlist(h14q03a, .,0,99) |  !inlist(h14q03b, .,0,99)  
replace asset_owner1=h14q03a if !inlist(h14q03a, .,0,99)  
replace asset_owner2=h14q03b if !inlist(h14q03b, .,0,99)
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
ren asset_owner ind
tostring ind, gen (individ)
*Now merge with member characteristics
merge 1:1 hhid individ using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", nogen keep(3)
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
recast str50 hhid, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_ownasset.dta", replace


********************************************************************************
* 						    AGRICULTURAL WAGES                                 *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/Agric/agsec3a.dta", clear
gen season=1 
append using "${Uganda_NPS_W8_raw_data}/Agric/agsec3b.dta" 
replace season=2 if season==.

ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.

*Hired wages:
gen hired_wage = s3aq36 // wage paid is not reported in season 2

*Hired costs
gen hired_labor_costs = s3aq36
gen wage_paid_aglabor = hired_labor_costs
*Constructing a household-specific wage
collapse (sum) wage_paid_aglabor, by(hhid)		
recast str50 hhid, force							
recode wage* (0=.)	
keep hhid wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_ag_wage.dta", replace

********************************************************************************
*                                  CROP YIELDS                                 *
********************************************************************************
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots.dta", replace
*ren crop_code_master crop_code
*ren hhid HHID
//Legacy stuff- agquery gets handled above.
replace dm_gender = 3 if dm_gender==.
gen area_plan_=ha_planted
collapse (sum) area_harv_=area_plan area_plan_=ha_planted harvest_=quant_harv_kg, by(hhid dm_gender purestand crop_code)
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropname_table.dta", nogen keep(1 3)
merge 1:1 hhid crop_code using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_
drop crop_code kgs_sold quant_harv_kg  
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string
*merge 1:1 HHID using "${Nigeria_GHS_W8_created_data}/Nigeria_GHS_W8_trees.dta"
collapse (sum) harvest* area_harv* area_plan* total_planted_area* total_harv_area* kgs_harvest* value_harv* value_sold* /*number_trees_planted**/  , by(hhid) 
recode harvest*  area_harv* area_plan* kgs_harvest* total_planted_area*  total_harv_area* value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*ren variable
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (UGX) (household)" 
	lab var value_sold_`p' "Value sold of `p' (UGX) (household)" 
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

foreach p of global topcropname_area {
	gen grew_`p'=(total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	*gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	*lab var harvested_`p' "1= Household harvested `p'"
	gen harvested_`p'= (harvest_`p'!=. & harvest_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
*Updated harvested_`p' if household has kgs harvested of topcropname_area (need this for future household summary stats).

*replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
*replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
*replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production.dta", replace
*Grouping following IMPACT categories but also mindful of the consumption categories.
recode crop_code 	(210/222						=1	"Beans and Cowpeas" )  ////   Beans, ,Cow peas
					(630  							=2	"Cassava"	)  //// 630 Cassava, 
					(520	 						=3	"Cotton"	)  ////	
					(650							=4	"Coco yam"	)  ////	
					(310 							=5	"Groundnuts"	)  ////					
					(150							=6	"Sorgum"	)  ////
					(130							=7  "Maize") ///
					(700 710 720 750 760 770 780	=8	"Fruits") /// oranges, paw paw, pineapples, mango, jackfruit, avocado, passion fruit 
					(141							=9	"Millet")  //// finger Millet
					(120   							=10	"Rice"	)  ////
					(640							=11	"Yam"	)  //// 
					(221 223 224					=12 "Other nuts,seeds, and pulses"	)  ////  221  223 224 field peas, pigeon peas, chick peas,
					(741 742 744 740				=13	"Bananas")  ////  banana food, banana beer, banana swwet
					(410 420 440 450 460 470   		=14	"Vegetables"	)  ////  cabbage, tomatoes, onions, pumpkins, dodo, egglplants 
					(890 							=15 "Other"	)  //// 
					(610							=16	"Potato")  ////  
					(620 							=17	"Sweet Potato"	)  ////  
					(320							=18	"Soya beans"	)  //// 
					(510 							=19 "Sugar"	)  //// 
					(111							=20	"Wheat")  ////  
					(820							=21	"Cocoa"	)  ////  
					(830							=22	"Tea"	)  ////  
					(870							=23	"Vanilla"	)  ////  
					(320							=11	"Oils and Fat"	)  //// 
					(810 							=24 "Coffee all"	)  //// 
					(330 							=25 "Sunflower"	)  //// 
					(340 							=26 "Simsim"	)  //// 
					(530							=27 "Tobacco"	)  //// 
					,generate(commodity)

gen type_commodity=	""
replace type_commodity = "Low" if inlist(commodity, 13, 2, 4, 7, 9, 12, 16, 6, 17, 11) 
/// banans, cassava, cocoyam, maize, millet, other nuts and seeds, potato, sorghum , sweet potato, yam 
replace type_commodity = "High" if inlist(commodity, 1, 21, 8, 5, 10, 18, 14, 13) 
/// beans and cowpeas, cocoa, fruits, groundnuts, rice, soybeans vegetables, bananas, 
replace type_commodity = "Out" if inlist(commodity, 3, 11, 19) 
/// cotton, oils n fats, sugar
* wheat tea vanilla sunflower simsim tobacco Need to add to type of commodity revising commodity high/low classification

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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production_grouped.dta", replace
restore
*use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production_grouped.dta", clear

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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production_type_crop.dta", replace


********************************************************************************
*                            SHANNON DIVERSITY INDEX                           *
********************************************************************************
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_area_plan.dta", replace
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0 
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_shannon_diversity_index.dta", replace

********************************************************************************
*                                   CONSUMPTION                                *
******************************************************************************** 
use "${Uganda_NPS_W8_raw_data}/pov2019_20.dta", clear
ren nrrexp  total_cons 
*ren cpexp30  total_cons 
ren equiv adulteq
*gen peraeq_cons = (total_cons / adulteq)
ren welfare peraeq_cons
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhsize.dta", nogen keep(1 3)
*gen percapita_cons = (total_cons / hsize)
gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30 
gen daily_percap_cons = percapita_cons/30
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq poor_2020
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_consumption.dta", replace

**We create an adulteq dataset for summary statistics sections
use "${Uganda_NPS_W8_raw_data}/pov2019_20.dta", clear
rename equiv adulteq
keep hhid adulteq
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_adulteq.dta", replace

********************************************************************************
*                                  FOOD SECURITY                               *
********************************************************************************
**DATA MISSING in W8

********************************************************************************
*                           HOUSEHOLD FOOD PROVISION                           * 
********************************************************************************
**DATA MISSING in W8


********************************************************************************
*                               HOUSEHOLD ASSETS                               *
********************************************************************************
use "${Uganda_NPS_W8_raw_data}/HH/gsec14", clear
* ren hh_m03 price_purch
ren h14q05 value_today
* ren hh_m02 age_item
ren h14q04 nb_items
*dropping items if hh doesnt report owning them 
tostring h14q03, gen(asset)
drop if asset=="3"
collapse (sum) value_assets=value_today, by(hhid)
recast str50 hhid, force
la var value_assets "Value of household assets"
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_assets.dta", replace

********************************************************************************
*                          DISTANCE TO AGRO DEALERS                            *
********************************************************************************
*Cannot create in this instrument

********************************************************************************
*                             HOUSEHOLD VARIABLES                              *
********************************************************************************
global empty_vars ""
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", clear

merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_cost_inputs.dta", nogen

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_inputs_`c'.dta", nogen
	merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_`c'_monocrop_hh_area.dta", nogen
}

//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
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
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish Income // No fish income for Uganda W8 
gen fish_income_fishfarm = 0
gen fish_income_fishing =0
gen fishing_income = 0
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars fish_income*

*Livestock income
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_sales.dta", nogen keep(1 3)
* recast str50 hhid, force
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_expenses.dta", nogen keep(1 3)
* recast str50 hhid, force
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_products.dta", nogen keep(1 3)
* recast str50 hhid, force
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_TLU.dta", nogen keep(1 3)
* recast str50 hhid, force
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_herd_characteristics.dta", nogen keep(1 3)
* recast str50 hhid, force
merge 1:1 hhid using"${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_TLU_Coefficients.dta", nogen keep(1 3)
* recast str50 hhid, force
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced /*value_other_produced fish_income_fishfarm*/  cost_*livestock (.=0)
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced/*value_other_produced*/) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_deworm_livestock + cost_ticks_livestock) /*fish_income_fishfarm*/
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

*Notes: We do have information for mean_12months and animals_lost12months by type of livestock but not for household level maybe we can add it. We can calculate mean_12months and animals_lost12months (in uganda the variable is named lost_disease_*) at the household level for all livestock (if thats what we are looking for)

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*

*Self-employment income
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta", nogen keep(1 3)
*This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is already part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_agwage_income.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_other_income.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_LSMS_ISA_W3_remittance_income.dta", nogen keep(1 3)
*: Remittance income is already included in the other income dataset. (Need to check why)
egen transfers_income = rowtotal (remittance_income pension_income)
* There is a confusion between remittance income and assistance income in the UGanda Other Income section that needs to be revised.
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm Size
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_size.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_size_all.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_size_total.dta", nogen keep(1 3)
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
recast str50 hhid, force
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired /*labor_family*/ (.=0) 

*Household size
recast str50 hhid, force
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_vaccine.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_LSMS_ISA_W3_fert_use.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", nogen keep(1 3)
recast str50 hhid, force
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_input_use.dta", nogen keep(1 3)
recast str50 hhid, force
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_imprvseed_crop.dta", nogen keep(1 3)
recast str50 hhid, force
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_any_ext.dta", nogen keep(1 3)
recast str50 hhid, force

*merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_LSMS_ISA_W3_fin_serv.dta", nogen keep(1 3) //  Not Available for Uganda Wave 3 dta missing
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode /*use_fin_serv**/ ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
*replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_milk_animals.dta", nogen keep(1 3)
recast str50 hhid, force

*gen liters_milk_produced=liters_per_largeruminant * milk_animals
*lab var liters_milk_produced "Total quantity (liters) of milk per year" 
*drop liters_per_largeruminant
gen liters_per_cow = . 
gen liters_per_buffalo = . 
gen costs_dairy = .
gen costs_dairy_percow = .
*la var costs_dairy "Dairy production cost (explicit)"
la var costs_dairy_percow "Dairy production cost (explicit) per cow"
 
gen share_imp_dairy = . 
*gen milk_animals = . 
global empty_vars $empty_vars *costs_dairy_percow *liters_per_cow *liters_per_buffalo *share_imp_dairy

*Egg productivity
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
recast str50 hhid, force

*gen liters_milk_produced = milk_months_produced * milk_quantity_produced //  2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_cropcosts.dta", nogen keep(1 3)
recast str50 hhid, force
 
*Rate of fertilizer application 
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_fertilizer_application.dta", nogen keep(1 3)
recast str50 hhid, force

*Agricultural wage rate
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_ag_wage.dta", nogen keep(1 3)
recast str50 hhid, force

*Crop yields 
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_yield_hh_crop_level.dta", nogen keep(1 3)
recast str50 hhid, force

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)
recast str50 hhid, force
 
*Household diet
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_household_diet.dta", nogen keep(1 3)
recast str50 hhid, force

*consumption 
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_consumption.dta", nogen keep(1 3)
recast str50 hhid, force

*Household assets
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hh_assets.dta", nogen keep(1 3)
recast str50 hhid, force
*Food insecurity
*merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_food_insecurity.dta", nogen keep(1 3)
recast str50 hhid, force
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health // cannot construct
gen disease_animal=. 
global empty_vars $empty_vars disease_animal* disease_*

*livestock feeding, water, and housing
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_livestock_feed_water_house.dta", nogen keep(1 3)

*Shannon Diversity index
merge 1:1 hhid using  "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
*gen value_farm_production
recode value_crop_production value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | crop_income!=0 /*| livestock_income!=0*/ | farm_area!=0 | tlu_today!=0)
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
gen fishing_hh = .
global empty_vars $empty_vars fishing_hh fishing_income
*gen fishing_hh = (fishing_income!=0)
*lab  var fishing_hh "1= Household has some fishing income" //  Not Available

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

gen wage_paid_aglabor_female=. 
gen wage_paid_aglabor_male=.
*gen wage_paid_aglabor_mixed=. 
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
*Generating labor_total as sum of winsorized labor_hired and labor_family
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

  /*Yield by Area Harvested //  2.20.23 Area Harvest not available 
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

*mortality rate //  Might Want to go back to Livestock Income section and see if needs to be calculated (I believe this indicator can be constructed.)
global animal_species lrum srum pigs equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = lost_disease_`s'/mean_12months_`s'
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
* 3/13/23  No information available, -though, variables have been created.

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

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
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
recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income_s*/ w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock /*w_share_fishing*/ w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ /*use_fin_serv*/ use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all  /*months_food_insec*/ w_value_assets /*
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
recode w_proportion_cropvalue_sold w_farm_size_agland  w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted /*w_all_area_harvested w_labor_family*/ (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland  w_labor_hired /*
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
* Here, we could do it with w_yield_planted_cn.

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

*Poverty Indicator Updates
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

********Currency Conversion Factors*********
gen ccf_loc = (1/$Uganda_NPS_W8_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W8_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W8_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W8_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

*Poverty indicators 
merge 1:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_consumption.dta", keep(1 3) nogen
gen poverty_under_1_9 = (daily_percap_cons < $Uganda_NPS_W8_poverty_190)
la var poverty_under_1_9 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_2_15 = (daily_percap_cons < $Uganda_NPS_W8_poverty_215)
la var poverty_under_2_15 "Household per-capita consumption is below $2.15 in 2017 $ PPP"

*gen poverty_under_npl = (daily_percap_cons < $Uganda_NPS_W8_poverty_npl)
ren poor_2020 poverty_under_npl 
la var poverty_under_npl "Household daily per-capita consumption is below the national poverty line"


gen clusterid=subcounty_code

*dropping unnecessary varables
// drop *_inter_*

*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in wheat beans {
		
		local newvar = "`x'_x"
	
		cap confirm var `newvar'
		if !_rc {
			display "`newvar' already exists. Skipping variable creation."
		}
		else {
			
			gen `newvar' = .
		}
		
		local renamevar = "val_harv_mono_`c'"
		cap confirm var `renamevar'
		if !_rc {
			display "Skipping renaming of `newvar' to `renamevar' because it already exists."
		}
		else {
			ren `newvar' `renamevar'
		}
	}
}

/*
*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in wheat beans {
		gen `x'_x = .
		ren *maize*_x *`c'*
	}
}
*/

*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* region region subcounty_code district county /*county_name*/ /*parish*/ parish_name rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq  *labor_hired use_inorg_fert  /*
*/ ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ ** *ls_exp_vac* *prop_farm_prod_sold *hrs_*    *value_assets*  *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* /**total_harv_area**/ /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* /*nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products nb_cows_today nb_smallrum_today nb_chickens_today area_plan* /*area_harv* *labor_family* vac_ feed* water* lvstck_housed* months_food_insec hhs_* */  *value_pro* *value_sal* *inter*

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) // This line is for HH vars only; rest for all three
ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
*ren hhid hhid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2019-20"
gen instrument = 57
*la var instrument "Wave and location of survey"
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
saveold "${Uganda_NPS_W8_final_data}/Uganda_NPS_W8_household_variables.dta", replace

********************************************************************************
*                         INDIVIDUAL-LEVEL VARIABLES                           *
********************************************************************************
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_fert_use.dta", clear
ren indiv individ
tostring individ, replace force
recast str50 individ, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_fert_use.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_improvedseed_use_temp.dta", clear
ren indiv individ
tostring individ, replace force
recast str50 individ, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_improvedseed_use_temp.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_vaccine.dta", clear
ren indiv individ
tostring individ, replace force
recast str50 individ, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_vaccine.dta", replace


use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", clear
recast str50 hhid, force
save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", replace

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_person_ids.dta", clear

merge m:1 hhid   using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_household_diet.dta", nogen
merge 1:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhsize.dta", nogen keep (1 3)
merge m:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_fert_use.dta", nogen  keep(1 3)
merge m:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_improvedseed_use_temp.dta", nogen  keep(1 3)
merge 1:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep (1 3)

*land rights
merge 1:1 hhid individ using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_land_rights_ind.dta", nogen
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
* 
gen women_diet=.
replace number_foodgroup=.

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2019-20"
gen instrument = 57
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
*gen strataid=region
gen clusterid=subcounty_code

*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_W8_final_data}/Uganda_NPS_W8_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0
saveold "${Uganda_NPS_W8_final_data}/Uganda_NPS_W8_individual_variables.dta", replace


********************************************************************************
*	                         PLOT -LEVEL VARIABLES                             *
********************************************************************************

*GENDER PRODUCTIVITY GAP
use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_all_plots", replace
collapse (sum) plot_value_harvest = value_harvest, by(hhid parcel_id plot_id season) //  10.10.23 Usiing Standarized version of value harvested
tempfile crop_values 
save `crop_values' // season level

use "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_areas.dta", replace // plot-season level
merge m:1 hhid using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_weights.dta", keep (1 3) nogen // hh level
merge 1:1 hhid parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_decision_makers.dta", keep (1 3) nogen //  plot-season level
merge m:1 hhid parcel_id plot_id using "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_plot_labor_days.dta", keep (1 3) nogen // plot level
ren hhid hhid
merge m:1 hhid using "${Uganda_NPS_W8_final_data}/Uganda_NPS_W8_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region subcounty_code)
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

********Currency Conversion Factors*********
gen ccf_loc = (1/$Uganda_NPS_W8_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$Uganda_NPS_W8_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Uganda_NPS_W8_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Uganda_NPS_W8_gdp_ppp_dollar
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

* We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
gen clusterid=subcounty_code // We don't have ea in Uganda W8
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
	gen manager_mixed_ssp = .
	//rename manager_gender_ssp3 manager_mixed_ssp

	label variable manager_male_ssp "Male only decision-maker - ssp"
	label variable manager_female_ssp "Female only decision-maker - ssp"
	label variable manager_mixed_ssp "Mixed gender decision-maker - ssp"

tab dm_gender if rural_ssp==0, generate(manager_gender_lsp)

	rename manager_gender_lsp1 manager_male_lsp
	rename manager_gender_lsp2 manager_female_lsp
	gen manager_mixed_lsp = .
	// rename manager_gender_lsp3 manager_mixed_lsp
	

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
rename v1 UGA_wave8

save "${Uganda_NPS_W8_created_data}/Uganda_NPS_W8_gendergap.dta", replace 
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
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2019-20"
gen instrument = 57
*la var instrument "Wave and location of survey"
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
saveold "${Uganda_NPS_W8_final_data}/Uganda_NPS_W8_field_plot_variables.dta", replace

********************************************************************************
*                           SUMMARY STATISTICS                                 *
******************************************************************************** 
/* 
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Uganda_NPS_W8"
do "$summary_stats"

************************************ STOP ************************************