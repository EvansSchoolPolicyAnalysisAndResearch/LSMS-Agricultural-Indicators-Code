/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 		: Agricultural Development Indicators for the LSMS-ISA, Malawi National Panel Survey (IHS3) LSMS-ISA Wave 1 	
					  (2010-2011)

*Author(s)      	: Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu
				 
*Date				: September 5th, 2025

*Dataset Version	: MWI_2010_IHS-III_v01_M

----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period March 2010 - March 2011.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1003
*Refer to the section "set directories" below for guidance on how to organize file naming

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi IHS (MWI LSMS) data set.
*The do.file first constructs common and intermediate variables, saving dta files when appropriate.
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available.

*The processed files include all households, individuals, and plots in the sample where possible.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results will be outputted in the excel file "Malawi_IHS_W1_summary_stats.xlsx"
*It is possible to modify the condition  "if rural==1" in the beginning of the separate .do file EPAR_UW_335_SUMMARY_STATISTICS to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED OR SAVED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Malawi_IHS_W1_hhids.dta
*WEIGHTS							Malawi_IHS_W1_weights.dta
*INDIVIDUAL IDS						Malawi_IHS_W1_person_ids.dta
*HOUSEHOLD SIZE						Malawi_IHS_W1_hhsize.dta
									Malawi_IHS_W1_weights.dta
*GPS COORDINATES					Malawi_IHS_W1_hh_coords.dta
*PLOT AREAS							Malawi_IHS_W1_plot_areas.dta
*PLOT DECISION MAKERS			    Malawi_IHS_W1_plot_decision_makers.dta
*FORMALIZED LAND RIGHTS				Malawi_IHS_W1_land_rights_hh.dta
*CALORIC CONVERSION					Malawi_IHS_W1_caloric_cf_crop_codes.dta
*ALL PLOTS							Malawi_IHS_W1_ha_planted.dta
									Malawi_IHS_W1_plot_season_length.dta
									Malawi_IHS_W1_hh_crop_prices_for_wages.dta
									Malawi_IHS_W1_all_plots_long.dta
									Malawi_IHS_W1_all_plots.dta
*TLU (Tropical Livestock Units)		Malawi_IHS_W1_TLU_Coefficients.dta
*GROSS CROP REVENUE					Malawi_IHS_W1_cropsales_value.dta
									Malawi_IHS_W1_crop_values_production.dta
									Malawi_IHS_W1_hh_crop_production.dta
									Malawi_IHS_W1_crop_losses.dta
*CROP EXPENSES						Malawi_IHS_W1_plot_labor_long.dta
									Malawi_IHS_W1_hh_cost_labor.dta
									Malawi_IHS_W1_fertilizer_kg_application.dta
									Malawi_IHS_W1_asset_rental_costs.dta
									Malawi_IHS_W1_cost_per_plot.dta
									Malawi_IHS_W1_plot_cost_inputs.dta
									Malawi_IHS_W1_input_quantities.dta
									Malawi_IHS_W1_hh_cost_inputs.dta
*MONOCROPPED PLOTS					Malawi_IHS_W1_monocrop_plots.dta
*LIVESTOCK INCOME					Malawi_IHS_W1_livestock_expenses.dta
									Malawi_IHS_W1_livestock_sales.dta
									Malawi_IHS_W1_herd_characteristics.dta
									Malawi_IHS_W1_TLU.dta
									Malawi_IHS_W1_livestock_income.dta
*FISH INCOME						Malawi_IHS_W1_fishing_expenses_1.dta
									Malawi_IHS_W1_fishing_expenses_2.dta
									Malawi_IHS_W1_fish_income.dta
*SELF-EMPLOYMENT INCOME				Malawi_IHS_W1_self_employment_income.dta
									Malawi_IHS_W1_fish_trading_income.dta
*NON-AG WAGE INCOME					Malawi_IHS_W1_wage_income.dta
*AG WAGE INCOME						Malawi_IHS_W1_agwage_income.dta
*OTHER INCOME						Malawi_IHS_W1_other_income.dta
									Malawi_IHS_W1_land_rental_income.dta
*FARM SIZE / LAND SIZE				Malawi_IHS_W1_land_size.dta
									Malawi_IHS_W1_farmsize_all_agland.dta
									Malawi_IHS_W1_land_size_all.dta
*OFF-FARM HOURS						Malawi_IHS_W1_off_farm_hours.dta
*FARM LABOR							Malawi_IHS_W1_plot_farmlabor_rainyseason.dta
									Malawi_IHS_W1_plot_farmlabor_dryseason.dta
									Malawi_IHS_W1_family_hired_labor.dta
*VACCINE USAGE						Malawi_IHS_W1_vaccine.dta
*ANIMAL HEALTH - DISEASES			Malawi_IHS_W1_livestock_diseases.dta
*USE OF INORGANIC FERTILIZER		Malawi_IHS_W1_fert_use.dta
*FERTILIZER APPLICATION RATE		Malawi_IHS_W1_fertilizer_application.dta
									Malawi_IHS_W1_fertilizer_application_plot.dta
*PLOT MANAGERS						Malawi_IHS_W1_farmer_improved_hybrid_seed_use.dta
									Malawi_IHS_W1_improved_hybrid_seed_use.dta
									Malawi_IHS_W1_input_use.dta
*REACHED BY AG EXTENSION			Malawi_IHS_W1_any_ext.dta
*MOBILE PHONE OWNERSHIP				Malawi_IHS_W1_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	Malawi_IHS_W1_fin_serv.dta
*MILK PRODUCTIVITY					Malawi_IHS_W1_milk_animals.dta
*EGG PRODUCTIVITY					Malawi_IHS_W1_eggs_animals.dta
*CROP PRODUCTION COSTS PER HECTARE	Malawi_IHS_W1_cropcosts.dta
*RATE OF FERTILIZER APPLICATION		Malawi_IHS_W1_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Malawi_IHS_W1_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Malawi_IHS_W1_control_income.dta
*WOMEN'S AG DECISION-MAKING			Malawi_IHS_W1_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Malawi_IHS_W1_ownasset.dta
*AGRICULTURAL WAGES					Malawi_IHS_W1_ag_wage.dta
*CROP YIELDS						Malawi_IHS_W1_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Malawi_IHS_W1_shannon_diversity_index.dta
*CONSUMPTION						Malawi_IHS_W1_consumption.dta
*HOUSEHOLD FOOD PROVISION			Malawi_IHS_W1_food_security.dta
*FOOD SECURITY						Malawi_IHS_W1_food_cons.dta
*HOUSEHOLD ASSETS					Malawi_IHS_W1_hh_assets.dta
*SHOCKS								Malawi_IHS_W1_clim_shocks.dta
*PLOT LEVEL VARIABLES				Malawi_IHS_W1_gendergap.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				MWI_IHS_W1_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			MWI_IHS_W1_individual_variables.dta	
*PLOT-LEVEL VARIABLES				MWI_IHS_W1_gender_productivity_gap.dta
*SUMMARY STATISTICS					MWI_IHS_W1_summary_stats.xlsx
*/

clear
set more off

clear matrix	
clear mata	
set maxvar 8000	
ssc install findname	

*****************************
***** SET DIRECTOREIS *******
*****************************
global directory "../.."
global MWI_IHS_W1_raw_data "$directory\Malawi IHS\Malawi IHS Wave 1\Raw DTA Files" //Use the full sample folder, which already contains the panel sample
global MWI_IHS_W1_appended_data "$directory\Malawi IHS\Malawi IHS Wave 1\Final DTA Files/temp_data"
global MWI_IHS_W1_created_data "$directory\Malawi IHS\Malawi IHS Wave 1\Final DTA Files/created_data"
global MWI_IHS_W1_final_data "$directory\Malawi IHS\Malawi IHS Wave 1\Final DTA Files/final_data"
global summary_stats "$directory\_Summary_statistics\EPAR_UW_335_SUMMARY_STATISTICS.do" //Path to the summary statistics file. This can take a long time to run, so the user should comment out this line the summary statistics output is not needed; if this line is commented out, the file will end with an error.

*Ensure that files downloaded from the microdata.worldbank.org link above are organized into the following sub-directories of \raw_data according to topic:
*Agriculture, Community, Fisheries, Geovariables, Household

********************************************************************************
*RE-SCALING SURVEY WEIGHTS TO MATCH POPULATION ESTIMATES
********************************************************************************
*https://databank.worldbank.org/source/world-development-indicators#
//population data from 2010, the last year in which data were collected for this wave
global MWI_IHS_W1_pop_tot 14718422
global MWI_IHS_W1_pop_rur 12430590
global MWI_IHS_W1_pop_urb 2287832

********************************************************************************
* EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD *
********************************************************************************
global MWI_IHS_W1_exchange_rate 805.9	  //https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2017&locations=MW&start=2011 {2017:730.27, 2021:805.9}
global MWI_IHS_W1_gdp_ppp_dollar 294.86 //2021    //https://data.worldbank.org/indicator/PA.NUS.PPP?end=2017&locations=MW&start=2011
global MWI_IHS_W1_cons_ppp_dollar 282.09 //2021	  //https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2017&locations=MW&start=2011
global MWI_IHS_W1_inflation 0.216626 // CPI Survey Year 2010/CPI of Poverty Line Baseline Year 2017=107.62/340.24, 2021=496.8 
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
global MWI_IHS_W1_2013_10_infl_adj 0.647922938 // CPI survey year 2011=107.62/CPI survey year 2013=166.1 https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009

global MWI_IHS_W1_poverty_under_190 (1.90*78.77*100/107.6) //see calculation and sources below
//WB's previous (PPP) poverty threshold is $1.90. 
//Multiplied by 78.77 - 2011 PPP conversion factor, private consumption (LCU per international $) - Malawi - https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=MW&start=2011
//Multiplied by 100 - 2010 Consumer price index (2010=100) - Malawi - https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2010&locations=MW&start=2010
//Divided by 107.6 - 2011 Consumer price index (2010=100) - Malawi - https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2011&locations=MW&start=2011
global MWI_IHS_W1_poverty_under_npl (109797*100/340.2/365) //see calculation and sources below
//MWI government set national poverty line to MWK109,797 in January 2017 values //https://massp.ifpri.info/files/2019/05/IFPRI_KeyFacts_Poverty_Final.pdf
//Multiplied by CPI in 2010 of 100 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
//Divided by CPI in 2017 of 340.2 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
//Divide  by # of days in year (365) to get daily amount
global MWI_IHS_W1_poverty_under_215 (2.15* (0.31630613 * 249.1))  //WB's (PPP) poverty threshold of $2.15 multiplied by globals
global MWI_IHS_W1_poverty_under_300 (3.00*($MWI_IHS_W1_inflation * $MWI_IHS_W1_cons_ppp_dollar)) //WB's New (PPP) poverty threshold of $3.00
 
********************************************************************************
* THRESHOLDS FOR WINSORIZATION *
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
* GLOBALS OF PRIORITY CROPS *
********************************************************************************
*Determined by the top 12 crops by area cultivated for MWI W1 (see All Plots)
global topcropname_area "maize tobacc grdnt pigpea nkhwni beans sorgum soy rice cotton swtptt pmill"
global topcrop_area "1 5 11 36 42 34 32 35 17 37 28 33" //corresponding numeric crop codes
global comma_topcrop_area "1, 5, 11, 36, 42, 34, 32, 35, 17, 37, 28, 33"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 

//display "$nb_topcrops"
set obs $nb_topcrops 
//This section can be commented out after the first run.
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
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropname_table.dta", replace //This gets used to generate the monocrop files.

********************************************************************************
* Cross-wave compatibility
********************************************************************************
// This section updates the household IDs in the raw dta files to make panel merges with other waves easier; it only needs to run once. 

capture confirm file "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_a_filt.dta" //Simple check to see if the code has already run; delete this file to make it run again. 
if _rc {
preserve
use "${directory}\Malawi IHS\mwi_panel_ids.dta", clear
keep if wave == 1
keep case_id case_id_aux
ren case_id_aux hhid
tempfile hhids
save `hhids'
save "${MWI_IHS_W1_created_data}\Malawi_panel_ids.dta", replace
restore

* Agriculture
global ag_raw_file_names ""
foreach x in a_filt b c d e f g h i j k l m n o p q r1 r2 s t1 t2 network {
	global ag_raw_file_names $ag_raw_file_names "ag_mod_`x'"
}

local ag_file "$MWI_IHS_W1_raw_data\Agriculture"
local ag_filelist : dir "`ag_file'" files "*.dta"

local n_ag_filelist : word count `ag_filelist'
local n_ag_raw_file_names : word count $ag_raw_file_names
assert `n_ag_filelist'==`n_ag_raw_file_names' // check that lengths are equal (requirement for loop to work)

forvalues i = 1/`n_ag_filelist' {
	local a : word `i' of `ag_filelist'
	local tempor = "${MWI_IHS_W1_raw_data}\Agriculture\" + "`a'"
	use "`tempor'", clear
	capture confirm var hhid
	if _rc == 111 {
		merge m:1 case_id using `hhids', nogen keep(3)
		replace hhid = case_id if hhid == ""
		ren case_id y1_hhid
		local save_file = "${MWI_IHS_W1_appended_data}\Agriculture\" + "`a'"
		save "`save_file'", replace
	}
	else {
		drop hhid
		merge m:1 case_id using `hhids', nogen keep(3)
		replace hhid = case_id if hhid == ""
		ren case_id y1_hhid
		local save_file = "${MWI_IHS_W1_appended_data}\Agriculture\" + "`a'"
		save "`save_file'", replace
	}
}

* Community
// not relevant for hhid conversion, all files have ea as unique id, not case_id
global comm_raw_file_names ""
foreach x in ca cb cc cd ce cf cg1 cg2 cg ci cj ck {
	global comm_raw_file_names $comm_raw_file_names "com_`x'"
}
local comm_file "$MWI_IHS_W1_raw_data\Community"
local comm_filelist : dir "`comm_file'" files "*.dta"

local n_comm_filelist : word count `comm_filelist'
local n_comm_raw_file_names : word count $comm_raw_file_names
assert `n_comm_filelist'==`n_comm_raw_file_names' // check that lengths are equal (requirement for loop to work)

forvalues i = 1/`n_comm_filelist' {
	local a : word `i' of `comm_filelist'
	local tempor = "${MWI_IHS_W1_raw_data}\Community\" + "`a'"
	use "`tempor'", clear
	local save_file = "${MWI_IHS_W1_appended_data}\Community\" + "`a'"
	save "`save_file'", replace
}

* Fisheries
global fs_raw_file_names ""
foreach x in b c d1 d2 d3 e1 e2 f1 f2 g h1 h2 h3 i1 i2 j1 j2 {
	global fs_raw_file_names $fs_raw_file_names "fs_mod_`x'"
}

local fs_file "$MWI_IHS_W1_raw_data\Fisheries"
local fs_filelist : dir "`fs_file'" files "*.dta"

local n_fs_filelist : word count `fs_filelist'
local n_fs_raw_file_names : word count $fs_raw_file_names
assert `n_fs_filelist'==`n_fs_raw_file_names' // check that lengths are equal (requirement for loop to work)

forvalues i = 1/`n_fs_filelist' {
	local a : word `i' of `fs_filelist'
	local tempor = "${MWI_IHS_W1_raw_data}\Fisheries\" + "`a'"
	use "`tempor'", clear
	capture confirm var hhid
	if _rc == 111 {
		merge m:1 case_id using `hhids', nogen keep(3)
		replace hhid = case_id if hhid == ""
		ren case_id y1_hhid
		local save_file = "${MWI_IHS_W1_appended_data}\Fisheries\" + "`a'"
		save "`save_file'", replace
	}
	else {
		drop hhid
		merge m:1 case_id using `hhids', nogen keep(3)
		replace hhid = case_id if hhid == ""
		ren case_id y1_hhid
		local save_file = "${MWI_IHS_W1_appended_data}\Fisheries\" + "`a'"
		save "`save_file'", replace
	}
}

* Household
global hh_raw_file_names ""
foreach x in a_filt b c d e f g1 g2 g3 h i1 i2 j k l m n1 n2 o p q r s1 s2 t u v w x {
	global hh_raw_file_names $hh_raw_file_names "hh_mod_`x'"
}

local hh_file "$MWI_IHS_W1_raw_data\Household"
local hh_filelist : dir "`hh_file'" files "*.dta"

local n_hh_filelist : word count `hh_filelist'
local n_hh_raw_file_names : word count $hh_raw_file_names
assert `n_hh_filelist'==`n_hh_raw_file_names' // check that lengths are equal (requirement for loop to work)

forvalues i = 1/`n_hh_filelist' {
	local a : word `i' of `hh_filelist'
	local tempor = "${MWI_IHS_W1_raw_data}\Household\" + "`a'"
	use "`tempor'", clear
	capture confirm var hhid
	if _rc == 111 {
		merge m:1 case_id using `hhids', nogen keep(3)
		replace hhid = case_id if hhid == ""
		ren case_id y1_hhid
		local save_file = "${MWI_IHS_W1_appended_data}\Household\" + "`a'"
		save "`save_file'", replace
	}
	else {
		drop hhid
		merge m:1 case_id using `hhids', nogen keep(3)
		replace hhid = case_id if hhid == ""
		ren case_id y1_hhid
		local save_file = "${MWI_IHS_W1_appended_data}\Household\" + "`a'"
		save "`save_file'", replace
	}
}

* Geovariables
// hh level
use "${MWI_IHS_W1_raw_data}\Geovariables\HH_level\householdgeovariables.dta", clear
merge m:1 case_id using `hhids', nogen
replace hhid = case_id if hhid == ""
ren case_id y1_hhid
save "${MWI_IHS_W1_appended_data}\Geovariables\HH_level\householdgeovariables.dta", replace

// plot level
use "${MWI_IHS_W1_raw_data}\Geovariables\Plot_level\plotgeovariables.dta", clear
merge m:1 case_id using `hhids', nogen
replace hhid = case_id if hhid == ""
ren case_id y1_hhid
save "${MWI_IHS_W1_appended_data}\Geovariables\Plot_level\plotgeovariables.dta", replace

//Consumption
use "${MWI_IHS_W1_raw_data}\Round 1 (2010) Consumption Aggregate.dta", clear
merge m:1 case_id using `hhids', nogen
replace hhid = case_id if hhid == ""
ren case_id y1_hhid
save "${MWI_IHS_W1_appended_data}\Round 1 (2010) Consumption Aggregate.dta", replace
}

********************************************************************************
* HOUSEHOLD IDS *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_a_filt.dta", clear
rename hh_a01 district
rename hh_a02 ta 
rename hh_wgt weight
ren ea_id ea
gen rural = (reside==2)
ren reside stratum
gen region = . 
replace region=1 if inrange(district, 101, 107)
replace region=2 if inrange(district, 201, 210)
replace region=3 if inrange(district, 301, 315)
lab var region "1=North, 2=Central, 3=South"
lab var rural "1=Household lives in a rural area"
gen panel = qx_type=="Panel A" | qx_type=="Panel B"
keep hhid district ta ea rural region weight panel
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", replace
// This dataset includes hhid as a unique identifier, along with its location identifiers (i.e. rural, ea, etc.).

********************************************************************************
* WEIGHTS * 
********************************************************************************
/*use "${MWI_IHS_W1_appended_data}\Household\hh_mod_a_filt.dta", clear
rename hh_a01 district
rename hh_a02 ta
rename hh_wgt weight
gen rural = (reside==2)
ren reside stratum
ren ea_id ea
gen region = . 
replace region=1 if inrange(district, 101, 107)
replace region=2 if inrange(district, 201, 210)
replace region=3 if inrange(district, 301, 315)
lab var region "1=North, 2=Central, 3=South"
lab var rural "1=Household lives in a rural area"
keep hhid region stratum district ta ea rural weight  
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", replace
*/

********************************************************************************
* INDIVIDUAL IDS *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_b.dta", clear
keep hhid hh_b01 hh_b03 hh_b04 hh_b05a
ren hh_b01 indiv
gen female= (hh_b03==2)
lab var female "1= Individual is female"
gen age=hh_b05a
lab var age "Individual age"
gen hh_head= (hh_b04==1)
lab var hh_head "1= individual is household head"
replace hh_head=0 if hh_head !=1
drop hh_b03 hh_b04 hh_b05a
duplicates drop  hhid indiv hh_head female, force //0 duplicates
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", replace
//This rescales the weights to match the population better (original weights underestimate total population and overestimate rural population)

********************************************************************************
* HOUSEHOLD SIZE *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_b.dta", clear
gen byte hhmember = inrange(hh_b04, 1, 10)
label variable hhmember "Dummy Variable = 1 if Individual is Considered a Household Member in 2010"
drop if hhmember==0 //A small number of panel individuals have either left the household or died; question not asked for cross section.
recode hhmember (.=1)
ren hhmember hh_members
rename hh_b03 gender
ren hh_b05a age
gen adulteq=.
replace adulteq=0.4 if (age<3 & age>=0)
replace adulteq=0.48 if (age<5 & age>2)
replace adulteq=0.56 if (age<7 & age>4)
replace adulteq=0.64 if (age<9 & age>6)
replace adulteq=0.76 if (age<11 & age>8)
replace adulteq=0.80 if (age<=12 & age>10) & gender==1		//1=male, 2=female
replace adulteq=0.88 if (age<=12 & age>10) & gender==2 		//ALT 01.04.21: Updated to <=12 b/c 12 yo's were being excluded from analysis
replace adulteq=1 if (age<15 & age>12)
replace adulteq=1.2 if (age<19 & age>14) & gender==1
replace adulteq=1 if (age<19 & age>14) & gender==2
replace adulteq=1 if (age<60 & age>18) & gender==1
replace adulteq=0.88 if (age<60 & age>18) & gender==2
replace adulteq=0.8 if (age>59 & age!=.) & gender==1
replace adulteq=0.72 if (age>59 & age!=.) & gender==2
replace adulteq=. if age==999
rename hh_b04 relhead 

gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members adulteq (max) fhh, by (hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
//Rescaling the weights to match the population better
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${MWI_IHS_W1_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"

*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${MWI_IHS_W1_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${MWI_IHS_W1_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

total hh_members [pweight=weight] if panel
matrix temp =e(b)
gen weight_panel=weight*${MWI_IHS_W1_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_panel] if panel
lab var weight_panel "Survey weight - adjusted for panel households"

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
//Align with waves 3 and 4
ren weight weight_sample
ren weight_pop_rururb weight
//save "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_hhsize.dta", replace //redundant
keep hhid region district ta ea weight* rural hh_members adulteq rural fhh
save "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_weights.dta", replace

********************************************************************************
* GPS COORDINATES *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Geovariables\HH_level\householdgeovariables.dta", clear
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen keep(3) 
ren lat_modified latitude
ren lon_modified longitude
keep hhid latitude longitude
gen GPS_level = "hhid"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_coords.dta", replace

********************************************************************************
* PLOT AREAS *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_p.dta", clear
gen season=2 //perm
ren ag_p0b plot_id
ren ag_p0d crop_code_perm // note: no need to recode/align values + labels with crop_code_long; just using crop_code_perm for collapse internal to this section
ren ag_p02a area
ren ag_p02b unit
duplicates drop //one duplicate entry
drop if plot_id=="" //6,732 observations deleted // A large number of obs have no plot_id (and are also zeroes) there's no reason to hold on to these observations since they cannot be matched with any other module and don't appear to contain meaningful information.
keep if strpos(plot_id, "T") & plot_id!=""
collapse (max) area, by(hhid plot_id crop_code_perm season unit) //AT: CHECK ON THIS
collapse (sum) area, by(hhid plot_id season unit)
recode area (0=.)
drop if area==. & unit==.

gen area_acres_est = area if unit==1 //Permanent crops in acres
replace area_acres_est = (area*2.47105) if unit == 2 & area_acres_est ==. //Permanent crops in hectares
replace area_acres_est = (area*0.000247105) if unit == 3 & area_acres_est ==.	//Permanent crops in square meters
collapse (sum) area_acres_est, by(hhid plot_id)
keep hhid plot_id area_acres_est
tempfile ag_perm
save `ag_perm'

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_c.dta", clear
gen season=0 //rainy
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_j.dta", gen(dry)
replace season=1 if season==. //dry
ren ag_c00 plot_id
replace plot_id=ag_j00 if plot_id=="" //1,447 real changes

* Counting acreage
gen area_acres_est = ag_c04a if ag_c04b == 1 										//Self-report in acres - rainy season 
replace area_acres_est = (ag_c04a*2.47105) if ag_c04b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_c04a*0.000247105) if ag_c04b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_j05a if ag_j05b==1 										//Replace with dry season measures if rainy season is not available
replace area_acres_est = (ag_j05a*2.47105) if ag_j05b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_j05a*0.000247105) if ag_j05b == 3 & area_acres_est ==.	//Self-report in square meters

* GPS MEASURE
gen area_acres_meas = ag_c04c														//GPS measure - rainy
replace area_acres_meas = ag_j05c if area_acres_meas==. 							//GPS measure - replace with dry if no rainy season measure

append using `ag_perm'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen area_est_hectares=area_acres_est / 2.47105
gen area_meas_hectares= area_acres_meas / 2.47105

recode area_meas_hectares area_est_hectares (.=0)
collapse (max) area_meas_hectares area_est_hectares, by(hhid plot_id)
gen field_size = area_meas_hectares
recode field_size (0=.)
replace field_size= area_est_hectares if field_size==.
recode field_size (0=.)
//keep if area_acres_est !=. | area_acres_meas !=. //13,491 obs deleted - Keep if acreage or GPS measure info is available
//keep hhid plot_id season area_meas_hectares area_est_hectares field_size			
gen gps_meas = area_meas_hectares!=. 
lab var gps_meas "Plot was measured with GPS, 1=Yes"

lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta", replace

********************************************************************************
* PLOT DECISION MAKERS * 
********************************************************************************
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", clear
drop if hh_head==0
duplicates drop hhid, force //1 obs deleted
tempfile pids 
save `pids'

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_p.dta", clear 
//11,931 
ren ag_p0b plot_id
gen season=2
ren ag_p0d crop_code_perm
replace crop_code_perm=10 if strpos(ag_p0d_os, "LEMONS") 
replace crop_code_perm=13 if strpos(ag_p0d_os, "MPOZA") 
replace crop_code_perm=12 if strpos(ag_p0d_os, "PEACHES") 
replace crop_code_perm=15 if strpos(ag_p0d_os, "PINEAPPLE") 
gen crop_code = crop_code_perm //file does not contain crop_code 
lab var crop_code_perm "TREE/PERMANENT CROP CODE"
drop if crop_code_perm ==. //6727 deleted, many households do not have tree crops
//duplicates drop hhid crop_code_perm garden_id plot_id, force //hhid appears to uniquely identify all households here 
keep hhid plot_id crop_code_perm season
duplicates tag hhid plot_id, gen(dups) //5795
preserve
keep if dups > 0 //4804 deleted
keep hhid plot_id season
duplicates drop
tempfile dm_p_hoh
save `dm_p_hoh' //reserve the multiple instances of similar crops for use in another recipe
restore
drop if dups>0 //restricting observations to those where a unique crop is grown on only one plot
drop dups
tempfile one_plot_per_crop
gen source_file="mod_p"
save `one_plot_per_crop' //4804

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_q.dta", clear
drop if ag_q01==2 //drop if no crop was sold.
ren ag_q06a indiv1 
ren ag_q06b indiv2 
ren ag_q0b crop_code_perm
duplicates drop hhid crop_code_perm indiv1 indiv2, force
merge 1:m hhid crop_code_perm  using `one_plot_per_crop', keep(2 3)
//The 2's will eventually get the same treatment as "dm_p_hoh"
keep hhid plot_id indiv* 
reshape long indiv, i(hhid plot_id) j(id_no)
gen season=2
recode indiv (.a=.)
tempfile dm_p
save `dm_p'

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear //No point in attempting to understand ownership because it isn't included in the instrument and all plots have at least one manager listed.
//merge m:1 hhid using "${MWI_IHS_W1_appended_data}\Household\hh_mod_b.dta", nogen keep(1 3)
//drop if ag_d20a==. //If no crops were cultivated on plot
rename ag_d00 plot_id
drop if plot_id=="" //0 observations deleted
gen season=0
ren ag_d01 indiv1 //manager
gen no_manager = indiv1==.  //0 plots with no managers
//replace indiv1 = ag_d13a if no_manager==1 // owners, if no managers - ag_d13a is the network roster 
recode indiv* (0=.)
keep hhid plot_id indiv* season
//duplicates drop //0 duplicates
tempfile dm_r
save `dm_r'

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear
//merge m:1 hhid using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_i.dta", nogen keep(1 3)
//drop if ag_k21a==. //Uncultivated
ren ag_k0a plot_id
drop if plot_id==""
gen season=1
gen indiv1=ag_k02 //manager
gen indiv2=ag_k05a //owner
replace indiv1=indiv2 if indiv1==.
recode indiv* (0=.)
keep hhid plot_id indiv* season 
//collapse (firstnm) indiv*, by(hhid plot_id garden_id season)
append using `dm_r'
duplicates tag hhid plot_id season, gen (dup)
drop if dup>0
drop dup
reshape long indiv, i(hhid plot_id season) j(id_no)
append using `dm_p'

preserve
bys hhid plot_id season : egen mindiv = min(indiv)
keep if mindiv==. 
duplicates drop
append using `dm_p_hoh' //670 obs
drop mindiv indiv id_no
merge m:1 hhid using `pids', nogen keep(3)
gen id_no=1
tempfile hoh_plots
save `hoh_plots'
restore

drop if indiv==.
merge m:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen keep (1 3) // only 6 observations unmatched
append using `hoh_plots'
gen dm1_gender=female+1 if id_no==1
gen dm1_id = indiv if id_no==1
preserve 
keep hhid plot_id indiv season female //for individual manager input use 
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_dm_ids.dta", replace
restore
collapse (mean) female (firstnm) dm1_gender dm1_id, by(hhid plot_id season)
gen dm_gender =3 if female !=.
replace dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
replace dm1_gender=dm_gender if dm1_gender==. & dm_gender<3
//5 with dm_gender missing
save  "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", replace  

********************************************************************************
* FORMALIZED LAND RIGHTS *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
gen season=0
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta"
replace season=1 if season==.
ren ea_id ea
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen formal_land_rights=1 if ag_d03>1 & ag_d03<5
replace formal_land_rights=1 if ag_k04>1 & ag_k04<6 & formal_land_rights==.
replace formal_land_rights=0 if ag_d03>4 & formal_land_rights==.
replace formal_land_rights=0 if ag_k04>4 & formal_land_rights==.

//Primary Land Owner
preserve
gen indiv=ag_d04a
replace indiv=ag_k05a if ag_k05a!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", keep (1 3) nogen //9 observations where formal_land_rights==1 but indiv is not merging
gen primary_land_owner = 1
ren female primary_land_owner_female
collapse (max) formal_land_rights primary_land_owner primary_land_owner_female, by(hhid indiv)
drop if indiv == .
tempfile p1
save `p1'
restore

//Secondary Land Owner
gen indiv=ag_d04b
replace indiv=ag_k05b if ag_k05b!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", keep (1 3) nogen //0 observations where formal_land_rights==1 but indiv is not merging
gen secondary_land_owner = 1
ren female secondary_land_owner_female
keep hhid indiv formal_land_rights secondary_land_owner secondary_land_owner_female
drop if indiv == .

append using `p1'
gen formal_land_rights_f=1 if formal_land_rights==1 & (primary_land_owner_female==1 | secondary_land_owner_female==1)
recode formal_land_rights_f .=0
preserve
collapse (max) formal_land_rights_f, by(hhid indiv)		
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rights_ind.dta", replace
restore
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)
keep hhid formal_land_rights_hh
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rights_hh.dta", replace

********************************************************************************
* CALORIC CONVERSION *
********************************************************************************
	// caloric_conversionfactor.dta from WB
	capture confirm file "${MWI_IHS_W1_created_data}/caloric_conversionfactor.dta"
	if !_rc {
	use "${MWI_IHS_W1_created_data}/caloric_conversionfactor.dta", clear
	
	/*The file contains some redundancies (e.g., we don't need maize flour because we know the caloric value of the grain; white and orange sweet potato are identical, etc. etc.)
	So we need a step to drop the irrelevant entries. */
	//Unlikely that tea and coffee are coded as tea/coffee
	//Also, data issue: no crop code indicates green maize (i.e., sweet corn); I'm assuming this means cultivation information is not tracked for that crop
	//Calories for wheat flour are slightly higher than for raw wheat berries.
	drop if inlist(item_code, 101, 102, 103, 105, 202, 204, 206, 207, 301, 305, 405, 813, 820, 822, 901, 902) | cal_100g == .

	
	local item_name item_name
	foreach var of varlist item_name{
		gen item_name_upper=upper(`var')
	}
	
	gen crop_code = .
	count if missing(crop_code) //106 missing
	
	// crop seed master list
	replace crop_code=1 if strpos(item_name_upper, "MAIZE") 
	replace crop_code=5 if strpos(item_name_upper, "TOBACCO")
	replace crop_code=11 if strpos(item_name_upper, "GROUNDNUT") 
    replace crop_code=17 if strpos(item_name_upper, "RICE")
	replace crop_code=34 if strpos(item_name_upper, "BEAN")
	replace crop_code=27 if strpos(item_name_upper, "GROUND BEAN") | strpos(item_name_upper, "NZAMA")
	replace crop_code=28 if strpos(item_name_upper, "SWEET POTATO")
	replace crop_code=29 if strpos(item_name_upper, "IRISH POTATO") | strpos(item_name_upper, "MALAWI POTATO")
	replace crop_code=30 if strpos(item_name_upper, "WHEAT")
	replace crop_code=31 if strpos(item_name_upper, "FINGER MILLET")  | strpos(item_name_upper, "MAWERE")
	replace crop_code=32 if strpos(item_name_upper, "SORGHUM")
	replace crop_code=46 if strpos(item_name_upper, "PEA") // first to account for PEArl millet and pigeonPEA
	replace crop_code=33 if strpos(item_name_upper, "PEARL MILLET") | strpos(item_name_upper, "MCHEWERE")
	replace crop_code=35 if strpos(item_name_upper, "SOYABEAN")
	replace crop_code=36 if strpos(item_name_upper, "PIGEONPEA")| strpos(item_name_upper, "NANDOLO") | strpos(item_name_upper, "PIGEON PEA")
	replace crop_code=38 if strpos(item_name_upper, "SUNFLOWER")
	replace crop_code=39 if strpos(item_name_upper, "SUGAR CANE")
	replace crop_code=40 if strpos(item_name_upper, "CABBAGE")
	replace crop_code=41 if strpos(item_name_upper, "TANAPOSI")
	replace crop_code=42 if strpos(item_name_upper, "NKHWANI")
	replace crop_code=43 if strpos(item_name_upper, "OKRA")
	replace crop_code=44 if strpos(item_name_upper, "TOMATO")
	replace crop_code=45 if strpos(item_name_upper, "ONION")
	replace crop_code=47 if strpos(item_name_upper, "PAPRIKA")

	count if missing(crop_code) //87 missing
	
	// food from tree/permanent crop master list
	replace crop_code=49 if strpos(item_name_upper,"CASSAVA") 
	replace crop_code=50 if strpos(item_name_upper,"TEA")
	replace crop_code=51 if strpos(item_name_upper,"COFFEE") 
	replace crop_code=52 if strpos(item_name_upper,"MANGO")
	replace crop_code=53 if strpos(item_name_upper,"ORANGE")
	replace crop_code=54 if strpos(item_name_upper,"PAWPAW")| strpos(item_name_upper, "PAPAYA")
	replace crop_code=55 if strpos(item_name_upper,"BANANA")
	
	replace crop_code=56 if strpos(item_name_upper,"AVOCADO" )
	replace crop_code=57 if strpos(item_name_upper,"GUAVA" )
	replace crop_code=58 if strpos(item_name_upper,"LEMON" )
	replace crop_code=59 if strpos(item_name_upper,"NAARTJE" )| strpos(item_name_upper, "TANGERINE")
	replace crop_code=60 if strpos(item_name_upper,"PEACH" )
	replace crop_code=61 if strpos(item_name_upper,"POZA") | strpos(item_name_upper, "APPLE")
	replace crop_code=63 if strpos(item_name_upper,"MASAU")
	replace crop_code=64 if strpos(item_name_upper,"PINEAPPLE" )
	replace crop_code=65 if strpos(item_name_upper,"MACADEMIA" )
	count if missing(crop_code) //76 missing
	drop if crop_code == . 
	
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_caloric_conversionfactor_crop_codes.dta", replace 
	}
	else {
	di as error "Updated calorie conversion factor file not present; caloric conversion will likely be incomplete"
	}

