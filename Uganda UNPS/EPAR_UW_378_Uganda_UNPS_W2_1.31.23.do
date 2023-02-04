/*------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 1 (2009-10)
*Author(s)		: Didier Alia, David Coomes, Elan Ebeling, Nina Forbes, Nida
				  Haroon, Muel Kiel, Anu Sidhu, Isabella Sun, Emma Weaver,
				  Ayala Wineman, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the
				  World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI,
				  IRRI, and the Bill & Melinda Gates Foundation Agricultural
				  Development Data and Policy team in discussing indicator
				  construction decisions. 
				  All coding errors remain ours alone.
*Date			: 2 February 2023
------------------------------------------------------------------------------*/



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

* This Master do.file constructs selected indicators using the Uganda UNPS 
* (UN LSMS) data set.
* Using data files from within the "\raw_data" folder, 
* the do.file first constructs common and intermediate variables, saving dta
* files when appropriate in the folder
* "\temp" 
*
* These variables are then brought together at the household, plot, or 
* individual level, saving dta files at each level when available in the
* folder "\output". 


* The processed files include all households, individuals, and plots in the 
* sample. Toward the end of the do.file, a block of code estimates summary 
* statistics (mean, standard error of the mean, minimum, first quartile, 
* median, third quartile, maximum) 
* of final indicators, restricted to the rural households only, disaggregated '
* by gender of head of household or plot manager.

* The results are outputted in the excel file 
* "Uganda_NPS_W2_summary_stats.xlsx" in the 
* "\output\uganda-wave2-2010-11-unps" folder. 



* It is possible to modify the condition  "if rural==1" in the portion of code 
* following the heading "SUMMARY STATISTICS" to generate all summary 
* statistics for a different sub_population.


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
local root_folder "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave2-2010-11"
global UGA_W2_raw_data "`root_folder'/raw_data"
global UGA_W2_final_data "`root_folder'/outputs"
global UGA_W2_created_data "`root_folder'/temp"

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



global NPS_LSMS_ISA_W2_exchange_rate  3690.85 //EFW 4.19.19 use 2016
// https://data.worldbank.org/indicator/PA.NUS.PPP?end=2016&locations=UG&start=2011&view=chart&year_low_desc=false
global NPS_LSMS_ISA_W2_gdp_ppp_dollar 833.54

global NPS_LSMS_ISA_W2_cons_ppp_dollar 946.89
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2011
global NPS_LSMS_ISA_W2_inflation 0.359 //(158.5 - 116.6)/116.6 https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2011 //EFW 4.19.19 updated see calculations


********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS 
*******************************************************************************

* Priority Crops (crop code)
* maize 		(130)		rice 			(120)		wheat 	(111)
* sorghum 		(150)		finger millet	(141)		cowpea	(222)
* groundnut 	(310)		common bean 	(210)		yam 	(640)
* sweet potato	(620)		cassava 		(630)		banana	(741) 
// Note: Banana is divided into three categories Banana food 
// (741), Banana beer(742), and Banana sweet (744). For this analysis only 
// Banana Food is used

global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana"
global topcrop_area "130 120 111 150 141 222 310 210 640 620 630 741"
global comma_topcrop_area"130, 120, 111, 150, 141, 222, 310, 210, 640, 620, 630, 741"

global nb_topcrops : list sizeof global(topcropname_area) 
display "$nb_topcrops"

********************************************************************************
*                                HOUSEHOLD  IDS                                *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC1.dta", clear

* Rename variables to EPAR standard
rename h1aq1 district
rename h1aq2b county
rename h1aq3b subcounty
rename h1aq4b parish
rename stratum strataid
rename wgt10 weight // Includes split off households
// All of the numeric codes have been removed from this
// version of the survey.

gen rural = urban==0
rename comm ea

keep HHID region district county subcounty parish ea rural weight strataid
lab var rural "1=Household lives in a rural area"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", replace

********************************************************************************
*WEIGHTS*
********************************************************************************
use "${UGA_W2_raw_data}/GSEC1.dta", clear
rename wgt10 weight //  Note: using panel weight for round 3 (only weight available) 2850 households total
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta"
keep HHID weight rural
save "${UGA_W2_created_data}/Uganda_NPS_W2_weights.dta", replace


********************************************************************************
*                                INDIVIDUAL IDS                                *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC2.dta", clear
keep HHID PID h2q1 h2q3 h2q4 h2q8

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
* Household 1053003307 has all kinds of crazy, lucky for us only personid 1
* is needed for this analysis
drop if HHID == "1053003307" & personid != 1

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
save "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", replace


********************************************************************************
*                                HOUSEHOLD SIZE                                *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC2.dta"


* Create female-headed household dummy variable 1 if person is head of 
* household and female
gen fhh = (h2q4==1 & h2q3==0)

* Combine all the members of a househould into one entry to get size of 
* household and whether or not the househould is headed by a female.
gen hh_members = 1

collapse (sum) hh_members (max) fhh, by (HHID)

* Label the created variables
lab var fhh "1= Female-headed househould"
lab var hh_members "Number of househould members"

save "${UGA_W2_created_data}/Uganda_NPS_W2_hhsize.dta", replace

********************************************************************************
*                                  PLOT AREA                                  *
********************************************************************************
//Note: Restarting this section and modeling it after Uganda W3, Seb's code. this one seemed to not be doing the right thing 
use "${UGA_W2_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${UGA_W2_raw_data}/AGSEC4B.dta", generate(last)		
replace season=2 if last==1
label var season "Season = 1 if 1st cropping season of 2010, 2 if 2nd cropping season of 2010"
gen plot_area=a4aq7 //values are in acres (Total area of plot planted) a4aq9 percentage of crop planted in the plot area 
replace plot_area = a4bq7 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
rename plot_area ha_planted

*Now, generate variables to fix issues with the percentage of a plot that crops are planted on not adding up to 100 (both above and below). This is complicated so each line below explains the procedure
gen percent_planted = a4aq9/100
replace percent_planted = a4bq9/100 if percent_planted==.
rename prcid parcel_id
rename pltid plot_id
bys HHID parcel_id plot_id season : egen total_percent_planted = sum(percent_planted) //generate variable for total percent of a plot that is planted (all crops)
duplicates tag HHID parcel_id plot_id season, g(dupes) //generate a duplicates ratio to check for all crops on a specific plot. the number in dupes indicates all of the crops on a plot minus one (the "original")
gen missing_ratios = dupes > 0 & percent_planted == . //now use that duplicate variable to find crops that don't have any indication of how much a plot they take up, even though there are multiple crops on that plot (otherwise, duplicates would equal 0)
bys HHID parcel_id plot_id season : egen total_missing = sum(missing_ratios) //generate a count, per plot, of how many crops do not have a percentage planted value.
gen remaining_land = 1 - total_percent_planted if total_percent_planted < 1 //calculate the amount of remaining land on a plot (that can be divided up amongst crops with no percentage planted) if it doesn't add up to 100%
bys HHID parcel_id plot_id season : egen any_missing = max(missing_ratios)
*Fix monocropped plots
replace percent_planted = 1 if percent_planted == . & any_missing == 0 //monocropped plots are marked with a percentage of 100% - impacts 5,244 crops
*Fix plots with or without missing percentages that add up to 100% or more
replace percent_planted = 1/(dupes + 1) if any_missing == 1 & total_percent_planted >= 1 //If there are any missing percentages and plot is at or above 100%, everything on the plot is equally divided (as dupes indicates the number of crops on that plot minus one) - this impacts 9 crops
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1 //some crops still add up to over 100%, but these ones aren't missing percentages. So we need to reduce them all proportionally so they add up to 100% but don't lose their relative importance.
*Fix plots that add up to less than 100% and have missing percentages
replace percent_planted = remaining_land/total_missing if missing_ratios == 1 & percent_planted == . & total_percent_planted < 1 //if any plots are missing a percentage but are below 100%, the remaining land is subdivided amonst the number of crops missing a percentage - impacts 205 crops

*Bring everything together
collapse (max) ha_planted (sum) percent_planted, by(HHID parcel_id plot_id season)
gen plot_area = ha_planted / percent_planted
bys HHID parcel_id season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep HHID parcel_id plot_id season plot_area total_plot_area plot_area_pct ha_planted
*need to rename parcel_id so that we can merge following data sets
rename parcel_id prcid 
merge m:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2A.dta", nogen
merge m:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2B.dta"
*generating field_size
generate parcel_acre = a2aq4
replace parcel_acre = a2bq4 if parcel_acre == . 
replace parcel_acre = a2aq5 if parcel_acre == . //Note: replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres)
replace parcel_acre = a2bq5 if parcel_acre == . //Note: see above
gen field_size = plot_area_pct*parcel_acre //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen parcel_ha = parcel_acre * 0.404686
*cleaning up and saving the data
rename prcid parcel_id
keep HHID parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size == .
label var field_size "Area of plot (ha)"
label var HHID "Household identifier"
save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", replace



********************************************************************************
*                             PLOT DECISION MAKERS                             *
********************************************************************************

//Note: There is no direct plot decision maker for this section so I had to improvise and use a question to infer who the decison maker was. Using this rather than the orginal section is important because we need the season variable and the original section used a general instrument section not an Ag Section. 

use "${UGA_W2_raw_data}/AGSEC3A.dta", clear 
gen season=1
append using "${UGA_W2_raw_data}/AGSEC3B.dta" 
replace season = 2 if season == .
ren pltid plot_id
ren prcid parcel_id

*First decision-maker variables 
gen personid = a3aq40a
replace personid = a3aq40b if personid == . & a3aq40b != .
replace personid = a3aq40c if personid == . & a3aq40c !=.

merge m:1 HHID person using  "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using
gen dm1_female = female

drop female 

*Note: no multiple decision makers reported in this wave

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep HHID parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null

*replace dm_gender = 3 if dm_gender == . & dm1_female == . & dm_gendermult==1 //no mixed-gender managed plots

label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"


*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhsize.dta", nogen
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . 
keep HHID parcel_id plot_id season dm_gender fhh //***cultivated, also plotname was here but is not a variable in this wave
***lab var cultivated "1=Plot has been cultivated"
save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", replace 
	

********************************************************************************
*                                  AREA PLANTED                                *
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC4A.dta", clear
append using "${UGA_W2_raw_data}/AGSEC4B.dta", gen(season)


// Standardizing some names across waves and files. 
rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

// Create hectares planted
gen ha_planted = a4aq8 *(1/2.47105)
replace ha_planted = a4bq8*(1/2.47105) if missing(ha_planted)

collapse (sum) ha_planted, by (HHID parcel_id plot_id crop_code season)

save "${UGA_W2_created_data}/Uganda_NPS_W2_area_planted_temp.dta", /*
*/ replace



********************************************************************************
*                              MONOCROPPED PLOTS                               * //Note: This is actual crop value estimation. Might need some code from gross revenue 
********************************************************************************

