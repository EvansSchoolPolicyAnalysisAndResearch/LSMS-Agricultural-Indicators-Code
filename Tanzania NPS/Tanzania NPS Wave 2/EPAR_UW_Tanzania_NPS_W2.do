
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: Agricultural Development Indicators for the LSMS-ISA, Tanzania National Panel Survey (TNPS) LSMS-ISA Wave 2 (2010-11)
*Author(s)		: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu

*Date			: March 31st, 2025
*Dataset Version	: TZA_2010_NPS-R2_v02_M_STATA8
----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Tanzania National Panel Survey was collected by the Tanzania National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period October 2010 - September 2011.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1050

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Tanzania National Panel Survey.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Tanzania NPS data set.
*Using data files from the "Raw DTA files" folder from within the "Tanzania NPS Wave 2" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in the folder "created_data" within the "Final DTA files" folder.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_W2_summary_stats.xlsx" in the "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".

 
/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file+
 					
*MAIN INTERMEDIATE FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Tanzania_NPS_W2_hhids.dta
*INDIVIDUAL IDS						Tanzania_NPS_W2_person_ids.dta
*HOUSEHOLD SIZE						Tanzania_NPS_W2_hhsize.dta
*PLOT AREAS							Tanzania_NPS_W2_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Tanzania_NPS_W2_plot_decision_makers.dta

*MONOCROPPED PLOTS					Tanzania_NPS_W2_[CROP]_monocrop_hh_area.dta

*TLU (Tropical Livestock Units)		Tanzania_NPS_W2_TLU_Coefficients.dta

*GROSS CROP REVENUE					Tanzania_NPS_W2_tempcrop_harvest.dta
									Tanzania_NPS_W2_tempcrop_sales.dta
									Tanzania_NPS_W2_permcrop_harvest.dta
									Tanzania_NPS_W2_permcrop_sales.dta
									Tanzania_NPS_W2_hh_crop_production.dta
									Tanzania_NPS_W2_plot_cropvalue.dta
									Tanzania_NPS_W2_crop_residues.dta
									Tanzania_NPS_W2_hh_crop_prices.dta
									Tanzania_NPS_W2_crop_losses.dta

									
*CROP EXPENSES						Tanzania_NPS_W2_wages_mainseason.dta
									Tanzania_NPS_W2_wages_season.dta
									Tanzania_NPS_W2_fertilizer_costs.dta
									Tanzania_NPS_W2_seed_costs.dta
									Tanzania_NPS_W2_land_rental_costs.dta
									Tanzania_NPS_W2_asset_rental_costs.dta
									Tanzania_NPS_W2_transportation_cropsales.dta
									
*CROP INCOME						Tanzania_NPS_W2_crop_income.dta
									
*LIVESTOCK INCOME					Tanzania_NPS_W2_livestock_expenses.dta
									Tanzania_NPS_W2_livestock_products.dta
									Tanzania_NPS_W2_hh_livestock_products.dta
									Tanzania_NPS_W2_dung.dta
									Tanzania_NPS_W2_livestock_sales.dta
									Tanzania_NPS_W2_TLU.dta
									Tanzania_NPS_W2_livestock_income.dta

*FISH INCOME						Tanzania_NPS_W2_fishing_expenses_1.dta
									Tanzania_NPS_W2_fishing_expenses_2.dta
									Tanzania_NPS_W2_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Tanzania_NPS_W2_self_employment_income.dta
									Tanzania_NPS_W2_agproducts_profits.dta
									Tanzania_NPS_W2_fish_trading_revenue.dta
									Tanzania_NPS_W2_fish_trading_other_costs.dta
									Tanzania_NPS_W2_fish_trading_income.dta
									
*WAGE INCOME						Tanzania_NPS_W2_wage_income.dta
									Tanzania_NPS_W2_agwage_income.dta
									
*OTHER INCOME						Tanzania_NPS_W2_other_income.dta
									Tanzania_NPS_W2_land_rental_income.dta
									
*OFF-FARM HOURS						Tanzania_NPS_W2_off_farm_hours.dta

*FARM SIZE / LAND SIZE				Tanzania_NPS_W2_land_size.dta
									Tanzania_NPS_W2_farmsize_all_agland.dta
									Tanzania_NPS_W2_land_size_all.dta
									Tanzania_NPS_W2_land_size_total.dta
									
*FARM LABOR							Tanzania_NPS_W2_farmlabor_mainseason.dta
									Tanzania_NPS_W2_farmlabor_season.dta
									Tanzania_NPS_W2_family_hired_labor.dta
									
*VACCINE USAGE						Tanzania_NPS_W2_vaccine.dta
									Tanzania_NPS_W2_farmer_vaccine.dta
									
*ANIMAL HEALTH						Tanzania_NPS_W2_livestock_diseases.dta
									
*USE OF INORGANIC FERTILIZER		Tanzania_NPS_W2_fert_use.dta
									Tanzania_NPS_W2_farmer_fert_use.dta
									
*USE OF IMPROVED SEED				Tanzania_NPS_W2_improvedseed_use.dta
									Tanzania_NPS_W2_farmer_improvedseed_use.dta

*REACHED BY AG EXTENSION			Tanzania_NPS_W2_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Tanzania_NPS_W2_fin_serv.dta

*MILK PRODUCTIVITY					Tanzania_NPS_W2_milk_animals.dta
*EGG PRODUCTIVITY					Tanzania_NPS_W2_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Tanzania_NPS_W2_hh_cost_land.dta
									Tanzania_NPS_W2_hh_cost_inputs_lrs.dta
									Tanzania_NPS_W2_hh_cost_inputs_srs.dta
									Tanzania_NPS_W2_hh_cost_seed_lrs.dta
									Tanzania_NPS_W2_hh_cost_seed_srs.dta		
									Tanzania_NPS_W2_cropcosts_total.dta
									
*AGRICULTURAL WAGES					Tanzania_NPS_W2_ag_wage.dta

*RATE OF FERTILIZER APPLICATION		Tanzania_NPS_W2_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Tanzania_NPS_W2_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Tanzania_NPS_W2_control_income.dta
*WOMEN'S AG DECISION-MAKING			Tanzania_NPS_W2_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Tanzania_NPS_W2_ownasset.dta

*CROP YIELDS						Tanzania_NPS_W2_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Tanzania_NPS_W2_shannon_diversity_index.dta
*CONSUMPTION						Tanzania_NPS_W2_consumption.dta
*HOUSEHOLD FOOD PROVISION			Tanzania_NPS_W2_food_insecurity.dta


*FINAL FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Tanzania_NPS_W2_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Tanzania_NPS_W2_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Tanzania_NPS_W2_field_plot_variables.dta
*SUMMARY STATISTICS					Tanzania_NPS_W2_summary_stats.xlsx
*/


clear
clear matrix	
clear mata			
set more off
set maxvar 8000	
ssc install findname  // need this user-written ado file for some commands to work

global directory "../.." //Update this to match the path to your local repo

*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global Tanzania_NPS_W2_raw_data 	    	"$directory/Tanzania NPS/Tanzania NPS Wave 2/Raw DTA Files"
global Tanzania_NPS_W2_created_data  		"$directory/Tanzania NPS/Tanzania NPS Wave 2/Final DTA Files/created_data"
global Tanzania_NPS_W2_final_data  			"$directory/Tanzania NPS/Tanzania NPS Wave 2/Final DTA Files/final_data"
global summary_stats 						"${directory}/_Summary_Statistics/EPAR_UW_335_SUMMARY_STATISTICS.do"
********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS
********************************************************************************
global Tanzania_NPS_W2_exchange_rate 2158			// https://www.bloomberg.com/quote/USDETB:CUR
global Tanzania_NPS_W2_gdp_ppp_dollar 762.96 // 889.45 was the value in 2017 https://data.worldbank.org/indicator/PA.NUS.PPP		// UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Tanzania_NPS_W2_cons_ppp_dollar 681.85 // 777.6 was the value in 2017 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP	// UPDATED 7/9/25: GDP_PPP_DOLLAR for 2021
global Tanzania_NPS_W2_infl_adj (112.69/200.7) // 112.69/175.04 was the inflation rate in 2017. Data was collected during 2010-2011.	Base year should be 2024 and is available as of the most recent update. As of 2025, we want to adjust value to 2021 // I = CPI 2011/CPI 2017 = 112.69/200.7 https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=TZ
global Tanzania_NPS_W2_poverty_190 (1.9 * 588.8 *(112.7/112.7))  //$1.90 was the poverty line in 2011. 588.8 was the PPP in 2011. Since the survey was conducted in 2010-2011, we deflate based on CPI (2011)/CPI (2011) //Previous international extreme poverty line //2011 is base year, so no inflation adjustment 
global Tanzania_NPS_W2_poverty_npl (1200 * (112.7/112.7)) //Similarly, the line is set based on assumption of 1200 TSH/day in 2011/2012. Included for comparison purposes; adjusted for inflation although it is not clear if that happens internally.  https://documents1.worldbank.org/curated/en/679851467999966244/pdf/AUS6819-WP-v1-P148501-PUBLIC-Tanzania-summary-15Apr15-Box391437B.pdf
global Tanzania_NPS_W2_poverty_215 (2.15*777.6*(112.7/175)) //$2.15 was the poverty line in 2017. 777.6 was the PPP in 2017 so we deflate based on CPI (2011)/CPI (2017) since that is the year we're adjusting for. 
global Tanzania_NPS_W2_poverty_300 (3.00* $Tanzania_NPS_W2_infl_adj * $Tanzania_NPS_W2_cons_ppp_dollar )
//$3.00 is the new poverty line in international PPP dollars which has been updated to 2021.

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

//seasoncut for making it easier to make crop-disaggregated variables. 
set obs $nb_topcrops //Update if number of crops changes //Update to reflect new length (should be 14 now)
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

save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropname_table.dta", replace 

*https://databank.worldbank.org/source/world-development-indicators#
global Tanzania_NPS_W2_pop_tot 45110527 //
global Tanzania_NPS_W2_pop_rur 32428153 // 
global Tanzania_NPS_W2_pop_urb 12682374 // 

********************************************************************************
*HOUSEHOLD IDS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_A.dta", clear
gen region_name=region
label define region_name  1 "Dodoma" 2 "Arusha" 3 "Kilimanjaro" 4 "Tanga" 5 "Morogoro" 6 "Pwani" 7 "Dar es Salaam" 8 "Lindi" 9 "Mtwara" 10 "Ruvuma" 11 "Iringa" 12 "Mbeya" 13 "Singida" 14 "Tabora" 15 "Rukwa" 16 "Kigoma" 17 "Shinyanga" 18 "Kagera" 19 "Mwanza" 20 "Mara" 21 "Manyara" 22 "Njombe" 23 "Katavi" 24 "Simiyu" 25 "Geita" 51 "Kaskazini Unguja" 52 "Kusini Unguja" 53 "Minji/Magharibi Unguja" 54 "Kaskazini Pemba" 55 "Kusini Pemba"
label values region_name region_name
gen district_name=.
tostring district_name, replace
ren y2_weight weight
gen hh_split=2 if hh_a11==3 //split-off household
label define hh_split 1 "ORIGINAL HOUSEHOLD" 2 "SPLIT-OFF HOUSEHOLD"
label values hh_split hh_split
lab var hh_split "2=Split-off household" 
gen rural = (y2_rural==1)
keep y2_hhid region district ward region_name district_name ea rural weight strataid clusterid hh_split
ren y2_hhid hhid
lab var rural "1=Household lives in a rural area"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", replace 

********************************************************************************
*INDIVIDUAL IDS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_B.dta", clear
keep y2_hhid indidy2 hh_b02 hh_b04 hh_b05
ren y2_hhid hhid 
ren indidy2 indiv
gen female=hh_b02==2 
lab var female "1= indivdual is female"
gen age=hh_b04
lab var age "Indivdual age"
gen hh_head=hh_b05==1 
lab var hh_head "1= individual is household head"
drop hh_b02 hh_b04 hh_b05
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", replace
 
 
********************************************************************************
*HOUSEHOLD SIZE
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_B.dta", clear
gen hh_members = 1
ren hh_b05 relhead 
ren hh_b02 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (y2_hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
ren y2_hhid hhid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", replace
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen
//renamed for hhid to standardize for y*hhid issue across all waves

*No panel weights
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Tanzania_NPS_W2_pop_tot}/el(temp,1,1) //scaling pweight to given total population rather than pop total calculated from survey weights
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Tanzania_NPS_W2_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_rur]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Tanzania_NPS_W2_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weights.dta", replace 
//save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", replace //replaced with weights.dta


********************************************************************************
*PLOT AREAS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC2A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC2B.dta", gen(season)
ren y2_hhid hhid 
ren plotnum plot_id
gen area_acres_est = ag2a_04
replace area_acres_est = ag2b_15 if area_acres_est==.
gen area_acres_meas = ag2a_09
replace area_acres_meas = ag2b_20 if area_acres_meas==.
keep if area_acres_est !=.
keep hhid plot_id area_acres_est area_acres_meas //y2_hhid renamed to hhid tp standardize across all waves
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", replace


********************************************************************************
*PLOT DECISION MAKERS
********************************************************************************
/*use "${Tanzania_NPS_W2_raw_data}/HH_SEC_B.dta", clear
ren y2_hhid hhid 
ren indiv personid
gen female =hh_b02==2
gen age = hh_b04
gen head = hh_b05==1 if hh_b05!=.
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
keep personid female age hhid head //renaming y2_hhid to hhid to standardize across all waves
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", replace
*/
//Some plots not found in plot roster 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
ren y2_hhid hhid 
gen season=0
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta"
recode season (.=1)
collapse (firstnm) zaocode, by(hhid plotnum season) //renaming y2_hhid to hhid to standardize across all waves
keep if zaocode!=.
tempfile sec4plots
save `sec4plots'

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
gen season=0
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren y2_hhid hhid
recode season (.=1)

drop if plotnum==""
//drop if ag3b_03==. & ag3a_03==.
gen cultivated = ag3b_03==1 | ag3a_03==1
//keep if cultivated==1 //Droppig uncultivated plots results in some orphaned observations.
merge 1:1 hhid plotnum season using `sec4plots', keepusing(hhid plotnum season) //renaming y2_hhid to hhid to standardize across all waves
ren plotnum plot_id 