********************************************************************************
* CONVERSION FACTOR SCRIPT * - development purposes only, do not run as external user	
********************************************************************************
/*
*HARVESTED CROPS*
	use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_g.dta", clear
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_m.dta"
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_p.dta"
* units_os
	ren ag_g13b_os unit_os //rainy unit_os harvested
	replace unit_os = ag_m11b_os if unit_os == "" & ag_m11b_os != "" //dry unit_os harvested
	replace unit_os = ag_p09b_os if unit_os == "" & ag_p09b_os != "" //tree/perm unit harvested

	keep unit_os
	gen dummy = 1
	collapse (sum) dummy, by(unit_os)
	tempfile unit_os_harv
	save `unit_os_harv'

	*SOLD CROPS*
	use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_i.dta", clear
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_o.dta"
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_q.dta"


//CONVERT BYTES TO STRINGS
	tostring ag_i21b_os, format(%19.0f) replace //was byte
	tostring ag_o21b_os, format(%19.0f) replace //was byte
	tostring ag_q21b_os, format(%19.0f) replace //was byte
	tostring ag_i30b_os, format(%19.0f) replace //was byte
	tostring ag_o30b_os, format(%19.0f) replace //was byte
	tostring ag_q30b_os, format(%19.0f) replace //was byte
* units_os0 - all buyers
	ren ag_i02b_os unit_os0 //rainy unit_os sold all buyers
	replace unit_os0 = ag_o02b_os if unit_os0 == "" & ag_o02b_os != "" //dry unit_os unit_os sold all buyers
	replace unit_os0= ag_q02b_os if unit_os0 == "" & ag_q02b_os != "" //tree/perm unit_os sold all buyers

* units_os1 - first largest buyer
	ren ag_i12b_os unit_os1 //rainy unit_os sold largest buyer
	replace unit_os1 = ag_o12b_os if unit_os1 == "" & ag_o12b_os != "" //dry unit_os sold largest buyer
	replace unit_os1= ag_q12b_os if unit_os1 == "" & ag_q12b_os != "" //tree/perm unit unit_os sold largest buyer

* units_os2 - second largest buyer
	ren ag_i21b_os unit_os2 //rainy unit_os sold second largest buyer
	replace unit_os2 = ag_o21b_os if unit_os2 == "" & ag_o21b_os != "" //dry unit_os sold second largest buyer
	replace unit_os2= ag_q21b_os if unit_os2 == "" & ag_q21b_os != "" //tree/perm unit_os sold second largest buyer

* units_os3 - third largest buyer
	ren ag_i30b_os unit_os3 //rainy unit_os sold third largest buyer
	replace unit_os3 = ag_o30b_os if unit_os3 == "" & ag_o30b_os != "" //dry unit_os sold third largest buyer
	replace unit_os3= ag_q30b_os if unit_os3 == "" & ag_q30b_os != "" //tree/perm unit_os sold third largest buyer

	keep unit_os*
	gen dummya = _n //creates a unique number for each observation - required for the reshape
	reshape long unit_os, i(dummya) j(buyer)
	keep unit_os
	gen dummy = 1
	collapse (sum) dummy, by(unit_os)
	tempfile unit_os_sold
	save `unit_os_sold'
	append using `unit_os_harv'
	collapse (sum) dummy, by(unit_os)
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_unit_os.dta", replace
	*/

********************************************************************************
* ALL PLOTS * 
********************************************************************************
	*********************************
	* 		   CROP VALUES          *
	*********************************

//Nonstandard unit values (kg values in plot variables section)
	use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_i.dta", clear
	gen season=0 //rainy season
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_o.dta"
	recode season (.=1) //dry season
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_q.dta"
	recode season(.=2) //tree or permanent crop; season 0= rainy, 1= dry, 2= perm
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	keep if ag_i01==1 | ag_o01==1 | ag_q01==1 //keeping only if sold crops harvested
	ren ea_id ea
	ren ag_i02a sold_qty //rainy: total sold
	replace sold_qty = ag_o02a if sold_qty ==. & ag_o02a!=. //dry
	replace sold_qty = ag_q02a if sold_qty ==. & ag_q02a!=. //tree/permanent
	ren ag_i02b unit
	replace unit = ag_o02b if unit ==. & ag_o02b!=.
	replace unit = ag_q02b if unit ==. & ag_q02b!=.
	ren ag_i03 sold_value
	replace sold_value=ag_o03 if sold_value==. & ag_o03!=.
	replace sold_value=ag_q03 if sold_value==. & ag_q03!=.
	gen condition=ag_i02c 
	replace condition=ag_o02c if condition==.
	ren ag_i0b crop_code_long
	replace crop_code_long =ag_o0b if crop_code_long ==. & ag_o0b!=.
	
	gen crop_code_perm=ag_q0b
	drop if crop_code_perm == 18 // dropped 3 values // Other (Specify) values for crop_code_perm should not be included in calculation of price medians
	//labelbook 
	/*checked to see that crop codes align*/
	recode crop_code_perm (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)
	la var crop_code_perm "Unique crop codes for trees/ permanent crops"

	replace crop_code_long = crop_code_perm if crop_code_long==. & crop_code_perm!=. // applying tree codes to crop codes
	
	label define relabel /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
label val crop_code_long relabel
	
	//keep hhid crop_code_long sold_qty unit sold_value

	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keepusing(region district ta ea rural weight) // 1,896 matched, 2,033 not matched
	ren unit unit_code
	tostring unit_code, g(unit)
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\MWI_IHS_cf.dta", nogen keep(1 3)
	drop unit 
	ren unit_code unit
	replace conversion=1 if conversion==. & unit==1 & inlist(condition, 1, 3)
	gen sold_qty_kg=conversion*sold_qty 
	
	* Calculate average sold value per crop unit (price_unit)
	gen price_unit = sold_value/sold_qty // 2,034 missing values; n = 1895
	gen price_kg = sold_value/sold_qty_kg
	lab var price_unit "Average sold value per crop unit"
	gen obs=price_unit!=.
	gen obs_kg=price_kg!=.
	preserve 
	//Report prices in terms of "long" crop code for sales, but collapse down to generic crop code for total revenue.
 	gen crop_code=crop_code_long //Generic level (without detail)
	recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	collapse (sum) kgs_sold=sold_qty_kg sales_value=sold_value, by(hhid crop_code) //fix names here
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropsales_value.dta", replace
	restore
	//merge m:1 hhid using "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_hhids.dta", nogen keep(1 3)	
	
	*create a value for the price of each crop at different levels
	foreach i in region district ta ea hhid  {
	preserve
	collapse (median) price_unit_`i'=price_unit (rawsum) obs_`i'_price=obs [aw=weight], by (`i' unit crop_code_long condition) 
	tempfile price_unit_`i'_median
	save `price_unit_`i'_median'
	restore
	preserve 
	collapse (median) price_kg_`i'=price_unit (rawsum) obs_`i'_kg=obs_kg [aw=weight], by (`i' crop_code_long ) 
	tempfile price_kg_`i'_median
	save `price_kg_`i'_median'
	restore 
	}
	preserve
	collapse (median) price_unit_country = price_unit (rawsum) obs_country_price=obs [aw=weight], by(crop_code_long unit condition)
	tempfile price_unit_country_median
	save `price_unit_country_median'
	restore
	collapse (median) price_kg_country = price_kg (rawsum) obs_country_kg=obs_kg [aw=weight], by(crop_code_long)
	tempfile price_kg_country_median
	save `price_kg_country_median'

	*********************************
	* 		 PLOT VARIABLES    		*
	*********************************
	// Integration of updated conversion factor file (cf.dta) to convert non-standard units (e.g. volume of crop)
	// to standard weight units (kg) based on physical characteristics of the crop and other survey information was successful:
	// legacy conversion factor file merge resulted in 28,941 matched observations and 6,578 unmatched observations (from using);
	// updated conversion factor file merge resulted in 31,704 matched observations and 3,814 unmatched observations (from using).
	// Outstanding unmatched observations may be caused by several possible contributing factors, primarily the following:
	// some observations are recorded as units == "Other (specify)" with unconvertible responses.
	
	use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_p.dta", clear //tree/perm
	ren ag_p0d crop_code_long
	ren ag_p0b plot_id
	gen ha_planted = ag_p02a 
	replace ha_planted = ag_p02a/2.47105 if ag_p02b==1
	replace ha_planted = ag_p02a/10000 if ag_p02b==3
	recode crop_code_long (1=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=48)
	tempfile treeperm
	save `treeperm'
	collapse (sum) tot_ha_treeperm=ha_planted, by(hhid plot_id)
	tempfile treearea
	save `treearea'
	
	use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_g.dta", clear //rainy 
	gen season=0 //create variable for season
	ren ag_g0d crop_code_long
	append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_m.dta" //dry
	replace crop_code_long = ag_m0d if crop_code_long == . & ag_m0d != .
	ren ag_g0b plot_id
	replace plot_id=ag_m0b if plot_id==""
	recode season(.=1)
	append using `treeperm'
	merge m:1 hhid plot_id using `treearea'
	recode season (.=2)
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season

	ren ag_p03 number_trees_planted // number of trees planted during last 12 months
	
	gen use_imprv_seed = 1 if crop_code_long == 2 | crop_code_long == 12 | crop_code_long == 18 | crop_code_long == 21 | crop_code_long == 23 | crop_code_long == 25 // MAIZE COMPOSITE/OPV | GROUNDNUT CG7 | RISE FAYA | RISE IET4094 (SENGA) | RISE KILOMBERO | RISE MTUPATUPA
recode use_imprv_seed .=0
gen use_hybrid_seed = 1 if crop_code_long == 3 | crop_code_long == 4 | crop_code_long == 15 | crop_code_long == 19 | crop_code_long == 20 // MAIZE HYBRID | MAIZE HYBRID RECYCLED | GROUNDNUT JL24 | RISE PUSSA | RISE TCG10 
recode use_hybrid_seed .=0

	label define relabel /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
label val crop_code_long relabel
	
	gen crop_code=crop_code_long //Generic level (without detail)
	recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	la var crop_code "Generic level crop code"
	label define relabel2 /*these exist already*/ 1 "MAIZE" 5 "TOBACCO" 11 "GROUNDNUT" 17 "RICE" 28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
	label val crop_code relabel2
	drop if crop_code==.
	
	*Create area variables
	gen crop_area_share=ag_g03
	label var crop_area_share "Proportion of plot planted with crop"
	replace crop_area_share=ag_m03 if crop_area_share==.
	
	//converting answers to proportions
	replace crop_area_share=0.125 if crop_area_share==1 // Less than 1/4
	replace crop_area_share=0.25 if crop_area_share==2 
	replace crop_area_share=0.5 if crop_area_share==3
	replace crop_area_share=0.75 if crop_area_share==4
	replace crop_area_share=.875 if crop_area_share==5 // More than 3/4 
	replace crop_area_share=1 if ag_g02==1 | ag_m02==1 | ag_g01==1 | ag_m01==1 //planted on entire plot for both rainy and dry season
	merge m:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta", keep(1 3) nogen
	replace ha_planted=crop_area_share*field_size if ha_planted==.

	ren ea_id ea
	//save "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_ha_planted.dta", replace

	drop crop_area_share
	
	
	gen lost_drought = inlist(ag_g11a, 1) | inlist(ag_g11b, 1) if ag_g10!=.
	replace lost_drought = inlist(ag_m10a,1) | inlist(ag_m10b,1) if ag_m09!=.
	replace lost_drought = inlist(ag_p08a,1) | inlist(ag_p08b,1) if ag_p07!=.
	
	gen lost_flood = inlist(ag_g11a, 2) | inlist(ag_g11b, 2) if ag_g10!=.
	replace lost_flood = inlist(ag_m10a,2) | inlist(ag_m10b,2) if ag_m09!=.
	replace lost_flood = inlist(ag_p08a,2) | inlist(ag_p08b,2) if ag_p07!=.
	
** TIME VARIABLES (month planted, harvest, and length of time grown)	
	*month planted
	gen month_planted = ag_g05a
	replace month_planted = ag_m05a if month_planted==.
	lab var month_planted "Month of planting"
	
	*year planted
	gen year_planted1 = ag_g05b
	gen year_planted2 = ag_m05b // no observations
	gen year_planted = year_planted1
	replace year_planted= year_planted2 if year_planted==. //no changes made as no observations for year_planted2
	lab var year_planted "Year of planting"
	
	*month harvest started
	gen harvest_month_begin = ag_g12a
	replace harvest_month_begin=ag_m12a if harvest_month_begin==. & ag_m12a!=.
	lab var harvest_month_begin "Month of start of harvesting"
	
	*month harvest ended
	gen harvest_month_end=ag_g12b
	replace harvest_month_end=ag_m12b if harvest_month_end==. & ag_m12b!=.
	lab var harvest_month_end "Month of end of harvesting"
	
	*months crop grown
	gen months_grown = harvest_month_begin - month_planted if harvest_month_begin > month_planted  // since no year info, assuming if month harvested was greater than month planted, they were in same year 
	replace months_grown = 12 - month_planted + harvest_month_begin if harvest_month_begin < month_planted // 5,749 real changes made; months in the first calendar year when crop planted
	replace months_grown = 12 - month_planted if months_grown<1 // reconcile crops for which month planted is later than month harvested in the same year
	replace months_grown=. if months_grown <1 | month_planted==. | harvest_month_begin==. // 0 changes made
	replace months_grown=. if year_planted!=2007 & year_planted!=2008 & year_planted!=2009 & year_planted!=2010 //choosing not to months_grown from observations with obscure planting years instead of dropping observations with obscure planting years
	lab var months_grown "Total months crops were grown before harvest"

	//Plot workdays
	preserve
	gen days_grown = months_grown*30 
	collapse (max) days_grown, by(hhid plot_id)
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_season_length.dta", replace
	restore
	
	* YEAR HARVESTED 
	//all observations of months_grown less than or equal to 11 months.
	gen year_harvested=year_planted if harvest_month_begin>month_planted
	replace year_harvested=year_planted+1 if harvest_month_begin<month_planted
	replace year_harvested=. if year_planted!=2007 & year_planted!=2008 & year_planted!=2009 & year_planted!=2010
	
	* DATE PLANTED	
	gen date_planted = mdy(month_planted, 1, ag_g05b) if ag_g05b!=. //1,847 missing values
	replace date_planted = mdy(month_planted-12, 1, ag_g05b) if month_planted>12 & ag_g05b!=. //0 real changes
	replace date_planted = mdy(month_planted-12, 1, ag_m05b) if month_planted>12 & ag_m05b!=. //0 real changes
	replace date_planted = mdy(month_planted, 1, ag_m05b) if date_planted==. & ag_m05b!=. //0 real changes
	
	* DATE HARVESTED 	
	gen date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if ag_g05b==2010
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if date_harvested==. & ag_m05b==2010
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if month_planted<=12 & harvest_month_begin>month_planted & date_harvest==. & ag_g05b!=. //assuming if planted in 2010 and month harvested is later than planted, it was harvested in 2010
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if month_planted<=12 & harvest_month_begin>month_planted & date_harvest==. & ag_m05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_g05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_m05b!=.
	
	format date_planted %td
	format date_harvested %td
	gen days_grown=date_harvest-date_planted
	
	//bys plot_id hhid : egen min_date_harvested = min(date_harvested)
	//bys plot_id hhid : egen max_date_planted = max(date_planted)
	//gen overlap_date = min_date_harvested - max_date_planted
	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	/*
	preserve
		gen obs=1
		//replace obs=0 if ag_g13a==0 | ag_m11a==0 | ag_p09a==0  //333 real changes made; would have been 0 if no crops were harvested
		collapse(sum)crops_plot=obs, by(hhid plot_id season)
		//br if crops_plot>1
		tempfile ncrops
		save `ncrops'
	restore
	*/
	
	gen obs=1
	preserve 
	keep if season==2 
	collapse (max) obs (sum) number_trees_planted, by(hhid plot_id crop_code)
	collapse (sum) obs (sum) number_trees_planted, by(hhid plot_id)
	ren obs ntreecrops
	ren number_trees_planted tot_trees
	tempfile ntreecrops
	save `ntreecrops'
	restore
	
	preserve
	drop if season==2
	collapse (max) crops_plot=obs (sum) totcrops=obs, by(hhid plot_id season crop_code)
	collapse (sum) crops_plot totcrops, by(hhid plot_id season)
	tempfile ncrops
	save `ncrops'
	restore
	
	drop obs
	merge m:1 hhid plot_id using `ntreecrops', nogen
	recode ntreecrops (.=0)
	merge m:1 hhid plot_id season using `ncrops', nogen
	recode crops_plot totcrops (.=0)
	replace crops_plot=crops_plot+ntreecrops
	replace totcrops=totcrops+ntreecrops
	
	/*
	gen contradict_mono = 1 if (ag_g01==1 | ag_m01==1) & crops_plot >1
	gen contradict_inter = 1 if (ag_g01==2 | ag_m01==2) & crops_plot ==1 
	replace contradict_inter = . if ag_g01==1 | ag_m01==1 
*/
	
	*Generating monocropped plot variables
	gen purestand = crops_plot==1 //i.e. smoothing over all varieties of a given crop
	bys hhid plot_id season : egen total_ha_planted = sum(ha_planted)
	bys hhid plot_id : egen max_ha_planted = max(total_ha_planted)
	replace field_size=max_ha_planted if field_size==. //Some missing values mainly with cassava that should get checked out.
	gen percent_field=ha_planted/field_size //5,471 missing values generated
	replace percent_field = number_trees_planted/tot_trees if percent_field==.
	gen percent_tree = tot_ha_treeperm/field_size
	recode percent_tree (.=0)
	*Generating total percent of purestand and monocropped on a field
	bys hhid plot_id season : egen total_percent = total(percent_field)
	replace total_percent = total_percent+percent_tree if season!=2 
	replace total_percent = 1 if total_percent==0 //Mainly tree crops that aren't in a plantation
	replace percent_field = percent_field/total_percent if total_percent>=1 & totcrops>1
	replace percent_field = 1 if percent_field>1 & totcrops==1
	replace ha_planted = ha_planted*percent_field 

	//replace ha_planted = percent_field*field_size
	gen ha_harvest = ha_planted if (ag_p09a!=0 & ag_p09a!=.) | (ag_m11a!=0 & ag_m11a!=.) | (ag_g13a!=0 & ag_g13a!=.) //no question about why harvested area was lower if it was lower, so we can't estimate the fraction of the area harvested.
	
	
	rename ag_g13b unit
	replace unit = ag_g09b if unit == . // 111 real changes
	replace unit = ag_m11b if unit == . // 1645 real changes
	replace unit = ag_p09b if unit == . // 5653 real changes
	drop if unit == 50 // 1 obs deleted

	* QUANTITY HARVESTED
	ren ag_g13a quantity_harvested
	replace quantity_harvested = ag_g09a if quantity_harvested==. & ag_g09a !=. // 14 changes rainy season (post-planting / pre-harvest panel visit)
	replace quantity_harvested = ag_m11a if quantity_harvested==. & ag_m11a !=. //0 changes dry season
	replace quantity_harvested = ag_p09a if quantity_harvested==. & ag_p09a !=. //1,476 changes
	
	* crop code other [specified]
	ren ag_g0d_os crop_code_os
	replace crop_code_os = ag_m0d_os if crop_code_os == "" & ag_m0d_os != "" //57 real changes made
	replace crop_code_os = ag_p0d_os if crop_code_os == "" & ag_p0d_os != "" //39 real changes made
	
	* units_os 
	ren ag_g13b_os unit_os
	replace unit_os = ag_g09b_os if unit_os == "" & ag_g09b_os != "" //14 real changes made
	replace unit_os = ag_m11b_os if unit_os == "" & ag_m11b_os != "" //6 real changes made
	replace unit_os = ag_p09b_os if unit_os == "" & ag_p09b_os != "" //205 real changes made

	* recode crop_code values that were erroneously listed in crop_code_os
	replace crop_code_long = 5 if strmatch(crop_code_os,"TOBACCO")
	replace crop_code_long = 17 if strmatch(crop_code_os,"RICE")
	replace crop_code_long = 28 if strmatch(crop_code_os,"SWEET POTATO")
	replace crop_code_long = 63 if strmatch(crop_code_os,"MASAU")
	replace crop_code_long = 64 if strmatch(crop_code_os,"PINEAPPLE")
	replace crop_code_long = 41 if strmatch(crop_code_os,"MPIRU")
	replace crop_code_long = 31 if strmatch(crop_code_os,"FINGERMILLET")
	replace crop_code_long = 410 if strmatch(crop_code_os,"PUMPKIN")
	replace crop_code_long = 60 if strmatch(crop_code_os,"PEACHES")
	replace crop_code_long = 58 if strmatch(crop_code_os,"LEMONS")
	replace crop_code_long = 11 if strmatch(crop_code_os,"GROUNDNUTS")
	replace crop_code_long = 34 if strmatch(crop_code_os,"AFRICAN BEANS") | strmatch(crop_code_os,"BUFFALO BEANS") | strmatch(crop_code_os,"KIDNEY BEANS") | strmatch(crop_code_os,"KALONGONDA") | strmatch(crop_code_os,"KALONGONDA")
	replace crop_code_long = 308 if strmatch(crop_code_os,"COWPEAS") | strmatch(crop_code_os,"NSEULA")
	replace crop_code_long = 405 if strmatch(crop_code_os,"CHINESE CABBAGE")
	replace crop_code_long = 409 if strmatch(crop_code_os,"CUCUMBER")
	replace crop_code_long = 55 if strmatch(crop_code_os,"KABUTHU")
	replace crop_code_long = 52 if strmatch(crop_code_os,"KALISERE")
	replace crop_code_long = 46 if strmatch(crop_code_os,"KAWALA") | strmatch(crop_code_os,"NKHUNGUDZU")
	
	
	//replace units with o/s response where possible
	//Malawi instruments do not have unit codes for units like "packet" or "stem" or "bundle". Converting unit codes to align with the Malawi conversion factor file (merged in later). Also, borrowing Nigeria's unit codes for units (e.g. packets) that do not have unit codes in the Malawi instrument or conversion factor file.
	replace unit=1 if strmatch(unit_os, "MG")
	replace quantity_harvested=quantity_harvested/1000000 if strmatch(unit_os, "MG")
	replace unit=1 if strmatch(unit_os, "20 KG BAG")
	replace quantity_harvested=quantity_harvested*20 if strmatch(unit_os, "20 KG BAG")
	replace unit=1 if strmatch(unit_os, "25 KG BAG")
	replace quantity_harvested=quantity_harvested*25 if strmatch(unit_os, "25 KG BAG")
	replace unit=1 if strmatch(unit_os, "50 KG BAG") | strmatch(unit_os, "1 BAG TUBERS OF 50 KG BAG")
	replace quantity_harvested=quantity_harvested*50 if strmatch(unit_os, "50 KG BAG") | strmatch(unit_os, "1 BAG TUBERS OF 50 KG BAG")
	replace unit=1 if strmatch(unit_os, "90 KG BAG")
	replace quantity_harvested=quantity_harvested*90 if strmatch(unit_os, "90 KG BAG")
	replace unit=1 if strmatch(unit_os, "100 KG BAG")
	replace quantity_harvested=quantity_harvested*100 if strmatch(unit_os, "100 KG BAG")
	replace unit=4 if strmatch(unit_os, "PAIL") | strmatch(unit_os, "SMALL PAIL") | strmatch(unit_os, "1 PAIL UNSHELLED")
	replace unit=5 if strmatch(unit_os, "LARGE PAIL") | strmatch(unit_os, "LARGE PAILS") | strmatch(unit_os, "PAIL LARGE") | strmatch(unit_os, "1X LARGE PAIL") | strmatch(unit_os, "2X LARGE PAIL")
	replace quantity_harvested=quantity_harvested*2 if strmatch(unit_os, "2X LARGE PAIL")
	replace unit=6 if strmatch(unit_os, "PLATE")  | strmatch(unit_os, "NO 10 PLATE") | strmatch(unit_os, "NO. 10 PLATE") | strmatch(unit_os, "NUMBER 10 PLATE") | strmatch(unit_os, "NO. 10 PLATE FLAT") | strmatch(unit_os, "2 NO 10 PLATES")
	replace quantity_harvested=quantity_harvested*2 if strmatch(unit_os, "2 NO 10 PLATES")
	replace unit=7 if strmatch(unit_os, "NO. 12 PLATE")  | strmatch(unit_os, "NUMBER 12 PLATE")  
	replace unit=9 if strmatch(unit_os, "PIECE") | strmatch(unit_os, "PIECES") | strmatch(unit_os, "PIECE OF MAIZE COB") | strmatch(unit_os, "STEMS") | strmatch(unit_os, "STEM CUTTINGS") | strmatch(unit_os, "CUTTINGS") | strmatch(unit_os, "BUNDLES") | strmatch(unit_os, "MTOLO UMODZI WA BATATA") //"motolo umodzi" translates to bundles and a standard bundle is 100 stems
	replace quantity_harvested=quantity_harvested*100 if strmatch(unit_os, "BUNDLES") | strmatch(unit_os, "MTOLO UMODZI WA BATATA")
	replace unit=11 if strmatch(unit_os, "DENGU") 
	replace unit=120 if strmatch(unit_os, "PACKET") | strmatch(unit_os, "1 PACKET") | strmatch(unit_os, "2 PACKETS")
	replace quantity_harvested=quantity_harvested*2 if strmatch(unit_os, "2 PACKETS")
	
	* recode unit values that were erroneously listed in unit_os
	replace unit = ag_g09b if unit == 13 & unit_os == "0KG" // ad hoc correction, suspected human-error between panel visit 1 & visit 2
	replace quantity_harvested = ag_g09a if unit == 13 & unit_os == "0KG" // same as above
	replace unit = 1 if unit == 13 & strmatch(unit_os,"TON")
	replace quantity_harvested = quantity_harvested * 1000 if unit == 13 & strmatch(unit_os,"TON")
	replace unit = 1 if unit == 13 & strmatch(unit_os,"1 TON")
	replace quantity_harvested = quantity_harvested * 1000 if unit == 13 & strmatch(unit_os,"1 TON")
	replace unit = 1 if unit == 13 & strmatch(unit_os,"3 TON TRUCK")
	replace quantity_harvested = quantity_harvested * 3000 if unit == 13 & strmatch(unit_os,"3 TON TRUCK")
	replace unit = 11 if unit == 13 & (strmatch(unit_os, "3 BASKETS") | strmatch(unit_os, "DENGU"))
	replace quantity_harvested = quantity_harvested * 3 if unit == 13 & strmatch(unit_os, "3 BASKETS")
	replace unit = 1 if unit == 13 & (strmatch(unit_os, "70 KGS") | strmatch(unit_os, "70 KG BAG"))
	replace quantity_harvested = quantity_harvested * 70 if unit == 13 & (strmatch(unit_os, "70 KGS") | strmatch(unit_os, "70 KG BAG"))
	replace unit = 9 if unit == 13 & strmatch(unit_os,"PIECES")
	replace unit = 12 if unit == 13 & strmatch(unit_os,"OXCART")
	replace unit = 1 if unit == 13 & strmatch(unit_os,"276 KILOGRAMS")
	replace quantity_harvested = quantity_harvested * 276 if unit == 13 & strmatch(unit_os,"276 KILOGRAMS")
	replace unit = 1 if unit == 13 & strmatch(unit_os, "WHEELBARROW")
	replace quantity_harvested = quantity_harvested * 80 if unit == 13 & strmatch(unit_os,"WHEELBARROW") // see citation under Crop Expenses / Fertilizer, Pesticides, and Herbicides
	
	// Unable to locate translations for several Malawian words used to describe "other [specify]" units for quantity_harvested:
	// Mkoko [172 obs], Lichelo [15 obs], chitaala [3 obs], nhokwe [2 obs], traditional nhokwe [1 obs], mbeya [1 obs]
	// Additional "other [specify]" units were not specific enough to support conversion to kg: case [18 obs], granary [7 obs], tin [2 obs],
	// unshielded [2 obs], in farm [2], toer [1]
	
	//merging in HH module A to bring in region info 
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen keep(1 3)
	
	*renaming condition vars in master to match using file 
	gen condition=ag_g09c
	lab define condition 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A", modify
	lab val condition condition
	replace condition = ag_g13c if condition==. & ag_g13c !=. //23,525 reach changes
	replace condition = ag_m11c if condition==. & ag_m11c !=. //0 real changes made, no observations for ag_m11c
	replace condition=3 if condition==. & crop_code!=. & unit!=. // conversion factor file is designed to create more merges provided recoding blank conditions to n/a
	recode condition (3=2) if crop_code == 17
	recode condition (3=2) if crop_code == 1
	replace condition=3 if crop_code == 5
	gen qmult = regexs(0) if(regexm(unit_os, "[0-9]+"))
	gen qty_vol = regexm(unit_os, "[Ll][Ii][Tt][RrEe][RrEe]")
	replace unit = 26 if qty_vol | regexm(unit_os, "[Cc][Hh][IiOo][Gg]")
	destring qmult, replace
	replace quantity_harvested = qmult/5 * quantity_harvested if qmult!=. & qmult!=0 & qty_vol 
	gen qty_wt = regexm(unit_os, "[Kk][Gg]")
	replace unit = 2 if qty_wt
	replace quantity_harvested = qmult/50 * quantity_harvested if qmult!=. & qmult!=0 & qty_wt
	capture tostring unit*, replace force
	
***** CONVERSION FACTORS ***** 
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\MWI_IHS_cf.dta", keep(1 3) gen(cf_merge) //33,102 matched, 2,384 not matched CG 11.15.24 //30,623 matched, 4,863 not matched CG 5.14.25
	replace conversion=1 if conversion==. & unit=="1" & inlist(condition, 1, 3) //1,761 changes made
	//br unit unit_os crop_code_os crop_code_long quantity_harvested crop_code cf_merge source
	destring unit*, replace force
	//Multiply by shelled/unshelled cf for unshelled units
	gen kg_harvest= quantity_harvested*conversion
	replace ha_harvest =. if kg_harvest==.
	replace ha_harvest =0 if kg_harvest==0
	
foreach i in ea ta district region hhid {
	merge m:1 `i' crop_code_long unit condition using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code_long using `price_kg_`i'_median', nogen keep(1 3)
	}
merge m:1 unit condition crop_code_long using `price_unit_country_median', nogen keep(1 3)
merge m:1 crop_code_long using `price_kg_country_median', nogen keep(1 3)

recode obs* (.=0)
gen price_unit=.
gen price_kg=.

foreach i in country region district ta ea { //decending order from largest to smallest geographical figure
replace price_unit = price_unit_`i' if obs_`i'_price > 9
replace price_kg = price_kg_`i' if obs_`i'_kg > 9
}

ren price_unit_hhid price_unit_hh
ren price_kg_hhid price_kg_hh 
replace price_unit_hh = price_unit if price_unit_hh==.
replace price_kg_hh = price_kg if price_kg_hh==.
gen value_harvest = price_unit*quantity_harvested 
replace value_harvest = price_kg*kg_harvest if value_harvest==. 
gen value_harvest_hh=price_unit_hh*quantity_harvested 
replace value_harvest_hh=price_kg_hh * kg_harvest if value_harvest_hh==. 

	//gen value_harvest = price_unit_country * kg_harvest 
	gen val_unit = value_harvest/quantity_harvested
	gen val_kg = value_harvest/kg_harvest
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep(1 3)
	gen plotweight = ha_planted*conversion
	gen obs=quantity_harvested>0 & quantity_harvested!=.
	gen harv_wt=quantity_harvested*weight

preserve
	collapse (mean) val_unit val_kg, by (hhid crop_code_long unit)
	drop if crop_code_long ==. 
	ren val_kg hh_price_mean
	lab var hh_price_mean "Average price reported for this for 1 kg in the household"
	duplicates drop hhid, force 	
	tostring unit, replace force
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_crop_prices_for_wages.dta", replace
restore

preserve
collapse (median) val_unit_country = val_unit (count) obs_unit_country=val_unit [aw=harv_wt], by(crop_code unit)
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_crop_prices_median_country.dta", replace //This gets used for self-employment income. 
restore

