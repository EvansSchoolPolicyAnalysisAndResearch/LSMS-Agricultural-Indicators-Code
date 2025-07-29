
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: Agricultural Development Indicators for the LSMS-ISA, Tanzania National Panel Survey (TNPS-LSMS-ISA) Wave 1 (2008-09)
*Author(s)		: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu

*Date			: March 31st, 2025
*Dataset Version: TZA_2008_NPS1_v02_M_STATA_English_labels 	
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Tanzania National Panel Survey was collected by the Tanzania National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period October 2008 - September 2009.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/76

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Tanzania NPS data set.
*Using data files from the "Raw DTA files" folder from within the "Tanzania NPS Wave 1" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_W1_summary_stats.xlsx" in the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Tanzania_NPS_W1_hhids.dta
*INDIVIDUAL IDS						Tanzania_NPS_W1_person_ids.dta
*HOUSEHOLD SIZE						Tanzania_NPS_W1_hhsize.dta
*PLOT AREAS							Tanzania_NPS_W1_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Tanzania_NPS_W1_plot_decision_makers.dta

*MONOCROPPED PLOTS					Tanzania_NPS_W1_[CROP]_monocrop_hh_area.dta

*TLU (Tropical Livestock Units)		Tanzania_NPS_W1_TLU_Coefficients.dta

*GROSS CROP REVENUE					Tanzania_NPS_W1_tempcrop_harvest.dta
									Tanzania_NPS_W1_tempcrop_sales.dta
									Tanzania_NPS_W1_permcrop_harvest.dta
									Tanzania_NPS_W1_permcrop_sales.dta
									Tanzania_NPS_W1_hh_crop_production.dta
									Tanzania_NPS_W1_plot_cropvalue.dta
									Tanzania_NPS_W1_hh_crop_prices.dta
									Tanzania_NPS_W1_crop_losses.dta

*CROP EXPENSES						Tanzania_NPS_W1_wages_mainseason.dta
									Tanzania_NPS_W1_wages_season.dta
									Tanzania_NPS_W1_fertilizer_costs.dta
									Tanzania_NPS_W1_seed_costs.dta
									Tanzania_NPS_W1_land_rental_costs.dta
									Tanzania_NPS_W1_asset_rental_costs.dta
									Tanzania_NPS_W1_transportation_cropsales.dta
									
*CROP INCOME						Tanzania_NPS_W1_crop_income.dta
									
*LIVESTOCK INCOME					Tanzania_NPS_W1_livestock_expenses.dta
									Tanzania_NPS_W1_hh_livestock_products.dta
									Tanzania_NPS_W1_livestock_sales.dta
									Tanzania_NPS_W1_TLU.dta
									Tanzania_NPS_W1_livestock_income.dta

*FISH INCOME						Tanzania_NPS_W1_fishing_expenses_1.dta
									Tanzania_NPS_W1_fishing_expenses_2.dta
									Tanzania_NPS_W1_fish_income.dta
																
*SELF-EMPLOYMENT INCOME				Tanzania_NPS_W1_self_employment_income.dta
									Tanzania_NPS_W1_agproducts_profits.dta
									Tanzania_NPS_W1_fish_trading_revenue.dta
									Tanzania_NPS_W1_fish_trading_other_costs.dta
									Tanzania_NPS_W1_fish_trading_income.dta
									
*WAGE INCOME						Tanzania_NPS_W1_wage_income.dta
									Tanzania_NPS_W1_agwage_income.dta

*OTHER INCOME						Tanzania_NPS_W1_other_income.dta
									Tanzania_NPS_W1_land_rental_income.dta

*FARM SIZE / LAND SIZE				Tanzania_NPS_W1_land_size.dta
									Tanzania_NPS_W1_farmsize_all_agland.dta
									Tanzania_NPS_W1_land_size_all.dta
									Tanzania_NPS_W1_land_size_total.dta
									
*OFF-FARM HOURS						Tanzania_NPS_W1_off_farm_hours.dta

*FARM LABOR							Tanzania_NPS_W1_farmlabor_mainseason.dta
									Tanzania_NPS_W1_farmlabor_season.dta
									Tanzania_NPS_W1_family_hired_labor.dta
									
*VACCINE USAGE						Tanzania_NPS_W1_vaccine.dta
									Tanzania_NPS_W1_farmer_vaccine.dta
									
*ANIMAL HEALTH						Tanzania_NPS_W1_livestock_diseases.dta
									
*USE OF INORGANIC FERTILIZER		Tanzania_NPS_W1_fert_use.dta
									Tanzania_NPS_W1_farmer_fert_use.dta
									
*USE OF IMPROVED SEED				Tanzania_NPS_W1_improvedseed_use.dta
									Tanzania_NPS_W1_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Tanzania_NPS_W1_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Tanzania_NPS_W1_fin_serv.dta
*MILK PRODUCTIVITY					Tanzania_NPS_W1_milk_animals.dta
*EGG PRODUCTIVITY					Tanzania_NPS_W1_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Tanzania_NPS_W1_hh_rental_rate.dta
									Tanzania_NPS_W1_hh_cost_land.dta
									Tanzania_NPS_W1_hh_cost_inputs_lrs.dta
									Tanzania_NPS_W1_hh_cost_inputs_srs.dta
									Tanzania_NPS_W1_hh_cost_seed_lrs.dta
									Tanzania_NPS_W1_hh_cost_seed_srs.dta		
									Tanzania_NPS_W1_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Tanzania_NPS_W1_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Tanzania_NPS_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Tanzania_NPS_W1_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Tanzania_NPS_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Tanzania_NPS_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Tanzania_NPS_W1_ownasset.dta

*CROP YIELDS						Tanzania_NPS_W1_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Tanzania_NPS_W1_shannon_diversity_index.dta
*CONSUMPTION						Tanzania_NPS_W1_consumption.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Tanzania_NPS_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Tanzania_NPS_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Tanzania_NPS_W1_field_plot_variables.dta
*SUMMARY STATISTICS					Tanzania_NPS_W1_summary_stats.xlsx
*/


clear
clear matrix 
clear mata 
set more off
set maxvar 8000

global directory "../.." //Update this to match the path to your local repo

//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Tanzania_NPS_W1_raw_data "$directory/Tanzania NPS/Tanzania NPS Wave 1\Raw DTA Files"
global Tanzania_NPS_W1_created_data "$directory/Tanzania NPS/Tanzania NPS Wave 1/Final DTA Files/created_data"
global Tanzania_NPS_W1_final_data  "$directory/Tanzania NPS/Tanzania NPS Wave 1/Final DTA Files/final_data"

/*
TNPS Wave 1 did not capture number of weeks per month indidivudal worked.
We impute these using median values by industry and type of residence using TNPS wave 2
see imputation below. This follows RIGA methods to deal with this issue
*/
global Tanzania_NPS_W2_raw_data 	    	"$directory/Tanzania NPS/Tanzania NPS Wave 2/Raw DTA Files"
global Tanzania_NPS_W2_created_data  	"$directory/Tanzania NPS/Tanzania NPS Wave 2/Final DTA Files/created_data"
global Tanzania_NPS_W2_final_data  		"$directory/Tanzania NPS/Tanzania NPS Wave 2/Final DTA Files/final_dta"

global summary_stats "${directory}/_Summary_Statistics/EPAR_UW_335_SUMMARY_STATISTICS.do" //This file calculates summary statistics for rural households for the indicators constructed in the in the "created data" and is executed at the end of the file; it can take several minutes to run.

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************

global Tanzania_NPS_W1_exchange_rate 2158			// https://www.bloomberg.com/quote/USDETB:CUR
global Tanzania_NPS_W1_gdp_ppp_dollar 762.96 // 889.45 was the value in 2017  https://data.worldbank.org/indicator/PA.NUS.PPP		// UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Tanzania_NPS_W1_cons_ppp_dollar 681.85 // 777.6 was the value in 2017 https://data.worldbank.org/indicator/PA.NUS.PRVT.PP	// UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Tanzania_NPS_W1_infl_adj  (94.2/200.7)	// (84/175) was the infl rate in 2017. Data was collected during 2008-09. Base year should be 2024 and is available as of the most recent update. As of 2025, we want to adjust the value to 2021 // I = CPI 2009/CPI 2021 = 84/200.7  https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=TZ
global Tanzania_NPS_W1_poverty_190 (1.9 * 588.8 * (94.2/112.7)) //$1.90 was the poverty line in 2011. 588.8 was the PPP in 2011. Since the survey was conducted in 2008-2009, we deflate based on CPI (2009)/CPI (2011)
//Previous international extreme poverty line
global Tanzania_NPS_W1_poverty_npl (1200 * (94.2/112.7)) //Similarly, line is set based on assumption of 1200 TSH/day in 2011/2012, deflated to 2009. Included for comparison purposes; adjusted for inflation although it is not clear if that happens internally. https://documents1.worldbank.org/curated/en/679851467999966244/pdf/AUS6819-WP-v1-P148501-PUBLIC-Tanzania-summary-15Apr15-Box391437B.pdf
global Tanzania_NPS_W1_poverty_215 (2.15*777.6*(94.2/175)) //$2.15 was the poverty line in 2017. 777.6 was the PPP in 2017 so we deflate based on CPI (2009)/CPI (2017) since that is the year we're adjusting for.

global Tanzania_NPS_W1_poverty_300 (3.00 * $Tanzania_NPS_W1_infl_adj * $Tanzania_NPS_W1_cons_ppp_dollar ) //$3.00 is the new poverty line in international PPP dollars which has been updated to 2021.

global Tanzania_NPS_W1_pop_tot 42570728 //
global Tanzania_NPS_W1_pop_rur 31171990 // 
global Tanzania_NPS_W1_pop_urb 11398738 //

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "maize rice wheat sorgum pmill grdnt bencwp yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "11 12 16 13 14 43 931 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 43, 931, 24, 22, 21, 71, 50, 41, 34"
global topcropname_area_full "maize rice wheat sorghum pearl-millet groundnuts beans-cowpeas yam sweet-potato cassava banana cotton sunflower pigeon-peas"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
//display "$nb_topcrops"

