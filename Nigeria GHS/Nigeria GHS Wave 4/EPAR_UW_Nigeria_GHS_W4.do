
/*-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: Agricultural Development Indicators for the LSMS-ISA, Nigeria General Household Survey (GHS) LSMS-ISA Wave 4 (2018-19)

*Author(s)		: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu

*Date			: March 31st, 2025

*Dataset Version: NGA_2018_GHSP-W4_v03_M 
----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*Data source
*-----------
*The Nigeria General Household Survey was collected by the Nigeria National Bureau of Statistics (NBS) 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period from July-September 2018 and January-February 2019
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/3557

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Nigeria General Household Survey .

*IMPORTANT NOTE: This update includes code to calculate childhood nutritional Z scores based on the WHO "iGrowUp" script and data. It can be downloaded for free at https://github.com/unicef-drp/igrowup_update. 
*Update the path on line 131 with your path to the Stata do file. If the iGrowUp script is missing, the code will continue to execute without computing these statistics.


*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Nigeria General Household Survey (NGA LSMS) data set.
*Using data files from the "Raw DTA files" within the "Nigeria GHS W4" folder, the the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*into the created_data folder, then combines indicators at the unit of observation level (household, plot, and individual plot manager) into the final_data folder, using these to 
*calculate summary statistics, saving the results to the same folder. Depending on the indicators of interest, it may be easier to use the intermediate files (typically "long" formatted) 
*than the final data files ("wide" formatted).

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Nigeria_GHS_W4_summary_stats.xlsx" in the "final_data" folder within "Final DTA files" folder.
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the documents
*"EPAR_UW_335_Indicator Construction Summary Tables" and "EPAR_UW_335_General Considerations and Principles for Indicator Construction.docx" within the folder "Supporting documents".
*/

/*OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Nigeria_GHS_W4_hhids.dta
*INDIVIDUAL IDS						Nigeria_GHS_W4_person_ids.dta
*HOUSEHOLD SIZE						Nigeria_GHS_W4_hhsize.dta
*HEAD OF HOUSEHOLD					Nigeria_GHS_W4_male_head.dta
*PARCEL AREAS						Nigeria_GHS_W4_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Nigeria_GHS_W4_plot_decision_makers.dta
*PLOT-CROP PLANTING/HARVEST DATA	Nigeria_GHS_W4_all_plots.dta
*GROSS CROP REVENUE					Nigeria_GHS_W4_cropsales_value.dta
									Nigeria_GHS_W4_hh_crop_values_production.dta
									Nigeria_GHS_W4_hh_crop_production.dta
*CROP EXPENSES						Nigeria_GHS_W4_hh_cost_labor.dta
									Nigeria_GHS_W4_plot_cost_inputs.dta *Plot
									Nigeria_GHS_W4_hh_cost_inputs.dta *Household
*TLU (Tropical Livestock Units)		Nigeria_GHS_W4_TLU_Coefficients.dta
									Nigeria_GHS_W4_herd_characteristics.dta
*LIVESTOCK INCOME					Nigeria_GHS_W4_livestock_expenses.dta
									Nigeria_GHS_W4_hh_livestock_products.dta
									Nigeria_GHS_W4_livestock_sales.dta
									Nigeria_GHS_W4_livestock_income.dta
*FISH INCOME						**Removed in W4								
*SELF-EMPLOYMENT INCOME				Nigeria_GHS_W4_self_employment_income.dta
									Nigeria_GHS_W4_agproduct_income.dta
*WAGE INCOME						Nigeria_GHS_W4_wage_income.dta
									Nigeria_GHS_W4_agwage_income.dta
*OTHER INCOME						Nigeria_GHS_W4_remittance_income.dta
									Nigeria_GHS_W4_other_income.dta
									Nigeria_GHS_W4_land_rental_income.dta
*FARM SIZE / LAND SIZE				Nigeria_GHS_W4_land_size.dta
									Nigeria_GHS_W4_farmsize_all_agland.dta
									Nigeria_GHS_W4_land_size_all.dta
*FARM LABOR							Nigeria_GHS_W4_farmlabor_postplanting.dta
									Nigeria_GHS_W4_farmlabor_postharvest
									Nigeria_GHS_W4_family_hired_labor.dta
*VACCINE USAGE						Nigeria_GHS_W4_farmer_vaccine.dta
*ANIMAL HEALTH						Nigeria_GHS_W4_livestock_diseases
*INPUT USE BY MANAGERS/HOUSEHOLDS	Nigeria_GHS_W4_farmer_fert_use.dta
									Nigeria_GHS_W4_input_use.dta
*REACHED BY AG EXTENSION			Nigeria_GHS_W4_any_ext.dta
*MOBILE PHONE OWNERSHIP				Nigeria_GHS_W4_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	Nigeria_GHS_W4_fin_serv.dta
*LIVESTOCK PRODUCTIVITY				Nigeria_GHS_W4_milk_animals.dta
									Nigeria_GHS_W4_egg_animals.dta
*CROP PRODUCTION COSTS PER HECTARE	Nigeria_GHS_W4_cropcosts.dta
*FERTILIZER APPLICATION RATES		Nigeria_GHS_W4_fertilizer_application.dta 
*HOUSEHOLD'S DIET DIVERSITY SCORE	Nigeria_GHS_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Nigeria_GHS_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			Nigeria_GHS_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Nigeria_GHS_W4_make_ownasset.dta
*SHANNON DIVERSITY INDEX			Nigeria_GHS_W4_shannon_diversity_index
*CONSUMPTION						Nigeria_GHS_W4_consumption.dta 
*ASSETS								Nigeria_GHS_W4_hh_assets.dta
*MPI INDICATORS & HH NUTRITION		Nigeria_GHS_W4_food_dep.dta
									Nigeria_GHS_W4_mpi_nutr.dta *Additional code required - see module notes
									Nigeria_GHS_W4_mpi_edu.dta
									Nigeria_GHS_W4_mpi_assets.dta
									Nigeria_GHS_W4_mpi_housing.dta
*GENDER PRODUCTIVITY GAP 			Nigeria_GHS_W4_gender_productivity_gap.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Nigeria_GHS_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Nigeria_GHS_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Nigeria_GHS_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					Nigeria_GHS_W4_summary_stats.xlsx

*/


clear
clear matrix
clear mata
program drop _all
set more off
set maxvar 10000

*Set location of raw data and output
global directory			"../.."
global Nigeria_GHS_W4_raw_data			"${directory}/Nigeria GHS/Nigeria GHS Wave 4/Raw DTA Files/"
global Nigeria_GHS_W4_created_data 		"${directory}/Nigeria GHS/Nigeria GHS Wave 4/Final DTA Files/created_data"
global Nigeria_GHS_W4_final_data  		"${directory}/Nigeria GHS/Nigeria GHS Wave 4/Final DTA Files/final_data"
global summary_stats 					"${directory}/_Summary_statistics\EPAR_UW_335_SUMMARY_STATISTICS.do"

//WHO iGrowUp file path
global dofilefold "${directory}/WHO Child Malnutrition Macro/igrowup_update-master" //For child anthropometry z-scores, from https://github.com/unicef-drp/igrowup_update. 

*DYA.11.1.2020 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global Nigeria_GHS_W4_pop_tot 198387623
global Nigeria_GHS_W4_pop_rur 98511358
global Nigeria_GHS_W4_pop_urb 99876265

global drop_unmeas_plots 0 //If not 0, this variable will result in all plots not measured by GPS being dropped; the implied conversion rates between nonstandard units and hectares (based on households with both measured and reported areas) appear to have changed substantially since Wave 3 and have resulted in some large yield estimates because the plots are very small. Easiest fix is to remove them, although bear in mind this will result in inaccurate estimates for national totals. 

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD
********************************************************************************
global Nigeria_GHS_W4_exchange_rate 401.15  		// https://www.bloomberg.com/quote/USDETB:CUR, https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2023&locations=NG&start=2011
// {2017:315,2021:401.15}
global Nigeria_GHS_W4_gdp_ppp_dollar 146.72		// https://data.worldbank.org/indicator/PA.NUS.PPP //2021
global Nigeria_GHS_W4_cons_ppp_dollar 155.72		// https://data.worldbank.org/indicator/PA.NUS.PRVT.PP //2021
global Nigeria_GHS_W4_infl_adj = 0.755009 //2017: 267.5/214.2, 2021: 267.5/354.3
	
global Nigeria_GHS_W4_pound_exchange 476.5
global Nigeria_GHS_W4_euro_exchange 418.7
	
	
//Poverty threshold calculation - It's probably easier to do up here than at the end of the code for ease of transparency and adjustability
//Per W3, we convert WB's international poverty threshold to 2011$ using the PA.NUS.PRVT.PP WB info then inflate to the last year of the survey using CPI
global Nigeria_GHS_W4_poverty_190 (1.90*79.531*(1+(267.512-110.84)/110.84)) //~365 N
global Nigeria_GHS_W4_poverty_npl 376.52 //ALT 06.18.2020: Nigeria's NBS defines poverty as living below 376 N/day. Included for comparison purposes.
global Nigeria_GHS_W4_poverty_215 (2.15*(1.249 * 112.0983276))  //New 2023 WB poverty threshold, works out to 273 N - a substantial drop largely because inflation was about 100% between 2011 and 2017
global Nigeria_GHS_W4_poverty_300 (3.00*($Nigeria_GHS_W4_infl_adj * $Nigeria_GHS_W4_cons_ppp_dollar )) //New 2025 WB poverty threshold, ~690 N

//These values from Bai, Y., et al. (2021) Cost and affordability of nutritious diets at retail prices: Evidence from 177 countries. Food Policy 99. doi:https://doi.org/10.1016/j.foodpol.2020.101983
//CoCA is cost of a calorically adequate diet in PPP$ (minimum number of calories needed for survival); CoNA is cost of a nutritionally adequate diet, i.e., the minimum expenditure required to get RDIs of macro and micronutrients. 
global Nigeria_GHS_W4_CoCA_diet (134.21 * 0.63) //2019 PPP$ 
global Nigeria_GHS_W4_CoNA_diet (134.21 * 1.24)
********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS //change these globals if you are interested in different crops
********************************************************************************
////Limit crop names in variables to 6 characters or the variable names will be too long! 
global topcropname_area "maize rice sorgum millet beanc grdnt yam swtptt cassav banana cocoa soy" //no wheat or beans		
global topcrop_area     "1080 1110 1070 1100 1010 1060 1120 2181 1020 2030 3040 2220" //ALT 12.09.19: As of W3, Yam was in categories 1120-1124 (yam, white yam, yellow yam, water yam, and three-leaved yam). For W4, yam is now only in categories 1121-1124, we have to decide how to collapse these. All four yams are in the genus Dioscorea and white yam and yellow yam are now considered different cultivars of the same species; another common species in cultivation (although less so in Nigeria) is Chinese yam, which doesn't have a category and may have historically wound up in 1120. Given this, I recode all 1121-1124 as 1120 (this will produce slightly different results than we did in W3) //ALT: As of the October 2024 update, we decided to drop three-leaved yam from this category
global comma_topcrop_area "1080, 1110, 1070, 1100, 1010, 1060, 1120, 2181, 1020, 2030, 3040, 2220" 
global topcropname_area_full "maize rice sorghum millet beanc grdnt yam swtptt cassav banana cocoa soy"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
set obs $nb_topcrops 
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
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", replace //This gets used to generate the monocrop files.

********************************************************************************
* WEIGHTS *
********************************************************************************
/*
use "${Nigeria_GHS_W4_raw_data}\secta_plantingw4.dta", clear
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave4 rural
ren wt_wave4 weight
*DYA.11.21.2020 household not survey will not have weights
drop if weight==.  //287 hh as expected
count // 4,976 obs as expected
save  "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_weights.dta", replace
*/



********************************************************************************
* HOUSEHOLD IDS *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/secta_plantingw4.dta", clear
gen rural = (sector==2)
lab var rural "1= Rural"
keep hhid zone state lga ea wt_wave4 rural
ren wt_wave4 weight
drop if weight == . 
*DYA.11.21.2020 from the the BID
*"The final sample consisted of 4,976 households of which 1,425 were from the long panel sample and 3,551 from the refresh sample."
*Now sure why we have 5,263 obs in this file.
*It seems that Overall, 34 refresh EAs were inaccessible during the listing period or post-planting visit. 
*The EAs were highly concentrated in the North East and North Central Zones where conflict (insurgency and farmer-herder attacks) were prevalent during this period.
*But these likely show up this this file explaing why with have 287 a additional households.
duplicates report hhid
//merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_weights.dta", keep(2 3) nogen  // keeping hh surveyed
save  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", replace



********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect1_plantingw4.dta", clear
gen season="plan"
append using "${Nigeria_GHS_W4_raw_data}/sect1_harvestw4.dta"
replace season="harv" if season==""
*keep if s1q4==1 //Drop individuals who've left household   // AYW_3.5.20 This question wasn't asked of all individuals. 
gen member = s1q4
replace member = 1 if s1q3 != . 
drop if member!=1
gen female= s1q2==2
gen fhh = s1q3==1 & female
recode fhh (.=0)
preserve 
collapse (max) fhh, by(hhid)
tempfile fhh
save `fhh'
restore 
la var female "1= individual is female"
ren s1q6 age
la var age "Individual age"
keep hhid indiv female age season
ren female female_
ren age age_ 
reshape wide female_ age_, i(hhid indiv) j(season) string
gen age = age_plan 
replace age=age_harv if age==.
gen female=female_plan 
replace female=female_harv if female==.
drop *harv *plan
merge m:1 hhid using `fhh'
merge m:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", keep(2 3) nogen  // keeping hh surveyed
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", replace


********************************************************************************
* HOUSEHOLD SIZE *
********************************************************************************
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", clear
gen member=1
collapse (max) fhh (sum) hh_members=member, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
collapse (sum) hh_members (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
*DYA.11.1.2020 Re-scaling survey weights to match population estimates
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${Nigeria_GHS_W4_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${Nigeria_GHS_W4_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${Nigeria_GHS_W4_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", replace
keep hhid zone state lga ea weight* rural
save "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_weights.dta", replace
/*
********************************************************************************
*HEAD OF HOUSEHOLD *
********************************************************************************
*Creating HOH gender
use "$Nigeria_GHS_W4_raw_data\sect1_plantingw4.dta", clear
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", nogen keep(2 3)
gen male_head = 0
replace male_head =1 if s1q3 & s1q2==1
collapse (max) male_head, by(hhid)
la var male_head "HH is male headed, 1=yes"	
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_male_head.dta", replace
*/
********************************************************************************
*GPS COORDINATES *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}\nga_householdgeovars_y4.dta", clear
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", nogen keep(3) 
ren lat_dd_mod latitude
ren lon_dd_mod longitude
keep lga ea latitude longitude
duplicates drop lga ea latitude longitude, force //ea+lga necessary to uniquely identify ea
gen GPS_level = "ea"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_ea_coords.dta", replace



********************************************************************************
* PLOT AREAS *
********************************************************************************
*starting with planting
//ALT IMPORTANT NOTE: As of W4, the implied area conversions for farmer estimated units (including hectares) are markedly different from previous waves. I recommend excluding plots that do not have GPS measured areas from any area-based productivity estimates.
use "${Nigeria_GHS_W4_raw_data}/sect11a1_plantingw4.dta", clear
*merging in planting section to get cultivated status
merge 1:1 hhid plotid using "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", nogen
*merging in harvest section to get areas for new plots
merge 1:1 hhid plotid using "${Nigeria_GHS_W4_raw_data}/secta1_harvestw4.dta", gen(plot_merge)
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", nogen keep( 3)
ren s11aq4aa area_size
ren s11aq4b area_unit
ren sa1q11 area_size2 //GPS measurement, no units in file
//ren sa1q9b area_unit2 //Not in file
ren s11aq4c area_meas_sqm
//ren sa1q9c area_meas_sqm2
gen cultivate = s11b1q27 ==1 
*assuming new plots are cultivated
//replace cultivate = 1 if sa1q1aa==1
//replace cultivate = 1 if sa1q3==1 //ALT: This has changed to respondent ID for w4
*using conversion factors from LSMS-ISA Nigeria Wave 2 Basic Information Document (Wave 3 unavailable, but Waves 1 & 2 are identical) 
*found at http://econ.worldbank.org/WBSITE/EXTERNAL/EXTDEC/EXTRESEARCH/EXTLSMS/0,,contentMDK:23635560~pagePK:64168445~piPK:64168309~theSitePK:3358997,00.html
*General Conversion Factors to Hectares
//		Zone   Unit         Conversion Factor
//		All    Plots        0.0667
//		All    Acres        0.4
//		All    Hectares     1
//		All    Sq Meters    0.0001

*Zone Specific Conversion Factors to Hectares
//		Zone           Conversion Factor
//				 Heaps      Ridges      Stands
//		1 		 0.00012 	0.0027 		0.00006
//		2 		 0.00016 	0.004 		0.00016
//		3 		 0.00011 	0.00494 	0.00004
//		4 		 0.00019 	0.0023 		0.00004
//		5 		 0.00021 	0.0023 		0.00013
//		6  		 0.00012 	0.00001 	0.00041

//ALT observed from the data
//		Zone           Conversion Factor
//				 Heaps      Ridges      Stands
//		1 		 0.00281 	0.0059 		0.00121
//		2 		 0.00748 	0.0052 		0.0006
//		3 		 0.00787 	0.0051	 	0.0002
//		4 		 0.00003 	0.0010 		0.0003
//		5 		 0.00076 	0.0008 		0.009
//		6  		 0.00437 	0.0005	 	0.002

*farmer reported field size for post-planting
gen field_size= area_size if area_unit==6
replace field_size = area_size*0.0667 if area_unit==4									//reported in plots
replace field_size = area_size*0.404686 if area_unit==5		    						//reported in acres
replace field_size = area_size*0.0001 if area_unit==7									//reported in square meters

replace field_size = area_size*0.00012 if area_unit==1 & zone==1						//reported in heaps
replace field_size = area_size*0.00016 if area_unit==1 & zone==2
replace field_size = area_size*0.00011 if area_unit==1 & zone==3
replace field_size = area_size*0.00019 if area_unit==1 & zone==4
replace field_size = area_size*0.00021 if area_unit==1 & zone==5
replace field_size = area_size*0.00012 if area_unit==1 & zone==6

replace field_size = area_size*0.0027 if area_unit==2 & zone==1							//reported in ridges
replace field_size = area_size*0.004 if area_unit==2 & zone==2
replace field_size = area_size*0.00494 if area_unit==2 & zone==3
replace field_size = area_size*0.0023 if area_unit==2 & zone==4
replace field_size = area_size*0.0023 if area_unit==2 & zone==5
replace field_size = area_size*0.00001 if area_unit==2 & zone==6

replace field_size = area_size*0.00006 if area_unit==3 & zone==1						//reported in stands
replace field_size = area_size*0.00016 if area_unit==3 & zone==2
replace field_size = area_size*0.00004 if area_unit==3 & zone==3
replace field_size = area_size*0.00004 if area_unit==3 & zone==4
replace field_size = area_size*0.00013 if area_unit==3 & zone==5
replace field_size = area_size*0.00041 if area_unit==3 & zone==6

/*ALT 02.23.23*/ gen area_est = field_size
*replacing farmer reported with GPS if available
replace field_size = area_meas_sqm*0.0001 if area_meas_sqm!=.               				
gen gps_meas = (area_meas_sqm!=.)
la var gps_meas "Plot was measured with GPS, 1=Yes"
ren plotid plot_id
if $drop_unmeas_plots !=0 {
	drop if gps_meas == 0
}
ren s11aq6a indiv1
ren s11aq6b indiv2
ren s11aq6c indiv3
ren s11aq6d indiv4

replace indiv1 = sa1q2 if indiv1==. //Post-Harvest (only reported for "new" plot)
replace indiv2 = sa1q2c_1 if indiv2==.
replace indiv3 = sa1q2c_2 if indiv3==. //The ph questionnaire goes up to six for ph but we'll stick to the first four for consistency with the pp questionnaire 
replace indiv4 = sa1q2c_3 if indiv4==.
replace indiv1 = s11b1q6_1 if indiv1==. & indiv2==. & indiv3==. & indiv4==. //plot owner if dm is empty

la var indiv1 "Primary plot manager (indiv id)"
la var indiv2 "First Secondary plot manager (indiv id)"
la var indiv3 "Second secondary plot manager (indiv id)"
la var indiv4 "Third secondary plot manager (indiv id)"
 
drop s11* sa1*
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", replace

********************************************************************************
* PLOT DECISION MAKERS *
********************************************************************************
*Using planting data 	
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", clear 	
keep hhid plot_id indiv* cultivate //ALT: Based on crop reporting numbers I would take the cultivate response with a grain of salt. 
reshape long indiv, i(hhid plot_id cultivate) j(indivno)
collapse (min) indivno, by(hhid plot_id indiv cultivate) //Removing excess observations to accurately estimate the number of decisionmakers in mixed-managed plots. Taking the highest rank
//At this point, we have the decisionmakers and their relative priority level, as the questionnaire asks to go in descending order of importance. This may be relevant for some applications (e.g., you want only the primary decisionmaker; keep if indivno==1), but we don't use it here.
drop if indiv==.
merge m:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", nogen keep(1 3) keepusing(female) 
preserve 
keep hhid plot_id indiv female
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_dm_ids.dta", replace
restore
gen dm1_gender = female+1 if indivno==1
collapse (mean) female (firstnm) dm1_gender, by(hhid plot_id)
*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 3 if female !=1 & female!=0 & female!=.
replace dm_gender = 1 if female == 0
replace dm_gender = 2 if female == 1
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
*replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep(1 3)
replace dm1_gender=fhh+1 if dm_gender==.
replace dm_gender=fhh+1 if dm_gender==.
gen dm_male = dm_gender==1
gen dm_female = dm_gender==2
gen dm_mixed = dm_gender==3
keep plot_id hhid dm* //fhh 
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers", replace


********************************************************************************
*Formalized Land Rights*
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", clear
//gen formal_land_rights = s11b1q8>=1 & s11b1q8b!= "NO NEED"	//ALT: For W4, this question was broken out into a bunch of yes/no questions for each type of instrument going with 7, "do you have a title"
*gen formal_land_rights = s11b1q7==1

*DYA.11.21.2020 Seems like we should be able to use the variable s11b1q8_ in this wave like in the previouis to maintain the comparability
gen formal_land_rights = (s11b1q8_1==1 | s11b1q8_2==1 | s11b1q8_3==1 | s11b1q8_5==1) | s11b1q9a==1

//drop if formal_land_rights==. //ALT 03.20.2020: Drop empties?
//ALT: This q was in w4 with up to 32 possible title holders across 4 categories. I'm redoing it with reshape because otherwise we'd be here all day.
ren s11b1q8b4_1 indiv1
ren s11b1q8b4_2 indiv2
ren s11b1q8b4_3 indiv3
ren s11b1q8b4_4 indiv4
ren s11b1q8b4_5 indiv5
ren s11b1q8b4_6 indiv6
ren s11b1q8b4_7 indiv7
ren s11b1q8b2_1 indiv8
ren s11b1q8b2_2 indiv9
ren s11b1q8b2_3 indiv10
ren s11b1q8b2_4 indiv11
ren s11b1q8b2_5 indiv12
ren s11b1q8b2_6 indiv13
ren s11b1q8b3_1 indiv14
ren s11b1q8b3_2 indiv15
ren s11b1q8b3_3 indiv16
ren s11b1q8b3_4 indiv17
ren s11b1q8b3_5 indiv18
ren s11b1q8b3_6 indiv19
ren s11b1q8b1_1 indiv20
ren s11b1q8b1_2 indiv21
ren s11b1q8b1_3 indiv22
ren s11b1q8b1_4 indiv23
ren s11b1q8b1_5 indiv24
ren s11b1q8b1_6 indiv25
ren s11b1q8b1_7 indiv26
ren s11b1q8b1_8 indiv27
ren s11b1q8b1_9 indiv28
ren s11b1q8b1_10 indiv29
ren s11b1q8b1_11 indiv30
ren s11b1q8b1_12 indiv31
ren s11b1q8b1_13 indiv32
*other ownership documents
/* ALT: Not person ids
ren s11b1q10_1 indiv33
ren s11b1q10_2 indiv34
ren s11b1q10_3 indiv35
ren s11b1q10_4 indiv36
ren s11b1q10_5 indiv37
ren s11b1q10_6 indiv38
ren s11b1q10_7 indiv39
ren s11b1q10_8 indiv40
*/

//Speed this section up to avoid a very long reshape.
unab vars : indiv*
foreach var in `vars' {
qui tab `var'
if `r(N)' == 0 drop `var'
}

egen id = concat(hhid plotid)
reshape long indiv, i(id) j(indiv_no)
drop if indiv==. //Drop 350k empty entries so that the merge doesn't break the program.
merge m:1 hhid indiv using "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_person_ids.dta", nogen keep(3)
gen formal_land_rights_f = formal_land_rights==1 & female==1
preserve
collapse (max) formal_land_rights_f, by(hhid indiv)		
save "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_land_rights_ind.dta", replace
restore	
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)		// taking max at household level; equals one if they have official documentation for at least one plot
//merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta"
//recode formal_land_rights_hh (.=0) //ALT 03.20.2020: I think this gets screwed up later in the code if there isn't a value for this variable.
//ALT 09.16.20: doing it this way results in abnormally low values for formal land rights.
keep hhid formal_land_rights_hh
*DYA.11.21.2020 there are only 691 observation which seems relatively lower than in w3
*ALT 02.01.2021: Including "other" resulted in an increase in obs.
save "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_land_rights_hh.dta", replace


********************************************************************************
*crop unit conversion factors
********************************************************************************
/*ALT: Theoretically this should be unnecessary because conversion factors are now
included in their respective files. However, in practice there is a lot of missing info
and so we need to construct a central conversion factors file like the one provided in W3.
Issues this section is used to address:
	*Known but missing conversion factors
	*Calculating conversion factors for seed (see seed section for why we need this)
	*Units that had conversion factors in previous waves that were not used in W4
	*Conversion factors for units that weren't included but which can be inferred from the literature
*/
use "${Nigeria_GHS_W4_raw_data}/secta3i_harvestw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/secta3iii_harvestw4.dta"
replace cropcode=1120 if inrange(cropcode, 1121,1124)
label define CROPCODE 1120 "1120. YAM" , add //all yam cfs are the same
//recode cropcode (2170=2030) //Bananas=plaintains ALT 06.23.2020: Bad idea, because the conversion factors vary a bunch (har har)
ren sa3iq6ii unit
ren sa3iq6_4 size
ren sa3iq6_2 condition
ren sa3iq6_conv conv_fact

replace unit=sa3iiq1c if unit==.
replace size=sa3iiq1d if size==.
replace condition=sa3iiq1b if condition==.  //ALT 02.01.21 Typo; fixed //DYA.11.21.2020  I am not sure why this? sa3iiq1d is "What was the total harvest of [CROP] from all HH's plots? (Size)". Should be sa3iiq1b but this is used below
replace conv_fact=sa3iiq1_conv if conv_fact==.

replace unit=sa3iiiq13c if unit==.
replace size=sa3iiiq13d if size==.
replace condition=sa3iiiq13b if condition==.
replace conv_fact=sa3iiiq13_conv if conv_fact==.


replace unit=sa3iq6d2 if unit==.
replace size=sa3iq6d4 if size==.
//ALT 09.25.20: something weird is happening here
replace condition=sa3iq6d2a if condition==.
replace conv_fact=sa3iq6d_conv if conv_fact==.
//drop if sa3iq3==2 | sa3iq3==. //drop if no harvest //ALT 02.03.21: I was mistakenly dropping things needed for conversion factors here
drop if unit==.  //DYA.11.21.2020 So all the missing units are instances where there was no harvest during the season
//At this point we have all cropcode/size/unit/condition combinations that show up in the survey.
//Ordinarily, we'd collapse by state/zone/country to get median values most representative of a hh's area.
//However, here the values are the same across geographies so we don't need to do it - we just need to add in our imputed values.

//ALT 06.23.2020: Code added for bananas/plantains, oil palm, other missing conversions. Turns out conversions are missing from the tree crop harvest in the next section, and so tree crops are being underreported in the final data.
replace conv_fact=1 if unit==1 //kg
replace conv_fact=0.001 if unit==2 //g

replace conv_fact=25 if size==10 //25kg bag
replace conv_fact=50 if size==11 //50kg bag
replace conv_fact=100 if size==12 //100kg bag

replace conv_fact = 21.3 if unit==160 & cropcode==2230 //Conversion factors for sugar cane, because they are not in the files or basic info doc
replace conv_fact = 2.13 if unit==80 & cropcode==2230
replace conv_fact = 53.905 if unit==170 & cropcode==2230
replace conv_fact = 1957.58 if unit==180 //Estimated weight for a pick-up 
//Banana/Plantain & oil palm conversions from W3
replace conv_fact=0.5 if unit==80 & size==0 & cropcode==2030
replace conv_fact=0.6 if unit==80 & (size==1 | size==.) & cropcode==2030
replace conv_fact=0.7 if unit==80 & size==2 & cropcode==2030
replace conv_fact=0.445 if unit==100 & size==0 & cropcode==2030
replace conv_fact=1.345 if unit==100 & (size==1 | size==.) & cropcode==2030
replace conv_fact=2.12 if unit==100 & size==2 & cropcode==2030
replace conv_fact=5.07 if unit==110 & size==0 & cropcode==2030
replace conv_fact=7.14 if unit==110 & (size==1 | size==.) & cropcode==2030
replace conv_fact=21.62 if unit==110 & size==2 & cropcode==2030

replace conv_fact=0.135 if unit==80 & size==0 & cropcode==2170
replace conv_fact=0.23 if unit==80 & (size==1 | size==.) & cropcode==2170
replace conv_fact=0.34 if unit==80 & size==2 & cropcode==2170
replace conv_fact=0.615 if unit==100 & size==0 & cropcode==2170
replace conv_fact=1.06 if unit==100 & (size==1 | size==.) & cropcode==2170
replace conv_fact=2.1 if unit==100 & size==2 & cropcode==2170
replace conv_fact=3.51 if unit==110 & size==0 & cropcode==2170
replace conv_fact=5.14 if unit==110 & (size==1 | size==.) & cropcode==2170
replace conv_fact=7.965 if unit==110 & size==2 & cropcode==2170

replace conv_fact=5.235 if unit==140 & size==0 & cropcode==2170
replace conv_fact=13.285 if unit==140 & (size==1 | size==.) & cropcode==2170
replace conv_fact=15.972 if unit==140 & size==2 & cropcode==2170
replace conv_fact=3.001 if unit==150 & size==0 & cropcode==2170
replace conv_fact=6.959 if unit==150 & (size==1 | size==.) & cropcode==2170
replace conv_fact=16.11 if unit==150 & size==2 & cropcode==2170

//Oil palm bunch data. Lots of papers report weights, but none report variances, so asessing small/med/large is difficult.
//The lit cites bunch weights anywhere from 15-40 kg, but Nigeria-specific research exclusively cites lower values. Here,
//I use the range from Genotype and genotype by environment (GGE) biplot analysis of fresh fruit bunch yield and yield components of oil palm (Elaeis guineensis Jacq.).
//by Okoye et al (2008) to approximate the field variation.

replace conv_fact=9.5 if unit==100 & size==0 & cropcode==3180
replace conv_fact=14.5 if unit==100 & size==2 & cropcode==3180
replace conv_fact=12 if unit==100 & (size==1 | size==.) & cropcode==3180

//Now one-size-fits-all estimates from WB and external sources to get stragglers 
//These from Local weights and measures in Nigeria: a handbook of conversion factors by Kormawa and Ogundapo
//paint rubber - 2.49 //LSMS says about 2.9
replace conv_fact=2.49 if unit==11 & conv_fact==.
replace conv_fact = 1.36 if (unit==20 | unit==30) & size==0 & conv_fact==. //Lower estimate given by Kormawa and Ogundapo
replace conv_fact = 1.5 if (unit==20 | unit==30) & (size==1 | size==.) & conv_fact==. //congo/mudu value from LSMS W1, assuming medium if left blank
replace conv_fact = 1.74 if (unit==20 | unit==30) & size==2 & conv_fact==. //Upper estimate by K&O
replace conv_fact = 2.72 if unit==50 & size==0 & conv_fact==. //1 tiya=2 mudu
replace conv_fact = 3 if unit==50 & (size==1 | size==.) & conv_fact==. //2x med mudu
replace conv_fact = 3.48 if unit==50 & size==2 & conv_fact==. //2x lg mudu
replace conv_fact = 0.35 if unit==40 & size==0  & conv_fact==. //Small derica from W1
replace conv_fact = 0.525 if unit==40 & (size==1 | size==.) & conv_fact==. //central value
replace conv_fact = 0.7 if unit==40 & size==2 & conv_fact==. & conv_fact==. //large derica from W1
replace conv_fact = 15 if unit==140 & size==0 & conv_fact==. //Small basket from W1
replace conv_fact = 30 if unit==140 & (size==1 | size==.) & conv_fact==. //Med basket W1
replace conv_fact = 50 if unit==140 & size==2 & conv_fact==. //Lg basket W1
replace conv_fact = 85 if unit==170 & size==. & conv_fact==. //Med wheelbarrow w1 

drop if conv_fact==.

collapse (median) conv_fact, by(unit size cropcode condition)
ren conv_fact conv_fact_median
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", replace


********************************************************************************
*ALL PLOTS
********************************************************************************
/*ALT 08.16.21: Imported the W3 code for this section 
This code is part of a project to create database-style files for use in AgQuery. At the same time,
it simplifies and reduces the ag indicator construction code. Most files generated by the old code
are still constructed (marked as "legacy" files); some files are eliminated where data were consolidated.
*/
	***************************
	*Crop Values
	***************************
	//Nonstandard unit values
use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestW4.dta", clear
	//Fstat highly insignificant for yam on price, so we'll lump here.
	replace cropcode=1120 if inrange(cropcode, 1121,1124)
	label define CROPCODE 1120 "1120. YAM", add
	keep if sa3iiq3==1
	ren sa3iiq5a qty
	ren sa3iiq1b condition
	ren sa3iiq1c unit
	ren sa3iiq1d size
	ren sa3iiq6 value
	merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb) keep(3)
	gen weight=qty*weight_pop_rururb
	//ren cropcode crop_code
	gen price_unit = value/qty
	gen obs=price_unit!=.
	keep if obs==1
	foreach i in zone state lga ea hhid {
		preserve
		bys `i' cropcode unit size condition : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i'=price_unit [aw=weight], by (`i' unit size condition cropcode obs_`i'_price)
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	bys cropcode unit size condition : egen obs_country_price = sum(obs)
	collapse (median) price_unit_country = price_unit [aw=weight], by(cropcode unit size condition obs_country_price)
	tempfile price_unit_country_median
	save `price_unit_country_median'
//Because we have several qualifiers now (size and condition), using kg as an alternative for pricing. Results from experimentation suggests that the kg method is less accurate than using original units, so original units should be preferred.
use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestW4.dta", clear
	keep if sa3iiq3==1
	replace cropcode=1120 if inrange(cropcode, 1121,1124)
	label define CROPCODE 1120 "1120. YAM", add
	ren sa3iiq5a qty
	ren sa3iiq1b condition
	ren sa3iiq1c unit
	ren sa3iiq1d size
	ren sa3iiq6 value
	merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb) keep(1 3)
	merge m:1 cropcode unit size condition using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", nogen keep(1 3)
	//ren cropcode crop_code
	gen qty_kg = qty*conv_fact 
	drop if qty_kg==. //34 dropped; largely basin and bowl.
	gen price_kg = value/qty_kg
	gen obs=price_kg !=.
	keep if obs == 1
	replace weight = weight_pop_rururb*qty_kg
	foreach i in zone state lga ea hhid {
		preserve
		bys `i' cropcode : egen obs_`i'_pkg = sum(obs)
		collapse (median) price_kg_`i'=price_kg [aw=weight_pop_rururb], by (`i' cropcode obs_`i'_pkg)
		tempfile price_kg_`i'_median
		save `price_kg_`i'_median'
		restore
	}
	bys cropcode : egen obs_country_pkg = sum(obs)
	collapse (median) price_kg_country = price_kg [aw=weight_pop_rururb], by(cropcode obs_country_pkg)
	tempfile price_kg_country_median
	save `price_kg_country_median'
 
	***************************
	*Plot variables
	***************************
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingW4.dta", clear
	gen crop_code_11f = cropcode
	merge 1:1 hhid plotid cropcode using "${Nigeria_GHS_W4_raw_data}/secta3i_harvestw4.dta", nogen
	merge 1:1 hhid plotid cropcode using "${Nigeria_GHS_W4_raw_data}/secta3iii_harvestw4.dta", nogen
	//ren cropcode crop_code_a3i 
	ren plotid plot_id
	ren s11fq5 number_trees_planted
	gen use_imprv_seed=s11fq3b==1
	
	gen perm_crop = s11fq0==2
	replace perm_crop = 1 if cropcode==1020 //I don't see any indication that cassava is grown as a seasonal crop in Nigeria
	//replace crop_code_11f=crop_code_a3i if crop_code_11f==.
	//replace crop_code_a3i = crop_code_11f if crop_code_a3i==.
	//gen cropcode =crop_code_11f //Generic level
	replace cropcode = crop_code_11f if cropcode==.
	drop if cropcode == 1010 & ((hhid==50053 & plot_id==2) | (hhid==209107 & plot_id==1)) //Reported as mistaken entries in sa3iq4_os
	recode cropcode (2170=2030) (2142 = 2141) (1121 1122 1123 1124=1120) //Only things that carry over from W3 are bananas/plantains, yams, and peppers. The generic pepper category 2040 in W3 is missing from this wave. //Okay to lump yams for price and unit conversions, not for other things. 
	replace cropcode = 4010 if strpos(sa3iq4_os, "FEED") | regexm(sa3iq4_os, "CONSUMP*TION") | regexm(sa3iq4_os, "ONLY.+LEAVES")
	drop if strpos(sa3iq4_os, "FALLOW") | regexm(sa3iq4_os, "NO.+PLANT") | strpos(sa3iq4_os, "MISTAK")
	label define CROPCODE 1120 "1120. YAM" 4010 "4010. FODDER", add
	la values cropcode CROPCODE
	merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(3) //ALT 05.03.23
	gen percent_field = s11fq1/100
	replace percent_field = s11fq4/100 if percent_field==. 
	recode percent_field field_size (0=.)
	
	bys hhid plot_id : egen tot_pct_planted = sum(percent_field)
	gen miss_pct = percent_field==. 
	bys hhid plot_id : egen tot_miss = sum(miss_pct)
	gen underplant_pct = 1-tot_pct_planted 
	replace percent_field = underplant_pct/tot_miss if miss_pct & underplant_pct > 0 
	replace percent_field = percent_field/tot_pct_planted if tot_pct_planted > 1
	gen ha_planted = percent_field*field_size
	
	gen pct_harvest=1 if sa3iq4b ==2 | sa3iiiq7==1 //Was area planted less than area harvested? 2=No / In the last 12 months, has your household harvested any <Tree Crop>? They don't ask for area harvested, so I assume that the whole area is harvested (not true for some crops)
	replace pct_harvest = sa3iq5/100 if sa3iq5!=. //1075 obs
	replace pct_harvest = 0 if pct_harvest==. & sa3iq4 < 6
	replace pct_harvest = 1 if cropcode==4010 //Assuming fodder crops were fully "harvested"
	gen ha_harvest=ha_planted*pct_harvest
	
	preserve
		gen obs=1
		replace obs=0 if inrange(sa3iq4,1,5) & s11fq0==1
		collapse (sum) obs, by(hhid plot_id cropcode)
		replace obs = 1 if obs > 1
		collapse (sum) crops_plot=obs, by(hhid plot_id)
		tempfile ncrops 
		save `ncrops'
	restore //14 plots have >1 crop but list monocropping; meanwhile 289 list intercropping or mixed cropping but only report one crop
	merge m:1 hhid plot_id using `ncrops', nogen

	
	gen purestand= crops_plot==1 //This includes replanted crops
	bys hhid plot_id : egen permax = max(perm_crop)
	
	gen planting_year = s11fq3_2
	gen planting_month = s11fq3_1
	gen harvest_month_begin = sa3iq4a1
	gen harvest_year_begin = sa3iq4a2
	gen harvest_year_end = sa3iq6c2
	gen harvest_month_end = sa3iq6c1

	
	*renaming unit code for merge
	//ALT 10.14.21: Tree crop harvests are recorded in both s11f (planting) and sa3iii (harvest); thus, it's likely that s11f has a lot of old harvests (range 2010-2018; mean 2017.365) that we wouldn't want to consider here. However, 465 obs note 2018 (vs 300 in harvest questionnaire), so I replace with sa3iii except when sa3iii is empty and the harvest year is 2018
	ren sa3iq6ii unit
	replace unit = sa3iiiq13c if unit==.
	replace unit = s11fq11b if unit==. & s11fq8b==2018 
	ren sa3iq6_4 size
	replace size = sa3iiiq13d if size==.
	replace size = s11fq11c if size==. & s11fq8b==2018
	ren sa3iq6_2 condition
	replace condition = sa3iiiq13b if condition==.
	replace condition = s11fq11d if condition==. & s11fq8b==2018
	ren sa3iq6i quantity_harvested
	replace quantity_harvested = sa3iiiq13a if quantity_harvested==.
	replace quantity_harvested = s11fq11a if quantity_harvested==. & s11fq8b==2018
	*merging in conversion factors
	merge m:1 cropcode unit size condition using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", keep(1 3) nogen //Only 169 obs of units unmerged. 
	replace conv_fact=1 if conv_fact==. & unit==1
	gen quant_harv_kg = quantity_harvested * sa3iq6_conv
	replace quant_harv_kg = quantity_harvested * sa3iiiq13_conv if quant_harv_kg == .
	replace quant_harv_kg = quantity_harvested * conv_fact if quant_harv_kg == .
	//gen quant_harv_kg= quantity_harvested*conv_fact
	ren sa3iq6a val_harvest_est
	replace val_harvest_est = sa3iiiq14 if val_harvest_est==.
	//ALT 09.28.22: I'm going to keep the grower-estimated valuation in here even though it's likely inaccurate for comparison purposes.
	gen val_unit_est = val_harvest_est/quantity_harvested
	gen val_kg_est = val_harvest_est/quant_harv_kg
	merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3)
	gen plotweight = ha_planted*weight_pop_rururb
	//IMPLAUSIBLE ENTRIES - at least 100x the typical yield
	foreach var in quantity_harvested quant_harv_kg val_harvest_est val_unit_est val_kg_est {
	replace `var' = . if (hhid == 299005 & plot_id == 2 & cropcode == 1020) | /* 2000 heaps of cassava on 0.003 ha 
	*/ (hhid == 339038 & plot_id == 2 & cropcode == 2190) | /* 5 tons of pumpkins on 0.0075 ha, an area smaller than my apartment
	*/ (hhid == 229068 & plot_id == 2 & cropcode == 1121) | /* 17 tons of yams on 0.144 ha
	*/ (hhid == 120058 & plot_id == 3 & cropcode == 1121) //14 tons of yams on 0.1 ha.
	}
	gen obs=quantity_harvested>0 & quantity_harvested!=.

foreach i in zone state lga ea hhid {
	merge m:1 `i' unit size condition cropcode using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' cropcode using `price_kg_`i'_median', nogen keep(1 3)
}
merge m:1 unit size condition cropcode using `price_unit_country_median', nogen keep(1 3)
*merge m:1 unit size condition cropcode using `val_unit_country_median', nogen keep(1 3)
merge m:1 cropcode using `price_kg_country_median', nogen keep(1 3)
*merge m:1 cropcode using `val_kg_country_median', nogen keep(1 3)