/*
preserve
collapse (max) lost_drought lost_flood, by(hhid)
gen lost_crop = lost_flood | lost_drought
merge 1:1 hhid using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_weights.dta", nogen
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_preharv_losses.dta", replace
restore */

	*********************************
	*   ADDING CALORIC CONVERSION	*
	*********************************
	capture {
		confirm file `"${MWI_IHS_W1_created_data}/MWI_IHS_W1_caloric_cf_crop_codes.dta"'
	} 
	if _rc!=0 {
		display "Note: file ${MWI_IHS_W1_created_data}/MWI_IHS_W1_caloric_cf_crop_codes.dta does not exist - skipping calorie calculations"		
	}
	if _rc==0{
		merge m:1 crop_code using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_caloric_cf_crop_codes.dta", nogen keep(1 3)
	
		// logic for units: calories / 100g * kg * 1000g/kg * edibe perc * 100 / perc * 1/1000 = cal
		gen calories = cal_100g * kg_harvest * edible_p / .1 
		count if missing(calories) //3,575 then 3,567 missing then 2,939 missing (pea fix) then 2,757 (cassava populated with sweet potato)
		//unit is blank on 352 observations - nothing we can do there; quantity_harvested only blank on 16 observations; 2,433 due to conversion being blank - likely because IHS Agri Conversion file has many . in conversion
	}
	
//AgQuery
/// ALT: Relocated this up from crop disposition section because we need crop_code_long for losses but crop_code for everything else. 
tempfile longcrops 
save `longcrops'

collapse (sum) value_harvest, by(hhid crop_code_long season)
tempfile hhlongcrops
save `hhlongcrops'



*Crops lost post-harvest
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_i.dta", clear
ren ag_i0b crop_code_long
gen season=0
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_o.dta"
replace season=1 if season==.
replace crop_code_long = 308 if strmatch(ag_i0b_os,"COWPEAS") | strmatch(ag_i0b_os,"NSEULA") //a few other OS to convert
replace crop_code_long = ag_o0b if crop_code_long==.
rename ag_i36e percent_lost
replace percent_lost = ag_o36d if percent_lost==. & ag_o36d!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=.
drop if percent_lost==. //Very few observations in this wave, several in local units that will need to get converted.
merge 1:1 hhid crop_code_long season using `hhlongcrops', nogen keep(1 3)
gen value_lost = value_harvest * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_crop_losses.dta", replace

use `longcrops', clear	
	gen no_harvest = ha_harvest == .
	//gen percent_field = ha_planted/field_size 
	recode percent_field field_size (0=.)
	gen rainy_seas_crops = season==0 | season==2 //for perm crops 
	gen dry_seas_crops = season==1 | season==2
	gen tree_crops = season==2
	bys hhid plot_id season : egen tot_rainy=sum(rainy_seas_crops)
	bys hhid plot_id season : egen tot_dry = sum(dry_seas_crops)
	bys hhid plot_id season : egen tot_tree = sum(tree_crops)
	gen n_crops = tot_rainy if season==0
	replace n_crops = tot_dry if season==1
	bys hhid plot_id : egen max_crops = max(n_crops)
	replace n_crops = max_crops if n_crops==.
	bys hhid plot_id season : egen tot_pct_planted = sum(percent_field)
	gen miss_pct = percent_field==. 
	bys hhid plot_id season : egen tot_miss = sum(miss_pct)

	gen underplant_pct = 1-tot_pct_planted 
	replace percent_field = underplant_pct/tot_miss if miss_pct & underplant_pct > 0 
	replace percent_field = percent_field/tot_pct_planted if tot_pct_planted > 1
    replace percent_field = 1/tot_miss if tot_miss==n_crops & percent_field==.
	
//AgQuery
	collapse (sum) kg_harvest ha_planted ha_harvest value_harvest* number_trees_planted percent_field (max) months_grown no_harvest use*, by(region district ea ta hhid plot_id crop_code purestand field_size season) //area_meas_hectares should get replaced with field_size for consistency.
	recode ha_planted (0=.)
	replace ha_harvest=. if (ha_harvest==0 & no_harvest==1) | (ha_harvest==0 & kg_harvest>0 & kg_harvest!=.)
	replace kg_harvest = . if kg_harvest==0 & no_harvest==1
	replace value_harvest=. if value_harvest==0 & (no_harvest==1 | kg_harvest!=0)
	drop no_harvest

	bys hhid plot_id : egen percent_area = sum(percent_field)
	bys hhid plot_id : gen percent_inputs = percent_field/percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length 
	
	drop if crop_code == .
	gen ha_harv_yld = ha_harvest if ha_planted >=0.05
	gen ha_plan_yld = ha_planted if ha_planted >=0.05
	
	merge m:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm*) //35,112 matched, 122 unmatched CG 5.14.25
	order region district ea ta hhid
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_all_plots.dta", replace 
	preserve
	collapse (sum) ha_planted, by(hhid plot_id season) //Use planted area for hh-level expenses 	
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_planted_area.dta", replace
	restore
	

	collapse (sum) value_harvest, by(hhid crop_code)
	merge 1:1 hhid crop_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropsales_value.dta", nogen
	//recode value_harvest value_crop_sales (.=0)
	recode value_harvest sales_value (.=0)
	//replace value_harvest = value if value>value_harvest & value !=. //In a few cases, sales value reported exceeds the estimated value of crop harvest
	ren sales_value value_crop_sales 
	ren value_harvest value_crop_production
	lab var value_crop_production "Gross value of crop production, summed over both seasons"
	lab var value_crop_sales "Value of crops sold so far, summed over both seasons"
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production.dta", replace

	collapse (sum) value_crop_production value_crop_sales, by (hhid)
	lab var value_crop_production "Gross value of crop production for this household"
	lab var value_crop_sales "Value of crops sold so far"
	gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
	lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_production.dta", replace

********************************************************************************
* TLU (Tropical Livestock Units) *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
gen tlu_coefficient=0.5 if (ag_r0a==301|ag_r0a==302|ag_r0a==303|ag_r0a==304|ag_r0a==306)
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308)
replace tlu_coefficient=0.2 if (ag_r0a==309)
replace tlu_coefficient=0.01 if (ag_r0a==310|ag_r0a==311|ag_r0a==312|ag_r0a==313|ag_r0a==314|ag_r0a==315|ag_r0a==316)
replace tlu_coefficient=0.3 if (ag_r0a==305) 
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Owned
gen cattle=inrange(ag_r0a,301,304)
gen smallrum=inlist(ag_r0a,307,308,309)
gen largerum=inrange(ag_r0a,301,304)
gen poultry=inrange(ag_r0a,310,316)
gen other_ls=inlist(ag_r0a,305,306)
gen cows=inrange(ag_r0a,303,303)
gen chickens=inrange(ag_r0a,310,313) //included chicken layer (310), local hen (311), chicken broiler (312), local cock (313)
ren ag_r07 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_poultry_1yearago=nb_ls_1yearago if poultry==1 
gen nb_other_ls_1yearago=nb_ls_1yearago if other_ls==1 
gen nb_cows_1yearago=nb_ls_1yearago if cows==1 
gen nb_chickens_1yearago=nb_ls_1yearago if chickens==1 
ren ag_r02 nb_ls_today
gen nb_cattle_today=nb_ls_today if cattle==1 
gen nb_smallrum_today=nb_ls_today if smallrum==1 
gen nb_largerum_today=nb_ls_today if largerum==1
gen nb_poultry_today=nb_ls_today if poultry==1 
gen nb_other_ls_today=nb_ls_today if other_ls==1  
gen nb_cows_today=nb_ls_today if cows==1 
gen nb_chickens_today=nb_ls_today if chickens==1 
gen tlu_1yearago = nb_ls_1yearago * tlu_coefficient
gen tlu_today = nb_ls_today * tlu_coefficient
rename ag_r17 income_live_sales 
rename ag_r16 number_sold 

*livestock holdings will be valued using observed sales prices.
ren ag_r0a livestock_code
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
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
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_TLU_Coefficients.dta", replace


********************************************************************************
* GROSS CROP REVENUE *
********************************************************************************
* Relocated to all plots





********************************************************************************
* CROP EXPENSES *
********************************************************************************
	*********************************
	* 			LABOR				*
	*********************************
	*Crop payments rainy
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear 
	ren ag_d00 plot_id
	ren ag_d46g crop_code_long
	ren ag_d46h qty
	ren ag_d46i unit
	ren ag_d46j condition
	ren ea_id ea
	keep hhid plot_id ea crop_code qty unit condition
	gen season=0
	drop if plot_id==""&qty==.
	tempfile rainy_crop_payments
	save `rainy_crop_payments'
	
	*Crop payments dry
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear 
	ren ag_k0a plot_id
	ren ag_k46g crop_code_long
	ren ag_k46h qty
	ren ag_k46i unit
	ren ag_k46j condition
	ren ea_id ea
	keep hhid plot_id ea crop_code qty unit condition
	gen season=1
	drop if plot_id==""&qty==.
	tempfile dry_crop_payments
	save `dry_crop_payments'

	//Not including in-kind payments as part of wages b/c they are not disaggregated by worker gender (but including them as an explicit expense at the end of the labor section)
	use `rainy_crop_payments', clear
	append using `dry_crop_payments'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	tostring unit*, replace force
	merge m:1 hhid crop_code_long using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_crop_prices_for_wages.dta", nogen keep (1 3) //423 matched
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep hhid val plot_id season
	gen exp = "exp"
	merge m:1 plot_id hhid season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", nogen keep (1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments' //Inkind payments currently not used because only a small number of households have them and valuation is 

	*Hired rainy
	//This code creates three temporary files for exchange labor in the rainy season: rainy_hired_all, rainy_hired_nonharvest, and rainy_hired_harvest. Will append nonharvest and harvest to compare to all.
	local qnums "46 47 48" //qnums refer to question numbers on instrument
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
	ren ag_d00 plot_id
	egen wagehiredmale=rowmean(ag_d46b ag_d47b ag_d48b)
	egen wagehiredfemale=rowmean(ag_d46d ag_d47d ag_d48d)
	egen wagehiredchild = rowmean(ag_d46f ag_d47f ag_d48f)
	keep hhid plot_id wagehired*
	gen season=0
	tempfile rainy_hired 
	save `rainy_hired'

	*Hired dry
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear 
	ren ag_k0a plot_id
	ren ag_k46b wagehiredmale
	ren ag_k46d wagehiredfemale
	ren ag_k46f wagehiredchild
	keep hhid plot_id wagehired*
	gen season=1
	tempfile dry_hired
	save `dry_hired' 

	use `rainy_hired'
	append using `dry_hired'
	drop if plot_id==""
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	duplicates drop //four repeated entries.
	reshape long wagehired, i(hhid plot_id season) j(gender) string
	drop if wagehired==.
	ren wagehired wagehired_plot
	tempfile plot_wages 
	save `plot_wages'
	
	preserve
	drop if gender=="child" | season==1 //Only considering adult wages during the main season here
	gen wage_paid_aglabor_male = wagehired if gender=="male"
	gen wage_paid_aglabor_female=wagehired if gender=="female"
	collapse (mean) wage_paid_aglabor_male wage_paid_aglabor_female wage_paid_aglabor=wagehired, by(hhid)
	gen hired_all=. 
	la var hired_all "Number of person-days for hired laborers (cannot construct)"
	gen hired_female=.
	la var hired_female "Number of person-days for female laborers (cannot construct)"
	gen hired_male = .
	la var hired_male "Number of person-days for male laborers (cannot construct)"
	lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
	lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers(local currency)"
	lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_ag_wage.dta", replace
	restore
	
	collapse (mean) wagehired=wagehired_plot, by(hhid season gender)
	merge m:1 hhid using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_weights.dta", nogen keep(1 3)
	gen obs=1
	foreach i in ea ta region district country {
	preserve
		collapse (median) wagehired_`i' = wagehired (rawsum) obs_`i'=obs [aw=weight], by(gender season `i')
		tempfile wages_`i'
		save `wages_`i''
	restore
	}
	/*The Malawi W1 instrument did not ask survey respondents to report number of laborers per day by laborer type. As such, we cannot say with certainty whether survey respondents reported wages paid as [per SINGLE hired laborer by laborer type (male, female, child) per day] or [per ALL hired laborers by laborer type (male, female, child) per day]. Looking at the collapses and scatterplots, it would seem that survey respondents had mixed interpretations of the question, making the value of hired labor more difficult to interpret. As such, we cannot impute the value of hired labor for observations where this is missing, hence the geographic medians section is commented out.*/

	*Exchange rainy
	/* No person-days, so it's impossible to value this.
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
	/*This code creates three temporary files for exchange labor in the rainy season: rainy_exchange_all, rainy_exchange_nonharvest, and rainy_exchange_harvest. Will append nonharvest and harvest to compare to all.*/
	local qnums "50 52 54" //question numbers
	foreach q in `qnums' {
		use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
		ren ag_d00 plot_id
		ren ea_id ea
		merge m:1 hhid ea using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen
		drop if plot_id==""&(ag_d54a==0|ag_d54a==.)
		ren ag_d`q'a daysnonhiredmale
		ren ag_d`q'b daysnonhiredfemale
		ren ag_d`q'c daysnonhiredchild
		keep region  district ta ea rural hhid plot_id daysnonhired*
		gen season=0 //rainy
		local suffix ""
		if `q' == 50 {
			local suffix "_all"
		}
		else if `q' == 52 {
			local suffix "_nonharvest"
		}
		else if `q' == 54 {
			local suffix "_harvest"
		}
		duplicates drop region  district ta ea rural hhid plot_id season, force //1 duplicate deleted
		reshape long daysnonhired, i(region  district ta ea rural hhid plot_id season) j(gender) string
		tempfile rainy_exchange`suffix'
		save `rainy_exchange`suffix'', replace
	}
	
	*Exchange dry
    use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear
	ren ag_k0a plot_id
	ren ea_id ea
	merge m:1 hhid ea using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen
	ren ag_k47a daysnonhiredmale
	ren ag_k47b daysnonhiredfemale
	ren ag_k47c daysnonhiredchild
	keep region  district ta ea rural hhid plot_id daysnonhired*
	drop if plot_id==""&daysnonhiredmale==.&daysnonhiredfemale==.&daysnonhiredchild==.
	gen season=1 //dry
	duplicates drop  region  district ta ea rural hhid plot_id season, force //3 duplicates deleted
	reshape long daysnonhired, i(region  district ta ea rural hhid plot_id season) j(gender) string
	tempfile dry_exchange_all
    save `dry_exchange_all', replace
	append using `rainy_exchange_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	reshape long days, i(region  district ta ea rural hhid plot_id season gender) j(labor_type) string
	tempfile all_exchange
	save `all_exchange', replace

	//creates tempfile `members' to merge with household labor later
	use "${MWI_IHS_W1_appended_data}\Household\hh_mod_b.dta", clear
	ren hh_b01 indiv
	isid hhid indiv
	gen male= (hh_b03==1)
	gen age=hh_b05a
	lab var age "Individual age"
	keep hhid indiv age male
	tempfile members
	save `members', replace
*/

*Rainy season household labor
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
ren ag_d00 plot_id
replace plot_id="10" if hhid=="203053010068-101-000-000-000" & plot_id=="R1" & ag_d20a==35 //Presumed typo.
local suffixes a e i m
local counter 1
foreach s of local suffixes {
    rename ag_d42`s' indivplanting`counter'
	rename ag_d43`s' indivnonharvest`counter'
	rename ag_d44`s' indivharvest`counter'
    local counter = `counter' + 1
}
local suffixes b f j n
local counter 1
foreach s of local suffixes {
    rename ag_d42`s' weeksplanting`counter'
	rename ag_d43`s' weeksnonharvest`counter'
	rename ag_d44`s' weeksharvest`counter'
    local counter = `counter' + 1
}
local suffixes d g k o
local counter 1
foreach s of local suffixes {
    rename ag_d42`s' daysplanting`counter'
	rename ag_d43`s' daysnonharvest`counter'
	rename ag_d44`s' dayssharvest`counter'
    local counter = `counter' + 1
}

keep hhid plot_id indiv* weeks* days*
unab vars : *4
local varlist : subinstr local vars "4" "", all
reshape long `varlist', i(hhid plot_id) j(entry_no)
reshape long indiv days weeks, i(hhid plot_id entry_no) j(labor_type) string //component of season, not used
drop if indiv==. | days==. | weeks==.
replace days=days*weeks 
collapse (sum) days, by(hhid plot_id indiv)
gen season=0
tempfile labor_rainy
save `labor_rainy'

	*Labor dry
	use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_k.dta", clear
ren ag_k0a plot_id
local suffixes a e i m
local counter 1
foreach s of local suffixes {
    rename ag_k43`s' indivplanting`counter'
	rename ag_k44`s' indivnonharvest`counter'
	rename ag_k45`s' indivharvest`counter'
    local counter = `counter' + 1
}
local suffixes b f j n
local counter 1
foreach s of local suffixes {
    rename ag_k43`s' weeksplanting`counter'
	rename ag_k44`s' weeksnonharvest`counter'
	rename ag_k45`s' weeksharvest`counter'
    local counter = `counter' + 1
}
local suffixes d g k o
local counter 1
foreach s of local suffixes {
    rename ag_k43`s' daysplanting`counter'
	rename ag_k44`s' daysnonharvest`counter'
	rename ag_k45`s' dayssharvest`counter'
    local counter = `counter' + 1
}

keep hhid plot_id indiv* weeks* days*
unab vars : *4
local varlist : subinstr local vars "4" "", all
di "`varlist'"
duplicates drop hhid plot_id, force // 3 obs deleted
reshape long `varlist', i(hhid plot_id) j(entry_no)
reshape long indiv days weeks, i(hhid plot_id entry_no) j(labor_type) string //component of season, not used
drop if indiv==. | days==. | weeks==.
replace days=days*weeks 
collapse (sum) days, by(hhid plot_id indiv)
gen season=1
append using `labor_rainy'	
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season 

	merge m:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen keep (1 3)
	gen gender="child" if age<15
	replace gender="male" if strmatch(gender,"") & female==0
	replace gender="female" if strmatch(gender,"") & female==1
	//gen labor_type="family"
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep(1 3) //merges in household info
	collapse (sum) days, by(country region district ta ea hhid plot_id season gender)
	//append using `all_exchange'
	
	merge 1:1 hhid plot_id season gender using `plot_wages', nogen keep(1 3)
	gen wage = wagehired_plot
	foreach i in ea ta district region country {		
		merge m:1 `i' season gender using `wages_`i'', nogen keep(1 3)
		replace wage = wagehired_`i' if obs_`i' > 9 & wage==.
	}
	gen val=wage*days
