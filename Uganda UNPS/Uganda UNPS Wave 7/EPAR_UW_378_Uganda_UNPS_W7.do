/*
--------------------------------------------------------------------------------------
*Title/Purpose: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) for the construction of a set of agricultural development indicators using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 7 (2018-19)

*Author(s): Didier Alia, Andrew Tomes, Peter Agamile & C. Leigh Anderson

*Acknowledgments: We acknowledge the helpful contributions of Pierre Biscaye, David Coomes, Nina Forbes, Joshua Grandbouche, Basil Hariri, Conor Hennessy, Marina Kaminsky, Claire Kasinadhuni, Sammi Kiel, Jack Knauer, Josh Merfeld, Adam Porton, Ahana Raina, Nezih Evren, Travis Reynolds, Carly Schmidt, Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, and Sebastian Wood, members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions.
															  
*Date : 21st May 2024

*Dataset Version: UGA_2018_UNPS_v02_M
--------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Uganda National Panel Survey was collected by the Uganda National Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period February 2018 - February 2019.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2862

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "raw_data" folder within the "uganda-wave7-2018-19" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "/uganda-wave7-2018-19/created data".
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "/uganda-wave7-2018-19/final data".

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of this do.file, there is a reference to another do.file that estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager or farm size.
*The results are outputted in the excel file "Uganda_NPS_W7_summary_stats.xlsx" in the "/uganda-wave7-2018-19/final data" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.
										
 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W7_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W7_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W7_hhsize.dta
*PLOT AREAS							Uganda_NPS_W7_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W7_plot_decision_makers.dta

*MONOCROPPED PLOTS					Uganda_NPS_W7_[CROP]_monocrop_hh_area.dta
									
*TLU (Tropical Livestock Units)		Uganda_NPS_W7_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_W7_tempcrop_harvest.dta
									Uganda_NPS_W7_tempcrop_sales.dta
									Uganda_NPS_W7_permcrop_harvest.dta
									Uganda_NPS_W7_permcrop_sales.dta
									Uganda_NPS_W7_hh_crop_production.dta
									Uganda_NPS_W7_plot_cropvalue.dta
									Uganda_NPS_W7_crop_residues.dta
									Uganda_NPS_W7_hh_crop_prices.dta
									Uganda_NPS_W7_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_W7_wages_mainseason.dta
									Uganda_NPS_W7_wages_shortseason.dta
									Uganda_NPS_W7_fertilizer_costs.dta
									Uganda_NPS_W7_seed_costs.dta
									Uganda_NPS_W7_land_rental_costs.dta
									Uganda_NPS_W7_asset_rental_costs.dta
									Uganda_NPS_W7_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_W7_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W7_livestock_expenses.dta
									Uganda_NPS_W7_hh_livestock_products.dta
									Uganda_NPS_W7_dung.dta
									Uganda_NPS_W7_livestock_sales.dta
									Uganda_NPS_W7_TLU.dta
									Uganda_NPS_W7_livestock_income.dta

*FISH INCOME						Uganda_NPS_W7_fishing_expenses_1.dta
									Uganda_NPS_W7_fishing_expenses_2.dta
									Uganda_NPS_W7_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W7_self_employment_income.dta
									Uganda_NPS_W7_agproducts_profits.dta
									Uganda_NPS_W7_fish_trading_revenue.dta
									Uganda_NPS_W7_fish_trading_other_costs.dta
									Uganda_NPS_W7_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_W7_wage_income.dta
									Uganda_NPS_W7_agwage_income.dta

*OTHER INCOME						Uganda_NPS_W7_other_income.dta
									Uganda_NPS_W7_land_rental_income.dta
									
*FARM SIZE / LAND SIZE				Uganda_NPS_W7_land_size.dta
									Uganda_NPS_W7_farmsize_all_agland.dta
									Uganda_NPS_W7_land_size_all.dta
									Uganda_NPS_W7_land_size_total.dta

*OFF-FARM HOURS						Uganda_NPS_W7_off_farm_hours.dta

*FARM LABOR							Uganda_NPS_W7_farmlabor_mainseason.dta
									Uganda_NPS_W7_farmlabor_shortseason.dta
									Uganda_NPS_W7_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_W7_vaccine.dta
									Uganda_NPS_W7_farmer_vaccine.dta
									
*ANIMAL HEALTH						Uganda_NPS_W7_livestock_diseases.dta
									Uganda_NPS_W7_livestock_feed_water_house.dta

*USE OF INORGANIC FERTILIZER		Uganda_NPS_W7_fert_use.dta
									Uganda_NPS_W7_farmer_fert_use.dta

*USE OF IMPROVED SEED				Uganda_NPS_W7_improvedseed_use.dta
									Uganda_NPS_W7_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W7_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W7_fin_serv.dta
*MILK PRODUCTIVITY					Uganda_NPS_W7_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W7_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W7_hh_rental_rate.dta
									Uganda_NPS_W7_hh_cost_land.dta
									Uganda_NPS_W7_hh_cost_inputs_lrs.dta
									Uganda_NPS_W7_hh_cost_inputs_srs.dta
									Uganda_NPS_W7_hh_cost_seed_lrs.dta
									Uganda_NPS_W7_hh_cost_seed_srs.dta
									Uganda_NPS_W7_asset_rental_costs.dta
									Uganda_NPS_W7_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Uganda_NPS_W7_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W7_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W7_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W7_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W7_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W7_ownasset.dta

*CROP YIELDS						Uganda_NPS_W7_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_W7_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_W7_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_W7_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_W7_hh_assets.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W7_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W7_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W7_field_plot_variables.dta
*SUMMARY STATISTICS					Uganda_NPS_W7_summary_stats.xlsx
*/

 
clear	
set more off
clear matrix	
clear mata	
set maxvar 10000	
ssc install findname  // need this user-written ado file for some commands to work

**Set directories 

global directory "../.."
global Uganda_NPS_W7_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 7/Raw DTA Files"
global Uganda_NPS_W7_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 7/Final DTA Files/created_data"
global Uganda_NPS_W7_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 7/Final DTA Files/final_data"
global summary_stats "$directory/_Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS.do"

*Some parcel values are missing in the all plots section (since they are the same in the previous waves). We will using wave 5 data in order to fill in those values. 
global Uganda_NPS_W5_raw_data 	"$directory/Uganda UNPS/Uganda UNPS Wave 5/Raw DTA Files"
global Uganda_NPS_W5_created_data "$directory/Uganda UNPS/Uganda UNPS Wave 5/Final DTA Files/created_data"
global Uganda_NPS_W5_final_data  "$directory/Uganda UNPS/Uganda UNPS Wave 5/Final DTA Files/final_data"

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
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
global UGA_W7_exchange_rate 3727.069		// Rate for 2018 from https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2020&locations=UG&start=1960 (replaced this> https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2015.html). instead of using a spot rate, think its better to use the annual average rate from WB.
global UGA_W7_gdp_ppp_dollar 1270.608398 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PPP?locations=UG
global UGA_W7_cons_ppp_dollar 1221.087646 // updated 4.6.23 to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG
global UGA_W7_inflation 1.05558616387 //CPI_SURVEY_YEAR/CPI_2017 -> CPI_2019/CPI_2017 -> 176.049367/166.7787747 from https://data.worldbank.org/indicator/FP.CPI.TOTL. The data were collected over the period February 2018 - February 2019.

global UGA_W7_poverty_190 ((1.90*944.255*142.024166)/116.6)
global UGA_W7_poverty_215 (2.15 * $UGA_W7_inflation * $UGA_W7_cons_ppp_dollar)  //New 2017 poverty line - 124.68 N


*Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Uganda_NPS_W7_pop_tot 42232238
global Uganda_NPS_W7_pop_rur 32065890
global Uganda_NPS_W7_pop_urb 10166348

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables
global wins_5_thres 5								//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_95_thres 95								//Threshold for winzorization at the top 5% of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
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

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropname_table.dta", replace 

********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "${Uganda_NPS_W7_raw_data}\GSEC1.dta", clear
ren hwgt_W7  weight 
gen rural = urban == 0 
gen strataid = region
ren district district_name
ren parish_code parish 
ren county_code county 
ren subcounty_code subcounty

keep hhid region district district_name subcounty subcounty_name parish county_name    parish_name rural weight strataid // ea and village variables missing in this section
label var rural "1 = Household lives in a rural area"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", replace

********************************************************************************
*WEIGHTS*
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/GSEC1.dta", clear
rename hwgt_W7 weight 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta"
keep hhid weight rural
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", replace


********************************************************************************
*INDIVIDUAL IDS
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/GSEC2.dta", clear
destring pid_unps, gen(indiv) ignore ("P" "-") //PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P", leading "0", and the "-"
gen female = h2q3==2
label var female "1= individual is female"
gen age = h2q8
label var age "Individual age"
gen hh_head = h2q4==1 
label var hh_head "1= individual is household head"
ren PID ind
tostring ind, gen (individ)

*clean up and save data
label var indiv "Personal identification"
label var individ "Roster number (identifier within household)"
keep hhid indiv individ female age hh_head
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", replace

 
********************************************************************************
*HOUSEHOLD SIZE
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/GSEC2", clear
gen hh_members = 1
ren h2q4 relhead 

ren h2q3 gender
gen fhh = (relhead==1 & gender==2) 
collapse (sum) hh_members (max) fhh, by (hhid)	

*Clean and save data
label var hh_members "Number of household members"
label var fhh "1 = Female-headed household"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", replace



* Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Uganda_NPS_W7_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Uganda_NPS_W7_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1
total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Uganda_NPS_W7_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0
egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", replace
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", nogen
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", replace

********************************************************************************

** GEOVARIABLES ** 
*Dataset does not exist in Wave 7

********************************************************************************


********************************************************************************
*PLOT AREAS 
********************************************************************************

* plot area cultivated
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta", gen (last)		
replace season = 2 if last==1
label var season "Season = 1 if 2nd cropping season of 2017, 2 if 1st cropping season of 2018" // need to check again
ren cropID cropcode

gen plot_area = s4aq07 //values are in acres
replace plot_area = s4bq07 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
ren plot_area ha_planted

gen percent_planted = s4aq09/100
replace percent_planted = s4bq09/100 if percent_planted==.
bys hhid parcelID pltid season : egen total_percent_planted = sum(percent_planted) 
duplicates tag hhid parcelID pltid season, g(dupes) 
gen missing_ratios = dupes > 0 & percent_planted == . 
bys hhid parcelID pltid season : egen total_missing = sum(missing_ratios) 
gen remaining_land = 1 - total_percent_planted if total_percent_planted < 1 
bys hhid parcelID pltid season : egen any_missing = max(missing_ratios)
*Fix monocropped plots
replace percent_planted = 1 if percent_planted == . & any_missing == 0 
*Fix plots with or without missing percentages that add up to 100% or more
replace percent_planted = 1/(dupes + 1) if any_missing == 1 & total_percent_planted >= 1 
replace percent_planted = percent_planted/total_percent_planted if total_percent_planted > 1
*Fix plots that add up to less than 100% and have missing percentages
replace percent_planted = remaining_land/total_missing if missing_ratios == 1 & percent_planted == . & total_percent_planted < 1 

*Bring everything together
collapse (max) ha_planted (sum) percent_planted, by(hhid parcelID pltid season)
gen plot_area = ha_planted / percent_planted
bys hhid parcelID season : egen total_plot_area = sum(plot_area)
gen plot_area_pct = plot_area/total_plot_area
keep hhid parcelID pltid season plot_area total_plot_area plot_area_pct ha_planted

merge m:1 hhid parcelID using "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", nogen
merge m:1 hhid parcelID using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta", nogen
ren s2* s2*_w7
ren a2* a2*_w7
ren t0_hhid HHID
replace HHID = hhid if !strpos(HHID, "H")
duplicates drop HHID parcelID, force
*Adding in parcel areas from wave 5 
merge 1:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2A.dta", nogen
merge 1:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2B.dta", nogen
// 1476 missing parcel_acre 
*generating field_size
gen parcel_acre = s2aq4_w7 //Used GPS estimation here to get parcel size in acres if we have it, but many parcels do not have GPS estimation
replace parcel_acre = s2aq04_w7 if parcel_acre == . 
replace parcel_acre = s2aq5_w7 if parcel_acre == . //replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres)
replace parcel_acre = s2aq05_w7 if parcel_acre == .
replace parcel_acre = a2aq4 if parcel_acre==.
replace parcel_acre = a2aq5 if parcel_acre==.
replace parcel_acre = a2bq4 if parcel_acre==.
replace parcel_acre = a2bq5 if parcel_acre==.
gen field_size = plot_area_pct*parcel_acre //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen parcel_ha = parcel_acre * 0.404686
*cleaning up and saving the data
ren pltid plot_id
ren parcelID parcel_id
keep hhid parcel_id plot_id season field_size plot_area total_plot_area parcel_acre parcel_ha ha_planted
drop if field_size == .
label var field_size "Area of plot (ha)"
label var hhid "Household identifier"
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/GSEC2.dta", clear
ren PID personid			
gen female =h2q3==2
ren h2q8 age
gen head = h2q4==1 if h2q4!=.
ren hhid HHID
keep personid female age HHID head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_gender_merge.dta", replace

use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta" 
replace season = 2 if season == .

ren hhid HHID
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id == . 
destring s3aq03_3, replace 
replace s3aq03_3 = s3aq03_3 if s3aq03_3==.
tostring s3aq03_3, gen(personid) format(%18.0f) 
destring personid, replace 
tostring HHID, format(%18.0f) replace
merge m:1 HHID personid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_gender_merge.dta", gen(dm1_merge) keep(1 3) 