set obs $nb_topcrops //Update if number of crops changes
egen rnum = seq(), f(1) t($nb_topcrops)
gen crop_code = .
gen crop_name = ""
forvalues k=1(1)$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area 
	replace crop_code = `c' if rnum==`k'
	replace crop_name = "`cn'" if rnum==`k'
}
drop rnum
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_cropname_table.dta", replace 


********************************************************************************
*HOUSEHOLD IDS 
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_A_T.dta", clear
ren hh_weight_trimmed weight
ren rural oldrural
gen rural=oldrural=="Rural"
ren hhno household 
keep hhid region district ward ea rural weight strataid clusterid household
lab var rural "1=Household lives in a rural area"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", replace

********************************************************************************
*INDIVIDUAL IDS
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_B_C_D_E1_F_G1_U.dta", clear
ren sbmemno personid
keep hhid personid sbq2 sbq4 sbq5
gen female=sbq2==2 
lab var female "1= indivdual is female"
gen age=sbq4
lab var age "Indivdual age"
gen hh_head=sbq5==1 
lab var hh_head "1= individual is household head"
gen indiv=personid 
drop sbq2 sbq4 sbq5
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", replace
 
********************************************************************************
*HOUSEHOLD SIZE
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_B_C_D_E1_F_G1_U.dta", clear
gen hh_members = 1
ren sbq5 relhead 
ren sbq2 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhsize.dta", replace

merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", nogen
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Tanzania_NPS_W1_pop_tot}/el(temp,1,1) //scaling pweight to given total population rather than pop total calculated from survey weights
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Tanzania_NPS_W1_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_rur]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Tanzania_NPS_W1_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_weights.dta", replace

********************************************************************************
*PLOT AREAS
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_2A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_2B.dta"
ren plotnum plot_id
gen area_acres_est = s2aq4
replace area_acres_est = s2bq9 if area_acres_est==.
gen area_acres_meas = area
keep if area_acres_est !=.
keep hhid plot_id area_acres_est area_acres_meas
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
gen field_size = area_meas_hectares 
replace field_size = area_est_hectares if field_size==. 
la var field_size "Plot area, using estimated area if not measured"
drop area_est_hectares
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta", replace


********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
gen season=0
gen cultivate = s3aq3==1
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
recode season (.=1)
drop if s3bq3==. & s3aq3==. // 5097 dropped 
*drop if hhid == "51020010120086" & plotnum == "M1" & season == 2 //duplicate plots in 3A and 3B 
*drop if hhid == "51020010120089" & plotnum == "M1" & season == 2 //duplicate plots in 3A and 3B 
replace cultivate = 1 if  s3bq3==1 
ren plotnum plot_id 
*Gender/age variables
gen indiv1 = s3aq6_1
replace indiv1 = s3bq6_1 if indiv1==. & s3bq6_1!=.
gen indiv2 = s3aq6_2
replace indiv2=s3bq6_2 if indiv2==.
gen indiv3=s3aq6_3 
replace indiv3=s3bq6_3 if indiv3==.
keep hhid plot_id season indiv* cultivate
reshape long indiv, i(hhid plot_id season cultivate) j(indivno )
collapse (min) indivno, by(hhid plot_id indiv season cultivate) //Removing excess observations to accurately estimate the number of decisionmakers in mixed-managed plots. Taking the highest rank
merge m:1 hhid indiv using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", nogen keep(1 3)		// Dropping unmatched from using
preserve 
keep hhid plot_id indiv female season
save  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_dm_ids.dta", replace
restore
gen dm1_gender = female+1 if indivno==1
collapse (mean) female (firstnm) dm1_gender, by(hhid plot_id season)
gen dm_gender=3
replace dm_gender=1 if female==0
replace dm_gender=2 if female==1
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
la val dm1_gender dm_gender 
lab var  dm_gender "Gender of plot manager/decision maker"
lab var dm1_gender "Gender of primary plot manager"
*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_weights.dta", nogen keepusing(fhh) 								// all matched
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
drop if  plot_id==""
//lab var cultivated "1=Plot has been cultivated"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_decision_makers.dta", replace

********************************************************************************
*ALL PLOTS
********************************************************************************
/* This is a new module that's designed to combine/streamline a lot of the crop
data processing. My goal is to have crops crunched down to 2-ish sections; one for
production, and the second for expenses.
	Workflow:
		Combine all plots into a single file
		Calculate area planted and area harvested
		Determine (actual) purestand/mixed plot status
		Determine yields
		Generate geographic medians for prices 
		Determine value
*/

*formalized land rights 
use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
gen season=0
gen cultivated = s3aq3==1
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
recode season (.=1)
replace s3aq26 = s3bq26 if s3aq26==.		// replacing with values in season  for season  observations
gen formal_land_rights = s3aq26>=1 & s3aq26<=7										// Note: Including anything other than "no documents" as formal

*Individual level (for women)
ren s3aq27_* indiv1*
ren s3bq27_* indiv2*
keep hhid formal_land_rights indiv*
gen dummy=_n
reshape long indiv, i(hhid formal_land_rights dummy) j(personno) //Can drop
drop personno dummy
merge m:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", nogen keep(3)
gen formal_land_rights_f = formal_land_rights==1 & female==1
preserve
collapse (max) formal_land_rights_f, by(hhid indiv)		
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rights_ind.dta", replace
restore	
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rights_hh.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_5A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_7A.dta"
gen season=0 
append using "${Tanzania_NPS_W1_raw_data}/SEC_5B.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_7B.dta"
recode season(.=1)
ren zaocode crop_code
recode s5aq2 s5bq2 s5aq5 s5aq7 s5bq5 s5bq7 s7aq3 s7bq3 (.=0)
gen quantity_sold = s5aq2 
replace quantity_sold=s5bq2 if quantity_sold==0
replace quantity_sold=s5aq5+s5aq7 if quantity_sold==0 
replace quantity_sold = s5bq5 + s5bq7 if quantity_sold==0
replace quantity_sold = s7aq3 if quantity_sold==0
replace quantity_sold = s7bq3 if quantity_sold==0

recode s5aq3 s5bq3 s7aq3 s7bq3 s7aq4 s7bq4 s5aq6 s5aq8 s5bq6 s5bq8 (.=0)
gen value_sold=s5aq3 
replace value_sold=s5aq6+s5aq8 if value_sold==0
replace value_sold=s5bq3 if value_sold==0
replace value_sold=s5bq6+s5bq8 if value_sold==0
replace value_sold=s7aq4 if value_sold==0
replace value_sold=s7bq4 if value_sold==0

collapse (sum) quantity_sold value_sold, by (hhid crop_code) //Although we expect crop prices to vary by season, the small number of observations results in striking differences between observed prices between seasons for some crops; it's necessary, therefore, to combine seasons.
recode value_sold (0=.)
lab var quantity_sold "Kgs sold of this crop"
lab var value_sold "Value sold of this crop"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_weights.dta", nogen keep(1 3) keepusing(region district ward ea weight_pop_rururb)
gen weight=quantity_sold*weight_pop_rururb
gen obs=price_kg !=. & weight!=.
foreach i in region district ward ea hhid {
preserve
	collapse (median) val_kg_`i'=price_kg (rawsum) obs_`i'_kg=obs  [aw=weight], by (`i' crop_code)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore
}
preserve
collapse (median) val_kg_country = price_kg (rawsum) obs_country_kg=obs [aw=weight], by(crop_code)
tempfile val_kg_country_median
save `val_kg_country_median'
restore

save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_sales.dta", replace
 
use "${Tanzania_NPS_W1_raw_data}/SEC_4A.dta", clear
	append using "${Tanzania_NPS_W1_raw_data}/SEC_6A.dta"
	gen season=0 
	append using "${Tanzania_NPS_W1_raw_data}/SEC_4B.dta"
	append using "${Tanzania_NPS_W1_raw_data}/SEC_6B.dta"
recode season (.=1)
ren plotnum plot_id 
ren zaocode crop_code
drop if crop_code==.
ren s6aq2 number_trees_planted
replace number_trees_planted = s6bq2 if number_trees_planted==.
sort hhid plot_id crop_code
bys hhid plot_id season : gen cropid = _n //Get number of crops grown on each plot in each season
bys hhid plot_id season : egen num_crops = max(cropid)
gen purestand = 1 if s4aq6==2 | s4bq6==2 | s6aq5==2 | s6bq5==2 
replace purestand = 1 if num_crops==1 //1240 plots where only one crop was reported but not tagged as purestand above
replace purestand = 0 if num_crops > 1 // 432 obs reported monocropping but had > 1 crop 

gen use_imprv_seed = s4aq23==2 | s4bq23==2
gen prop_planted = s4aq4/4
replace prop_planted = s4bq4/4 if prop_planted==.
replace prop_planted=1 if s4bq3==1 | s4aq3==1
//Remaining issue is tree crops: we don't have area harvested nor area planted, so if a tree crop is reported as a purestand but grown on a plot with other crops, we have to assume that the growers accurately estimate the area of their remaining crops; this can lead to some incredibly large plant populations on implausibly small patches of ground. For now, I assume a tree is purestand if it's the only crop on the plot (and assign it all plot area regardless of tree count) or if there's a plausible amount of room for at least *some* trees to be grown on a subplot.
replace prop_planted = 1 if prop_planted==. & num_crops==1 
bys hhid plot_id season : egen total_prop_planted=sum(prop_planted)
bys hhid plot_id : egen max_prop_planted=max(total_prop_planted) //Used for tree crops
gen intercropped = s6aq5
replace intercropped = s6bq5 if intercropped==.
replace purestand=0 if prop_planted==. & (max_prop_planted>=1 | intercropped==1) //No changes
merge m:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
gen est_ha_planted=prop_planted*field_size //Used later.
replace prop_planted = prop_planted/total_prop_planted if total_prop_planted > 1
replace total_prop_planted=1 if total_prop_planted > 1
gen ha_planted = prop_planted*field_size

gen ha_harvest = s4aq8/2.47105
replace ha_harvest = s4bq8/2.47105 if ha_harvest==.

/*Filling in permcrops
//Per Ayala et al. in technical report 354, bananas and cassava likely occupy non-trivial quantities of land;
//remaining crops may be trivial, but some folks have a lot of permanent crops planted on their plots
	A: Assume purestand plantings that are the only listed crop take up the whole field
	B: For fields where the only crops are permanent crops (i.e., n_permcrops==n_crops), area is proportional to the total number of trees
	C: For fields where the planting is split (i.e., total fraction of annuals planted < 1), permcrops are assigned remaining area according to A or B.
		C.1: For plots that were cultivated in both season and long seasons, trees must take up the smallest area remaining on each plot
	D: For fields where the trees are intercropped/mixed in (i.e., total fraction of annuals >=1), total area planted is both unknown and unknowable; omit.
*/
gen permcrop=number_trees_planted>0 & number_trees_planted!=.
bys hhid plot_id : egen anypermcrop=max(permcrop)
bys hhid plot_id : egen n_permcrops = sum(permcrop)
bys hhid plot_id : egen n_trees=sum(number_trees_planted)
replace ha_planted = number_trees_planted/n_trees*(field_size*(1-max_prop_planted)) if max_prop_planted<=1 & ha_planted==.
recode ha_planted (0=.) 

//Rescaling
//SOP from the previous wave was to assume, for plots that have been subdivided and partially reported as monocropped, that the monocrop area is accurate and the intercrop area accounts for the rest of the plot. 
//Difficulty with accounting for tree crops in both long and season rainy seasons, although there's only a few where this is a problem.
bys hhid plot_id season : gen total_ha_planted=sum(ha_planted)
bys hhid plot_id season : egen max_ha_planted=max(total_ha_planted) 
replace total_ha_planted=max_ha_planted
drop max_ha_planted
bys hhid plot_id season purestand : gen total_purestand_ha = sum(ha_planted)
gen total_mono_ha = total_purestand_ha if purestand==1
gen total_inter_ha = total_purestand_ha if purestand==0
recode total_*_ha (.=0)
bys hhid plot_id season : egen mono_ha = max(total_mono_ha)
bys hhid plot_id season : egen inter_ha = max(total_inter_ha)
drop total_mono_ha total_inter_ha
replace mono_ha = mono_ha/total_ha_planted * field_size if mono_ha > total_ha_planted
gen intercrop_ha_adj = field_size - mono_ha if mono_ha < field_size & (mono_ha+inter_ha)>field_size
gen ha_planted_adj = ha_planted/inter_ha * intercrop_ha_adj if purestand==0
recode ha_planted_adj (0=.)
replace ha_planted = ha_planted_adj if ha_planted_adj!=.

//Harvest
gen kg_harvest = s4aq15
replace kg_harvest = s4bq15 if kg_harvest==.
replace kg_harvest = s6aq8 if kg_harvest==.
replace kg_harvest = s6bq8 if kg_harvest==.
replace kg_harvest = kg_harvest/(1-s4aq14/100) if s4aq12==2 & s4aq14 < 100 //There are several observations ranging from 200-60000
replace kg_harvest = kg_harvest/(1-s4bq14/100) if s4bq12==2 & s4bq14 < 100


	gen over_harvest = ha_harvest > ha_planted & ha_planted!=.
gen lost_plants = s4aq17==1 | s6aq9==1 | s4bq17==1 | s6bq9==1
//Assume that the area harvest=area planted if the farmer does not report crop losses
replace ha_harvest = ha_planted if over_harvest==1 & lost_plants==0 
replace ha_harvest = ha_planted if s6aq9==2 | s6bq9==2 //"Was area harvested less than area planted? 2=no"
replace ha_harvest = ha_planted if permcrop==1 & over_harvest==1 //Lack of information to deal with permanent crops, so rescaling to ha_planted
replace ha_harvest = 0 if kg_harvest==. 
//Remaining observations at this point have (a) recorded preharvest losses (b) have still harvested some crop, and (c) have area harvested greater than area planted, likely because estimated area > GPS-measured area. We can conclude that the area_harvested should be less than the area planted; one possible scaling factor could be area_harvested over estimated area planted.
gen ha_harvest_adj = ha_harvest/est_ha_planted * ha_planted if over_harvest==1 & lost_plants==1 
replace ha_harvest = ha_harvest_adj if ha_harvest_adj !=. & ha_harvest_adj<= ha_harvest
replace ha_harvest = ha_planted if ha_harvest_adj !=. & ha_harvest_adj > ha_harvest //14 plots where this clever plan did not work; going with area planted because that's all we got for these guys

/*
ren s4aq16 value_harvest
replace value_harvest=s4bq16 if value_harvest==.
gen val_kg = value_harvest/kg_harvest
//Bringing in the permanent crop price data.
merge m:1 hhid crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_sales.dta", nogen keep(1 3) keepusing(price_kg)
replace price_kg = val_kg if price_kg==.
drop val_kg
ren price_kg val_kg //Use observed sales prices where available, farmer estimated values where not 
gen obs=kgs_harvest>0 & kg_harvest!=.
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", nogen keep(1 3)
//gen plotweight=ha_planted*weight
*/

merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta"
foreach i in region district ward ea hhid {
	merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
}
merge m:1 crop_code using `val_kg_country_median',nogen keep(1 3)
recode obs* (.=0)
gen val_kg = .
foreach i in country region district ward ea {
	replace val_kg = val_kg_`i' if obs_`i'_kg >9
}
	
	replace val_kg_hhid = val_kg if val_kg_hhid==.
	gen value_harvest=val_kg*kg_harvest 
	gen value_harvest_hh = val_kg_hhid * kg_harvest
	replace value_harvest = s4aq16 if value_harvest==.
	replace value_harvest = s4bq16 if value_harvest==.
	
preserve
collapse (mean) price_kg=val_kg [aw=kg_harvest], by(hhid crop_code) //get household prices for crops 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_prices.dta", replace
restore

preserve
	//gen month_harv = max(month_harv0 month_harv1)
	collapse (sum) value_harvest /*(max) month_harv*/, by(hhid plot_id season)
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_value_prod.dta", replace //Needed to estimate plot rent values
restore
	//collapse (sum) kgs_harvest value_harvest ha_planted ha_harvest number_trees_planted (min) purestand, by(region district ward ea hhid plot_id crop_code field_size season) 
	//	merge m:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	gen lost_drought = inlist(s4bq10, 1) | inlist(s4bq10, 1)
	gen lost_flood = inlist(s4bq10, 2) | inlist(s4bq10, 2) 
	gen lost_crop = lost_flood | lost_drought	
	
	gen n_crops=1
	gen no_harvest=ha_harvest==. 
	collapse (max) no_harvest  (sum) kg_harvest use_imprv_seed value_harvest value_harvest_hh ha_planted ha_harvest number_trees_planted n_crops (min) purestand, by(region district season ward ea hhid plot_id crop_code field_size total_ha_planted) 
		merge m:1 hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender dm1_gender) //Drops the 3 hhs  we filtered out earlier
		gen percent_field = ha_planted/total_ha_planted
		gen percent_inputs = percent_field if percent_field!=0
		recode percent_inputs (0=.)
		gen missing_vals = percent_inputs==.
		bys *hhid plot_id season : egen max_missing = max(missing_vals)
		replace percent_inputs = . if max_missing == 1
		drop missing_vals percent_field max_missing total_ha_planted
		replace percent_inputs=round(percent_inputs,0.0001) //Getting rid of all the annoying 0.9999999999 etc.
		recode ha_planted (0=.)
		
		//Combining beans and cowpeas together into a single crop_code.
		tab crop_code if crop_code==31 | crop_code==32 
		recode crop_code (31 32=931) //recoding for new consolidated crop bnscps (931) for combined beans and cowpeas 
		label define crop_code 931 "Beans-cowpeas", add
		label values crop_code crop_code
		tab crop_code if crop_code==931 // Check if crops combined 
	
		replace ha_harvest=. if (ha_harvest==0 & no_harvest==1) | (ha_harvest==0 & kg_harvest>0 & kg_harvest!=.)
   replace kg_harvest = . if kg_harvest==0 & no_harvest==1
   drop no_harvest
   gen ha_harv_yld=ha_harvest if ha_planted >=0.05 & !inlist(crop_code, 302,303,304,305,306,19) //Excluding nonfood crops & seaweed 
   gen ha_plan_yld=ha_planted if ha_planted >=0.05 & !inlist(crop_code, 302,303,304,305,306,19) 
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta",replace


//AT: moving this up here and making it its own file because we use it often below
	collapse (sum) ha_planted, by(hhid plot_id) //Use planted area for hh-level expenses 
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_planted_area.dta", replace
	 
********************************************************************************
* CROP EXPENSES *
********************************************************************************
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid plot_id season)
tempfile planted_area
save `planted_area' 


	*********************************
	* 			SEED				*
	*********************************

use "${Tanzania_NPS_W1_raw_data}/SEC_4A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_4B.dta" 
	ren plotnum plot_id
	drop if zaocode==.
	ren zaocode crop_code
	recode crop_code(31 32 = 931)
	label define crop_code 931 "Bnscps", add
	label values crop_code crop_code
	tab crop_code if inlist(crop_code, 931, 31, 32)
//ren ag4a_10c_1 qtyseedexp0 //Not in W2
//ren ag4a_10c_2 unitseedexp0
gen valseedexp0 = s4aq20
//ren ag4b_10c_1 qtyseedexp1
//ren ag4b_10c_2 unitseedexp1
gen valseedexp1 = s4bq20
/* For implicit costing - currently omitting (see comments below)
gen qtyseedimp0 = ag4a_10_1 - qtyseedexp0 if ag4a_10_2==unitseedexp0 //Only one ob without same units
gen qtyseedimp1 = ag4b_10_1 - qtyseedexp1 if ag4b_10_2==unitseedexp1 
gen valseedimp0 =.
gen valseedimp1 =.*/ 
collapse (sum) val*, by(hhid plot_id) // Note: All of the crop expenses are accounted for at the plot level   
tempfile seeds 
save `seeds' 
	
	******************************************************
	* LABOR, CHEMICALS, FERTILIZER, LAND   				 *
	******************************************************
	use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
	merge 1:1 hhid plotnum using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta", nogen
	//keep if ag3a_03==1 | ag3b_03==1
ren plotnum plot_id
merge 1:1 hhid plot_id using `seeds', nogen
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
	//No way to disaggregate by gender of worker because instrument only asks for aggregate pay.
	gen wagesexp0=(s3aq63_3+s3aq63_6+s3aq63_6) 
	gen wagesexp1=(s3bq63_3+s3bq63_6+s3bq63_6)

	*drop ag3b_70_id* ag3a_70_id* // dropping all variables after ag3b_70_id
	egen hh_labor0= rowtotal(s3aq61_*) //total days of labor performed by all household members, by season
	egen hh_labor1 = rowtotal(s3bq61_*)

// Generating labor tempfile with paid wages and total hours worked by household members 
preserve 
	keep hhid plot_id wages*
	reshape long wagesexp, i(hhid plot_id) j(season)
	rename wagesexp val
	gen input = "hired_labor"
	gen exp="exp"
	tempfile hired_labor
	save `hired_labor'
restore
preserve
	keep hhid plot_id hh_labor*
	reshape long hh_labor, i(hhid plot_id) j(season)
	ren hh_labor val
	gen input = "hh_labor"
	gen exp="imp" //Not that we can determine value here. Estimated daily wages range from 100 to >100,000 shillings
	append using `hired_labor'
	** error 
	sort hhid plot_id season input //changed y1 to hhid
	tempfile labor
	save `labor'
restore 

ren s3aq51_amount qtypestexp0 //
ren s3aq51_measure unitpestexp0 // 
ren s3aq52 valpestexp0 // 
ren s3bq51_amount qtypestexp1  // 
ren s3bq51_measure unitpestexp1 // 
ren s3bq52 valpestexp1 // 