/*
	preserve
	collapse (sum) days_rescale=days, by(region  district ta ea rural hhid plot_id indiv /*season tag*/ season)
	merge m:1 hhid plot_id using"${MWI_IHS_W1_created_data}\Malawi_IHS_W1_plot_season_length.dta", nogen keep(1 3)
	replace days_rescale = days_grown if days_rescale > days_grown
	tempfile rescaled_days
	save `rescaled_days'
	restore
	//Rescaling to season
	bys hhid plot_id indiv : egen tot_days = sum(days)
	gen days_prop = days/tot_days 
	merge m:1 region  district ta ea rural hhid plot_id indiv /*season tag*/ season using `rescaled_days' //all matched
	replace days = days_rescale * days_prop if tot_days > days_grown
	merge m:1 hhid indiv using `members', nogen keep (1 3)
	gen gender="child" if age<15
	replace gender="male" if strmatch(gender,"") & male==1
	replace gender="female" if strmatch(gender,"") & male==0
	gen labor_type="family"
	*/
	
	//Labor expense estimates are severely understated for several reasons: 1. the survey instrument did not ask for number of hired labors. Therefore, the constructed value of hired labor for some households could represent all hired labor costs or per laborer hired labor costs. 2. We typically use the value of hired labor to imput the value of family and nonhired (exchange) labor. However, due to issues with how hired labor is contructed, we cannot use these values to impute the value of family or nonhired (exchange) labor.
	
	collapse (sum) val days, by(hhid plot_id season gender) 
	merge m:1 plot_id hhid season using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_decision_makers", nogen keep(1 3) keepusing(dm_gender)
	/* No longer needed
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	//la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (MWK)"
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_labor_long.dta",replace
	*/
preserve
	gen labor_family_female=days if gender=="female"
	gen labor_family_male=days if gender=="male"
	collapse (sum) labor_family_male labor_family_female labor_family=days, by (hhid plot_id season)
	recode labor* (0=.)
	gen labor_nonhired=.
	gen labor_hired=.
	gen labor_hired_female=.
	gen labor_hired_male=.
	gen labor_total = . 
	la var labor_family "Number of family person-days spent on plot, all seasons"
	la var labor_nonhired "Number of exchange person-days spent on plot (cannot be constructed)"
	la var labor_hired "Number of hired labor person-days spent on plot (cannot be constructed)"
	la var labor_total "Total number of person-days spent on plot (cannot be constructed)"
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_family_hired_labor.dta",replace
	collapse (sum) labor*, by(hhid)
	recode labor* (0=.)
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_family_hired_labor.dta", replace
restore
	//AgQuery
preserve
	//gen exp="exp" if strmatch(labor_type,"hired")
	//replace exp="imp" if strmatch(exp,"")
	gen exp="imp" //All family labor is implicit
	//append using `inkind_payments' //To check //Few observations, may be influenced by pay rates and so potentially biased.
	collapse (sum) val, by(hhid plot_id exp dm_gender season)
	gen input="labor"
	drop if plot_id == "" | val == 0
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_labor.dta", replace //this gets used below.
restore	

	collapse (sum) val, by(hhid plot_id season /*labor_type*/ dm_gender)
	ren val val_family
	gen val_hired=.
	gen val_nonhired=.
	//reshape wide val_, i(hhid plot_id season dm_gender) j(labor_type) string
	ren val* val*_
	reshape wide val*, i(hhid plot_id dm_gender) j(season)
	ren *0 *rainy_
	ren *1 *dry_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	replace dm_gender2 = "unknown" if dm_gender==. 
	drop dm_gender
	reshape wide val*, i(hhid plot_id) j(dm_gender2) string
	collapse (sum) val*, by(hhid)
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_cost_labor.dta", replace


	*********************************
	* 		LAND/PLOT RENTS			*
	*********************************
	use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta", clear
	collapse (sum) ha_planted, by(hhid plot_id season)
	tempfile planted_area
	save `planted_area'
	
	* Crops Payments
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
	gen season=0
	append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta"
	replace season=1 if season==.
	gen cultivate = 0
	replace cultivate = 1 if ag_d14 == 1
	replace cultivate = 1 if ag_k15 == 1
	ren ag_d00 plot_id
	replace plot_id=ag_k0a if plot_id==""
	gen payment_period=ag_d12
	replace payment_period=ag_k13 if payment_period==.

	* Paid
	ren ag_d08a crop_code_paid
	replace crop_code_paid=ag_k09a if crop_code_paid==.
	ren ag_d08b qty_paid
	replace qty_paid=ag_k09b if qty_paid==.
	ren ag_d08c unit_paid
	replace unit_paid=ag_k09c if unit_paid==.
	ren ag_d08d condition_paid
	replace condition_paid=ag_k09d if condition_paid==.

	* Owed
	ren ag_d10a crop_code_owed
	replace crop_code_owed=ag_k11a if crop_code_owed==.
	ren ag_d10b qty_owed
	replace qty_owed=ag_k11b if qty_owed==.
	ren ag_d10c unit_owed
	replace unit_owed=ag_k11c if unit_owed==.
	ren ag_d10d condition_owed
	replace condition_owed=ag_k11d if condition_owed==.

	
	drop if crop_code_paid==. & crop_code_owed==. //only care about crop payments from households that made plot rental payments by crops
	drop if (unit_paid==. & crop_code_paid!=.) | (unit_owed==. & crop_code_owed!=.)  //8 observations deleted-cannot convert to kg if units are unavailable
	
	keep hhid plot_id cultivate season crop_code* qty* unit* condition* payment_period
	reshape long crop_code qty unit condition, i (hhid season plot_id payment_period cultivate) j(payment_status) string
	ren crop_code crop_code_long
	drop if crop_code_long==. //cannot estimate crop values for payments we do not have crop types for
	drop if qty==. //cannot estimate crop values for payments we do not have qty for
	
	// normally, we would execute a conversion of unit [ag_d08c and ag_d10c] = "Other (specify)" to another value for unit that is convertible via cf.dta
	// however, only one observation for ag_d08c and ag_d10c have the value "Other (specify)". That observation does not have a valid crop_code ('.')
	// so, we skip the step of manually converting O/S units to normal units
	
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", keepusing (region district ta ea) keep(1 3) nogen	
	capture tostring unit*, replace force
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\MWI_IHS_cf.dta", keep (1 3) // all matched
	merge m:1 hhid crop_code_long using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_crop_prices_for_wages.dta", nogen keep (1 3) //all matched

	gen val=qty*hh_price_mean // one observation possibly data entry error: qty is 50 and unit is 50 kg bag; if this is a data entry error, we are greatly overstating expenses for this observation
	drop qty unit crop_code_long condition hh_price_mean payment_status
	keep if val!=. //14 obs deleted; cannot monetize crop payments without knowing the mean hh price
	tempfile plotrentbycrops
	save `plotrentbycrops'


	* Rainy Cash + In-Kind
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
	gen cultivate = 0
	replace cultivate = 1 if ag_d14 == 1
	ren ag_d00 plot_id
	
	ren ag_d09a cash_rents_total
	ren ag_d09b inkind_rents_total
	ren ag_d11a cash_rents_paid
	ren ag_d11b inkind_rents_paid
	ren ag_d12 payment_period
	replace cash_rents_paid=cash_rents_total if cash_rents_paid==. & cash_rents_total!=. & payment_period==1
	ren ag_d11c cash_rents_owed
	ren ag_d11d inkind_rents_owed
	egen val = rowtotal(cash_rents_paid inkind_rents_paid cash_rents_owed inkind_rents_owed)
	gen season = 0 //"Rainy"
	keep hhid plot_id val season cult payment_period
	tempfile rainy_land_rents
	save `rainy_land_rents', replace

	* Dry Cash + In-Kind
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear 
	gen cultivate = 0
		replace cultivate = 1 if ag_k15 == 1
    ren ag_k0a plot_id
	ren ag_k10a cash_rents_total
	ren ag_k10b inkind_rents_total
    ren ag_k12a cash_rents_paid
	ren ag_k12b inkind_rents_paid
	ren ag_k13 payment_period
	replace payment_period=0 if payment_period==3 & (strmatch(ag_k13_os, "DIMBA SEASON ONLY") | strmatch(ag_k13_os, "DIMBA SEASOOY") | strmatch(ag_k13_os, "ONLY DIMBA"))
	replace cash_rents_paid=cash_rents_total if cash_rents_paid==. & cash_rents_total!=. & payment_period==0
	ren ag_k12c cash_rents_owed
	ren ag_k12d inkind_rents_owed
	egen val = rowtotal(cash_rents_paid inkind_rents_paid cash_rents_owed inkind_rents_owed)	
	keep hhid plot_id val cult payment_period
	gen season = 1 //"Dry"

	* Combine dry + rainy + payments-by-crop
	append using `rainy_land_rents'
	append using `plotrentbycrops'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	gen input="plotrent"
	gen exp="exp" //all rents are explicit

	duplicates report hhid plot_id season
	duplicates tag hhid plot_id season, gen(dups)
	//br if dups>0
	duplicates drop hhid plot_id season, force //two duplicate entries
	drop dups

	//This chunk identifies and deletes duplicate observations across season modules where an annual payment is recorded twice
	gen check=1 if payment_period==2 & val>0 & val!=.
	duplicates report hhid plot_id payment_period check
	duplicates tag hhid plot_id payment_period check, gen(dups)
	drop if dups>0 & check==1 & season==1 // dropping one entry for which the annual plot rents was recorded in both the rainy and dry module
	drop dups check

	gen qty=0
	recode val (.=0)
	collapse (sum) val, by (hhid plot_id season exp input qty cultivate)

	merge m:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta", keep (1 3)
	count if _m==1 & plot_id!="" & val!=. & val>0
			drop if _m != 3 //9,179 obs deleted
			drop _m

		* Calculate quantity of plot rents etc. 
		replace qty = field_size if val > 0 & val! = . //1,304 changes
		keep hhid plot_id season input exp val qty
		tempfile plotrents
		save `plotrents'	

	******************************************
	* FERTILIZER, PESTICIDES, AND HERBICIDES *
	******************************************
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
	gen season=0
	append using   "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta"
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep (1 3)
	//merge m:m hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta" 
	ren ag_d00 plot_id
	replace plot_id = ag_k0a if plot_id==""
	drop if plot_id==""
	replace season=1 if season==.
	preserve
	gen plot_irr=1 if ag_d28a !=7 //7 is no irrigation
	replace plot_irr=1 if plot_irr==0 & ag_k29a != 7
	recode plot_irr (.=0)
	keep hhid plot_irr plot_id season ea ta district  
	duplicates tag plot_id hhid season, gen (dups)
	drop if dups>0
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_irrigation.dta", replace	
	restore
	
	ren ag_d37a qtyorgfert1
	ren ag_d37b unitorgfert1
	replace qtyorgfert1=qtyorgfert1*50 if strpos(ag_d37b_os, "50")
	replace qtyorgfert1=qtyorgfert1*7000 if strpos(ag_d37b_os, "7")
	replace qtyorgfert1=qtyorgfert1*1000 if ag_d37b_os=="TON"
	replace unitorgfert1=2 if strpos(ag_d37b_os, "50") | strpos(ag_d37b_os, "7") | ag_d37b_os=="TON"
	replace qtyorgfert1 = qtyorgfert1*200 if strpos(ag_d37b_os, "200")
	replace unitorgfert1=8 if strpos(ag_d37b_os, "LITER")

	ren ag_d39a itemcodeinorg1
	ren ag_d39d qtyinorg1 //already in kgs
	gen unitinorg1=2
	ren ag_d39f itemcodeinorg2
	ren ag_d39i qtyinorg2
	gen unitinorg2=2
	ren ag_k40a itemcodeinorg3
	ren ag_k40d qtyinorg3
	gen unitinorg3 = 2
	ren ag_k40f itemcodeinorg4
	ren ag_k40i qtyinorg4
	gen unitinorg4=2
	//no obs for o/s units 
	ren ag_d41a itemcodeherbpest1
	ren ag_d41c unitherbpest1
	ren ag_d41b qtyherbpest1
	ren ag_d41d itemcodeherbpest2
	ren ag_d41e qtyherbpest2
	ren ag_d41f unitherbpest2
	ren ag_k42a itemcodeherbpest3
	ren ag_k42c unitherbpest3
	ren ag_k42b qtyherbpest3
	ren ag_k42d itemcodeherbpest4
	ren ag_k42e qtyherbpest4
	ren ag_k42f unitherbpest4
	ren ag_k38a qtyorgfert2
	ren ag_k38b unitorgfert2
	//ren ea_id ea

	keep hhid ea plot_id qty* unit* itemcode* season
	collapse (firstnm) item* qty* unit*, by(hhid ea plot_id season) 
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i(hhid ea plot_id season) j(obs)
	reshape long qty unit itemcode, i(hhid ea plot_id season obs) j(input) string
	drop obs
	replace itemcode = 0 if input=="orgfert"
	replace input="herb" if input=="herbpest" & itemcode==8
	replace input="pest" if input=="herbpest" 
	drop if itemcode==. | (unit==. & itemcode==7) //2 pesticide entries with blank units
	//convert to kg so we can compare with hh totals - see below for explanations.
	replace qty = qty/1000 if (unit==1 | unit == 9) & qty > 4 //We're going to conflate kg and liters here even though most products are more dense than water.  //Still some questionable herb/pest values that should be investigated.
	replace unit = 1 if unit==2 //we're going to take the grams unit code for kg because we use kg = 1 liter. 
	replace unit = 8 if unit==9

	replace qty = qty*.5375 if unit== 8 & itemcode==0 //liter
	replace qty = qty*20*.5375 if unit== 10 & itemcode==0 //bucket
	replace qty = qty*1.05722 if unit== 8 & itemcode==1 //liter
	replace qty = qty*20*1.05722 if unit== 10 & itemcode==1 //bucket
	replace qty = qty*20*1 if unit== 10 & itemcode==2 //bucket
	replace qty = qty*1.514606 if unit== 8 & itemcode==3 //liter
	replace qty = qty*20*1.514606 if unit== 10 & itemcode==3 //bucket
	replace qty = qty*.760 if unit== 8 & itemcode==4 //liter
	replace qty = qty*20*.760 if unit== 10 & itemcode==4 //bucket
	replace qty = qty*1.5873 if unit== 8 & itemcode==5 //liter
	replace qty = qty*20*1.5873 if unit== 10 & itemcode==5 //bucket
	replace qty = qty*20*1 if unit== 10 & (itemcode==2 | itemcode==3) //bucket
	replace qty = qty*80 if unit==11
	replace qty = qty*800 if unit==12
	replace unit = 1  if inlist(unit, 8,9,10,11,12) & inlist(itemcode, 0,1,2,3,4,5)
	replace unit = 1 if unit==8

	preserve
	collapse (sum) qty, by(hhid ea input itemcode unit season)
	drop if qty==0 | qty==.
	bys hhid ea itemcode season : egen max_unit = max(unit)
	drop if max_unit > 1
	drop max_unit
	ren qty hh_qty_kg
	tempfile hh_input_kg
	save `hh_input_kg'
	restore

	tempfile plot_inputs
	save `plot_inputs'
	
	/* Fertilizer Nutrient Application Rates:
		Itemcodes for fertilizer
           1   23:21:0+4S/CHITOWE
           2   dap - 18-46-0
           3   can - ~24-0-0
           4   urea - 46-0-0
           5   D COMPOUND - 10-20-10
	*/
	
	keep if unit==1 //to be addressed

	gen n_kg = 0.23*itemcode==1 + 0.18 * itemcode==2 + 0.24*itemcode==3 + 0.46*itemcode==4 + 0.10*itemcode==5 if unit==1
	gen p_kg = 0.21*itemcode==1 + 0.46 * itemcode==2 + 0.2*itemcode==5 if unit==1
	gen k_kg = 0.1*itemcode==5 if unit==1
	gen n_org_kg = 0.02*itemcode==0*qty 
	gen org_fert_kg=qty*itemcode==0	
	gen nps_kg = qty*(itemcode==1)
	gen dap_kg = qty*(itemcode==2)
	gen can_kg = qty*(itemcode==3)
	gen urea_kg = qty*(itemcode==4)
	gen npk_kg = qty*(itemcode==5) 
	gen pest_kg = qty*inlist(itemcode, 7, 9, 10, 11)
	gen herb_kg = qty*itemcode==8
	
	la var nps_kg "Total quantity of NPS fertilizer applied to plot"
	la var dap_kg "Total quantity of DAP fertilizer applied to plot"
	la var can_kg "Total quantity of CAN fertilizer applied to plot"
	la var urea_kg "Total quantity of Urea fertilizer applied to plot"
	la var npk_kg "Total quantity of NPK fertilizer applied to plot"
	la var n_kg "Kg of nitrogen applied to plot from inorganic fertilizer"
	la var p_kg "Kg of phosphorus applied to plot from inorganic fertilizer"
	la var k_kg "Kg of potassium applied to plot from inorganic fertilizer"
	la var n_org_kg "Kg of nitrogen from manure and organic fertilizer applied to plot"
	collapse (sum) *kg, by(ea season hhid plot_id)
	egen inorg_fert_kg=rowtotal(nps_kg dap_kg can_kg urea_kg npk_kg)
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_fertilizer_kg_application_plot.dta", replace
	collapse (sum) *kg, by(ea season hhid)
	save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_fertilizer_kg_application_hh.dta", replace

	//Question layout here is a bit weird - ag_f/l01 represents the total amount of fertilizer applied. This may be lower than the total amount purchased - the way the questions are worded seems meant to avoid that (i.e., "how much of <this> input"), but I don't think it's reasonable to conclude that most respondents understood that. 

	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_f.dta", clear
	gen season = 0 
	append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_l.dta"
	replace season = 1 if season == .
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	rename ag_f0c itemcode
	replace itemcode=ag_l0c if itemcode==.
	drop if itemcode==. 
	replace itemcode = 7 if strmatch(ag_f0c_os, "2.4D") //backfill
	replace itemcode = 8 if strmatch(ag_f0c_os, "ROUND UP") //backfill
	gen input = "inorg" if inlist(item, 1,2,3,4,5,6)
	replace input = "herb" if itemcode==8
	replace input = "pest" if inlist(itemcode, 7,9,10)
	replace input = "orgfert" if itemcode==0
	drop if itemcode==11 & (ag_f0c_os!="2.4D" | ag_f0c_os!="ROUND UP" | ag_l0c_os!="DIMETHOATE") // 8 obs deleted

	rename ag_l36c_os ag_l36b_os //all of the other specified units are b, not c - changing to b so that the loop works 
	//Some o/s variables are being stored as bytes - this converts all of them to strings
	local qnum 07 16 26 36 38 42
	foreach q in `qnum'{
		tostring ag_f`q'b_os, format(%19.0f) replace
		tostring ag_l`q'b_os, format(%19.0f) replace
	}

	*All Source Input and Transportation Costs (Explicit)*
	gen unitinputimp0 = ag_f01b
	gen qtyinputimp0 = ag_f01a if ag_f03==1
	replace qtyinputimp0 = qtyinputimp0/1000 if unitinputimp0==1 | unitinputimp0==9
	replace unitinputimp0=2 if unitinputimp0==1 
	replace unitinputimp0=8 if unitinputimp0==9

	replace ag_f07a = ag_f07a/1000 if ag_f07b==1 | ag_f07b==9
	replace ag_f07b = 2 if ag_f07b==1 
	replace ag_f07b = 8 if ag_f07b==9
	replace qtyinputimp0 = ag_f01a - ag_f07a if ag_f03==2 & ag_f07b == unitinputimp0 //This will generate some 0's but we'll privilege obs of purchases. Also note no unmatched units across these two questions
	replace qtyinputimp0 = 0 if qtyinputimp0 < 0 //Lot of negative observations here, which is strange because we're supposed to have the total amount of input in ag_f01b
	gen itemcodeinputimp0=itemcode

	gen unitinputimp1 = ag_l01b
	gen qtyinputimp1 = ag_l01a if ag_l03==1
	replace qtyinputimp1 = ag_l01a - ag_l07a if ag_l03==2
	replace qtyinputimp1 = 0 if qtyinputimp1 < 0
	gen itemcodeinputimp1 = itemcode

	ren ag_f07a qtyinputexp0 //This can exceed the amount of fertilizer applied, but we should use the full amount for price estimation.
	replace qtyinputexp0 = ag_l07a if qtyinputexp0 ==.
	ren ag_f07b unitinputexp0
	replace unitinputexp0 = ag_l07b if unitinputexp0 ==. //adding dry season
	ren ag_f09 valtransfertexp0 //all transportation is explicit
	replace valtransfertexp0 = ag_l09 if valtransfertexp0 == .
	ren ag_f10 valinputexp0
	replace valinputexp0 = ag_l10 if valinputexp0 == .

	//While this looks like double dipping, it's fine because there's only an entry in (what we rename to) *1-3 if there's nothing in 0
	*First Source Input and Transportation Costs (Explicit)*
	ren ag_f16a qtyinputexp1
	replace qtyinputexp1 = ag_l16a if qtyinputexp1 ==.
	ren ag_f16b unitinputexp1
	replace unitinputexp1 = ag_l16b if unitinputexp1 ==. //adding dry season
	ren ag_f18 valtransfertexp1 //all transportation is explicit
	replace valtransfertexp1 = ag_l18 if valtransfertexp1 == .
	ren ag_f19 valinputexp1
	replace valinputexp1 = ag_l19 if valinputexp1 == .

	*Second Source Input and Transportation Costs (Explicit)*
	ren ag_f26a qtyinputexp2
	replace qtyinputexp2 = ag_l26a if qtyinputexp2 ==.
	ren ag_f26b unitinputexp2
	replace unitinputexp2 = ag_l26b if unitinputexp2 ==. //adding dry season
	ren ag_f28 valtransfertexp2 //all transportation is explicit
	replace valtransfertexp2 = ag_l28 if valtransfertexp2 == .
	ren  ag_f29 valinputexp2
	replace valinputexp2 = ag_l29 if valinputexp2 == .

	*Third Source Input Costs (Explicit)* // Transportation Costs and Value of input not asked about for third source on W1 instrument, hence the need to impute these costs later provided we have itemcode code and qtym
	ren ag_f36a qtyinputexp3  // Third Source
	replace qtyinputexp3 = ag_l36a if qtyinputexp3 == .
	ren ag_f36b unitinputexp3
	replace unitinputexp3 = ag_l36b if unitinputexp3 == . //adding dry season

	*Free and Left-Over Input Costs (Implicit)*
	gen itemcodeinputimp2 = itemcode
	ren ag_f38a qtyinputimp2  // Free input
	replace qtyinputimp2 = ag_l38a if qtyinputimp2 == .
	ren ag_f38b unitinputimp2
	replace unitinputimp2 = ag_l38b if unitinputimp2 == . //adding dry season
	ren ag_f42a qtyinputimp3 //Quantity input left
	replace qtyinputimp3 = ag_l42a if qtyinputimp3 == .
	ren ag_f42b unitinputimp3
	replace unitinputimp3 = ag_l42b if unitinputimp2== . //adding dry season

	//Organic fertilizer (manure) from own animals; only applies to the orgfert line item
	ren ag_f44a qtyinputimp4 
	ren ag_f44b unitinputimp4
	replace qtyinputimp4 = ag_l44a if qtyinputimp4==.
	replace unitinputimp4 = ag_l44b if unitinputimp4 == .

	*Free Input Source Transportation Costs (Explicit)*
	ren ag_f40 valtransfertexp3 //all transportation is explicit
	replace valtransfertexp3 = ag_l40 if valtransfertexp3 == .

	ren ag_f07b_os otherunitinputexp0
	replace otherunitinputexp0=ag_l07b_os if otherunitinputexp0==""
	ren ag_f16b_os otherunitinputexp1
	replace otherunitinputexp1=ag_l16b_os if otherunitinputexp1==""
	ren ag_f26b_os otherunitinputexp2
	replace otherunitinputexp2=ag_l26b_os if otherunitinputexp2==""
	ren ag_f36b_os otherunitinputexp3
	replace otherunitinputexp3=ag_l36b_os if otherunitinputexp3==""
	ren ag_f38b_os otherunitinputimp1
	replace otherunitinputimp1=ag_l38b_os if otherunitinputimp1==""
	ren ag_f42b_os otherunitinputimp2
	replace otherunitinputimp2=ag_l42b_os if otherunitinputimp2==""

	keep qty* unit* otherunit* val* hhid itemcode input season
	gen dummya = _n
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i (hhid dummya itemcode input) j(entry_no)
	drop entry_no
	replace dummya=_n
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	reshape long `stubs2', i(hhid dummya itemcode input) j(exp) string
	replace dummya=_n
	reshape long qty unit val, i(hhid exp dummya itemcode input) j(type) string
	replace input=type if type=="transfert"
	drop type otherunitinput dummya
	drop if (val==. | val==0) & (qty==. | qty==0) & unit==. 

	// Converting GRAMS to KILOGRAM
	replace qty = qty / 1000 if unit == 1 
	// Converting 2 KG BAG to KILOGRAM
	replace qty = qty * 2 if unit == 3
	// Converting 3 KG BAG to KILOGRAM
	replace qty = qty * 3 if unit == 4
	// Converting 5 KG BAG to KILOGRAM
	replace qty = qty * 5 if unit == 5
	// Converting 10 KG BAG to KILOGRAM
	replace qty = qty * 10 if unit == 6
	// Converting 50 KG BAG to KILOGRAM
	replace qty = qty * 50 if unit == 7
	recode unit (1 2 3 4 5 6 7 = 1) //Using 1 for kgs

	replace itemcode = 12 if input=="transfert"
	replace unit=1 if input=="transfert"
	collapse (sum) val qty, by(season hhid input itemcode exp unit)

	*CONVERTING VOLUMES TO MASS*
	/*Assuming 1 BUCKET is about 20L in Malawi
	Citation: Mponela, P., Villamor, G. B., Snapp, S., Tamene, L., Le, Q. B., & Borgemeister, C. (2020). The role of women empowerment and labor dependency on adoption of integrated soil fertility management in Malawi. Sustainability, 12(15), 1-11. https://doi.org/10.1111/sum.12627
	*/

	*ORGANIC FERTILIZER
	/*Assuming bulk density of ORGANIC FERTILIZER is between 420-655 kg/m3 (midpoint 537.5kg/m3)
	Citation: Khater, E. G. (2015). Some Physical and Chemical Properties of Compost. Agricultural Engineering Department, Faculty of Agriculture, Benha University, Egypt. Corresponding author: Farouk K. M. Wali, Assistant professor, Chemical technology Department, The Prince Sultan Industrial College, Saudi Arabia, Tel: +20132467034; E-mail: alsayed.khater@fagr.bu.edu.eg. Retrieved from https://www.walshmedicalmedia.com/open-access/some-physical-and-chemical-properties-of-compost-2252-5211-1000172.pdf
	*/
	//before we do this, we need nonstandard unit pricing for manure. 
	preserve
	keep if itemcode==0
	gen price_unit = val/qty 
	replace price_unit = . if price_unit > 50000 // one obs with weird units  
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep(1 3)
	gen obs=1
	foreach i in region district ta ea {
		bys `i' input itemcode : egen obs_`i' = sum(obs)
		bys `i' itemcode input unit season : egen price_unit_`i'=median(price_unit)
	}
	bys `i' itemcode input unit season : egen price_unit_`i'=median(price_unit)
	keep ea hhid itemcode unit price_unit_* obs_* input
	tempfile orgfert_unit_pricing
	save `orgfert_unit_pricing'
	restore 

	replace qty = qty*.5375 if unit== 8 & itemcode==0 //liter
	replace qty = qty/1000*.5375 if unit== 9 & itemcode==0 //milliliter
	replace qty = qty*20*.5375 if unit== 10 & itemcode==0 //bucket

	*CHITOWE*
	/*Assuming bulk density of CHITOWE(NPK) is between 66lb/ft3 (converts to 1057.22kg/m3) based on the bulk density of YaraMila 16-16-16 by Yara North America, Inc. fertilizer available at https://www.yara.us/contentassets/280676bbae1c466799e9d22b57225584/yaramila-16-16-16-pds/
	*/
	replace qty = qty*1.05722 if unit== 8 & itemcode==1 //liter
	replace qty = qty/1000*1.05722 if unit== 9 & itemcode==1 //milliliter
	replace qty = qty*20*1.05722 if unit== 10 & itemcode==1 //bucket

	*DAP*
	/*Assuming bulk density of DAP is between 900-1100kg/m3 (midpoint 1000kg/m3) based on the bulk density of DAP fertlizer by Incitec Pivot Ltd. (Australia) available at https://www.incitecpivotfertilisers.com.au/~/media/Files/IPF/Documents/Fact%20Sheets/40%20Fertiliser%20Products%20Density%20and%20Sizing%20Fact%20Sheet.pdf
	*/
	replace qty = qty*1 if unit== 8 & itemcode==2 //liter
	replace qty = qty/1000*1 if unit== 9 & itemcode==2 //milliliter
	replace qty = qty*20*1 if unit== 10 & itemcode==2 //bucket

	*CAN*
	/*Assuming bulk density of CAN is 12.64lb/gal (converts to 1514.606kg/m3) based on the bulk density of CAN-17 by Simplot (Boise, ID) available at https://techsheets.simplot.com/Plant_Nutrients/Calcium_Ammon_Nitrate.pdf
	*/
	replace qty = qty*1.514606 if unit== 8 & itemcode==3 //liter
	replace qty = qty/1000*1.514606 if unit== 9 & itemcode==3 //milliliter
	replace qty = qty*20*1.514606 if unit== 10 & itemcode==3 //bucket

	*UREA*
	/*Assuming bulk density of UREA is 760kg/m3 based on the bulk density of  urea-prills by Pestell Nutrition (Canada) available at https://pestell.com/product/urea-prills/
	*/
	replace qty = qty*.760 if unit== 8 & itemcode==4 //liter
	replace qty = qty/1000*.760 if unit== 9 & itemcode==4 //milliliter
	replace qty = qty*20*.760 if unit== 10 & itemcode==4 //bucket

	*D COMPOUND*
	/*Assuming bulk density of D COMPOUND is approximately 1,587.30kg/m3 based on the bulk density D Compound-50kg stored in a (30cm x 50cm x 70cm) bag by E-msika (Zambia) available at www.emsika.com/product-details/54

	Calculation: 50 kg stored in a (30cm x 50cm x 70cm) = 31,500cm3 (0.0315m3) bag; so 50kg/0.0315m3 or 1,587.30kg/m3
	*/

	replace qty = qty*1.5873 if unit== 8 & itemcode==5 //liter
	replace qty = qty/1000*1.5873 if unit== 9 & itemcode==5 //milliliter
	replace qty = qty*20*1.5873 if unit== 10 & itemcode==5 //bucket

	*PESTICIDES AND HERBICIDES*
	/*Pesticides and herbicides do not have a bulk density because they are typically sold already in liquid form, so they'd have a mass density. It depends on the concentration of the active ingredient and the presence of any adjuvants and is typically impossible to get right unless you have the specific brand name. Accordingly, EPAR currently assumes 1L=1kg, which results in a slight underestimate of herbicides and pesticides.*/
	replace qty = qty*1 if unit== 8 & (itemcode==2 | itemcode==3) //liter
	replace qty = qty/1000*1 if unit== 9 & (itemcode==2 | itemcode==3) //milliliter
	replace qty = qty*20*1 if unit== 10 & (itemcode==2 | itemcode==3) //bucket

	*CONVERTING WHEELBARROW AND OX-CART TO KGS*
	/*Assuming 1 WHEELBARROW max load is 80 kg 
	Assuming 1 OX-CART has a 800 kgs carrying capacity, though author notes that ox-carts typically carry loads far below their weight capacity, particularly for crops (where yields may not fill the cart entirely)
	Citation: Wendroff, A. P. (n.d.). THE MALAWI CART: An Affordable Bicycle-Wheel Wood-Frame Handcart for Agricultural, Rural and Urban Transport Applications in Africa. Research Associate, Department of Geology, Brooklyn College / City University of New York; Director, Malawi Handcart Project. Available at: https://www.academia.edu/15078493/THE_MALAWI_CART_An_Affordable_Bicycle-Wheel_Wood-Frame_Handcart_for_Agricultural_Rural_and_Urban_Transport_Applications_in_Africa
	*/
	replace qty = qty*80 if unit==11
	replace qty = qty*800 if unit==12

	* Updating the unit for unit to "1" (to match seed code) for the relevant units after conversion
	replace unit = 1 if inlist(unit, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)

	//Replacing household level quantities with plot totals if the latter are larger - as a way to correct for unit errors. Some folks are using *a lot* of manure but otherwise the replacements look reasonable. A few obs of pesticides at the 1-5 gram level 
	drop if unit!=1 
	bys hhid input itemcode season : egen tot_qty = sum(qty)
	gen exp_ratio = qty/tot_qty if exp=="exp"
	replace exp_ratio = 0 if exp_ratio == . & input!="transfert"
	collapse (sum) qty val (max) exp_ratio, by(hhid input itemcode unit season)
	ren input input_hh
	merge 1:1 hhid season itemcode using `hh_input_kg', nogen
	recode hh_qty_kg qty (.=0)
	replace qty = hh_qty_kg if qty < hh_qty_kg 
	*assert qty == hh_qty_kg
	replace qty=0 if input_hh=="transfert" //0 changes
	recode val (0=.)
	keep if qty>0 //1,727 deleted
	drop hh_qty_kg
	replace exp_ratio = 0 if exp_ratio == . // we assume that missing values correspond to items that were consumed but not purchased, an implicit category
	preserve
	gen ratioimp = 1 - exp_ratio
	ren exp_ratio ratioexp
	reshape long ratio, i(hhid itemcode season) j(exp) string
	tempfile phys_inputs1
	save `phys_inputs1'
	restore
	tempfile phys_inputs
	save `phys_inputs'

	drop if input=="transfert" | val==.
	gen price_kg = val/qty  //note apparent data entry error for 23:21:0 in hhid==101012040045
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep(1 3)
	gen obs=1
	foreach i in region district ta ea hhid {
		preserve
		bys `i' input itemcode : egen obs_`i' = sum(obs)
		collapse (median) price_kg_`i'=price_kg, by(`i' obs_`i' itemcode input season)
		tempfile input_price_`i'
		save `input_price_`i''
		restore
	}
	preserve
	collapse (median) price_kg_country=price_kg (sum) obs_country=obs, by(season itemcode input)
	tempfile input_price_country
	save `input_price_country'
	restore

	use `plot_inputs', clear
	drop if qty==. & input != "transfert"
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep(1 3) keepusing(region district ta ea)
	foreach i in region district ta ea hhid {
	merge m:1 `i' itemcode input season using `input_price_`i'', nogen keep(1 3)
	}
	merge m:1 itemcode input season using `input_price_country', nogen


	gen val = qty*price_kg_hhid
	gen missing_val = val==.
	recode obs* (.=0)
	foreach i in country region district ta ea {
		replace val = qty*price_kg_`i' if unit==2 & missing_val==1 & obs_`i' > 9
	}
	//generate exp/imp observations on a plot-level based on hh-level data
	merge m:1 hhid itemcode season using `phys_inputs', keepusing(exp_ratio) keep(1 3)
	drop if hhid == "" | exp_ratio == .
	duplicates drop // 125 duplicates dropped
	collapse (sum) qty val (mean) exp_ratio obs_* price_kg_* missing_*, by(hhid plot_id season input unit itemcode ea district ta region) //60 duplicate observations where qty and val were different. E.g. val1 = 40 and val2 = 30
	gen ratioimp = 1-exp_ratio
	ren exp_ratio ratioexp
	reshape long ratio, i(hhid plot_id season itemcode) j(exp) string
	replace val = val * ratio
	drop ratio
	drop if plot_id == "" | val == 0 // removes null values
	merge m:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", gen(dms) keep(1 3) keepusing(dm_gender) 

	tempfile phys_inputs_plot
	save `phys_inputs_plot'

	*********************************
	* 			 SEED			    *
	*********************************
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_h.dta", clear
	gen season = 0
	append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_n.dta"
	replace season = 1 if season == .
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	ren ag_h0b seedcode
	replace seedcode=ag_n0c if seedcode == .
	drop if seedcode==. //9,425 empty observations deleted

	//Some o/s variables are being stored as bytes - this converts all of them to strings
	local qnum 07 16 26 36 38 42
	foreach q in `qnum'{
		tostring ag_h`q'b_os, format(%19.0f) replace
		tostring ag_n`q'b_os, format(%19.0f) replace
	}

	/*The W1 instrument also asks for commercial seed costs in total (and breaks down by first, second, and third sources). If HH did not complete fields for Commercial Sources 1-3, we can replace with ALL.*/
	replace ag_h16a=ag_h07a if (ag_h07a!=. & ag_h16a==. & ag_h26a==. & ag_h36a==.) //4,838 changes
	replace ag_h16b=ag_h07b if (ag_h07b!=. & ag_h16b==. & ag_h26b==. & ag_h36b==.) //4,837 changes
	replace ag_h16b_os=ag_h07b_os if (ag_h07b_os!="" & ag_h16b_os=="" & ag_h26b_os=="" & ag_h36b_os=="") //0 changes
	replace ag_h18=ag_h09 if (ag_h09!=. & ag_h18==. & ag_h28==.) //4,832 changes
	replace ag_h19=ag_h10 if (ag_h10!=. & ag_h19==. & ag_h29==.) //4,831 changes
	replace ag_n16a=ag_n07a if (ag_n07a!=. & ag_n16a==. & ag_n26a==. & ag_n36a==.) //712 changes
	replace ag_n16b=ag_n07b if (ag_n07b!=. & ag_n16b==. & ag_n26b==. & ag_n36b==.) //712 changes
	replace ag_n16b_os=ag_n07b_os if (ag_n07b_os!="" & ag_n16b_os=="" & ag_n26b_os=="" & ag_n36b_os=="") //19 changes
	replace ag_n18=ag_n09 if (ag_n09!=. & ag_n18==. & ag_n28==.) //711 changes
	replace ag_n19=ag_n10 if (ag_n10!=. & ag_n19==. & ag_n29==.) //706 changes

	*First Source Seed and Transportation Costs (Explicit)*
	ren ag_h16a qtyseedexp1
	replace qtyseedexp1 = ag_n16a if qtyseedexp1 ==.
	ren ag_h16b unitseedexp1
	replace unitseedexp1 = ag_n16b if unitseedexp1 ==. //adding dry season
	ren ag_h18 valseedtransexp1 //all transportation is explicit
	replace valseedtransexp1 = ag_n18 if valseedtransexp1 == .
	ren ag_h19 valseedsexp1
	replace valseedsexp1 = ag_n19 if valseedsexp1 == .
	gen itemcodeseedexp1 = seedcode if qtyseedexp1 != .

	*Second Source Seed and Transportation Costs (Explicit)*
	ren ag_h26a qtyseedexp2
	replace qtyseedexp2 = ag_n26a if qtyseedexp2 ==.
	ren ag_h26b unitseedexp2
	replace unitseedexp2 = ag_n26b if unitseedexp2 ==. //adding dry season
	ren ag_h28 valseedtransexp2 //all transportation is explicit
	replace valseedtransexp2 = ag_n28 if valseedtransexp2 == .
	ren  ag_h29 valseedsexp2
	replace valseedsexp2 = ag_n29 if valseedsexp2 == .
	gen itemcodeseedexp2 = seedcode if qtyseedexp2 != .

	*Third Source Seed Costs (Explicit)*
	// Transportation Costs and Value of seed not asked about for third source on W1 instrument, hence the need to impute these costs later provided we have itemcode code and qty
	ren ag_h36a qtyseedexp3  // Third Source
	replace qtyseedexp3 = ag_n36a if qtyseedexp3 == .
	ren ag_h36b unitseedexp3
	replace unitseedexp3 = ag_n36b if unitseedexp3 == . //adding dry season

	*Free and Left-Over Seed Costs (Implicit)*
	gen itemcodeseedimp1 = seedcode
	ren ag_h38a qtyseedimp1  // Free seed
	replace qtyseedimp1 = ag_n38a if qtyseedimp1 == .
	ren ag_h38b unitseedimp1
	replace unitseedimp1 = ag_n38b if unitseedimp1 == . //adding dry season
	ren ag_h42a qtyseedimp2 //Quantity seed left
	replace qtyseedimp2 = ag_n42a if qtyseedimp2 == .
	ren ag_h42b unitseedimp2
	replace unitseedimp2 = ag_n42b if unitseedimp2== . //adding dry season

	*Free Source Transportation Costs (Explicit)*
	ren ag_h40 valseedtransexp3 //all transportation is explicit
	replace valseedtransexp3 = ag_n40 if valseedtransexp3 == .

	ren ag_h16b_os otherunitseedexp1
	replace otherunitseedexp1=ag_n16b_os if otherunitseedexp1==""
	ren ag_h26b_os otherunitseedexp2
	replace otherunitseedexp2=ag_n26b_os if otherunitseedexp2==""
	ren ag_h36b_os otherunitseedexp3
	replace otherunitseedexp3=ag_n36b_os if otherunitseedexp3==""
	ren ag_h38b_os otherunitseedimp1
	replace otherunitseedimp1=ag_n38b_os if otherunitseedimp1==""
	ren ag_h42b_os otherunitseedimp2
	replace otherunitseedimp2=ag_n42b_os if otherunitseedimp2==""

	local valtab exp1 exp2 
	foreach v in `valtab'{
	tab valseeds`v', missing
	}
	//this tells me that val is missing for the majority of these

	local qtytab exp1 exp2 exp3 imp1 imp2
	foreach q in `qtytab'{
	tab qtyseed`q', missing
	}
	//this tells me that qty is missing for the majority of these, we cannot impute the value of something we do not have qty for

	local suffix exp1 exp2 exp3 imp1 imp2
	foreach s in `suffix' {
	//CONVERT SPECIFIED UNITS TO KGS
	replace qtyseed`s'=qtyseed`s'/1000 if unitseed`s'==1
	replace qtyseed`s'=qtyseed`s'*2 if unitseed`s'==3
	replace qtyseed`s'=qtyseed`s'*3 if unitseed`s'==4
	replace qtyseed`s'=qtyseed`s'*3.7 if unitseed`s'==5
	replace qtyseed`s'=qtyseed`s'*5 if unitseed`s'==6
	replace qtyseed`s'=qtyseed`s'*10 if unitseed`s'==7
	replace qtyseed`s'=qtyseed`s'*50 if unitseed`s'==8
	recode unitseed`s' (1/8 = 1) //see below for redefining variable labels
	label define unitrecode`s' 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify
	label values unitseed`s' unitrecode`s'

	//REPLACE UNITS WITH O/S WHERE POSSIBLE
	//Malawi instruments do not have unit codes for units like "packet" or "stem" or "bundle". Converting unit codes to align with the Malawi conversion factor file (merged in later). Also, borrowing Nigeria's unit codes for units (e.g. packets) that do not have unit codes in the Malawi instrument or conversion factor file.
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "MG")
	replace qtyseed`s'=qtyseed`s'/1000000 if strmatch(otherunitseed`s', "MG")
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "20 KG BAG")
	replace qtyseed`s'=qtyseed`s'*20 if strmatch(otherunitseed`s', "20 KG BAG")
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "25 KG BAG")
	replace qtyseed`s'=qtyseed`s'*25 if strmatch(otherunitseed`s', "25 KG BAG")
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "50 KG BAG") | strmatch(otherunitseed`s', "1 BAG TUBERS OF 50 KG BAG")
	replace qtyseed`s'=qtyseed`s'*50 if strmatch(otherunitseed`s', "50 KG BAG") | strmatch(otherunitseed`s', "1 BAG TUBERS OF 50 KG BAG")
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "90 KG BAG")
	replace qtyseed`s'=qtyseed`s'*90 if strmatch(otherunitseed`s', "90 KG BAG")
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "100 KG BAG")
	replace qtyseed`s'=qtyseed`s'*100 if strmatch(otherunitseed`s', "100 KG BAG")

	replace unitseed`s'=4 if strmatch(otherunitseed`s', "PAIL") | strmatch(otherunitseed`s', "SMALL PAIL") | strmatch(otherunitseed`s', "1 PAIL UNSHELLED")

	replace unitseed`s'=5 if strmatch(otherunitseed`s', "LARGE PAIL") | strmatch(otherunitseed`s', "LARGE PAILS") | strmatch(otherunitseed`s', "PAIL LARGE") | strmatch(otherunitseed`s', "1X LARGE PAIL") | strmatch(otherunitseed`s', "2X LARGE PAIL")
	replace qtyseed`s'=qtyseed`s'*2 if strmatch(otherunitseed`s', "2X LARGE PAIL")

	replace unitseed`s'=6 if strmatch(otherunitseed`s', "PLATE")  | strmatch(otherunitseed`s', "NO 10 PLATE") | strmatch(otherunitseed`s', "NO. 10 PLATE") | strmatch(otherunitseed`s', "NUMBER 10 PLATE") | strmatch(otherunitseed`s', "NO. 10 PLATE FLAT") | strmatch(otherunitseed`s', "2 NO 10 PLATES")
	replace qtyseed`s'=qtyseed`s'*2 if strmatch(otherunitseed`s', "2 NO 10 PLATES")

	replace unitseed`s'=7 if strmatch(otherunitseed`s', "NO. 12 PLATE")  | strmatch(otherunitseed`s', "NUMBER 12 PLATE")  

	replace unitseed`s'=9 if strmatch(otherunitseed`s', "PIECE") | strmatch(otherunitseed`s', "PIECES") | strmatch(otherunitseed`s', "PIECE OF MAIZE COB") | strmatch(otherunitseed`s', "STEMS") | strmatch(otherunitseed`s', "STEM CUTTINGS") | strmatch(otherunitseed`s', "CUTTINGS") | strmatch(otherunitseed`s', "BUNDLES") | strmatch(otherunitseed`s', "MTOLO UMODZI WA BATATA") //"motolo umodzi" translates to bundles and a standard bundle is 100 stems
	replace qtyseed`s'=qtyseed`s'*100 if strmatch(otherunitseed`s', "BUNDLES") | strmatch(otherunitseed`s', "MTOLO UMODZI WA BATATA")

	replace unitseed`s'=11 if strmatch(otherunitseed`s', "DENGU") 

	replace unitseed`s'=120 if strmatch(otherunitseed`s', "PACKET") | strmatch(otherunitseed`s', "1 PACKET") | strmatch(otherunitseed`s', "2 PACKETS")
	replace qtyseed`s'=qtyseed`s'*2 if strmatch(otherunitseed`s', "2 PACKETS")

	// see citation under Crop Expenses / Fertilizer, Pesticides, and Herbicides 
	replace unitseed`s'=1 if strmatch(otherunitseed`s', "WHEELBARROW")
	replace qtyseed`s'=qtyseed`s'*80 if strmatch(otherunitseed`s', "WHEELBARROW")
	}

	keep qty* unit* val* hhid seedcode season
	gen dummya = _n
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i (hhid dummya seedcode) j(entry_no)
	drop entry_no
	replace dummya=_n
	unab vars2 : *exp
	local stubs2 : subinstr local vars2 "exp" "", all
	drop if qtyseedexp==. & valseedsexp==.
	reshape long `stubs2', i(hhid dummya seedcode) j(exp) string
	replace dummya=_n
	reshape long qty unit val, i(hhid exp dummya seedcode) j(input) string
	tab val if exp=="imp" & input=="seedtrans"
	drop if strmatch(exp,"imp") & strmatch(input, "seedtrans") //No implicit transportation costs
	label define unitrecode 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet, modify
	label values unit unitrecode

	drop if (qty==. | qty==0) & strmatch(input, "seed") //7,500 obs deleted - cannot impute val without qty for seed
	drop if unit==. & strmatch(input, "seed") //0 obs deleted - cannot impute val without unit for seed
	gen byte qty_missing = missing(qty) //only relevant to seedtrans
	gen byte val_missing = missing(val)
	collapse (sum) val qty, by(hhid unit seedcode exp input qty_missing val_missing /*season tag*/ season)
	replace qty =. if qty_missing
	replace val =. if val_missing
	drop qty_missing val_missing

	ren seedcode crop_code_long
	drop if crop_code_long==. & strmatch(input, "seed") //0 obs deleted
	gen condition=1 
	replace condition=3 if inlist(crop_code, 5, 6, 7, 8, 10, 28, 29, 30, 31, 32, 33, 37, 39, 40, 41, 42, 43, 44, 45, 47) //4,896 real changes //these are crops for which the cf file only has entries with condition as N/A
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", keepusing (region district ta ea) keep(1 3) nogen
	capture tostring unit*, replace force
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\MWI_IHS_cf.dta", keep (1 3)
	destring unit*, replace force
	replace qty=. if input=="seedtrans" //0 changes, seedtrans must already have blanks for qty on all observations
	keep if qty>0 //2 obs deleted - dropping any observations where seed info not reported

	//Ensures that conversion factors did not get used for planted-as-seed crops where the conversion factor weights only work for planted-as-harvested crops
	replace conversion =. if inlist(crop_code, 5-8, 10, 28-29, 37, 39-45, 47) //265 real changes 

	replace unit=1 if unit==. //Weight, meaningless for transportation 
	replace conversion = 1 if unit==1 //conversion factor converts everything in kgs so if kg is the unit, cf is 1
	replace conversion = 1 if unit==9 //if unit is piece, we use conversion factor of 1 but maintain unit name as "piece"/unitcode #9
	replace qty=qty*conversion if conversion!=.
	/*By converting smaller units (e.g. grams, packets, bunches, etc.) into kgs and then imputing values (see end of crop expenses) for these observations where val is missing, we are underestimating the true value of smaller quantities of seeds.
	ren crop_code_short itemcode*/
	rename crop_code itemcode
	tempfile seed
	save `seed'

	*********************************************
	*  	MECHANIZED TOOLS AND ANIMAL TRACTION	*
	*********************************************

	use "${MWI_IHS_W1_appended_data}\Household\hh_mod_m.dta", clear // reported at the household level
	rename hh_m0a itemid
	gen anml = (itemid>=609 & itemid<=610) // Ox Cart, Ox Plow
	gen mech = (itemid>=601 & itemid<= 608 | itemid>=611 & itemid<=612 | itemid>=613 & itemid <=625) // Hand hoe, slasher, axe, sprayer, panga knife, sickle, treadle pump, watering can, ridger, cultivator, generator, motor pump, grain mill, other, chicken house, livestock and poultry kraal, storage house, granary, barn, pig sty and tractor (to align with NGA LSMS-ISA)
	rename hh_m14 rental_cost 
	gen rental_cost_anml = rental_cost if anml==1
	gen rental_cost_mech = rental_cost if mech==1
	recode rental_cost_anml rental_cost_mech (.=0)

	collapse (sum) rental_cost_anml rental_cost_mech, by (hhid)
	lab var rental_cost_anml "Costs for renting animal traction"
	lab var rental_cost_mech "Costs for renting other agricultural items" 
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_asset_rental_costs.dta", replace

	ren rental_cost_* val*
	reshape long val, i(hhid) j(input) string
	gen exp = "exp" //all rents are explict
	tempfile asset_rental
	save `asset_rental'

	*********************************************
	*   TREE/ PERMANENT CROP TRANSPORTATION	    *
	*********************************************
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_q.dta", clear
	ren ag_q10 valtreetrans
	collapse (sum) val, by (hhid)
	reshape long val, i(hhid) j(input) string
	gen exp = "exp"
	tempfile tree_transportation
	save `tree_transportation'

	*********************************************
	*       TEMPORARY CROP TRANSPORTATION       *
	*********************************************
	use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_o.dta", clear
	append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_i.dta"
	egen valtempcroptrans = rowtotal(ag_i10 ag_o10)
	collapse (sum) val, by(hhid)
	reshape long val, i(hhid) j(input) string
	gen exp = "exp"
	tempfile tempcrop_transportation
	save `tempcrop_transportation'

	*********************************************
	*     	COMBINING AND GETTING PRICES	    *
	*********************************************

	use `plotrents', clear
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cost_per_plot.dta", replace 

	recast str50 hhid, force 
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta",gen(weights) keep(1 3) keepusing(weight weight region district ea ta) //added geo vars here to avoid having to merge in later using a diff file
	merge m:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta", gen(plotareas) keep(1 3) keepusing(field_size) 
	merge m:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", gen(dms) keep(1 3) keepusing(dm_gender)
	
	gen plotweight = weight*field_size
	tempfile all_plot_inputs
	save `all_plot_inputs', replace

	* Calculating Geographic Medians for PLOT LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	gen price = val/qty
	drop if price==.
	gen obs=1

	* dropped "unit" and "itemcode" from all of these loops bc we don't have them anymore (since phys inputs is not at plot level)
	capture restore,not 
	foreach i in ea ta district region hhid {
	preserve
		bys `i' input : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price [aw=plotweight], by (`i' input obs_`i')
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}
	
	preserve
	bys input : egen obs_country = sum(obs)
	collapse (median) price_country = price [aw=plotweight], by(input  obs_country)
	tempfile price_country_median
	save `price_country_median'
	restore

	use `all_plot_inputs',clear
	foreach i in ea ta district region hhid {
		merge m:1 `i' input using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country ea ta district region  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	//Default to household prices when available
	replace price = price_hhid if price_hhid>0
	replace qty = 0 if qty <0 
	recode val qty (.=0)
	drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0

	append using `phys_inputs_plot'
	
	* For PLOT LEVEL data, add in plot_labor data
	append using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_labor.dta"
	collapse (sum) val, by (hhid plot_id exp input dm_gender /*season tag*/ season)

	* Save PLOT-LEVEL Crop Expenses (long)
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_cost_inputs_long.dta",replace 

	* Save PLOT-Level Crop Expenses (wide, does not currently get used in MWI W4 code)
	preserve
	collapse (sum) val_=val, by(hhid plot_id exp dm_gender /*season tag*/ season)
	reshape wide val_, i(hhid plot_id dm_gender /*season tag*/ season) j(exp) string 
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_cost_inputs.dta", replace
	restore

	*Aggregate PLOT-LEVEL crop expenses data up to HH level and append to HH LEVEL data.	
	preserve
	use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_cost_inputs_long.dta", clear
	collapse (sum) val, by(hhid plot_id input exp /*season tag*/ season)
	tempfile plot_to_hh_cropexpenses
	save `plot_to_hh_cropexpenses', replace
	restore