*First decision-maker variables 
gen dm1_female = female
gen individ = s3aq03_3
destring s3aq03_3, replace 
destring s3bq03_3, replace 
replace individ = s3bq03_3 if individ == . & s3bq03_3 != .
drop personid 
*ren individ personid
tostring individ, replace 
ren HHID hhid 
drop dm1_merge

merge m:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using

* multiple decision makers 
gen dm_gendermult=s3aq03_2==2
replace dm_gendermult=s3bq03_2==2 if dm_gendermult==0

*Second decision-maker variables // Note: data only available on primary decision maker in wave 7


collapse (max) dm1_female dm_gendermult, by (hhid parcel_id plot_id season)

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep hhid parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & !(dm1_female == .) //if both dm1 and dm2 are null, then dm_gender is null

replace dm_gender = 3 if dm_gender == . & dm1_female == . & dm_gendermult==1 //no mixed-gender managed plots

label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", nogen
replace dm_gender = 1 if fhh == 0 & dm_gender == .
replace dm_gender = 2 if fhh == 1 & dm_gender == . 
drop if plot_id == . 
keep hhid parcel_id plot_id season dm_gender fhh 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen formal_land_rights = 1 if s2aq23<4 & s2aq23!=.
replace formal_land_rights = 0 if s2aq23==4  // added this line for HH w/o documents as zero (prior we only had 1's and missing information)

*Starting with first owner
preserve 
tostring s2aq24__0, gen(individ) format(%18.0f) 
tostring hhid, format(%18.0f) replace
merge m:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)	// PID string and HHID+PID formatted 
keep hhid individ female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve 
tostring s2aq24__1, gen(individ) format(%18.0f) 
tostring hhid, format(%18.0f) replace
merge m:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)	// PID string and HHID+PID formatted 
keep hhid individ female formal_land_rights
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid individ)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rights_ind.dta", replace
restore

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rights_hh.dta", replace
restore

 

**************
*AREA PLANTED*
**************
use "${Uganda_NPS_W7_raw_data}/AGSEC4A", clear 
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B"
replace season = 2 if season == .
ren cropID crop_code
ren parcelID parcel_id
ren pltid plot_id

// check variable for cultivated
gen ha_planted = s4aq07*(1/2.47105)
replace ha_planted = s4bq07*(1/2.47105) if ha_planted==.

collapse (sum) ha_planted, by (hhid parcel_id plot_id crop_code season)

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_area_planted_temp.dta", replace

********************************************************************************
*ALL PLOTS
********************************************************************************

	***************************
	*Crop Values 
	***************************
	use "${Uganda_NPS_W7_raw_data}/AGSEC5A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W7_raw_data}/AGSEC5B.dta"
	replace season = 2 if season == .
	gen condition_harv=a5aq6b
replace condition_harv =  a5bq6b if condition_harv==.
gen unit_code_harv=a5aq6c
replace unit_code_harv = a5bq6c if unit_code_harv==.
clonevar conv_factor_harv = a5aq6d 
replace conv_factor_harv = a5bq6d if season==2
replace conv_factor_harv = 1 if unit_code_harv==1

*Unit of crop Sold
	ren s5aq07a_1 sold_qty
	replace sold_qty = s5bq07a_1 if sold_qty == .
	ren s5aq07c_1 sold_unit_code 
	replace sold_unit_code=s5bq07c_1 if sold_unit_code==.
	
	
	ren s5aq08_1 sold_value
	replace sold_value=s5bq08_1 if sold_value==.
	ren pltid plot_id
	ren parcelID parcel_id
	ren cropID crop_code
	gen unit_cd=a5bq6b
	replace unit_cd=a5aq6c if unit_cd==.
	clonevar conv_factor_sold = conv_factor_harv 
replace conv_factor_sold = 1 if sold_unit_code==1
gen quant_sold_kg = sold_qty*conv_factor_sold 
	merge m:1 hhid using "${Uganda_NPS_W7_created_data}\Uganda_NPS_W7_hhids.dta", nogen keep(1 3)
	ren hhid HHID


	**********************************
** Standard Conversion Factor Table **
**********************************
* This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold 


***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
*Region is not present
merge m:1 crop_code sold_unit_code region using  "${Uganda_NPS_W7_created_data}\UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_W7_created_data}\UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 *We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region!=. // We merge the national standard conversion factor for those HHID with missing regional info. 
gen s_quant_sold_kg = sold_qty*s_conv_factor_sold
replace s_quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen s_price_unit = sold_value/s_quant_sold_kg 
gen obs1 = s_price_unit!=.

// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standar conversion factor table)
foreach i in region district county subcounty /* ea*/ parish  HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen s_obs_`i'_price = sum(obs1)
		collapse (median) s_price_unit_`i' = s_price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' s_obs_`i'_price)
		tempfile s_price_unit_`i'_median
		save `s_price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) s_price_unit_country = s_price_unit (sum) s_obs_country_price = obs1 [aw=weight], by(crop_code /*sold_unit_code*/)
	tempfile s_price_unit_country_median
	save `s_price_unit_country_median'
	restore


***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
merge m:1 crop_code unit_code region using "${Uganda_NPS_W7_created_data}\UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${Uganda_NPS_W7_created_data}\UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
*This is for HHID that are missing regional information


* From Conversion factor section to calculate medians
clonevar quantity_harv=harvest
replace quantity_harv=harvest_b if quantity_harv==.
*gen quant_harv_kg = quantity_harv*conv_factor_harv 
replace s_conv_factor_harv = sn_conv_factor_harv if region==. //  SAW 7/25/23 We merge the national standard conversion factor for those HHID with missing regional info.
gen quant_harv_kg = quantity_harv*s_conv_factor_harv 

*Notes: There are many observations who harvested but do not have s_conversion factors harvest given that they are missing the region variable (Need to fix this) One option would be to calculate national level median conversion factors -both harvested and sold - and assign those values to HHID with missing region information.

*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg  that using the WB conversion factors -though there are many cases that standard qty harvested is smaller than the WB qty harvested. 
*Notes: Should we winsorize the sold qty ($) prior to calculating the price per kg giventhis variable is also driving the variation and has many outliers. Though, it won't affect themedian price per kg it will affect the  price per unit for all the observations that do have sold harvested affecting the value of harvest. 


	 * We do not have information about the year of harvest. Questionnaire references the variable to year 2011 and we have information on month of harvest start and month of harvest end.
gen month_harv_date = s5aq06e_1
replace month_harv_date = s5bq06e_1 if season==2
gen year_harv_date = s5aq06e_1_1
replace year_harv_date = s5bq06e_1_1
gen harv_date = ym(year_harv_date,month_harv_date)
format harv_date %tm
label var harv_date "Harvest start date"

gen month_harv_end = s5aq06f_1
replace month_harv_end = s5bq06f_1
gen year_harv_end = s5aq06f_1_1
replace year_harv_end = s5bq06f_1_1 if year_harv_end==.
gen harv_end = ym(year_harv_end,month_harv_end)
format harv_end %tm
label var harv_end "Harvest end date"

* Create Price unit for converted sold quantity (kgs)
gen price_unit=sold_value/(quant_sold_kg)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=.
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
	
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_value.dta", replace
*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested*/
	//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.
	
	foreach i in region district county subcounty parish /*ea*/ HHID {
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
	
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master

**********************************
**  Update: Standard Conversion Factor Table END **
**********************************
	
	***************************
	*Plot variables
	***************************	
	preserve
	use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta"
	replace season = 2 if season == .
	
	ren pltid plot_id
	ren parcelID parcel_id
	*ren cropID crop_code
	drop if cropID == .

	clonevar crop_code = cropID //we want to keep the original crop IDs intact while reducing the number of categories in the master version
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223)
label define cropID 740 "BANANAS" 220 "PEAS", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master
tostring hhid, format(%18.0f) replace



	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3) // terrible merge, only 2623 matched
	
	gen perm_tree = 1 if inlist(crop_code, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop"
ren hhid HHID
duplicates drop HHID parcel_id plot_id crop_code season, force 
tempfile plotplanted
save `plotplanted'
restore
merge m:1 HHID parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3)
**********************************
** Plot Variables After Merge **
**********************************
* Update - *Ahana: no planting dates

*gen months_grown1 = harv_date - plant_date if perm_tree==0
*gen months_grown = harv_date - plant_date if perm_tree==0
*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		collapse (sum) crops_plot = obs2, by(HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen
	*drop if hh_agric == .
	*gen contradict_mono = 1 if s4aq09 == 100 | s4bq09 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	*gen contradict_inter = 1 if crops_plot == 1
	*replace contradict_inter = . if s4aq09 == 100 | s4aq08 == 1 | s4bq09 == 100 | s4bq08 == 1 //meanwhile 64 list intercropping or mixed cropping but only report one crop

*Generate variables around lost and replanted crops
	gen lost_crop = inrange(s5bq17_1,1,5) | inrange(s5bq17_2,1,5) // SAW I think it should be intange(var,1,5) why not include "other"
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.
ren HHID hhid
*Generating monocropped plot variables (Part 1)
	bys hhid parcel_id plot_id season: egen crops_avg = mean(crop_code) //Checks for different versions of the same crop in the same plot and season
	*gen purestand = (s4aq08 == 1 | s4bq08 == 1) if  (s4aq08!=. | s4bq08!=.)
	gen purestand=1
	bys hhid parcel_id plot_id season : egen permax = max(perm_tree)
	*bys hhid parcel_id plot_id season Crop_Planted_Month Crop_Planted_Year Crop_Planted_Month2 Crop_Planted_Year2 : gen plant_date_unique = _n
	bysort hhid parcel_id plot_id season: gen cropcount= _N
	bysort hhid parcel_id plot_id: gen perm_crop= _N
	gen perm_code =crop_code if perm_crop!=0 //Assuming perm_crop == 1 if crop is a tree crop and 0 otherwise
	bys hhid parcel_id plot_id : egen mean_pc = mean(perm_code)	
	replace purestand = 0 if (cropcount > 1 & crop_code != perm_code) | (cropcount == 1 & (perm_crop > 1 | (perm_crop == 1 & crop_code != perm_code))) 

	*bys hhid parcel_id plot_id season: egen max_intercrop = max(contradict_inter)
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (s4aq08 == 2 | s4bq08 == 2) if  (s4aq08!=. | s4bq08!=.)
	bys hhid parcel_id plot_id season : egen mixed_max = max(mixed)
	*replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	*replace purestand = 0 if purestand == . //assumes null values are just 0 
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys hhid parcel_id plot_id season: egen total_percent = total(percent_field)
	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	replace ha_planted = percent_field*field_size
	gen ha_harvest=ha_planted
ren hhid HHID
	**********************************
** Crop Harvest Value **
**********************************
* Update Incorporating median price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors 
foreach i in  region district county subcounty parish /*ea*/ HHID {	
	merge m:1 `i' /*unit_code*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
}
	merge m:1 /*unit_code*/ crop_code using `price_unit_country_median', nogen keep(1 3)
rename price_unit val_unit

*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
recode obs_* (.=0) //ALT 
foreach i in country region district county subcounty parish /*ea*/ {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	*replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .
	gen value_harvest = val_unit*quant_harv_kg 

preserve
	ren unit_code_harv unit
	collapse (mean) val_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_prices_for_wages.dta", replace
restore
/*
*Combining Banana crops in one category, and coffee arabica and robusta into one coffee category. Update
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master
*/
*AgQuery+
	collapse (sum) ha_harvest quant_harv_kg value_harvest ha_planted percent_field /*s_quant_harv_kg months_grown plant_dat s_value_harvest*/ (max) harv_date harv_end, by(region district county subcounty parish /*ea*/ HHID parcel_id plot_id season crop_code purestand field_size /*month_planted month_harvest*/)

	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	ren HHID hhid
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace

********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************

********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC5A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC5B.dta"
replace season = 2 if season == .
	
ren pltid plot_id
ren parcelID parcel_id
ren cropID crop_code
ren s5aq08_1 value_sold
replace value_sold = s5bq08_1 if value_sold == . 
recode value_sold (.=0)
*s5bq07a_2 seems to be for partial harvest 
ren s5aq07a_1 qty_sold 
replace qty_sold = s5bq07a_1 if qty_sold==. & s5bq07a_1!=. 
gen sold_unit_code=s5aq07c_1
replace sold_unit_code=s5bq07c_1 if sold_unit_code==.
* harvest (2nd season in 2017 & 1st season in 2018)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using  "${Uganda_NPS_W7_created_data}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen //4926 matched and 9268 not matched 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${Uganda_NPS_W7_created_data}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 
*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = qty_sold*s_conv_factor_sold
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
collapse (sum) value_sold kgs_sold, by (hhid crop_code season) // adding in season here...since assuming that value of goods sold does vary by season - done in order to merge in crop production per hectare properly
lab var value_sold "Value of sales of this crop"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropsales_value.dta", replace


use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace
collapse (sum) value_harvest quant_harv_kg , by (hhid crop_code season) 
merge 1:1 hhid crop_code season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropsales_value.dta"
recode value_harvest value_sold (.=0)
replace value_harvest = value_sold if value_sold>value_harvest & value_sold!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value_sold value_crop_sales 
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production.dta", replace

//Legacy code 
collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Uganda_NPS_W7_raw_data}/AGSEC5A.dta", clear
gen season=1 
append using "${Uganda_NPS_W7_raw_data}/AGSEC5B.dta"
replace season=2 if season==.
rename parcelID parcel_id
rename pltid plot_id
ren cropID crop_code 
*rename HHID hhid2
*rename hh HHID
recode crop_code (811 812 = 810) (741 742 744 = 740) (224 = 223) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
drop if crop_code==.
*1st cropping season data not in the raw dataset 
rename s5bq16_1 percent_lost
replace percent_lost = s5bq16_2 if percent_lost==. & s5bq16_2!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
merge m:1 hhid crop_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_losses.dta", replace

********************************************************************************
** 								CROP EXPENSES								  **
******************************************************************************** 
	*********************************
	* 			LABOR				*
	*********************************
	//Purpose: This section will develop indicators around inputs related to crops, such as labor (hired and family), pesticides/herbicides, animal power (not measured for Uganda), machinery/tools, fertilizer, land rent, and seeds. 
	
*********************************
* 		 HIRED LABOR			*
*********************************
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
*rename HHID Hhid
*rename hh HHID
ren pltid plot_id
ren parcelID parcel_id
ren s3aq35a dayshiredmale
*replace dayshiredmale = s3aq35a if dayshiredmale == . //only one season exists
replace dayshiredmale = . if dayshiredmale == 0

ren s3aq35b dayshiredfemale
replace dayshiredfemale = s3bq35b if dayshiredfemale == .
replace dayshiredfemale = . if dayshiredfemale == 0
ren s3aq35c dayshiredchild
*replace dayshiredchild = a3bq35c if dayshiredchild == . //only one season exists
replace dayshiredchild = . if dayshiredchild == 0	

ren s3aq36 wagehired
*replace wagehired = a3bq36 if wagehired == .
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
duplicates drop hhid parcel_id plot_id season, force
reshape long dayshired wagehired, i(hhid parcel_id plot_id season) j(gender) string
reshape long days wage, i(hhid parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0
gen val = wage*days
tostring hhid, format(%18.0f) replace
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district county subcounty parish /*ea*/ hhid {
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

*********************************
* 		 FAMILY LABOR			*
*********************************
*This section combines both seasons and renames variables to be more useful
*Can't be constructed
 
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
*rename HHID Hhid
*rename hh HHID
ren pltid plot_id
ren parcelID parcel_id
egen days= rowmean(s3aq35a s3aq35b s3aq35c)
*rename indiv_*_*

gen gender = "child" if s3aq35a!=. 
replace gender = "male" if strmatch(gender, "") & s3aq35c !=.
replace gender = "female" if strmatch(gender, "") & s3aq35b != 1 
replace gender = "unknown" if strmatch(gender, "") & gender == ""
gen labor_type = "hired"
drop if gender == "unknown"
keep hhid parcel_id labor_type gender plot_id season days t0_hhid

merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county subcounty /* ea*/ parish  hhid parcel_id days plot_id season gender  labor_type 

foreach i in region district county subcounty /* ea*/ parish  hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) 

	gen wage = wage_hhid
	*recode wage (.=0)
	
	
foreach i in country region district county subcounty /*ea*/ parish  {
	replace wage = wage_`i' if obs_`i' > 9
	} //Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in gaps of implicit labor value.

