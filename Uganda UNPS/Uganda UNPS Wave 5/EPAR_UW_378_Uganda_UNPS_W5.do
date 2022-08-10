/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 5 (2015-16).
*Author(s)		: Didier Alia, C. Leigh Anderson, & Josh Grandbouche

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  We also acknowledge the contributions of former EPAR members Pierre Biscaye, David Coomes, Jack Knauer, Josh Merfeld,  
				  Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, & Travis Reynolds.
				  All coding errors remain ours alone.
*Date			: This  Version - 15 July 2022
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Uganda National Panel Survey was collected by the Uganda National Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period October 2015 - January 2016.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2862

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "raw_data" folder within the "uganda-wave5-2015-16" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "\uganda-wave5-2015-16\created data".
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "\uganda-wave5-2015-16\final data".

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of this do.file, there is a reference to another do.file that estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager or farm size.
*The results are outputted in the excel file "Uganda_NPS_W5_summary_stats.xlsx" in the "\uganda-wave5-2015-16\final data" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.
										
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files that will be created by running this Master do.file - currently, only a portion of these are in workable condition for posting publicly. Further updates will come this later in 2022.
 					
*MAIN INTERMEDIATE FILES CREATED (see note above in line 45)
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_W5_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_W5_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_W5_hhsize.dta
*PLOT AREAS							Uganda_NPS_W5_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_W5_plot_decision_makers.dta

*ALL PLOTS							Uganda_NPS_W5_all_plots.dta

*CROP EXPENSES						Uganda_NPS_W5_wages_mainseason.dta
									Uganda_NPS_W5_wages_shortseason.dta
									Uganda_NPS_W5_fertilizer_costs.dta
									Uganda_NPS_W5_seed_costs.dta
									Uganda_NPS_W5_land_rental_costs.dta
									Uganda_NPS_W5_asset_rental_costs.dta
									Uganda_NPS_W5_transportation_cropsales.dta
									
*MONOCROPPED PLOTS					Uganda_NPS_W5_[CROP]_monocrop_hh_area.dta
									
*TLU (Tropical Livestock Units)		Uganda_NPS_W5_TLU_Coefficients.dta
									
*CROP INCOME						Uganda_NPS_W5_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_W5_livestock_expenses.dta
									Uganda_NPS_W5_hh_livestock_products.dta
									Uganda_NPS_W5_dung.dta
									Uganda_NPS_W5_livestock_sales.dta
									Uganda_NPS_W5_TLU.dta
									Uganda_NPS_W5_livestock_income.dta

*FISH INCOME						Uganda_NPS_W5_fishing_expenses_1.dta
									Uganda_NPS_W5_fishing_expenses_2.dta
									Uganda_NPS_W5_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_W5_self_employment_income.dta
									
*WAGE INCOME						Uganda_NPS_W5_wage_income.dta
									Uganda_NPS_W5_agwage_income.dta

*OTHER INCOME						Uganda_NPS_W5_other_income.dta
									Uganda_NPS_W5_land_rental_income.dta
									
*FARM SIZE / LAND SIZE				Uganda_NPS_W5_land_size.dta
									Uganda_NPS_W5_farmsize_all_agland.dta
									Uganda_NPS_W5_land_size_all.dta
									Uganda_NPS_W5_land_size_total.dta

*OFF-FARM HOURS						Uganda_NPS_W5_off_farm_hours.dta

*FARM LABOR							Uganda_NPS_W5_farmlabor_mainseason.dta
									Uganda_NPS_W5_farmlabor_shortseason.dta
									Uganda_NPS_W5_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_W5_vaccine.dta
									Uganda_NPS_W5_farmer_vaccine.dta
									
*ANIMAL HEALTH						Uganda_NPS_W5_livestock_diseases.dta
									Uganda_NPS_W5_livestock_feed_water_house.dta

*USE OF INORGANIC FERTILIZER		Uganda_NPS_W5_fert_use.dta
									Uganda_NPS_W5_farmer_fert_use.dta

*USE OF IMPROVED SEED				Uganda_NPS_W5_improvedseed_use.dta
									Uganda_NPS_W5_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_W5_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_W5_fin_serv.dta
*MILK PRODUCTIVITY					Uganda_NPS_W5_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_W5_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_W5_hh_rental_rate.dta
									Uganda_NPS_W5_hh_cost_land.dta
									Uganda_NPS_W5_hh_cost_inputs_lrs.dta
									Uganda_NPS_W5_hh_cost_inputs_srs.dta
									Uganda_NPS_W5_hh_cost_seed_lrs.dta
									Uganda_NPS_W5_hh_cost_seed_srs.dta
									Uganda_NPS_W5_asset_rental_costs.dta
									Uganda_NPS_W5_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Uganda_NPS_W5_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_W5_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_W5_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_W5_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_W5_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_W5_ownasset.dta

*CROP YIELDS						Uganda_NPS_W5_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_W5_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_W5_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_W5_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_W5_hh_assets.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_W5_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_W5_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_W5_field_plot_variables.dta
*SUMMARY STATISTICS					Uganda_NPS_W5_summary_stats.xlsx
*/

 
clear	
set more off
clear matrix	
clear mata	
set maxvar 10000	
ssc install findname  // need this user-written ado file for some commands to work

// set directories
* These paths correspond to the folders where the raw data files are located 
* and where the created data and final data will be stored.
global directory "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda"
//set directories: These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Uganda_NPS_W5_raw_data 			"$directory\uganda-wave5-2015-16\raw_data"
global Uganda_NPS_W5_created_data 		"$directory\uganda-wave5-2015-16\temp" //JHG: change this when done to actual created_data and final_data folders 
global Uganda_NPS_W5_final_data  		"$directory\uganda-wave5-2015-16\temp" //JHG: change this when done to actual created_data and final_data folders 

 
********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
global Uganda_NPS_W5_exchange_rate 3346.0703		// Rate of Dec 1, 2015 from https://www.exchangerates.org.uk/USD-UGX-spot-exchange-rates-history-2015.html
global Uganda_NPS_W5_gdp_ppp_dollar 1125.471   		// Rate for 2015 from https://data.worldbank.org/indicator/PA.NUS.PPP?locations=UG
global Uganda_NPS_W5_cons_ppp_dollar 1127.687		// Rate for 2015 from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG
global Uganda_NPS_W5_inflation 00  		// inflation rate 2015-16 (years). Data was collected during the time period Oct 2015-Jan 2016. We want to adjust the monetary values to 2016 (year).

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************

//Purpose: Generate a crop .dta file that only contains the priority crops. This is used in for a couple of other indicators down the line. You can edit this section to change which crops you are examining.

*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum fmillt cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea coffee irptt" //JHG: added coffee (Robusta/Arabica), finger millet, and irish potatoes as they are all in the top 10 for Uganda (and pearl millet is not grown there)
global topcrop_area "130 120 111 150 141 222 310 210 640 620 630 740 520 330 223 810 610"
global comma_topcrop_area "130, 120, 111, 150, 141, 222, 310, 210, 640, 620, 630, 740, 520, 330, 223, 810, 610"
global topcropname_area_full "maize rice wheat sorghum fingermillet cowpea groundnut beans yam sweetpotato cassava banana cotton sunflower pigeonpea coffee irishpotato"
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
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_cropname_table.dta", replace //This gets used to generate the monocrop files.


