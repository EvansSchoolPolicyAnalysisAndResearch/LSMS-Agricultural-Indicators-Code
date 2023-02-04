/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 3 (2011-12)
*Author(s)		: Didier Alia,  C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, David Coomes, 
				  Elan Ebeling, Kelsey Figone, Nina Forbes, Nida Haroon Muel Kiel, Anu Sidhu, Isabella Sun, Emma Weaver, Ayala Wineman, Sebastian Wood,
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: This Version - 4 January 2021

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period November 2011 - November 2012.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2059

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
*Using data files from within the "/Raw Data" folder within the "/Uganda - Wave 3 - 2011-12" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "/temp" within the "/Uganda - Wave 3 - 2011-12" folder. 
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "/outputs" within the "/Uganda - Wave 3 - 2011-12" folder. //EFW 1.22.19 Update this with new file path 

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager or farm size.
*The results are outputted in the excel file "" in the "" within the "" folder. 
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_LSMS_ISA_W3_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_LSMS_ISA_W3_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_LSMS_ISA_W3_hhsize.dta
*PARCEL AREAS						Uganda_NPS_LSMS_ISA_W3_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Uganda_NPS_LSMS_ISA_W3_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_LSMS_ISA_W3_tempcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W3_tempcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W3_permcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W3_permcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W3_hh_crop_production.dta
									Uganda_NPS_LSMS_ISA_W3_plot_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W3_parcel_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W3_crop_residues.dta
									Uganda_NPS_LSMS_ISA_W3_hh_crop_prices.dta
									Uganda_NPS_LSMS_ISA_W3_crop_losses.dta
*CROP EXPENSES						Uganda_NPS_LSMS_ISA_W3_wages_mainseason.dta
									Uganda_NPS_LSMS_ISA_W3_wages_shortseason.dta
									Uganda_NPS_LSMS_ISA_W3_fertilizer_costs.dta
									Uganda_NPS_LSMS_ISA_W3_seed_costs.dta
									Uganda_NPS_LSMS_ISA_W3_land_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W3_asset_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W3_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_LSMS_ISA_W3_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_LSMS_ISA_W3_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W3_livestock_expenses.dta
									Uganda_NPS_LSMS_ISA_W3_hh_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W3_livestock_sales.dta
									Uganda_NPS_LSMS_ISA_W3_TLU.dta
									Uganda_NPS_LSMS_ISA_W3_livestock_income.dta

*FISH INCOME						Uganda_NPS_LSMS_ISA_W3_fishing_expenses_1.dta
									Uganda_NPS_LSMS_ISA_W3_fishing_expenses_2.dta
									Uganda_NPS_LSMS_ISA_W3_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Uganda_NPS_LSMS_ISA_W3_self_employment_income.dta
									Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta
									Uganda_NPS_LSMS_ISA_W3_fish_trading_revenue.dta
									Uganda_NPS_LSMS_ISA_W3_fish_trading_other_costs.dta
									Uganda_NPS_LSMS_ISA_W3_fish_trading_income.dta
									
*WAGE INCOME						Uganda_NPS_LSMS_ISA_W3_wage_income.dta
									Uganda_NPS_LSMS_ISA_W3_agwage_income.dta
									
*OTHER INCOME						Uganda_NPS_LSMS_ISA_W3_other_income.dta
									Uganda_NPS_LSMS_ISA_W3_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_LSMS_ISA_W3_land_size.dta
									Uganda_NPS_LSMS_ISA_W3_farmsize_all_agland.dta
									Uganda_NPS_LSMS_ISA_W3_land_size_all.dta
									
*FARM LABOR							Uganda_NPS_LSMS_ISA_W3_farmlabor_mainseason.dta
									Uganda_NPS_LSMS_ISA_W3_farmlabor_shortseason.dta
									Uganda_NPS_LSMS_ISA_W3_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_LSMS_ISA_W3_vaccine.dta

*USE OF INORGANIC FERTILIZER		Uganda_NPS_LSMS_ISA_W3_fert_use.dta

*USE OF IMPROVED SEED				Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta

*REACHED BY AG EXTENSION			Uganda_NPS_LSMS_ISA_W3_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_LSMS_ISA_W3_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_LSMS_ISA_W3_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W3_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W3_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_LSMS_ISA_W3_hh_cost_land.dta
									Uganda_NPS_LSMS_ISA_W3_hh_cost_inputs_lrs.dta
									Uganda_NPS_LSMS_ISA_W3_hh_cost_inputs_srs.dta
									Uganda_NPS_LSMS_ISA_W3_hh_cost_seed_lrs.dta
									Uganda_NPS_LSMS_ISA_W3_hh_cost_seed_srs.dta		
									Uganda_NPS_LSMS_ISA_W3_cropcosts_perha.dta
									
*AGRICULTURAL WAGES					Uganda_NPS_LSMS_ISA_W3_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_LSMS_ISA_W3_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_LSMS_ISA_W3_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_LSMS_ISA_W3_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_LSMS_ISA_W3_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_LSMS_ISA_W3_ownasset.dta

*CROP YIELDS						Uganda_NPS_LSMS_ISA_W3_yield_hh_crop_level.dta

*FINAL FILES CREATED						
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_LSMS_ISA_W3_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_LSMS_ISA_W3_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_LSMS_ISA_W3_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_LSMS_ISA_W3_summary_stats.xlsx
*/

clear
clear matrix	
clear mata			
set more off
set maxvar 8000		
ssc install findname  // need this user-written ado file for some commands to work //335

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global root_folder "//netid.washington.edu/wfs/EvansEPAR/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave3-2011-12"
*global root_folder "/Volumes/wfs/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave3-2011-12"
*global root_folder "R:/Project/EPAR/Working Files/378 - LSMS Burkina Faso, Malawi, Uganda/uganda-wave3-2011-12"

global UGS_W3_raw_data 	"${root_folder}/raw_data"
global UGS_W3_created_data "${root_folder}/temp"
global UGS_W3_final_data  "${root_folder}/outputs"


****************************
*EXCHANGE RATE AND INFLATION
**************************** 

global NPS_LSMS_ISA_W3_exchange_rate 3690.85     // to be updated
global NPS_LSMS_ISA_W3_gdp_ppp_dollar 994.607    // https://data.worldbank.org/indicator/PA.NUS.PPP // for 2012
global NPS_LSMS_ISA_W3_cons_ppp_dollar 1045.316	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP for 2012
global NPS_LSMS_ISA_W3_inflation  0.1267 // (131.344-116.565)/116.565 https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2016&locations=UG&start=2010

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//Threshold for winzorization at the top of the distribution of continous variables


/*
********************************************************************************
RE-SCALING SURVEY WEIGHTS TO MATCH POPULATION ESTIMATES
********************************************************************************
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

*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum fmillt grdnt beans yam swtptt cassav banana cotton sunflr coffee irptt" //JHG: added coffee (Robusta/Arabica), finger millet, and irish potatoes as they are all in the top 10 for Uganda (and pearl millet is not grown there)
*global topcropname_area "maize rice wheat sorgum fmillt cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea coffee irptt" // SAW Original code - we take cowpea and pigpea out to run code
global topcrop_area "130 120 111 150 141 310 210 640 620 630 740 520 330 810 610"
global comma_topcrop_area "130, 120, 111, 150, 141, 310, 210, 640, 620, 630, 740, 520, 330, 810, 610"
global topcropname_area_full "maize rice wheat sorghum fingermillet groundnut beans yam sweetpotato cassava banana cotton sunflower coffee irishpotato"
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropname_table.dta", replace //This gets used to generate the monocrop files.

********************************************************************************
*HOUSEHOLD IDS*
********************************************************************************
use "${UGS_W3_raw_data}/GSEC1.dta", clear
ren h1aq1 district
ren h1aq2 county
ren h1aq3 subcounty 
ren h1aq4 parish
ren comm ea
ren mult weight
gen rural=urban==0
keep region district county subcounty parish ea HHID rural regurb weight // excludes stratum Q. Don't have break down on county and county name, parish and parish name
lab var rural "1 = Household lives in rural area"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", replace


********************************************************************************
*WEIGHTS*
********************************************************************************
use "${UGS_W3_raw_data}/GSEC1.dta", clear
rename mult weight 
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta"
keep HHID weight rural
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", replace


********************************************************************************
*INDIVIDUAL IDS*
********************************************************************************
use "${UGS_W3_raw_data}/GSEC2.dta", clear
gen female=h2q3==2 // sex=h2q3==2 is female
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "Individual age"
gen hh_head=h2q4==1 // relationship to hh head
lab var hh_head "1= individual is household head"
keep HHID PID female age hh_head
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", replace

********************************************************************************
*HOUSEHOLD SIZE*
********************************************************************************
use "${UGS_W3_raw_data}/GSEC2.dta", clear
gen hh_members = 1
ren h2q4 relhead //relationship to HH head
ren h2q3 gender // sex
gen fhh = (relhead==1 & gender==2) // EFW changed this to relhead==1. We want just the households where the head is listed as a female, even if this is a small number
collapse (sum) hh_members (max) fhh, by (HHID)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", replace

********************************************************************************
*PLOT AREA*
********************************************************************************
*SAW 2.18.22 I might need to recode this section to create field_size variable required to code All Plot section. We need field size at the plot level, currently only at parcel level. By using area planted size as a % of total area planted size per parcel we might be able to proxy field size at the plot level. 
use "${UGS_W3_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B.dta", generate(last)		
replace season=2 if last==1
label var season "Season = 1 if 1st cropping season of 2011, 2 if 2nd cropping season of 2011"
gen plot_area=a4aq7 //values are in acres (Total area of plot planted) a4aq9 percentage of crop planted in the plot area 
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
replace percent_planted = 1 if percent_planted == . & any_missing == 0 
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
merge m:1 HHID parcelID using "${UGS_W3_raw_data}/AGSEC2A.dta", nogen
merge m:1 HHID parcelID using "${UGS_W3_raw_data}/AGSEC2B.dta"
*generating field_size
generate parcel_acre = a2aq4 
replace parcel_acre = a2bq4 if parcel_acre == . 
replace parcel_acre = a2aq5 if parcel_acre == . 
replace parcel_acre = a2bq5 if parcel_acre == . 
gen field_size = plot_area_pct*parcel_acre //using calculated percentages of plots (out of total plots per parcel) to estimate plot size using more accurate parcel measurements
replace field_size = field_size * 0.404686 //conversion factor is 0.404686 ha = 1 acre.
gen parcel_ha = parcel_acre * 0.404686
*cleaning up and saving the data
rename plotID plot_id
rename parcelID parcel_id
keep HHID parcel_id plot_id season field_size plot_area total_plot_area parcel_acre ha_planted parcel_ha
drop if field_size == .
label var field_size "Area of plot (ha)"
label var HHID "Household identifier"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", replace

********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${UGS_W3_raw_data}/GSEC2.dta", clear
ren PID personid			
gen female =h2q3==2
ren h2q8 age
gen head = h2q4==1 if h2q4!=. 
keep personid female age HHID head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", replace

use "${UGS_W3_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
ren plotID plot_id
ren parcelID parcel_id // using parcel ID 
drop if plot_id == . 

replace a3aq3_3 = a3bq3_3 if a3aq3_3==.
tostring a3aq3_3, gen(personid) format(%18.0f) 
tostring HHID, format(%18.0f) replace

merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", gen(dm1_merge) keep(1 3) //6,021 matched, 8,008 unmatched from master //ALT: 6018/8011


*First decision-maker variables
gen dm1_female = female
drop female personid

*Second decision-maker 
ren a3aq3_4a personid
replace personid =a3bq3_4a if personid==. &  a3bq3_4a!=.
tostring personid, format(%18.0f) replace
merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", gen(dm2_merge) keep(1 3) //7,652 matched, 6,377 unmatched from master //ALT: 7627/6402
gen dm2_female = female
drop female personid

*Third decision-maker 
ren a3aq3_4b personid
replace personid =a3bq3_4b if personid==. &  a3bq3_4b!=.
tostring personid, format(%18.0f) replace
merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", gen(dm3_merge) keep(1 3) //7,646 matched, 6,383 unmatched from master //ALT: 7630/6399
gen dm3_female = female
drop female personid

//EFW 6.5.19 Currently need season to uniquely identify, but need to collapse to the plot level for later code
//EFW 6.5.19 Collapse to plot level before we create 3-part gendered decision-maker variable
collapse (max) dm1_female dm2_female dm3_female, by (HHID parcel_id plot_id season)

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", nogen 							
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
*replace parcel_id = parcelID if parcel_id==. & parcelID!=.
drop if  plot_id==.
count if parcel_id ==. //6 //ALT: 6
drop if parcel_id == .
 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", replace


//EFW 4.18.19 adding an area planted section since the plot areas section doesn't include information on area planted (which we need below)

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen formal_land_rights = 1 if a2aq23<4
replace formal_land_rights = 0 if a2aq23==4 // SAW 1.31.23 Here I added this line for HH w/o documents as zero (prior we only had 1's and missing information)

*Starting with first owner
preserve 
tostring a2aq24a, gen(PID) format(%18.0f) 
tostring HHID, format(%18.0f) replace
merge m:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen keep(3)	// PID string and HHID+PID formatted 
keep HHID PID female formal_land_rights
tempfile p1
save `p1', replace
restore

*Now second owner
preserve 
tostring a2aq24b, gen(PID) format(%18.0f) 
tostring HHID, format(%18.0f) replace
merge m:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen keep(3)	// PID string and HHID+PID formatted 
keep HHID PID female formal_land_rights
append using `p1'
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(HHID PID)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_ind.dta", replace
restore

preserve
collapse (max) formal_land_rights_hh=formal_land_rights, by(HHID)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_hh.dta", replace
restore
********************************************************************************
** 								ALL PLOTS									  **
********************************************************************************
************************
*SAW 02.03.2022 Coding All plots using NGA and UGA W5 code as reference. Purpose: Agquery+ 

/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.

*/
*Notes: Must check that current subsections coded have  not already been coded in later sections. 
**********************************
** Crop Values **
**********************************
use "${UGS_W3_raw_data}/AGSEC5A", clear 
append using "${UGS_W3_raw_data}/AGSEC5B"
gen sold_qty=a5aq7a
gen season=1 if sold_qty!=.
replace sold_qty=a5bq7a if sold_qty==.
replace season = 2 if season == . & a5bq7a != .
*rename a5aq7a sold_qty
clonevar unit_code=a5aq6c
replace unit_code=a5bq6c if unit_code==.
gen sold_unit_code=a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
gen sold_value=a5aq8
replace sold_value=a5bq8 if sold_value==. // SAW 05.05.22 It seems like the var a5aq8 "What was the value?" refers to total value of the crop sold in contrast to UG W5 that shows price unit. 
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keepusing(region district county subcounty parish ea weight)
*rename HHID hhid
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code
gen price_unit=sold_value/sold_qty
label var price_unit "Average sold value per crop unit"
gen obs = price_unit!=.
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_value.dta", replace 
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
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_value.dta", replace 
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity==.
*rename a5aq6a quantity
clonevar condition_harv=a5aq6b
replace condition_harv=a5bq6b if condition==.
*rename a5aq6b condition
clonevar conv_fact_harv_raw= a5aq6d
replace conv_fact_harv_raw=a5bq6d if conv_fact_harv_raw==.
*rename a5aq6d conv_fact_raw
recode crop_code  (741 742 744 = 740) (221 222 223 224 = 220) //  Same for bananas (740) and peas (220).
label define cropID 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master
collapse (median) conv_fact_harv_raw, by (crop_code condition_harv unit_code)
rename conv_fact_harv_raw conv_fact_median
lab var conv_fact_median "Median value of supplied conversion factor by crop type, condition, and unit code"
drop if conv_fact_med == . | crop_code == . | condition == .
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_conv_fact_harv.dta", replace 