*replace wage = wage_hhid if wage_hhid != . & abs(wage_hhid - mean_wage) / wage_sd < 3 //Using household wage when available, but omitting implausibly high or low values. Changed about 6,700 hh obs, max goes from 500,000->500,000; mean 45,000 -> 41,000; min 10,000 -> 2,000

by hhid parcel_id plot_id season, sort: egen numworkers = count(_n)
*replace days = days/numworkers // If we divided by famworkers we would not be capturing the total amount of days worked. 
gen val = wage * days
append using `all_hired'
keep region district county  subcounty /* ea*/ parish  hhid parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(hhid parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (hhid parcel_id plot_id labor_type)
reshape wide labor_, i(hhid parcel_id plot_id) j(labor_type) string
		*la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_labor_days.dta", replace
restore 

preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(hhid parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_labor.dta", replace
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_labor.dta", replace

******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.

**********************    PESTICIDES/HERBICIDES   ******************************
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
*rename HHID Hhid
ren pltid plot_id
ren parcelID parcel_id
ren s3aq24a unitpest //unit code for total pesticides used, first planting season (kg = 1, litres = 2)
ren s3aq24b qtypest //quantity of unit for total pesticides used, first planting season
replace unitpest = s3bq24a if unitpest == . //add second planting season
replace qtypest = s3bq24b if qtypest == . //add second planting season
ren s3aq26 qtypestexp //amount of total pesticide that is purchased
replace qtypestexp = s3bq26 if qtypestexp ==. //add second planting season
gen qtypestimp = qtypest - qtypestexp //this calculates the non-purchased amount of pesticides used	
ren s3aq27 valpestexp
replace valpestexp = s3bq27 if valpestexp == .	
gen valpestimp= .
rename unitpest unitpestexp
gen unitpestimp = unitpestexp
drop qtypest

gen qtyanmlexp = .
gen qtyanmlimp = .
gen unitanmlexp = .
gen unitanmlimp = .
gen valanmlexp = .
gen valanmlimp = .
tostring hhid, format(%18.0f) replace
tempfile pestherb
save `pestherb', replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", clear

*************************    MACHINERY INPUTS   ********************************
//JHG 6_14_22: Information was collected on machinery inputs for crop expenses in section 10, but was only done at the household level. Other inputs are at the plot level. Ask Didier about machinery that is owned.
preserve //This section creates raw data on value of machinery/tools
use "${Uganda_NPS_W7_raw_data}/AGSEC10.dta", clear
ren A10itemcod_ID Farm_Implement
drop if  Farm_Implement == 2 //2 = no farm implement owned, rented, or used (separated by implement)
ren s10q01a qtymechimp //number of owned machinery/tools
ren s10q02a valmechimp //total value of owned machinery/tools, not per-item
ren s10q03aa qtymechexp //number of rented machinery/tools
ren s10q08a valmechexp //total value of rented machinery/tools, not per-item
*collapse (sum) valmechimp valmechexp, by(hhid) //combine values for all tools, don't combine quantities since there are many varying types of tools 
collapse (sum) qtymechimp qtymechexp valmechimp valmechexp, by(hhid)
isid hhid //check for duplicate hhids, which there shouldn't be after the collapse
tempfile rawmechexpense
save `rawmechexpense', replace
restore

/*
preserve
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_area_planted_temp.dta", replace
collapse (sum) ha_planted, by(hhid)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore
	
preserve
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_area_planted_temp.dta", replace
merge m:1 hhid using `ha_planted_total', nogen
gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted / SAW ha_planted_total its total area planted for both seasons per hhid 
collapse planted_percent, by(hhid parcel_id plot_id season)
tempfile planted_percent
save `planted_percent'
restore
*/

 
collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
bys hhid : egen ha_planted_total = sum(ha_planted)
gen planted_percent = ha_planted/ha_planted_total
merge m:1 hhid parcel_id plot_id season using `pestherb', nogen keep (1 3)
merge m:1 hhid using `rawmechexpense', nogen keep (1 3) //The 2's represent households that reported machinery but didn't cultivate crops? To investigate.
replace valmechexp = valmechexp * planted_percent //replace total with plot and season specific value of rented machinery/tools

//Now to reshape long and get all the medians at once.
keep hhid parcel_id plot_id season qty* /*unit**/ val* 
unab vars : *exp //create a local macro called vars out of every variable that ends with exp
local stubs : subinstr local vars "exp" "", all //create another local called stubs with exp at the end, with "exp" removed. This is for the reshape below
duplicates drop hhid parcel_id plot_id season, force // we need to  drop 3 duplicates so reshape can run
*rename qtypest qtypesticide
reshape long `stubs', i(hhid parcel_id plot_id season) j(exp) string // 178 obs with no parcel or plot id 
drop if parcel_id==. | plot_id==.
reshape long val qty unit, i(hhid parcel_id plot_id season exp) j(input) string //534  (3 times earlier missing) obs with no parcel or plot id 
gen itemcode=1
tempfile plot_inputs
tostring hhid, format(%18.0f) replace
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3)
save `plot_inputs'


******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
*rename HHID Hhid
*rename hh HHID
ren pltid plot_id
ren parcelID parcel_id

************************    INORGANIC FERTILIZER   ****************************** 
//(all variables have "1" suffix) 7.1.22 SAW Not sure why the 1 suffix? might create trouble in the reshape code (if theres any)
ren s3aq14 itemcodefert //what type of inorganic fertilizer (1 = nitrate, 2 = phosphate, 3 = potash, 4 = mixed); this can be used for purchased and non-purchased amounts
replace itemcodefert = s3bq14 if itemcodefert == . //add second season
ren s3aq15 qtyferttotal1 //quantity of inorganic fertilizer used; thankfully, only measured in kgs
replace qtyferttotal1 = s3bq15 if qtyferttotal1 == . //add second season
ren s3aq17 qtyfertexp1 //quantity of purchased inorganic fertilizer used; only measured in kgs
replace qtyfertexp1 = s3bq17 if qtyfertexp1 == . //add second season
ren s3aq18 valfertexp1 //value of purchased inorganic fertilizer used, not all fertilizer
replace valfertexp1 = s3bq18 if valfertexp1 == . //add second season
gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1

*************************    ORGANIC FERTILIZER   *******************************
ren s3aq05 qtyferttotal2 //quantity of organic fertilizer used; only measured in kg
replace qtyferttotal2 = s3bq05 if qtyferttotal2 == . //add second season
ren s3aq07 qtyfertexp2 //quantity of purchased organic fertilizer used; only measured in kg
replace qtyfertexp2 = s3bq07 if qtyfertexp2 == . //add second season
replace itemcodefert = 5 if qtyferttotal2 != . //Current codes are 1-4; we'll add 5 as a temporary label for organic
label define fertcode 1 "Nitrate" 2 "Phosphate" 3 "Potash" 4 "Mixed" 5 "Organic" , modify //need to add new codes to the value label, fertcode
label values itemcodefert fertcode //apply organic label to itemcodefert
ren s3aq08 valfertexp2 //value of purchased organic fertilizer, not all fertilizer
replace valfertexp2 = s3bq08 if valfertexp2 == . //add second season 
gen qtyfertimp2 = qtyferttotal2 - qtyfertexp2
tostring hhid, format(%18.0f) replace
//JHG 6_15_22: no transportation costs are given; no subsidized fertilizer

//Clean-up data
keep item* qty* val* hhid parcel_id plot_id season
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

//Get parcel rent data
use "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta", clear
ren parcelID parcel_id
*rename HHID Hhid
*rename hh HHID
ren a2bq09 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace
merge m:1 hhid parcel_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_rental.dta", nogen keep (3)
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
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear
gen season=1 
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta"
replace season=2 if season==.
*rename hhid hhid2
*rename hh hhid
rename pltid plot_id
rename parcelID parcel_id
ren cropID crop_code
ren s4aq08 purestand 
replace purestand = s4bq08 if purestand==.
ren s4aq11a qtyseeds //includes all types of seeds (purchased, left-over, free, etc.)
replace qtyseeds = s4bq11a if qtyseeds == . //add second season
ren s4aq11b unitseeds //includes all types of seeds (purchased, left-over, free, etc.)
replace unitseeds = s4bq11b if unitseeds == . //add second season
ren s4aq15	valseeds //only value for purchased seeds. There is no quantity for purchased seeds, so one cannot calculate per kg value of seeds.
replace valseeds = s4bq15 if valseeds == . //add second season

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
* What should we do with Tin (20 and 5 lts) and plastic bins (15lts), assume 1lt = 1kg? 
//replace qty = qty * 20 if unit_code == 20 //Tin (20lts):   
//replace qty = qty * 5 if unit_code == 21 //Tin (5kgs):  
//replace qty = qty * 15 if unit_code == 22 //Plastic Bin (15 lts):   

*gen unit = 1 if inlist(unit_cd,160,161,162,80,81,82) //pieces
*replace unit = 2 if unit == . //Weight, meaningless for transportation
*replace unit = 0 if conversion == . //useless for price calculations
gen unit = 1 if unit_code == 1
replace unit = 2 if unit == .
replace unit = 0 if inlist(unit_code, 20, 21, 22, 66, 85, 99) //the units above that could not be converted will not be useful for price calculations

ren crop_code itemcode
collapse (sum) val qty, by(hhid parcel_id plot_id season input itemcode unit) 
gen exp = "exp"
tempfile seeds
save `seeds'

//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'

merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
drop region district county county_name parish parish_name weight rural /*ea*/
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
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