foreach i in pestexp {
	foreach j in 0 1 {
	replace qty`i'`j'=qty`i'`j'/1000 if unit`i'`j'==3 & qty`i'`j'>9 //Assuming instances of very small amounts are typos. 
	replace unit`i'`j'=2 if unit`i'`j'==3
		}
	}

ren s3aq38 qtyorgfertexp0 // 
recode qtyorgfertexp0 (.=0)
ren s3aq41 valorgfertexp0

ren s3bq38 qtyorgfertexp1
recode qtyorgfertexp1 (.=0)
ren s3bq41 valorgfertexp1

/* ALT 07.13.21: I initially set this up like the Nigeria code on the assumption that implicit costs were highly relevant to crop production; however, it doesn't seem like this 
is as much of a thing in Tanzania, and there's not enough information to accurately account for them if it turns out that they are. All explicit inputs have price information,
so there's also no need to do geographic medians to fill in holes. I'm leaving the implicit valuation for organic fertilizer and seed in case we come back to this.
gen qtyorgfertimp0 = ag3a_42-qtyorgfertexp0
gen valorgfertimp0 = .
gen qtyorgfertimp1 = ag3b_42-qtyorgfertexp1 
gen valorgfertimp1 = . //We should expect only this value to get filled in by the pricing code.
*/
//Price disaggregation of inorganic fertilizer isn't necessary, because there's no implicit inorganic fertilizer useage
egen qtyinorgfertexp0=rowtotal(s3aq45)
egen valinorgfertexp0=rowtotal(s3aq46) 
egen qtyinorgfertexp1=rowtotal(s3bq45)
egen valinorgfertexp1=rowtotal(s3bq46) 

//Fertilizer units
preserve
//We can estimate how many nutrient units were applied for most fertilizers; DAP is 18-46-0, Urea is 46-0-0, CAN is around 24-0-0, ammonium sulfate is 21-0-0 and rock phosphate is 0-32-0 and NPK is 5-0-0. Source: https://www.frontiersin.org/articles/10.3389/fsufs.2019.00029/pdf
gen input=s3aq46
replace input = s3bq46 if input==.
label define input 1 "DAP" 2 "urea" 3 "TSP" 4 "CAN" 5 "SA" 6 "npk_fert" 7 "mrp"
label values input "input"
decode input, gen (input_inorg) 
gen qty = s3aq47
replace qty = s3bq47 if qty==. 
gen qty_org=qtyorgfertexp0
replace qty_org=qtyorgfertexp1 if qty_org==.
gen n_kg = qty*strmatch(input_inorg, "npk_fert")*0.17 + qty*strmatch(input_inorg, "urea")*0.46 + qty*strmatch(input_inorg, "mrp")*0.24
gen p_kg = qty*strmatch(input_inorg, "npk_fert")*0.17 + qty*strmatch(input_inorg, "dap")*0.18 + qty*strmatch(input_inorg, "mrp")*0.32 + qty*strmatch(input_inorg, "TSP")*0.45
gen k_kg = qty*strmatch(input_inorg, "npk_fert")*0.17
gen dap_kg = qty*strmatch(input_inorg, "DAP")
gen can_kg = qty*strmatch(input_inorg, "CAN")
gen sa_kg = qty*strmatch(input_inorg, "SA")
gen mrp_kg = qty*strmatch(input_inorg, "mrp")
gen n_org_kg = qty_org*0.01
la var n_kg "Kg of nitrogen applied to plot from inorganic fertilizer"
la var p_kg "Kg of phosphorus applied to plot from inorganic fertilizer"
la var k_kg "Kg of potassium applied to plot from inorganic fertilizer"
la var dap_kg "Kg of Di-ammoium Phosphate applied to plot from inorganic fertilizer"
la var can_kg "Kg of Calcium Ammonium Nitrate applied to plot from inorganic fertilizer"
la var sa_kg "Kg of Ammonium sulphate applied to plot from inorganic fertilizer"
la var mrp_kg "Kg of Rock Phosphate applied to plot from inorganic fertilizer"
la var n_org_kg "Kg of nitrogen from manure and organic fertilizer applied to plot"
gen npk_kg = qty*strmatch(input_inorg, "npk_fert")
gen urea_kg = qty*strmatch(input_inorg, "urea")
la var npk_kg "Total quantity of NPK fertilizer applied to plot"
la var urea_kg "Total quantity of urea fertilizer applied to plot"
collapse (sum) *kg, by(hhid plot_id)
tempfile fert_units
save `fert_units'
restore

**Land Rent
preserve
	//For rent, need to generate a price (for implicit costing), adjust quantity for long seasons (main file) and generate a total value. Geographic medians may not be particularly useful given the small sample size
	drop val*
	ren s3aq30 vallandrentexp0
	ren s3bq30 vallandrentexp1
	gen monthslandrent0 = s3aq31_idadi
	replace monthslandrent0=monthslandrent0*12 if s3aq31_meas==2
	gen monthslandrent1 = s3bq31_idadi
	replace monthslandrent1=monthslandrent1*12 if s3bq31_meas==2
	
	//Changing the in-kind share categories from categorical to fourths
	recode s3aq32 s3bq32 (1 2 .=0) (3=1) (4=2) (5=3) (6=4)
	gen propinkindpaid0 = s3aq32/4
	gen propinkindpaid1 = s3bq32/4

	
	replace vallandrentexp0 = . if monthslandrent0==0 //One obs with rent paid but no time period of rental
	keep hhid plot_id months* prop* val* field_size
	reshape long monthslandrent vallandrentexp propinkindpaid, i(hhid plot_id) j(season)
	la val season //
	merge 1:1 hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_value_prod.dta", nogen keep(3)
	gen pricelandrent = (vallandrentexp+(propinkindpaid*value_harvest))/monthslandrent/field_size 
	keep hhid plot_id pricelandrent season field_size
	reshape wide pricelandrent, i(hhid plot_id field_size) j(season) //
	la var pricelandrent0 "Cost of land rental per hectare per month (long rainy season data)"
	la var pricelandrent1 "Cost of land rental per hectare per month (season rainy season data)"
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rents.dta", replace
restore
merge 1:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rents.dta", nogen keep(1 3)

//Doing one year with the option to rescale to growing season if we figure out a way to do it later.
gen n_seas = pricelandrent0!=. + pricelandrent1!=.
gen vallandrent0 = pricelandrent0*12*field_size/n_seas 
gen vallandrent1 = pricelandrent1*12*field_size/n_seas
recode vallandrent* (.=0)
keep hhid plot_id qty* val* unit*

unab vars1 : *1 //This is a seasoncut to get all stubs 
local stubs1 : subinstr local vars1 "1" "", all
//di "`stubs1'" //viewing macro stubs1
reshape long `stubs1', i(hhid plot_id) j(season)

unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
reshape long `stubs2', i(hhid plot_id season) j(exp) string
reshape long qty val unit, i(hhid plot_id season exp) j(input) string
la val season //Remove a weird label that got stuck on this at some point.
//The var exp will be "exp" for all because we aren't doing implicit expenses and can be dropped or ignored.

recode val qty (.=0)
//drop if val==0 & qty==0 //Important to exclude this if we're doing plot or hh-level averages.
preserve
	//Need this for quantities and not sure where it should go.
	keep if strmatch(input,"orgfert") | strmatch(input,"inorgfert") | strmatch(input,"herb") | strmatch(input,"pest") //Seed rates would also be doable if we have conversions for the nonstandard units
	//Unfortunately we have to compress liters and kg here, which isn't ideal. But we don't know which inputs were used, so we would have to guess at density.
	collapse (sum) qty_=qty, by(hhid plot_id input season)
	reshape wide qty_, i(hhid plot_id season) j(input) string
	ren qty_inorg inorg_fert_kg
	ren qty_orgfert org_fert_kg
	// ren qty_herb herb_kg (No herbisites)
	ren qty_pest pest_kg
	la var inorg_fert_kg "Qty inorganic fertilizer used (kg)"
	la var org_fert_kg "Qty organic fertilizer used (kg)"
	//la var herb_kg "Qty of herbicide used (kg/L)"
	la var pest_kg "Qty of pesticide used (kg/L)"
	merge m:1 hhid plot_id using `fert_units', nogen
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_input_quantities.dta", replace
restore
append using `labor'
collapse (sum) val, by (hhid plot_id input season exp) //Keeping exp in for compatibility with the AQ compilation script.
merge m:1 hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_decision_makers.dta",  keepusing(dm_gender) nogen keep(3) //Removes uncultivated plots
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_cost_inputs_long.dta",replace

preserve
collapse (sum) val, by(hhid input season exp) //Keeping exp in for compatibility with the AQ compilation script.
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_cost_inputs_long.dta", replace
restore 

preserve
drop input
collapse (sum) val, by(hhid plot_id exp dm_gender season)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender2 season) j(exp) string
ren val* val*_
merge m:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time

merge 1:1 plot_id hhid season using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid plot_id season) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid)
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)

drop val*
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_cost_inputs.dta", replace
restore

preserve
	replace exp = "exp" if exp == ""
	collapse (sum) val_=val, by(hhid plot_id exp dm_gender season)
	reshape wide val_, i(hhid plot_id dm_gender season) j(exp) string 
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_cost_inputs.dta", replace 
restore

********************************************************************************
*MONOCROPPED PLOTS
********************************************************************************

	use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", clear
ren ha_planted monocrop_ha
	ren kg_harvest kgs_harv_mono
	ren value_harvest val_harv_mono
	collapse (sum) *mono*, by(hhid plot_id crop_code dm_gender season)

forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	keep if crop_code==`c'
	count
	if _N!=0 { //If we haven't dropped everything, continue.
	ren monocrop_ha `cn'_monocrop_ha
	drop if `cn'_monocrop_ha==0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_`cn'_monocrop.dta", replace
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' `cn'_monocrop { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	collapse (sum) *monocrop_ha* kgs_harv_mono* val_harv_mono* (max) `cn'_monocrop `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed, by(hhid)
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (TSH)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_`cn'_monocrop_hh_area.dta", replace
	}
restore
}

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_cost_inputs_long.dta", clear
merge m:1 hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_decision_makers.dta", nogen keep(3) keepusing(dm_gender)
collapse (sum) val, by(hhid plot_id dm_gender input season)
levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid plot_id dm_gender season) j(input) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
foreach cn in $topcropname_area {
preserve
	//keep if strmatch(exp, "exp")
	//drop exp
	capture confirm file "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_`cn'_monocrop.dta"
	if !_rc {
	ren val* val*_`cn'_
	reshape wide val*, i(hhid plot_id season) j(dm_gender2) string
	merge 1:1 hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_`cn'_monocrop.dta", nogen keep(3)
	count
	if(r(N) > 0){
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_inputs_`cn'.dta", replace
	}
	}
restore
}



********************************************************************************
*TLU (Tropical Livestock Units)
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
gen tlu_coefficient=0.5 if (animal==1|animal==2|animal==3|animal==4|animal==5|animal==6|animal==13)
replace tlu_coefficient=0.1 if (animal==7|animal==8)
replace tlu_coefficient=0.2 if (animal==9)
replace tlu_coefficient=0.01 if (animal==10|animal==11|animal==12)
replace tlu_coefficient=0.3 if (animal==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
*Owned
drop if animal==15
ren animal livestock_code
gen cattle=inlist(livestock_code,1,2,3,4,5,6)
gen smallrum=inlist(livestock_code,7,8,9)
gen poultry=inlist(livestock_code,10,11,12,13)
gen largerum = inlist(livestock_code,1,2,3,4,5,6)
gen other_ls=inlist(livestock_code,14,15,16)
gen cows=inrange(livestock_code,2,2)
gen chickens=inrange(livestock_code,10,10)
ren s10aq3 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
egen nb_ls_today= rowtotal(s10aq4_1 s10aq4_2 s10aq4_3)
gen nb_largerum_today=nb_ls_today if largerum==1
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
ren s10aq9 income_live_sales 
ren s10aq8 number_sold 
recode  tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_largerum_today "Number of large ruminant owned as of the time of survey"
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
drop if hhid==""
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_TLU_Coefficients.dta", replace


********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
*The preprocessing - including value imputation - is all in the "all plots" section above; this is mostly legacy compatibility stuff
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", clear
gen value_harvest_imputed = value_harvest
lab var value_harvest_imputed "Imputed value of crop production"
collapse (sum) value_harvest_imputed kg_harvest, by (hhid crop_code)
merge 1:1 hhid crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_sales.dta", nogen 
tab crop_code if crop_code==931
preserve
	recode  value_harvest_imputed value_sold kg_harvest quantity_sold (.=0)
	recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		tab crop_code if crop_code==931 
		
	collapse (sum) value_harvest_imputed value_sold kg_harvest quantity_sold , by (hhid crop_code)
	ren value_harvest_imputed value_crop_production
	lab var value_crop_production "Gross value of crop production, summed over main and season"
	ren value_sold value_crop_sales
	lab var value_crop_sales "Value of crops sold so far, summed over main and season"
	lab var kg_harvest "Kgs harvested of this crop, summed over main and season"
	ren quantity_sold kgs_sold
	gen price_kg = value_crop_production/kg_harvest
	lab var price_kg "Estimated household value of crop per kg, from sales and imputed values" //ALT 07.22.21: Added this var to make the crop processing value calculations work.
	lab var kgs_sold "Kgs sold of this crop, summed over main and season"
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production.dta", replace
restore
*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested,  

collapse (sum) value_harvest_imputed value_sold, by (hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* 155 changes here, suggests big gap between farmer estimated valuation and sales price. */
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_production.dta", replace

*Crop residues (not captured in Tanzania wave 1) 


*Crops lost post-harvest
use "${Tanzania_NPS_W1_raw_data}/SEC_7A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_7B.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_5A.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_5B.dta" 
ren s7aq9 value_lost
replace value_lost = s7bq9 if value_lost==.
replace value_lost = s5aq17 if value_lost==.
replace value_lost = s5bq17 if value_lost==.
recode value_lost (.=0)
ren zaocode crop_code
recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		label define crop_code 931 "Beans-Cowpeas", add
		label values crop_code crop_code
		tab crop_code if crop_code==931 
		
collapse (sum) value_lost, by (hhid crop_code)
merge 1:1 hhid crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production.dta", nogen keep(1 3)
replace value_lost = value_crop_production if value_lost > value_crop_production
collapse (sum) value_lost, by (hhid)
ren value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_losses.dta", replace




********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*Expenses		
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
ren s10aq18 cost_fodder_livestock
ren s10aq16 cost_hired_labor_livestock 
recode cost_fodder_livestock cost_hired_labor_livestock (.=0)
gen cost_lrum = cost_fodder_livestock + cost_hired_labor_livestock if animal < 7 
collapse (sum) cost_fodder_livestock cost_lrum cost_hired_labor_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_expenses", replace
*Livestock products 		
use "${Tanzania_NPS_W1_raw_data}/SEC_10B.dta", clear
ren lvstkprod livestock_code
ren s10bq2 months_produced
ren s10bq3_meas quantity_month
ren s10bq3_meat quantity_month_unit
replace quantity_month_unit = 1 if livestock_code==1 | livestock_code==2 
replace quantity_month_unit = 3 if livestock_code==3 | livestock_code==4 
replace quantity_month_unit = 1 if livestock_code==5
replace quantity_month_unit = 3 if livestock_code==6
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey */
lab var quantity_produced "Quantity of this product produed in past year"
ren s10bq5_1 sales_quantity
ren s10bq5_2 sales_unit
replace sales_unit = 1 if livestock_code==1 | livestock_code==2 
replace sales_unit = 3 if livestock_code==3 | livestock_code==4 
replace sales_unit = 1 if livestock_code==5
replace sales_unit = 3 if livestock_code==6
ren s10bq6 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
replace livestock_code = 21 if livestock_code==3 | livestock_code ==4
replace livestock_code = 22 if livestock_code==5
replace livestock_code = 23 if livestock_code==6
label define livestock_code_label 21 "Eggs" 22 "Honey" 23 "Skins"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
recode price_per_unit price_per_unit_hh (0=.)
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_other", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_other"
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_ea.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_unit price_median_ward
lab var price_median_ward "Median price per unit for this livestock product in the ward"
lab var obs_ward "Number of sales observations for this livestock product in the ward"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_ward.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_district.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_region.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_country.dta", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products", clear
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ward if price_per_unit==. & obs_ward >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen price_cowmilk_med = price_median_country if livestock_code==1 | livestock_code == 2
egen price_cowmilk = max(price_cowmilk_med)
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_per_unit if livestock_code == 1 | livestock_code == 2 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==21
gen value_other_produced = quantity_produced * price_per_unit if livestock_code !=1 & livestock_code !=2 & livestock_code != 21 & livestock_code != 7 //7 is other, shouldn't be included
*share of total production sold
egen sales_livestock_products = rowtotal(earnings_sales)		// this will be for all livestock products ("other" and milk/cheese)
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of honey and skins and hides produced"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_products", replace 		

*Sales (live animals)
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
ren animal livestock_code
ren s10aq9 income_live_sales 
ren s10aq8 number_sold 
ren s10aq12 number_slaughtered 
ren s10aq13 number_slaughtered_sold 
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
ren s10aq14 income_slaughtered
recode income_live_sales number_sold number_slaughtered number_slaughtered_sold income_slaughtered (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.) 
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district ward ea livestock_code number_sold income_live_sales number_slaughtered number_slaughtered_sold income_slaughtered price_per_animal 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", replace

*Implicit prices
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_ea.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_animal price_median_ward
lab var price_median_ward "Median price per unit for this livestock in the ward"
lab var obs_ward "Number of sales observations for this livestock in the ward"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_ward.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
ren price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_district.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_region.dta", replace
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_country.dta", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_sales", clear
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
replace value_slaughtered_sold = income_slaughtered if (value_slaughtered < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
replace value_slaughtered = value_slaughtered_sold if (value_slaughtered_sold > value_slaughtered) & (number_slaughtered > number_slaughtered_sold) //replace value of slaughtered with value of slaughtered sold if value sold is larger
gen value_livestock_sales = value_lvstck_sold + value_slaughtered_sold
collapse (sum) value_livestock_sales value_lvstck_sold value_slaughtered, by (hhid) 
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
ren animal lvstckid
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)		//
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12)
replace tlu_coefficient=0.5 if (lvstckid==13)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
ren s10aq4_1 number_today_indigenous
recode s10aq4_2 s10aq4_3 number_today_indigenous (.=0)
gen number_today_exotic = s10aq4_2 + s10aq4_3 
gen number_today = number_today_indigenous + number_today_exotic
gen tlu_today = number_today * tlu_coefficient
ren s10aq9 income_live_sales 
ren s10aq8 number_sold
ren lvstckid livestock_code
ren s10aq20 lost_disease 
egen mean_12months = rowmean(number_today)
gen animals_lost12months = lost_disease	// only includes lost to disease
gen share_imp_herd_cows = number_today_exotic/(number_today) if livestock_code==2
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(inlist(livestock_code==13,14)) + 5*(inlist(livestock_code,10,11)) 
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species
preserve
*Now to household level
*First, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today animals_lost12months lost_disease number_today_exotic lvstck_holding=number_today, by(hhid species)
egen mean_12months = rowmean(number_today)
gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
*A loop to create species variables
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(hhid)
*Overall any improved herd
gen any_imp_herd = number_today_exotic!=0 if number_today!=0
drop number_today_exotic number_today
*Generating missing variables in order to construct labels (just for the labeling loop below)
foreach i in lvstck_holding animals_lost12months mean_12months lost_disease{
	gen `i' = .
}
la var lvstck_holding "Total number of livestock holdings (# of animals)"
la var any_imp_herd "At least one improved animal in herd"
la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
lab var animals_lost12months  "Total number of livestock  lost to disease"
lab var  mean_12months  "Average number of livestock  today and 1  year ago"
lab var lost_disease "Total number of livestock lost to disease"
*A loop to label these variables (taking the labels above to construct each of these for each species)
foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
la var any_imp_herd "At least one improved animal in herd - all animals"
*Total livestock holding for large ruminants, small ruminants, and poultry
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
*any improved large ruminants, small ruminants, or poultry
gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
recode lvstck_holding* (.=0)
drop lvstck_holding animals_lost12months mean_12months lost_disease
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", nogen keep(1 3)
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_today = number_today * price_per_animal
collapse (sum) tlu_today value_today, by (hhid) 
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_TLU.dta", replace

*Livestock income
*Cow dung information not avaliable 

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_sales", clear
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_products", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_expenses", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_TLU.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_TLU_Coefficients.dta", nogen
gen livestock_income = value_livestock_sales + (value_milk_produced + value_eggs_produced + value_other_produced) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock) //
lab var livestock_income "Net livestock income"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_income", replace


********************************************************************************
*FISH INCOME
********************************************************************************
*Fishing expenses
use "${Tanzania_NPS_W1_raw_data}/SEC_12A.dta", clear
ren s12q9 equipment_repair_cost
collapse (sum) equipment_repair_cost, by (hhid)
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fishing_expenses_1.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_12D.dta", clear
ren s12q24_q27 months
gen fuel_costs_month = s12q25_q28 if itemcode == 10 
gen cost = s12q25_q28 if itemcode !=4 & itemcode !=6 & itemcode !=5 & itemcode != 10 // Exclude taxes, per RuLIS guidelines
recode months fuel_costs_month cost(.=0) 
gen cost_fuel = fuel_costs_month * months
gen cost_paid = cost * months
collapse (sum) cost_fuel cost_paid, by (hhid) 
lab var cost_fuel "Costs for fuel over the past year"
lab var cost_paid "Other costs paid for fishing activities"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fishing_expenses_2.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_12B.dta", clear
ren s12q10 fishing_yesno
keep if fishing_yesno == 1
ren s12q14 kgs_sold_perday
ren s12q15 earnings_perday
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta"
drop if _merge==2
drop _merge
gen price_per_kg = earnings_perday/kgs_sold_perday
recode price_per_kg (0=.) 
collapse (median) price_per_kg [aw = weight], by (itemcode)
ren price_per_kg price_per_kg_median
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fish_prices.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_12B.dta", clear
ren s12q10 fishing_yesno
keep if fishing_yesno == 1
ren s12q11 months
ren s12q12 days_perweek
ren s12q13 kgs_caught_perday
ren s12q14 kgs_sold_perday
replace kgs_caught_perday = max((kgs_caught_perday/100),kgs_sold_perday) if (((kgs_caught_perday/kgs_sold_perday) >= 10) & kgs_caught_perday > 100)  
replace kgs_sold_perday = kgs_caught_perday if kgs_sold_perday > kgs_caught_perday  
ren s12q15 earnings_perday
merge m:1 itemcode using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fish_prices.dta"
drop if _merge==2
drop _merge
gen price_per_kg = earnings_perday/kgs_sold_perday
recode price_per_kg (0=.) 
replace price_per_kg = price_per_kg_median if (price_per_kg == . | price_per_kg == 0) & kgs_caught !=. & kgs_caught != 0
gen income_fish_sales = price_per_kg * kgs_sold_perday * days_perweek * 4 * months 
gen value_fish_harvest = price_per_kg * kgs_caught_perday * days_perweek * 4 * months 
collapse (sum) value_fish_harvest income_fish_sales, by (hhid)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fish_income.dta", replace


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_E2.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_B_C_D_E1_F_G1_U.dta"
ren seq41o months_activ
ren seq42o monthly_profit
replace months_activ= seq41 if months_activ==.
replace monthly_profit= seq42 if monthly_profit==.
gen annual_selfemp_profit = months_activ*monthly_profit
recode annual_selfemp_profit (.=0)
duplicates drop hhid months_activ annual_selfemp_profit if annual_selfemp_profit!=0, force
replace seq36_1=seq36_1o if seq36_1==.
replace seq36_2=seq36_2o if seq36_2==.
gen alrea_report_annualprofit=monthly_profit==months_activ*seq36_2 if seq36_1==2
tab alrea_report_annualprofit if  monthly_profit!=0 & monthly_profit!=.
gen alrea_report_annualprofit2=monthly_profit==months_activ*4*seq36_2 if seq36_1==1
tab alrea_report_annualprofit2
replace annual_selfemp_profit=months_activ*seq36_2 if alrea_report_annualprofit==1 &  seq36_1==2
replace annual_selfemp_profit=months_activ*seq36_2 if alrea_report_annualprofit2==1 &  seq36_1==1
collapse (sum) annual_selfemp_profit, by (hhid)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_self_employment_income.dta", replace				

*Processed crops
use "${Tanzania_NPS_W1_raw_data}/SEC_9_ALL.dta", clear
ren zaocode crop_code
ren s9q2name crop_name 
ren s9q5 byproduct_sold_yesno
ren s9q4_1 byproduct_quantity
ren s9q4_2 byproduct_unit
ren s9q7 kgs_used_in_byproduct 
ren s9q8 byproduct_price_received
ren s9q10 other_expenses_yesno
ren s9q11 byproduct_other_costs
merge m:1 hhid crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_prices.dta"
drop _merge
recode byproduct_quantity kgs_used_in_byproduct byproduct_other_costs (.=0)
gen byproduct_sales = byproduct_quantity * byproduct_price_received
gen byproduct_crop_cost = kgs_used_in_byproduct * price_kg
gen byproduct_profits = byproduct_sales - (byproduct_crop_cost + byproduct_other_costs)
collapse (sum) byproduct_profits, by (hhid)
lab var byproduct_profits "Net profit from sales of agricultural processed products or byproducts"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_agproducts_profits.dta", replace

*Fish trading
*Not present in wave 1 

********************************************************************************
*WAGE INCOME
********************************************************************************
capture confirm file "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta"
if _rc {
	di as error "The wave 2 raw data are needed to impute time worked."
}
use   "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
merge m:1 y2_hhid using  "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta"
//Classification of Industry to get median wage for imputation, taken from RIGA coding	
g industry=1 if hh_e17_2<=3
replace  industry=2  if hh_e17_2>= 5 & hh_e17_2<= 9 & industry==.
replace  industry=3  if hh_e17_2>= 10 & hh_e17_2<= 33 & industry==.
replace  industry=3  if hh_e17_2>= 101 & hh_e17_2<= 107 & industry==.
replace  industry=4  if hh_e17_2>= 35 & hh_e17_2<= 39 & industry==.
replace  industry=5  if hh_e17_2>= 41 & hh_e17_2<= 43 & industry==.
replace  industry=5  if hh_e17_2==4321 & industry==.
replace  industry=6  if hh_e17_2>= 45 & hh_e17_2<= 47 & industry==.
replace  industry=6  if hh_e17_2>= 471 & hh_e17_2<= 479 & industry==.
replace  industry=7  if hh_e17_2>= 49 & hh_e17_2<= 63 & industry==.
replace  industry=7  if hh_e17_2>= 491 & hh_e17_2<= 563 & industry==.
replace  industry=7  if hh_e17_2>= 4921 & hh_e17_2<= 4923 & industry==.
replace  industry=7  if hh_e17_2==614 & industry==.
replace  industry=8  if hh_e17_2>= 64 & hh_e17_2<= 68 & industry==.
replace  industry=9  if hh_e17_2>= 69 & hh_e17_2<= 96 & industry==.
replace  industry=10  if hh_e17_2>= 97 & hh_e17_2<= 99 & industry==.
replace  industry=10  if hh_e17_2==9999 & industry==.
replace  industry=10  if hh_e17_2==48 | hh_e17_2==447 & industry==. /*unknown industries*/
replace  industry=10  if hh_e17_2==. & industry==. /*unknown industries*/
label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry
* urbrur should be y3_rural
ren y2_rural 	urbrur	
g urbrur2=1 if region==7 			/* Dar el Salaam */
replace urbrur2=2 if urbrur==0 & urbrur2==.	/*other urban*/
replace urbrur2=3 if urbrur==1 & urbrur2==.	/* rural  */
label var urbrur2 "Dar es Salaam / Other Urban / Rural" 
label define urbrur2 1 "Dar es Salaam"  2 "Other Urban"  3 "Rural" 
label values urbrur2 urbrur2
// get median annual weeks worked for each industry
recode hh_e26 hh_e27 (.=0)
gen weeks = hh_e26*hh_e27
replace weeks = hh_e27 if hh_e26 == 0
ren y2_weight weight

preserve
sort urbrur2 industry
collapse (median) weeks, by(urbrur2 industry)
sort urbrur2 industry
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_hours_imputation_urban.dta", replace
restore
sort industry
collapse (median) weeks, by(industry)
sort industry
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_hours_imputation.dta", replace

//Use Wave 1 income
use "${Tanzania_NPS_W1_raw_data}/SEC_B_C_D_E1_F_G1_U.dta", clear
ren sbmemno personid
merge m:1 hhid using "${Tanzania_NPS_W1_raw_data}/SEC_A_T.dta"
drop _m
//Classification of Industry to get median wage for imputation, taken from r coding	
gen industry=1 if seq13<=3
replace  industry=2  if seq13>= 5 & seq13<= 9 & industry==.
replace  industry=3  if seq13>= 10 & seq13<= 33 & industry==.
replace  industry=3  if seq13>= 101 & seq13<= 107 & industry==.
replace  industry=4  if seq13>= 35 & seq13<= 39 & industry==.
replace  industry=5  if seq13>= 41 & seq13<= 43 & industry==.
replace  industry=5  if seq13==4321 & industry==.
replace  industry=6  if seq13>= 45 & seq13<= 47 & industry==.
replace  industry=6  if seq13>= 471 & seq13<= 479 & industry==.
replace  industry=7  if seq13>= 49 & seq13<= 63 & industry==.
replace  industry=7  if seq13>= 491 & seq13<= 563 & industry==.
replace  industry=7  if seq13>= 4921 & seq13<= 4923 & industry==.
replace  industry=8  if seq13>= 64 & seq13<= 68 & industry==.
replace  industry=9  if seq13>= 69 & seq13<= 96 & industry==.
replace  industry=10  if seq13>= 97 & seq13<= 99 & industry==.
replace  industry=10  if seq13==9999 & industry==.
replace  industry=10  if seq13==48 | seq13==447 & industry==. /*unknown industries*/
replace  industry=10  if seq13==. & industry==. /*unknown industries*/
label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry
ren rural 	urbrur	
g urbrur2=1 if region==7 			/* Dar el Salaam */
replace urbrur2=2 if urbrur=="Urban" & urbrur2==.	/*other urban*/
replace urbrur2=3 if urbrur=="Rural" & urbrur2==.	/* rural  */
label var urbrur2 "Dar es Salaam / Other Urban / Rural" 
label define urbrur2 1 "Dar es Salaam"  2 "Other Urban"  3 "Rural" 
label values urbrur2 urbrur2
* merge in median weeks worked
sort urbrur2 industry
merge m:1 urbrur2 industry using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_hours_imputation_urban.dta"
drop if _m==2
drop _m
ren weeks weeks_urban
sort industry
merge m:1 industry using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_hours_imputation.dta"
tab _m
drop if _m==2
drop _m
ren weeks weeks_industry
g weeks= weeks_urban
replace weeks=weeks_industry if weeks==.

//Wage Income
ren seq18_1 most_recent_payment
replace most_recent_payment = . if industry == 1 // We do not want agriculture in this category
ren seq18_2 payment_period
ren seq21_1 most_recent_payment_other
ren seq21_2 payment_period_other
ren seq19 wage_hours_week
gen annual_salary_cash_aggregate = most_recent_payment*wage_hours_week*weeks if payment_period==1
replace annual_salary_cash_aggregate=most_recent_payment*6*weeks if payment_period==2 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*weeks if payment_period==3 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/2) if payment_period==4 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/4.3) if payment_period==5 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/13) if payment_period==6 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/26) if payment_period==7 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/52) if payment_period==8 & annual_salary_cash_aggregate==.
gen wage_salary_other_aggregate=most_recent_payment_other*wage_hours_week*weeks if payment_period==1
replace wage_salary_other_aggregate=most_recent_payment_other*6*weeks if payment_period==2 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*weeks if payment_period==3 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/2) if payment_period==4 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/4.3) if payment_period==5 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/13) if payment_period==6 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/26) if payment_period==7 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/52) if payment_period==8 & wage_salary_other_aggregate==.
recode annual_salary_cash_aggregate wage_salary_other_aggregate (.=0)
gen annual_salary = annual_salary_cash_aggregate + wage_salary_other_aggregate
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage - Imputed"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_income.dta", replace

//Ag Wage 
use "${Tanzania_NPS_W1_raw_data}/SEC_B_C_D_E1_F_G1_U.dta", clear
ren sbmemno personid
merge m:1 hhid using "${Tanzania_NPS_W1_raw_data}/SEC_A_T.dta"
drop _m
gen industry=1 if seq13<=3
replace  industry=2  if seq13>= 5 & seq13<= 9 & industry==.
replace  industry=3  if seq13>= 10 & seq13<= 33 & industry==.
replace  industry=3  if seq13>= 101 & seq13<= 107 & industry==.
replace  industry=4  if seq13>= 35 & seq13<= 39 & industry==.
replace  industry=5  if seq13>= 41 & seq13<= 43 & industry==.
replace  industry=5  if seq13==4321 & industry==.
replace  industry=6  if seq13>= 45 & seq13<= 47 & industry==.
replace  industry=6  if seq13>= 471 & seq13<= 479 & industry==.
replace  industry=7  if seq13>= 49 & seq13<= 63 & industry==.
replace  industry=7  if seq13>= 491 & seq13<= 563 & industry==.
replace  industry=7  if seq13>= 4921 & seq13<= 4923 & industry==.
replace  industry=8  if seq13>= 64 & seq13<= 68 & industry==.
replace  industry=9  if seq13>= 69 & seq13<= 96 & industry==.
replace  industry=10  if seq13>= 97 & seq13<= 99 & industry==.
replace  industry=10  if seq13==9999 & industry==.
replace  industry=10  if seq13==48 | seq13==447 & industry==. /*unknown industries*/
replace  industry=10  if seq13==. & industry==. /*unknown industries*/
label define industry 1 "Agriculture & fishing" 2 " Mining" 3 "Manufacturing" 4 "Electricity & utilities" 5 "Construction" 6 "Commerce" 7 "Transport, storage, communication"  8 "Finance, insurance, real estate" 9 "Services" 10 "Unknown" 
label values industry industry
g urbrur2=1 if region==7 			/* Dar el Salaam */
replace urbrur2=2 if urbrur==1 & urbrur2==.	/*other urban*/
replace urbrur2=3 if urbrur==2 & urbrur2==.	/* rural  */
label var urbrur2 "Dar es Salaam / Other Urban / Rural" 
label define urbrur2 1 "Dar es Salaam"  2 "Other Urban"  3 "Rural" 
label values urbrur2 urbrur2
* merge in median weeks worked
sort urbrur2 industry
merge m:1 urbrur2 industry using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_hours_imputation_urban.dta"
drop if _m==2
drop _m
ren weeks weeks_urban
sort industry
merge m:1 industry using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_hours_imputation.dta"
tab _m
drop if _m==2
drop _m
ren weeks weeks_industry
g weeks= weeks_urban
replace weeks=weeks_industry if weeks==.
ren seq18_1 most_recent_payment
replace most_recent_payment = . if industry != 1 // We only want agriculture in this category
ren seq18_2 payment_period
ren seq21_1 most_recent_payment_other
ren seq21_2 payment_period_other
ren seq19 wage_hours_week
gen annual_salary_cash_aggregate = most_recent_payment*wage_hours_week*weeks if payment_period==1
replace annual_salary_cash_aggregate=most_recent_payment*6*weeks if payment_period==2 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*weeks if payment_period==3 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/2) if payment_period==4 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/4.3) if payment_period==5 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/13) if payment_period==6 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/26) if payment_period==7 & annual_salary_cash_aggregate==.
replace annual_salary_cash_aggregate=most_recent_payment*(weeks/52) if payment_period==8 & annual_salary_cash_aggregate==.
gen wage_salary_other_aggregate=most_recent_payment_other*wage_hours_week*weeks if payment_period==1
replace wage_salary_other_aggregate=most_recent_payment_other*6*weeks if payment_period==2 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*weeks if payment_period==3 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/2) if payment_period==4 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/4.3) if payment_period==5 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/13) if payment_period==6 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/26) if payment_period==7 & wage_salary_other_aggregate==.
replace wage_salary_other_aggregate=most_recent_payment_other*(weeks/52) if payment_period==8 & wage_salary_other_aggregate==.
recode annual_salary_cash_aggregate wage_salary_other_aggregate (.=0)
gen annual_salary = annual_salary_cash_aggregate + wage_salary_other_aggregate
collapse (sum) annual_salary, by (hhid)
ren annual_salary annual_salary_agwage
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months - Imputed"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_agwage_income.dta", replace


********************************************************************************
*OTHER INCOME
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_G2.dta", clear 
append using "${Tanzania_NPS_W1_raw_data}/SEC_O1.dta" 
ren sgq11 cash_inkind_gifts_received 
ren soq3 assistance_cash
ren soq4 assistance_food
ren soq5 assistance_inkind
recode cash_inkind_gifts_received assistance_cash assistance_food assistance_inkind (.=0)
ren cash_inkind_gifts_received remittance_income 
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) remittance_income assistance_income, by (hhid)
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_other_income.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
ren s3aq4 land_rental_income_mainseason
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
ren s3bq4 land_rental_income_season
recode land_rental_income_mainseason land_rental_income_season (.=0)
gen land_rental_income = land_rental_income_mainseason + land_rental_income_season
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rental_income.dta", replace