use "${UGA_W2_raw_data}/AGSEC5A.dta", clear
append using "${UGA_W2_raw_data}/AGSEC5B.dta"
gen sold_qty=a5aq7a
gen season=1 if sold_qty!=.
replace sold_qty=a5bq7a if sold_qty==.
replace season = 2 if season == . & a5bq7a != .
*rename a5aq7a sold_qty
clonevar unit_code=a5aq7c
replace unit_code=a5bq7c if unit_code==.
gen sold_unit_code=a5aq7a
replace sold_unit_code=a5bq7a if sold_unit_code==.
gen sold_value=a5aq8
replace sold_value=a5bq8 if sold_value==.
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keepusing(region district county subcounty parish ea weight)
*rename HHID hhid
rename pltid plot_id
rename prcid parcel_id
rename cropID crop_code
gen price_unit=sold_value/sold_qty
label var price_unit "Average sold value per crop unit"
gen obs = price_unit!=.
save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_value.dta", replace 
keep HHID parcel_id plot_id crop_code unit_code sold_unit_code sold_qty sold_value region district county subcounty parish ea weight obs price_unit


//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.
	foreach i in region district county subcounty parish ea HHID {
		preserve
		bys `i' crop_code sold_unit_code : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by (`i' sold_unit_code crop_code obs_`i'_price)
		rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code sold_unit_code)
	rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
	tempfile price_unit_country_median
	save `price_unit_country_median'
	
**********************************
** Crop Unit Conversion Factors **
**********************************
*Create conversion factors for harvest
use "${UGA_W2_created_data}/Uganda_NPS_W2_crop_value.dta", replace 
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity==.
clonevar condition_harv=a5aq6b
replace condition_harv=a5bq6b if condition==.
clonevar conv_fact_harv_raw= a5aq6d
replace conv_fact_harv_raw=a5bq6d if conv_fact_harv_raw==.
recode crop_code  (741 742 744 = 740) (221 222 223 224 = 220) //  Same for bananas (740) and peas (220).
label define cropID 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master
*Note: added HHID to collapse to be used later in revenues section
collapse (median) conv_fact_harv_raw, by (crop_code condition_harv unit_code)
rename conv_fact_harv_raw conv_fact_median
lab var conv_fact_median "Median value of supplied conversion factor by crop type, condition, and unit code"
drop if conv_fact_med == . | crop_code == . | condition == .
save "${UGA_W2_created_data}/Uganda_NPS_W2_conv_fact_harv.dta", replace 

*Create conversion factors for sold crops (this is exactly the same with different variable names for use with merges later)
use "${UGA_W2_created_data}/Uganda_NPS_W2_crop_value.dta", replace 
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity==.
clonevar condition_harv=a5aq6b
replace condition_harv=a5bq6b if condition==.
clonevar conv_fact_harv_raw= a5aq6d
replace conv_fact_harv_raw=a5bq6d if conv_fact_harv_raw==.
recode crop_code  (741 742 744 = 740) (221 222 223 224 = 220) // Which is being reduced from different types to just coffee. Same for bananas (740) and peas (220).
label define cropID 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master
collapse (median) conv_fact_harv_raw, by (crop_code condition_harv unit_code)
rename conv_fact_harv_raw conv_fact_sold_median
lab var conv_fact_sold_median "Median value of supplied conversion factor by crop type, condition, and unit code"
drop if conv_fact_sold_median == . | crop_code == . | condition_harv == .
rename unit_code sold_unit_code //done to make a merge later easier, at this point it just represents an abstract unit code
*rename condition_harv condition //again, done to make a merge later easier
save "${UGA_W2_created_data}/Uganda_NPS_W2_conv_fact_sold.dta", replace 


**********************************
** Plot Variables **
**********************************
use "${UGA_W2_raw_data}/AGSEC4A", clear 
gen season=1
append using "${UGA_W2_raw_data}/AGSEC4B"
replace season=2 if season==.
*rename HHID hhid
rename pltid plot_id
rename prcid parcel_id
rename cropID crop_code_plant //crop codes for what was planted
drop if crop_code_plant == .
clonevar crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
recode crop_code_master  (741 742 744 = 740) (221 222 223 224 = 220) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define L_CROP_LIST 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
label values crop_code_master L_CROP_LIST //apply crop labels to crop_code_master

*Merge area variables (now calculated in plot areas section earlier)
merge m:1 HHID parcel_id plot_id season using "${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", nogen keep(1 3)	

merge m:m HHID parcel_id plot_id  /*crop_code */ season using "${UGA_W2_created_data}/Uganda_NPS_W2_crop_value.dta", nogen keep(1 3)
rename crop_code crop_code_harvest
drop if crop_code_harvest == . 
gen month_harvest = a5aq6e 
replace month_harvest = a5bq6e if season==2 
lab var month_harvest "Month of planting relative to December 2011 (both cropping seasons)"

gen edate_harvest=mdy(month_harvest,1,2010)
*Note: no planting dates
gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop"


*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(a5aq17,1,4) | inrange(a5bq17,1,5) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
		collapse (sum) crops_plot = obs2, by(HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen
	gen contradict_mono = 1 if a4aq9 == 100 | a4bq9 == 100 & crops_plot > 1 //CPK: no plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if a4aq9 == 100 | a4aq7 == 1 | a4bq9 == 100 | a4bq7 == 1 //CPK: meanwhile 88 list intercropping or mixed cropping but only report one crop
	
*Generate variables around lost and replanted crops
	gen lost_crop = inrange(a5aq17,1,5) | inrange(a5bq17,1,5) 
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.

	*Generating monocropped plot variables (Part 1)
	bys HHID parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys HHID parcel_id plot_id season : egen permax = max(perm_tree)
	*CPK: removed Crop_Planted_Month Crop_Planted_Year Crop_Planted_Month2 Crop_Planted_Year2
	
	bys HHID parcel_id plot_id season : gen plant_date_unique = _n 
	*replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //CPK: What does this do? this would never be coded as a 99 so I don't really understand -currently only 1, 2 or .
*JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis SAW No Unknow planting dates
	bys HHID parcel_id plot_id season a5aq6e a5bq6e : gen harv_date_unique = _n // SAW harvest was all in the same year (2011)
	bys HHID parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys HHID parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop
	
*Generating mixed stand plot variables (Part 2)
	gen mixed = (a4aq7 == 2 | a4bq7 == 2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	
	
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 SAW Should we assume null values are intercropped?  or maybe missing information??
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg harv_dates harv_date_unique permax
		
		
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys HHID parcel_id plot_id season: egen total_percent = total(percent_field)
//CPK: something seems fishy here. 

	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	//8568 changes made
	replace ha_planted = percent_field*field_size
	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey
	
	*Renaming variables for merge to work //JHG 1/20/2022: section is unnecessary if we can't get conversion factors to work
	ren a5aq6a quantity_harvested
	replace quantity_harvested = a5bq6a if quantity_harvested == .
	ren crop_code_harvest crop_code
	recode crop_code   (741 742 744 = 740) (221 222 223 224 = 220) // Which is being reduced from different types to just coffee. Same for bananas (740) and peas (220).
	label define cropID 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
	label values crop_code cropID
	rename a5aq6b condition_harv
	replace condition_harv = a5bq6b if condition_harv == .
*	
	*merging in conversion factors and generating value of harvest variables
	merge m:1 crop_code condition_harv sold_unit_code using "${UGA_W2_created_data}/Uganda_NPS_W2_conv_fact_sold.dta", keep(1 3) gen(cfs_merge) // 
	merge m:1 crop_code condition_harv unit_code using "${UGA_W2_created_data}/Uganda_NPS_W2_conv_fact_harv.dta", keep(1 3) gen(cfh_merge) 
	gen quant_sold_kg = sold_qty * conv_fact_sold_median if cfs_merge == 3
	gen quant_harv_kg = quantity_harvested * conv_fact_median //not all harvested is sold, in fact most is not
	gen total_sold_value = price_unit * sold_qty
	gen value_harvest = price_unit * quantity_harvested
	rename price_unit val_unit
	gen val_kg = total_sold_value/quant_sold_kg if cfs_merge == 3
	
	*Generating plot weights, then generating value of both permanently saved and temporarily stored for later use
	merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keepusing(weight) keep(1 3)
	gen plotweight = ha_planted * weight
	gen obs3 = quantity_harvested > 0 & quantity_harvested != .
	foreach i in region district county subcounty parish ea HHID { //JHG 1_28_22: scounty_code and parish_code are not currently labeled, just numerical
preserve
	bys crop_code `i' : egen obs_`i'_kg = sum(obs3)
	collapse (median) val_kg_`i' = val_kg  [aw = plotweight], by (`i' crop_code obs_`i'_kg)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore
}

preserve
collapse (median) val_kg_country = val_kg (sum) obs_country_kg = obs3 [aw = plotweight], by(crop_code)
tempfile val_kg_country_median
save `val_kg_country_median'
restore

foreach i in region district county subcounty parish ea HHID { //something in here breaks when looking for unit_code
preserve
	bys `i' crop_code sold_unit_code : egen obs_`i'_unit = sum(obs3)
	collapse (median) val_unit_`i' = val_unit [aw = plotweight], by (`i' sold_unit_code crop_code obs_`i'_unit)
	rename sold_unit_code unit_code //done for the merge a few lines below
	tempfile val_unit_`i'_median
	save `val_unit_`i'_median'
restore
	merge m:1 `i' unit_code crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' unit_code crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i'  crop_code using `val_kg_`i'_median', nogen keep(1 3)
}

preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit = obs [aw = plotweight], by(crop_code unit_code)
save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_median_country.dta", replace //This gets used for self-employment income
restore