*drop rural plotweight parish  district
foreach i in region /*sregion*/ subcounty district county parish hhid /*ea*/{
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
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
*drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district county parish /*ea*/ hhid {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_hhid (. = 0)
	gen price = price_hhid
foreach i in country region district county parish /*ea*/ {
	replace price = price_`i' if obs_`i' > 9 & obs_`i' != .
}

replace price = price_hhid if price_hhid > 0
replace qty = 0 if qty < 0
recode val qty (. = 0)
drop if val == 0 & qty == 0 
replace val = qty*price if val == 0 
replace input = "orgfert" if itemcode == 5
replace input = "inorg" if strmatch(input,"fert")

//Need this for quantities and not sure where it should go.
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_input_quantities.dta", replace 
restore

*Note: no family labour in the data
*append using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_labor.dta" 
collapse (sum) val, by (hhid parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_cost_inputs_long.dta", replace 

preserve
collapse (sum) val, by(hhid exp input) //JHG 7_5_22: includes both seasons, is that okay?
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs_long.dta", replace 
restore

preserve
collapse (sum) val_ = val, by(hhid parcel_id plot_id season exp dm_gender)
reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(exp) string
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_cost_inputs.dta", replace //This gets used below.
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs_verbose.dta", replace 

//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace 

collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_cost_inputs_long.dta", clear

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
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
merge m:1 hhid parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid) 

foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs.dta", replace

********************************************************************************
*MONOCROPPED PLOTS
********************************************************************************
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped
ren crop_code cropcode
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_monocrop_plots.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace
keep if purestand == 1 

merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
ren crop_code cropcode
ren ha_planted monocrop_ha
ren quant_harv_kg kgs_harv_mono
ren value_harvest val_harv_mono

*This loop creates 17 values using the nb_topcrops global (as that is the number of priority crops), then generates two .dtas for each priority crop that contains household level variables (split by season). You can change which priority crops it uses by adjusting the priority crops global section near the top of this code.

forvalues k = 1(1)$nb_topcrops  {		
preserve	
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
local cn_full : word `k' of $topcropname_area_full
keep if cropcode == `c'			
ren monocrop_ha `cn'_monocrop_ha
drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==. 			
ren kgs_harv_mono kgs_harv_mono_`cn'
ren val_harv_mono val_harv_mono_`cn'
gen `cn'_monocrop = 1
la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", replace
	
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop_hh_area.dta", replace
restore
}

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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", replace
	
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop_hh_area.dta", replace
restore
}
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_cost_inputs_long.dta", clear	
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
	merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_inputs_`cn'.dta", replace
restore
}
	


********************************************************************************
*LIVESTOCK  + TLUs   
********************************************************************************

// Step 1: Create three TLU coefficient .dta files for later use, stripped of HHIDs

*For livestock
use "${Uganda_NPS_W7_raw_data}/AGSEC6A.dta", clear
ren LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 | livestockid == 12 //Includes indigenous donkeys & mules and horses 
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W7_raw_data}/AGSEC6B.dta", clear
ren ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W7_raw_data}/AGSEC6C.dta", clear
ren APCode livestockid
gen tlu_coefficient = 0.01  // This includes chicken (all kinds), turkey, ducks, geese, and rabbits)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/tlu_poultry_misc.dta", replace

*Combine 3 TLU .dtas into a single .dta
use "${Uganda_NPS_W7_created_data}/tlu_livestock.dta", clear
append using "${Uganda_NPS_W7_created_data}/tlu_small_animals.dta"
append using "${Uganda_NPS_W7_created_data}/tlu_poultry_misc.dta"
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - Cows" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid 
save "${Uganda_NPS_W7_created_data}/tlu_all_animals.dta", replace


// Step 2: Generate ownership variables per household

*Combine hhid and livestock data into a single sheet
use "${Uganda_NPS_W7_raw_data}/AGSEC6A.dta", clear
append using "${Uganda_NPS_W7_raw_data}/AGSEC6B.dta"
append using "${Uganda_NPS_W7_raw_data}/AGSEC6C.dta"
gen livestockid = LiveStockID
replace livestockid = ALiveStock_Small_ID if livestockid == .
replace livestockid = APCode if livestockid == .
drop LiveStockID ALiveStock_Small_ID APCode
merge m:m livestockid using "${Uganda_NPS_W7_created_data}/tlu_all_animals.dta", nogen
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
ren s6aq03b ls_ownership_now
drop if ls_ownership == 2 //2 = do not own this animal anytime within the past 12 months (eliminates non-owners for all relevant time periods)
ren s6bq03b sa_ownership_now
drop if sa_ownership == 2 //2 = see above
ren s6cq03c po_ownership_now
drop if po_ownership == 2 //2 = see above

  
ren s6aq03a ls_number_now
ren s6bq03a sa_number_now
ren s6cq03a po_number_now 
gen livestock_number_now = ls_number_now
replace livestock_number_now = sa_number_now if livestock_number_now == .
replace livestock_number_now = po_number_now if livestock_number_now == .
lab var livestock_number_now "Number of animals owned at time of survey (see livestockid for type)"

gen nb_cattle_today = livestock_number_now if cattle == 1
gen nb_cows_today = livestock_number_now if cows == 1
gen nb_smallrum_today = livestock_number_now if smallrum == 1
gen nb_poultry_today = livestock_number_now if poultry == 1
gen nb_chickens_today = livestock_number_now if chickens == 1
gen nb_other_today = livestock_number_now if otherlivestock == 1
gen nb_tlu_today = livestock_number_now * tlu_coefficient
  
*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
ren s6aq06 ls_number_past
ren s6bq06 sa_number_past
ren s6cq06 po_number_past
gen livestock_number_past = ls_number_past
replace livestock_number_past = sa_number_past if livestock_number_past == .
replace livestock_number_past = po_number_past if livestock_number_past == .
lab var livestock_number_past "Number of animals owned 12 months before survey (see livestockid for type)"

gen num_cattle_past = livestock_number_past if cattle == 1
gen num_cows_past = livestock_number_past if cows == 1
gen num_smallrum_past = livestock_number_past if smallrum == 1
gen num_poultry_past = livestock_number_past if poultry == 1
gen num_chickens_past = livestock_number_past if chickens == 1
gen num_other_past = livestock_number_past if otherlivestock == 1
gen num_tlu_past = livestock_number_past * tlu_coefficient

     
//Step 3: Generate animal sales variables (sold alive)
ren s6aq14b ls_avgvalue
ren s6bq14b sa_avgvalue
ren s6cq14b po_avgvalue
ren s6aq14a num_ls_sold
ren s6bq14a num_sa_sold
ren s6cq14a num_po_sold

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
collapse (sum) num* nb*, by (hhid)
lab var num_ls_sold "Number of animals sold alive (livestock)"
lab var num_sa_sold "Number of animals sold alive (small animals)"
lab var num_po_sold "Number of animals sold alive (poultry)"
lab var num_totalvalue "Total value of animals sold alive"
lab var nb_cattle_today "Number of cattle owned at time of survey"
lab var nb_cows_today "Number of cows owned at time of survey"
lab var nb_smallrum_today "Number of small ruminants owned at time of survey"
lab var nb_poultry_today "Number of poultry owned at time of survey"
lab var nb_chickens_today "Number of chickens owned at time of survey"
lab var nb_other_today "Number of other livestock (donkeys/mules & horses) owned at time of survey"
lab var nb_tlu_today "Number of Tropical Livestock Units at time of survey"
lab var num_cattle_past "Number of cattle owned 12 months before survey"
lab var num_cows_past "Number of cows owned 12 months before survey"
lab var num_smallrum_past "Number of small ruminants owned 12 months before survey"
lab var num_poultry_past "Number of poultry owned 12 months before survey"
lab var num_chickens_past "Number of chickens owned 12 months before survey"
lab var num_other_past "Number of other livestock (donkeys/mules & horses) owned 12 months before survey"
lab var num_tlu_past "Number of Tropical Livestock Units 12 months before survey"
 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU_Coefficients.dta", replace

* Note: crop loss and replanting not reported in the UG dta.


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
use "${Uganda_NPS_W7_raw_data}/AGSEC6A.dta", clear
rename LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W7_raw_data}/AGSEC6B.dta", clear
rename ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W7_raw_data}/AGSEC6C.dta", clear
rename APCode livestockid
gen tlu_coefficient = 0.01 if (livestockid == 23 | livestockid == 24 | livestockid == 25 | livestockid == 26 | livestockid == 27) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_poultry_misc.dta", replace
*NOTES: There's an additional categoty of beehives (==28) that we are not currently adding to any tlu_coefficient. Did not find it in another survey.

*Combine 3 TLU .dtas into a single .dta
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_livestock.dta", clear
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_small_animals.dta"
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_poultry_misc.dta"
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - Cows" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid //JHG 12_30_21: have to reassign labels to values after append (possibly unnecessary since this is an intermediate step, don't delete code though because it is necessary)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_tlu_all_animals.dta", replace



********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
* Note: Livestock inputs raw data missing in W7 

********************************************************************************
*LIVESTOCK Products
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC8B.dta", clear
*rename hhid hhid2
rename t0_hhid HHID
rename AGroup_ID livestock_code
gen livestock_code2="1. Milk"
keep if livestock_code==101 | livestock_code==105 //Exotic+Indigenous large ruminants. Leaving out small ruminants because small ruminant milk accounts only for 0.04% of total production, and there's no price information
ren s8bq01 animals_milked
gen months_milked = s8bq02 // Need review: In contrast to wave 3 that asked how many days in the year livestock were milked , wave 4 asked how many months in the year livestock were milked.
rename s8bq03 liters_perday
recode animals_milked months_milked liters_perday (.=0)
gen milk_liters_produced = animals_milked*liters_perday*months_milked*30.5
lab var milk_liters_produced "Liters of milk produced in past 12 months"
gen liters_sold_per_day = s8bq05a
gen liters_sold_per_year = s8bq05a*30.5*s8bq02 //SW: The question asks how many liters did you sell per day (liters/days). Earning sales are reported 
ren s8bq06 liters_peryear_to_cheese 
ren s8bq09 earnings_per_year_milk

recode liters_sold_per_year liters_peryear_to_cheese (.=0)
gen liters_sold_year = liters_sold_per_year + liters_peryear_to_cheese 
gen price_per_liter = earnings_per_year_milk/ liters_sold_year 
gen price_per_unit = price_per_liter
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
gen earnings_sales = earnings_per_year_milk	//  It seems like earnings from milk and dairy are already defined for the past 12 months, no need to convert them to yearly estimates.
keep hhid livestock_code livestock_code2 milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_sales
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_sales "Total earnings of sale of milk produced"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_milk.dta", replace 

*2. Eggs
use "${Uganda_NPS_W7_raw_data}/AGSEC8C.dta", clear
*rename hhid hhid2
rename t0_hhid HHID
ren AGroup_ID livestock_code 
rename s8cq01 months_produced
rename s8cq02 quantity_month
recode months_produced quantity_month (.=0)
gen quantity_produced = 4 * quantity_month // Units are pieces for eggs & skin, liters for honey. SW: Uganda wave 3 is quantity_month*4 why?
lab var quantity_produced "Quantity of this product produed in past year"
rename s8cq03 sales_quantity
rename s8cq05 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
*replace livestock_code = 21 if livestock_code==1
*replace livestock_code = 22 if livestock_code==2
*replace livestock_code = 23 if livestock_code==3
*label define livestock_code_label 21 "Eggs" 
*label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of egg per unit sold"
lab var price_per_unit_hh "Price of egg per unit sold at household level"
gen livestock_code2 = "2. Eggs"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_other.dta", replace 

*We append the 3 subsection of livestock earnings
append using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_milk.dta"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products.dta", replace 
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products.dta", replace 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", keep(1 3) nogen

collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code) //Nigeria also uses by quantity_sol_season_unit but UGanda does not have that information, though units should be the same within livestock_code2 (product type). Also, we could include by livestock_code (type of animal)
ren price_per_unit price_unit_median_country
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_country.dta", replace 
*Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products.dta", replace 
merge m:1 livestock_code2 livestock_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products_prices_country.dta", nogen keep(1 3) //SAW We have an issue with price units for some types of meat products and specific animal tpye. I assign those price_unit values for the missing based on similar types of animals with information.
keep if quantity_produced!=0
gen value_produced = price_per_unit * quantity_produced 
replace value_produced = price_unit_median_country * quantity_produced if value_produced==.
replace value_produced = value_produced*4 if livestock_code2=="2. Eggs" // SAW Like we said earlier, eggs sales is for the past 3 months we need to extrapolate for the whole year.
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products.dta", replace 

*****************************    LIVESTOCK SOLD (LIVE)       *******************************
use "${Uganda_NPS_W7_raw_data}/AGSEC6A.dta", clear
append using  "${Uganda_NPS_W7_raw_data}/AGSEC6B.dta"
append using  "${Uganda_NPS_W7_raw_data}/AGSEC6C.dta"
//Making sure value labels for 6B and 6C get carried over. Just in case.
rename t0_hhid hhid2
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
ren s6aq06 animal_owned // Have you owned in the past 12 months?
replace animal_owned=s6bq06 if animal_owned==. // Have you owned in the past 6 months?
replace animal_owned=s6cq06 if animal_owned==. // Have you owned in the past 3 months?
keep if animal_owned==1
ren s6aq14a number_sold // a6aq14a a6bq14a a6cq14a
replace number_sold = 2*s6bq14a if number_sold==. & s6bq14a!=. // SW Should it just be multiplied by 1? The selling number is for the past 12 months just like a6aq14a
replace number_sold = 4*s6cq14a if number_sold==. & s6cq14a!=.
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
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3) //106 missing from master
keep hhid region rural weight district county subcounty county_name parish parish_name /*ea*/ price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales.dta", replace

* This section is coming from the NGA w3 coding which uses a loop instead of longer code.
*Implicit prices (shorter)
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_livestock_sales.dta", clear
gen obs = 1
foreach i in region district county subcounty /* ea*/ parish  {
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

foreach i in region district county subcounty /* ea*/ parish  country {
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_sales.dta", replace


//ALT Merge resolution: redundancy here?
********************************************************************************
**                                 TLU    		         	         	      **
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC6A.dta", clear
append using  "${Uganda_NPS_W7_raw_data}/AGSEC6B.dta"
append using  "${Uganda_NPS_W7_raw_data}/AGSEC6C.dta"
//Making sure value labels for 6B and 6C get carried over. Just in case.
*rename HHID hhid2
rename t0_hhid HHID
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
ren s6aq03b animal_owned 
replace animal_owned=s6bq03b if animal_owned==.
replace animal_owned=s6cq03b if animal_owned==.
gen tlu_coefficient =  0.5 if inrange(livestock_code, 1, 10) //Bulls and oxen, calves, heifer and cows
replace tlu_coefficient = 0.55 if livestock_code==12 //mules/horses; average of the two (horses = 0.5 and mules = 0.6)
replace tlu_coefficient = 0.3 if livestock_code==11 //donkeys
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
replace number_today = s6bq03a if number_today==. //No estimated price value by farmers questions or owned  at the start of the ag season like Nigeria_GHS_W3_raw_data
gen number_today_exotic = number_today if inlist(livestock_code,1,2,3,4,5,13,14,15,16,17)
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
gen income_live_sales = s6aq14b // Value of each animal sold on average
replace income_live_sales = s6bq14b*1 if income_live_sales==. & s6bq14b!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace income_live_sales = s6cq14b*1 if income_live_sales==. & s6cq14b!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months
gen number_sold = s6aq14a
replace number_sold = s6bq14a*1 if number_sold==. & s6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace number_sold = s6cq14a*4 if number_sold==. & s6bq14a!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months
*SW Notes: Again, for s6bq14a it asks in the last 12 months, it should not be multiplied by 2.

gen lost_theft = s6aq10
replace lost_theft = s6bq10*2 if lost_theft==. & s6bq10!=.
replace lost_theft = s6cq10*4 if lost_theft==. & s6cq10!=.
gen lost_other = s6aq11 // animals lost to injury/accident/naturalcalamity 
replace lost_other = s6bq11*2 if lost_other==. & s6bq11!=.
replace lost_other = s6cq11*4 if lost_other==. & s6cq11!=.
gen lost_disease = s6aq12 //includes animals lost to disease
replace lost_disease = s6bq12*2 if lost_disease==. & s6bq12!=. 
replace lost_disease = s6cq12*4 if lost_disease==. & s6cq12!=.
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
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep(1 3) //106 missing from master
foreach i in region district county subcounty /*ea*/ parish  {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

gen value_today = number_today * price_per_animal
gen value_1yearago = number_1yearago * price_per_animal
collapse (sum) number_today number_1yearago lost_theft lost_other lost_disease animals_lost lvstck_holding=number_today value* tlu*, by(hhid species)
egen mean_12months=rowmean(number_today number_1yearago)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_herd_characteristics_long.dta", replace //AgQuery

preserve
keep hhid species number_today number_1yearago /*animals_lost*/ lost_disease lost_other lost_theft  lvstck_holding mean_12months
global lvstck_vars number_today number_1yearago lost_other lost_theft lost_disease lvstck_holding mean_12months
foreach i in $lvstck_vars {
	ren `i' `i'_
}
reshape wide $lvstck_vars, i(hhid) j(species) string
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_herd_characteristics.dta", replace 
restore

collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of one year ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU.dta", replace 



********************************************************************************
**                                 FISH INCOME    		         	          **
********************************************************************************
* No Fish Income data collected in Uganda w4. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
//Purpose: This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. 
*Generate profit from business activities (revenue net of operating costs)
use "${Uganda_NPS_W7_raw_data}/gsec12_2.dta", clear
rename hhid HHID
ren h12q09 months_activ // how many months did the business operate
ren h12q10 monthly_revenue //  avg monthly gross revenues when active
ren h12q12 wage_expense // avg expenditure on wages 
ren h12q13 materials_expense // avg expenditures on raw materials
ren h12q14 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (. = 0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit != . // W3 has some hhs with negative profit (56)
gen annual_selfemp_profit = monthly_profit * months_activ
collapse (sum) annual_selfemp_profit, by (HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_self_employment_income.dta", replace 

*Processed crops
//Not captured in w5 instrument (or other UGA waves)

*Fish trading
//It is captured in the GSEC12 section (already included)

********************************************************************************
*							 WAGE INCOME (AG & NON-AG)			 		  			*
********************************************************************************
 
use "${Uganda_NPS_W7_raw_data}/GSEC8.dta", clear
gen wage_yesno = s8q04==1 // did any wage work in the last 12 months y/n
ren s8q30 number_months // months worked for main job
ren s8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12
egen hours_pastweek = rowtotal(s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if s8q36a!=. | s8q36b!=. | s8q36c!=. | s8q36d!=. | s8q36e!=. | s8q36f!=. | s8q36g!=.
gen number_hours = hours_pastweek*number_weeks

gen most_recent_payment = s8q31a // cash and in-kind payments
*gen most_recent_payment_other = s8q31b
ren s8q31c payment_period 
ren s8q37 secwage_yesno // did they have a secondary wage?
*ren s8q45a secwage_most_recent_payment // only one variable avaliable...so we just have most recent payment
ren s8q45b secwage_most_recent_payment
ren s8q45c secwage_payment_period
egen secwage_hours_pastweek = rowtotal(s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g) if s8q43a!=. | s8q43b!=. | s8q43c!=. | s8q43d!=. | s8q43e!=. | s8q43f!=. | s8q43g!=.

gen annual_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace annual_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace annual_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

gen second_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace second_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace second_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace second_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

gen annual_salary_in_kind = (number_months*secwage_most_recent_payment) if secwage_payment_period==4
replace annual_salary_in_kind = (number_weeks*secwage_most_recent_payment) if secwage_payment_period==3
replace annual_salary_in_kind = ((number_hours/8)*secwage_most_recent_payment) if secwage_payment_period==2 // assuming 8 hour workdays 
replace annual_salary_in_kind = (number_hours*secwage_most_recent_payment) if secwage_payment_period==1

gen second_salary_in_kind = (number_months*secwage_most_recent_payment) if secwage_payment_period==4
replace second_salary_in_kind = (number_weeks*secwage_most_recent_payment) if secwage_payment_period==3
replace second_salary_in_kind = ((number_hours/8)*secwage_most_recent_payment) if secwage_payment_period==2 // assuming 8 hour workdays 
replace second_salary_in_kind = (number_hours*secwage_most_recent_payment) if secwage_payment_period==1

recode annual_salary_cash second_salary_cash annual_salary_in_kind second_salary_in_kind (.=0)
gen main_job_ag= 1 if (h8q19b_fourDigit>=6111 & h8q19b_fourDigit<=6340) | (h8q19b_fourDigit>=9211 & h8q19b_fourDigit<=9216)
replace main_job_ag=0 if main_job_ag==.
destring h8q38b_fourDigit, replace
gen sec_job_ag = 1 if (h8q38b_fourDigit>=6111 & h8q38b_fourDigit<=6340) | (h8q38b_fourDigit>=9211 & h8q38b_fourDigit<=9216)
replace sec_job_ag=0 if sec_job_ag==.
*SW Non-Ag Wages
preserve
recode annual_salary_cash  annual_salary_in_kind (nonmissing=0) if main_job_ag==1
recode second_salary_cash  second_salary_in_kind (nonmissing=0) if sec_job_ag==1
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage (both Main and Secondary Job)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wage_income.dta", replace
restore
*SW Ag Wages
recode annual_salary_cash  annual_salary_in_kind (nonmissing=0) if main_job_ag==0
recode second_salary_cash  second_salary_in_kind (nonmissing=0) if sec_job_ag==0
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from agricultural wage (both Main and Secondary Job)"
rename annual_salary annual_salary_agwage
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_agwage_income.dta", replace

********************************************************************************
**                             OFF-FARM HOURS      	    	                  **
********************************************************************************
//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs).
use "${Uganda_NPS_W7_raw_data}/GSEC8.dta", clear
*Use ISIC codes for non-farm activities (For wave 3 we have a 1 digit ISCO variable ~ [0,9] that we can use, same as wave 7)
egen primary_hours = rowtotal (s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if (s8q04==1 | s8q06==1 | s8q08==1 | s8q10==1) & s8q22!=6 // includes work for someone else, work without payment for the house, apprentice etc. for all work MAIN JOB excluding "Working on the household farm or with household livestock.." Last 7 days total hours worked per person
gen secondary_hours =  . // don't have this infromation h8q43 if  h8q41!=6 &  h8q41!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours, for the past 7 days"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_off_farm_hours.dta", replace 
*Notes:  We have information about the total weeks and months worked for Main job and Secondary Job, should we aim to construct a off-farm hours worked for the year and not only for the past 7 days? Similar to what we did for Agricultural hours worked section.


********************************************************************************
**                               OTHER INCOME 	        	    	          **
********************************************************************************
*This section does not exist in Wave 7

********************************************************************************
**                           LAND RENTAL INCOME        	    	              **
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
rename s2aq14 land_rental_income
recode land_rental_income (.=0)
collapse(sum) land_rental_income, by(hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rental_income.dta", replace
* 9.19.22 SAW Updated this small section since it was not running wrong names of vars... etc Double check if we are not coding this section better. (Very few observations have land rental income)

********************************************************************************
*								FARM SIZE / LAND SIZE				  		   *
********************************************************************************

*Parcel areas not being created earlier so creating it now for merge later: 
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta", gen (last)		
replace season = 2 if last==1
label var season "Season = 1 if 2nd cropping season of 2012, 2 if 1st cropping season of 2013" // need to check again

ren parcelID parcel_id
ren pltid plot_id
drop if parcel_id==.| plot_id==.
ren cropID crop_code_master
drop if crop_code_master == .
gen cropcode = crop_code_master 
ren hhid HHID
recode cropcode (811 812 = 810) (741 742 744 = 740) (221 = 222) (224 = 223)
gen plot_area = s4aq07  //values are in acres
replace plot_area = s4bq07 if plot_area==. //values are in acres
replace plot_area = plot_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
collapse (sum) plot_area, by (HHID parcel_id plot_id season)
bys HHID parcel_id season : egen total_plot_area = sum(plot_area)
gen plot_area_pct = plot_area/total_plot_area
keep HHID parcel_id plot_id season plot_area total_plot_area plot_area_pct
ren HHID hhid 
tempfile plarea
save `plarea'

use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
gen season = 1
append using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta", gen (last)		
replace season = 2 if last==1
ren s2* s2*_w7
ren a2* a2*_w7
ren t0_hhid HHID
drop if !strpos(HHID, "H")
duplicates drop HHID parcelID, force //Should double check the three obs dropped here to see what's going on
merge 1:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2A.dta", nogen keep (1 3)
merge 1:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2B.dta", nogen keep (1 3) 
*generating field_size
gen parcel_area = s2aq4_w7
replace parcel_area = s2aq5_w7 if parcel_area == .
replace parcel_area = a2aq4 if parcel_area==.
replace parcel_area = a2aq5 if parcel_area==.
replace parcel_area = a2bq4 if parcel_area==.
replace parcel_area = a2bq5 if parcel_area==. 
ren parcelID parcel_id
merge 1:m hhid parcel_id season using `plarea', nogen 
drop if plot_id==.

gen field_size = plot_area_pct*parcel_area //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size/2.471 //convert acres to hectares

*cleaning up and saving the data
*keep HHID parcel_id plot_id season field_size
drop if field_size == . // 6276 obs dropped 
label var field_size "Area of plot (ha)"
label var HHID "Household identifier"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace
*ren hhid hhid2
*ren HHID hhid
* create hh total parcel size 
ren field_size area_acres_meas
collapse (sum) area_acres_meas, by (hhid parcel_id)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcel_areas.dta", replace

*Determining whether crops were grown on a plot
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta"
replace season =2 if season == . 
*ren hhid HHID
ren parcelID parcel_id
ren pltid plot_id
drop if parcel_id==. | plot_id==.
ren cropID crop_code
drop if crop_code==.
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid parcel_id)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crops_grown.dta", replace

**
use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta"
replace season =2 if season == . 
ren parcelID parcel_id
gen cultivated = (s2aq11a==1 | s2aq11a==2 | s2aq11b==1 | s2aq11b==2)
replace cultivated= (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if cultivated==.

collapse (max) cultivated, by (hhid parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_cultivated.dta", replace

merge 1:1 hhid parcel_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcel_areas.dta", nogen keep (1 3) // all matched  

keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size.dta", replace

*All agricultural land
use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
append using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta"
*ren HHID hhid
ren parcelID parcel_id
drop if parcel_id==.
merge 1:1 hhid parcel_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crops_grown.dta", nogen
*ren hhid hhid2
*ren t0_hhid hhid
gen rented_out = (s2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (s2aq11b==1 | s2aq11b==2 | a2bq12b==1 | a2bq12b==2) //own cultivated annual and perennial crops
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
gen agland = s2aq11a==1 | s2aq11a==2 | s2aq11a==5 | s2aq11a==6| a2bq12a==1 | a2bq12a==2 | a2bq12a==5 | a2bq12a==6 // includes cultivated, fallow, pasture
drop if agland!=1 & crop_grown==.
collapse (max) agland, by (hhid parcel_id)
lab var agland "1= Parcel was used for crop cultivation or pasture or left fallow in this past year (forestland and other uses excluded)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_agland.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_agland.dta", clear
merge 1:1 hhid parcel_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
*replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmsize_all_agland.dta", replace

use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
append using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta"
ren hhid HHID
ren t0_hhid hhid2
ren parcelID parcel_id
drop if parcel_id==.
gen rented_out = (s2aq11a==3 | a2bq12a==3) 
gen cultivated_short = (s2aq11b==1 | s2aq11b==2 | a2bq12b==1 | a2bq12b==2) 
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1
drop if rented_out==1
gen parcel_held = 1
ren HHID hhid
collapse (max) parcel_held, by (hhid parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_held.dta", replace

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcels_held.dta", clear
merge 1:1 hhid parcel_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all parcels listed by the household except those rented out" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Uganda_NPS_W7_raw_data}/AGSEC2A.dta", clear
append using "${Uganda_NPS_W7_raw_data}/AGSEC2B.dta"
*ren hhid HHID
*ren t0_hhid hhid
ren parcelID parcel_id
drop if parcel_id==.
drop if hhid=="."
merge m:1 hhid parcel_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_parcel_areas.dta", nogen keep(1 3) //hhid and parcel don't uniquely identify in master - is that a problem? Also only 700 matches 
replace area_acres_meas=. if area_acres_meas<0
*replace area_acres_meas = area_acres_est if area_acres_meas==. 
*replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (max) area_acres_meas, by(hhid parcel_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size_total.dta", replace

********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/GSEC8", clear
ren PID pid 
egen primary_hours = rowtotal (s8q36a s8q36b s8q36c s8q36d s8q36e s8q36f s8q36g) if (s8q04==1 | s8q06==1 | s8q08==1 | s8q10==1) & s8q22!=6
egen secondary_hours = rowtotal(s8q43a s8q43b s8q43c s8q43d s8q43e s8q43f s8q43g) if h8q38b_oneDigit!=5 & h8q38b_oneDigit!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_off_farm_hours.dta", replace


********************************************************************************
*FARM LABOR
********************************************************************************
*Family labor // family labor days data missing in this section 
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear 
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.
ren s3aq35a days_hired_men
ren s3aq35b days_hired_women
ren s3aq35c days_hired_children
recode days_hired_men days_hired_women days_hired_children (.=0)
gen days_hired_mainseason = days_hired_men + days_hired_women + days_hired_children
collapse (sum) days_hired_mainseason /*days_famlabor_mainseason*/, by (hhid plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
*lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_mainseason.dta", replace


use "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta", clear
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.
*ren s3aq35a days_hired_men
ren s3bq35b days_hired_women
*ren s3aq35c days_hired_children
recode /*days_hired_men days_hired_children */ days_hired_women (.=0)
gen days_hired_shortseason = /*days_hired_men + days_hired_children*/ days_hired_women
collapse (sum) days_hired_shortseason /*days_famlabor_shortseason*/, by (hhid plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
*lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_shortseason.dta", replace



*Hired Labor
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_mainseason.dta", clear
merge 1:1 hhid plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_farmlabor_shortseason.dta", nogen 

recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_shortseason)
*egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_shortseason)
*egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_shortseason days_famlabor_shortseason)
*lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
*lab var labor_family "Total labor days (family) allocated to the farm"
*lab var labor_total "Total labor days allocated to the farm"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
*lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
*lab var labor_family "Total labor days (family) allocated to the farm"
*lab var labor_total "Total labor days allocated to the farm" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_family_hired_labor.dta", replace




********************************************************************************
*VACCINE USAGE // Note: section raw data missing
********************************************************************************

********************************************************************************
*ANIMAL HEALTH - DISEASES  // Note: section raw data missing
********************************************************************************

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING  // Note: section raw data missing
********************************************************************************

********************************************************************************
*USE OF INORGANIC FERTILIZER
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id

gen use_inorg_fert=(s3aq13==1 | s3bq13==1) if (s3aq13!=. | s3bq13!=.)
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fert_use.dta", replace
  
  
*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.

gen all_use_inorg_fert=(s3aq13==1 | s3bq13==1) if (s3aq13!=. | s3bq13!=.)

*keep hhid s3aq03_3 s3bq03_3 all_use_inorg_fert 
ren s3aq03_3 farmerid
replace farmerid= s3bq03_3 if farmerid=="" 

* Note: no second/third decision maker reported in W7 


collapse (max) all_use_inorg_fert, by(hhid farmerid)
drop if farmerid=="" 
ren farmerid individ

merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta"
drop if _m==2
drop _m 
keep hhid individ all_use_inorg_fert
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"

gen farm_manager=1 if individ!=""
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_fert_use.dta", replace


********************************************************************************
*USE OF IMPROVED SEED
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
drop if plot_id==.
gen imprv_seed_use= (s4aq13==2) if s4aq13!=.
replace imprv_seed_use=s4bq13==2 if imprv_seed_use==. & s4bq13!=.
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
ren cropID cropcode

*Use of seed by crop
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	
	gen imprv_seed_`cn'=imprv_seed_use if cropcode==`c'
	gen hybrid_seed_`cn'=.
}
collapse (max) imprv_seed_* hybrid_seed_*, by(hhid)
lab var imprv_seed_use "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops 
*replace imprv_seed_cassav = . 
*replace imprv_seed_banana = . 

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_improvedseed_use.dta", replace
  
*Seed adoption by farmers ( a farmer is an individual listed as plot manager)
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear 
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta" 
replace season = 2 if season == .
ren parcelID parcel_id
ren pltid plot_id
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
ren cropID cropcode
drop if plot_id==.
gen imprv_seed_use= (s4aq13==2) if s4aq13!=.
replace imprv_seed_use=s4bq13==2 if imprv_seed_use==. & s4bq13!=.
ren imprv_seed_use all_imprv_seed_use
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp.dta", replace



*Use of seed by crop
forvalues k=1/$nb_topcrops {
	use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=all_imprv_seed_use if cropcode==`c'  
	gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= cropcode==`c' 
	ren s4aq06_1 individ
	replace individ= s4bq06_1 if individ==""
	
	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (hhid individ)
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp_`cn'.dta", replace
}

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 hhid individ all_imprv_seed_use using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use_temp_`v'.dta", nogen
}	 

drop if individ==""
merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

gen farm_manager=1 if individ!=""
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops
*replace all_imprv_seed_cassav = . 
*replace all_imprv_seed_banana = . 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use.dta", replace

********************************************************************************
**                             PLOT MANAGER        	                          **
********************************************************************************
*Construct this section using Nigeria Wave 3 as reference.
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${Uganda_NPS_W7_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC4B.dta"
replace season = 2 if season == .
rename t0_hhid HHID
recode cropID (811 812 = 810) (741 742 744 = 740) (224 = 223) //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
gen use_imprv_seed = (s4aq13==2) if s4aq13!=.
replace use_imprv_seed= (s4bq13==2) if use_imprv_seed==. & s4bq13!=.
rename parcelID parcel_id
rename pltid plot_id
rename cropID crop_code
collapse (max) use_imprv_seed, by(hhid parcel_id plot_id crop_code season) 
tempfile imprv_seed
save `imprv_seed'

use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear
gen season=1
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
ren hhid HHID2
rename t0_hhid hhid
*Only one decision maker
clonevar PID1 = s3aq03_3
*replace PID1 = s3aq3_4a if s3aq03_2==2
replace PID1 = s3bq03_3 if PID1==""
*replace PID1 = s3bq3_4a if PID1==. & s3bq03_2==2
*clonevar PID2 = s3aq3_4b
*replace PID2 = a3bq3_4b if PID2==. & a3bq03_2==2
keep hhid parcelID pltid PID* season
duplicates drop hhid parcelID pltid season, force // 3 obs deleted
reshape long PID, i(hhid parcelID pltid season) j(pidno)
drop pidno
drop if PID==""
clonevar personid = PID
destring personid, replace 
ren hhid HHID
merge m:1 HHID personid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_gender_merge.dta", nogen keep(1 3)
ren HHID hhid
rename pltid plot_id
rename parcelID parcel_id
tempfile personids
save `personids'

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_input_quantities.dta", clear
foreach i in inorg_fert org_fert pest /*herb*/ {
	recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'
}

collapse (max) use_*, by(hhid parcel_id plot_id season) 
merge 1:m hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", nogen keep(1 3) keepusing(crop_code)
*ren crop_code_master crop_code
collapse (max) use*, by(hhid parcel_id plot_id crop_code season)
merge 1:1 hhid parcel_id plot_id crop_code season using `imprv_seed',nogen keep(1 3)
recode use* (.=0)
preserve 
keep hhid parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropname_table.dta", nogen keep(3)
drop if crop_code==.
drop crop_code	
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_imprvseed_crop.dta", replace 
restore

merge m:m hhid parcel_id using `personids', nogen keep(1 3) 
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid personid female crop_code)
merge m:1 crop_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropname_table.dta", nogen keep(3)
drop if crop_code==.
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
clonevar indiv = personid 
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use.dta", replace 
restore


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
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if personid!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
*	clonevar PID = personid // SAW 15/3/23 I need this for individual summary stats
	clonevar indiv = personid 
	save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_fert_use.dta", replace //This is currently used for AgQuery
restore
*******************************************************************************
*REACHED BY AG EXTENSION
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC9B.dta", clear

gen receive_advice=(h9q03a__1==1 | h9q03a__2==1 | h9q03a__3==1 | h9q03a__4==1 | h9q03a__5==1 | h9q03a__7==1 | h9q03a__6==1) if (h9q03a__1!=. | h9q03a__2!=. | h9q03a__3!=. | h9q03a__4!=. | h9q03a__5!=. | h9q03a__7!=. | h9q03a__6!=.) // ag12b_08
preserve
use "${Uganda_NPS_W7_raw_data}/AGSEC9A.dta", clear
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
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
*lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_any_ext.dta", replace
 
********************************************************************************
**                         MOBILE PHONE OWNERSHIP                             **
********************************************************************************
*SAW 1.5.23 CODED using Nigeria wave 3 as reference. This section has not been coded for other Uganda waves. 
use "${Uganda_NPS_W7_raw_data}/GSEC14.dta", clear
*append using "${Uganda_NPS_W4_raw_data}/HH/GSEC14B.dta"
recode h14q04 (.=0)
gen hh_number_mobile_owned=h14q04 if h14q02==16.00 // number mobile phones owned by household today
recode hh_number_mobile_owned (.=0)
gen mobile_owned=hh_number_mobile_owned>0
collapse (max) mobile_owned, by(hhid)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_mobile_own.dta", replace 

********************************************************************************
*USE OF FORMAL FINANCIAL SERVICES // needs to be checked again; mixed borrowing with use?
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/GSEC7_1", clear
append using "${Uganda_NPS_W7_raw_data}/GSEC7_4"

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
gen use_fin_serv_others= CB06X==1 | use_saving==1 
gen use_fin_serv_insur=.
**No insurance data in this module
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_digital==1 | use_fin_serv_others==1  | use_fin_serv_credit==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fin_serv.dta", replace


********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
*Total production
use "${Uganda_NPS_W7_raw_data}/AGSEC8B.dta", clear
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==102
ren s8bq01 milk_animals
ren s8bq02 months_milked
ren s8bq03 liters_day 
gen liters_per_largeruminant = (liters_day*365*(months_milked/12))	
keep if milk_animals!=0 & milk_animals!=.
drop if liters_per_largeruminant==.
keep hhid milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_milk_animals.dta", replace


********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************

use "${Uganda_NPS_W7_raw_data}/AGSEC6C.dta", clear
gen poultry_owned = s6cq03a if (APCode==1 | APCode==2 | APCode==3 | APCode==4)
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W7_raw_data}/AGSEC8C.dta", clear	
gen eggs_months = s8cq01/3	// number of layers was reported for the last three months thus the need to divide by 3 to get monthly total				
gen eggs_per_month = s8cq02/3	// number of eggs laid was reported for the last three months thus the need to divide by 3 to get monthly total			
collapse (sum) eggs_months eggs_per_month, by(hhid)
gen eggs_total_year = eggs_month*eggs_per_month*12 // multiply by 12 to get the annual total 
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months eggs_per_month eggs_total_year poultry_owned 
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_eggs_animals.dta", replace

********************************************************************************
**                      CROP PRODUCTION COSTS PER HECTARE                      **
********************************************************************************
*SAW 9.26.23 Using Uganda wave 3 as reference.
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace 
replace dm_gender = 3 if dm_gender==.
collapse (sum) ha_planted ha_harvest, by(hhid parcel_id plot_id season purestand field_size) // Using ha_planted as subsitute for ha_harvest 
duplicates drop hhid parcel_id plot_id season, force // 776 obs deleted 
reshape long ha_, i(hhid parcel_id plot_id season purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_cost_inputs_long.dta", replace
collapse (sum) cost_=val, by(hhid parcel_id plot_id season dm_gender exp)  
reshape wide cost_, i(hhid parcel_id plot_id season dm_gender) j(exp) string  
recode cost_exp cost_imp (.=0)
drop cost_total
gen cost_total=cost_imp+cost_exp
drop cost_imp
drop if plot_id ==.
merge 1:m hhid parcel_id plot_id season using `plot_areas', nogen keep(3) // since this is on the crop level it should one to many...
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
replace dm_gender=1 if dm_gender==.

collapse (sum) cost* ha_ , by(hhid /*parcel_id*/ /*plot_id*/ dm_gender area_type) //collapsing at household level by gender of plot manager - by field size 

*collapse (mean) cost*ha_ [aw=field_size], by(hhid /*parcel_id*/ /*plot_id*/ season dm_gender area_type) //collapsing at househol level by gender of plot manager - by field size 
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender // SAW There are 20 obs with no info on dm_gender which was causing the doubles in the code above
gen dummy = _n
replace area_type = "harvested" if strmatch(area_type,"harvest")

foreach var of varlist cost_exp cost_total cost_exp_ha_ cost_total_ha_{
	replace `var'=`var'/ha_
}
reshape wide cost*_, i(hhid dm_gender2 dummy) j(area_type) string
drop dummy
ren cost* cost*_
gen dummy = _n
replace dm_gender2 = "missing" if dm_gender2=="."
reshape wide cost*, i(hhid dummy) j(dm_gender2) string
drop dummy

foreach i in male female mixed {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropcosts.dta", replace

********************************************************************************
                    * RATE OF FERTILIZER APPLICATION *
********************************************************************************
*SAW 1.6.23 Available in Uganda wave 7, Not in old Uganda wave 3. Best option is to use NGA wave 3 as reference since it uses previous sections that used same code as reference. 
*SAW 1.9.23 Using Nigeria Wave 3 as reference:
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace 
collapse (sum) ha_planted ha_harvest, by(hhid parcel_id plot_id season dm_gender) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
merge 1:1 hhid parcel_id plot_id season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_input_quantities.dta", keep(1 3) nogen
collapse (sum) ha_planted ha_harvest inorg_fert_rate org_fert_rate pest_rate, by(hhid parcel_id plot_id season dm_gender) // at the plot level for both seasons
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
reshape wide ha_planted_ fert_inorg_kg_ fert_org_kg_ pest_kg_ /*herb_kg_*/, i(hhid parcel_id plot_id season) j(dm_gender2) string
collapse (sum) *male *mixed, by(hhid)
recode ha_planted* (0=.)
foreach i in ha_planted fert_inorg_kg fert_org_kg pest_kg /*herb_kg*/ {
	egen `i' = rowtotal(`i'_*)
}
merge m:1 hhid using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", keep (1 3) nogen
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fertilizer_application.dta", replace 

********************************************************************************
*						HOUSEHOLD'S DIET DIVERSITY SCORE					   *
********************************************************************************.
* Thus, only the proportion of households eating nutritious food can be estimated
use "${Uganda_NPS_W7_raw_data}/GSEC15B.dta", clear
* recode food items to map HDDS food categories
recode coicop_5 	(1111/1115				=1	"CEREALS" )  //// 
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_household_diet.dta", replace

********************************************************************************
*WOMEN'S CONTROL OVER INCOME
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
use "${Uganda_NPS_W7_raw_data}/AGSEC5A", clear   	// use of crop sales earnings/output - s5aq11f_1 s5aq11g s5aq11h/ s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W7_raw_data}/AGSEC5B" 	// use of crop sales earnings/output - s5bq11f_1 s5bq11g s5bq11h/ s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W7_raw_data}/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC8A" 	// meat production - who controls the revenue - s8aq06a s8aq06b
append using "${Uganda_NPS_W7_raw_data}/AGSEC8B" 	// milk production - who controls the revenue - s8bq10a s8bq10b
append using "${Uganda_NPS_W7_raw_data}/AGSEC8C" 	// egg production - who controls the revenue - s8cq6a s8cq6b


append using "${Uganda_NPS_W7_raw_data}/GSEC8"	// wage control (s8q31d1 s8q31d2 for primary) (s8q45d1 s8q45d2 for secondary)
append using "${Uganda_NPS_W7_raw_data}/GSEC7_1" //other hh income data does not contain explit identification of controller but decided to use the identity of "person responsible for the income section in the survey"

append using "${Uganda_NPS_W7_raw_data}/GSEC12_2" //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b



gen type_decision="" 
gen controller_income1=.
gen controller_income2=. 


* Control Over Harvest from Crops *
destring s5aq06a_2_1, gen(s5aq06a_2)
replace type_decision="control_harvest" if  !inlist(s5aq06a_2, .,0,-99) |  !inlist(s5aq06a3, .,0,99) |  !inlist(s5aq06a4, .,0,99) // first cropping season
replace controller_income1=s5aq06a_2 if !inlist(s5aq06a_2, .,0,-99) // primary controller
replace controller_income2=s5aq06a3 if !inlist(s5aq06a3, .,0,99) // 2 controllers, first listed
replace controller_income2=s5aq06a4 if controller_income2==. & !inlist(s5aq06a4, .,0,99) // 2 controllers, second listed

destring s5bq06a_2_1, gen(s5bq06a2)
replace type_decision="control_harvest" if  !inlist(s5bq06a2, .,0,-99) |  !inlist(s5bq06a3_1, .,0,99) |  !inlist(s5bq06a4_1, .,0,99) // second cropping season
replace controller_income1=s5bq06a2 if !inlist(s5bq06a2, .,0,99) // primary controller
replace controller_income2=s5bq06a3_1 if !inlist(s5bq06a3_1, .,0,99) // 2 controllers, first listed
replace controller_income2=s5bq06a4_1 if controller_income2==. & !inlist(s5bq06a4_1, .,0,99) // 2 controllers, second listed

* Control Over Sales Income *
destring s5aq11f_1, gen(s5aq11f1)
replace type_decision="control_sales" if  !inlist(s5aq11f1, .,0,-99) |  !inlist(s5aq11g, .,0,99) |  !inlist(s5aq11h, .,0,99)  // first cropping season
replace controller_income1=s5aq11f1 if !inlist(s5aq11f1, .,0,-99)  
replace controller_income2=s5aq11h if !inlist(s5aq11h, .,0,99)
replace controller_income2=s5aq11h if controller_income2==. & !inlist(s5aq11h, .,0,99)

destring s5bq11f_1, gen(s5bq11f1)  
replace type_decision="control_sales" if  !inlist(s5bq11f1, .,0,-99) |  !inlist(s5bq11g, .,0,99) |  !inlist(s5bq11h, .,0,99) // second cropping season
replace controller_income1=s5bq11f1 if !inlist(s5bq11f1, .,0,-99)  
replace controller_income2=s5bq11g if !inlist(s5bq11g, .,0,99)
replace controller_income2=s5bq11h if controller_income2==. & !inlist(s5bq11h, .,0,99)

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

* Control Over Remittances
destring h7_respondent, gen(h7_respond)
replace type_decision="control_remittance" if s11q01==7
replace controller_income1= h7_respond if !inlist(h7_respond, .,0,-99) & s11q01==7


* Control Over Assistance Income
replace type_decision="control_assistance" if s11q01==6
replace controller_income1= h7_respond if !inlist(h7_respond, .,0,-99) & s11q01==6 

keep hhid type_decision controller_income1 controller_income2


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
merge 1:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_control_income.dta", replace



********************************************************************************
*				WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING	       *
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making

use "${Uganda_NPS_W7_raw_data}/AGSEC3A", clear // planting input decision maker - s3aq03_3
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B" // s3bq03_3
append using "${Uganda_NPS_W7_raw_data}/AGSEC5A" // s5aq06a_2_1 s5aq06a3 s5aq06a4
append using "${Uganda_NPS_W7_raw_data}/AGSEC5B" // s5bq06a_2_1 s5bq06a3_1 s5bq06a4_1
append using "${Uganda_NPS_W7_raw_data}/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c

gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.

* planting_input
destring s3aq03_3, gen(s3aq033)
replace type_decision="planting_input" if  !inlist(s3aq033, .,0,99) 
replace decision_maker1=s3aq033 if !inlist(s3aq033, .,0,99)  

destring s3bq03_3, gen(s3bq033)
replace type_decision="planting_input" if  !inlist(s3bq033, .,0,99) 
replace decision_maker2=s3bq033 if !inlist(s3bq033, .,0,99)  

* harvest control 
destring s5aq06a_2_1, gen(s5aq06a2)
replace type_decision="harvest" if  !inlist(s5aq06a2, .,0,-99) |  !inlist(s5aq06a3, .,0,99)  |  !inlist(s5aq06a4, .,0,99) 
replace decision_maker1=s5aq06a2 if !inlist(s5aq06a2, .,0,-99)  
replace decision_maker2=s5aq06a3 if !inlist(s5aq06a3, .,0,99)
replace decision_maker3=s5aq06a4 if !inlist(s5aq06a4, .,0,99)

destring s5bq06a_2_1, gen(s5bq06a2)
replace type_decision="harvest" if  !inlist(s5bq06a2, .,0,-99) |  !inlist(s5bq06a3_1, .,0,99)  |  !inlist(s5bq06a4_1, .,0,99) 
replace decision_maker1=s5bq06a2 if !inlist(s5bq06a2, .,0,-99)  
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
merge 1:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_make_ag_decision.dta", replace

 
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 

use "${Uganda_NPS_W7_raw_data}/AGSEC2A", clear // land ownership 
append using "${Uganda_NPS_W7_raw_data}/AGSEC6A" 	//owns cattle & pack animals - s6aq03b s6aq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC6B" 	//owns small animals - s6bq03b s6bq03c
append using "${Uganda_NPS_W7_raw_data}/AGSEC6C" 	//owns poultry - s6cq03b s6cq03c
append using "${Uganda_NPS_W7_raw_data}/GSEC14"
*use "${Uganda_NPS_W7_raw_data}/GSEC14", clear

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
merge 1:1 hhid individ using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", nogen keep(3)
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_ownasset.dta", replace
 
//ALT merge resolution: double check this section for accuracy and comparability to other countries.
********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/AGSEC3A.dta", clear
gen season=1 
append using "${Uganda_NPS_W7_raw_data}/AGSEC3B.dta" 
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
recode wage* (0=.)	
keep hhid wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_ag_wage.dta", replace



********************************************************************************
*CROP YIELDS
********************************************************************************
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots.dta", replace // at the plot season level
*ren crop_code_master crop_code
//Legacy stuff- agquery gets handled above.
replace dm_gender = 3 if dm_gender==.
gen area_plan_=ha_planted
collapse (sum) area_harv_=area_plan area_plan harvest_=quant_harv_kg, by(hhid dm_gender purestand crop_code) 

gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
drop if mixed==""
duplicates drop hhid dm_gender2 crop_code mixed, force
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
bysort hhid: gen all_area_harvested=area_harv
bysort hhid: gen all_area_planted=area_plan
collapse (sum) all_area_harvested all_area_planted, by(hhid)

replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropname_table.dta", nogen keep(1 3)
**# Bookmark #6

merge 1:1 hhid crop_code using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production.dta", nogen keep(1 3)
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
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest* value_harv* value_sold* /*number_trees_planted**/  , by(hhid) 
recode harvest* area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* value_harv* value_sold* (0=.)
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
	*gen harvested_`p'= (harvest_`p'!=. & harvest_`p'!=.0 )
	*lab var harvested_`p' "1= Household harvested `p'" // 08/24/2024 why are both of them named the same thing?  
}
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production.dta", replace
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production_grouped.dta", replace
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production_type_crop.dta", replace
 
//ALT merge resolution: this may require modification
********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan.dta", clear
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0

*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
*la var sdi "Shannon diversity index"
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
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Uganda_NPS_W7_raw_data}/pov2018_19.dta", clear
ren cpexp30  total_cons // using real consumption-adjusted for region price disparities
ren equiv adulteq
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hsize)
gen daily_peraeq_cons = peraeq_cons/30 
gen daily_percap_cons = percapita_cons/30
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_consumption.dta", replace

use "${Uganda_NPS_W7_raw_data}/pov2018_19.dta", clear
rename equiv adulteq
keep hhid adulteq
tostring hhid, format(%18.0f) replace
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_adulteq.dta", replace


********************************************************************************
*HOUSEHOLD FOOD PROVISION* // DATA MISSING in W7
********************************************************************************


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${Uganda_NPS_W7_raw_data}/GSEC14", clear
* ren hh_m03 price_purch
ren h14q05 value_today
* ren hh_m02 age_item
ren h14q04 num_items
*dropping items if hh doesnt report owning them 
tostring h14q03, gen(asset)
drop if asset=="3"
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_assets.dta", replace 



********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument
 

********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)

global empty_vars ""
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", clear
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:m hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_production.dta", nogen keep(1 3) // season was added in no longer unique
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production_grouped.dta", nogen keep(1 3) 
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_crop_values_production_type_crop.dta", nogen keep(1 3)
recode value_pro* value_sal* (.=0)
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_cost_inputs.dta", nogen keep(1 3)

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_inputs_`c'.dta", nogen	
}
foreach c in $topcropname_area {
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_`c'_monocrop_hh_area.dta", nogen
}
// don't want to add season to the area so making is m:1? 
foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 
*disaggregate by gender of plot manager
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(/*val_anml_`c'_`i' val_labor_`c'_`i'*/ val_mech_`c'_`i'  val_pest_`c'_`i' val_inorg_`c'_`i' val_orgfert_`c'_`i' val_plotrent_`c'_`i' val_seeds_`c'_`i' /*val_transfert_`c'_`i' val_seedtrans_`c'_`i'*/) //These are already narrowed to explicit costs
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

//drop rental_cost_land* cost_seed* value_fertilizer* cost_trans_fert* value_herbicide* value_pesticide* val_labor* value_manure_purch* cost_trans_manure*
drop /*val_anml**/ val_mech*  /*val_herb**/ val_inorg* val_orgfert* val_plotrent* val_seeds* /*val_transfert* val_seedtrans**/ val_pest* val_parcelrent* //

*Land rights
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rights_hh.dta", nogen keep(1 3)
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

*AR- since livestock, income, farm size, hours is season invariant changed it to m:1?
*Livestock income  
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_sales.dta", nogen keep(1 3) 
*merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_expenses.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_products.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_herd_characteristics.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_TLU_Coefficients.dta", nogen keep(1 3)
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced  /*cost_*livestock value_other_produced fish_income_fishfarm */  (.=0)
*No expenses available for livestock
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced/*value_other_produced*/) /*
*/ /*fish_income_fishfarm - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock + cost_deworm_livestock + cost_ticks_livestock) */
*Notes: SAW should we include value of livestock products here?
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
*gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
*lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
*ren cost_vaccines_livestock ls_exp_vac 
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
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* //any_imp_herd_ vac_animal* not present at all in data 

*Self-employment income
ren hhid HHID
merge m:1 HHID using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 hhid using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta", nogen keep(1 3)
*SAW: This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is alre ady part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
ren HHID hhid
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_agwage_income.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_off_farm_hours.dta", nogen keep(1 3)

*Farm Size
merge m:1 hhid using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size.dta", nogen keep(1 3)
merge m:1 hhid using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size_all.dta", nogen keep(1 3)
merge m:1 hhid using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmsize_all_agland.dta", nogen keep(1 3)
merge m:1 hhid using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_size_total.dta", nogen keep(1 3)

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
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired /*labor_family*/ (.=0) 

*Household size
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
*merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_vaccine.dta", nogen keep(1 3) // no vaccine data
*merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fert_use.dta", nogen keep(1 3)
*merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_improvedseed_use.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_input_use.dta", nogen keep(1 3) 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_imprvseed_crop.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_any_ext.dta", nogen keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fin_serv.dta", nogen keep(1 3)
ren use_imprv_seed imprv_seed_use 
ren use_hybrid_seed hybrid_seed_use
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use  (.=0)
*replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & farm_area==. &  tlu_today==0)
replace imprv_seed_use=. if farm_area==.  
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_milk_animals.dta", nogen keep(1 3) // only 500 matching? 
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
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
*gen liters_milk_produced = milk_months_produced * milk_quantity_produced // SAW 2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year