*Other income
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_other_income.dta", clear
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rental_income.dta"
egen other_income_sources = rowtotal (remittance_income assistance_income land_rental_income)


********************************************************************************
*FARM SIZE / LAND SIZE
********************************************************************************
*Determining whether crops were grown on a plot
use "${Tanzania_NPS_W1_raw_data}/SEC_4A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_4B.dta"
ren plotnum plot_id
drop if plot_id==""
drop if zaocode==.
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid plot_id)
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crops_grown.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
gen cultivated = (s3aq3==1 | s3bq3==1)
preserve 
use "${Tanzania_NPS_W1_raw_data}/SEC_6A.dta", clear
gen cultivated=1 if (s6aq8!=. & s6aq8!=0) | (s6aq4!=. & s6aq4!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (hhid plotnum)
drop if plotnum==""
tempfile fruit_tree
save `fruit_tree', replace
restore
append using `fruit_tree'

preserve 
use "${Tanzania_NPS_W1_raw_data}/SEC_6B.dta", clear
gen cultivated=1 if (s6bq8!=. & s6bq8!=0) | (s6bq4!=. & s6bq4!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (hhid plotnum)
drop if plotnum==""
tempfile perm_crop
save `perm_crop', replace
restore
append using `perm_crop'
ren plotnum plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_parcels_cultivated.dta", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_parcels_cultivated.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_size.dta", replace

*All agricultural land
use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
ren plotnum plot_id
drop if plot_id==""
merge m:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crops_grown.dta", nogen
gen rented_out = (s3aq3==2 | s3aq3==3 | s3bq3==2 | s3bq3==3)
gen cultivated = (s3bq3==1)
bys hhid plot_id: egen plot_cult = max(cultivated)
replace rented_out = 0 if plot_cult==1 // If cultivated in season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
*57 obs dropped
gen agland = (s3aq3==1 | s3aq3==4 | s3bq3==1 | s3bq3==4) // All cultivated AND fallow plots

preserve 
use "${Tanzania_NPS_W1_raw_data}/SEC_6A.dta", clear
gen cultivated=1 if (s6aq8!=. & s6aq8!=0) | (s6aq4!=. & s6aq4!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (hhid plotnum)
drop if plotnum==""
ren plotnum plot_id
tempfile fruit_tree
save `fruit_tree', replace
restore
append using `fruit_tree'

preserve 
use "${Tanzania_NPS_W1_raw_data}/SEC_6B.dta", clear
gen cultivated=1 if (s6bq8!=. & s6bq8!=0) | (s6bq4!=. & s6bq4!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (hhid plotnum)
drop if plotnum==""
ren plotnum plot_id
tempfile perm_crop
save `perm_crop', replace
restore
append using `perm_crop'
replace agland=1 if cultivated==1

drop if agland!=1 & crop_grown==.
collapse (max) agland, by (hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_parcels_agland.dta", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_parcels_agland.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta"
drop if _merge == 2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmsize_all_agland.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
ren plotnum plot_id
drop if plot_id==""
gen rented_out = (s3aq3==2 | s3aq3==3 | s3bq3==2 | s3bq3==3)
gen cultivated_season = (s3bq3==1)
bys hhid plot_id: egen plot_cult_season = max(cultivated_season)
replace rented_out = 0 if plot_cult_season==1 // If cultivated in season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_parcels_held.dta", replace

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_parcels_held.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household" 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
ren plotnum plot_id
drop if plot_id==""
merge m:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (max) area_acres_meas, by(hhid plot_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_size_total.dta", replace


********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_B_C_D_E1_F_G1_U.dta", clear // no secondary wage data 
ren sbmemno personid
gen  hrs_main_wage_off_farm=seq19 if (seq13>3 & seq13!=.)		
*gen  hrs_sec_wage_off_farm= hh_e50 if (hh_e39_2>3 & hh_e39_2!=.)		// hh_e21_2 1 to 3 is agriculture  
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm ) //hrs_sec_wage_off_farm
gen  hrs_main_wage_on_farm=seq19 if (seq13<=3 & seq13!=.)		 
*gen  hrs_sec_wage_on_farm= hh_e50 if (hh_e39_2<=3 & hh_e39_2!=.)	 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm ) //hrs_sec_wage_on_farm
drop *main* 
ren seq45 hrs_unpaid_off_farm
recode seq46_hr seq47_hr seq48_hr (.=0) 
gen hrs_domest_fire_fuel=(seq47_hr+ seq48_hr/60+seq47_hr+seq48_hr/60)*7  // hours worked just yesterday
ren  seq46_hr hrs_ag_activ
egen hrs_off_farm=rowtotal(hrs_wage_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
egen hrs_domest_all=rowtotal(hrs_domest_fire_fuel)
egen hrs_other_all=rowtotal(hrs_unpaid_off_farm)
gen hrs_self_off_farm=.

foreach v of varlist hrs_* {
	local l`v'=subinstr("`v'", "hrs", "nworker",.)
	gen  `l`v''=`v'!=0
} 
gen member_count = 1
collapse (sum) nworker_* hrs_*  member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var hrs_unpaid_off_farm  "Total household hours - unpaid activities"
la var hrs_ag_activ "Total household hours - agricultural activities"
la var hrs_wage_off_farm "Total household hours - wage off-farm"
la var hrs_wage_on_farm  "Total household hours - wage on-farm"
la var hrs_domest_fire_fuel  "Total household hours - collecting fuel and making fire"
la var hrs_off_farm  "Total household hours - work off-farm"
la var hrs_on_farm  "Total household hours - work on-farm"
la var hrs_domest_all  "Total household hours - domestic activities"
la var hrs_other_all "Total household hours - other activities"
la var hrs_self_off_farm  "Total household hours - self-employment off-farm"
la var nworker_unpaid_off_farm  "Number of HH members with positve hours - unpaid activities"
la var nworker_ag_activ "Number of HH members with positve hours - agricultural activities"
la var nworker_wage_off_farm "Number of HH members with positve hours - wage off-farm"
la var nworker_wage_on_farm  "Number of HH members with positve hours - wage on-farm"
la var nworker_domest_fire_fuel  "Number of HH members with positve hours - collecting fuel and making fire"
la var nworker_off_farm  "Number of HH members with positve hours - work off-farm"
la var nworker_on_farm  "Number of HH members with positve hours - work on-farm"
la var nworker_domest_all  "Number of HH members with positve hours - domestic activities"
la var nworker_other_all "Number of HH members with positve hours - other activities"
la var nworker_self_off_farm  "Number of HH members with positve hours - self-employment off-farm"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_off_farm_hours.dta", replace



********************************************************************************
*FARM LABOR
********************************************************************************
*Farm labor
use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear  
ren s3aq63_2 landprep_women 
ren s3aq63_1 landprep_men 
ren s3aq63_4 weeding_men 
ren s3aq63_5 weeding_women 
ren s3aq63_7 harvest_men 
ren s3aq63_8 harvest_women 
recode landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women (.=0)
egen days_hired_mainseason = rowtotal(landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women) 
recode s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 s3aq61_5 s3aq61_6 s3aq61_7 s3aq61_8 s3aq61_9 s3aq61_10 s3aq61_11 s3aq61_12 (.=0)
egen days_flab_landprep = rowtotal(s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 s3aq61_5 s3aq61_6 s3aq61_7 s3aq61_8 s3aq61_9 s3aq61_10 s3aq61_11 s3aq61_12)
recode s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 s3aq61_17 s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 s3aq61_22 s3aq61_23 s3aq61_24 (.=0)
egen days_flab_weeding = rowtotal(s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 s3aq61_17 s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 s3aq61_22 s3aq61_23 s3aq61_24)
recode s3aq61_25 s3aq61_26 s3aq61_27 s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 s3aq61_34 s3aq61_35 s3aq61_36 (.=0)
egen days_flab_harvest = rowtotal(s3aq61_25 s3aq61_26 s3aq61_27 s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 s3aq61_34 s3aq61_35 s3aq61_36)
gen days_famlabor_mainseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotnum plot_id
collapse (sum) days_hired_mainseason days_famlabor_mainseason, by (hhid plot_id)
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_farmlabor_mainseason.dta", replace

use "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta", clear 
ren s3bq63_2 landprep_women 
ren s3bq63_1 landprep_men 
ren s3bq63_4 weeding_men 
ren s3bq63_5 weeding_women 
ren s3bq63_7 harvest_men 
ren s3bq63_8 harvest_women 
recode landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women(.=0)
egen days_hired_season = rowtotal(landprep_women landprep_men weeding_men weeding_women harvest_men harvest_women) 
recode s3bq61_1 s3bq61_2 s3bq61_3 s3bq61_4 s3bq61_5 s3bq61_6 s3bq61_7 s3bq61_8 s3bq61_9 s3bq61_10 s3bq61_11 s3bq61_12 (.=0)
egen days_flab_landprep = rowtotal(s3bq61_1 s3bq61_2 s3bq61_3 s3bq61_4 s3bq61_5 s3bq61_6 s3bq61_7 s3bq61_8 s3bq61_9 s3bq61_10 s3bq61_11 s3bq61_12)
recode s3bq61_13 s3bq61_14 s3bq61_15 s3bq61_16 s3bq61_17 s3bq61_18 s3bq61_19 s3bq61_20 s3bq61_21 s3bq61_22 s3bq61_23 s3bq61_24  (.=0)
egen days_flab_weeding = rowtotal(s3bq61_13 s3bq61_14 s3bq61_15 s3bq61_16 s3bq61_17 s3bq61_18 s3bq61_19 s3bq61_20 s3bq61_21 s3bq61_22 s3bq61_23 s3bq61_24)
recode s3bq61_25 s3bq61_26 s3bq61_27 s3bq61_28 s3bq61_29 s3bq61_30 s3bq61_31 s3bq61_32 s3bq61_33 s3bq61_34 s3bq61_35 s3bq61_36 (.=0)
egen days_flab_harvest = rowtotal(s3bq61_25 s3bq61_26 s3bq61_27 s3bq61_28 s3bq61_29 s3bq61_30 s3bq61_31 s3bq61_32 s3bq61_33 s3bq61_34 s3bq61_35 s3bq61_36)
gen days_famlabor_season = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotnum plot_id
collapse (sum) days_hired_season days_famlabor_season, by (hhid plot_id)
lab var days_hired_season  "Workdays for hired labor (crops) in season growing season"
lab var days_famlabor_season  "Workdays for family labor (crops) in season growing season"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_farmlabor_season.dta", replace

*Labor
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_farmlabor_mainseason.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_farmlabor_season.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id)
egen labor_hired =rowtotal(days_hired_mainseason days_hired_season)
egen labor_family=rowtotal(days_famlabor_mainseason  days_famlabor_season)
egen labor_total = rowtotal(days_hired_mainseason days_famlabor_mainseason days_hired_season days_famlabor_season)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days (hired +family) allocated to the farm"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days (hired +family) allocated to the farm" 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_family_hired_labor.dta", replace
 
 
********************************************************************************
*VACCINE USAGE
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
gen vac_animal=.
replace vac_animal=1 if s10aq26==1 | s10aq26==2 
replace vac_animal=0 if s10aq26==3
replace vac_animal=. if s10aq26==.
replace vac_animal=. if animal == 15 //remove vaccinated dogs
replace vac_animal = . if s10aq2 ==2 | s10aq2==. //missing if the household did now own any of these types of animals 
*Disagregating vaccine usage by animal type 
ren animal livestock_code
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(inlist(livestock_code,13,14)) + 5*(inlist(livestock_code,10,11))
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
collapse (max) vac_animal*, by (hhid)
lab var vac_animal "1= Household has an animal vaccinated"
foreach i in vac_animal {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_vaccine.dta", replace
 
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
gen all_vac_animal=.
replace all_vac_animal=1 if s10aq26==1 | s10aq26==2  
replace all_vac_animal=0 if s10aq26==3
replace all_vac_animal=. if s10aq26==.
replace all_vac_animal=. if s10aq2 ==2 | s10aq2==. //missing if the household did now own any of these types of animals 
replace all_vac_animal=. if animal == 15 //remove vaccinated dogs

preserve
keep hhid s10aq5_1 all_vac_animal 
ren s10aq5_1 farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid  s10aq5_2  all_vac_animal 
ren s10aq5_2 farmerid
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta", clear
gen disease_animal = 1 if (s10aq25_1!=22 | s10aq25_2!=22 | s10aq25_3!=22 | s10aq25_4!=22) 
replace disease_animal = 0 if (s10aq25_1==22)
replace disease_animal = . if (s10aq25_1==. & s10aq25_2==. & s10aq25_3==. & s10aq25_4==.) 
gen disease_fmd = (s10aq25_1==7 | s10aq25_2==7 | s10aq25_3==7 | s10aq25_4==7 )
gen disease_lump = (s10aq25_1==3 | s10aq25_2==3 | s10aq25_3==3 | s10aq25_4==3 )
gen disease_bruc = (s10aq25_1==1 | s10aq25_2==1 | s10aq25_3==1 | s10aq25_4==1 )
gen disease_cbpp = (s10aq25_1==2 | s10aq25_2==2 | s10aq25_3==2 | s10aq25_4==2 )
gen disease_bq = (s10aq25_1==9 | s10aq25_2==9 | s10aq25_3==9 | s10aq25_4==9 )
ren animal livestock_code
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
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_diseases.dta", replace



********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
*cannot construct

********************************************************************************
* PLOT MANAGERS * (INPUT USE)
********************************************************************************
//This can be simplified a little more; added to to-dos
use "${Tanzania_NPS_W1_raw_data}/SEC_4A.dta", clear 
gen season = 0
append using "${Tanzania_NPS_W1_raw_data}/SEC_4B.dta" 
recode season (.=1)
ren plotnum plot_id 
ren zaocode crop_code
recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		label define crop_code 931 "Beans-Cowpeas", add
		label values crop_code crop_code
		tab crop_code if crop_code==931 
		
gen use_imprv_seed = s4aq23==2 | s4bq23==2
collapse (max) use_imprv_seed, by(hhid plot_id crop_code season) 
tempfile imprv_seed 
save `imprv_seed'

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_input_quantities.dta", clear
gen use_inorg_fert = inorg_fert_kg != 0 & inorg_fert_kg!=.
gen use_org_fert = org_fert_kg != 0 & org_fert_kg != .
gen use_pest = pest_kg != 0 & pest_kg!=.
//merge 1:m hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", nogen keepusing(crop_code)
//merge 1:1 hhid plot_id crop_code season using `imprv_seed', nogen
merge 1:m hhid plot_id season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", nogen keepusing(crop_code use_imprv_seed)
recode use* (.=0)

preserve
keep hhid plot_id crop_code use_imprv_seed season 
ren use_imprv_seed imprv_seed_ 
//recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas"
		//label values crop_code crop_code
		tab crop_code if crop_code==931 
collapse (max) imprv_seed_, by(hhid crop_code)
gen hybrid_seed_ = . //More specific for hybrid crop varieties; not available in this wave
merge m:1 crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_cropname_table.dta", nogen keep(3)
drop crop_code 
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_imprvseed_crop.dta", replace 
restore

//collapse (max) use*, by(y2_hhid plot_id season)
merge m:m hhid  using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_dm_ids.dta" //*plot_id season
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
//recode crop_code (31 32=931) //recoding for new consolidated crop bnscps (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		tab crop_code if crop_code==931 
	
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmer_improvedseed_use.dta", replace
restore

ren use_imprv_seed imprv_seed_use
collapse (max) use_* imprv_seed_use, by(hhid indiv female)
gen all_imprv_seed_use = imprv_seed_use //Legacy
//TO FIX
gen all_use_inorg_fert = use_inorg_fert
gen all_use_org_fert = use_org_fert 
gen all_use_pest = use_pest 
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmer_input_use.dta", replace 
	collapse (max) use_inorg_fert imprv_seed_use use_org_fert use_pest, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var imprv_seed_use "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_input_use.dta", replace 


********************************************************************************
*REACHED BY AG EXTENSION
********************************************************************************
*disaggregate by public and private source
* public : Government
use "${Tanzania_NPS_W1_raw_data}/SEC_13B.dta", clear
ren s13q7 receive_advice
ren itemcode sourceid
preserve
use "${Tanzania_NPS_W1_raw_data}/SEC_13A.dta", clear
ren s13q1 receive_advice
ren source sourceid
replace sourceid=8 if sourceid==5
tempfile TZ_advice2
save `TZ_advice2'
restore
append using  `TZ_advice2'
**Government Extension
gen advice_gov = (sourceid==1 & receive_advice==1)
**NGO
gen advice_ngo = (sourceid==2 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==3 & receive_advice==1)
**Large Scale Farmer
gen advice_farmer =(sourceid==4 & receive_advice==1)
**Radio
gen advice_radio = (sourceid==5 & receive_advice==1)
**Publication
gen advice_pub = (sourceid==6 & receive_advice==1)
**Neighbor
gen advice_neigh = (sourceid==7 & receive_advice==1)
**Other
gen advice_other = (sourceid==8 & receive_advice==1)
**advice on prices from extension
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1)
gen ext_reach_unspecified=(advice_radio==1 | advice_pub==1 | advice_other==1)
gen ext_reach_ict=(advice_radio==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1 )
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_any_ext.dta", replace
 
 
********************************************************************************
*USE OF FORMAL FINANACIAL SERVICES
********************************************************************************
use "${Tanzania_NPS_W1_raw_data}/SEC_P2.dta", clear
gen borrow_bank = spq3==1
gen borrow_micro = spq3==2
gen borrow_mortgage = spq3==3
gen borrow_insurance = spq3==4
gen borrow_other_fin= spq3==5
gen borrow_neigh= spq3==6
gen borrow_employer=spq3==9
gen borrow_ngo= spq3==11
* Credit, Insurance, others 
gen use_fin_serv_credit= borrow_mortgage==1 | borrow_bank==1  | borrow_other_fin==1
gen use_fin_serv_insur= borrow_insurance==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all= use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_others==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fin_serv.dta", replace


********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
*Total production
use "${Tanzania_NPS_W1_raw_data}/SEC_10B.dta", clear
keep if lvstkprod == 1 | lvstkprod == 2		
gen months_milked = s10bq2			// average months milked in last year (by holder)
gen liters_month = s10bq3_meas			// average quantity (liters) per day (questionnaire sounds like this question is TOTAL, not per head)
gen liters_milk_produced=months_milked*liters_month 
collapse (sum) liters_milk_produced, by (hhid)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_milk_animals.dta", replace


********************************************************************************
*EGG ********************************************************************************
************
use "${Tanzania_NPS_W1_raw_data}/SEC_10B.dta", clear
keep if lvstkprod == 3 | lvstkprod == 4		// keeping eggs only
drop if s10bq1 == 2
gen eggs_months = s10bq2	// number of months eggs were produced
gen eggs_per_month = s10bq3_meas 			
gen eggs_total_year = eggs_month*eggs_per_month			// eggs per month times number of months produced in last 12 months
collapse (sum) eggs_total_year, by (hhid) 
lab var eggs_total_year "Total number of eggs that was produced (household)"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_eggs_animals.dta", replace


********************************************************************************
*CROP PRODUCTION COSTS PER HECTARE
********************************************************************************
*Constructed using both implicit and explicit costs
*NOTE: There's some overlap with crop production expenses above, but this is because the variables were created separately.

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
*Relocated to plot labor 


********************************************************************************
*RATE OF FERTILIZER APPLICATION
********************************************************************************

use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
gen season = 0
recode season (.=1)
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta"
ren  plotnum plot_id
collapse (max) s3aq15 s3bq15, by (hhid plot_id)
merge 1:1 hhid plot_id  using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_planted_area.dta"
merge 1:m hhid plot_id  using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_decision_makers.dta", nogen keep(1 3)
merge 1:1 hhid  plot_id  season using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_input_quantities.dta", nogen keep(1 3) 
ren s3aq15 plot_irr
replace plot_irr=s3bq15 if plot_irr==.
recode plot_irr (2=0) // 2 is "No"
gen ha_irr_ = plot_irr * ha_planted
unab vars : *kg 
local vars `vars' ha_irr ha_planted

recode *kg (.=0)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "other" if dm_gender==. 
drop dm_gender
ren *kg *kg_
ren ha_planted ha_planted_
drop _merge 

reshape wide *_, i(hhid plot_id season) j(dm_gender2) string

collapse (sum) ha_planted_* *kg* ha_irr_*, by(hhid)

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}

lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
lab var npk_kg "NPK fertilizer (kgs) for household"
lab var n_kg "Units of Nitrogen (kgs) for household"
lab var p_kg "Units of Phosphorus (kgs) for household"
lab var k_kg "Units of Potassium (kgs) for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var urea_kg "Urea (kgs) for `i'-managed plots"
lab var npk_kg "NPK fertilizer (kgs) for `i'-managed plots"
lab var n_kg "Units of Nitrogen (kgs) for `i'-managed plots"
lab var p_kg "Units of Phosphorus (kgs) for `i'-managed plots"
lab var k_kg "Units of Potassium (kgs) for `i'-managed plots"
}

save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fertilizer_application.dta", replace


********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
* TZA LSMS does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of householdd eating nutritious food can be estimated
use "${Tanzania_NPS_W1_raw_data}/SEC_K1.dta" , clear
* recode food items to map HDDS food categories
recode skcode    	(101/112 108 				    =1	"CEREALS" )  //// 
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
gen adiet_yes=(skq1==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid )
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS. 
Can use either cut-off of 6 (=12/2) or cut-off=mean(score) 
*/
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_household_diet.dta", replace
 
 
********************************************************************************
*WOMEN'S CONTROL OVER INCOME 		
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*In most cases, TZA LSMS 1 lists the first tow decision makers.
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
use "${Tanzania_NPS_W1_raw_data}/SEC_4A", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_4B"
append using "${Tanzania_NPS_W1_raw_data}/SEC_5A"
append using "${Tanzania_NPS_W1_raw_data}/SEC_5B"
append using "${Tanzania_NPS_W1_raw_data}/SEC_6A"
append using "${Tanzania_NPS_W1_raw_data}/SEC_6B"
append using "${Tanzania_NPS_W1_raw_data}/SEC_7A"
append using "${Tanzania_NPS_W1_raw_data}/SEC_7B"
append using "${Tanzania_NPS_W1_raw_data}/SEC_9_ALL"
append using "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_10B.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_E2.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_G2.dta"
append using "${Tanzania_NPS_W1_raw_data}/SEC_O1.dta"
gen type_decision="" 
gen controller_income1=.
gen controller_income2=.
* Business income 
* We are making the assumption that whoever owns the business might have some sort of control over the income generated by the business.
* We don't think that the business manager have control of the business income. If she does, she is probaly listed as owner
*Control of business income
replace type_decision="control_businessincome" if  !inlist( seq25_1o, .,0,99) |  !inlist( seq25_2o, .,0,99) 
replace controller_income1=seq25_1o if !inlist( seq25_1o, .,0,99)  
replace controller_income2=seq25_2o if !inlist( seq25_2o, .,0,99)
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
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																
collapse (max) control_* , by (hhid controller_income )  //any decision															
ren controller_income personid
*Now merge with member characteristics
merge 1:1 hhid personid  using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_businessincome "1=invidual has control over business income"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_control_income.dta", replace


********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING	
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making
use "${Tanzania_NPS_W1_raw_data}/SEC_3A", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B"
append using "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.
*Make decision about planting and input
replace type_decision="planting_input" if  !inlist( s3aq6_1, .,0,99) |  !inlist( s3aq6_2, .,0,99) |  !inlist( s3aq6_3, .,0,99) 
replace decision_maker1=s3aq6_1 if !inlist( s3aq6_1, .,0,99)  
replace decision_maker2=s3aq6_2 if !inlist( s3aq6_2, .,0,99)
replace decision_maker3=s3aq6_3 if !inlist( s3aq6_3, .,0,99)
replace type_decision="planting_input" if  !inlist( s3bq6_1, .,0,99) |  !inlist( s3bq6_2, .,0,99) |  !inlist( s3bq6_3, .,0,99) 
replace decision_maker2=s3bq6_1 if !inlist( s3bq6_1, .,0,99)  
replace decision_maker2=s3bq6_2 if !inlist( s3bq6_2, .,0,99)
replace decision_maker3=s3bq6_3 if !inlist( s3bq6_3, .,0,99)
* keep/manage livesock
replace type_decision="livestockowners" if  !inlist( s10aq5_1, .,0,99) |  !inlist( s10aq5_2, .,0,99)  
replace decision_maker1=s10aq5_1 if !inlist( s10aq5_1, .,0,99)  
replace decision_maker2=s10aq5_2 if !inlist( s10aq5_2, .,0,99)   
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
gen make_decision_crop=1 if  type_decision=="planting_input"  						
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"  
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  
ren decision_maker personid
* Now merge with member characteristics
merge 1:1 hhid personid  using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", nogen 
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_make_ag_decision.dta", replace

 
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS		
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${Tanzania_NPS_W1_raw_data}/SEC_3A.dta", clear
append using "${Tanzania_NPS_W1_raw_data}/SEC_3B.dta" 
append using "${Tanzania_NPS_W1_raw_data}/SEC_10A.dta"
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.
* Ownership of land.
replace type_asset="landowners" if  !inlist( s3aq27_1, .,0,99) |  !inlist( s3aq27_2, .,0,99) 
replace asset_owner1=s3aq27_1 if !inlist( s3aq27_1, .,0,99)  
replace asset_owner2=s3aq27_1 if !inlist( s3aq27_2, .,0,99)
replace type_asset="landowners" if  !inlist( s3bq27_1, .,0,99) |  !inlist( s3bq27_2, .,0,99) 
replace asset_owner1=s3bq27_1 if !inlist( s3bq27_1, .,0,99)  
replace asset_owner2=s3bq27_1 if !inlist( s3bq27_2, .,0,99)
*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( s10aq5_1, .,0,99) |  !inlist( s10aq5_2, .,0,99)  
replace asset_owner1=s10aq5_1 if !inlist( s10aq5_1, .,0,99)  
replace asset_owner2=s10aq5_2 if !inlist( s10aq5_2, .,0,99)   
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
ren asset_owner personid
* Now merge with member characteristics
merge 1:1 hhid personid  using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", nogen 
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_ownasset.dta", replace

**# New crop code 
                                             
********************************************************************************
*CROP YIELDS
********************************************************************************
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", clear
gen number_trees_planted_cassava=number_trees_planted if crop_code==21 
gen number_trees_planted_banana=number_trees_planted if crop_code==71
recode number_trees_planted_cassava number_trees_planted_banana (.=0) 	
collapse (sum) number_trees_planted_*, by(hhid) //This should get revisited because some of the cassava might be off the plot by the second season, but we'll cast a wide net for now.
tempfile trees
save `trees'


use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", clear
*ren cropcode crop_code
gen no_harvest=ha_harvest==.
gen harvest=kg_harvest if season==0 & ha_plan_yld!=. 
gen area_plan=ha_plan_yld if season==0
gen area_harv = ha_harv_yld if season==0 
gen mixed = "inter"  //Note to adjust this for lost crops 
replace mixed="pure" if purestand==1
gen dm_gender2="unknown"
replace dm_gender2="male" if dm_gender==1
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3

foreach i in harvest area_plan area_harv {	
	foreach j in inter pure {
		gen `i'_`j'=`i' if mixed == "`j'"
		foreach k in male female mixed {
			gen `i'_`j'_`k' = `i' if mixed=="`j'" & dm_gender2=="`k'"
			capture confirm var `i'_`k'
			if _rc {
				gen `i'_`k'=`i' if dm_gender2=="`k'"
			}
		}
	}
}

collapse (sum) harvest* area* kg_harvest (max) no_harvest, by(hhid crop_code)
unab vars : harvest* area*
foreach var in `vars' {
	replace `var' = . if `var'==0 & no_harvest==1
}

replace area_plan = . if area_plan==0
replace area_harv = . if area_plan==. | (area_harv==0 & no_harvest==1)
unab vars2 : area_plan_*
local suffix : subinstr local vars2 "area_plan_" "", all
foreach var in `suffix' {
	replace area_plan_`var' = . if area_plan_`var'==0
	replace harvest_`var'=. if area_plan_`var'==. | (harvest_`var'==0 & no_harvest==1)
	replace area_harv_`var'=. if area_plan_`var'==. | (area_harv_`var'==0 & no_harvest==1)
}
//bencwp has been coded at this point. Beans (31) and Cowpeas (32) do not exist due to the recode. 
drop no_harvest
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_area_plan.dta", replace
preserve
	keep if inlist(crop_code, $comma_topcrop_area)
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_harvest_area_yield.dta", replace
restore
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_area_planted_harvested_allcrops.dta", replace
restore