merge m:1 unit_code crop_code using `price_unit_country_median', nogen keep(1 3)
merge m:1 unit_code crop_code using "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)

*Generate a definitive list of value variables
//Note: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
foreach i in country region district county subcounty parish ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .

foreach i in country region district county subcounty parish ea { //JHG 1_28_22: is this filling in empty variables with other geographic levels?
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_HHID if val_unit_HHID != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_HHID if val_kg_HHID != . //Preferring household values where available.
	
//All that for these two lines that generate actual harvest values:
	replace value_harvest = val_unit * quantity_harvested if value_harvest == .
	replace value_harvest = val_kg * quant_harv_kg if value_harvest == .
//XXX real changes total. But note we can also subsitute local values for households with weird prices, which might work better than winsorizing.
	//Replacing conversions for unknown units
	replace val_unit = value_harvest / quantity_harvested if val_unit == .
preserve
	ren unit_code unit
	collapse (mean) val_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_prices_for_wages.dta", replace
	restore
		
*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field, by(region district county subcounty parish ea HHID parcel_id plot_id season crop_code_master purestand field_size)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 HHID parcel_id plot_id season using "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${UGA_W2_created_data}/Uganda_NPS_W2_all_plots.dta", replace


********************************************************************************
*                                 LIVESTOCK  + TLUs                            *
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC6A.dta", clear
append using "${UGA_W2_raw_data}/AGSEC6B.dta"
append using "${UGA_W2_raw_data}/AGSEC6C.dta"
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

  /*******************/
 /* Owned Livestock */
/*******************/
* Create dummy variables for our categories of livestock
* Cattle (Calves, Bulls, Oxen, Heifer, and Cows) 1-10
gen cattle 		= inrange(lvstckid, 1, 10)

* Small ruminants (Goats and Sheep) 13-20
gen smallrum	= inrange(lvstckid, 13, 20)

* Poultry (Chicken, Turkeys, Geese) 32-41
gen poultry		= inrange(lvstckid, 32, 41)

* Other Livestock (Donkeys, Horses/Mules, Pigs, Rabbits) 11, 12, 21, 31
gen other_ls 	= inlist(lvstckid, 11, 12, 21, 31)

* Cows (Exotic and Indigeneous) 5, 10
gen cows		= inlist(lvstckid, 5, 10)

* Chickens (Backyard chicken, Parent stock for broilers, Parent Stock for 
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
collapse (sum) tlu_* nb_*, by (HHID)

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

save "${UGA_W2_created_data}/Uganda_NPS_W2_TLU_Coefficients.dta", /*
	*/ replace

********************************************************************************
*                              GROSS CROP REVENUE                              *
********************************************************************************

//Note: A lot of this is redundant (variables already computed for "all plots")  and can be removed (or should be incorporated into the crop valuation code at the beginning of the section.)
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using "${UGA_W2_raw_data}/AGSEC5B.dta"

* Drop observations without a plot id or a parcel id
drop if missing(pltid) | missing(prcid)

* Standardizing major variable names across waves/files
rename pltid plot_id
rename cropID crop_code
rename prcid parcel_id

* Set uniform variable names across seasons/waves for: 
* quantity harvested		condition at harvest 	unit of measure at harvest
* conversion to kg			quantity sold			condition at sale
* unit of measure at sale	value harvested

rename a5aq6a qty_harvest
replace qty_harvest =  a5bq6a 		if missing(qty_harvest)

rename a5aq6b condition_harv
replace condition_harv = a5bq6b 	if missing(condition_harv)

rename a5aq6c unit_harv 
replace unit_harv = a5bq6c 			if missing(unit_harv)

rename a5aq6d conversion
replace conversion = a5bq6d 		if missing(conversion)

rename a5aq7a qty_sold
replace qty_sold = a5bq7a 			if missing(qty_sold)

rename a5aq7b condition_sold
replace condition_sold = a5bq7b		if missing(condition_sold)

rename a5aq7c unit_sold
replace unit_sold = a5bq7c 			if missing(unit_sold)

rename a5aq8 value_sold
replace value_sold = a5bq8 			if missing(value_sold)

* KGs harvested = quantity harvested times conversion factor
gen kgs_harvest = qty_harvest * conversion
* There is one observation with some qty_harvest but no conversion which can be
* converted into kgs easily
replace kgs_harvest = qty_harvest * 20 if unit_harv == 37 & missing(kgs_harvest)

* KGs sold = quantity sold * conversion if the units and condition have not
* changed since harvest
gen kgs_sold = qty_sold * conversion if condition_sold == condition_harv & /*
	*/ unit_sold == unit_harv

* Find out what units_sold are used for entries where condition or units changed
* from harvest to sale
// bysort unit_sold : count if missing(kgs_sold) & qty_sold > 0 & qty_sold != .

* Codes for Units sold with a missing value for kgs_sold and some qty_sold:
* 01: kilograms				02: Gram					03: Litre 
* 04: Small Cup w/ Handle	05: Metre					06: Square Metre (???)
* 07: Yard 					08: Millilitre				09: Sack (120kg)^
* 10: Sack (100kg)^			11: Sack (80kg)^			12: Sack (50kg)^
* 15: Jerrican (10lts)		18: Jerrican (2lts)			20: Tin (20lts)
* 22: Plastic Basin (15lts)	24: Bottle (500ml)			25: Bottle (350ml)
* 30: Kimbo Tin (1???)		32: Cup/Mug (0.5lt)			33: Glass (.25lt)
* 37: Basket (20kg)^		38: Basket (10kg)^			39: Basket (5kg)^
* 44: Buns (100g)^			45: Buns (50g)^				50: Packet (1kg)^
* 58: Fish - Cut up to 1 kg	60: Fish - Cut Above 2 kg	63: Crate
* 67: Bunch (big)			68: Bunch (medium)			69: Bunch (small)
* 70: Cluster (unspecified)	74: Gologolo (4-5lts)		80: Tot (50ml)
* 85: Number of Units		87: Other (specify)			98+: Invalid
* The largest group is those missing units sold 
* Entries marked with ^ are easily converted to kgs_sold and that is done below
//Note: Incorporate this into the price code if necessary.
replace kgs_sold = qty_sold 		if (unit_sold == 1 | unit_sold == 50 ) /*
													 */& missing(kgs_sold)
replace kgs_sold = qty_sold * 120 	if unit_sold == 9  & missing(kgs_sold)
replace kgs_sold = qty_sold * 100 	if unit_sold == 10 & missing(kgs_sold)
replace kgs_sold = qty_sold * 80 	if unit_sold == 11 & missing(kgs_sold)
replace kgs_sold = qty_sold * 50 	if unit_sold == 12 & missing(kgs_sold)
replace kgs_sold = qty_sold * 20	if unit_sold == 37 & missing(kgs_sold)
replace kgs_sold = qty_sold * 10	if unit_sold == 38 & missing(kgs_sold)
replace kgs_sold = qty_sold * 5 	if unit_sold == 39 & missing(kgs_sold)
replace kgs_sold = qty_sold / 10	if unit_sold == 44 & missing(kgs_sold)
replace kgs_sold = qty_sold / 20	if unit_sold == 45 & missing(kgs_sold)


* For those missing information on units or condition sold but without conflict
* between condition sold or unit sold 
replace kgs_sold = qty_sold * conversion if missing(kgs_sold) 				& /*
		*/  (qty_sold > 0   &  ~missing(conversion)  &  ~missing(qty_sold)) & /*
		*/ ((missing(condition_sold) |    condition_sold == condition_harv) & /*
		*/  (missing(unit_sold)      |    unit_sold      ==      unit_harv))
// NOTE: There are still 323 which have not been addressed by the above measures
// Two largest categories of units are Tin (20lts) - 102 - and Missing - 75. 

*Collapse to parcel level and label
collapse (sum) kgs_harvest kgs_sold value_sold , /*
		*/ by (HHID parcel_id plot_id crop_code)

* Calculate the price per kg
gen price_kg = value_sold / kgs_sold
recode price_kg (0 = .)

* Merge in Household data
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta"/*
	*/, keep(1 3)
drop _merge

* Label generated variables
lab var kgs_harvest /*
	*/ "Kgs harvested of this crop summed over both growing seasons"
lab var value_sold "Value sold of this crop summed over both growing seasons"
lab var kgs_sold "Kgs sold of this crop summed over both growing seasons"
lab var price_kg "Price per kg sold"


save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_sales.dta", replace



  /***************************/
 /* Crops Lost Post Harvest */
/***************************/
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using "${UGA_W2_raw_data}/AGSEC5B.dta"

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
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_crop_values_temp.dta", /*
	*/ keep(1 3)

* Multiple kgs lost by price per kg (imputed) to 
gen crop_value_lost = kgs_lost * price_kg

* Sum losses for the entire household. 
collapse (sum) crop_value_lost, by(HHID)
label variable crop_value_lost /*
	*/ "Value of crop production which had been lost by the time of the survey"
save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_losses.dta", replace

********************************************************************************
*                                 CROP EXPENSES                                *
********************************************************************************
 
 /*******************/
 /* Expenses: Labor */
/*******************/

use "${UGA_W2_raw_data}/AGSEC3A.dta", clear 
append using "${UGA_W2_raw_data}/AGSEC3B.dta" 
gen season = 1
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

keep HHID parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

duplicates drop HHID parcel_id plot_id season, force
reshape long dayshired wagehired, i(HHID parcel_id plot_id season) j(gender) string
reshape long days wage, i(HHID parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0

gen val = wage*days
tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using "${UGA_W2_created_data}/Uganda_NPS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district county subcounty parish ea HHID {
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




  /********************/
 /* Expenses: Inputs */
/********************/
use "${UGA_W2_raw_data}/AGSEC2A", clear
gen season = 1
append using "${UGA_W2_raw_data}/AGSEC2B.dta", gen(short)	
replace season = 2 if season == .

*formalized land rights
gen formal_land_rights = (a2aq25==1 | a2aq25==2 | a2aq25==3)	// CPK: no data on formal ownership reported in season 2

*Starting with first owner
preserve
ren a2aq26a personid
merge m:1 HHID personid using "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen keep(3)
//keep only matched
keep HHID personid female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve
ren a2aq26b personid
merge m:1 HHID personid using "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen keep(3)		// keep only matched (just 2)	
keep HHID personid female
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(HHID personid)		
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rights_ind.dta", replace
restore	

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(HHID)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rights_hh.dta", replace
restore

  /************************************************/
 /* Expenses: fertilizer and pesticide purchase   /
/************************************************/
*/

use "${UGA_W2_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${UGA_W2_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .

gen value_fertilizer = a3aq31
replace value_fertilizer = a3bq31 if value_fertilizer==.

gen value_pesticide = a3aq19
replace value_pesticide = a3bq19 if value_pesticide==.

gen value_manure_purch = a3aq8
replace value_manure_purch = a3bq8 if value_manure_purch==.


*In the survey instrument, the value of inputs obtained on credit is already captured in the question "What was the total value of the --- purchased?"
collapse (sum) value_fertilizer value_pesticide value_manure_purch, by (HHID) 
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons" 
lab var value_pesticide "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons"
lab var value_manure_purch "Value of manure purchased (not necessarily the same as used) in main and short growing seasons"
save "${UGA_W2_created_data}/Uganda_NPS_W2_fertilizer_costs.dta", replace

  /**********/
 /* Seed   /
/*********/
*/
use "${UGA_W2_raw_data}/AGSEC4A.dta", clear
gen season = 1
append using "${UGA_W2_raw_data}/AGSEC4B.dta", gen(short)	
replace season = 2 if season == .

gen cost_seed = a4aq11
replace cost_seed = a4bq11 if cost_seed==.
recode cost_seed (.=0) 

collapse (sum) cost_seed, by (HHID)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${UGA_W2_created_data}/Uganda_NPS_W2_seed_costs.dta", replace
*Note that planting material for permanent crops is not captured anywhere.


  /****************/
 /* Land Rental   /
/****************/
*/
use "${UGA_W2_raw_data}/AGSEC2A.dta", clear
gen season = 1
append using "${UGA_W2_raw_data}/AGSEC2B.dta", gen(short)	
replace season = 2 if season == .

	
gen rental_cost_land = a2bq9 // rent recoded in season 2 covers both season 1 & 2
recode rental_cost_land (.=0)
collapse (sum) rental_cost_land, by (HHID)
lab var rental_cost_land "Rental costs paid for land"
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_costs.dta", replace



  /***************************/
 /* Expenses: Asset Rentals */
/***************************/

* Load the data from disk
use "${UGA_W2_raw_data}/AGSEC10", clear

* Is this observation related to animal traction (ox plough)
gen animal_traction	= itmcd == 14
* Is this observation related to machine traction (plough, tractor, trailer,
* harrow/cultivator)
gen tractor 		= inlist(itmcd, 2, 6, 15, 16)
* Everything else
gen ag_asset		= ~tractor & ~animal_traction & ~missing(itmcd)

* Rename for ease
rename a10q8 rental_cost

* Assign rental costs to categories
gen rental_cost_animal_traction	= rental_cost	if animal_traction
gen rental_cost_tractor			= rental_cost	if tractor
gen rental_cost_ag_asset		= rental_cost 	if ag_asset


* Collapse to the household level
collapse (sum) rental_cost_*, by(HHID)

* Label the newly created variables
label variable rental_cost_animal_traction "Costs for renting animal traction"
label variable rental_cost_ag_asset "Costs for renting other agricultural items"
label variable rental_cost_tractor "Costs for renting a tractor"
save "${UGA_W2_created_data}/Uganda_NPS_W2_asset_rental_costs.dta", /*
	*/ replace

  /****************************/
 /* Expenses: Crop Transport */
/****************************/
* Load the data
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using "${UGA_W2_raw_data}/AGSEC5B"

* Rename key variables for cross wave/country compliance
rename prcid parcel_id

* Consolidate transport costs across seassons 
rename a5aq10 transport_costs_cropsales
replace transport_costs_cropsales = a5bq10 if missing(transport_costs_cropsales)
recode transport_costs_cropsales (.=0)
* Collapse to the household level.
collapse (sum) transport_costs_cropsales, by(HHID)

* Label the new variable.
label variable transport_costs_cropsales /*
	*/ "Expenditures on transportation for crop sales"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_transportation_cropsales.dta", /*
	*/ replace

  /******************************/
 /* Expenses: Total Crop Costs */
/******************************/
* Load and merge all the data just created
use "${UGA_W2_created_data}/Uganda_NPS_W2_asset_rental_costs", clear
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_costs", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_seed_costs", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_fertilizer_costs", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_wages_shortseason", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_wages_mainseason", nogen
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_transportation_cropsales", /*
	*/ nogen

* Recode any missing values to 0
recode rental_cost_* cost_seed value_* wages_paid_* transport_costs_* (.=0)

* Sum all the costs for the household
egen crop_production_expenses = rowtotal(*cost* value_* wages_paid_*)


* Label the newly created variable
label variable crop_production_expenses "Total crop production expenses"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_crop_income.dta", replace


********************************************************************************
*                               LIVESTOCK INCOME                               *
********************************************************************************

  /**********************/
 /* Livestock Expenses */
/**********************/
* Load the data
use "${UGA_W2_raw_data}/AGSEC7", clear

* Place livestock costs into categories
generate cost_hired_labor_livestock	= a7q4 	if a7q2 == 1
generate cost_fodder_livestock		= a7q4	if a7q2 == 2
generate cost_vaccines_livestock	= a7q4	if a7q2 == 3
generate cost_other_livestock		= a7q4	if a7q2 == 4
* Water costs are not captured outside of "other"
generate cost_water_livestock		= 0

recode cost_* (.=0)
preserve
	* Species is not captured for livestock costs, and so this disaggregation
	* is impossible. Created for conformity with other waves
	gen cost_lrum = .
	keep HHID cost_lrum
	label variable cost_lrum "Livestock expenses for large ruminants"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_lrum_expenses", replace
restore

* Collapse Livestock costs to the household level
collapse (sum) cost_*, by(HHID)

label variable cost_water_livestock			"Cost for water for livestock"
label variable cost_fodder_livestock 		"Cost for fodder for livestock"
label variable cost_vaccines_livestock 		/*
	*/ "Cost for vaccines and veterinary treatment for livestock"
label variable cost_hired_labor_livestock	"Cost for hired labor for livestock"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_expenses.dta", /*
	*/ replace


  /**********************/
 /* Livestock Products */
/**********************/
* Load the data from disk
use "${UGA_W2_raw_data}/AGSEC8", clear

* Rename key variables for conformity across waves/countries
rename a8q2 livestock_code
rename a8q3 months_produced
rename a8q4 quantity_month
rename a8q5 unit
rename a8q6 quantity_month_sold
rename a8q7 earnings_month

* Minor data cleaning
drop if missing(livestock_code)
recode months_produced (12/max = 12)
* drop if there is a unit of 'other'
drop if unit == 6

* Standardize units. For all items reported with multiple units, the units
* were converted to the unit with the greatest number of observations,
* regardless of what the unit was. No products had observations with more than
* two units (except honey)

* Trays of eggs to numbers of eggs
replace unit			= 4 				  if livestock_code == 5 & unit == 3
replace quantity_month 	= quantity_month * 30 if livestock_code == 5 & unit == 3
* Litres of Ghee to KG.
replace unit 		   = 1 if livestock_code == 4 & unit == 2
replace quantity_month = quantity_month * .91	if livestock_code == 4 & /*
	*/	unit == 2
* Kgs of Honey to litres
replace unit 		   = 2 if livestock_code == 6 & unit == 1
replace quantity_month = quantity_month / 1.42 if livestock_code == 6 & /*
	*/	unit == 1

* Calculate amount produced, quantity produced, etc.
gen quantity_produced 	= months_produced * quantity_month
gen price_per_unit		= earnings_month  / quantity_month_sold 
gen earnings_sales		= earnings_month  * months_produced
gen price_per_unit_hh 	= price_per_unit

* Pull out milk observations for cross-country compatibility
gen price_per_liter		= price_per_unit 	if inlist(livestock_code, 1, 3) & /*
										*/  unit == 2
gen earnings_milk_year	= earnings_sales  	if inlist(livestock_code, 1, 3)

* Replace per unit prices (including price_per_liter for milk) with missing 
* rather than 0
recode price_per_*		(0=.)

* Label all of the newly created information
lab var quantity_produced	"Quantity of this product produced in past year"
lab var price_per_liter		"Price of milk per liter sold"
lab var price_per_unit		"Unit price of the livestock product"
lab var price_per_unit_hh 	"Unit price of the livestock product"
lab var earnings_milk_year	"Total earnings of sale of milk produced"

* The next section seeks to impute prices based on the median per unit price
* for each of the goods. 
gen observation = 1 if ~missing(price_per_unit)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ nogen keep(1 3)
save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_products", replace

* Price Imputation *
********************
preserve
	bysort region district county subcounty parish ea livestock_code : /*
		*/ egen obs_ea = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county subcounty parish ea obs_ea /*
			*/ livestock_code) 
	rename price_per_unit price_median_ea

	label variable price_median_ea /*
		*/ "Median price per kg for this livestock product in the enumeration area"
	label variable obs_ea /*
		*/ "Number of sales observed for this livestock product in the enumeration area"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_ea.dta", /*
		*/ replace
restore

* Median Price at the parish level
preserve
	bysort region district county subcounty parish livestock_code : /*
		*/ egen obs_parish = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county subcounty parish obs_parish /*
		*/ livestock_code) 
	rename price_per_unit price_median_parish

	label variable price_median_parish /*
		*/ "Median price per kg for this livestock product in the Parish"
	label variable obs_parish /*
		*/ "Number of sales observed for this livestock product in the Parish"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_parish.dta",/*
	*/ replace
restore

* Median Price at the subcounty level
preserve
	bysort region district county subcounty livestock_code : /*
		*/ egen obs_sub = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county subcounty obs_sub livestock_code) 
	rename price_per_unit price_median_sub

	label variable price_median_sub /*
		*/ "Median price per kg for this livestock product in the Subcounty"
	label variable obs_sub /*
		*/ "Number of sales observed for this livestock product in the Subcounty"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_subcounty.dta",/*
	*/ replace
restore

* Median Price at the county level
preserve
	bysort region district county livestock_code : /*
		*/ egen obs_county = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district county obs_county livestock_code) 
	rename price_per_unit price_median_county

	label variable price_median_county /*
		*/ "Median price per kg for this livestock product in the County"
	label variable obs_county /*
		*/ "Number of sales observed for this livestock product in the County"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_county.dta",/*
	*/ replace
restore

* Median Price at the District level
preserve
	bysort region district livestock_code : /*
		*/ egen obs_district = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region district obs_district livestock_code) 
	rename price_per_unit price_median_district

	label variable price_median_district /*
		*/ "Median price per kg for this livestock product in the District"
	label variable obs_district /*
		*/ "Number of sales observed for this livestock product in the District"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_district.dta",/*
	*/ replace
restore

* Median Price at the Region level
preserve
	*Count number of observations
	bysort region livestock_code : /*
		*/ egen obs_region = count(observation)
	* Find the median price for the region
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by (region obs_region livestock_code) 
	rename price_per_unit price_median_region

	label variable price_median_region /*
		*/ "Median price per kg for this livestock product in the Region"
	label variable obs_region /*
		*/ "Number of sales observed for this livestock product in the Region"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_region.dta",/*
	*/ replace
restore

* Median Price at the Country level
preserve
	bysort livestock_code : /*
		*/ egen obs_country = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_unit [aw=weight] , /*
		*/ by ( obs_country livestock_code) 
	rename price_per_unit price_median_country

	label variable price_median_country /*
		*/ "Median price per kg for this livestock product in the Country"
	label variable obs_country /*
		*/ "Number of sales observed for this livestock product in the Country"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_country.dta",/*
	*/ replace
restore

drop observation
* Merge back in the median prices found above
* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
	*/	using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_ea", /*
	*/	nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
	*/	using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_parish", /*
	*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
		*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_subcounty", /*
	*/ nogen
* County
merge m:1 region district county livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_county", /*
	*/ nogen
* District
merge m:1 region district livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_district", /*
	*/ nogen
* Region
merge m:1 region livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_region", /*
	*/ nogen
* Country
merge m:1 livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_product_prices_country", /*
	*/ nogen

* Replace missing prices with imputed prices
replace price_per_unit = price_median_ea		if price_per_unit == . & /*
	*/ obs_ea		>= 10
replace price_per_unit = price_median_parish	if price_per_unit == . & /*
	*/ obs_parish	>= 10
replace price_per_unit = price_median_sub 		if price_per_unit == . & /*
	*/ obs_sub		>= 10
replace price_per_unit = price_median_county 	if price_per_unit == . & /*
	*/ obs_county	>= 10
replace price_per_unit = price_median_district	if price_per_unit == . & /*
	*/ obs_district	>= 10
replace price_per_unit = price_median_region	if price_per_unit == . & /*
	*/ obs_region	>= 10

* Disaggregate into separate livestock products
gen value_milk_produced			= quantity_produced * price_per_unit /*
	*/ if inlist(livestock_code, 1, 3)
gen value_eggs_produced			= quantity_produced * price_per_unit /*
	*/ if livestock_code == 5
gen value_other_produced		= quantity_produced * price_per_unit /*
	*/ if inlist(livestock_code, 2, 4, 6, 13, 14, 15)
gen sales_livestock_products	= earnings_sales

* Collapse to the household level
collapse (sum) value_*_produced sales_livestock_products, by(HHID)

* Sum total value of livestock products sold
egen value_livestock_products	= rowtotal(value_*_produced)

* Calculate share of livestock products sold
gen share_livestock_prod_sold	= sales_livestock_products / /*
	*/ value_livestock_products

* Label the variables
label variable value_livestock_products /*
	*/ "value of livestock products produced (milk, egss, other)"
label variable value_other_produced	/*
	*/ "value of ghee, honey, skins, goat milk and blood produced"
label variable value_eggs_produced	"Value of eggs produced"
label variable value_milk_produced	"Value of milk produced"

* Recode 0s to missing
recode value_*_produced 		(0=.)

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_livestock_products", /*
	*/ replace

  /***********************/
 /* Sales: Live Animals */
/***********************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC6A", clear
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"

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

* Merge in geographic data
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ keep(1 3) nogen

drop a6* rural strata

save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_livestock_sales", replace

* Impute Prices *
*****************
gen observation = 1

* Median Price at the enumeration area level
preserve
	bysort region district county subcounty parish ea livestock_code : /*
		*/ egen obs_ea = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county subcounty parish ea obs_ea /*
			*/ livestock_code ) 
	rename price_per_animal price_median_ea

	label variable price_median_ea /*
		*/ "Median price per animal for this livestock in the enumeration area"
	label variable obs_ea /*
		*/ "Number of sales observed for this livestock in the enumeration area"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea.dta", /*
		*/ replace
restore

* Median Price at the parish level
preserve
	bysort region district county subcounty parish livestock_code : /*
		*/ egen obs_parish = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county subcounty parish obs_parish /*
		*/ livestock_code ) 
	rename price_per_animal price_median_parish

	label variable price_median_parish /*
		*/ "Median price per kg for this livestock in the Parish"
	label variable obs_parish /*
		*/ "Number of sales observed for this livestock in the Parish"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish.dta",/*
	*/ replace
restore

* Median Price at the subcounty level
preserve
	bysort region district county subcounty livestock_code : /*
		*/ egen obs_sub = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county subcounty obs_sub livestock_code) 
	rename price_per_animal price_median_sub

	label variable price_median_sub /*
		*/ "Median price per kg for this livestock in the Subcounty"
	label variable obs_sub /*
		*/ "Number of sales observed for this livestock in the Subcounty"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty.dta",/*
	*/ replace
restore

* Median Price at the county level
preserve
	bysort region district county livestock_code : /*
		*/ egen obs_county = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district county obs_county livestock_code) 
	rename price_per_animal price_median_county

	label variable price_median_county /*
		*/ "Median price per kg for this livestock in the County"
	label variable obs_county /*
		*/ "Number of sales observed for this livestock in the County"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_county.dta",/*
	*/ replace
restore

* Median Price at the District level
preserve
	bysort region district livestock_code : /*
		*/ egen obs_district = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region district obs_district livestock_code) 
	rename price_per_animal price_median_district

	label variable price_median_district /*
		*/ "Median price per kg for this livestock in the District"
	label variable obs_district /*
		*/ "Number of sales observed for this livestock in the District"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_district.dta",/*
	*/ replace
restore

* Median Price at the Region level
preserve
	*Count number of observations
	bysort region livestock_code : /*
		*/ egen obs_region = count(observation)
	* Find the median price for the region
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by (region obs_region livestock_code) 
	rename price_per_animal price_median_region

	label variable price_median_region /*
		*/ "Median price per kg for this livestock in the Region"
	label variable obs_region /*
		*/ "Number of sales observed for this livestock in the Region"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_region.dta",/*
	*/ replace
restore

* Median Price at the Country level
preserve
	bysort livestock_code : /*
		*/ egen obs_country = count(observation)
	* Find the median price and the number of observations
	collapse (median) price_per_animal [aw=weight] , /*
		*/ by ( obs_country livestock_code ) 
	rename price_per_animal price_median_country

	label variable price_median_country /*
		*/ "Median price per kg for this livestock in the Country"
	label variable obs_country /*
		*/ "Number of sales observed for this livestock in the Country"
	save/*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_country.dta",/*
	*/ replace
restore

drop observation
* Merge back in the median prices found above
* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
	*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea", /*
	*/ nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
	*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish", /*
	*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
		*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty", /*
	*/ nogen
* County
merge m:1 region district county livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_county", /*
	*/ nogen
* District
merge m:1 region district livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_district", /*
	*/ nogen
* Region
merge m:1 region livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_region", /*
	*/ nogen
* Country
merge m:1 livestock_code using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_country", /*
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
* Calculate final values
gen value_lvstck_sold		= income_live_sales
replace value_lvstck_sold	= price_per_animal * number_sold 	/*
	*/ if missing(value_lvstck_sold)
// NOTE: No values were given for slaughtered sales. Using price of live animal
// sales to estimate the value of of sluaghtered animals
gen value_slaughtered		= price_per_animal * number_slaughtered
gen value_livestock_sales 	= value_lvstck_sold * value_slaughtered

collapse (sum) value_*, by(HHID)
drop if HHID == ""
label variable value_livestock_sales /*
	*/ "Value of livestock sold (live and slaughtered)"
label variable value_lvstck_sold "Value of livestock sold live"
label variable value_slaughtered /*
	*/ "Value of livestock slaughtered (with slaughtered livestock valued at local median prices for live animal sales)"
label variable value_livestock_purchases "Value of livestock purchases"
save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_sales", replace

 
  /**********************************/
 /* TLU (Tropical Livestock Units) */
/**********************************/
* Load the data from disk.
use "${UGA_W2_raw_data}/AGSEC6A", clear
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"

* Rename key variables for consistency across instruments
rename a6aq3 livestock_code
replace livestock_code = a6bq3	if missing(livestock_code)
replace livestock_code = a6cq3	if missing(livestock_code)

* Get rid of observations missing a livestock_code
drop if missing(livestock_code)

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
	bysort HHID : egen herd_cows_tot = sum(number_today)
	
	* Calculate the percentage of cows which are improved
	gen share_imp_herd_cows	= number_today_exotic / herd_cows_tot
	* collapse to household to deal with differences between exotic and 
	* indigenous observations
	collapse (max) share_imp_herd_cows, by (HHID)
	tempfile cows
	save `cows', replace