*Rate of fertilizer application 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

*Costs of crop production per hectare
*merge 1:1 hhid season using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_cropcosts.dta", nogen keep(1 3) // since gender is involved..causing issues in the merge to be unique...
 
*Household diet
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_household_diet.dta", nogen keep(1 3)

*consumption 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_consumption.dta", nogen keep(1 3)

*Household assets
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hh_assets.dta", nogen keep(1 3)

/*Food insecurity
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 
*/
*The section Food Security and Food Consumption at the hh level has not been included yet in nigeria and uganda even though it is available.

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health // cannot construct
gen disease_animal=. 
global empty_vars $empty_vars disease_animal* disease_*

*livestock feeding, water, and housing
*merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_livestock_feed_water_house.dta", nogen keep(1 3) // not in dataset 

*Shannon Diversity index
merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_shannon_diversity_index.dta", nogen keep(1 3)

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
gen fishing_hh = .
lab  var fishing_hh "1= Household has some fishing income" // 

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' total_harv_area_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' total_harv_area_`cn' kgs_harvest_`cn' total_planted_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}

*all rural households engaged in livestcok production of a given species // feeding, grazing housing information not in dataset 
foreach i in lrum srum poultry {
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i' feed_grazing_`i'  water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' */ (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' /*disease_animal_`i' feed_grazing_`i'  water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' */(.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired farm_size_agland /*all_area_harvested labor_family */ all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired farm_size_agland /*all_area_harvested labor_family */ all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestock production //
*livestock_expenses feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed missing 
recode animals_lost12months* mean_12months*  disease_animal  (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months*  disease_animal  (nonmissing=.) if livestock_hh==0		

*all rural households 
recode /*DYA.10.26.2020*/ /*hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/ off_farm_hours off_farm_any_count crop_income livestock_income self_employment_income nonagwage_income agwage_income /* all_other_income transfers_income fishing_income*/   value_assets (.=0)
*all rural households engaged in dairy production
rename liters_per_largeruminant liters_milk_produced
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed"
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono labor_family*/ total_planted_area* total_harv_area* /*
*/ labor_hired  /*
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020 hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm livestock_expenses*/  off_farm_hours off_farm_any_count crop_production_expenses value_assets cost_expli_hh /*
*/  ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager //wage_paid_aglabor not there
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh 
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg 

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
egen w_labor_total=rowtotal(w_labor_hired)
*local labor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top ${wins_upper_thres}%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested /*transfers_income*/ all_area_planted ha_planted /*
*/ crop_income livestock_income /*fishing_income all_other_income*/ self_employment_income nonagwage_income agwage_income   total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* /*dist_agrodealer*/ land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p($wins_lower_thres $wins_upper_thres) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  /* we want to keep actual zeros */
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace w_`v'_`g'= r(r1) if w_`v'_`g' < r(r1) & w_`v'_`g'!=. & w_`v'_`g'!=0  /* we want to keep actual zeros */
			replace w_`v'_`g'= r(r2) if  w_`v'_`g' > r(r2)  & w_`v'_`g'!=.		
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"
		}		
	}
}