*Yield at the household level
//ALT 07.21.21: Code continues here as written in W4

use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_harvest_area_yield.dta", clear
merge m:1 crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_cropname_table.dta", nogen keep(3)
merge 1:1 hhid crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production.dta", nogen keep(1 3) keepusing(value_crop_production value_crop_sales kgs_sold)
merge m:1 crop_code using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_cropname_table.dta", nogen keep(3)		
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
ren kgs_sold kgs_sold_
ren kg_harvest kg_harvest_

foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 

drop crop_code
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string
merge 1:1 hhid using `trees', nogen
egen kg_harvest = rowtotal(kg_harvest_*)
egen kgs_sold = rowtotal(kgs_sold_*)
lab var kgs_sold "Kgs sold (household) (all seasons)"
lab var kg_harvest "Kgs harvested (household) (all seasons)"
//lab var kgs_sold "Kgs sold (household) (all seasons)" //Do we need this here?
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (household)" 
	lab var value_sold_`p' "Value sold of `p' (household)" 
	lab var kg_harvest_`p'  "Harvest of `p' (kgs) (household) (all seasons)" 
	lab var kgs_sold_`p'  "Quantity sold of `p' (kgs) (household) (all seasons)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (all seasons)" 
	lab var total_planted_area_`p'  "Total area planted of `p' (ha) (household) (all seasons)" 
	lab var harvest_`p' "Harvest of `p' (kgs) (household)" 
	lab var harvest_male_`p' "Harvest of `p' (kgs) (male-managed plots)" 
	lab var harvest_female_`p' "Harvest of `p' (kgs) (female-managed plots)" 
	lab var harvest_mixed_`p' "Harvest of `p' (kgs) (mixed-managed plots)"
	lab var harvest_pure_`p' "Harvest of `p' (kgs) - purestand (household)"
	lab var harvest_pure_male_`p'  "Harvest of `p' (kgs) - purestand (male-managed plots)"
	lab var harvest_pure_female_`p'  "Harvest of `p' (kgs) - purestand (female-managed plots)"
	lab var harvest_pure_mixed_`p'  "Harvest of `p' (kgs) - purestand (mixed-managed plots)"
	lab var harvest_inter_`p' "Harvest of `p' (kgs) - intercrop (household)"
	lab var harvest_inter_male_`p' "Harvest of `p' (kgs) - intercrop (male-managed plots)" 
	lab var harvest_inter_female_`p' "Harvest of `p' (kgs) - intercrop (female-managed plots)"
	lab var harvest_inter_mixed_`p' "Harvest  of `p' (kgs) - intercrop (mixed-managed plots)"
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

*Household grew crop
foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
foreach p in cassav banana { //tree/permanent crops have no area in this instrument 
	replace grew_`p' = 1 if number_trees_planted_`p'!=0 & number_trees_planted_`p'!=.
}

*Household grew crop in the LRS
foreach p of global topcropname_area {
	gen grew_`p'_lrs=(area_harv_`p'!=. & area_harv_`p'!=0 ) | (area_plan_`p'!=. & area_plan_`p'!=0)
	lab var grew_`p'_lrs "1=Household grew `p' in the long rainy season" 
	gen harvested_`p'_lrs= (area_harv_`p'!=. & area_harv_`p'!=.0 )
	lab var harvested_`p'_lrs "1= Household harvested `p' in the long rainy season"
}

foreach p of global topcropname_area {
	recode kg_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}

//Drop everything that isn't crop-related - changing to make this location-independent.
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_yield_hh_crop_level.dta", replace


********************************************************************************
*PRODUCTION BY HIGH/LOW VALUE CROPS - ALT 07.21.21
********************************************************************************
* VALUE OF CROP PRODUCTION  // using 335 output
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production.dta", clear