********************************************************************************
*HOUSEHOLD IDS
********************************************************************************

//Purpose: Generate a .dta with weights and urban/rural dummy variable, alongside hhid and regional variables (state, etc.)

*JHG 10_26_21: Check for consistency of variable naming for hhid, HHID, hh, etc. across the different surveys. May need to rename the variables to be consistent, as was done in Uganda W4
use "${Uganda_NPS_W5_raw_data}\AGSEC1", clear
rename hwgt_W5  pweight  // using the crossectional weight that applies to all respondents
rename h1aq6 village
rename HHID hhid
generate rural = urban == 0 //creates new variable "rural", codes rural=1 if urban=0
generate strataid = region
generate clusterid = ea
keep hhid region district district_name scounty_code subcounty_name parish_code parish_name village ea rural pweight strataid clusterid
label var rural "1 = Household lives in a rural area"
label var ea "Enumeration Area"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", replace


********************************************************************************
*WEIGHTS
********************************************************************************

//Purpose: This additional file only contains weights and is used in the calculation of later indicators.

use "${Uganda_NPS_W5_raw_data}/gsec1.dta", clear
rename h_xwgt_W5 weight //using the household crossectional weight for w5
rename HHID hhid
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta"
keep hhid weight rural
save  "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_weights.dta", replace


********************************************************************************
*INDIVIDUAL IDS
********************************************************************************

//Purpose: Generate a .dta file containing information on all household members

use "${Uganda_NPS_W5_raw_data}\gsec2", clear
destring pid, gen(indiv) ignore ("P" "-") //PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P", leading "0", and the "-"
generate female = h2q3==2
label var female "1= individual is female"
generate age = h2q8
label var age "Individual age"
generate hh_head = h2q4==1 //hh_head: head of household
label var hh_head "1= individual is household head"
rename h2q1 individ //2015-16 roster number, need the roster number for formal land rights

*clean up and save data
label var indiv "Personal identification"
label var individ "Roster number (identifier within household)"
keep hhid indiv individ female age hh_head
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_person_ids.dta", replace

 
********************************************************************************
*HOUSEHOLD SIZE
********************************************************************************

//Purpose: Generate a .dta file with information on the number of family members in a household and the gender of the head of the household

use "${Uganda_NPS_W5_raw_data}/gsec2.dta", clear
generate hh_members = 1
rename h2q4 relhead //relhead: relationship to head of household
rename h2q3 gender
generate fhh = (relhead == 1 & gender == 2) //fhh: female head of household
collapse (sum) hh_members (max) fhh, by (hhid)	// Aggregate households to sum the number of people in each house and note whether they have a female head of household or not

*Clean and save data
label var hh_members "Number of household members"
label var fhh "1 = Female-headed household"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhsize.dta", replace

********************************************************************************
*PLOT AREAS
********************************************************************************

//Purpose: Generate a size, in hectares for individual plots. This variable is called field_size.

/*JHG 10_27_21: This first section is a check to make sure plots sum up to parcels. Commented out unless needed. Update JHG 3/17/22: Not sure if needed anymore due to different procedure below, but will leave in for now

use "${Uganda_NPS_W5_raw_data}/AGSEC4A.dta", clear
generate season = 1
append using "${Uganda_NPS_W5_raw_data}/AGSEC4B.dta", generate(last)		
replace season = 2 if last==1
label var season "Season = 1 if 2nd cropping season of 2014, 2 if 1st cropping season of 2015"
generate plot_area = a4aq7
replace plot_area = a4bq7 if plot_area==.
collapse (sum) plot_area, by(HHID parcelID season) //Aggregate plots by household and by parcel within household AND by season, this results in more observations than if just aggregated up to the household level
merge m:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2A.dta", nogen
merge m:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2B.dta"
rename HHID hhid
generate parcel_area = a2aq4 //JHG 10_27_21: Used GPS estimation here if we have it, but many parcels do not have GPS estimation
replace parcel_area = a2bq4 if a2bq4 != .
replace parcel_area = a2aq5 if parcel_area==. //JHG 10_27_21: replaced missing values with farmer estimation
replace parcel_area = a2bq5 if parcel_area==. //JHG 10_27_21: see above
keep hhid parcelID season plot_area parcel_area // Drop unnecessary variables to compare
generate diff = parcel_area - plot_area
codebook diff
*JHG 10_27_21: Results are close but with a negative skew, indicating that parcel sizes are often smaller than the sum of plots by parcel.
*/

//Now we'll actually make the changes to plot area to adjust, under the assumption that farmers' estimates of parcel size are more accurate than plot size (all these value are just area planted, not total plot and not inclusive of non-cultivated plots)

*First, clean up the data and put it in hectares
use "${Uganda_NPS_W5_raw_data}/AGSEC4A.dta", clear
generate season = 1
append using "${Uganda_NPS_W5_raw_data}/AGSEC4B.dta"		
replace season = 2 if season == .
label var season "Season = 1 if 2nd cropping season of 2014, 2 if 1st cropping season of 2015"
generate planted_area = a4aq7 //values are in acres
replace planted_area = a4bq7 if planted_area == . //values are in acres
replace planted_area = planted_area * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
ren planted_area ha_planted

*Now, generate variables to fix issues with the percentage of a plot that crops are planted on not adding up to 100 (both above and below). This is complicated so each line below explains the procedure
generate percent_planted = a4aq9/100
replace percent_planted = a4bq9/100 if percent_planted == . //generating a single variable for the percent of a crop that is planted (both seasons in one variable)
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

*Fix plots with missing ha_planted issues and calculate final plot areas
replace ha_planted = 0.404686 if HHID == "H2210202" & parcelID == 1 & plotID == 2 & season == 1 //ha_planted was 0 here, replaced with the value from the same plot in a different season where percent_planted equaled 100%; same for the next two lines
replace ha_planted = 0.202343 if HHID == "H1650201" & parcelID == 1 & plotID == 1 & season == 1
replace ha_planted = 0.202343 if HHID == "H3650101" & parcelID == 2 & plotID == 2 & season == 1
gen plot_area = ha_planted / percent_planted

bys HHID parcelID season : egen total_plot_area = sum(plot_area)
generate plot_area_pct = plot_area/total_plot_area
keep HHID parcelID plotID season plot_area total_plot_area plot_area_pct ha_planted
merge m:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2A.dta", nogen
merge m:1 HHID parcelID using "${Uganda_NPS_W5_raw_data}/AGSEC2B.dta"
rename HHID hhid

*generating field_size
generate parcel_acre = a2aq4 //JHG 10_27_21: Used GPS estimation here to get parcel size in acres if we have it, but many parcels do not have GPS estimation
replace parcel_acre = a2bq4 if parcel_acre == . 
replace parcel_acre = a2aq5 if parcel_acre == . //replace missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres)
replace parcel_acre = a2bq5 if parcel_acre == . //see above
gen field_size = plot_area_pct * parcel_acre //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen parcel_ha = parcel_acre * 0.404686

*cleaning up and saving the data
rename plotID plot_id
rename parcelID parcel_id
keep hhid parcel_id plot_id season field_size plot_area total_plot_area parcel_acre parcel_ha ha_planted
drop if field_size == .
label var field_size "Area of plot (ha)"
label var hhid "Household identifier"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas.dta", replace


********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************

