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
*Date			: This Version - 9 May 2024

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
* This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
* Using data files from within the "Raw DTA Files" folder, the do.file first constructs common and intermediate variables, 
* saving dtafiles when appropriate in the folder "Final DTA Files/created_data" 
*
* These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available in the
* folder "Final DTA Files/final_data". 


* The processed files include all households, individuals, and plots in the sample. Toward the end of the do.file, a block of code estimates summary 
* statistics (mean, standard error of the mean, minimum, first quartile, 
* median, third quartile, maximum) of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.

* The results are saved in the excel file "Uganda_NPS_LSMS_ISA_W5_summary_stats.xlsx" in the "Final DTA Files/final_data" folder. 




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

global root_folder "335_Agricultural-Indicator-Curation"
global UGS_W3_raw_data "$root_folder/Uganda UNPS/Uganda UNPS Wave 3/raw_data"
global UGS_W3_final_data "$root_folder/Uganda UNPS/Uganda UNPS Wave 3/Final DTA Files/final_data"
global UGS_W3_created_data "$root_folder/Uganda UNPS/Uganda UNPS Wave 3/Final DTA Files/created_data"
global directory "$root_folder/_Summary_statistics/"
****************************
*EXCHANGE RATE AND INFLATION
**************************** 

global NPS_LSMS_ISA_W3_exchange_rate 3690.85     
global NPS_LSMS_ISA_W3_gdp_ppp_dollar 1270.608398 
global NPS_LSMS_ISA_W3_cons_ppp_dollar 1221.087646 // updated to 2017 values from https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG // for 2014 
global NPS_LSMS_ISA_W3_inflation .78753179 //CPI_SURVEY_YEAR/CPI_2017 - > CPI_2012/CPI_2017 ->  131.3435875/166.7787747 from https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG  //The data were collected over the period 2011 to 2012 (therefore we use 2012 the latest year)
global UGS_W3_poverty_threshold (1.90*944.255*131.3/116.6)


*Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global NPS_LSMS_ISA_W3_pop_tot 34273295
global NPS_LSMS_ISA_W3_pop_rur 27273317
global NPS_LSMS_ISA_W3_pop_urb 6999978

*Calculation for WB' previous $1.90 (PPP) poverty threshold, 2020.2696 Uganda Shilling UGX. This is calculated as the following: PovertyLine x PPP conversion factor (private consumption)t=2011 (reference year of PL, therefore 2011. This is fixed across waves so no need to change it) x Inflation(from t=2011 to t+1=last year survey was implemented). Inflation is calculated as the following: CPI Uganda inflation from 2011 (baseline year) to 2012 (last survey year) Inflation = Inflation (t=last survey year =2012)/Inflation (t= baseline year of PL =2011) https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG&name_desc=false and https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG

global UGS_W3_poverty_215 2.15*($NPS_LSMS_ISA_W3_inflation) * $NPS_LSMS_ISA_W3_cons_ppp_dollar
*The $2.15 Poverty line ($US) is converted to Uganda Shillings using the PPP Conversion Factor, Consumption of 2017 (so we get the value in UGX 2017) and then we deflate this value to the last year of the survey implementation 2012. The 2.15 PL is 2067.5375 UGX (2017) Notes: This time we had to deflate since our cpp was in 2017 but the last year of the survey was 2012, for the 2011 1.90 poverty line we had to inflate given that the baseline year was 2011 but the last year of the survey was 2012. 
*The national poverty line is merged later since it's already provided by the raw data (Also there npl has variation across regions so it's not a single number)

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

global topcropname_area "maize cassav beans fldpea swtptt fmillt sybea banana coffee grdnt sorgum"
*global topcropname_area "maize rice wheat sorgum fmillt cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea coffee irptt" // SAW Original code - we take cowpea and pigpea out to run code
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
keep region district county subcounty parish ea HHID rural regurb weight
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
gen fhh = (relhead==1 & gender==2) 
collapse (sum) hh_members (max) fhh, by (HHID)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", replace