*** HH LEVEL Files: seed, asset_rental, phys inputs
	use `seed', clear
	append using `asset_rental'
	append using `phys_inputs1'
	append using `tree_transportation'
	append using `tempcrop_transportation'
	recast str50 hhid, force
	merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep(1 3) keepusing(weight region district ea ta) // merge in hh weight & geo data
	drop _merge
	tempfile all_HH_LEVEL_inputs
	save `all_HH_LEVEL_inputs', replace

	* Calculating Geographic Medians for HH LEVEL files
	keep if strmatch(exp,"exp")
	recode val (0=.)
	drop if unit==0 | unit == . //Remove things with unknown units.
	gen price = val/qty
	drop if price==. // drops 33,281 observations
	gen obs=1

	* Plotweight has been changed to aw = qty*weight (where weight is population weight) 
	foreach i in ea ta district region hhid {
	preserve
		bys `i' input unit itemcode : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price  [aw = (qty*weight)], by (`i' input unit itemcode obs_`i') 
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}
	
	preserve
	bys input unit itemcode : egen obs_country = sum(obs)
	collapse (median) price_country = price  [aw = (qty*weight)], by(input unit itemcode obs_country)
	tempfile price_country_median
	save `price_country_median'
	restore

	use `all_HH_LEVEL_inputs', clear
	foreach i in ea ta district region hhid {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country ea ta district region  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	//Default to household prices when available
	replace price = price_hhid if price_hhid>0
	replace qty = 0 if qty <0 // Remove any households reporting negative quantities of fertilizer.
	recode val qty (.=0)
	drop if val==0 & qty==0 //Dropping unnecessary observations.
	replace val=qty*price if val==0
	replace input = "orgfert" if itemcode==5
	replace input = "inorg" if strmatch(input,"fert")
	preserve
	keep if strpos(input,"orgfert") | strpos(input,"inorg") | strpos(input,"herb") | strpos(input,"pest")
	//Unfortunately we have to compress liters and kg here, which isn't ideal.
	collapse (sum) qty_=qty, by(hhid /*plot_id */input season)
	reshape wide qty_, i(hhid /*plot_id */season) j(input) string
	ren qty_inorg inorg_fert_kg
	ren qty_orgfert org_fert_kg
	ren qty_pest pest_kg
	ren qty_herb herb_kg
	la var inorg_fert_kg "Qty inorganic fertilizer used (kg)"
	la var org_fert_kg "Qty organic fertilizer used (kg)"
	la var herb_kg "Qty of herbicide used (kg/L)"
	la var pest_kg "Qty of pesticide used (kg/L)"	
	merge 1:1 hhid season using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_fertilizer_kg_application_hh.dta"
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_input_quantities.dta", replace
	restore	
	
	* Save HH-LEVEL Crop Expenses (long)
	preserve
	collapse (sum) val, by(hhid exp input region district ea ta)
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_cost_inputs_long.dta", replace
	restore

	* COMBINE HH-LEVEL crop expenses (long) with PLOT level data (long) aggregated up to HH LEVEL:
	use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_cost_inputs_long.dta", clear
	append using `plot_to_hh_cropexpenses'
	collapse (sum) val, by(hhid exp input region district ea ta)
	replace exp = "exp" if strpos(input, "asset") |  strpos(input, "animal") | strpos(input, "tractor")
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_cost_inputs_long_complete.dta", replace

use `plot_to_hh_cropexpenses', clear
collapse (sum) val, by(hhid plot_id exp season)

merge m:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", nogen keep(1 3)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id dm_gender2 season) j(exp) string
ren val* val*_
merge m:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
merge 1:1 plot_id hhid season using `planted_area', nogen keep(1 3)
replace dm_gender2 = "unknown" if dm_gender2 == ""

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
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_cost_inputs.dta", replace

********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************
	
//Setting things up for AgQuery first
use "${MWI_IHS_W1_created_data}/MWI_IHS_W1_all_plots.dta", clear
	keep if purestand==1
	ren ha_planted monocrop_ha
	ren kg_harvest kgs_harv_mono
	ren value_harvest val_harv_mono
	collapse (sum) *mono*, by(hhid plot_id crop_code dm_gender season)
	
	forvalues k=1(1)$nb_topcrops  {
	preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	count if crop_code==`c'
	if `r(N)'!=0 {
	keep if crop_code==`c'
	ren monocrop_ha `cn'_monocrop_ha
	count if `cn'_monocrop_ha!=0
	if `r(N)'!=0 {
	drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==.	
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' `cn'_monocrop {
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	
	gen dm_male = dm_gender == 1
	gen dm_female = dm_gender == 2
	gen dm_mixed = dm_gender == 3
	
	collapse (sum) *monocrop_ha* kgs_harv_mono* val_harv_mono* (max) dm* `cn'_monocrop `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed, by(hhid)
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (MWK)"
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
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_`cn'_monocrop_hh_area.dta", replace
	}
	}
restore
}

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_cost_inputs_long.dta", clear
merge m:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val, by(hhid plot_id dm_gender season input)
levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid plot_id dm_gender season) j(input) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	replace dm_gender2 = "unknown" if dm_gender==.
	drop dm_gender
	merge 1:m hhid plot_id season using "${MWI_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", nogen keep(3) keepusing(crop_code purestand)
	keep if purestand==1
	merge m:1 crop_code using "${MWI_IHS_W1_created_data}/Malawi_IHS_W1_cropname_table.dta", nogen keep(3) 
	
foreach cn in $topcropname_area {
preserve
	capture confirm file "${MWI_IHS_W1_created_data}\MWI_IHS_W1_`cn'_monocrop.dta"
	if !_rc {
	ren val* val*_`cn'_
	reshape wide val*, i(hhid plot_id season) j(dm_gender2) string
	merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_`cn'_monocrop.dta", nogen keep(3)
	count
	if(r(N) > 0){
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_*)
	}
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_inputs_`cn'.dta", replace
	}
	}
restore
}


********************************************************************************
* LIVESTOCK INCOME *
********************************************************************************
*Expenses
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r2.dta"
ren ea_id ea
rename ag_r28 cost_fodder_livestock
rename ag_r29 cost_vaccines_livestock
rename ag_r30 cost_othervet_livestock
gen cost_medical_livestock = cost_vaccines_livestock + cost_othervet_livestock
rename ag_r27 cost_hired_labor_livestock 
rename ag_r31 cost_input_livestock
recode cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock(.=0)
preserve
	keep if inlist(ag_r0a, 301, 302, 303, 304, 3304)
	egen cost_lrum = rowtotal (cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_hired_labor_livestock cost_input_livestock)
	gen costs_dairy=cost_lrum if ag_r0a==303
	collapse (sum) cost_lrum costs_dairy, by(hhid)
	lab var cost_lrum "Livestock expenses for large ruminants"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_lrum_expenses.dta", replace
restore 
preserve 
	rename ag_r0a livestock_code
	gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 311,313,315,319,3310,3314))
	recode species (0=.)
	la def species 1 "Large ruminants (calf, steer/heifer, cow, bull, ox)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
	la val species species
	
	collapse (sum) cost_medical_livestock, by (hhid species) 
	rename cost_medical_livestock ls_exp_med
		foreach i in ls_exp_med{
			gen `i'_lrum = `i' if species==1
			gen `i'_srum = `i' if species==2
			gen `i'_pigs = `i' if species==3
			gen `i'_equine = `i' if species==4
			gen `i'_poultry = `i' if species==5
		}
collapse (firstnm) *lrum *srum *pigs *equine *poultry, by(hhid)
	foreach i in ls_exp_med{
		gen `i' = .
	}
	la var ls_exp_med "Cost for vaccines and veterinary treatment for livestock"
	
	foreach i in ls_exp_med{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
	drop ls_exp_med
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_expenses_animal.dta", replace
restore 
collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines for livestock"
lab var cost_othervet_livestock "Cost for other veterinary treatment for livestock"
lab var cost_medical_livestock "Cost for vaccines, medicines and other veterinary treatment for livestock"
lab var cost_hired_labor_livestock
lab var cost_input_livestock "Cost for inputs for livestock"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_expenses.dta", replace

*Livestock products 
* Milk
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 no_of_months_milk
rename ag_s03a qty_milk_per_month
gen liters_milk_produced = no_of_months_milk * qty_milk_per_month if ag_s03b==1
lab var liters_milk_produced "Liters of milk produced in past 12 months"
gen liters_sold_12m = ag_s05a if ag_s05b==1
rename ag_s06 earnings_milk_year
gen price_per_liter = earnings_milk_year/liters_sold_12m if liters_sold_12m > 0
gen price_per_unit = price_per_liter
gen quantity_produced = liters_milk_produced
recode price_per_liter price_per_unit (0=.) 
keep hhid product_code liters_milk_produced price_per_liter price_per_unit quantity_produced earnings_milk_year 
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_milk.dta", replace

* Other livestock products
// Includes milk, eggs, honey, meat, hides/skins, and manure.
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a livestock_code
rename ag_s02 months_produced
rename ag_s03a quantity_month
rename ag_s03b quantity_month_unit

drop if livestock_code == 401
replace livestock_code = 404 if strmatch(ag_s0a_os, "CHICKEN") | strmatch(ag_s0a_os, "CHICKEN MEAT") | strmatch(ag_s0a_os, "DOVE") | strmatch(ag_s0a_os, "PIGEON")
replace quantity_month_unit =. if quantity_month_unit!=1     // milk, keeping only liters. 
replace quantity_month = round(quantity_month/0.06) if livestock_code==402 & quantity_month_unit==2
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs. 
replace quantity_month_unit = 3 if livestock_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if livestock_code==402 & quantity_month_unit!=3        // chicken eggs, pieces
replace quantity_month_unit =. if livestock_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
replace quantity_month = quantity_month*1.5 if livestock_code==404 & quantity_month_unit==3 // Vconverting pieces to kgs for meat, 
// using conversion for chicken. Cannot convert ltrs & buckets.  
replace quantity_month_unit = 2 if livestock_code== 404 & quantity_month_unit==3
replace quantity_month_unit =. if livestock_code==404 & quantity_month_unit!=2     //  now, only keeping kgs for meat
replace quantity_month_unit =. if livestock_code== 406 & quantity_month_unit!=3   //  skin and hide, pieces. Not converting kg and bucket.
replace quantity_month_unit =. if livestock_code== 407 & quantity_month_unit!=2 //  manure, using only obsns in kgs. 
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month // Units are liters for milk, pieces for eggs & skin, kg for meat and manure.
lab var quantity_produced "Quantity of this product produced in past year"
rename ag_s05a sales_quantity
rename ag_s05b sales_unit
replace sales_unit =. if livestock_code==401 & sales_unit!=1 // milk, liters only
replace sales_unit =. if livestock_code==402 & sales_unit!=3  // chicken eggs, pieces only
replace sales_unit =. if livestock_code== 403 & sales_unit!=3   // guinea fowl eggs, pieces only
replace sales_quantity = sales_quantity*1.5 if livestock_code==404 & sales_unit==3 
replace sales_unit = 2 if livestock_code== 404 & sales_unit==3 //  kgs for meat
replace sales_unit =. if livestock_code== 406 & sales_unit!=3   //  pieces for skin and hide, not converting kg (1 obsn).
replace sales_unit =. if livestock_code== 407 & quantity_month_unit!=2  //  kgs for manure, not converting liters(1 obsn), bucket, wheelbarrow & oxcart (2 obsns each)
rename ag_s06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
label define livestock_code_label 402 "Chicken Eggs" 403 "Guinea Fowl Eggs" 404 "Meat" 406 "Skin/Hide" 407 "Manure"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of milk per unit sold"
lab var price_per_unit_hh "Price of milk per unit sold at household level"
//drop if livestock_code ==. //does this work?
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_other.dta", replace

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_milk.dta", clear
append using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_other.dta"
recode price_per_unit (0=.)
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_long.dta", replace
//45,688
gen country = "MWI"
//Median prices 
foreach i in ea ta district region country {
	preserve
keep if price_per_unit !=. 
gen observation = 1
collapse (median) price_per_unit (rawsum) obs_`i'=obs [aw=weight], by (`i' livestock_code)
rename price_per_unit price_median_`i'
lab var price_median_`i' "Median price per unit for this livestock product in the `i'"
lab var obs_`i' "Number of sales observations for this livestock product in the `i'"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_prices_`i'.dta", replace
restore
}

*Household Livestock Products
foreach i in country region district ta ea {
	merge m:1 `i' livestock_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_prices_`i'.dta", nogen
}
drop country
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ta if price_per_unit==. & obs_ta >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
gen value_milk_produced = liters_milk_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==402|livestock_code==403
gen value_other_produced = quantity_produced * price_per_unit if livestock_code== 404|livestock_code==406|livestock_code==407
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)
*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livestock products produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of skins, meat and manure produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_livestock_products.dta", replace

*Ag Query
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_other.dta", clear
gen sales_eggs = earnings_sales if livestock_code == 402 | livestock_code == 403
collapse (sum) sales_eggs, by(hhid)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_sales_eggs.dta", replace

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_livestock_products.dta", clear
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products_milk.dta", nogen keep (1 3)
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_sales_eggs.dta", nogen keep (1 3)
ren earnings_milk_year sales_milk 
collapse (sum) value_milk_produced value_eggs_produced value_livestock_products value_other_produced share_livestock_prod_sold sales_livestock_products sales_milk sales_eggs, by (hhid)
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_products.dta", replace
 
* Manure (Dung)
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (hhid)
lab var sales_manure "Value of manure sold" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_manure.dta", replace

*Sales (live animals)
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
rename ag_r0a livestock_code
rename ag_r17 income_live_sales     // total value of sales of [livestock] live animals last 12m
rename ag_r16 number_sold          // # animals sold alive last 12 m
rename ag_r19 number_slaughtered  // # animals slaughtered last 12 m 
rename ea_id ea
rename ag_r11 value_livestock_purchases // tot. value of purchase of live animals last 12m
recode income_live_sales number_sold number_slaughtered value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animals sold"
recode price_per_animal (0=.) 
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district ta ea livestock_code number_sold income_live_sales number_slaughtered price_per_animal value_livestock_purchases
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_livestock_sales.dta", replace

*Implicit prices 
* ea Level
gen country="MWI"
foreach i in country district region ta ea { 
	preserve
	keep if price_per_animal !=.
gen observation = 1
collapse (median) price_median_`i'=price_per_animal (rawsum) obs_`i' = obs [aw=weight], by(`i' livestock_code)
lab var price_median_`i' "Median price per unit for this livestock in the `i'"
lab var obs_`i' "Number of sales observations for this livestock in the `i'"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_prices_`i'.dta", replace
	restore
}

foreach i in country region district ta ea {
	merge m:1 `i' livestock_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_prices_`i'.dta", nogen
}

replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered

collapse (sum) value_livestock_purchases value_lvstck_sold value_slaughtered, by (hhid)
drop if hhid==""
lab var value_livestock_purchases "Value of livestock purchases"
lab var value_lvstck_sold "Value of livestock sold live"
lab var value_slaughtered "Value of livestock slaughtered" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_sales.dta", replace

*TLU (Tropical Livestock Units)
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
rename ag_r0a lvstckid
gen tlu_coefficient=0.5 if (lvstckid==301|lvstckid==302|lvstckid==303|lvstckid==304) // calf (301), steer/heifer (302), cow (303), bull/ox (304)
replace tlu_coefficient=0.1 if (lvstckid==307|lvstckid==308) //goats (307), sheep (308)
replace tlu_coefficient=0.2 if (lvstckid==309) // pigs
replace tlu_coefficient=0.01 if (lvstckid==310|lvstckid==311|lvstckid==312|lvstckid==313|lvstckid==314|lvstckid==315|lvstckid==316) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
replace tlu_coefficient=0.3 if (lvstckid==305 | lvstckid==306) // donkey, mule/horse
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

rename lvstckid livestock_code
rename ag_r07 number_1yearago
rename ag_r02 number_today_total
rename ag_r03 number_today_exotic
preserve
keep if livestock_code==303
collapse (sum) number_today_total number_1yearago, by(hhid)
egen milk_animals = rowmean(number_today_total number_1yearago)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_milk_animals_hh.dta", replace
restore
drop if number_today_total ==. | number_today_total ==0
gen number_today_indigenous = number_today_total - number_today_exotic
recode number_today_total number_today_indigenous number_today_exotic (.=0)
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_total * tlu_coefficient
rename ag_r17 income_live_sales 
rename ag_r16 number_sold 

rename ag_r23b lost_disease_1
rename ag_r23d lost_disease_2
gen lost_disease = lost_disease_1+lost_disease_2
rename ag_r15 lost_stolen // # of livestock lost or stolen in last 12m
egen mean_12months = rowmean(number_today_total number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_stolen)	
gen share_imp_herd_cows = number_today_exotic/(number_today_total) if livestock_code==303 // only cows, not including calves, steer/heifer, ox and bull
gen species = (inlist(livestock_code,301,302,303,304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(inlist(livestock_code,305,306)) + 5*(inlist(livestock_code,310,311,312,313,314,315,316))
recode species (0=.)
la def species 1 "Large ruminants (calves, steer/heifer, cows, bulls, oxen)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, mules)" 5 "Poultry"
la val species species
ren ea_id ea

*Now to household level
*First, generating these values by species
preserve
collapse (firstnm) share_imp_herd_cows (sum) number_today_total number_1yearago animals_lost12months lost_disease number_today_exotic lvstck_holding=number_today_total, by(hhid species)
egen mean_12months = rowmean(number_today_total number_1yearago)
gen any_imp_herd = number_today_exotic!=0 if number_today_total!=. & number_today_total!=0

foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
collapse (sum) number_today_total number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(hhid)

*Overall any improved herd
gen any_imp_herd = number_today_exotic!=0 if number_today_total!=0
drop number_today_exotic number_today_total

foreach i in lvstck_holding animals_lost12months mean_12months lost_disease {
	gen `i' = .
}
la var lvstck_holding "Total number of livestock holdings (# of animals)"
la var any_imp_herd "At least one improved animal in herd"
la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
lab var animals_lost12months  "Total number of livestock  lost in last 12 months"
lab var  mean_12months  "Average number of livestock  today and 1  year ago"
lab var lost_disease "Total number of livestock lost to disease or injury" 

foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease {
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
drop lvstck_holding animals_lost12months mean_12months lost_disease /*ihs*/
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_herd_characteristics.dta", replace
restore

gen price_per_animal = income_live_sales / number_sold
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen keep(1 3)
gen country="MWI"
foreach i in country region district ta ea {
	merge m:1 `i' livestock_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_prices_`i'.dta", nogen
}
drop country 
recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today_total * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_TLU.dta", replace

*Livestock income
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_sales", clear
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_livestock_products.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_manure.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_expenses.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_TLU.dta", nogen


gen livestock_income = value_lvstck_sold + - value_livestock_purchases ///
+ (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) ///
- (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_income.dta", replace

********************************************************************************
* FISH INCOME *
********************************************************************************
*Fishing expenses  
// Method of calculating ft and pt weeks and days consistent with ag module indicators for rainy/dry seasons
use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_c.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_g.dta"
rename fs_c01a weeks_ft_fishing_high // FT weeks, high season
replace weeks_ft_fishing_high= fs_g01a if weeks_ft_fishing_high==. // FT weeks, low season
rename fs_c02a weeks_pt_fishing_high // PT weeks, high season
replace weeks_pt_fishing_high= fs_g02a if weeks_pt_fishing_high==. // PT weeks, low season
gen weeks_fishing = weeks_ft_fishing_high + weeks_pt_fishing_high

rename fs_c01b days_ft_fishing_high // FT, days, high season
replace days_ft_fishing_high= fs_g01b if days_ft_fishing_high==. // FT days, low season
rename fs_c02b days_pt_fishing_high // PT days, high season
replace days_pt_fishing_high= fs_g02b if days_pt_fishing_high==. // PT days, low season
gen days_per_week = days_ft_fishing_high + days_pt_fishing_high

recode weeks_fishing days_per_week (.=0)
collapse (max) weeks_fishing days_per_week, by (hhid) 
keep hhid weeks_fishing days_per_week
lab var weeks_fishing "Weeks spent working as a fisherman (maximum observed across individuals in household)"
lab var days_per_week "Days per week spent working as a fisherman (maximum observed across individuals in household)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weeks_fishing.dta", replace

use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_d1.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_h2.dta"
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weeks_fishing.dta"
rename weeks_fishing weeks
ren fs_h13 fuel_costs_week
rename fs_h12 rental_costs_fishing_boat
rename fs_d06 rental_costs_fishing_gear
gen rental_costs_fishing = rental_costs_fishing_boat + rental_costs_fishing_gear
rename fs_h10 purchase_costs_fishing_boat // Boat/Engine purchase.
rename fs_d04 purchase_costs_fishing_gear
gen purchase_costs_fishing = purchase_costs_fishing_boat + purchase_costs_fishing_gear

recode weeks fuel_costs_week rental_costs_fishing purchase_costs_fishing(.=0)
gen cost_fuel = fuel_costs_week * weeks
collapse (sum) cost_fuel rental_costs_fishing, by (hhid)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fishing_expenses_1.dta", replace // Not including hired labor costs, keeping consistent with other LSMS-ISA countries. May reassess.

* Other fishing costs
use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_d3.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_h3.dta"
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weeks_fishing", nogen
rename fs_d24a total_cost_high // total other costs in high season, only 6 obsns. 
replace total_cost_high=fs_h24a if total_cost_high==.
rename fs_d24b unit
replace unit=fs_h24b if unit==. 
gen cost_paid = total_cost_high if unit== 2  // season
replace cost_paid = total_cost_high * weeks_fishing if unit==1 // weeks
collapse (sum) cost_paid, by (hhid)
lab var cost_paid "Other costs paid for fishing activities"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fishing_expenses_2.dta", replace

* Fish Prices
use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_e1.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=11) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season - in W1, omits two obs that had fresh and sun-dried entries
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b fish_quantity_unit
replace fish_quantity_unit=fs_i06b if fish_quantity_unit==.
rename fs_e08b unit  // piece, dozen/bundle, kg, small basket, large basket //Assuming "small pail" and "10 liter pail" under unit-other are the same. 
gen price_per_unit = fs_e08d
replace price_per_unit = fs_i08d if price_per_unit==.
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta"
drop if _merge==2
drop _merge
recode price_per_unit (0=.) 
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==11
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_prices.dta", replace

* Value of fish harvest & sales 
use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_e1.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=11) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b unit  // piece, dozen/bundle, kg, small basket, large basket
merge m:1 fish_code unit using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_prices.dta"
drop if _merge==2
drop _merge
rename fs_e08a quantity_1
replace quantity_1=fs_i08a if quantity_1==.
rename fs_e08b unit_1
replace unit_1=fs_i08b if unit_1==.
gen price_unit_1 = fs_e08d
replace price_unit_1=fs_i08d if price_unit_1==.
rename fs_e08e quantity_2
replace quantity_2=fs_i08e if quantity_2==.
rename fs_e08f unit_2 
replace unit_2= fs_i08f if unit_2==.
gen price_unit_2=fs_e08h
replace price_unit_2=fs_i08h if price_unit_2==.
replace price_unit_1 = price_per_unit_median if price_unit_1==. //Replace w/ median value if unit_1 value is missing
//Fish price code failed to generate a per-piece price for utaka even though some households sold that fish in those units
recode quantity_1 quantity_2 fish_quantity_year price_unit_2 (.=0) //need to include price_unit_2 or income calculation will fail
gen income_fish_sales = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest = (fish_quantity_year * price_unit_1) if unit==unit_1 
replace value_fish_harvest = (fish_quantity_year * price_per_unit_median) if value_fish_harvest==.
collapse (sum) value_fish_harvest income_fish_sales, by (hhid)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
//Need some sort of SOP for when value_harvest > 0 but income = 0 due to missing information
//Questionable values: small dataset and it looks like only some of the prices were recorded
//per piece. Others look like they are totals. 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_income.dta", replace

********************************************************************************
* SELF-EMPLOYMENT INCOME *
********************************************************************************
*Self-employment income
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_n2.dta", clear
rename hh_n40 last_months_profit
gen self_employed_yesno = .
replace self_employed_yesno = 1 if last_months_profit !=.
replace self_employed_yesno = 0 if last_months_profit == .
collapse (max) self_employed_yesno (sum) last_months_profit, by(hhid)
lab var self_employed_yesno "1=Household has at least one member with self-employment income"
drop if self != 1
ren last_months_profit self_employ_income
lab var self_employ_income "self employment income in previous month"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_self_employment_income.dta", replace

*Fish trading
use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_c.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_g.dta"
rename fs_c04a weeks_fish_trading 
replace weeks_fish_trading=fs_g04a if weeks_fish_trading==.
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (hhid) 
keep hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weeks_fish_trading.dta", replace

use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_f1.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_f2.dta"
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_j1.dta"
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_j2.dta"
rename fs_f02a quant_fish_purchased_1
replace quant_fish_purchased_1= fs_j02a if quant_fish_purchased_1==.
rename fs_f02d price_fish_purchased_1
replace price_fish_purchased_1= fs_j02d if price_fish_purchased_1==.
rename fs_f02e quant_fish_purchased_2
replace quant_fish_purchased_2= fs_j02e if quant_fish_purchased_2==.
rename fs_f02h price_fish_purchased_2
replace price_fish_purchased_2= fs_j02h if price_fish_purchased_2==.
rename fs_f03a quant_fish_sold_1
replace quant_fish_sold_1=fs_j03a if quant_fish_sold_1==.
rename fs_f03d price_fish_sold_1
replace price_fish_sold_1=fs_j03d if price_fish_sold_1==.
rename fs_f03e quant_fish_sold_2
replace quant_fish_sold_2=fs_j03e if quant_fish_sold_2==.
rename fs_f03h price_fish_sold_2
replace price_fish_sold_2=fs_j03h if price_fish_sold_2==.
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 ///
quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 (.=0)

gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2)
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit, by (hhid)
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep hhid weekly_fishtrade_profit
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_trading_revenues.dta", replace   

use "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_f2.dta", clear
append using "${MWI_IHS_W1_appended_data}\Fisheries\fs_mod_j2.dta"
rename fs_f05 weekly_costs_for_fish_trading //  Other costs: Hired labor, transport, packaging, ice, tax.
replace weekly_costs_for_fish_trading=fs_j05 if weekly_costs_for_fish_trading==.
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (hhid)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep hhid weekly_costs_for_fish_trading
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_trading_other_costs.dta", replace

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weeks_fish_trading.dta", clear
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_trading_revenues.dta" 
drop _merge
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep hhid fish_trading_income
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_trading_income.dta", replace

//The results are messy due to the underlying data rather than coding errors. I think the sample
//size is a little to small to effectively deal with outliers.

********************************************************************************
* NON-AG WAGE INCOME *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_e.dta", clear
rename hh_e18 wage_yesno // In last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
rename hh_e22 number_months  //# of months worked at main wage job in last 12m. 
rename hh_e23 number_weeks   //# of weeks/month worked at main wage job in last 12m. 
rename hh_e24 number_hours   //# of hours/week worked at main wage job in last 12m. 
rename hh_e25 most_recent_payment // amount of last payment

replace most_recent_payment=. if inlist(hh_e19b,62 63 64) // main wage job
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if inlist(hh_e19b,62,63,64) // code of main wage job 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if hh_e33b== 62  // code of secondary wage job
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38 secwage_hours_pastweek // What was the average hours per week?
gen annual_salary_cash=.
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5  // month
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period== 4 // week
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==3  // day
gen wage_salary_other=.
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5 // month
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==4 //week
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==3 //day
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_wage_income.dta", replace

********************************************************************************
* AG WAGE INCOME *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_e.dta", clear
rename hh_e18 wage_yesno //  last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
* last 12m, work as an unpaid apprentice OR employee for a wage, salary, commission or any payment in kind; incl. paid apprenticeship, domestic work or paid farm work 
rename hh_e22 number_months  //# of months worked at main wage job in last 12m. During the last 12 months, for how many months did [NAME] work in this job?
rename hh_e23 number_weeks  // # of weeks/month worked at main wage job in last 12m.  During the last 12 months, how many weeks per month did [NAME] usually work in this job?
rename hh_e24 number_hours  // # of hours/week worked at main wage job in last 12m.  During the last 12 months, how many hours per week did [NAME] usually work in this job?
rename hh_e25 most_recent_payment // amount of last payment
gen agwage = 1 if inlist(hh_e19b,62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers
gen secagwage = 1 if hh_e33b==62 //62: Agriculture and animal husbandry worker
replace most_recent_payment = . if agwage!=1
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if agwage!=1 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if secagwage!=1  // code of secondary wage job
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38 secwage_hours_pastweek // Avg hours per week

gen annual_salary_cash=.
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5  // month
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period== 4 // week
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==3  // day
gen wage_salary_other=.
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5 // month
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==4 //week
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==3 //day
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (hhid)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_agwage_income.dta", replace 

********************************************************************************
* OTHER INCOME *
********************************************************************************
use "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_crop_prices_for_wages.dta", clear
keep if crop_code==1 //instrument measures food assistance in maize
ren hh_price_mean price_kg
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_maize_prices.dta", replace

use "${MWI_IHS_W1_appended_data}\Household\hh_mod_p.dta", clear
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_r.dta"
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_o.dta"
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_maize_prices.dta"
rename hh_p0a income_source
rename hh_p02 amount_income
ren hh_p01 received_income
gen rental_income=amount_income if received_income==1 & inlist(income_source, 106, 107, 108, 109) // non-ag land rental, house/apt rental, shope/store rental, vehicle rental
gen pension_investment_income=amount_income if received_income==1 &  income_source==105| income_source==104 | income_source==116 // pension & savings/interest/investment income+ private pension
gen asset_sale_income=amount_income if received_income==1 &  inlist(income_source, 110,111,112) // real estate sales, non-ag hh asset sale income, hh ag/fish asset sale income
gen other_income=amount_income if received_income==1 &  inlist(income_source, 113, 114, 115) // inheritance, lottery, other income
rename hh_r0a prog_code
gen assistance_cash= hh_r02a if inlist(prog_code, 104,108,111,112) // Cash from MASAF, Non-MASAF pub. works,
*inputs-for-work, sec. level scholarships, tert. level. scholarships, dir. Cash Tr. from govt, DCT other
gen assistance_food= hh_r02b if inlist(prog_code, 102, 103) // Cash value of in-kind assistance from free food and Food for work. 
replace assistance_food=hh_r02c*price_kg if prog_code==101 & crop_code==1 // cash value of free maize, imputed from hh. median prices. 
gen assistance_inkind=hh_r02b if inlist(prog_code, 104, 108, 111, 112) // cash value of in-kind assistance from MASAF
* inputs-for-work, scholarships (sec. & tert.), direct cash transfers (govt & other)
gen cash_received=1 if income_source== 101 // Cash transfers/gifts from indivs. 
gen inkind_gifts_received=1 if inlist(income_source, 102,103) // Food & In-kind transfers/gifts from indivs.
rename hh_o14 cash_remittance
rename hh_o17 in_kind_remittance
recode rental_income pension_investment_income asset_sale_income other_income assistance_cash assistance_food assistance_inkind cash_received inkind_gifts_received cash_remittance in_kind_remittance (.=0)

gen remittance_income = cash_received + inkind_gifts_received + cash_remittance + in_kind_remittance
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) rental_income pension_investment_income asset_sale_income other_income remittance_income assistance_income, by (hhid)
lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_other_income.dta", replace

*Land rental
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear // * The below code calculates only agricultural land rental income
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta"
rename ag_d19a land_rental_cash_rainy_recd 
rename ag_d19b land_rental_inkind_rainy_recd
rename ag_d19c land_rental_cash_rainy_owed
rename ag_d19d land_rental_inkind_rainy_owed
rename ag_k20a land_rental_cash_dry_recd 
rename ag_k20b land_rental_inkind_dry_recd
rename ag_k20c land_rental_cash_dry_owed
rename ag_k20d land_rental_inkind_dry_owed
recode land_rental_cash_rainy_recd land_rental_inkind_rainy_recd land_rental_cash_rainy_owed land_rental_inkind_rainy_owed land_rental_cash_dry_recd land_rental_inkind_dry_recd land_rental_cash_dry_owed land_rental_inkind_dry_owed (.=0)
gen land_rental_income_rainyseason= land_rental_cash_rainy_recd + land_rental_inkind_rainy_recd + land_rental_cash_rainy_owed + land_rental_inkind_rainy_owed
gen land_rental_income_dryseason= land_rental_cash_dry_recd + land_rental_inkind_dry_recd + land_rental_cash_dry_owed + land_rental_inkind_dry_owed 
gen land_rental_income = land_rental_income_rainyseason + land_rental_income_dryseason
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rental_income.dta", replace

********************************************************************************
* FARM SIZE / LAND SIZE *
********************************************************************************