//Purpose: Create a .dta file with information on plot managers (gender of head of household and gender of plot manager, whether male, female, or mixed). Separate dummy variables are created whether the plot manager is female, male, or mixed, for a total of three variables there. If no gender is available for plot manager, head of household is substituted in.

use "${Uganda_NPS_W5_raw_data}/gsec2.dta", clear
destring pid, gen(indiv) ignore ("P" "-") //PID is a string variable that contains some of the information we need to identify household members later in the file, need to destring and ignore the "P", leading "0", and the "-"
generate female = h2q3 == 2
label var female "1 = individual is female"
generate age = h2q8
label var age "Individual age"
generate hh_head = h2q4 == 1 //hh_head: head of household
label var hh_head "1 = individual is household head"
keep hhid indiv female age hh_head 
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_gender_merge.dta", replace

use "${Uganda_NPS_W5_raw_data}/AGSEC3A.dta", clear //This raw data from the end of 2014 only contains plots that were cultivated

gen season = 1
append using "${Uganda_NPS_W5_raw_data}/AGSEC3B.dta" //This raw data from the beginning of 2015 only contains plots that were cultivated
replace season = 2 if season == .
rename HHID hhid
rename parcelID parcel_id
rename plotID plot_id

*Single decision-maker variables 
gen indiv = a3aq3_3
replace indiv = a3bq3_3 if indiv == . & a3bq3_3 != .
merge m:1 hhid indiv using  "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_gender_merge.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using. JHG 1_28_22: 11,565 observations dropped. Why? JHG 5_18_22: likely because we're only looking at a subset of the data
gen dm1_female = female
drop female indiv

*Multiple decision-maker variables: first decision maker
gen indiv = a3aq3_4a
replace indiv = a3bq3_4a if indiv == . &  a3bq3_4a != .
merge m:1 hhid indiv using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using. JHG 1_28_22: 9,5772 observations dropped.
gen dm2_female = female
drop female indiv
replace dm1_female = dm2_female if dm1_female == .
drop dm2_female dm2_merge

*Multiple decision-maker variables: second decision maker
gen indiv = a3aq3_4b
replace indiv = a3bq3_4b if indiv == . &  a3bq3_4b != .
merge m:1 hhid indiv using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using. JHG 1_28_22: 9,5772 observations dropped.
gen dm2_female = female
drop female indiv

//JHG 12_28_21: They only collected information on two decision-makers per plot.

*Constructing three-part gendered decision-maker variable; male only (= 1) female only (= 2) or mixed (= 3)
keep hhid parcel_id plot_id season dm*
gen dm_gender = 1 if (dm1_female == 0 | dm1_female == .) & (dm2_female == 0 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 2 if (dm1_female == 1 | dm1_female == .) & (dm2_female == 1 | dm2_female == .) & !(dm1_female == . & dm2_female == .) //if both dm1 and dm2 are null, then dm_gender is null
replace dm_gender = 3 if dm_gender == . & !(dm1_female == . & dm2_female == .) //2,269 mixed-gender managed plots
label def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
label val dm_gender dm_gender
label var dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhsize.dta", keep(1 3) nogen
replace dm_gender = 1 if fhh == 0 & dm_gender == . //4,394 replaced
replace dm_gender = 2 if fhh == 1 & dm_gender == . //2,359 replaced
//219 observations have a null value for gender.
keep hhid parcel_id plot_id season dm_gender fhh
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_decision_makers.dta", replace


********************************************************************************
*ALL PLOTS
********************************************************************************

/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section). Unfortunately, data quality on crop values is incredibly inconsistent and currently makes this data unusable. Further code updates may remove sections for valuing crops.

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs, percent field, and months grown variables.