//We're going to prefer observed prices first
gen price_unit = . 
gen price_kg = .
recode obs_* (.=0)
foreach i in country zone state lga ea {
	replace price_unit = price_unit_`i' if obs_`i'_price>9 & price_unit_`i'!=.
	replace price_kg = price_kg_`i' if obs_`i'_pkg>9 & price_kg_`i'!=. 
}
	ren price_unit_hhid price_unit_hh 
	ren price_kg_hhid price_kg_hh
	
	replace price_unit_hh = price_unit if price_unit_hh==.
	replace price_kg_hh = price_kg if price_kg_hh==.
	gen value_harvest = price_unit * quantity_harvested
	replace value_harvest = price_kg * quant_harv_kg if value_harvest == .
	replace value_harvest = val_harvest_est if value_harvest == .
	gen value_harvest_hh= price_unit_hh*quantity_harvested 
	replace value_harvest_hh=price_kg_hh*quant_harv_kg if value_harvest_hh==.
	replace value_harvest_hh=value_harvest if value_harvest==.
	
//A few situations (mainly cocoa) where the grower estimated price is substantially below the area median.	

	//Replacing conversions for unknown units
	replace val_unit_est = value_harvest/quantity_harvested if val_unit_est==.
	replace val_kg_est = value_harvest/quant_harv_kg if val_kg_est == .

preserve
//ALT note to double check and see if the changes to valuation mess this up.
	replace val_kg = val_kg_est if val_kg==.
	collapse (mean) val_kg=price_kg conv_fact, by(hhid cropcode)
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_prices_kg.dta", replace //Backup for s-e income.
restore
preserve
	//ALT 02.10.22: NOTE: This should be changed to ensure we get all household values rather than just ones with recorded harvests (although I imagine the number of households that paid in a crop they did not harvest is small)
	replace val_unit = val_unit_est if val_unit==.
	collapse (mean) val_unit=price_unit, by (hhid cropcode unit size condition)
	drop if unit == .
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_prices_for_wages.dta", replace //This gets used for self-employment income
restore
	//still-to-harvest value
	gen same_unit=unit==sa3iq6d2 & size==sa3iq6d4 & condition==sa3iq6d2a & unit!=.
	replace price_unit = value_harvest/quantity_harvested if same_unit==1 & price_unit==.
	//ALT 05.12.21: I feel like we should include the expected harvest.
	//Addendum 10.14: Unfortunately we can only reliably do this for annual crops because the question for tree crops was asked in the planting survey; estimates are probably not reliable.
	//Addendum to addendum 9.28.22: The plant survey also asks about temporary crops, not just tree crops. This was causing estimated harvests to be far too high.
	//Addendum to addendum 9.30.24: Adding an additional criterion to only include harvests that had been started, some long-haul crops like cassava and yam were probably not intended for harvest this year.
	replace sa3iq6d1 = . if sa3iq6d1 > 19000 //This corrects two plots, one where the household anticipates harvesting 20,000 paint rubbers of peppers (2000x current harvest) and another that anticipates 722,500 bags of rice.
	drop unit size condition quantity_harvested
	ren sa3iq6d2 unit
	ren sa3iq6d4 size
	ren sa3iq6d2a condition
	ren sa3iq6d1 quantity_harvested
	//replace quantity_harvested = . if hhid == 220016 & plot_id==2 & cropcode==1121 //One obs of 2000 pickups on a quarter of a hectare. Planting estimate was 1 pickup; likely a unit typo. //ALT: Excluded by the 9.30.24 update
	gen quant_harv_kg2 = quantity_harvested * sa3iq6d_conv
	replace quant_harv_kg2 = quantity_harvested * conv_fact if same_unit == 1
	drop conv_fact
	merge m:1 cropcode unit size condition using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", nogen keep(1 3)
	replace quant_harv_kg2= quantity_harvested*conv_fact if quant_harv_kg2 == .
	gen val_harv2 = 0
	gen val_harv2_hh=0
	recode quant_harv_kg2 quantity_harvested value_harvest (.=0) //ALT 02.10.22: This is causing people with "still to harvest" values getting missing where they should have something.
	replace val_harv2=quantity_harvested*price_unit if val_harv2==0 & same_unit==1  //Use household price for consistency. (see line 959)
	replace val_harv2=quant_harv_kg*price_kg if val_harv2==0 
	replace val_harv2_hh = quantity_harvested*price_unit_hh 
	replace val_harv2_hh = quant_harv_kg * price_kg_hh if val_harv2_hh==0
	gen missing_unit =val_harv2 == 0

	replace quant_harv_kg = quant_harv_kg+quant_harv_kg2 if sa3iq3==1
	replace quant_harv_kg = quant_harv_kg2 if sa3iq3==1 & quant_harv_kg==. //this annoying two-step here to deal with how stata processes missing values and the desire to avoid introducing spurious 0s.
	replace value_harvest = value_harvest+val_harv2 if sa3iq3==1 
	replace value_harvest = val_harv2 if sa3iq3==1 & value_harvest==.
	replace value_harvest_hh = value_harvest_hh + val_harv2_hh if sa3iq3==1
	replace value_harvest_hh = val_harv2_hh if sa3iq3==1 & value_harvest==.
	replace ha_harvest = ha_planted if sa3iq3==1 & !inlist(quant_harv_kg2,0,.) & !inlist(sa3iq4c, 1, .)
	replace cropcode = 1124 if crop_code_11f==1124 //Removing three-leaved yams from yams. 
	gen lost_crop=inrange(sa3iq4,1,5) & s11fq0==1
	gen lost_drought = sa3iq4==1 | sa3iq4c==2
	gen lost_flood = sa3iq4==2 | sa3iq4c==3
	gen lost_pest = sa3iq4==3 | sa3iq4c==4
	gen no_harvest = sa3iq4 >= 6 & sa3iq4 <=10
	collapse (sum) quant_harv_kg value_harvest* /*val_harvest_est*/ ha_planted ha_harvest number_trees_planted percent_field (max) lost_pest lost_flood lost_drought no_harvest use_imprv_seed, by(zone state lga sector ea hhid plot_id cropcode purestand field_size gps_meas)
	bys hhid plot_id : gen count_crops = _N
	recode ha_planted (0=.)
	replace purestand = 0 if count_crops > 1 & purestand==1 //Three plots no longer considered monocropped after the disaggregation.
	bys hhid plot_id : egen percent_area = sum(percent_field)
	bys hhid plot_id : gen percent_inputs = percent_field/percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	replace ha_harvest=. if (ha_harvest==0 & no_harvest==1) | (ha_harvest==0 & quant_harv_kg>0 & quant_harv_kg!=.)
	replace value_harvest =. if value_harvest==0 & (no_harvest==1 | (quant_harv_kg!=0 & quant_harv_kg!=.))
	replace quant_harv_kg = . if quant_harv_kg==0 & no_harvest==1
	drop no_harvest
	drop if (ha_planted==0 | ha_planted==.) & (ha_harvest==0 | ha_harvest==.) & (quant_harv_kg==0 | quant_harv_kg==.)
	merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm*)
		//We remove small planted areas from the sample for yield, as these areas are likely undermeasured/underestimated and cause substantial outliers. The harvest quantities are retained for farm income and production estimates. 
	gen ha_harv_yld = ha_harvest if ha_planted >=0.05
	gen ha_plan_yld = ha_planted if ha_planted >=0.05
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta",replace



********************************************************************************
* GROSS CROP REVENUE *
********************************************************************************
**Creating median crop prices at different geographic levels to use for imputation**
use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestw4.dta", clear
//ren cropcode crop_code Note to do this @ end.
ren sa3iiq6 sales_value
recode sales_value (.=0)
/*DYA*/ ren sa3iiq5a quantity_sold
/*DYA*/ ren sa3iiq1c unit
		ren sa3iiq1d size
		ren sa3iiq1b condition
*renaming unit code for merge 
*merging in conversion factors
merge m:1 cropcode unit condition size using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", gen(cf_merge)
//ALT 02.15.22: More accurate conversion, hopefully
replace conv_fact = sa3iiq1_conv if sa3iiq1_conv!=.
gen kgs_sold= quantity_sold*conv_fact
//ALT 02.15.22: Needed for crop value lost
recode cropcode (2170=2030) (2142 = 2141) (1121 1122 1123 /*1124*/=1120) //Only things that carry over from W3 are bananas/plantains, yams, and peppers. The generic pepper category 2040 in W3 is missing from this wave. 10.09.24: Excluding three leaved yams.
label define CROPCODE 1120 "1120. YAM", replace
ren cropcode crop_code
collapse (sum) sales_value kgs_sold, by (hhid crop_code)
lab var sales_value "Value of sales of this crop"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropsales_value.dta", replace 


use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
ren cropcode crop_code
collapse (sum) value_harvest, by (hhid crop_code) 
merge 1:1 hhid crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropsales_value.dta"
recode  value_harvest sales_value  (.=0)
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
collapse (sum) value_harvest value_crop_sales, by (hhid crop_code)
ren value_harvest value_crop_production 
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production.dta", replace 

//Legacy code 
collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
replace proportion_cropvalue_sold = . if proportion_cropvalue_sold > 1 //HS 4/12/23: Where proportion is greater than 1 (i.e. where value sold >0 but value harvested = 0), repace with empty "."
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestw4.dta", clear
ren sa3iiq18a share_lost //ALT 02.15.22: This is quantity lost, not percentage. 
ren sa3iiq1c unit
ren sa3iiq1d size
ren sa3iiq1b condition
merge m:1 cropcode unit condition size using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", nogen keep(1 3)
//ALT 02.15.22: I think it's probably better to do this as units, not kg, but I think that requires a little restructuring to make that process make sense.
recode cropcode (2170=2030) (2142 = 2141) (1121 1122 1123 1124=1120) //Only things that carry over from W3 are bananas/plantains, yams, and peppers. The generic pepper category 2040 in W3 is missing from this wave.
label define CROPCODE 1120 "1120. YAM", replace
replace conv_fact = sa3iiq1_conv if sa3iiq1_conv!=.
recode share_lost (.=0)
gen kgs_lost = share_lost * conv_fact 
merge m:1 hhid cropcode using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_prices_kg.dta", nogen keep(1 3)
gen crop_value_lost = kgs_lost * val_kg
collapse (sum) crop_value_lost, by (hhid)
lab var crop_value_lost "Value of crops lost between harvest and survey time"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_crop_losses.dta", replace

********************************************************************************
* CROP EXPENSES *
********************************************************************************
//See NGA W3

	*********************************
	* 			LABOR				*
	*********************************
use "${Nigeria_GHS_W4_raw_data}/sect11c1b_plantingw4.dta", clear //Hired Labor
	ren plotid plot_id
	ren s11c1q2 numberhiredmale
	ren s11c1q5 numberhiredfemale
	ren s11c1q8 numberhiredchild
	ren s11c1q3 dayshiredmale
	ren s11c1q6 dayshiredfemale
	ren s11c1q9 dayshiredchild
	ren s11c1q4 wagehiredmale
	ren s11c1q7 wagehiredfemale
	ren s11c1q10 wagehiredchild
	ren s11c1q14a numbernonhiredmale
	ren s11c1q14b numbernonhiredfemale
	ren s11c1q14c numbernonhiredchild
	ren s11c1q15a daysnonhiredmale
	ren s11c1q15b daysnonhiredfemale
	ren s11c1q15c daysnonhiredchild
	keep zone state lga ea hhid plot_id *hired*
	gen season="pp"
tempfile postplanting_hired
save `postplanting_hired'

use "${Nigeria_GHS_W4_raw_data}/secta2b_harvestw4.dta", clear
ren plotid plot_id
	ren sa2bq2 numberhiredmale 
	ren sa2bq3 dayshiredmale
	ren sa2bq5 numberhiredfemale
	ren sa2bq6 dayshiredfemale
	ren sa2bq8 numberhiredchild
	ren sa2bq9 dayshiredchild
	ren sa2bq4 wagehiredmale //Wage per person/per day
	ren sa2bq7 wagehiredfemale
	ren sa2bq10 wagehiredchild
	ren sa2bq14a numbernonhiredmale
	ren sa2bq14b numbernonhiredfemale
	ren sa2bq14c numbernonhiredchild
	ren sa2bq15a daysnonhiredmale
	ren sa2bq15b daysnonhiredfemale
	ren sa2bq15c daysnonhiredchild
	keep zone state lga ea hhid plot_id *hired*
	gen season="ph"
append using `postplanting_hired'

unab vars : *female
local stubs : subinstr local vars "female" "", all
reshape long `stubs', i(zone state lga ea hhid plot_id season) j(gender) string
reshape long number days wage, i(zone state lga ea hhid plot_id gender season) j(labor_type) string
gen val = days*number*wage
//farm labor
preserve 
	drop if strmatch(gender, "child") //Not keeping track of hired labor for some reason.
	collapse (sum) days number val, by(hhid gender)
	gen hired_ = days*number
	gen wage_paid_aglabor_ = val/(days*number)
	keep hhid gender hired_ wage_paid_aglabor_
	reshape wide hired_ wage_paid_aglabor_, i(hhid) j(gender) string
	egen hired_all=rowtotal(hired*)
	egen wage_paid_aglabor=rowtotal(wage*)
	lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
	lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers (local currency)"
	lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
	lab var hired_all "Total hired labor (number of person-days)" 
	lab var hired_female "Total hired women's (number of person-days)"
	lab var hired_male "Total hired men's labor (number of person-days)"
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_ag_wage.dta", replace 
restore

merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3) keepusing(weight_pop_rururb)
merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
gen plotweight = weight*field_size
recode wage (0=.)
gen obs=wage!=.
*Median wages

foreach i in zone state lga ea hhid {
preserve
	bys `i' season gender : egen obs_`i' = sum(obs)
	collapse (median) wage_`i'=wage  [aw=plotweight], by (`i' season gender obs_`i')
	tempfile wage_`i'_median
	save `wage_`i'_median'
restore
}
preserve
collapse (median) wage_country = wage (sum) obs_country=obs [aw=plotweight], by(season gender)
tempfile wage_country_median
save `wage_country_median'
restore

drop obs plotweight
tempfile all_hired_ex
save `all_hired_ex'

//Family labor
use "${Nigeria_GHS_W4_raw_data}/sect11c1a_plantingw4.dta", clear
	drop if s11c1q1a==2
	ren plotid plot_id
	ren indiv pid
	ren s11c1q1b days
keep zone state lga sector ea hhid plot_id pid days
gen season="pp"
tempfile postplanting_family
save `postplanting_family'

use "${Nigeria_GHS_W4_raw_data}/secta2a_harvestw4.dta", clear
	ren plotid plot_id
	ren indiv pid
	ren sa2aq1b days
keep zone state lga sector ea hhid plot_id pid days
gen season="ph"
tempfile harvest_family
save `harvest_family'


use "${Nigeria_GHS_W4_raw_data}/sect1_plantingw4.dta", clear
ren indiv pid
gen male = s1q2==1
gen age = s1q6
keep hhid pid age male
tempfile members
save `members', replace

use `postplanting_family',clear
append using `harvest_family'
drop if days==.
merge m:1 hhid pid using `members', nogen keep(3) //183 unmatched
gen gender="child" if age<16
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
gen number=1 // ALT 05.01.23
keep zone state lga sector ea hhid plot_id season gender days labor_type /*ALT 05.01.23*/ number 
append using `all_hired_ex'
	//ALT 05.01.23: 
	drop if number == . //Empty obs
	replace days = days * number //if labor_type!="family"
	//end ALT 05.01.23
foreach i in zone state lga ea hhid {
	merge m:1 `i' gender season using `wage_`i'_median', nogen keep(1 3) 
}
	merge m:1 gender season using `wage_country_median', nogen keep(1 3) //~234 with missing vals b/c they don't have matches on pid
	recode obs* (.=0)
replace wage=wage_hhid if wage==.
gen wage_missing = wage==. //ALT 05.02.23
foreach i in country zone state lga ea { 
	replace wage = wage_`i' if obs_`i' > 9 & wage_missing==1 //ALT 05.02.23
}
egen wage_sd = sd(wage_hhid), by(gender season)
egen mean_wage = mean(wage_hhid), by(gender season)
/* The below code assumes that wages are normally distributed and values below the 0.15th percentile and above the 99.85th percentile are outliers, keeping the median values for the area in those instances.
In reality, what we see is that it trims a significant amount of right skew - the max value is 14 stdevs above the mean while the min is only 1.15 below. 
*/
//replace wage=wage_hhid if wage_hhid !=. & abs(wage_hhid-mean_wage)/wage_sd <3 //Using household wage when available, but omitting implausibly high or low values. Trims about 5,000 hh obs, max goes from 80,000->35,000; mean 3,300 -> 2,600

replace val = wage*days if val==.
keep zone state lga sector ea hhid plot_id season days val labor_type gender number
//drop if val==. //Either days or number was missing, or both. //ALT 20
merge m:1 plot_id hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers", nogen keep(3) keepusing(dm_gender) //ALT: 261 entries across 65 plots are unmatched here; all are post-planting labor only, and I'm not sure why they don't show up in the plot roster
collapse (sum) number val days, by(hhid plot_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Naira)"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_=days, by (hhid plot_id labor_type)
	reshape wide labor_, i(hhid plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_labor_days.dta",replace //AgQuery
restore
//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	//append using `inkind_payments' //Only available at hh level in W4
	collapse (sum) val, by(hhid plot_id exp dm_gender)
	gen input="labor"
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_labor.dta", replace //this gets used below.
restore	
//And now we go back to wide
collapse (sum) val, by(hhid plot_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid plot_id season dm_gender) j(labor_type) string
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_labor.dta", replace

	*************************************************************
	* SEED, LAND, ANIMALS, MACHINES, CHEMICALS, AND FERTILIZERS	*
	*************************************************************
	***Seeds***
use "${Nigeria_GHS_W4_raw_data}/sect11e1_plantingw4.dta", clear
ren s11eq21 valseedexp
gen improved = mod(seedid, 2)==1 //All "improved" codes end in 1
collapse (sum) valseedexp, by(hhid cropcode improved)
tempfile seedvals
save `seedvals'
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta", clear
ren plotid plot_id 
gen improved=s11fq3b==1
replace improved = s11fq7a==1 if s11fq3b==.
preserve //This is for the monocropped thing; need to integrate it overall.
keep hhid plot_id cropcode improved
//ren cropcode crop_code 
tempfile imprv_seeds
save `imprv_seeds'
restore
preserve
replace cropcode=1120 if inrange(cropcode, 1121,1123) //10.24 yam update 
	label define CROPCODE 1120 "1120. YAM", replace
	//backwards compatibility
	collapse (max) imprv_seed_ = improved, by(hhid cropcode)
	ren cropcode crop_code
	merge m:1 crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", nogen keep(3)
	keep hhid crop_name imprv_seed_
	reshape wide imprv_seed_, i(hhid) j(crop_name) string	
	//recode imprv_seed* (.=0)
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_imprv_seed_by_crop.dta", replace
restore
merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(1 3)
merge m:1 hhid cropcode improved using `seedvals', nogen keep(1 3) //885 not matched from master
gen crop_area_planted=s11fq1/100*field_size
bys hhid plot_id : egen total_area_planted = sum(crop_area_planted)
replace crop_area_planted = (crop_area_planted/total_area_planted)*field_size if total_area_planted>field_size
replace crop_area_planted = s11fq7 if crop_area_planted==. //Using number of trees etc. in place of area for tree crops; there's no overlap between plants with responses for s11fq7 and s11fq1, so mixing units is not a concern here.
bys hhid cropcode : egen total_crop_area = sum(crop_area_planted)
gen pct_crop_plot = crop_area_planted/total_crop_area
replace valseedexp = valseedexp*pct_crop_plot //89 still changed to missing because we don't have enough info.
collapse (sum) valseedexp, by(hhid plot_id)
reshape long valseed, i(hhid plot_id) j(exp) string
reshape long val, i(hhid plot_id exp) j(input) string
gen qty=1
gen unit=1
tempfile seeds
save `seeds' //Not going to do geographic medians for these guys b/c there's only 1 missing value.



	***Land Rent***
//ALT 12.29.19: This works the same for W3 and W4
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid plot_id)
tempfile planted_area
save `planted_area' 

use "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", clear
ren plotid plot_id
ren s11b1q27 cultivate
keep if cultivate==1 //No need for uncultivated plots
egen valplotrentexp=rowtotal(s11b1q13 s11b1q14)
merge 1:1 plot_id hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas", nogen keep(1 3) keepusing(field_size) //71 not matched from master.
merge 1:1 plot_id hhid using `planted_area'
gen qtyplotrentexp=field_size if valplotrentexp>0 & valplotrentexp!=.
replace qtyplotrentexp=ha_planted if qtyplotrentexp==. & valplotrentexp>0 & valplotrentexp!=. //as in quantity of land rented
gen qtyplotrentimp = field_size if qtyplotrentexp==.
replace qtyplotrentimp = ha_planted if qtyplotrentimp==. & qtyplotrentexp==.
keep zone state lga ea sector hhid plot_id valplotrent* qtyplotrent* 
reshape long valplotrent qtyplotrent, i(zone state lga ea sector hhid plot_id) j(exp) string
reshape long val qty, i(zone state lga ea sector hhid plot_id exp) j(input) string
gen unit=1 //dummy var
//gen itemcode=1 //dummy var
tempfile plotrents
save `plotrents'

	***Animal Rent***
use "${Nigeria_GHS_W4_raw_data}/secta11c2_harvestw4.dta", clear
//New W3 code
ren plotid plot_id
ren s11c2q21 qtyanmlexp //All in days
gen valanmlexp = s11c2q23
gen valfeedanmlexp = s11c2q25 //Assuming all feed values are explicit regardless of own/rented animal status.
gen qtyfeedanmlexp = valfeedanmlexp!=.
gen unitfeedanmlexp=0 //To exclude from geographic medians.
gen valfeedanmlimp=.
gen qtyfeedanmlimp=0
gen unitfeedanmlimp=0
gen valanmlimp=. //ALT 05.05.21: We should count "own animal use" as an impicit cost We need a per-day cost estimate, though
gen qtyanmlimp=s11c2q20
//We can't do any imputation for machinery, so we don't need to include those.
gen unitanmlexp=1 //Dummies for the reshape
gen unitanmlimp=1
keep unit* val* qty* hhid plot_id zone state lga ea 
reshape long unitanmlrent valanml qtyanml unitfeedanml valfeedanml qtyfeedanml, i(hhid plot_id) j(exp) string
reshape long val unit qty, i(hhid plot_id exp) j(input) string 
preserve
	keep if strmatch(input, "feedanml")
	tempfile anmlfeed
	save `anmlfeed'
restore
keep if strmatch(input, "anml")
tempfile anmlrenttemp
save `anmlrenttemp' 
keep if strmatch(exp,"exp")
gen price = val/qty
gen obs=price!=. 
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
gen plotweight = weight*field_size
foreach i in zone state lga ea hhid {
preserve
	bys `i' : egen obs_`i' = sum(obs)
	collapse (median) price_`i'=price [aw=plotweight], by (`i' input obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
}

preserve
bys input unit : egen obs_country = sum(obs)
collapse (median) price_country = price [aw=plotweight], by(input unit obs_country)
tempfile price_country_median
save `price_country_median'
restore

use `anmlrenttemp', clear
gen price = val/qty
foreach i in zone state lga ea hhid {
	merge m:1 `i' input using `price_`i'_median', nogen
}
merge m:1 input using `price_country_median', nogen

replace price = price_hhid if price_hhid!=.
gen price_missing = price==.
foreach i in country zone state lga ea {
	replace price = price_`i' if price_missing==1 & obs_`i'>9
}
replace val = price*qty if val==.
keep zone state lga ea hhid plot_id input exp val
tempfile anmlrent
save `anmlrent'


	***Fertilizers and Ag Chemicals***
//Changes in structure have made this different from per-ha expenses section (they used to be the same)
//secta11c3 asks for total household purchases; the plot Q's asked for amount used. Thus, the plots have
//explicit and implicit costs (can include subsidized fertilizer/free fertilizer from other sources, or fertilizer leftover from previous season)
//while the crop expenses section seems designed to capture only the explicit costs. So I stick with secta11c3 here and use plot data in per-ha costs


use "${Nigeria_GHS_W4_raw_data}/secta11c3_harvestw4.dta", clear
gen qty=s11c3q4a*s11c3q4_conv
ren s11c3q5 val
ren s11c3q4b unit
recode unit (4=3) (2 10 11 12 13 30 31 50 51 52=1) //Everything has been converted to kg/L
replace val=s11c3q10 if inputid==7 | inputid==8 //Equipment rental costs 
//Now we have all hhs for the value calculations and can keep track of implicit/explicit costs later. This'll partially correct for the fact that
//the enumerators stopped asking about free inputs in W3.
keep zone state lga sector ea hhid inputid qty val unit
/*merge 1:1 hhid inputid using `impl_inputs'
replace cost_implicit=0 if _merge!=2
drop _merge
gen exp="exp" if cost_implicit==0
replace exp="imp" if cost_implicit==1 */
//ALT 07.03.20 Note, if _merge==1, this implies that the hh bought inputs but didn't use them. 
gen input = "orgfert" if inputid==1
replace input = "npk_fert" if inputid==2
replace input = "urea" if inputid==3
replace input = "other_fert" if inputid==4
replace input = "pest" if inputid==5
replace input = "herb" if inputid==6
replace input = "mech" if inputid==7 | inputid==8
replace qty = 0 if inputid==7 | inputid==8
replace unit = 0 if inputid==7 | inputid==8
drop inputid
preserve
	keep if strmatch(input,"mech") //We'll add these back in after we do prices
	collapse (sum) val, by(hhid input qty unit)
	tempfile mechrenttemp
	save `mechrenttemp'
	use "${Nigeria_GHS_W4_raw_data}/secta11c2_harvestw4.dta", clear
	gen use_mech=s11c2q27==1
	ren plotid plot_id
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)
	gen mech_area = field_size*use_mech 
	bys hhid : egen total_mech_area = sum(mech_area)
	gen frac_mech_area = mech_area/total_mech_area 
	merge m:1 hhid using `mechrenttemp', nogen 
	replace val=val*frac_mech_area if frac_mech_area!=.
	keep if val!=.
	keep zone state lga ea hhid plot_id qty unit input val 
		gen exp="exp"
	tempfile mechrent
	save `mechrent'
restore
drop if strmatch(input,"mech")
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb)
replace weight=0 if weight==.
gen price = val/qty
recode price (0=.)
gen obs=price!=.
tempfile phys_inputs
save `phys_inputs'

drop if unit == 0 | unit==. //Dropping things that don't have units
foreach i in zone state lga ea hhid {
preserve
	bys `i' input unit : egen obs_`i' = sum(obs)
	collapse (median) price_`i'=price [aw=weight_pop_rururb], by (`i' input unit obs_`i')
	tempfile price_`i'_median
	save `price_`i'_median'
restore
}

preserve
bys input unit : egen obs_country = sum(obs)
collapse (median) price_country = price [aw=weight_pop_rururb], by(input unit obs_country)
tempfile price_country_median
save `price_country_median'
restore

keep hhid input qty
ren qty hhqty
reshape wide hhqty, i(hhid) j(input) string //Determining implicit ratios
tempfile hhqty
save `hhqty'

use "${Nigeria_GHS_W4_raw_data}/secta11c2_harvestw4.dta", clear
gen qtyherb=s11c2q11a*s11c2q11_conv 
gen qtypest=s11c2q2a*s11c2q2_conv 
gen qtynpk_fert=s11c2q37a*s11c2q37a_conv 

gen qtyurea = s11c2q38a*s11c2q38a_conv
gen qtyorgfert = s11dq37a*s11c2q37_conv //This looks wrong but it isn't
gen qtyother_fert=s11c2q39a*s11c2q39a_conv 
ren s11c2q11b unitherb
ren s11c2q2b unitpest
ren s11c2q37b unitnpk_fert
ren s11c2q38b uniturea
ren s11c2q39b unitother_fert
ren s11dq37b unitorgfert
ren plotid plot_id 
replace qtyurea = . if uniturea == 12 & s11c2q38a > 1000
preserve
collapse (sum) qty*, by(hhid)
merge 1:1 hhid using `hhqty'
reshape long hhqty qty, i(hhid) j(input) string
recode hhqty qty (.=0)
gen exp_ratio = hhqty/qty if qty!=0
drop if exp_ratio==.
replace exp_ratio = 1 if exp_ratio > 1
//"hhqty" is the amount purchased by the household, qty is the amount used. If hhqty > qty, the household bought more than it used, and we can assume it paid for all of its inputs.
//if hhqty < qty, the household used more than it bought and so some proportion of the plot inputs come from leftover or free supplies and should be considered implicit.
//if hhqty > 0 but qty==0, the household bought but did not use, and those expenses don't get considered (might be an issue for panel households, because those purchases would become implicit next season 
//but were never accounted for as a household purchase)

tempfile exp_ratios
save `exp_ratios'
restore

recode unit* (4=3) (2 10 11 12 13 30 31 50 51 52=1) //Everything has been converted to kg/L
keep zone state lga ea hhid plot_id qty* unit* 
reshape long qty unit, i(zone state lga ea hhid plot_id) j(input) string

foreach i in zone state lga ea hhid {
	merge m:1 `i' input unit using `price_`i'_median', nogen keep(1 3) 
}
	merge m:1 input unit using `price_country_median', nogen keep(1 3)
	recode price_hhid (.=0)
	gen price=price_hhid
foreach i in country zone state lga ea {
	replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
}
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
gen val = qty*price
drop if val==0 | val==.
merge m:1 hhid input using `exp_ratios', nogen keep(1 3)
recode exp_ratio (.=0) //If there's no match, the hh recorded using an input but didn't provide any information related to its purchase 
gen qtyexp = qty*exp_ratio 
gen qtyimp = qty-qtyexp 
gen valexp = val*exp_ratio 
gen valimp = val-valexp
gen unitimp = unit
gen unitexp = unit
//Fertilizer units
preserve
//We can estimate how many nutrient units were applied for most fertilizers; dry urea is 46% N and NPK can have several formulations; we go with a weighted average of 18-12-11 based on https://africafertilizer.org/#/en/vizualizations-by-topic/consumption-data/
gen n_kg = qty*strmatch(input, "npk_fert")*0.18 + qty*strmatch(input, "urea")*0.46
gen p_kg = qty*strmatch(input, "npk_fert")*0.12
gen k_kg = qty*strmatch(input, "npk_fert")*0.11
gen n_org_kg = qty*strmatch(input,"orgfert")*0.01
la var n_kg "Kg of nitrogen applied to plot from inorganic fertilizer"
la var p_kg "Kg of phosphorus applied to plot from inorganic fertilizer"
la var k_kg "Kg of potassium applied to plot from inorganic fertilizer"
la var n_org_kg "Kg of nitrogen from manure and organic fertilizer applied to plot"
gen npk_kg = qty*strmatch(input, "npk_fert")
gen urea_kg = qty*strmatch(input, "urea")
la var npk_kg "Total quantity of NPK fertilizer applied to plot"
la var urea_kg "Total quantity of urea fertilizer applied to plot"
collapse (sum) *kg, by(ea hhid plot_id)
tempfile fert_units
save `fert_units'
restore
keep zone state lga ea hhid plot_id input *exp *imp

reshape long qty val unit, i(zone state lga ea hhid plot_id input) j(exp) string
replace input = "inorg" if strmatch(input,"npk_fert") | strmatch(input,"urea") | strmatch(input, "other_fert")

//merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)

//merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb)
append using `mechrent'
append using `plotrents'
append using `anmlrent'
append using `anmlfeed'
append using `seeds'
merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers",nogen keep(3) keepusing(dm_gender) //This drops a substantial number of nonzero entries, but I can't figure out where the extra plots are coming from.
collapse (sum) val qty, by(hhid plot_id input exp dm_gender) 
preserve
	//Need this for quantities and not sure where it should go.
	keep if strmatch(input,"orgfert") | strmatch(input,"inorg") | strmatch(input,"herb") | strmatch(input,"pest")
	//Unfortunately we have to compress liters and kg here, which isn't ideal.
	collapse (sum) qty_=qty, by(hhid plot_id input)
	reshape wide qty_, i(hhid plot_id) j(input) string
	ren qty_inorg inorg_fert_kg
	ren qty_orgfert org_fert_kg
	ren qty_herb herb_kg
	ren qty_pest pest_kg
	la var inorg_fert_kg "Qty inorganic fertilizer used (kg)"
	la var org_fert_kg "Qty organic fertilizer used (kg)"
	la var herb_kg "Qty of herbicide used (kg/L)"
	la var pest_kg "Qty of pesticide used (kg/L)"
	merge 1:1 hhid plot_id using `fert_units', nogen
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_quantities.dta", replace
restore
append using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_labor.dta"
//Note to self: remove instances of dm_gender above
//drop dm_gender //Not all modules include this; may as well do it here instead.
//merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_"
collapse (sum) val, by (hhid plot_id exp input dm_gender)
tempfile hh_cost_inputs
save `hh_cost_inputs'
collapse (sum) val, by(hhid plot_id input exp dm_gender)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_long.dta", replace
collapse (sum) val_ = val, by(hhid plot_id exp dm_gender)
reshape wide val_, i(hhid plot_id dm_gender) j(exp) string
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs.dta", replace //legacy?

use "${Nigeria_GHS_W4_raw_data}/secta11c3q12_harvestw4.dta", clear //Transportation, lump sum for all inputs; 2502 not found in using, but the values are empty for all 
ren s11c3q12 val 
gen input = "trans"
gen exp = "exp" //Transportation is explicit 
collapse (sum) val, by(hhid exp input)
tempfile transportation
save `transportation' 
use `hh_cost_inputs', clear
collapse (sum) val, by(hhid exp input) 
append using `transportation'
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_inputs_long.dta", replace

//This version of the code retains identities for all inputs; not strictly necessary for later analyses.
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_long.dta", clear
ren val val_ 
reshape wide val_, i(hhid plot_id exp dm_gender) j(input) string
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender) j(exp) string
//tempfile hh_inputs_wide
//save `hh_inputs_wide'
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_wide.dta", replace //Used for monocrop plots

collapse (sum) val*, by(hhid)
unab vars3 : *_exp_male //just get stubs from one
local stubs3 : subinstr local vars3 "_exp_male" "", all
foreach i in `stubs3' {
	egen `i'_exp_hh = rowtotal(`i'_exp_male `i'_exp_female `i'_exp_mixed)
	egen `i'_imp_hh=rowtotal(`i'_exp_hh `i'_imp_male `i'_imp_female `i'_imp_mixed)
}
egen val_exp_hh=rowtotal(*_exp_hh)
egen val_imp_hh=rowtotal(*_imp_hh)
drop val_mech_imp* /*val_trans_imp*/ val_feedanml_imp* //Not going to have any data 
//Note: this version does not have transportation costs because we don't have them disaggregated by gender.
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_inputs_verbose.dta", replace