*Determining whether crops were grown on a plot
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_g.dta", clear
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_m.dta"
ren ag_g0b plot_id
drop if plot_id==""
drop if ag_g0d==. // crop code
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid plot_id)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_crops_grown.dta", replace

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear
rename ag_k0a plot_id
ren ea_id ea
tempfile ag_mod_k_numeric
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ag_mod_k_temp.dta", replace  // Renaming plot ids, to work with Module D and K together.
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d00 plot_id
append using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ag_mod_k_temp.dta"
gen cultivated = (ag_d14==1 | ag_k15==1) //  cultivated plots in rainy or dry seasons
collapse (max) cultivated, by (hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_parcels_cultivated.dta", replace

preserve
ren cultivated cultivate
keep if cultivate==1
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plots_cultivate.dta", replace // for plot-level variables
restore

merge 1:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta",
drop if _merge==2
keep if cultivated==1
collapse (sum) field_size, by (hhid)
rename field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_size.dta", replace

* All agricultural land
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d00 plot_id
append using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ag_mod_k_temp.dta"
drop if plot_id==""
merge m:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_crops_grown.dta", nogen

gen rented_out = (ag_d14==2 |ag_k15==2)
gen cultivated_dry = (ag_k15==1)
bys hhid plot_id: egen plot_cult_dry = max(cultivated_dry)
replace rented_out = 0 if plot_cult_dry==1 //  If cultivated in short season, not considered rented out in long season.

drop if rented_out==1 & crop_grown!=1
gen agland = (ag_d14==1 | ag_d14==4 |ag_k15==1 | ag_k15==4) // All cultivated AND fallow plots, forests/woodlot & pasture is captured within "other" (can't be separated out)

drop if agland!=1 & crop_grown==.
collapse (max) agland, by (hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_parcels_agland.dta", replace

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_parcels_agland.dta", clear
merge 1:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta"
drop if _merge==2
collapse (sum) field_size, by (hhid)
rename field_size farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105)
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmsize_all_agland.dta", replace

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
append using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ag_mod_k_temp.dta"
drop if plot_id=="" //Drops a lot of obs
gen rented_out = (ag_d14==2 | ag_d14==3 | ag_k15==2 | ag_k15==3) // rented out (2) & gave out for free (3)
gen cultivated_dry = (ag_k15==1)
bys hhid plot_id: egen plot_cult_dry = max(cultivated_dry)
replace rented_out = 0 if plot_cult_dry==1 // If cultivated in dry season, not considered rented out in rainy season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_parcels_held.dta", replace

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_parcels_held.dta", clear
merge 1:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta"
drop if _merge==2
collapse (sum) field_size, by (hhid)
rename field_size land_size
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_plot_areas.dta", clear
rename field_size land_size_total
collapse (sum) land_size_total, by(hhid)
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_size_total.dta", replace

********************************************************************************
* OFF-FARM HOURS *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_e.dta", clear
gen hrs_main_wage_off_farm = hh_e24 if !inlist(hh_e19b, 62, 63, 64) & hh_e19b != .
gen hrs_sec_wage_off_farm=hh_e38 if hh_e33b!=62 & hh_e33b!=.
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm)
gen  hrs_main_wage_on_farm = hh_e24 if inlist(hh_e19b, 62, 63, 64) & hh_e19b!=. 		 
gen  hrs_sec_wage_on_farm = hh_e38 if hh_e33b == 62 & hh_e33b != .	 
egen hrs_wage_on_farm = rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm) 
drop *main* *sec*
gen hrs_unpaid_off_farm = hh_e52 //Q= During the last 7days, approximately how many hours did you work at this unpaid apprenticeship?

recode hh_e06 hh_e05 (.=0)
gen  hrs_domest_fire_fuel=(hh_e06+ hh_e05)*7 // hrs worked last week
ren hh_e07 hrs_ag_activ
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
la var hrs_domest_fire_fuel  "Total household hours - collecting fuel and making fire and collecting water" 
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
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_off_farm_hours.dta", replace

********************************************************************************
* FARM LABOR *
********************************************************************************
** Family labor
* Rainy Season
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
rename ag_d47c landprep_women  // # of days women hired for land preparation, planting, ridging, weeding and fertilizing
rename ag_d47a landprep_men   // # of days men hired for land preparation, planting, ridging, weeding and fertilizing
rename ag_d47e landprep_child // # of days children hired for land preparation, planting, ridging, weeding and fertilizing 
rename ag_d48a harvest_men    // # of days men hired for harvesting
rename ag_d48c harvest_women // # of days women hired for harvesting
rename ag_d48e harvest_child // # of days children hired for harvesting
recode landprep_women landprep_men landprep_child harvest_men harvest_women harvest_child (.=0)
egen days_hired = rowtotal(landprep_women landprep_men landprep_child harvest_men harvest_women harvest_child) 
recode ag_d42c ag_d42g ag_d42k ag_d42o(.=0)  // # of days per week spent by hh.members (upto 4) in land prep/planting
egen days_flab_landprep = rowtotal(ag_d42c ag_d42g ag_d42k ag_d42o)
recode ag_d43c ag_d43g ag_d43k ag_d43o (.=0) // # of days per week spent by hh.members (upto 4) in weeding, fertilizing and/or any other non-harvest activity
egen days_flab_weeding = rowtotal(ag_d43c ag_d43g ag_d43k ag_d43o)
recode ag_d44c ag_d44g ag_d44k ag_d44o (.=0) // # of days per week spent by hh.members (upto 4) in harvesting
egen days_flab_harvest = rowtotal(ag_d44c ag_d44g ag_d44k ag_d44o)
gen days_famlabor = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren ag_d00 plot_id
collapse (sum) days_hired days_famlabor, by (hhid plot_id)
gen season=0
//lab var days_hired_rainyseason  "Workdays for hired labor (crops) in rainy season"
//lab var days_famlabor_rainyseason  "Workdays for family labor (crops) in rainy season"
save "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_rainyseason.dta", replace

* Dry Season
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta", clear
rename ag_k46a no_days_men_all
rename ag_k46c no_days_women_all 
rename ag_k46e no_days_chldrn_all 
recode no_days_men_all no_days_women_all no_days_chldrn_all(.=0)
egen days_hired = rowtotal(no_days_men_all no_days_women_all no_days_chldrn_all) 
recode ag_k43c ag_k43g ag_k43k ag_k43o(.=0) // # of days per week spent by hh.members (upto 4) in land prep/planting
egen days_flab_landprep = rowtotal(ag_k43c ag_k43g ag_k43k ag_k43o)
recode ag_k44c ag_k44g ag_k44k ag_k44o (.=0) // # of days per week spent by hh.members (upto 4) in weeding, fertilizing and/or any other non-harvest activity
egen days_flab_weeding = rowtotal(ag_k44c ag_k44g ag_k44k ag_k44o)
recode ag_k45c ag_k45g ag_k45k ag_k45o(.=0) // # of days per week spent by hh.members (upto 4) in harvesting
egen days_flab_harvest = rowtotal(ag_k45c ag_k45g ag_k45k ag_k45o)
gen days_famlabor = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren ag_k0a plot_id
collapse (sum) days_hired days_famlabor, by (hhid plot_id)
gen season=1
//lab var days_hired_dryseason  "Workdays for hired labor (crops) in dry season"
//lab var days_famlabor_dryseason  "Workdays for family labor (crops) in dry season"
save "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_dryseason.dta", replace


*Hired Labor
use "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_rainyseason.dta", clear
append using "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_plot_farmlabor_dryseason.dta"
recode days*  (.=0)
collapse (sum) labor_hired=days_hired labor_family=days_famlabor, by(hhid plot_id season)
gen labor_total = labor_family
lab var labor_total "Total labor days (family, hired, or other) allocated to the plot"
lab var labor_hired "Total labor days (hired) allocated to the plot"
lab var labor_family "Total labor days (family) allocated to the plot"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_family_hired_labor.dta", replace

********************************************************************************
* VACCINE USAGE *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
gen vac_animal=ag_r24>0
replace vac_animal = 0 if ag_r24==0  
replace vac_animal = . if ag_r24==. //  4092 observations on a hh-animal level

*Disagregating vaccine usage by animal type 
rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(inlist(livestock_code,305, 306)) + 5*(inlist(livestock_code, 310,311,312,313,314,315,316))
recode species (0=.)
la def species 1 "Large ruminants (calf, steer/heifer, cow, bull, ox)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
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
lab var vac_animal "1=Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_vaccine.dta", replace

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
gen all_vac_animal=ag_r24>0
replace all_vac_animal = 0 if ag_r24==0  
replace all_vac_animal = . if ag_r24==.
keep hhid ag_r06a ag_r06b all_vac_animal
ren ag_r06a farmerid1
ren ag_r06b farmerid2
gen t=1
gen patid=sum(t)
reshape long farmerid, i(patid) j(idnum)
drop t patid

collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_vaccine.dta", replace

********************************************************************************
* ANIMAL HEALTH - DISEASES *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
gen disease_animal = 1 if ag_r22==1 // Answered "yes" for "Did livestock suffer from any disease in last 12m?"
replace disease_animal = 0 if ag_r22==2
replace disease_animal = . if (ag_r22==.) 
gen disease_ASF = ag_r23a==14  //  African swine fever
gen disease_amapl = ag_r23a==22 // Amaplasmosis
gen disease_bruc = ag_r23a== 1 // Brucelosis
gen disease_mange = ag_r23a==20 // Mange
gen disease_NC= ag_r23a==10 // New Castle disease
gen disease_spox= ag_r23a==11 // Small pox
gen disease_other = inrange(ag_r23a, 2, 9) | inrange(ag_r23a, 12, 13) | inrange(ag_r23a,15,19) | ag_r23a==21 | inrange(ag_r23a,22,25)

rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(inlist(livestock_code,305, 306)) + 5*(inlist(livestock_code, 310,311,312,313,314,315,316))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

*A loop to create species variables
foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox disease_other{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) disease_*, by (hhid)
lab var disease_animal "1= Household has animal that suffered from disease"
lab var disease_ASF "1= Household has animal that suffered from African Swine Fever"
lab var disease_amapl"1= Household has animal that suffered from amaplasmosis disease"
lab var disease_bruc"1= Household has animal that suffered from brucelosis"
lab var disease_mange "1= Household has animal that suffered from mange disease"
lab var disease_NC "1= Household has animal that suffered from New Castle disease"
lab var disease_spox "1= Household has animal that suffered from small pox"
lab var disease_other "1=Household has animal that had another disease"

	foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox disease_other{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}

save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_diseases.dta", replace

********************************************************************************
* LIVESTOCK WATER, FEEDING, AND HOUSING *
********************************************************************************
*Omitting this section. MWI W1 has questions about feed and other inputs,
*but nothing about water/housing.


********************************************************************************
* USE OF INORGANIC FERTILIZER *
********************************************************************************
use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_d.dta", clear
append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_k.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_d.dta", clear
append using "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_k.dta" 
gen all_use_inorg_fert=(ag_d38==1 | ag_k39==1)

ren ag_d01 farmerid
replace farmerid= ag_k02 if farmerid==.

collapse (max) all_use_inorg_fert , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_fert_use.dta", replace

********************************************************************************
* PLOT MANAGERS *
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta", clear
collapse (max) use_imprv_seed use_hybrid_seed, by(hhid plot_id crop_code)
tempfile imprv_hybr_seed
save `imprv_hybr_seed'

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_cost_inputs_long.dta", clear
gen use_herb = input == "herb"
gen use_pest = input == "pest"
gen use_org_fert = input == "orgfert"
gen use_inorg_fert = input == "inorg"
merge m:m hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_dm_ids.dta", nogen keep(1 3)
collapse (max) use_*, by(hhid indiv female) //These will all be 1's because we've only got plots with recorded inputs right now
tempfile plotfertilizer
save `plotfertilizer'

use `imprv_hybr_seed', clear
merge m:m hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_dm_ids.dta", nogen keep(1 3)
merge m:1 crop_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropname_table.dta", nogen keep(3) 
ren use_imprv_seed all_imprv_seed_
ren use_hybrid_seed all_hybrid_seed_
drop crop_code
collapse (max) all*, by(hhid indiv female crop_name)
gen farmer_ = 1
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
merge m:m hhid indiv female using `plotfertilizer', nogen
recode farmer_* (.=0)
ren farmer_* *_farmer

collapse (max) use_* all_* *_farmer, by(hhid indiv female)	
recode use* all* (.=0)
egen all_imprv_seed_use = rowmax(all_imprv_*)
egen all_hybrid_seed_use = rowmax(all_hybrid_seed_*)
gen all_org_fert_use = use_org_fert
gen all_inorg_fert_use = use_inorg_fert
gen all_pest_use = use_pest 
gen all_herb_use=use_herb
forvalues k=1/$nb_topcrops {
	local v : word `k' of $topcropname_area
	local vn : word `k' of $topcropname_area_full
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `vn'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `vn'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `vn'"
}
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
lab var all_hybrid_seed_use "1 = Individual farmer (plot manager) uses hybrid seeds"
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_farmer_input_use.dta", replace 

ren all_hybrid_seed_* hybrid_seed_*
ren all_imprv_seed_* imprv_seed_*	
collapse (max) use_* imprv_seed_* hybrid_seed_*, by(hhid)	
recode use_* imprv_* hybrid_* (.=0)
ren imprv_seed_use use_imprv_seed 
ren hybrid_seed_use use_hybrid_seed
la var use_imprv_seed "1 = household uses improved seed for at least one crop"	
la var use_hybrid_seed "1 = household uses hybrid seed for at least one crop"
la var use_inorg_fert "1=household uses inorganic fertilizer on at least one plot"
la var use_org_fert "1=household uses organic fertilizer on at least one plot"	
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_input_use.dta", replace		

********************************************************************************
* REACHED BY AG EXTENSION *
********************************************************************************
use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_t1.dta", clear
ren ag_t01 receive_advice
ren ag_t02 sourceids
**Government Extension
gen advice_gov = (sourceid==1|sourceid==3 & receive_advice==1) // govt ag extension & govt. fishery extension. 
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1) // ag coop/farmers association
**Large Scale Farmer
gen advice_farmer =(sourceid== 10 & receive_advice==1) // lead farmers
**Radio/TV
gen advice_electronicmedia = (sourceid==12 & receive_advice==1) // electronic media:TV/Radio
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1) // handouts, flyers
**Neighbor
gen advice_neigh = (sourceid==11 & receive_advice==1) // Other farmers: neighbors, relatives
** Farmer Field Days
gen advice_ffd = (sourceid==7 & receive_advice==1)
** Village Ag Extension Meeting
gen advice_village = (sourceid==8 & receive_advice==1)
** Ag Ext. Course
gen advice_course= (sourceid==9 & receive_advice==1)
** Private Ag. Extension 
gen advice_pvt= (sourceid==2 & receive_advice==1)
**Other
gen advice_other = (sourceid== 14 & receive_advice==1)

**advice on prices from extension
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_pvt)
gen ext_reach_unspecified=(advice_neigh==1 | advice_pub==1 | advice_other==1 | advice_farmer==1 | advice_ffd==1 | advice_course==1 | advice_village==1)
gen ext_reach_ict=(advice_electronicmedia==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1)

**irrigation rainy
preserve
use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_d.dta", clear
gen useirrigation1=inlist(ag_d28a, 1, 3, 4)|inlist(ag_d28a_os,"CANALS", "CANALS OF WATER FROM NANNANKOKWE RIVER","DAM FROM UPLAND")|inlist(ag_d28b,1) //1=divert stream,3=hand pump,4=treadle pump
collapse (max) useirrigation1, by(hhid)
tempfile irrigation_rainy
save `irrigation_rainy'

use "${MWI_IHS_W1_appended_data}/Agriculture/ag_mod_k.dta", clear
gen useirrigation2=inlist(ag_k29a, 1, 3, 4, 5, 6)|inlist(ag_k29a_os,"CANALS", "CANALS OF WATER FROM NANNANKOKWE RIVER","DAM FROM UPLAND")|inlist(ag_k29b,1,3,4) //1=divert stream,3=hand pump,4=treadle pump,5=motor pump
collapse (max) useirrigation2, by(hhid)
tempfile irrigation_dry
save `irrigation_dry'
restore

collapse (max) ext_reach_*, by (hhid)
merge m:1 hhid using `irrigation_rainy', keep(1 3) keepusing(useirrigation1) nogen
merge m:1 hhid using `irrigation_dry', keep(1 3) keepusing(useirrigation2) nogen
gen useirrigation=useirrigation1==1|useirrigation2==1
keep hhid ext_reach_* useirrigation
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
lab var useirrigation "1 = Household irrigated at least one field during the current agricultural season?"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_any_ext.dta", replace

********************************************************************************
* MOBILE PHONE OWNERSHIP *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_f.dta", clear
ren hh_f34 mobile_owned
recode mobile_owned (.=0)
drop if mobile_owned == 0
keep hhid mobile_owned
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_mobile_own.dta", replace

********************************************************************************
* USE OF FORMAL FINANCIAL SERVICES *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_f.dta", clear
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_s1.dta"
gen borrow_bank= hh_s04==10 
gen borrow_relative=hh_s04==1
gen borrow_moneylender=hh_s04==4
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
gen borrow_other_fin=hh_s04==7|hh_s04==8|hh_s04==9
gen borrow_neigh=hh_s04==2
gen borrow_employer=hh_s04==5
gen borrow_ngo=hh_s04==11
gen borrow_other=hh_s04==12


gen use_fin_serv_credit= borrow_bank==1  | borrow_other_fin==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all= use_fin_serv_credit==1 |  use_fin_serv_others==1 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fin_serv.dta", replace

********************************************************************************
* MILK PRODUCTIVITY *
********************************************************************************
*Total production
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked
rename ag_s03a qty_milk_per_month
gen liters_milk_produced = months_milked * qty_milk_per_month if ag_s03b==1 | ag_s03b == 7 // Liters only, omits kg (1), piece (3), bucket (2)
replace liters_milk_produced = liters_milk_produced * 1.5 if ag_s03b == 7 // Units [Other (specify)] == "1500ML"
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_milk_animals_hh.dta"
gen liters_per_cow=liters_milk_produced/milk_animals
lab var liters_milk_produced "Liters of milk produced in past 12 months"
lab var months_milked "Average months milked in last year (household)"
drop if liters_milk_produced==.
keep hhid product_code months_milked liters_milk_produced liters_per_cow milk_animals
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_milk_animals.dta", replace

********************************************************************************
* EGG PRODUCTIVITY *
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta", clear
rename ag_r0a livestock_code
gen poultry_owned = ag_r02 if inlist(livestock_code, 311, 3310, 3314) //This is probably an overcount because nonlocal layers and broilers are combined as are guinea fowl and turkeys. 
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_s.dta", clear
rename ag_s0a product_code
keep if product_code==402 | product_code==403
rename ag_s02 eggs_months // # of months in past year that hh. produced eggs
rename ag_s03a eggs_per_month  // avg. qty of eggs per month in past year
rename ag_s03b quantity_month_unit
replace eggs_per_month = round(eggs_per_month/0.06) if product_code==402 & quantity_month_unit==2
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs for eggs 
replace quantity_month_unit = 3 if product_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if product_code==402 & quantity_month_unit!=3  // chicken eggs, pieces
replace quantity_month_unit =. if product_code== 403 & quantity_month_unit!=3 // guinea fowl eggs, pieces
recode eggs_months eggs_per_month (.=0)
gen eggs_total_year = eggs_months* eggs_per_month // Units are pieces for eggs 
collapse (sum) eggs_total_year eggs_per_month (max) eggs_months, by (hhid) // Collapsing chicken & guinea fowl eggs
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months eggs_per_month eggs_total_year poultry_owned 
gen egg_poultry_year = eggs_total_year/poultry_owned 
 
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_eggs_animals.dta", replace

********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE *
********************************************************************************
use "${MWI_IHS_W1_created_data}/MWI_IHS_W1_all_plots.dta", clear
collapse (sum) ha_planted, by(hhid plot_id purestand field_size) // using area_meas_hectares instead of field_size
reshape long ha_, i(hhid plot_id purestand field_size) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(hhid plot_id dm_gender exp)
reshape wide cost_, i(hhid plot_id dm_gender) j(exp) string
recode cost_exp cost_imp (.=0) // note: no obs where cost_imp > 0
gen cost_total=cost_imp+cost_exp
drop cost_imp
collapse (sum) cost_* (max) dm_gender, by(hhid plot_id)
merge 1:m hhid plot_id using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
recode cost_exp_ha_ cost_total_ha_ (.=0)
collapse (mean) cost*ha_ [aw=field_size], by(hhid dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(hhid dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid) j(dm_gender2) string
ren *_planted_* *_*

foreach i in male female mixed unknown {
	la var cost_exp_ha_`i' "Explicit cost per hectare by `i'-managed plots"
	la var cost_total_ha_`i' "Total cost per hectare by `i'-managed plots"
	}
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropcosts.dta", replace

********************************************************************************
* RATE OF FERTILIZER APPLICATION * - CG updated 5.8.25
********************************************************************************
use "${MWI_IHS_W1_created_data}/MWI_IHS_W1_planted_area.dta", clear
merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_fertilizer_kg_application_plot.dta", nogen keep(1 3)
merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_decision_makers.dta", nogen keep(1 3)
merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_irrigation.dta", nogen keep(1 3) 
drop if ha_planted==0
recode plot_irr (.=0)
gen ha_irr = plot_irr * ha_planted
unab vars : *kg 
local vars `vars' ha_irr ha_planted
recode *kg (.=0)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
ren *kg *kg_
ren ha_planted ha_planted_
ren ha_irr ha_irr_
reshape wide *_, i(hhid plot_id season) j(dm_gender2) string
collapse (sum) ha_planted_* *kg* ha_irr_*, by(hhid)
foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}

drop *_unknown

/*
foreach i in ha_planted fert_inorg_kg fert_org_kg pest_kg herb_kg {
	egen `i' = rowtotal(`i'_*)
}*/
//Some high inorg fert rates as a result of large tonnages on small plots. 
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
lab var urea_kg "Urea (kgs) for household"
lab var npk_kg "NPK fertilizer (kgs) for household"
lab var n_kg "Units of Nitrogen (kgs) for household"
lab var p_kg "Units of Phosphate (kgs) for household"
lab var k_kg "Units of Potash (kgs) for household"
lab var n_org_kg "Units of organic Nitrogen (kgs) for household"
lab var nps_kg "Units of NPS (kgs) for household"
lab var dap_kg "Units of DAP (kgs) for household"
lab var can_kg "Units of CAN (kgs) for household"
la var ha_irr "Planted area under irrigation (ha) for hh"
lab var ha_planted "Area planted (ha), all crops, for household"

foreach i in male female mixed {
lab var inorg_fert_kg_`i' "Inorganic fertilizer (kgs) for `i'-managed plots"
lab var org_fert_kg_`i' "Organic fertilizer (kgs) for `i'-managed plots" 
lab var pest_kg_`i' "Pesticide (kgs) for `i'-managed plots"
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
lab var urea_kg_`i' "Urea (kgs) for `i'-managed plots"
lab var npk_kg_`i' "NPK fertilizer (kgs) for `i'-managed plots"
lab var n_kg_`i' "Units of Nitrogen (kgs) for `i'-managed plots"
lab var p_kg_`i' "Units of Phosphorus (kgs) for `i'-managed plots"
lab var k_kg_`i' "Units of Potassium (kgs) for `i'-managed plots"
lab var nps_kg_`i' "Units of NPS (kgs) for `i'-managed plots"
lab var n_org_kg_`i' "Units of organic Nitrogen (kgs) for `i'-managed plots"
lab var dap_kg_`i' "Units of DAP (kgs) for `i'-managed plots"
lab var can_kg_`i' "Units of CAN (kgs) for `i'-managed plots"
lab var ha_planted_`i' "Area planted (ha), all crops, `i'-managed plots"
la var ha_irr_`i' "Planted hectares under irrigation for `i'-managed plots"
}
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fertilizer_application.dta", replace

/* AT: Check, probably no longer needed
********************************************************************************
*USE OF IMPROVED SEED        
********************************************************************************
use "${MWI_IHS_W1_created_data}/Malawi_IHS_W1_all_plots.dta", clear
collapse (sum) ha_planted, by(hhid plot_id)
merge 1:1 hhid plot_id using "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_kg_application.dta", nogen
gen n_rate = n_units / ha_planted 
gen p_rate = p_units / ha_planted
gen k_rate = k_units / ha_planted 
gen n_rate_org = n_units_org / ha_planted 
la var n_rate "Inorganic N application (kg/ha)"
la var p_rate "Phosphate application (kg/ha)"
la var k_rate "Potash application (kg/ha)"
la var n_rate_org "Organic N application from manure (kg/ha)"

save  "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_application_plot.dta", replace

collapse (sum) ha_planted *units*, by(hhid)
gen n_rate_hh = n_units / ha_planted 
gen p_rate_hh = p_units / ha_planted
gen k_rate_hh = k_units / ha_planted 
gen n_rate_org_hh = n_units_org / ha_planted 
la var n_rate_hh "Inorganic N application (kg/ha), hh avg"
la var p_rate_hh "Phosphate application (kg/ha), hh avg"
la var k_rate_hh "Potash application (kg/ha), hh avg"
la var n_rate_org_hh "Organic N application from manure (kg/ha), hh avg"

save  "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_fertilizer_application.dta", replace
*/

********************************************************************************
* WOMEN'S DIET QUALITY *
********************************************************************************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available

********************************************************************************
* HOUSEHOLD'S DIET DIVERSITY SCORE *
********************************************************************************
* Malawi LSMS 1 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of households eating nutritious food can be estimated

* Constructing rCSI: stands for reduced coping strategies index and is a weighted total of the types of strategies a household uses to avoid insufficient food
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_h.dta" , clear
keep hh_h02* hhid
*Weights from The Coping Strategies Index: Field Methods Manual (2008)
ren hh_h02a strategy1 // Rely on less preferred and/or less expensive foods * (severity weight = 1)
ren hh_h02b strategy2 // Limit portion size at meal-times * (severity weight = 1)
ren hh_h02c strategy3 // Reduce number of meals eaten in a day * (severity weight = 1)
ren hh_h02d strategy4 // Restrict consumption by adults in order for small children to eat * (severity weight = 3)
ren hh_h02e strategy5 // Borrow food or rely on help from a relative * (severity weight = 2)
gen rcsi=strategy1 + strategy2 + strategy3 + 3*strategy4 + 2*strategy5 
label var rcsi "Reducing Coping Strategies Index, weighted total of the types of strategies a household uses to avoid insufficient food"
keep hhid rcsi 
//MWI rCSI varies by season and not all households were interviewed at the same time. 
gen rcsi_phase1 = (rcsi <= 3)
gen rcsi_phase2 = (rcsi > 3 & rcsi <= 18)
gen rcsi_phase3 = (rcsi > 19 & rcsi <= 42)
gen rcsi_phase4 = (rcsi > 42)
label var rcsi_phase1 "1 = Household rCSI score belongs to IPC Phase 1, minimal food insecurity (0-3)"
label var rcsi_phase2 "1 = Household rCSI score belongs to IPC Phase 2, stressed food insecurity (4 - 18)"
label var rcsi_phase3 "1 = Household rCSI score belongs to IPC Phase 3, crisis food insecurity (19 - 42)"
label var rcsi_phase4 "1 = Household rCSI score belongs to IPC Phase 4, emergency food insecurity (> 42)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_rcsi.dta", replace

* Constructing FCS: similar to HDDS but it adds in the last 7 days and weighted by food group 
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_g2.dta", clear
ren hh_g08a foodgroup_string
ren hh_g08c days
recode days (8=7)
recode days (.=0)
gen foodgroup = ustrpos("ABCDEFGHIJ", foodgroup_string)
label define foodgroup_label 1 "A" 2 "B" 3 "C" 4 "D" 5 "E" 6 "F" 7 "G" 8 "H" 9 "I" 10 "J"
label values foodgroup foodgroup_label
keep foodgroup hhid days
reshape wide days, i(hhid) j(foodgroup)
gen max_days = max(days1, days2)
gen min_days = min(days1, days2)
gen sum_days = days1+days2
gen fcs_a =.
replace fcs_a =7 if max_days==7
replace fcs_a=max_days if min_days==0
replace fcs_a=((max_days+min_days)/2) if sum_days>7
drop days1 days2 days10 *_days
ren fcs_a days1
reshape long days, i(hhid) j(foodgroup)
gen weight = .
replace weight = 2 if foodgroup==1  // max of A and B 
replace weight = 3 if foodgroup == 3  // C
replace weight = 1 if foodgroup == 4 | foodgroup == 6 // D & F
replace weight = 4 if foodgroup == 5 | foodgroup == 7  // E & G
replace weight = 0.5 if foodgroup == 8 | foodgroup == 9  // H & I
gen fcs =. 
replace fcs = days*weight
collapse (sum) fcs, by (hhid)
label var fcs "Food Consumption Score"
gen fcs_poor = (fcs <= 21)
gen fcs_borderline = (fcs > 21 & fcs <= 35)
gen fcs_acceptable = (fcs > 35)
label var fcs_poor "1 = Household has poor Food Consumption Score (0-21)"
label var fcs_borderline "1 = Household has borderline Food Consumption Score (21.5 - 35)"
label var fcs_acceptable "1 = Household has acceptable Food Consumption Score (> 35)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fcs.dta", replace