restore

merge m:1 HHID using `cows', nogen

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
		*/ lvstck_holding = number_today, by(HHID species)
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
		*/ *_pigs *_equine *_poultry share_imp_herd_cows, by(HHID)

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
	save "${UGA_W2_created_data}/Uganda_NPS_W2_herd_characteristics",/*
		*/ replace

restore
* Calculate the per animal price for live animals
gen 	price_per_animal		= income_live_sales / number_sold

* Merge in Imputed prices for missing values
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids", /*
	*/ keep(1 3) nogen
* Enumeration Area
merge m:1 region district county subcounty parish ea livestock_code /*
*/ using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_ea", /*
*/ nogen
* Parish
merge m:1 region district county subcounty parish livestock_code /*
*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_parish", /*
*/ nogen 
* Subcounty
merge m:1 region district county subcounty livestock_code /*
*/using "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_subcounty", /*
*/ nogen
* County
merge m:1 region district county livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_county", /*
*/ nogen

* District
merge m:1 region district livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_district", /*
*/ nogen
* Region
merge m:1 region livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_region", /*
*/ nogen
* Country
merge m:1 livestock_code using /*
*/ "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_prices_country", /*
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

* Calculate the value of the herd today and 1 year ago
gen value_1yearago	= number_1yearago * price_per_animal
gen value_today		= number_today * price_per_animal

* Collapse TLUs and livestock holdings values to the household level
collapse (sum) tlu_today tlu_1yearago value_*, by(HHID)
drop if HHID == ""

* I really don't know why we do it, but for conformity:
gen lvstck_holding_tlu = tlu_today

* Label constructed variables
label variable tlu_1yearago	"Tropical Livestock Units as of 12 months ago"
label variable tlu_today	"Tropical Livestock Units as of the time of survey"
label variable lvstck_holding_tlu	"Total HH livestock holdings, TLU"
label variable value_1yearago	"Value of livestock holdings from one year ago"
label variable value_today		"Vazlue of livestock holdings today"

* Save data to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_TLU", replace

  /********************/
 /* Livestock Income */
/********************/
* Load data from disk, and merge in various expense and revenue files
use "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_sales", clear
merge 1:1 HHID using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_hh_livestock_products", /*
	*/ nogen
merge 1:1 HHID using /*
	*/"${UGA_W2_created_data}/Uganda_NPS_W2_livestock_expenses", nogen
merge 1:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_TLU", nogen

* Calculate the value of income from livestock holdings (revenue - expenses)
gen livestock_income = value_lvstck_sold + value_slaughtered - /*
	*/ value_livestock_purchases + (value_milk_produced + value_eggs_produced /*
	*/ + value_other_produced) - (cost_hired_labor_livestock + /*
	*/ cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock /*
	*/ + cost_other_livestock)
* Label the new variable
label variable livestock_income "Net livestock income"

save "${UGA_W2_created_data}/Uganda_NPS_W2_livestock_income", replace

********************************************************************************
*                                 FISH  INCOME                                 *
********************************************************************************
* Fishing section of survey was removed in wave 2 None of this can be
* constructed

********************************************************************************
*                            SELF-EMPLOYMENT INCOME                            *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC12", clear

* Rename key variables to make them easier to work with
rename	h12q12 months_activ
rename	h12q13 monthly_income
rename	h12q15 monthly_wages
rename	h12q16 monthly_materials
rename	h12q17 monthly_other_expenses
* Fix invalid values. (Number of months greater than 12)
recode months_activ (12/max = 12)

* Calculate the profit
gen		annual_selfemp_profit = months_activ * (monthly_income - monthly_wages/*
		*/ - monthly_materials - monthly_other_expenses)
recode	annual_selfemp_profit (.=0)
// 90 Enterprises are reported as unprofitable

* Collapse to the household level
collapse (sum) annual_selfemp_p
* Recode responses whrofit, by(HHID)
// 78 households are reported to be engaged in unprofitable enterprise
* Label constructed variables
label variable annual_selfemp_profit /*
	*/"Estimated annual net profit from self-employment over previous 12 months"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_self_employment_income", /*
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
use "${UGA_W2_raw_data}/GSEC8", clear

* Set variable names to cross-wave standard
rename	h8q30	num_months
rename	h8q30b	num_weeks
rename 	h8q31c	pay_period

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
	collapse (sum) annual_salary, by(HHID)

	* Label the created variable
	lab var annual_salary "Annual earnings from non-agricultural wage"

	* Save data to disk.
	save "${UGA_W2_created_data}/Uganda_NPS_W2_wage_income", replace
restore

  /******************/
 /* Ag Wage Income */
/******************/
* Calculate the annual salary if it was earned in a non-ag job
gen annual_salary 			= hourly_wage * hrs_worked_annual if /*
	*/	~inlist(h8q19a, 611, 612, 613, 614, 621, 921)

* Collapse to the household level
collapse (sum) annual_salary, by(HHID)

* Label the created variable
lab var annual_salary "Annual earnings from agricultural wage"

* Save data to disk.
save "${UGA_W2_created_data}/Uganda_NPS_W2_agwage_income", replace

  /****************/
 /* Other Income */
/****************/
* Load data from disk
use "${UGA_W2_raw_data}/GSEC11", clear

* Rename key variables for easier use
rename	h11q2	income_code
rename	h11q5	cash_pay
rename	h11q6	inkind_pay

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
collapse (sum) *_income, by(HHID)

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
save "${UGA_W2_created_data}/Uganda_NPS_W2_other_income", replace

* Land Rental Income *
**********************
* Load land rental data
use "${UGA_W2_raw_data}/AGSEC2A", clear

* Rename key variable to cross instrument standard
rename a2aq16 land_rental_income
* Set missing values to 0 (assuming the respondent did not have any income from
* that source)
recode land_rental_income (.=0)

* Collapse to the household level
collapse (sum) land_rental_income, by(HHID)

* Label newly created variable
label variable land_rental_income /*
	*/ "Estimated income from renting out land over previous 12 months"

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_rental_income", replace

********************************************************************************
*                             FARM SIZE / LAND SIZE                            *
********************************************************************************
  /***************/
 /* Crops Grown */
/***************/
* Load data from disk First season
use "${UGA_W2_raw_data}/AGSEC4A", clear
* Append data from second season
append using "${UGA_W2_raw_data}/AGSEC4B"

* Drop incomplete entries
drop if missing(cropID, prcid, pltid)

* Rename key variables for cross file compatibility
rename pltid plot_id
rename prcid parcel_id
rename cropID crop_code

* Create a crop grown variable for any remaining observations
gen crop_grown = 1

* Collapse to the parcel level
collapse (max) crop_grown, by(HHID parcel_id)

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_crops_grown", replace

  /*******************/
 /* Plot Cultivated */
/*******************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC2A", clear
gen season = 1
append using "${UGA_W2_raw_data}/AGSEC2B"
replace season = 2 if season == .
* Rename key variables for cross file compatibility
rename prcid parcel_id

* Create a boolean, was the parcel cultivated
gen	cultivated	= inlist(a2aq13a, 1, 2) | inlist(a2aq13b, 1, 2) | /*
	*/	inlist(a2bq15a, 1, 2) | inlist(a2bq15b, 1, 2)

* Collapse to the parcel level
collapse (max) cultivated, by(HHID parcel_id)

* Label newly created variable
label variable cultivated "1= Parcel was cultivated in this data set"
* Save data to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_cultivated", replace

  /*************/
 /* Farm Area */
/*************/
use "${UGA_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${UGA_W2_raw_data}/AGSEC2B.dta" 
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
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_size", replace


  /*************************/
 /* All Agricultural Land */
/*************************/
use "${UGA_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${UGA_W2_raw_data}/AGSEC2B.dta" 
replace season = 2 if season == .
ren prcid parcel_id
gen		rented_out = inlist(a2aq13a, 3, 4) | inlist(a2aq13b, 3, 4)
replace rented_out=. if rented_out==0  & (a2aq13a==. & a2aq13b==. & a2bq15a==. & a2bq15b==.)
drop if rented_out==1
* Check the use of the land is agricultural and drop it if it is not
gen		agland = inlist(a2aq13a, 1, 2, 5, 6) | inlist(a2aq13b, 1, 2, 5, 6)
drop if	agland != 1 
collapse (max) agland, by (HHID)
merge 1:m HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_crops_grown.dta"
drop if _m!=3
drop _m crop_grown
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_agland.dta", replace



use "${UGA_W2_created_data}/Uganda_NPS_W2_land_size.dta", clear
merge 1:m HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_agland.dta"
collapse (mean) farm_area, by (HHID)
ren farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmsize_all_agland.dta", replace




  /*************/
 /* Land Size */
/*************/
* Load data from disk
use "${UGA_W2_raw_data}/AGSEC2A", clear
append using "${UGA_W2_raw_data}/AGSEC2B"

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

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_parcels_held", replace


use "${UGA_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${UGA_W2_raw_data}/AGSEC2B.dta" 
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
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_size_all.dta", replace



  /***********************/
 /* Total Land Holdings */
/***********************/

use "${UGA_W2_raw_data}/AGSEC2A.dta", clear 
gen season=1
append using "${UGA_W2_raw_data}/AGSEC2B.dta" 
replace season = 2 if season == .
ren prcid parcel_id
gen area_acres_meas=a2aq5 if (a2aq5!=. & a2aq5!=0)
replace area_acres_meas=a2aq4 if area_acres_meas==. & (a2aq4!=. & a2aq4!=0)
replace area_acres_meas=a2bq5 if area_acres_meas==. & (a2bq5!=. & a2bq5!=0)
replace area_acres_meas=a2bq4 if area_acres_meas==. & (a2bq4!=. & a2bq4!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size_total
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${UGA_W2_created_data}/Uganda_NPS_W2_land_size_total.dta", replace



********************************************************************************
*                                OFF-FARM HOURS                                *
********************************************************************************

* Load data from disk (Household section 8)
use "${UGA_W2_raw_data}/GSEC8", clear

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

* Save the data
save "${UGA_W2_created_data}/Uganda_NPS_W2_off_farm_hours.dta", replace

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
use "${UGA_W2_raw_data}/AGSEC3A", clear

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

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_mainseason", /*
	*/	replace


  /****************/
 /* Short Season */
/****************/
* Load AgSec3B (Agricultural Inputs and Labor Second Visit) from disk
use "${UGA_W2_raw_data}/AGSEC3B", clear

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

* Save to disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_shortseason", /*
	*/	replace


  /***************/
 /* All Seasons/Hired Labor */
/***************/

* Load/Merge the two newly created files
use "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_mainseason", clear

merge 1:1 HHID parcel_id using /*
	*/ "${UGA_W2_created_data}/Uganda_NPS_W2_farmlabor_shortseason", /*
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
save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_family_hired_labor", /*
	*/	replace

* Collapse labor variables to the household level
collapse  (sum) labor_*, by(HHID)

* Relabel the variables to get rid of the junk added by collapse
label variable labor_hired	"Total labor days (hired) allocated to the farm"
label variable labor_family	"Total labor days (family) allocated to the farm"
label variable labor_total 	/*
	*/	"Total labor days (family, hired, or other) allocated to the farm"

* Save household level data to the disk
save "${UGA_W2_created_data}/Uganda_NPS_W2_family_hired_labor", replace

********************************************************************************
*                                VACCINE  USAGE                                *
********************************************************************************
/*	NOTE: Only Large Ruminants and Equines have data on 
 *	vaccines. The Sheep, goats, pigs module and the poultry/rabbit module
 *	do not include data on vaccine usage.
 */

* 	Load Agricultural Section 6A - Livestock Ownership: Cattle and Pack Animals
* 	dta from Disk
use "${UGA_W2_raw_data}/AGSEC6A", clear

* Standardize key variables across waves
rename	a6aq3 livestock_code
/*	__NOTE__ SAK 20200107: a6aq18 response of 1 means all animals are 
 *	vaccinated, response of 2 is some animals vaccinated
 */
gen		vac_animal	= inlist(a6aq18, 1, 2)

gen		species = 	inrange(livestock_code, 1, 10) + /*
				*/	4*(inlist(livestock_code, 11, 12))	
* Don't use data if no species is specified
recode species (0=.)

* Set the value labels based on the species value labels created earlier
/* 	__NOTE__ label the value of species is pointless as it is 
 *	dropped by the collapse
 */
label values species species
disp "`species_len'"
* Use a loop to reshape the data
forvalues k=1(1)`species_len' {
	local s	: word `k' of `species_list'
	gen vac_animal_`s' = vac_animal if species == `k'
}
* Finish the reshape by collapsing species to the household level
collapse (max) vac_animal*, by(HHID)

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
save "${UGA_W2_created_data}/Uganda_NPS_W2_vaccine", replace