*Gender/age variables
gen personid1 = ag3a_08_1
replace personid1  = ag3b_08_1 if personid1==.
gen personid2 = ag3a_08_2
replace personid2 = ag3b_08_2 if personid2==. 
gen personid3 = ag3a_08_3
replace personid3 = ag3b_08_3 if personid3==.
keep hhid plot_id cultivated season person* //renaming y2_hhid to hhid to standardize across all waves
*reshape long personid, i(hhid plot_id cultivated season) j(personno) 
*merge m:1 hhid personid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", nogen keep(1 3)		// Dropping unmatched from using and empties from master 
*drop if personid==.
reshape long personid, i(hhid plot_id cultivated season) j(individ)  
ren personid indiv
merge m:1 hhid indiv using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen keep(1 3)		// Dropping unmatched from using and empties from master 
drop if indiv==.
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_dm_ids.dta", replace
gen dm1_gender=female+1 if individ==1
collapse (mean) female (firstnm) dm1_gender, by(hhid plot_id season cultivated)
//gen dm_gender = female + 1
//replace dm_gender = 3 if !inlist(dm_gender, 1, 2,.)
gen dm_gender = 3 if female !=1 & female!=0 & female!=.
replace dm_gender = 1 if female == 0
replace dm_gender = 2 if female == 1
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
*la val dm_gender dm_gender
*la val dm1_gender dm_gender
*lab var dm1_gender "Gender of primary decisionmaker"
*lab var  dm_gender "Gender of all plot manager/decision makers"

*Replacing observations without gender of plot manager with gender of HOH //ALT NOTE: This decision varies a lot by country. 
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weights.dta", nogen keep(3) keepusing (fhh)

//merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", nogen keep(3) //Replaced with weights.dta
//N/A to W2 - no replacements made 							
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
//ALT 09.26.24: I have no idea why these drops here.
drop if hhid=="1902025003005901" & season==0
drop if hhid=="1903007058008017" & season==0
drop if hhid=="5301008072017501" & season==0

lab var cultivated "1=Plot has been cultivated"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", replace


********************************************************************************
*FORMAL LAND RIGHTS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", gen(season)
ren y2_hhid hhid
*formalized land rights
replace ag3a_24 = ag3b_24 if ag3a_24==.		// replacing with values in season for season observations
gen formal_land_rights = ag3a_24==1			// Note: Including anything other than "no documents" as formal
*Individual level (for women)
*NOTE: Assuming ANY listed owners are also listed on the document (if they have a document, that is)
ren ag3a_29_1 indidy1
replace indidy1 = ag3b_29_1 if indidy1==.
ren ag3a_29_2 indidy2
replace indidy2 = ag3b_29_2 if indidy2==.
keep hhid indidy* formal_land_rights //renaming y2_hhid to hhid for standardizing across all waves
gen obs = _n
reshape long indidy, i(hhid formal_land_rights obs) j(indivno)
ren indidy indiv
merge m:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen keep(3)		
gen formal_land_rights_f = formal_land_rights==1 if female==1
collapse (max) formal_land_rights_f, by(hhid indiv)	
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_ind.dta", replace
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_hh.dta", replace
********************************************************************************
*ALL PLOTS - ALT Updated on 9/25/24
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
use "${Tanzania_NPS_W2_raw_data}/AG_SEC5a.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC7a.dta"
gen season=0 
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5b.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC7b.dta"
ren y2_hhid hhid 
recode season(.=1)
ren zaocode crop_code
recode ag7a_03 ag7b_03 ag5a_02 ag5b_02 (.=0)
gen quantity_sold = ag5a_02 
replace quantity_sold=ag5b_02 if quantity_sold==0
replace quantity_sold=ag5a_02+ag7a_03 if quantity_sold==0 
replace quantity_sold = ag5b_02 + ag7b_03 if quantity_sold==0
replace quantity_sold = ag7b_03 if quantity_sold==0
replace quantity_sold = ag7a_03 if quantity_sold==0

recode ag7a_04 ag7b_04 ag5a_03 ag5b_03 (.=0)
gen value_sold=ag5a_03 
replace value_sold=ag7a_04+ag5a_03 if value_sold==0
replace value_sold=ag5a_03 if value_sold==0
replace value_sold=ag5b_03+ag7b_04 if value_sold==0
replace value_sold=ag7a_04 if value_sold==0
replace value_sold=ag7b_04 if value_sold==0

collapse (sum) quantity_sold value_sold, by (hhid crop_code) //Although we expect crop prices to vary by season, the small number of observations results in striking differences between observed prices between seasons for some crops; it's necessary, therefore, to combine seasons.
recode value_sold (0=.)
lab var quantity_sold "Kgs sold of this crop"
lab var value_sold "Value sold of this crop"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weights.dta", nogen keep (1 3) keepusing(region district ward ea weight_pop_rururb) //Replaces hhids with weights.dta


//merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3) keepusing(region district ward ea weight_pop_rururb) //Replaced with weights.dta
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC4a.dta", clear
	append using "${Tanzania_NPS_W2_raw_data}/AG_SEC6a.dta"
	gen season=0 
	append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4b.dta"
	append using "${Tanzania_NPS_W2_raw_data}/AG_SEC6b.dta"
	ren y2_hhid hhid 
recode season (.=1)
ren plotnum plot_id 
ren zaocode crop_code
drop if crop_code==.
ren ag6a_02 number_trees_planted
replace number_trees_planted = ag6b_02 if number_trees_planted==.
sort hhid plot_id crop_code
bys hhid plot_id season : gen cropid = _n //Get number of crops grown on each plot in each season
bys hhid plot_id season : egen num_crops = max(cropid)
gen purestand = 1 if ag4a_04==2 | ag4b_04==2 | ag6a_05==2 | ag6b_05==2 
replace purestand = 1 if num_crops==1 //1240 plots where only one crop was reported but not tagged as purestand above
replace purestand = 0 if num_crops > 1 // 432 obs reported monocropping but had > 1 crop 

//Retaining the old code above for plot decision makers. There is no viable way to assign individual-level decisionmakers for tree crops in Wave 2. The management information was unavailable as harvest control was the only one present. 

gen prop_planted = ag4a_02/4
replace prop_planted = ag4b_02/4 if prop_planted==.
replace prop_planted=1 if ag4a_01==1 | ag4b_01==1
//Remaining issue is tree crops: we don't have area harvested nor area planted, so if a tree crop is reported as a purestand but grown on a plot with other crops, we have to assume that the growers accurately estimate the area of their remaining crops; this can lead to some incredibly large plant populations on implausibly small patches of ground. For now, I assume a tree is purestand if it's the only crop on the plot (and assign it all plot area regardless of tree count) or if there's a plausible amount of room for at least *some* trees to be grown on a subplot.
replace prop_planted = 1 if prop_planted==. & num_crops==1 
bys hhid plot_id season : egen total_prop_planted=sum(prop_planted)
bys hhid plot_id : egen max_prop_planted=max(total_prop_planted) //Used for tree crops
gen intercropped = ag6a_05
replace intercropped = ag6b_05 if intercropped==.
replace purestand=0 if prop_planted==. & (max_prop_planted>=1 | intercropped==1) //No changes

merge m:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
gen est_ha_planted=prop_planted*field_size //Used later.

replace prop_planted = prop_planted/total_prop_planted if total_prop_planted > 1
replace total_prop_planted=1 if total_prop_planted > 1
gen ha_planted = prop_planted*field_size

gen ha_harvest = ag4a_08/2.47105
replace ha_harvest = ag4b_08/2.47105 if ha_harvest==.

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
gen imprv_seed_use= ag4a_23==2 | ag4b_23==2
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
gen kgs_harvest = ag4a_15
replace kgs_harvest = ag6a_08 if kgs_harvest==.
replace kgs_harvest = ag6b_08 if kgs_harvest==.
//Only 3 obs are not finished with harvest
replace kgs_harvest = ag4b_15 if kgs_harvest==.
replace kgs_harvest = kgs_harvest/(1-ag4a_14/100) if ag4b_12==2 & ag4a_14 < 100 //There are several observations ranging from 200-9000
replace kgs_harvest = kgs_harvest/(1-ag4b_14/100) if ag4b_12==2 & ag4b_14 < 100
	//Rescale harvest area 
gen over_harvest = ha_harvest > ha_planted & ha_planted!=.
gen lost_plants = ag4a_17==1 | ag6a_09==1 | ag4b_17==1 | ag6b_09==1
//Assume that the area harvest=area planted if the farmer does not report crop losses
replace ha_harvest = ha_planted if over_harvest==1 & lost_plants==0 
replace ha_harvest = ha_planted if ag4a_09==2 | ag4b_09==2 //"Was area harvested less than area planted? 2=no"
replace ha_harvest = ha_planted if permcrop==1 & over_harvest==1 //Lack of information to deal with permanent crops, so rescaling to ha_planted
replace ha_harvest = 0 if kgs_harvest==. 
//Remaining observations at this point have (a) recorded preharvest losses (b) have still harvested some crop, and (c) have area harvested greater than area planted, likely because estimated area > GPS-measured area. We can conclude that the area_harvested should be less than the area planted; one possible scaling factor could be area_harvested over estimated area planted.
gen ha_harvest_adj = ha_harvest/est_ha_planted * ha_planted if over_harvest==1 & lost_plants==1 
replace ha_harvest = ha_harvest_adj if ha_harvest_adj !=. & ha_harvest_adj<= ha_harvest
replace ha_harvest = ha_planted if ha_harvest_adj !=. & ha_harvest_adj > ha_harvest //14 plots where this clever plan did not work; going with area planted because that's all we got for these guys

/*
ren ag4a_16 value_harvest
replace value_harvest=ag4b_16 if value_harvest==.
gen val_kg = value_harvest/kgs_harvest
//Bringing in the permanent crop price data.
merge m:1 y2_hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", nogen keep(1 3) keepusing(price_kg)
replace price_kg = val_kg if price_kg==.
drop val_kg
ren price_kg val_kg //Use observed sales prices where available, farmer estimated values where not 
gen obs=kgs_harvest>0 & kgs_harvest!=.
merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
gen plotweight=ha_planted*weight
foreach i in region district ward ea y2_hhid {
preserve
	bys crop_code `i' : egen obs_`i' = sum(obs)
	collapse (median) val_kg_`i'=val_kg (sum) obs_`i'_kg=obs  [aw=plotweight], by (`i' crop_code)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore
merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
}
preserve
collapse (median) val_kg_country = val_kg (sum) obs_country_kg=obs [aw=plotweight], by(crop_code)
tempfile val_kg_country_median
save `val_kg_country_median'
restore
merge m:1 crop_code using `val_kg_country_median',nogen keep(1 3)
foreach i in country region district ward ea {
	replace val_kg = val_kg_`i' if obs_`i'_kg >9
}
	replace val_kg = val_kg_y2_hhid if val_kg_y2_hhid!=.
	replace value_harvest=val_kg*kgs_harvest if value_harvest==.
*/
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
//ren y2_hhid hhid

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
	gen value_harvest=val_kg*kgs_harvest 
	gen value_harvest_hh = val_kg_hhid * kgs_harvest
	replace value_harvest = ag4a_16 if value_harvest==.
	replace value_harvest = ag4b_16 if value_harvest==.


preserve
//ren hhid y2_hhid
collapse (mean) price_kg=val_kg [aw=kgs_harvest], by(hhid crop_code) //get household prices for crops 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_prices.dta", replace
restore
	
preserve
//ren hhid y2_hhid
	//gen month_harv = max(month_harv0 month_harv1)
	collapse (sum) value_harvest /*(max) month_harv*/, by(hhid plot_id season)
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_value_prod.dta", replace //Needed to estimate plot rent values
restore
	//collapse (sum) kgs_harvest value_harvest ha_planted ha_harvest number_trees_planted (min) purestand, by(region district ward ea y2_hhid plot_id crop_code field_size season) 
	//	merge m:1 y2_hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	//ren hhid y2_hhid
    gen lost_drought = inlist(ag4a_10, 1) | inlist(ag4b_10, 1)
	gen lost_flood = inlist(ag4a_10, 2) | inlist(ag4b_10, 2) 
	gen lost_crop = lost_flood | lost_drought
	
gen n_crops=1
	gen no_harvest=ha_harvest==. 
	collapse (max) no_harvest  (sum) kgs_harvest imprv_seed_use value_harvest* ha_planted ha_harvest number_trees_planted n_crops (min) purestand, by(region district season ward ea hhid plot_id crop_code field_size total_ha_planted)  
		merge m:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen keep(3) keepusing(dm*) //Drops the 3 hhs  we filtered out earlier
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
		recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		label define crop_code 931 "Beans-Cowpeas", add
		label values crop_code crop_code
		tab crop_code if crop_code==931 // Check if crops combined 
		
		replace ha_harvest=. if (ha_harvest==0 & no_harvest==1) | (ha_harvest==0 & kgs_harvest>0 & kgs_harvest!=.)
   replace kgs_harvest = . if kgs_harvest==0 & no_harvest==1
   drop no_harvest
   gen ha_harv_yld=ha_harvest if ha_planted >=0.05 & !inlist(crop_code, 302,303,304,305,306,19) //Excluding nonfood crops & seaweed 
   gen ha_plan_yld=ha_planted if ha_planted >=0.05 & !inlist(crop_code, 302,303,304,305,306,19) 
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta",replace

//One extremely large and implausible (but not impossible) harvest value for coconuts: 55,000 kg reported from 80 trees (but on 16 hectares, so possibly many more trees) with a reported value of 7,500 TSH/kg (not unreasonable), leading to a large value of harvest of 412 MM Shillings. Left in data because it doesn't defy physics. 

//AT: moving this up here and making it its own file because we use it often below
	collapse (sum) ha_planted, by(hhid season plot_id) //Use planted area for hh-level expenses 
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_planted_area.dta", replace
	
********************************************************************************
* CROP EXPENSES *
********************************************************************************

//ALT: Updated this section to improve efficiency and remove redundancies elsewhere.
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid plot_id season)
tempfile planted_area
save `planted_area' 


	*********************************
	* 			SEED				*
	*********************************

use "${Tanzania_NPS_W2_raw_data}/ag_sec4a.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/ag_sec4b.dta" 
ren y2_hhid hhid 
	ren plotnum plot_id
	drop if zaocode==.
	ren zaocode crop_code 
	recode crop_code(31 32 = 931)
	label define crop_code 931 "Beans-Cowpeas", add
	label values crop_code crop_code
	tab crop_code if inlist(crop_code, 931, 31, 32)
	
//ren ag4a_10c_1 qtyseedexp0 //Not in W2
//ren ag4a_10c_2 unitseedexp0
gen valseedexp0 = ag4a_21
//ren ag4b_10c_1 qtyseedexp1
//ren ag4b_10c_2 unitseedexp1
gen valseedexp1 = ag4b_21
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
	use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
	merge 1:1 y2_hhid plotnum using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta", nogen
	//keep if ag3a_03==1 | ag3b_03==1
ren y2_hhid hhid
ren plotnum plot_id
merge 1:1 hhid plot_id using `seeds', nogen
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3) keepusing(weight)
merge m:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size)


	//No way to disaggregate by gender of worker because instrument only asks for aggregate pay.
	gen wagesexp0=(ag3a_72_3+ag3a_72_6+ag3a_72_64+ag3a_72_9) 
	gen wagesexp1=(ag3b_72_3+ag3b_72_6+ag3b_72_64+ag3b_72_9)

	drop ag3b_70_id* ag3a_70_id* // dropping all variables after ag3b_70_id
	egen hh_labor0= rowtotal(ag3a_72_*) //total days of labor performed by all household members, by season
	egen hh_labor1 = rowtotal(ag3b_72_*)