*/

	***************************
	*Crop Values
	***************************
	use "${Uganda_NPS_W5_raw_data}/AGSEC5A.dta", clear
	append using "${Uganda_NPS_W5_raw_data}/AGSEC5B.dta"
	rename a5aq7a sold_qty
	gen season = 1 if sold_qty != .
	ren a5aq6c unit_code 
	replace unit_code = a5bq6c if unit_code == .
	replace sold_qty = a5bq7a if sold_qty == .
	replace season = 2 if season == . & a5bq7a != .
	rename a5aq7c sold_unit_code
	replace sold_unit_code = a5bq7c if sold_unit_code == .
	rename a5aq8 price_unit // we determined that this question wasn't asking for total sold value, but something else... even per-unit doesn't really work. Crop values might be a lost cause here
	replace price_unit = a5bq8 if price_unit == .
	merge m:m HHID using "${Uganda_NPS_W5_raw_data}/AGSEC1.dta", nogen keepusing(region district scounty_code parish_code ea region)
	rename HHID hhid
	rename plotID plot_id
	rename parcelID parcel_id
	rename cropID crop_code
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_value.dta", replace
	keep hhid parcel_id plot_id crop_code unit_code sold_unit_code sold_qty price_unit district scounty_code parish_code ea region
	merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keepusing(pweight)
	gen obs = price_unit != .
	
	//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.
	foreach i in region ea district scounty_code parish_code hhid {
		preserve
		bys `i' crop_code sold_unit_code : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=pweight], by (`i' sold_unit_code crop_code obs_`i'_price)
		rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	*drop if crop_code != 130 //take away once problem is fixed
	*drop if sold_unit_code != 1 //take away once problem is fixed
	collapse (mean) price_unit_country = price_unit (sum) obs_country_price = obs [aw=pweight], by(crop_code sold_unit_code)
	rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
	drop if unit_code == .
	tempfile price_unit_country_median
	save `price_unit_country_median'
	
	**********************************
	** Crop Unit Conversion Factors **
	**********************************
	*Create conversion factors for harvest
	use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_value.dta", clear
	rename a5aq6a quantity_harv
	replace quantity_harv = a5bq6a if quantity_harv == .
	rename a5aq6b condition_harv
	replace condition_harv = a5bq6b if condition_harv == .
	rename a5aq6d conv_fact_harv_raw
	replace conv_fact_harv_raw = a5bq6d if conv_fact_harv_raw == .
	recode crop_code (811 812 = 810) (741 742 744 = 740) //810 is coffee, which is being reduced from different types to just coffee. Same for bananas (740).
	label define cropID 810 "Coffee" 740 "Bananas", modify //need to add new codes to the value label, cropID
	label values crop_code cropID //apply crop labels to crop_code
	collapse(median) conv_fact_harv_raw, by (crop_code condition unit_code)
	rename conv_fact_harv_raw conv_fact_harv_median
	lab var conv_fact_harv_median "Median value of supplied conversion factor by crop type, condition, and unit code"
	replace conv_fact_harv_median = 1 if unit_code == 1
	drop if conv_fact_harv_median == . | crop_code == . | condition == .
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_conv_fact_harv.dta", replace
	
	*Create conversion factors for sold crops (this is exactly the same with different variable names for use with merges later)
	use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_value.dta", clear
	rename a5aq6a quantity_harv
	replace quantity_harv = a5bq6a if quantity_harv == .
	rename a5aq6b condition_harv
	replace condition_harv = a5bq6b if condition_harv == .
	rename a5aq6d conv_fact_harv_raw
	replace conv_fact_harv_raw = a5bq6d if conv_fact_harv_raw == .
	recode crop_code (811 812 = 810) (741 742 744 = 740) //810 is coffee, which is being reduced from different types to just coffee. Same for bananas (740).
	label define cropID 810 "Coffee" 740 "Bananas", modify //need to add new codes to the value label, cropID
	label values crop_code cropID //apply crop labels to crop_code
	collapse(median) conv_fact_harv_raw, by (crop_code condition unit_code)
	rename conv_fact_harv_raw conv_fact_sold_median
	lab var conv_fact_sold_median "Median value of supplied conversion factor by crop type, condition, and unit code"
	replace conv_fact_sold_median = 1 if unit_code == 1
	drop if conv_fact_sold_median == . | crop_code == . | condition == .
	rename unit_code sold_unit_code //done to make a merge later easier, at this point it just represents an abstract unit code
	rename condition_harv condition //again, done to make a merge later easier
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_conv_fact_sold.dta", replace
	
	
	***************************
	*Plot variables
	***************************	
	*Clean up file and combine both seasons
	use "${Uganda_NPS_W5_raw_data}/AGSEC4A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W5_raw_data}/AGSEC4B.dta"
	replace season = 2 if season == .
	rename HHID hhid
	rename plotID plot_id
	rename parcelID parcel_id
	rename cropID crop_code_plant //crop codes for what was planted
	drop if crop_code_plant == .
	gen crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
	recode crop_code_master (811 812 = 810) (741 742 744 = 740) //810 is coffee, which is being reduced from different types to just coffee. Same for bananas (740).
		label define cropID 810 "Coffee" 740 "Bananas", modify //need to add new codes to the value label, cropID
	label values crop_code_master cropID //apply crop labels to crop_code_master
	
	*Merge area variables (now calculated in plot areas section earlier)
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas.dta", nogen keep(1 3)
	
	
	*Creating time variables (month planted, harvested, and length of time grown)
	gen month_planted = a4aq9_1
	replace month_planted = a4bq9_1 if season == 2 
	replace month_planted = . if a4aq9_1 == 99 //have to remove permanent crops/trees like coffee and bananas
	replace month_planted = . if a4bq9_1 == 99
	lab var month_planted "Month of planting relative to December 2013 (both cropping seasons)"
	merge m:m hhid parcel_id plot_id /*crop_code*/ season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_value.dta", nogen
	rename crop_code crop_code_harvest
	drop if crop_code_harvest == . //10 observations dropped
	gen month_harvest = a5aq6e //JHG 12_31_21: Harvest start and end dates are different. Which to choose? Will use start date for now.
	replace month_harvest = a5bq6e if season == 2
	replace month_harvest = month_harvest + 12 if (a5aq6e < 13 & a5aq6e_1 == 2015) //fixing inconsistency between reported month of harvest and reported year
	lab var month_harvest "Month of planting relative to December 2013 (both cropping seasons)"
	gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order
	replace perm_tree = 0 if perm_tree == .
	lab var perm_tree "1 = Tree or permanent crop" 
	gen months_grown = month_harvest - month_planted if perm_tree == 0 //If statement removes permanent crops from consideration. JHG 12_31_21: results in some negative values. These likely are typos (putting the wrong year) because the timeline would lineup correctly based on the crop if the years were 2015 instead of 2014 for harvesting. Attempt to fix above corrected some entries but not all. Rest are removed in next line.
	replace months_grown = . if months_grown < 1 | month_planted == . | month_harvest == .
	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs = 1
		replace obs = 0 if inrange(a5aq17,1,4) | inrange(a5bq17,1,4) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc.
		collapse (sum) crops_plot = obs, by(hhid parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 hhid parcel_id plot_id season using `ncrops', nogen
	drop if hh_agric == .
	gen contradict_mono = 1 if a4aq9 == 100 | a4bq9 == 100 & crops_plot > 1 //816 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if a4aq9 == 100 | a4aq8 == 1 | a4bq9 == 100 | a4bq8 == 1 //meanwhile 173 list intercropping or mixed cropping but only report one crop
	
	*Generate variables around lost and replanted crops
	gen lost_crop = inrange(a5aq17,1,4) | inrange(a5bq17,1,4)
	bys hhid parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.
	
	*Generating monocropped plot variables (Part 1)
	bys hhid parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys hhid parcel_id plot_id season : egen permax = max(perm_tree)
	bys hhid parcel_id plot_id season a4aq9_1 a4bq9_1 : gen plant_date_unique = _n
	replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis
	bys hhid parcel_id plot_id season a5aq6e a5bq6e : gen harv_date_unique = _n
	bys hhid parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys hhid parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop.
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (a4aq8 == 2 | a4bq8 == 2)
	bys hhid parcel_id plot_id season : egen mixed_max = max(mixed)
	/*replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 //JHG 1_14_22: 8 replacements, all of which report missing crop_code values.
	//No relay cropping
	gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 */
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
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
	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey
	
	*Renaming variables for merge to work 
	ren a5aq6a quantity_harvested
	replace quantity_harvested = a5bq6a if quantity_harvested == .
	ren crop_code_harvest crop_code
	recode crop_code (811 812 = 810) (741 742 744 = 740) //810 is coffee, which is being reduced from different types to just coffee. Same for bananas (740).
	label define cropID 810 "Coffee" 740 "Bananas", modify //need to add new codes to the value label, cropID
	label values crop_code cropID //apply crop labels to crop_code
	rename a5aq6b condition_harv
	replace condition_harv = a5bq6b if condition_harv == .
	rename a5aq7b condition
	replace condition = a5bq7b if condition == .
	//JHG 1/20/2022: can't do any conversion without conversion factors, what they provide is very inconsistent within units (different conversion factors for same unit and crop). To get around this, we decided to use median values by crop, condition, and unit given what the survey provides.	
	
	*merging in conversion factors and generating value of harvest variables
	merge m:1 crop_code condition sold_unit_code using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_conv_fact_sold.dta", keep(1 3) gen(cfs_merge) // two thirds of observations report nothing sold, hence many aren't matched
	merge m:1 crop_code condition_harv unit_code using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_conv_fact_harv.dta", keep(1 3) gen(cfh_merge) 
	gen quant_sold_kg = sold_qty * conv_fact_sold_median if cfs_merge == 3
	gen quant_harv_kg = quantity_harvested * conv_fact_harv_median //not all harvested is sold, in fact most is not
	gen total_sold_value = price_unit * sold_qty
	gen value_harvest = price_unit * quantity_harvested
	rename price_unit val_unit
	gen val_kg = total_sold_value/quant_sold_kg if cfs_merge == 3
	
	*Generating plot weights, then generating value of both permanently saved and temporarily stored for later use
	merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keepusing(pweight) keep(1 3)
	gen plotweight = ha_planted * pweight
	gen obs = quantity_harvested > 0 & quantity_harvested != .
	foreach i in region district scounty_code parish_code ea hhid { //JHG 1_28_22: scounty_code and parish_code are not currently labeled, just numerical
preserve
	bys crop_code `i' : egen obs_`i'_kg = sum(obs)
	collapse (median) val_kg_`i' = val_kg  [aw = plotweight], by (`i' crop_code obs_`i'_kg)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore
}

preserve
collapse (median) val_kg_country = val_kg (sum) obs_country_kg = obs [aw = plotweight], by(crop_code)
tempfile val_kg_country_median
save `val_kg_country_median'
restore

foreach i in region district scounty_code parish_code ea hhid {
preserve
	bys `i' crop_code sold_unit_code : egen obs_`i'_unit = sum(obs)
	collapse (median) val_unit_`i' = val_unit [aw = plotweight], by (`i' sold_unit_code crop_code obs_`i'_unit)
	rename sold_unit_code unit_code //done for the merge a few lines below
	tempfile val_unit_`i'_median
	save `val_unit_`i'_median'
restore
	merge m:1 `i' unit_code crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' unit_code crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
}
preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit = obs [aw = plotweight], by(crop_code unit_code)
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore

merge m:1 unit_code crop_code using `price_unit_country_median', nogen keep(1 3)
merge m:1 unit_code crop_code using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)

*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea)
foreach i in country region district scounty_code parish_code ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_hhid if price_unit_hhid != .

foreach i in country region district scounty_code parish_code ea { 
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_hhid if val_unit_hhid != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_hhid if val_kg_hhid != . //Preferring household values where available.
	
//All that for these two lines that generate actual harvest values:
	replace value_harvest = val_unit * quantity_harvested if value_harvest == .
	replace value_harvest = val_kg * quant_harv_kg if value_harvest == .
	//Replacing conversions for unknown units
	replace val_unit = value_harvest / quantity_harvested if val_unit == .
preserve
	ren unit_code unit
	collapse (mean) val_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hh_crop_prices_for_wages.dta", replace
restore
		
*AgQuery
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field (max) months_grown, by(region district scounty_code parish_code ea hhid parcel_id plot_id season crop_code_master purestand field_size)
	bys hhid parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys hhid parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_all_plots.dta", replace


********************************************************************************
*CROP EXPENSES
******************************************************************************** 


//Purpose: Generate values for expenses of inputs. Includes hired labor, family labor, pesticides, rented machinery, land rent, and seeds. Not all inputs have expenses assigned to them due to data availability issues given what was asked in the survey.

/*This section has been formatted significantly differently from previous waves and the Tanzania template file (see also NGA W3 and TZA W3-5).
Previously, inconsistent nomenclature forced the complete enumeration of variables at each step, which led to accidental omissions messing with prices.
This section is designed to reduce the amount of code needed to compute expenses and ensure everything gets included. I accomplish this by 
taking advantage of Stata's "reshape" command to take a wide-formatted file and convert it to long (see help(reshape) for more info). The resulting file has 
additional columns for expense type ("input") and whether the expense should be categorized as implicit or explicit ("exp"). This allows simple file manipulation using
collapse rather than rowtotal and can easily be converted back into our standard "wide" format using reshape. 

*/
	*********************************
	* 			LABOR				*
	*********************************
	
	*Hired //Note: no information on the number of people, only person-days hired and total value (cash and in-kind) of daily wages
use "${Uganda_NPS_W5_raw_data}/AGSEC3A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W5_raw_data}/AGSEC3B.dta"
	replace season = 2 if season == .
	ren plotID plot_id
	ren parcelID parcel_id
	ren HHID hhid
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
	keep hhid parcel_id plot_id season *hired*
	drop wagehired

reshape long dayshired wagehired, i(hhid parcel_id plot_id season) j(gender) string
reshape long days wage, i(hhid parcel_id plot_id season gender) j(labor_type) string
	recode wage days (. = 0)
	drop if wage == 0 & days == 0
	gen val = wage*days

merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keep(1 3)
gen plotweight = weight * field_size //hh crossectional weight multiplied by the plot area
recode wage (0 = .)
gen obs = wage != .

*Median wages
foreach i in region district subcounty_name parish_name village ea hhid {
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

drop obs plotweight wage rural strataid clusterid
tempfile all_hired
save `all_hired'

//Family labor 

*This section combines both seasons and renames variables to be more useful
use "${Uganda_NPS_W5_raw_data}/AGSEC3A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W5_raw_data}/AGSEC3B.dta"
	replace season = 2 if season == .
	ren plotID plot_id
	ren HHID hhid
	ren parcelID parcel_id 
	ren a3aq33*_1 days_*
	replace days_a = a3bq33a_1 if days_a == .
	replace days_b = a3bq33b_1 if days_b == .
	replace days_c = a3bq33c_1 if days_c == .
	replace days_d = a3bq33d_1 if days_d == .
	replace days_e = a3bq33e_1 if days_e == .
	ren a3aq33* pid_*
	replace pid_ = a3bq33 if pid_ == .
	replace pid_a = a3bq33a if pid_a == .
	replace pid_b = a3bq33b if pid_b == .
	replace pid_c = a3bq33c if pid_c == .
	replace pid_d = a3bq33d if pid_d == .
	replace pid_e = a3bq33e if pid_e == .
	rename pid_ fam_worker_count
keep hhid parcel_id plot_id season pid* days_* fam_worker_count

preserve
use "${Uganda_NPS_W5_raw_data}/gsec2.dta", clear
gen male = h2q3 == 1
gen age = h2q8
keep hhid pid age male
destring pid, replace ignore ("P" "-") //need to destring so we can add it to the other data below, as it contains letters and characters not in the version we created above
isid hhid pid
tempfile members
save `members', replace
restore

reshape long pid days, i(hhid parcel_id plot_id season) j(colid) string
drop if days == .
merge m:1 hhid pid using `members', nogen keep(1 3) //JHG 5_12_22: 1,692 not matched from master (34,281 matched), unclear as to why. Most likely scenario is that the information was never collected for these individuals due to returning over multiple seasons. There is no additional info stored anywhere else. Avg days worked is ~18 (not insignificant). Unknown gender code will be generated to label null values.
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & male == 1
replace gender = "female" if strmatch(gender, "") & male == 0 
replace gender = "unknown" if strmatch(gender, "") & male == .
gen labor_type = "family"
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district subcounty_name parish_name village ea hhid parcel_id plot_id season gender days labor_type

foreach i in region district subcounty_name parish_name village ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //JHG 5_12_22: 1,692 with missing vals b/c they don't have matches on pid, see code above

	gen wage = wage_hhid
foreach i in country region district subcounty_name parish_name village ea {
	replace wage = wage_`i' if obs_`i' > 9
} //Goal of this loop is to get median wages to infer value of family labor as an implicit expense. Uses continually more specific values by geography to fill in gaps of implicit labor value.

egen wage_sd = sd(wage_hhid), by(gender season)
egen mean_wage = mean(wage_hhid), by(gender season)

replace wage = wage_hhid if wage_hhid != . & abs(wage_hhid - mean_wage) / wage_sd < 3 //Using household wage when available, but omitting implausibly high or low values. Changed about 6,700 hh obs, max goes from 500,000->500,000; mean 45,000 -> 41,000; min 10,000 -> 2,000