* Load AgSec 6A, B, and C: Livestock Ownership. (contains vaccine data)
use "${UGA_W2_raw_data}/AGSEC6A", replace
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"

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

* Merge in gender data for later gender disaggregation of proportions
merge 1:1 HHID personid using "${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen

* Any people which were not part of the data before the merge should be set as
* not being livestock keepers
recode livestock_keeper (.=0)

* Label newly created variables
label variable all_vac_animal /*
	*/	"1= Individual farmer (livestock keeper) uses vaccines"
label variable livestock_keeper /*
	*/	"1= Individual is listed as a livestock keeper (at least one type of livestock)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmer_vaccine", replace
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
*                         USE OF  INORGANIC FERTILIZER                         *
********************************************************************************
* Load data on Agricultural and Labor Inputs (first and second visit)
use "${UGA_W2_raw_data}/AGSEC3A", clear
append using "${UGA_W2_raw_data}/AGSEC3B" 

* Make 1 = to yes and 0= no on inorganic fertilizer use questions and assume 
* missing answers are no inorganic fertilizer
recode a3aq14 a3bq14 (2=0) (.=0)

* Combine the inorganic fertilizer question from both seasons into 1 variable
egen use_inorg_fert = rowmax(a3aq14 a3bq14)

* Perserve before collapsing to the household level (prevents duplicating work)
preserve
	collapse (max) use_inorg_fert, by (HHID)
	label variable use_inorg_fert "1 = Household uses inorganic fertilizer"
	save "${UGA_W2_created_data}/Uganda_NPS_W2_fert_use", replace