*Create conversion factors for sold crops (this is exactly the same with different variable names for use with merges later)
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_value.dta", replace 
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity==.
*rename a5aq6a quantity
clonevar condition_harv=a5aq6b
replace condition_harv=a5bq6b if condition==.
*rename a5aq6b condition
clonevar conv_fact_harv_raw= a5aq6d
replace conv_fact_harv_raw=a5bq6d if conv_fact_harv_raw==.
*rename a5aq6d conv_fact_raw
recode crop_code  (741 742 744 = 740) (221 222 223 224 = 220) // Which is being reduced from different types to just coffee. Same for bananas (740) and peas (220).
label define cropID 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master
collapse (median) conv_fact_harv_raw, by (crop_code condition_harv unit_code)
rename conv_fact_harv_raw conv_fact_sold_median
lab var conv_fact_sold_median "Median value of supplied conversion factor by crop type, condition, and unit code"
drop if conv_fact_sold_median == . | crop_code == . | condition_harv == .
rename unit_code sold_unit_code //done to make a merge later easier, at this point it just represents an abstract unit code
*rename condition_harv condition //again, done to make a merge later easier
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_conv_fact_sold.dta", replace 

**********************************
** Plot Variables **
**********************************
*Clean up file and combine both seasons
use "${UGS_W3_raw_data}/AGSEC4A", clear 
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season=2 if season==.
*rename HHID hhid
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code_plant //crop codes for what was planted
drop if crop_code_plant == .
clonevar crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
recode crop_code_master  (741 742 744 = 740) (221 222 223 224 = 220) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
label define L_CROP_LIST 740 "Bananas" 220 "Peas", modify //need to add new codes to the value label, cropID
label values crop_code_master L_CROP_LIST //apply crop labels to crop_code_master
tostring HHID, format(%18.0f) replace
*Merge area variables (now calculated in plot areas section earlier)
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3)	

*Creating time variables (month planted, harvested, and length of time grown)
gen month_planted = Crop_Planted_Month 
replace month_planted = Crop_Planted_Month2 if season==2
replace month_planted=. if month_planted==99 //no changes
lab var month_planted "Month of planting relative to December year_planted (both cropping seasons)" // we have a variable with the year as well which is different than w5 actually w5 also has the year variable might want to check with Josh
gen year_planted = 2010 if Crop_Planted_Year==1 | (Crop_Planted_Year2==1 & season==2)
replace year_planted= 2011 if Crop_Planted_Year==2 | (Crop_Planted_Year2==2 & season==2)
merge m:m HHID parcel_id plot_id  /*crop_code */ season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_value.dta", nogen keep(1 3)
rename crop_code crop_code_harvest
drop if crop_code_harvest == . 
gen month_harvest = a5aq6e 
replace month_harvest = a5bq6e if season==2 
lab var month_harvest "Month of planting relative to December 2011 (both cropping seasons)"
gen edate_harvest=mdy(month_harvest,1,2011)
gen edate_planted=mdy(month_planted,1,year_planted)
gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop" 
gen months_grown = month_harvest - month_planted if perm_tree == 0 //If statement removes permanent crops from consideration. JHG 12_31_21: results in some negative values. These likely are typos (putting the wrong year) because the timeline would lineup correctly based on the crop if the years were 2015 instead of 2014 for harvesting. Attempt to fix above corrected some entries but not all. Rest are removed in next line.
gen month_grown = (edate_harvest-edate_planted)/30.437
replace month_grown = round(month_grown,1)
replace month_grown = . if month_grown < 1 | edate_planted == . | edate_harvest == .

*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(a5aq17,1,4) | inrange(a5bq17,1,5) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
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
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) 
	gen replanted = (max_lost == 1 & crops_plot > 0)
	drop if replanted == 1 & lost_crop == 1 //Crop expenses should count toward the crop that was kept, probably. 89 plots did not replant; keeping and assuming yield is 0.

	*Generating monocropped plot variables (Part 1)
	bys HHID parcel_id plot_id season: egen crops_avg = mean(crop_code_master) //Checks for different versions of the same crop in the same plot and season
	gen purestand = 1 if crops_plot == 1 //This includes replanted crops
	bys HHID parcel_id plot_id season : egen permax = max(perm_tree)
	bys HHID parcel_id plot_id season Crop_Planted_Month Crop_Planted_Year Crop_Planted_Month2 Crop_Planted_Year2 : gen plant_date_unique = _n
	*replace plant_date_unique = . if a4aq9_1 == 99 | a4bq9_1 == 99 //JHG  1_12_22: added this code to remove permanent crops with unknown planting dates, so they are omitted from this analysis SAW No Unknow planting dates
	bys HHID parcel_id plot_id season a5aq6e a5bq6e : gen harv_date_unique = _n // SAW harvest was all in the same year (2011)
	bys HHID parcel_id plot_id season : egen plant_dates = max(plant_date_unique)
	bys HHID parcel_id plot_id season : egen harv_dates = max(harv_date_unique)
	replace purestand = 0 if (crops_plot > 1 & (plant_dates > 1 | harv_dates > 1)) | (crops_plot > 1 & permax == 1) //Multiple crops planted or harvested in the same month are not relayed; may omit some crops that were purestands that preceded or followed a mixed crop
	
	*Generating mixed stand plot variables (Part 2)
	gen mixed = (a4aq8 == 2 | a4bq8 == 2)
	bys HHID parcel_id plot_id season : egen mixed_max = max(mixed)
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0 SAW Should we assume null values are intercropped?  or maybe missing information??
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys HHID parcel_id plot_id season: egen total_percent = total(percent_field)

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

	
	*merging in conversion factors and generating value of harvest variables
	merge m:1 crop_code condition_harv sold_unit_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_conv_fact_sold.dta", keep(1 3) gen(cfs_merge) 
	merge m:1 crop_code condition_harv unit_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_conv_fact_harv.dta", keep(1 3) gen(cfh_merge) 
	gen quant_sold_kg = sold_qty * conv_fact_sold_median if cfs_merge == 3
	gen quant_harv_kg = quantity_harvested * conv_fact_median //not all harvested is sold, in fact most is not
	gen total_sold_value = price_unit * sold_qty
	gen value_harvest = price_unit * quantity_harvested
	rename price_unit val_unit
	gen val_kg = total_sold_value/quant_sold_kg if cfs_merge == 3
	
	*Generating plot weights, then generating value of both permanently saved and temporarily stored for later use
	merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keepusing(weight) keep(1 3)
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_median_country.dta", replace //This gets used for self-employment income
restore