gen val = wage * days
append using `all_hired'
keep region district subcounty_name parish_name village ea hhid parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 parcel_id season plot_id hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(hhid parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_ = days, by (hhid parcel_id plot_id labor_type)
	reshape wide labor_, i(hhid parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_labor_days.dta",replace //AgQuery
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(hhid parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_labor.dta", replace //this gets used below.
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
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hh_cost_labor.dta", replace


	******************************************************************************
	** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
	******************************************************************************

	*** Pesticides/Herbicides
use "${Uganda_NPS_W5_raw_data}/AGSEC3A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W5_raw_data}/AGSEC3B.dta"
	replace season = 2 if season == .
	ren plotID plot_id
	ren parcelID parcel_id
	ren HHID hhid
	ren a3aq24a unitpesttotal //unit code for total pesticides used, first planting season (kg = 1, litres = 2)
	ren a3aq24b qtypesttotal //quantity of unit for total pesticides used, first planting season
	replace unitpesttotal = a3bq24a if unitpesttotal == . //add second planting season
	replace qtypesttotal = a3bq24b if qtypesttotal == . //add second planting season
	ren a3aq26 qtypestexp //amount of total pesticide that is purchased
	replace qtypestexp = a3bq26 if qtypestexp == . //add second planting season
	gen qtypestimp = qtypesttotal - qtypestexp //this calculates the non-purchased amount of pesticides used
	
	//JHG 6_14_22: 3 observations report purchasing more than they used, which is likely a misunderstanding or data entry issue. Will drop purchased amount to used amount, assuming that all used is purchased.
	replace qtypestexp = qtypesttotal if qtypestimp < 0
	replace qtypestimp = 0 if qtypestimp < 0
	
	ren a3aq27 valpestexp
	replace valpestexp = a3bq27 if valpestexp == .

//this survey does not ask about herbicide specifically, but considers pesticides and herbicides together

//JHG 6_14_22: barely any information collected on livestock inputs to crop agriculture. There are binary variables as to whether a house used their own livestock on their fields, but no collection of data about renting animal labor for a household. Some information (Section 11 in ag survey, question 5) about income from renting out their own animals is asked, but this is not pertinent to crop expenses. Animal labor can be a big expense, so we are creating explicit and implicit cost variables below but filling them with empty values.
	gen valanmlexp = .
	gen valanmlimp = .

//JHG 6_14_22: Information was collected on machinery inputs for crop expenses in section 10, but was only done at the household level. Other inputs are at the plot level.
	preserve //This section creates raw data on value of machinery/tools
	use "${Uganda_NPS_W5_raw_data}/AGSEC10.dta", clear
	drop if Farm_Implement == 2 //2 = no farm implement owned, rented, or used (separated by implement)
	ren a10q1 qtymechimp //number of owned machinery/tools
	ren a10q2 valmechimp //total value of owned machinery/tools, not per-item
	ren a10q7 qtymechexp //number of rented machinery/tools
	ren a10q8 valmechexp //total value of rented machinery/tools, not per-item
	ren HHID hhid
	collapse (sum) valmechimp valmechexp, by(hhid) //combine values for all tools, don't combine quantities since there are many varying types of tools 
	isid hhid //check for duplicate hhids, which there shouldn't be after the collapse
	tempfile rawmechexpense
	save `rawmechexpense', replace
	restore
	
	preserve
	use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas", clear
	collapse (sum) ha_planted, by(hhid)
	ren ha_planted ha_planted_total
	tempfile ha_planted_total
	save `ha_planted_total'
	restore
	
	preserve
	use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas", clear
	merge m:1 hhid using `ha_planted_total', nogen
	gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted
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
reshape long `stubs', i(hhid parcel_id plot_id season) j(exp) string
reshape long val qty unit, i(hhid parcel_id plot_id season exp) j(input) string
gen itemcode = 1
tempfile plot_inputs
save `plot_inputs'



	***Fertilizer
use "${Uganda_NPS_W5_raw_data}/AGSEC3A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W5_raw_data}/AGSEC3B.dta"
	replace season = 2 if season == .
	ren plotID plot_id
	ren parcelID parcel_id
	ren HHID hhid

	
//Inorganic fertilizer (all variables have "1" suffix)
	ren a3aq14 itemcodefert //what type of inorganic fertilizer (1 = nitrate, 2 = phosphate, 3 = potash, 4 = mixed); this can be used for purchased and non-purchased amounts
	replace itemcodefert = a3bq14 if itemcodefert == . //add second season

	ren a3aq15 qtyferttotal1 //quantity of inorganic fertilizer used; thankfully, only measured in kgs
	replace qtyferttotal1 = a3bq15 if qtyferttotal1 == . //add second season

	ren a3aq17 qtyfertexp1 //quantity of purchased inorganic fertilizer used; only measured in kgs
	replace qtyfertexp1 = a3bq17 if qtyfertexp1 == . //add second season

	ren a3aq18 valfertexp1 //value of purchased inorganic fertilizer used, not all fertilizer
	replace valfertexp1 = a3bq18 if valfertexp1 == . //add second season

	gen qtyfertimp1 = qtyferttotal1 - qtyfertexp1
	
//organic fertilizer (all variables have "2" suffix)
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

//JHG 6_15_22: no transportation costs are given; no subsidized fertilizer either

//Clean-up data
keep item* qty* val* hhid parcel_id plot_id season
drop if itemcodefert == .
gen dummya = 1
gen dummyb = sum(dummya) //dummy id for duplicates
drop dummya
unab vars : *2
local stubs : subinstr local vars "2" "", all
reshape long `stubs', i(hhid parcel_id plot_id season dummyb) j(entry_no)
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

//Create area planted tempfile for use at the end of the crop expenses section
use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

	***Land Rent
//Get parcel rent data
use "${Uganda_NPS_W5_raw_data}/AGSEC2B.dta", clear
	ren parcelID parcel_id
	ren HHID hhid
	ren a2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_rental", replace

//Calculate rented parcel area (in ha)
use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas", clear
	merge m:1 hhid parcel_id using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_rental", nogen keep (3)
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
replace val = valseason if valseason != . //2,110 observations changed, all parcel rent.
drop valseason
drop duplicate
gen unit = 1 //dummy var
gen itemcode = 1 //dummy var
tempfile plotrents
save `plotrents'


	***Seeds

//Clean up raw data and generate initial estimates	
use "${Uganda_NPS_W5_raw_data}/AGSEC4A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W5_raw_data}/AGSEC4B.dta"
	replace season = 2 if season == .
	ren plotID plot_id
	ren parcelID parcel_id
	ren HHID hhid
	ren cropID crop_code
	ren a4aq8 purestand //1 = pure stand, 2 = intercropped (or mixed) stand
	replace purestand = a4bq8 if purestand == . //add second season
	ren a4aq11a qtyseeds //includes all types of seeds (purchased, left-over, free, etc.)
	replace qtyseeds = abaq11a if qtyseeds == . //add second season
	ren a4aq11b unitseeds //includes all types of seeds (purchased, left-over, free, etc.)
	replace unitseeds = a4bq11b if unitseeds == . //add second season
	ren a4aq15	valseeds //only value for purchased seeds. There is no quantity for purchased seeds, so I cannot calculate per kg value of seeds.
	replace valseeds = a4bq15 if valseeds == . //add second season

keep unit* qty* val* crop_code purestand hhid parcel_id plot_id season
	gen dummya = 1
	gen dummyb = sum(dummya) //dummy id for duplicates, similar process as above for fertilizers
	drop dummya
	reshape long qty unit val, i(hhid parcel_id plot_id season dummyb) j(input) string
	collapse (sum) val qty, by(hhid parcel_id plot_id season unit input crop_code purestand)
	ren unit unit_code
	drop if qty == 0
	*drop input //there is only purchased value, none of it is implicit (free, left over, etc.)