*Winsorizing variables that go into yield at the top and bottom 5% 
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv area_plan harvest 
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p($wins_lower_thres $wins_upper_thres)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0 
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top ${wins_upper_thres}% and bottom ${wins_lower_thres}%"
			
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
 
  *Yield by Area Harvested // SAW 2.20.23 Area Harvest not available 
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

*mortality rate // no livestock income section so have to create it here
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
	lab var  w_`v'  "`l`v'' - Winzorized top ${wins_upper_thres}%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" {
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
		_pctile `i'_`c' [aw=weight] ,  p($wins_95_thres)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winzorized top ${wins_upper_thres}%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winzorized top ${wins_upper_thres}%"
		}
	}
}

foreach c of global topcropname_area {
	replace w_yield_pl_`c'=. if w_area_plan_`c'<0.05
	*replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		*replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
	}
}

*Create final income variables using un_winzorized and un_winzorized values
egen total_income = rowtotal(crop_income livestock_income /* all_other_income transfers_income fishing_income*/ self_employment_income nonagwage_income agwage_income)
egen nonfarm_income = rowtotal(/*fishing_income transfers_income*/ self_employment_income nonagwage_income  )
egen farm_income = rowtotal(crop_income livestock_income agwage_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"
egen w_total_income = rowtotal(w_crop_income w_livestock_income /* w_all_other_income w_fishing_income w_transfers_income*/ w_self_employment_income w_nonagwage_income w_agwage_income)
egen w_nonfarm_income = rowtotal(/*w_fishing_income w_all_other_income w_transfers_income*/ w_self_employment_income w_nonagwage_income  )
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top ${wins_upper_thres}%"
lab var w_farm_income "Farm income - Winzorized top ${wins_upper_thres}%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top ${wins_upper_thres}%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top ${wins_upper_thres}%"
global income_vars crop livestock /*fishing all_other transfers */ self_employment nonagwage agwage 
foreach p of global income_vars {
	gen `p'_income_s = `p'_income
	replace `p'_income_s = 0 if `p'_income_s < 0
	gen w_`p'_income_s = w_`p'_income
	replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}

egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s /*w_fishing_income_s w_transfers_income_s w_all_other_income_s*/ w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s   )
foreach p of global income_vars {
	gen w_share_`p' = w_`p'_income_s / w_total_income_s
	lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}