merge m:1 unit_code crop_code using `price_unit_country_median', nogen keep(1 3)
merge m:1 unit_code crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)

*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
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
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_for_wages.dta", replace
	restore
		
*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field (max) month_grown, by(region district county subcounty parish ea HHID parcel_id plot_id season crop_code_master purestand field_size)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace


********************************************************************************
** 								ALL PLOTS END								  **
********************************************************************************

********************************************************************************
** 								GROSS CROP REVENUE							  **
********************************************************************************
*Temporary crops (both seasons)
use "${UGS_W3_raw_data}/AGSEC5A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC5B.dta"

rename parcelID parcel_id
rename plotID plot_id
ren cropID crop_code //EFW 6.4.19 change to crop_code since that's what we use later on
drop if plot_id == . 

//EFW 6.2.19 Stopped Here; check DYA code
rename a5aq6a qty_harvest 
replace qty_harvest = a5bq6a if qty_harvest==. 
rename a5aq6d conversion
replace conversion = a5bq6d if conversion==. & a5bq6d!=.
gen kgs_harvest = qty_harvest * conversion

ren a5aq7a qty_sold 
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 

*Calculate kgs sold 
ren A5AQ7D conversion_sold
replace conversion_sold = A5BQ7D if conversion_sold == . //EFW 6.4.19
gen kgs_sold = qty_sold * conversion_sold
ren a5aq8 value_sold //Assuming value for quantity sold 
replace value_sold = a5bq8 if value_sold == . //EFW 6.4.19
collapse (sum) kgs_harvest kgs_sold value_sold qty_sold, by (HHID parcel_id plot_id crop_code)
lab var kgs_harvest "Kgs harvest of this crop"
lab var kgs_sold "Kgs sold of this crop"
lab var value_sold "Value sold of this crop"

*Price per kg
gen price_kg = value_sold/kgs_sold
lab var price_kg "price per kg sold"
recode price_kg (0=.)
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta" // Getting an error that HHID is double in master but string in data. How to fix this? //ALT 10.25.19 - converted HHID to string
drop if _merge==2 //638 observations not matched from using //ALT: I got 661 from using and 15970 matched
drop _merge

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", replace
//ALT 12.2.19: Looks like this section works, but sometimes crops that are not harvested are sold.


*Impute crop prices from sales
//median price at the ea level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region district county subcounty parish ea crop_code: egen obs_ea = count (observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty parish ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_ea.dta", replace 

//median price at the parish level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region district county subcounty parish crop_code: egen obs_parish = count (observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty parish crop_code obs_parish)
rename price_kg price_kg_median_parish
lab var price_kg_median_parish "Median price per kg for this crop in the parish"
lab var obs_parish "Number of sales observations for this crop in the parish"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_parish.dta", replace

//median price at the subcounty level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region district county subcounty crop_code: egen obs_sub = count (observation)
collapse (median) price_kg [aw=weight], by (region district county subcounty crop_code obs_sub)
rename price_kg price_kg_median_sub
lab var price_kg_median_sub "Median price per kg for this crop in the subcounty"
lab var obs_sub "Number of sales observations for this crop in the subcounty"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_subcounty.dta", replace

//median price at the county level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region district county crop_code: egen obs_county = count (observation)
collapse (median) price_kg [aw=weight], by (region district county crop_code obs_county)
rename price_kg price_kg_median_county
lab var price_kg_median_county "Median price per kg for this crop in the county"
lab var obs_county "Number of sales observations for this crop in the county"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_county.dta", replace

//median price at the district level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region district crop_code: egen obs_district = count (observation)
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_district.dta", replace

//median price at the region level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count (observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_region.dta", replace

//median price at the country level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count (observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
merge m:1 region district county subcounty parish ea crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_ea.dta", nogen
merge m:1 region district county subcounty parish crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_parish.dta", nogen
merge m:1 region district county subcounty crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_subcounty.dta", nogen
merge m:1 region district county crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_county.dta", nogen
merge m:1 region district crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_country.dta", nogen

gen price_kg_hh = price_kg

//Impute prices based on local median values
replace price_kg  = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 
replace price_kg  = price_kg_median_parish if price_kg==. & obs_parish >= 10 & crop_code!=890
replace price_kg  = price_kg_median_sub if price_kg==. & obs_sub >= 10 & crop_code!=890
replace price_kg  = price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg  = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890
replace price_kg  = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=890
replace price_kg  = price_kg_median_country if price_kg==. & obs_country >= 10 & crop_code!=890
lab var price_kg "Price per kg, with missing values imputed using local median values"


//Computing value harvest as price_kg * kgs_harvest as done in Ethiopia baseline
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=.  //This instrument doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_values_tempfile.dta", replace

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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production.dta", replace
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_production.dta", replace 

*Plot value of crop production
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (HHID parcel_id plot_id) 
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cropvalue.dta", replace


*Crop values for inputs in agricultural product processing (self-employment)
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_sales.dta", clear
merge m:1 region district county subcounty parish ea crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_ea.dta", nogen
merge m:1 region district county subcounty parish crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_parish.dta", nogen
merge m:1 region district county subcounty crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_subcounty.dta", nogen
merge m:1 region district county crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_county.dta", nogen
merge m:1 region district crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_country.dta", nogen
replace price_kg  = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 //Don't impute prices for "other" crops
replace price_kg  = price_kg_median_parish if price_kg==. & obs_parish >= 10 & crop_code!=890
replace price_kg  = price_kg_median_sub if price_kg==. & obs_sub >= 10 & crop_code!=890
replace price_kg  = price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg  = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890
replace price_kg  = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=890
replace price_kg  = price_kg_median_country if price_kg==. & obs_country >= 10 & crop_code!=890 
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=.  //This instrument doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
*keep HHID crop_code price_kg
*duplicates drop 
recode price_kg (.=0)
collapse (mean) price_kg, by (HHID crop_code) 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_prices.dta", replace

*Crops lost post-harvest // Construct this as value crop production * percent lost similar to Ethiopia waves
use "${UGS_W3_raw_data}/AGSEC5A", clear
append using "${UGS_W3_raw_data}/AGSEC5B"
ren parcelID parcel_id
ren plotID plot_id
ren cropID crop_code //EFW 6.4.19
drop if crop_code==. // observations dropped
rename a5aq16 percent_lost
replace percent_lost = a5bq16 if percent_lost==. & a5bq16!=.

*collapse (sum) percent_lost, by (HHID crop_code) //EFW 6.5.19 fixing a mistake from my code
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. // changes made
tostring HHID, format(%18.0f) replace
merge m:1 HHID crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production.dta"
drop if _merge==2 //0 dropped

gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_losses.dta", replace


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
*SAW 1/3/23 I will do Hired Labor again given that wagehired gives the total wages payed for the total number of days worked hired and not wages per day for each men, women, or children. Notes: 1. I created a variable of total persondays hired by adding dayshiredmale, dayshiredfemale and dayshiredchild. 2. I created a variable of wages per person per day by dividing the wageshired variable -which represent the total amount of hired labored payed for all person-days irrespective of the gender - by totaldayshired. 3. I assigned the new wages per person-day to each gender that worked in that particular household, so if both women and men work in that particular hh, parcel, plot they will be assigned the same wage, since we cannot differentiate between the wages payed for each particular gender.  */

*Hired Labor 
//Note: no information on the number of people, only person-days hired and total value (cash and in-kind) of daily wages
use "${UGS_W3_raw_data}/AGSEC3A", clear 
gen season = 1	
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
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
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild //6.30.22 SAW  "How much did you pay including the value of in-kind payments for these days of labor?" Not 100% sure this is the same as what is mentioned above. Maybe the variable wagehired is for total? Might want to check Uganda wages to see if it's payment per day per perosn or for the total number of days... 
replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal
replace wagehiredchild = wagehiredchild/dayshiredtotal
//
keep HHID parcel_id plot_id season *hired*
drop wagehired dayshiredtotal

* 6.30.22 SAW We need to drop duplicates in order to conduct the following code reshape 6 observations droped
duplicates drop HHID parcel_id plot_id season, force
reshape long dayshired wagehired, i(HHID parcel_id plot_id season) j(gender) string
reshape long days wage, i(HHID parcel_id plot_id season gender) j(labor_type) string
recode wage days (. = 0)
drop if wage == 0 & days == 0
gen val = wage*days
tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
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
*SAW 1/3/23  I will do Family Labor based on the updates on Hired labor. 
*This section combines both seasons and renames variables to be more useful
use "${UGS_W3_raw_data}/AGSEC3A", clear 
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
ren plotID plot_id
ren parcelID parcel_id 
ren a3aq32 days // SAW  a3aq32 "For this plot how many days did they work?" a3aq31  "How many household members worked on this plot during the first season of 2011?" . Not sure if a3aq32 is total days or total days per person (a3aq31)?  1/3/23 Questionnaire says its person days... will use that. 
rename a3aq31 fam_worker_count // number of hh members who worked on the plot
ren a3aq33* PID_* // The number of total family members working on plot (fam_worker_count) can be higher than the pid_* vars since a max of 3 hh members are counted.
keep HHID parcel_id plot_id season PID* days fam_worker_count

preserve
use "${UGS_W3_raw_data}/GSEC2", clear 
gen male = h2q3 == 1
gen age = h2q8
keep HHID PID age male
isid HHID PID
tempfile members
save `members', replace
restore

duplicates drop  HHID parcel_id plot_id season, force // SAW 3 observations deleted 
reshape long PID, i(HHID parcel_id plot_id season) j(colid) string
drop if days == .
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
merge m:1 HHID PID using `members', nogen keep(1 3) 
gen gender = "child" if age < 16
replace gender = "male" if strmatch(gender, "") & male == 1
replace gender = "female" if strmatch(gender, "") & male == 0 
replace gender = "unknown" if strmatch(gender, "") & male == .
gen labor_type = "family"
drop if gender == "unknown"
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
keep region district county subcounty parish ea HHID parcel_id plot_id season gender days labor_type fam_worker_count

foreach i in region district county subcounty parish ea HHID {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //JHG 5_12_22: 1,692 with missing vals b/c they don't have matches on pid, see code above

	gen wage = wage_HHID
	*recode wage (.=0)
foreach i in country region district county subcounty parish ea {
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
keep region district county subcounty parish ea HHID parcel_id plot_id season days val labor_type gender
drop if val == . & days == .
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(HHID parcel_id plot_id season labor_type gender dm_gender) //JHG 5_18_22: Number of workers is not measured by this survey, may affect agwage section
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_labor_long.dta", replace

preserve
collapse (sum) labor_ = days, by (HHID parcel_id plot_id labor_type)
reshape wide labor_, i(HHID parcel_id plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_labor_days.dta", replace
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp = "exp" if strmatch(labor_type,"hired")
	replace exp = "imp" if strmatch(exp, "")
	collapse (sum) val, by(HHID parcel_id plot_id exp dm_gender) //JHG 5_18_22: no season?
	gen input = "labor"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_labor.dta", replace
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_cost_labor.dta", replace


******************************************************************************
** CHEMICALS, FERTILIZER, LAND, ANIMALS (excluded for Uganda), AND MACHINES **
******************************************************************************
*Notes: This is still part of the Crop Expenses Section.
**********************    PESTICIDES/HERBICIDES   ******************************
use "${UGS_W3_raw_data}/AGSEC3A", clear 
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
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
use "${UGS_W3_raw_data}/AGSEC10", clear 
drop if own_implement == 2 //2 = no farm implement owned, rented, or used (separated by implement)
ren a10q1 qtymechimp //number of owned machinery/tools
ren a10q2 valmechimp //total value of owned machinery/tools, not per-item
ren a10q7 qtymechexp //number of rented machinery/tools
ren a10q8 valmechexp //total value of rented machinery/tools, not per-item
collapse (sum) valmechimp valmechexp, by(HHID) //combine values for all tools, don't combine quantities since there are many varying types of tools 
isid HHID //check for duplicate hhids, which there shouldn't be after the collapse
tostring HHID, format(%18.0f) replace
tempfile rawmechexpense
save `rawmechexpense', replace
restore