//We can do this more simply by:
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_long.dta", clear
//back to wide
drop input
collapse (sum) val, by(hhid plot_id exp dm_gender)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender2) j(exp) string
ren val* val*_
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
merge 1:1 plot_id hhid using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid plot_id) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by(hhid)
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_inputs.dta", replace

**


********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************

//
/*ALT 10.09.24: This is old code; will be integrated into the main plot files. 
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
	keep if purestand==1 & relay!=1 //For now, omitting relay crops.
	//preserve 
	merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_wide.dta", nogen keep(3)
	//merge 1:1 ea hhid plot_id using `fert_units', nogen keep(1 3)
	merge 1:1 hhid plot_id cropcode using `imprv_seeds', nogen keep(1 3)
	ren plot_id plotid
	merge 1:1 hhid plotid using "${Nigeria_GHS_W4_raw_data}\nga_plotgeovariables_y4", nogen keep(3)
	merge 1:1 hhid plotid using "${Nigeria_GHS_W4_raw_data}\sect11b1_plantingw4.dta", nogen keep(3)

	drop s11b1q2-s11b1q37b 
	ren s11b1q39 irrigation 	
	drop s11b1q40-s11b1q43_os
	ren s11b1q44 soil_type
	drop s11b1q44_os 
	ren s11b1q45 soil_quality
	ren s11b1q46 slope
	ren s11b1q47 erosion
	drop s11b1q48_1-s11b1q48_os
	ren s11b1q49 erosion_control
	drop s11b1q50_1 - s11b1q27 
	ren s11b1q11a mech_landprep
	drop s11b1q11b s11b1q11b_os
	recode /*units*/ improved irrigation mech_landprep erosion_control erosion (. 2=0)
	foreach i in val_anml val_feedanml val_herb val_inorg val_labor val_mech val_orgfert val_pest val_plotrent val_seed {
		recode `i'_exp `i'_imp (.=0)
		gen `i' = (`i'_exp+`i'_imp)/field_size
		drop `i'_exp `i'_imp
	}
	/*
	replace n_units = n_units/field_size
	replace p_units = p_units/field_size
	replace k_units = k_units/field_size
	replace n_units_org = n_units_org/field_size
	gen kg_ha = quant_harv_kg/field_size 
	gen yield_unit_n = kg_ha/n_units
	la var n_units "Nitrogen kg/ha"
	la var p_units "Phosphorus kg/ha"
	la var k_units "Potassium kg/ha"
	la var n_units_org "Kg/ha of manure nitrogen applied, estimated"
	la var yield_unit_n "Kg of yield per kg of N per ha"
	save "${Nigeria_GHS_W4_created_data}/nga_plots_for_regression.dta", replace
	*/

	//merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs.dta", nogen keep(1 3)
	/*Easy way, starting from previous line
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_wide.dta", nogen keep(1 3) //If we want to keep identities of all inputs
	merge m:1 cropcode using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", nogen keep(3) //Filter down to crops we have names for.
	local listvars = "firstvar-lastvar" //Note to look this up
	foreach i in `listvars' {
		ren `i' `i'_
	}
	gen grew_ = 1 //Only plots where <cropname> was grown are here
	reshape wide *_, i(hhid cropcode) j(cropname)
	recode grew_* (.=0)
	//ALT note that the nomenclature here will be different than is standard in these files, but this is quicker and, I think, easier than the way we currently do it (one file to merge in at the end instead of several). I'm not using these files for agquery.
*/
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_monocrop_plots.dta", replace
*/

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
	keep if purestand==1
	//File now has 2550 unique entries after omitting the crops that were "replaced" - it should be noted that some these were grown in mixed plots and only one crop was lost. Which is confusing.
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono
	
	* HS 4/14/23: Not recognizing topcrop = "yam" because there are "1121. YAM, WHITE", "1122. YAM, YELLOW", "1123. WATER YAM", "1124. YAM, THREE LEAVED"
	* Copied from above:
	//replace cropcode=1120 if inrange(cropcode, 1121,1124)
	//label define CROPCODE 1120 "1120. YAM", replace
	
forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	di "`cn_full'"
	keep if cropcode==`c'			
	ren monocrop_ha `cn'_monocrop_ha
	drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==.	
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	capture save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	/*
	gen dm_male = dm_gender==1 
	gen dm_female = dm_gender==2
	gen dm_mixed = dm_gender==3
	*/
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (Naira)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	collapse (sum) *monocrop* kgs_harv* val_harv* (max) dm*, by(hhid)
	foreach i in kgs_harv_mono_`cn' val_harv_mono_`cn' {
	foreach j in male female mixed {
	replace `i'_`j' = . if dm_`j'==0
	}
	}
	recode `cn'_monocrop_ha* (0=.)
	drop dm*
	capture save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_`cn'_monocrop_hh_area.dta", replace
restore
}

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_long.dta", clear
foreach cn in $topcropname_area {
preserve
	di "`cn'"
	keep if strmatch(exp, "exp")
	drop exp
	levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid plot_id dm_gender) j(input) string
	ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	drop dm_gender
	reshape wide val*, i(hhid plot_id) j(dm_gender2) string
	merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_`cn'_monocrop.dta", nogen keep(3)
	recode val* (.=0)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_inputs_`cn'.dta", replace
restore
}

********************************************************************************
* APPLICATION RATES *
********************************************************************************
/*
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
collapse (sum) ha_planted, by(hhid plot_id) 
merge 1:1 hhid plot_id using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_quantities.dta", nogen 
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3)
//Winsorizing up here to avoid having to calculate this multiple times; national only 
drop if ha_planted == 0 | ha_planted == .
recode *kg (.=0)

_pctile ha_planted [aw=weight_pop_rururb], p($wins_lower_thres $wins_upper_thres)
gen w_ha_planted = ha_planted 
replace w_ha_planted =r(r1) if w_ha_planted < r(r1)   & w_ha_planted !=. &  w_ha_planted !=0 
replace w_ha_planted = r(r2) if  w_ha_planted > r(r2) & w_ha_planted !=.    

_pctile inorg_fert_kg [aw=weight_pop_rururb], p(95)
gen wins_inorg_fert_kg = inorg_fert_kg 
//replace wins_inorg_fert_kg = r(r1) if wins_inorg_fert_kg > r(r1) 
replace wins_inorg_fert_kg = . if wins_inorg_fert_kg > r(r1) 

unab vars : *kg 
local vars_nom : subinstr local vars "_kg" "", all 

foreach var in `vars_nom' {
	gen `var'_rate = `var'_kg / ha_planted 
	gen w_`var'_rate = `var'_kg / w_ha_planted 
	gen use_`var' = `var'_kg!=0
}

save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_application_rates.dta", replace
*/
********************************************************************************
* TLU (Tropical Livestock Units) *
********************************************************************************
**# Bookmark #1

use "${Nigeria_GHS_W4_raw_data}/sect11i_plantingw4.dta", clear
gen tlu=0.5 if (animal_cd==101|animal_cd==102|animal_cd==103|animal_cd==104|animal_cd==105|animal_cd==106|animal_cd==107|animal_cd==109)
replace tlu=0.3 if (animal_cd==108)
replace tlu=0.1 if (animal_cd==110|animal_cd==111)
replace tlu=0.2 if (animal_cd==112)
replace tlu=0.01 if (animal_cd==113|animal_cd==114|animal_cd==115|animal_cd==116|animal_cd==117|animal_cd==118|animal_cd==119|animal_cd==120|animal_cd==121)
replace tlu=0.7 if (animal_cd==122)
lab var tlu "Tropical Livestock Unit coefficient"
ren tlu tlu_coefficient
*Owned
ren animal_cd lvstckid
gen cattle=inrange(lvstckid,101,107)
gen smallrum=inlist(lvstckid,110,  111, 120)  //DYA.11.21.2020 no 119 in the options
gen largerum = inlist(lvstckid,101,102,103,104,105,106,107) // HKS 6.16.23
gen poultry=inrange(lvstckid,113,120)  //DYA.11.21.2020  "120" guinea fowl is poultry
gen other_ls=inlist(lvstckid,108,109, 122, 123) //DYA.11.21.2020   no 121
gen cows=inrange(lvstckid,105,105)
gen chickens=inrange(lvstckid,113,116)
ren s11iq6 nb_ls_stardseas
gen nb_cattle_stardseas=nb_ls_stardseas if cattle==1 
gen nb_smallrum_stardseas=nb_ls_stardseas if smallrum==1 
gen nb_poultry_stardseas=nb_ls_stardseas if poultry==1 
gen nb_other_ls_stardseas=nb_ls_stardseas if other_ls==1 
gen nb_cows_stardseas=nb_ls_stardseas if cows==1 
gen nb_chickens_stardseas=nb_ls_stardseas if chickens==1 
gen nb_ls_today =s11iq2a   //DYA.11.21.2020 This wave makes the distinction between animal owned and animal kept but in earlier waves there was not such distinction and it is more likely that in W1-3 we are counting animals owned and kept together (this could be why  tlu is much smaller in W4 is we use s11iq2 instead of s11iq2a which I am using now)
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_largerum_today=nb_ls_today if largerum==1 // HKS 6.16.23
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_stardseas = nb_ls_stardseas * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
ren s11iq16 nb_ls_sold 
ren s11iq17 income_ls_sales 
recode   tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_stardseas "Number of cattle owned at the begining of ag season"
lab var nb_smallrum_stardseas "Number of small ruminant owned at the begining of ag season"
lab var nb_poultry_stardseas "Number of cattle poultry at the begining of ag season"
lab var nb_other_ls_stardseas "Number of other livestock (dog, donkey, and other) owned at the begining of ag season"
lab var nb_cows_stardseas "Number of cows owned at the begining of ag season"
lab var nb_chickens_stardseas "Number of chickens owned at the begining of ag season"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_largerum_today "Number of large ruminant owned as of the time of survey" // HKS 6.16.23
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (dog, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_stardseas "Tropical Livestock Units at the begining of ag season"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_stardseas  "Number of livestock owned at the begining of ag season"
lab var nb_ls_stardseas  "Number of livestock owned at the begining of ag season"
lab var nb_ls_today "Number of livestock owned as of today"
lab var nb_ls_sold "Number of total livestock sold alive this ag season"
drop tlu_coefficient
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_TLU_Coefficients.dta", replace


********************************************************************************
* LIVESTOCK INCOME *
********************************************************************************
*Expenses
use "${Nigeria_GHS_W4_raw_data}/sect11j_plantingw4.dta", clear //ALT: This section has changed a lot - instead of enumerating by item, the questionnaire has costs in several columns
ren s11jq6 cost_vaccines_livestock
ren s11jq8 cost_vet_livestock
ren s11jq13 cost_water_livestock
ren s11jq17 cost_fodder_livestock
ren s11jq19 cost_hired_labor_livestock
ren s11jq21 cost_damage_livestock
ren s11jq23 cost_other_livestock

**cannot disaggregate costs by species in W3, but possible for W4
collapse (sum) cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock cost_other_livestock cost_vet_livestock cost_water_livestock cost_damage_livestock, by (hhid /*livestock_cd*/)
lab var cost_fodder_livestock "Cost for fodder for <livestock>"
lab var cost_vaccines_livestock "Cost for vaccines and veterminary treatment for <livestock>"
lab var cost_hired_labor_livestock "Cost for hired labor for <livestock>"
lab var cost_other_livestock "Cost for any other expenses for <livestock>"
lab var cost_water_livestock "Cost for water for <livestock>"
lab var cost_vet_livestock "Cost for veterinary services for <livestock>"
lab var cost_damage_livestock "Costs incurred for damage caused by <livestock>"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_expenses.dta", replace

//use "${Nigeria_GHS_W4_raw_data}/sect11k1_plantingw4.dta", clear //ALT: This file has dung and services. Do we need them?
use "${Nigeria_GHS_W4_raw_data}/sect11k2_plantingw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/sect11k3_plantingw4.dta"
//ren s11k2q4 milk_animals
//ren s11k3q4 poultry_owned 
gen produced_milkeggs = s11k2q1
replace produced_milkeggs = s11k3q1 if produced_milkeggs==.
drop if produced_milkeggs !=1
ren s11k2q2 months_producedmilk
recode months_producedmilk (.=0)
ren s11k2q4 qty_animals
replace qty_animals = s11k3q4 if qty_animals == .
ren s11k2q3 days_producedmilk
ren s11k2q5 quantity_daymilk
gen quantity_producedmilk = qty_animals*days_producedmilk*quantity_daymilk //*months_producedmilk ALT 01.05.20: Looks like this should be qty/month rather than qty/season
ren s11k2q10 qty_sold_weekrawmilk
ren s11k2q11 earnings_weekrawmilk
gen earnings_rawmilk = earnings_weekrawmilk*4.35*months_producedmilk //s11k2q11 asks for earnings/week; 4.35 is avg wks/month
ren s11k2q13 qty_sold_weekprocmilk
ren s11k2q14 earnings_weekprocmilk
gen earnings_procmilk=earnings_weekprocmilk*4.35*months_producedmilk 
recode earnings_rawmilk earnings_procmilk qty_sold_weekrawmilk qty_sold_weekprocmilk (.=0)
gen earnings_salesmilk=earnings_rawmilk+earnings_procmilk
gen quantity_sold_seasonmilk = qty_sold_weekprocmilk*4.35*months_producedmilk +  qty_sold_weekrawmilk*4.35*months_producedmilk

ren s11k3q2 months_producedeggs
ren s11k3q2a weeks_producedeggs
ren s11k3q3 days_producedeggs
gen quantity_producedeggs = days_producedeggs*weeks_producedeggs //*months_producedeggs 
ren s11k3q6 eggs_sold_3months
ren s11k3q4a eggs_laid_3months
ren s11k3q8 earnings_eggs_3months
gen price_per_egg = earnings_eggs_3months/eggs_sold_3months
gen quantity_sold_seasoneggs = eggs_sold_3months/eggs_laid_3months * quantity_producedeggs 
gen earnings_saleseggs = price_per_egg * quantity_sold_seasoneggs
//ALT: Because they only ask for sales for 3 months, I extrapolate total earnings by multiplying
//the proportion of eggs sold in the 3 month period times total eggs produced.

//ren prod_cd livestock_code
reshape long months_produced quantity_produced quantity_sold_season earnings_sales, i(hhid livestock_cd animal_cd) j(product, string)
drop if product=="milk" & s11k2q1!=1
drop if product=="eggs" & s11k3q1!=1
gen prod_cd = product=="milk"
recode prod_cd (0=2)
gen unit=3 if prod_cd==1 
replace unit=81 if prod_cd==2
label define PROD_CD 1 milk 2 eggs
label values prod_cd PROD_CD
gen price_unit = earnings_sales/quantity_sold_season
//ALT 01.05.20: TODO get labels defined for units, resolve issue with processed milk v raw milk for unit price.
keep hhid livestock_cd prod_cd months_produced quantity_produced unit quantity_sold_season earnings_sales price_unit qty_animals
recode months_produced quantity_produced quantity_sold_season earnings_sales (.=0)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_products.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_products", clear
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3)
collapse (median) price_unit [aw=weight_pop_rururb], by (livestock_cd prod_cd)
ren price_unit price_unit_median_country
//ren quantity_sold_season_unit unit
//replace price_unit_median_country = 100 if livestock_code == 1 & unit==1 //ALT: I don't know why this is here or what it's for.
//No median price available for small ruminants
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_products_prices_country.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_products", clear
merge m:1 livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_products_prices_country.dta", nogen keep(1 3)
keep if quantity_produced!=0
gen value_produced = price_unit * quantity_produced * months_produced
replace value_produced = price_unit_median_country * quantity_produced * months_produced if value_produced==.
replace value_produced = earnings_sales if value_produced==.
lab var price_unit "Price per liter (milk) or per egg per piece using local median prices if household did not sell"
gen value_milk_produced = quantity_produced * price_unit * months_produced if livestock_cd==1
replace value_milk_produced = quantity_produced * price_unit_median_country * months_produced if livestock_cd==1 & value_milk_produced==.
gen value_eggs_produced = quantity_produced * price_unit * months_produced if livestock_cd==5
replace value_eggs_produced = quantity_produced * price_unit_median_country * months_produced if livestock_cd==5 & value_eggs_produced==.
//gen value_other_produced = quantity_produced * price_unit * months_produced if livestock_cd!=1 & livestock_cd!=2
*Share of total production sold
gen sales_livestock_products = earnings_sales	
/*Agquery 12.01*/
gen sales_milk = earnings_sales if prod_cd==1
gen sales_eggs = earnings_sales if prod_cd==2
collapse (sum) value_milk_produced value_eggs_produced sales_livestock_products /*agquery*/ sales_milk sales_eggs, by (hhid)
**
*Share of production sold
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of livestock products that is sold" 
/*AgQuery 12.01*/
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
**
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_products.dta", replace

*Sales (live animals)
//ALT 12.13.19: Running these sections unchanged
use "${Nigeria_GHS_W4_raw_data}/sect11i_plantingw4.dta", clear
ren s11iq16 number_sold 
ren s11iq17 income_live_sales 
ren s11iq19a number_slaughtered_sold 
ren s11iq19b number_slaughtered_consumption 
ren s11iq11 value_livestock_purchases
recode number_sold income_live_sales number_slaughtered_sold number_slaughtered_consumption value_livestock_purchases (.=0)
gen number_slaughtered = number_slaughtered_sold + number_slaughtered_consumption 
lab var number_slaughtered "Number slaughtered for sale and home consumption"
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3)
keep if price_per_animal !=. & price_per_animal!=0
keep hhid weight_pop_rururb zone state lga ea livestock_cd number_sold income_live_sales number_slaughtered number_slaughtered_sold price_per_animal value_livestock_purchases
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", replace

*Implicit prices (based on observed sales)
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", clear
gen observation = 1
bys zone state lga ea livestock_cd: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone state lga ea livestock_cd obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_ea.dta", replace
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", clear
gen observation = 1
bys zone state lga livestock_cd: egen obs_lga = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone state lga livestock_cd obs_lga)
ren price_per_animal price_median_lga
lab var price_median_lga "Median price per unit for this livestock in the lga"
lab var obs_lga "Number of sales observations for this livestock in the lga"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_lga.dta", replace
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", clear
gen observation = 1
bys zone state livestock_cd: egen obs_state = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone state livestock_cd obs_state)
ren price_per_animal price_median_state
lab var price_median_state "Median price per unit for this livestock in the state"
lab var obs_state "Number of sales observations for this livestock in the state"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_state.dta", replace
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", clear
gen observation = 1
bys zone livestock_cd: egen obs_zone = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (zone livestock_cd obs_zone)
ren price_per_animal price_median_zone
lab var price_median_zone "Median price per unit for this livestock in the zone"
lab var obs_zone "Number of sales observations for this livestock in the zone"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_zone.dta", replace
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", clear
gen observation = 1
bys livestock_cd: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight_pop_rururb], by (livestock_cd obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_country.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_sales", clear
merge m:1 zone state lga ea livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_ea.dta", nogen
merge m:1 zone state lga livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_lga.dta", nogen
merge m:1 zone state livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_state.dta", nogen
merge m:1 zone livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_zone.dta", nogen
merge m:1 livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_lga if price_per_animal==. & obs_lga >= 10
replace price_per_animal = price_median_state if price_per_animal==. & obs_state >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
gen value_livestock_sales = value_lvstck_sold + value_slaughtered_sold
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered /*AgQuery 12.01*/value_slaughtered_sold, by (hhid)
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
/* AgQuery 12.01*/ gen prop_meat_sold = value_slaughtered_sold/value_slaughtered 
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_sales.dta", replace

*TLU (Tropical Livestock Units)
//The disease information is stored in sect j, which only has livestock code and not animal code
use "${Nigeria_GHS_W4_raw_data}/sect11i_plantingw4.dta", clear
keep if s11iq1==1
replace s11iq2=s11iq2a if s11iq2b==1 //ALT: If all animals kept by hh are owned, update ownership column with animals kept column value
gen tlu=0.5 if (animal_cd==101|animal_cd==102|animal_cd==103|animal_cd==104|animal_cd==105|animal_cd==106|animal_cd==107|animal_cd==109)
replace tlu=0.3 if (animal_cd==108)
replace tlu=0.1 if (animal_cd==110|animal_cd==111)
replace tlu=0.2 if (animal_cd==112)
replace tlu=0.01 if (animal_cd==113|animal_cd==114|animal_cd==115|animal_cd==116|animal_cd==117|animal_cd==118|animal_cd==119|animal_cd==120|animal_cd==121)
replace tlu=0.7 if (animal_cd==122)
collapse (sum) s11iq2 s11iq2a s11iq6 s11iq16 s11iq17 (mean) tlu s11iq3, by(zone state lga sector ea hhid livestock_cd)
lab var tlu "Tropical Livestock Unit coefficient"
merge 1:1 hhid livestock_cd using "${Nigeria_GHS_W4_raw_data}/sect11j_plantingw4.dta"
//ren animal_cd livestock_code
ren tlu tlu_coefficient
ren s11iq2 number_today
ren s11iq3 price_per_animal_est /* Estimated by the respondent */
ren s11iq6 number_start_agseas 
gen tlu_start_agseas = number_start_agseas * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
ren s11iq16 number_sold 
ren s11iq17 income_live_sales
ren s11jq3 lost_disease //Changed between W3 and W4

*Livestock mortality rate and percent of improved livestock breeds
egen mean_agseas = rowmean(number_today number_start_agseas)
gen animals_lost_agseas = lost_disease	// Only animals lost to disease; thefts and death by accidents not included
//gen species = (inlist(livestock_code,101,102,103,104,105,106,107)) + 2*(inlist(livestock_code,110,111)) + 3*(livestock_code==112) + 4*(inlist(livestock_code,108,109,122)) + 5*(inlist(livestock_code,113,114,115,116,117,118,120))
gen species=livestock_cd //ALT: Keeping this as originally coded for W4 to avoid losing information. Camels are a separate category.
preserve
*Now to household level
*First, generating these values by species
collapse (sum) number_today number_start_agseas animals_lost_agseas lost_disease lvstck_holding=number_today, by(hhid species)
egen mean_agseas = rowmean(number_today number_start_agseas)
*A loop to create species variables
//ALT: Order of these has changed for W4
foreach i in animals_lost_agseas mean_agseas lvstck_holding lost_disease{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==3
	gen `i'_pigs = `i' if species==4
	gen `i'_equine = `i' if species==2
	gen `i'_poultry = `i' if species==5
	gen `i'_camels = `i' if species==6 //ALT: Added for W4
}
*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
collapse (sum) number_today (firstnm) *lrum *srum *pigs *equine *poultry *camels, by(hhid)
*Overall any improved herd
drop number_today
*Generating missing variables in order to construct labels (just for the labeling loop below) 
foreach i in lvstck_holding animals_lost_agseas mean_agseas lost_disease{
	gen `i' = .
}
la var lvstck_holding "Total number of livestock holdings (# of animals)"
lab var animals_lost_agseas  "Total number of livestock  lost to disease"
lab var  mean_agseas  "Average number of livestock  today and 1  year ago"
lab var lost_disease "Total number of livestock lost to disease"
*A loop to label these variables (taking the labels above to construct each of these for each species)
foreach i in lvstck_holding animals_lost_agseas mean_agseas lost_disease{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
	lab var `i'_camels "`l`i'' - camels"
}
*Now dropping these missing variables, used to construct the labels above
recode lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) //ALT 09.16: I'm not sure where and how the missing values are introduced, but we get a lower number of animals overall if we omit this step. Not sure why.
gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry //Why not pigs?
la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
drop lvstck_holding animals_lost_agseas mean_agseas lost_disease
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_herd_characteristics", replace
restore
gen price_per_animal = income_live_sales / number_sold
recode price_per_animal (0=.)
merge m:1 zone state lga ea livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_ea.dta", nogen
merge m:1 zone state lga livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_lga.dta", nogen
merge m:1 zone state livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_state.dta", nogen
merge m:1 zone livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_zone.dta", nogen
merge m:1 livestock_cd using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_lga if price_per_animal==. & obs_lga >= 10
replace price_per_animal = price_median_state if price_per_animal==. & obs_state >= 10
replace price_per_animal = price_median_zone if price_per_animal==. & obs_zone >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_start_agseas = number_start_agseas * price_per_animal
gen value_today = number_today * price_per_animal
gen value_today_est = number_today * price_per_animal_est
collapse (sum) tlu_start_agseas tlu_today value_start_agseas value_today value_today_est, by (hhid)
lab var tlu_start_agseas "Tropical Livestock Units as of the start of the agricultural season"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_start_agseas "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
lab var value_today_est "Value of livestock holdings today, per estimates (not observed sales)"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_TLU.dta", replace


********************************************************************************
* FISH INCOME *
********************************************************************************
//ALT: W4 does not catalog catch by species - fish_cd is instead 
//wild-caught or cultured fish. There are relatively few entries 
//total, so these data are not likely to be reliable. For now
//I'm keeping the W3 structure, but we'll need to note that these results
//are different.
use "${Nigeria_GHS_W4_raw_data}/secta9a_harvestw4.dta", clear
ren fishid fish_code
ren sa9aq6b unit
ren sa9aq7 price_per_unit
recode price_per_unit (0=.)
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3)
collapse (median) price_per_unit [aw=weight_pop_rururb], by (/*fish_code*/ unit) //ALT: There's no point in using fishid because the only units for which there are price data are wild-caught
ren price_per_unit price_per_unit_median //ALT: The variance on these is incredibly high, likely because there's multiple species per unit and a low number of observations
//replace price_per_unit_median = . if fish_code==5 /* "Other */
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fish_prices_1.dta", replace /* Caught fish */


use "${Nigeria_GHS_W4_raw_data}/secta9a_harvestw4.dta", clear
keep if sa9aq1==1 //ALT: 163 "Yes" obs
ren fishid fish_code
ren sa9aq2 weeks_fishing
ren sa9aq3a quantity_caught /* on average per week */
ren sa9aq3b unit
/*ren sa9aq4b1 quantity_harvested /* on average per week */
ren sa9aq4b2 quantity_harvested_unit*/ //ALT: Caught/harvested are single column in W4 and distinguished by fishid
ren sa9aq6b sold_unit
ren sa9aq7 price_per_unit
/*ren sa9aq7b sold_unit_harvested
ren sa9aq8 price_per_unit_harvested*/
recode quantity_caught /*quantity_harvested*/ (.=0)
/*ren quantity_caught_unit unit*/
merge m:1 /*fish_code*/ unit using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fish_prices_1.dta", nogen keep(1 3) //ALT: Using median prices for wild-caught to price aquaculture units, 
gen value_fish_caught = (quantity_caught * price_per_unit) if unit==sold_unit                        				  //because no aquaculture price information was collected. Results are probably inaccurate.
replace value_fish_caught = (quantity_caught * price_per_unit_median) if value_fish_caught==.
replace value_fish_caught = value_fish_caught * weeks_fishing if fish_code==1 //ALT: No weeks_fishing records for aquaculture
//collapse (median) /*value_fish_harvest*/ value_fish_caught (max) weeks_fishing, by (hhid) //ALT: This gets accomplished with a reshape below
keep hhid fish_code weeks_fishing value_fish_caught
reshape wide weeks_fishing value_fish_caught, i(hhid) j(fish_code) 
egen weeks_fishing = rowtotal(weeks_fishing1 weeks_fishing2) //ALT: Theoretically combines aquaculture weeks and fishing weeks, but there are no values for aquaculture.
drop weeks_fishing1 weeks_fishing2
ren value_fish_caught1 value_fish_caught
ren value_fish_caught2 value_fish_harvest
recode value_fish_caught value_fish_harvest weeks_fishing (.=0)
lab var value_fish_caught "Value of fish caught over the past 12 months"
lab var value_fish_harvest "Value of fish harvested over the past 12 months"
lab var weeks_fishing "Total number weeks spent on fishing activites" //ALT: Previously this was maximum number of weeks spent fishing for any species.
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fish_income.dta", replace //ALT: Some hh's have 10^8 naira reported income. 
//ALT: A substantial piece of fishing-related costs from W3 is missing from W4, including fuel, maintenance, labor, and supply costs. They ask about boat ownership and income from renting the boats out, but that's it.


********************************************************************************
* SELF-EMPLOYMENT INCOME * //ALT Updated 10/15 
********************************************************************************	
use "${Nigeria_GHS_W4_raw_data}/sect9b_harvestw4.dta", clear
egen months_activ = rowtotal(s9q10__2 - s9q10__13) //ALT: Questionnaire goes from Jan '18 to Feb '19. I'm doing Feb 18-Jan 19 to keep it consistent with W3
replace months_activ = 12 if s9q10__0==1 //ALT: "Active in last 12 months" would mean either Jan-Dec 18 or Feb 18 - Jan 19 depending on when HH was surveyed
ren s9q27a monthly_profit
gen annual_selfemp_profit = monthly_profit * months_activ
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by (hhid)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months (Feb 18 - Jan 19)"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_self_employment_income.dta", replace

use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestw4.dta", clear
ren sa3iiq1d size
ren sa3iiq1c unit
ren sa3iiq1b condition
ren sa3iiq18aa qty
ren sa3iiq21 value_processed_crop_sold 
drop if qty==. | value < 5 //Some zeroes, one "2" - typos, or hh didn't end up finding a buyer?
//collapse (sum) qty value_processed_crop_sold, by(hhid zone state cropcode unit size condition)
merge m:1 hhid cropcode unit size condition using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_prices_for_wages.dta", keep(1 3) nogen
merge m:1 hhid cropcode using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_prices_kg.dta", keep(1 3) nogen
recode cropcode (2170=2030) //Plaintains=bananas
replace cropcode=1120 if inrange(cropcode, 1121,1123) //10.24 yam update
label define crop 1120 "1120. YAM", add
gen value_as_input =hh_price_mean*qty
replace value_as_input=val_kg*qty*conv_fact_median if value_as_input==.
gen profit_processed_crop_sold = value_processed_crop_sold - value_as_input
replace profit_processed_crop_sold = 0 if profit_processed_crop_sold < 0
collapse (sum) profit_processed_crop_sold, by (hhid)
lab var profit_processed_crop_sold "Net value of processed crops sold, with crop inputs valued at the unit price for the harvest"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_agproduct_income.dta", replace

********************************************************************************
*OFF-FARM HOURS
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect3a_harvestw4.dta", clear
gen  hrs_main_wage_off_farm=s3q18 if (s3q14>1 & s3q14!=.)	& s3q15b1!=1	// s3q14 1 to 2 is agriculture  (exclude mining). Also exclude apprenticeship and considered this as unpaid work 
*gen  hrs_sec_wage_off_farm= hh_e50 if (hh_e39_2>3 & hh_e39_2!=.)		// s3q14 1 to 2 is agriculture  
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm /*hrs_sec_wage_off_farm*/) 
gen  hrs_main_wage_on_farm=s3q18 if (s3q14<=1 & s3q14!=.) & s3q15b1!=1		 
*gen  hrs_sec_wage_on_farm= hh_e50 if (hh_e39_2<3 & hh_e39_2!=.)	 
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm /*hrs_sec_wage_on_farm*/) 
drop *main* /*sec*/
gen hrs_unpaid_off_farm=s3q7b // Hours on apprenticeship
*recode hh_e70 hh_e71 (.=0) 
gen  hrs_domest_fire_fuel=. // hrs worked just yesterday
ren  s3q5b hrs_ag_activ 
ren s3q6b hrs_self_off_farm

egen hrs_off_farm=rowtotal(hrs_wage_off_farm hrs_self_off_farm)
egen hrs_on_farm=rowtotal(hrs_ag_activ hrs_wage_on_farm)
gen hrs_domest_all=.
egen hrs_other_all=rowtotal(hrs_unpaid_off_farm)
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

save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_off_farm_hours.dta", replace


********************************************************************************
* WAGE INCOME *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect3a_harvestw4.dta", clear
ren s3q13b activity_code
ren s3q14 sector_code
//ren s3q12b1 mainwage_yesno //ALT: Because this section only covers one job, it's assumed that we're asking about the main wage
egen mainwage_number_months = rowtotal(s3q16a__9 - s3q16a__20) //ALT: Questionnaire goes from June '17 to April '19. I'm doing Feb 18-Jan 19 to keep it consistent with W3
replace mainwage_number_months = 12 if s3q16a__0==1 //ALT: "All 12 months" would mean either Jan-Dec 18 or Feb 18 - Jan 19 depending on when HH was surveyed. Not sure why the questionnaire goes out to April.
//ren s3q16 mainwage_number_months
ren s3q17 mainwage_number_weeks
ren s3q18 mainwage_number_hours
ren s3q21a mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity==1 // exclude ag wages 
ren s3q21b mainwage_payment_period
ren s3q24a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity==1
ren s3q24b mainwage_payment_period_other
ren s3q4 worked_as_employee
recode  mainwage_number_months (12/max=12)
recode  mainwage_number_weeks (52/max=52)
recode  mainwage_number_hours (84/max=84)
local vars main //sec oth
foreach p of local vars {
	replace `p'wage_recent_payment=. if worked_as_employee!=1
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = ((`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	replace `p'wage_recent_payment_other=. if worked_as_employee!=1
	gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
	replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
	replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
	replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
	replace `p'wage_salary_other = ((`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
	replace `p'wage_salary_other = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
	recode `p'wage_salary_cash `p'wage_salary_other (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary = mainwage_annual_salary
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Estimated annual earnings from non-agricultural wage employment over previous 12 months"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_wage_income.dta", replace


*Ag wage income
use "${Nigeria_GHS_W4_raw_data}/sect3a_harvestw4.dta", clear
ren s3q13b activity_code
ren s3q14 sector_code
ren s3q12b1 mainwage_yesno
egen mainwage_number_months = rowtotal(s3q16a__9 - s3q16a__20)
replace mainwage_number_months = 12 if s3q16a__0==1
//ren s3q16 mainwage_number_months
ren s3q17 mainwage_number_weeks
ren s3q18 mainwage_number_hours
ren s3q21a mainwage_recent_payment
gen ag_activity = (sector_code==1)
replace mainwage_recent_payment = . if ag_activity!=1 // include only ag wages
ren s3q21b mainwage_payment_period
ren s3q24a mainwage_recent_payment_other
replace mainwage_recent_payment_other = . if ag_activity!=1 // include only ag wages
ren s3q24b mainwage_payment_period_other
ren s3q4 worked_as_employee
recode  mainwage_number_months (12/max=12)
recode  mainwage_number_weeks (52/max=52)
recode  mainwage_number_hours (84/max=84)
local vars main //sec oth
foreach p of local vars {
	replace `p'wage_recent_payment=. if worked_as_employee!=1
	gen `p'wage_salary_cash = `p'wage_recent_payment if `p'wage_payment_period==8
	replace `p'wage_salary_cash = ((`p'wage_number_months/6)*`p'wage_recent_payment) if `p'wage_payment_period==7
	replace `p'wage_salary_cash = ((`p'wage_number_months/4)*`p'wage_recent_payment) if `p'wage_payment_period==6
	replace `p'wage_salary_cash = (`p'wage_number_months*`p'wage_recent_payment) if `p'wage_payment_period==5
	replace `p'wage_salary_cash = ((`p'wage_number_weeks/2)*`p'wage_recent_payment) if `p'wage_payment_period==4
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_recent_payment) if `p'wage_payment_period==3
	replace `p'wage_salary_cash = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment) if `p'wage_payment_period==2
	replace `p'wage_salary_cash = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment) if `p'wage_payment_period==1
	replace `p'wage_recent_payment_other=. if worked_as_employee!=1
	gen `p'wage_salary_other = `p'wage_recent_payment_other if `p'wage_payment_period_other==8
	replace `p'wage_salary_other = ((`p'wage_number_months/6)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==7
	replace `p'wage_salary_other = ((`p'wage_number_months/4)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==6
	replace `p'wage_salary_other = (`p'wage_number_months*`p'wage_recent_payment_other) if `p'wage_payment_period_other==5
	replace `p'wage_salary_other = ((`p'wage_number_weeks/2)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==4
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_recent_payment_other) if `p'wage_payment_period_other==3
	replace `p'wage_salary_other = (`p'wage_number_weeks*(`p'wage_number_hours/8)*`p'wage_recent_payment_other) if `p'wage_payment_period_other==2
	replace `p'wage_salary_other = (`p'wage_number_weeks*`p'wage_number_hours*`p'wage_recent_payment_other) if `p'wage_payment_period_other==1
	recode `p'wage_salary_cash `p'wage_salary_other (.=0)
	gen `p'wage_annual_salary = `p'wage_salary_cash + `p'wage_salary_other
}
gen annual_salary_agwage = mainwage_annual_salary //+ secwage_annual_salary + othwage_annual_salary
collapse (sum) annual_salary_agwage, by (hhid)
lab var annual_salary_agwage "Estimated annual earnings from agricultural wage employment over previous 12 months"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_agwage_income.dta", replace 


********************************************************************************
*OTHER INCOME *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect6_harvestw4.dta", clear
global Nigeria_GHS_W4_pound_exchange 476.5
global Nigeria_GHS_W4_euro_exchange 418.7
//ALT: Updated this section to pull from global exchange rates
ren s6q4a cash_received
ren s6q4b cash_received_unit
ren s6q8a inkind_received
ren s6q8b inkind_received_unit
local vars cash_received inkind_received
foreach p of local vars {
	replace `p' = `p'* $Nigeria_GHS_W4_exchange_rate if `p'_unit==1
	replace `p' = `p'* $Nigeria_GHS_W4_euro_exchange if `p'_unit==2
	replace `p' = `p'* $Nigeria_GHS_W4_pound_exchange if `p'_unit==3 //ALT: added pounds from same source (3 entries)
	replace `p'_unit = 5 if (`p'_unit==1|`p'_unit==2|`p'_unit==3)
	//tab `p'_unit
}
//ALT: 23 total entries in foreign currency
recode cash_received inkind_received (.=0)
gen remittance_income = cash_received + inkind_received
collapse (sum) remittance_income, by (hhid)
lab var remittance_income "Estimated income from OVERSEAS remittances over previous 12 months"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_remittance_income.dta", replace