*Grouping following IMPACT categories but also mindful of the consumption categories.
gen crop_group=""
replace crop_group=	"Maize"	if crop_code==	11
replace crop_group=	"Rice"	if crop_code==	12
replace crop_group=	"Millet and sorghum"	if crop_code==	13
replace crop_group=	"Millet and sorghum"	if crop_code==	14
replace crop_group=	"Millet and sorghum"	if crop_code==	15
replace crop_group=	"Wheat"	if crop_code==	16
replace crop_group=	"Other cereals"	if crop_code==	17
replace crop_group=	"Spices"	if crop_code==	18
replace crop_group=	"Spices"	if crop_code==	19
replace crop_group=	"Cassava"	if crop_code==	21
replace crop_group=	"Sweet potato"	if crop_code==	22
replace crop_group=	"Potato"	if crop_code==	23
replace crop_group=	"Yam"	if crop_code==	24
replace crop_group=	"Yam"	if crop_code==	25
replace crop_group=	"Vegetables"	if crop_code==	26
replace crop_group=	"Spices"	if crop_code==	27
replace crop_group=	"Beans, peas, and pulses"	if crop_code==	31
replace crop_group=	"Beans, peas, and pulses"	if crop_code==	32
replace crop_group=	"Beans, peas, and pulses"	if crop_code==	33
replace crop_group=	"Beans, peas, and pulses"	if crop_code==	34
replace crop_group=	"Beans, peas, and pulses"	if crop_code==	35
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	36
replace crop_group=	"Beans, peas, and pulses"	if crop_code==	37
replace crop_group=	"Fruits"	if crop_code==	38
replace crop_group=	"Fruits"	if crop_code==	39
replace crop_group=	"Oils and fats"	if crop_code==	41
replace crop_group=	"Oils and fats"	if crop_code==	42
replace crop_group=	"Groundnuts"	if crop_code==	43
replace crop_group=	"Oils and fats"	if crop_code==	44
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	45
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	46
replace crop_group=	"Soyabeans"	if crop_code==	47
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	48
replace crop_group=	"Cotton"	if crop_code==	50
replace crop_group=	"Other other"	if crop_code==	51
replace crop_group=	"Other other"	if crop_code==	52
replace crop_group=	"Other other"	if crop_code==	53
replace crop_group=	"Tea, coffee, cocoa"	if crop_code==	54
replace crop_group=	"Tea, coffee, cocoa"	if crop_code==	55
replace crop_group=	"Tea, coffee, cocoa"	if crop_code==	56
replace crop_group=	"Other other"	if crop_code==	57
replace crop_group=	"Other other"	if crop_code==	58
replace crop_group=	"Other other"	if crop_code==	59
replace crop_group=	"Sugar"	if crop_code==	60
replace crop_group=	"Spices"	if crop_code==	61
replace crop_group=	"Spices"	if crop_code==	62
replace crop_group=	"Spices"	if crop_code==	63
replace crop_group=	"Spices"	if crop_code==	64
replace crop_group=	"Spices"	if crop_code==	65
replace crop_group=	"Spices"	if crop_code==	66
replace crop_group=	"Fruits"	if crop_code==	67
replace crop_group=	"Fruits"	if crop_code==	68
replace crop_group=	"Fruits"	if crop_code==	69
replace crop_group=	"Fruits"	if crop_code==	70
replace crop_group=	"Bananas and plantains"	if crop_code==	71
replace crop_group=	"Fruits"	if crop_code==	72
replace crop_group=	"Fruits"	if crop_code==	73
replace crop_group=	"Fruits"	if crop_code==	74
replace crop_group=	"Fruits"	if crop_code==	75
replace crop_group=	"Fruits"	if crop_code==	76
replace crop_group=	"Fruits"	if crop_code==	77
replace crop_group=	"Fruits"	if crop_code==	78
replace crop_group=	"Fruits"	if crop_code==	79
replace crop_group=	"Fruits"	if crop_code==	80
replace crop_group=	"Fruits"	if crop_code==	81
replace crop_group=	"Fruits"	if crop_code==	82
replace crop_group=	"Fruits"	if crop_code==	83
replace crop_group=	"Fruits"	if crop_code==	84
replace crop_group=	"Vegetables"	if crop_code==	86
replace crop_group=	"Vegetables"	if crop_code==	87
replace crop_group=	"Vegetables"	if crop_code==	88
replace crop_group=	"Vegetables"	if crop_code==	89
replace crop_group=	"Vegetables"	if crop_code==	90
replace crop_group=	"Vegetables"	if crop_code==	91
replace crop_group=	"Vegetables"	if crop_code==	92
replace crop_group=	"Vegetables"	if crop_code==	93
replace crop_group=	"Vegetables"	if crop_code==	94
replace crop_group=	"Fruits"	if crop_code==	95
replace crop_group=	"Vegetables"	if crop_code==	96
replace crop_group=	"Vegetables"	if crop_code==	97
replace crop_group=	"Vegetables"	if crop_code==	98
replace crop_group=	"Vegetables"	if crop_code==	99
replace crop_group=	"Vegetables"	if crop_code==	100
replace crop_group=	"Fruits"	if crop_code==	101
replace crop_group=	"Fruits"	if crop_code==	200
replace crop_group=	"Fruits"	if crop_code==	201
replace crop_group=	"Fruits"	if crop_code==	202
replace crop_group=	"Fruits"	if crop_code==	203
replace crop_group=	"Fruits"	if crop_code==	204
replace crop_group=	"Fruits"	if crop_code==	205
replace crop_group=	"Other other"	if crop_code==	210
replace crop_group=	"Vegetables"	if crop_code==	211
replace crop_group=	"Vegetables"	if crop_code==	212
replace crop_group=	"Vegetables"	if crop_code==	300
replace crop_group=	"Vegetables"	if crop_code==	301
replace crop_group=	"Other other"	if crop_code==	302
replace crop_group=	"Other other"	if crop_code==	303
replace crop_group=	"Other other"	if crop_code==	304
replace crop_group=	"Other other"	if crop_code==	305
replace crop_group=	"Other other"	if crop_code==	306
replace crop_group=	"Fruits"	if crop_code==	851
replace crop_group=	"Fruits"	if crop_code==	852
replace crop_group=	"Other other"	if crop_code==	998
ren  crop_group commodity

*High/low value crops
gen type_commodity=""
* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"Low"	if crop_code==	11
replace type_commodity=	"High"	if crop_code==	12
replace type_commodity=	"Low"	if crop_code==	13
replace type_commodity=	"Low"	if crop_code==	14
replace type_commodity=	"Low"	if crop_code==	15
replace type_commodity=	"Low"	if crop_code==	16
replace type_commodity=	"Low"	if crop_code==	17
replace type_commodity=	"High"	if crop_code==	18
replace type_commodity=	"High"	if crop_code==	19
replace type_commodity=	"Low"	if crop_code==	21
replace type_commodity=	"Low"	if crop_code==	22
replace type_commodity=	"Low"	if crop_code==	23
replace type_commodity=	"Low"	if crop_code==	24
replace type_commodity=	"Low"	if crop_code==	25
replace type_commodity=	"High"	if crop_code==	26
replace type_commodity=	"High"	if crop_code==	27
replace type_commodity=	"High"	if crop_code==	31
replace type_commodity=	"High"	if crop_code==	32
replace type_commodity=	"High"	if crop_code==	33
replace type_commodity=	"High"	if crop_code==	34
replace type_commodity=	"High"	if crop_code==	35
replace type_commodity=	"High"	if crop_code==	36
replace type_commodity=	"High"	if crop_code==	37
replace type_commodity=	"High"	if crop_code==	38
replace type_commodity=	"High"	if crop_code==	39
replace type_commodity=	"High"	if crop_code==	41
replace type_commodity=	"High"	if crop_code==	42
replace type_commodity=	"High"	if crop_code==	43
replace type_commodity=	"Out"	if crop_code==	44
replace type_commodity=	"High"	if crop_code==	45
replace type_commodity=	"High"	if crop_code==	46
replace type_commodity=	"High"	if crop_code==	47
replace type_commodity=	"High"	if crop_code==	48
replace type_commodity=	"Out"	if crop_code==	50
replace type_commodity=	"Out"	if crop_code==	51
replace type_commodity=	"High"	if crop_code==	52
replace type_commodity=	"Out"	if crop_code==	53
replace type_commodity=	"High"	if crop_code==	54
replace type_commodity=	"Out"	if crop_code==	55
replace type_commodity=	"High"	if crop_code==	56
replace type_commodity=	"Out"	if crop_code==	57
replace type_commodity=	"Out"	if crop_code==	58
replace type_commodity=	"Out"	if crop_code==	59
replace type_commodity=	"Out"	if crop_code==	60
replace type_commodity=	"High"	if crop_code==	61
replace type_commodity=	"Out"	if crop_code==	62
replace type_commodity=	"High"	if crop_code==	63
replace type_commodity=	"High"	if crop_code==	64
replace type_commodity=	"High"	if crop_code==	65
replace type_commodity=	"High"	if crop_code==	66
replace type_commodity=	"High"	if crop_code==	67
replace type_commodity=	"High"	if crop_code==	68
replace type_commodity=	"High"	if crop_code==	69
replace type_commodity=	"High"	if crop_code==	70
replace type_commodity=	"Low"	if crop_code==	71
replace type_commodity=	"High"	if crop_code==	72
replace type_commodity=	"High"	if crop_code==	73
replace type_commodity=	"High"	if crop_code==	74
replace type_commodity=	"High"	if crop_code==	75
replace type_commodity=	"High"	if crop_code==	76
replace type_commodity=	"High"	if crop_code==	77
replace type_commodity=	"High"	if crop_code==	78
replace type_commodity=	"High"	if crop_code==	79
replace type_commodity=	"High"	if crop_code==	80
replace type_commodity=	"High"	if crop_code==	81
replace type_commodity=	"High"	if crop_code==	82
replace type_commodity=	"High"	if crop_code==	83
replace type_commodity=	"High"	if crop_code==	84
replace type_commodity=	"High"	if crop_code==	86
replace type_commodity=	"High"	if crop_code==	87
replace type_commodity=	"High"	if crop_code==	88
replace type_commodity=	"High"	if crop_code==	89
replace type_commodity=	"High"	if crop_code==	90
replace type_commodity=	"High"	if crop_code==	91
replace type_commodity=	"High"	if crop_code==	92
replace type_commodity=	"High"	if crop_code==	93
replace type_commodity=	"High"	if crop_code==	94
replace type_commodity=	"High"	if crop_code==	95
replace type_commodity=	"High"	if crop_code==	96
replace type_commodity=	"High"	if crop_code==	97
replace type_commodity=	"High"	if crop_code==	98
replace type_commodity=	"High"	if crop_code==	99
replace type_commodity=	"High"	if crop_code==	100
replace type_commodity=	"High"	if crop_code==	101
replace type_commodity=	"High"	if crop_code==	200
replace type_commodity=	"High"	if crop_code==	201
replace type_commodity=	"High"	if crop_code==	202
replace type_commodity=	"High"	if crop_code==	203
replace type_commodity=	"High"	if crop_code==	204
replace type_commodity=	"High"	if crop_code==	205
replace type_commodity=	"High"	if crop_code==	210
replace type_commodity=	"High"	if crop_code==	211
replace type_commodity=	"High"	if crop_code==	212
replace type_commodity=	"High"	if crop_code==	300
replace type_commodity=	"High"	if crop_code==	301
replace type_commodity=	"High"	if crop_code==	302
replace type_commodity=	"Out"	if crop_code==	303
replace type_commodity=	"Out"	if crop_code==	304
replace type_commodity=	"Out"	if crop_code==	305
replace type_commodity=	"Out"	if crop_code==	306
replace type_commodity=	"High"	if crop_code==	851
replace type_commodity=	"High"	if crop_code==	852
replace type_commodity=	"Out"	if crop_code==	998