use "${MWI_IHS_W1_appended_data}\Household\hh_mod_g1.dta" , clear
ren hh_g02 itemcode
drop if itemcode==829 | itemcode==830 | itemcode==804 //Restaurant meals and other.
* recode food items to map HDDS food categories //Including prepared foods in their respective categories
recode itemcode 	(101/117 820 					=1	"CEREALS" )  ////  Also includes biscuits, buns, scones // Added cooked maize from vendor
					(201/209 821 822 828			=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////Including chips and samosas
					(401/414 	 					=3	"VEGETABLES"	)  ////	
					(601/610						=4	"FRUITS"	)  ////	
					(504/512 515 824 825 826		=5	"MEAT"	)  ////	 512: Tinned meat or fish, included in meat				
					(501 823					    =6	"EGGS"	)  ////
					(502/503 513/514				=7  "FISH") ///
					(301/310						=8	"LEGUMES, NUTS AND SEEDS") ///
					(701/709						=9	"MILK AND MILK PRODUCTS")  ////
					(803  							=10	"OILS AND FATS"	)  ////
					(801 802 815/817 827			=11	"SWEETS"	)  //// Including sugar in sweets, oils are 803, ignoring one other (cassava leaves) in 804. Also including 827 - doughnuts
					(901/916  810/814 818			=14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)

gen adiet_yes=(hh_g01==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid Diet_ID)
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(hhid )
ren adiet_yes hdds 
sum hdds 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(hdds>=`cut_off1')
gen household_diet_cut_off2=(hdds>=`cut_off2')
lab var household_diet_cut_off1 "1= household consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= household consumed at least `cut_off2' of the 12 food groups last week" 
label var hdds "Number of food groups individual consumed last week HDDS"
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_rcsi.dta", nogen 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fcs.dta", nogen 
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_household_diet.dta", replace

********************************************************************************
* WOMEN'S CONTROL OVER INCOME *
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*In most cases, MWI LSMS W1 lists the first TWO decision makers.
*Indicator may be biased downward if some women would participate in decisions about the use of income
*but are not listed among the first two
 

* First append all files with information on who controls various types of income

* Control over Crop production income
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_i.dta", clear  // control over crop sale earnings rainy season
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_o.dta" // control over crop sale earnings dry season
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_q.dta" // control over permanent crop sale earnings
* Control over Livestock production income
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_s.dta" // control over livestock product sale earnings
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta" // control over livestock sale earnings
* Control over wage income
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_e.dta" // control over salary payment, allowances/gratuities, ganyu labor earnings 
* Control over business income
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_n2.dta" // household enterprise ownership
* Control over program assistance 
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_r.dta"
* Control over other income 
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_p.dta"
* Control over remittances
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_o.dta"


gen type_decision="" 
gen controller_income1=. 
gen controller_income2=.
 
* control_annualsales
replace type_decision="control_annualsales" if  !inlist( ag_i06a, .,0,99) |  !inlist( ag_i06b, .,0,99) 
replace controller_income1=ag_i06a if !inlist(ag_i06a, .,0,99)  
replace controller_income2=ag_i06b if !inlist(ag_i06b, .,0,99)
replace type_decision="control_annualsales" if  !inlist(ag_o06a, .,0,99) |  !inlist( ag_o06b, .,0,99) 
replace controller_income1=ag_o06a if !inlist( ag_o06a, .,0,99)  
replace controller_income2=ag_o06b if !inlist( ag_o06b, .,0,99)
* append who controls earnings from sale to customer 1
preserve
replace type_decision="control_annualsales" if  !inlist( ag_i14a, .,0,99) |  !inlist( ag_i14b, .,0,99) 
replace controller_income1=ag_i14a if !inlist( ag_i14a, .,0,99)  
replace controller_income2=ag_i14b if !inlist( ag_i14b, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag_o14a, .,0,99) |  !inlist( ag_o14b, .,0,99) 
replace controller_income1=ag_o14a if !inlist( ag_o14a, .,0,99)  
replace controller_income2=ag_o14b if !inlist( ag_o14b, .,0,99)
keep if !inlist( ag_i14a, .,0,99) |  !inlist( ag_i14b, .,0,99)  | !inlist( ag_o14a, .,0,99) |  !inlist( ag_o14b, .,0,99) 
keep hhid type_decision controller_income1 controller_income2
tempfile saletocustomer1
save `saletocustomer1'
restore
append using `saletocustomer1'
* append who controls earning from sale to customer 2 
preserve
replace type_decision="control_annualsales" if  !inlist( ag_i23a, .,0,99) |  !inlist( ag_i23b, .,0,99) 
replace controller_income1=ag_i23a if !inlist( ag_i23a, .,0,99)  
replace controller_income2=ag_i23b if !inlist( ag_i23b, .,0,99)
replace type_decision="control_annualsales" if  !inlist( ag_o23a, .,0,99) |  !inlist( ag_o23b, .,0,99) 
replace controller_income1=ag_o23a if !inlist( ag_o23a, .,0,99)  
replace controller_income2=ag_o23b if !inlist( ag_o23b, .,0,99)
keep if !inlist( ag_i23a, .,0,99) |  !inlist( ag_i23b, .,0,99)  | !inlist( ag_o23a, .,0,99) |  !inlist( ag_o23b, .,0,99) 
keep hhid type_decision controller_income1 controller_income2
tempfile saletocustomer2
save `saletocustomer2'
restore
append using `saletocustomer2'


* control_permsales
replace type_decision="control_permsales" if  !inlist( ag_q06a, .,0,99) |  !inlist( ag_q06b, .,0,99) 
replace controller_income1=ag_q06a if !inlist( ag_q06a, .,0,99)  
replace controller_income2=ag_q06b if !inlist( ag_q06b, .,0,99)
replace type_decision="control_permsales" if  !inlist( ag_q14a, .,0,99) |  !inlist( ag_q14b, .,0,99) 
replace controller_income1=ag_q14a if !inlist( ag_q14a, .,0,99)  
replace controller_income2=ag_q14b if !inlist( ag_q14b, .,0,99)
replace type_decision="control_permsales" if  !inlist( ag_q23a, .,0,99) |  !inlist( ag_q23b, .,0,99) 
replace controller_income1=ag_q23a if !inlist( ag_q23a, .,0,99)  
replace controller_income2=ag_q23b if !inlist( ag_q23b, .,0,99)


* Livestock Production Income
* MWI W1 did not ask directly about of who controls Livestock Production Income from live animal sales and slaughtered sales
* We are making the assumption that whoever owns the livestock might have some sort of control over the income generated by live animal sales and slaughter sales.
* livestock_sales (products) 
replace type_decision="control_livestocksales" if  !inlist( ag_s07a, .,0,99) |  !inlist( ag_s07b, .,0,99) 
replace controller_income1=ag_s07a if !inlist( ag_s07a, .,0,99)  
replace controller_income2=ag_s07b if !inlist( ag_s07b, .,0,99)

* livestock_sales (live animal)
replace type_decision="control_livestocksales" if !inlist( ag_r16, .,0) & (!inlist( ag_r05a, .,0,99) |  !inlist( ag_r05b, .,0,99))
replace controller_income1=ag_s07a if !inlist( ag_r16, .,0) & !inlist( ag_r05a, .,0,99)  
replace controller_income2=ag_s07b if !inlist( ag_r16, .,0) & !inlist( ag_r05b, .,0,99)
 
* livestock_sales (slaughtered)
replace type_decision="control_livestocksales" if !inlist( ag_r19, .,0) & (!inlist( ag_r05a, .,0,99) |  !inlist( ag_r05b, .,0,99))
replace controller_income1=ag_s07a if !inlist( ag_r19, .,0) & !inlist( ag_r05a, .,0,99)  
replace controller_income2=ag_s07b if !inlist( ag_r19, .,0) & !inlist( ag_r05b, .,0,99)
 
* Fish production income 
* No information available in MWI W1

* Business income 
* MWI W1 did not ask directly about of who controls Business Income
* We are making the assumption that whoever owns the business might have some sort of control over the income generated
* by the business (same as livestock production income).
* We don't think that the business manager have control of the business income. If she does, she is probably listed as owner
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( hh_n12a, .,0,99) |  !inlist( hh_n12b, .,0,99) 
replace controller_income1=hh_n12a if !inlist( hh_n12a, .,0,99)  
replace controller_income2=hh_n12b if !inlist( hh_n12b, .,0,99)

** --- Wage income --- **
* MWI W1 has questions on control over salary payments & allowances/gratuities in main + secondary job & ganyu earnings
* Approach below assumes that respondent is controller of their own wage income

* control_salary  //These don't work the same in MWI W1; instrument asks if "you" earned income, so there's only one column for controller
replace type_decision="control_salary" if  hh_e18==1
replace controller_income1=hh_e01 if hh_e18==1  //There are two id cols, id_code and hh_e01; a few are different, most are not

* append who controls salary earnings from secondary job
preserve
replace type_decision="control_salary" if  hh_e32==1
replace controller_income1=hh_e01 if hh_e32==1
keep if hh_e32==1 
keep hhid type_decision controller_income1 controller_income2
tempfile wages2
save `wages2'
restore
append using `wages2'

* control_allowances
replace type_decision="control_allowances" if  hh_e27!=. & hh_e27>0  
replace controller_income1=hh_e01 if hh_e27!=. & hh_e27>0 

* append who controls  allowance/gratuity earnings from secondary job
preserve
replace type_decision="control_allowances" if  hh_e41!=. & hh_e41>0 //|  !inlist(hh_e42_1b , .,0,99) 
replace controller_income1=hh_e01 if hh_e41!=. & hh_e41>0  
//replace controller_income2= hh_e42_1b if !inlist( , .,0,99)
keep if hh_e41!=. & hh_e41>0 // |  !inlist(hh_e42_1b , .,0,99)  
keep hhid type_decision controller_income1 controller_income2
tempfile allowances2
save `allowances2'
restore
append using `allowances2'

* control_ganyu
replace type_decision="control_ganyu" if  (hh_e55==1)
replace controller_income1= hh_e01 if (hh_e55==1)  

*Remittances Income
* MWI W1 doesn't really pose this question, it just identifies hh children who send remittances
* Because remittance decision-maker/controller is not specified, we must defer to the head of hh
* control_remittance 
preserve
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", clear
keep if hh_head == 1
gen fhh = hh_head if female == 1
recode fhh .=0
collapse (max) hh_head indiv fhh, by(hhid) // removes single duplicate value
tempfile hh_head_roster
save `hh_head_roster'
restore

preserve
recode hh_o11 (2=0)
recode hh_o11 (.=0)
collapse (sum) hh_o11, by(hhid)
gen type_decision=""
gen controller_income1=. 
replace type_decision="control_remittance" if hh_o11 > 0  
merge m:1 hhid using `hh_head_roster', nogen keep(3)
replace controller_income1=indiv if hh_o11 > 0
keep hhid type_decision controller_income1
tempfile remittance_cash
save `remittance_cash'
restore
append using `remittance_cash'

* append who controls in-kind remittances
preserve
recode hh_o15 (2=0)
recode hh_o15 (.=0)
collapse (sum) hh_o15, by(hhid)
gen type_decision=""
gen controller_income1=. 
replace type_decision="control_remittance" if hh_o15 > 0  
merge m:1 hhid using `hh_head_roster', nogen keep(3)
replace controller_income1=indiv if hh_o15 > 0
keep hhid type_decision controller_income1
tempfile remittance_in_kind
save `remittance_in_kind'
restore
append using `remittance_in_kind'

* control_assistance income
replace type_decision="control_assistance" if !inlist( hh_r05a, .,0,99) |  !inlist( hh_r05b, .,0,99) 
replace controller_income1=hh_r05a if !inlist( hh_r05a, .,0,99)  
replace controller_income1=hh_r05b if !inlist( hh_r05b, .,0,99)

* control_other income 
replace type_decision="control_otherincome" if !inlist( hh_p04a, .,0,99) |  !inlist( hh_p04b, .,0,99) 
replace controller_income1=hh_p04a if !inlist( hh_p04a, .,0,99) 
replace controller_income2=hh_p04b if !inlist( hh_p04b, .,0,99)


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
gen control_cropincome=1 if  type_decision=="control_annualsales" | type_decision=="control_permsales" 
recode 	control_cropincome (.=0)		
							
gen control_livestockincome=1 if  type_decision=="control_livestocksales" 												
recode 	control_livestockincome (.=0)

gen control_farmincome=1 if  control_cropincome==1 | control_livestockincome==1							
recode 	control_farmincome (.=0)		
							
gen control_businessincome=1 if  type_decision=="control_businessincome" 
recode 	control_businessincome (.=0)

gen control_salaryincome=1 if type_decision=="control_salary"| type_decision=="control_allowances"| type_decision=="control_ganyu"
recode 	control_salaryincome (.=0)
																					
gen control_nonfarmincome=1 if type_decision=="control_assistance" /// Removed remittance from this part b/c unconstructable for MWI W1
							  | type_decision=="control_otherincome" ///
							  | type_decision=="control_remittance" /// Added remittance, per assumption above: remittance dm = head of hh
							  | control_salaryincome== 1 ///
							  | control_businessincome==1 
recode 	control_nonfarmincome (.=0)
																		
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*	Now merge with member characteristics
merge 1:1 hhid indiv  using  "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen keep (3) // 20433/20433  matched

recode control_* (.=0)
lab var control_cropincome "1=individual has control over crop income"
lab var control_livestockincome "1=individual has control over livestock income"
lab var control_farmincome "1=individual has control over farm (crop or livestock) income"
lab var control_businessincome "1=individual has control over business income"
lab var control_salaryincome "1= individual has control over salary income"
lab var control_nonfarmincome "1=individual has control over non-farm (business, salary, assistance, remittances or other income) income"
lab var control_all_income "1=individual has control over at least one type of income"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_control_income.dta", replace

********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION-MAKING*
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	In most cases, MWI LSMS 4 lists the first TWO decision makers.
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
*	first append all files related to agricultural activities with income in who participate in the decision making

use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta" 
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_g.dta"
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_m.dta"
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_i.dta"
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_o.dta"
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_p.dta"
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_q.dta"
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.

* planting_input - Makes decision about plot Rainy Season
*Decisions concerning the timing of cropping activities, crop choice and input use on the [PLOT]
replace type_decision="planting_input" if !inlist(ag_d01, .,0,99) // no follow-up q re: "other decision makers" like W2
replace decision_maker1=ag_d01 if !inlist(ag_d01, .,0,99, 98) // no follow-up q re: "other decision makers" like W2

* Makes decision about plot dry Season
replace type_decision="planting_input" if !inlist(ag_k02, .,0,99) //same as above
replace decision_maker1=ag_k02 if !inlist(ag_k02, .,0,99, 98) //same as above

* append who make decision about (owner plot) rainy
preserve
replace type_decision="planting_input" if !inlist(ag_d04a, .,0,99) | !inlist(ag_d04b, .,0,99)
replace decision_maker1=ag_d04a if !inlist(ag_d04a, .,0,99, 98) 
replace decision_maker2=ag_d04b if !inlist(ag_d04b, .,0,99, 98) 
* append who make decision about (owner plot) dry
replace type_decision="planting_input" if !inlist(ag_k05a, .,0,99) | !inlist(ag_k05b, .,0,99)
replace decision_maker1=ag_k05a if !inlist(ag_k05a, .,0,99, 98) 
replace decision_maker2=ag_k05b if !inlist(ag_k05b, .,0,99, 98) 

keep if !inlist(ag_d04a, .,0,99) | !inlist(ag_d04b, .,0,99) | !inlist(ag_k05a, .,0,99) | !inlist(ag_k05b, .,0,99)

keep hhid type_decision decision_maker*
tempfile planting_input1
save `planting_input1'
restore
append using `planting_input1' 

*Livestock owners
replace type_decision="livestockowners" if !inlist(ag_r05a, .,0,99) | !inlist(ag_r05b, .,0,99)
replace decision_maker1=ag_r05a if !inlist(ag_r05a, .,0,99) 
replace decision_maker2=ag_r05b if !inlist(ag_r05b, .,0,99) 

keep hhid type_decision decision_maker1 decision_maker2 decision_maker3

preserve
keep hhid type_decision decision_maker2
drop if decision_maker2==.
ren decision_maker2 decision_maker
tempfile decision_maker2
save `decision_maker2'
restore

keep hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'

* number of time appears as decision maker
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest"
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv 
* Now merge with member characteristics
merge 1:1 hhid indiv  using  "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen // 12,861 matched
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_make_ag_decision.dta", replace

********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS*
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* MWI W1 asked to list the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets

*First, append all files with information on asset ownership
use "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_d.dta", clear //rainy
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_k.dta" //dry
append using "${MWI_IHS_W1_appended_data}\Agriculture\ag_mod_r1.dta"
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.

* Ownership of land.
replace type_asset="landowners" if  !inlist( ag_d04a, .,0,99) |  !inlist( ag_d04b, .,0,99) 
replace asset_owner1=ag_d04a if !inlist( ag_d04a, .,0,99)  
replace asset_owner2=ag_d04b if !inlist( ag_d04b, .,0,99)

replace type_asset="landowners" if  !inlist( ag_k05a, .,0,99) |  !inlist( ag_k05b, .,0,99) 
replace asset_owner1=ag_k05a if !inlist( ag_k05a, .,0,99)  
replace asset_owner2=ag_k05b if !inlist( ag_k05b, .,0,99)

*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( ag_r05a, .,0,99) |  !inlist( ag_r05b, .,0,99)  
replace asset_owner1=ag_r05a if !inlist( ag_r05a, .,0,99)  
replace asset_owner2=ag_r05b if !inlist( ag_r05b, .,0,99)

* non-farm equipment,  large durables/appliances, mobile phone
// Module M: FARM IMPLEMENTS, MACHINERY, AND STRUCTURES - does not report who in the household own them
// No ownership information regarding non-farm equipment,  large durables/appliances, mobile phone

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
merge 1:1 hhid indiv  using  "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", nogen 
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ownasset.dta", replace

********************************************************************************
*AGRICULTURAL WAGES*
********************************************************************************
*Moved to crop expenses

********************************************************************************
*CROP YIELDS*
********************************************************************************
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta", clear
gen number_trees_planted_banana = number_trees_planted if crop_code == 55
recode crop_code (52 53 54 56 57 58 59 60 61 62 63 64=100) // recode to "other fruit":  mango, orange, papaya, avocado, guava, lemon, tangerine, peach, poza, masuku, masau, pineapple
gen number_trees_planted_other_fruit = number_trees_planted if crop_code == 100
gen number_trees_planted_cassava = number_trees_planted if crop_code == 49
gen number_trees_planted_tea = number_trees_planted if crop_code == 50
gen number_trees_planted_coffee = number_trees_planted if crop_code == 51 
recode number_trees_planted_banana number_trees_planted_other_fruit number_trees_planted_cassava number_trees_planted_tea number_trees_planted_coffee (.=0)
collapse (sum) number_trees_planted*, by(hhid)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_trees.dta", replace

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta", clear
gen no_harvest=ha_harvest==.
ren kg_harvest harvest 
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
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_hh_crop_area_plan.dta", replace


use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta", clear
collapse (sum) area_harv_=ha_harvest area_plan_=ha_planted harvest_=kg_harvest, by(hhid dm_gender purestand crop_code)
drop if purestand == .
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
duplicates tag hhid dm_gender2 crop_code mixed, gen(dups)
drop if dups > 0
drop dups
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
tempfile areas_sans_hh
save `areas_sans_hh'

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", clear
merge 1:m hhid using `areas_sans_hh', keep(1 3) nogen
drop ea weight district ta rural region

save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_area_plan.dta", replace

*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_crop_harvest_area_yield.dta", replace

**Yield at the household level

*Value of crop production
merge m:1 crop_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropname_table.dta", nogen keep(1 3) // 100% matched
merge 1:1 hhid crop_code using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production.dta", nogen keep(1 3) keepusing(value*)
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
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_trees.dta", nogen keep(1 3)
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest* value_harv* value_sold* number_trees_planted*, by(hhid) 
recode harvest* area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area* value_harv* value_sold* (0=.)
egen kgs_harvest = rowtotal(kgs_harvest_*)
la var kgs_harvest "Quantity harvested of all crops (kgs) (household) (summed accross all seasons)" 

*ren variables
foreach p of global topcropname_area {
	lab var value_harv_`p' "Value harvested of `p' (Kwacha) (household)" 
	lab var value_sold_`p' "Value sold of `p' (Kwacha) (household)" 
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
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}

save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION 
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production.dta", clear
*Grouping following IMPACT categories but also mindful of the consumption categories.
gen crop_group=""
replace crop_group=	"Maize"	if crop_code==	1
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	5 //tobacco 
replace crop_group=	"Groundnuts"	if crop_code==	11 //ground nut
replace crop_group=	"Rice"	if crop_code==	17
replace crop_group=	"Beans and cowpeas"	if crop_code==	27 //ground bean
replace crop_group=	"Sweet potato"	if crop_code==	28
replace crop_group=	"Potato"	if crop_code==	29
replace crop_group=	"Wheat"	if crop_code==	30
replace crop_group=	"Millet"	if crop_code==	31 
replace crop_group=	"Sorghum"	if crop_code==	32
replace crop_group=	"Millet"	if crop_code==	33
replace crop_group=	"Beans and cowpeas"	if crop_code==	34 //bean
replace crop_group=	"Soyabean"	if crop_code==	35
replace crop_group=	"Beans and cowpeas"	if crop_code==	36 //pigeonpea
replace crop_group=	"Cotton"	if crop_code==	37
replace crop_group=	"Other other"	if crop_code==	38 //sunflower
replace crop_group=	"Sugar"	if crop_code==	39
replace crop_group=	"Vegetables"	if crop_code==	40 //cabbage
replace crop_group=	"Vegetables"	if crop_code==	41 //tanaposi
replace crop_group=	"Vegetables"	if crop_code==	42 //nkhwani
replace crop_group=	"Vegetables"	if crop_code==	43 //okra
replace crop_group=	"Fruits"	if crop_code==	44 //tomato
replace crop_group=	"Vegetables"	if crop_code==	45 //onion
replace crop_group=	"Beans and cowpeas"	if crop_code==	46 //pea
replace crop_group=	"Spices"	if crop_code==	47 //paprika
replace crop_group=	"Other other"	if crop_code==	48
replace crop_group=	"Cassava"	if crop_code==	49
replace crop_group=	"Tea"	if crop_code==	50
replace crop_group=	"Fruits"	if crop_code==	52 //mango
replace crop_group=	"Fruits"	if crop_code==	53 //orange
replace crop_group=	"Fruits"	if crop_code==	54 //papaya
replace crop_group=	"Fruits"	if crop_code==	55 //banana
replace crop_group=	"Fruits"	if crop_code==	56 //avocado
replace crop_group=	"Fruits"	if crop_code==	57 //guava
replace crop_group=	"Fruits"	if crop_code==	58 //lemon
replace crop_group=	"Fruits"	if crop_code==	59 //tangerine
replace crop_group=	"Fruits"	if crop_code==	60 //peach
replace crop_group=	"Fruits"	if crop_code==	61 //poza
replace crop_group=	"Fruits"	if crop_code==	62 //masuku
replace crop_group=	"Fruits"	if crop_code==	63 //masau
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	65 //macademia 
replace crop_group=	"Other other"	if inlist(crop_code, 1800, 1900, 2000) //fodder trees, fertilizer trees, fuel wood trees
ren  crop_group commodity

*High/low value crops
gen type_commodity=""
replace type_commodity=	"Low"	if crop_code==	1 //maize
replace type_commodity=	"Out"	if crop_code==	5 //tobacco 
replace type_commodity=	"High"	if crop_code==	11 //groundnut
replace type_commodity=	"High"	if crop_code==	17 //rice
replace type_commodity=	"High"	if crop_code==	27 //ground bean
replace type_commodity=	"Low"	if crop_code==	28 //sweet potato 
replace type_commodity=	"Low"	if crop_code==	29 //potato
replace type_commodity=	"Low"	if crop_code==	30 //wheat
replace type_commodity=	"Low"	if crop_code==	31 //millet
replace type_commodity=	"Low"	if crop_code==	32 //sorghum
replace type_commodity=	"Low"	if crop_code==	33 //millet
replace type_commodity=	"High"	if crop_code==	34 //bean
replace type_commodity=	"High"	if crop_code==	35 //soya bean
replace type_commodity=	"High"	if crop_code==	36 //pigeonpea
replace type_commodity=	"Out"	if crop_code==	37 //cotton
replace type_commodity=	"High"	if crop_code==	38 //sunflower
replace type_commodity=	"Out"	if crop_code==	39 //sugarcane
replace type_commodity=	"High"	if crop_code==	40 //cabbage
replace type_commodity=	"High"	if crop_code==	41 //tanaposi
replace type_commodity=	"High"	if crop_code==	42 //nkhwani
replace type_commodity=	"High"	if crop_code==	43 //okra
replace type_commodity=	"High"	if crop_code==	44 //tomato
replace type_commodity=	"High"	if crop_code==	45 //onion
replace type_commodity=	"High"	if crop_code==	46 //pea
replace type_commodity=	"High"	if crop_code==	47  //paprika
replace type_commodity=	"Out"	if crop_code==	48 //other 
replace type_commodity=	"Low"	if crop_code==	49 //cassava
replace type_commodity=	"Out"	if crop_code==	50 //tea
replace type_commodity=	"High"	if crop_code==	52 //mango
replace type_commodity=	"High"	if crop_code==	53 //orange
replace type_commodity=	"High"	if crop_code==	54 //papaya
replace type_commodity=	"Low"	if crop_code==	55 //banana
replace type_commodity=	"High"	if crop_code==	56 //avocado
replace type_commodity=	"High"	if crop_code==	57 //guava
replace type_commodity=	"High"	if crop_code==	58 //lemon
replace type_commodity=	"High"	if crop_code==	59 //tangerine
replace type_commodity=	"High"	if crop_code==	60 //peach
replace type_commodity=	"High"	if crop_code==	61 //poza
replace type_commodity=	"High"	if crop_code==	62 //masuku
replace type_commodity=	"High"	if crop_code==	63 //masau
replace type_commodity=	"High"	if crop_code==	65 //macademia
replace type_commodity=	"Out"	if crop_code==	1800 //fodder trees 
replace type_commodity=	"Out"	if crop_code==  1900 //fertilizer trees  
replace type_commodity=	"Out"	if crop_code==	2000 //fuel wood trees 

preserve
collapse (sum) value_crop_production value_crop_sales, by(hhid commodity) 

ren value_crop_production value_pro
ren value_crop_sales value_sal
separate value_pro, by(commodity)
separate value_sal, by(commodity)

foreach s in pro sal {
	ren value_`s'1 value_`s'_beans
	ren value_`s'2 value_`s'_casav
	ren value_`s'3 value_`s'_coton
	ren value_`s'4 value_`s'_fruit
	ren value_`s'5 value_`s'_gdnut
	ren value_`s'6 value_`s'_maize
	ren value_`s'7 value_`s'_mill 
	ren value_`s'8 value_`s'_onuts
	ren value_`s'9 value_`s'_oths
	ren value_`s'10 value_`s'_pota 
	ren value_`s'11 value_`s'_rice 
	ren value_`s'12 value_`s'_sorg
	ren value_`s'13 value_`s'_sybea 
	ren value_`s'14 value_`s'_spice
	ren value_`s'15 value_`s'_suga
	ren value_`s'16 value_`s'_spota
	ren value_`s'17 value_`s'_tea
	ren value_`s'18 value_`s'_vegs
	ren value_`s'19 value_`s'_whea
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
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production_grouped.dta", replace
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
	ren value_`s'3 value_`s'_other
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
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
*SHANNON DIVERSITY INDEX*
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use  "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_area_plan.dta", clear

*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_shannon_diversity_index.dta", replace

********************************************************************************
*CONSUMPTION*
********************************************************************************

use "${MWI_IHS_W1_appended_data}\Round 1 (2010) Consumption Aggregate.dta", clear 
drop panel
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep (3)
preserve
collapse (mean) price_index_region=price_indexL [aw=weight], by(region intmonth)
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_price_index_lookup_region.dta", replace
restore
collapse (mean) price_index_district=price_indexL [aw=weight], by(district region intmonth)
fillin region district intmonth
merge m:1 region intmonth using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_price_index_lookup_region.dta", nogen keep (3)
gen price_index=price_index_district
replace price_index=price_index_region if price_index ==.
keep district intmonth price_index
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_price_index_lookup.dta", replace

use "${MWI_IHS_W1_appended_data}\Household\hh_mod_g1.dta", clear
ren hh_g05 cons_value // how much did you spend? 
ren hh_g04b unit_purchase //how much came from purchases (unit)?
ren hh_g04a qty_purchase //how much came from purchases (qty)?
gen price_unit = cons_value/qty_purchase
lab var price_unit "Price per unit of food item, estimated from purchases"
gen unit_gift=hh_g07b
gen qty_gift=hh_g07a
gen qty_own =hh_g06a
gen unit_own=hh_g06b
ren hh_g02 itemcode
recode qty* (.=0)
drop if qty_purchase==0 & qty_own==0 & qty_gift==0
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen	
drop ea_id weight_pop_tot //weight_pop_rururb
keep hhid weight price_unit unit* qty* itemcode region district ta ea
gen country = "MWI" 
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_cons_value.dta", replace

use "${MWI_IHS_W1_created_data}/MWI_IHS_W1_cons_value.dta", clear
drop if price_unit==0 | price_unit==. 
gen obs=price_unit!=.
gen obs_weight = weight*qty_purchase

*create a value for the price of each food consumed at different levels
	foreach i in country region district ta ea hhid {
	preserve
	collapse (median) price_unit_`i' = price_unit (rawsum) obs_`i'_price = obs [aw=obs_weight], by(`i' unit_purchase itemcode) 
	ren unit_purchase unit 
	tempfile price_`i'_median 
	save `price_`i'_median'
	restore
	}
	
use "${MWI_IHS_W1_created_data}/MWI_IHS_W1_cons_value.dta", clear
reshape long unit qty, i(hhid itemcode price_unit) j(item_source) string
gen price_missing=price_unit==.
foreach i in country region district ta ea hhid {
	merge m:1 `i' unit itemcode using `price_`i'_median', nogen keep(1 3)
	replace price_unit = price_unit_`i' if obs_`i'_price >9 & price_missing ==1 & price_unit_`i' !=.
	}
replace price_unit = price_unit_hhid if price_unit_hhid !=. 
replace price_unit = price_unit_country if price_unit==.
gen val_fdcons=price_unit*qty
collapse (sum) val_fdcons, by (hhid) 

// cross sectional: visit 1, Panel A vist 1 & visit 2, Panel B visit 1 & visit 2 (hh_a23b_2)
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen keep (1 3)
merge m:1 hhid using "${MWI_IHS_W1_appended_data}\Household\hh_mod_a_filt.dta", nogen keep(1 3)	
gen intmonth=.
replace intmonth = hh_a23b_1 if qx_type == "Panel A" | qx_type == "Cross-Section"
replace intmonth = hh_a23b_2 if qx_type == "Panel B" 
keep intmonth hhid val_fdcons district region ea
merge m:m district intmonth using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_price_index_lookup.dta", nogen keep(1 3) 
gen missing_p_index = price_index ==.
gen intmonth_orig=intmonth
replace intmonth=intmonth-1 if missing_p_index == 1
replace intmonth=2 if intmonth==0
rename price_index price_index1
merge m:m district intmonth using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_price_index_lookup.dta", nogen keep(1 3) //9,790 matched, 2,477 not matched
replace price_index1=price_index if price_index1==.
drop price_index
rename price_index1 price_index
gen imputed=missing_p_index & price_index !=.
gen price_fdcons = (price_index/100)*val_fdcons 
keep hhid val_fdcons district region district intmonth price_index price_fdcons ea
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_food_consumption.dta", replace
ren ea ea_id
merge m:1 ea_id hhid using "${MWI_IHS_W1_appended_data}\Round 1 (2010) Consumption Aggregate.dta", nogen keep(3)
gen annual_val_fdcons=(val_fdcons*52)
sum annual_val_fdcons
sum rexp_cat011
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_agg_consumption.dta", replace 

use "${MWI_IHS_W1_appended_data}\Household\hh_mod_i1.dta", clear
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_i2.dta"
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_j.dta"
append using "${MWI_IHS_W1_appended_data}\Household\hh_mod_k.dta"
gen rexp_cat02=hh_i03*52 if inlist(hh_i02, 103) // tobacco, past week
gen rexp_cat03=hh_j03*4 if inrange(hh_j02, 301, 327) // clothing/footwear
gen rexp_cat04=hh_i06*12 if inlist(hh_i05, 215, 216, 217, 218, 219) // housing/utilities
replace rexp_cat04=hh_i03*12 if inlist(hh_i02, 101, 102) // housing/utilities, past month
replace rexp_cat04=hh_j03*4 if inlist(hh_j02, 328, 329, 330, 331, 333, 338) // housing/utilities
replace rexp_cat04=hh_k03 if inrange(hh_k02, 401, 410) // housing/utilities
replace rexp_cat04=hh_k03 if inlist(hh_k02, 420) // housing/utilities
gen rexp_cat06=hh_i06*12 if inlist(hh_i05, 202, 204, 205, 206, 207) // health
gen rexp_cat07=hh_i03*52 if inlist(hh_i02, 107, 108, 109) // transport, past week
replace rexp_cat07=hh_i06*12 if inlist(hh_i05, 212, 213, 214) //transport
gen rexp_cat08=hh_i03*12 if inlist(hh_i02, 210, 221) // communication, past month
replace rexp_cat08=hh_i06*12 if inlist(hh_i05, 106) // communication
gen rexp_cat09=hh_j03*4 if inrange(hh_j02, 334, 337) // recreation
gen rexp_cat11=hh_j03*4 if inlist(hh_j02, 339) // hotels/restaurants
gen rexp_cat12=hh_i06*12 if inlist(hh_i05, 201, 203, 209, 211, 220) // misc goods & services
replace rexp_cat12=hh_i03*52 if inlist(hh_i02, 104, 105) // misc goods & services, past week
replace rexp_cat12=hh_j03*4 if inlist(hh_j02, 332) // misc goods & services
replace rexp_cat12=hh_k03 if inrange(hh_k02, 411, 419) // misc goods & services
keep hhid rexp* visit ea_id
ren rexp* rexp*new
merge m:1 hhid using "${MWI_IHS_W1_appended_data}\Round 1 (2010) Consumption Aggregate.dta", nogen keep (3)
*Our method produces differnces from the World Bank consumption method. This code allows you to compare both panel and cross section. 
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_aggregate_consumption.dta", replace

use "${MWI_IHS_W1_raw_data}\Round 1 (2010) Consumption Aggregate.dta", clear
preserve
use "${directory}\Malawi IHS\mwi_panel_ids.dta", clear
keep if wave == 1
keep case_id case_id_aux
ren case_id_aux hhid
tempfile hhids
save `hhids'
restore

merge m:1 case_id using `hhids', nogen keep(3)
replace hhid = case_id if hhid == ""
drop case_id
ren rexpagg total_cons
ren pcrexpagg percapita_cons
replace total_cons = total_cons * $MWI_IHS_W1_2013_10_infl_adj // convert to 2010 LCU
replace percapita_cons = percapita_cons * $MWI_IHS_W1_2013_10_infl_adj // convert to 2010 LCU
gen peraeq_cons = total_cons/adulteq
gen daily_cons = total_cons/365
gen daily_percap_cons = percapita_cons/365
gen daily_peraeq_cons = peraeq_cons/365
lab var total_cons "Total HH consumption"
lab var percapita_cons "Consumption per capita"
lab var peraeq_cons "Consumption per adult equivalent"
lab var daily_cons "Daily HH consumption"
lab var daily_percap_cons "Daily consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
keep hhid total_cons percapita_cons peraeq_cons daily_cons daily_percap_cons daily_peraeq_cons adulteq hhsize //district
//ren total_cons val_fdcons
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_consumption.dta", replace

********************************************************************************
*HOUSEHOLD FOOD PROVISION*
********************************************************************************
use "${MWI_IHS_W1_appended_data}/Household/hh_mod_a_filt.dta", clear
merge 1:1 hhid using "${MWI_IHS_W1_appended_data}/Household/hh_mod_h.dta", nogen
gen int_month = hh_a23b_1 
replace int_month = hh_a23b_2 if qx_type=="Panel B"
gen int_year = hh_a23c_1
replace int_year=hh_a23c_2 if qx_type=="Panel B"
preserve
keep hhid int_month int_year
tempfile int_meta
save `int_meta'
restore
gen mar_2009 = hh_h05a_01 == "X" if int_month <  4 & int_year!=2011
gen apr_2009 = hh_h05a_02 == "X" if int_month <  5 & int_year!=2011
gen may_2009 = hh_h05a_03 == "X" if int_month <  6 & int_year!=2011
gen jun_2009 = hh_h05a_04 == "X" if int_month <  7 & int_year!=2011 
gen jul_2009 = hh_h05a_05 == "X" if int_month <  8 & int_year!=2011
gen aug_2009 = hh_h05a_06 == "X" if int_month <  9 & int_year!=2011
gen sep_2009 = hh_h05a_07 == "X" if int_month < 10 & int_year!=2011
gen oct_2009 = hh_h05a_08 == "X" if int_month < 11 & int_year!=2011
gen nov_2009 = hh_h05a_09 == "X" if int_year!=2011
gen dec_2009 = hh_h05a_10 == "X" if int_year!=2011
gen jan_2010 = hh_h05b_01 == "X" if int_year!=2011
gen feb_2010 = hh_h05b_02 == "X" if int_year!=2011
gen mar_2010 = hh_h05b_03 == "X" if int_month >  3 & int_year!=2011
gen apr_2010 = hh_h05b_04 == "X" if int_month >  4 & int_year!=2011
gen may_2010 = hh_h05b_05 == "X" if int_month >  5 | (int_year==2011 & int_month==5)
gen jun_2010 = hh_h05b_06 == "X" if int_month >  6 | int_year==2011
gen jul_2010 = hh_h05b_07 == "X" if int_month >  7 | int_year==2011
gen aug_2010 = hh_h05b_08 == "X" if int_month >  8 | int_year==2011
gen sep_2010 = hh_h05b_09 == "X" if int_month >  9 | int_year==2011
gen oct_2010 = hh_h05b_10 == "X" if int_month > 10 | int_year==2011
gen nov_2010 = hh_h05b_11 == "X" if int_year == 2011
gen dec_2010 = hh_h05b_12 == "X" if int_year == 2011
gen jan_2011 = hh_h05b_13 == "X" if int_year == 2011
gen feb_2011 = hh_h05b_14 == "X" if int_year == 2011
gen mar_2011 = hh_h05b_15 == "X" if int_year == 2011
egen months_food_insec=rowtotal(mar_2009-mar_2011)
keep hhid  months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_months_food_insufficient.dta", replace

use "${MWI_IHS_W1_appended_data}/Household/hh_mod_a_filt.dta", clear
merge 1:1 hhid using "${MWI_IHS_W1_appended_data}/Household/hh_mod_h.dta", nogen
merge 1:1 hhid using `int_meta', nogen keep(3)
ren hh_h01 days_nofd
ren hh_h02a rcsi_1
ren hh_h02b rcsi_2
ren hh_h02c rcsi_3
ren hh_h02d rcsi_4
ren hh_h02e rcsi_5
recode days_nofd rcsi* (.=0)
egen rcsi_6ques = rowtotal(days_nofd-rcsi_5)
gen rcsi_FEWS = rcsi_1 + rcsi_2 + rcsi_3 + rcsi_4 * 3 + rcsi_5 * 2
foreach i in 1 2 3 4 5 {
gen rcsi_`i'cat = rcsi_`i'
recode rcsi_`i'cat (1 2 3 = 1) (4 5 6 7=2)
}
gen rcsi_Rasch = rcsi_1cat + rcsi_2cat + rcsi_3cat + (rcsi_5cat!=0)*2 + rcsi_4cat*2
keep ea_id hhid visit days_nofd rcsi* int*
merge 1:1 hhid using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_months_food_insufficient.dta", nogen 
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_food_insecurity.dta", replace

********************************************************************************
*FOOD SECURITY*
********************************************************************************
use "${MWI_IHS_W1_raw_data}\Round 1 (2010) Consumption Aggregate.dta", clear
preserve
use "${directory}\Malawi IHS\mwi_panel_ids.dta", clear
keep if wave == 1
keep case_id case_id_aux
ren case_id_aux hhid
tempfile hhids
save `hhids'
restore

merge m:1 case_id using `hhids', nogen keep(3)
replace hhid = case_id if hhid == ""
drop case_id
ren rexp_cat011 fdconstot
replace fdconstot = fdconstot * $MWI_IHS_W1_2013_10_infl_adj // convert to 2010 LCU
gen daily_per_aeq_fdcons = fdconstot / adulteq / 365
gen daily_percap_fdcons = fdconstot / hhsize / 365
ren ea_id ea
keep hhid ea region urban district hhsize adulteq fdconstot daily_per_aeq_fdcons daily_percap_fdcons
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_food_cons.dta", replace

********************************************************************************
*HOUSEHOLD ASSETS*
********************************************************************************
use "${MWI_IHS_W1_appended_data}\Household\hh_mod_l.dta", clear
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_assets.dta", replace 

********************************************************************************
* SHOCKS 
********************************************************************************
use "${MWI_IHS_W1_appended_data}/Household/hh_mod_u.dta", clear
keep if inlist(hh_u0a, 101,102) & hh_u02!=. 
gen shock_clim = hh_u01==1
keep hhid y1_hhid hh_u0a shock_clim hh_u04a hh_u04b hh_u04c
reshape long hh_u04, i(hhid y1_hhid hh_u0a shock_clim) j(copingid) string
drop copingid
gen coping_savings = hh_u04==1
gen coping_help = inlist(hh_u04,2,3,4)
gen coping_redcons = inlist(hh_u04,5,9)
gen coping_employment = inlist(hh_u04, 6,7)
gen coping_mig = hh_u04==8
gen coping_assetsales = inlist(hh_u04,11,12,13,14,15)
gen coping_religion = inlist(hh_u04,18)
gen coping_nothing = hh_u04==19
collapse (max) coping*, by(hhid y1_hhid)
save "${MWI_IHS_W1_created_data}/MWI_IHS_W1_clim_shocks.dta", replace

********************************************************************************
*HOUSEHOLD VARIABLES*
********************************************************************************
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
global empty_vars ""
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", clear
//merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_adulteq.dta", nogen keep(1 3) // file not created in this wave, adulteq var created in consumption file
*Gross crop income 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_production.dta", nogen
* Production by group and type of crop
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)

*Production by group and type of crops
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production_grouped.dta", nogen 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_crop_values_production_type_crop.dta", nogen 
recode value_pro* value_sal* (.=0)
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_cost_inputs.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_yield_hh_crop_level.dta", nogen // 10,091 matched, 2180 not matched

*Crop costs //does not exist 
//Merge in summarized crop costs:
gen crop_production_expenses = cost_expli_hh
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"

*Top crop costs by area planted
foreach c in $topcropname_area {
	//merge 1:1 hhid hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rental_costs_`c'.dta", nogen //no land rental costs by top crops available
	capture confirm file "${MWI_IHS_W1_created_data}\MWI_IHS_W1_inputs_`c'.dta" 
	if _rc==0 { 
	merge 1:1 hhid  using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_inputs_`c'.dta", nogen //All expenses are in here now.
	merge 1:1 hhid  using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_`c'_monocrop_hh_area.dta", nogen
	}
}

global empty_crops ""

foreach c in $topcropname_area {
capture confirm var `c'_monocrop_ha //Check to make sure this isn't empty.
if !_rc {
	egen `c'_exp = rowtotal(val_*_`c'_hh) //Only explicit costs for right now; add "exp" and "imp" tag to variables to disaggregate in future 
	lab var `c'_exp "Crop production costs(explicit)-Monocrop `c' plots only"
	la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household"	
	*disaggregate by gender of plot manager
	foreach i in male female mixed {
		egen `c'_exp_`i' = rowtotal(val_*_`c'_`i')
		local l`c'_exp : var lab `c'_exp
		la var `c'_exp_`i' "`l`c'_exp' - `i' managed plots"
	}
	replace `c'_exp = . if `c'_monocrop_ha==. // set to missing if the household does not have any monocropped plots
	foreach i in male female mixed{
		replace `c'_exp_`i' = . if `c'_monocrop_ha_`i'==.
			}
	}
	else {
		global empty_crops $empty_crops `c'
	}
		
}

*Land rights
merge 1:1 hhid using  "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rights_hh.dta", nogen
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income //data not available for dung
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_sales.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_livestock_products.dta", nogen
//merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_dung.dta", nogen //does not exist 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_manure.dta", nogen // added this 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_expenses.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_TLU.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_herd_characteristics.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_TLU_Coefficients.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_expenses_animal.dta", nogen 

recode value_slaughtered value_lvstck_sold value_livestock_purchases value_milk_produced value_eggs_produced value_other_produced /*sales_dung*/ sales_manure cost_hired_labor_livestock cost_fodder_livestock cost_vaccines_livestock /*cost_water_livestock*/ (.=0) 
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases + (value_milk_produced + value_eggs_produced + value_other_produced + /*sales_dung +*/ sales_manure) - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock /*+ cost_water_livestock*/)
lab var livestock_income "Net livestock income"
gen livestock_expenses = cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock /*+ cost_water_livestock*/
ren cost_vaccines_livestock ls_exp_vac  
drop value_livestock_purchases value_other_produced /*sales_dung*/ sales_manure cost_hired_labor_livestock cost_fodder_livestock /*cost_water_livestock*/
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"
foreach i in lrum srum poultry {
	gen ls_exp_vac_`i' = .
}
gen sales_dung = .
gen cost_water_livestock = .
global empty_vars $empty_vars *ls_exp_vac_*

*Fish income
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_income.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fishing_expenses_1.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fishing_expenses_2.dta", nogen
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid
lab var fishing_income "Net fish income"
drop cost_fuel rental_costs_fishing cost_paid

*Self-employment income
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_self_employment_income.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fish_trading_income.dta", nogen 
//merge 1:1 hhid using"${MWI_IHS_W1_created_data}\MWI_IHS_W1_agproducts_profits.dta", nogen //file does not exist 

egen self_employment_income = rowtotal(/*annual_selfemp_profit*/ fish_trading_income /*byproduct_profits*/) //annual_selfemp_profit does not exist, W1 only asks for last months profit
lab var self_employment_income "Income from self-employment" 
drop /*annual_selfemp_profit*/ fish_trading_income /*byproduct_profits*/


*Wage income
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_wage_income.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_agwage_income.dta", nogen
recode annual_salary annual_salary_agwage(.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_off_farm_hours.dta", nogen

*Other income
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_other_income.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rental_income.dta", nogen

egen transfers_income = rowtotal (/*pension_income*/ remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income  land_rental_income)
lab var all_other_income "Income from all other revenue"
drop /*pension_income*/ remittance_income assistance_income rental_income other_income land_rental_income

*Farm size
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_size.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_size_all.dta", nogen 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmsize_all_agland.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_size_total.dta", nogen 

recode land_size (.=0)

*Add farm size categories
recode farm_size_agland (.=0)
gen farm_size_0_0=farm_size_agland==0
gen farm_size_0_1=farm_size_agland>0 & farm_size_agland<=1
gen farm_size_1_2=farm_size_agland>1 & farm_size_agland<=2
gen farm_size_2_4=farm_size_agland>2 & farm_size_agland<=4
gen farm_size_4_more=farm_size_agland>4
lab var farm_size_0_0 "1=Household has no farm"
lab var farm_size_0_1 "1=Household farm size > 0 Ha and <=1 Ha"
lab var farm_size_1_2 "1=Household farm size > 1 Ha and <=2 Ha"
lab var farm_size_2_4 "1=Household farm size > 2 Ha and <=4 Ha"
lab var farm_size_4_more "1=Household farm size > 4 Ha" 

*Labor 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_family_hired_labor.dta", nogen 

*Household size
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_vaccine.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_input_use.dta", nogen 
//merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_input_use.dta", nogen // improved seeds captured by input_use.dta
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_any_ext.dta", nogen
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fin_serv.dta", nogen
//merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_improved_hybrid_seed_use.dta", nogen // now in inputs
recode use_fin_serv* ext_reach* use* vac_animal (.=0)
replace vac_animal=. if tlu_today==0
replace use_inorg_fert=. if farm_area==0 | farm_area==.
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace use_imprv_seed=. if farm_area==.

*Milk productivity
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_milk_animals.dta", nogen
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
gen liters_per_buffalo = .
gen liters_per_largeruminant=.
gen share_imp_dairy = . 
global empty_vars $empty_vars share_imp_dairy *liters_per_buffalo liters_per_largeruminant

*Dairy costs 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_lrum_expenses", nogen 
gen costs_dairy_percow = costs_dairy/milk_animals
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
// gen share_imp_dairy = . // already defined

*Egg productivity
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_eggs_animals.dta", nogen

*Costs of crop production per hectare
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_cropcosts.dta", nogen //9758 matched, 2513 not matched 

*Rate of fertilizer application 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_fertilizer_application.dta", nogen
*Agricultural wage rate
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ag_wage.dta", nogen
*Crop yields 
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_yield_hh_crop_level.dta", nogen
*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_area_planted_harvested_allcrops.dta", nogen
*Household diet
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_household_diet.dta", nogen
*Consumption
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_consumption.dta", nogen
*Household assets
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hh_assets.dta", nogen

*Food insecurity
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_food_insecurity.dta", nogen

gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer

*Livestock health
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_diseases.dta", nogen

*livestock feeding, water, and housing
//merge 1:1 hhid  using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_livestock_feed_water_house.dta", nogen //does not exist
gen feed_grazing = . 
gen water_source_nat = . 
gen water_source_const = . 
gen water_source_cover = . 
gen lvstck_housed = . 
foreach v in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
foreach i in lrum srum poultry {
	gen `v'_`i' = .
	}
}
global empty_vars $empty_vars feed_grazing* water_source* lvstck_housed*