use "${Nigeria_GHS_W4_raw_data}/sect13_harvestw4.dta", clear
ren s13q2 income
replace income=0 if s13q1==2
keep zone state lga sector ea hhid source_cd income
reshape wide income, i(zone state lga sector ea hhid) j(source_cd)
ren income101 investment_income
ren income102 rental_income_buildings
ren income103 income_pension //ALT: Not asked in W3
ren income104 other_income
append using "${Nigeria_GHS_W4_raw_data}/sect14a_harvestw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/secta4_harvestw4.dta"
//ren s13q2 investment_income
//ren s13q5 rental_income_buildings
//ren s13q8 other_income
//ALT: W4 divides assistance among programs 
ren s14q1a__1 assistance_cash
ren s14q1a__2 assistance_food
ren s14q1a__3 assistance_inkind
ren s14q1a__4 assistance_scholarship //ALT: Not in W3
ren sa4q7 rental_income_assets
recode investment_income rental_income_buildings other_income assistance_cash assistance_food assistance_inkind rental_income_assets /*New*/ income_pension assistance_scholarship (.=0)
gen assistance_income = assistance_cash + assistance_food + assistance_inkind + assistance_scholarship
collapse (sum) investment_income rental_income_buildings other_income assistance_income rental_income_assets income_pension, by (hhid)
lab var investment_income "Estimated income from interest or investments over previous 12 months"
lab var rental_income_buildings "Estimated income from rentals of buildings, tools, land, transport animals over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var assistance_income "Estimated income from a food aid, food-for-work, scholarship, etc. over previous 12 months"
lab var rental_income_assets "Estimated income from rentals of tools and other agricultural assets over previous 12 months"
lab var income_pension "Estimated income from pensions over previous 12 months"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_other_income.dta", replace

*Land rental
use "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", clear
//ren s11b1q29 year_rented ALT: Replaced with s11b1q29a: for how many consecutive years has <plot> been rented out?
ren s11b1q31 land_rental_income_cash //Payment period is up to 1 year
ren s11b1q33 land_rental_income_inkind
recode land_rental_income_cash land_rental_income_inkind (.=0)
gen land_rental_income = land_rental_income_cash + land_rental_income_inkind
replace land_rental_income = . if s11b1q32==5 //Drops 4 obs of payments that cover 2-6 years
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_rental_income.dta", replace


********************************************************************************
* FARM SIZE/LAND SIZE *
********************************************************************************
//ALT 01.04.20: This section seems to run the same in W4 as it does in W3. Minimal modifications.
use "${Nigeria_GHS_W4_raw_data}/secta3i_harvestw4.dta", clear
gen cultivated = 1
merge m:1 hhid plotid using "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", nogen keep(1 3)
ren s11b1q27 cultivated_this_year
preserve 
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta", clear
gen cultivated = 1 if (s11fq7!=. & s11fq7!=0) |  (s11fq11a!=. & s11fq11a!=0)
collapse (max) cultivated, by (hhid plotid)
tempfile tree
save `tree', replace
restore
append using `tree'

replace cultivated = 1 if cultivated_this_year==1 & cultivated==.
ren plotid plot_id
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_cultivated.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", clear
merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_cultivated.dta"
keep if cultivated==1
collapse (sum) field_size, by (hhid plot_id)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_sizes.dta", replace
collapse (sum) field_size, by (hhid)
ren field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" /* Uses measures */
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_size.dta", replace

*All Agricultural Land
use "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", clear
ren plotid plot_id
gen agland = (s11b1q27==1 | s11b1q28==1 | s11b1q28==6) // Cultivated, fallow, or pasture
merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_cultivated.dta", nogen keep(1 3)
preserve 
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta", clear
gen cultivated = 1 if (s11fq7!=. & s11fq7!=0) |  (s11fq11a!=. & s11fq11a!=0)
collapse (max) cultivated, by (hhid plotid)
ren plotid plot_id
tempfile tree
save `tree', replace
restore
append using `tree'
replace agland=1 if cultivated==1
keep if agland==1
collapse (max) agland, by (hhid plot_id)
keep hhid plot_id agland
lab var agland "1= Plot was cultivated, left fallow, or used for pasture"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_agland.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_agland.dta", nogen
keep if agland==1
collapse (sum) field_size, by (hhid)
ren field_size farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmsize_all_agland.dta", replace

*Total land holding including cultivated and rented out
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", clear
collapse (sum) field_size, by (hhid)
ren field_size land_size_total
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_size_total.dta", replace

********************************************************************************
*LAND SIZE
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", clear
ren plotid plot_id
gen rented_out = inlist(s11b1q28, 2,3,4) //=1 if plot was rented out, sharecropped out, or given out for free.
drop if rented_out==1
gen plot_held=1
keep hhid plot_id plot_held
lab var plot_held "1= Plot was NOT rented out in 2018"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_held.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", clear
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_parcels_held.dta", nogen
keep if plot_held==1
collapse (sum) field_size, by (hhid)
ren field_size land_size
lab var land_size "Land size in hectares, including all plots listed by the household (and not rented out)"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_size_all.dta", replace 
//ALT 01.04.20: The original variable for rented_out was s11b1q29, which wasn't asked in W4

********************************************************************************
*FARM LABOR
********************************************************************************
//ALT: Plot level indicators are used, hh-level indicators are not.
//ALT: Replaced in crop expenses. This code here for legacy file compatibility.
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_labor_long.dta", clear
drop if strmatch(gender,"all")
ren days labor_
preserve //ALT 02.07.22: quick 'n' dirty fix for individual section
collapse (sum) labor_total = labor_, by(hhid plot_id)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_farmlabor.dta", replace
restore
collapse (sum) labor_, by(hhid labor_type gender)
reshape wide labor_, i(hhid gender) j(labor_type) string
drop if strmatch(gender,"")
ren labor* labor*_
reshape wide labor*, i(hhid) j(gender) string
egen labor_total=rowtotal(labor*)
egen labor_hired = rowtotal(labor_hired*)
egen labor_family = rowtotal(labor_family*)
egen labor_nonhired = rowtotal(labor_nonhired*)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm in the past year"
lab var labor_hired "Total labor days (hired) allocated to the farm in the past year"
lab var labor_family "Total labor days (family) allocated to the farm in the past year"
lab var labor_hired_male "Workdays for male hired labor allocated to the farm in the past year"		
lab var labor_hired_female "Workdays for female hired labor allocated to the farm in the past year"		
lab var labor_nonhired "Total days for exchange labor in the past year."
keep hhid labor_total labor_hired labor_family labor_hired_male labor_hired_female labor_nonhired
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_family_hired_labor.dta", replace

********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect11j_plantingw4.dta", clear //ALT: Moved from 11i in W3 to 11j in W4
gen vac_animal= s11jq4==1
//ALT: Not in W4 replace  vac_animal=. if animal_cd==121 | animal_cd==123 // other categories includes essentially dogsa\ and cats and other animals for which vaccination is not relevant
//replace vac_animal = . if s11iq1==2 | s11iq1==. //missing if the household did now own any of these types of animals  - Not in W4
*disagregating vaccine usage by animal type 
ren livestock_cd species

*A loop to create species variables *Note! Order has changed since W3
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==3
	gen `i'_pigs = `i' if species==4
	gen `i'_equine = `i' if species==2
	gen `i'_poultry = `i' if species==5
	gen `i'_camels = `i' if species==6 //ALT: Added for W4. 9 obs
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
	lab var `i'_camels "`l`i'' - camels"
}
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_vaccine.dta", replace
 
use "${Nigeria_GHS_W4_raw_data}/sect11j_plantingw4.dta", clear
gen all_vac_animal=s11jq4==1
reshape long s11jq15_, i(hhid livestock_cd) j(farmer)
ren s11jq15_ farmerid
collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", nogen
keep hhid farmerid all_vac_animal indiv female age
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmer_vaccine.dta", replace

********************************************************************************
*ANIMAL HEALTH - DISEASES
********************************************************************************

use "${Nigeria_GHS_W4_raw_data}/sect11j_plantingw4.dta", clear
gen disease_animal = 1 if s11jq1a==1
replace disease_animal = 0 if s11jq1a==2
ren s11jq2_4 disease_fmd
ren s11jq2_5 disease_lump
ren s11jq2_7 disease_bruc
ren s11jq2_9 disease_cbpp
ren s11jq2_6 disease_bq
ren livestock_cd species
*A loop to create species variables
foreach i in disease_animal disease_fmd disease_lump disease_bruc disease_cbpp disease_bq{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==3
	gen `i'_pigs = `i' if species==4
	gen `i'_equine = `i' if species==2
	gen `i'_poultry = `i' if species==5
	gen `i'_camels = `i' if species==6
}
collapse (max) disease_*, by (hhid)
lab var disease_animal "1= Household experienced veterinary disease"
lab var disease_fmd "1= Household experienced foot and mouth disease"
lab var disease_lump "1= Household experienced lumpy skin disease"
lab var disease_bruc "1= Household experienced brucelosis"
lab var disease_cbpp "1= Household experienced contagious bovine pleuro pneumonia"
lab var disease_bq "1= Household experienced black quarter"
foreach i in disease_animal disease_fmd disease_lump disease_bruc disease_cbpp disease_bq{
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' in large ruminants"
	lab var `i'_srum "`l`i'' in small ruminants"
	lab var `i'_pigs "`l`i'' in pigs"
	lab var `i'_equine "`l`i'' in equine"
	lab var `i'_poultry "`l`i'' in poultry"
	lab var `i'_camels "`l`i'' in camels"
}
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_diseases.dta", replace


********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING
********************************************************************************
//ALT: Was not constructable for W3, but some of the information is in W4. Using TZ code as a model.
use "${Nigeria_GHS_W4_raw_data}/sect11j_plantingw4.dta", clear
gen feed_grazing = (s11jq14==1 | s11jq14==2)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
drop if livestock_cd==7 //"Other"
/*gen water_source_nat = (lf04_06_1==5 | lf04_06_1==6 | lf04_06_1==7)
gen water_source_const = (lf04_06_1==1 | lf04_06_1==2 | lf04_06_1==3 | lf04_06_1==4 | lf04_06_1==8 | lf04_06_1==9 | lf04_06_1==10)
gen water_source_cover = (lf04_06_1==1 | lf04_06_1==2 )
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source" */ //ALT: Not available for Nigeria
gen lvstck_housed = inrange(s11jq11,2,7)
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
*A loop to create species variables
foreach i in feed_grazing lvstck_housed {
	gen `i'_lrum = `i' if livestock_cd==1
	gen `i'_srum = `i' if livestock_cd==3
	gen `i'_pigs = `i' if livestock_cd==4
	gen `i'_equine = `i' if livestock_cd==2
	gen `i'_poultry = `i' if livestock_cd==5
	gen `i'_camels = `i' if livestock_cd==6
}
collapse (max) feed_grazing* lvstck_housed*, by (hhid)
lab var feed_grazing "1=HH feeds only or mainly by grazing"
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
foreach i in feed_grazing lvstck_housed {
	local l`i' : var lab `i'
	lab var `i'_lrum "`l`i'' - large ruminants"
	lab var `i'_srum "`l`i'' - small ruminants"
	lab var `i'_pigs "`l`i'' - pigs"
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
	lab var `i'_camels "`l`i'' - camels"
}
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_feed_water_house.dta", replace


********************************************************************************
* PLOT MANAGERS *
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta", clear
gen use_imprv_seed=s11fq3b==1
ren plotid plot_id
ren cropcode crop_code
//Crop recode
recode crop_code (2170=2030) (2142 = 2141) (1121 1122 1123=1120)
la def cropcode 1120 "1120. YAM", replace
collapse (max) use_imprv_seed, by(hhid plot_id crop_code)
tempfile imprv_seed
save `imprv_seed'




use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
keep hhid plot_id cropcode use_imprv_seed 
ren cropcode crop_code
merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_quantities.dta", nogen
foreach i in inorg_fert org_fert pest herb {
	recode `i'_kg (.=0)
	gen use_`i'= `i'_kg > 0
}
collapse (max) use*, by(hhid plot_id crop_code)
merge 1:1 hhid plot_id crop_code using `imprv_seed',nogen
recode use* (.=0)
preserve 
keep hhid plot_id crop_code use_imprv_seed
ren use_imprv_seed imprv_seed_ //ALT 02.07.22
gen hybrid_seed_ = .
collapse (max) imprv_seed_ hybrid_seed_, by(hhid crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", nogen keep(3)
drop crop_code
reshape wide imprv_seed_ hybrid_seed_, i(hhid) j(crop_name) string
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_imprvseed_crop.dta", replace 
restore 


merge m:m hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_dm_ids.dta", nogen keep(1 3)
preserve
ren use_imprv_seed all_imprv_seed_
gen all_hybrid_seed_ =.
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", nogen keep(3)
drop crop_code
gen farmer_=1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmer_improvedseed_use.dta", replace
restore

collapse (max) use_*, by(hhid indiv female)
gen all_imprv_seed_use = use_imprv_seed //Legacy
//Temp code to get the values out faster
/*	collapse (max) use_*, by(hhid)
	merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(3)
	recode use* (.=0)
	collapse (mean) use* [aw=weight_pop_rururb] */
//Legacy files, replacing the code below.

preserve
	collapse (max) use_inorg_fert use_imprv_seed use_org_fert use_pest use_herb, by (hhid)
	la var use_inorg_fert "1= Household uses inorganic fertilizer"
	la var use_pest "1 = household uses pesticide"
	la var use_herb "1 = household uses herbicide"
	la var use_org_fert "1= household uses organic fertilizer"
	la var use_imprv_seed "1=household uses improved or hybrid seeds for at least one crop"
	gen use_hybrid_seed = .
	la var use_hybrid_seed "1=household uses hybrid seeds (not in this wave - see imprv_seed)"
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_use.dta", replace 
restore

preserve
	ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if indiv!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmer_fert_use.dta", replace //Used for AgQuery
restore

********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
*Extension
use "${Nigeria_GHS_W4_raw_data}/sect11l1_plantingw4.dta", clear
ren s11l1q1 receive_advice
ren s11l1q2 sourceid
ren s11l1q2_os sourceid_other
preserve

// BT 01.14.2021 editing code to reflect wave 4 dataset and variable names 
use "${Nigeria_GHS_W4_raw_data}/secta5b_harvestw4.dta", clear
ren sa5bq1 receive_advice
ren source_cd sourceid
tempfile advie_ph
save `advie_ph'
restore
append using `advie_ph'

// NKF 11.6.20 Breaking down by each specific type of extension, combining all non-peer sources to "advice_all"
**Government Extension
gen advice_gov_ag = ((sourceid==1 ) & receive_advice==1)
gen advice_gov_fish = ((sourceid==3) & receive_advice==1)
**private Extension
gen advice_private = (sourceid==2 & receive_advice==1)
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1)
**Fishing Co-iop
gen advice_fish_coop = (sourceid==6 & receive_advice==1)
**Farmer field day
gen advice_field_day = (sourceid==7 & receive_advice==1)
*Village ag extension
gen advice_village_ag_ext = (sourceid==8 & receive_advice==1)
**Ag extension course
gen advice_ag_ext_course = (sourceid==9 & receive_advice==1)
**Leader farmer
gen advice_lead_farmer = (sourceid==10 & receive_advice==1)
**Peer farmer
gen advice_peer_farmer = (sourceid==11 & receive_advice==1)
**Radio
gen advice_media = (sourceid==12 & receive_advice==1)
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1)
**Other
gen advice_other = ((sourceid==14)  & receive_advice==1)
*Advice All // BT 11.24.20 added in lead farmers and peer farmers as sources (sourceid = 10 or 11)

*DYA.04.26.2022 added here
*gen ext_reach_all=(advice_gov==1 | advice_ngo==1 | advice_coop==1 | advice_media==1  | advice_pub==1)
gen ext_reach_public=(advice_gov_ag==1 & advice_gov_fish==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1)
gen ext_reach_unspecified=(advice_media==1 | advice_pub==1 | advice_other==1)
gen ext_reach_ict=(advice_media==1)
*End



gen advice_all = ((sourceid==1 | sourceid==2 | sourceid==3 | sourceid==4 | sourceid==5 | sourceid==6 | sourceid==7 | sourceid==8 | sourceid==9 | sourceid==10 | sourceid==11| sourceid==12 | sourceid==13 | sourceid==14 )  & receive_advice==1)

// BT 01.14.2021 editing code to reflect wave 4 dataset and variable names 
preserve
use "${Nigeria_GHS_W4_raw_data}/sect11e1_plantingw4.dta", clear
gen seed_ext_advice=0
// BT 01.14.2021 editing code to reflect wave 4 dataset and variable names 
replace seed_ext_advice=1 if (s11eq4a==3 | s11eq4a==4 | s11eq4a==5) // BT 01.14.2021 note that labels differ in this wave 
tempfile advice_seed
save `advice_seed'

// For waves 1-3: NKF 11.6.20 - There's supposed to be a question on fertilizer use + extension officer in PH Sect 11D Q5, but I'm not seeing it in .dta 
// DIDIER PLEASR CHECK For wave 4 - BT 01.14.2021 not sure if we want to add this since, other waves did not include this
// Question in 11c3:  From whom did your household purchase most of the [INPUT] for used during the 2018/2019 agricultural season? 
// Answers:  AGRICULTURE INPUT  DEALER; FELLOW FARMER; GOVERNMENT EXTENSION OFFICER; FAMILY MEMBER /RELATIVES; OTHER (SPECIFY); LOCAL/OPEN MARKET 

// DYA 02.09.2021: I am not sure about this. My reading of the question indicate that it is about from whom did hh purchase input and not why thet decide to make the purchase. So I would not classify this as advisory services.

use "${Nigeria_GHS_W4_raw_data}/secta11c3_harvestw4.dta", clear
gen input_ext_advice = 0
replace input_ext_advice=1 if s11c3q6b==2 | s11c3q6b ==3 // including ext officer and fellow farmer should we include input dealer or family members?
tempfile advice_input
save `advice_input' 

restore
append using `advice_seed'
replace advice_all=1 if seed_ext_advice==1 & advice_all==0 
append using `advice_input'
replace advice_all=1 if input_ext_advice==1 & advice_all==0 

collapse (max) advice_* , by (hhid)
ren advice_all ext_reach_all
 
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_any_ext.dta", replace 

********************************************************************************
* MOBILE PHONE OWNERSHIP *
********************************************************************************
*BET 03.26.2021
use "${Nigeria_GHS_W4_raw_data}/sect5_plantingw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/sect4b_plantingw4.dta"
// recode missing to 0 in s5q1 (0 mobile owned if missing)
recode s5q1 s4bq8  (.=0) 

gen mobile_owned=s5q1a==1 if (item_cd==3321 | item_cd==3322) // number mobile phones owned post planting BT 01.14.2021 questionaire asks about both smart and regular mobile phones
bysort hhid: egen hh_number_mobile_owned=total(s5q1) if (item_cd==3321 | item_cd==3322)

gen  indiv_mobile_access=s4bq8==1 if (s4bq9==1  |  s4bq9==2)   // BT 01.14.2021 individual has access to own mobile phone mobile or phone ownded by family membder 
bysort hhid: egen hh_number_mobile_access=total(indiv_mobile_access)
recode hh_number_mobile_access (.=0)

replace mobile_owned=hh_number_mobile_access>0 if mobile_owned==0

collapse (max) mobile_owned hh_number_mobile_owned, by(hhid)

save "${Nigeria_GHS_W4_created_data}/Nigeria_2018_mobile_own", replace

********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect4a1_plantingw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/sect4a2_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect4b_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect4c1_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect4c2_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect4c3_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect9a_harvestw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect9b_harvestw4.dta"
gen use_bank_acount=s4aq1==1
gen use_bank_other=((s9q17==1 |  s9q18==1) &( s9q19_1==1 |  s9q19_2==1)) //ALT: Use of mobile phone banking was dropped from W4 questionnaire
*gen use_saving=s4aq9b==3 | s4aq9d==1 | s4aq9f==1 //ALT: If you look at the W3 codes for this, 3 is microfinance and 1 is a cooperative. Why do we use these labels?
gen use_saving=s4aq9__1==1 | s4aq9__2==1 | s4aq9__3==1 //Q5 is "Other"; a few respondants say bank or savings account in this entry, but most of them are informal. 
//gen use_MM=s4bq10b==1  & s4bq10!=0 & s4bq10!=. ALT: Mobile phone banking. Not in W4
//gen formal_loan=1 if (s4cq2b==3 | s4cq2b==4) & s4cq8!=. //Loan is formal if 3 (microfinance) or 4 (bank)
gen formal_loan=1 if (s4cq2b==3 | s4cq2b==4) & s4cq16!=2 //ALT: W3 asks when in last 12 mo. loan was received in s4cq8. The Q is not in W4; closest analog is s4cq16: Did you need a loan in the last 12 months?
gen rec_loan=formal_loan==1
gen use_credit_selfemp= (s9q17==1 |  s9q18==1) & ( s9q19_1==1 |  s9q19_2==1)
gen use_insur=s4aq16==1
gen use_fin_serv_bank= use_bank_acount==1
gen use_fin_serv_credit= use_credit_selfemp==1 | rec_loan==1   
gen use_fin_serv_insur= use_insur==1
gen use_fin_serv_digital=. //ALT: Cannot construct
gen use_fin_serv_others= use_saving==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | /*use_fin_serv_digital==1 |*/  use_fin_serv_others==1
recode use_fin_serv* (.=0)
collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank accout"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fin_serv.dta", replace 

 
********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_products", clear
keep if livestock_cd == 1 & quantity_produced!=0
gen milk_quantity_produced = quantity_produced
gen milk_months_produced = months_produced
collapse (sum) milk_months_produced milk_quantity_produced qty_animals, by (hhid)
ren qty_animals milk_animals
gen liters_milk_produced = milk_quantity_produced * milk_months_produced
la var liters_milk_produced "Amount of milk produced per year"
la var milk_months_produced "Number of months that the household produced milk"		
la var milk_quantity_produced "Average quantity of milk produced per month - liters"		 
drop if milk_months_produced==0 | milk_quantity_produced==0
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_milk_animals.dta", replace


********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_livestock_products", clear
keep if livestock_cd==5 & quantity_produced!=0
gen eggs_quantity_produced = quantity_produced
gen eggs_months_produced = months_produced
collapse (sum) eggs_months_produced eggs_quantity_produced qty_animals, by (hhid)
ren qty_animals poultry_owned 
drop if eggs_months_produced==0 | eggs_quantity_produced==0
la var eggs_months_produced "Number of months that the household produced eggs"		
la var eggs_quantity_produced "Average number of eggs produced per month"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_egg_animals.dta", replace

********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid plot_id purestand field_size)
reshape long ha_, i(hhid plot_id purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(hhid plot_id dm_gender exp)
reshape wide cost_, i(hhid plot_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0)
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge 1:m hhid plot_id using `plot_areas', nogen keep(3)
//reshape long cost_, i(hhid plot_id dm_gender) j(exp) string
//replace cost_ = cost_/ha_
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=field_size], by(hhid dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(hhid dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid) j(dm_gender2) string

foreach i in male female mixed {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropcosts.dta", replace


********************************************************************************
* RATE OF FERTILIZER APPLICATION *
********************************************************************************
//ALT 08.04.21: Added in org fert, herbicide, and pesticide; additional coding needed to integrate these into summary stats
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
collapse (sum) ha_planted, by(hhid plot_id dm_gender)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_quantities.dta", nogen keep(1 3) //11 plots have expenses but don't show up in the all_plots roster.
drop if ha_planted==0
recode *kg (.=0)
//ren *_rate *_kg_
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
unab vars : *_kg
ren *kg *kg_
ren ha_planted ha_planted_
//ren w_ha_planted w_ha_planted_

reshape wide *_, i(hhid plot_id) j(dm_gender2) string
//recode ha_planted* (0=.)
collapse (sum) *kg* ha_planted_*, by(hhid)
/*
foreach i in inorg_fert org_fert herb pest {
	foreach j in male female mixed {
		gen `i'_rate_`j' = `i'_kg_`j'/w_ha_planted_`j'
}
}
*/


foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}

//Some high inorg fert rates as a result of large tonnages on small plots. 
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
lab var npk_kg "NPK fertilizer (kgs) for household"
lab var n_kg "Units of Nitrogen (kgs) for household"
lab var p_kg "Units of Phosphorus (kgs) for household"
lab var k_kg "Units of Potassium (kgs) for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var urea_kg "Urea (kgs) for `i'-managed plots"
lab var npk_kg "NPK fertilizer (kgs) for `i'-managed plots"
lab var n_kg "Units of Nitrogen (kgs) for `i'-managed plots"
lab var p_kg "Units of Phosphorus (kgs) for `i'-managed plots"
lab var k_kg "Units of Potassium (kgs) for `i'-managed plots"
}

save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fertilizer_application.dta", replace

/*
********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************

//ALT 01.24.21: Fixed missing file references
*Now getting area planted 
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta", clear
ren plotid plot_id
*Merging in gender of plot manager
merge m:1 plot_id hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas", nogen keep(1 3)
gen ha_planted = s11fq1/100*field_size //ALT: Using field_size from plot_areas
*Rescaling
merge m:1 plot_id hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas", nogen keep(1 3)			
merge m:1 plot_id hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers", nogen keep(1 3)
bys plot_id hhid: egen total_ha_planted = total(ha_planted)					
replace ha_planted = ha_planted*(field_size/total_ha_planted) if total_ha_planted>field_size	//ALT: 8154 changes. It looks like area planted was frequently misreported; in some cases there's no way the number of seeds/seedlings planted correspond to plot area. I don't see an alternative.
gen ha_planted_male = ha_planted if dm_gender==1
gen ha_planted_female = ha_planted if dm_gender==2
gen ha_planted_mixed = ha_planted if dm_gender==3
ren plot_id plotid
*Merging in rental rate (both at aggregate level and at household level)
merge m:1 hhid plotid using "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", nogen keep(1 3)	
egen plot_rent = rowtotal(s11b1q13 s11b1q14)										// total paid for rent (on plot)
preserve
keep if plot_rent != 0 & plot_rent != .
collapse (sum) plot_rent field_size, by(zone state lga sector hhid)
gen rental_rate_hh = plot_rent/field_size
gen obs = rental_rate_hh != 0 & rental_rate_hh !=. 
drop if rental_rate_hh==.
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb)
tempfile rental_rate_hh
save `rental_rate_hh'
restore
		// household's average rental rate (total rent paid divided by total ha rented at household level)

foreach i in zone state lga sector {
	preserve
	use `rental_rate_hh', clear
	bys `i' : egen obs_`i' = sum(obs)
	collapse (mean) rental_rate_`i' =rental_rate_hh [aw=weight_pop_rururb], by(`i' obs_`i')
	tempfile rental_rate_`i'
	save `rental_rate_`i''
	restore
	merge m:1 `i' using `rental_rate_`i'', nogen
}
merge m:1 hhid using `rental_rate_hh', nogen keep(1 3)	
gen ha_rental_rate = rental_rate_hh
recode ha_rental_rate (0=.)
foreach i in lga state zone sector { 
replace ha_rental_rate = rental_rate_`i' if ha_rental_rate == . & obs_`i' > 9 & rental_rate_`i' != .
}
gen value_owned_land = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0)		// generate value owned using aggregate rental rate - only for plots that were not rented
//replace value_owned_land = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0	
*Repeating for male
gen value_owned_land_male = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0) & dm_gender==1
//replace value_owned_land_male = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0 & dm_gender==1
*Repeating for female
gen value_owned_land_female = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0) & dm_gender==2
//replace value_owned_land_female = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0 & dm_gender==2
*Repeating for mixed
gen value_owned_land_mixed = ha_planted*ha_rental_rate if (plot_rent==. | plot_rent==0) & dm_gender==3
//replace value_owned_land_mixed = ha_planted*ha_rental_hh if (plot_rent==. | plot_rent==0) & ha_rental_hh!=. & ha_rental_hh!=0 & dm_gender==3

/*ARP 11.1.20 - improved seed additional code*/
preserve
*Gen improved seed measure
gen imprv_seed_use=s11fq3b==1
tab imprv_seed_use, miss /*6.84% of observations improved*/

*Collapse by household, crop, and improved seed use
collapse (sum) ha_planted, by(hhid cropcode imprv_seed_use)
//isid hhid crop_code imprv_seed_use
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_area_improved.dta", replace
restore
/*ARP 11.1.20 - end*/


collapse (sum) value_owned_land* ha_planted*, by(hhid)
ren value_owned_land value_owned_land_hh //Make this easier when aggregating data below
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_land.dta", replace
*/


/*ALT 10.18.21: This section is for getting implicit costs to better estimate expenses per ha; it has issues (the presence of nonstandard units and their conversions mean some seed prices are ridiculous) but would be necessary if we want to compare to past waves. It properly belongs in the crop expenses section now but I am omitting 'til we decide whether we really want to use it.
********************************************************************************
* SEED COSTS *
********************************************************************************

/*ALT:
This section was previously in the per-ha costs section, but it was also much easier for W3 because purchases were at the plot level.
In W4, seed purchases are at the hh-level, but planting is at the plot level. Seeds could be purchased as one bulkier unit and then 
split into smaller units for planting. Consequently, we need to get a val/kg to determine plot-level crop expenses and disaggregate by 
gender of plot manager. The process for this is to divide crops into three groups: planted-as-units,
planted-as-harvested and planted-as-seed. Planted-as-units are in some countable quantity - bundle, stalk, seedling, etc.  
Planted-as-harvested crops are presumably in the same condition at harvest (or shelled) as they are at planting: cereals, beans, peanuts/groundnuts, yams.
Planted-as-seed are not like this and need to be converted using a known conversion factor for something of the same bulk density: e.g., green/cruciferous/solanaceous vegetables and melons/pumpkins. 
Workflow: 
Get conversions for planted-as-harvested from W4 crop unit conversions.
Get as-seed from food unit conversions or similar crop-unit conversions or external sources.

Categories:
Planted as harvested (unshelled/na): 1070* 1090 1090 (as 1091) 1100* 1110 (as 1111) 1120-1124 (as 1120) 2040 2180 2181 2193 (as 2190) 2200 2270 2290 (as 2191) 3020 (as 3022) 3040 (as 3042) 3110 (as 3112)
Planted as harvested (shelled): 1010 1060 (as 1062) 1080 (as 1082) 2150 2220 2280 3060-3062 //and 2020
Planted as seed (shelled): 1050 (as 1051/1053) 2260
Planted as seed (unshelled or n/a): 1093 (as 1090) 2050 2060 2070 2080 2120 2130 2140-2143 (as 2140) 2194 3030 
Planted as units: 1020 1040 2160 2230 3040 3110 3190 3180 3220 3221 

Questions: 2010 (acha) 2020 (bambara) 2090 (garlic) 2100 (ginger) 2110 (gum arabic) 2195 (kuka) 2240 (tea) 2250 (tobacco) - 3210 (pawpaw) and 3180 (oil palm) should be planted as units but occasionally have something else


*(sorghum/millet) sometimes planted as "bundles" of harvested stalks 

**********************************
Bulk Densities for Seed Groups
**
Solanaceous crops (tomato, pepper, garden egg) have a bulk density of ~0.3 
Cabbage: 0.73 (source: https://www.ijcmas.com/6-10-2017/M.L.%20Jadhav,%20et%20al.pdf), similar to field corn (0.72)
Soybeans, cowpeas are also similar. Most beans are probably close in terms of bulk density. (~0.75-0.77) (see https://www.cfd.coop/go/doc/f/CMDT_Weight_of_Bulk_Materials_and_Bushel_Weights.pdf)
Pumpkin is assumed similar to melon/egusi
Green Vegetable: research indicates this is either in the amaranth family or the asteraceae. If latter, bd is 0.35. If former, it's 0.538. Accuracy might be hard here.
Cucumber: 0.61
Okra: 0.51
Onion (seed): 0.42
Cotton (seed): 0.4
Cashew: 0.5 (per FAO: http://www.fao.org/3/ap815e/ap815e.pdf)
Peanut/groundnut are typically planted SHELLED: 0.36 //Some W3 data suggests that they were being planted unshelled, but that information is missing here. Standard practice is to shell
Sesame/beeni/benni - 0.64 
Paddy Rice - 0.6 (central value)
Millet=0.64
Sorghum = 0.54
Kola ~ 0.60

Bulk Density Groups
*1: Melon/melon-like, use egusi seed from food table
*2: Solanaceous crops, peanut/groundnut/bambara (2020): shelled field values for peanut/groundnut or food values
*3: Field corn, cabbage, and other brassicas: can use corn, food or shelled field values
*4: Beans: use shelled field or food values
*5: Cashew, okra (use food values for cashew), sorghum (not ideal, but fairly close)
*6: Onion, cotton, green vegetable (assume central value), use delinted cottonseed.
*7: Yams (as pieces, pooling conversion factors across varieties)
*8: potatoes/sweet potatoes
*9: Millet & sesame
//Note: Medium basket for sweet potato is clearly wrong
*/

use "${Nigeria_GHS_W4_raw_data}/sect7b_plantingw4.dta", clear
	ren s7bq2b unit_eaten
	ren s7bq2c size_eaten
	ren s7bq2_cvn conv_fact_eaten
	ren s7bq9b unit_bought
	ren s7bq9c size_bought
	ren s7bq9_cvn conv_fact_bought
	ren item_cd cropcode
	recode cropcode (22=1080) (10=1070) (11=1100) (12=1110) (40=2220) (41 42=1010) (47=3110)  (44=1060) (48=3020) (146=1090) (31=1120) (32=1121) (33=1122) (37=2180) (36=2181)
	drop if cropcode < 1000 
	gen dummy_id=1
	gen dummy_sum=sum(1)
reshape long unit_ size_ conv_fact_, i(dummy_sum) j(status, string)
	drop dummy*
	ren unit_ unit
	ren size_ size
	ren conv_fact cf_w4_food 
	drop if cf_w4_food==. 
collapse (median) cf_w4_food, by (zone unit cropcode size)
tempfile cf_w4_food
save `cf_w4_food', replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cf.dta", clear
keep if (inlist(cropcode, 1010, 1060, 1080, 2150, 2220, 2280, 3060) & condition==2) | /* planted shelled/na, no cottonseed for w4
*/ (inlist(cropcode, 1070, 1090, 1100, 1110, 1120-1124, 2040, 2180, 2190, 2200 2270 2290, 3020, 3040, 3110) & (condition==1 | condition==.))
ren conv_fact_median conv_fact_w4
duplicates drop cropcode size unit , force //DYA 09.29.2020 check this later
tempfile cf_w4
save `cf_w4', replace



use "${Nigeria_GHS_W4_raw_data}/sect11e1_plantingw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta"
//Now that we have at least some unit conversions to start with, we'll create 
//a unit conversion table by scraping up all the crop-unit combinations that 
//were given in this survey.

ren s11eq6a qty_leftover
ren s11eq6b unit_leftover
ren s11eq6b_os other_leftover
ren s11eq6c size_leftover
ren s11eq10a qty_free
ren s11eq10b unit_free
ren s11eq10b_os other_free
ren s11eq10c size_free
ren s11eq18a qty_bought
ren s11eq18b unit_bought
ren s11eq18b_os other_bought
ren s11eq18c size_bought
ren s11fq3d_1 qty_planted
ren s11fq3d_2 unit_planted
ren s11fq3d_2_os other_planted
ren s11fq3d_3 size_planted
ren s11eq21 value_bought
gen value_planted=. //Dummy variables for seed values to make the reshape cleaner
gen value_free=.
gen value_leftover=.

gen dummy1=1
gen dummy2=sum(dummy1) //unique ID for merge
reshape long qty_ size_ unit_ other_ value_, i(dummy2) j(source, string)
ren other_ other
ren qty_ qty
ren unit_ unit
ren size_ size
ren value_ value
drop if qty==.
drop dummy*

//Cleaning up the "other" 
replace unit=280 if strmatch(other, "MERTIC CUP") | strmatch(other,"METIRC CUP") | strmatch(other,"METRIC CUP") | strmatch(other,"METRICE CUP")
replace qty = qty*10 if strmatch(other,  "10 STEMS OF OKRO")
replace unit =260  if strmatch(other,  "10 STEMS OF OKRO") | strmatch(other,  "1 PLAINTAIN TREE") | strmatch(other,  "*HEAD*") | strmatch(other,  "*SUCKER*") /*
*/ | strmatch(other,  "SEEDL*")
//Stems
replace unit=210 if strmatch(other,  "STEAM") | strmatch(other,  "STALK") | strmatch(other,  "*STEM*") | strmatch(other,  "STEMS") | (cropcode ==1020 & strmatch(other,  "*STAND*")) //For cassava, stand is a synonym for stem

//Basins
replace unit=150 if strmatch(other,  "*BASIN*") | strmatch(other,  "*BESIN*")

//Pickups
replace unit=180 if strmatch(other,  "*PICK*UP*")

//Bin/Basket
replace unit=10 if strmatch(other,  "BASKET") | strmatch(other,  "BIN" )

//Pieces
replace unit=80 if strmatch(other, "*PIECE*") | strmatch(other,  "SEED YAM") | strmatch(other,  "SEEDYAM") | strmatch(other,  "YAM SET")

//Heaps
replace unit=90 if strmatch(other,  "HEAP")

//Bundles
replace unit=100 if strmatch(other, "BUNDLE")

drop if unit==900 | unit==. //Drop remaining "other" and no unit given.
//Simplify unit sizes for analysis
replace size=. if unit==11 /* Only one large paint rubber
				*/ | unit==80 /* Pieces
				*/ | unit==100 /* Bundles - ignoring size for the time being because it likely refers to size of stems, not size of bundle
				*/ | unit==110 /* Stalks
				*/ | unit==210 /* Stems
				*/ | unit==211 /* Tubers
				*/ | unit==260 /* Seedlings
				*/ | unit==1 | unit==2 /* No different sizes for g/kg
				*/ | unit==10 /* Only one medium bin/basket 
				*/ | (unit==90 & cropcode==1020) //testing the hypothesis that cassava heaps are individual units
				
merge m:1 cropcode size unit using `cf_w4'
ren _merge merge_w4
merge m:1 cropcode size unit zone using `cf_w4_food'
ren _merge merge_w4_food

gen conv_fact=conv_fact_w4
//Known units of conversion that should be easy to fill in - pieces or kg/g
replace conv_fact=1 if unit==1 //kg
replace conv_fact=0.001 if unit==2 //g
gen type=1 if (cropcode==1020 & unit==100) | (cropcode==2230 & unit==100) | unit==110 | unit==80 | unit==210 | unit==211 | unit==260 | /* cassava heap test */ (unit==90 & cropcode==1020) //Keeping track of what's in pieces so we can note that on the values.
recode type (.=0)
replace conv_fact=50 if cropcode==1020 & unit==100 //50 stems per cassava bundle, regardless of size 
replace conv_fact=10 if cropcode==2230 & unit==100 //10 stems per sugarcane bundle, regardless of size
replace conv_fact=1 if unit==80 | unit==110 | unit==210 | unit==211 | unit==260 | (unit==90 & cropcode==1020) //pieces, stalks, stems, tuber, seedling/plant, cassava heaps
replace conv_fact=25 if size==10 //25kg bag
replace conv_fact=50 if size==11 //50kg bag
replace conv_fact=100 if size==12 //100kg bag


//Generating medians for bulk density groups, then inferring from the food conversion rates.

gen bd_seed=0
replace bd_seed=1 if inlist(cropcode, 1090, 2060, 2190)
replace bd_seed=2 if inlist(cropcode, 1060, 2260, 2020, 2141, 2142, 2080, 3030)
replace bd_seed=3 if inlist(cropcode, 2070, 1080)
replace bd_seed=4 if inlist(cropcode, 1010, 2220)
replace bd_seed=5 if inlist(cropcode, 3020, 2120, 1070)
replace bd_seed=6 if inlist(cropcode, 2194, 1050, 2130)
replace bd_seed=7 if inrange(cropcode, 1120,1124) //Yams
replace bd_seed=8 if inlist(cropcode, 2180, 2181) //Potatoes
replace bd_seed=9 if inlist(cropcode, 1100, 2040)