restore

* Parcel manager level *
************************
* Rename to the individual level variable name
rename use_inorg_fert all_use_inorg_fert

* Plot managers are only at the parcel level
collapse (max) all_use_inorg_fert, by(HHID prcid)

* Merge in plot manager details from land holdings data
merge 1:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2A", nogen keep(1 3)
merge 1:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2B", nogen keep(1 3)

* Set the values for the two plot managers
egen personid1 = rowfirst(a2aq27a a2bq25a)
egen personid2 = rowfirst(a2aq27b a2bq25b)

* reshape data so each row has a single personid
reshape long personid, i(HHID prcid)

* drop the missing people created by the reshape
drop if missing(personid)

* Collapse to the individual level
collapse (max) all_use_inorg_fert, by(HHID personid)

* Mark existing individuals as farm manager
gen farm_manager	= 1
* create a farmer id for consistency
gen farmerid		= personid

* Merge in data on farmer's gender from created gender merge file
merge 1:1 HHID personid using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen
* Set in new entries (i.e. those with no entry before the merge) as non farm 
* managers
recode farm_manager (.=0)

* Label the newly created variables
label variable farm_manager /*
	*/	"1= Individual is listed as a manager for at least one plot"
label variable all_use_inorg_fert /*
	*/	"1= Individual farmer (plot manager) uses inorganic fertilizer"
