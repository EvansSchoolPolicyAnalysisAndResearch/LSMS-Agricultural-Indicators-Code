
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 8 (2019-20).
*Author(s)		: Didier Alia, Andrew Tomes, Rebecca Hsu, & 
				  C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of Pierre Biscaye, David Coomes, Jack Knauer, Josh Merfeld, Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, Travis Reynolds members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  
				  All coding errors remain ours alone.
*Date			: This  Version - 18 April 2022 // update
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
global directory "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda"
//set directories: These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Uganda_NPS_w8_raw_data 			"$directory\uganda-wave8-2019-20\raw_data\UGA_2019_UNPS_v01_M_STATA14"
global Uganda_NPS_w8_created_data 		"$directory\uganda-wave8-2019-20\temp"
global Uganda_NPS_w8_final_data  		"$directory\uganda-wave8-2019-20\temp"

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS -- RH complete 4/19/22
********************************************************************************
//global Uganda_NPS_w8_exchange_rate 3376.4246		// Rate of Jan 1, 2015 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2016.html (Can we get historical rate from bloomberg?) // RH: average exchrt for 2019 was 3704.5036 UGX. Use that instead of Jan 1,2015?

global Uganda_NPS_w8_exchange_rate 3704.5036		// Average rate of 2019 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2019.html

global Uganda_NPS_w8_gdp_ppp_dollar 1,311,42   		// https://data.worldbank.org/indicator/PA.NUS.PPP (2019)
global Uganda_NPS_w8_cons_ppp_dollar 1,235.95		// https://data.worldbank.org/indicator/PA.NUS.PRVT.PP (2019)
global Uganda_NPS_w8_inflation 0.1152  		// inflation rate 2015-2016. Data was collected during feb2019-2020. We want to adjust the monetary values to 2016  
/*global NPS_LSMS_ISA_W3_inflation  0.1267 // (131.344-116.565)/116.565 https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2010; 
RH 4/19/22: Instructions for updating inflation
UGA CPI in 2019 = 173.87, 2016 155.91
Inflation value: (surveyyear_CPIvalue - 2016_CPIvalue)/2016_CPIvalue
	2019 Uganda inflation = 0.1152 = (173.87-155.91)/155.91
//update all waves to 2016 baseline using World Bank's FP.CPI.TOTL indicator
*/

*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
*Using 2019 numbers
global Uganda_NPS_W8_pop_tot 44269587
global Uganda_NPS_W8_pop_rur 33485073
global Uganda_NPS_W8_pop_urb 10784514


********************************************************************************
*THRESHOLDS FOR WINSORIZATION -- complete
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
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"


*********************************************************************** *********
*HOUSEHOLD IDS -- RH complete 10/25/21 - added EA but only available for about half of the households; // 12/23 note -- need to check if update is needed, see commented code
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec1", clear
/*Note from w4, check to see if have to make this same edit to w8
ren HHID hhid // In UGA W4, household id variables are not consistently named between the Ag data sections and the Household data sections 
			//In Ag, there are two id variables (HHID and hh) HHID is long and hh is string (they are composed of the same numbers, but string version has 'H' and '-' added)
			//In Household, HHID is string, and in one case hhid is used instead of HHID
			//We rename all string household id variables to "hhid" for consistency and to allow for merging between data files
			*/


ren wgt weight  // using the crossectional weight
*ren h1aq6 village // no village
ren district district_name
ren dc_2018 district_code
ren s1aq02a county_name
ren cc_2018 county_code
ren s1aq03a scounty_name
ren sc_2018 scounty_code
ren s1aq04a parish_name
ren pc_2018 parish_code

gen rural = (urban==0)
gen strataid = region // do we want to keep both strataid and region if they're describing the same thing?

keep hhid region district_name district_code county_name county_code scounty_name scounty_code parish_name parish_code  /*village ea - ea being merged in*/  rural weight strataid batch /*clusterid*/
lab var rural "1=Household lives in a rural area"
recast str32 hhid, force
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids_noea.dta", replace