replace cf_w4_food=conv_fact if cf_w4_food==. & conv_fact!=. & inlist(cropcode, 1070, 1090, 1100, 1110, 1120-1124, 2020, 2040, 2180, 2190, 2200, 2270, 2290, 3020, 3040, 3110, 1010, 1060, 1080, 2150, 2220, 2280, 3060) 
//Back-coding planted-as-harvested crops to the food conversions so we have a more robust median. We've already distinguished between shelled and unshelled above, so this conversion factor should be reliable.

bys unit size bd_seed : egen cf_bybd_median_w4=median(cf_w4_food) //Ignoring regional variation
replace conv_fact=cf_w4_food if conv_fact==.
replace conv_fact=cf_bybd_median_w4 if conv_fact==. & bd_seed!=0

//Now one-size-fits-all estimates from WB and external sources to get stragglers 
//These from Local weights and measures in Nigeria: a handbook of conversion factors by Kormawa and Ogundapo
//milk cup - 0.14?
//cigarette cup -0.18 //agrees w/ LSMS
//paint rubber - 2.49 //lower than lsms
//pickup - 1957.58
//Sachets - sm, med, lg = 0.1 1, ? 
//1 metric cup = 250 mL 
replace conv_fact = 1957.58 if unit==180 & conv_fact==.
replace conv_fact = 0.18 if unit==13 & conv_fact==.
replace conv_fact = 0.14 if unit==12 & conv_fact==.
//replace conv_fact = mm if unit==170 & conv_fact==.

//Bulk density conversion for metric cups and paint rubbers (std size is 4L)
replace conv_fact = 0.25*0.22 if bd_seed==1 & conv_fact==. & unit==280 //Significant variability for squashes/melons. Range is 0.14-0.30
replace conv_fact = 0.25*0.36 if bd_seed==2 & conv_fact==. & unit==280
replace conv_fact = 0.25*0.72 if bd_seed==3 & conv_fact==. & unit==280
replace conv_fact = 0.25*0.76 if bd_seed==4 & conv_fact==. & unit==280
replace conv_fact = 0.25*0.50 if bd_seed==5 & conv_fact==. & unit==280
replace conv_fact = 0.25*0.40 if bd_seed==6 & conv_fact==. & unit==280

replace conv_fact = 4*0.22 if bd_seed==1 & conv_fact==. & unit==11 //Significant variability for squashes/melons. Range is 0.14-0.30
replace conv_fact = 4*0.36 if bd_seed==2 & conv_fact==. & unit==11
replace conv_fact = 4*0.72 if bd_seed==3 & conv_fact==. & unit==11
replace conv_fact = 4*0.76 if bd_seed==4 & conv_fact==. & unit==11
replace conv_fact = 4*0.50 if bd_seed==5 & conv_fact==. & unit==11
replace conv_fact = 4*0.40 if bd_seed==6 & conv_fact==. & unit==11
replace conv_fact = 2.75 if unit==11 & cropcode == 1110 & conv_fact==. //Rubber value for local rice from K&O (suggests a bulk density of about 0.68 - assuming rubber is level - which is a little high for rice)
replace conv_fact = 2.75 if unit==70 & cropcode == 1110 & conv_fact==. //bowl from K&O
replace conv_fact = 8.03 if unit==150 & cropcode == 1110 & conv_fact==. //Basin from K&O

*replace conv_fact = 1.72 if unit==90 & inrange(zone, 1, 3) & cropcode==1040 //Cocoyam medians for heaps by K&O, but they do not differentiate by size while LSMS does.
*replace conv_fact = 1.01 if unit==90 & inrange(zone, 3, 6) & cropcode==1040 

replace conv_fact = 1.36 if (unit==20 | unit==30) & size==0 & conv_fact==. //Lower estimate given by Kormawa and Ogundapo
replace conv_fact = 1.5 if (unit==20 | unit==30) & (size==1 | size==.) & conv_fact==. //congo/mudu value from LSMS W1, assuming medium if left blank
replace conv_fact = 1.74 if (unit==20 | unit==30) & size==2 & conv_fact==. //Upper estimate by K&O
replace conv_fact = 2.72 if unit==50 & size==0 & conv_fact==. //1 tiya=2 mudu
replace conv_fact = 3 if unit==50 & (size==1 | size==.) & conv_fact==. //2x med mudu
replace conv_fact = 3.48 if unit==50 & size==2 & conv_fact==. //2x lg mudu
replace conv_fact = 0.35 if unit==40 & size==0  & conv_fact==. //Small derica from W1
replace conv_fact = 0.525 if unit==40 & (size==1 | size==.) & conv_fact==. //central value
replace conv_fact = 0.7 if unit==40 & size==2 & conv_fact==. & conv_fact==. //large derica from W1
replace conv_fact = 15 if unit==140 & size==0 & conv_fact==. //Small basket from W1
replace conv_fact = 30 if unit==140 & (size==1 | size==.) & conv_fact==. //Med basket W1
replace conv_fact = 50 if unit==140 & size==2 & conv_fact==. //Lg basket W1
replace conv_fact = 85 if unit==170 & size==. & conv_fact==. //Med wheelbarrow w1 

replace conv_fact = 0.595 if unit==60 & size==0 & conv_fact==. //10 obs from other values put the small kobiowu at 0.595 even 
//The most reliable source I could find for seed packaging suggests that sizes can be 1, 2, 5, 10, 25, or 50 kg packs (but maybe 100 g for some garden plants), so it's impossible to tell what a small, medium, or large sachet would be (whether a grower is referring to the low end or high end of the range, or the whole thing)
drop if hhid==. //Used unmatched unit conversions to try to get some answers in the bulk density groups, but now they're no longer needed.

preserve
gen obs=1 if conv_fact!=.
//Zone is the smallest area over which these values could differ
bys zone cropcode unit size type : egen conv_fact_zone = median(conv_fact) //Not weighting these
bys zone cropcode unit size type : egen obs_zone = sum(obs)
bys cropcode unit size type : egen conv_fact_national = median(conv_fact)
replace conv_fact=conv_fact_zone if obs_zone > 9 & conv_fact==.
replace conv_fact=conv_fact_national if conv_fact==.
keep zone state lga sector ea hhid cropcode conv_fact* unit size type
drop conv_fact_w* 
collapse (median) conv_fact*, by(zone state lga hhid cropcode unit size type)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_seed_unit_conversions.dta", replace //Note that these should not be the same as agricultural conversions for all crops.
restore



//Inferring seed values
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(1 3)
keep zone state lga ea hhid cropcode type qty unit size value conv_fact weight 
recode value(0=.)
gen kg_seed_purchased = qty*conv_fact 
gen val_seed_kg = value/kg_seed_purchased //or pieces
replace val_seed_kg=. if kg_seed_purchased < 0.5 //Just because this is likely to generate outliers.
//replace  val_seed_kg=. if unit==2 | unit==13 | (unit==50 & size==0) | unit==12
replace val_seed_kg=. if val_seed_kg > 10000 | val_seed_kg<0.0001 //Taking care of the obvious outliers, then trimming further.
//Dropping outliers - there might have been some misunderstandings on units b/c some conversions don't make sense
preserve 
collapse (median) val_seed_median=val_seed_kg [aw=weight_pop_rururb], by(cropcode type) 
tempfile seedvals
save `seedvals'
restore
merge m:1 cropcode type using `seedvals', nogen
gen AD = abs(val_seed_kg-val_seed_median)
preserve
//Using median absolute deviation to remove outliers
collapse (median) MAD=AD [aw=weight_pop_rururb], by(cropcode type)
tempfile seedMAD
save `seedMAD'
restore
merge m:1 cropcode type using `seedMAD', nogen
replace MAD=1.486*MAD //using the b value from the normal distribution 
gen is_outlier=1 if AD/MAD>=2
replace val_seed_kg = . if is_outlier==1
drop val_seed_median AD MAD is_outlier

//Even after this step, it might be preferable to use medians rather than hh values, because some are still extreme.


gen obs=1 if conv_fact!=.
bys zone state lga hhid cropcode type : egen val_seed_hh=median(val_seed_kg)

preserve //egen would be easier here, but it doesn't allow weights 
collapse (median) val_seed_lga=val_seed_hh (sum) obs_lga = obs [aw=weight_pop_rururb], by(zone state lga cropcode type) 
tempfile seed_lga
save `seed_lga', replace
restore 

preserve
collapse (median) val_seed_state=val_seed_hh (sum) obs_state=obs [aw=weight_pop_rururb], by(zone state cropcode type)
tempfile seed_state
save `seed_state', replace
restore

preserve 
collapse (median) val_seed_zone=val_seed_hh (sum) obs_zone=obs [aw=weight_pop_rururb], by(zone cropcode type)
tempfile seed_zone
save `seed_zone', replace
restore

preserve
collapse(median) val_seed_national=val_seed_hh [aw=weight_pop_rururb], by (cropcode type)
tempfile seed_national
save `seed_national', replace
restore

merge m:1 zone state lga cropcode type using `seed_lga', nogen
merge m:1 zone state cropcode type using `seed_state', nogen
merge m:1 zone cropcode type using `seed_zone', nogen
merge m:1 cropcode type using `seed_national', nogen

replace val_seed_kg = val_seed_hh if val_seed_kg==.
replace val_seed_kg=val_seed_lga if obs_lga > 9 & val_seed_kg==.
replace val_seed_kg=val_seed_state if obs_state > 9 & val_seed_kg==.
replace val_seed_kg=val_seed_zone if obs_zone > 9 & val_seed_kg==.
replace val_seed_kg=val_seed_national if val_seed_kg==.
collapse (median) val_seed_kg, by(zone state lga ea hhid cropcode type)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_seed_values.dta", replace

***Compiling seed values based on qty planted/plot. Explicit costs were already measured in the crop expenses section - this is to get the implicit costs 
use "${Nigeria_GHS_W4_raw_data}/sect11f_plantingw4.dta", clear //This would have been much easier if the conversion factors were included in this section.
ren s11fq3d_2 unit 
ren s11fq3d_3 size
ren s11fq3d_1 qty
drop if qty==.
ren plotid plot_id

replace unit=280 if (strmatch(s11fq3d_2_os, "MERTIC CUP") | strmatch(s11fq3d_2_os,"METIRC CUP") | strmatch(s11fq3d_2_os,"METRIC CUP") | strmatch(s11fq3d_2_os,"METRICE CUP")) & unit==900
replace qty = qty*10 if strmatch(s11fq3d_2_os,  "10 STEMS OF OKRO")
replace unit =260  if (strmatch(s11fq3d_2_os,  "10 STEMS OF OKRO") | strmatch(s11fq3d_2_os,  "1 PLAINTAIN TREE") | strmatch(s11fq3d_2_os,  "*HEAD*") | strmatch(s11fq3d_2_os,  "*SUCKER*")  /*
*/ | strmatch(s11fq3d_2_os,  "SEEDL*")) & unit==900
//Stems
replace unit=210 if (strmatch(s11fq3d_2_os,  "STEAM") | strmatch(s11fq3d_2_os,  "STALK") | strmatch(s11fq3d_2_os,  "*STEM*") | strmatch(s11fq3d_2_os,  "STEMS") | (cropcode ==1020 & strmatch(s11fq3d_2_os,  "*STAND*"))) & unit==900 //For cassava, stand is a synonym for stem

//Basins
replace unit=150 if (strmatch(s11fq3d_2_os,  "*BASIN*") | strmatch(s11fq3d_2_os,  "*BESIN*")) & unit==900

//Pickups
replace unit=180 if strmatch(s11fq3d_2_os,  "*PICK*UP*") & unit==900

//Bin/Basket
replace unit=10 if (strmatch(s11fq3d_2_os,  "BASKET") | strmatch(s11fq3d_2_os,  "BIN" )) & unit==900

//Pieces
replace unit=80 if (strmatch(s11fq3d_2_os, "*PIECE*") | strmatch(s11fq3d_2_os,  "SEED YAM") | strmatch(s11fq3d_2_os,  "SEEDYAM") | strmatch(s11fq3d_2_os,  "YAM SET")) & unit==900

//Heaps
replace unit=90 if strmatch(s11fq3d_2_os,  "HEAP*") & unit==900

//Bundles
replace unit=100 if strmatch(s11fq3d_2_os, "BUNDLE*") & unit==900


replace size=. if unit==11 /* Only one large paint rubber
				*/ | unit==80 /* Pieces
				*/ | unit==100 /* Bundles - ignoring size for the time being
				*/ | unit==110 /* Stalks
				*/ | unit==210 /* Stems
				*/ | unit==211 /* Tubers
				*/ | unit==260 /* Seedlings
				*/ | unit==1 | unit==2 /* No different sizes for g/kg
				*/ | unit==10 /* Only one medium bin/basket 
				*/ | (unit==90 & cropcode==1020) //testing the hypothesis that cassava heaps are individual units

gen type=1 if (cropcode==1020 & unit==100) | (cropcode==2230 & unit==100) | unit==110 | unit==80 | unit==210 | unit==211 | unit==260 | (unit==90 & cropcode==1020) //If unit is some form of countable thing, type is 1. This keeps piece rates and seed rates separate.
recode type (.=0)
merge m:1 zone state lga hhid cropcode unit size type using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_seed_unit_conversions.dta", nogen keep(1 3)
merge m:1 hhid cropcode type using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_seed_values.dta", nogen keep(1 3)
merge 1:1 hhid plot_id cropcode using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_seed_costs.dta", nogen keepusing(val_seed_ex)
gen qty_seed = conv_fact*qty
gen val_seed = val_seed_kg*qty_seed
replace val_seed_ex=val_seed if val_seed_ex > val_seed
gen val_seed_im = val_seed - val_seed_ex
recode val_seed* (.=0)
collapse (sum) val_seed* qty_seed*, by (hhid plot_id)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
gen qty_seed_male = qty_seed if dm_gender==1
gen qty_seed_female = qty_seed if dm_gender==2
gen qty_seed_mixed = qty_seed if dm_gender==3
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_seed_values.dta", replace

gen val_seed_im_male = val_seed_im if dm_gender==1
gen val_seed_ex_male = val_seed_ex if dm_gender==1
gen val_seed_im_female = val_seed_im if dm_gender==2
gen val_seed_ex_female = val_seed_ex if dm_gender==2
gen val_seed_im_mixed = val_seed_im if dm_gender==3
gen val_seed_ex_mixed = val_seed_ex if dm_gender==3
/* ALT 07.14.20 Not necessary?
//monocropped plots
foreach cn in $topcropname_area{
	preserve
	merge m:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_`cn'_monocrop.dta", nogen /*assert(1 3)*/ keep(3)
	foreach i in val_seed_ex val_seed_im {
		gen `i'_`cn'=`i'
		gen `i'_`cn'_male = `i' if dm_gender==1
		gen `i'_`cn'_female = `i' if dm_gender==2
		gen `i'_`cn'_mixed = `i' if dm_gender==3
	}
	collapse (sum) val_seed*, by(hhid)	
	lab var val_seed_ex_`cn' "Value of purchased seed used on monocropped `cn' plots only"
	lab var val_seed_im_`cn' "Value of free/own seed used on monocropped `cn' plots only"

	foreach g in male female mixed {		
	lab var val_seed_ex_`cn'_`g' "Value of purchased seed used on monocropped `cn' `g' plots only"
	lab var val_seed_im_`cn'_`g' "Value of free/own seed used on monocropped `cn' `g' plots only"
	}
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cost_seed_`cn'.dta", replace
	restore
}
*/

collapse (sum) val_seed* qty_seed*, by(hhid) //ALT: Difficult to deal with piece/weight differences here. 
//ALT: 585 entries still missing a conversion factor; issues are primarily vague units like bunches, bundles, sachets, and heaps.
//One problem is the bin/basket conversion, which ranges from 2kg - 6kg in w3. A bin of potatoes weighs >6kg, and potatoes have a bulk density of around 1.07.
//Another problem is that cocoyam culture in Nigeria is that cocoyam cultivation is not well documented, so it's not clear if they're planting corms/cormels or stems. 

ren val_seed_ex val_seed_ex_hh 
ren val_seed_im val_seed_im_hh

save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_seed.dta", replace
*/

********************************************************************************
*WOMEN'S DIET QUALITY
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE
********************************************************************************
* since the diet variable is available in both PP and PH datasets, we first append the two together
use "${Nigeria_GHS_W4_raw_data}/sect7b_plantingw4.dta" , clear
keep zone state lga sector ea hhid item_cd s7bq1
gen survey="PP"
preserve
use "${Nigeria_GHS_W4_raw_data}/sect10b_harvestw4.dta" , clear
keep zone state lga sector ea hhid item_cd s10bq1
ren  s10bq1  s7bq1 // ren the variable indicating household consumption of food items to harminize accross data set
gen survey="PH"
tempfile diet_ph
save `diet_ph'
restore 
append using `diet_ph'
* We recode food items to map to India food groups used as reference

recode item_cd 	    (10 11 13 14 16 19 20/23 25 28   		=1	"CEREALS")  ///
					(17 18 30/38    						=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES")  ///
					(78  70/77 79	 						=3	"VEGETABLES")  ///
					( 60/69 145/147 601						=4	"FRUITS")  ///
					(80/82 90/96 29 						=5	"MEAT")  ///
					(83/85									=6	"EGGS")  ///
					(100/107  								=7  "FISH") ///
					(43/48 40/42   							=8  "LEGUMES, NUTS AND SEEDS") ///
					(110/115								=9	"MILK AND MILK PRODUCTS")  ///
					(50/56   								=10	"OILS AND FATS")  ///
					(26 27 130/133 121 152/155				=11	"SWEETS")  ///
					(76 77 140/144 120 122 150 151 160/164	=12	"SPICES, CONDIMENTS, BEVERAGES"	) ///
					(150 151 								=. ) ///
					,generate(Diet_ID)	
gen adiet_yes=(s7bq1==1)
ta Diet_ID   
** Now, we collapse to food group level assuming that if an a household consumes at least one food item in a food group,
* then he has consumed that food group. That is equivalent to taking the MAX of adiet_yes
collapse (max) adiet_yes, by(hhid survey Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid survey )
collapse (mean) adiet_yes, by(hhid )
/*
There are no established cut-off points in terms of number of food groups to indicate
adequate or inadequate dietary diversity for the HDDS. 
Can use either cut-off or 6 (=12/2) or cut-off=mean(socore) 
*/
ren adiet_yes number_foodgroup 
local cut_off1=6
sum number_foodgroup
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2') 
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week - average PP and PH"
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2PP' of the 12 food groups last week - average PP and PH"
label var number_foodgroup "Number of food groups individual consumed last week HDDS="
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_household_diet.dta", replace

********************************************************************************
*WOMEN'S CONTROL OVER INCOME
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*Inmost cases, NGA LSMS 3 lsit the first TWO decision makers.
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", clear
tempfile hh_members
save `hh_members'

* control of harvest from annual crops
use "${Nigeria_GHS_W4_raw_data}/secta3i_harvestw4", clear //use the data that says who controls crop income
keep plotid cropcode hhid sa3iq6e*
drop if (plotid == . & cropcode == .) //the crop income control questions were not answered for any observation w/o plotid and cropcode, so no data important for this section is lost by dropping these
gen control_cropincome = 0 
reshape long sa3iq6e_, i(hhid plotid cropcode) j(j) //arrange the data long, so each hhid comes with a list of who controls crop income in the household, which can be merged later with all the individuals in the household to determine who controls assets
ren sa3iq6e_ income_controller
keep hhid income_controller control_cropincome 
drop if income_controller == .
replace control_cropincome = 1 if  !inlist( income_controller, .,0,99, 98)
tempfile annual_harvest_temp //After this section, we have a list of people who own assets. We will later merge this list with a full list of people who live in these households, to determine who owns assets and who doesn't.
save `annual_harvest_temp'


* control_annualsales 
use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestw4", clear
preserve
reshape long sa3iiq9_, i(hhid cropcode) j(j)
keep sa3iiq9_ hhid
ren sa3iiq9_ income_controller
drop if income_controller == .
duplicates drop hhid income_controller, force
merge 1:m hhid income_controller using `annual_harvest_temp', nogen
replace control_cropincome = 1 if  !inlist( income_controller, .,0,99, 98) 
tempfile annual_sales_temp 
save `annual_sales_temp'

* append who controls earning from sale to customer 2
restore
reshape long sa3iiq23_, i(hhid cropcode) j(j)
keep sa3iiq23_ hhid 
ren sa3iiq23_ income_controller
drop if income_controller == .
duplicates drop hhid income_controller, force
merge 1:m hhid income_controller using `annual_sales_temp', nogen
replace control_cropincome = 1 if  !inlist( income_controller, .,0,99, 98) 
tempfile annual_sales2_temp 
save `annual_sales2_temp'

* control_businessincome
use "${Nigeria_GHS_W4_raw_data}/sect9b_harvestw4.dta", clear
gen control_businessincome = 0
ren s9q5b1 s9q5a3
ren s9q5b2 s9q5a4
reshape long s9q5a, i(hhid ent_id) j(j)
keep s9q5a hhid  control_businessincome
ren s9q5a income_controller
drop if income_controller == .
duplicates drop hhid income_controller, force
merge 1:m hhid income_controller using `annual_sales2_temp', nogen
replace control_businessincome = 1 if  !inlist( income_controller, .,0,99, 98)
tempfile business_temp 
save `business_temp'

* control_wageincome
use "${Nigeria_GHS_W4_raw_data}/sect3a_harvestw4.dta", clear
gen control_wageincome = 0
reshape long s3q22_, i(hhid indiv) j(j)
keep s3q22_ hhid control_wageincome
ren s3q22_ income_controller
drop if income_controller == .
duplicates drop hhid income_controller, force
merge 1:m hhid income_controller using `business_temp', nogen
replace control_wageincome = 1 if  !inlist( income_controller, .,0,99, 98) 
tempfile wage_temp
save `wage_temp'

* control_otherincome
use "${Nigeria_GHS_W4_raw_data}/sect13_harvestw4.dta", clear
gen control_otherincome = 0
reshape long s13q3_, i(hhid source_cd) j(j)
keep s13q3_ hhid control_otherincome
ren s13q3_ income_controller
drop if income_controller == .
duplicates drop hhid income_controller, force
merge 1:m hhid income_controller using `wage_temp', nogen
replace control_otherincome = 1 if  !inlist( income_controller, .,0,99, 98) 

//W3 has information about the control of earnings from processed crop sales, livestock, interest from saving, income from renting property that is not available for this indicator in W4


duplicates drop income_controller hhid, force
gen control_all_income = 1
ren income_controller indiv
merge 1:m hhid indiv using `hh_members', nogen
recode 	control_all_income (.=0)	 //will be missing for any individual who wasn't listed before the merge, and therefore doesn't control any income

													

lab var control_cropincome "1=individual has control over crop income"
lab var control_wageincome "1=individual has control over wage income"
lab var control_businessincome "1=individual has control over business income"
lab var control_otherincome "1=individual has control over non-farm (business or remittances) income"
lab var control_all_income "1=individual has control over at least one type of income"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_control_income.dta", replace



********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
********************************************************************************

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", clear
tempfile hh_members
save `hh_members'


* comment
use "${Nigeria_GHS_W4_raw_data}/sect11a1_plantingw4.dta", clear
gen make_decision_crop = 0
ren s11aq6a s11aq6_1
ren s11aq6b s11aq6_2
ren s11aq6c s11aq6_3
ren s11aq6d s11aq6_4
reshape long s11aq6_, i(hhid plotid) j(j)
ren s11aq6_ decision_maker
keep hhid decision_maker make_decision_crop
drop if decision_maker == .
replace make_decision_crop = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile plot_decisions
save `plot_decisions'

use "${Nigeria_GHS_W4_raw_data}/sect11e1_plantingw4.dta", clear
reshape long s11eq15_, i(hhid seedid) j(j)
ren s11eq15_ decision_maker
keep hhid decision_maker 
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `plot_decisions', nogen
replace make_decision_crop = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile planting_input
save `planting_input'

use "${Nigeria_GHS_W4_raw_data}/secta1_harvestw4.dta", clear
ren sa1q2 decision_maker
keep decision_maker hhid
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `planting_input', nogen
replace make_decision_crop = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile planting_input2
save `planting_input2'

use "${Nigeria_GHS_W4_raw_data}/secta1_harvestw4.dta", clear
reshape long sa1q2c_, i(hhid plotid) j(j)
ren sa1q2c_ decision_maker
keep decision_maker hhid
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `planting_input2', nogen
replace make_decision_crop = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile planting_input3
save `planting_input3'
 
use "${Nigeria_GHS_W4_raw_data}/secta11c3_harvestw4.dta", clear 
gen paid_for_inorganic_fertilizer_1 = s11c3q3_1 if (inputid == 2 | inputid == 3 | inputid == 4)
gen paid_for_inorganic_fertilizer_2 = s11c3q3_2 if (inputid == 2 | inputid == 3 | inputid == 4)
gen paid_for_inorganic_fertilizer_3 = s11c3q3_3 if (inputid == 2 | inputid == 3 | inputid == 4)
reshape long paid_for_inorganic_fertilizer_, i(hhid inputid) j(j)
ren paid_for_inorganic_fertilizer_ decision_maker
keep decision_maker hhid
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `planting_input3', nogen
replace make_decision_crop = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile planting_input4
save `planting_input4'

use "${Nigeria_GHS_W4_raw_data}/secta3ii_harvestw4.dta", clear
reshape long sa3iiq8_, i(hhid cropcode) j(j)
ren sa3iiq8_ decision_maker
keep decision_maker hhid
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `planting_input4', nogen
replace make_decision_crop = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile sales_processedcrop
save `sales_processedcrop'


* keep/manage livesock
use "${Nigeria_GHS_W4_raw_data}/sect11i_plantingw4.dta", clear
reshape long s11iq4_, i(hhid animal_cd) j(j)
ren s11iq4_ decision_maker
keep decision_maker hhid
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `sales_processedcrop', nogen
gen make_decision_livestock = 0
replace make_decision_livestock = 1 if !inlist( decision_maker, .,0,99, 98)
tempfile livestockowners
save `livestockowners'

* keep/manage livesock
use "${Nigeria_GHS_W4_raw_data}/sect11i_plantingw4.dta", clear
reshape long s11iq5_, i(hhid animal_cd) j(j)
ren s11iq5_ decision_maker
keep decision_maker hhid
drop if decision_maker == .
duplicates drop hhid decision_maker, force
merge 1:m hhid decision_maker using `livestockowners', nogen
replace make_decision_livestock = 1 if !inlist( decision_maker, .,0,99, 98)
ren decision_maker indiv
duplicates drop hhid indiv, force
merge 1:m hhid indiv using `hh_members', nogen
sort hhid indiv

gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode make_decision_ag (.=0)
recode make_decision_crop (.=0)
recode make_decision_livestock (.=0)

keep make_decision_crop make_decision_livestock make_decision_ag female age  hhid indiv
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_make_ag_decision.dta", replace


********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* In most cases, NGA LSMS 3 as the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${Nigeria_GHS_W4_raw_data}/sect11b1_plantingw4.dta", clear 
keep hhid plotid s11b1q6* s11b1q22* s11b1q8b2* //keep the variables relevant to asset ownership
reshape long s11b1q6_ s11b1q22_ s11b1q8b2_, i(hhid plotid) j(j) //format so that each hhid has lists of asset owners that can later be compared to its list of residents
drop j plotid  //plotid is only needed to uniquely identify observations in the reshape, j is created by the reshape and does not represent anything
drop if s11b1q6_==. & s11b1q22_==. & s11b1q8b2_==. //drop observations where the questions relevant to this section were unanswered
duplicates drop hhid s11b1q6_, force //duplicates happen when one person opens multiple plots, not relavent to what we are tracking in this section
preserve // save all variables as they currently are, will be needed later

keep hhid s11b1q22_ // look at who in each household has the right to sell a plot
ren s11b1q22_ indiv //change the name so the data can be merged
duplicates drop hhid indiv, force //duplicates occur when someone has rights to more than one plot, which is not relevant to counting asset owners
tempfile can_sell_plots //save data for later
save `can_sell_plots'

restore 
preserve
keep hhid s11b1q8b2_ //see whose name household Right of Occupancy is under
ren s11b1q8b2_ indiv //change the name so that the data can be merged
duplicates drop hhid indiv, force //duplicates occur when someone has rights to more than one plot, which is not relevant to counting asset owners
tempfile right_of_occupancy //save data for later
save `right_of_occupancy'

restore 
keep hhid s11b1q6_ //see who in each household owns a plot or plots
ren s11b1q6_ indiv //prepare data to be merged

merge 1:m hhid indiv using `can_sell_plots', nogen //in each household, more than one person can own a plot, and one person can own multiple plots, so there were not unique identifier in either the long or wide direction
merge 1:m hhid indiv using `right_of_occupancy', nogen //so merging the variables like this was the best way to obtain lists of who in each household owned at least one asset
drop if indiv == .
gen type_asset = "landowners"

tempfile sect11assets1_temp //After this section, we have a list of people who own assets. We will later merge this list with a full list of people who live in these households, to determine who owns assets and who doesn't.
save `sect11assets1_temp' //But first, we must add to the list of asset owners, by adding people who own different types of assets, so we save this data to be used later.


use "${Nigeria_GHS_W4_raw_data}/secta1_harvestw4.dta", clear 
keep hhid plotid sa1q2c* //look at other people in the household who can make decisions about each plot
reshape long sa1q2c_ , i(hhid plotid) j(j) //format so that each hhid has a list of asset owners that can later be compared to its list of residents
drop j plotid  //j was created by the reshape and not descriptive of anything,  plotid is no longer needed for the asset ownership section
drop if sa1q2c_==.  //drop observations where the questions relevant to this section were unanswered
duplicates drop hhid sa1q2c_, force //duplicates happen when one person opens multiple plots, not relavent to what we are tracking in this section

ren sa1q2c_ indiv //this rename allows the file with the variables from prior sections to be merged in, where non-duplicate asset owners FIX THIS
merge m:1 hhid indiv using  `sect11assets1_temp', nogen //merge with asset ownership data from the prior section, to create a list of all the asset owners we know of so far
replace type_asset="landowners" if type_asset == "" // go back and change this to the missing string thing

tempfile sect11assets2_temp 
save `sect11assets2_temp' //save the combined asset owner list, so we can get more asset ownership data now and merge with individual data later


use "${Nigeria_GHS_W4_raw_data}/sect11i_plantingw4.dta", clear
keep hhid animal_cd s11iq4* //keep the variables relevant to asset ownership
reshape long s11iq4_, i(hhid animal_cd) j(j) //format so that each hhid has lists of asset owners that can later be compared to its list of residents
drop j animal_cd //not relevant 
drop if s11iq4_ ==. //drop observations where the questions relevant to this section were unanswered
duplicates drop hhid s11iq4_, force //duplicates happen when one person opens multiple plots, not relavent to what we are tracking in this section
ren s11iq4_ indiv // allows data to be merged 
merge m:1 hhid indiv using `sect11assets2_temp', nogen //merge with asset ownership data from the prior section, to create a list of all the asset owners we know of so far
replace type_asset="livestockowners" if type_asset == "" 
tempfile sect11assets3_temp //save the combined asset owner list, so we can get more asset ownership data now and merge with individual data later
save `sect11assets3_temp' 


use "${Nigeria_GHS_W4_raw_data}/secta4_harvestw4.dta", clear
keep hhid item_cd sa4q2* //keep the variables relevant to asset ownership
reshape long sa4q2_, i(hhid item_cd) j(j) //format so that each hhid has lists of asset owners that can later be compared to its list of residents
drop j item_cd //not relevant to asset ownership
drop if sa4q2_ ==. //drop observations where the questions relevant to this section were unanswered
duplicates drop hhid sa4q2_, force //duplicates happen when one person opens multiple plots, not relavent to what we are tracking in this section
ren sa4q2_ indiv  // prepare data to be merged
merge m:1 hhid indiv using `sect11assets3_temp', nogen //merge with asset ownership data from the prior section, to create a list of all the asset owners we know of so far
replace type_asset="equipmentowners" if type_asset == "" //FIX THIS
tempfile sect11assets4_temp //save the combined asset owner list, so we can get more asset ownership data now and merge later
save `sect11assets4_temp' 


use "${Nigeria_GHS_W4_raw_data}/sect5_plantingw4.dta", clear
keep hhid item_cd s5q2* //keep the variables relevant to asset ownership
reshape long s5q2_, i(hhid item_cd) j(j) //format so that each hhid has lists of asset owners that can later be compared to its list of residents
drop j item_cd //not relevant to asset ownership
drop if s5q2_ ==. //drop observations where the questions relevant to this section were unanswered
duplicates drop hhid s5q2_, force //duplicates happen when one person opens multiple plots, not relavent to what we are tracking in this section
ren s5q2_ indiv //prepare data to be merged
merge m:1 hhid indiv using `sect11assets4_temp', nogen 
replace type_asset="equipmentowners" if type_asset == "" 


gen own_asset = 1 // everyone individual currently in the list of observations got in there by owning an asset of some sort
merge m:1 hhid indiv using "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_person_ids.dta", nogen //merge the list of asset owners with the full list of individuals
sort hhid indiv  //sorting makes it easier to verify that everything worked properly
replace own_asset=0 if own_asset == . //asset_owner will be missing for any individual who wasn't listed before the merge, and therefore doesn't own an asset


//ren asset_owner own_asset // FIX THIS
lab var own_asset "1=invidual owns an assets (land or livestock or agricultural capital)"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_ownasset.dta", replace



********************************************************************************
*AGRICULTURAL WAGES
********************************************************************************
//ALT 05.11.21: Moved to crop expenses


********************************************************************************
*CROP YIELDS
********************************************************************************
//ALT: This section is still here for legacy file compatibility; the data have already been generated by this point, it's just a matter of reshaping them into a format that later code will accept. With some modification to the final variables code, this section could be shortened significantly.
/*File structure:
	in hh_crop_area_plan.dta (by hhid crop_code):
		Prefixes:
			harvest
			area_plan
			area_harv 
		Suffixes: (inter pure)x(male female mixed)
	in hh_area_planted_harvested_allcrops.dta:
		all_area_harvested (sum area_harv)
		all_area_planted (sum area_plan)
	in crop_harvest_area_yield.dta
		Same as crop_area_plan, filtered to the topcrops.
	in yield_hh_crop_level.dta:
		Prefixes: 
			harvest
			area_harv
			area_plan
		Suffixes: (inter pure)x(male female mixed)x(crop)
			total_planted_area 
			total_harv_area
			value_harv 
			value_sold 
			harvested 
			grew
			kgs_harvest 
		Suffixes: crop (only)
*/
/* no longer necessary
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
ren cropcode crop_code
gen number_trees_planted_banana = number_trees_planted if crop_code==2030 
gen number_trees_planted_cassava = number_trees_planted if crop_code==1020 
gen number_trees_planted_cocoa = number_trees_planted if crop_code==3040
recode number_trees_planted_banana number_trees_planted_cassava number_trees_planted_cocoa (.=0) 
collapse (sum) number_trees_planted*, by(hhid)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_trees.dta", replace
*/

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
ren cropcode crop_code
drop if hhid== 200156 | hhid==200190 | hhid==310091 // households that have an area planted or harvested but indicated that they rented out or did not cultivate 
gen grew_=1
gen harvested_ = (quant_harv_kg!=0 & quant_harv_kg!=.) | (ha_harvest!=0 & ha_harvest!=.)
collapse (max) grew_ harvested_, by(hhid crop_code)
merge m:1 crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", nogen keep(3)
keep hhid crop_name grew_ harvested_
fillin hhid crop_name
drop _fillin
recode grew_ harvested_ (.=0)
reshape wide grew_ harvested_, i(hhid) j(crop_name) string
tempfile grew_crops
save `grew_crops'



use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
ren cropcode crop_code
gen no_harvest=ha_harvest==.
ren quant_harv_kg harvest 
ren ha_plan_yld area_plan
ren ha_harv_yld area_harv 
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

collapse (sum) harvest* area* (max) no_harvest, by(hhid crop_code)
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
drop no_harvest
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_area_plan.dta", replace


*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_area_planted_harvested_allcrops.dta", replace
restore


keep if inlist(crop_code, $comma_topcrop_area)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_crop_harvest_area_yield.dta", clear
*Value of crop production
merge m:1 crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropname_table.dta", nogen keep(1 3)
merge m:1 hhid crop_code using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production.dta", nogen keep(1 3) // HS 4/14/23: Switched 1:1 to m:1 to allow for multiple yam observations following recode of yam varietis to just yam
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_

drop crop_code
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string
//merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_trees.dta"
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*ren variable
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (Naira) (household)" 
	lab var value_sold_`p' "Value sold of `p' (Naira) (household)" 
	lab var kgs_harvest_`p'  "Quantity harvested of `p' (kgs) (household) (summed accross all seasons)" 
	lab var total_harv_area_`p'  "Total area harvested of `p' (ha) (household) (summed accross all seasons)" 
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