egen w_nonfarm_income_s = rowtotal(/*w_fishing_income_s w_transfers_income_s w_all_other_income_s*/ w_self_employment_income_s w_nonagwage_income_s  )
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
	drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid

recode w_total_income w_percapita_income w_crop_income w_livestock_income /*w_fishing_income_s w_transfers_income w_all_other_income*/ w_nonagwage_income w_agwage_income w_self_employment_income   /*
*/ w_share_crop w_share_livestock /*w_share_fishing months_food_insec */ w_share_nonagwage w_share_agwage w_share_self_employment  w_share_nonfarm /*
*/ /*use_fin_serv*/ use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh *_hrs_*_pc_all   w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode /*vac_animal livestock_expenses w_ls_exp_vac*/ w_share_livestock_prod_sold   (. = 0) if livestock_hh==1 
recode /*vac_animal livestock_expenses w_ls_exp_vac*/ w_share_livestock_prod_sold (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode /*vac_animal_`i' w_ls_exp_vac_`i'*/ any_imp_herd_`i' w_lost_disease_`i'  (nonmissing=.) if lvstck_holding_`i'==0
	recode /*vac_animal_`i' w_ls_exp_vac_`i'*/ any_imp_herd_`i' w_lost_disease_`i'  (.=0) if lvstck_holding_`i'==1	
}
 
*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland  w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /* w_labor_family*/ (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland  w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
	
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' w_value_harv_`cn' w_total_harv_area_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' (nonmissing=.) if grew_`cn'==0
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
gen ccf_loc = (1/$UGA_W7_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$UGA_W7_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$UGA_W7_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$UGA_W7_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

*Poverty indicators 
gen poverty_under_1_9 = (daily_percap_cons < $UGA_W7_poverty_190)
la var poverty_under_1_9 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_2_15 = (daily_percap_cons < $UGA_W7_poverty_215)
la var poverty_under_2_15 "Household per-capita consumption is below $2.15 in 2017 $ PPP"

merge 1:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_consumption.dta", keep(1 3) nogen 

*generating clusterid and strataid
gen clusterid=subcounty
*gen strataid=region

*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep hhid poverty* fhh clusterid strataid weight *wgt* region region subcounty district county county_name parish parish_name rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq  *labor_hired use_inorg_fert  /*
*/ ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ ** *ls_exp_vac* *prop_farm_prod_sold *hrs_*    *value_assets*  *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned nb* *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh  *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* /*fishing_hh nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp nb_* *sales_livestock_products area_plan* area_harv* /*labor_family* vac_ feed* water* lvstck_housed* months_food_insec hhs_* */value_pro* *value_sal*

ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"
gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) 

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen HHID_panel = hhid 
lab var HHID_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2018-19"
gen instrument = 56
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	

saveold "${Uganda_NPS_W7_final_data}/Uganda_NPS_W7_household_variables.dta", replace


********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_person_ids.dta", clear
merge m:1 hhid   using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_household_diet.dta", nogen
merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhsize.dta", nogen keep (1 3)
merge m:1 hhid indiv using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_fert_use.dta", nogen  keep(1 3)
merge m:1 hhid indiv using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_improvedseed_use.dta", nogen  keep(1 3)
*merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_hhids.dta", nogen keep (1 3)

*land rights
merge 1:1 hhid individ using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_land_rights_ind.dta", nogen
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
*gen female_vac_animal=all_vac_animal if female==1
*gen male_vac_animal=all_vac_animal if female==0
*lab var male_vac_animal "1 = Individual male farmers (livestock keeper) uses vaccines"
*lab var female_vac_animal "1 = Individual female farmers (livestock keeper) uses vaccines"
*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0
* 
gen women_diet=.
replace number_foodgroup=.

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen HHID_panel = hhid 
lab var HHID_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2018-19"
gen instrument = 56
//Only runs if label isn't already defined.
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
gen clusterid=subcounty

ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

*merge in hh variable to determine ag household
preserve
use "${Uganda_NPS_W7_final_data}/Uganda_NPS_W7_household_variables.dta", clear
duplicates drop hhid, force // to make it back unique to household - is this okay? 
keep hhid ag_hh 
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0
saveold "${Uganda_NPS_W7_final_data}/Uganda_NPS_W7_individual_variables.dta", replace

********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_all_plots", replace
collapse (sum) plot_value_harvest = value_harvest, by(hhid parcel_id plot_id season) // SAW 10.10.23 Usiing Standarized version of value harvested
tempfile crop_values 
save `crop_values' // season level

use "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_areas.dta", replace // plot-season level 
merge m:1 hhid using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_weights.dta", keep (1 3) nogen // hh level
merge m:1 hhid parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge m:1 hhid parcel_id plot_id season using  "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_decision_makers.dta", keep (1 3) nogen
merge m:1 hhid plot_id using "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_plot_family_hired_labor.dta", keep (1 3) nogen
merge m:1 hhid using "${Uganda_NPS_W7_final_data}/Uganda_NPS_W7_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region)

recode farm_size_agland (.=0) 
gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

*keep if cultivate==1 // 3/15/23 We need to generate this indicator
ren field_size  area_meas_hectares
egen labor_total = rowtotal( labor_hired /*labor_nonhired labor_family*/) // labor_nonhired needs to be created too. 
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
*gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
*lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight 
lab var plot_weight "Weight for plots (weighted by plot area)"
gen plot_labor_prod=.
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	

gen ccf_loc = (1/$UGA_W7_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$UGA_W7_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$UGA_W7_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$UGA_W7_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

global monetary_val plot_value_harvest plot_productivity  /*plot_labor_prod*/
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
gen clusterid=subcounty
*gen strataid=region
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) 
gen larea_meas_hectares=ln(w_area_meas_hectares)
svy, subpop( if rural==1 ): reg  lplot_productivity_usd male_dummy  
matrix b1a=e(b)
gen gender_prod_gap1a=100*el(b1a,1,1)
sum gender_prod_gap1a
lab var gender_prod_gap1a "Gender productivity gap (%) - regression in logs with no controls"
matrix V1a=e(V)
gen segender_prod_gap1a= 100*sqrt(el(V1a,1,1)) 
sum segender_prod_gap1a
lab var segender_prod_gap1a "SE Gender productivity gap (%) - regression in logs with no controls"

*Gender-gap 1b
svy, subpop(if rural==1 ): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
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
svy, subpop(if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.region
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
	 
	 .
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
rename v1 UGA_wave7

save "${Uganda_NPS_W7_created_data}/Uganda_NPS_W7_gendergap.dta", replace 
restore

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
	}
	
ren weight weight_orig 
ren weight_pop_rururb weight
la var weight_orig "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

/*
foreach i in 1ppp 2ppp loc{
	gen w_plot_labor_prod_all_`i'=w_plot_labor_prod_`i'
	gen w_plot_labor_prod_female_`i'=w_plot_labor_prod_`i' if dm_gender==2
	gen w_plot_labor_prod_male_`i'=w_plot_labor_prod_`i' if dm_gender==1
	gen w_plot_labor_prod_mixed_`i'=w_plot_labor_prod_`i' if dm_gender==3
}

gen plot_labor_weight= w_labor_total*weight
*/
//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments

gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier"
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2018-19"
gen instrument = 56
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument
saveold "${Uganda_NPS_W7_final_data}/Uganda_NPS_W7_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/* 
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters


global list_instruments  "Uganda_NPS_W7"
do "$summary_stats"