*Merging in the ea from the community survey on household batch, as well as available geo - level codes. (However, about half of hhs don't have an ea availabe after merge)
use  "${Uganda_NPS_w8_raw_data}/Community/csec1a.dta", clear
destring s1aq01b, gen(district_code)
destring s1aq02b, gen(county_code)
destring s1aq03b, gen(scounty_code)
destring s1aq04b, gen(parish_code)
ren Batch batch
ren Final_EA_code ea
keep ea batch district_code county_code scounty_code parish_code

merge m:m batch district_code county_code scounty_code parish_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids_noea.dta", nogen 
//is m:m ok? Only way they would merge
//1925 obs matched, 1 not matched from master (csec1), 1173 not matched from using (gsec1)
//1173 hhids will not have ea available

keep hhid region district_name district_code county_name county_code scounty_name scounty_code parish_name parish_code ea rural weight strataid /*clusterid*/
lab var rural "1=Household lives in a rural area"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta", replace

********************************************************************************
*INDIVIDUAL IDS - RH complete 10/21/21// 12/23 note -- need to check if update is needed, see commented code
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec2", clear
/*
ren HHID hhid
//PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P0" and the "-"
destring PID, gen(indiv) ignore ("P" "-") 
*/


gen female=h2q3==2 
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "Individual age"
gen hh_head=h2q4==1 
lab var hh_head "1= individual is household head"
keep  hhid pid female age hh_head
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_person_ids.dta", replace
 
********************************************************************************
*HOUSEHOLD SIZE - RH complete 10/21/21
********************************************************************************
use "${Uganda_NPS_w8_raw_data}/HH/gsec2.dta", clear
*ren hhid HHID // using hhid
gen hh_members = 1
rename h2q4 relhead 
rename h2q3 gender
recast str32 hhid
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)	// SAK 2019-07-08: see previous note.
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", replace

****************************************************************
*PARCEL AREAS -- RH Complete 1/12/22, checked 4/13/22-ALT
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
*PLOT DECISION MAKERS -- RH complete 2/16/22
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
drop if parcelID==. // same as "plotnum" variable?
gen season=1 

append using "${Uganda_NPS_w8_raw_data}\Agric\agsec3b.dta" // NON-OWNED PLOTS
replace season = 2 if season ==.

ren parcelID parcel_id
ren pltid plot_id
recast str32 hhid

*First decision-maker variables 
gen indiv = s3aq03_3
replace indiv = s3bq03_3 if indiv == . & s3bq03_3 != .
merge m:1 hhid indiv using  "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", gen(dm1_merge) keep(1 3)		// 6,969 unmatched from master. 
gen dm1_female = female
drop female indiv

*Second decision-maker variables
gen indiv = s3aq03_4b
replace indiv = s3bq03_4b if indiv == . &  s3bq03_4b != .
merge m:1 hhid indiv using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_gender_merge.dta", gen(dm2_merge) keep(1 3)		// 6,149 unmatched from master. 
gen dm2_female = female
drop female indiv