// Generating labor tempfile with paid wages and total hours worked by household members - DIFFERENT labor units, need to investigate how this is used in subsequent processing steps (HI 11.9.21)
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
	sort hhid plot_id season input //changed y1 to y2_hhid
	tempfile labor
	save `labor'
restore 

ren ag3a_60_1 qtypestexp0 //0-1 designators for long/season growing seasons  // changed ag3a_65b_1 to ag3a_65_1
ren ag3a_60_2 unitpestexp0 // changed ag3a_65b_2 to ag3a_65_2
ren ag3a_61 valpestexp0 // changed ag3a_65c to  ag3a_65 as per the raw data 
ren ag3b_60_1 qtypestexp1  // changed ag3b_65b_1 to ag3b_65_1
ren ag3b_60_2 unitpestexp1 // changed ag3b_65b_2 to ag3b_65_2 
ren ag3b_61 valpestexp1 // changed ag3b_65c to ag3b_61 as per the raw data 

foreach i in pestexp {
	foreach j in 0 1 {
	replace qty`i'`j'=qty`i'`j'/1000 if unit`i'`j'==3 & qty`i'`j'>9 //Assuming instances of very small amounts are typos. 
	replace unit`i'`j'=2 if unit`i'`j'==3
		}
	}

ren ag3a_40 qtyorgfertexp0 // changed from ag3a_42 to ag3a_40
recode qtyorgfertexp0 (.=0)
ren ag3a_45 valorgfertexp0

ren ag3b_40 qtyorgfertexp1
recode qtyorgfertexp1 (.=0)
ren ag3b_45 valorgfertexp1

/* ALT 07.13.21: I initially set this up like the Nigeria code on the assumption that implicit costs were highly relevant to crop production; however, it doesn't seem like this 
is as much of a thing in Tanzania, and there's not enough information to accurately account for them if it turns out that they are. All explicit inputs have price information,
so there's also no need to do geographic medians to fill in holes. I'm leaving the implicit valuation for organic fertilizer and seed in case we come back to this.
gen qtyorgfertimp0 = ag3a_42-qtyorgfertexp0
gen valorgfertimp0 = .
gen qtyorgfertimp1 = ag3b_42-qtyorgfertexp1 
gen valorgfertimp1 = . //We should expect only this value to get filled in by the pricing code.
*/
//Price disaggregation of inorganic fertilizer isn't necessary, because there's no implicit inorganic fertilizer useage
egen qtyinorgfertexp0=rowtotal(ag3a_47 ag3a_54)
egen valinorgfertexp0=rowtotal(ag3a_49 ag3a_56) 
egen qtyinorgfertexp1=rowtotal(ag3b_47 ag3b_54)
egen valinorgfertexp1=rowtotal(ag3b_49 ag3b_56) 

//Fertilizer units
preserve
//We can estimate how many nutrient units were applied for most fertilizers; DAP is 18-46-0, Urea is 46-0-0, CAN is around 24-0-0, ammonium sulfate is 21-0-0 and rock phosphate is 0-32-0 and NPK is 5-0-0. Source: https://www.frontiersin.org/articles/10.3389/fsufs.2019.00029/pdf
gen input=ag3a_46
replace input = ag3b_46 if input==.
label define input 1 "DAP" 2 "urea" 3 "TSP" 4 "CAN" 5 "SA" 6 "npk_fert" 7 "mrp"
label values input "input"
decode input, gen (input_inorg) 
gen qty = ag3b_47
replace qty = ag3a_47 if qty==. 
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
	ren ag3a_32 vallandrentexp0
	ren ag3b_32 vallandrentexp1
	gen monthslandrent0 = ag3a_33_1
	replace monthslandrent0=monthslandrent0*12 if ag3a_33_2==2
	gen monthslandrent1 = ag3b_33_1
	replace monthslandrent1=monthslandrent1*12 if ag3b_33_2==2
	//Changing the in-kind share categories from categorical to fourths
	recode ag3a_34 ag3b_34 (1 2 .=0) (3=1) (4=2) (5=3) (6=4)
	gen propinkindpaid0 = ag3a_34/4
	gen propinkindpaid1 = ag3b_34/4
	
	replace vallandrentexp0 = . if monthslandrent0==0 //One obs with rent paid but no time period of rental
	keep hhid plot_id months* prop* val* field_size
	reshape long monthslandrent vallandrentexp propinkindpaid, i(hhid plot_id) j(season)
	la val season //Remove value labels from the season variable - not sure why they're getting applied
	merge 1:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_value_prod.dta", nogen keep (1 3)
	gen pricelandrent = (vallandrentexp+(propinkindpaid*value_harvest))/monthslandrent/field_size 
	keep hhid plot_id pricelandrent season field_size
	reshape wide pricelandrent, i(hhid plot_id field_size) j(season) //82 total observations; there isn't a significant difference between season and long rainy season rents.
	la var pricelandrent0 "Cost of land rental per hectare per month (long rainy season data)"
	la var pricelandrent1 "Cost of land rental per hectare per month (season rainy season data)"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rents.dta", replace
restore
merge 1:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rents.dta", nogen keep(1 3)
/* Standardizing Rental Prices 
69/172 have years instead of months as their rental units; another 114 appear to have given the rental price per month. I adjust to one year here. 
*/
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
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_input_quantities.dta", replace
	
restore
append using `labor'
collapse (sum) val, by (hhid plot_id input season exp) //Keeping exp in for compatibility with the AQ compilation script.
merge m:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta",  keepusing(dm_gender) nogen keep(3) //Removes uncultivated plots
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_cost_inputs_long.dta",replace

preserve
collapse (sum) val, by(hhid input season exp) //Keeping exp in for compatibility with the AQ compilation script.
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_long.dta", replace
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
merge m:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs.dta", replace
restore

preserve
	replace exp = "exp" if exp == ""
	collapse (sum) val_=val, by(hhid plot_id exp dm_gender season)
	reshape wide val_, i(hhid plot_id dm_gender season) j(exp) string 
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_cost_inputs.dta", replace 
restore


*******************************************************************************
*MONOCROPPED PLOTS - ALT updated 07/21
********************************************************************************
//Generating area harvested and kilograms harvested - for monocropped plots
/* Checking to see if there's an issue where expenses are recorded but crops are not (e.g., for tree crops); no mismatches occur. I'm assuming this is because all relevant expenses are recorded when the crop is surveyed.
It could also be because there is not a lot in the way of crop expenses. 
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs_long.dta", clear
collapse (sum) val, by(y2_hhid plot_id season)
tempfile plot_exp
save `plot_exp'
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", clear
	keep if purestand==1
	merge m:1 y2_hhid plot_id season using `plot_exp', nogen keep(1 3)
*/	

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", clear
	ren ha_planted monocrop_ha
	ren kgs_harvest kgs_harv_mono
	ren value_harvest val_harv_mono
	tab crop_code if crop_code==931
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
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", replace
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
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop_hh_area.dta", replace
	}