drop if hhid== 200156 | hhid==200190 | hhid==310091 // households that have an area planted or harvested but indicated that they rented out or did not cultivate 
merge 1:1 hhid using `grew_crops', nogen
foreach p of global topcropname_area {
	//gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	//gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}

/* No longer necessary
replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
replace grew_cassav =1 if number_trees_planted_cassava!=0 & number_trees_planted_cassava!=. 
replace grew_cocoa =1 if number_trees_planted_cocoa!=0 & number_trees_planted_cocoa!=. 
*/
//drop harvest- harvest_pure_mixed area_harv- area_harv_pure_mixed area_plan- area_plan_pure_mixed value_harv value_sold total_planted_area total_harv_area  
//ALT 08.16.21: No drops necessary; only variables here are the ones that are listed in the labeling block above.
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production.dta", clear
*Grouping following IMPACT categories but also mindful of the consumption categories.
//ren cropcode crop_code
gen crop_group=""
replace crop_group=	"Beans and cowpeas"	if crop_code==	1010
replace crop_group=	"Cassava"	if crop_code==	1020
replace crop_group=	"Cocoyam"	if crop_code==	1040
replace crop_group=	"Cotton"	if crop_code==	1050
replace crop_group=	"Cotton"	if crop_code==	1051
replace crop_group=	"Cotton"	if crop_code==	1052
replace crop_group=	"Cotton"	if crop_code==	1053
replace crop_group=	"Groundnuts"	if crop_code==	1060
replace crop_group=	"Groundnuts"	if crop_code==	1061
replace crop_group=	"Groundnuts"	if crop_code==	1062
replace crop_group=	"Sorghum"	if crop_code==	1070
replace crop_group=	"Maize"	if crop_code==	1080
replace crop_group=	"Maize"	if crop_code==	1081
replace crop_group=	"Maize"	if crop_code==	1082
replace crop_group=	"Maize"	if crop_code==	1083
replace crop_group=	"Fruits"	if crop_code==	1090
replace crop_group=	"Fruits"	if crop_code==	1091
replace crop_group=	"Fruits"	if crop_code==	1092
replace crop_group=	"Fruits"	if crop_code==	1093
replace crop_group=	"Millet"	if crop_code==	1100
replace crop_group=	"Rice"	if crop_code==	1110
replace crop_group=	"Rice"	if crop_code==	1111
replace crop_group=	"Rice"	if crop_code==	1112
replace crop_group=	"Yam"	if crop_code==	1120
replace crop_group=	"Yam"	if crop_code==	1121
replace crop_group=	"Yam"	if crop_code==	1122
replace crop_group=	"Yam"	if crop_code==	1123
replace crop_group=	"Yam"	if crop_code==	1124
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2010
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2020
replace crop_group=	"Bananas"	if crop_code==	2030
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2040
replace crop_group=	"Vegetables"	if crop_code==	2050
replace crop_group=	"Vegetables"	if crop_code==	2060
replace crop_group=	"Vegetables"	if crop_code==	2070
replace crop_group=	"Vegetables"	if crop_code==	2071
replace crop_group=	"Fruits"	if crop_code==	2080
replace crop_group=	"Spices"	if crop_code==	2090
replace crop_group=	"Spices"	if crop_code==	2100
replace crop_group=	"Spices"	if crop_code==	2101
replace crop_group=	"Spices"	if crop_code==	2102
replace crop_group=	"Vegetables"	if crop_code==	2103
replace crop_group=	"Vegetables"	if crop_code==	2110
replace crop_group=	"Vegetables"	if crop_code==	2120
replace crop_group=	"Vegetables"	if crop_code==	2130
replace crop_group=	"Vegetables"	if crop_code==	2140
replace crop_group=	"Vegetables"	if crop_code==	2141
replace crop_group=	"Vegetables"	if crop_code==	2142
replace crop_group=	"Other other"	if crop_code==	2143
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2150
replace crop_group=	"Fruits"	if crop_code==	2160
replace crop_group=	"Plantains"	if crop_code==	2170
replace crop_group=	"Potato"	if crop_code==	2180
replace crop_group=	"Sweet potato"	if crop_code==	2181
replace crop_group=	"Vegetables"	if crop_code==	2190
replace crop_group=	"Vegetables"	if crop_code==	2191
replace crop_group=	"Vegetables"	if crop_code==	2192
replace crop_group=	"Vegetables"	if crop_code==	2193
replace crop_group=	"Vegetables"	if crop_code==	2194
replace crop_group=	"Vegetables"	if crop_code==	2195
replace crop_group=	"Other other"	if crop_code==	2200
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2210
replace crop_group=	"Soyabean"	if crop_code==	2220
replace crop_group=	"Sugar"	if crop_code==	2230
replace crop_group=	"Tea"	if crop_code==	2240
replace crop_group=	"Other other"	if crop_code==	2250
replace crop_group=	"Vegetables"	if crop_code==	2260
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	2270
replace crop_group=	"Wheat"	if crop_code==	2280
replace crop_group=	"Other other"	if crop_code==	2290
replace crop_group=	"Other other"	if crop_code==	2291
replace crop_group=	"Fruits"	if crop_code==	3010
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3020
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3021
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3022
replace crop_group=	"Spices"	if crop_code==	3030
replace crop_group=	"Cocoa"	if crop_code==	3040
replace crop_group=	"Cocoa"	if crop_code==	3041
replace crop_group=	"Cocoa"	if crop_code==	3042
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3050
replace crop_group=	"Coffee"	if crop_code==	3060
replace crop_group=	"Coffee"	if crop_code==	3061
replace crop_group=	"Coffee"	if crop_code==	3062
replace crop_group=	"Other other"	if crop_code==	3070
replace crop_group=	"Fruits"	if crop_code==	3080
replace crop_group=	"Fruits"	if crop_code==	3090
replace crop_group=	"Fruits"	if crop_code==	3100
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3110
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3111
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3112
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3113
replace crop_group=	"Fruits"	if crop_code==	3120
replace crop_group=	"Fruits"	if crop_code==	3130
replace crop_group=	"Other other"	if crop_code==	3140
replace crop_group=	"Fruits"	if crop_code==	3150
replace crop_group=	"Fruits"	if crop_code==	3160
replace crop_group=	"Fruits"	if crop_code==	3170
replace crop_group=	"Oils and fats"	if crop_code==	3180
replace crop_group=	"Fruits"	if crop_code==	3181
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	3182
replace crop_group=	"Oils and fats"	if crop_code==	3183
replace crop_group=	"Oils and fats"	if crop_code==	3184
replace crop_group=	"Oils and fats"	if crop_code==	3190
replace crop_group=	"Oils and fats"	if crop_code==	3200
replace crop_group=	"Fruits"	if crop_code==	3210
replace crop_group=	"Fruits"	if crop_code==	3220
replace crop_group=	"Fruits"	if crop_code==	3221
replace crop_group=	"Other other"	if crop_code==	3230
replace crop_group=	"Other other"	if crop_code==	3231
replace crop_group=	"Other other"	if crop_code==	3232
replace crop_group=	"Vegetables"	if crop_code==	3240
replace crop_group=	"Vegetables"	if crop_code==	3250
replace crop_group=	"Vegetables"	if crop_code==	3260

ren  crop_group commodity

*High/low value crops
gen type_commodity=""
/* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"Low"	if crop_code==	1010
replace type_commodity=	"Low"	if crop_code==	1020
replace type_commodity=	"Low"	if crop_code==	1040
replace type_commodity=	"High"	if crop_code==	1050
replace type_commodity=	"High"	if crop_code==	1051
replace type_commodity=	"High"	if crop_code==	1052
replace type_commodity=	"High"	if crop_code==	1053
replace type_commodity=	"Low"	if crop_code==	1060
replace type_commodity=	"Low"	if crop_code==	1061
replace type_commodity=	"Low"	if crop_code==	1062
replace type_commodity=	"Low"	if crop_code==	1070
replace type_commodity=	"Low"	if crop_code==	1080
replace type_commodity=	"Low"	if crop_code==	1081
replace type_commodity=	"Low"	if crop_code==	1082
replace type_commodity=	"Low"	if crop_code==	1083
replace type_commodity=	"High"	if crop_code==	1090
replace type_commodity=	"High"	if crop_code==	1091
replace type_commodity=	"High"	if crop_code==	1092
replace type_commodity=	"High"	if crop_code==	1093
replace type_commodity=	"Low"	if crop_code==	1100
replace type_commodity=	"Low"	if crop_code==	1110
replace type_commodity=	"Low"	if crop_code==	1111
replace type_commodity=	"Low"	if crop_code==	1112
replace type_commodity=	"Low"	if crop_code==	1120
replace type_commodity=	"Low"	if crop_code==	1121
replace type_commodity=	"Low"	if crop_code==	1122
replace type_commodity=	"Low"	if crop_code==	1123
replace type_commodity=	"Low"	if crop_code==	1124
replace type_commodity=	"Low"	if crop_code==	2010
replace type_commodity=	"Low"	if crop_code==	2020
replace type_commodity=	"High"	if crop_code==	2030
replace type_commodity=	"Low"	if crop_code==	2040
replace type_commodity=	"High"	if crop_code==	2050
replace type_commodity=	"High"	if crop_code==	2060
replace type_commodity=	"High"	if crop_code==	2070
replace type_commodity=	"High"	if crop_code==	2071
replace type_commodity=	"High"	if crop_code==	2080
replace type_commodity=	"High"	if crop_code==	2090
replace type_commodity=	"High"	if crop_code==	2100
replace type_commodity=	"High"	if crop_code==	2101
replace type_commodity=	"High"	if crop_code==	2102
replace type_commodity=	"High"	if crop_code==	2103
replace type_commodity=	"High"	if crop_code==	2110
replace type_commodity=	"High"	if crop_code==	2120
replace type_commodity=	"High"	if crop_code==	2130
replace type_commodity=	"High"	if crop_code==	2140
replace type_commodity=	"High"	if crop_code==	2141
replace type_commodity=	"High"	if crop_code==	2142
replace type_commodity=	"High"	if crop_code==	2143
replace type_commodity=	"Low"	if crop_code==	2150
replace type_commodity=	"High"	if crop_code==	2160
replace type_commodity=	"High"	if crop_code==	2170
replace type_commodity=	"High"	if crop_code==	2180
replace type_commodity=	"High"	if crop_code==	2181
replace type_commodity=	"High"	if crop_code==	2190
replace type_commodity=	"High"	if crop_code==	2191
replace type_commodity=	"High"	if crop_code==	2192
replace type_commodity=	"High"	if crop_code==	2193
replace type_commodity=	"High"	if crop_code==	2194
replace type_commodity=	"High"	if crop_code==	2195
replace type_commodity=	"Low"	if crop_code==	2200
replace type_commodity=	"High"	if crop_code==	2210
replace type_commodity=	"High"	if crop_code==	2220
replace type_commodity=	"High"	if crop_code==	2230
replace type_commodity=	"High"	if crop_code==	2240
replace type_commodity=	"High"	if crop_code==	2250
replace type_commodity=	"High"	if crop_code==	2260
replace type_commodity=	"High"	if crop_code==	2270
replace type_commodity=	"Low"	if crop_code==	2280
replace type_commodity=	"Low"	if crop_code==	2290
replace type_commodity=	"Low"	if crop_code==	2291
replace type_commodity=	"High"	if crop_code==	3010
replace type_commodity=	"High"	if crop_code==	3020
replace type_commodity=	"High"	if crop_code==	3021
replace type_commodity=	"High"	if crop_code==	3022
replace type_commodity=	"High"	if crop_code==	3030
replace type_commodity=	"High"	if crop_code==	3040
replace type_commodity=	"High"	if crop_code==	3041
replace type_commodity=	"High"	if crop_code==	3042
replace type_commodity=	"High"	if crop_code==	3050
replace type_commodity=	"High"	if crop_code==	3060
replace type_commodity=	"High"	if crop_code==	3061
replace type_commodity=	"High"	if crop_code==	3062
replace type_commodity=	"High"	if crop_code==	3070
replace type_commodity=	"High"	if crop_code==	3080
replace type_commodity=	"High"	if crop_code==	3090
replace type_commodity=	"High"	if crop_code==	3100
replace type_commodity=	"High"	if crop_code==	3110
replace type_commodity=	"High"	if crop_code==	3111
replace type_commodity=	"High"	if crop_code==	3112
replace type_commodity=	"High"	if crop_code==	3113
replace type_commodity=	"High"	if crop_code==	3120
replace type_commodity=	"High"	if crop_code==	3130
replace type_commodity=	"Low"	if crop_code==	3140
replace type_commodity=	"High"	if crop_code==	3150
replace type_commodity=	"High"	if crop_code==	3160
replace type_commodity=	"High"	if crop_code==	3170
replace type_commodity=	"High"	if crop_code==	3180
replace type_commodity=	"High"	if crop_code==	3181
replace type_commodity=	"High"	if crop_code==	3182
replace type_commodity=	"High"	if crop_code==	3183
replace type_commodity=	"High"	if crop_code==	3184
replace type_commodity=	"High"	if crop_code==	3190
replace type_commodity=	"High"	if crop_code==	3200
replace type_commodity=	"High"	if crop_code==	3210
replace type_commodity=	"High"	if crop_code==	3220
replace type_commodity=	"High"	if crop_code==	3221
replace type_commodity=	"High"	if crop_code==	3230
replace type_commodity=	"High"	if crop_code==	3231
replace type_commodity=	"High"	if crop_code==	3232
replace type_commodity=	"High"	if crop_code==	3240
replace type_commodity=	"High"	if crop_code==	3250
replace type_commodity=	"High"	if crop_code==	3260 
*/

* CJS 10.21 revising commodity high/low classification
replace type_commodity=	"High"	if crop_code==	1010
replace type_commodity=	"Low"	if crop_code==	1020
replace type_commodity=	"Low"	if crop_code==	1040
replace type_commodity=	"Out"	if crop_code==	1050
replace type_commodity=	"High"	if crop_code==	1060
replace type_commodity=	"Low"	if crop_code==	1070
replace type_commodity=	"Low"	if crop_code==	1080
replace type_commodity=	"High"	if crop_code==	1090
replace type_commodity=	"Low"	if crop_code==	1100
replace type_commodity=	"High"	if crop_code==	1110
replace type_commodity=	"Low"	if crop_code==	1120
replace type_commodity=	"Low"	if crop_code==	1121
replace type_commodity=	"Low"	if crop_code==	1122
replace type_commodity=	"Low"	if crop_code==	1123
replace type_commodity=	"Low"	if crop_code==	1124
replace type_commodity=	"Low"	if crop_code==	2010
replace type_commodity=	"High"	if crop_code==	2020
replace type_commodity=	"Low"	if crop_code==	2030
replace type_commodity=	"High"	if crop_code==	2040
replace type_commodity=	"High"	if crop_code==	2050
replace type_commodity=	"High"	if crop_code==	2060
replace type_commodity=	"High"	if crop_code==	2070
replace type_commodity=	"High"	if crop_code==	2071
replace type_commodity=	"High"	if crop_code==	2080
replace type_commodity=	"High"	if crop_code==	2090
replace type_commodity=	"High"	if crop_code==	2100
replace type_commodity=	"High"	if crop_code==	2120
replace type_commodity=	"High"	if crop_code==	2130
replace type_commodity=	"High"	if crop_code==	2141
replace type_commodity=	"High"	if crop_code==	2142
replace type_commodity=	"High"	if crop_code==	2150
replace type_commodity=	"High"	if crop_code==	2160
replace type_commodity=	"Low"	if crop_code==	2170
replace type_commodity=	"Low"	if crop_code==	2180
replace type_commodity=	"Low"	if crop_code==	2181
replace type_commodity=	"High"	if crop_code==	2190
replace type_commodity=	"High"	if crop_code==	2194
replace type_commodity=	"High"	if crop_code==	2220
replace type_commodity=	"Out"	if crop_code==	2230
replace type_commodity=	"Out"	if crop_code==	2240
replace type_commodity=	"Out"	if crop_code==	2250
replace type_commodity=	"High"	if crop_code==	2260
replace type_commodity=	"High"	if crop_code==	2270
replace type_commodity=	"Low"	if crop_code==	2280
replace type_commodity=	"Out"	if crop_code==	2290
replace type_commodity=	"High"	if crop_code==	3010
replace type_commodity=	"High"	if crop_code==	3020
replace type_commodity=	"High"	if crop_code==	3030
replace type_commodity=	"High"	if crop_code==	3040
replace type_commodity=	"High"	if crop_code==	3050
replace type_commodity=	"High"	if crop_code==	3060
replace type_commodity=	"High"	if crop_code==	3080
replace type_commodity=	"High"	if crop_code==	3090
replace type_commodity=	"High"	if crop_code==	3110
replace type_commodity=	"High"	if crop_code==	3120
replace type_commodity=	"High"	if crop_code==	3130
replace type_commodity=	"High"	if crop_code==	3150
replace type_commodity=	"High"	if crop_code==	3160
replace type_commodity=	"High"	if crop_code==	3170
replace type_commodity=	"Out"	if crop_code==	3180
replace type_commodity=	"High"	if crop_code==	3190
replace type_commodity=	"High"	if crop_code==	3200
replace type_commodity=	"High"	if crop_code==	3210
replace type_commodity=	"High"	if crop_code==	3220
replace type_commodity=	"High"	if crop_code==	3221
replace type_commodity=	"Out"	if crop_code==	3230
replace type_commodity=	"Out"	if crop_code==	9999


preserve
collapse (sum) value_crop_production value_crop_sales, by( hhid commodity) 
ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)
//Topcrop abbrs:
//global topcropname_area "maize rice sorgum millet cowpea grdnt yam swtptt cassav banana cocoa soy" /

foreach s in pro sal {
	ren value_`s'1 value_`s'_banana
	ren value_`s'2 value_`s'_beanc 
	ren value_`s'3 value_`s'_cassav
	ren value_`s'4 value_`s'_cocoa
	ren value_`s'5 value_`s'_cyam
	ren value_`s'6 value_`s'_coton
	ren value_`s'7 value_`s'_fruit 
	ren value_`s'8 value_`s'_grdnt
	ren value_`s'9 value_`s'_maize 
	ren value_`s'10 value_`s'_millet 
	ren value_`s'11 value_`s'_oilc 
	ren value_`s'12 value_`s'_onuts
	ren value_`s'13 value_`s'_oths 
	//ren value_`s'14 value_`s'_plant: This got incorporated into banana
	ren value_`s'14 value_`s'_pota  
	ren value_`s'15 value_`s'_rice
	ren value_`s'16 value_`s'_sorgum 
	ren value_`s'17 value_`s'_soy
	ren value_`s'18 value_`s'_spice
	ren value_`s'19 value_`s'_suga
	ren value_`s'20 value_`s'_swtptt
	ren value_`s'21 value_`s'_vegs
*	ren value_`s'23 value_`s'_whea 
	ren value_`s'22 value_`s'_yam
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
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production_grouped.dta", replace
restore

*type of commodity
collapse (sum) value_crop_production value_crop_sales, by( hhid type_commodity) 
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
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production_type_crop.dta", replace
*End DYA 9.13.2020 


********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*Area planted
*Bringing in area planted for LRS
//ALT: Wave 3 code seems to run okay without modification
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_area_plan.dta", clear
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_shannon_diversity_index.dta", replace


********************************************************************************
*CONSUMPTION
********************************************************************************
*first get adult equivalent
use "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_person_ids.dta", clear
gen adulteq=.
gen gender=female+1
replace adulteq=0.4 if (age<3 & age>=0)
replace adulteq=0.48 if (age<5 & age>2)
replace adulteq=0.56 if (age<7 & age>4)
replace adulteq=0.64 if (age<9 & age>6)
replace adulteq=0.76 if (age<11 & age>8)
replace adulteq=0.80 if (age<=12 & age>10) & gender==1		//1=male, 2=female
replace adulteq=0.88 if (age<=12 & age>10) & gender==2      //ALT 01.07.21: Updated this to be inclusive, otherwise 12-year-olds get left out
replace adulteq=1 if (age<15 & age>12)
replace adulteq=1.2 if (age<19 & age>14) & gender==1
replace adulteq=1 if (age<19 & age>14) & gender==2
replace adulteq=1 if (age<60 & age>18) & gender==1
replace adulteq=0.88 if (age<60 & age>18) & gender==2
replace adulteq=0.8 if (age>59 & age!=.) & gender==1
replace adulteq=0.72 if (age>59 & age!=.) & gender==2
replace adulteq=. if age==999
collapse (sum) adulteq, by(hhid)
lab var adulteq "Adult-Equivalent"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_adulteq.dta", replace

//ALT 03.31.22: This is now available as of data version 3, but the format of the table has changed significantly and can hinder comparison with previous waves. Since the code is here, I keep it and use the spatial deflators to adjust prices.
//ALT: This is something that seemed to have been pre-built for W3 that isn't available in W4. It can be constructed, but we have to do it manually.
//Workflow for this section: generate prices for all items, then put together a consumption table that loosk like cons_agg_w3, then process using W3 code.
*use "${Nigeria_GHS_W4_raw_data}/cons_agg_wave3_visit1.dta", clear
*ren  totcons totcons_v1
*merge 1:1 hhid using "${Nigeria_GHS_W4_raw_data}/cons_agg_wave3_visit2.dta", nogen
*ren  totcons totcons_v2
*merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_adulteq.dta"
*Per the Nigeria BID in Wave 2, we should average the consumption aggregat for the tow visits
*egen totcons=rowmean(totcons_v1 totcons_v2)  
*gen percapita_cons = totcons
*gen daily_percap_cons = percapita_cons/365
*gen total_cons = (totcons *hhsize)
*gen peraeq_cons = total_cons/adulteq
*gen daily_peraeq_cons = peraeq_cons/365
*la var percapita_cons "Yearly HH consumption per person"	
*la var total_cons "Total yearly HH consumption - averaged over two visits"								
*la var peraeq_cons "Yearly HH consumption per adult equivalent"				
*la var daily_peraeq_cons "Daily HH consumption per adult equivalent"		
*la var daily_percap_cons "Daily HH consumption per person" 		
*keep hhid adulteq totcons percapita_cons daily_percap_cons total_cons peraeq_cons daily_peraeq_cons 
*save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_consumption.dta", replace

//Step 1: get prices
//Step 2: fill in missing prices
//Step 3: separate out bought/own production (including gifts as "own") 


	***********
	* Visit 2

use "${Nigeria_GHS_W4_raw_data}/sect11a_harvestw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/sect11b_harvestw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect11c_harvestw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect11d_harvestw4.dta"

gen nfd_ = s11aq2/7 //Per day
replace nfd_ = s11bq4/30 if nfd_==.
replace nfd_ = s11cq6/182.5 if nfd_==.
replace nfd_ = s11dq8/365 if nfd_==.
recode nfd_ (.=0)

keep hhid nfd_ item_cd 
reshape wide nfd_, i(hhid) j(item_cd)
gen nfdtbac = nfd_101+nfd_102 //Tobacco and matches
gen nfdrecre = nfd_103+nfd_105+nfd_322+nfd_506+nfd_507 //"Recreation and culture", here including gambling/lotto and newspapers/magazines
gen nfdfares = nfd_104 //Public transportation
gen nfdwater = nfd_312
gen nfdelec = nfd_305
gen nfdgas = nfd_303
gen nfdkero = nfd_301
gen nfdliqd = nfd_304+nfd_302
gen nfdutil = nfd_509 //Council rates?
egen nfdcloth = rowtotal(nfd_401-nfd_418 nfd_431 nfd_432)
egen nfdfmtn = rowtotal(nfd_311 nfd_323 nfd_324 nfd_325 nfd_330 nfd_419-nfd_427 nfd_433-nfd_439 nfd_501-nfd_505 nfd_508)
gen nfdrepar = nfd_327+nfd_328
gen nfddome = nfd_325
gen nfdpetro = nfd_309
gen nfddiesl = nfd_310
gen nfdcomm = nfd_318+nfd_319+nfd_320+nfd_321+nfd_440+nfd_441
gen nfdinsur = nfd_511+nfd_512+nfd_513
egen nfdfoth =rowtotal(nfd_308 nfd_313-nfd_317 nfd_428 nfd_429 nfd_514 nfd_515 nfd_516 nfd_517) //Added dowry, wedding, and funeral expenses/fines and legal fees
gen nfdfwood = nfd_306
gen nfdchar = nfd_307
gen nfdtrans = 0 //Other transportation. Doesn't appear to have an associated question in W4
gen nfdrnthh = nfd_326+nfd_329
gen nfdhealth = nfd_430 + nfd_510 //Health insurance and non-insurance healthcare expenses
drop nfd_*

merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/totcons_final.dta", nogen keepusing(reg_def_mean)
unab vars : nfd*
foreach i in `vars' {
	gen `i'_def = `i'/reg_def_mean
}
//There are a couple of big-ticket repair bills that likely aren't recurring monthly expenses even though they ask for 30-day recall on those questions. I'm assuming that they should probably be reported as annual expenses rather than monthly ones and rescale to fit.
replace nfdrepar = nfdrepar*30/365 if hhid == 320056 | hhid == 199048
replace nfdrepar_def = nfdrepar*30/365 if hhid == 320056 | hhid == 199048
la var nfdtbac "Tobacco & narcotics"
la var nfdrecre "Recreation and culture"
la var nfdfares "Fares"
la var nfdwater "Water, excluding packaged water"
la var nfdelec "Electricity"
la var nfdgas "Gas"
la var nfdkero "Kerosene"
la var nfdliqd "Other liquid fuels"
la var nfdutil "Refuse, sewage collection, disposal, and other services"
la var nfdcloth "Clothing and footwear"
la var nfdfmtn "Furnishings and routine household maintenance"
la var nfdrepar "Maintenance and repairs to dwelling"
la var nfddome "Domestic household services"
la var nfdpetro "Petrol"
la var nfddiesl "Diesel"
la var nfdtrans "Other transportation (n/a)"
la var nfdcomm "Communication (post, telephone, and computing/internet)"
la var nfdinsur "Other insurance excluding education and health"
la var nfdfoth "Expenditures on frequent non-food not mentioned elsewhere"
la var nfdfwood "Firewood"
la var nfdchar "Charcoal"
la var nfdrnthh "Mortgage and Rent"
la var nfdhealth "Healthcare expenses"

tempfile hhexp
save `hhexp', replace


//Getting prepared foods out of the way
use "${Nigeria_GHS_W4_raw_data}/sect10a_harvestw4.dta", clear
keep if s10aq1==1
gen item_ = s10aq2/7 //Total consumption per day (avg) of prepared foods/beverages
keep hhid item_cd item_ 
reshape wide item_, i(hhid) j(item_cd)
recode item_* (.=0)
gen fdbevby1 = item_6+item_8 
gen fdalcby1 = item_9
gen fdrestby = item_1+item_2+item_3+item_4
gen fdothby1=item_5+item_7
merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/totcons_final.dta", nogen keepusing(reg_def_mean)
gen fdbevby1_def = fdbevby1/reg_def_mean
gen fdalcby1_def = fdalcby1/reg_def_mean 
gen fdothby1_def = fdothby1/reg_def_mean
gen fdrestby_def = fdrestby/reg_def_mean
drop item*
tempfile prepfoods
save `prepfoods', replace


use "${Nigeria_GHS_W4_raw_data}/sect10b_harvestw4.dta", clear
gen obs=1 if s10bq9a != .
keep if s10bq5a!= . | s10bq6a != . | s10bq7a != . 
ren s10bq9a qty_bought 
gen kg_bought = qty_bought*s10bq9_cvn
gen price_kg = s10bq10/kg_bought
//ALT 01.25.21: I've tested this with weighted/unweighted and kg vs unit-based pricing.
//It seems like weighted average per-kgs are producing the most reasonable results, but it is a value judgment.
merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/totcons_final.dta", nogen keep(1 3) keepusing(reg_def_mean)
gen price_kg_def = price_kg/reg_def_mean 
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(3) keepusing(weight_pop_rururb)

foreach i in ea lga state zone {
	preserve
	bys `i' item_cd : egen obs_`i' = total(obs)
	collapse (median) price_`i' = price_kg price_def_`i' = price_kg_def [aw=weight_pop_rururb], by(item_cd `i' obs_`i')
	tempfile food_`i'
	save `food_`i''
	restore
	merge m:1 item_cd `i' using `food_`i'', nogen
}

preserve
bys item_cd : egen obs_country=total(obs)
collapse (median) price_kg price_kg_def [aw=weight_pop_rururb], by(item_cd obs_country)
keep item_cd price_kg price_kg_def obs_country
ren price_kg price_country
ren price_kg_def price_def_country
tempfile food_country
save `food_country'
restore

merge m:1 item_cd using `food_country', nogen


foreach i in lga state zone country {
	replace price_kg = price_`i' if price_kg ==. & obs_`i' > 9
	replace price_kg_def = price_def_`i' if price_kg_def == . & obs_`i' > 9
}

gen qty_purch = s10bq2_cvn * s10bq5a 
gen qty_own = s10bq2_cvn * (s10bq6a+s10bq7a)
//Getting per-day consumption
gen purch_ = qty_purch*price_kg/7
gen own_ = qty_own*price_kg/7
gen purch_def_ = qty_purch*price_kg_def/7
gen own_def_ = qty_own*price_kg_def/7
keep hhid item_cd purch* own*
reshape wide purch_ own_ purch_def_ own_def_, i(hhid) j(item_cd)
recode purch_* own_* (.=0)
ren purch_def_* purch_*_def 
ren own_def_* own_*_def

//Needed for water section
preserve
//ALT 4/1/22: Using deflated values now
gen purch_water_ph = purch_151_def + purch_150_def
gen own_water_ph = own_151_def + own_150_def
keep hhid purch_water_ph own_water_ph 
tempfile water_ph
save `water_ph'
restore
ren purch_10 fdsorby
ren purch_10_def fdorsby_def
ren purch_11 fdmilby
ren purch_11_def fdmilby_def
gen fdmaizby = purch_16+purch_20+purch_22
gen fdmaizby_def = purch_16_def + purch_20_def + purch_22_def
gen fdriceby = purch_13+purch_14
gen fdriceby_def = purch_13_def + purch_14_def
gen fdyamby = purch_17+purch_31 
gen fdyamby_def = purch_17_def + purch_31_def
gen fdcasby = purch_18+purch_30+purch_32+purch_33 
gen fdcasby_def = purch_18_def + purch_30_def + purch_32_def + purch_33_def
gen fdcereby = purch_23+purch_19
gen fdcereby_def = purch_23_def + purch_19_def
gen fdbrdby = purch_25+purch_26+purch_27+purch_28
gen fdbrdby_def = purch_25_def + purch_26_def + purch_27_def + purch_28_def
gen fdtubby = purch_34+purch_35+purch_36+purch_37+purch_38+purch_60 
gen fdtubby_def = purch_34_def + purch_35_def + purch_36_def + purch_37_def + purch_38_def + purch_60_def
gen fdpoulby = purch_80+purch_81+purch_82
gen fdpoulby_def = purch_80_def + purch_81_def + purch_82_def 
gen fdmeatby = purch_29+purch_90+purch_91+purch_92+purch_93+purch_94+purch_96
gen fdmeatby_def = purch_29_def + purch_90_def + purch_91_def + purch_92_def + purch_93_def + purch_94_def + purch_96_def
gen fdfishby = purch_100+purch_101+purch_102+purch_103+purch_104+purch_105+purch_106+purch_107
gen fdfishby_def = purch_100_def + purch_101_def + purch_102_def + purch_103_def + purch_104_def + purch_105_def + purch_106_def + purch_107_def
gen fddairby = purch_83+purch_84+purch_110+purch_111+purch_112+purch_113+purch_114+purch_115
gen fddairby_def = purch_83_def + purch_84_def + purch_110_def + purch_111_def + purch_112_def + purch_113_def + purch_114_def + purch_115_def
gen fdfatsby = purch_46+purch_47+purch_48+purch_50+purch_51+purch_52+purch_53+purch_56+purch_63+purch_43+purch_44
gen fdfatsby_def = purch_46_def + purch_47_def + purch_48_def + purch_50_def + purch_51_def + purch_52_def + purch_53_def + purch_56_def + purch_63_def + purch_43_def + purch_44_def
gen fdfrutby = purch_61+purch_62+purch_64+purch_65+purch_66+purch_67+purch_68+purch_69+purch_70+purch_71+purch_601
gen fdfrutby_def = purch_61_def + purch_62_def + purch_64_def + purch_65_def + purch_66_def + purch_67_def + purch_68_def + purch_69_def + purch_70_def + purch_71_def + purch_601_def
gen fdvegby = purch_72+purch_73+purch_74+purch_75+purch_76+purch_77+purch_78+purch_79
gen fdvegby_def = purch_72_def + purch_73_def + purch_74_def + purch_75_def + purch_76_def + purch_77_def +  purch_78_def + purch_79_def
gen fdbeanby = purch_40+purch_41+purch_42+purch_45
gen fdbeanby_def = purch_40_def + purch_41_def + purch_42_def + purch_45_def
gen fdswtby = purch_130+purch_132+purch_133
gen fdswtby_def = purch_130_def + purch_132_def + purch_133_def
gen fdbevby2 = purch_120+purch_121+purch_122+purch_150+purch_151+purch_152+purch_153+purch_154+purch_155
gen fdbevby2_def = purch_120_def + purch_121_def + purch_122_def + purch_150_def + purch_151_def + purch_152_def + purch_153_def + purch_154_def + purch_155_def
gen fdalcby2 = purch_160+purch_161+purch_162+purch_163+purch_164
gen fdalcby2_def = purch_160_def + purch_161_def + purch_162_def + purch_163_def + purch_164
gen fdothby2 = purch_142+purch_143
gen fdothby2_def = purch_142_def + purch_143_def
gen fdspiceby = purch_141+purch_144+purch_148+purch_145+purch_146+purch_147
gen fdspiceby_def = purch_141_def + purch_144_def + purch_148_def + purch_145_def + purch_146_def + purch_147_def

ren own_10 fdsorpr
ren own_10_def fdorspr_def
ren own_11 fdmilpr
ren own_11_def fdmilpr_def
gen fdmaizpr = own_16+own_20+own_22
gen fdmaizpr_def = own_16_def + own_20_def + own_22_def
gen fdricepr = own_13+own_14
gen fdricepr_def = own_13_def + own_14_def
gen fdyampr = own_17+own_31 
gen fdyampr_def = own_17_def + own_31_def
gen fdcaspr = own_18+own_30+own_32+own_33 
gen fdcaspr_def = own_18_def + own_30_def + own_32_def + own_33_def
gen fdcerepr = own_23+own_19
gen fdcerepr_def = own_23_def + own_19_def
gen fdbrdpr = own_25+own_26+own_27+own_28
gen fdbrdpr_def = own_25_def + own_26_def + own_27_def + own_28_def
gen fdtubpr = own_34+own_35+own_36+own_37+own_38+own_60 
gen fdtubpr_def = own_34_def + own_35_def + own_36_def + own_37_def + own_38_def + own_60_def
gen fdpoulpr = own_80+own_81+own_82
gen fdpoulpr_def = own_80_def + own_81_def + own_82_def 
gen fdmeatpr = own_29+own_90+own_91+own_92+own_93+own_94+own_96
gen fdmeatpr_def = own_29_def + own_90_def + own_91_def + own_92_def + own_93_def + own_94_def + own_96_def
gen fdfishpr = own_100+own_101+own_102+own_103+own_104+own_105+own_106+own_107
gen fdfishpr_def = own_100_def + own_101_def + own_102_def + own_103_def + own_104_def + own_105_def + own_106_def + own_107_def
gen fddairpr = own_83+own_84+own_110+own_111+own_112+own_113+own_114+own_115
gen fddairpr_def = own_83_def + own_84_def + own_110_def + own_111_def + own_112_def + own_113_def + own_114_def + own_115_def
gen fdfatspr = own_46+own_47+own_48+own_50+own_51+own_52+own_53+own_56+own_63+own_43+own_44
gen fdfatspr_def = own_46_def + own_47_def + own_48_def + own_50_def + own_51_def + own_52_def + own_53_def + own_56_def + own_63_def + own_43_def + own_44_def
gen fdfrutpr = own_61+own_62+own_64+own_65+own_66+own_67+own_68+own_69+own_70+own_71+own_601
gen fdfrutpr_def = own_61_def + own_62_def + own_64_def + own_65_def + own_66_def + own_67_def + own_68_def + own_69_def + own_70_def + own_71_def + own_601_def
gen fdvegpr = own_72+own_73+own_74+own_75+own_76+own_77+own_78+own_79
gen fdvegpr_def = own_72_def + own_73_def + own_74_def + own_75_def + own_76_def + own_77_def +  own_78_def + own_79_def
gen fdbeanpr = own_40+own_41+own_42+own_45
gen fdbeanpr_def = own_40_def + own_41_def + own_42_def + own_45_def
gen fdswtpr = own_130+own_132+own_133
gen fdswtpr_def = own_130_def + own_132_def + own_133_def
gen fdbevpr = own_120+own_121+own_122+own_150+own_151+own_152+own_153+own_154+own_155
gen fdbevpr_def = own_120_def + own_121_def + own_122_def + own_150_def + own_151_def + own_152_def + own_153_def + own_154_def + own_155_def
gen fdalcpr = own_160+own_161+own_162+own_163+own_164
gen fdalcpr_def = own_160_def + own_161_def + own_162_def + own_163_def + own_164
gen fdothpr = own_142+own_143
gen fdothpr_def = own_142_def + own_143_def
gen fdspicepr = own_141+own_144+own_148+own_145+own_146+own_147
gen fdspicepr_def = own_141_def + own_144_def + own_148_def + own_145_def + own_146_def + own_147_def

drop purch_* own_*

merge 1:1 hhid using `prepfoods', nogen
gen fdothby = fdothby1+fdothby2
gen fdbevby = fdbevby1+fdbevby2 
gen fdalcby = fdalcby1+fdalcby2 
gen fdothby_def = fdothby1_def + fdothby2_def 
gen fdbevby_def = fdbevby1_def+ fdbevby2_def
gen fdalcby_def = fdalcby1_def+fdalcby2_def
drop fdothby1* fdothby2* fdbevby1* fdbevby2* fdalcby1* fdalcby2* 

la var fdsorby "Sorghum purchased"
la var fdmilby "Millet purchased"
la var fdmaizby "Maize grain and flours purchased"
la var fdriceby "Rice in all forms purchased"
la var fdyamby "Yam roots and flour purchased"
la var fdcasby "Cassava-gari, roots, and flour purchased"
la var fdcereby "Other cereals purchased"
la var fdbrdby "Bread and the like purchased"
la var fdtubby "Bananas & tubers purchased"
la var fdpoulby "Poultry purchased"
la var fdmeatby "Meat purchased"
la var fdfishby "Fish & seafood purchased"
la var fddairby "Milk, cheese, and eggs purchased"
la var fdfatsby "Oils, fats, & oil-rich nuts purchased"
la var fdfrutby "Fruits purchased"
la var fdvegby "Vegetables excluding pulses purchased"
la var fdbeanby "Pulses (beans, peas, and groundnuts) purchased"
la var fdswtby "Sugar, jam, honey, chocolate & confectionary purchased"
la var fdbevby "Non-alcoholic purchased"
la var fdalcby "Alcoholic beverages purchased"
la var fdrestby "Food consumed in restaurants & canteens purchased"
la var fdspiceby "Spices and condiments purchased"
la var fdothby "Food items not mentioned above purchased"

la var fdsorpr "Sorghum auto-consumption"
la var fdmilpr "Millet auto-consumption"
la var fdmaizpr "Maize grain and flours auto-consumption"
la var fdricepr "Rice in all forms auto-consumption"
la var fdyampr "Yam roots and flour auto-consumption"
la var fdcaspr "Cassava-gari, roots, and flour auto-consumption"
la var fdcerepr "Other cereals auto-consumption"
la var fdbrdpr "Bread and the like auto-consumption"
la var fdtubpr "Bananas & tubers auto-consumption"
la var fdpoulpr "Poultry auto-consumption"
la var fdmeatpr "Meat auto-consumption"
la var fdfishpr "Fish & seafood auto-consumption"
la var fddairpr "Milk, cheese, and eggs auto-consumption"
la var fdfatspr "Oils, fats, & oil-rich nuts auto-consumption"
la var fdfrutpr "Fruits auto-consumption"
la var fdvegpr "Vegetables excluding pulses auto-consumption"
la var fdbeanpr "Pulses (beans, peas, and groundnuts) auto-consumption"
la var fdswtpr "Sugar, jam, honey, chocolate & confectionary auto-consumption"
la var fdbevpr "Non-alcoholic auto-consumption"
la var fdalcpr "Alcoholic beverages auto-consumption"
la var fdspiceby "Spices and condiments auto-consumption"
la var fdothpr "Food items not mentioned above auto-consumption"