*JHG 12_28_21: They only collected information on two decision-makers per plot. (w8 as well)

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep hhid parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & (dm2_female == 0 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & (dm2_female == 1 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 3 if dm_gender == . & !(dm1_female == . & dm2_female == .) //no mixed-gender managed plots
label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhsize.dta", nogen // 593 not matched
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . // 593 dropped
keep hhid parcel_id plot_id season dm_gender fhh //***cultivated, also plotname was here but is not a variable in this wave
***lab var cultivated "1=Plot has been cultivated"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_plot_decision_makers.dta", replace


********************************************************************************
*TLU (Tropical Livestock Units) // Complete 12/23/21, but RH Flag - how to handle different time periods of data?
********************************************************************************
//uga w4 as reference

//TZA w4: lf_sec_02.dta // livestock section 2- livestock stock

use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a.dta", clear // livestock - large ruminants
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b.dta"
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c.dta"

//6a - large ruminants
//6b - small ruminants
//6c - poultry

*ren hh hhid
//Uganda - splits up types of livestock into different dta files. Creating a single livestock code (See UGA w4 code as reference)
gen lvstckid = LiveStockID
replace lvstckid = ALiveStock_Small_ID if lvstckid==. & ALiveStock_Small_ID!=.
replace lvstckid = APCode if lvstckid==. & APCode!=.

label define lvstckid 1 "EXOTIC/CROSS - Calves" 2 "EXOTIC/CROSS - Bulls" 3 "EXOTIC/CROSS - Oxen" 4 "EXOTIC/CROSS - Heifers" 5 "EXOTIC/CROSS - Cows" 6 "INDIGENOUS - Calves" 7 "INDIGENOUS - Bulls" 8 "INDIGENOUS - Oxen" 9 "INDIGENOUS - Heifers" 10 "INDIGENOUS - Cows" 11 "INDIGENOUS - Donkeys/mules" 12 "INDIGENOUS - Horses" 13 "EXOTIC/CROSS - Male goats" 14 "EXOTIC/CROSS - Female goats" 15 "EXOTIC/CROSS - Male sheep" 16 "EXOTIC/CROSS - Female sheep" 17 "EXOTIC/CROSS - Pigs" 18 "INDIGENOUS - Male goats" 19 "INDIGENOUS - Female goats" 20 "INDIGENOUS - Male sheep" 21 "INDIGENOUS - Female sheep" 22 "INDIGENOUS - Pigs" 23 "Indigenous dual-purpose chicken" 24 "Layers (exotic/cross chicken)" 25 "Broilers (Exotic/cross chicken)" 26 "Other poultry and birds (turkeys / ducks / geese)" 27 "Rabbits" 


//Adapted from UGA w4 TLU code
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6|lvstckid==7|lvstckid==8|lvstckid==9|lvstckid==10|lvstckid==12) //calves, bulls, oxen, heifer, cows (indigenous and exotic)
replace tlu_coefficient=0.45 if (lvstckid==11) //donkeys/mules (indigenous) // Donkeys/ Mules are a combined variable in this instrument so we take the average of TLU for donkeys(.3) and for mules (.6) =.45
replace tlu_coefficient=0.2 if (lvstckid==17|lvstckid==22) //pigs 
replace tlu_coefficient=0.1 if (lvstckid==13|lvstckid==14|lvstckid==15|lvstckid==16|lvstckid==18|lvstckid==19|lvstckid==20|lvstckid==21) //goats, sheep
replace tlu_coefficient=0.01 if (lvstckid==23|lvstckid==24|lvstckid==25|lvstckid==26|lvstckid==27) //chickens, rabbits, ducks/ turkeys 
la var tlu_coefficient "Tropical Livestock Unit coefficient"

gen cattle=inrange(lvstckid,1,10) // calves, bulls, heifers, cows, oxen
gen smallrum=inrange(lvstckid,13,22) // goats, sheep, pigs
gen poultry=inrange(lvstckid,23,26) //chickens, turkey, ducks
gen other_ls=inlist(lvstckid,11,12,27) //donkeys/mules, horses, rabbits
gen cows=inlist(lvstckid,5,10)
gen chickens=inlist(lvstckid,23,24,25) // dual-purpose chicken, layer chicken, broiler chicken


//May not be able to construct this section for this instrument, because types of livestock have different time periods referred to:
//s6aq06 - large ruminants 1 year ago
//s6bq06 - small ruminants 6 months ago
//s6cq06 - poultry 3 months ago

//Created these based on time periods available. (See above)
gen nb_ls_1yearago = s6aq06 //how many animals owned by household exactly 12 months ago (large ruminants only)
gen nb_ls_6mosago = s6bq06 // small ruminants only
gen nb_ls_3mosago = s6cq06 // poultry only

gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_6mosago=nb_ls_6mosago if smallrum==1 
gen nb_poultry_3mosago=nb_ls_3mosago if poultry==1 

gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_3mosago=nb_ls_3mosago if chickens==1 


gen nb_ls_today= s6aq03a // sum, how many [animal] does household currently own (indigenous + improved/exotic)
replace nb_ls_today = s6bq03a if nb_ls_today==. & s6bq03a!=.
replace nb_ls_today = s6cq03a if nb_ls_today==. & s6cq03a!=.

gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 

*gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient // see note above
gen tlu_today = nb_ls_today * tlu_coefficient

//adapted from uga w4 code

gen number_sold_year = s6aq14a // large ruminants
gen number_sold_6mo = s6bq14a // small ruminants 
gen number_sold_3mo = s6cq14a // poultry

// RH Flag 12/23/21: Could use 6mo and 3mo vars, to create estimate?
//Flag - Code for if we want estimated sales over 1 years
gen income_live_sales_year = number_sold_year*s6aq14b // number [large ruminants] sold*avg value of [large ruminants]
gen income_live_sales_6mo = number_sold_6mo*s6bq14b // number [small ruminants] sold*avg value of [small ruminants]
gen income_live_sales_3mo = number_sold_3mo*s6cq14b // number [poultry] sold*avg value of [poultry]
recode income_live_sales_year (.=0)
recode income_live_sales_6mo (.=0)
recode income_live_sales_3mo (.=0)

*Lots of things are valued in between here, but it isn't a complete story.
*So livestock holdings will be valued using observed sales prices.
ren lvstckid livestock_code
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_* income_live_sales_year income_live_sales_6mo income_live_sales_3mo , by (hhid)

lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_6mosago "Number of small ruminant owned as of 6 months ago"
lab var nb_poultry_3mosago "Number of cattle poultry as of 3 months ago"
*lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_3mosago "Number of chickens owned as of 3 months ago"
*/
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"

*lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
*lab var nb_ls_1yearago  "Number of livestock owned as of 12 months ago"
lab var nb_ls_today "Number of livestock owned as of today"
drop tlu_coefficient
drop if hhid==""

save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_TLU_Coefficients.dta", replace


*************************************************************************
*LIVESTOCK INCOME // RH complete 1/4/21, not checked
*************************************************************************
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
//rename s7q06c cost_deworming_livestock /* Includes cost of deworming and professional fees. Not included in 335/TNZ but included in W8. Should include?*/
/*Not included s7q07c What was the total cost of the treatment of [...] against ticks, including cost of drugs and professional fee?*/


ren s7q08c cost_hired_labor_livestock // total cost of curative treatment
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_expenses", replace

*Livestock products
* Milk
// liters for all questions
//reference period = 12 mos large ruminants, 6mos small ruminants
use "${Uganda_NPS_w8_raw_data}\Agric\agsec8b.dta", clear
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==105 // Exotic + Indigenous large ruminants. 
rename s8bq01 animals_milked // 12 months
ren s8bq02 months_milked //Do we need this? (Doesn't have total days milked like w3)
gen days_milked = months_milked*30
rename s8bq03 liters_per_day // avg milk production per day per animal milked
recode animals_milked months_milked days_milked liters_per_day (.=0)

gen milk_liters_produced = (animals_milked * days_milked * liters_per_day) /* 30 days per month (in year units)*/
lab var milk_liters_produced "Liters of milk produced in past 12 months"

*rename s8bq07 liters_sold_perdayper_year // Question: During this period (1 yr) how much did you sell per day. (Unit is liters/day). Multiply by 365 to get year? // However, only 45 responses, 38/45 = 0. 1 response is 10,000, so may be total year instead of per day over year (drop?) 
gen liters_sold_per_year = s8bq07 * 365 
ren s8bq07 liters_sold_per_day 

rename s8bq06 liters_perday_to_dairy // RH 1.3.21: "processed dairy" instead of cheese //RH: Q asks for liters/day. What is reasonable? 10-30 possible for per day? 720 is not (cheese in day units)
rename s8bq09 earnings_per_year_milk // milk and dairy products// In questionnaire: How much earned over 12 mos, not day (milk in year units)

recode liters_sold_per_year liters_perday_to_dairy (.=0)

gen liters_sold_day = (liters_sold_per_year/days_milked) + liters_perday_to_dairy

gen price_per_liter = earnings_per_year_milk / liters_sold_per_year
gen price_per_unit = price_per_liter  
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
*gen earnings_milk_year = earnings_per_day_milk*months_milked*30 
gen earnings_milk_year=price_per_liter*(liters_sold_per_year + (liters_perday_to_dairy * 365)) //ALT: Double check and make sure this is actually what we want. -- based on w3 code. dairy seems to be perday for w8, so multiplying by 365.
keep hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_milk", replace

**
*Eggs
use "${Uganda_NPS_w8_raw_data}\Agric\agsec8c.dta", clear
ren AGroup_ID livestock_code

// Time period = Over 3 months; code based on UGA w3

ren s8cq01 months_produced // how many poultry laid eggs in the last 3 months (qs diff from TNPS)
ren s8cq02 quantity_month // what quantity of eggs were produced in the last 3 mos
gen quantity_produced = quantity_month * 4 // Var = est. of eggs produced in last year. Extrapolating from 3 months (reported in survey)
lab var quantity_produced "Quantity of this product produced in past year"
recode months_produced quantity_month (.=0)

ren s8cq03 sales_quantity // eggs sold in the last 3 months
ren s8cq05 earnings_sales

recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
//units not included
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_other", replace

**
*Combined livestock products
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_milk", clear
append using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_other"
recode price_per_unit (0=.)
recast str32 hhid, force 
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", replace

**
//Median livestock product prices by EA

use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
keep if price_per_unit !=. //ALT: This drops a lot of observations b/c zeros are recoded as missing above.
gen observation = 1

preserve
bys region district_code parish_code ea livestock_code: egen obs_ea = count(observation) 
collapse (median) price_per_unit [aw=weight], by (region district_code county_code parish_code ea livestock_code obs_ea)
ren price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_ea.dta", replace

restore
//median price at parish level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district_code county_code parish_code livestock_code: egen obs_parish = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district_code county_code parish_code livestock_code obs_parish)
ren price_per_unit price_median_parish
lab var price_median_parish "Median price per unit for this livestock product in the ward"
lab var obs_parish "Number of sales observations for this livestock product in the parish"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_parish.dta", replace

//median price at county level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district_code county_code livestock_code: egen obs_county = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district_code county_code livestock_code obs_county)
ren price_per_unit price_median_county
lab var price_median_county "Median price per unit for this livestock product in the county"
lab var obs_county "Number of sales observations for this livestock product in the county"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_livestock_products_prices_county.dta", replace

*RH FLAG: Add scounty?

//median price at district level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district_code livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district_code livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_district.dta", replace

//median price at region level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_region.dta", replace

//median price at country level
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_country.dta", replace

//Pull prices into estimates
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products", clear
merge m:1 region district_code county_code parish_code ea livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_ea.dta", nogen // corrected ea
merge m:1 region district_code county_code parish_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_parish.dta", nogen
merge m:1 region district_code county_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_county.dta", nogen
merge m:1 region district_code livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10 // corrected ea
replace price_per_unit = price_median_parish if price_per_unit==. & obs_parish >= 10
replace price_per_unit = price_median_county if price_per_unit==. & obs_county >= 10 
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"

/*gen price_cowmilk_med = price_median_country if livestock_code==101 | livestock_code==102 | livestock_code==105 | livestock_code==106
egen price_cowmilk = max(price_cowmilk_med)
replace price_per_unit = price_cowmilk if livestock_code==101 | livestock_code==102 | livestock_code==105 | livestock_code==106*/ //ALT: I updated the TZ code for these lines but I don't think they're needed because the code above takes care of it.
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==103 | livestock_code==107
*gen value_other_produced = quantity_produced * price_per_unit if livestock_code==22 | livestock_code==23 // uga only has milk and eggs

//no price info available for small ruminants
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		

collapse (sum) value_milk_produced value_eggs_produced sales_livestock_products, by (hhid)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
lab var value_livestock_products "value of livesotck products produced (milk, eggs)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
recode value_milk_produced value_eggs_produced (0=.)
recast str32 hhid, force
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_products", replace

*Sales (live animals)
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a", clear
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b"
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c"

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
recast str32 hhid, force
merge m:1 hhid using "${Uganda_NPS_w8_created_data}/Uganda_NPS_W8_hhids.dta", nogen keep(1 3) //106 missing from master

keep hhid region rural weight district_code county_code scounty_code parish_code ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code

save "${Uganda_NPS_w8_created_data}//Uganda_NPS_W8_hh_livestock_sales.dta", replace
**

*Implicit prices
//median price at the ea level

//RH FLAG: should we only keep obs that have an ea?
use "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district_code county_code scounty_code parish_code ea livestock_code: egen obs_ea = count(observation)
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
save "${Uganda_NPS_w8_created_data}/Uganda_NPS_w8_livestock_sales", replace
 
*TLU (Tropical Livestock Units)
use "${Uganda_NPS_w8_raw_data}/Agric/agsec6a", clear
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6b"
append using "${Uganda_NPS_w8_raw_data}/Agric/agsec6c"

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
replace tlu_coefficient = 0.5 if livestock_code==12 //(horses = 0.5 and mules = 0.6), separates donkeys/mules from horses in w8
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
gen income_live_value = s6aq14b // this is avg value of livestock type sold
replace income_live_value = s6bq14b if income_live_value==. & s6bq14b!=. 
replace income_live_value = s6cq14b if income_live_value==. & s6cq14b!=. 
gen number_sold = s6aq14a
replace number_sold = s6bq14a*2 if number_sold==. & s6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace number_sold = s6cq14a*4 if number_sold==. & s6bq14a!=. //EFW 8.26.19 multiply by 4 because question asks in last 3 months

gen income_live_sales = income_live_value * number_sold // assuming sales variable is amt money made in sales 

egen mean_12months = rowmean(number_1yearago number_today)

//How many animals lost to theft
gen animals_lost12monthstheft = s6aq10
replace animals_lost12monthstheft = s6bq10*2 if animals_lost12monthstheft==. & s6bq10!=. // over 6 mos
replace animals_lost12monthstheft = s6cq10*4 if animals_lost12monthstheft==. & s6cq10!=. // over 3 mos

//How many animals lost to accident or injury
gen animals_lost12monthsian = s6aq11
replace animals_lost12monthsian = s6bq11*2 if animals_lost12monthsian==. & s6bq11!=.
replace animals_lost12monthsian = s6cq11*4 if animals_lost12monthsian==. & s6cq11!=.

// How many animals lost to disease
gen animals_lost12monthsdis = s6aq12 //includes animals died or lost
replace animals_lost12monthsdis = s6bq12*2 if animals_lost12monthsdis==. & s6bq12!=. 
replace animals_lost12monthsdis = s6cq12*4 if animals_lost12monthsdis==. & s6cq12!=.
 
//Total lost in last 12 months 
gen animals_lost12months = animals_lost12monthstheft + animals_lost12monthsian + animals_lost12monthsdis //includes animals died or lost due to theft,injury accident natural calamity and disease

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


*************************************************************************
*SELF-EMPLOYMENT INCOME // RH complete 1/4/21; processed crops and fish trading not captured in instrument
*************************************************************************Based on uga w3
use "${Uganda_NPS_w8_raw_data}/HH/gsec12_2.dta", clear
ren h12q09 months_activ // how many months did the business operate
replace months_activ = 12 if months_activ > 12 & months_activ!=. //1 change made
ren h12q10 monthly_revenue // avg monthly gross revenues when active
ren h12q12 wage_expense // avg expenditure on wages
ren h12q13 materials_expense // avg expenditures on raw materials
ren h12q14 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (.=0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit <0 & monthly_profit!=. //52 EFW 6.24.19 What do we do with negatives profit, recode to zero?? check other code
// RH ^^ w8 has many hhs with negative profit (52)

gen annual_selfemp_profit = monthly_profit * months_activ
count if annual_selfemp_profit<0 & annual_selfemp_profit!=. //52
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by(hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_w8_raw_data}/Uganda_NPS_w8_self_employment_income.dta", replace

*Processed crops 
//RH 1/4/21: Not captured in w8 instrument (or other UGA waves)

*Fish trading
//RH 1/4/21: Not captured in w8 instrument (or other UGA waves)



*************************************************************************
*NON-AG WAGE INCOME -- RH complete 12/26/21, not checked
*************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec8.dta", clear

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

ren s8q04 wage_yesno // Did [NAME] work for wage, salary, commission or any payment in kind? [w4 used q05, but that wasn't available in w8. -- did any wage work in the last 12 months y/n]
ren s8q30 number_months // months worked for main job
ren s8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12

egen hours_pastweek = rowtotal(s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g)
gen number_hours = hours_pastweek*number_weeks

gen agwage = 1 if ((h8q19b_twoDigit>=61 & h8q19b_twoDigit<=63) | (h8q19b_twoDigit==92))	//Based on ISCO classifications used in Basic Information Document used for Wave 4
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
*OTHER INCOME - RH complete 12/27/21, See FLAG questions
********************************************************************************
use "${Uganda_NPS_w8_raw_data}\HH\gsec7_2.dta", clear

gen rental_income_cash = s11q05 if (IncomeSource==21 | IncomeSource==22 | IncomeSource==23) //net rent from buildings/property; net rent from land; royalties. RH FLAG: Include royalties? Was in UGA w4 code 
gen rental_income_inkind = s11q06 if (IncomeSource==21 | IncomeSource==22 | IncomeSource==23) //net rent from buildings/property; net rent from land; royalties. RH FLAG: Include royalties? Was in UGA w4 code 
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

**
use "${Uganda_NPS_w8_raw_data}\Agric\agsec2a.dta", clear
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