restore
}

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_cost_inputs_long.dta", clear
merge m:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen keep(3) keepusing(dm_gender)
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
	capture confirm file "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta"
	if !_rc {
	ren val* val*_`cn'_
	reshape wide val*, i(hhid plot_id season) j(dm_gender2) string
	merge 1:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`cn'_monocrop.dta", nogen keep(3)
	count
	if(r(N) > 0){
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_inputs_`cn'.dta", replace
	}
	}
restore
}


********************************************************************************
*TLU (Tropical Livestock Units)
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren lvstkcode lvstckid
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12|lvstckid==13)
replace tlu_coefficient=0.3 if (lvstckid==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
*Owned
drop if lvstckid==15
gen cattle=inrange(lvstckid,1,6)
gen smallrum=inlist(lvstckid,7,8,9)
gen poultry=inlist(lvstckid,10,11,12,13)
gen largerum = inlist(lvstckid,1,2,3,4,5,6)
gen other_ls=inlist(lvstckid,14,15,16)
gen cows=inrange(lvstckid,2,2)
gen chickens=inrange(lvstckid,10,10)
ren lvstckid livestock_code
ren ag10a_04 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
egen nb_ls_today= rowtotal(ag10a_05_2  ag10a_05_3)
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_largerum_today=nb_ls_today if largerum==1
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1 
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1  
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
ren ag10a_21 income_live_sales 
ren ag10a_20 number_sold 
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (y2_hhid)
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
drop if y2_hhid==""
ren y2_hhid hhid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU_Coefficients.dta", replace


********************************************************************************
*GROSS CROP REVENUE
********************************************************************************
*ALT 07.06.21: The preprocessing - including value imputation - is all in the "all plots" section above; this is mostly legacy compatibility stuff
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", clear
gen value_harvest_imputed = value_harvest
lab var value_harvest_imputed "Imputed value of crop production"

collapse (sum) value_harvest_imputed kgs_harvest, by (hhid crop_code)
merge 1:1 hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_sales.dta", nogen 
tab crop_code if crop_code==931
preserve
	recode  value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
	recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		tab crop_code if crop_code==931 
		
	collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (hhid crop_code)
	ren value_harvest_imputed value_crop_production
	lab var value_crop_production "Gross value of crop production, summed over main and season"
	ren value_sold value_crop_sales
	lab var value_crop_sales "Value of crops sold so far, summed over main and season"
	lab var kgs_harvest "Kgs harvested of this crop, summed over main and season"
	ren quantity_sold kgs_sold
	gen price_kg = value_crop_production/kgs_harvest
	lab var price_kg "Estimated household value of crop per kg, from sales and imputed values" //ALT 07.22.21: Added this var to make the crop processing value calculations work.
	lab var kgs_sold "Kgs sold of this crop, summed over main and season"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta", replace
restore
*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested,  

collapse (sum) value_harvest_imputed value_sold, by (hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* 155 changes here, suggests big gap between farmer estimated valuation and sales price. */
sum value_harvest_imputed value_sold 
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_production.dta", replace

*Crop residues (captured only in Tanzania) 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC5A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B.dta"
ren y2_hhid hhid 
gen residue_sold_yesno = (ag5a_24==7) /* Just 3 observations of sales of crop residue */
ren ag5a_26 value_cropresidue_sales
recode value_cropresidue_sales (.=0)
collapse (sum) value_cropresidue_sales, by (hhid)
lab var value_cropresidue_sales "Value of sales of crop residue (considered an agricultural byproduct)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_residues.dta", replace

*Crops lost post-harvest
use "${Tanzania_NPS_W2_raw_data}/AG_SEC7A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC7B.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5A.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B.dta" 
ren ag7a_09 value_lost
ren y2_hhid hhid 
replace value_lost = ag7b_09 if value_lost==.
replace value_lost = ag5a_23 if value_lost==.
replace value_lost = ag5b_23 if value_lost==.
recode value_lost (.=0)
ren zaocode crop_code
recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		label define crop_code 931 "Beans-Cowpeas", add
		label values crop_code crop_code
		tab crop_code if crop_code==931 
		
collapse (sum) value_lost, by (hhid crop_code)
merge 1:1 hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta", nogen keep(1 3)
replace value_lost = value_crop_production if value_lost > value_crop_production
collapse (sum) value_lost, by (hhid)
ren value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_losses.dta", replace

********************************************************************************
*LIVESTOCK INCOME
********************************************************************************
*Expenses
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren y2_hhid hhid 
ren ag10a_36 cost_fodder_livestock
ren ag10a_34 cost_hired_labor_livestock 
recode cost_fodder_livestock cost_hired_labor_livestock (.=0)
gen cost_lrum = cost_fodder_livestock + cost_hired_labor_livestock if lvstkcode < 7 
collapse (sum) cost_fodder_livestock cost_hired_labor_livestock cost_lrum, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"

save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses", replace

*Livestock products
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
ren y2_hhid hhid 
ren itemcode livestock_code
ren ag10b_02 months_produced
ren ag10b_03_1 quantity_month
ren ag10b_03_2 quantity_month_unit
replace quantity_month_unit = 1 if livestock_code==1 | livestock_code==2
replace quantity_month_unit = 3 if livestock_code==3 | livestock_code==4
replace quantity_month_unit = 1 if livestock_code==5 
replace quantity_month_unit = 1 if livestock_code==6 
replace quantity_month_unit = 1 if livestock_code==7
replace quantity_month_unit = 3 if livestock_code==8
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month /* Units are pieces for eggs & skin, liters for honey, liters for milk */
lab var quantity_produced "Quantity of this product produed in past year"
ren ag10b_05_1 sales_quantity
ren ag10b_05_2 sales_unit
replace sales_unit = 1 if livestock_code==1 | livestock_code==2
replace sales_unit = 3 if livestock_code==3 | livestock_code==4
replace sales_unit = 1 if livestock_code==5
replace sales_unit = 1 if livestock_code==6 
replace sales_unit = 1 if livestock_code==7
replace sales_unit = 3 if livestock_code==8
replace sales_unit = 3 if livestock_code==10 | livestock_code==11 | livestock_code==12 
ren ag10b_06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
recode price_per_unit price_per_unit_hh (0=.) 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_other", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_other", clear
*ren y2_hhid hhid
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
*ren hhid y2_hhid
drop if _merge==2
drop _merge 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ea.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_unit price_median_ward
lab var price_median_ward "Median price per unit for this livestock product in the ward"
lab var obs_ward "Number of sales observations for this livestock product in the ward"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ward.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_district.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_region.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_country.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products", clear
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ward if price_per_unit==. & obs_ward >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen price_cowmilk_med = price_median_country if livestock_code==1 | livestock_code==2
egen price_cowmilk = max(price_cowmilk_med)
lab var price_per_unit "Price per liter (milk) or per egg/liter/container honey, imputed with local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_per_unit if livestock_code==1 | livestock_code==2
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==3 | livestock_code==4
gen value_other_produced = quantity_produced * price_per_unit if livestock_code!= 1 & livestock_code!=2 & livestock_code!=3 & livestock_code!=4
gen sales_livestock_products = earnings_sales	
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of butter, cheese, honey and skins produced"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_products", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
ren y2_hhid hhid 
gen sales_dung=ag10b_06 if itemcode==9 
recode sales_dung (.=0)
collapse (sum) sales_dung, by (hhid)
lab var sales_dung "Value of dung sold" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_dung.dta", replace

*Sales (live animals)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren y2_hhid hhid 
ren lvstkcode livestock_code
ren ag10a_21 income_live_sales 
ren ag10a_20 number_sold 
ren ag10a_25 number_slaughtered 
ren ag10a_26 number_slaughtered_sold 
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold 
ren ag10a_27 income_slaughtered
ren ag10a_09 value_livestock_purchases
recode income_live_sales number_sold number_slaughtered number_slaughtered_sold income_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district ward ea livestock_code number_sold income_live_sales number_slaughtered number_slaughtered_sold income_slaughtered price_per_animal value_livestock_purchases
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", replace

*Implicit prices
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ea.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ward livestock_code: egen obs_ward = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ward livestock_code obs_ward)
ren price_per_animal price_median_ward
lab var price_median_ward "Median price per unit for this livestock in the ward"
lab var obs_ward "Number of sales observations for this livestock in the ward"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ward.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
ren price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_district.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_region.dta", replace
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_country.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_sales", clear
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_country.dta", nogen
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
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered, by (hhid)
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_sales", replace

*TLU (Tropical Livestock Units)
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
ren y2_hhid hhid 
ren lvstkcode lvstckid
gen tlu_coefficient=0.5 if (lvstckid==1|lvstckid==2|lvstckid==3|lvstckid==4|lvstckid==5|lvstckid==6)
replace tlu_coefficient=0.1 if (lvstckid==7|lvstckid==8)
replace tlu_coefficient=0.2 if (lvstckid==9)
replace tlu_coefficient=0.01 if (lvstckid==10|lvstckid==11|lvstckid==12|lvstckid==13)
replace tlu_coefficient=0.3 if (lvstckid==14)
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
ren lvstckid livestock_code
ren ag10a_04 number_1yearago
ren ag10a_05_1 number_today_indigenous
recode ag10a_05_2 ag10a_05_3 (.=0)
gen number_today_exotic=ag10a_05_2 + ag10a_05_3
gen number_today = number_today_indigenous + number_today_exotic
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
ren ag10a_21 income_live_sales 
ren ag10a_20 number_sold 
ren ag10a_14 lost_disease
*adding livestock mortality rate and percent of improved licestock breeds
*Going to construct twelve month average livestock ownership as average of number today and number one year ago
egen mean_12months = rowmean(number_today number_1yearago)
gen animals_lost12months = lost_disease // animals lost to disease, NOT including theft or injury
*Generating mortality rate as animals lost divided by mean
gen share_imp_herd_cows = number_today_exotic/(number_today) if livestock_code==2 
gen species=(inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(livestock_code==13) + 5*(inlist(livestock_code,10,11))
recode species (0=.)
la def species 1 "Large ruminants (cows)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses)" 5 "Poultry"
la val species species
preserve
*household level
*first, generating these values by species
collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lost_disease lvstck_holding=number_today, by(hhid species)
egen mean_12months = rowmean(number_today number_1yearago)
gen any_imp_herd=number_today_exotic!=0 if number_today!=. & number_today!=0

* A loop to create species variables
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease{
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
foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease{
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.) 
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep(1 3)
merge m:1 region district ward ea livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ea.dta", nogen
merge m:1 region district ward livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_ward.dta", nogen
merge m:1 region district livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ward if price_per_animal==. & obs_ward >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var value_1yearago "Value of livestock holdings from one year ago"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU.dta", replace

*Livestock income
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_sales", clear
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_products", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_dung.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU_Coefficients.dta", nogen
gen livestock_income = value_livestock_sales - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock)
lab var livestock_income "Net livestock income"
*save "$created_data/Tanzania_NPS_W2_livestock_income.dta", replace

********************************************************************************
*FISH INCOME
********************************************************************************
*Fishing expenses
use "${Tanzania_NPS_W2_raw_data}/FS_C1.dta", clear
ren y2_hhid hhid 
ren fs_c01a weeks_fishing_fulltime_hs 
ren fs_c01b days_per_week_fulltime_hs
ren fs_c02a weeks_fishing_part_hs
ren fs_c02c days_per_week_part_hs
recode weeks_fishing_fulltime_hs days_per_week_fulltime_hs weeks_fishing_part_hs days_per_week_part_hs (.=0)
gen weeks_fishing_hs = weeks_fishing_part_hs + weeks_fishing_fulltime_hs 
gen days_fishing_hs = (weeks_fishing_fulltime_hs * days_per_week_fulltime_hs) + (weeks_fishing_part_hs * days_per_week_part_hs)
collapse days_fishing_hs (max) weeks_fishing_hs, by (hhid) 
keep hhid weeks_fishing_hs days_fishing_hs
lab var weeks_fishing_hs "Weeks spent working fulltime and parttime as a fisherman in the last high season (maximum observed across individuals in household)"
lab var days_fishing_hs "Days spent working fulltime and parttime as a fisherman in the last high season (maximum observed across individuals in household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing_highseason.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_I.dta", clear
ren fs_i01a weeks_fishing_fulltime_ls 
ren fs_i01b days_per_week_fulltime_ls
ren fs_i02a weeks_fishing_part_ls
ren fs_i02c days_per_week_part_ls
ren y2_hhid hhid 
recode weeks_fishing_fulltime_ls days_per_week_fulltime_ls weeks_fishing_part_ls days_per_week_part_ls (.=0)
gen weeks_fishing_ls = weeks_fishing_part_ls + weeks_fishing_fulltime_ls 
gen days_fishing_ls = (weeks_fishing_fulltime_ls * days_per_week_fulltime_ls) + (weeks_fishing_part_ls * days_per_week_part_ls)
collapse days_fishing_ls (max) weeks_fishing_ls, by (hhid) 
keep hhid weeks_fishing_ls days_fishing_ls
lab var weeks_fishing_ls "Weeks spent working fulltime and parttime as a fisherman in the last low season (maximum observed across individuals in household)"
lab var days_fishing_ls "Days spent working fulltime and parrtime as a fisherman in the last low season (maximum observed across individuals in household)"
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing_highseason.dta"
drop _merge
gen weeks_fishing = weeks_fishing_hs + weeks_fishing_ls
gen days_fishing = days_fishing_hs + days_fishing_ls
lab var weeks_fishing "Weeks spent working as a fisherman in the last year (maximum observed across individuals in household)"
lab var days_fishing "Days spent working as a fisherman in the last year (maximum observed across individuals in household)" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta", replace

*Hired labor
use "${Tanzania_NPS_W2_raw_data}/FS_D2.dta", clear
ren fs_d06a adults_fishing
ren fs_d06b weeks_per_adult 
ren fs_d06c children_fishing
ren fs_d06d weeks_per_child
merge 1:1 y2_hhid using "${Tanzania_NPS_W2_raw_data}/FS_D3.dta"
ren fs_d08a fixed_wage_adult
ren fs_d08b fixed_wage_child
ren fs_d12a boatrev_wage_adult
ren fs_d12b boatrev_wage_child
ren fs_d13a inkind_wage_adult
ren fs_d13b inkind_wage_child
ren y2_hhid hhid 
recode fixed_wage_adult fixed_wage_child boatrev_wage_adult boatrev_wage_child inkind_wage_adult inkind_wage_child (.=0)
gen cost_labor_adult = (fixed_wage_adult + boatrev_wage_adult + inkind_wage_adult) * weeks_per_adult * adults_fishing
gen cost_labor_child = (fixed_wage_child + boatrev_wage_child + inkind_wage_child) * weeks_per_child * children_fishing 
gen cost_total_labor_highseason = cost_labor_child + cost_labor_adult
collapse (sum) cost_total_labor_highseason, by (hhid)
lab var cost_total_labor "Cost for hired labor in the last high season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_labor_highseason.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_E1.dta", clear
merge 1:1 y2_hhid gearid using "${Tanzania_NPS_W2_raw_data}/FS_K1.dta"
drop _merge
ren fs_e06 rental_costs_fishing_hs
ren fs_k06 rental_costs_fishing_ls
recode rental_costs_fishing_hs rental_costs_fishing_ls (.=0)
gen rental_cost_fishing= rental_costs_fishing_hs + rental_costs_fishing_ls
ren y2_hhid hhid 
collapse (sum) rental_cost_fishing, by (hhid)
lab var rental_cost_fishing "cost for other rental fishing expenses over the past year"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1-1.dta", replace 

use "${Tanzania_NPS_W2_raw_data}/FS_E2.dta", clear
merge 1:1 boatengine_id y2_hhid using "${Tanzania_NPS_W2_raw_data}/FS_K2.dta"
drop _merge
ren fs_e12a rental_costs_boat_hs
ren fs_e12b rental_costs_boat_unit_hs 
ren fs_k12a rental_costs_boat_ls
ren fs_k12b rental_costs_boat_unit_ls
ren fs_e14a boat_maintenance_hs
ren fs_e14b boat_maintenance_unit_hs
ren fs_k14a boat_maintenance_ls 
ren fs_k14b boat_maintenance_unit_ls
ren fs_e13a fuel_cost_hs
ren fs_e13b fuel_cost_unit_hs
ren fs_k13a fuel_cost_ls
ren fs_k13b fuel_cost_unit_ls
ren y2_hhid hhid 
recode rental_costs_boat_hs rental_costs_boat_ls boat_maintenance_hs boat_maintenance_ls fuel_cost_hs fuel_cost_ls (.=0)
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta"
replace rental_costs_boat_hs = rental_costs_boat_hs * weeks_fishing_hs if rental_costs_boat_unit_hs == 2
replace rental_costs_boat_hs = rental_costs_boat_hs * days_fishing_hs if rental_costs_boat_unit_hs == 1
replace rental_costs_boat_ls = rental_costs_boat_ls * weeks_fishing_ls if rental_costs_boat_unit_ls == 2
replace rental_costs_boat_ls = rental_costs_boat_ls * days_fishing_ls if rental_costs_boat_unit_ls == 1
gen rental_costs_boat = rental_costs_boat_hs + rental_costs_boat_ls
replace boat_maintenance_hs = boat_maintenance_hs * weeks_fishing_hs if boat_maintenance_unit_hs == 2
replace boat_maintenance_hs = boat_maintenance_hs * days_fishing_hs if boat_maintenance_unit_hs == 1
replace boat_maintenance_ls = boat_maintenance_ls * weeks_fishing_ls if boat_maintenance_unit_ls == 2
replace boat_maintenance_ls = boat_maintenance_ls * days_fishing_ls if boat_maintenance_unit_ls == 1
gen boat_maintenance = boat_maintenance_hs + boat_maintenance_ls 
replace fuel_cost_hs = fuel_cost_hs * weeks_fishing_hs if fuel_cost_unit_hs == 2
replace fuel_cost_hs = fuel_cost_hs * days_fishing_hs if fuel_cost_unit_hs == 1
replace fuel_cost_ls = fuel_cost_ls * weeks_fishing_ls if fuel_cost_unit_ls== 2
replace fuel_cost_ls = fuel_cost_ls * days_fishing_ls if fuel_cost_unit_ls==1 
gen cost_fuel = fuel_cost_hs + fuel_cost_ls + boat_maintenance
collapse (sum) rental_costs_boat cost_fuel, by (hhid) 
la var rental_costs_boat "Costs for boat rental over the past year"
la var cost_fuel "Costs for fuel, oil, and maintenance over the past year" 
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1-1.dta"
drop _merge
gen rental_costs_fishing = rental_cost_fishing + rental_costs_boat
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
keep hhid cost_fuel rental_costs_fishing
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_E3.dta", clear
ren y2_hhid hhid 
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta"
gen cost = fs_e16a if inputid!= "A" & inputid!= "B" & inputid!= "C" & inputid!= "D" /* Exclude taxes, per RuLIS guidelines */
ren fs_e16b unit
gen cost_paid_hs = cost if unit==4 | unit==3
replace cost_paid = cost * weeks_fishing if unit==2
replace cost_paid = cost * days_fishing if unit==1
collapse (sum) cost_paid_hs, by (hhid)
lab var cost_paid_hs "Other costs paid for fishing activities in the last high season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2-1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_K3.dta", clear
ren y2_hhid hhid
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fishing.dta"
gen cost = fs_k16a if inputid!= "A" & inputid!= "B" & inputid!= "C" & inputid!= "D" /* Exclude taxes, per RuLIS guidelines */
ren fs_k16b unit
gen cost_paid_ls = cost if unit==4 | unit==3
replace cost_paid = cost * weeks_fishing if unit==2
replace cost_paid = cost * days_fishing if unit==1
collapse (sum) cost_paid_ls, by (hhid)
lab var cost_paid_ls "Other costs paid for fishing activities in the last low season"
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2-1.dta"
gen cost_paid = cost_paid_ls + cost_paid_hs
keep hhid cost_paid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_F.dta", clear
recode fs_f11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
ren fs_f02b fish_code 
ren fs_f11a fish_quantity
ren fs_f11b unit 
gen price_per_unit=fs_f11d/fish_quantity
append using "${Tanzania_NPS_W2_raw_data}/FS_L.dta"
recode fs_l11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
replace fish_code = fs_l02b if fish_code==.
drop if fish_code==. /* "Other" = 33 */
replace fish_quantity = fs_l11a if fish_quantity==.
replace unit = fs_l11b if unit==.
replace price_per_unit= fs_l11d/fs_l11a if price_per_unit==.
recode price_per_unit (0=.) 
ren y2_hhid hhid
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta"
drop if _merge==2
drop _merge
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
ren price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==33
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_prices.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_F.dta", clear
recode fs_f11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
ren fs_f02b fish_code 
drop if fish_code==. 
ren fs_f04a fish_quantity_hs
replace fish_quantity_hs = . if fish_quantity_hs==999
ren fs_f04b unit
ren fs_f11a quantity_1
ren fs_f11b unit_1
gen price_unit_1 = fs_f11d/quantity_1
ren fs_f11e quantity_2
ren fs_f11f unit_2
gen price_unit_2 = fs_f11h/quantity_2
recode quantity_1 quantity_2 fish_quantity price_unit_1 price_unit_2 (.=0)
ren y2_hhid hhid 
drop if hhid=="1903007058008003" // typo
drop if hhid == "2003024004005901" & unit==9 // dropped because we don't have price and the unit is "other" so we cannot convert 
replace unit = 3 if hhid == "5301019011000901" & fishid == 5 //unit harvested in 25 kg bag. Sold unit in kg
replace fish_quantity = fish_quantity*25 if hhid == "5301019011000901" & fishid == 5 
replace unit = 3 if hhid == "0606007003026001" & fishid == 2 // unit harvested in 10 kg bag. Sold unit in kg
replace fish_quantity = fish_quantity*10 if hhid == "0606007003026001" & fishid == 2
replace unit = 1 if hhid == "1603011001019401" & fishid == 1 //unit harvested reported in dozen/bundle. There are median prices for this species in pieces
replace fish_quantity = fish_quantity*12 if hhid == "1603011001019401" & fishid == 1
replace unit = 3 if hhid == "1502019003084901" & fishid == 1 // unit harvested in 5kg bag. There are median prices for this species in kg. 
replace fish_quantity = fish_quantity*5 if hhid == "1502019003084901" & fishid == 1
merge m:1 fish_code unit using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_prices.dta"
drop if _merge==2
drop _merge
gen income_fish_sales_hs = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest_hs = (fish_quantity * price_unit_1) if unit==unit_1 /* Use household's price, if it's observed*/
replace value_fish_harvest_hs = (fish_quantity * price_per_unit_median) if value_fish_harvest_hs==.
collapse fish_quantity (sum) value_fish_harvest_hs income_fish_sales_hs, by (hhid)
recode value_fish_harvest_hs income_fish_sales_hs (.=0)
replace income_fish_sales_hs=value_fish_harvest_hs if value_fish_harvest_hs < income_fish_sales_hs
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income_1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_L.dta", clear
recode fs_l11d (9999999=.) (9999900=.) ( 9800000=.) (9600000 =.) (9400000=.) (9000000=.)
ren fs_l02b fish_code 
drop if fish_code==. 
ren fs_l04a fish_quantity_ls
replace fish_quantity_ls = . if fish_quantity_ls==999
ren fs_l04b unit
ren fs_l11a quantity_1
ren fs_l11b unit_1
gen price_unit_1 = fs_l11d/quantity_1
ren fs_l11e quantity_2
ren fs_l11f unit_2
gen price_unit_2 = fs_l11h/quantity_2
recode quantity_1 quantity_2 fish_quantity price_unit_1 price_unit_2 (.=0) 
merge m:1 fish_code unit using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_prices.dta"
ren y2_hhid hhid 
drop if _merge==2
drop _merge
gen income_fish_sales_ls = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest_ls = (fish_quantity * price_unit_1) if unit==unit_1
replace value_fish_harvest_ls = (fish_quantity * price_per_unit_median) if value_fish_harvest_ls==.
collapse fish_quantity (sum) value_fish_harvest_ls income_fish_sales_ls, by (hhid)
recode value_fish_harvest_ls income_fish_sales_ls (.=0)
merge 1:1 hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income_1.dta"
recode value_fish_harvest_hs income_fish_sales_hs value_fish_harvest_ls income_fish_sales_ls (.=0)
gen value_fish_harvest = value_fish_harvest_hs + value_fish_harvest_ls
gen income_fish_sales = income_fish_sales_hs + income_fish_sales_ls
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
keep hhid value_fish_harvest income_fish_sales
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income.dta", replace



*Fish income
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_income.dta", clear
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_1.dta"
drop _merge
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fishing_expenses_2.dta"
drop _merge
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid


********************************************************************************
*SELF-EMPLOYMENT INCOME
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_E2.dta"
ren hh_e70 months_activ
ren hh_e71 monthly_profit
ren y2_hhid hhid 
recode months_activ monthly_profit (.=0)
gen annual_selfemp_profit = months_activ*monthly_profit 
recode annual_selfemp_profit (.=0)
duplicates drop hhid months_activ annual_selfemp_profit if annual_selfemp_profit!=0, force 
gen alrea_report_annualprofit=monthly_profit==months_activ*hh_e65_2 & hh_e65_1==2
tab alrea_report_annualprofit if  monthly_profit!=0 & monthly_profit!=.
gen alrea_report_annualprofit2=monthly_profit==months_activ*4*hh_e65_2 if  hh_e65_1==1
tab alrea_report_annualprofit2
replace annual_selfemp_profit=months_activ*hh_e65_2 if alrea_report_annualprofit==1 &  hh_e65_1==2
replace annual_selfemp_profit=months_activ*hh_e65_2 if alrea_report_annualprofit2==1 &  hh_e65_1==1
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_self_employment_income.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC09.dta", clear
ren zaocode crop_code
ren ag09_05 byproduct_sold_yesno
ren ag09_06_1 byproduct_quantity
ren ag09_06_2 byproduct_unit
ren ag09_07 kgs_used_in_byproduct 
ren ag09_08 byproduct_price_received
ren ag09_10 other_expenses_yesno
ren ag09_11 byproduct_other_costs
ren y2_hhid hhid 
merge m:1 hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_prices.dta"
drop _merge
recode byproduct_quantity kgs_used_in_byproduct byproduct_other_costs (.=0)
gen byproduct_sales = byproduct_quantity * byproduct_price_received
gen byproduct_crop_cost = kgs_used_in_byproduct * price_kg
gen byproduct_profits = byproduct_sales - (byproduct_crop_cost + byproduct_other_costs)
collapse (sum) byproduct_profits, by (hhid)
lab var byproduct_profits "Net profit from sales of agricultural processed products or byproducts"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agproducts_profits.dta", replace

*Fish trading
use "${Tanzania_NPS_W2_raw_data}/FS_C1.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/FS_I.dta"
ren y2_hhid hhid 
ren fs_c04a weeks_fish_trading_hs
ren fs_i04a weeks_fish_trading_ls
recode weeks_fish_trading_* (.=0)
gen weeks_fish_trading = weeks_fish_trading_hs + weeks_fish_trading_ls
collapse (max) weeks_fish_trading, by (hhid) 
replace weeks_fish_trading = 52 if weeks_fish_trading > 52
keep hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader(maximum observed across individuals in household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fish_trading.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_H1.dta", clear
ren fs_h03a quant_fish_purchased_1
ren fs_h03d price_fish_purchased_1
ren fs_h03e quant_fish_purchased_2
ren fs_h03h price_fish_purchased_2
ren fs_h04a quant_fish_sold_1
ren fs_h04d price_fish_sold_1
ren fs_h04e quant_fish_sold_2
ren fs_h04h price_fish_sold_2
ren y2_hhid hhid 
drop if price_fish_sold_1==6880000 // much higher than other prices
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 (.=0)
gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2)
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit_hs = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit_hs, by (hhid)
keep hhid weekly_fishtrade_profit_hs
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue-1.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_N1.dta", clear
ren fs_n03a quant_fish_purchased_1
ren fs_n03d price_fish_purchased_1
ren fs_n03e quant_fish_purchased_2
ren fs_n03h price_fish_purchased_2
ren fs_n04a quant_fish_sold_1
ren fs_n04d price_fish_sold_1
ren fs_n04e quant_fish_sold_2
ren fs_n04h price_fish_sold_2
ren y2_hhid hhid
drop if price_fish_sold_1==99999 
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 (.=0)
gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2)
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit_ls = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit_ls, by (hhid)
keep hhid weekly_fishtrade_profit_ls
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue-1.dta"
drop _merge
gen weekly_fishtrade_profit = weekly_fishtrade_profit_hs + weekly_fishtrade_profit_ls
keep hhid weekly_fishtrade_profit
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue.dta", replace

use "${Tanzania_NPS_W2_raw_data}/FS_H2.dta", clear
ren y2_hhid hhid 
ren fs_h06 weekly_costs_for_fish_trading_hs
recode weekly_costs_for_fish_trading_hs (.=0)
collapse (sum) weekly_costs_for_fish_trading_hs, by (hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs-1.dta", replace
use "${Tanzania_NPS_W2_raw_data}/FS_N2.dta", clear
ren y2_hhid hhid 
ren fs_n06 weekly_costs_for_fish_trading_ls
recode weekly_costs_for_fish_trading_ls (.=0)
collapse (sum) weekly_costs_for_fish_trading_ls, by (hhid)
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs-1.dta"
drop _merge
gen weekly_costs_for_fish_trading = weekly_costs_for_fish_trading_hs + weekly_costs_for_fish_trading_ls
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep hhid weekly_costs_for_fish_trading
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weeks_fish_trading.dta", clear
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_revenue.dta" 
drop _merge
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep hhid fish_trading_income
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fish_trading_income.dta", replace

********************************************************************************
*WAGE INCOME
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
ren hh_e04 wage_yesno
ren hh_e26 number_months
ren hh_e27 number_weeks
ren hh_e28 number_hours
ren hh_e22_1 most_recent_payment
ren y2_hhid hhid 
replace most_recent_payment = . if (hh_e16_2 == 921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621) 
ren hh_e22_2 payment_period
ren hh_e24_1 most_recent_payment_other
replace most_recent_payment_other = . if (hh_e16_2 == 921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621) 
ren hh_e24_2 payment_period_other
ren hh_e29 secondary_wage_yesno
ren hh_e37_1 secwage_most_recent_payment
replace secwage_most_recent_payment = . if (hh_e31_2 == 921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621) 
ren hh_e37_2 secwage_payment_period
ren hh_e39_1 secwage_recent_payment_other
ren hh_e39_2 secwage_payment_period_other
ren hh_e40 secwage_hours_pastweek
gen annual_salary_cash = most_recent_payment if payment_period==8
replace annual_salary_cash = ((number_months/6)*most_recent_payment) if payment_period==7
replace annual_salary_cash = ((number_months/4)*most_recent_payment) if payment_period==6
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5
replace annual_salary_cash = (number_months*(number_weeks/2)*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==2
replace annual_salary_cash = (number_months*number_weeks*number_hours*most_recent_payment) if payment_period==1
gen wage_salary_other = most_recent_payment_other if payment_period_other==8
replace wage_salary_other = ((number_months/6)*most_recent_payment_other) if payment_period_other==7
replace wage_salary_other = ((number_months/4)*most_recent_payment_other) if payment_period_other==6
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5
replace wage_salary_other = (number_months*(number_weeks/2)*most_recent_payment_other) if payment_period_other==4
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==3
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==2
replace wage_salary_other = (number_months*number_weeks*number_hours*most_recent_payment_other) if payment_period_other==1
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wage_income.dta", replace

*TASCO codes: 921 is an agricultural laborer.
*Gives slightly different response than hh_e21_2: What kind of trade or business is it connected with?

*Agwage
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
ren hh_e04 wage_yesno
ren hh_e26 number_months
ren hh_e27 number_weeks
ren hh_e28 number_hours
ren hh_e22_1 most_recent_payment
ren y2_hhid hhid
gen agwage = 1 if (hh_e16_2==921 | hh_e16_2==611 | hh_e16_2==612 | hh_e16_2==613 | hh_e16_2==614 | hh_e16_2==621)
replace agwage = 0 if hh_e16_2 != 921 & hh_e16_2 != 611 & hh_e16_2 != 612 & hh_e16_2 != 613 & hh_e16_2 != 614 & hh_e16_2 != 621
gen secagwage = 1 if (hh_e31_2==921 | hh_e31_2==611 | hh_e31_2==612 | hh_e31_2==613 | hh_e31_2==614 | hh_e31_2==621)
replace secagwage = 0 if hh_e16_2 != 921 & hh_e16_2 != 611 & hh_e16_2 != 612 & hh_e16_2 != 613 & hh_e16_2 != 614 & hh_e16_2 != 621
replace most_recent_payment = . if agwage!=1
ren hh_e22_2 payment_period
ren hh_e24_1 most_recent_payment_other
replace most_recent_payment_other = . if agwage!=1
ren hh_e24_2 payment_period_other
ren hh_e29 secondary_wage_yesno
ren hh_e37_1 secwage_most_recent_payment
replace secwage_most_recent_payment = . if secagwage!=1
ren hh_e37_2 secwage_payment_period
ren hh_e39_1 secwage_recent_payment_other
ren hh_e39_2 secwage_payment_period_other
ren hh_e40 secwage_hours_pastweek
gen annual_salary_cash = most_recent_payment if payment_period==8
replace annual_salary_cash = ((number_months/6)*most_recent_payment) if payment_period==7
replace annual_salary_cash = ((number_months/4)*most_recent_payment) if payment_period==6
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5
replace annual_salary_cash = (number_months*(number_weeks/2)*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==2
replace annual_salary_cash = (number_months*number_weeks*number_hours*most_recent_payment) if payment_period==1
gen wage_salary_other = most_recent_payment_other if payment_period_other==8
replace wage_salary_other = ((number_months/6)*most_recent_payment_other) if payment_period_other==7
replace wage_salary_other = ((number_months/4)*most_recent_payment_other) if payment_period_other==6
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5
replace wage_salary_other = (number_months*(number_weeks/2)*most_recent_payment_other) if payment_period_other==4
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==3
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==2
replace wage_salary_other = (number_months*number_weeks*number_hours*most_recent_payment_other) if payment_period_other==1
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (hhid)
ren annual_salary annual_salary_agwage
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agwage_income.dta", replace

********************************************************************************
*OTHER INCOME
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_Q.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_O1.dta"
ren hh_q15 rental_income
ren hh_q16 pension_income
ren hh_q17 other_income
ren hh_q10 cash_received
ren hh_q13 inkind_gifts_received
ren hh_o03 assistance_cash
ren hh_o04 assistance_food
ren hh_o05 assistance_inkind
ren y2_hhid hhid 
recode rental_income pension_income other_income cash_received inkind_gifts_received assistance_cash assistance_food assistance_inkind (.=0)
gen remittance_income = cash_received + inkind_gifts_received
gen assistance_income = assistance_cash + assistance_food + assistance_inkind 
collapse (sum) rental_income pension_income other_income remittance_income assistance_income, by (hhid)
lab var rental_income "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var pension_income "Estimated income from a pension AND INTEREST over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, etc. over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_other_income.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
ren ag3a_04 land_rental_income_mainseason
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren ag3b_04 land_rental_income_season
ren y2_hhid hhid
recode land_rental_income_mainseason land_rental_income_season (.=0)
gen land_rental_income = land_rental_income_mainseason + land_rental_income_season
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_income.dta", replace

*Other income
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_other_income.dta", clear
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_income.dta"
egen other_income_sources = rowtotal (rental_income pension_income other_income remittance_income assistance_income land_rental_income)

********************************************************************************
*FARM SIZE / LAND SIZE
********************************************************************************
*Determining whether crops were grown on a plot
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta"
ren plotnum plot_id
ren y2_hhid hhid 
drop if plot_id==""
drop if zaocode==.
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid plot_id)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crops_grown.dta", replace
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
gen cultivated = (ag3a_03==1 | ag3b_03==1)
ren y2_hhid hhid

preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta", clear
gen cultivated=1 if (ag6a_08!=. & ag6a_08!=0) | (ag6a_04!=. & ag6a_04!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
ren y2_hhid hhid 
collapse (max) cultivated, by (hhid plotnum)
drop if plotnum==""
tempfile fruit_tree
save `fruit_tree', replace
restore
append using `fruit_tree'

preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6b.dta", clear
gen cultivated=1 if (ag6b_09!=. & ag6b_09!=0) | (ag6b_04!=. & ag6b_04!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
ren y2_hhid hhid 
collapse (max) cultivated, by (hhid plotnum)
drop if plotnum==""
tempfile perm_crop
save `perm_crop', replace
restore
append using `perm_crop'

ren plotnum plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_cultivated.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_cultivated.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size.dta", replace

*All agricultural land
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren plotnum plot_id
ren y2_hhid hhid 
drop if plot_id==""
merge m:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crops_grown.dta", nogen
gen rented_out = (ag3a_03==2 | ag3a_03==3 | ag3b_03==2 | ag3b_03==3)
gen cultivated_season = (ag3b_03==1)
bys hhid plot_id: egen plot_cult_season = max(cultivated_season)
replace rented_out = 0 if plot_cult_season==1 // If cultivated in season, not considered rented out in long season.
drop if rented_out==1 & crop_grown!=1
*110 obs dropped
gen agland = (ag3a_03==1 | ag3a_03==4 | ag3b_03==1 | ag3b_03==4)

preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6A.dta", clear
ren y2_hhid hhid 
gen cultivated=1 if (ag6a_09!=. & ag6a_09!=0) | (ag6a_04!=. & ag6a_04!=0) // defining plots with fruit/permanent crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
collapse (max) cultivated, by (hhid plotnum)
ren plotnum plot_id
tempfile fruit_tree
save `fruit_tree', replace
restore
append using `fruit_tree'
preserve 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC6B.dta", clear
gen cultivated=1 if (ag6b_09!=. & ag6b_09!=0) | (ag6b_04!=. & ag6b_04!=0) //defining plots with fruit/permanant crops as cultivated if there was any harvest or if any trees were planted in the last 12 months
ren y2_hhid hhid 
collapse (max) cultivated, by (hhid plotnum)
ren plotnum plot_id
tempfile perm_crop
save `perm_crop', replace
restore
append using `perm_crop'
replace agland=1 if cultivated==1
drop if agland!=1 & crop_grown==.
collapse (max) agland, by (hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_agland.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_agland.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmsize_all_agland.dta", replace

use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren plotnum plot_id
drop if plot_id==""
gen rented_out = (ag3a_03==2 | ag3a_03==3 | ag3b_03==2 | ag3b_03==3)
gen cultivated_season = (ag3b_03==1)
bys y2_hhid plot_id: egen plot_cult_season = max(cultivated_season)
replace rented_out = 0 if plot_cult_season==1 // If cultivated in season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
ren y2_hhid hhid 
collapse (max) plot_held, by (hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_held.dta", replace

use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_parcels_held.dta", clear
merge 1:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
ren plotnum plot_id
drop if plot_id==""
ren y2_hhid hhid 
merge m:1 hhid plot_id using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (max) area_acres_meas, by(hhid plot_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_total.dta", replace

********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta", clear
*Start with first wage job; no agriculture (which also includes mining/livestock)
gen agwage=hh_e32_2==1

gen  hrs_main_wage_off_farm=hh_e28 if agwage==0	
gen  hrs_sec_wage_off_farm= hh_e43 if agwage==0	
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm) 
gen  hrs_main_wage_on_farm=hh_e28 if agwage==1	 
gen  hrs_sec_wage_on_farm= hh_e43 if agwage==1	 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm) 
drop *main* *sec*
ren  hh_e06 hrs_unpaid_off_farm

recode hh_e80_1 hh_e80_2 hh_e81_1 hh_e81_1 (.=0) //hh_e80* (collecting firewood) hh_e81* (collecting water); in W4 equivalent vars used were hh_e70 (firewood) and hh_e71 (water)
gen  hrs_domest_fire_fuel=(hh_e80_1+hh_e80_2 +hh_e81_1 +hh_e81_1) 
ren  hh_e78 hrs_ag_activ
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
preserve 
ren y2_hhid hhid 
collapse (sum) nworker_* hrs_*  member_count, by(hhid)
la var member_count "Number of HH members age 5 or above"
la var hrs_unpaid_off_farm  "Total household hours - unpaid activities"
la var hrs_ag_activ "Total household hours - agricultural activities"
la var hrs_wage_off_farm "Total household hours - wage off-farm"
la var hrs_wage_on_farm  "Total household hours - wage on-farm"
la var hrs_domest_fire_fuel  "Total household hours - collecting fuel and making fire and collecting water" //ARP W5 notes: in both W4 and W5, the vars that go into this metric above are collecting fuel and collecting WATER; in W4 code water not noted in label, but correct added in here in W5
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_off_farm_hours.dta", replace
restore

********************************************************************************
*FARM LABOR
********************************************************************************
*Farm labor
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
gen season = 0
ren ag3a* ag3b* 
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"
recode season (.=1)
ren ag3b_72_1 landprep_women 
ren ag3b_72_2 landprep_men 
ren ag3b_72_21 landprep_child 
ren ag3b_72_4 weeding_women 
ren ag3b_72_5 weeding_men 
ren ag3b_72_51 weeding_child 
ren ag3b_72_61 nonharvest_men
ren ag3b_72_62 nonharvest_women
ren ag3b_72_63 nonharvest_child
ren ag3b_72_8 harvest_men 
ren ag3b_72_7 harvest_women 
ren ag3b_72_81 harvest_child
ren ag3b_72_3 wage_landprep
ren ag3b_72_6 wage_weeding 
ren ag3b_72_64 wage_nonharvest
ren ag3b_72_9 wage_harvest 
ren y2_hhid hhid 
recode landprep_* nonharvest* weeding* wage* (.=0)
egen tot_aglabor_wage = rowtotal(wage*)
egen labor_hired = rowtotal(landprep_women landprep_men landprep_child weeding_men weeding_women weeding_child harvest_men harvest_women harvest_child)
recode ag3b_70* (.=0)
egen days_flab_landprep = rowtotal(ag3b_70_1-ag3b_70_6)
egen days_flab_weeding = rowtotal(ag3b_70_13-ag3b_70_18)
egen days_flab_nonharvest = rowtotal(ag3b_70_37-ag3b_70_42)
egen days_flab_harvest = rowtotal(ag3b_70_25-ag3b_70_30)
gen labor_family = days_flab_landprep + days_flab_weeding + days_flab_harvest 
ren plotnum plot_id
gen labor_total = labor_hired + labor_family
lab var labor_hired "Total labor days (hired) allocated to the plot"
lab var labor_family "Total labor days (family) allocated to the plot"
lab var labor_total "Total labor days allocated to the plot"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_family_hired_labor.dta", replace

//collapse (sum) days_hired_* days_famlabor_* labor* tot_aglabor_wage, by (y2_hhid plot_id)
gen days_famlabor_season = labor_family if season==1
gen days_famlabor_mainseason = labor_family if season == 0 
gen days_hired_season = labor_hired if season==1
gen days_hired_mainseason = labor_hired if season==0
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
lab var days_hired_season  "Workdays for hired labor (crops) in season growing season"
lab var days_famlabor_season  "Workdays for family labor (crops) in season growing season"
lab var days_hired_mainseason  "Workdays for hired labor (crops) in season growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in season growing season"
collapse (sum) labor_* tot_aglabor_wage, by(hhid)
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm" 
gen wage_paid_aglabor = tot_aglabor_wage/labor_hired 
la var wage_paid_aglabor "Average daily agricultural labor wage paid, main and seasons"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_family_hired_labor.dta", replace

********************************************************************************
*VACCINE USAGE
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
gen vac_animal=.
ren y2_hhid hhid 
replace vac_animal=1 if ag10a_38==1 | ag10a_38==2
replace vac_animal=0 if ag10a_38==3
replace vac_animal=. if ag10a_38==.
replace vac_animal=. if lvstkcode==14 //dogs aren't counted as TLUs
replace vac_animal = . if ag10a_02==2 | ag10a_02==. // missing if the household did now own any of these types of animals 
*Disagregating vaccine usage by animal type 
ren lvstkcode livestock_code
gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,7,8)) + 3*(livestock_code==9) + 4*(livestock_code==13) + 5*(inlist(livestock_code,10,11))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses)" 5 "Poultry"
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_vaccine.dta", replace
 
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
gen all_vac_animal=.
replace all_vac_animal=1 if ag10a_38==1 | ag10a_38==2
replace all_vac_animal=0 if ag10a_38==3
replace all_vac_animal=. if ag10a_38==.
replace all_vac_animal=. if lvstkcode==14 //dogs aren't counted as TLUs
replace all_vac_animal = . if ag10a_02==2 | ag10a_02==. // missing if the household did now own any of these types of animals 
ren y2_hhid hhid 
preserve
keep hhid ag10a_29_1 all_vac_animal 
ren ag10a_29_1 farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep hhid  ag10a_29_2  all_vac_animal 
ren ag10a_29_2 farmerid
tempfile farmer2
save `farmer2'
restore
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
*gen personid=farmerid
*drop if personid==.
*merge 1:1 hhid personid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gender_merge.dta", nogen
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
*ren personid indiv
*ren indiv indiv
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_vaccine.dta", replace


********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta", clear
gen disease_animal = 1 if (ag10a_37_1!=23 | ag10a_37_2!=23 |  ag10a_37_3!=23 |  ag10a_37_4!=23 ) 
replace disease_animal = 0 if (ag10a_37_1==23)
replace disease_animal = . if (ag10a_37_1==. & ag10a_37_2==. & ag10a_37_3==. & ag10a_37_4==.) 
gen disease_fmd = (ag10a_37_1==7 | ag10a_37_2==7 | ag10a_37_3==7 | ag10a_37_4==7 )
gen disease_lump = (ag10a_37_1==3 | ag10a_37_2==3 | ag10a_37_3==3 | ag10a_37_4==3 )
gen disease_bruc = (ag10a_37_1==1 | ag10a_37_2==1 | ag10a_37_3==1 | ag10a_37_4==1 )
gen disease_cbpp = (ag10a_37_1==2 | ag10a_37_2==2 | ag10a_37_3==2 | ag10a_37_4==2 )
gen disease_bq = (ag10a_37_1==9 | ag10a_37_2==9 | ag10a_37_3==9 | ag10a_37_4==9 )
ren lvstkcode livestock_code
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
ren y2_hhid hhid 
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_diseases.dta", replace

********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
**cannot construct



********************************************************************************
* PLOT MANAGERS * (INPUT USE)
********************************************************************************
//This can be simplified a little more; added to to-dos
/*
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A.dta", clear 
gen season = 0
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC4B.dta" 
recode season (.=1)
ren plotnum plot_id 
ren zaocode crop_code
recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		label define crop_code 931 "Beans-Cowpeas", add
		label values crop_code crop_code
		tab crop_code if crop_code==931 
ren y2_hhid hhid 
gen imprv_seed_use= ag4a_23==2 | ag4b_23==2
collapse (max) imprv_seed_use, by(hhid plot_id crop_code season) 
tempfile imprv_seed 
save `imprv_seed'
*/
 
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_input_quantities.dta", clear
gen use_inorg_fert = inorg_fert_kg != 0 & inorg_fert_kg!=.
gen use_org_fert = org_fert_kg != 0 & org_fert_kg != .
gen use_pest = pest_kg != 0 & pest_kg!=.
merge 1:m hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", nogen
*merge m:1 hhid plot_id crop_code season using `imprv_seed', nogen
recode use* (.=0)

preserve
ren imprv_seed_use imprv_seed_ 
//recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		//tab crop_code if crop_code==931 
collapse (max) imprv_seed_, by(hhid crop_code)
gen hybrid_seed_ = . //More specific for hybrid crop varieties; not available in this wave
merge m:1 crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropname_table.dta", nogen keep(3)
drop crop_code 
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_imprvseed_crop.dta", replace 
restore

//collapse (max) use*, by(hhid plot_id season)
merge m:m hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_dm_ids.dta"
preserve
ren imprv_seed_use all_imprv_seed_
gen all_hybrid_seed_ =.
//recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		//tab crop_code if crop_code==931 
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
*ren personid indiv
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use.dta", replace
restore

collapse (max) use_* imprv_seed_use, by(hhid indiv female)
*ren personid indiv
gen all_imprv_seed_use = imprv_seed_use //Legacy
//TO FIX
gen all_use_inorg_fert = use_inorg_fert
gen all_use_org_fert = use_org_fert 
gen all_use_pest = use_pest 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_input_use.dta", replace 
	collapse (max) use_inorg_fert imprv_seed_use use_org_fert use_pest, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var imprv_seed_use "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_input_use.dta", replace 
	
/* Legacy 
preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if !missing(personid)
	recode farm_manager (.=0)
	lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore
*/

********************************************************************************
*REACHED BY AG EXTENSION
********************************************************************************
*public: government
use "${Tanzania_NPS_W2_raw_data}/AG_SEC12B.dta", clear
ren ag12b_07 receive_advice
ren ag12b_0a sourceid
ren y2_hhid hhid 
preserve
use "${Tanzania_NPS_W2_raw_data}/AG_SEC12A.dta", clear
ren ag12a_01 receive_advice
ren y2_hhid hhid 
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_any_ext.dta", replace
 
********************************************************************************
*USE OF FORMAL FINANACIAL SERVICES
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_P.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_Q.dta" 
gen borrow_bank= hh_p03==1
gen borrow_micro=hh_p03==2
gen borrow_mortgage=hh_p03==3
gen borrow_insurance=hh_p03==4
gen borrow_other_fin=hh_p03==5
gen borrow_neigh=hh_p03==6
gen borrow_employer=hh_p03==9
gen borrow_ngo=hh_p03==11
gen use_bank_acount=hh_q18==1
gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 //use any MM services
gen use_fin_serv_bank= use_bank_acount==1
gen use_fin_serv_credit= borrow_mortgage==1 | borrow_bank==1  | borrow_other_fin==1
gen use_fin_serv_insur= borrow_insurance==1
gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_digital==1 |  borrow_other_fin==1
recode use_fin_serv* (.=0)
ren y2_hhid hhid 
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fin_serv.dta", replace
 
********************************************************************************
*MILK PRODUCTIVITY
********************************************************************************
*Total production
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
keep if itemcode == 1 | itemcode == 2		// keeping milk only
gen months_milked = ag10b_02			// average months milked in last year (by holder)
gen liters_month = ag10b_03_1			// average quantity (liters) per day (questionnaire sounds like this question is TOTAL, not per head)
gen liters_milk_produced=months_milked*liters_month 
ren y2_hhid hhid
collapse (sum) liters_milk_produced, by (hhid)
lab var liters_milk_produced "Total quantity (liters) of milk per year (household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_milk_animals.dta", replace

********************************************************************************
*EGG PRODUCTIVITY
********************************************************************************
*Have to get total owned poultry and then number of eggs
use "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta", clear
keep if itemcode == 3 | itemcode == 4		// keeping eggs only
drop if ag10b_01 == 2
gen eggs_months = ag10b_02	// number of months eggs were produced
gen eggs_per_month = ag10b_03_1 			
gen eggs_total_year = eggs_month*eggs_per_month			// eggs per month times number of months produced in last 12 months
ren y2_hhid hhid 
collapse (sum) eggs_total_year, by (hhid) 
lab var eggs_total_year "Total number of eggs that was produced (household)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_eggs_animals.dta", replace

********************************************************************************
*CROP PRODUCTION COSTS PER HECTARE
********************************************************************************
*Constructed using both implicit and explicit costs and only main rainy season (meher)
*NOTE: There's some overlap with crop production expenses above, but this is because the variables were created separately.
*As of the W5 release this is no longer needed. 

********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
//ALT: Relocated to plot labor 

********************************************************************************
*RATE OF FERTILIZER APPLICATION - Combining with irrigation
********************************************************************************


* AREA PLANTED IRRIGATED
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
gen season = 0
ren ag3a* ag3b* 
recode season (.=1)
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta"

ren  plotnum plot_id
ren y2_hhid hhid 
merge 1:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_planted_area.dta"
merge 1:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_decision_makers.dta", nogen keep(1 3)
merge 1:1 hhid  plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_input_quantities.dta", nogen keep(1 3) 
drop if ha_planted==0
ren ag3b_17 plot_irr
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
reshape wide *_, i(hhid  plot_id season) j(dm_gender2) string

collapse (sum) ha_planted_* *kg* ha_irr_*, by(hhid)

foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}


drop *other* //Need this for household totals but otherwise we don't track plots with unknown management
//Some high inorg fert rates as a result of large tonnages on small plots.
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
lab var npk_kg "NPK fertilizer (kgs) for household"
lab var n_kg "Units of Nitrogen (kgs) for household"
lab var p_kg "Units of Phosphorus (kgs) for household"
lab var k_kg "Units of Potassium (kgs) for household"
la var ha_irr "Planted area under irrigation (ha) for hh"

lab var ha_planted "Area planted (ha), all crops, for household"
foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var urea_kg "Urea (kgs) for `i'-managed plots"
lab var npk_kg "NPK fertilizer (kgs) for `i'-managed plots"
lab var n_kg "Units of Nitrogen (kgs) for `i'-managed plots"
lab var p_kg "Units of Phosphorus (kgs) for `i'-managed plots"
lab var k_kg "Units of Potassium (kgs) for `i'-managed plots"
la var ha_irr_`i' "Planted hectares under irrigation for `i'-managed plots"
}

save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_application.dta", replace

********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available



********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
* TZA LSMS does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of householdd eating nutritious food can be estimated
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_K1.dta" , clear
* recode food items to map HDDS food categories
recode itemcode 	(101/112 		  				=1	"CEREALS" )  //// 
					(201/207    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(601/603		 				=3	"VEGETABLES"	)  ////	
					(701/703						=4	"FRUITS"	)  ////	
					(801/806 						=5	"MEAT"	)  ////					
					(807							=6	"EGGS"	)  ////
					(808/810 						=7  "FISH") ///
					(401  501/504					=8	"LEGUMES, NUTS AND SEEDS") ///
					(901/903						=9	"MILK AND MILK PRODUCTS")  ////
					(1001 1002   					=10	"OILS AND FATS"	)  ////
					(301/303 704 1104 				=11	"SWEETS"	)  //// 
					(1003 1004 1101/1103 1105/1108 	=14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)			
gen adiet_yes=(hh_k01_2==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
ren y2_hhid hhid 
collapse (max) adiet_yes, by(hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid )
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS. 
Can use either cut-off or 6 (=12/2) or cut-off=mean(socore) 
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", replace

preserve 
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_K2.dta" , clear
ren y2_hhid hhid
ren hh_k08_3 days 
ren itemcode item_id
drop hh_k08_2
reshape wide days, i(hhid) j(item_id) string 

gen max_12 = max(daysA, daysB)
gen min_12 = min(daysA, daysB)
egen sum_12 = rowtotal(daysA daysB)
gen fcs_A= 7 if  max_12==7 
replace fcs_A = sum_12 if min_12 ==0
replace fcs_A = (max_12+min((sum_12), 7))/2

drop daysA daysB max_* min_* sum_* 
ren fcs_A daysA

reshape long days, i(hhid) j (item_id) string
gen weight=.
replace weight = 2 if item == "A"  // A
replace weight = 3 if item == "C"  // C
replace weight = 1 if item == "D"  // D
replace weight = 4 if item == "E"  // E
replace weight = 1 if item == "F"  // F
replace weight = 4 if item == "G"  // G
replace weight = 0.5 if item == "H"  // H
replace weight = 0.5 if item == "I"  // I

gen fcs=days*weight
collapse (sum) fcs, by(hhid) 
label var fcs "Food Consumption Score"
gen fcs_poor = (fcs <= 21)
gen fcs_borderline = (fcs > 21 & fcs <= 35)
gen fcs_acceptable = (fcs > 35)
label var fcs_poor "1 = Household has poor Food Consumption Score (0-21)"
label var fcs_borderline "1 = Household has borderline Food Consumption Score (21.5 - 35)"
label var fcs_acceptable "1 = Household has acceptable Food Consumption Score (> 35)"
tempfile fcs_hhid
save `fcs_hhid'
restore

preserve 
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_I1.dta" , clear
keep hh_i02* y2_hhid  
ren y2_hhid hhid 
gen rcsi=hh_i02_1 + hh_i02_2 + hh_i02_3 + hh_i02_4 + 3*hh_i02_5 + hh_i02_6*2+hh_i02_7*4+hh_i02_8*4
label var rcsi "Reducing Coping Strategies Index, weighted total of the types of strategies a household uses to avoid insufficient food"
keep hhid rcsi 

gen rcsi_phase1 = (rcsi <= 3)
gen rcsi_phase2 = (rcsi > 3 & rcsi <= 18)
gen rcsi_phase3 = (rcsi > 19 & rcsi <= 42)
gen rcsi_phase4 = (rcsi > 42)
label var rcsi_phase1 "1 = Household rCSI score belongs to IPC Phase 1, minimal food insecurity (0-3)"
label var rcsi_phase2 "1 = Household rCSI score belongs to IPC Phase 2, stressed food insecurity (4 - 18)"
label var rcsi_phase3 "1 = Household rCSI score belongs to IPC Phase 3, crisis food insecurity (19 - 42)"
label var rcsi_phase4 "1 = Household rCSI score belongs to IPC Phase 4, emergency food insecurity (> 42)"
tempfile rcsi_hhid
save `rcsi_hhid' 
restore

merge 1:1 hhid using `rcsi_hhid', nogen 
merge 1:1 hhid using `fcs_hhid', nogen 
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", replace

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
use "${Tanzania_NPS_W2_raw_data}/AG_SEC4A", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5A"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC5B"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC09"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta"
append using "${Tanzania_NPS_W2_raw_data}/HH_SEC_E1.dta"
gen type_decision="" 
ren y2_hhid hhid 
gen controller_income1=.
gen controller_income2=.
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( ag5a_09_1, .,0,99) |  !inlist( ag5a_09_2, .,0,99) 
replace controller_income1=ag5a_09_1 if !inlist( ag5a_09_1, .,0,99)  
replace controller_income2=ag5a_09_2 if !inlist( ag5a_09_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_09_1, .,0,99) |  !inlist( ag5b_09_2, .,0,99) 
replace controller_income1=ag5b_09_1 if !inlist( ag5b_09_1, .,0,99)  
replace controller_income2=ag5b_09_2 if !inlist( ag5b_09_2, .,0,99)
* append who controle earning from sale to customer 2
preserve
replace type_decision="control_annualsales" if  !inlist( ag5a_14_1, .,0,99) |  !inlist( ag5a_14_2, .,0,99) 
replace controller_income1=ag5a_14_1 if !inlist( ag5a_14_1, .,0,99)  
replace controller_income2=ag5a_14_2 if !inlist( ag5a_14_2, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag5b_14_1, .,0,99) |  !inlist( ag5b_14_2, .,0,99) 
replace controller_income1=ag5b_14_1 if !inlist( ag5b_14_1, .,0,99)  
replace controller_income2=ag5b_14_2 if !inlist( ag5b_14_2, .,0,99)
keep if !inlist( ag5a_14_1, .,0,99) |  !inlist( ag5a_14_2, .,0,99)  | !inlist( ag5b_14_1, .,0,99) |  !inlist( ag5b_14_2, .,0,99) 
keep hhid type_decision controller_income1 controller_income2
tempfile saletocustomer2
save `saletocustomer2'
restore
append using `saletocustomer2'  
* livestock_sales (live)
replace type_decision="control_livestocksales" if  !inlist( ag10a_22_1, .,0,99) |  !inlist( ag10a_22_2, .,0,99) 
replace controller_income1=ag10a_22_1 if !inlist( ag10a_22_1, .,0,99)  
replace controller_income2=ag10a_22_2 if !inlist( ag10a_22_2, .,0,99)
* append who controle earning from livestock_sales (slaughtered)
preserve
replace type_decision="control_livestocksales" if  !inlist( ag10a_28_1, .,0,99) |  !inlist( ag10a_28_2, .,0,99) 
replace controller_income1=ag10a_28_1 if !inlist( ag10a_28_1, .,0,99)  
replace controller_income2=ag10a_28_2 if !inlist( ag10a_28_2, .,0,99)
keep if  !inlist( ag10a_28_1, .,0,99) |  !inlist( ag10a_28_2, .,0,99) 
keep hhid type_decision controller_income1 controller_income2
tempfile control_livestocksales2
save `control_livestocksales2'
restore
append using `control_livestocksales2' 
* control control_otherlivestock_sales
replace type_decision="control_otherlivestock_sales" if  !inlist( ag10b_08_1, .,0,99) |  !inlist( ag10b_08_2, .,0,99) 
replace controller_income1=ag10b_08_1 if !inlist( ag10b_08_1, .,0,99)  
replace controller_income2=ag10b_08_2 if !inlist( ag10b_08_2, .,0,99)
* Fish production income 
*No information available
replace type_decision="control_businessincome" if  !inlist( hh_e54_1, .,0,99) |  !inlist( hh_e54_2, .,0,99) 
replace controller_income1=hh_e54_1 if !inlist( hh_e54_1, .,0,99)  
replace controller_income2=hh_e54_2 if !inlist( hh_e54_2, .,0,99)

** --- Wage income --- *
* There is no question in Tanzania LSMS on who control wage earnings
* and we can't assume that the wage earner always controle the wage income
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
gen control_cropincome = 1 if type_decision == "control_annualsales"
recode 	control_cropincome (.=0)									
gen control_livestockincome = 1 if  type_decision == "control_livestocksales" | type_decision=="control_otherlivestock_sales"							
recode 	control_livestockincome (.=0)
gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode control_farmincome (.=0)								
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)																					
gen control_nonfarmincome=1 if control_businessincome== 1 
recode 	control_nonfarmincome (.=0)																		
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*Now merge with member characteristics
merge 1:1 hhid indiv  using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen 
recode control_* (.=0)
lab var control_cropincome "1=invidual has control over crop income"
lab var control_livestockincome "1=invidual has control over livestock income"
lab var control_farmincome "1=invidual has control over farm (crop or livestock) income"
lab var control_businessincome "1=invidual has control over business income"
lab var control_nonfarmincome "1=invidual has control over non-farm (business or remittances) income"
lab var control_all_income "1=invidual has control over at least one type of income"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_control_income.dta", replace

********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
*first append all files related to agricultural activities with income in who participate in the decision making
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta"
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10B.dta"
gen type_decision="" 
ren y2_hhid hhid 
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
* keep/manage livesock
replace type_decision="manage_livestock" if  !inlist( ag10a_29_1, .,0,99) |  !inlist( ag10a_29_2, .,0,99)  
replace decision_maker1=ag10a_29_1 if !inlist( ag10a_29_1, .,0,99)  
replace decision_maker2=ag10a_29_2 if !inlist( ag10a_29_2, .,0,99)
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
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv 
* Now merge with member characteristics
merge 1:1 hhid indiv using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen 
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_make_ag_decision.dta", replace 
********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${Tanzania_NPS_W2_raw_data}/AG_SEC3A.dta", clear
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC3B.dta" 
append using "${Tanzania_NPS_W2_raw_data}/AG_SEC10A.dta"
gen type_asset=""
ren y2_hhid hhid 
gen asset_owner1=.
gen asset_owner2=.
* Ownership of land.
replace type_asset="landowners" if  !inlist( ag3a_29_1, .,0,99) |  !inlist( ag3a_29_2, .,0,99) 
replace asset_owner1=ag3a_29_1 if !inlist( ag3a_29_1, .,0,99)  
replace asset_owner2=ag3a_29_1 if !inlist( ag3a_29_2, .,0,99)
replace type_asset="landowners" if  !inlist( ag3b_29_1, .,0,99) |  !inlist( ag3b_29_2, .,0,99) 
replace asset_owner1=ag3b_29_1 if !inlist( ag3b_29_1, .,0,99)  
replace asset_owner2=ag3b_29_1 if !inlist( ag3b_29_2, .,0,99)
*livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( ag10a_29_1, .,0,99) |  !inlist( ag10a_29_2, .,0,99)  
replace asset_owner1=ag10a_29_1 if !inlist( ag10a_29_1, .,0,99)  
replace asset_owner2=ag10a_29_2 if !inlist( ag10a_29_2, .,0,99)
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
ren asset_owner indiv
* Now merge with member characteristics
merge 1:1 hhid indiv  using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", nogen 
* 3 member ID in assed files not is member list
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ownasset.dta", replace

********************************************************************************
*CROP YIELDS
********************************************************************************
//ALT 07.20.21: Preprocessing taken care of in the all plots section. At this point, I have what I need for AgQuery and so this is purely for legacy file compatibility
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", clear
gen number_trees_planted_cassava=number_trees_planted if crop_code==21 
gen number_trees_planted_banana=number_trees_planted if crop_code==71
recode number_trees_planted_cassava number_trees_planted_banana (.=0) 	
collapse (sum) number_trees_planted_*, by(hhid) //This should get revisited because some of the cassava might be off the plot by the second season, but we'll cast a wide net for now.
tempfile trees
save `trees'
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", clear
*ren cropcode crop_code
gen no_harvest=ha_harvest==.
gen harvest=kgs_harvest if season==0  & ha_plan_yld !=.
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

collapse (sum) harvest* area* kgs_harvest (max) no_harvest, by(hhid crop_code)
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
//Bencwp has been coded at this point. Beans (31) and Cowpeas (32) do not exist due to the recode. 
drop no_harvest
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan.dta", replace
preserve
	keep if inlist(crop_code, $comma_topcrop_area)
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_harvest_area_yield.dta", replace
restore
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops.dta", replace
restore
*Yield at the household level
//ALT 07.21.21: Code continues here as written in W4
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_harvest_area_yield.dta", clear
recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		tab crop_code if crop_code==931 
		
merge m:1 crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropname_table.dta", nogen keep(3)
merge 1:1 hhid crop_code using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta", nogen keep(1 3) 
recode crop_code (31 32=931) //recoding for new consolidated crop bencwp (931) for combined beans and cowpeas 
		//label define crop_code 931 "Beans-Cowpeas", add
		//label values crop_code crop_code
		tab crop_code
		
		
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
ren kgs_sold kgs_sold_
ren kgs_harvest kgs_harvest_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 
drop /*crop_code*/ price_kg
unab vars : *_ crop_code
reshape wide `vars', i(hhid) j(crop_name) string
merge 1:1 hhid using `trees', nogen
egen kgs_harvest = rowtotal(kgs_harvest_*)
egen kgs_sold = rowtotal(kgs_sold_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)"
//lab var kgs_sold "Kgs sold (household) (all seasons)" //Do we need this here?
//Removing the LRS SRS tagging as they are moot now. 
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (household)" 
	lab var value_sold_`p' "Value sold of `p' (household)" 
	lab var kgs_harvest_`p'  "Harvest of `p' (kgs) (household) (all seasons)" 
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
	recode kgs_harvest_`p' (.=0) if grew_`p'==1 
	recode value_sold_`p' (.=0) if grew_`p'==1 
	recode value_harv_`p' (.=0) if grew_`p'==1 
}

ds kgs_harvest*
sum kgs_harvest_* value_sold* value_harv*

//Check from here if any crops get dropped. Looks like the loop assumes that none was sold if certain crops aren't being recoded earlier and therefore doesn't compute them in the loop.
//Drop everything that isn't crop-related - changing to make this location-independent.
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_yield_hh_crop_level.dta", replace

*Start DYA 9.13.2020 
********************************************************************************
*PRODUCTION BY HIGH/LOW VALUE CROPS - ALT 07.21.21
********************************************************************************
* VALUE OF CROP PRODUCTION  // using 335 output
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production.dta", clear


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
replace crop_group= "Beans, peas, and pulses"   if crop_code==  931
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
replace type_commodity= "High"  if crop_code==  931
replace type_commodity=	"Out"	if crop_code==	998

//ALT 07.22.21: Edited b/c no wheat
preserve
collapse (sum) value_crop_production value_crop_sales, by( hhid commodity) 
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production_grouped.dta", replace
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
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production_type_crop.dta", replace
*End DYA 9.13.2020 
********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan.dta", clear
collapse (sum) area_plan*, by(hhid crop_code)
*Some households have crop observations, but the area planted=0. This will give them an encs of 1 even though they report no crops. Dropping these observations
drop if area_plan==0
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_area_plan_shannon.dta", nogen		//all matched
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

save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_shannon_diversity_index.dta", replace

********************************************************************************
*CONSUMPTION
******************************************************************************** 
use "${Tanzania_NPS_W2_raw_data}/TZY2.HH.Consumption.dta", clear
ren expmR total_cons // using real consumption-adjusted for region price disparities
gen peraeq_cons = (total_cons / adulteq)
gen daily_peraeq_cons = peraeq_cons/365
gen percapita_cons = (total_cons / hhsize)
gen daily_percap_cons = percapita_cons/365
ren y2_hhid hhid 
keep hhid total_cons peraeq_cons daily_peraeq_cons percapita_cons daily_percap_cons adulteq
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_consumption.dta", replace

********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Tanzania_NPS_W2_raw_data}/HH_SEC_I2.dta", clear
forvalues j=1/3 {
	gen food_insecurity_`j'_1 = (hh_i09_`j'_01=="X")
	gen food_insecurity_`j'_2 = (hh_i09_`j'_02=="X")
	gen food_insecurity_`j'_3 = (hh_i09_`j'_03=="X")
	gen food_insecurity_`j'_4 = (hh_i09_`j'_04=="X")
	gen food_insecurity_`j'_5 = (hh_i09_`j'_05=="X")
	gen food_insecurity_`j'_6 = (hh_i09_`j'_06=="X")
	gen food_insecurity_`j'_7 = (hh_i09_`j'_07=="X")
	gen food_insecurity_`j'_8 = (hh_i09_`j'_08=="X")
	gen food_insecurity_`j'_9 = (hh_i09_`j'_09=="X")
	gen food_insecurity_`j'_10 = (hh_i09_`j'_10=="X")
	gen food_insecurity_`j'_11 = (hh_i09_`j'_11=="X")
	gen food_insecurity_`j'_12 = (hh_i09_`j'_12=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
replace months_food_insec = 12 if months_food_insec>12
la var months_food_insec "Number of months in the past year when the HH has experienced food insecurity"
ren y2_hhid hhid 
keep months_food_insec hhid
save "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_food_insecurity.dta", replace

********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
//Cannot be calculated for W2

********************************************************************************
*HOUSEHOLD VARIABLES  
********************************************************************************
global empty_vars ""
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weights.dta", clear
//use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", clear //Replaced by weights.dta

*Gross crop income 
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_production.dta", nogen
* Production by group and type of crop
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)
*Variables: value_crop_production crop_value_lost
* Production by group and type of crops
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_crop_values_production_type_crop.dta", nogen