*Shannon diversity index
merge 1:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_shannon_diversity_index.dta", nogen

*Farm Production 
recode value_crop_production  value_livestock_products value_slaughtered value_lvstck_sold (.=0)
egen value_farm_production = rowtotal(value_crop_production value_livestock_products value_slaughtered value_lvstck_sold)
lab var value_farm_production "Total value of farm production (crops + livestock products)"
egen value_farm_prod_sold = rowtotal(value_crop_sales sales_livestock_products /*value_livestock_sales*/)
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.
gen value_livestock_sales = .
global empty_vars $empty_vars value_livestock_sales

*Agricultural households
recode value_crop_production livestock_income farm_area tlu_today (.=0)
gen ag_hh = (value_crop_production!=0 | crop_income!=0 | livestock_income!=0 | farm_area!=0 | tlu_today!=0)
lab var ag_hh "1= Household has some land cultivated, some livestock, some crop income, or some livestock income"

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
//gen fishing_income=0 // this variable exists, lines not needed
recode fishing_income (.=0)
gen fishing_hh = (fishing_income!=0)
lab  var fishing_hh "1= Household has some fishing income"

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
foreach i in lrum srum poultry{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland  all_area_harvested all_area_planted  encs num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales /*labor_hired labor_family */ farm_size_agland all_area_harvested all_area_planted  encs num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0

*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0	

*all rural households 
recode hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_income livestock_income self_employment_income nonagwage_income agwage_income fishing_income transfers_income all_other_income value_assets (.=0)

*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 		
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0		

*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed"

*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* /*kgs_harv_mono*/ total_planted_area* total_harv_area* /* // kgs_harv_mono redundant given kgs_harv*
*/ labor_hired labor_family /*
*/ animals_lost12months* mean_12months* lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses /*ls_exp_vac**/ sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=.
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top $wins_upper_thres%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg org_fert_kg pest_kg herb_kg urea_kg npk_kg n_kg p_kg k_kg n_org_kg nps_kg dap_kg can_kg wage_paid_aglabor ha_irr 

foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v' "`l`v'' - Winsorized top $wins_upper_thres%"
	
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winsorized top $wins_upper_thres%"
	}
}

drop *wage_paid_aglabor_mixed
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`labor_total' - Winsorized top $wins_upper_thres%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income fishing_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income total_cons percapita_cons daily_percap_cons peraeq_cons daily_peraeq_cons /* 
*/ *_monocrop_ha* dist_agrodealer land_size_total

foreach v of varlist $wins_var_top1_bott1 {
	_pctile `v' [aw=weight] , p($wins_lower_thres $wins_upper_thres) 
	gen w_`v'=`v'
	replace w_`v'= r(r1) if w_`v' < r(r1) & w_`v'!=. & w_`v'!=0  /* we want to keep actual zeros */
	replace w_`v'= r(r2) if  w_`v' > r(r2)  & w_`v'!=.		
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top and bottom 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top and bottom 1% percentile to winsorize gender-disagregated variables
	if "`v'"=="ha_planted" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace w_`v'_`g'= r(r1) if w_`v'_`g' < r(r1) & w_`v'_`g'!=. & w_`v'_`g'!=0  /* we want to keep actual zeros */
			replace w_`v'_`g'= r(r2) if  w_`v'_`g' > r(r2)  & w_`v'_`g'!=.		
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winsorized top and bottom 1%"		
		}		
	}
}

*Winsorizing variables that go into yield at the top and bottom 5% //IHS 10.2.19
global allyield male female mixed inter inter_male inter_female inter_mixed pure  pure_male pure_female pure_mixed
global wins_var_top1_bott1_2 area_harv  area_plan harvest
foreach v of global wins_var_top1_bott1_2 {
	foreach c of global topcropname_area {
		_pctile `v'_`c'  [aw=weight] , p(1 99)
		gen w_`v'_`c'=`v'_`c'
		replace w_`v'_`c' = r(r1) if w_`v'_`c' < r(r1)   &  w_`v'_`c'!=0 
		replace w_`v'_`c' = r(r2) if (w_`v'_`c' > r(r2) & w_`v'_`c' !=.)  		
		local l`v'_`c'  : var lab `v'_`c'
		lab var  w_`v'_`c' "`l`v'_`c'' - Winsorized top and bottom 5%"	
		* now use pctile from area for all to trim gender/inter/pure area
		foreach g of global allyield {
			gen w_`v'_`g'_`c'=`v'_`g'_`c'
			replace w_`v'_`g'_`c' = r(r1) if w_`v'_`g'_`c' < r(r1) &  w_`v'_`g'_`c'!=0 
			replace w_`v'_`g'_`c' = r(r2) if (w_`v'_`g'_`c' > r(r2) & w_`v'_`g'_`c' !=.)  	
			local l`v'_`g'_`c'  : var lab `v'_`g'_`c'
			lab var  w_`v'_`g'_`c' "`l`v'_`g'_`c'' - Winsorized top and bottom 5%"
			
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

*generate inorg_fert_rate, costs_total_ha, and costs_explicit_ha using winsorized values
//gen inorg_fert_rate=w_fert_inorg_kg/w_ha_planted
gen cost_total_ha = w_cost_total / w_ha_planted
gen cost_expli_ha = w_cost_expli / w_ha_planted 
gen cost_explicit_hh_ha=w_cost_expli_hh/w_ha_planted
gen irr_rate = w_ha_irr / w_ha_planted

*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
foreach v in inorg_fert org_fert n p k herb pest urea npk n_org nps dap can {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
} 
}

foreach g of global gender {
	replace cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
	gen cost_expli_ha_`g'=w_cost_expli_`g'/ w_ha_planted_`g' 	
	gen irr_rate_`g' = ha_irr_`g' / ha_planted_`g'

}
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
lab var dap_rate_`g' "Rate of DAP application (kgs/ha) (`g'-managed plots)"
lab var n_org_rate_`g' "Rate of organic Nitrogen application (kgs/ha) (`g'-managed plots)"
lab var nps_rate_`g' "Rate of NPS fertilizer application (kgs/ha) (`g'-managed plots)"
lab var can_rate_`g' "Rate of CAN fertilizer application (kgs/ha) (`g'-managed plots)"
lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
la var irr_rate_`g' "Proportion of planted area irrigated (household)"
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household level)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household level)"
lab var p_rate "Rate of potassium application (kgs/ha) (household level)"
lab var k_rate "Rate of potassium application (kgs/ha) (household level)"
lab var herb_rate "Rate of herbicide application (kgs/ha) (household level)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household level)"
lab var urea_rate "Rate of urea application (kgs/ha) (household level)"
lab var npk_rate "Rate of NPK fertilizer application (kgs/ha) (household level)"
lab var n_org_rate "Rate of organic nitrogen application (kgs/ha) (household level)"
lab var nps_rate "Rate of NPS application (kgs/ha) (household level)"
lab var dap_rate "Rate of DAP application (kgs/ha) (household level)"
lab var can_rate "Rate of CAN application (kgs/ha) (household level)"
lab var irr_rate "Proportion of planted area irrigated (household)"
lab var cost_total_ha "Explicit + implicit costs (per ha) of crop production (household level)"		
lab var cost_total_ha_male "Explicit + implicit costs (per ha) of crop production (male-managed plots)"
lab var cost_total_ha_female "Explicit + implicit costs (per ha) of crop production (female-managed plots)"
lab var cost_total_ha_mixed "Explicit + implicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_expli_ha "Explicit costs (per ha) of crop production (household level)"
lab var cost_expli_ha_male "Explicit costs (per ha) of crop production (male-managed plots)"
lab var cost_expli_ha_female "Explicit costs (per ha) of crop production (female-managed plots)"
lab var cost_expli_ha_mixed "Explicit costs (per ha) of crop production (mixed-managed plots)"
lab var cost_explicit_hh_ha "Explicit costs (per ha) of crop production (household level)"

*mortality rate
global animal_species lrum srum pigs equine poultry 
foreach s of global animal_species {
	gen mortality_rate_`s' = animals_lost12months_`s'/mean_12months_`s'
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
//gen labor_productivity = w_value_crop_production/w_labor_total 
gen labor_productivity=.
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (cannot be constructed)"   

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
recode *irr_rate* *org_fert_rate* *inorg_fert_rate* *n_org_rate* *nps_rate* *dap_rate* *can_rate* *n_rate* *p_rate* *k_rate* *herb_rate* *pest_rate* *urea_rate* *npk_rate* cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity /*labor_productivity*/ (.=0) if crop_hh==1
recode *irr_rate* *org_fert_rate* *inorg_fert_rate* *n_org_rate* *nps_rate* *dap_rate* *can_rate* *n_rate* *p_rate* *k_rate* *herb_rate* *pest_rate* *urea_rate* *npk_rate* cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity /*labor_productivity*/ (nonmissing=.) if crop_hh==0

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}
*all rural households 
recode hrs_*_pc_all (.=0)  
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
global wins_var_ratios_top1 inorg_fert_rate n_org_rate org_fert_rate n_rate p_rate k_rate herb_rate pest_rate urea_rate nps_rate dap_rate can_rate npk_rate cost_total_ha cost_expli_ha cost_expli_hh_ha irr_rate land_productivity /*labor_productivity*/ /*
*/ mortality_rate* liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top $wins_upper_thres%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
		if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" | "`v'"=="*_rate" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winsorized top $wins_upper_thres%"
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
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha - Winsorized top $wins_upper_thres%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_ha_`g'= `v'_exp_ha_`g'
		replace w_`v'_exp_ha_`g' = r(r1) if w_`v'_exp_ha_`g' > r(r1) & w_`v'_exp_ha_`g'!=.
		local l`v'_exp_ha_`g' : var lab `v'_exp_ha_`g'
		lab var w_`v'_exp_ha_`g' "`l`v'_exp_ha_`g'' - winsorized top $wins_upper_thres%"
	}
	*winsorizing cost per kilogram
	_pctile `v'_exp_kg [aw=weight] , p($wins_upper_thres)  
	gen w_`v'_exp_kg=`v'_exp_kg
	replace  w_`v'_exp_kg = r(r1) if  w_`v'_exp_kg > r(r1) &  w_`v'_exp_kg!=.
	local l`v'_exp_kg : var lab `v'_exp_kg
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winsorized top $wins_upper_thres%"
		*now by gender using the same method as above
		foreach g of global gender {
		gen w_`v'_exp_kg_`g'= `v'_exp_kg_`g'
		replace w_`v'_exp_kg_`g' = r(r1) if w_`v'_exp_kg_`g' > r(r1) & w_`v'_exp_kg_`g'!=.
		local l`v'_exp_kg_`g' : var lab `v'_exp_kg_`g'
		lab var w_`v'_exp_kg_`g' "`l`v'_exp_kg_`g'' - winsorized top $wins_upper_thres%"
	}
}

*now winsorize ratio only at top 1% - yield 
foreach c of global topcropname_area {
	foreach i in yield_pl yield_hv{
		_pctile `i'_`c' [aw=weight] ,  p(95)  //IHS WINSORIZING YIELD FOR MALAWI AT 5 PERCENT. 
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winsorized top $wins_upper_thres%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winsorized top $wins_upper_thres%"
		}
	}
}

/* Now in crop yields
foreach c of global topcropname_area {
	replace w_yield_pl_`c'=. if w_area_plan_`c'<0.05
	replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
	}
}
*/
*Create final income variables using un_Winsorized and un_Winsorized values
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
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winsorized top $wins_upper_thres%"
lab var w_farm_income "Farm income - Winsorized top $wins_upper_thres%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winsorized top $wins_upper_thres%"
lab var w_percapita_income "Household income per hh member per year - Winsorized top $wins_upper_thres%"
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
*/ use_* /*
*/ formal_land_rights_hh *_hrs_*_pc_all  months_food_insec w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses /*w_ls_exp_vac*/ (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses /*w_ls_exp_vac*/ (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestock production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' /*w_ls_exp_vac_`i'*/ (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' /*w_ls_exp_vac_`i'*/ (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ use_* /*w_labor_productivity*/ w_land_productivity /*
*/ w_inorg_fert_rate w_*_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ use* /*w_labor_productivity*/ w_land_productivity /*
*/ w_inorg_fert_rate w_*_rate w_cost_expli_hh w_cost_expli_hh_ha w_cost_expli_ha w_cost_total_ha /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested (nonmissing= . ) if crop_hh==0
		
*hh engaged in crop or livestock production
recode ext_reach* (.=0) if (crop_hh==1 | livestock_hh==1)
recode ext_reach* (nonmissing=.) if crop_hh==0 & livestock_hh==0

*all rural households growing specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (.=0) if grew_`cn'==1
	recode imprv_seed_`cn' hybrid_seed_`cn' w_yield_pl_`cn' /*
	*/ w_value_harv_`cn' w_value_sold_`cn' w_kgs_harvest_`cn' w_total_planted_area_`cn' w_total_harv_area_`cn' (nonmissing=.) if grew_`cn'==0
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
gen w_labor_weight=weight //*w_labor_total //we don't have this
//lab var w_labor_weight "labor-adjusted household weights"
lab var w_labor_weight "weight for labor - equal to household weight"
gen w_land_weight=weight*w_farm_area
lab var w_land_weight "land-adjusted household weights"
gen w_aglabor_weight_all=weight //*w_labor_hired //Also do not have
lab var w_aglabor_weight_all "weight for labor - equal to household weight"
gen w_aglabor_weight_female= weight // cannot create in this instrument  
lab var w_aglabor_weight_female "weight for labor - equal to household weight"
gen w_aglabor_weight_male= weight // cannot create in this instrument 
lab var w_aglabor_weight_male "weight for labor - equal to household weight"
gen weight_milk=weight * milk_animals //cannot create in this instrument
gen weight_egg=weight * poultry_owned

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

*Rural poverty headcount ratio
*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=TZ&start=1990
	// 1.90 * 79.531 = 151.1089  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=TZ&start=2003
	// 1+(134.925 - 110.84)/110.84 = 1.6587243	
	// 151.1089* 1.6587243 = 250.648 N
*NOTE: if the survey was carried out over multiple years we use the last year
*This is the poverty line at the local currency in the year the survey was carried out

gen ccf_loc = (1/$MWI_IHS_W1_inflation) 
lab var ccf_loc "currency conversion factor - 2021 MWK"
gen ccf_usd = ccf_loc/$MWI_IHS_W1_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$MWI_IHS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$MWI_IHS_W1_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

gen poverty_under_190 = daily_percap_cons < $MWI_IHS_W1_poverty_under_190 if daily_percap_cons != .
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $MWI_IHS_W1_poverty_under_215 if daily_percap_cons != .
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $MWI_IHS_W1_poverty_under_npl	if daily_percap_cons != .
la var poverty_under_npl "Household per-capita consumption is below the 2017 national poverty line."
gen poverty_under_300 = daily_percap_cons < $MWI_IHS_W1_poverty_under_300 if daily_percap_cons !=.
la var poverty_under_300 "Household per-capita consumption is below $3.00 in 2021 $PPP"

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
gen strataid=district

* adding empty variables to global
foreach x in any_imp_herd disease_amapl disease_animal disease_ASF disease_bruc disease_mange disease_NC disease_spox *lost_disease lvstck_holding *mortality_rate vac_animal  {
	global empty_vars $empty_vars `x'_equine
}

foreach x of global topcropname_area {
	global empty_vars $empty_vars hybrid_seed_`x'
	global empty_vars $empty_vars imprv_seed_`x'
}

foreach x in cotton pmill rice {
	global empty_vars $empty_vars *mixed*`x'*
	global empty_vars $empty_vars *`x'*mixed*
}

global empty_vars $empty_vars *value_harv_pmill *value_sold_pmill

foreach x in sorgum soy {
	global empty_vars $empty_vars *pure_mixed_`x'*
}

foreach x in casav fruit mill oths pota sorg spice suga tea vegs whea {
	global empty_vars $empty_vars w_value_pro_`x'
	global empty_vars $empty_vars w_value_sal_`x'
}

foreach x in casav tea {
	global empty_vars $empty_vars value_pro_`x'
	global empty_vars $empty_vars value_sal_`x'
}

foreach x in grdnt maize soy tobacc {
	global empty_vars $empty_vars w_kgs_harv_mono_`x'_mixed
}

global empty_vars $empty_vars *costs_dairy* *hrs_self_off_farm *lost_disease_lrum *maize_exp_kg_mixed *soy_exp_kg_mixed *tobacc_exp_kg_mixed w_hrs_unpaid_off* *yield_*_pure_mixed_nkhwni

foreach x in lrum pigs srum {
	global empty_vars $empty_vars disease_amapl_`x'
}

foreach x in lrum srum pigs equine poultry {
	global empty_vars $empty_vars ls_exp_med_`x'
}

foreach x in srum pigs poultry {
	global empty_vars $empty_vars w_lost_disease_`x'
}

global empty_vars $empty_vars disease_ASF_lrum disease_bruc_lrum disease_mange_lrum disease_spox_poultry grdnt_exp_kg_mixed w_aglabor_weight_female w_aglabor_weight_male w_cost_per_lit_milk w_fishing_income w_grdnt_monocrop_ha_mixed w_hrs_other_all w_hrs_other_all_pc_all w_liters_per_largeruminant w_maize_monocrop_ha_mixed w_self_employment_income w_share_fishing w_share_self_employment w_soy_monocrop_ha_mixed w_tobacc_monocrop_ha_mixed w_value_livestock_sales w_grdnt_exp_kg_mixed weight_milk weight_egg

* Recode to missing any variables that cannot be created in this instrument
* replace empty vars with missing
foreach v of varlist $empty_vars { 
	capture confirm var `v'
	if _rc {
		gen `v' = .
	}
	else {
		replace `v' = .
	}
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* region district ta ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use* vac_* /*
*/ feed* water* lvstck_housed* ext_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* /**ls_exp_vac**/ *prop_farm_prod_sold *value_*_prod* *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_poultry_today nb_smallrum_today nb_largerum_today nb_cows_today nb_chickens_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* area_harv* *_rate* *value_pro* *value_sal* *inter*

gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50)
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid
lab var hhid_panel "panel hh identifier" 
gen geography = "Malawi"
gen survey = "LSMS-ISA" 
gen year = "2010-11"
gen instrument = 41
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
save "${MWI_IHS_W1_final_data}\MWI_IHS_W1_household_variables.dta", replace // NOTE TO DEV: filename MWI... is intentionally different from standard file naming format. Keep MWI for Summary Stat file compatibility

********************************************************************************
*INDIVIDUAL LEVEL VARIABLES*
********************************************************************************
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_person_ids.dta", clear
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", nogen keep (1 3) 
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_input_use.dta", nogen  keep(1 3)
//merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_fert_use.dta", nogen  keep(1 3)
//merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\Malawi_IHS_W1_farmer_improved_hybrid_seed_use.dta", nogen  keep(1 3) 
//merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_improvedseed_use.dta", nogen  keep(1 3) 
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_hhids.dta", nogen keep (1 3)

*Land rights
merge 1:1 hhid indiv using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve
use "${MWI_IHS_W1_final_data}\MWI_IHS_W1_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)

replace make_decision_ag =. if ag_hh==0

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

gen female_use_inorg_fert= use_inorg_fert if female==1
gen male_use_inorg_fert= use_inorg_fert if female==0
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

* Recode to missing any variables that cannot be created in this instrument
* replace empty vars with missing
/*
foreach v of varlist $empty_vars { 
	capture confirm var `v'
	if _rc {
		gen `v' = .
	}
	else {
		replace `v' = .
	}
}
*/


la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid
lab var hhid_panel "panel hh identifier" 
gen geography = "Malawi"
gen survey = "LSMS-ISA"
gen year = "2010-11"
gen instrument = 41
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
gen strataid=district
gen clusterid=ea
save "${MWI_IHS_W1_final_data}\MWI_IHS_W1_individual_variables.dta", replace // NOTE TO DEV: filename MWI... is intentionally different from standard file naming format. Keep MWI for Summary Stat file compatibility

********************************************************************************
*PLOT LEVEL VARIABLES*
********************************************************************************
// global empty_vars ""
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_all_plots.dta", clear
collapse (sum) plot_value_harvest = value_harvest, by(hhid plot_id season)
tempfile crop_values
save `crop_values'

use "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_areas.dta", clear
merge m:1 hhid using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_weights.dta", keep(1 3) nogen
merge 1:m hhid plot_id using `crop_values', nogen //this brings in season
merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_decision_makers.dta", keep (1 3) nogen
merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plot_family_hired_labor.dta", nogen
//merge 1:1 hhid plot_id season using "${MWI_IHS_W1_created_data}/MWI_IHS_W1_plot_labor_days.dta", nogen //Redundant
//merge 1:1 hhid plot_id using "${MWI_IHS_W1_created_data}\MWI_IHS_W1_plots_cultivate.dta", nogen

merge m:1 hhid using "${MWI_IHS_W1_final_data}\MWI_IHS_W1_household_variables.dta", nogen /*keep(1 3)*/ keepusing(ag_hh fhh farm_size_agland)
gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural == 1
recode rural_ssp .=0

gen cultivate = (plot_value_harvest > 0 & plot_value_harvest !=.) | (labor_total > 0 & labor_total !=.)
keep if cultivate==1
replace area_meas_hectares=area_est_hectares if area_meas_hectares==. // 519 changes
// ren field_size  area_meas_hectares // already defined
// egen labor_total = rowtotal(labor_family labor_hired labor_nonhired) // already defined
global winsorize_vars field_size labor_total
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
lab var w_plot_value_harvest "Value of crop harvest on this plot - Winsorized top $wins_upper_thres%"

*Generate land and labor productivity using winsorized values
gen plot_productivity = w_plot_value_harvest/ w_field_size
lab var plot_productivity "Plot productivity Value production/hectare"

*Productivity at the plot level
//gen plot_labor_prod = w_plot_value_harvest/w_labor_total  	
gen plot_labor_prod=.
lab var plot_labor_prod "Plot labor productivity (cannot construct)"

*Winsorize both land and labor productivity at top 1% only
gen plot_weight=w_field_size*weight 
lab var plot_weight "Weight for plots (weighted by plot area)"
foreach v of varlist  plot_productivity  /*plot_labor_prod*/ {
	_pctile `v' [aw=plot_weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top $wins_upper_thres%"
}

gen ccf_loc = (1/$MWI_IHS_W1_inflation) 
lab var ccf_loc "currency conversion factor - 2021 MWK"
gen ccf_usd = ccf_loc/$MWI_IHS_W1_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$MWI_IHS_W1_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$MWI_IHS_W1_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

global monetary_val plot_value_harvest plot_productivity  /*plot_labor_prod*/ 
foreach p of global monetary_val {
	gen `p'_1ppp = `p' * ccf_1ppp
	gen `p'_2ppp = `p' * ccf_2ppp
	gen `p'_usd = `p' * ccf_usd 
	gen `p'_loc =  `p' * ccf_loc 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2021 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2021 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2021$ USD)"
	lab var `p'_loc "`l`p'' (2021 MWK)" 
	lab var `p' "`l`p'' (MWK)"  
	gen w_`p'_1ppp = w_`p' * ccf_1ppp
	gen w_`p'_2ppp = w_`p' * ccf_2ppp
	gen w_`p'_usd = w_`p' * ccf_usd
	gen w_`p'_loc = w_`p' * ccf_loc
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2021 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2021 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2021 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2021 MWK)" 
	lab var w_`p' "`lw_`p'' (MWK)" 
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/district)
* both can be obtained using a simple regression.
* use clustered standards errors
gen clusterid=ea
gen strataid=district
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean

* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a  here we first take to log of plot productivity. This allows the distribution to be less skewed and less sensitive to extreme values

gen lplot_productivity_usd=ln(plot_productivity_usd) 
lab var lplot_productivity_usd "Log Value of crop production per hectare"
gen lfield_size=ln(field_size)
lab var lfield_size "Log plot area hectare"
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
svy, subpop(if rural==1) : reg  lplot_productivity_usd male_dummy lfield_size i.district
matrix b1b=e(b)
gen gender_prod_gap1b=100*el(b1b,1,1)
sum gender_prod_gap1b
lab var gender_prod_gap1b "Gender productivity gap (%) - regression in logs with controls"
matrix V1b=e(V)
gen segender_prod_gap1b= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b
lab var segender_prod_gap1b "SE Gender productivity gap (%) - regression in logs with controls"


*SSP
svy, subpop(  if rural==1 & rural_ssp==1): reg  lplot_productivity_usd male_dummy lfield_size i.district
matrix b1b=e(b)
gen gender_prod_gap1b_ssp=100*el(b1b,1,1)
sum gender_prod_gap1b_ssp
lab var gender_prod_gap1b_ssp "Gender productivity gap (%) - regression in logs with controls - SSP"
matrix V1b=e(V)
gen segender_prod_gap1b_ssp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_ssp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - SSP"


*LS_SSP
svy, subpop(  if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy lfield_size i.district
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
	rename manager_gender_ssp3 manager_mixed_ssp

	label variable manager_male_ssp "Male only decision-maker - ssp"
	label variable manager_female_ssp "Female only decision-maker - ssp"
	label variable manager_mixed_ssp "Mixed gender decision-maker - ssp"

tab dm_gender if rural_ssp==0, generate(manager_gender_lsp)

	rename manager_gender_lsp1 manager_male_lsp
	rename manager_gender_lsp2 manager_female_lsp
	// rename manager_gender_lsp3 manager_mixed_lsp // no mixed gender plot dm for lsp

	label variable manager_male_lsp "Male only decision-maker - lsp"
	label variable  manager_female_lsp "Female only decision-maker - lsp"
	// label variable manager_mixed_lsp "Mixed gender decision-maker - lsp" // no mixed gender plot dm for lsp
	
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
rename v1 NGA_wave3

save "${MWI_IHS_W1_created_data}\MWI_IHS_W1_gendergap.dta", replace
restore

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= weight
la var weight_sample "Original survey weight"
la var weight "Weight adjusted to match rural/urban populations"

* Recode to missing any variables that cannot be created in this instrument
* replace empty vars with missing
/*
foreach v of varlist $empty_vars { 
	capture confirm var `v'
	if _rc {
		gen `v' = .
	}
	else {
		replace `v' = .
	}
}
*/

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid
lab var hhid_panel "panel hh identifier" 
gen geography = "Malawi"
gen survey = "LSMS-ISA"
gen year = "2010-11"
gen instrument = 41
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
//gen strataid=district // defined earlier in section
//gen clusterid=ea // defined earlier in section
save "${MWI_IHS_W1_final_data}\MWI_IHS_W1_field_plot_variables.dta", replace // NOTE TO DEV: filename MWI... is intentionally different from standard file naming format. Keep MWI for Summary Stat file compatibility

********************************************************************************
*SUMMARY STATISTICS
******************************************************************************** 
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separate dofile that is called here
*/ 

*Parameters
global list_instruments  "MWI_IHS_W1"
do "$summary_stats"