save "${UGA_W2_created_data}/Uganda_NPS_W2_farmer_fert_use", /*
	*/	replace

********************************************************************************
*                             USE OF IMPROVED SEED                             *
********************************************************************************
  /*******************/
 /* Household Level */
/*******************/
**Note: adding the below line because the code kept getting stuck here without it. 
local crop_len : list sizeof global(topcropname_area)

* Load "Crops Grown and Types of Seed Used" first and second visit data
use "${UGA_W2_raw_data}/AGSEC4A", clear
append using "${UGA_W2_raw_data}/AGSEC4B", gen(season)

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

	save "${UGA_W2_created_data}/Uganda_NPS_W2_improvedseed_use", replace
restore
  /********************/
 /* Individual level */
/********************/
* Merge in data on the parcel managers AGSEC2A - Owned Parcels; AGSEC2B - 
* Rented Parcels
merge m:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2A", keep(1 3) nogen
merge m:1 HHID prcid using "${UGA_W2_raw_data}/AGSEC2B", keep(1 3) nogen

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

* Merge in the gender data
merge 1:1 HHID personid using /*
	*/	"${UGA_W2_created_data}/Uganda_NPS_W2_gender_merge", nogen
* Set the value of Farm manager to 0 for people who did not show up prior to the
* merge of gender data and therefore have farm_manager == .
recode farm_manager (.=0)

save "${UGA_W2_created_data}/Uganda_NPS_W2_farmer_improved_seed_use", replace
//Continue
********************************************************************************
*                           REACHED BY AG EXTENSION                            *
********************************************************************************

*use "${UGA_W2_raw_data}/AGSEC9.dta", clear
use "${UGA_W2_raw_data}/AGSEC9", clear
rename HHID hhid
ta a9q2, gen(newvar)
gen ext_reach_public=(newvar4==1)
gen ext_reach_private=(newvar1==1 | newvar2==1 | newvar3==1 | newvar5==1)
gen ext_reach_unspecified=(newvar6==1)
*gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${UGA_W2_created_data}/Uganda_NPS_W2_any_ext", replace

********************************************************************************
*								HOUSEHOLD ASSETS							   *
********************************************************************************
use "${UGA_W2_raw_data}/GSEC14.dta", clear
ren h14q5 value_today
ren h14q4 num_items
*dropping items if hh doesnt report owning them 
tostring h14q3, gen(asset)
drop if asset=="0"
collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets"
save "${UGA_W2_created_data}/Uganda_W2_hh_assets.dta", replace 

********************************************************************************
*                      USE OF FORMAL FINANCIAL SERVICES                       *
********************************************************************************
//Note: Different options than those in wave 7. Couldn't make certain categories that were present in that wave. Disregarded relative/friend.There was also no NGO category, generated this but left it empty. 

use "${UGA_W2_raw_data}/GSEC13A.dta", clear
ta h13q16, gen (borrow)

rename borrow1 borrow_bank
rename borrow10 borrow_other_fin
gen borrow_micro= borrow3==1 | borrow4==1 | borrow6==1 | borrow8==1 | borrow9==1 
gen use_fin_serv_credit= borrow_bank==1 | borrow_micro==1  | borrow_other_fin==1
gen borrow_NGO = 0
//Note: No information on saving in the data even though this was included in the survey. Generated these but left them empty. This means the only variable with data in the final variables was use_fin_serv_all and use_fin_serv_credit

gen use_fin_serv_digital= 0
gen use_fin_serv_others= 0
gen use_fin_serv_bank= 0
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_digital==1 | use_fin_serv_others==1  | use_fin_serv_credit==1

collapse (max) use_fin_serv_*, by (HHID)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"

save "${UGA_W2_created_data}/Uganda_NPS_W2_fin_serv.dta", replace
********************************************************************************


********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
* Not applicable for this Instrument


********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************
* Not applicable for this Instrument


********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${UGA_W2_raw_data}/AGSEC3A.dta", clear
ren prcid parcel_id
ren pltid plot_id
gen season=1 
append using "${UGA_W2_raw_data}/AGSEC3B.dta"
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
save "${UGA_W2_created_data}/Uganda_NPS_W2_ag_wage.dta", replace


********************************************************************************
*LAND RENTAL (*CROP PRODUCTION COSTS PER HECTARE) 
********************************************************************************LRS*
use "${UGA_W2_raw_data}/AGSEC4A.dta", clear
gen season=1 
append using "${UGA_W2_raw_data}/AGSEC4B.dta"
replace season=2 if season==.

ren prcid parcel_id
ren pltid plot_id
gen plot_area=a4aq8 if a4aq8!=.
replace plot_area=a4bq8 if plot_area==. & a4bq8!=.

gen plot_ha = a4aq8/2.47105						
keep plot_ha *_id HHID
collapse (sum) plot_ha, by (HHID)
lab var plot_ha "Plot area in hectare" 
save "${UGA_W2_created_data}/Uganda_NPS_W2_plot_area_lrs.dta", replace

use "${UGA_W2_created_data}/Uganda_NPS_W2_plot_decision_makers.dta", clear // to be used to add plot managers shortly
keep if season==1
tempfile season 
save `season'

*Getting plot rental rate
use "${UGA_W2_raw_data}/AGSEC2B", clear
ren prcid parcel_id
gen land_rent=a2bq9
gen cultivated = (a2bq15b==1 | a2bq15b==2) if a2bq15b!=.
replace cultivated =(a2bq15b==1 | a2bq15b==2) if a2bq15b!=. & cultivated==0
collapse (sum) land_rent (max) cultivated, by (HHID)
merge 1:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_plot_area_lrs.dta" , nogen

merge 1:m HHID using  `season', nogen keep (1 3)
gen plot_rental_rate = land_rent/plot_ha
recode plot_rental_rate (0=.) 
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rent_nomiss_lrs.dta", replace	

//add plot managers 

preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(HHID)
lab var value_rented_land_male "Value of rented land (male-managed plot)
lab var value_rented_land_female "Value of rented land (female-managed plot)
lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rental_rate_lrs.dta", replace
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0			
collapse (sum) plot_rental_rate plot_ha, by(HHID)		
gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				
keep ha_rental_hh_lrs HHID
lab var ha_rental_hh_lrs "Area of rented plot during the long run season"
save "${UGA_W2_created_data}/Uganda_NPS_W2_rental_rate_hhid_lrs.dta", replace
restore

*Merging in geographic variables
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(3)	

*Geographic medians
bys region district subcounty parish: egen ha_rental_count_par = count(ha_rental_rate_hh)
bys region district subcounty parish: egen ha_rental_rate_par = median(ha_rental_rate_hh)
bys region district subcounty: egen ha_rental_count_subc = count(ha_rental_rate_hh)
bys region district subcounty: egen ha_rental_rate_subc = median(ha_rental_rate_hh)
bys region district: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region district: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys region: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_reg = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)

*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_par if ha_rental_count_par>=10		
replace ha_rental_rate = ha_rental_rate_subc if ha_rental_count_subc>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(HHID region district subcounty parish)

lab var ha_rental_rate "Land rental rate per ha"
save "${UGA_W2_created_data}/Uganda_NPS_W2_rental_rate_lrs.dta", replace


*Now getting total ha of all plots that were cultivated at least once
use "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rent_nomiss_lrs.dta", clear
*append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_srs.dta"
collapse (max) cultivated plot_ha, by(HHID plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = plot_ha if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(HHID)				// total ha of all plots that were cultivated in at least one season
lab var ha_cultivated_plots "Area of cultivated plots (ha)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_cultivated_plots_ha.dta", replace


use "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rental_rate_lrs.dta", clear
*append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rental_rate_srs.dta"
*collapse (sum) value_rented_land*, by(hhid)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${UGA_W2_created_data}/Uganda_NPS_W2__hh_rental_rate.dta", replace

*Now getting area planted
*  LRS  *
use "${UGA_W2_raw_data}/AGSEC4A.dta", clear
ren prcid parcel_id
ren pltid plot_id
merge m:1 HHID parcel_id plot_id using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
gen percent_plot = a4aq9
replace percent_plot=100 if percent_plot==. & a4aq7==1 & a4aq7!=.
drop plot_ha	
gen plot_ha = a4aq8/2.47105	
	
gen ha_planted = (percent_plot/100)*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3

*Merging in geographic variables
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(3)				
*Now merging in aggregate rental costs
merge m:1 HHID region district subcounty parish using "${UGA_W2_created_data}/Uganda_NPS_W2_rental_rate_lrs.dta", nogen keep(3)				
*Now merging in rental costs of individual plots
*merge m:1 hhid plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in household rental rate
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_rental_rate_hhid_lrs.dta", nogen keep(1 3)

gen value_owned_land = ha_planted*ha_rental_rate 	
replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. 

*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if dm_gender==1
*replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if  dm_gender==2
*replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if dm_gender==3
*replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & dm_gender==3

//CPK: Confused by the lack of plotID metric... 
collapse (sum) value_owned_land* ha_planted*, by(HHID)			// summing ha_planted across crops on same plot
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed)"
lab var value_owned_land_female "Value of owned land (female-managed)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed)"
lab var ha_planted_female "Area planted (female-managed)"
lab var ha_planted_mixed "Area planted (mixed-managed)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_cost_land_lrs.dta", replace

*  SRS  *
*Now getting area planted
use "${UGA_W2_raw_data}/AGSEC4B.dta", clear
ren prcid parcel_id
ren pltid plot_id
merge m:1 HHID parcel_id plot_id using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
gen percent_plot = a4bq9
replace percent_plot=100 if percent_plot==. & a4bq7==1 & a4bq7!=.
drop plot_ha	
gen plot_ha = a4bq8/2.47105

*Merging in total plot area
gen ha_planted = percent_plot*plot_ha
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3

*Merging in geographic variables
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(3)				
*Now merging in aggregate rental costs
merge m:1 HHID region district subcounty parish using "${UGA_W2_created_data}/Uganda_NPS_W2_rental_rate_lrs", nogen keep(3)				
*Now merging in household rental rate
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_rental_rate_hhid_lrs.dta", nogen keep(1 3)
	
gen value_owned_land = ha_planted*ha_rental_rate 
*replace value_owned_land = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. 	
*Now creating gender value
gen value_owned_land_male = ha_planted*ha_rental_rate if dm_gender==1
*replace value_owned_land_male = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==1
*Female
gen value_owned_land_female = ha_planted*ha_rental_rate if dm_gender==2
*replace value_owned_land_female = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==2
*Mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if dm_gender==3
*replace value_owned_land_mixed = ha_planted*ha_rental_hh_lrs if ha_rental_hh_lrs!=0 & ha_rental_hh_lrs!=. & (ag3a_33==0 | ag3a_33==.) & dm_gender==3
collapse (sum) value_owned_land* ha_planted*, by(HHID)			
append using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_cost_land_lrs.dta"						