recode value_pro* value_sal* (.=0)

*Crop costs
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_cost_inputs.dta", nogen
recode cost_expli_hh (.=0) if value_crop_production!=.
gen crop_production_expenses = cost_expli_hh //ALT Kludge, to fix
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost //ALT 10.14.24

lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue"


foreach c in $topcropname_area {
	capture confirm file "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_inputs_`c'.dta"
	if _rc==0 {
	merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_`c'_monocrop_hh_area.dta", nogen
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
merge 1:1 hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_hh.dta", nogen
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_sales", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_livestock_products", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_dung.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses", nogen //only fodder and hired labor in this wave.
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_herd_characteristics", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_TLU_Coefficients.dta", nogen
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_expenses_animal.dta", nogen 

*other household characteristics 
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_mobile_own.dta", nogen //ALT: Not constructed

gen ls_exp_vac =. 
gen cost_water_livestock = .
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
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_self_employment_income.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agproducts_profits.dta", nogen

/*OUT DYA.10.30.2020*/
egen self_employment_income = rowtotal(annual_selfemp_profit /*fish_trading_income*/ byproduct_profits)
lab var self_employment_income "Income from self-employment"
drop annual_selfemp_profit /*fish_trading_income*/ byproduct_profits 

*Wage income
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_wage_income.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_agwage_income.dta", nogen
/*OUT DYA.10.30.2020*/
recode annual_salary annual_salary_agwage(.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_off_farm_hours.dta", nogen

*Other income
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_other_income.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rental_income.dta", nogen

/*OUT DYA.10.30.2020*/
egen transfers_income = rowtotal (pension_income remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income  land_rental_income)
lab var all_other_income "Income from all other revenue"
drop pension_income remittance_income assistance_income rental_income other_income land_rental_income

*Farm size
merge 1:1 hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size.dta", nogen
merge 1:1 hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_all.dta", nogen
merge 1:1 hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmsize_all_agland.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_size_total.dta", nogen

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
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_family_hired_labor.dta", nogen

*Household size
//merge 1:1 y2_hhid using  "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", nogen //should be in weights.dta

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_vaccine.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_input_use.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_imprvseed_crop.dta"
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_improvedseed_use.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_any_ext.dta", nogen
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fin_serv.dta", nogen

/*OUT DYA.10.30.2020*/
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. 
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.
global empty_vars $empty_vars imprv_seed_cassav imprv_seed_banana hybrid_seed_*

*Milk productivity
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_milk_animals.dta", nogen

/*OUT DYA.10.30.2020*/
//gen liters_milk_produced=liters_per_largeruminant * milk_animals //Already constructed
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
//drop liters_per_largeruminant //does not exist
gen liters_per_cow = . 
gen liters_per_buffalo = . 

*Dairy costs 
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_lrum_expenses", nogen

*Rate of fertilizer application (new)
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_fertilizer_application.dta", nogen keep(1 3)

/*OUT DYA.10.30.2020*/
//ALT Note: we can construct this but do not currently  
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
lab var avg_cost_lrum "Average cost per large ruminant"
*gen costs_dairy = avg_cost_lrum*milk_animals 
gen costs_dairy=.
gen costs_dairy_percow = avg_cost_lrum
drop avg_cost_lrum cost_lrum
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen share_imp_dairy = . 

*Egg productivity
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_eggs_animals.dta", nogen

/*OUT DYA.10.30.2020*/
gen egg_poultry_year = . 
global empty_vars $empty_vars *liters_per_cow *liters_per_buffalo *costs_dairy_percow* share_imp_dairy *egg_poultry_year

*Costs of crop production per hectare
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_cropcosts_total.dta", nogen

*Agricultural wage rate
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ag_wage.dta", nogen //ALT: No longer necessary 
*Crop yields 
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_yield_hh_crop_level.dta", nogen 
sum value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* //Check to see if all crop-related variables are being computed here
 
*Total area planted and harvested across all crops, plots, and seasons
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_area_planted_harvested_allcrops.dta", nogen 
*Household diet
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", nogen
*Consumption
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_consumption.dta", nogen
*Household assets
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hh_assets.dta", nogen

 sum value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* //Check to see if the crop-related values are being retained after the merges

*Food insecurity
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_food_insecurity.dta", nogen

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
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_diseases.dta", nogen

*livestock feeding, water, and housing
//merge 1:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_livestock_feed_water_house.dta", nogen
 
*Shannon diversity index
merge 1:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_shannon_diversity_index.dta", nogen

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

sum value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* //Check to see if all crop-related variables are being computed
  
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}

sum value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* //Check to see if all crop-related variables are being computed
 
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
 
 sum value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* //Check to see if all crop-related variables are being computed
 
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
 
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal (nonmissing=.) if livestock_hh==0
 
*all rural households 
recode  hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income /*value_assets*/ /*NA for W2*/ (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

sum value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* //Check to see if all crop-related variables are being computed

global gender "female male mixed"
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months* mean_12months* lost_disease* /* 
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced egg_poultry_year /*
*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_production_expenses  cost_expli_hh /*
*/ livestock_expenses  sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold value_pro* value_sal* //ls_exp_vac* value_assets

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
lab var w_labor_total "labor_total' - Winzorized top 1%"

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
 
*generate inorg_fert_kg, costs_total_ha, and costs_expli_ha using winsorized values
foreach v in inorg_fert org_fert n p k  pest urea npk { //herb
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
}
}
gen cost_total_ha=w_cost_total/w_ha_planted //ALT 05.04.23: removed "_hh" - no longer necessary?
gen cost_expli_ha=w_cost_expli/w_ha_planted	
			
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

foreach x in ag_activ wage_off_farm wage_on_farm unpaid_off_farm domest_fire_fuel off_farm on_farm domest_all other_all {
	local l`v':var label hrs_`x'
	gen hrs_`x'_pc_all = hrs_`x'/member_count
	lab var hrs_`x'_pc_all "Per capital (all) `l`v''"
	gen hrs_`x'_pc_any = hrs_`x'/nworker_`x'
    lab var hrs_`x'_pc_any "Per capital (only worker) `l`v''"
}

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
//recode /*DYA.10.26.2020*/ hrs_*_pc_all (.=0)   //ALT: to do
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
global wins_var_ratios_top1 inorg_fert_rate n_rate p_rate k_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo  /*costs_dairy_percow*/ /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk	//egg_poultry_year 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" | "`v'"=="n_rate" | "`v'"=="k_rate" | "`v'"=="p_rate" |  "`v'"=="urea_rate" |  "`v'"=="npk_rate"{
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
*/ formal_land_rights_hh *_hrs_*_pc_all months_food_insec /*w_value_assets*/ /*NA for W2*/ /*
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
*/ imprv_seed_use use_inorg_fert w_labor_productivity *_rate w_land_productivity /*
*/ w_inorg_fert_kg* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland *_rate w_labor_family w_labor_hired /*
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
gen ccf_loc = (1/$Tanzania_NPS_W2_infl_adj) 
lab var ccf_loc "currency conversion factor - 2017 $NGN"
gen ccf_usd = ccf_loc/$Tanzania_NPS_W2_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Tanzania_NPS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Tanzania_NPS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"


************Rural poverty headcount ratio***************
gen poverty_under_190 = daily_percap_cons < $Tanzania_NPS_W2_poverty_190
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $Tanzania_NPS_W2_poverty_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $Tanzania_NPS_W2_poverty_npl
gen poverty_under_300 = daily_percap_cons < $Tanzania_NPS_W2_poverty_300
la var poverty_under_300 "Household per-capita consumption is below $3.00 in 2021 $ PPP"

_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

*replace empty vars with missing 
foreach v of varlist $empty_vars {
	replace `v' = .
}

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* region region_name district district_name ward /*ward_name*/ /*village*/ /*village_name*/ ea rural farm_size* *total_income* /*
*/ percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland *_rate ha_irr_* hh_members adulteq* *labor_family *labor_hired use_inorg_fert *_kg vac_* /*
*/ /*feed* water**/ * ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* /*ls_exp_vac*/ *prop_farm_prod_sold  /*DYA.10.26.2020*/ /**hrs_**/   months_food_insec /*value_assets*/ hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* /*milk_animals*/ /*poultry_owned*/ *costs_dairy* *cost_per_lit* *cost*/*
*/ *egg_poultry_year* *inorg_fert_kg* *ha_planted* *cost_expli* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* poverty_under_*/*
*/ *_exp* poverty* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* total_cons nb_cattle_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products *value_pro* *value_sal*  /*DYA 10.6.2020*/ *value_livestock_sales*  *w_value_farm_production* *value_slaughtered* *value_lvstck_sold* *value_crop_sales* *sales_livestock_products* *value_livestock_sales* nb*

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

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
la val instrument instrument
gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_largerum_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) & ag_hh==1
saveold "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_household_variables.dta", replace