//Convert quantities into kilograms
replace qty = qty * 2 if unit_code == 40 //Basket (2kgs): 25 changes
replace qty = qty * 120 if unit_code == 9 //Sack (120kgs): 27 changes
replace qty = qty * 20 if unit_code == 37 //Basket (20kgs): 7 changes
replace qty = qty * 10 if unit_code == 38 //Basket (10kgs): 12 changes
replace qty = qty / 1000 if unit_code == 2 //Gram: 104 changes
replace qty = qty * 5 if unit_code == 39 //Basket (5kgs): 34 changes
replace qty = qty * 100 if unit_code == 10 //Sack (100kgs): 531 changes
replace qty = qty * 80 if unit_code == 11 //Sack (80kgs): 160 changes
replace qty = qty * 50 if unit_code == 12 //Sack (50kgs): 105 changes
replace qty = qty * 2 if unit_code == 29 //Kimbo/Cowboy/Blueband Tin (2kgs): 65 changes
replace qty = qty * 0.5 if unit_code == 31 //Kimbo/Cowboy/Blueband Tin (0.5kgs): 477 changes
replace unit_code = 1 if inlist(unit_code, 2, 9, 10, 11, 12, 29, 31, 37, 38, 39, 40) //label them as kgs now

//JHG 6_27_22: no conversion factors (or even units for the last two) for Tin (20 lts) [1.94%] {code is 20}, Tin (5 lts) [0.34%] {code is 21}, Plastic basin (15 lts) [5.53%] {code is 22}, Bundle (6.7%) {code is 66}, Number of Units (General) [1.04%] {code is 85}, or Other Units (Specify) [4.16%] {code is 99}. This means a total of 19.71% of observations cannot be converted into kilograms. We can't use conversion factors from crops as seeds have different densities. Will use conversions derived from other sources in later code update

gen unit = 1 if unit_code == 1
replace unit = 2 if unit == .
replace unit = 0 if inlist(unit_code, 20, 21, 22, 66, 85, 99) //the units above that could not be converted will not be useful for price calculations

ren crop_code itemcode
collapse (sum) val qty, by(hhid parcel_id plot_id season input itemcode unit) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for.
gen exp = "exp"

//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_weights.dta",nogen keep(1 3) keepusing(weight)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_decision_makers.dta",nogen keep(1 3) keepusing(dm_gender)
tempfile all_plot_inputs
save `all_plot_inputs' //Woo, now we can estimate values.

//Calculating geographic medians
keep if strmatch(exp,"exp") & qty != . //Keep only explicit prices with actual values for quantity
gen plotweight = weight*field_size
recode val (0 = .)
drop if unit == 0 //Remove things with unknown units.
gen price = val/qty
drop if price == . //6,246 observations now remaining
gen obs = 1
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keep(1 3) //need to add in regional variables
drop strataid clusterid rural pweight parish_code scounty_code district_name

foreach i in region district subcounty_name parish_name village ea hhid {
preserve
	bys `i' input unit itemcode : egen obs_`i' = sum(obs)
	collapse (median) price_`i' = price [aw = plotweight], by (`i' input unit itemcode obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
} //this loop generates a temporary file for prices at the different geographic levels specified in the first line of the loop (region, district, etc.)