//ALT 07.22.21: Edited b/c no wheat
preserve
collapse (sum) value_crop_production value_crop_sales, by(hhid commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
foreach s in pro sal {
	ren value_`s'1 value_`s'_bana
	ren value_`s'2 value_`s'_bpuls
	ren value_`s'3 value_`s'_casav
	ren value_`s'4 value_`s'_coton
	ren value_`s'5 value_`s'_fruit
	ren value_`s'6 value_`s'_gdnut
	ren value_`s'7 value_`s'_maize
	ren value_`s'8 value_`s'_mlsor
	ren value_`s'9 value_`s'_oilc
	ren value_`s'10 value_`s'_onuts
	ren value_`s'11 value_`s'_oths
	ren value_`s'12 value_`s'_pota
	ren value_`s'13 value_`s'_rice
	ren value_`s'14 value_`s'_sybea
	ren value_`s'15 value_`s'_spice
	ren value_`s'16 value_`s'_suga
	ren value_`s'17 value_`s'_spota
	ren value_`s'18 value_`s'_tcofc
	ren value_`s'19 value_`s'_vegs
	//ren value_`s'20 value_`s'_whea
	ren value_`s'20 value_`s'_yam
	gen value_`s'_whea=.
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
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production_grouped.dta", replace
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
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_area_plan.dta", clear
collapse (sum) area_plan*, by(hhid crop_code)
*Some households have crop observations, but the area planted=0. This will give them an encs of 1 even though they report no crops. Dropping these observations
drop if crop_code==.
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
gen multiple_crops = (num_crops_hh>1 & num_crops_hh!=.)
la var multiple_crops "Household grows more than one crop"
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_shannon_diversity_index.dta", replace


 
********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Tanzania_NPS_W1_raw_data}/TZY1.HH.Consumption.dta", clear
ren expmR total_cons // using real consumption-adjusted for region price disparities
gen peraeq_cons = (total_cons / adulteq)
gen daily_peraeq_cons = peraeq_cons/365
gen percapita_cons = (total_cons / hhsize)
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent in the HH"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var percapita_cons "Consumption per HH member"
lab var daily_percap_cons "Daily consumption per capita"
keep hhid total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons adulteq
save "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_consumption.dta", replace

 
********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
// Wave 1 did not report household food insecurity.


********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
// Wave 1 only reported the number of assets and not value.


********************************************************************************
*DISTANCE TO AGRO DEALERS*
********************************************************************************
*Cannot create in this instrument


********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************

global empty_vars ""
//use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", clear
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_weights.dta", clear

*Gross crop income 
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_production.dta", nogen
* Production by group and type of crop
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)
*Variables: value_crop_production crop_value_lost
* Production by group and type of crops
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_crop_values_production_type_crop.dta", nogen

recode value_pro* value_sal* (.=0)
*Crop costs
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_cost_inputs.dta", nogen
recode cost_expli_hh (.=0) if value_crop_production!=.
gen crop_production_expenses = cost_expli_hh //ALT Kludge, to fix
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost //ALT 10.14.24

lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue"

foreach c in $topcropname_area {
	capture confirm file "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_inputs_`c'.dta"
	if _rc==0 {
	merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_`c'_monocrop_hh_area.dta", nogen
	}
}

global empty_crops ""

foreach c in $topcropname_area {
	//ALT 07.23.21: Because variable names are similar, we can use wildcards to collapse and avoid mentioning missing variables by name.
capture confirm var `c'_monocrop //Check to make sure this isn't empty.
if !_rc {
	egen `c'_exp = rowtotal(val_*_`c'_hh) //Only explicit costs for right now; add "exp" and "imp" tag to variables to disaggregate in future 
	lab var `c'_exp "Crop production costs(explicit)-Monocrop `c' plots only"
	la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household"		
	*disaggregate by gender of plot manager
	foreach i in male female mixed{
		egen `c'_exp_`i' = rowtotal(val_*_`c'_`i')
		local l`c'_exp : var lab `c'_exp
		la var `c'_exp_`i' "`l`c'_exp' - `i' managed plots"
	}
	replace `c'_exp = . if `c'_monocrop_ha==.			// set to missing if the household does not have any monocropped plots
	foreach i in male female mixed{
		replace `c'_exp_`i' = . if `c'_monocrop_ha_`i'==.
			}
	}
	else {
		global empty_crops $empty_crops `c'
	}
		
}


*land rights
merge 1:1 hhid using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rights_hh.dta", nogen
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_sales", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_livestock_products", nogen
*merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_dung.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_expenses", nogen //only fodder and hired labor in this wave.
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_TLU.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_herd_characteristics", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_TLU_Coefficients.dta", nogen
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_expenses_animal.dta", nogen 

*other household characteristics 
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_mobile_own.dta", nogen //ALT: Not constructed

gen ls_exp_vac =. 
gen cost_water_livestock = .
gen sales_dung = .
gen value_livestock_purchases =. 
global empty_vars $empty_vars cost_water_livestock ls_exp_vac

/*OUT DYA.10.30.2020*/
recode value_slaughtered value_lvstck_sold value_livestock_purchases value_milk_produced value_eggs_produced value_other_produced sales_dung cost_hired_labor_livestock cost_fodder_livestock (.=0) // AYW 8.7.20
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /* 
*/ - (cost_hired_labor_livestock + cost_fodder_livestock)
lab var livestock_income "Net livestock income"
gen livestock_expenses = cost_hired_labor_livestock + cost_fodder_livestock
drop value_livestock_purchases value_other_produced sales_dung cost_hired_labor_livestock cost_fodder_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"

*Self-employment income
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_self_employment_income.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_agproducts_profits.dta", nogen

/*OUT DYA.10.30.2020*/
egen self_employment_income = rowtotal(annual_selfemp_profit /*fish_trading_income*/ byproduct_profits)
lab var self_employment_income "Income from self-employment"
drop annual_selfemp_profit /*fish_trading_income*/ byproduct_profits 

*Wage income
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_wage_income.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_agwage_income.dta", nogen
/*OUT DYA.10.30.2020*/
recode annual_salary annual_salary_agwage(.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_off_farm_hours.dta", nogen

*Other income
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_other_income.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rental_income.dta", nogen

/*OUT DYA.10.30.2020*/
egen transfers_income = rowtotal ( remittance_income assistance_income) //pension_income 
lab var transfers_income "Income from transfers including remittances, and assisances)"
egen all_other_income = rowtotal (  land_rental_income) //rental_income other_income
lab var all_other_income "Income from all other revenue"
drop remittance_income assistance_income land_rental_income

*Farm size
merge 1:1 hhid using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_size.dta", nogen
merge 1:1 hhid using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_size_all.dta", nogen
merge 1:1 hhid using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmsize_all_agland.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_size_total.dta", nogen

/*OUT DYA.10.30.2020*/
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
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_family_hired_labor.dta", nogen


*Household size
merge 1:1 hhid using  "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhsize.dta", nogen
//Should be in weights.dta

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_vaccine.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_input_use.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_imprvseed_crop.dta"  
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_any_ext.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fin_serv.dta", nogen

/*OUT DYA.10.30.2020*/
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. 
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.
global empty_vars $empty_vars imprv_seed_cassav imprv_seed_banana hybrid_seed_*

*Milk productivity
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_milk_animals.dta", nogen

/*OUT DYA.10.30.2020*/
//gen liters_milk_produced=liters_per_largeruminant * milk_animals //Already constructed
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
//drop liters_per_largeruminant //does not exist
gen liters_per_cow = . 
gen liters_per_buffalo = . 

*Dairy costs 
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_lrum_expenses", nogen

/*OUT DYA.10.30.2020*/
//ALT Note: we can construct this but do not currently  
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
lab var avg_cost_lrum "Average cost per large ruminant"
//gen costs_dairy = avg_cost_lrum*milk_animals 
gen costs_dairy=.
gen costs_dairy_percow = avg_cost_lrum
drop avg_cost_lrum cost_lrum
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen share_imp_dairy = . 

*Egg productivity
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_eggs_animals.dta", nogen

/*OUT DYA.10.30.2020*/
gen egg_poultry_year = . 
global empty_vars $empty_vars *liters_per_cow *liters_per_buffalo *costs_dairy_percow* share_imp_dairy *egg_poultry_year

*Costs of crop production per hectare
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_cropcosts_total.dta", nogen
*Rate of fertilizer application 
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_fertilizer_application.dta", nogen
*Agricultural wage rate
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_ag_wage.dta", nogen //ALT: No longer necessary 
*Crop yields 
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_yield_hh_crop_level.dta", nogen
*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_area_planted_harvested_allcrops.dta", nogen
*Household diet
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_household_diet.dta", nogen
*Consumption
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_consumption.dta", nogen
*Household assets
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hh_assets.dta", nogen

*Food insecurity
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_food_insecurity.dta", nogen

/*OUT DYA.10.30.2020*/
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Livestock health
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_diseases.dta", nogen

*livestock feeding, water, and housing
//merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_livestock_feed_water_house.dta", nogen
 
*Shannon diversity index
merge 1:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_shannon_diversity_index.dta", nogen

/*OUT DYA.10.30.2020*/ 
*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered  value_lvstck_sold (.=0)
egen value_farm_production = rowtotal(value_crop_production value_livestock_products value_slaughtered value_lvstck_sold)
lab var value_farm_production "Total value of farm production (crops + livestock products)"
egen value_farm_prod_sold = rowtotal(value_crop_sales sales_livestock_products value_livestock_sales)
lab var value_farm_prod_sold "Total value of farm production that is sold" 
*replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

*Agricultural households
recode crop_income livestock_income farm_area tlu_today land_size farm_size_agland value_farm_prod_sold (.=0)
gen ag_hh = (value_crop_production!=0 | livestock_income !=0 | farm_area!=0 | tlu_today!=0)
recode value_farm_production value_farm_prod_sold value_crop_production value_livestock_products value_slaughtered value_lvstck_sold (0=.) if ag_hh==0
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"
replace value_farm_production=. if ag_hh==0

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
gen fishing_income=0 //ALT 07.23.21: Do not have this for this wave. 
//recode fishing_income (.=0)
gen fishing_hh = (fishing_income!=0)
lab  var fishing_hh "1= Household has some fishing income"



****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops

	unab cropvarlist : *maize* //ALT: dealing with missing crops (in this wave, wheat) is kind of a pain in the neck - other waves just tend to omit the missing crops, but this can create issues if we end up with changes in crops from wave to wave; it can also be an issue for users who might inadvertently change the list to include an obscure crop that might only show up in one wave or none whatsoever - it seems preferable to build something that's robust to weird inputs. A procedural way to generate a list of crop variables to fill with empty values might work well, but we have to have a way to get all those values. Listing them out by hand is tedious and subject to breaking the second we add, adjust, or remove variables. A kludge can be to search by a crop we expect to *always* show up in the code, but there should be a less brittle way to do this.
	//This method also results in some weird empty variables in value_pro because we use different abbreviations for most of those crops except for the common ones.
foreach c in $empty_crops {
	local allcropvars : subinstr local cropvarlist "maize" "`c'", all //Replace maize with missing crop
		di "`allcropvars'"
			foreach i in `allcropvars' {
				capture confirm var `i'
				if _rc {
					gen `i'=.
				}
			}
}

recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kg_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kg_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
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
	recode lost_disease_`i' disease_animal_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' disease_animal_`i' (.=0) if lvstck_holding_`i'==1	
}
 
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
 
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal (nonmissing=.) if livestock_hh==0
 
*all rural households 
recode /*DYA.10.26.2020*/ /*hrs_ag_activ*/ /*ALT: To be implemented in W2*/ /*hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/ crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income /*value_assets*/ /*NA for W2*/ (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed"
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kg_harvest* kgs_harv_mono* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months* mean_12months* lost_disease* /* 
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced egg_poultry_year /*
*/ /*DYA.10.26.2020*/ /*hrs_ag_activ*/ /*ALT: To be implemented in W2*/ /*hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm*/ crop_production_expenses /*value_assets*/ /*NA for W2*/ cost_expli_hh /*
*/ livestock_expenses /*ls_exp_vac**/  sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold value_pro* value_sal*

foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager
gen cost_expli=cost_expli_hh //These are the same but get used inconsistently across the file; kludge to fix 
gen cost_total=cost_total_hh 

global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp 
}
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg org_fert_kg n_kg p_kg k_kg dap_kg ha_irr can_kg sa_kg mrp_kg n_org_kg npk_kg urea_kg pest_kg wage_paid_aglabor
gen wage_paid_aglabor=.
gen wage_paid_aglabor_female=. 
gen wage_paid_aglabor_male=.
gen wage_paid_aglabor_mixed=. 
lab var wage_paid_aglabor_female "Daily wage in agricuture - female workers"
lab var wage_paid_aglabor_male "Daily wage in agricuture - male workers"

global empty_vars $empty_vars *wage_paid_aglabor_female* *wage_paid_aglabor_male* inorg_fert_kg org_fert_kg n_kg p_kg k_kg dap_kg can_kg sa_kg mrp_kg n_org_kg npk_kg urea_kg pest_kg 
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

**# Bookmark #1

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
 
*generate inorg_fert_kg, costs_total_ha, and costs_expli_ha using winsorized values
foreach v in inorg_fert org_fert n p k  pest urea npk  {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
}
}
gen cost_total_ha = w_cost_total / w_ha_planted  
gen cost_expli_ha = w_cost_expli / w_ha_planted 
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted

foreach g of global gender {
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 			
}
lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household)"
lab var k_rate "Rate of postassium application (kgs/ha) (household)"
lab var p_rate "Rate of phosphorus appliction (kgs/ha) (household)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household)"
*lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
lab var urea_rate "Rate of urea application (kgs/ha) (household)"
lab var npk_rate "Rate of NPK fertilizer application (kgs/ha) (household)" 

foreach g in $gender {
lab var inorg_fert_rate_`g' "Rate of fertilizer application (kgs/ha) (`g'-managed crops)"
lab var cost_total_ha_`g' "Explicit + implicit costs (per ha) of crop production (`g'-managed plots)"
lab var cost_expli_ha_`g' "Explicit costs (per ha) of crop production (`g'-managed plots)"
lab var org_fert_rate_`g' "Rate of organic fertilizer application (kgs/ha) (`g'-managed plots)"
lab var n_rate_`g' "Rate of nitrogen application (kgs/ha) (`g'-managed plots)"
lab var k_rate_`g' "Rate of postassium application (kgs/ha) (`g'-managed plots)"
lab var p_rate_`g' "Rate of phosphorus appliction (kgs/ha) (`g'-managed plots)"
lab var pest_rate_`g' "Rate of pesticide application (kgs/ha) (`g'-managed plots)"
*lab var herb_rate_`g' "Rate of herbicide application (kgs/ha) (`g'-managed plots)"
lab var urea_rate_`g' "Rate of urea application (kgs/ha) (`g'-managed plots)"
lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
}

lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"

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

/*DYA.10.26.2020*/ 
*Hours per capita using winsorized version off_farm_hours 
*Add in later for Ahana - ag_activ
foreach x in  wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all  {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}
**# Bookmark #1

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh / w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*milk productivity
//ALT 10.14.24
//gen liters_per_largeruminant= w_liters_milk_produced/milk_animals 
gen liters_per_largeruminant = .
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
recode inorg_fert_kg cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_kg cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}

*all rural households 
 recode hrs_*_pc_all (.=0)   //ALT: to do
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
*/ mortality_rate* liters_per_largeruminant /*costs_dairy_percow*/ liters_per_cow liters_per_buffalo /*
*/  hrs_*_pc_all hrs_*_pc_any* cost_per_lit_milk 	

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
gen total_income = crop_income +livestock_income +fishing_income +self_employment_income +nonagwage_income+  agwage_income+ transfers_income+ all_other_income
gen nonfarm_income = fishing_income +self_employment_income+ nonagwage_income +transfers_income +all_other_income
gen farm_income = crop_income +livestock_income+ agwage_income
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"

gen w_total_income = w_crop_income +w_livestock_income + w_self_employment_income+ w_nonagwage_income +w_agwage_income+ w_transfers_income +w_all_other_income
gen w_nonfarm_income = w_fishing_income+ w_self_employment_income+ w_nonagwage_income +w_transfers_income +w_all_other_income
gen w_farm_income = w_crop_income+ w_livestock_income +w_agwage_income
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"

global income_vars crop livestock fishing self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
gen `p'_income_s = `p'_income
replace `p'_income_s = 0 if `p'_income_s < 0
*replace `p'_income_s = 0 if `p'_income_s == . 

gen w_`p'_income_s = w_`p'_income
replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
*replace w_`p'_income_s = 0 if w_`p'_income_s == . 
}


gen w_total_income_s = w_crop_income_s +w_livestock_income_s + w_self_employment_income_s+ w_nonagwage_income_s +w_agwage_income_s  +w_transfers_income_s+ w_all_other_income_s
foreach p of global income_vars {
gen w_share_`p' = w_`p'_income_s / w_total_income_s
lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}

gen w_nonfarm_income_s = w_fishing_income_s +w_self_employment_income_s +w_nonagwage_income_s+ w_transfers_income_s+ w_all_other_income_s
 
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
*/ formal_land_rights_hh  /*DYA.10.26.2020*/ *_hrs_*_pc_all  /*months_food_insec w_value_assets*/ /*NA for W2*/ /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses /*w_ls_exp_vac*/  any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses /*w_ls_exp_vac*/  any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' /*w_ls_exp_vac_`i'*/ (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' /*w_ls_exp_vac_`i'*/ (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_kg* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_kg* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kg_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kg_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
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
//gen weight_milk=milk_animals*weight
//gen weight_egg=poultry_owned*weight
gen weight_milk=.
gen weight_egg=.
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
capture confirm var adulteq //ALT 07.23.21: Writing this so I don't have to comment it out while we work on consumption
if _rc==0 gen adulteq_weight=adulteq*weight 
else {
	gen adulteq=hh_members
	gen adulteq_weight=individual_weight
}

********Currency Conversion Factors*********
gen ccf_loc = (1/$Tanzania_NPS_W1_infl_adj) 
lab var ccf_loc "currency conversion factor - 2017 $NGN"
gen ccf_usd = ccf_loc/$Tanzania_NPS_W1_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Tanzania_NPS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Tanzania_NPS_W1_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"


************Rural poverty headcount ratio***************

gen poverty_under_190 = daily_percap_cons < $Tanzania_NPS_W1_poverty_190
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $Tanzania_NPS_W1_poverty_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $Tanzania_NPS_W1_poverty_npl
gen poverty_under_300 = daily_percap_cons < $Tanzania_NPS_W1_poverty_300
la var poverty_under_300 "Household per-capita consumption is below $3.00 in 2021 $ PPP"

_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

*replace vars that cannot be created with .

*replace empty vars with missing 
foreach v of varlist $empty_vars {
	replace `v' = .
}

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* region  district  ward /*region_name ward_name district_name*/ /*village*/ /*village_name*/ ea rural farm_size* *total_income* /*
*/ percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq* *labor_family *labor_hired use_inorg_fert vac_* /*
*/ /*feed* water**/ * ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* /*ls_exp_vac*/ *prop_farm_prod_sold  /*DYA.10.26.2020*/ /**hrs_**/    /*months_food_insec value_assets*/ hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* /*milk_animals*/ /*poultry_owned*/ *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_kg* *ha_planted* *cost_expli* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty* *value_crop_production* *value_harv* *_kg *value_crop_sales* *value_sold* *kg_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* total_cons nb_cattle_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products *value_pro* *value_sal*  /*DYA 10.6.2020*/ *value_livestock_sales*  *w_value_farm_production* *value_slaughtered* *value_lvstck_sold* *value_crop_sales* *sales_livestock_products* *value_livestock_sales* nb*

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren hhid hhid
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Tanzania" 
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 12
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
la val instrument instrument
gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_largerum_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) & ag_hh==1  
saveold "${Tanzania_NPS_W1_final_data}/Tanzania_NPS_W1_household_variables.dta", replace


********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_person_ids.dta", clear
merge m:1 hhid   using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_household_diet.dta", nogen

merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_ownasset.dta", nogen  keep(1 3)

//merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhsize.dta", nogen keep (1 3) // Should be in weights.dta

merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmer_input_use.dta", nogen  keep(1 3) //ALT 07.22.21: fert -> input
merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_weights.dta", nogen keep (1 3) 

//merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", nogen keep (1 3) //replaced by weights.dta

*land rights
merge 1:1 hhid indiv using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_land_rights_ind.dta", nogen
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
recode make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 //control_all_income
recode make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0 //control_all_income
* NA in TZA NPS_LSMS-ISA
gen women_diet=.
replace number_foodgroup=.

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren hhid hhid
ren personid indid
merge m:1 hhid using "${Tanzania_NPS_W1_final_data}/Tanzania_NPS_W1_household_variables.dta", nogen keep (1 3) keepusing(ag_hh)
replace make_decision_ag =. if ag_hh==0
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Tanzania" 
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 12
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
saveold "${Tanzania_NPS_W1_final_data}/Tanzania_NPS_W1_individual_variables.dta", replace


********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", clear
collapse (sum) plot_value_harvest=value_harvest, by(dm_gender hhid plot_id field_size season)
merge m:1 hhid plot_id  using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_family_hired_labor.dta", keep (1 3) nogen //season
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", keep (1 3) nogen //ALT 07.26.21: Note to include this in the all_plots file.

/*DYA.12.2.2020*/ merge m:1 hhid using "${Tanzania_NPS_W1_final_data}/Tanzania_NPS_W1_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 
//replace area_meas_hectares=area_est_hectares if area_meas_hectares==.
ren field_size area_meas_hectares

*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_all_plots.dta", clear
collapse (sum) plot_value_harvest=value_harvest, by(dm_gender hhid plot_id field_size)
merge m:1 hhid plot_id using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_plot_family_hired_labor.dta", keep (1 3)nogen //season
merge m:1 hhid using "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_hhids.dta", keep (1 3) nogen //ALT 07.26.21: Note to include this in the all_plots file.

/*DYA.12.2.2020*/ merge m:1 hhid using "${Tanzania_NPS_W1_final_data}/Tanzania_NPS_W1_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

//replace area_meas_hectares=area_est_hectares if area_meas_hectares==.
ren field_size area_meas_hectares
//keep if cultivated==1
global winsorize_vars area_meas_hectares  labor_total  plot_value_harvest 
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}

*winsorize plot_value_harvest at top 1% only 
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*winsorize both land labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres) 
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	

gen ccf_loc = (1/$Tanzania_NPS_W1_infl_adj) 
lab var ccf_loc "currency conversion factor - 2017 $TSH"
gen ccf_usd = ccf_loc/$Tanzania_NPS_W1_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Tanzania_NPS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Tanzania_NPS_W1_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

*Convert monetary values to USD and PPP
global monetary_val plot_value_harvest plot_productivity plot_labor_prod  //ALT note: check 895 missing values?

foreach p of varlist $monetary_val {
	foreach n in 1ppp 2ppp usd loc {
	gen `p'_`n' =  `p' * ccf_`n'
	gen w_`p'_`n' = w_`p'*ccf_`n'
	local lw_`p' : var lab w_`p'
}
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2017 $ Pvt Cons PPP)"
	lab var `p'_2ppp "`l`p'' (2017 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2017 $ USD)"
	lab var `p'_loc "`l`p'' (2017 TSH)"  
	lab var `p' "`l`p'' (TSH)"  
	lab var w_`p'_1ppp "`lw_`p'' (2017 $ Pvt Cons PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2017 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2017 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2017 TSH)"
	lab var w_`p' "`lw_`p'' (TSH)"  
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only


*** With winsorized variables
gen lplot_productivity_usd=ln(w_plot_productivity_usd) 
gen larea_meas_hectares=ln(w_area_meas_hectares)

/*
*** With non-winsorized variables //BT 12.04.2020 - Estimates do not change substantively 
gen lplot_productivity_usd=ln(plot_productivity_usd) 
gen larea_meas_hectares=ln(area_meas_hectares)

*/

*Gender-gap 1a 
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
lab var gender_prod_gap1b_lsp "Gender productivity gap (%) - regression in logs with controls - LSP"
matrix V1b=e(V)
gen segender_prod_gap1b_lsp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_lsp
lab var segender_prod_gap1b_lsp "SE Gender productivity gap (%) - regression in logs with controls - LSP"
/*DYA.12.2.2020 - End*/ 

/// *BT 12.3.2020

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


save   "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_gendergap.dta", replace
*save   "${Tanzania_NPS_W1_created_data}/Tanzania_NPS_W1_gendergap_nowin.dta", replace
restore

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
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Tanzania" 
gen survey = "LSMS-ISA" 
gen year = "2010-11" 
gen instrument = 12
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS SDD" 16 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument	
saveold "${Tanzania_NPS_W1_final_data}/Tanzania_NPS_W1_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Tanzania_NPS_W1"

do "$summary_stats"