********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_person_ids.dta", clear
merge m:1 hhid   using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_household_diet.dta", nogen
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_ownasset.dta", nogen  keep(1 3)
//merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhsize.dta", nogen keep (1 3) // In weights.dta
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_input_use.dta", nogen  keep(1 3) //ALT 07.22.21: fert -> input
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_farmer_vaccine.dta", nogen  keep(1 3)
//merge m:1 y2_hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", nogen keep (1 3) // In weights.dta
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_weights.dta", nogen keep (1 3)

*land rights
merge 1:1 hhid indiv using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_land_rights_ind.dta", nogen
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
ren indiv indid
merge m:1 hhid using "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_household_variables.dta", nogen keep (1 3) keepusing(ag_hh)
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
saveold "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_individual_variables.dta", replace

********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_all_plots.dta", clear
collapse (sum) plot_value_harvest=value_harvest, by(dm_gender hhid plot_id field_size season)
merge 1:1 hhid plot_id season using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_plot_family_hired_labor.dta", keep (1 3) nogen
merge m:1 hhid using "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_hhids.dta", keep (1 3) nogen //ALT 07.26.21: Note to include this in the all_plots file.

///*DYA.12.2.2020*/ gen hhid=y2_hhid
/*DYA.12.2.2020*/ merge m:1 hhid using "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

//replace area_meas_hectares=area_est_hectares if area_meas_hectares==.
ren field_size area_meas_hectares

//keep if cultivated==1
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
	
gen ccf_loc = (1/$Tanzania_NPS_W2_infl_adj) 
lab var ccf_loc "currency conversion factor - 2017 $TSH"
gen ccf_usd = ccf_loc/$Tanzania_NPS_W2_exchange_rate 
lab var ccf_usd "currency conversion factor - 2017 $USD"
gen ccf_1ppp = ccf_loc/$Tanzania_NPS_W2_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2017 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Tanzania_NPS_W2_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

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

//rename v1 TNZ_wave2 //ALT: Necessary?
save   "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gendergap.dta", replace
*save   "${Tanzania_NPS_W2_created_data}/Tanzania_NPS_W2_gendergap_nowin.dta", replace
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
saveold "${Tanzania_NPS_W2_final_data}/Tanzania_NPS_W2_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Tanzania_NPS_W2"

do "$summary_stats"