//Create national level median prices
preserve
bysort input unit itemcode : egen obs_country = sum(obs)
collapse (median) price_country = price [aw = plotweight], by(input unit itemcode obs_country)
tempfile price_country_median
save `price_country_median'
restore

//Combine all price information into one variable, using household level prices where available in enough quantities but replacing with the medians from larger and larger geographic areas to fill in gaps, up to the national level
use `all_plot_inputs', clear
merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keep(1 3) //need to add in regional variables
drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district subcounty_name parish_name village ea hhid {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_hhid (. = 0)
	gen price = price_hhid
foreach i in country region district subcounty_name parish_name village ea {
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
	collapse (sum) qty_ = qty, by(hhid parcel_id plot_id season input)
	reshape wide qty_, i(hhid parcel_id plot_id season) j(input) string
	ren qty_inorg inorg_fert_rate
	ren qty_orgfert org_fert_rate
	ren qty_pest pest_rate
	la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
	la var org_fert_rate "Qty organic fertilizer used (kg)"
	la var pest_rate "Qty of pesticide used (kg)"
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_input_quantities.dta", replace
restore

append using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_labor.dta"
collapse (sum) val, by (hhid parcel_id plot_id season exp input dm_gender)
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_cost_inputs_long.dta", replace 

preserve
	collapse (sum) val, by(hhid exp input) 
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hh_cost_inputs_long.dta", replace
restore

preserve
	collapse (sum) val_ = val, by(hhid parcel_id plot_id season exp dm_gender)
	reshape wide val_, i(hhid parcel_id plot_id season dm_gender) j(exp) string
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_cost_inputs.dta", replace //This gets used below.
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
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
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
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hh_cost_inputs_verbose.dta", replace


//We can do this more simply by:
use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_cost_inputs_long.dta", clear
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
merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
merge m:1 hhid parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid)
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hh_cost_inputs.dta", replace
	

********************************************************************************
*MONOCROPPED PLOTS
********************************************************************************

//Purpose: Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots


//Setting things up for AgQuery first
use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_all_plots.dta", clear
	keep if purestand == 1 //1 = monocropped
	ren crop_code_master cropcode
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_monocrop_plots.dta", replace


use "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_all_plots.dta", clear
	keep if purestand == 1 //1 = monocropped
	//File now has 7237 unique entries - it should be noted that some these were grown in mixed plots and 12 crops report no kg harvested. Which is confusing.
	merge 1:1 hhid plot_id season using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren crop_code_master cropcode
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
	drop if `cn'_monocrop_ha == 0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop = 1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_`cn'_monocrop.dta", replace
	
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
	collapse (sum) *monocrop* kgs_harv* val_harv*, by(hhid season)
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_`cn'_monocrop_hh_area.dta", replace
restore
}


********************************************************************************
*TLU (Tropical Livestock Units)
********************************************************************************

/*
Purpose: 
1. Generate coefficients to convert different types of farm animals into the standardized "tropical livestock unit," which is usually based around the weight of an animal (kg of meat) [JHG 12_30_21: double-check the units after recoding].

2. Generate variables whether a household owns certain types of farm animals, both currently and over the past 12 months, and how many they own. Separate into pre-specified categories such as cattle, poultry, etc. Convert into TLUs

3. Grab information on livestock sold alive and calculate total value.
*/


//Step 1: Create three TLU coefficient .dta files for later use, stripped of HHIDs

*For livestock
use "${Uganda_NPS_W5_raw_data}/AGSEC6A.dta", clear
rename LiveStockID livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W5_created_data}/tlu_livestock.dta", replace

*for small animals
use "${Uganda_NPS_W5_raw_data}/AGSEC6B.dta", clear
rename ALiveStock_Small_ID livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W5_created_data}/tlu_small_animals.dta", replace

*For poultry and misc.
use "${Uganda_NPS_W5_raw_data}/AGSEC6C.dta", clear
rename APCode livestockid
gen tlu_coefficient = 0.01  // This includes chicken (all kinds), turkey, ducks, geese, and rabbits)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${Uganda_NPS_W5_created_data}/tlu_poultry_misc.dta", replace

*Combine 3 TLU .dtas into a single .dta
use "${Uganda_NPS_W5_created_data}/tlu_livestock.dta", clear
append using "${Uganda_NPS_W5_created_data}/tlu_small_animals.dta"
append using "${Uganda_NPS_W5_created_data}/tlu_poultry_misc.dta"
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - Cows" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid //JHG 12_30_21: have to reassign labels to values after append (possibly unnecessary since this is an intermediate step, don't delete code though because it is necessary)
save "${Uganda_NPS_W5_created_data}/tlu_all_animals.dta", replace


//Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${Uganda_NPS_W5_raw_data}/AGSEC6A.dta", clear
append using "${Uganda_NPS_W5_raw_data}/AGSEC6B.dta"
append using "${Uganda_NPS_W5_raw_data}/AGSEC6C.dta"
gen livestockid = LiveStockID
replace livestockid = ALiveStock_Small_ID if livestockid == .
replace livestockid = APCode if livestockid == .
drop LiveStockID ALiveStock_Small_ID APCode
merge m:m livestockid using "${Uganda_NPS_W5_created_data}/tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
rename HHID hhid
sort hhid livestockid //Put back in order

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

gen num_cattle_now = livestock_number_now if cattle == 1
gen num_cows_now = livestock_number_now if cows == 1
gen num_smallrum_now = livestock_number_now if smallrum == 1
gen num_poultry_now = livestock_number_now if poultry == 1
gen num_chickens_now = livestock_number_now if chickens == 1
gen num_other_now = livestock_number_now if otherlivestock == 1
gen num_tlu_now = livestock_number_now * tlu_coefficient

*Generate "number of animals" variable per livestock category and household (12 Months Before Survey)
rename a6aq6 ls_number_past
rename a6bq6 sa_number_past
rename a6cq6 po_number_past
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
rename a6aq14b ls_avgvalue
rename a6bq14b sa_avgvalue
rename a6cq14b po_avgvalue
rename a6aq14a num_ls_sold
rename a6bq14a num_sa_sold
rename a6cq14a num_po_sold

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

//JHG 12_30_21: lots of opportunities for loops above here to clean up the code

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
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_TLU_Coefficients.dta", replace

	
********************************************************************************
*SELF-EMPLOYMENT INCOME //JHG 4_5_22: finished this indicator
********************************************************************************
//Purpose: This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. This includes profit from business, X, and X.

*Generate profit from business activities (revenue net of operating costs)
use "${Uganda_NPS_W5_raw_data}/gsec12_2.dta", clear
ren h12q12 months_activ // how many months did the business operate
replace months_activ = 12 if months_activ > 12 & months_activ != . //1 change made
ren h12q13 monthly_revenue // avg monthly gross revenues when active
ren h12q15 wage_expense // avg expenditure on wages
ren h12q16 materials_expense // avg expenditures on raw materials
ren h12q17 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (. = 0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit != . // JHG 4_5_22: W5 has some hhs with negative profit (10)
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (. = 0)
ren hhid HHID
collapse (sum) annual_selfemp_profit, by (HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_self_employment_income.dta", replace

*Processed crops
//Not captured in w5 instrument (or other UGA waves)

*Fish trading
//Not captured in w5 instrument (or other UGA waves)


********************************************************************************
*OFF-FARM HOURS
********************************************************************************

//Purpose: This indicator is meant to create variables related to the amount of hours per-week (based on the 7 days prior to the survey) that household members individually worked at primary and secondary income-generating activities (i.e., jobs).

use "${Uganda_NPS_W5_raw_data}\gsec8.dta", clear
*Use ISIC codes for non-farm activities
gen h8q19b_twoDigit = substr(h8q19B,1,2) //convert existing job codes into two-digit versions by dropping the third and fourth digit - this essentially moved the job codes up from more specific to more general categories
destring h8q19b_twoDigit, replace //convert string to numeric variable

egen primary_hours = rowtotal (h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) if (h8q19b_twoDigit < 61 | (h8q19b_twoDigit > 63 & h8q19b_twoDigit < 92) | h8q19b_twoDigit > 92) //Based on ISCO classifications used in Basic Information Document used for Wave 8 //JHG 4_12_22: did not change the if statement at all, unsure if they carry over to W5 or if there were changes between W5 and W8 to these codes
rename h8q43 secondary_hours //unlike the primary (or main) job, this is not split out day-by-day, just a weekly total

egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours != 0
gen member_count = 1
rename hhid HHID
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)

lab var member_count "Number of HH members age 5 or above"
lab var off_farm_any_count "Number of HH members with positive off-farm hours"
lab var off_farm_hours "Total household off-farm hours"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_w5_off_farm_hours.dta", replace //JHG 4_12_22: do we need to drop all of the other questions/variables that are included here? Doesn't seem like it has been done in the past.


********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************

//Purpose: To develop variables related to milk production of respondents. It is not limited to just cows but contains milk production data from all large ruminants. Variables developed include number of animals milked, number of months and days they are milked (days are estimated if not available), and the number of liters of milk obtained per large ruminant. This data won't consider HHs that had large ruminants but did not use them to get milk.

*Total production
**adapted from w3 & w8 code
use "${Uganda_NPS_W5_raw_data}/AGSEC8B.dta", clear
keep if AGroup_ID == 101 | AGroup_ID == 105 //We're keeping only large ruminants (both exotic/cross & indigenous) - can't limit to just cows
gen milk_animals = a8bq1 //how many animals were milked in the last 12 months?

gen months_milked = a8bq2 // number of months milked
gen days_milked = months_milked * 30.5 // no days milked, but can create est.
gen liters_day_perlargeruminant = a8bq3 // avg milk prod. per day per animal
gen liters_year_perlargeruminant = liters_day_perlargeruminant * days_milked // getting estimated total milk production over a year per animal. 
gen liters_year_tot = liters_year_perlargeruminant * milk_animals // total liters produced over a year
keep HHID milk_animals months_milked days_milked liters_year_perlargeruminant liters_day_perlargeruminant liters_year_tot
label variable milk_animals "Number of large ruminants that were milked (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day_perlargeruminant "Average milk production  (liters) per day per milked animal (household)"
label variable liters_year_perlargeruminant "Average quantity (liters) per year per milked animal (household)"
label variable liters_year_tot "Average quantity (liters) per year (household)"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_w5_milk_animals.dta", replace


********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************

//Purpose: To create variables around egg production by poultry owned by the farmers. These variables include eggs per 3 month period (quarterly), eggs per year (here this is estimated), number of poultry owned.

use "${Uganda_NPS_W5_raw_data}/AGSEC6C", clear
egen poultry_owned = rowtotal(a6cq3a) if inlist(APCode, 23, 24, 25, 26) //these codes all include types of poultry, essentially we are just excluding rabbits here
collapse (sum) poultry_owned, by(HHID) //JHG 4_12_22: 99.9% of responses under 400 (most under 100), but one observation indicates 1,162 poultry owned. Remove?

tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${Uganda_NPS_W5_raw_data}/AGSEC8C.dta", clear
gen eggs_per_3months = a8cq2 // "How many eggs did you produce in the last 3 months"		
collapse (sum) eggs_per_3months, by(HHID)
gen eggs_total_year_est = eggs_per_3months * 4 //we have eggs per 3 months but not months producing. Estimate of 3 months times 4, but assumes same rate of egg production throughout the year

merge 1:1 HHID using `eggs_animals_hh', nogen keep(1 3)			
keep HHID eggs_per_3months eggs_total_year_est poultry_owned 
lab var eggs_per_3months "Number of months eggs that were produced per 3 months (household)"
lab var eggs_total_year_est "Estimated total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${Uganda_NPS_W5_created_data}/Uganda_NPS_w5_eggs_animals.dta", replace