preserve
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", clear
collapse (sum) ha_planted, by(HHID)
ren ha_planted ha_planted_total
tempfile ha_planted_total
save `ha_planted_total'
restore
	
preserve
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", clear
merge m:1 HHID using `ha_planted_total', nogen
gen planted_percent = ha_planted / ha_planted_total //generates a per-plot and season percentage of total ha planted / SAW ha_planted_total its total area planted for both seasons per HHID 
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
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)
save `plot_inputs'


******************************************************************************
****************************     FERTILIZER   ********************************** 
******************************************************************************
*SAW Using Josh Code as reference which uses Nigeria W3 Code.

use "${UGS_W3_raw_data}/AGSEC3A", clear 
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
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

***************************    LAND RENTALS   **********************************

//Get parcel rent data
use "${UGS_W3_raw_data}/AGSEC2B", clear 
ren parcelID parcel_id
ren a2bq9 valparcelrentexp //rent paid for PARCELS (not plots) for BOTH cropping seasons (so total rent, inclusive of both seasons, at a parcel level)
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_rental.dta", replace

//Calculate rented parcel area (in ha)
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", replace
merge m:1 HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_rental.dta", nogen keep (3)
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

******************************    SEEDS   **************************************

//Clean up raw data and generate initial estimates	
use "${UGS_W3_raw_data}/AGSEC4A", clear 
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season = 2 if season == .
ren plotID plot_id
ren parcelID parcel_id
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
replace qty = qty * 0.5 if unit_code == 31 //Kimbo/Cowboy/Blueband Tin (0.5kgs): 
replace unit_code = 1 if inlist(unit_code, 2, 9, 10, 11, 12, 29, 31, 37, 38, 39, 40) //label them as kgs now	
*SAW What should we do with Tin (20 and 5 lts) and plastic bins (15lts), assume 1lt = 1kg? 
//replace qty = qty * 20 if unit_code == 20 //Tin (20lts):   
//replace qty = qty * 5 if unit_code == 21 //Tin (5kgs): 
//replace qty = qty * 15 if unit_code == 22 //Plastic Bin (15 lts):  

//JHG 6_27_22: no conversion factors (or even units for the last two) for Tin (20 lts) [1.94%] {code is 20}, Tin (5 lts) [0.34%] {code is 21}, Plastic basin (15 lts) [5.53%] {code is 22}, Bundle (6.7%) {code is 66}, Number of Units (General) [1.04%] {code is 85}, or Other Units (Specify) [4.16%] {code is 99}. This means a total of 19.71% of observations cannot be converted into kilograms. We can't use conversion factors from crops as seeds have different densities. Need input on what to do with these remaining conversions

gen unit = 1 if unit_code == 1
replace unit = 2 if unit == .
replace unit = 0 if inlist(unit_code, 20, 21, 22, 66, 85, 99) //the units above that could not be converted will not be useful for price calculations

ren crop_code itemcode
collapse (sum) val qty, by(HHID parcel_id plot_id season input itemcode unit) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for. JHG 7_5_22: all this code does is drop variables, it doesn't actually collapse anything
gen exp = "exp"
tostring HHID, format(%18.0f) replace

//Combining and getting prices.
append using `plotrents'
*tostring HHID, format(%18.0f) replace
append using `plot_inputs'
*destring HHID, replace
append using `phys_inputs'
*tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", nogen keep(1 3) keepusing(weight)
*destring HHID, replace
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
*tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
drop region regurb ea district county subcounty parish weight rural
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
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
foreach i in region district county subcounty parish ea HHID {
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
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3) //merge in regional data (districts, etc.)
*drop strataid clusterid rural pweight parish_code scounty_code district_name
foreach i in region district county subcounty parish ea HHID {
	merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
	recode price_HHID (. = 0)
	gen price = price_HHID
foreach i in country region district county subcounty parish ea {
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_input_quantities.dta", replace
restore

append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_labor.dta"
collapse (sum) val, by (HHID parcel_id plot_id season exp input dm_gender)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_long.dta", replace

preserve
collapse (sum) val, by(HHID exp input) //JHG 7_5_22: includes both seasons, is that okay?
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_cost_inputs_long.dta", replace
restore

preserve
collapse (sum) val_ = val, by(HHID parcel_id plot_id season exp dm_gender)
reshape wide val_, i(HHID parcel_id plot_id season dm_gender) j(exp) string
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs.dta", replace //This gets used below.
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_wide.dta", replace //Used for monocropped plots, this is important for that section
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_cost_inputs_verbose.dta", replace 


//Create area planted tempfile for use at the end of the crop expenses section
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace 
collapse (sum) ha_planted, by(HHID parcel_id plot_id season)
tempfile planted_area
save `planted_area' 

//We can do this (JHG 7_5_22: what is "this"?) more simply by:
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_long.dta", clear
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
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
*tostring HHID, format(%18.0f) replace
merge m:1 HHID parcel_id plot_id season using `planted_area', nogen keep(1 3)
reshape wide val*, i(HHID parcel_id plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(HHID) 
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_cost_inputs.dta", replace 

********************************************************************************
** 								MONOCROPPED PLOTS							  **
********************************************************************************

*Purpose: Generate crop-level .dta files to be able to quickly look up data about households that grow specific, priority crops on monocropped plots

//Setting things up for AgQuery first
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped
ren crop_code_master cropcode
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_monocrop_plots.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped //File now has 6801 unique entries - it should be noted that some these were grown in mixed plots.
merge 1:1 HHID plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", replace
	
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop_hh_area.dta", replace
restore
}


use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_long.dta", clear
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
	merge 1:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(HHID)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_inputs_`cn'.dta", replace
restore
}

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
use "${UGS_W3_raw_data}/AGSEC6A", clear 
rename lvstid livestockid
gen tlu_coefficient = 0.5 if (livestockid == 1 | livestockid == 2 | livestockid == 3 | livestockid == 4 | livestockid == 5 | livestockid == 6 | livestockid == 7 | livestockid == 8 | livestockid == 9 | livestockid == 10 | livestockid == 12) // This includes calves, bulls, oxen, heifer, cows, and horses (exotic/cross and indigenous)
replace tlu_coefficient = 0.3 if livestockid == 11 //Includes indigenous donkeys and mules
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_livestock.dta", replace

*for small animals
use "${UGS_W3_raw_data}/AGSEC6B", clear 
rename lvstid livestockid
gen tlu_coefficient = 0.1 if (livestockid == 13 | livestockid == 14 | livestockid == 15 | livestockid == 16 | livestockid == 18 | livestockid == 19 | livestockid == 20 | livestockid == 21) // This includes goats and sheeps (indigenous, exotic/cross, male, and female)
replace tlu_coefficient = 0.2 if (livestockid == 17 | livestockid == 22) //This includes pigs (indigenous and exotic/cross)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_small_animals.dta", replace

*For poultry and misc.
use "${UGS_W3_raw_data}/AGSEC6C", clear 
rename lvstid livestockid
gen tlu_coefficient = 0.01 if (livestockid == 23 | livestockid == 24 | livestockid == 25 | livestockid == 26 | livestockid == 27) // This includes chicken (all kinds), turkey, ducks, geese, and rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep livestockid tlu_coefficient
duplicates drop
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_poultry_misc.dta", replace
*NOTES:  SAW: There's an additional categoty of beehives (==28) that we are not currently adding to any tlu_coefficient. Did not find it in another survey.

*Combine 3 TLU .dtas into a single .dta
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_livestock.dta", clear
append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_small_animals.dta"
append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_poultry_misc.dta"
label def livestockid 1 "Exotic/cross - Calves" 2 "Exotic/cross - Bulls" 3 "Exotic/cross - Oxen" 4 "Exotic/cross - Heifer" 5 "Exotic/cross - Cows" 6 "Indigenous - Calves" 7 "Indigenous - Bulls" 8 "Indigenous - Oxen" 9 "Indigenous - Heifer" 10 "Indigenous - Cows" 11 "Indigenous - Donkeys/Mules" 12 "Indigenous - Horses" 13 "Exotic/Cross - Male Goats" 14 "Exotic/Cross - Female Goats" 15 "Exotic/Cross - Male Sheep" 16 "Exotic/Cross - Female Sheep" 17 "Exotic/Cross - Pigs" 18 "Indigenous - Male Goats" 19 "Indigenous - Female Goats" 20 "Indigenous - Male Sheep" 21 "Indigenous - Female Sheep" 22 "Indigenous - Pigs" 23 "Indigenous Dual-Purpose Chicken" 24 "Layers (Exotic/Cross Chicken)" 25 "Broilers (Exotic/Cross Chicken)" 26 "Other Poultry and Birds (Turkeys/Ducks/Geese)" 27 "Rabbits"
label val livestockid livestockid //JHG 12_30_21: have to reassign labels to values after append (possibly unnecessary since this is an intermediate step, don't delete code though because it is necessary)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_all_animals.dta", replace

**********************    HOUSEHOLD LIVESTOCK OWNERSHIP   ***********************
//Step 2: Generate ownership variables per household

*Combine HHID and livestock data into a single sheet
use "${UGS_W3_raw_data}/AGSEC6A", clear 
append using "${UGS_W3_raw_data}/AGSEC6B" 
append using "${UGS_W3_raw_data}/AGSEC6C"
gen livestockid = lvstid
merge m:m livestockid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_tlu_all_animals.dta", nogen
label val livestockid livestockid //have to reassign labels to values after creating new variable
label var livestockid "Livestock Species ID Number"
sort HHID livestockid //Put back in order

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
*SAW 7.5.22 Though, a6Xq6 refers to different types of animals the time of ownership asked in each question is different (12 months for livestock, 6 months for small animals, and 3 motnhs for poultry)

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
collapse (sum) num*, by (HHID)
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
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU_Coefficients.dta", replace


********************************************************************************
**                           LIVESTOCK INCOME       		         		  **
********************************************************************************
*SAW 7.5.22 We will use Nigeria Wave 3 as reference to write this section. This section was previously written in older version of Uganda W3 with different format.

*****************************    EXPENSES        *******************************
use "${UGS_W3_raw_data}/AGSEC7A", clear 
append using "${UGS_W3_raw_data}/AGSEC7B"
ren a7bq2e cost_fodder_livestock 
ren a7bq3f cost_water_livestock
ren a7bq5d cost_vaccines_livestock
ren a7bq6c cost_deworm_livestock
ren a7bq7c cost_ticks_livestock
ren a7bq8c cost_hired_labor_livestock // From old code this is cost_hired_labor_livestock. Might want to corroborate 
collapse (sum) cost*, by(HHID)
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses.dta", replace
reshape long cost_, i(HHID) j(input) string
rename cost_ val_total
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses_long.dta", replace // SAW In case is needed for AgQuery

*****************************    LIVESTOCK PRODUCTS        *******************************
*1. Milk
use "${UGS_W3_raw_data}/AGSEC8B", clear
rename AGroup_ID livestock_code
gen livestock_code2="1. Milk"
keep if livestock_code==101 | livestock_code==105 //Exotic+Indigenous large ruminants. Leaving out small ruminants because small ruminant milk accounts only for 0.04% of total production, and there's no price information
ren a8bq1 animals_milked
ren a8bq2 days_milked
rename a8bq3 liters_perday_peranimal
recode animals_milked days_milked liters_perday_peranimal (.=0)
gen milk_liters_produced = animals_milked*liters_perday_peranimal*days_milked
lab var milk_liters_produced "Liters of milk produced in past 12 months"
rename a8bq7 liters_sold_per_year 

rename a8bq6 liters_per_year_to_dairy 
rename a8bq9 earnings_sales 
recode liters_sold_per_year liters_per_year_to_dairy (.=0)
gen price_per_liter = earnings_sales / liters_sold_per_year
gen price_per_unit = price_per_liter  
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
keep HHID livestock_code livestock_code2  milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_sales
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_sales "Total earnings of sale of milk produced"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta", replace


*2. Eggs
use "${UGS_W3_raw_data}/AGSEC8C.dta", clear
rename AGroup_ID livestock_code
rename a8cq1 months_produced //how many poultry laid eggs in the last 3 months (different qs. from TNPS)
rename a8cq2 quantity_month //what quantity of eggs were produced in the last 3 months
recode months_produced quantity_month (.=0)
//gen quantity_produced = months_produced * quantity_month //Seems inaccurate as number of months not included 
//ALT: Does not seem necessary.  Quantity produced should be listed in a8cq2
gen quantity_produced = quantity_month*4 //ALT: per the label, this is supposed to be an estimate of eggs produced in the last year. There's not much else we can do besides extrapolate from the last three months.
lab var quantity_produced "Quantity of this product produced in past year"
rename a8cq3 sales_quantity // eggs sold in the last 3 months
rename a8cq5 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep HHID livestock_code quantity_produced price_per_unit earnings_sales
// units not included
gen livestock_code2 = "2. Eggs"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta", replace

*We append the 3 subsection of livestock earnings
append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta"
*append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace
*tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", keep(1 3) nogen
collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code) //Nigeria also uses by quantity_sol_season_unit but UGanda does not have that information, though units should be the same within livestock_code2 (product type). Also, we could include by livestock_code (type of animal)
ren price_per_unit price_unit_median_country

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", replace
*SAW Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace
merge m:1 livestock_code2 livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", nogen keep(1 3) //SAW We have an issue with price units for some types of meat products and specific animal tpye. I assign those price_unit values for the missing based on similar types of animals with information.
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace

*****************************    LIVESTOCK SOLD (LIVE)       *******************************
*SAW 7.12.22 Unlike Nigeria, Uganda has a section on meat production coming from slaughtered animals and their corresponding earning sales, which means we do not need to predict price values for slaughtered animals using live aninmals sold prices like Nigeria did. Though, we do need prices and earnings coming from sales of live animals but we already have earning coming from slaughtered animals.
*Notes: I will construct this section like Nigeria did - including values for slaughted animals using inputed median prices from live animals sales - and will ask Andres what to do with the livestock production coming from meat production. The only issue I see it is we might be double counting income from meat production and in this ssection inputed income from slaughtered animals. Code was taken from older version of Uganda w3.
use "${UGS_W3_raw_data}/AGSEC6A", clear
append using "${UGS_W3_raw_data}/AGSEC6B"
append using "${UGS_W3_raw_data}/AGSEC6C"
//Making sure value labels for 6B and 6C get carried over. Just in case.
label define lvstid 13 "Exotic/Cross - Male Goats"/*
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
tostring HHID, format(%18.0f) replace
//Time periods differ across livestock type: Cattle & pack animals (12 months), small animals (6 months), poultry (3 months)
//Adjust time periods below to 12 months 
ren lvstid livestock_code
ren a6aq2 animal_owned
replace animal_owned=a6bq2 if animal_owned==.
replace animal_owned=a6cq2 if animal_owned==.
keep if animal_owned==1
ren a6aq14a number_sold
replace number_sold = 2*a6bq14a if number_sold==. & a6bq14a!=.
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
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3) //106 missing from master
keep HHID region rural weight district county subcounty parish ea price_per_animal number_sold income_live_sales number_slaughtered value_livestock_purchases livestock_code
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", replace

*SAW 7.12.22 This section is coming from the NGA w3 coding which uses a loop instead of longer code.
*Implicit prices (shorter)
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
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
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01value_slaughtered_sold*/, by (HHID)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
*lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.0 gen prop_meat_sold = value_slaughtered_sold/value_slaughtered*/ // SAW We don't have slaughtered sold in this section. We do potentially have it in the 8C section though..... Actually this variable is available in the 8C - meat sold - subsection in earlier code.
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_sales.dta", replace

********************************************************************************
**                                 TLU    		         	         	      **
********************************************************************************
use "${UGS_W3_raw_data}/AGSEC6A", clear
append using "${UGS_W3_raw_data}/AGSEC6B"
append using "${UGS_W3_raw_data}/AGSEC6C"
//Making sure value labels for 6B and 6C get carried over. Just in case.
label define lvstid 13 "Exotic/Cross - Male Goats"/*
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
tostring HHID, format(%18.0f) replace
ren lvstid livestock_code
ren a6aq2 animal_owned
replace animal_owned=a6bq2 if animal_owned==.
replace animal_owned=a6cq2 if animal_owned==.
*keep if animal_owned==1
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
replace income_live_sales = a6bq14b*2 if income_live_sales==. & a6bq14b!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace income_live_sales = a6cq14b*4 if income_live_sales==. & a6cq14b!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months
gen number_sold = a6aq14a
replace number_sold = a6bq14a*2 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
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
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3) //106 missing from master
foreach i in region district county subcounty parish ea {
	merge m:1 `i' livestock_code using  `livestock_prices_`i'', nogen keep(1 3)
	replace price_per_animal = price_median_`i' if obs_`i' > 9 & price_per_animal==.
}

*gen value_start_agseas = number_start_agseas * price_per_animal
gen value_today = number_today * price_per_animal
gen value_1yearago = number_1yearago * price_per_animal
*gen value_today_est = number_today * price_per_animal_est

collapse (sum) number_today number_1yearago lost_theft lost_other lost_disease animals_lost lvstck_holding=number_today value* tlu*, by(HHID species)
egen mean_12months=rowmean(number_today number_1yearago)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_herd_characteristics_long.dta", replace //AgQuery

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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_herd_characteristics.dta", replace
restore

collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (HHID)
lab var tlu_1yearago "Tropical Livestock Units as of one year ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLUs.dta", replace



********************************************************************************
**                                 FISH INCOME    		         	          **
********************************************************************************
*SAW 9.19.22 No Fish Income data collected in Uganda w3. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************
//Purpose: This section is meant to calculate the value of all activities the household undertakes that would be classified as self-employment. This includes profit from business... SAW Check for other sources of self-employment income
*Generate profit from business activities (revenue net of operating costs)
use "${UGS_W3_raw_data}/GSEC12", clear
ren h12q12 months_activ // how many months did the business operate
ren h12q13 monthly_revenue //  avg monthly gross revenues when active
ren h12q15 wage_expense // avg expenditure on wages // SAW Check if its av expen on wage per individual or total (since we got an indicator for number of people hired)
ren h12q16 materials_expense // avg expenditures on raw materials
ren h12q17 operating_expense // other operating expenses (fuel, kerosine)
recode monthly_revenue wage_expense materials_expense operating_expense (. = 0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit < 0 & monthly_profit != . // W3 has some hhs with negative profit (86)
gen annual_selfemp_profit = monthly_profit * months_activ
collapse (sum) annual_selfemp_profit, by (HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_self_employment_income.dta", replace
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

use "${UGS_W3_raw_data}/GSEC8.dta", clear
*Use ISIC codes for non-farm activities (For wave 3 we have a 1 digit ISCO variable ~ [0,9] that we can use, same as wave 7)
egen primary_hours = rowtotal (h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) if (h8q4==1 | h8q6==1 | h8q8==1 | h8q10==1) & h8q22!=6 // includes work for someone else, work without payment for the house, apprentice etc. for all work MAIN JOB excluding "Working on the household farm or with household livestock.." Last 7 days total hours worked per person
gen secondary_hours =  h8q43 if h8q38b!=6 & h8q38b!=.
egen off_farm_hours = rowtotal(primary_hours secondary_hours) if (primary_hours!=. | secondary_hours!=.)
gen off_farm_any_count = off_farm_hours!=0 if off_farm_hours!=.
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours, for the past 7 days"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_off_farm_hours.dta", replace
*Notes:  SAW 9.20.22 We have information about the total weeks and months worked for Main job and Secondary Job, should we aim to construct a off-farm hours worked for the year and not only for the past 7 days? Similar to what we did for Agricultural hours worked section.

********************************************************************************
**                          NON-AG WAGE INCOME  	     	    	          **
********************************************************************************
/*
UGS Wave 3 did not capture number of weeks per month individual worked. 
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

//EFW 7.15.19 double check RIGA methodology to make sure industry codes are the same

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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_hours_imputation_urban.dta", replace
restore
sort industry
collapse(median) weeks, by(industry)
sort industry
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_hours_imputation.dta", replace

//use wave 2 income
use "${UGS_W3_raw_data}/GSEC8.dta", clear
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta", nogen
//Classification of Industry to get median wage for imputation, taken from r coding
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

*merge in median weeks worked
sort urban industry
merge m:1 urban industry using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_hours_imputation_urban.dta", nogen keep(1 3)
ren weeks weeks_urban

sort industry
merge m:1 industry using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_hours_imputation.dta", nogen keep (1 3)
ren weeks weeks_industry
gen weeks = weeks_urban
replace weeks = weeks_industry if weeks == .

//Wage Income
rename h8q30 number_months
egen number_hours = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) //EFW 7.10.19 //Total number of hours worked in the last 7 days
rename h8q31a most_recent_payment
replace most_recent_payment = . if (h8q19a > 611 & h8q19a < 623) | h8q19a != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct? SAW We are getting rid of subsistance ag workers income 68% of all observations why?? Double check is it because we are only includin non-ag income here?
rename h8q31c payment_period
rename h8q31b most_recent_payment_other
*SAW We do the same for Secondary Jobs
rename h8q44 secwage_number_months
rename h8q44_1 secwage_number_weeks
replace secwage_number_weeks=. if secwage_number_weeks>4 // number of weeks worked per month cant be higher than 4 (10 obs)
gen secwage_hours_pastweek = h8q43  // Total hours worked in 2ndary job for the past week. 
rename h8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if (h8q38a > 611 & h8q38a < 623) | h8q38a != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct? SAW 9.19.22 Change it to work done in 2dary job not the main job (it was using the same prevoous variable h8q19a)
rename h8q45c secwage_payment_period
rename h8q45b secwage_recent_payment_other

*Non Ag Wages Income Main Job
gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

*Non Ag Waves Income Secondary Job
gen annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_months if secwage_payment_period==4
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks if secwage_payment_period==3
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

gen wage_salary_other_sec = secwage_recent_payment_other*secwage_number_months if secwage_payment_period==4
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks if secwage_payment_period==3
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

recode annual_salary_cash wage_salary_other annual_salary_cash_sec wage_salary_other_sec (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other + annual_salary_cash_sec + wage_salary_other_sec
collapse(sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from non-agricultural wage (both Main and Secondary Job)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_income.dta", replace

********************************************************************************
**                          AG WAGE INCOME  	     	        	          **
********************************************************************************
*SAW Same procedure as above but considering Agricultual related Work. Is it better to not exclude ag related wages as done earlier and just have a different variable to indicate that variable so the procedure doesn't have to be coded twice. For the sake of having shorter lines of code.

/*
UGS Wave 1 did not capture number of weeks per month individual worked. 
We impute these using median values by industry and type of residence using UGS W2
see imputation below. This follows RIGA methods.
*/
//use wave 2 income as reference
use "${UGS_W3_raw_data}/GSEC8.dta", clear
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta", nogen
//Classification of Industry to get median wage for imputation, taken from r coding
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
*merge in median weeks worked
sort urban industry
merge m:1 urban industry using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_hours_imputation_urban.dta", nogen keep(1 3)
ren weeks weeks_urban
sort industry
merge m:1 industry using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_hours_imputation.dta", nogen keep (1 3)
ren weeks weeks_industry
gen weeks = weeks_urban
replace weeks = weeks_industry if weeks == .

// AG Wage Income
rename h8q30 number_months
egen number_hours = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) //EFW 7.10.19 //Total number of hours worked in the last 7 days
rename h8q31a most_recent_payment
replace most_recent_payment = . if industry!=1 // SAW We get rid of all non agricultural related wages 
rename h8q31c payment_period
rename h8q31b most_recent_payment_other
*SAW We do the same for Secondary Jobs
rename h8q44 secwage_number_months
rename h8q44_1 secwage_number_weeks
replace secwage_number_weeks=. if secwage_number_weeks>4 // number of weeks worked per month cant be higher than 4 (10 obs)
gen secwage_hours_pastweek = h8q43  // Total hours worked in 2ndary job for the past week. 
rename h8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if industry!=1 // SAW We get rid of all non agricultural related wages 
rename h8q45c secwage_payment_period
rename h8q45b secwage_recent_payment_other

*Non Ag Wages Income Main Job
gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

*Non Ag Waves Income Secondary Job
gen annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_months if secwage_payment_period==4
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks if secwage_payment_period==3
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2 // SAW Why is it divided by 8? Is 8 the average numbers of hours worked per day?
replace annual_salary_cash_sec = secwage_most_recent_payment*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

gen wage_salary_other_sec = secwage_recent_payment_other*secwage_number_months if secwage_payment_period==4
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks if secwage_payment_period==3
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*(secwage_hours_pastweek/8) if secwage_payment_period==2
replace wage_salary_other_sec = secwage_recent_payment_other*secwage_number_weeks*secwage_hours_pastweek if secwage_payment_period==1

recode annual_salary_cash wage_salary_other annual_salary_cash_sec wage_salary_other_sec (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other + annual_salary_cash_sec + wage_salary_other_sec
collapse(sum) annual_salary, by (HHID)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agwage_income.dta", replace

********************************************************************************
**                               OTHER INCOME 	        	    	          **
********************************************************************************
*SAW Using Earlier UG w3 code plus some adjustments 
use "${UGS_W3_raw_data}/GSEC11.dta", clear
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_other_income.dta", replace

********************************************************************************
**                           LAND RENTAL INCOME        	    	              **
********************************************************************************

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
rename a2aq14 land_rental_income
recode land_rental_income (.=0)
collapse(sum) land_rental_income, by(HHID)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rental_income.dta", replace


********************************************************************************
**                           LAND SIZE       	    	              **
********************************************************************************
*SAW 9.20.22 Using Uganda W7 Code as reference. 
*Determining whether crops were grown on a plot
use "${UGS_W3_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B.dta" 
replace season = 2 if season == .
*ren parcelID parcel_id
*ren pltid plot_id
drop if plotID==.
gen crop_grown = 1 
collapse (max) crop_grown, by(HHID plotID) // SW maybe we should add parcel_id and season? 
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crops_grown.dta", replace

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated = (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if (a2aq11a==. & a2aq11b==.)
replace cultivated=. if cultivated==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
collapse (max) cultivated, by (HHID parcelID)
lab var cultivated "1= Parcel was cultivated in this data set"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_cultivated.dta", replace
*Notes: SAW We currently do not differentiate between visits or seasons, cultivated =1 if in at least one visit there was a cultivated plot.

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated = (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if (a2aq11a==. & a2aq11b==.)
replace cultivated=. if cultivated==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
keep if cultivated==1
*Get parcel acres size SAW I prioritize GPS measurement than farmer estimate (cases when we had both measures) contrary to wave 7 which does the opposite.
gen area_acres_meas = a2aq4
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size.dta", replace
*SAW Wave 7 does have a lot of missing data on farm area that is counted as zero. In this case, all households have farm area observations. (no zeros) land_size dta file its at the HHID level, do we want it to be at the parcel level? collapse by (HHID parcelID)

*All agricultural land 
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
gen other_land_use= (a2aq11a==7 | a2aq11a==96 | a2aq11b==7 | a2aq11b==96 | a2bq12a==6 | a2bq12a==96 | a2bq12b==6 | a2bq12b==96)
replace other_land_use=. if other_land_use==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
drop if rented_out==1 | other_land_use==1
gen agland = 1  
collapse (max) agland, by (HHID)
tostring HHID, format(%18.0f) replace
merge 1:m HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crops_grown.dta", keep(3)
drop _m crop_grown
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_agland.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size.dta", replace
merge 1:m HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_agland.dta", keep(3)
collapse (mean) farm_area, by(HHID)
rename farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmsize_all_agland.dta", replace
*SAW Not sure what's the point of this. This dta file is exactly the same as the land_size dta file. Should it only include agland HHID? 
*SAW changed the keep to only merged obs. So the dta only included agland households (before it had keep(1 3) and it was the same as land_size.

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
drop if rented_out==1 
gen parcel_held = 1  
collapse (sum) parcel_held, by (HHID)
lab var parcel_held "1= Parcel was NOT rented out in the main season" // confusion of parcel with plot 
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_held.dta", replace

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
drop if rented_out==1 
gen area_acres_meas = a2aq4 if (a2aq4!=. & a2aq4!=0)
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen area_acres_meas = a2aq4 if (a2aq4!=. & a2aq4!=0)
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas land_size_total
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size_total.dta", replace


********************************************************************************
**                             FARM LABOR       	    	                  **
********************************************************************************
*SAW 9.21.22 Using Peter's code as reference (Uganda wave 7)

*1.  Hired Labor and Family labor  1st Visit and 2nd visit (main and short season)
use "${UGS_W3_raw_data}/AGSEC3A.dta", clear
drop if plotID==.
ren a3aq35a days_hired_men
ren a3aq35b days_hired_women
ren a3aq35c days_hired_children // Person days hired labor
recode days_hired_men days_hired_women days_hired_children (.=0)
gen days_hired_mainseason = days_hired_men + days_hired_women + days_hired_children
rename a3aq32 days_famlabor_mainseason // SAW Person days family labor (questionnaire does not differentiate across gender, children)
recode days_famlabor_mainseason (.=0)
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (HHID parcelID plotID) 
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_farmlabor_mainseason.dta", replace

use "${UGS_W3_raw_data}/AGSEC3B.dta", clear
drop if plotID==.
rename a3bq35a days_hired_men
rename a3bq35b days_hired_women
rename  a3bq35c days_hired_children
recode days_hired_men days_hired_children days_hired_women (.=0)
gen days_hired_shortseason = days_hired_men + days_hired_children + days_hired_women
rename a3bq32 days_famlabor_shortseason // SAW Again, no granularity on men, women, children
recode days_famlabor_shortseason (.=0)
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (HHID parcelID plotID)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_farmlabor_shortseason.dta", replace

*SAW Notes: 1. Check that we DO want to include children labor, I do recall at some point deciding to exclude it. (Cant remember the context of the situation)

*2. We merge both seasons into one dataset
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_farmlabor_mainseason.dta", replace
merge 1:1 HHID parcelID plotID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_farmlabor_shortseason.dta", nogen
recode days* (.=0)
collapse (sum) days*, by(HHID parcelID plotID)
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

********************************************************************************
**                             VACCINE USAGE      	    	                  **
********************************************************************************
*SAW 9.22.22 Using Nigeria Wave 3 as reference, since there is no code available for other Uganda Waves. Migh want to let other uganda coders about this so they code this section. 

use "${UGS_W3_raw_data}/AGSEC7B", clear
gen vac_animal = a7bq5a==1 | a7bq5a==2 // SAW This dataset only includes cattle owned by households
*Disagregating vaccine usage by animal type
gen species = (inlist(AGroup_ID,101,105)) + 2*(inlist(AGroup_ID,102,106)) + 3*(inlist(AGroup_ID,104,108)) + 4*(inlist(AGroup_ID,103,107))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Poultry"
la val species species
*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_poultry = `i' if species==4
}
collapse (max) vac_animal*, by (HHID)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_poultry "`l`i'' - poultry"
}
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_vaccine.dta", replace
*SAW Comments: Only include animals which are owned by the households in the summary stats.

*Individual farmers listed as farmer keeper that use vaccines SAW This is a crude attempt since it hasn't been done for Uganda before. (using NGA w3 as reference)
use "${UGS_W3_raw_data}/AGSEC7B", clear
preserve
gen species = (inlist(AGroup_ID,101,105)) + 2*(inlist(AGroup_ID,102,106)) + 3*(inlist(AGroup_ID,104,108)) + 4*(inlist(AGroup_ID,103,107))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Poultry"
la val species species
gen vac_animal = a7bq5a==1 | a7bq5a==2 // SAW This dataset only includes cattle owned by households
keep HHID species vac_animal 
tempfile vaccines
save `vaccines'
restore
*gen all_vac_animal=s11iq22>=1 & s11iq1==1 Vaccination data is on 7B
preserve
use "${UGS_W3_raw_data}/AGSEC6A", clear
append using "${UGS_W3_raw_data}/AGSEC6B"
append using "${UGS_W3_raw_data}/AGSEC6C"
gen double farmerid = a6aq3d // SAW: When creating PID variable we need to add double because before it was saving it as float and the PID where being modified which later merge was not working properly
replace farmerid = a6bq3d if farmerid==.
replace farmerid = a6cq3d if farmerid==.
keep HHID farmerid lvstid
*rename a6aq3d farmerid
tempfile farmer1
save `farmer1'
restore
preserve
use "${UGS_W3_raw_data}/AGSEC6A", clear
append using "${UGS_W3_raw_data}/AGSEC6B"
append using "${UGS_W3_raw_data}/AGSEC6C"
gen double farmerid = a6aq3e
replace farmerid = a6bq3e if farmerid==.
replace farmerid = a6cq3e if farmerid==.
keep HHID farmerid lvstid
*rename a6aq3d farmerid
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
*SAW We need to create from livestockid to AgroupID categories variables so the merge can occur. SAW I'll use species since it's easier
gen species = (inlist(lvstid,1,2,3,4,5,6,7,8,9,10,11,12)) + 2*(inlist(lvstid,13,14,15,16,18,19,20,21)) + 3*(inlist(lvstid,17,22)) + 4*(inlist(lvstid,23,24,25,26,27,28))
*la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Poultry"
*la val species species
merge m:m HHID species using `vaccines' 
collapse (max) vac_animal , by(HHID farmerid)
gen double  PID=farmerid // SAW again using gen double so PID values do not get different values 
drop if PID==.
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen
keep HHID farmerid vac_animal age female hh_head PID
lab var vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_vaccine", replace


********************************************************************************
**                        ANIMAL HEALTH - DISEASES     	    	              **
********************************************************************************
*26.09.22 SAW This is a first attempt to code this section in Uganda (Not coded before for earlier waves). Using NGA w3 as reference 
*Comments: No information available on types of diseases suffered by [livestock_id], we only have information on which types of diseases hhid vaccineted for.

********************************************************************************
**                   LIVESTOCK WATER, FEEDING, AND HOUSING     	              **
********************************************************************************
*SAW 26.09.22 SAW This section has not been coded for any Uganda wave yet. Also, not available for NGA w3. We will use as reference old code from Uganda w5 that does not run but gives an idea of the final indicators that we are looking for. 

use "${UGS_W3_raw_data}/AGSEC7B", clear
gen feed_grazing = (a7bq2a==1 | a7bq2a==2)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat = (a7bq3b==5 | a7bq3b==6 | a7bq3b==7 | a7bq3b==9) //
gen water_source_const = (a7bq3b==1 | a7bq3b==2 | a7bq3b==3 | a7bq3b==9)
gen water_source_cover = (a7bq3b==4 | a7bq3b==8 | a7bq3b==10) 
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
*Comments: Water systems 1 tap water, 2 borehole, 3 dam, 4 well, 5 river, 6 spring, 7 stream, 8 constructed water points, 9 rainwater harvesting, 10 other. Here's the list of water systems not sure where to include each of those so might need to change later. 
gen lvstck_housed = (a7bq4==2 | a7bq4==3 | a7bq4==4 | a7bq4==5 | a7bq4==6 | a7bq4==6==7) // SAW Includes: Confined in sheds, paddocks, fences, cages, baskets, and others
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
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_feed_water_house.dta", replace
*SW: Double check in which categories each sources of water, housing, and feeding was added to.  I'm not entirely sure what they exactly mean (Only issue quick to solve)

********************************************************************************
**                      USE OF INORGANIC FERTILIZER         	              **
********************************************************************************
*SAW 9.26.22 Using Uganda Wave 7 as reference. 
use "${UGS_W3_raw_data}/AGSEC3A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
gen use_inorg_fert=(a3aq13==1 | a3bq13==1) if (a3aq13!=. | a3bq13!=.)
collapse (max) use_inorg_fert, by (HHID)
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fert_use.dta", replace

*Fertilizer use by farmers ( a farmer is an individual listed as plot manager)
use "${UGS_W3_raw_data}/AGSEC3A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
gen all_use_inorg_fert=(a3aq13==1 | a3bq13==1) if (a3aq13!=. | a3bq13!=.)
preserve
*Recording First and 2nd decision makers regarding each plot. 
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
gen double  PID=farmerid // SAW again using gen double so PID values do not get different values 
drop if PID==.
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", keep(1 3) nogen
keep HHID PID all_use_inorg_fert
lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if PID!=""
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_fert_use.dta", replace
*Comments: SAW In this case, Uganda wave 3 does provide more than 1 decision maker on plot.

********************************************************************************
**                           USE OF IMPROVED SEED         	                  **
********************************************************************************
*SAW Using Peter's work on Uganda wave 7 as reference.
use "${UGS_W3_raw_data}/AGSEC4A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season = 2 if season == .
gen imprv_seed_use = (a4aq13==2) if a4aq13!=.
replace imprv_seed_use= (a4bq13==2) if imprv_seed_use==. & a4bq13!=.

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
replace imprv_seed_banana = . 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", replace

*Seed adoption by farmers ( a farmer is an individual listed as plot manager)
use "${UGS_W3_raw_data}/AGSEC4A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season = 2 if season == .
gen imprv_seed_use = (a4aq13==2) if a4aq13!=.
replace imprv_seed_use= (a4bq13==2) if imprv_seed_use==. & a4bq13!=.
ren imprv_seed_use all_imprv_seed_use
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp.dta", replace

*Use of seed by crops
forvalues k=1/$nb_topcrops {
	use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved maize seeds
	gen all_imprv_seed_`cn'=all_imprv_seed_use if cropID==`c'  
	*gen all_hybrid_seed_`cn' =. 
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= cropID==`c' 
	gen double PID = a4aq6_1
	replace PID= a4bq6_1 if PID==.
	tostring HHID, format(%18.0f) replace
    tostring PID, format(%18.0f) replace
	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' /*all_hybrid_seed_`cn'*/  `cn'_farmer, by (HHID PID)
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp_`cn'.dta", replace
}

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 HHID PID all_imprv_seed_use using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp_`v'.dta", nogen
}	 
drop if PID==""
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	*lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

gen farm_manager=1 if PID!=""
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" // 
*Replacing permanent crop seed information with missing because this section does not ask about permanent crops
replace all_imprv_seed_cassav = . 
replace all_imprv_seed_banana = . 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use.dta", replace

*SAW Comments :In this case, Section 4A and 4B does not provide information on who is responsible for the crop only who is respondent for the crop on the questionnaire not sure if they are the same thing. For example, for other sections using 3A and 3B they do explicitly ask who is decision makers of the plot etc. 
*SAW: 5.1.23 Nigeria Wave 3 Has a PLOT MANAGER section that includes fertlizer use, improved seed into one section - might want to update the sections above to reduce number of lines of code. 


********************************************************************************
**                         REACHED BY AG EXTENSION         	                  **
********************************************************************************
*SAW Using  Uganda Wave 7 as reference.
use "${UGS_W3_raw_data}/AGSEC9", clear
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
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_any_ext.dta", replace
*SAW Comments: We could specify the advice on prices from extension if required (we got the data for that and other types of advise). Right now, we are not worring about which type of advise is given (e.g. ag production, ag prices, ag processing, crop marketing, fish production, livestock production, livestock diseases etc.)

********************************************************************************
**                         MOBILE PHONE OWNERSHIP                             **
********************************************************************************
*SAW 1.5.23 CODED using Nigeria wave 3 as reference. This section has not been coded for other Uganda waves. 
use "${UGS_W3_raw_data}/GSEC14", clear
recode h14q4 (.=0)
gen hh_number_mobile_owned=h14q4 if h14q2==16 // number mobile phones owned by household today
recode hh_number_mobile_owned (.=0)
gen mobile_owned=hh_number_mobile_owned>0
collapse (max) mobile_owned, by(HHID)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_mobile_own.dta", replace

********************************************************************************
**                     USE OF FORMAL FINANCIAL SERVICES                       **
********************************************************************************
*SAW No data available on Uganda wave 3 to code this section. SAW 1.5.23 Household Questionnaire does not have Section 7. Use of Financial Services section.

********************************************************************************
**                           MILK PRODUCTIVITY                                **
********************************************************************************
*SAW 1.5.23 NEEDS TO BE CODED. Available for NGA Wave 3, potentially available on Ug wave 7 or wave 5. Coded in older versions of Uganda wave 3. 
*SW 7/20/21 I will do Milk productivity again since I can not find the temp file and AGSEC8 raw data does not seem to exist.
use "${UGS_W3_raw_data}/AGSEC8B", clear
keep if AGroup_ID==101 | AGroup_ID==105 //SW We keep only large ruminants(exotic/cross & Indigenous) Notes: Uganda wave 7 does only keep exotic/cross large and small ruminants (not sure which ones we should keep) EASY FIX
gen milk_animals = a8bq1
*SW Not able to considerd only Cow milk, it will consider all milk from large ruminants.
gen days_milked = a8bq2
*This won't consider HH that had large ruminant but did not used them to get milk.
gen months_milked = days_milked/30.5
*gen months_milked = round(days_milked/30.5)
gen liters_day = a8bq3 // SAW  What was the average [AGroup_ID] milk production per day per milking animal?
gen liters_per_largerruminant = days_milked*liters_day
keep HHID milk_animals months_milked days_milked liters_per_largerruminant liters_day
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/UGS_W3_milk_animals.dta", replace
/*Notes: Not sure if it is possible to dissagregate this indicator by type of large ruminant(cows etc.). 
Also, do we want the indicator to be Average quantity per year per milked animal or by total sum of milked animals?"
Indicator liters_per_largerruminant mean 721.35 vs Tanzania wave 4 indicator is 1123.2 */
*SW 1.6.23  Check for outliers in milk animals(a8bq1). This is consistent with Uganda wave 7 Indicators on Milk Productivity (not nigeria)

********************************************************************************
**                            EGG PRODUCTIVITY                                **
********************************************************************************
*SAW 1.6.23 I am really not confident of this section below. Numbers differ widely from Uganda wave 7. Discuss with Peter. 
use "${UGS_W3_raw_data}/AGSEC6C", clear
gen poultry_owned = a6cq3a if (lvstid==23 | lvstid==24 | lvstid==25)
collapse (sum) poultry_owned, by(HHID)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${UGS_W3_raw_data}/AGSEC8C", clear
gen eggs_months = a8cq1  // number of layers was reported for the last three months thus the need to divide by 3 to get monthly total	SAW 1.6.23 How many poultry laid eggs in the last 3 months?	why whould you divide by 3? 
gen eggs_per_month = a8cq2/3	// How many poultry eggs did you produce in the last 3 months?	
collapse (sum) eggs_months eggs_per_month, by(HHID)
gen eggs_total_year = eggs_per_month*12 // multiply by 12 to get the annual total 
merge m:1 HHID using  `eggs_animals_hh', nogen keep(1 3)			
keep HHID eggs_months eggs_per_month eggs_total_year poultry_owned 
lab var eggs_months " How many poultry laid eggs in the last 3 months"
lab var eggs_per_month "Total number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in the year(household)"
lab var poultry_owned "Total number of poulty owned (household)"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_eggs_animals.dta", replace



********************************************************************************
**                      CROP PRODUCTION COSTS PER HECTARE                      **
********************************************************************************
/*SAW Comments: This section is much different than older versions of uganda and uganda wave 7. I will currently use NGA wave 3 as reference, since it was also used as reference for the ALL PlOTS section which is used as input for this section.
*All the preprocessing is done in the crop expenses section */
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
collapse (sum) ha_planted /*ha_harvest*/, by(HHID parcel_id plot_id /*season*/ purestand field_size) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
duplicates drop HHID parcel_id plot_id /*season*/, force
reshape long ha_, i(HHID parcel_id plot_id /*season*/ purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
**# Bookmark #1
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_long.dta", replace
collapse (sum) cost_=val, by(HHID parcel_id plot_id  /*season*/ dm_gender exp)
reshape wide cost_, i(HHID parcel_id plot_id  /*season*/ dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
drop cost_total
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge m:1 HHID parcel_id plot_id /*season*/ using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(HHID dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
*replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(HHID dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(HHID) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted /*harvested*/ {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropcosts.dta", replace

*Notes: For Crop production costs per hectare we are adding all costs and area planted across both seasons at the plot level. 

********************************************************************************
                    * RATE OF FERTILIZER APPLICATION *
********************************************************************************
*SAW 1.9.23 Using Nigeria Wave 3 as reference:
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
collapse (sum) ha_planted /*ha_harvest*/, by(HHID parcel_id plot_id season/*season*/ dm_gender) // SAW All plots section is unable to construct ha harvest variable (no information available), might want to "predict" it just as we did for ha planted at the plot level. (Also, har harvest might be available at the parcel level like plot size?)
merge 1:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_input_quantities.dta", keep(1 3) nogen
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
merge m:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", keep (1 3) nogen
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fertilizer_application.dta", replace

********************************************************************************
                    * RATE OF FERTILIZER APPLICATION *
********************************************************************************

********************************************************************************
                    * WOMEN'S DIET QUALITY *
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available
*SW Need to find a good example on how to construct this variable. Not available in TZN W4, NGA wave 3, Any Uganda wave.

********************************************************************************
                    *HOUSEHOLD'S DIET DIVERSITY SCORE *
********************************************************************************
*SW 08.02.2021
use "${UGS_W3_raw_data}/GSEC15B", clear
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_household_diet.dta", replace
*SAW 1.9.23  Notes: Should the cut off point be a fixed value (not relative to te mean within each wave) to make comparison across time possible? 

********************************************************************************
                     * WOMEN'S CONTROL OVER INCOME *
********************************************************************************
*SW 8.3.21
use "${UGS_W3_raw_data}/AGSEC5A", clear
append using  "${UGS_W3_raw_data}/AGSEC5B"
append using  "${UGS_W3_raw_data}/AGSEC8A"
append using  "${UGS_W3_raw_data}/AGSEC8B"
append using  "${UGS_W3_raw_data}/AGSEC8C"
tostring HHID, format(%18.0f) replace



append using  "${UGS_W3_raw_data}/GSEC12" //  //Non-Agricultural Household Enterprises/Activities - h12q19a h12q19b
gen type_decision="" 
gen double controller_income1=.
gen double controller_income2=.
*Control of harvest from annual crops A5AQ6A_1 A5AQ6A_2 A5AQ6A_3 A5AQ6A_4 A5BQ6A_2 A5BQ6A_3 A5BQ6A_4
replace type_decision="control_annualharvest" if !missing(A5AQ6A_2) | !missing(A5AQ6A_3) | !missing(A5AQ6A_4)
replace controller_income1=A5AQ6A_2
replace controller_income1=A5AQ6A_3 if controller_income1==.
replace controller_income2=A5AQ6A_4
replace type_decision="control_annualharvest" if !missing(A5BQ6A_2) | !missing(A5BQ6A_3) | !missing(A5BQ6A_4)
replace controller_income1=A5BQ6A_2 if controller_income1==.
replace controller_income1=A5BQ6A_3 if controller_income1==.
replace controller_income2=A5BQ6A_4 if controller_income2==.
*Control over crop sales earnings A5AQ6A_1
replace type_decision="control_annualsales" if !missing(A5AQ11F) | !missing(A5AQ11G) | !missing(A5AQ11H)
replace controller_income1=A5AQ11F if controller_income1==.
replace controller_income1=A5AQ11G if controller_income1==.
replace controller_income2=A5AQ11H if controller_income2==.
replace type_decision="control_annualsales" if !missing(A5BQ11F) | !missing(A5BQ11G) | !missing(A5BQ11H)
replace controller_income1=A5BQ11F if controller_income1==.
replace controller_income1=A5BQ11G if controller_income1==.
replace controller_income2=A5BQ11H if controller_income2==.
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
ren controller_income PID
*	Now merge with member characteristics
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
merge 1:1 HHID PID  using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_control_income.dta", replace

 *SAW 1.9.23 Notes:  Uganda Wave 7 asks "Who in this household decides on the use of earnings from this enterprise?", Uganda wave 3 does not have that question instead it asks Who in the household owns/ manages this enterprise? Household Questionnaire Section 12 Question 5A 5B
 
********************************************************************************
            * WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING *
********************************************************************************
 *SW 9/2/21 Coded using Tanzania Wave 4 as reference. SAW 1.9.23 Final dataset is similar to Nigeria wave 3, has same indicators and unit of analysis, should be OK. 
use "${UGS_W3_raw_data}/AGSEC3A", clear
append using "${UGS_W3_raw_data}/AGSEC3B"
append using "${UGS_W3_raw_data}/AGSEC5A"
append using "${UGS_W3_raw_data}/AGSEC5B"
append using "${UGS_W3_raw_data}/AGSEC6A"
gen type_decision=""
gen double decision_maker1=.
gen double decision_maker2=.
*gen decision_maker3=.
*Decisions concerning the timing of cropping activities, crop choice and input use on the [PLOT]
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
*TZN W4 1. Responsible for negotiating the sale of crop to costumer No data avalaible for this category
*Keep and Manage Livestock (TZN-W4) 1. Who is responsible for keeping the animal (lf95_01_1) vs (UG W4) 1. Who own the livestock? #2 ID (a6aq3b a6aq3c) 2. Who keeps the livestock that the HH owns? (a6aq3d a6aq3e) 3. Who keeps the livestock that the HH does not own? (a6aq4b a6aq4c)
*Notes: Should I use Only the question with ownership of livestock or both? Or should I go straight to ownership of livestock?
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
* Now merge with member characteristics
merge 1:1 HHID PID  using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen 
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_make_ag_decision.dta", replace


********************************************************************************
                      * WOMEN'S OWNERSHIP OF ASSETS *
********************************************************************************
*SW 8.13.21 Using Tanzania Wave 4 as reference. 
use "${UGS_W3_raw_data}/AGSEC2A", clear
append using "${UGS_W3_raw_data}/AGSEC2B"
append using "${UGS_W3_raw_data}/AGSEC6A"
append using "${UGS_W3_raw_data}/AGSEC6B"
append using "${UGS_W3_raw_data}/AGSEC6C"
gen type_asset=""
gen double asset_owner1=.
gen double asset_owner2=.
*Ownership of land
*Notes: There is no information about ownership of plot, only on a parcel level? Also, we use ownership as ownership of right of the parcel. But in section 2a first question is about ownership of land which may means that only yes responses are available? SEC2B only considered parcels that the hh has users right access (considered, since TZNW4 does) SAW 1.9.23 
replace type_asset="landowners" if !missing(a2aq24a) | !missing(a2aq24b)
replace asset_owner1=a2aq24a 
replace asset_owner2=a2aq24b
*append who has right to sell or use
*preserve
replace type_asset="landowners" if !missing(a2bq21a) | !missing(a2bq21b)
replace asset_owner1=a2bq21a if asset_owner1==.
replace asset_owner2=a2bq21b if asset_owner2==.
*Ownership of Livestock(Cattle and pack animals)
replace type_asset="livestockowners" if !missing(a6aq3b) | !missing(a6aq3c)
replace asset_owner1=a6aq3b if asset_owner1==.
replace asset_owner2=a6aq3c if asset_owner2==.
*Ownership of small animals 
replace type_asset="livestockowners" if !missing(a6bq3b) | !missing(a6bq3c)
replace asset_owner1=a6bq3b if asset_owner1==.
replace asset_owner2=a6bq3c if asset_owner2==.
*Ownership of Poultry and others
replace type_asset="livestockowners" if !missing(a6cq3b) | !missing(a6cq3c)
replace asset_owner1=a6cq3b if asset_owner1==.
replace asset_owner2=a6cq3c if asset_owner2==.
*use "${UGS_W3_raw_data}/GSEC14", clear // No information regarding non-farm implements and machinery. Same with HH assets (Only info on a HH level)
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
ren asset_owner PID
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
* Now merge with member characteristics
merge 1:1 HHID PID  using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ownasset.dta", replace
*SAW 1.9.23 Check With Peter Uganda Wave 7 results, onw_assets mean is 1. 

********************************************************************************
                          * AGRICULTURAL WAGES *
********************************************************************************

*SAW 1.9.23 New version using Nigeria Wave 3 as reference. Might be better for Agquery+
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_labor_long.dta", clear // at the plot season level
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ag_wage.dta", replace

********************************************************************************
                          * CROP YIELDS *
********************************************************************************
*SAW 1.9.23 Using Nigeria Wave 3 as reference, since it uses All Plots sections to construct crop yields.

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
ren crop_code_master crop_code
//Legacy stuff- agquery gets handled above.
collapse (sum) /*area_harv_=ha_harvest*/ area_plan_=ha_planted harvest_=quant_harv_kg, by(HHID dm_gender purestand crop_code)
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
collapse (sum) /*all_area_harvested=area_harv*/ all_area_planted=area_plan, by(HHID)
*replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropname_table.dta", nogen keep(1 3)
merge 1:1 HHID crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
*gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_
drop crop_code kgs_sold kgs_harvest  // SAW 1.9.23 need to drop this 2 vars to make reshape possible
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
}

*replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
*replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
*replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production.dta", replace
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
					(741 742 744						=13	"Bananas")  ////  banana food, banana beer, banana swwet
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
*SAW 1.10.23 wheat tea vanilla sunflower simsim tobacco Need to add to type of commodity revising commodity high/low classification

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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production_grouped.dta", replace
restore
*use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production_grouped.dta", clear

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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
                          * SHANNON DIVERSITY INDEX *
********************************************************************************
*SAW 1.10.23 This section is written using Nigeria Wave 3 as reference, since it is not available for other Uganda waves.
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_area_plan.dta", replace
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0 
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(HHID)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_shannon_diversity_index.dta", replace

********************************************************************************
                          * CONSUMPTION *
********************************************************************************
*SW 1.10.23 This section is written using Uganda Wave 7  as reference. 
use "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate", clear
ren cpexp30 total_cons // 
ren equiv adulteq
ren welfare peraeq_cons
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)
gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30
gen daily_percap_cons = percapita_cons/30 // saw why 30? days in a month? 
lab var total_cons "Total HH consumption, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var peraeq_cons "Consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var percapita_cons "Consumption per capita, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var daily_peraeq_cons "Daily consumption per adult equivalent, in 05/06 prices, spatially and temporally adjusted in 11/12"
lab var daily_percap_cons "Daily consumption per capita, in 05/06 prices, spatially and temporally adjusted in 11/12" 
keep HHID total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_consumption.dta", replace

**We create an adulteq dataset for summary statistics sections
use "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate", clear
rename equiv adulteq
keep HHID adulteq
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_adulteq.dta", replace


********************************************************************************
                          * FOOD SECURITY *
********************************************************************************
*SW 1.10.23 This section is written using Nigeria wave 3 as reference. (Not available for Uganda old wave 3, wave 5, and 7)
use "${UGS_W3_raw_data}/GSEC15B", clear
rename h15bq5 fd_home
rename h15bq7 fd_awayhome
rename h15bq9 fd_ownp
rename h15bq11 fd_gift
egen food_total = rowtotal(fd*) 
*/ SAW This includes food purchased at home, away from home, own production, and gifts.
*rename h15bq15 fd_total
collapse (sum) fd* food_total, by(HHID)
merge 1:1 HHID using "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate", nogen keep(1 3)
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)
drop if equiv ==.
recode fd* food_total (0=.)
gen daily_peraeq_fdcons = food_total/equiv /365 
*SAW I think this is consumption for the last 7 days, might want to multiply by 52? 
gen daily_percap_fdcons = food_total/hh_members/365
*SAW I think this is consumption for the last 7 days, might want to multiply by 52?  Need to get a sense of the poverty line for this year to see if numbers make sense. 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_food_cons.dta", replace
*SAW : Not sure if we can construct food consumption indicators at the season level to track intrayearly food insecurity. 

********************************************************************************
                          * FOOD PROVISION *
********************************************************************************
*SW 1.10.23 This section is written using Nigeria wave 3 as reference. (Not available for Uganda old wave 3, wave 5, and 7)
use "${UGS_W3_raw_data}/GSEC17A", clear //SAW  Have you been faced with a situation when you did not have enough food to feed in the last 12 months Yes/No answer? Maybe this works? The questionnaire includes months when this happened but the actual dataset does not. 
use "${UGS_W3_raw_data}/GSEC17B", clear 
gen food_insecurity = 1 if h17q10a==1
replace food_insecurity = 0 if food_insecurity==.
collapse (sum) months_food_insec= food_insecurity, by(HHID)
lab var months_food_insec "Number of months where the household experienced any food insecurity" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_food_insecurity.dta", replace
*Notes: SAW This dataset only includes households that answered in GSEC17A question h17q9 "Have you been faced with a situation when you did not have enough food to feed the lasth 12 months" as Yes, any household that answered as No, it is not in this final dataset but the values would be equal to 0. ------> after merging recode months_food_insec (.=0)

********************************************************************************
                          *HOUSEHOLD ASSETS*
********************************************************************************

*SW 1.19.23 This section is written using Nigeria Wave 3 as reference. (Available for Uganda wave 7 as well)
use "${UGS_W3_raw_data}/GSEC14", clear 
rename h14q5 value_today
rename h14q4 num_items
*dropping items if hh doesnt report owning them 
keep if h14q3==1
collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets in Shs"
format value_assets %20.0g
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_assets.dta", replace

********************************************************************************
                         *DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument


********************************************************************************
                          *HOUSEHOLD VARIABLES*
********************************************************************************
* This section and final summary statistics datasets are currently being coded. Please continue checking our EPAR Github for future updates.