*CPK: 10.23.23 Re-scaling survey weights to match population estimates
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${NPS_LSMS_ISA_W3_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${NPS_LSMS_ISA_W3_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1
total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${NPS_LSMS_ISA_W3_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0
egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", replace
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", nogen
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", replace

********************************************************************************
** GEOVARIABLES **
********************************************************************************
*Updates based on CSIRO data request.
use "${UGS_W3_raw_data}/UNPS_Geovars_1112", clear 
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta"
keep if source==2
rename lat_mod latitude
rename lon_mod longitude
keep ea latitude longitude
duplicates drop ea latitude longitude, force //ea+lga necessary to uniquely identify ea
gen GPS_level = "ea"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ea_coords.dta", replace

********************************************************************************
*PLOT AREA*
********************************************************************************
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
merge m:1 HHID parcelID using "${UGS_W3_raw_data}/AGSEC2A.dta", nogen
merge m:1 HHID parcelID using "${UGS_W3_raw_data}/AGSEC2B.dta"
*generating field_size
generate parcel_acre = a2aq4 //Used GPS estimation here to get parcel size in acres if we have it, but many parcels do not have GPS estimation
replace parcel_acre = a2bq4 if parcel_acre == . 
replace parcel_acre = a2aq5 if parcel_acre == . //replaced missing GPS values with farmer estimation, which is less accurate but has full coverage (and is also in acres)
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
lab var head "1=Individual is the head of household"
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
merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", gen(dm1_merge) keep(1 3)

*First decision-maker variables
gen dm1_female = female
drop female personid

*Second decision-maker 
ren a3aq3_4a personid
replace personid =a3bq3_4a if personid==. &  a3bq3_4a!=.
tostring personid, format(%18.0f) replace
merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", gen(dm2_merge) keep(1 3) 
gen dm2_female = female
drop female personid

*Third decision-maker 
ren a3aq3_4b personid
replace personid =a3bq3_4b if personid==. &  a3bq3_4b!=.
tostring personid, format(%18.0f) replace
merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", gen(dm3_merge) keep(1 3) 
gen dm3_female = female
drop female personid

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
drop if  plot_id==.
count if parcel_id ==. //6 //ALT: 6
drop if parcel_id == .
duplicates report HHID plot_id season
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", replace

********************************************************************************
*FORMALIZED LAND RIGHTS
********************************************************************************
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen formal_land_rights = 1 if a2aq23<4
replace formal_land_rights = 0 if a2aq23==4  //Here I added this line for HH w/o documents as zero (prior we only had 1's and missing information)

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
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_hh.dta", replace
restore
********************************************************************************
** 								ALL PLOTS									  **
********************************************************************************
/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta */

**********************************
** Crop Values **
**********************************
use "${UGS_W3_raw_data}/AGSEC5A", clear 
gen season=1
append using "${UGS_W3_raw_data}/AGSEC5B"
replace season=2 if season==.
* Unit of Crop Harvested 
clonevar condition_harv = a5aq6b
replace condition_harv = a5bq6b if season==2
clonevar unit_code_harv=a5aq6c
replace unit_code_harv=a5bq6c if unit_code==.
*Unit of Crop Sold
clonevar sold_unit_code =a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
clonevar sold_value= a5aq8
replace sold_value=a5bq8 if sold_value==. 
gen sold_qty=a5aq7a
replace sold_qty=a5bq7a if sold_qty==.
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code
drop if plot_id==. | parcel_id==. | crop_code==.

**********************************
** Standard Conversion Factor Table **
**********************************
*This section calculates Price per kg (Sold value ($)/Qty Sold (kgs)) but using Standard Conversion Factor table instead of raw WB Conversion factor w3 -both harvested and sold.
 *Standard Conversion Factor Table: By using All 7 Available Uganda waves we calculated the median conversion factors at the crop-unit-regional level for both sold and harvested crops. For  crops-unit-region conversion factors that were missing observations, information we imputed the conversion factors at the crop-unit-national level values. 
*This Standard coversion factor table will be used across all Uganda waves to estimate kilogram harvested, and price per kilogram median values. 

***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${UGS_W3_created_data}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${UGS_W3_created_data}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 

*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. // We merge the national standard conversion factor for those HHID with missing regional info. 
gen quant_sold_kg = sold_qty*s_conv_factor_sold
replace quant_sold_kg=. if sold_qty==0 | sold_unit_code==.
gen price_unit = sold_value/quant_sold_kg 
gen obs1 = price_unit!=.

// Loop for price per kg for each crop at different geographic dissagregate using Standard price per kg variable (from standard conversion factor table)
	foreach i in region district county subcounty parish ea HHID {
		preserve
		bys `i' crop_code /*sold_unit_code*/ : egen obs_`i'_price = sum(obs1)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by /*(`i' sold_unit_code crop_code obs_`i'_price)*/ (crop_code /*sold_unit_code*/ `i' obs_`i'_price)
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	preserve
	collapse (median) price_unit_country = price_unit (sum) obs_country_price = obs1 [aw=weight], by(crop_code /*sold_unit_code*/)
	tempfile price_unit_country_median
	save `price_unit_country_median'
	restore

***We merge Crop Harvested Conversion Factor at the crop-unit-regional ***
clonevar  unit_code= unit_code_harv
merge m:1 crop_code unit_code region using "${UGS_W3_created_data}/UG_Conv_fact_harvest_table.dta", keep(1 3) nogen 

***We merge Crop Harvested Conversion Factor at the crop-unit-national ***
merge m:1 crop_code unit_code using "${UGS_W3_created_data}/UG_Conv_fact_harvest_table_national.dta", keep(1 3) nogen 
*This is for HHID that are missing regional information


*From Conversion factor section to calculate medians
clonevar quantity_harv=a5aq6a
replace quantity_harv=a5bq6a if quantity_harv==.
replace s_conv_factor_harv = sn_conv_factor_harv if region==. // We merge the national standard conversion factor for those HHID with missing regional info.
gen quant_harv_kg = quantity_harv*s_conv_factor_harv 

*By using the standard conversion factor we calculate -On average - a higher quantity harvested in kg  that using the WB conversion factors -though there are many cases that standard qty harvested is smaller than the WB qty harvested. 
*Notes: Should we winsorize the sold qty ($) prior to calculating the price per kg giventhis variable is also driving the variation and has many outliers. Though, it won't affect themedian price per kg it will affect the  price per unit for all the observations that do have sold harvested affecting the value of harvest. 

**********************************
* Update: Standard Conversion Factor Table END **
**********************************
* We do not have information about the year of harvest. Questionnaire references the variable to year 2011 and we have information on month of harvest start and month of harvest end. Then we can calculate th

gen month_harv_date = a5aq6e
replace month_harv_date = a5bq6e if season==2
gen harv_date = ym(2011,month_harv_date)
format harv_date %tm
label var harv_date "Harvest start date"

gen month_harv_end = a5aq6f
replace month_harv_end = a5bq6f
gen harv_end = ym(2011,month_harv_end) if month_harv_end>month_harv_date
replace harv_end = ym(2012,month_harv_end) if month_harv_end<month_harv_date
format harv_end %tm
label var harv_end "Harvest end date"

*Create Price unit for converted sold quantity (kgs)
label var price_unit "Average sold value per kg of harvest sold"
gen obs = price_unit!=.
*Checking price_unit mean and sd for each type of crop ->  bys crop_code: sum price_unit
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_value.dta", replace 
*We collapse to get to a unit of analysis at the HHID, parcel, plot, season level instead of ... plot, season, condition and unit of crop harvested*/

**********************************
** Plot Variables **
**********************************
*Clean up file and combine both seasons
preserve 
use "${UGS_W3_raw_data}/AGSEC4A", clear 
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season=2 if season==.
rename plotID plot_id
rename parcelID parcel_id
rename cropID crop_code_plant //crop codes for what was planted
drop if crop_code_plant == .
clonevar crop_code_master = crop_code_plant //we want to keep the original crop IDs intact while reducing the number of categories in the master version
tostring HHID, format(%18.0f) replace
*Merge area variables (now calculated in plot areas section earlier)
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3)	

*Creating time variables (month planted, harvested, and length of time grown) 
gen year_planted = 2010 if Crop_Planted_Year==1 | (Crop_Planted_Year2==1 & season==2)
replace year_planted= 2011 if Crop_Planted_Year==2 | (Crop_Planted_Year2==2 & season==2)

* Update
gen month_planted = Crop_Planted_Month
replace month_planted = Crop_Planted_Month2 if season==2
gen plant_date = ym(year_planted,month_planted)
format plant_date %tm
label var plant_date "Plantation start date"

clonevar crop_code =  crop_code_master 
gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 741, 742, 744, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order SAW everythins works except for 740 banana that is still 741 742 and 744
replace perm_tree = 0 if perm_tree == .
lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?
duplicates drop HHID parcel_id plot_id crop_code season, force // We get rid of Other crops which create merging issues
tempfile plotplanted
save `plotplanted'
restore
merge m:1 HHID parcel_id plot_id crop_code season using `plotplanted', nogen keep(1 3)

**********************************
** Plot Variables After Merge **
**********************************
* Update 
gen months_grown1 = harv_date - plant_date if perm_tree==0
replace harv_date = ym(2012,month_harv_date) if months_grown1<=0
gen months_grown = harv_date - plant_date if perm_tree==0

*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs2 = 1
		replace obs2 = 0 if inrange(a5aq17,1,4) | inrange(a5bq17,1,5) //obs = 0 if crop was lost for some reason like theft, flooding, pests, etc. SAW 6.29.22 Should it be 1-5 not 1-4?
		collapse (sum) crops_plot = obs2, by(HHID parcel_id plot_id season)
		tempfile ncrops 
		save `ncrops'
	restore 
	merge m:1 HHID parcel_id plot_id season using `ncrops', nogen
	gen contradict_mono = 1 if a4aq9 == 100 | a4bq9 == 100 & crops_plot > 1 //6 plots have >1 crop but list monocropping
	gen contradict_inter = 1 if crops_plot == 1
	replace contradict_inter = . if a4aq9 == 100 | a4aq8 == 1 | a4bq9 == 100 | a4bq8 == 1 //meanwhile 145 list intercropping or mixed cropping but only report one crop

*Generate variables around lost and replanted crops
	gen lost_crop = inrange(a5aq17,1,5) | inrange(a5bq17,1,5) // SAW I think it should be intange(var,1,5) why not include "other"
	bys HHID parcel_id plot_id season : egen max_lost = max(lost_crop) //more observations for max_lost than lost_crop due to parcels where intercropping occurred because one of the crops grown simultaneously on the same plot was lost
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
	replace purestand = 0 if purestand == . //assumes null values are just 0 
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	

	gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys HHID parcel_id plot_id season: egen total_percent = total(percent_field)
	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	replace ha_planted = percent_field*field_size

**********************************
** Crop Harvest Value **
**********************************
*Update Incorporating median price per kg to calculate Value of Harvest ($) - Using Standard Conversion Factors
foreach i in  region district county subcounty parish ea HHID {	
	merge m:1 `i' /*unit_code*/ crop_code using `price_unit_`i'_median', nogen keep(1 3)
}
	merge m:1 /*unit_code*/ crop_code using `price_unit_country_median', nogen keep(1 3)
rename price_unit val_unit

*Generate a definitive list of value variables
// We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
recode obs_* (.=0) //ALT 
foreach i in country region district county subcounty parish ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_HHID if price_unit_HHID != .
gen value_harvest = val_unit*quant_harv_kg 

preserve
	ren unit_code_harv unit
	collapse (mean) val_unit, by (HHID crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_prices_for_wages.dta", replace
	restore
	
*Update

/*CSIRO Data Request
preserve
merge m:1 ea using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ea_coords.dta", nogen keep(1 3)
ren region adm1
ren district adm2
ren county adm3
ren ea adm4
*ren hhid hhID
*ren plot_id plotID
ren crop_code_plant crop //The original, unmodified crop code 
*ren area_est plot_area_reported   //farmer estimated plot area - may need to be created
ren field_size plot_area_measured 
*replace plot_area_measured = . if gps_meas==0
ren percent_field crop_area_share
gen planting_month = month(plant_date)
gen planting_year = year(plant_date)
gen harvest_month_begin = month(harv_date)
gen harvest_month_end = month(harv_end)
gen harvest_year_begin = year(harv_date)
gen harvest_year_end = year(harv_date)
keep adm* HHID parcel_id plot_id crop /*plot_area_reported*/ plot_area_measured crop_area_share planting_month planting_year harvest_month_begin harvest_month_end harvest_year_begin harvest_year_end /*gps_meas*/ purestand
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots_date.dta", replace
restore
	*/
*Combining Banana crops in one category. Update
recode crop_code  (741 742 744 = 740)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values crop_code cropID //apply crop labels to crop_code_master

*AgQuery+
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field (max) months_grown plant_date harv_date harv_end, by(region district county subcounty parish ea HHID parcel_id plot_id season crop_code purestand field_size /*month_planted month_harvest*/)
	bys HHID parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys HHID parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen  keep(1 3) keepusing(dm_gender)
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
ren cropID crop_code 
drop if plot_id == . 
ren a5aq8 value_sold
replace value_sold = a5bq8 if value_sold == . 
recode value_sold (.=0)
ren a5aq7a qty_sold 
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 
gen sold_unit_code=a5aq7c
replace sold_unit_code=a5bq7c if sold_unit_code==.
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keepusing(region district county subcounty parish ea weight) keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 crop_code sold_unit_code region using "${UGS_W3_created_data}/UG_Conv_fact_sold_table.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
*This is for HHID with missiong regional information. 
merge m:1 crop_code sold_unit_code  using "${UGS_W3_created_data}/UG_Conv_fact_sold_table_national.dta", keep(1 3) nogen 
 
*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace s_conv_factor_sold = sn_conv_factor_sold if region==. //  We merge the national standard conversion factor for those HHID with missing regional info. 
gen kgs_sold = qty_sold*s_conv_factor_sold
recode crop_code  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
collapse (sum) value_sold kgs_sold, by (HHID crop_code)
lab var value_sold "Value of sales of this crop"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropsales_value.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", clear
collapse (sum) value_harvest quant_harv_kg  , by (HHID crop_code) // Update: SW We start using the standarized version of value harvested and kg harvested
merge 1:1 HHID crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropsales_value.dta"
replace value_harvest = value_sold if value_sold>value_harvest & value_sold!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value_sold value_crop_sales 
recode  value_harvest value_crop_sales  (.=0)
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (HHID crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production.dta", replace
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (HHID)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${UGS_W3_raw_data}/AGSEC5A", clear
append using "${UGS_W3_raw_data}/AGSEC5B"
ren parcelID parcel_id
ren plotID plot_id
ren cropID crop_code 
recode crop_code  (741 742 744 = 740) //740 is bananas, which is being reduced from different types to just bananas. Same for peas (220).
drop if crop_code==.
rename a5aq16 percent_lost
replace percent_lost = a5bq16 if percent_lost==. & a5bq16!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
tostring HHID, format(%18.0f) replace
merge m:1 HHID crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (HHID)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_losses.dta", replace


********************************************************************************
** 								CROP EXPENSES								  **
******************************************************************************** 
// New labor module. The old one was unwieldy and I'm pretty sure values were still getting dropped. This is better. And I need it for agquery.
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
gen dayshiredtotal = dayshiredmale + dayshiredfemale + dayshiredchild 
replace wagehiredmale = wagehiredmale/dayshiredtotal
replace wagehiredfemale = wagehiredfemale/dayshiredtotal
replace wagehiredchild = wagehiredchild/dayshiredtotal
//
keep HHID parcel_id plot_id season *hired*
drop wagehired dayshiredtotal
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
replace wage = wage_HHID if wage_HHID != . & abs(wage_HHID - mean_wage) / wage_sd < 3 
*  Because he got total days of work for family labor but not for each individual on the hhhd we need to divide total days by number of  subgroups of gender that were included as workers in the farm within each household. OR we could assign median wages irrespective of gender (we would need to calculate that in family hired by geographic levels of granularity irrespective ofgender)
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
drop if dm_gender2 == "" //JHG 5_18_22: 169 observations lost, due to missing values in both plot decision makers and gender of head of hh. Looked into it but couldn't find a way to fill these gaps, although I did minimize them. SAW: We need to fix this at some point, this is due to missing geographic information. 
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
*Notes: Does the quantity for machinery matters here? Right now we haven't constructed a qtymechimp qtymechexp variable so quantity var for mech is always missing. Let Josh now so he can update UG W5.

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

**************************    LAND RENTALS   **********************************

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
collapse (sum) val qty, by(HHID parcel_id plot_id season input itemcode unit) //Andrew's note from Nigeria code: Eventually, quantity won't matter for things we don't have units for. JHG 7_5_22: all this code does is drop variables, it doesn't actually collapse anything
gen exp = "exp"
tostring HHID, format(%18.0f) replace

//Combining and getting prices.
append using `plotrents'
append using `plot_inputs'
append using `phys_inputs'
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", nogen keep(1 3) keepusing(weight)
merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
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
collapse (sum) val* field_size* ha_planted*, by(HHID) //JHG 7_5_22: double-check this section to make sure there is now weirdness with summing up to household level when there are multiple seasons - was too tired when coding this to go back and check
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
ren crop_code cropcode
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_monocrop_plots.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
keep if purestand == 1 //1 = monocropped //File now has 6801 unique entries - it should be noted that some these were grown in mixed plots.

*merge 1:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
ren crop_code cropcode
ren ha_planted monocrop_ha
ren quant_harv_kg kgs_harv_mono // : We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
ren value_harvest val_harv_mono // : We use Kilogram harvested using standard units table (across all waves) and price per kg methodology
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
	replace dm_gender2 = "mixed" if dm_gender==3 | dm_gender==.
	drop dm_gender
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

*3. Meat // SAW 7.8.22 I;ll add a subsection on meat as well just in case we decide to use it, otherwise exclude it. 
/*
use "${UGS_W3_raw_data}/AGSEC8A.dta", clear
rename AGroup_ID livestock_code
gen livestock_code2 = "3. Meat"
rename a8aq1 number_slaught
rename a8aq2 meat_mean
gen quantity_produced = number_slaught*meat_mean
label var quantity_produced "Total live meat slaughtered (kg) in the past 12 months"
rename a8aq3 sales_quantity
rename a8aq5 earnings_sales
gen price_per_unit = earnings_sales/sales_quantity
keep HHID livestock_code sales_quantity earnings_sales livestock_code2 quantity_produced price_per_unit number_slaught meat_mean
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_meat.dta", replace
*Notes: Quantity_sales =0 if hh produced but did not sale, . if did not produce=slaughtered anything. Should we change the 0 to . in the first case?
*/

*We append the 3 subsection of livestock earnings
append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta"
*append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", keep(1 3) nogen
collapse (median) price_per_unit [aw=weight], by (livestock_code2 livestock_code) 
ren price_per_unit price_unit_median_country
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", replace
* Notes: For some specific type of animal we don't have any information on median price_unit (meat) , I assigned missing median price_unit values based on similar type of animals and product type.

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace
merge m:1 livestock_code2 livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", nogen keep(1 3) // We have an issue with price units for some types of meat products and specific animal tpye. I assign those price_unit values for the missing based on similar types of animals with information.
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
* Unlike Nigeria, Uganda has a section on meat production coming from slaughtered animals and their corresponding earning sales, which means we do not need to predict price values for slaughtered animals using live aninmals sold prices like Nigeria did. Though, we do need prices and earnings coming from sales of live animals but we already have earning coming from slaughtered animals.
*Notes: I will construct this section like Nigeria did - including values for slaughted animals using inputed median prices from live animals sales. The only issue I see it is we might be double counting income from meat production and in this ssection inputed income from slaughtered animals. 
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
/* AgQuery 12.0 gen prop_meat_sold = value_slaughtered_sold/value_slaughtered*/ // 
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU.dta", replace


********************************************************************************
**                                 FISH INCOME    		         	          **
********************************************************************************
* No Fish Income data collected in Uganda w3. (Similar to other Uganda waves)

********************************************************************************
**                          SELF-EMPLOYMENT INCOME   		    	          **
********************************************************************************

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

*Processed crops
//Not captured in w5 instrument (or other UGA waves)

*Fish trading
//It is captured in the GSEC12 section (already included)

********************************************************************************
**                             OFF-FARM HOURS      	    	                  **
********************************************************************************
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

*Overhaul of classifications 
g industry=. 
replace industry = 1 if inlist(h8q19a, 151, 112, 123, 121, 114, 214, 244, 246, 247, 248, 315, 341, 342, 343, 344, 345, 346, 347, 348, 349, 411, 412, 414, 516, 531, 421, 422) //Government, public administration, social and personal services, social scientists, engineering, religion
replace industry = 2 if inlist(h8q19a, 211, 223, 224, 231, 232, 233, 236, 237, 241, 311, 312, 323, 324, 325, 326, 328, 331, 332, 333, 335, 351, 352, 322, 321, 222) //Education, higher ed, science, health
replace industry = 3 if inlist(h8q19a, 921, 611, 612, 613, 614, 615, 616, 621, 622, 623) //Agriculture
replace industry = 4 if inlist(h8q19a, 512, 513, 514, 515, 913, 914, 915, 916, 917, 511, 832, 714) //hotels, restaurants, travel, other services like house work, vehicle drivers, etc.
replace industry = 5 if inlist(h8q19a, 931, 711) //Mining
replace industry = 6 if inlist(h8q19a, 932, 712, 713, 715, 721) //Construction
replace industry = 7 if inlist(h8q19a, 933, 934, 935, 941, 313, 723, 724, 833, 841, 741, 545, 821, 829) //Laborers/manufacturing/large scale processing
replace industry = 8 if inlist(h8q19a, 549, 521, 522, 523, 911, 912, 542, 541, 535, 536, 537, 534) //Retail, buyers, wholesale
replace industry = 9 if inlist(h8q19a, 732, 733, 734, 743, 744, 745, 751, 543, 722, 245) //Craftsmen, artists, writers
replace industry = 10 if inlist(h8q19a, 355, 999, 1000) //Other

label define industry 1 "Government, public admin, social services" 2 " Education, science, health" 3 "Agriculture" 4 "Hotel, Restaurant, travel, home services" 5 "Mining" 6 "Construction" 7 "Laborers/large scale processing/manufacturing"  8 "Retail, wholesale" 9 "Craftsmen, artists, writers" 10 "Other"
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

g industry=. 
replace industry = 1 if inlist(h8q19a, 151, 112, 123, 121, 114, 214, 244, 246, 247, 248, 315, 341, 342, 343, 344, 345, 346, 347, 348, 349, 411, 412, 414, 516, 531, 421, 422, 122, 141, 213) //Government, public administration, social and personal services, social scientists, engineering, religion
replace industry = 2 if inlist(h8q19a, 211, 223, 224, 231, 232, 233, 236, 237, 241, 311, 312, 323, 324, 325, 326, 328, 331, 332, 333, 335, 351, 352, 322, 321, 222, 329, 212, 235, 334, 238) //Education, higher ed, science, health
replace industry = 3 if inlist(h8q19a, 921, 611, 612, 613, 614, 615, 616, 621, 622, 623) //Agriculture
replace industry = 4 if inlist(h8q19a, 512, 513, 514, 515, 913, 914, 915, 916, 917, 511, 832, 714) //hotels, restaurants, travel, other services like house work, vehicle drivers, etc.
replace industry = 5 if inlist(h8q19a, 931, 711, 811) //Mining
replace industry = 6 if inlist(h8q19a, 932, 712, 713, 715, 721) //Construction
replace industry = 7 if inlist(h8q19a, 933, 934, 935, 941, 824, 816, 825, 828) //Laborers/manufacturing/large scale processing
replace industry = 8 if inlist(h8q19a, 549, 521, 522, 523, 911, 912, 542, 541, 535, 536, 537, 534, 327, 532) //Retail, buyers, wholesale
replace industry = 9 if inlist(h8q19a, 313, 723, 724, 833, 841, 741, 545, 821, 829, 827, 731, 314, 812, 817, 823, 814, 831) //Manufacturing 
replace industry = 10 if inlist(h8q19a, 732, 733, 734, 743, 744, 745, 751, 543, 722, 245) //Craftsmen, artists, writers
replace industry = 11 if inlist(h8q19a, 355, 999, 1000, 918, 403, 354, 413) //Other

// (Updated industry codes and fixed non-ag income so this ACTUALLY generates non-ag income)

label define industry 1 "Government, public admin, social services" 2 " Education, science, health" 3 "Agriculture" 4 "Hotel, Restaurant, travel, home services" 5 "Mining" 6 "Construction" 7 "Laborers/large scale processing"  8 "Retail, wholesale" 9 "Manufacturing" 10 "Craftsmen, artists, writers" 11 "Other"
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
replace most_recent_payment = . if industry == 3
*replace most_recent_payment = . if (h8q19a > 611 & h8q19a < 623) | h8q19a != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct? SAW We are getting rid of subsistance ag workers income 68% of all observations why?? Double check is it because we are only includin non-ag income here?
rename h8q31c payment_period
rename h8q31b most_recent_payment_other
replace most_recent_payment_other = . if industry == 3
*SAW We do the same for Secondary Jobs
rename h8q44 secwage_number_months
rename h8q44_1 secwage_number_weeks
replace secwage_number_weeks=. if secwage_number_weeks>4 // number of weeks worked per month cant be higher than 4 (10 obs)
gen secwage_hours_pastweek = h8q43  // Total hours worked in 2ndary job for the past week. 
rename h8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if industry == 3
*replace secwage_most_recent_payment = . if (h8q38a > 611 & h8q38a < 623) | h8q38a != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct? SAW 9.19.22 Change it to work done in 2dary job not the main job (it was using the same prevoous variable h8q19a)
rename h8q45c secwage_payment_period
rename h8q45b secwage_recent_payment_other
replace secwage_recent_payment_other = . if industry == 3

*Non Ag Wages Income Main Job
gen annual_salary_cash = most_recent_payment*(weeks/4) if payment_period==4 
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2 
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*(weeks/4) if payment_period==4 
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
/*
UGS Wave 1 did not capture number of weeks per month individual worked. 
We impute these using median values by industry and type of residence using UGS W2
see imputation below. This follows RIGA methods.
*/
//use wave 2 income as reference
use "${UGS_W3_raw_data}/GSEC8.dta", clear
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta", nogen
//Classification of Industry to get median wage for imputation, taken from r coding
/*
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
*/
g industry=. 
replace industry = 1 if inlist(h8q19a, 151, 112, 123, 121, 114, 214, 244, 246, 247, 248, 315, 341, 342, 343, 344, 345, 346, 347, 348, 349, 411, 412, 414, 516, 531, 421, 422, 122, 141, 213) //Government, public administration, social and personal services, social scientists, engineering, religion
replace industry = 2 if inlist(h8q19a, 211, 223, 224, 231, 232, 233, 236, 237, 241, 311, 312, 323, 324, 325, 326, 328, 331, 332, 333, 335, 351, 352, 322, 321, 222, 329, 212, 235, 334, 238) //Education, higher ed, science, health
replace industry = 3 if inlist(h8q19a, 921, 611, 612, 613, 614, 615, 616, 621, 622, 623) //Agriculture
replace industry = 4 if inlist(h8q19a, 512, 513, 514, 515, 913, 914, 915, 916, 917, 511, 832, 714) //hotels, restaurants, travel, other services like house work, vehicle drivers, etc.
replace industry = 5 if inlist(h8q19a, 931, 711, 811) //Mining
replace industry = 6 if inlist(h8q19a, 932, 712, 713, 715, 721) //Construction
replace industry = 7 if inlist(h8q19a, 933, 934, 935, 941, 824, 816, 825, 828) //Laborers/manufacturing/large scale processing
replace industry = 8 if inlist(h8q19a, 549, 521, 522, 523, 911, 912, 542, 541, 535, 536, 537, 534, 327, 532) //Retail, buyers, wholesale
replace industry = 9 if inlist(h8q19a, 313, 723, 724, 833, 841, 741, 545, 821, 829, 827, 731, 314, 812, 817, 823, 814, 831) //Manufacturing 
replace industry = 10 if inlist(h8q19a, 732, 733, 734, 743, 744, 745, 751, 543, 722, 245) //Craftsmen, artists, writers
replace industry = 11 if inlist(h8q19a, 355, 999, 1000, 918, 403, 354, 413) //Other
label define industry 1 "Government, public admin, social services" 2 " Education, science, health" 3 "Agriculture" 4 "Hotel, Restaurant, travel, home services" 5 "Mining" 6 "Construction" 7 "Laborers/large scale processing"  8 "Retail, wholesale" 9 "Manufacturing" 10 "Craftsmen, artists, writers" 11 "Other"
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
replace most_recent_payment = . if industry!=3 // SAW We get rid of all non agricultural related wages 
rename h8q31c payment_period
rename h8q31b most_recent_payment_other
*SAW We do the same for Secondary Jobs
rename h8q44 secwage_number_months
rename h8q44_1 secwage_number_weeks
replace secwage_number_weeks=. if secwage_number_weeks>4 // number of weeks worked per month cant be higher than 4 (10 obs)
gen secwage_hours_pastweek = h8q43  // Total hours worked in 2ndary job for the past week. 
rename h8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if industry!=3 // SAW We get rid of all non agricultural related wages 
rename h8q45c secwage_payment_period
rename h8q45b secwage_recent_payment_other

*Non Ag Wages Income Main Job
gen annual_salary_cash = most_recent_payment*(weeks/4) if payment_period==4 
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2 
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*(weeks/4) if payment_period==4 
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
**                           LAND SIZE     				    	              **
********************************************************************************
*Determining whether crops were grown on a plot
use "${UGS_W3_raw_data}/AGSEC4A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B.dta" 
replace season = 2 if season == .
drop if plotID==.
gen crop_grown = 1 
collapse (max) crop_grown, by(HHID parcelID /*plotID*/) 
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crops_grown.dta", replace
*Notes: The parcel had crops grown in at least one season. 

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
*Notes:  We currently do not differentiate between visits or seasons, cultivated =1 if in at least one visit there was a cultivated parcel.

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen cultivated = (a2aq11a==1 | a2aq11a==2 | a2aq11b==1 | a2aq11b==2)
replace cultivated = (a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2) if (a2aq11a==. & a2aq11b==.)
replace cultivated=. if cultivated==0 & (a2aq11a==. & a2aq11b==. & a2bq12a==. & a2bq12b==.)
keep if cultivated==1
*Get parcel acres size, I prioritize GPS measurement than farmer estimate (cases when we had both measures) contrary to wave 7 which does the opposite.
gen area_acres_meas = a2aq4
replace area_acres_meas = a2bq4 if area_acres_meas==. & (a2bq4!=. | a2bq4!=0)
replace area_acres_meas = a2aq5 if area_acres_meas==. & (a2aq5!=. | a2aq5!=0)
replace area_acres_meas =  a2bq5 if area_acres_meas==. & (a2bq5!=. | a2bq5!=0)
tostring HHID, format(%18.0f) replace
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size.dta", replace
*Notes: Land Size in hectares of all parcels in each household.

*All agricultural land 
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
tostring HHID, format(%18.0f) replace
drop if parcelID==.
merge 1:1 HHID parcelID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crops_grown.dta", nogen
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
collapse (max) agland (sum) farm_area, by (HHID parcelID)
lab var agland "1= Parcel was used for crop cultivation or pasture or left fallow in this past year (forestland and other uses excluded)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_agland.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_agland.dta", replace
collapse (sum) farm_area, by (HHID)
ren farm_area farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmsize_all_agland.dta", replace

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
replace season = 2 if season == .
gen rented_out = (a2aq11a==3 | a2aq11b==3 | a2bq12a==3 | a2bq12b==3)
replace rented_out=. if rented_out==0 & (a2aq11a==. | a2aq11b==. | a2bq12a==. | a2bq12b==.)
drop if rented_out==1 
gen parcel_held = 1  
collapse (sum) parcel_held, by (HHID parcelID)
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
gen all_vac_animal=a7bq5a<=2 
keep HHID species vac_animal  all_vac_animal
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
collapse (max) vac_animal all_vac_animal , by(HHID farmerid)
gen double  PID=farmerid // SAW again using gen double so PID values do not get different values 
drop if PID==.
tostring HHID, format(%18.0f) replace
tostring PID, format(%18.0f) replace
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen
keep HHID farmerid vac_animal age female hh_head PID all_vac_animal
lab var vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_vaccine", replace

********************************************************************************
**                        ANIMAL HEALTH - DISEASES     	    	              **
********************************************************************************
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

********************************************************************************
**                             PLOT MANAGER        	                          **
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${UGS_W3_raw_data}/AGSEC4A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season = 2 if season == .
gen use_imprv_seed = (a4aq13==2) if a4aq13!=.
replace use_imprv_seed= (a4bq13==2) if use_imprv_seed==. & a4bq13!=.
*Crop Recode (Must check if applies for Uganda)
recode cropID  (741 742 744 = 740)  //  Same for bananas (740)
label define cropID 740 "Bananas", modify //need to add new codes to the value label, cropID
label values cropID cropID //apply crop labels to crop_code_master
collapse (max) use_imprv_seed, by(HHID parcelID plotID cropID) //SAW Potentially we could do it by season. 
rename parcelID parcel_id
rename plotID plot_id
rename cropID crop_code
tempfile imprv_seed
tostring HHID, format(%18.0f) replace
save `imprv_seed'

use "${UGS_W3_raw_data}/AGSEC3A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
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
tostring HHID, format(%18.0f) replace
tostring PID, format(%19.0f) replace
clonevar personid = PID
merge m:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", nogen keep(1 3)
rename plotID plot_id
rename parcelID parcel_id
tempfile personids
save `personids'

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_input_quantities.dta", clear
foreach i in inorg_fert org_fert pest /*herb*/ {
	recode `i'_rate (.=0)
	replace `i'_rate=1 if `i'_rate >0 
	ren `i'_rate use_`i'
}
collapse (max) use_*, by(HHID parcel_id plot_id) // SAW If in at least one season it used any of i it is coded as 1. 
merge 1:m HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", nogen keep(1 3) keepusing(crop_code)
*ren crop_code_master crop_code
collapse (max) use*, by(HHID parcel_id plot_id crop_code)
merge 1:1 HHID parcel_id plot_id crop_code using `imprv_seed',nogen keep(1 3)
recode use* (.=0)
preserve 
keep HHID parcel_id plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(HHID crop_code)
merge m:1 crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropname_table.dta", nogen keep(3)
drop crop_code	
reshape wide imprv_seed_ hybrid_seed_, i(HHID) j(crop_name) string
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_imprvseed_crop.dta", replace //ALT: this is slowly devolving into a kludgy mess as I try to keep continuity up in the hh_vars section.
restore

merge m:m HHID parcel_id plot_id using `personids', nogen keep(1 3) // SAW personids is at the plot season level while input quantities at the plot level
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(HHID personid female crop_code)
merge m:1 crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropname_table.dta", nogen keep(3)
*decode crop_code, gen(crop_name)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(HHID personid female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
clonevar PID = personid // SAW 15/3/23 I need this for individual summary stats
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use.dta", replace
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
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_input_use.dta", replace
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if personid!=""
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	clonevar PID = personid // SAW 15/3/23 I need this for individual summary stats
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore

*Notes: 2.20.23 SAW If this works I might be able to get rid of Improved seeds and Fertilizers use (sections on top) to reduce lines of code. It ended up being almost same lines of code than just doing them separetely. 
********************************************************************************
**                         REACHED BY AG EXTENSION         	                  **
********************************************************************************
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
use "${UGS_W3_raw_data}/AGSEC8B", clear
keep if AGroup_ID==101 | AGroup_ID==105 
gen milk_animals = a8bq1
gen days_milked = a8bq2
*This won't consider HH that had large ruminant but did not used them to get milk.
gen months_milked = days_milked/30.5
gen liters_day = a8bq3 
gen liters_per_largerruminant = days_milked*liters_day
keep HHID milk_animals months_milked days_milked liters_per_largerruminant liters_day
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/UGS_W3_milk_animals.dta", replace

gen liters_milk_produced = milk_animals*days_milked*liters_day
collapse (sum) milk_animals liters_milk_produced (mean) days_milked months_milked liters_day liters_per_largerruminant, by(HHID)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_milk_animals.dta", replace


********************************************************************************
**                            EGG PRODUCTIVITY                                **
********************************************************************************
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
*All the preprocessing is done in the crop expenses section */
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
replace dm_gender = 3 if dm_gender==.
collapse (sum) ha_planted /*ha_harvest*/ field_size , by(HHID parcel_id plot_id /*season purestand field_size*/) //  All plots section is unable to construct ha harvest variable (no information available)
duplicates drop HHID parcel_id plot_id /*season*/, force // 11 observations deleted
reshape long ha_, i(HHID parcel_id plot_id /*season purestand field_size*/) j(area_type) string
tempfile plot_areas
save `plot_areas' // Unit of Analysis: Plot - purestand level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_cost_inputs_long.dta", replace
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropcosts.dta", replace

*Notes: For Crop production costs per hectare we are adding all costs and area planted across both seasons at the plot level. 
* Season added in green in case we want to compute this section at the household season level. 

********************************************************************************
                    * RATE OF FERTILIZER APPLICATION *
********************************************************************************
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
collapse (sum) ha_planted /*ha_harvest*/, by(HHID parcel_id plot_id season/*season*/ dm_gender) // SAW All plots section is unable to construct ha harvest variable
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

********************************************************************************
            * WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING *
********************************************************************************
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

********************************************************************************
                          * AGRICULTURAL WAGES *
********************************************************************************
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
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
//Legacy stuff- agquery gets handled above.
replace dm_gender = 3 if dm_gender==.
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
gen kgs_harvest_ = harvest_
drop crop_code kgs_sold quant_harv_kg  // SAW 1.9.23 need to drop this 2 vars to make reshape possible
unab vars : *_
reshape wide `vars', i(HHID) j(crop_name) string
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
					(741 742 744 740					=13	"Bananas")  ////  banana food, banana beer, banana swwet
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
use "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate", clear
ren cpexp30 total_cons // 
ren equiv adulteq
ren welfare peraeq_cons
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)
gen percapita_cons = (total_cons / hh_members)
gen daily_peraeq_cons = peraeq_cons/30
gen daily_percap_cons = percapita_cons/30  
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
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
global empty_vars ""
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", clear
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

* Production by group and type of crops
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production_grouped.dta", nogen
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_cost_inputs.dta", nogen

*Crop Costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_inputs_`c'.dta", nogen
	merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`c'_monocrop_hh_area.dta", nogen
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
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish Income // SAW No fish income for Uganda wave 3 
gen fish_income_fishfarm = 0
gen fish_income_fishing =0
gen fishing_income = 0
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"

//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars fish_income*

*Livestock income
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_sales.dta", nogen keep(1 3)
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", nogen keep(1 3)
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU.dta", nogen keep(1 3)
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 HHID using"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU_Coefficients.dta", nogen keep(1 3)
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
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_self_employment_income.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agproducts_profits.dta", nogen keep(1 3)
*SAW: This dataset it is not calculated in Uganda waves. Want to make sure the reason why (not available or it is already part of the self_employment_income dta)
egen self_employment_income = rowtotal(/*profit_processed_crop_sold*/ annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agwage_income.dta", nogen keep(1 3)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_other_income.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_remittance_income.dta", nogen keep(1 3)
*SAW: Remittance income is already included in the other income dataset. (Need to check why)
egen transfers_income = rowtotal (remittance_income pension_income)
*SAW There is a confusion between remittance income and assistance income in the UGanda Other Income section that needs to be revised.
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm Size
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size.dta", nogen keep(1 3)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size_all.dta", nogen keep(1 3)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size_total.dta", nogen keep(1 3)
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
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family (.=0) 

*Household size
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_vaccine.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fert_use.dta", nogen keep(1 3)
*merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_input_use.dta", nogen keep(1 3)
*SAW: This Input Use dataset comes from the Plot Manager section that is constructed in the Nigeria Wave 3 do file which includes fert use and improved seed use along pesticides and fertilizers into one single dataset. We might want to construct this section in Uganda for fewer lines of code in the future. (It comes adter the Fertilizer Use and Improved Seed sections in Uganda)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_imprvseed_crop.dta", nogen keep(1 3)
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_any_ext.dta", nogen keep(1 3)
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
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_milk_animals.dta", nogen keep(1 3)
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
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_eggs_animals.dta", nogen keep(1 3) // eggs_months eggs_per_month eggs_total_year poultry_owned
*gen liters_milk_produced = milk_months_produced * milk_quantity_produced // SAW 2.20.23 Decided to produce this in the milk productivity section
*lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
*gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
*lab var eggs_total_year "Total number of eggs that was produced (household)"
gen egg_poultry_year = . 
*gen poultry_owned = .
global empty_vars $empty_vars *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fertilizer_application.dta", nogen keep(1 3)


*Agricultural wage rate
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ag_wage.dta", nogen keep(1 3)


*Crop yields 
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_yield_hh_crop_level.dta", nogen keep(1 3)


*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)

 
*Household diet
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_household_diet.dta", nogen keep(1 3)


*consumption 
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_food_insecurity.dta", nogen keep(1 3)
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
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_feed_water_house.dta", nogen keep(1 3)

*Shannon Diversity index
merge 1:1 HHID using  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_shannon_diversity_index.dta", nogen keep(1 3)

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
global empty_vars $empty_vars fishing_hh fishing_income
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
gen  imprv_seed_wheat=.
gen hybrid_seed_wheat=.
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
gen ccf_loc = (1/$NPS_LSMS_ISA_W3_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$NPS_LSMS_ISA_W3_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$NPS_LSMS_ISA_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$NPS_LSMS_ISA_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

*Poverty indicators 
gen poverty_under_1_9 = (daily_percap_cons < $UGS_W3_poverty_threshold)
la var poverty_under_1_9 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_2_15 = (daily_percap_cons < $UGS_W3_poverty_215)
la var poverty_under_2_15 "Household per-capita consumption is below $2.15 in 2017 $ PPP"

*We merge the national poverty line provided by the World bank "${UGS_W3_raw_data}/AGSEC9"
merge 1:1 HHID using "${UGS_W3_raw_data}/UNPS 2011-12 Consumption Aggregate.dta", keep(1 3) nogen 
*gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W1_poverty_nbs
rename poor poverty_under_npl
la var poverty_under_npl "Household per-capita consumption is below national poverty line in 05/06 PPP prices"

*generating clusterid and strataid
gen clusterid=ea
gen strataid=region

*dropping unnecessary varables
drop *_inter_*

*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep HHID fhh clusterid strataid *weight* *wgt* region regurb district county subcounty parish ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* /*use_fin_**/ lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired /*ar_h_wgt_* *yield_hv_**/ ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* /**total_harv_area**/ /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* /*nb_cattle_today nb_poultry_today*/ bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* /*area_harv**/  *value_pro* *value_sal*

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren HHID hhid
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2012-13" 
gen instrument = 53 
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
saveold "${UGS_W3_final_data}/UGS_W3_household_variables.dta", replace


********************************************************************************
                          *INDIVIDUAL-LEVEL VARIABLES*
********************************************************************************
*SAW 14/04/23 This section uses Nigeria Wave 3 as reference
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", clear
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_control_income.dta", nogen keep(1 3)
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_make_ag_decision.dta", nogen keep(1 3)
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ownasset.dta", nogen keep(1 3)
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", nogen keep(1 3)
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_fert_use.dta", nogen keep(1 3) // HHID srting  persoind HHID+01 string as well
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_vaccine.dta", nogen keep(1 3)
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3)

*Land rights
merge 1:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_ind.dta", nogen keep(1 3)
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0
ren HHID hhid
*merge in hh variable to determine ag household
preserve
use "${UGS_W3_final_data}/UGS_W3_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.
foreach c in wheat /*beans*/ {
	gen all_imprv_seed_`c' = .
	gen all_hybrid_seed_`c' = .
	gen `c'_farmer = .
}

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
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2012-13" 
gen instrument = 53 
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
gen strataid=region
gen clusterid=ea
saveold "${UGS_W3_final_data}/UGS_W3_individual_variables.dta", replace

********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*SAW 14/04/23 This section uses Nigeria Wave 3 as reference

*GENDER PRODUCTIVITY GAP
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_all_plots.dta", replace
collapse (sum) plot_value_harvest = value_harvest, by(HHID parcel_id plot_id season) // SAW 10.10.23 Usiing Standarized version of value harvested
tempfile crop_values 
save `crop_values' // season level

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", replace // plot-season level
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_weights.dta", keep (1 3) nogen // hh level
merge 1:1 HHID parcel_id plot_id season using `crop_values', keep (1 3) nogen //  plot-season level
merge 1:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", keep (1 3) nogen //  plot-season level
merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_labor_days.dta", keep (1 3) nogen // plot level
ren HHID hhid
/*DYA.12.2.2020*/ merge m:1 hhid using "${UGS_W3_final_data}/UGS_W3_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland region ea)
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

*SAW 4/20/23 Update
****Currency Conversion Factors***
gen ccf_loc = (1/$NPS_LSMS_ISA_W3_inflation) 
lab var ccf_loc "currency conversion factor - 2017 $UGX"
gen ccf_usd = ccf_loc/$NPS_LSMS_ISA_W3_exchange_rate
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$NPS_LSMS_ISA_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$NPS_LSMS_ISA_W3_gdp_ppp_dollar
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

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gendergap.dta", replace 
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
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Uganda"
gen survey = "LSMS-ISA" 
gen year = "2012-13" 
gen instrument = 53
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
saveold "${UGS_W3_final_data}/UGS_W3_field_plot_variables.dta", replace 

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

global list_instruments  "UGS_W3"
do "$directory/EPAR_UW_335_Summary_statistics.do"
*Sebastian notes: We have created this folder in 378.