preserve
collapse (sum) ha_planted*, by(HHID)
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_ha_planted_total.dta", replace
restore
collapse (sum) ha_planted* value_owned_land*, by(HHID) // taking max area planted (and value owned) by plot so as to not double count plots that were planted in both seasons -- CPK: no plot_id so what's going on?
collapse (sum) ha_planted* value_owned_land*, by(HHID)					// now summing to household
lab var value_owned_land "Value of owned land that was cultivated (household)"
lab var value_owned_land_male "Value of owned land (male-managed plots)"
lab var value_owned_land_female "Value of owned land (female-managed plots)"
lab var value_owned_land_mixed "Value of owned land (mixed-managed plots)"
lab var ha_planted "Area planted (household)"
lab var ha_planted_male "Area planted (male-managed plots)"
lab var ha_planted_female "Area planted (female-managed plots)"
lab var ha_planted_mixed "Area planted (mixed-managed plots)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_cost_land.dta", replace

********************************************************************************
*INPUT COST *
********************************************************************************* 
* LRS  *
use "${UGA_W2_raw_data}/AGSEC3A.dta", clear
ren prcid parcel_id
ren pltid plot_id

*Merging in geographic variables first (for constructing prices)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(3)		
*Gender variables
merge m:1 HHID parcel_id plot_id using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
gen value_inorg_fert_lrs = a3aq19			
gen value_herb_pest_lrs = a3aq31	
gen value_org_purchased_lrs = a3aq8

preserve
gen fert_org_kg = a3aq5	// need to verify if these are reported in kilograms and if not convert 
gen fert_inorg_kg = a3aq16	
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3

collapse (sum) fert_org_kg fert_inorg_kg*, by(HHID)
lab var fert_org_kg "Organic fertilizer (kgs)"
lab var fert_inorg_kg "Inorganic fertilizer (kgs)"	
lab var fert_inorg_kg_male "Inorganic fertilizer (kgs) for male-managed crops"
lab var fert_inorg_kg_female "Inorganic fertilizer (kgs) for female-managed crops"
lab var fert_inorg_kg_mixed "Inorganic fertilizer (kgs) for mixed-managed crops"
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_fert_lrs.dta", replace
restore

recode a3aq5 a3aq7 (.=0) if a3aq4!=.			
gen org_fert_notpurchased = a3aq5-a3aq7			
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0	
gen org_fert_purchased = a3aq7						
gen org_fert_price = a3aq8 /org_fert_purchased		
recode org_fert_price (0=.)   

*Household-specific value
preserve
keep if org_fert_purchased!=0 & org_fert_purchased!=.		
collapse (sum) org_fert_purchased a3aq8, by(HHID)		
gen org_fert_price_hh = a3aq8/org_fert_purchased
save "${UGA_W2_created_data}/Uganda_NPS_W2_org_fert_lrs.dta", replace
restore
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_org_fert_lrs.dta", nogen

*Geographic medians
bys region district subcounty parish: egen org_price_count_par = count(org_fert_price)
bys region district subcounty parish: egen org_price_par = median(org_fert_price) 
bys region district subcounty: egen org_price_count_subc = count(org_fert_price)
bys region district subcounty: egen org_price_subc = median(org_fert_price) 
bys region district: egen org_price_count_dist = count(org_fert_price)
bys region district: egen org_price_dist = median(org_fert_price) 
bys region: egen org_price_count_reg = count(org_fert_price)
bys region: egen org_price_reg = median(org_fert_price)
egen org_price_nat = median(org_fert_price)
drop org_fert_price
gen org_fert_price = org_price_par if org_price_count_par>=10
replace org_fert_price = org_price_subc if org_price_count_subc>=10 & org_fert_price==.
replace org_fert_price = org_price_dist if org_price_count_dist>=10 & org_fert_price==.
replace org_fert_price = org_price_reg if org_price_count_reg>=10 & org_fert_price==.
replace org_fert_price = org_price_nat if org_fert_price==.			
replace org_fert_price = org_fert_price_hh if org_fert_price_hh!=. & org_fert_price_hh!=0		
gen value_org_notpurchased_lrs = org_fert_price*org_fert_notpurchased	

* Note: In UGA, labor not broken down by specific farm activity 
		
*Hired labor //CPK: don't have this in the instrument
egen hired_labor = rowtotal(a3aq42a a3aq42b a3aq42c) if (a3aq42a!=. & a3aq42b!=. & a3aq42c!=.)

*Hired wages:
gen hired_wage = a3aq43

*Hired costs
gen hired_labor_costs = a3aq43

gen value_hired_labor_lrs = hired_labor_costs
*Constructing a household-specific wage
preserve
collapse (sum) hired_labor hired_wage hired_labor_costs, by(HHID)	
gen hired_wage_hh = hired_labor_costs/hired_labor									
recode *wage* (0=.)			
save "${UGA_W2_created_data}/Uganda_NPS_W2_wages_hh_lrs.dta", replace
restore

*Merging right back in
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_wages_hh_lrs.dta", nogen

*Going to construct wages separately for each type
*Constructing for each labor type
foreach i in hired {
	recode `i'_wage (0=.) 
	bys region district subcounty parish: egen `i'_wage_count_par = count(`i'_wage)
	bys region district subcounty parish: egen `i'_wage_price_par = median(`i'_wage)
	bys region district subcounty: egen `i'_wage_count_subc = count(`i'_wage)
	bys region district subcounty: egen `i'_wage_price_subc = median(`i'_wage)
	bys region district: egen `i'_wage_count_dist = count(`i'_wage)
	bys region district: egen `i'_wage_price_dist = median(`i'_wage)
	bys region: egen `i'_wage_count_reg = count(`i'_wage)
	bys region: egen `i'_wage_price_reg = median(`i'_wage)
	egen `i'_wage_price_nat = median(`i'_wage)
	*Creating wage rate
	gen `i'_wage_rate = `i'_wage_price_par if `i'_wage_count_par>=10
	replace `i'_wage_rate = `i'_wage_price_subc if `i'_wage_count_subc>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_dist if `i'_wage_count_dist>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_reg if `i'_wage_count_reg>=10 & `i'_wage_rate==.
	replace `i'_wage_rate = `i'_wage_price_nat if `i'_wage_rate==.
}

*Renaming (dropping lrs)
ren *_lrs *
foreach i in value_inorg_fert value_herb_pest value_org_purchased value_org_notpurchased value_hired_labor {
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
}
collapse (sum) value_*, by(HHID)
save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_cost_inputs_lrs.dta", replace


*  SRS  *
use "${UGA_W2_raw_data}/AGSEC3B.dta", clear
ren prcid parcel_id
ren pltid plot_id
*Merging in geographic variables first (for constructing prices)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", nogen keep(3)		
*Gender variables
merge m:1 HHID parcel_id plot_id using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_rent_nomiss_lrs.dta", nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
gen value_inorg_fert_srs = a3bq19			
gen value_herb_pest_srs = a3bq31
gen value_org_purchased_srs = a3bq8

preserve
gen fert_org_kg = a3bq5
gen fert_inorg_kg = a3bq16	
gen fert_inorg_kg_male = fert_inorg_kg if dm_gender==1
gen fert_inorg_kg_female = fert_inorg_kg if dm_gender==2
gen fert_inorg_kg_mixed = fert_inorg_kg if dm_gender==3
collapse (sum) fert_org_kg fert_inorg_kg*, by(HHID)

save "${UGA_W2_created_data}/Uganda_NPS_W2_hh_fert_srs.dta", replace
restore
recode a3bq5 a3bq7 (.=0) if a3bq4!=.			
gen org_fert_notpurchased = a3bq5-a3bq7		
replace org_fert_notpurchased = 0 if org_fert_notpurchased<0			
gen org_fert_purchased = a3bq7					
gen org_fert_price = a3bq5/org_fert_purchased		
recode org_fert_price (0=.)



********************************************************************************
*RATE OF FERTILIZER APPLICATION
********************************************************************************
use "${UGA_W2_created_data}/Uganda_NPS_W2_hh_cost_land.dta", clear
append using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_fert_lrs.dta"
append using "${UGA_W2_created_data}/Uganda_NPS_W2_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(HHID)
merge m:1 HHID using "${UGA_W2_created_data}/Uganda_NPS_W2_hhids.dta", keep (1 3) nogen
drop ha_planted*
lab var fert_inorg_kg "Quantity of fertilizer applied (kgs) (household level)"
lab var fert_inorg_kg_male "Quantity of fertilizer applied (kgs) (male-managed plots)"
lab var fert_inorg_kg_female "Quantity of fertilizer applied (kgs) (female-managed plots)"
lab var fert_inorg_kg_mixed "Quantity of fertilizer applied (kgs) (mixed-managed plots)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_fertilizer_application.dta", replace

********************************************************************************
*WOMEN'S DIET QUALITY
*******************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
use "${UGA_W2_raw_data}/GSEC15B", clear
rename hh HHID
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
save "${UGA_W2_created_data}/Uganda_NPS_W2_household_diet.dta", replace
********************************************************************************
                     * WOMEN'S CONTROL OVER INCOME *
********************************************************************************

* First append all files with information on who control various types of income
use "${UGA_W2_raw_data}/AGSEC5A", clear
append using  "${UGA_W2_raw_data}/AGSEC5B"
append using "${UGA_W2_raw_data}/AGSEC6A" 
append using "${UGA_W2_raw_data}/AGSEC6B" 	
append using "${UGA_W2_raw_data}/AGSEC6C" 	
append using  "${UGA_W2_raw_data}/AGSEC8"


append using "${UGA_W2_raw_data}/GSEC12" //  //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b
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
*	Now merge with member characteristics
*tostring HHID, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
merge m:1 HHID personid using "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${UGA_W2_created_data}/Uganda_NPS_W2_control_income.dta", replace

use "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", replace
use "${UGA_W2_created_data}/Uganda_NPS_W2_control_income.dta", replace

********************************************************************************
            * WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING *
********************************************************************************


********************************************************************************
                      * WOMEN'S OWNERSHIP OF ASSETS *
********************************************************************************

use "${UGA_W2_raw_data}/AGSEC2", clear
append using "${UGA_W2_raw_data}/AGSEC2A"
append using "${UGA_W2_raw_data}/AGSEC2B"
append using "${UGA_W2_raw_data}/AGSEC6A"
append using "${UGA_W2_raw_data}/AGSEC6B"
append using "${UGA_W2_raw_data}/AGSEC6C"
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
ren asset_owner personid
*tostring HHID, format(%18.0f) replace
*tostring PID, format(%18.0f) replace
* Now merge with member characteristics
merge 1:1 HHID personid  using  "${UGA_W2_created_data}/Uganda_NPS_W2_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${UGA_W2_created_data}/Uganda_NPS_W2_ownasset.dta", replace






********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************
* This section and final summary statistics datasets are currently being coded. Please continue checking our EPAR Github for future updates.