merge 1:1 hhid using `hhexp', nogen
unab varlist : *_def 
local vars_nom : subinstr local varlist "_def" "", all 
egen totcons = rowtotal(`vars_nom')
egen totcons_def = rowtotal(`varlist')
drop if totcons_def == 0 // Dropping 3 households for which we have extremely partial consumption statistics 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keepusing(hh_members)
//Convert to annual to get these aligned with the WB files
gen totcons_pc = totcons/hh_members * 365
gen totcons_adj = totcons_def/hh_members * 365
la var totcons "Total daily consumption per hh, nominal"
la var totcons_def "Total daily consumption per hh, regionally deflated"
la var totcons_pc "Total percap cons exp, annual, nominal, postharverst vals only"
la var totcons_adj "Total percap cons exp, annual, regionally deflated, postharvest vals only"
save "${Nigeria_GHS_W4_created_data}/cons_agg_wave4_visit2.dta", replace


	*****************
	*Visit 1

use "${Nigeria_GHS_W4_raw_data}/sect8a_plantingw4.dta", clear
append using "${Nigeria_GHS_W4_raw_data}/sect8b_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect8c_plantingw4.dta"
append using "${Nigeria_GHS_W4_raw_data}/sect11d_harvestw4.dta" //They didn't ask about annual purchases in the post-planting survey; I borrow from the harvest survey to keep everything balanced. These terms will essentially drop out when we take the average for estimated consumption

gen nfd_ = s8q2/7 //Per day
replace nfd_ = s8q4/30 if nfd_==.
replace nfd_ = s8q6/182.5 if nfd_==.
replace nfd_ = s11dq8/365 if nfd_==.
recode nfd_ (.=0)

keep hhid nfd_ item_cd 
reshape wide nfd_, i(hhid) j(item_cd)
gen nfdtbac = nfd_101+nfd_102 //Tobacco and matches
gen nfdrecre = nfd_103+nfd_105+nfd_322+nfd_506+nfd_507 //"Recreation and culture", here including gambling/lotto and newspapers/magazines
gen nfdfares = nfd_104 //Public transportation
gen nfdwater = nfd_312
gen nfdelec = nfd_305
gen nfdgas = nfd_303
gen nfdkero = nfd_301
gen nfdliqd = nfd_304+nfd_302
gen nfdutil = nfd_509 //Council rates?
egen nfdcloth = rowtotal(nfd_401-nfd_418 nfd_431 nfd_432)
egen nfdfmtn = rowtotal(nfd_311 nfd_323 nfd_324 nfd_325 nfd_330 nfd_419-nfd_427 nfd_433-nfd_439 nfd_501-nfd_505 nfd_508)
gen nfdrepar = nfd_327+nfd_328
gen nfddome = nfd_325
gen nfdpetro = nfd_309
gen nfddiesl = nfd_310
gen nfdcomm = nfd_318+nfd_319+nfd_320+nfd_321+nfd_440+nfd_441
gen nfdinsur = nfd_511+nfd_512+nfd_513
egen nfdfoth =rowtotal(nfd_308 nfd_313-nfd_317 nfd_428 nfd_429 nfd_514 nfd_515 nfd_516 nfd_517) //Added dowry, wedding, and funeral expenses
gen nfdfwood = nfd_306
gen nfdchar = nfd_307
gen nfdtrans = 0 //Other transportation. Doesn't appear to have an associated question in W4
gen nfdrnthh = nfd_326+nfd_329
gen nfdhealth = nfd_430 + nfd_510 //Health insurance and non-insurance healthcare expenses
drop nfd_*


merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/totcons_final.dta", nogen keepusing(reg_def_mean)
unab vars : nfd*
foreach i in `vars' {
	gen `i'_def = `i'/reg_def_mean
}

//See visit 2 notes.
replace nfdrepar = nfdrepar*30/365 if hhid == 320056 | hhid == 199048
replace nfdrepar_def = nfdrepar*30/365 if hhid == 320056 | hhid == 199048


la var nfdtbac "Tobacco & narcotics"
la var nfdrecre "Recreation and culture"
la var nfdfares "Fares"
la var nfdwater "Water, excluding packaged water"
la var nfdelec "Electricity"
la var nfdgas "Gas"
la var nfdkero "Kerosene"
la var nfdliqd "Other liquid fuels"
la var nfdutil "Refuse, sewage collection, disposal, and other services"
la var nfdcloth "Clothing and footwear"
la var nfdfmtn "Furnishings and routine household maintenance"
la var nfdrepar "Maintenance and repairs to dwelling"
la var nfddome "Domestic household services"
la var nfdpetro "Petrol"
la var nfddiesl "Diesel"
la var nfdtrans "Other transportation (n/a)"
la var nfdcomm "Communication (post, telephone, and computing/internet)"
la var nfdinsur "Other insurance excluding education and health"
la var nfdfoth "Expenditures on frequent non-food not mentioned elsewhere"
la var nfdfwood "Firewood"
la var nfdchar "Charcoal"
la var nfdrnthh "Mortgage and Rent"
la var nfdhealth "Healthcare expenses"

tempfile hhexp
save `hhexp', replace

//Getting prepared foods out of the way
use "${Nigeria_GHS_W4_raw_data}/sect7a_plantingw4.dta", clear
keep if s7aq1==1
gen item_ = s7aq2/7 //Total consumption per day (avg) of prepared foods/beverages
keep hhid item_cd item_ 
reshape wide item_, i(hhid) j(item_cd)
recode item_* (.=0)
gen fdbevby1 = item_6+item_8 
gen fdalcby1 = item_9
gen fdrestby = item_1+item_2+item_3+item_4
gen fdothby1=item_5+item_7
merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/totcons_final.dta", nogen keepusing(reg_def_mean)
gen fdbevby1_def = fdbevby1/reg_def_mean
gen fdalcby1_def = fdalcby1/reg_def_mean 
gen fdothby1_def = fdothby1/reg_def_mean
gen fdrestby_def = fdrestby/reg_def_mean
drop item*
replace fdrestby = . if hhid == 40172 // ~ N 170k of restaurant purchases
replace fdrestby_def = . if hhid==40172
tempfile prepfoods
save `prepfoods', replace


use "${Nigeria_GHS_W4_raw_data}/sect7b_plantingw4.dta", clear
gen obs = s7bq9a != .
keep if s7bq5a!= . | s7bq6a != . | s7bq7a != . 
ren s7bq9a qty_bought 
gen kg_bought = qty_bought*s7bq9_cvn
gen price_kg = s7bq10/kg_bought

//ALT 01.25.21: I've tested this with weighted/unweighted and kg vs unit-based pricing.
//It seems like weighted average per-kgs are producing the most reasonable results, but it is a value judgment.
//ALT 07.23.21: Quicker version of the geographic medians code.
merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/totcons_final.dta", nogen keep(1 3) keepusing(reg_def_mean)
gen price_kg_def = price_kg/reg_def_mean 
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keep(3) keepusing(weight_pop_rururb)
foreach i in ea lga state zone {
	preserve
	bys `i' item_cd : egen obs_`i' = total(obs)
	collapse (median) price_`i' = price_kg price_def_`i' = price_kg_def [aw=weight_pop_rururb], by(item_cd `i' obs_`i')
	tempfile food_`i'
	save `food_`i''
	restore
	merge m:1 item_cd `i' using `food_`i'', nogen
}

preserve
bys item_cd : egen obs_country=total(obs)
collapse (median) price_kg price_kg_def [aw=weight_pop_rururb], by(item_cd obs_country)
keep item_cd price_kg price_kg_def obs_country
ren price_kg price_country
ren price_kg_def price_def_country
tempfile food_country
save `food_country'
restore

merge m:1 item_cd using `food_country', nogen

foreach i in lga state zone country {
	replace price_kg = price_`i' if price_kg ==. & obs_`i' > 9
	replace price_kg_def = price_def_`i' if price_kg_def == . & obs_`i' > 9
}

gen qty_purch = s7bq2_cvn * s7bq5a 
gen qty_own = s7bq2_cvn * (s7bq6a+s7bq7a)
//Getting per-day consumption
gen purch_ = qty_purch*price_kg/7
gen own_ = qty_own*price_kg/7
gen purch_def_ = qty_purch*price_kg_def/7
gen own_def_ = qty_own*price_kg_def/7
keep hhid item_cd purch* own*
reshape wide purch_ own_ purch_def_ own_def_, i(hhid) j(item_cd)
recode purch_* own_* (.=0)
ren purch_def_* purch_*_def 
ren own_def_* own_*_def

//Water section
preserve
gen purch_water_pp = purch_151 + purch_150
gen own_water_pp = own_151 + own_150
keep hhid purch_water_pp own_water_pp 
merge 1:1 hhid using `water_ph', nogen
recode *water* (.=0)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_water_cons.dta", replace

restore
ren purch_10 fdsorby
ren purch_10_def fdorsby_def
ren purch_11 fdmilby
ren purch_11_def fdmilby_def
gen fdmaizby = purch_16+purch_20+purch_22
gen fdmaizby_def = purch_16_def + purch_20_def + purch_22_def
gen fdriceby = purch_13+purch_14
gen fdriceby_def = purch_13_def + purch_14_def
gen fdyamby = purch_17+purch_31 
gen fdyamby_def = purch_17_def + purch_31_def
gen fdcasby = purch_18+purch_30+purch_32+purch_33 
gen fdcasby_def = purch_18_def + purch_30_def + purch_32_def + purch_33_def
gen fdcereby = purch_23+purch_19
gen fdcereby_def = purch_23_def + purch_19_def
gen fdbrdby = purch_25+purch_26+purch_27+purch_28
gen fdbrdby_def = purch_25_def + purch_26_def + purch_27_def + purch_28_def
gen fdtubby = purch_34+purch_35+purch_36+purch_37+purch_38+purch_60 
gen fdtubby_def = purch_34_def + purch_35_def + purch_36_def + purch_37_def + purch_38_def + purch_60_def
gen fdpoulby = purch_80+purch_81+purch_82
gen fdpoulby_def = purch_80_def + purch_81_def + purch_82_def 
gen fdmeatby = purch_29+purch_90+purch_91+purch_92+purch_93+purch_94+purch_96
gen fdmeatby_def = purch_29_def + purch_90_def + purch_91_def + purch_92_def + purch_93_def + purch_94_def + purch_96_def
gen fdfishby = purch_100+purch_101+purch_102+purch_103+purch_104+purch_105+purch_106+purch_107
gen fdfishby_def = purch_100_def + purch_101_def + purch_102_def + purch_103_def + purch_104_def + purch_105_def + purch_106_def + purch_107_def
gen fddairby = purch_83+purch_84+purch_110+purch_111+purch_112+purch_113+purch_114+purch_115
gen fddairby_def = purch_83_def + purch_84_def + purch_110_def + purch_111_def + purch_112_def + purch_113_def + purch_114_def + purch_115_def
gen fdfatsby = purch_46+purch_47+purch_48+purch_50+purch_51+purch_52+purch_53+purch_56+purch_63+purch_43+purch_44
gen fdfatsby_def = purch_46_def + purch_47_def + purch_48_def + purch_50_def + purch_51_def + purch_52_def + purch_53_def + purch_56_def + purch_63_def + purch_43_def + purch_44_def
gen fdfrutby = purch_61+purch_62+purch_64+/*purch_65+*/purch_66+purch_67+purch_68+purch_69+purch_70+purch_71+purch_601 //65 is only in postharvest questionnaire for some reason
gen fdfrutby_def = purch_61_def + purch_62_def + purch_64_def + /*purch_65_def +*/ purch_66_def + purch_67_def + purch_68_def + purch_69_def + purch_70_def + purch_71_def + purch_601_def
gen fdvegby = purch_72+purch_73+purch_74+purch_75+purch_76+purch_77+purch_78+purch_79
gen fdvegby_def = purch_72_def + purch_73_def + purch_74_def + purch_75_def + purch_76_def + purch_77_def +  purch_78_def + purch_79_def
gen fdbeanby = purch_40+purch_41+purch_42+purch_45
gen fdbeanby_def = purch_40_def + purch_41_def + purch_42_def + purch_45_def
gen fdswtby = purch_130+purch_132+purch_133
gen fdswtby_def = purch_130_def + purch_132_def + purch_133_def
gen fdbevby2 = purch_120+purch_121+purch_122+purch_150+purch_151+purch_152+purch_153+purch_154+purch_155
gen fdbevby2_def = purch_120_def + purch_121_def + purch_122_def + purch_150_def + purch_151_def + purch_152_def + purch_153_def + purch_154_def + purch_155_def
gen fdalcby2 = purch_160+purch_161+purch_162+purch_163+purch_164
gen fdalcby2_def = purch_160_def + purch_161_def + purch_162_def + purch_163_def + purch_164
gen fdothby2 = purch_142+purch_143
gen fdothby2_def = purch_142_def + purch_143_def
gen fdspiceby = purch_141+purch_144+purch_148+purch_145+purch_146+purch_147
gen fdspiceby_def = purch_141_def + purch_144_def + purch_148_def + purch_145_def + purch_146_def + purch_147_def

ren own_10 fdsorpr
ren own_10_def fdorspr_def
ren own_11 fdmilpr
ren own_11_def fdmilpr_def
gen fdmaizpr = own_16+own_20+own_22
gen fdmaizpr_def = own_16_def + own_20_def + own_22_def
gen fdricepr = own_13+own_14
gen fdricepr_def = own_13_def + own_14_def
gen fdyampr = own_17+own_31 
gen fdyampr_def = own_17_def + own_31_def
gen fdcaspr = own_18+own_30+own_32+own_33 
gen fdcaspr_def = own_18_def + own_30_def + own_32_def + own_33_def
gen fdcerepr = own_23+own_19
gen fdcerepr_def = own_23_def + own_19_def
gen fdbrdpr = own_25+own_26+own_27+own_28
gen fdbrdpr_def = own_25_def + own_26_def + own_27_def + own_28_def
gen fdtubpr = own_34+own_35+own_36+own_37+own_38+own_60 
gen fdtubpr_def = own_34_def + own_35_def + own_36_def + own_37_def + own_38_def + own_60_def
gen fdpoulpr = own_80+own_81+own_82
gen fdpoulpr_def = own_80_def + own_81_def + own_82_def 
gen fdmeatpr = own_29+own_90+own_91+own_92+own_93+own_94+own_96
gen fdmeatpr_def = own_29_def + own_90_def + own_91_def + own_92_def + own_93_def + own_94_def + own_96_def
gen fdfishpr = own_100+own_101+own_102+own_103+own_104+own_105+own_106+own_107
gen fdfishpr_def = own_100_def + own_101_def + own_102_def + own_103_def + own_104_def + own_105_def + own_106_def + own_107_def
gen fddairpr = own_83+own_84+own_110+own_111+own_112+own_113+own_114+own_115
gen fddairpr_def = own_83_def + own_84_def + own_110_def + own_111_def + own_112_def + own_113_def + own_114_def + own_115_def
gen fdfatspr = own_46+own_47+own_48+own_50+own_51+own_52+own_53+own_56+own_63+own_43+own_44
gen fdfatspr_def = own_46_def + own_47_def + own_48_def + own_50_def + own_51_def + own_52_def + own_53_def + own_56_def + own_63_def + own_43_def + own_44_def
gen fdfrutpr = own_61+own_62+own_64+/*own_65+*/own_66+own_67+own_68+own_69+own_70+own_71+own_601
gen fdfrutpr_def = own_61_def + own_62_def + own_64_def + /*own_65_def +*/ own_66_def + own_67_def + own_68_def + own_69_def + own_70_def + own_71_def + own_601_def
gen fdvegpr = own_72+own_73+own_74+own_75+own_76+own_77+own_78+own_79
gen fdvegpr_def = own_72_def + own_73_def + own_74_def + own_75_def + own_76_def + own_77_def +  own_78_def + own_79_def
gen fdbeanpr = own_40+own_41+own_42+own_45
gen fdbeanpr_def = own_40_def + own_41_def + own_42_def + own_45_def
gen fdswtpr = own_130+own_132+own_133
gen fdswtpr_def = own_130_def + own_132_def + own_133_def
gen fdbevpr = own_120+own_121+own_122+own_150+own_151+own_152+own_153+own_154+own_155
gen fdbevpr_def = own_120_def + own_121_def + own_122_def + own_150_def + own_151_def + own_152_def + own_153_def + own_154_def + own_155_def
gen fdalcpr = own_160+own_161+own_162+own_163+own_164
gen fdalcpr_def = own_160_def + own_161_def + own_162_def + own_163_def + own_164
gen fdothpr = own_142+own_143
gen fdothpr_def = own_142_def + own_143_def
gen fdspicepr = own_141+own_144+own_148+own_145+own_146+own_147
gen fdspicepr_def = own_141_def + own_144_def + own_148_def + own_145_def + own_146_def + own_147_def

drop purch_* own_*

merge 1:1 hhid using `prepfoods', nogen
gen fdothby = fdothby1+fdothby2
gen fdbevby = fdbevby1+fdbevby2 
gen fdalcby = fdalcby1+fdalcby2 
gen fdothby_def = fdothby1_def + fdothby2_def 
gen fdbevby_def = fdbevby1_def+ fdbevby2_def
gen fdalcby_def = fdalcby1_def+fdalcby2_def
drop fdothby1* fdothby2* fdbevby1* fdbevby2* fdalcby1* fdalcby2* 
replace fdfishby=0 if hhid == 39004 //One hh reporting consuming N 228k of fish per day.
replace fdfishby_def = 0 if hhid == 39004

la var fdsorby "Sorghum purchased"
la var fdmilby "Millet purchased"
la var fdmaizby "Maize grain and flours purchased"
la var fdriceby "Rice in all forms purchased"
la var fdyamby "Yam roots and flour purchased"
la var fdcasby "Cassava-gari, roots, and flour purchased"
la var fdcereby "Other cereals purchased"
la var fdbrdby "Bread and the like purchased"
la var fdtubby "Bananas & tubers purchased"
la var fdpoulby "Poultry purchased"
la var fdmeatby "Meat purchased"
la var fdfishby "Fish & seafood purchased"
la var fddairby "Milk, cheese, and eggs purchased"
la var fdfatsby "Oils, fats, & oil-rich nuts purchased"
la var fdfrutby "Fruits purchased"
la var fdvegby "Vegetables excluding pulses purchased"
la var fdbeanby "Pulses (beans, peas, and groundnuts) purchased"
la var fdswtby "Sugar, jam, honey, chocolate & confectionary purchased"
la var fdbevby "Non-alcoholic purchased"
la var fdalcby "Alcoholic beverages purchased"
la var fdrestby "Food consumed in restaurants & canteens purchased"
la var fdspiceby "Spices and condiments purchased"
la var fdothby "Food items not mentioned above purchased"

la var fdsorpr "Sorghum auto-consumption"
la var fdmilpr "Millet auto-consumption"
la var fdmaizpr "Maize grain and flours auto-consumption"
la var fdricepr "Rice in all forms auto-consumption"
la var fdyampr "Yam roots and flour auto-consumption"
la var fdcaspr "Cassava-gari, roots, and flour auto-consumption"
la var fdcerepr "Other cereals auto-consumption"
la var fdbrdpr "Bread and the like auto-consumption"
la var fdtubpr "Bananas & tubers auto-consumption"
la var fdpoulpr "Poultry auto-consumption"
la var fdmeatpr "Meat auto-consumption"
la var fdfishpr "Fish & seafood auto-consumption"
la var fddairpr "Milk, cheese, and eggs auto-consumption"
la var fdfatspr "Oils, fats, & oil-rich nuts auto-consumption"
la var fdfrutpr "Fruits auto-consumption"
la var fdvegpr "Vegetables excluding pulses auto-consumption"
la var fdbeanpr "Pulses (beans, peas, and groundnuts) auto-consumption"
la var fdswtpr "Sugar, jam, honey, chocolate & confectionary auto-consumption"
la var fdbevpr "Non-alcoholic auto-consumption"
la var fdalcpr "Alcoholic beverages auto-consumption"
la var fdspiceby "Spices and condiments auto-consumption"
la var fdothpr "Food items not mentioned above auto-consumption"


merge 1:1 hhid using `hhexp', nogen
unab varlist : *_def 
local vars_nom : subinstr local varlist "_def" "", all 
egen totcons = rowtotal(`vars_nom')
egen totcons_def = rowtotal(`varlist')
drop if totcons_def == 0 // Dropping 3 households for which we have extremely partial consumption statistics 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keepusing(hh_members)
//Convert to annual to get these aligned with the WB files
gen totcons_pc = totcons/hh_members * 365
gen totcons_adj = totcons_def/hh_members * 365
la var totcons "Total daily consumption per hh, nominal"
la var totcons_def "Total daily consumption per hh, regionally deflated"
la var totcons_pc "Total percap cons exp, annual, nominal, postplanting vals only"
la var totcons_adj "Total percap cons exp, annual, regionally deflated, postplanting vals only"
save "${Nigeria_GHS_W4_created_data}/cons_agg_wave4_visit1.dta", replace

ren totcons totcons_pp
ren totcons_def totcons_def_pp 
ren totcons_pc totcons_pc_pp
ren totcons_adj totcons_adj_pp
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/cons_agg_wave4_visit2.dta", nogen keepusing(totcons*)
ren totcons totcons_ph
ren totcons_def totcons_def_ph
ren totcons_pc totcons_pc_ph 
ren totcons_adj totcons_adj_ph 
gen totcons = (totcons_pp+totcons_ph)/2
gen totcons_def = (totcons_def_pp+totcons_def_ph)/2
gen totcons_pc = (totcons_pc_pp+totcons_pc_ph)/2
gen totcons_adj = (totcons_adj_ph+totcons_pc_pp)/2

merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_adulteq.dta", nogen keep(1 3) keepusing(adulteq)
//merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep(1 3)
 
gen daily_peraeq_cons = totcons/adulteq 
gen peraeq_cons = daily_peraeq_cons*365
gen daily_percap_cons = totcons/hh_members
gen percapita_cons = daily_percap_cons*365
gen total_cons = totcons*365

la var totcons "Total daily consumption per hh, nominal"
la var totcons_def "Total daily consumption per hh, regionally deflated"
la var totcons_pc "Total percap cons exp, annual, nominal"
la var totcons_adj "Total percap cons exp, annual, regionally deflated"

la var percapita_cons "Yearly HH consumption per person"	
la var total_cons "Total yearly HH consumption - harvest"								
la var peraeq_cons "Yearly HH consumption per adult equivalent"				
la var daily_peraeq_cons "Daily HH consumption per adult equivalent"		
la var daily_percap_cons "Daily HH consumption per person" 		
keep hhid adulteq totcons totcons_def totcons_pc totcons_adj percapita_cons daily_percap_cons total_cons peraeq_cons daily_peraeq_cons 
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_consumption.dta", replace




********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect12_harvestw4.dta", clear
reshape long s12q6__, i(hhid) j(j)
ren s12q6__ months_food_insec
keep hhid months_food_insec
collapse (sum) months_food_insec, by(hhid)
gen months_food_insec2 = months_food_insec //ALT 02.01.21: The questionnaire asks up to 15 months, but the max is 12 - I think the way the q's were administered was to ask "over the last year" and the greater time range accounts for different survey times
replace months_food_insec=(months_food_insec/12)*6 //Rescale to 6 months as this is the extent of previous waves
la var months_food_insec "Food insecurity, rescaled to 6 months max"
la var months_food_insec2 "Food insecurity over last 12 months"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_insecurity.dta", replace

********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${Nigeria_GHS_W4_raw_data}/sect5_plantingw4.dta", clear
ren s5q4 value_today
ren s5q1 number_items_owned
ren s5q3 age_item
gen value_assets = value_today*number_items_owned
//collapse (sum) value_assets=value_today, by(hhid)
collapse (sum) value_assets, by(hhid) //ALT 12.01.23: Bug fix
lab var value_assets "Value of household assets"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_assets.dta", replace 


********************************************************************************
*POVERTY INDICES
********************************************************************************
/*ALT 12.21.21:
This section implements the multidimensional poverty index (MPI) and Alkire & Ul Haq's extension to individual indicators of deprivation (as well as their individual subcomponents) for implementation in AgQuery+
Additional work is needed to integrate this into the standard summary statistics
*/
	******************************
	*WATER, SANITATION & HOUSING *
	******************************
//General idea: Workflow for this section is to get amount paid for sachet/bottled water and amount of time spent collecting water.
//How water-gathering time should be costed is up to some debate, but there seems to be broad agreement around 1/2x the unskilled wage for the given class of worker.
//Disaggregate by man, woman, child and use agricultural as a proxy to get water-gathering costs. Then we can do cost per day per capita as well as estimate the cost tradeoff between sachet and well water

//Water expenses appear in multiple areas: s11q69: how much did you pay for water in the last 30 days, including delivery costs?
//Section 7b/10b: How much did you pay for bottled/sachet water? (150/151)
//Section 8/11: Non food water expenditure (30 days): 312
//Making comparisons:
/*
use "${Nigeria_GHS_W4_raw_data}/sect11_plantingw4", clear
ren s11q69 water_mo_pp
keep hhid water_mo_pp 
tempfile water1
save `water1'

use "${Nigeria_GHS_W4_raw_data}/sect7b_plantingw4", clear
keep if item_cd==150 | item_cd==151
ren s7bq10 val_water_pp 
collapse (sum) val_water_pp, by(hhid)
tempfile water2
save `water2'

use "${Nigeria_GHS_W4_raw_data}/sect10b_harvestw4", clear
keep if item_cd==150 | item_cd==151
ren s10bq10 val_water_ph 
collapse (sum) val_water_ph, by(hhid)
tempfile water3
save `water3'

use "${Nigeria_GHS_W4_raw_data}/sect8b_plantingw4", clear
keep if item_cd == 312
ren s8q4 val_water_noncon_pp 
collapse (sum) val_water_noncon_pp, by(hhid)
tempfile water4
save `water4'

use "${Nigeria_GHS_W4_raw_data}/sect11b_harvestw4", clear
keep if item_cd == 312
ren s11bq4 val_water_noncon_ph
collapse (sum) val_water_noncon_ph, by(hhid)
tempfile water5
save `water5'

use `water1', clear 
merge 1:1 hhid using `water2', nogen
merge 1:1 hhid using `water3', nogen
merge 1:1 hhid using `water4', nogen
merge 1:1 hhid using `water5', nogen
ALT: inasmuch as it looks like there's correlations here, water_mo_pp is 1:1 related to val_water_noncon_pp for about 25% of the sample, but remaining values are (predictably) all over the place
It's also possible that s11q69 (water questionnaire) captures non-household purchases of water, but I can't imagine that would be universal given the number of responses (n of nonzero obs is 2287 for s11q69 and 1358 for s8b, with 1218 of the latter overlapping with nonzero values of the former). *For now* I think it's best to capture all the expenses questions, even if there's evidence indicating that we're double counting for some households.
*/
use "${Nigeria_GHS_W4_raw_data}/sect11_plantingw4", clear
ren s11q69 water_mo
keep hhid water_mo 
tempfile water1
save `water1'

//2 and 3 get handled in consumption.
use "${Nigeria_GHS_W4_raw_data}/sect8b_plantingw4", clear
keep if item_cd == 312
ren s8q4 val_water_noncon_pp 
collapse (sum) val_water_noncon_pp, by(hhid)
tempfile water4
save `water4'

use "${Nigeria_GHS_W4_raw_data}/sect11b_harvestw4", clear
keep if item_cd == 312
ren s11bq4 val_water_noncon_ph
collapse (sum) val_water_noncon_ph, by(hhid)
tempfile water5
save `water5'

use `water1', clear
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_water_cons.dta", nogen
merge 1:1 hhid using `water4', nogen
merge 1:1 hhid using `water5', nogen
recode *water* (.=0)
//Expense is over 30 days, but value of water *consumed* is over 1 week.
replace purch_water_pp = purch_water_pp/7*30
replace purch_water_ph = purch_water_ph/7*30
gen val_water_purch = (purch_water_pp+purch_water_ph)/2
replace own_water_ph = own_water_ph/7*30
replace own_water_pp = own_water_pp/7*30
gen val_water_own = (own_water_ph+own_water_pp)/2
gen val_water_services = (val_water_noncon_pp + val_water_noncon_ph)/2
drop *pp *ph
gen val_water_day = (water_mo + val_water_own + val_water_services + val_water_purch)/30
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_total_water_costs.dta", replace

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_labor_long.dta", clear
keep if strmatch(season, "pp")
collapse (sum) val days, by(hhid gender)
gen rate = val/days
gen hh_rate = rate
gen obs=1
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep(1 3) keepusing(weight_pop_rururb zone state lga ea)

foreach i in ea lga state zone {
	preserve
	bys `i' : egen `i'_obs = total(obs)
	collapse (median) `i'_rate = rate [aw=weight_pop_rururb], by(`i' gender `i'_obs)
	tempfile `i'_labor
	save ``i'_labor'
	restore
	merge m:1 `i' gender using ``i'_labor', nogen keep(1 3)
}
preserve
collapse (median) country_rate=rate (sum) country_obs=obs [aw=weight_pop_rururb], by(gender)
tempfile country_labor
save `country_labor'
restore
merge m:1 gender using `country_labor', nogen

foreach i in country zone state lga ea {
	replace rate = `i'_rate if `i'_obs > 9
}
replace rate = hh_rate if hh_rate != . //I think medians should be used for everyone, but this is current practice
foreach i in child male female {
	preserve
	keep if strmatch(gender, "`i'")
	_pctile rate
	scalar wins_thresh=r(p95)
	replace rate = wins_thresh if rate > wins_thresh
	tempfile `i'_rates
	save ``i'_rates'
	restore
}

use `male_rates', clear
append using `female_rates'
append using `child_rates'
replace rate = rate*0.5
keep hhid gender rate
tempfile water_wage_rates
save `water_wage_rates'

use "${Nigeria_GHS_W4_raw_data}/sect3b_plantingw4.dta", clear
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", nogen keep(1 3)
recode s3bq7 (.=0)
gen hrs_water_perday = s3bq7/7
gen gender = "child" if age<=15
replace gender = "male" if age > 15 & female==0
replace gender = "female" if age > 15 & female==1
collapse (sum) hrs*, by(zone state lga ea hhid gender)
merge 1:1 hhid gender using `water_wage_rates', nogen keep(3)
gen water_cost_labor = rate * hrs_water_perday/6 //The wage here is the day rate; assuming a workday is 6 hours.
la var water_cost_labor "Daily cost of water-collecting labor hours by gender of hh members"
la var rate "Estimated value of unskilled labor by gender (based value of 0.5 farm labor hours)"
la var hrs_water_perday "Total household hours per day spent collecting water"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_water_labor.dta", replace
collapse (sum) hrs_water_perday water_cost, by(hhid zone state lga ea)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_total_water_costs.dta", nogen
egen hh_water_labor = rowtotal(water_cost_labor val_water_own)
egen hh_water_purch = rowtotal(val_water_purch water_mo val_water_services)
egen hh_water_all = rowtotal(hh_water*)
keep zone state lga hhid hrs* hh_water_labor hh_water_purch hh_water_all
la var hh_water_labor "Cost for collected water and value of self-produced bottled/sachet water"
la var hh_water_purch "Cost of purchased sachet/bottled water and other water services"
la var hh_water_all "Total hh cost of water"
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_water_costs_hh.dta", replace

use "${Nigeria_GHS_W4_raw_data}/sect11_plantingw4.dta", clear
ren s11q57a travel_time_wet
replace travel_time_wet=travel_time_wet*60 if s11q57b==2
replace travel_time_wet = 0 if travel_time_wet < 1 & s11q57b==1

ren s11q63a travel_time_dry
replace travel_time_dry = travel_time_dry*60 if s11q63b==2
replace travel_time_dry = 0 if travel_time_dry < 1 & s11q63b==1 //Likely wrong units in these instances
recode travel_time* (.=0)
egen travel_time_max = rowmax(travel_time_wet travel_time_dry)

gen water_insecure=s11q65==1
gen has_filter=s11q67__4==1

//WHO defines safely managed drinking-water as located on premises (q 56/62), available when needed (q65), and free from contamination
//World Bank describes an improved water source as piped, standpipe, tube well, protected well or spring, or rainwater. Alkire and Foster define "available" as <30 min walk away.
replace s11q60 = s11q33b if s11q60==.
gen dep_water = travel_time_max > 30 | /*(s11q65==1)*/ (!inlist(s11q33b, 1, 2, 3, 4, 5, 6, 10, 11, 12, 14, 15, 16) | !inlist(s11q60, 1, 2, 3, 4, 5, 6, 10, 11, 12, 14, 15, 16))
//gen improved_toilet=inrange(s11q36,1,6)
gen daily_water_bill = s11q69/30
gen dep_housing = inlist(s11q6, 1, 8, 9) | inlist(s11q7, 1, 6, 7, 10) | inlist(s11q8, 1, 2, 6)
//Alkire and Foster say wood, charcoal, or dung. Also including sawdust, crop residue; some 67% of hh's use wood as their primary or secondary source, though.
gen dep_fuel = inlist(s11q43_1, 3, 4, 6, 7, 8, 9, 11) | inlist(s11q43_2, 3, 4, 6, 7, 8, 9, 11)
gen dep_elec = s11q47 == 2
//Toilet unimproved or shared. W/B considers a pit latrine with slab as improved, assuming pit latrine w/o slab and hanging toilet are not improved.
gen dep_sanit = s11q73==1 | inlist(s11q36, 8, 11, 12)

keep hhid travel_* water_* has_* daily* dep*
//merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_water_costs_hh.dta", nogen
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_housing.dta", replace

//Household assets in MPI: radio, TV, telephone, computer, animal cart, bike, motorbike, refrigerator, does not own car or truck.
use "${Nigeria_GHS_W4_raw_data}/secta4_harvestw4.dta", clear
keep if inlist(item_cd, 301, 303, 306)
gen has_item = sa4q1a==1
keep hhid item_cd has_item
tempfile ag_assets
save `ag_assets'

use "${Nigeria_GHS_W4_raw_data}/sect5_plantingw4.dta", clear
keep if inlist(item_cd, 312, 313, 317, 318, 319, 322, 327, 328, 3321, 3322)
recode s5q1a (2=0)
ren s5q1a has_item
append using `ag_assets'
gen has_car = (item_cd==319 | item_cd==301 | item_cd==306) & has_item==1
drop if item_cd==319
collapse (max) has_car (sum) num_assets=has_item, by(hhid)
gen dep_asset = has_car==0 & num_assets <= 1

save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_assets.dta", replace

	********************************
	*INDIVIDUAL ACCESS TO EDUCATION*
	********************************
//ALT: Alkire & Ul Haq identify individual deprivation of education as being eligible up to the 8th year of education but not in school. For south Asia, this is typically age 6-14. In Nigeria, the primary schooling duration is 9 years, typically starting at age 5. Ergo, the age range should be extended to 5-14.

//They also introduce the concept of a pioneer child, which is one that has had at least 6 years of schooling but lives in a household where the parents do not.
use "${Nigeria_GHS_W4_raw_data}/sect2_harvestw4.dta", clear
drop if s2aq7==1 | s2aq2==2 //Remove from dataset if the respondent is too young to attend school.
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}\Nigeria_GHS_W4_person_ids.dta", nogen keep(1 3)
gen years_school = 1*(s2aq9==11)+2*(s2aq9==12)+3*(s2aq9==13)+4*(s2aq9==14)+5*(s2aq9==15)+6*(s2aq9==16 | s2aq9==27) + 7*(s2aq9==21) + 8*(s2aq9==22) + 9 * inlist(s2aq9,23,411,412) + 10*(s2aq9==24)+11*(s2aq9==25)+12*inlist(s2aq9, 26, 28, 31, 33, 34, 35, 41, 43, 321, 322, 421, 422, 423, 424) //It appears OND/HND are roughly equivalent to the GED. Modern school is a high school. Non-university nursing school appears to be roughly equivalent to a Bachelors in terms of years of education.
//Quranic education is controversial in Nigeria - traditional quranic schools do not provide instruction in typical academic subjects like math, science, etc. (something the Nigerian government has deemed unacceptable), so I consider this to be equivalent to no school.
//replace years_school = . if s2aq9==. & s2aq6!=2 //No one has reported attending school but not provided info

gen in_school = age>=5 & age<=14 & s2aq13a==1
gen school_eligible = age>=5 & age<=14

gen adult_ed = years_school*(age>=15)
gen child_ed = years_school*(age<15)
gen missing_data = adult_ed==. | child_ed==.
gen hh_mmbrs = 1
collapse (sum) tot_missing=missing_data hh_mmbrs in_school school_eligible (max) adult_ed child_ed, by(hhid)
gen prop_missing = tot_missing/hh_mmbrs 
gen pioneer_child = adult_ed < 6 & child_ed >= 6
gen dep_att = in_school < school_eligible //Households that have no children are considered not deprived in attendance. 
gen dep_edyr = adult_ed < 6 & child_ed < 6
replace dep_edyr = . if tot_missing > 0.33 //No missing values.
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_edu.dta", replace
//Cannot construct the death of a child indicator.


	*********************************
	*		FOOD SECURITY			*
	*********************************
	//UN SDG 2 defines eliminating hunger as inadequate access to "safe, nutritious, and sufficient food year round"
	//8b: about healthy and nutritious/preferred foods (60% of sample)
	//8c: inadequate dietary diversity (57% of sample)
	//8d: skipped meals (41% of sample)
	//8e: insufficient quantity (49%)
	//8f: ran out of food? (38%)
	//8g: were hungry but did not eat (34%)
	//8h: went without eating for the whole day (13%)
	//8i: reduced own food consumption so kids had enough to eat (28%)
	//8j: had to borrow or rely on help from a friend or relative (18%)
	//5: Did you not have enough to feed hh at some point in last 12 months? (43%)
	//I omit 8a ("Has anyone hh worried about not having enough") in favor of concrete indicators - even so, about 70% of the sample - and this does not change much with weight - has experienced at least one of these, much higher than 'typical' hunger estimates. We can restrict to Q5 as a "narrowly construed" indicator, or we can construct a composite score and choose a cutoff. Hard to see a way to do that that isn't arbitrary, though. Cumulative frequency is essentially linear until you hit 0. (roughly 7-8% of pop in each bin)
use "${Nigeria_GHS_W4_created_data}/cons_agg_wave4_visit1.dta", clear
drop totcons
egen fdconstot = rowtotal(fd*)
keep hhid fd*
ren fd* fd*_pp
tempfile visit1
save `visit1'
use "${Nigeria_GHS_W4_created_data}/cons_agg_wave4_visit2.dta",	clear
drop totcons
egen fdconstot = rowtotal(fd*)
keep hhid fd* 
ren fd* fd*_ph
merge 1:1 hhid using `visit1', nogen
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_adulteq.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep(1 3)
replace fdconstot_ph = fdconstot_pp if fdconstot_ph == . | fdconstot_ph==0
drop if adulteq==.
recode fdconstot_pp fdconstot_ph (0=.)
reshape long fdconstot_, i(hhid) j(season) string
ren fdconstot_ fdconstot
gen daily_peraeq_fdcons = fdconstot/adulteq 
gen daily_percap_fdcons = fdconstot/hh_members
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_cons.dta", replace
keep hhid daily* season
ren daily* daily*_ 
reshape wide daily*_, i(hhid) j(season) string
drop if daily_peraeq_fdcons_ph > 7000 | daily_peraeq_fdcons_pp > 7000 //Outliers.
tempfile fdcons
save `fdcons'
	
use "${Nigeria_GHS_W4_raw_data}/sect9_plantingw4.dta", clear
//drop s9q8a
recode s9q8* s9q5 (.=0) (2=0) 
egen dep_food = rowmax(s9q8* s9q5) 
egen total_dep_food = rowtotal(s9q8* s9q5)
gen calor_insuf = s9q8d==1 | s9q8e == 1 | s9q8f == 1 | s9q8g == 1 | s9q8h == 1 | s9q8i == 1 | s9q5==1
gen nutr_insuf = calor_insuf==0 & (s9q8b==1 | s9q8c==1)
gen precarious = nutr_insuf == 0 & calor_insuf==0 & (s9q8a==1 | s9q8j==1)
gen secure=precarious==0 & calor_insuf==0 & nutr_insuf==0
/*Cumulative percentages:
10 - 5.8
9 -  13.0
8 -  21.4
7 -  29.5
6 -  36.0
5 -  42.3
4 -  47.7
3 -  54.3
2 -  62.2
1 -  70.2
*/	
keep hhid dep_food total_dep_food calor_insuf nutr_insuf precarious secure
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_insecurity.dta", nogen
merge 1:1 hhid using `fdcons', nogen
drop if daily_peraeq_fdcons_pp==. //Not sure what the missing values here signify.
egen min_fdcons = rowmin(daily_peraeq_fdcons_*) //Get lowest
egen max_fdcons = rowmax(daily_peraeq_fdcons_*) 
gen avg_fdcons = (daily_peraeq_fdcons_ph + daily_peraeq_fdcons_pp)/2
gen blw_coca_min = min_fdcons < $Nigeria_GHS_W4_CoCA_diet
gen blw_coca_max = max_fdcons < $Nigeria_GHS_W4_CoCA_diet
gen blw_cona_min = min_fdcons < $Nigeria_GHS_W4_CoNA_diet
gen blw_cona_max = max_fdcons < $Nigeria_GHS_W4_CoNA_diet
gen blw_coca_avg = avg_fdcons < $Nigeria_GHS_W4_CoCA_diet
gen blw_cona_avg = avg_fdcons < $Nigeria_GHS_W4_CoNA_diet

gen blw_cona_pp = daily_peraeq_fdcons_pp < $Nigeria_GHS_W4_CoNA_diet
gen blw_coca_pp = daily_peraeq_fdcons_pp < $Nigeria_GHS_W4_CoCA_diet
gen blw_cona_ph = daily_peraeq_fdcons_ph < $Nigeria_GHS_W4_CoNA_diet
gen blw_coca_ph = daily_peraeq_fdcons_ph < $Nigeria_GHS_W4_CoCA_diet
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_dep.dta", replace

***rCSI
*Alternative food consumption measure using the reduced coping strategies index. Weights are from the WFP guidance document Kenya Pilot Study (see https://documents.wfp.org/stellent/groups/public/documents/manual_guide_proced/wfp211058.pdf)
	//Question																	Severity Score
	//8b: about healthy and nutritious/preferred foods 							1	
	//8c: inadequate dietary diversity 											1
	//8d: skipped meals															1
	//8e: insufficient quantity 												1
	//8f: ran out of food? 														3
	//8g: were hungry but did not eat 											4
	//8h: went without eating for the whole day									4
	//8i: reduced own food consumption so kids had enough to eat 				3
	//8j: had to borrow or rely on help from a friend or relative				2

use "${Nigeria_GHS_W4_raw_data}/sect9_plantingw4.dta", clear
recode s9q8* (2=0)
gen rCSI = s9q8b + s9q8c + s9q8d + s9q8e + s9q8f*3 + s9q8g * 4 + s9q8h*4 + s9q8i * 3 + s9q8j*2	
//Max score is 20, 50th percentile among scores > 0 is 9
gen nofoodinsec = rCSI <= 3
gen highfoodinsec = rCSI >= 12
keep state hhid rCSI nofoodinsec highfoodinsec
tempfile rCSI
save `rCSI'
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_dep.dta", clear
merge 1:1 hhid using `rCSI', nogen
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keepusing(hh_members weight_pop_rururb)
//collapse (mean) dep_food total_dep_food calor_insuf nutr_insuf precarious secure months* min_fdcons max_fdcons avg_fdcons rCSI nofoodinsec highfoodinsec hh_members [aw=weight_pop_rururb], by(state)
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_dep_ext.dta", replace

	*********************************
	*	WHO CHILD MALNUTRITION		*
	*********************************
/* This section uses a stata module developed by the WHO to compare child anthropometry to a reference population to determine stunting/malnourishment. The module must be downloaded from https://www.who.int/toolkits/child-growth-standards/software
for this section to run. Be sure to update the paths to the ado and data files. The code automatically checks to see if there's a file at the specified location before continuing and will not construct the final poverty index if the data are not present; you can still refer to the final output file for the other subscores. */

capture confirm file "${dofilefold}/igrowup_restricted.ado"
if !_rc {
	adopath + "$dofilefold"
	//Need to add file references, then we're good to go.
	use "${Nigeria_GHS_W4_raw_data}/sect1_harvestw4.dta", clear
	merge 1:1 hhid indiv using "${Nigeria_GHS_W4_raw_data}/sect4a_harvestw4.dta", nogen keep(3)
	merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", nogen keep(3)
	merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep(1 3) keepusing(weight_pop_rururb)
	ren weight sw
	gen sex =female + 1 //1 for males and 2 for females
	egen weight = rowtotal(s4aq52_1 s4aq52_2 s4aq52_3)
	replace weight=weight/3 if s4aq52_3 != . & s4aq52_3 != 0
	replace weight=weight/2 if s4aq52_3 == . | s4aq52_3 ==0
	recode weight (.=0)
	drop if weight==0
	merge m:1 hhid using "${Nigeria_GHS_W4_raw_data}/secta_harvestw4.dta", nogen keep(3)
	gen int_date = dofc(InterviewStart)
	recode s1q6_day (99=1) //assuming day is 1 if day is unknown
	tostring s1q6_day, gen(birth_day)
	replace birth_day = "0" + birth_day if s1q6_day < 10
	tostring s1q6_month, gen(birth_month)
	replace birth_month = "0" + birth_month if s1q6_month < 10
	tostring s1q6_year, gen(birth_year)
	gen birthday = date(birth_day+birth_month+birth_year, "DMY")
	gen agedays = int_date - birthday
	gen str6 ageunit="days"
	gen measure = "l" if s4aq53b==2
	replace measure = "h" if s4aq53b==1
	egen lenhei = rowtotal(s4aq53_1 s4aq53_2 s4aq53_3)
	replace lenhei = lenhei / 3 if s4aq53_3 != . & s4aq53_3!=0
	replace lenhei = lenhei / 2 if s4aq53_3 ==. | s4aq53_3==0
	
	gen str1 oedema="n"
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_anthro.dta", replace
	gen reflib = "$dofilefold"
	gen datalib = "$Nigeria_GHS_W4_created_data"
	gen str30 datalab = "Nigeria_GHS_W4_anthro"
	igrowup_restricted reflib datalib datalab sex agedays ageunit weight lenhei measure oedema sw
	use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_anthro_z_rc.dta", clear //Update to corect file name
	replace _zwei = . if _fwei==1
	gen low_weight = _zwei < -2 & _zwei!=.
	merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", nogen
	gen under_5 = age <5
	collapse (max) low_weight under_5 (min) age, by(hhid)
	recode low_weight (.=2) //HH does not have any eligible members
	merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen
	//merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_dep.dta", nogen
	la var under_5 "1 = household is eligible for anthropometry measurements"
	gen dep_nutr = low_weight == 1
	save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_nutr.dta", replace
}

use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", clear
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_dep.dta", nogen keep(3)

merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_edu.dta", nogen keep(3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_assets.dta", nogen keep(3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_housing.dta", nogen keep(3)
capture confirm file  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_nutr.dta"
if !_rc {
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_nutr.dta", nogen keep(3)
} 
else {
	gen dep_nutr=0
	gen low_weight=0
}
gen popweight = hh_members*weight_pop_rururb
gen mpi_tot = (1/6)*(dep_nutr + dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)
gen mpi_coca = (1/6)*(blw_coca_min + dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)
gen mpi_cona = (1/6)*(blw_cona_min + dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)

gen dep_nutr2 = (low_weight==1)/9 + 2*(calor_insuf==1)/18 + nutr_insuf/18 + 2*(blw_coca_min==1)/18 + blw_cona_min/18
gen mpi_testindic = dep_nutr2 + (1/6)*(dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset)
gen dist_foodline = 153-min_fdcons
replace dist_foodline = 0 if dist_foodline < 0
gen mpi_base = (1/6)*(dep_edyr + dep_att) + (1/18) * (dep_fuel + dep_sanit + dep_water + dep_elec + dep_housing + dep_asset) //all non-health indicators.
gen dep_nutr3 = (low_weight==1)/9 + (1-(dist_foodline/153))/9 + 2*(calor_insuf==1)/18 + nutr_insuf/18
gen dep_nutr4 = (months_food_insec2/12)/9 + (dist_foodline/153)/9 + 2*(calor_insuf==1)/18 + nutr_insuf/18
gen mpi_test4 = mpi_base + dep_nutr4
gen mpi_poor4 = mpi_test4 > 0.33
//Because child mortality is missing, we adjust the total mpi score lower to ~0.84. One third of this is 0.275
gen mpi_poor = mpi_tot <= 0.275
gen coca_poor = mpi_coca <= 0.275
gen cona_poor = mpi_coca <= 0.275
save "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_mpi_indicators.dta", replace

********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
global empty_vars ""
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", clear
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_adulteq.dta", nogen keep(1 3)
*Gross crop income 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_production.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

*Start DYA 9.13.2020 
* Production by group and type of crops
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production_grouped.dta", nogen
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_crop_values_production_type_crop.dta", nogen
recode value_pro* value_sal* (.=0)
*End DYA 9.13.2020 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_cost_inputs.dta", nogen

*Crop costs
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_`c'_monocrop_hh_area.dta",nogen
}

foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	//egen `c'_exp = rowtotal(val_anml_`c' val_mech_`c' val_labor_`c' val_herb_`c' val_inorg_`c' val_orgfert_`c' val_plotrent_`c' val_seeds_`c' val_transfert_`c' val_seedtrans_`c') //Need to be careful to avoid including val_harv
	//lab var `c'_exp "Crop production expenditures (explicit) - Monocropped `c' plots only"
	//la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household" 

*disaggregate by gender of plot manager
foreach i in male female mixed hh {
	egen `c'_exp_`i' = rowtotal(val_anml_`c'_`i' val_mech_`c'_`i' val_labor_`c'_`i' val_herb_`c'_`i' val_inorg_`c'_`i' val_orgfert_`c'_`i' val_plotrent_`c'_`i' val_seed_`c'_`i' /*val_transfert_`c'_`i' val_seedtrans_`c'_`i'*/ /*ALT 10.25: need to redo these to plot level*/) //These are already narrowed to explicit costs
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
//drop rental_cost_land* cost_seed* value_fertilizer* cost_trans_fert* value_herbicide* value_pesticide* value_manure_purch* cost_trans_manure*
//drop val_anml* val_mech* val_labor* val_herb* val_inorg* val_orgfert* val_plotrent* val_seed* /*val_transfert* val_seedtrans* */ //
*Land rights
merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Fish income
//ALT: Not constructable for  W4
/*merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fish_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fishing_expenses_1.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fishing_expenses_2.dta", nogen keep(1 3)
gen fish_income_fishfarm = value_fish_harvest - fish_expenses_1 - fish_expenses_2
gen fish_income_fishing = value_fish_caught - fish_expenses_1 - fish_expenses_2
gen fishing_income = fish_income_fishing
recode fishing_income fish_income_fishing fish_income_fishfarm (.=0)
lab var fish_income_fishing "Net fishing income (value of production and consumption minus expenditures)"
lab var fish_income_fishfarm "Net fish farm income (value of production minus expenditures)"
lab var fishing_income "Net fishing income (value of production and consumption minus expenditures)"*/
gen fish_income_fishing=.
gen fish_income_fishfarm=.
gen fish_expenses_1=.
gen fish_expenses_2=.
gen fishing_income=.
global empty_vars $empty_vars fish_income* fishing_income fish_expens*


*Livestock income
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_products.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_herd_characteristics.dta", nogen keep(1 3)
*merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_TLU_Coefficients.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_TLU_Coefficients.dta", nogen keep (1 3) // HKS 6.16.23
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced cost_*livestock (.=0) /*value_other_produced*/ /*fish_income_fishfarm*/  //Commented variables not in W4
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + ( value_milk_produced + value_eggs_produced /*+ value_other_produced*/) /*
*/ - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock) /*+ fish_income_fishfarm*/
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_other_livestock)
lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
ren cost_vaccines_livestock ls_exp_vac 
gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced /*+ value_other_produced*/)
lab var livestock_product_revenue "Gross revenue from sale of livestock products"
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
gen animals_lost12months=.
gen mean_12months=.
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
gen any_imp_herd_all =. 
foreach v in ls_exp_vac any_imp_herd{
foreach i in lrum srum poultry pigs equine camels {
	gen `v'_`i' = .
	}
}
//adding - starting list of missing variables - recode all of these to missing at end of HH level file

global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_*

*Self-employment income
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_self_employment_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_agproduct_income.dta", nogen keep(1 3)
egen self_employment_income = rowtotal(profit_processed_crop_sold annual_selfemp_profit)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_agwage_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_wage_income.dta", nogen keep(1 3)
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_other_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_remittance_income.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_other_income.dta", nogen keep(1 3)
egen transfers_income = rowtotal (remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (investment_income rental_income_buildings other_income  rental_income_assets)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm size
merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_size.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_size_all.dta", nogen keep(1 3)
merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmsize_all_agland.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_size_total.dta", nogen
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
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_family_hired_labor.dta", nogen keep(1 3)
recode labor_hired labor_family labor_nonhired (.=0) 

*Household size
merge 1:1 hhid using  "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep(1 3)
 
*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_vaccine.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_input_use.dta", nogen keep(1 3)
//merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_improvedseed_use.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_imprv_seed_by_crop.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_any_ext.dta", nogen keep(1 3)
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fin_serv.dta", nogen keep(1 3)
ren use_imprv_seed imprv_seed_use //ALT 02.03.22: Should probably fix code to align this with other inputs.
ren use_hybrid_seed hybrid_seed_use
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. // Area cultivated this year
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & (farm_area==0 | farm_area==.) &  tlu_today==0) //ALT 01.26.21: Changed & to | for farm_area
replace imprv_seed_use=. if farm_area==.
global empty_vars $empty_vars hybrid_seed*

*Milk productivity
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_milk_animals.dta", nogen keep(1 3)
gen costs_dairy = .
gen costs_dairy_percow = .
la var costs_dairy "Dairy production cost (explicit)"
la var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen liters_per_cow = milk_months_produced * milk_quantity_produced/milk_animals
gen liters_per_buffalo = . 
gen share_imp_dairy = . 
global empty_vars $empty_vars *costs_dairy* *costs_dairy_percow* share_imp_dairy *liters_per_buffalo

*Egg productivity
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_egg_animals.dta", nogen keep(1 3)
gen eggs_total_year =eggs_quantity_produced * eggs_months_produced
gen egg_poultry_year = eggs_total_year/poultry_owned
lab var eggs_total_year "Total number of eggs that was produced (household)"

*Costs of crop production per hectare
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_cropcosts.dta", nogen keep(1 3)
 
*Rate of fertilizer application 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_fertilizer_application.dta", nogen keep(1 3)

*Agricultural wage rate
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_ag_wage.dta", nogen keep(1 3)

*Crop yields 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_yield_hh_crop_level.dta", nogen keep(1 3)

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_area_planted_harvested_allcrops.dta", nogen keep(1 3)
 
*Household diet
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_household_diet.dta", nogen keep(1 3)

*consumption 
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_consumption.dta", nogen keep(1 3)

*Household assets
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hh_assets.dta", nogen keep(1 3)

*Food insecurity
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_food_insecurity.dta", nogen keep(1 3)
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Livestock health
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_diseases.dta", nogen keep(1 3)

*livestock feeding, water, and housing
*cannot construct for water
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_livestock_feed_water_house.dta", nogen keep(1 3) 
//gen feed_grazing = . 
gen water_source_nat = . 
gen water_source_const = . 
gen water_source_cover = . 
//gen lvstck_housed = . 
foreach v in water_source_nat water_source_const water_source_cover {
foreach i in lrum srum poultry pigs equine camels {
	gen `v'_`i' = .
	}
}
global empty_vars $empty_vars water_source*

*Shannon Diversity index
merge 1:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
recode value_crop_production value_livestock_products value_slaughtered value_lvstck_sold (.=0)
egen value_farm_production = rowtotal(value_crop_production value_livestock_products value_slaughtered value_lvstck_sold)
lab var value_farm_production "Total value of farm production (crops + livestock products)"
egen value_farm_prod_sold = rowtotal(value_crop_sales sales_livestock_products value_livestock_sales)
lab var value_farm_prod_sold "Total value of farm production that is sold" 


*Agricultural households
recode value_farm_production crop_income livestock_income farm_area tlu_today land_size farm_size_agland value_farm_prod_sold (.=0)
//ALT 06.18.2020: Note to revisit this. Ayala says it's oddly high.
gen ag_hh = (value_crop_production!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
replace value_farm_production=. if ag_hh==0
replace value_farm_prod_sold=. if ag_hh==0
recode nb* tlu* *tlu (.=0) if ag_hh==1 //ALT 10.08.24: Issue causing SSP to be too low; consider other variables if needed
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
recode farm_size_agland (.=0) if crop_hh==0 & livestock_hh==1 //Livestock-only households. 
//recode fishing_income (.=0)
gen fishing_hh = . //(fishing_income!=0)
global empty_vars $empty_vars fishing_hh

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1 
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry pigs equine camels{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family labor_nonhired farm_size_agland all_area_harvested all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family labor_nonhired farm_size_agland all_area_harvested all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0		
*all rural households 
recode /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

//ALT: Turns out renaming the variables like this was a bad idea. Temporary kludge til I go back and fix.
gen cost_total = cost_total_hh //ALT: In W3, these two variables were generated using the same code. I'm assuming we need both because of how the loop is structured.
gen cost_expli = cost_expli_hh
gen cost_total_all = cost_total //ALT 06.23.2020: Needed for summary stats file?
gen cost_expli_all = cost_expli
gen wage_paid_aglabor_all = wage_paid_aglabor //ALT 06.23.2020: Added
//drop w_ha_planted* //ALT 10.04.24: drops the winsorized area variable used to produce the winsorized input application estimates. Long term should see if we can just skip it below.

global gender "female male mixed" //ALT 06.23.2020: 'All' is included in the gender list in the final summary statistics file, and some variables don't get generated if it's not included here.
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family labor_nonhired /*
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*






gen wage_paid_aglabor_mixed=. //create this just to make the loop work and delete after
/*alt 05.04.23: New winsorization code (see ETH W3)
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
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


global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg wage_paid_aglabor

foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
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
egen w_labor_total=rowtotal(w_labor_hired w_labor_family w_labor_nonhired)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres) 
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

*/

levelsof zone, local(list_levels)
foreach v of varlist $wins_var_top1 {
	gen w_`v'=`v'
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	scalar p1_nat=r(r1)
	di p1_nat
	foreach r of local list_levels {
		_pctile `v' [aw=weight_pop_rururb] if zone==`r', p($wins_upper_thres)  
		scalar p1_lev_`r'=r(r1)
		di "Top 1% by zone  _`r' " p1_lev_`r'
		di min(p1_lev_`r',p1_nat)
		replace  w_`v' = min(p1_lev_`r',p1_nat) if zone==`r' & w_`v' > min(p1_lev_`r',p1_nat) &  w_`v'!=.
	}
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	

* By gender 

global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp  
}

global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg org_fert_kg n_kg p_kg k_kg npk_kg urea_kg herb_kg pest_kg wage_paid_aglabor  

foreach v of varlist $wins_var_top1_gender {
	gen w_`v'=`v'
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	scalar p1_nat=r(r1)
	di p1_nat
	foreach r of local list_levels {
		_pctile `v' [aw=weight_pop_rururb] if zone==`r', p($wins_upper_thres)  
		scalar p1_lev_`r'=r(r1)
		di "Top 1% by zone  _`r' " p1_lev_`r'
		di min(p1_lev_`r',p1_nat)
		replace  w_`v' = min(p1_lev_`r',p1_nat) if zone==`r' & w_`v' > min(p1_lev_`r',p1_nat) &  w_`v'!=.
	}
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		foreach r of local list_levels {
			replace  w_`v'_`g' = min(p1_lev_`r',p1_nat) if zone==`r' & w_`v' > min(p1_lev_`r',p1_nat) &  w_`v'_`g'!=.
		}	
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winsorized top 1%"
	}
}

//ALT end update

* Generate winsorized labor vars 

//global empty_vars $empty_vars w_lost_disease w_lost_disease_lrum w_lost_disease_srum w_lost_disease_poultry
drop *wage_paid_aglabor_mixed
*Generating labor_total as sum of winsorized labor_hired and labor_family
egen w_labor_total=rowtotal(w_labor_hired w_labor_family w_labor_nonhired) 
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winsorized top 1%"


//ALT 05.04.23 update to regional winsorization

global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
*/ total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer

foreach v of varlist $wins_var_top1_bott1 {
	gen w_`v'=`v'
	_pctile `v' [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres)  
	scalar p1_nat = r(r1)
	scalar p2_nat = r(r2)
	foreach r of local list_levels {
		_pctile `v' [aw=weight_pop_rururb] if zone==`r', p($wins_lower_thres $wins_upper_thres)  
		scalar p1_lev_`r'=r(r1)
		scalar p2_lev_`r'=r(r2)
		di "Bottom 1% by zone  _`r' " p1_lev_`r'
		di "Top 1% by zone  _`r' " p2_lev_`r'
		di max(p1_lev_`r',p1_nat)
		di min(p2_lev_`r',p2_nat)
		replace  w_`v' = max(p1_lev_`r',p1_nat) if zone==`r' & w_`v' < max(p1_lev_`r',p1_nat) &  w_`v'!=.
		replace  w_`v' = min(p2_lev_`r',p2_nat) if zone==`r' & w_`v' > min(p2_lev_`r',p2_nat) &  w_`v'!=.
	}
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top and bottom 1%"
		*some variables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			foreach r of local list_levels {
				replace w_`v'_`g'= max(p1_lev_`r',p1_nat) if w_`v'_`g' < max(p1_lev_`r',p1_nat) & w_`v'_`g'!=. & w_`v'_`g'!=0  /* we want to keep actual zeros */
				replace w_`v'_`g'=  min(p2_lev_`r',p2_nat) if  w_`v'_`g' >  min(p2_lev_`r',p2_nat)  & w_`v'_`g'!=.		
				local l`v'_`g' : var lab `v'_`g'
				}
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winzorized top and bottom 1%"		
		}		
	}
}


*area_harv and area_plan are also winsorized both at the top 1% and bottom 1% because we need to analyze at the crop level 
global allyield male female mixed inter inter_male inter_female inter_mixed pure pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest 	
levelsof zone, local(list_levels)
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		gen w_`v'_`c'=`v'_`c'
		_pctile `v'_`c'  [aw=weight_pop_rururb] , p($wins_lower_thres $wins_upper_thres) 
		scalar p1_nat=r(r1)
		scalar p2_nat=r(r2)	
		foreach r of local list_levels {
			_pctile `v'_`c' [aw=weight_pop_rururb] if zone==`r', p($wins_lower_thres $wins_upper_thres)  
			scalar p1_lev_`r'=r(r1)
			scalar p2_lev_`r'=r(r2)
			replace  w_`v'_`c' = max(p1_lev_`r',p1_nat) if zone==`r' & w_`v'_`c' < max(p1_lev_`r',p1_nat) &  w_`v'_`c'!=.
			replace w_`v'_`c'=  min(p2_lev_`r',p2_nat) if zone==`r' & w_`v'_`c' >  min(p2_lev_`r',p2_nat)  & w_`v'_`c'!=.		
		}		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winzorized top and bottom 1%"
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			foreach r of local list_levels {
				replace w_`v'_`g'_`c' = max(p1_lev_`r',p1_nat) if zone==`r' & w_`v'_`g'_`c' < max(p1_lev_`r',p1_nat) &  w_`v'_`g'_`c'!=0 
				replace w_`v'_`g'_`c' =  min(p2_lev_`r',p2_nat) if zone==`r' & (w_`v'_`g'_`c' >  min(p2_lev_`r',p2_nat) & w_`v'_`g'_`c' !=.) 
			}
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winzorized top and bottom 1%"
			
		}
	}
}


*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
foreach v in inorg_fert org_fert n p k herb pest urea npk {
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
lab var herb_rate "Rate of herbicide application (kgs/ha) (household)"
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
lab var herb_rate_`g' "Rate of herbicide application (kgs/ha) (`g'-managed plots)"
lab var urea_rate_`g' "Rate of urea application (kgs/ha) (`g'-managed plots)"
lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
}

lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"


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


*mortality rate
global animal_species lrum srum pigs equine  poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost_agseas_`s'/mean_agseas_`s'
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

/*DYA.10.26.2020*/ 
*Hours per capita using winsorized version off_farm_hours 
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
gen liters_per_largeruminant= .
la var liters_per_largeruminant "Average quantity (liters) per year (household)"
global empty_vars $empty_vars liters_per_largeruminant		

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
*all rural households harvesting specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'==0 | w_area_plan_pure_`cn'==.  
}
*all rural households harvesting specific crops (in the long rainy season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'==1 & w_area_plan_pure_`cn'!=. 
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'==0 | w_area_plan_pure_`cn'==.  
}

*households engaged in dairy production  
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1				
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0		

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate n_rate p_rate k_rate cost_total_ha cost_expli_ha cost_expli_hh_ha /*		
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ /*DYA.10.26.2020*/  hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight_pop_rururb] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" | "`v'"=="n_rate" | "`v'"=="k_rate" | "`v'"=="p_rate" {
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
	_pctile `v'_exp_ha [aw=weight_pop_rururb] , p($wins_upper_thres)  
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
	_pctile `v'_exp_kg [aw=weight_pop_rururb] , p($wins_upper_thres)  
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
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight_pop_rururb] ,  p(95)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
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
 
*Create final income variables using un_winzorized and un_winzorized values
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
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
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
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	gen hybrid_seed_`cn'=.
	recode imprv_seed_`cn' hybrid_seed_`cn'  w_yield_pl_`cn' /* Hybrid seed and improved seed are a single category in this wave.
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
	global empty_vars $empty_vars hybrid_seed_`cn'
}
*all rural households that harvested specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0
}

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
	_pctile `p'_aghh  [aw=weight_pop_rururb] , p(40) 
	gen small_`p' = (`p' <= r(r1))
	replace small_`p' = . if ag_hh!=1
}
gen small_farm_household = (small_land_size==1 & small_tlu_today==1 & small_total_income==1)
replace small_farm_household = . if ag_hh != 1
sum small_farm_household if ag_hh==1 
drop land_size_aghh small_land_size tlu_today_aghh small_tlu_today total_income_aghh small_total_income   
lab var small_farm_household "1= HH is in bottom 40th percentiles of land size, TLU, and total revenue"

*create different weights 
gen w_labor_weight=weight_pop_rururb*w_labor_total
lab var w_labor_weight "labor-adjusted household weights"
gen w_land_weight=weight_pop_rururb*w_farm_area
lab var w_land_weight "land-adjusted household weights"
gen w_aglabor_weight_all=w_labor_hired*weight_pop_rururb
lab var w_aglabor_weight_all "Hired labor-adjusted household weights"
gen w_aglabor_weight_female=. // cannot create in this instrument  
lab var w_aglabor_weight_female "Hired labor-adjusted household weights -female workers"
gen w_aglabor_weight_male=. // cannot create in this instrument 
lab var w_aglabor_weight_male "Hired labor-adjusted household weights -male workers"
**# Bookmark #2
gen weight_milk=milk_animals * weight
gen weight_egg = poultry_owned*weight
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
	gen area_weight_`g'=weight_pop_rururb*w_ha_planted_`g'
}
gen w_ha_planted_weight=w_ha_planted_all*weight_pop_rururb
drop w_ha_planted_all
gen individual_weight=hh_members*weight_pop_rururb
gen adulteq_weight=adulteq*weight_pop_rururb

*Rural poverty headcount ratio
//ALT NB: We used to hard code the calculation here based on calculating the 2011 LCU/$PPP for private consumption and then inflating.
//I moved this to the globals at the top of the file so we could make modifications more easily and to avoid hard coding this far in.
/*
gen poverty_under_1_9 = (daily_percap_cons<$Nigeria_GHS_W4_poverty_threshold)	 
la var poverty_under_1_9 "Household has a per capita conumption of under $1.90 in 2018 $ PPP)"
*/
//ALT Update START
gen ccf_loc = (1/$Nigeria_GHS_W4_infl_adj) 
lab var ccf_loc "currency conversion factor - 2021 $NGN"
gen ccf_usd = ccf_loc/$Nigeria_GHS_W4_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Nigeria_GHS_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Nigeria_GHS_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

gen poverty_under_190 = (daily_percap_cons < $Nigeria_GHS_W4_poverty_190)
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $Nigeria_GHS_W4_poverty_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $Nigeria_GHS_W4_poverty_npl
la var poverty_under_npl "Household per-capita consumption is below the national poverty line"
gen poverty_under_300 = daily_percap_cons < $Nigeria_GHS_W4_poverty_300
la var poverty_under_300 "household per-capita consumption is below $3.00 in 2021 $PPP"
//ALT Update END
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

*generating clusterid and strataid
gen clusterid=ea
gen strataid=state
/*
*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in wheat beans {
		gen `x'_x = .
		ren *maize*_x *`c'*
	}
}

global empty_vars $empty_vars *wheat* *beans* 
*/
*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing
foreach v of varlist $empty_vars { 
	replace `v' = .
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid weight *weight_pop_rururb* *_weight* *wgt* zone state lga ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_* vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold /*DYA.10.26.2020*/ *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today /*HKS 6.6.23*/ nb_largerum_t nb_smallrum_t nb_chickens_t  *sales_livestock_products nb_cows_today lvstck_holding_srum  nb_smallrum_today nb_chickens_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products  *value_pro* *value_sal* *inter* *pure* *value_farm*

ren weight weight_sample
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria"
la var geography "Location of survey"
gen survey = "LSMS-ISA"
la var survey "Survey type (LSMS or AgDev)"
gen year = "2018-19"
la var year "Year survey was carried out"
gen instrument = 34 
la var instrument "Wave and location of survey"
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
*saveold "${Nigeria_GHS_W4_final_data}/Nigeria_GHS_W4_household_variables.dta", replace

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_largerum_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) & ag_hh==1 // HKS 6.16.23
saveold "${Nigeria_GHS_W4_final_data}/Nigeria_GHS_W4_household_variables.dta", replace

*Stop

********************************************************************************
*INDIVIDUAL-LEVEL VARIABLES
********************************************************************************
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_person_ids.dta", clear
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhsize.dta", nogen keep (1 3) 
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_hhids.dta", nogen keep (1 3)
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", nogen keepusing(weight_pop_rururb)
//End experimental code

*Land rights
merge 1:1 hhid indiv using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1	
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${Nigeria_GHS_W4_final_data}/Nigeria_GHS_W4_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)

replace   make_decision_ag =. if ag_hh==0

* NA in NG_LSMS-ISA
gen women_diet=.
gen  number_foodgroup=.

*generate missings
foreach c in wheat beans{
	gen all_imprv_seed_`c' = .
	gen all_hybrid_seed_`c' = .
	gen `c'_farmer = .
}

*Set improved seed adoption to missing if household is not growing crop
foreach v in $topcropname_area {
	replace all_imprv_seed_`v' =. if `v'_farmer==0 | `v'_farmer==.
	recode all_imprv_seed_`v' (.=0) if `v'_farmer==1
	//replace all_hybrid_seed_`v' =. if  `v'_farmer==0 | `v'_farmer==.
	//recode all_hybrid_seed_`v' (.=0) if `v'_farmer==1
	gen female_imprv_seed_`v'=all_imprv_seed_`v' if female==1
	gen male_imprv_seed_`v'=all_imprv_seed_`v' if female==0
	//gen all_hybrid_seed_`v' = .
	gen female_hybrid_seed_`v'= . //all_hybrid_seed_`v' if female==1
	gen male_hybrid_seed_`v'= . //all_hybrid_seed_`v' if female==0
	
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


*replace empty vars with missing 
global empty_vars *hybrid_seed* women_diet number_foodgroup
foreach v of varlist $empty_vars { 
	replace `v' = .
}

ren weight weight_sample 
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
ren indiv indid
gen geography = "Nigeria"
gen survey = "LSMS-ISA"
gen year = "2018-19"
gen instrument = 34 
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
gen strataid=state
gen clusterid=ea
saveold "${Nigeria_GHS_W4_final_data}/Nigeria_GHS_W4_individual_variables.dta", replace


********************************************************************************
*PLOT -LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_all_plots.dta", clear
collapse (sum) plot_value_harvest=value_harvest, by(hhid plot_id dm_gender)
merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_areas.dta", keep(1 3) nogen
merge m:1 hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_weights.dta", keep (1 3) nogen

//merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_cropvalue.dta", keep (1 3) nogen
//merge 1:1 hhid plot_id using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_decision_makers", keep (1 3) nogen // Bring in the gender file
merge 1:1 plot_id hhid using "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_plot_farmlabor.dta", keep (1 3) nogen

/*DYA.12.2.2020*/ merge m:1 hhid using "${Nigeria_GHS_W4_final_data}/Nigeria_GHS_W4_household_variables.dta", nogen keep (1 3) keepusing(ag_hh fhh farm_size_agland)
/*DYA.12.2.2020*/ recode farm_size_agland (.=0) 
/*DYA.12.2.2020*/ gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural==1 

keep if cultivate==1
ren field_size  area_meas_hectares

global winsorize_vars area_meas_hectares labor_total  

/*ALT update 05.04.23
foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight_pop_rururb] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)    
	replace w_`p' = r(r1) if w_`p' < r(r1)  & w_`p'!=. & w_`p'!=0
	replace w_`p' = r(r2) if w_`p' > r(r2)  & w_`p'!=.
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}

_pctile plot_value_harvest  [aw=weight_pop_rururb] , p($wins_upper_thres)  
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
gen plot_weight=w_area_meas_hectares*weight_pop_rururb 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}	
*/

foreach p of global winsorize_vars { 
	gen w_`p' =`p'
	local l`p' : var lab `p'
	_pctile w_`p'   [aw=weight_pop_rururb] if w_`p'!=0 , p($wins_lower_thres $wins_upper_thres)     
	scalar p1_nat = r(r1)
	scalar p2_nat = r(r2)
	foreach r of local list_levels {	
		_pctile w_`p' [aw=weight_pop_rururb] if zone==`r', p($wins_lower_thres $wins_upper_thres)
		scalar p1_lev_`r' = r(r1) 
		scalar p2_lev_`r' = r(r2)
		replace  w_`p' = max(p1_nat, p1_lev_`r') if  zone==`r' & w_`p' < max(p1_nat, p1_lev_`r') &  w_`p'!=.
		replace  w_`p' = min(p2_nat, p2_lev_`r') if  zone==`r' & w_`p' > min(p2_nat, p2_lev_`r') &  w_`p'!=.
	}
	lab var w_`p' "`l`p'' - Winsorized top and bottom 1%"
}
 
*Winsorize plot_value_harvest at top  1% only 
_pctile plot_value_harvest  [aw=weight_pop_rururb] , p($wins_upper_thres)  
gen w_plot_value_harvest=plot_value_harvest
replace w_plot_value_harvest = r(r1) if w_plot_value_harvest > r(r1) & w_plot_value_harvest != . 
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top 1%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_area_meas_hectares
lab var plot_productivity "Plot productivity Value production/hectare"
gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
lab var plot_labor_prod "Plot labor productivity (value production/labor-day)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_area_meas_hectares*weight_pop_rururb
lab var plot_weight "Weight for plots (weighted by plot area)"

foreach v of varlist  plot_productivity  plot_labor_prod {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winzorized top 1%"
}		

gen ccf_loc = (1/$Nigeria_GHS_W4_infl_adj) 
lab var ccf_loc "currency conversion factor - 2021 $NGN"
gen ccf_usd = ccf_loc/$Nigeria_GHS_W4_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$Nigeria_GHS_W4_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$Nigeria_GHS_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"


global monetary_val plot_value_harvest plot_productivity  plot_labor_prod 
foreach p of global monetary_val {
	gen `p'_1ppp = `p' * ccf_1ppp
	gen `p'_2ppp = `p' * ccf_2ppp
	gen `p'_usd = `p' * ccf_usd 
	gen `p'_loc =  `p' * ccf_loc 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2021 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2021 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2021$ USD)"
	lab var `p'_loc "`l`p'' (2021 NGN)" 
	lab var `p' "`l`p'' (NGN)"  
	gen w_`p'_1ppp = w_`p' * ccf_1ppp
	gen w_`p'_2ppp = w_`p' * ccf_2ppp
	gen w_`p'_usd = w_`p' * ccf_usd
	gen w_`p'_loc = w_`p' * ccf_loc
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2021 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2021 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2021 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2021 NGN)" 
	lab var w_`p' "`lw_`p'' (NGN)" 
}


*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
gen clusterid=ea
gen strataid=state
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
svy, subpop(if rural==1) : reg  lplot_productivity_usd male_dummy larea_meas_hectares i.state  
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
svy, subpop(  if rural==1 & rural_ssp==1): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.state
matrix b1b=e(b)
gen gender_prod_gap1b_ssp=100*el(b1b,1,1)
sum gender_prod_gap1b_ssp
lab var gender_prod_gap1b_ssp "Gender productivity gap (%) - regression in logs with controls - SSP"
matrix V1b=e(V)
gen segender_prod_gap1b_ssp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_ssp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - SSP"


*LS_SSP
svy, subpop(  if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.state
matrix b1b=e(b)
gen gender_prod_gap1b_lsp=100*el(b1b,1,1)
sum gender_prod_gap1b_lsp
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls - LSP"
matrix V1b=e(V)
gen segender_prod_gap1b_lsp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_lsp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - LSP"
/*DYA.12.2.2020 - End*/ 

//*BET.12.4.2020 - START*/ 

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
rename v1 NGA_wave4

save   "${Nigeria_GHS_W4_created_data}/Nigeria_GHS_W4_gendergap.dta", replace
restore
/*BET.12.4.2020 - END*/

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_labor_prod_all_`i'=w_plot_labor_prod_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_labor_prod_female_`i' = w_plot_labor_prod_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_labor_prod_male_`i' = w_plot_labor_prod_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
	gen w_plot_labor_prod_mixed_`i' = w_plot_labor_prod_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight_pop_rururb
ren weight weight_sample 
ren weight_pop_rururb weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"
//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Nigeria"
gen survey = "LSMS-ISA"
gen year = "2018-19"
gen instrument = 34 
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
saveold "${Nigeria_GHS_W4_final_data}/Nigeria_GHS_W4_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Nigeria_GHS_W4"

do "${summary_stats}"
