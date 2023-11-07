
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (TNPS) LSMS-ISA Wave 4 (2014-15)
*Author(s)		: Anu Sidhu, C. Leigh Anderson, Travis Reynolds, Chae Won Lee, Haley Skinner, Claire Gracia

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 21 January 2018

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period April 2019 - March 2020.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*https://microdata.worldbank.org/index.php/catalog/3818

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi LSMS data set.
*Using data files from within the "378 - LSMS Burkina Faso, Malawi, Uganda" folder within the "raw_data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\code 
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. // update when done

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //update when done
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						MWI_IHS_IHPS_W4_hhids.dta
*WEIGHTS							MWI_IHS_IHPS_W4_weights.dta
*INDIVIDUAL IDS						MWI_IHS_IHPS_W4_person_ids.dta
*HOUSEHOLD SIZE						MWI_IHS_IHPS_W4_hhsize.dta
*GPS COORDINATES					Malawi_IHS_LSMS_ISA_hh_coords.dta
*PLOT AREAS							MWI_IHS_IHPS_W4_plot_areas.dta
*PLOT-CROP DECISION MAKERS			MWI_IHS_IHPS_W4_plot_decision_makers.dta
*CROP UNIT CONVERSION FACTORS		MWI_IHS_IHPS_W4_cf.dta
									caloric_conversionfactor_crop_codes.dta
*ALL PLOTS							MWI_IHS_IHPS_W4_all_plots.dta
*TLU (Tropical Livestock Units)		MWI_IHS_IHPS_W4_TLU_Coefficients.dta

*GROSS CROP REVENUE					MWI_IHS_IHPS_W4_tempcrop_harvest.dta
									MWI_IHS_IHPS_W4_tempcrop_sales.dta
									MWI_IHS_IHPS_W4_permcrop_harvest.dta
									MWI_IHS_IHPS_W4_permcrop_sales.dta
									MWI_IHS_IHPS_W4_hh_crop_production.dta
									MWI_IHS_IHPS_W4_plot_cropvalue.dta
									MWI_IHS_IHPS_W4_parcel_cropvalue.dta
									MWI_IHS_IHPS_W4_crop_residues.dta
									MWI_IHS_IHPS_W4_hh_crop_prices.dta
									MWI_IHS_IHPS_W4_crop_losses.dta

*CROP EXPENSES						MWI_IHS_IHPS_W4_fertilizer_costs.dta
									MWI_IHS_IHPS_W4_seed_costs.dta
									MWI_IHS_IHPS_W4_land_rental_costs.dta
									MWI_IHS_IHPS_W4_asset_rental_costs.dta
									MWI_IHS_IHPS_W4_transportation_cropsales.dta
									
*MONOCROPPED PLOTS					MWI_IHS_IHPS_W4_monocrop_plots.dta
									Malawi_IHS_W4_`cn'_monocrop_hh_area.dta
									Malawi_IHS_W4_`cn'_monocrop.dta
									Malawi_IHS_W4_inputs_`cn'.dta

*LIVESTOCK INCOME					MWI_IHS_IHPS_W4_livestock_products.dta
									MWI_IHS_IHPS_W4_livestock_expenses.dta
									MWI_IHS_IHPS_W4_hh_livestock_products.dta
									MWI_IHS_IHPS_W4_livestock_sales.dta
									MWI_IHS_IHPS_W4_TLU.dta
									MWI_IHS_IHPS_W4_livestock_income.dta						

*FISH INCOME						MWI_IHS_IHPS_W4_fishing_expenses_1.dta
									MWI_IHS_IHPS_W4_fishing_expenses_2.dta
									MWI_IHS_IHPS_W4_fish_income.dta
									
*OTHER INCOME						MWI_IHS_IHPS_W4_other_income.dta
									MWI_IHS_IHPS_W4_land_rental_income.dta
									
*LAND RENTAL INCOME					MWI_IHS_IHPS_W4_land_rental_income

*CROP INCOME						MWI_IHS_IHPS_W4_crop_income.dta
																	
*SELF-EMPLOYMENT INCOME				MWI_IHS_IHPS_W4_self_employment_income.dta
									MWI_IHS_IHPS_W4_agproducts_profits.dta
									MWI_IHS_IHPS_W4_fish_trading_revenue.dta
									MWI_IHS_IHPS_W4_fish_trading_other_costs.dta
									MWI_IHS_IHPS_W4_fish_trading_income.dta
									
*WAGE INCOME						MWI_IHS_IHPS_W4_wage_income.dta
									MWI_IHS_IHPS_W4_agwage_income.dta

*FARM SIZE / LAND SIZE				MWI_IHS_IHPS_W4_land_size.dta
									MWI_IHS_IHPS_W4_farmsize_all_agland.dta
									MWI_IHS_IHPS_W4_land_size_all.dta
*FARM LABOR							MWI_IHS_IHPS_W4_farmlabor_mainseason.dta
									MWI_IHS_IHPS_W4_farmlabor_shortseason.dta
									MWI_IHS_IHPS_W4_family_hired_labor.dta
									
*VACCINE USAGE						MWI_IHS_IHPS_W4_vaccine.dta
*USE OF INORGANIC FERTILIZER		MWI_IHS_IHPS_W4_fert_use.dta
*USE OF IMPROVED SEED				MWI_IHS_IHPS_W4_improvedseed_use.dta

*REACHED BY AG EXTENSION			MWI_IHS_IHPS_W4_any_ext.dta
*MOBILE OWNERSHIP                   Malawi_IHS_LSMS_ISA_W2_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	MWI_IHS_IHPS_W4_fin_serv.dta

*GENDER PRODUCTIVITY GAP 			MWI_IHS_IHPS_W4_gender_productivity_gap.dta
*MILK PRODUCTIVITY					MWI_IHS_IHPS_W4_milk_animals.dta
*EGG PRODUCTIVITY					MWI_IHS_IHPS_W4_eggs_animals.dta

*CONSUMPTION						MWI_IHS_IHPS_W4_consumption.dta
*HOUSEHOLD FOOD PROVISION			MWI_IHS_IHPS_W4_food_insecurity.dta
*HOUSEHOLD ASSETS					MWI_IHS_IHPS_W4_hh_assets.dta
*SHANNON DIVERSITY INDEX			MWI_IHS_IHPS_W4_shannon_diversity_index

*RATE OF FERTILIZER APPLICATION		MWI_IHS_IHPS_W4_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	MWI_IHS_IHPS_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		MWI_IHS_IHPS_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			MWI_IHS_IHPS_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			MWI_IHS_IHPS_W4_ownasset.dta

*CROP YIELDS						MWI_IHS_IHPS_W4_yield_hh_crop_level.dta
*CROP PRODUCTION COSTS PER HECTARE	MWI_IHS_IHPS_W4_hh_cost_land.dta
									MWI_IHS_IHPS_W4_hh_cost_inputs_lrs.dta
									MWI_IHS_IHPS_W4_hh_cost_inputs_srs.dta
									MWI_IHS_IHPS_W4_hh_cost_seed_lrs.dta
									MWI_IHS_IHPS_W4_hh_cost_seed_srs.dta		
									MWI_IHS_IHPS_W4_cropcosts_perha.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				MWI_IHS_IHPS_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			MWI_IHS_IHPS_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				MWI_IHS_IHPS_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					MWI_IHS_IHPS_W4_summary_stats.xlsx
*/


* General notes *
* HKS: The "reference" rainy and dry (dimba) seasons can refer to one of 2 seasons as per the BID
* HKS: For Malawi W4, some questions from the questionnaire were reserved only for the IHS cross-sectional interviews, while others were reserved for the IHPS panel data. Households are (generally) tracked across IHS and IHPS using the common identifier "case_id". Similar identifiers, such as "hhid" (IHS) and y4_hhid (IHPS) are not sufficient when incorporating both datasets, as they refer to only one. 
* HKS: For consistency across waves and for future integration into AgQueryPlus, HHID is being consistently renamed to hhid for all created/final data files. 

clear
set more off

clear matrix	
clear mata	
set maxvar 8000		
ssc install findname      //need this user-written ado file for some commands to work_TH



*****************************
***** SET DIRECTOREIS *******
*****************************
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
*global MWI_IHS_IHPS_W4_raw_data 			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data"
*global MWI_IHS_IHPS_W4_created_data 		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\temp" // hks 5/5/23: not sure why this would be temp??? there are files saved to both temp and creatd data recently; not sure who changed the file path?

* To accomodate the IHS+IHPS appended files, use TEMP folder I create in loop below
global MWI_IHS_IHPS_W4_raw_data 			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\RA Working Folders\Haley\LSMS_GitHub\335_LSMS_dev\Malawi IHS\Malawi IHS Wave 4\Final DTA Files\Temp" // where "Temp" file holds those with IHPS data appended (see section below)

global MWI_IHS_IHPS_W4_created_data 		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\created_data"

global MWI_IHS_IHPS_W4_final_data  		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\outputs"

//Conventions: After section title, add initials; "IP" for in Progress/ "Complete [date] without check" if code is drafted but not checked; "Complete [date] + [Reviewer initials] checked [date]"


************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS  
************************************************************************
global MWI_IHS_IHPS_W4_exchange_rate 2158
global MWI_IHS_IHPS_W4_gdp_ppp_dollar 205.61    // https://data.worldbank.org/indicator/PA.NUS.PPP -2017
global MWI_IHS_IHPS_W4_cons_ppp_dollar 207.24	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP - Only 2016 data available 
global MWI_IHS_IHPS_W4_inflation 0.7366255144 // inflation rate 2015-2016. Data was collected during oct2014-2015. We want to adjust the monetary values to 2016 // hs 4/12/23: CPI 2015/CPI2017 = 250.6/340.2

* New poverty indicators added 4/12/23 by HS
global MWI_IHS_IHPS_W4_pov_threshold (1.90*78.7) // HS 4/12/23: 1.90*(CONS PPP 2011 = 78.7) //Calculation for WB's previous $1.90 (PPP) poverty threshold. This controls the indicator poverty_under_1_9; change the 1.9 to get results for a different threshold. Note this is based on the 2011 PPP conversion!
global MWI_IHS_IHPS_W4_poverty_nbs 7184 *(1.5263367917) // HS 4/12/23: According to this document, the national poverty line in Birr in 2015/16 was 7184 (https://dagethiopia.org/sites/g/files/zskgke376/files/2022-03/poverty_economic_growth_in_ethiopia-mon_feb_11_2019.pdf); thus to calculate this figure adjusted to 2018-19, we calculate inflation = CPI 2018/CPI 2015 = 382.5/250.6 = 1.5263367917
global MWI_IHS_IHPS_W4_poverty_215 2.15 * $MWI_IHS_IHPS_W4_inflation * $MWI_IHS_IHPS_W4_cons_ppp_dollar  // using 2017 values

 
********************************************************************************
*THRESHOLDS FOR WINSORIZATION -- RH, Complete 7/15/21 - not checked
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

********************************************************************************
* POPULATION FIGURES 
********************************************************************************
* (https://databank.worldbank.org/source/world-development-indicators#)
global MWI_IHS_IHPS_W4_pop_tot 18867337
global MWI_IHS_IHPS_W4_pop_rur 15627061
global MWI_IHS_IHPS_W4_pop_urb 3240276

/********************************************************************************
* APPENDING Malawi IHPS data to IHS data (does not need to be re-run every time)
* After running, must change created_data file path back to raw/created_data (above)
********************************************************************************
* HKS 07.06.23: Adding a new global for appending in the panel data
global append_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets"
* Issue: case_id doesn't account for split off households. For example, 2 households may both have a case_id of "210663390033", but have different y4_hhid (1309-002 and 1312-004) and often y3_hhid as well. Later, when trying to merge in hh_mod_a_filt_19.dta (to get case_id and qx),

* HKS 7/6/23: appending panel files (IHPS) in to IHS data; renaming HHID hhid
global temp_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\RA Working Folders\Haley\LSMS_GitHub\335_LSMS_dev\Malawi IHS\Malawi IHS Wave 4\Final DTA Files\Temp"
local directory_raw "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data"
local directory_panel "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets"
cd "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\"
local raw_files : dir "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data" files "*.dta", respectcase
local panel_files : dir "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets" files "*_19.dta", respectcase



*local panel_files : dir "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets\bs" files "*_19.dta", respectcase


*  restrict to only those which haven't been run to completion
foreach panelfile of local panel_files {
			*local filename : subinstr local panelfile "19.dta" ""
			*isplay in red "`filename'"
	local raw_file = subinstr("`panelfile'", "_19", "", .)
			if !fileexists("${temp_data}/`raw_file'") { // if file has not yet been saved to temp_data
			if (!strpos("`panelfile'", "meta") & !strpos("`panelfile'", "com_") ){
				use "`directory_panel'/`panelfile'", clear // use IHPS
					display in red  "`directory_panel'/`panelfile'"
			local append_file "`directory_raw'/`raw_file'" // Append IHS
				display in red "we will be appending the following raw IHS data: `append_file'"
				
			*if (!strpos("`append_file'", "meta")) { // if the raw data (append file) does not contain "meta", appendfile
			preserve
				use "${append_data}\hh_mod_a_filt_19.dta", clear
				tostring HHID, replace
				replace HHID = y4_hhid
				*ren HHID hhid
				tempfile merge_file
				save `merge_file'
			restore

			capture tostring ag_e13_2*, replace
			capture destring ag_f39*, replace
			capture destring ag_h39*, replace
			capture tostring HHID, replace
			capture destring PID, replace
			capture replace HHID = y4
				if _rc {
					capture gen HHID = y4
				}

			append using "`append_file'"
			merge m:1 y4_hhid using "`merge_file'", nogen keep(1 3) keepusing(case_id HHID y4 qx ea) // merge in case_id to each of these IHPS file
			* Households that do not match from master are those which are in IHS but are not also in IHPS.
				ren qx panel_dummy
				ren HHID hhid
				ren y4_hhid y4_hhid_IHPS
				*replace hhid = y4 if hhid == ""
				display in red "we are saving to '${temp_data}\`raw_file'" 
				save "${temp_data}/`raw_file'", replace // Save in GH location
				}
}
}

use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\householdgeovariables_ihs5.dta", clear
duplicates drop
*drop if HHID == .
append using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets\MWI W4\householdgeovariables_y4.dta"
			merge m:1 y4_hhid using "${append_data}\hh_mod_a_filt_19.dta", nogen keep(1 3) keepusing(case_id HHID y4 qx) // merge in case_id to each of these IHPS file
			*drop if HHID == .
			drop if case_id == ""
save "${temp_data}\householdgeovariables_ihs5", replace
 
* For other files in the original raw folder that were not edited - copy them into new "raw" (that is, my Temp folder):
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\Agricultural Conversion Factor Database.dta", clear
save "${MWI_IHS_IHPS_W4_raw_data}\Agricultural Conversion Factor Database.dta", replace

use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\caloric_conversionfactor.dta", clear
	save "${MWI_IHS_IHPS_W4_raw_data}\caloric_conversionfactor.dta", replace

use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\ihs_seasonalcropconversion_factor_2020_alt-mod_update.dta", clear
	save "${MWI_IHS_IHPS_W4_raw_data}\ihs_seasonalcropconversion_factor_2020_alt-mod_update.dta", replace


use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\ihs_seasonalcropconversion_factor_2020_alt-mod_update.dta", clear
	save "${MWI_IHS_IHPS_W4_raw_data}\ihs_seasonalcropconversion_factor_2020_alt-mod_update.dta", replace

use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\Conversion_factors_perm.dta", clear
	save "${MWI_IHS_IHPS_W4_raw_data}\Conversion_factors_perm.dta", replace


*"${MWI_IHS_IHPS_W4_raw_data}/Conversion_factors_perm.dta"	*/

************************************************
*HOUSEHOLD IDS - RH complete 7/15/21, not checked
************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\hh_mod_a_filt.dta", clear
*append using "${append_data}\hh_mod_a_filt_19.dta"
ren hh_a02a TA 
rename hh_wgt weight
recode region (1=100) (2=200) (3=300) //ALT 10.09.23: Added in to fix append issue
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
keep hhid case_id region district TA ea weight rural panel_dummy y4 
ren y4 y4_hhid

lab var rural "1=Household lives in a rural area"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", replace

********************************************************************************
* WEIGHTS * 
********************************************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\hh_mod_a_filt.dta", clear
rename hh_a02a TA 
rename hh_a03 ea
rename hh_wgt weight
gen rural = (reside==2)
ren reside stratum
lab var region "1=North, 2=Central, 3=South" 
lab var rural "1=Household lives in a rural area"
keep case_id hhid region stratum district TA ea rural weight  
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weights.dta", replace

************************************************
*INDIVIDUAL IDS - RH complete 7/15/21, not checked
************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\hh_mod_b", clear
ren PID indiv	//At the individual-level, the IHPS data from 2010, 2013, and 2016, and 2019 can be merged using the variable PID - will be used later in data
keep hhid y4 indiv hh_b03 hh_b05a hh_b04
gen female=hh_b03==2 
lab var female "1= indivdual is female"
gen age=hh_b05a
lab var age "Indivdual age"
gen hh_head=hh_b04 if hh_b04==1
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b05 hh_b04
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_person_ids.dta", replace


************************************************
*HOUSEHOLD SIZE - RH complete 7/15/21, not checked
************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\hh_mod_b", clear
gen hh_members = 1	//Generate this so we can sum later and identify the # of hh members (each member gets a HHID so summing will help collapse this to see hh #)
rename hh_b04 relhead 
rename hh_b03 gender
gen fhh = (relhead==1 & gender==2)	//Female heads of households
collapse (sum) hh_members (max) fhh, by (case_id hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"

merge 1:1 case_id hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen keep(2 3)
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${MWI_IHS_IHPS_W4_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=weight*${MWI_IHS_IHPS_W4_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=weight*${MWI_IHS_IHPS_W4_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhsize.dta", replace

********************************************************************************
*GPS COORDINATES *
********************************************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\householdgeovariables_ihs5.dta", clear
ren HHID hhid
tostring hhid, replace
merge 1:m case_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen keep(3) 
ren ea_lat_mod latitude
ren ea_lon_mod longitude
keep case_id latitude longitude
gen GPS_level = "hhid"

save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_coords.dta", replace

************************************************
*PLOT AREAS - CWL complete 10/27/22. not checked. // Updated 5/11/23 by HKS to model NGA W3; major changes are merging in conversion factors and calculating field_size (used later in plot rents)
************************************************
//CWL: adding module o2 include tree/permcrop roster here
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_c.dta", clear // HS 2.3.23: RAINY SEASON crop data; data about PLOT ID, Garden ID (how many plots per HH? How many gardens and how many plots in that garden?) GPS conditions, area reporting info, etc.
	gen season = 0 
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_j.dta" // HS 2.3.23: DRY SEASON crop data; more GARDEN and PLOT info
	replace season = 1 if season ==. 
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_o2.dta" // HS 2.3.23:  PERMANENT CROPS
	replace season = 2 if season == .

* Counting acreage
gen area_acres_est = ag_c04a if ag_c04b == 1 										//Self-report in acres - rainy season 
replace area_acres_est = (ag_c04a*2.47105) if ag_c04b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_c04a*0.000247105) if ag_c04b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_j05a if ag_j05b==1										//Replace with dry season measures if rainy season is not available
replace area_acres_est = (ag_j05a*2.47105) if ag_j05b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_j05a*0.000247105) if ag_j05b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_o04a if ag_o04b==1										//Permanent crops in acres
replace area_acres_est = (ag_o04a*2.47105) if ag_o04b == 2 & area_acres_est ==.		//Permanent crops in hectares
replace area_acres_est = (ag_o04a*0.000247105) if ag_o04b == 3 & area_acres_est ==. //Permanent crops in square meters

* GPS MEASURE
gen area_acres_meas = ag_c04c														//GPS measure - rainy
replace area_acres_meas = ag_j05c if area_acres_meas==. 							//GPS measure - replace with dry if no rainy season measure
replace area_acres_meas = ag_o04c if area_acres_meas == . 							//GPS measure - permanent crops
keep if area_acres_est !=. | area_acres_meas !=. 									//Keep if acreage or GPS measure info is available

lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 

gen field_size= (area_acres_est* (1/2.47105))
replace field_size = (area_acres_meas* (1/2.47105))  if field_size==. & area_acres_meas!=. 
ren plot plot_id
ren gardenid garden_id
keep hhid case_id plot_id garden_id area_acres_est area_acres_meas field_size season	
gen gps_meas = area_acres_meas!=. 
lab var gps_meas "Plot was measured with GPS, 1=Yes" 

lab var area_acres_meas "Plot area in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_areas.dta", replace 

************************************************
*PLOT DECISION MAKERS - HKS 5/24/23: copied from RH, adapting accordingly because CWL's version is weird
************************************************
use "${MWI_IHS_IHPS_W4_raw_data}/hh_mod_b.dta", clear  	
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_o2.dta"	 
ren PID indiv	 							
drop if indiv==.
gen female =hh_b03==2
gen age = hh_b05a
gen head = hh_b04==1 if hh_b04!=.
gen fhh = 1 if hh_b03 == 2 & hh_b04 == 1
keep female fhh age case_id hhid head indiv
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_gender_merge.dta", replace 

use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_d.dta", clear 	
ren gardenid garden_id
ren plotid plot_id
drop if ag_d14==. 
gen cultivated = 1 if ag_d14==1 	
drop if plot_id==""	// 0 obs deleted
gen dry = strpos(plot_id, "D") > 0 	//To code for dry season as a variable used later, 0 = rainy, 1 = dry (plot level); all rainy for now
gen dry_garden = strpos(garden_id, "D") > 0  // "dry" is plot level, "dry_garden" is garden level (plot and garden can be different)
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_rainy_season_plot_manager.dta", replace

	
// DRY SEASON plot manager data
use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_k.dta", clear 
ren gardenid garden_id
ren plotid plot_id
drop if plot_id==""
gen dry = strpos(plot_id, "D") > 0   
gen dry_garden = strpos(garden_id, "D") > 0 // "dry" is plot level, "dry_garden" is garden level (plot and garden can be different)
drop if ag_k36==. 
gen cultivated = ag_k36==1 	
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_dry_season_plot_manager.dta", replace

	
// Combine DRY AND RAINY SEASON:
append using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_rainy_season_plot_manager.dta"
	recode cultivated (.=0)

* Gender/age variables - decision makers
gen indiv = ag_d01 // RH note - the decision-maker concerning crops, not respondent id
replace indiv = ag_k02 if indiv==. &  ag_k02!=.	// ag_k02 is "Who in the household makes the decisions concerning crops to be planted..." 

* Merge rainy+dry season plot manager data with individual person data (by gender)
merge m:1 hhid case_id indiv using  "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_gender_merge.dta", gen(dm1_merge) keep (1 3)	// Dropping unmatched from using // RH Confirm request: can PIDs be mapped onto ag_d01? (Ag_d01 is the id of the plot decision maker, not the respondent, where the gender merge uses PID as indiv)

** DECISION-MAKER Variables
	*First decision-maker 
		gen dm1_female = female // replace females for first manager with new variable so we can add new identifiers for later managers below. 
		drop female indiv	// in order to do next two manager variables. 

		* Second decision-maker 
		gen indiv = ag_d01_2a // check question - ag_d01_1, should this be used?
		replace indiv =ag_k02_2a if indiv==. &  ag_k02_2a!=.
		merge m:1 hhid case_id indiv using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using 
		gen dm2_female = female
		drop female indiv

		* Third decision-maker 
		gen indiv = ag_d01_2b
		replace indiv =ag_k02_2b if indiv==. &  ag_k02_2b!=.
		merge m:1 hhid case_id indiv using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
		gen dm3_female = female
		drop female indiv 
	
*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.) // dm_gender = 1 if male
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.) // dm_gender = 2 if female
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.) // dm_gender = 3 if mixed (at least 1 male and at least 1 female dm)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid case_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhsize.dta", nogen keep (1 3)								
replace dm_gender = 1 if fhh==0 & dm_gender==. // HKS 5.24.23: 0 real changes
replace dm_gender = 2 if fhh==1 & dm_gender==. // HKS 5.24.23: 0 real changes
*ren plotid plot_id 

* HKS 5.24.23: Bring in plot_areas so we have field_size in final output, like NGA W3
merge 1:1 hhid case_id garden_id plot_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_areas.dta", nogen keep(1 3) keepusing(field_size)

drop if  plot_id==""
keep hhid case_id plot_id case_id garden_id dm_gender cultivated field_size fhh
lab var cultivated "1=Plot has been cultivated"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_decision_makers.dta", replace


********************************************************************************
* FORMALIZED LAND RIGHTS * - No formalized land rights data available for W4
********************************************************************************
/*
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_b2.dta", clear
gen season=0
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_i2.dta"
replace season=1 if season==.
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen formal_land_rights=1 if ag_b213__0 !=. & ag_b213__1 !=. 
replace formal_land_rights=1 if ag_i213a !=. & ag_i213b !=.
replace formal_land_rights=0 if  ag_b213__0 !=1 & ag_b213__1 !=1
replace formal_land_rights=0 if ag_i213a !=1 & ag_i213b

//Primary Land Owner
gen indiv=ag_b204_2__0
replace indiv=ag_i204a_1 if ag_i204a_1!=. & indiv==.
recast str50 hhid, force 
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 684 observations matched 
ren indiv primary_land_owner
ren female primary_land_owner_female
drop age hh_head

//Secondary Land Owner
gen indiv=ag_b204_2__1
replace indiv=ag_i204a_2 if ag_i204a_2!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 67 observations matched 
ren indiv secondary_land_owner_1
ren female secondary_land_owner_female_1
drop age hh_head

//Secondary Land Owner #2 
gen indiv=ag_b204_2__2
replace indiv=ag_i204a_3 if ag_i204a_3!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 16 observations matched 
ren indiv secondary_land_owner_2
ren female secondary_land_owner_female_2
drop age hh_head

//Secondary Land Owner #3 
gen indiv=ag_b204_2__3
replace indiv=ag_i204a_4 if ag_i204a_4!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 11 observations matched 
ren indiv secondary_land_owner_3
ren female secondary_land_owner_female_3
drop age hh_head

gen formal_land_rights_f=1 if formal_land_rights==1 & (primary_land_owner_female==1 | secondary_land_owner_female_1==1 | secondary_land_owner_female_2==1 | secondary_land_owner_female_3 ==1 )
preserve
collapse (max) formal_land_rights_f, by(hhid) //MGM 10.6.2023: QUESTION FOR ALT - I removed indiv from by() as compared to Nigeria because we have both primary and secondary land owners in MWI and we need one obs per househould, correct?		
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_land_rights_ind.dta", replace
restore
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)
keep hhid formal_land_rights_hh
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_rights_hh.dta", replac
*/

************************************************
*CROP UNIT CONVERSION FACTORS
************************
use "${MWI_IHS_IHPS_W4_raw_data}/Agricultural Conversion Factor Database.dta", clear
ren crop_code crop_code_full
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_cf.dta", replace

*** Caloric conversions - 9/26/22 CWL addressed comments from ALT
	use "${MWI_IHS_IHPS_W4_raw_data}/caloric_conversionfactor.dta", clear
	
* Notes Addressed by CWL in Code Below * 	
	/*ALT: It's important to note that the file contains some redundancies (e.g., we don't need maize flour because we know the caloric value of the grain; white and orange sweet potato are identical, etc. etc.)
	So we need a step to drop the irrelevant entries. */
	//Also there's no way tea and coffee are just tea/coffee
	//Also, data issue: no crop code is indicative of green maize (i.e., sweet corn); I'm assuming this means cultivation information is not tracked for that crop
	//Calories for wheat flour are slightly higher than for raw wheat berries.
	
	* Drop redundant items
	drop if inlist(item_code, 101, 102, 103, 105, 202, 204, 206, 207, 301, 305, 405, 813, 820, 822, 901, 902) | cal_100g == .

	* Standardize item names to all UPPER CASE
	local item_name item_name
	foreach var of varlist item_name{
		gen item_name_upper=upper(`var')
	}
	
	* Create new crop code
	gen crop_code = .
	count if missing(crop_code) //106 missing (number of obs)
	
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
	replace crop_code=33 if strpos(item_name_upper, "PEARL MILLET") | strpos(item_name_upper, "MCHEWERE")
	replace crop_code=35 if strpos(item_name_upper, "SOYABEAN")
	replace crop_code=36 if strpos(item_name_upper, "PIGEONPEA")| strpos(item_name_upper, "NANDOLO")
	replace crop_code=38 if strpos(item_name_upper, "SUNFLOWER")
	replace crop_code=39 if strpos(item_name_upper, "SUGAR CANE")
	replace crop_code=40 if strpos(item_name_upper, "CABBAGE")
	replace crop_code=41 if strpos(item_name_upper, "TANAPOSI")
	replace crop_code=42 if strpos(item_name_upper, "NKHWANI")
	replace crop_code=43 if strpos(item_name_upper, "OKRA")
	replace crop_code=44 if strpos(item_name_upper, "TOMATO")
	replace crop_code=45 if strpos(item_name_upper, "ONION")
	replace crop_code=46 if strpos(item_name_upper, "PIGEON PEA")
	replace crop_code=47 if strpos(item_name_upper, "PAPRIKA")

	count if missing(crop_code) //87 missing
	
	// food from tree/permanent crop master list
	replace crop_code=49 if strpos(item_name_upper,"CASSAVA") 
	replace crop_code=50 if strpos(item_name_upper,"TEA")
	replace crop_code=51 if strpos(item_name_upper,"COFFEE") 
	replace crop_code=52 if strpos(item_name_upper,"MANGO")
	replace crop_code=53 if strpos(item_name_upper,"ORANGE" )
	replace crop_code=54 if strpos(item_name_upper,"PAWPAW" )| strpos(item_name_upper, "PAPAYA")
	replace crop_code=55 if strpos(item_name_upper,"BANANA" )
	
	replace crop_code=56 if strpos(item_name_upper,"AVOCADO" )
	replace crop_code=57 if strpos(item_name_upper,"GUAVA" )
	replace crop_code=58 if strpos(item_name_upper,"LEMON" )
	replace crop_code=59 if strpos(item_name_upper,"NAARTJE" )| strpos(item_name_upper, "TANGERINE")
	replace crop_code=60 if strpos(item_name_upper,"PEACH" )
	replace crop_code=61 if strpos(item_name_upper,"POZA") | strpos(item_name_upper, "APPLE")
	replace crop_code=63 if strpos(item_name_upper,"MASAU")
	replace crop_code=64 if strpos(item_name_upper,"PINEAPPLE" )
	replace crop_code=65 if strpos(item_name_upper,"MACADEMIA" )
	//replace crop_code= X if strpos(item_name_upper,"COCOYAM") No cropcode for cocoyam.
	count if missing(crop_code) //76 missing
	drop if crop_code == . 
	
	// Extra step for maize: maize grain (104) is same as shelled (removed from cob) maize
	// Use shelled/unshelled  ratio in unit conversion file
	//ALT: m:m should be a 1:m merge because duplicates indicate a problem. 
	gen unit = 1 //kg
	gen region = 1 //region doesn't matter for our purposes but will help reduce redundant entries after merge.
	merge 1:m crop_code unit region using "${MWI_IHS_IHPS_W4_raw_data}/Agricultural Conversion Factor Database.dta", nogen keepusing(condition shell_unshelled) keep(1 3)
	replace edible_p = shell_unshelled * edible_p if shell_unshelled !=. & item_code==104
	
	// Extra step for groundnut: single item with edible portion that implies that value is for unshelled
	// If it's shelled, assume edible portion is 100
	replace edible_p = 100 if strpos(item_name,"Groundnut") & strpos(item_name, "Shelled") // 0 changes 
	
	//ALT: you need to keep condition to successfully merge this with the crop harvest data
	//Note to double check and make sure that you don't need to fill in the missing condition codes.
	keep item_name crop_code cal_100g edible_p condition
	
	// Assume shelled if edible portion is 100
	replace condition=1 if edible_p==100
	
	// More matches using crop_code_short
	ren crop_code crop_code_short
	save "${MWI_IHS_IHPS_W4_raw_data}/caloric_conversionfactor_crop_codes.dta", replace

********************************************************************************
*ALL PLOTS 
********************************************************************************
/*This is based off Malawi W2. 
Inputs to this section: 
					___change__> sect11f: area_planted, date of last harvest, losses, actual harvest of tree/permanent crop, anticipated harvest of field crops, expected sales
					__change___> secta3i: date of harvest, quantity harvested, future expected harvest
					ag_mod_i_13 / ag_mod_o_13: actual sales
				Workflow:
					Get area planted/harvested
					Determine what's *actually* a monocropped plot 
					Value crop (based on estimated value, anticipated sales value, or actual sales value? Seems like going in reverse order is best)*/
					
/*Purpose: (from Uganda W5)
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.

Note: Malawi has dry season, rainy season, and permanent/tree crop data in separate modules
*/

   ***************************
	*Crop values 
	***************************
	//Nonstandard unit values (kg values in plot variables section)
	use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_i.dta", clear
	gen season=0 //rainy season 
	append using "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_o.dta" 
	recode season (.=1) //dry season 
	append using "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_q.dta"
	recode season (.=2) //tree or permanent crop
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	keep if ag_i01==1 | ag_o01==1 | ag_q01==1 // keep if crop was sold
	ren ag_i02a sold_qty //rainy: total sold
	replace sold_qty = ag_o02a if sold_qty ==. & ag_o02a!=. //dry
	replace sold_qty = ag_q02a if sold_qty ==. & ag_q02a!=. //tree/permanent 
	ren ag_i02b unit
	ren ag_i02c condition
	replace unit = ag_o02b if unit ==. & ag_o02b! =.
	replace unit = ag_q02b if unit ==. & ag_q02b! =.
	ren ag_i03 sold_value
	replace sold_value=ag_o03 if sold_value==. & ag_o03!=.
	replace sold_value=ag_q03 if sold_value==. & ag_q03!=.
	gen value_harvest = sold_value 	// HKS 08.08.23: As per ALT, sold_value ("total value of all crop sales") is what we want for value_harvest, since there is no observed price value data
	//count if missing(crop_code); CWL: 0 missing crop_code
	
	keep hhid case_id crop_code sold_qty unit sold_value condition value_harvest
	merge m:1 case_id hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weights.dta", nogen keep(1 3)
	keep hhid case_id sold_qty unit sold_value crop_code region district TA ea rural weight  value_harv
	lab var region "1=North, 2=Central, 3=South" 

	* Calculate average sold value per crop unit (price_unit)
	gen price_unit = sold_value/sold_qty // HS 02.07.23 3 missing values, n = 10,544
	lab var price_unit "Average sold value per crop unit"
	gen obs=price_unit!=.
	drop if price_unit==. | price_unit == 0 // HKS 4/27/23: this line is not present in W1, is it necessary?

	merge m:1 hhid case_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen keep(1 3)	
	
	* HKS 08.08.23 - for incorporating value harvested later (to avoid having to use val_harvest_est)
	preserve
	collapse (sum) value_harvest sold_qty, by(hhid crop_code unit)
	tempfile value_harvest_data
		save `value_harvest_data'
	restore
		
	* Create a value for the price of each crop at different levels
	foreach i in hhid ea TA district region {
	preserve
	bys `i' crop_code unit : egen obs_`i'_price = sum(obs) 
	collapse (median) price_unit_`i'=price_unit [aw=weight], by (`i' unit crop_code obs_`i'_price) 
	tempfile price_unit_`i'_median
	save `price_unit_`i'_median'
	restore
	}
	collapse (median) price_unit_country = price_unit (sum) obs_country_price=obs [aw=weight], by(crop_code unit)
	tempfile price_unit_country_median
	save `price_unit_country_median'
	
	***************************
	*Plot variables
	***************************	
	use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_g.dta", clear //rainy
	gen season=0 //create variable for season 
	append using "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_m.dta" //dry
	recode season(.=1)
	append using "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_p.dta" // tree/perm
	replace season = 2 if season == .
		lab var season "season: 0=rainy, 1=dry, 2=tree crop"
		label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
		label values season season 
	ren plotid plot_id
	ren gardenid garden_id
	ren hhid HHID
	merge m:1 HHID using   "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data\hh_mod_a_filt.dta", nogen keep(1 3) keepusing(ea hh_a03)
	ren HHID hhid
	replace ea = hh_a03 if ea == ""
	
	ren ag_p03 number_trees_planted // number of trees planted during last 12 months 
	recode season (.=2)
	gen crop_code_perm=ag_p0c //MGM: tree crop codes overlap with crop crop codes. Recoded to have unique numbers.
	recode crop_code_perm (2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(21=66)(100=49)(1800=68)(1900 = 69)(2000=70)

	replace crop_code=crop_code_perm if crop_code==. & crop_code_perm!=.
	label define ag_G_crop_roster__id 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "FODDER TREES" 67 "FERTILIZER TREES" 68 "FUEL WOOD TREES" 69 "OTHER (SPECIFY)"  1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", add 
		label val crop_code ag_G_crop_roster__id
		la var crop_code "Unconsolidated crops"
		
	* Consolidate crop codes (into the lowest number of the crop category)
	gen crop_code_short = crop_code //Generic level (without detail)
	recode crop_code_short (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17) //CWL:1-4=maize ; 5-10=tobacco; 11-16=groundnut; 17-26=rice
		la var crop_code_short "Generic level crop code"
		la val crop_code_short AG_G0D
		label define AG_G0D 1 "Maize" 5 "Tobacco" 11 "Groundnut" 17 "Rice", modify
		drop if crop_code_short==. //4509 obs deleted //ALT 11.18.22: this is now down to 33 obs deleted 

	* Create area variables
	gen crop_area_share=ag_g03 //rainy season // TH: this indicates proportion of plot with crop, but NGA crop_area_share indicates the unit (ie stands/ridges/heaps) that area was measured in; tree file did not ask about area planted
		label var crop_area_share "Proportion of plot planted with crop"
	replace crop_area_share=ag_m03 if crop_area_share==. & ag_m03!=. //crops dry season
	
	* Convert answers to proportions
	replace crop_area_share=0.125 if crop_area_share==1 // Less than 1/4
	replace crop_area_share=0.25 if crop_area_share==2 
	replace crop_area_share=0.5 if crop_area_share==3
	replace crop_area_share=0.75 if crop_area_share==4
	replace crop_area_share=.875 if crop_area_share==5 // More than 3/4 
	replace crop_area_share=1 if ag_g02==1 | ag_m02==1 //planted on entire plot for both rainy and dry season
	
	* Merge with plot_areas
	merge m:1 hhid case_id plot_id garden_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_areas.dta", keep(1 3) nogen //CWL: 8,467 not matches 35,826 matched //ALT 11.18.22: This is down to 437 not matched from master (not worried about using b/c we can presume those plots weren't cultivated)
	
	* Convert to hectares
	gen ha_planted=crop_area_share*area_meas_hectares
	replace ha_planted=crop_area_share*area_est_hectares if ha_planted==. & area_est_hectares!=. & area_est_hectares!=0
	replace ha_planted=ag_p02a* (1/2.47105) if ag_p02b==1 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	replace ha_planted=ag_p02a*(1/10000) if ag_p02b==3 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_ha_planted.dta", replace
	
	drop crop_area_share 
	
	//TH: Malawi w2 doesn't ask about area harvested, only if area harvested was less than area planted (y/n, without numerical info). We assume area planted=area harvested bc no extra info 
	//CWL: assume the logic of Malawi w2 that assumes area harvest = area planted because not extra information
	
	* Hectares Harvested:
	gen ha_harvested = ha_planted // HS: 15,520 obs ha_harvested == .
	replace ha_harvested=ha_planted * ag_g11_2 if ag_g11_2!=. & ha_planted!=. 	
	
** TIME VARIABLES (month planted, harvest, and length of time grown)
	* MONTH planted
		gen month_planted = ag_g05a // HS: "when [what month] did you plant the seeds...during the rainy season"
		replace month_planted = ag_m05a if month_planted==.
		lab var month_planted "Month of planting"
		
	* YEAR planted
		//codebook ag_m05b // YEAR
		//codebook ag_g05b // YEAR
		//drop if ag_m05b < 2018 
		//CWL:question asked about dry season in 2018/2019, dropping responses not in in this range - there are handful in 2001-2017
		//drop if ag_g05b < 2017 
		//There are  8,749 obs in 2017 - not dropping because it's larger
		//CWL-QUESTION: should we drop regardless?
		//ALT 11.18.22: All temporary crop production should be relevant to the survey period, so we should only be dropping tree crops whose production period ended before the survey target season. Those early plantings are headscratchers, though. I'm going to assume typos, although some are sugarcane, which can be grown as a perennial crop.
		//drop if ag_p06a < 2017 // "What was the last completed production period for the tree/permanent crop"
			* Drops 7,872 obs // HS: confused about why it drops years if its a month variable (even if its a factor)
		gen year_planted1 = ag_g05b // "When did you plant the seeds for [CROP] on this [PLOT] during the RAINY SEASON"
		gen year_planted2 = ag_m05b // HS. other season
		gen year_planted = year_planted1 // HS. Consolidate year_planted for both seasons
		replace year_planted= year_planted2 if year_planted==. // HS. Consolidate year_planted for both seasons
		lab var year_planted "Year of planting"
		
		
	* MONTH harvest started
		gen harvest_month_begin = ag_g12a
		replace harvest_month_begin=ag_m12a if harvest_month_begin==. & ag_m12a!=. //MGM: 0 changes made. Something seems to be going continually wrong the dry season data. Not a lot of information there. //ALT: Harvest data may not be available for many dry season plots because the survey was being conducted during the harvest period.
		lab var harvest_month_begin "Month of start of harvesting"
		
	* MONTH harvest ended
		gen harvest_month_end=ag_g12b
		replace harvest_month_end=ag_m12b if harvest_month_end==. & ag_m12b!=.
		lab var harvest_month_end "Month of end of harvesting"
		
		
	* MONTHS crop grown
		gen months_grown = harvest_month_begin - month_planted if harvest_month_begin > month_planted  // since no year info, assuming if month harvested was greater than month planted, they were in same year 
		replace months_grown = 12 - month_planted + harvest_month_begin if harvest_month_begin < month_planted // months in the first calendar year when crop planted 
		replace months_grown = 12 - month_planted if months_grown<1 // reconcile crops for which month planted is later than month harvested in the same year
		replace months_grown=. if months_grown <1 | month_planted==. | harvest_month_begin==.
		lab var months_grown "Total months crops were grown before harvest"

	//MGM 5.31.23 adding this - note for MWI team to add to their Waves too!
	//Plot workdays
	preserve
	gen days_grown = months_grown*30 
	collapse (max) days_grown, by(case_id hhid garden_id plot)
	save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_season_length.dta", replace
	restore
		
	* YEAR HARVESTED 
			*TH: survey did not ask for harvest year, see/ check assumptions for year:
		*MGM: 4.17.2023 - inferring harvest year from month_planted, year_planted, harvest_month_begin, and months_grown
		//all observations of months_grown less than or equal to 11 months. Hence, the following code:
		gen year_harvested=year_planted if harvest_month_begin>month_planted
		replace year_harvested=year_planted+1 if harvest_month_begin<month_planted
		replace year_harvested=. if year_planted!=2007 & year_planted!=2008 & year_planted!=2009 & year_planted!=2010 //choosing not to infer year_harvested from observations with obscure planting years instead of dropping observations with obscure planting years
		//lab var year_harvested "Year of harvesting
		
		
	* DATE PLANTED
		//CWL-QUESTION: do we need the date_planted?
		gen date_planted = mdy(month_planted, 1, ag_g05b) if ag_g05b!=. // where ag_g05b is year planted (rainy)
		/* replace date_planted = mdy(month_planted-12, 1, ag_g05b) if month_planted>12 & ag_g05b!=. // 0 changes bc month_planted is always < 12
		replace date_planted = mdy(month_planted-12, 1, ag_m05b) if month_planted>12 & ag_m05b!=. // 0 changes bc month_planted is always < 12 */
		replace date_planted = mdy(month_planted, 1, ag_m05b) if date_planted==. & ag_m05b!=. // if no date planted and year_planted_ds is not empty
		
		
	* DATE HARVESTED 
		* Section coded by HS/MGM 4.23; not checked
		gen date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if ag_g05b==2010
		replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if date_harvested==. & ag_m05b==2010
		replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if month_planted<=12 & harvest_month_begin>month_planted & date_harvest==. & ag_g05b!=. //assuming if planted in 2010 and month harvested is later than planted, it was harvested in 2010
		replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if month_planted<=12 & harvest_month_begin>month_planted & date_harvest==. & ag_m05b!=.
		replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_g05b!=.
		replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_m05b!=.

	* Calculate days of growth
	format date_planted %td
	format date_harvested %td
	gen days_grown=date_harvest-date_planted // 647 missing values
	
	* Calculate overlap date (of harvesting and planting)
	bys plot hhid : egen min_date_harvested = min(date_harvested)
	bys plot hhid : egen max_date_planted = max(date_planted)
	gen overlap_date = min_date_harvested - max_date_planted 

 	//ALT: Need to remember garden_id here
	* Generate crops_plot variable for number of crops per plot. 
		* This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs=1
		replace obs=0 if ag_g13a==0 | ag_m11a==0 | ag_p09a==0  
		//obs=0 if no crops were harvested; 
		collapse (sum) crops_plot = obs, by(hhid case_id garden_id plot season)
		tempfile ncrops
		save `ncrops'
	restore
	merge m:1 hhid garden_id plot season using `ncrops', nogen /// HKS 5/10/23: 43,766 matched
		
		
	* Generating Monocropped Plot Variables (pt 1)
		bys hhid plot garden_id season: egen crops_avg = mean(crop_code_short) //checks for diff versions of same crop in the same plot
		gen purestand = 1 if crops_plot==1 | crops_avg == crop_code_short //HKS 5/3/23: 28k missing values 
		gen perm_crop=1 if ag_p0c!=. // HS 2.14.23: 35,880 missing values
		bys hhid garden_id plot: egen permax = max(perm_crop) // HS 2.14.23: 35,880 missing
			//ALT: Seems like the number of permanet crops recorded in this wave dropped off quite a bit - something maybe to follow up on later.
		
	* Checking for relay-cropping; Generally does not occur in Malawi
		bys hhid plot month_planted year_planted : gen plant_date_unique=_n
		bys hhid plot harvest_month_begin : gen harv_date_unique=_n //TH: survey does not ask year of harvest for crops
		bys hhid plot : egen plant_dates = max(plant_date_unique)
		bys hhid plot : egen harv_dates = max(harv_date_unique) 
	
		replace purestand=0 if (crops_plot>1 & (plant_dates>1 | harv_dates>1))  | (crops_plot>1 & permax==1)  
		//ALT 2.2023: At this point, roughly 30% of plots are purestand, which seems fairly reasonable given the strictness of our criteria.
		gen any_mixed=!(ag_g01==1 | ag_m01==1 | (perm_crop==1 & purestand==1)) 
		bys hhid plot : egen any_mixed_max = max(any_mixed)
		replace purestand=1 if crops_plot>1 & plant_dates==1 & harv_dates==1 & permax==0 & any_mixed_max==0 // HS 2.14.23: 0 changes
		
		replace purestand=1 if crop_code==crops_avg
		replace purestand=0 if purestand==.
		drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	* 07.10.23 from NGA
	ren ag_g13_1 val_harvest_est
	ren ag_g13a quantity_harvested
	gen val_unit_est = val_harvest_est/quantity_harvested
	
	*** Rescaling plots 
	replace ha_planted = ha_harvest if ha_planted==. //HKS 5/3/23: 0 changes
	
	* Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > area_meas_hectares & ha_harvest < ha_planted & ha_harvest!=. //HKS 5/3/23: 0 changes
	gen percent_field=ha_planted/area_meas_hectares
	
	* Generating total percent of purestand and monocropped on a field
	bys hhid plot: egen total_percent = total(percent_field)
	replace percent_field = percent_field/total_percent if total_percent>1 & purestand==0
	replace percent_field = 1 if percent_field>1 & purestand==1
	replace ha_planted = percent_field*area_meas_hectares 
	replace ha_harvest = ha_planted if ha_harvest > ha_planted

	* Renaming unit code for merge
	ren ag_g13b unit // Rainy season units
	replace unit = ag_m11b if unit==. & ag_m11b !=. 
	replace unit = ag_p09b if unit==. & ag_p09b !=. // 0 changes
	lab define ag_g13b 3 "90 KG BAG" 11 "BASKET (DENGU)" 14 "PAIL (MEDIUM)" 98 "HEAP", add //TH: adding units from conversion file to merge 4/29
	
	* Renaming quantity harvested for merge	
	replace quantity_harvested = ag_m11a if quantity_harvested==. & ag_m11a !=.
	replace quantity_harvested = ag_p09a if quantity_harvested==. & ag_p09a !=. // Tree/Permanent crops
	
	* Merge in HH module A to bring in region info 

	merge m:1 case_id hhid using "${MWI_IHS_IHPS_W4_raw_data}/HH_MOD_A_FILT.dta", nogen keep(1 3) // HKS 5/5/23: 43,766 obs matched
	
	* Rename condition vars in master to match using file 
	ren ag_p09_1 condition // condition of tree/perm crop
	 
	* Recode and rename value labels for tree/perm condition for consistency; dry = shelled, fresh = unshelled
	recode condition (1=2) (2=1) (3=3)
	lab define condition 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A", modify 
	lab val condition condition 
	
	* Recode unit spelling variations to match conversion files
	gen specify_unit_new=ag_g13b_oth
	replace specify_unit_new = "90 KG BAG" if strpos(ag_g13b_oth,"90") 
	replace specify_unit_new = "50 KG BAG" if strpos(ag_g13b_oth,"50")
	replace specify_unit_new = "70 KG BAG" if strpos(ag_g13b_oth,"70")
	replace specify_unit_new = "60 KG BAG" if strpos(ag_g13b_oth,"60")
	replace specify_unit_new = "BASKET (DENGU)" if strpos(ag_g13b_oth,"Basket") | strpos(ag_g13b_oth,"BASKET") | strpos(ag_g13b_oth,"basket") | strpos(ag_g13b_oth,"dengu") | strpos(ag_g13b_oth,"Dengu") | strpos(ag_g13b_oth,"DENGU")
	replace specify_unit_new = "PAIL (SMALL)" if strpos(ag_g13b_oth,"small") | strpos(ag_g13b_oth,"Small") | strpos(ag_g13b_oth,"SMALL") //grouping basin and pail labelled as small into PAIL (SMALL)
	replace specify_unit_new = "PAIL (MEDIUM)" if strpos(ag_g13b_oth,"Pail medium") | strpos(ag_g13b_oth,"Pail (medium)") | strpos(ag_g13b_oth,"PAIL( MEDIUM)")
	replace specify_unit_new = "PAIL (LARGE)" if specify_unit_new == "Basin Large" | specify_unit_new == "Large pail" | specify_unit_new == "Pail Large" |specify_unit_new =="large pail"
	replace specify_unit_new = "PIECE" if specify_unit_new== "PIECES"
	replace specify_unit_new = "TONNE" if specify_unit_new== "TINA" | specify_unit_new== "Tina" | specify_unit_new== "Tone" | specify_unit_new== "Tones" | specify_unit_new== "Tornes" | specify_unit_new== "tan" | specify_unit_new== "tans" | specify_unit_new== "tone" | specify_unit_new== "tones" | specify_unit_new== "torn"
	replace specify_unit_new = "40 LITER PAIL" if strpos(ag_g13b_oth,"40")
	replace specify_unit_new = "5 LITER PAIL" if strpos(ag_g13b_oth,"5 litre") | strpos(ag_g13b_oth,"5 LITRE") | strpos(ag_g13b_oth,"5Litre") 
	replace specify_unit_new = "25 KG BAG" if strpos(ag_g13b_oth,"25")
	//replace specify_unit_new = "BAGS" if strpos(ag_g13b_oth,"BAG")|  strpos(ag_g13b_oth,"Bag")
	
	replace unit = 3 if unit==13 & specify_unit_new=="90 KG BAG"
	replace unit = 2 if unit==13 & specify_unit_new=="50 KG BAG"
	replace unit = 11 if unit==13 & specify_unit_new=="BASKET (DENGU)"
	replace unit = 4 if unit==13 & specify_unit_new=="PAIL (SMALL)"
	replace unit = 14 if unit==13 & specify_unit_new=="PAIL (MEDIUM)"
	replace unit = 5 if unit==13 & specify_unit_new=="PAIL (LARGE)"
	replace unit = 9 if unit==13 & specify_unit_new=="PIECE"
		
	
***** CONVERSION FACTORS ***** 
	capture confirm file "${MWI_IHS_IHPS_W4_raw_data}/ihs_seasonalcropconversion_factor_2020_alt-mod_update.dta"
	if !_rc {
	merge m:1 region crop_code unit condition using "${MWI_IHS_IHPS_W4_raw_data}/ihs_seasonalcropconversion_factor_2020_alt-mod_update.dta", keep(1 3) gen(cf_merge) //HS 2.27.23: 32,228 matched; 3,666 not matched
	// TH: no conversion data for tree crops; tree crop n=7886; unit==. n=5514; crop_code==. n=2718
	//ALT 11.18.22: Main source of unmatched is now g and kg; make sure to fill those in before converting. Outstanding after that is "Tina" under "other" category. 
} 
	else {
 di as error "Updated conversion factors file not present; harvest data will likely be incomplete"
	}

	* Filling in empty conversions using unit description
	replace conversion = 1 if unit == 1 & conversion==.
	replace conversion = 50 if unit==2 & conversion==. // Unit 2 = "50 KG BAG"
	replace conversion = 90 if unit==3 & conversion==. // Unit 2 = "90 KG BAG"
	gen quant_harv_kg= quantity_harvested*conversion 

merge m:1 case_id hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weights.dta", nogen // HKS 5/5/2023: 43,766 matched, 2191 not matched from using (weights.dta)
replace ea = hh_a03 if ea == ""
replace ea = ea_id if ea == ""
	
	merge m:1 hhid crop_code unit using `value_harvest_data', keepusing(value_harvest) // HS 08.08.23: 48,481 unmatched from master - not sure why

	gen val_unit = value_harvest/quantity_harvested // HKS 08.08.23: swapped "val_harvest_est" out for "value_harvest"
	gen val_kg = value_harvest/quant_harv_kg // HKS 08.08.23: swapped "val_harvest_est" out for "value_harvest"
	
	
	gen plotweight = ha_planted*weight
	gen obs=quantity_harvested>0 & quantity_harvested!=.
		
foreach i in ea TA district region hhid { 
preserve
	bys crop_code `i' : egen obs_`i'_kg = sum(obs)
	collapse (median) val_kg_`i'=val_kg  [aw=plotweight], by (`i' crop_code obs_`i'_kg)
	tempfile val_kg_`i'_median
	save `val_kg_`i'_median'
restore
}		
	
preserve
collapse (median) val_kg_country = val_kg (sum) obs_country_kg=obs [aw=plotweight], by(crop_code)
tempfile val_kg_country_median
save `val_kg_country_median'
restore
	
foreach i in ea TA district region hhid  {
preserve
	bys `i' crop_code unit : egen obs_`i' = sum(obs)
	collapse (median) val_unit_`i'=val_unit (sum) obs_`i'_unit=obs  [aw=plotweight], by (`i' unit crop_code)
	tempfile val_unit_`i'_median
	save `val_unit_`i'_median'
restore
	merge m:1 `i' unit crop_code using `price_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' unit crop_code using `val_unit_`i'_median', nogen keep(1 3)
	merge m:1 `i' crop_code using `val_kg_`i'_median', nogen keep(1 3)
}

preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit=obs [aw=plotweight], by(crop_code unit)
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore
	
merge m:1 unit crop_code using `price_unit_country_median', nogen keep(1 3) 
merge m:1 unit crop_code using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)


//We're going to prefer observed prices first
foreach i in region district TA ea {
	replace val_unit = price_unit_`i' if obs_`i'_price>9
	replace val_kg = val_kg_`i' if obs_`i'_kg >9
}
	gen val_missing = val_unit==.
	replace val_unit = price_unit_hhid if price_unit_hhid!=.
	
	
foreach i in region district TA ea {
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing==1
} 
	replace val_unit = val_unit_hhid if val_unit_hhid!=. & val_missing==1
	replace val_kg = val_kg_hhid if val_kg_hhid!=. //Preferring household values where available.
//All that for these two lines:
	replace val_harvest_est=val_unit*quantity_harvested if val_harvest_est==.
	*replace value_harvest=val_kg*quant_harv_kg if value_harvest==. // HKS 08.08.2023: Value harvest does not exist at this point
	
	//Replacing conversions for unknown units
*replace val_unit = val_harvest_est/quantity_harvested if val_unit==. // HKS 08.08.23: I believe I had (in error) previously replaced many "value_harvest" with "val_harvest_est"; now that I've generated value_harvest, rework the code accordingly:
	drop val_unit
	gen val_unit = value_harvest/quantity_harvested
	*gen val_kg = value_harvest/quant_harv_kg

preserve
	collapse (mean) val_kg, by (hhid case_id crop_code)
	ren val_kg hh_price_mean
	lab var hh_price_mean "Average price reported for kg in the household"
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_crop_prices_for_wages.dta", replace
restore
preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit=obs [aw=plotweight], by(crop_code unit)
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_crop_prices_median_country.dta", replace //This gets used for self-employment income. 
restore

	**** Adding Caloric conversion
	// Add calories if the prerequisite caloric conversion file exists
	capture {
		confirm file `"${MWI_IHS_IHPS_W4_raw_data}/caloric_conversionfactor_crop_codes.dta"' 
	} 
	if _rc!=0 {
		display "Note: file ${MWI_IHS_IHPS_W4_raw_data}/caloric_conversionfactor_crop_codes.dta does not exist - skipping calorie calculations"		
	}
	if _rc==0{
		//ren calories_100g-edible_fraction {, cal_100g edible_p} this line of code may be needed
		gen calories=.
*		gen calories_100g=. // HKS 5/5/23: this isn't doing anything, isn't used
*		gen edible_fraction=1 // HKS 5/5/23: this isn't doing anything, isn't used; edible_portion already exists
		merge m:1 crop_code_short condition using "${MWI_IHS_IHPS_W4_raw_data}/caloric_conversionfactor_crop_codes.dta", nogen keep(1 3)
				*ren  crop_code_short crop_code
				// HS 5/5/23: 42,208 obs not matching; only 3749 matching; seems pretty extreme...
	
		// logic for units: calories / 100g * kg * 1000g/kg * edibe perc * 100 / perc * 1/1000 = cal
		replace calories = cal_100g * quant_harv_kg * edible_p / 1000
		count if missing(calories) // HKS 5/5/23: missing 44,278
	}


	//AgQuery
	collapse (sum) quant_harv_kg ha_planted ha_harvest value_harvest number_trees_planted percent_field /*calories*/ (max) months_grown, by(region district ea hhid case_id /*y4*/ plot_id garden_id crop_code purestand area_meas_hectares season) // HKS 5/5/23: copied from W1, added garden_id, HHID
	bys hhid case_id plot_id garden_id: egen percent_area = sum(percent_field) // HKS 5/5/23: copied from W1, added garden_id, HHID
	bys hhid case_id plot_id garden_id: gen percent_inputs = percent_field/percent_area // HKS 5/5/23: copied from W1, added garden_id, HHID
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops

*	ren  plotid plot_id 
	* HKS 5.24.23: Chae wrote a "single_plot_decision_makers.dta" instead of "plot_decision_makers.dta"; need to compare
	merge m:1 hhid plot_id garden_id case_id /*y4*/ using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_decision_makers.dta",  nogen keep(1 3) keepusing(dm_gender) // HKS 5/10/23: 5,989 obs NOT matching; 39,861 matched
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_all_plots.dta", replace

	
************************
*TLU (Tropical Livestock Units) // HKS 5/10/23: hasn't been updated 
************************
use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_r1.dta", clear		//EEE 10.1.19 even though this runs, I would try to always match the dta file exactly in terms of capitalization
gen tlu_coefficient=0.5 if (ag_r0a==304|ag_r0a==303|ag_r0a==302|ag_r0a==301) //bull, cow, steer & heifer, calf [for Malawi]
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308) //goat, sheep
replace tlu_coefficient=0.2 if (ag_r0a==309) //pig
replace tlu_coefficient=0.01 if (ag_r0a==3310|ag_r0a==315) //lvstckid==12|lvstckid==13) //chicken (layer & broiler), duck, other poultry (MLW has "other"?), hare (not in MLW but have hen?) AKS 5.15		
//EEE 10.1 From looking at other instruments/waves, I would include 311 LOCAL-HEN, 313-LOCAL-COCK, 3314 TURKEY/GUINEA FOWL, and 319 DOVE/PIGEON in the line above
replace tlu_coefficient=0.3 if ag_r0a==3305 // donkey
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Livestock categories
gen cattle=inrange(ag_r0a,301,304)
gen smallrum=inlist(ag_r0a,307,308,309) //inlcudes sheep, goat			//EEE 10.1 inrange vs. inlist
gen poultry=inlist(ag_r0a,311,313,315,319,3310,3314)  //includes pigeon (319)		//EEE 10.1 changed to reflect list above
gen other_ls=ag_r0a==318 | 3305 | 3304 // inlcludes other, donkey/horse, ox		//EEE 10.1 must include ag_r0a= with every single or clause
gen cows=ag_r0a==303
gen chickens= ag_r0a==313 | 311 | 3310 | 3314 // includes local cock (313), local hen (311),  chicken layer (3310), and turkey (3314)		//EEE 10.1 same problem here
ren ag_r0a livestock_code

*Number of livestock owned, present-day
ren ag_r02 nb_ls_today
gen nb_cattle_today=nb_ls_today if cattle==1
gen nb_smallrum_today=nb_ls_today if smallrum==1
gen nb_poultry_today=nb_ls_today if poultry==1
gen nb_other_ls_today=nb_ls_today if other==1 
gen nb_cows_today=nb_ls_today if cows==1
gen nb_chickens_today=nb_ls_today if chickens==1
gen tlu_today = nb_ls_today * tlu_coefficient

lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (horse, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_today "Number of livestock owned as of today" 

*Number of livestock owned, 1 year ago
//ren ag_r07 nb_ls_1yearago // Help - number of different livestock 1 year ago - wasn't working when I renamed the variable for some reason AKS 6.12.19 //VAP 08/16/2019: move this line after line 503 or rename ag_r07 as nb_ls_1yearago in lines 496-503. 		//EEE 10.1 fixed this down below
gen nb_cattle_1yearago = ag_r07 if cattle==1
gen nb_smallrum_1yearago=ag_r07 if smallrum==1
gen nb_poultry_1yearago=ag_r07 if poultry==1
gen nb_other_1yearago=ag_r07 if other==1
gen nb_cows_1yearago=ag_r07 if cows==1
gen nb_chickens_1yearago=ag_r07 if chickens==1
gen nb_ls_1yearago = ag_r07
gen tlu_1yearago = ag_r07 * tlu_coefficient

lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminants owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of poultry as of 12 months ago"
lab var nb_other_1yearago "Number of other livestock (horse, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_ls_1yearago "Number of livestock owned 12 months ago"

recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
drop tlu_coefficient
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_TLU_Coefficients.dta", replace

//ALT 01.31.23: Replace this with updated gross crop revenue code. 


************************
*GROSS CROP REVENUE // HKS 5/10/23: hasn't been updated 
************************



************************************************
*CROP EXPENSES - (W.I.P. by team MWI 5/3/2023 - 5/17/2023)
************************************************
/* Explanation of changes
MGM transferring notes from ALT: This section has been formatted significantly differently from previous waves and the Tanzania template file (see also NGA W3 and TZA W3-5).
Previously, inconsistent nomenclature forced the complete enumeration of variables at each step, which led to accidental omissions messing with prices.
This section is designed to reduce the amount of code needed to compute expenses and ensure everything gets included. We accomplish this by 
taking advantage of Stata's "reshape" command to take a wide-formatted file and convert it to long (see help(reshape) for more info). The resulting file has 
additional columns for expense type ("input") and whether the expense should be categorized as implicit or explicit ("exp"). This allows simple file manipulation using
collapse rather than rowtotal and can easily be converted back into our standard "wide" format using reshape. 
*/

	*********************************
	* 			LABOR				*
	*********************************
	* Crop Payments: rainy
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_d.dta", clear 
	ren gardenid garden_id
	ren plotid plot_id
	ren ag_d46c qty 
	ren ag_d46f crop_code 
	ren ag_d46f_oth crop_name 
	ren ag_d46d unit 
	ren ag_d46d_oth unit_desc 
	ren ag_d46e condition
	keep hhid case_id garden_id plot_id ea_id crop_code crop_name qty unit condition
	gen season= 0
tempfile rainy_crop_payments
save `rainy_crop_payments'
				
	*Crop payments: dry
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_k.dta", clear 
	ren gardenid garden_id
	ren plotid plot_id
	ren ag_k46c crop_code 
	ren ag_k46d qty
	ren ag_k46e unit 
	ren ag_k46f condition 
	keep case_id hhid garden_id plot_id ea_id crop_code qty unit condition
	gen season= 1 
tempfile dry_crop_payments
save `dry_crop_payments'
	
	//Not including in-kind payments as part of wages b/c they are not disaggregated by worker gender (but including them as an explicit expense at the end of the labor section), combining dry & rainy payments here 
use `rainy_crop_payments', clear
	append using `dry_crop_payments'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	recast str50 hhid, force
	merge m:1 case_id hhid crop_code using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_crop_prices_for_wages.dta", nogen keep (1 3) //275 matched
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep case_id hhid val garden_id plot_id
	gen exp = "exp"
	merge m:1 hhid garden_id plot_id case_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_decision_makers.dta", nogen keep (1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments'
	

	*Hired rainy		
local qnums "46 47 48" 		
foreach q in `qnums' {
    use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_d.dta", clear
	ren gardenid garden_id
	ren plotid plot_id
	ren y4 y4_hhid
	merge m:1  hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta"
	ren ag_d`q'a1 dayshiredmale
	ren ag_d`q'a2 dayshiredfemale 
	ren ag_d`q'a3 dayshiredchild 
	ren ag_d`q'b1 wagehiredmale
	ren ag_d`q'b2 wagehiredfemale
	ren ag_d`q'b3 wagehiredchild

	capture ren TA ta
	keep region district ta ea_id rural hhid case_id garden_id plot_id *hired*
	gen season=0 
    local suffix ""
    if `q' == 46 {
        local suffix "_all"
		gen period="all"
    }
    else if `q' == 47 {
        local suffix "_nonharvest"
		gen period="harv-nonharv"
    }
    else if `q' == 48 {
        local suffix "_harvest"
		gen period="harv-nonharv"
    }
    tempfile rainy_hired`suffix'
    save `rainy_hired`suffix'', replace
}

	*Hired dry
	//MGM: Unlike the rainy season, the survey instrument does not delineate between all, non-harvest, and harvest for hired labor during the dry season, hence no loop needed
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_k.dta", clear 
	merge m:1 hhid ea_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta" , nogen
	ren plot plot_id
	ren gardenid garden_id
	ren ag_k46a1 dayshiredmale 
	ren ag_k46a2 dayshiredfemale
	ren ag_k46a3 dayshiredchild
	ren ag_k46b1 wagehiredmale
	ren ag_k46b2 wagehiredfemale
	ren ag_k46b3 wagehiredchild
	ren TA ta
	keep region district ta ea_id rural hhid case_id plot_id garden_id *hired* 
	gen season= 1
tempfile dry_hired_all
save `dry_hired_all' 

	use `rainy_hired_all'
	append using `dry_hired_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	duplicates report region district ta ea hhid case_id plot_id season
	duplicates tag region district ta ea hhid case_id garden_id plot_id season, gen(dups)
	
	duplicates drop region district ta ea_id case_id hhid garden_id plot_id season, force
	drop dups
	reshape long dayshired wagehired, i(region district ta ea_id case_id hhid garden_id plot_id season) j(gender) string //fix zone state etc.
	reshape long days wage, i(region district ta ea case_id hhid garden_id plot season gender) j(labor_type) string	
	recode wage days (.=0) 
	drop if wage==0 & days==0 //127,545 observations deleted
	gen val = wage*days
	
	* fill in missing eas
	gsort hhid case_id  -ea
	replace ea = ea[_n-1] if ea == ""	

/* HKS 09.04.23, copied comment from MGM: The Malawi W4 instrument did not ask survey respondents to report number of laborers per day by laborer type. As such, we cannot say with certainty whether survey respondents reported wages paid as [per SINGLE hired laborer by laborer type (male, female, child) per day] or [per ALL hired laborers by laborer type (male, female, child) per day]. Looking at the collapses and scatterplots, it would seem that survey respondents had mixed interpretations of the question, making the value of hired labor more difficult to interpret. As such, we cannot impute the value of hired labor for observations where this is missing, hence the geographic medians section is commented out. */ 

tempfile all_hired
save `all_hired'

	*Exchange rainy
local qnums "50 52 54" 
foreach q in `qnums' {
    use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_d.dta", clear
	ren plotid plot_id
	ren gardenid garden_id
	merge m:1 hhid  using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen
	ren ag_d`q'a daysnonhiredmale
	ren ag_d`q'b daysnonhiredfemale
	ren ag_d`q'c daysnonhiredchild
			ren TA ta
	keep region district ta ea_id rural case_id hhid plot_id garden_id daysnonhired*
	gen season= 0
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
	//duplicates drop  region district ta ea rural hhid garden_id plot_id season, force //0 duplicates deleted
	reshape long daysnonhired, i(region district ta ea rural hhid garden_id plot_id season) j(gender) string
	//reshape long days, i(region stratum district ta ea rural case_id plot_id season gender) j(labor_type) string
    tempfile rainy_exchange`suffix'
    save `rainy_exchange`suffix'', replace
}

	*Exchange dry
    use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_k.dta", clear
	ren gardenid garden_id
	ren plotid plot_id
	merge m:1 hhid  using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen
	ren ag_k47a daysnonhiredmale
	ren ag_k47b daysnonhiredfemale
	ren ag_k47c daysnonhiredchild
	ren TA ta
	keep region district ta ea_id rural hhid garden_id plot_id daysnonhired*
	gen season= 1 
	//duplicates drop  region district ta ea rural hhid garden_id plot_id season, force //0 duplicates deleted
	reshape long daysnonhired, i(region  district ta ea_id rural hhid garden_id plot_id season) j(gender) string
	tempfile dry_exchange_all
    save `dry_exchange_all', replace
	append using `rainy_exchange_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	reshape long days, i(region district ta ea rural hhid garden_id plot_id season gender) j(labor_type) string
	tempfile all_exchange
	save `all_exchange', replace
	

//creates tempfile `members' to merge with household labor later
use "${MWI_IHS_IHPS_W4_raw_data}\hh_mod_b.dta", clear
ren PID indiv
isid  hhid indiv
gen male= (hh_b03==1)
gen age=hh_b05a
lab var age "Individual age"
keep hhid case_id indiv age male
tempfile members
save `members', replace

	*Household labor, rainy and dry
local seasons 0 1 
foreach season in `seasons' {
	di "`season'"
	if `season'== 0 { 
		local qnums  "42 43 44"
		local dk d
		local ag ag_d00
	} 
	else {
		local qnums "43 44 45"
		local dk k
		local ag ag_k0a
	}
	use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_`dk'.dta", clear
    merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen 
	ren TA ta
	
	forvalues k=1(1)3 {
		local q : word `k' of `qnums'
		if `k' == 1 { 
        local suffix "_planting" 
    }
    else if `k' == 2 { 
        local suffix "_nonharvest"
    }
    else if `k' == 3 { 
        local suffix "_harvest"
    }
	ren ag_`dk'`q'a1 indiv1`suffix'
    ren ag_`dk'`q'b1 weeks_worked1`suffix'
    ren ag_`dk'`q'c1 days_week1`suffix'
    ren ag_`dk'`q'd1 hours_day1`suffix'
    ren ag_`dk'`q'a2 indiv2`suffix'
    ren ag_`dk'`q'b2 weeks_worked2`suffix'
    ren ag_`dk'`q'c2 days_week2`suffix'
    ren ag_`dk'`q'd2 hours_day2`suffix'
    ren ag_`dk'`q'a3 indiv3`suffix'
    ren ag_`dk'`q'b3 weeks_worked3`suffix'
    ren ag_`dk'`q'c3 days_week3`suffix'
    ren ag_`dk'`q'd3 hours_day3`suffix'
    ren ag_`dk'`q'a4 indiv4`suffix'
    ren ag_`dk'`q'b4 weeks_worked4`suffix'
    ren ag_`dk'`q'c4 days_week4`suffix'
    ren ag_`dk'`q'd4 hours_day4`suffix'
	ren ag_`dk'`q'a5 indiv5`suffix'
    ren ag_`dk'`q'b5 weeks_worked5`suffix'
    ren ag_`dk'`q'c5 days_week5`suffix'
    ren ag_`dk'`q'd5 hours_day5`suffix'
	
	ren ag_`dk'`q'a6 indiv6`suffix'
    ren ag_`dk'`q'b6 weeks_worked6`suffix'
    ren ag_`dk'`q'c6 days_week6`suffix'
    ren ag_`dk'`q'd6 hours_day6`suffix'
	
	ren ag_`dk'`q'a7 indiv7`suffix'
    ren ag_`dk'`q'b7 weeks_worked7`suffix'
    ren ag_`dk'`q'c7 days_week7`suffix'
    ren ag_`dk'`q'd7 hours_day7`suffix'
	
	ren ag_`dk'`q'a8 indiv8`suffix'
    ren ag_`dk'`q'b8 weeks_worked8`suffix'
    ren ag_`dk'`q'c8 days_week8`suffix'
    ren ag_`dk'`q'd8 hours_day8`suffix'
	
    capture ren ag_`dk'`q'a9 indiv9`suffix'
    capture ren ag_`dk'`q'b9 weeks_worked9`suffix'
    capture ren ag_`dk'`q'c9 days_week9`suffix'
    capture ren ag_`dk'`q'd9 hours_day9`suffix'
	
	capture ren ag_`dk'`q'a10 indiv10`suffix'
    capture ren ag_`dk'`q'b10 weeks_worked10`suffix'
    capture ren ag_`dk'`q'c10 days_week10`suffix'
    capture ren ag_`dk'`q'd10 hours_day10`suffix'
	
	capture ren ag_`dk'`q'a11 indiv11`suffix'
    capture ren ag_`dk'`q'b11 weeks_worked11`suffix'
    capture ren ag_`dk'`q'c11 days_week11`suffix'
    capture ren ag_`dk'`q'd11 hours_day11`suffix'
    }
	ren gardenid garden_id
	ren plotid plot_id
	keep region district ta ea_id rural hhid garden_id plot_id indiv* weeks_worked* days_week* hours_day*
    gen season = "`season'"
	unab vars : *`suffix' 
	local stubs : subinstr local vars "_`suffix'" "", all 
	duplicates drop  region district ta ea_id rural hhid garden_id plot_id season, force
	reshape long indiv weeks_worked days_week hours_day, i(region district ta ea_id rural hhid garden_id plot_id season) j(num_suffix) string
	split num_suffix, parse(_)
	if `season'== 0 { 
		tempfile rainy
		save `rainy'
	}
	else {
		append using `rainy'
	}
}
gen days=weeks_worked*days_week
gen hours=weeks_worked*days_week*hours_day
drop if days==. 
drop if hours==. //0 observations deleted
//rescaling fam labor to growing season duration
preserve
collapse (sum) days_rescale=days, by(region district ta ea rural hhid garden_id plot_id indiv season)
merge m:1 hhid garden_id plot_id using"${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_season_length.dta", nogen keep(1 3)
replace days_rescale = days_grown if days_rescale > days_grown
tempfile rescaled_days
save `rescaled_days'
restore

//Rescaling to season
bys hhid plot_id garden_id indiv : egen tot_days = sum(days)
gen days_prop = days/tot_days 
merge m:1 region district ta ea_id rural hhid garden_id plot_id indiv season using `rescaled_days'
replace days = days_rescale * days_prop if tot_days > days_grown
merge m:1 hhid indiv using `members', nogen keep (1 3)
gen gender="child" if age<15 
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
keep region district ta ea_id rural hhid garden_id plot_id season gender days labor_type
destring season, replace
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season
append using `all_exchange'

//MGM 7.20.23: EPAR cannot construct the value of family labor or nonhired (AKA exchange) labor MWI Waves 1, 2, 3, and 4 given issues with how the value of hired labor is constructed (e.g. we do not know how many laborers are hired and if wages are reported as aggregate or singular). Therefore, we cannot use a median value of hired labor to impute the value of family or nonhired (AKA exchange) labor.

gen val = . 
append using `all_hired'
keep region district ta ea_id rural case_id hhid garden_id plot_id season days val labor_type gender 
drop if val==.&days==.
capture ren plotid plot_id
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val days, by(case_id hhid garden_id plot_id season labor_type gender dm_gender) 
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot" 
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_=days, by (case_id hhid garden_id plot_id labor_type season)
	reshape wide labor_, i(case_id hhid garden_id season plot_id) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons" 
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons" 
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_labor_days.dta",replace 	
//AgQuery
restore

//ALT: At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	append using `inkind_payments'
	collapse (sum) val, by(case_id hhid plot_id exp dm_gender season)
	gen input="labor"
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_labor.dta", replace 
restore	

//Back to wide format
collapse (sum) val, by(case_id hhid garden_id plot_id labor_type season dm_gender)
ren val val_ 
reshape wide val_, i(case_id plot_id hhid garden_id season dm_gender) j(labor_type) string
ren val* val*_
gen season_fix="rainy" if season==0
replace season_fix="dry" if season==1
drop season
ren season_fix season

reshape wide val*, i(case_id hhid garden_id plot_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
ren val* val*_ 
replace dm_gender2 = "unknown" if dm_gender == ""
reshape wide val*, i(case_id hhid garden_id plot_id) j(dm_gender2) string
collapse (sum) val*, by(case_id hhid)
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_cost_labor.dta", replace

*******************************************
		* LAND/PLOT RENTS *
*******************************************
* Crops Payments
	use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_b2.dta", clear
	gen season=0
	append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_i2.dta"
	gen cultivate = 0
	replace cultivate = 1 if ag_b214 == 1
	replace cultivate = 1 if ag_i214 == 1 
	ren gardenid garden_id
	gen payment_period=ag_b212
	replace payment_period=ag_i212 if payment_period==. 
	
* Paid 
	ren ag_b208a crop_code_paid
	replace crop_code_paid=ag_i208a if crop_code_paid==.
	ren ag_b208b qty_paid
	replace qty_paid=ag_i208b if qty_paid==.
	ren ag_b208c unit_paid
	replace unit_paid=ag_i208c if unit_paid==.
	ren ag_b208d condition_paid
	replace condition_paid=ag_i208d if condition_paid==.

* Owed
	ren ag_b210a crop_code_owed
	ren ag_b210b qty_owed
	ren ag_b210c unit_owed
	ren ag_b210d condition_owed

	drop if crop_code_paid==. & crop_code_owed==. //21,175 observations deleted
	drop if (unit_paid==. & crop_code_paid!=.) | (unit_owed==. & crop_code_owed!=.)  //210 observations deleted
	
	keep case_id hhid garden_id cultivate season crop_code* qty* unit* condition* payment_period
	reshape long crop_code qty unit condition, i (hhid season garden_id payment_period cultivate) j(payment_status) string
	drop if crop_code==. //59 observations deleted
	drop if qty==. //0 observations deleted
	duplicates drop hhid, force  //6 observation deleted 
	recast str50 hhid, force 
	merge m:1 case_id hhid crop_code using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_crop_prices_for_wages.dta", nogen keep (1 3) //48 out of 53 matched

gen val=qty*hh_price_mean 
drop qty unit crop_code condition hh_price_mean payment_status
keep if val!=. //22 obs deleted
tempfile plotrentbycrops
save `plotrentbycrops'

* Rainy Cash + In-Kind
	use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_b2.dta", clear
	gen cultivate = 0
	replace cultivate = 1 if ag_b214 == 1
	ren gardenid garden_id
	
	ren ag_b209a cash_rents_total
	ren ag_b209b inkind_rents_total
	ren ag_b211a cash_rents_paid
	ren ag_b211b inkind_rents_paid
	ren ag_b212 payment_period
	replace cash_rents_paid=cash_rents_total if cash_rents_paid==. & cash_rents_total!=. & payment_period==1
	ren ag_b211c cash_rents_owed
	ren ag_b211d inkind_rents_owed
	egen val = rowtotal(cash_rents_paid inkind_rents_paid cash_rents_owed inkind_rents_owed)
	gen season = 0 
	keep hhid garden_id val season cult payment_period
	tempfile rainy_land_rents
	save `rainy_land_rents', replace

* Dry Cash + In-Kind 
	use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_i2.dta", clear 
	gen cultivate = 0
		replace cultivate = 1 if ag_i214 == 1
    ren gardenid garden_id 
	ren ag_i208a cash_rents_total
	ren ag_i208b inkind_rents_total
	ren ag_i212 payment_period
	replace payment_period=0 if payment_period==3 & (strmatch(ag_i212_oth, "DIMBA SEASON ONLY") | strmatch(ag_i212_oth, "DIMBA SEASOOY") | strmatch(ag_i212_oth, "ONLY DIMBA"))
	egen val = rowtotal( cash_rents_total inkind_rents_total)
	keep hhid garden_id val cult payment_period
	gen season = 1

* Combine dry + rainy + payments-by-crop
append using `rainy_land_rents' 
append using `plotrentbycrops'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season
gen input="plotrent"
gen exp="exp"

duplicates report hhid garden_id season
duplicates tag hhid garden_id season, gen(dups)
duplicates drop hhid garden_id season, force //29 duplicate entries
drop dups

gen check=1 if payment_period==2 & val>0 & val!=.
duplicates report hhid garden_id payment_period check
duplicates tag  hhid garden_id payment_period check, gen(dups)
drop if dups>0 & check==1 & season==1 
drop dups check

gen qty=0
recode val (.=0)
collapse (sum) val, by (hhid garden_id season exp input qty cultivate)
duplicates drop hhid garden_id, force //1 observation deleted 
recast str50 hhid, force 
merge 1:m hhid garden_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_areas.dta", keep (1 3) 
count if _m==1 & plot_id!="" & val!=. & val>0 
	drop if _m != 3 //724 obs deleted
	drop _m

* Calculate quantity of plot rents etc. 
replace qty = field_size if val > 0 & val! = . //1,616 changes
keep if cultivate==1 //444 observations deleted 
keep hhid garden_id plot_id season input exp val qty
tempfile plotrents
save `plotrents'	


	******************************************
	* FERTILIZER, PESTICIDES, AND HERBICIDES *
	******************************************
* HH-LEVEL Plot info (mod F & mod L)
use "${MWI_IHS_IHPS_W4_raw_data}\AG_MOD_F.dta", clear
gen season = 0
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_l.dta"
replace season = 1 if season == .
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season
ren ag_f0c itemcode
replace itemcode = ag_l0c if itemcode == .
drop if itemcode == . //2 observations deleted
//Type of inorganic fertilizer or Herbicide (1 = 23:21:0+4S/CHITOWE, 2 =  DAP, 3 = CAN 4 = UREA, 5 = D COMPOUND 5, 6 = Other Fertilizer, 7 = INSECTICIDE, 8 = HERBICIDE, 9 = FUMIGANT 10 = Other Pesticide or Herbicide. 17 - unknown)
			
gen codefertherb = 0 if item == 0 
replace code = 1 if inlist(item, 1,2,3,4,5,6)
replace code = 2 if inlist(item, 7,9,10) 
replace code = 3 if inlist(item, 8)
		
lab var codefertherb "Code: 0 = organic fert, 1 = inorganic fert, 2 = pesticide, 3 = herbicide"
lab define codefertherb 0 "organic fert" 1 "inorganic fert" 2 "pesticide" 3 "herbicide"
lab values codefertherb codefertherb			

* For all "specify unit" variable
local qnum 07 16 26 36 38 42 
foreach q in `qnum'{
	tostring ag_f`q'b_oth, format(%19.0f) replace
	tostring ag_l`q'b_oth, format(%19.0f) replace
}
*All Source Input and Transportation Costs (Explicit)*
ren ag_f07a qtyinputexp0
replace qtyinputexp0 = ag_l07a if qtyinputexp0 ==.
ren ag_f07b unitinputexp0
replace unitinputexp0 = ag_l07b if unitinputexp0 ==.
ren ag_f09 valtransfertexp0 
replace valtransfertexp0 = ag_l09 if valtransfertexp0 == .
ren ag_f10 valinputexp0
replace valinputexp0 = ag_l10 if valinputexp0 == .

*First Source Input and Transportation Costs (Explicit)*
ren ag_f16a qtyinputexp1
replace qtyinputexp1 = ag_l16a if qtyinputexp1 ==.
ren ag_f16b unitinputexp1
replace unitinputexp1 = ag_l16b if unitinputexp1 ==. 
ren ag_f18 valtransfertexp1
replace valtransfertexp1 = ag_l18 if valtransfertexp1 == .
ren ag_f19 valinputexp1
replace valinputexp1 = ag_l19 if valinputexp1 == .

*Second Source Input and Transportation Costs (Explicit)*
ren ag_f26a qtyinputexp2
replace qtyinputexp2 = ag_l26a if qtyinputexp2 ==.
ren ag_f26b unitinputexp2
replace unitinputexp2 = ag_l26b if unitinputexp2 ==.
ren ag_f28 valtransfertexp2
replace valtransfertexp2 = ag_l28 if valtransfertexp2 == .
ren  ag_f29 valinputexp2
replace valinputexp2 = ag_l29 if valinputexp2 == .

*Third Source Input Costs (Explicit)*
ren ag_f36a qtyinputexp3  // Third Source
replace qtyinputexp3 = ag_l36a if qtyinputexp3 == .
ren ag_f36b unitinputexp3
replace unitinputexp3 = ag_l36b if unitinputexp3 == . 

*Free and Left-Over Input Costs (Implicit)*
gen itemcodeinputimp1 = itemcode
ren ag_f38a qtyinputimp1
replace qtyinputimp1 = ag_l38a if qtyinputimp1 == .
ren ag_f38b unitinputimp1
replace unitinputimp1 = ag_l38b if unitinputimp1 == . 
ren ag_f42a qtyinputimp2
replace qtyinputimp2 = ag_l42a if qtyinputimp2 == .
ren ag_f42b unitinputimp2
replace unitinputimp2 = ag_l42b if unitinputimp2== .

*Free Input Source Transportation Costs (Explicit)*
ren ag_f40 valtransfertexp3
replace valtransfertexp3 = ag_l40 if valtransfertexp3 == .

ren ag_f07b_o otherunitinputexp0
replace otherunitinputexp0=ag_l07b_o if otherunitinputexp0==""

ren ag_f16b_o otherunitinputexp1
replace otherunitinputexp1=ag_l16b_o if otherunitinputexp1==""
ren ag_f26b_o otherunitinputexp2
replace otherunitinputexp2=ag_l26b_o if otherunitinputexp2==""
ren ag_f36b_o otherunitinputexp3
replace otherunitinputexp3=ag_l36b_o if otherunitinputexp3==""
ren ag_f38b_o otherunitinputimp1
replace otherunitinputimp1=ag_l38b_o if otherunitinputimp1==""
ren ag_f42b_o otherunitinputimp2
replace otherunitinputimp2=ag_l42b_o if otherunitinputimp2==""

replace qtyinputexp1=qtyinputexp0 if (qtyinputexp0!=. & qtyinputexp1==. & qtyinputexp2==. & qtyinputexp3==.) //10,161 changes
replace unitinputexp1=unitinputexp0 if (unitinputexp0!=. & unitinputexp1==. & unitinputexp2==. & unitinputexp3==.) //10,059 changes
replace otherunitinputexp1=otherunitinputexp0 if (otherunitinputexp0!="" & otherunitinputexp1=="" & otherunitinputexp2=="" & otherunitinputexp3=="") //77 changes
replace valtransfertexp1=valtransfertexp0 if (valtransfertexp0!=. & valtransfertexp1==. & valtransfertexp2==.) //10,161 changes
replace valinputexp1=valinputexp0 if (valinputexp0!=. & valinputexp1==. & valinputexp2==.) //10,161 changes

keep qty* unit* otherunit* val* hhid itemcode codefertherb season
gen dummya = _n
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i (hhid dummya itemcode codefertherb) j(entry_no)
drop entry_no
replace dummya=_n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
reshape long `stubs2', i(hhid dummya itemcode codefertherb) j(exp) string
replace dummya=_n
reshape long qty unit val, i(hhid exp dummya itemcode codefertherb) j(input) string
tab val if exp=="imp" & input=="transfert"
drop if strmatch(exp,"imp") & strmatch(input, "transfert")

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

*CONVERTING VOLUMES TO MASS*
/*Assuming 1 BUCKET is about 20L in Malawi
Citation: Mponela, P., Villamor, G. B., Snapp, S., Tamene, L., Le, Q. B., & Borgemeister, C. (2020). The role of women empowerment and labor dependency on adoption of integrated soil fertility management in Malawi. Sustainability, 12(15), 1-11. https://doi.org/10.1111/sum.12627
*/

*ORGANIC FERTILIZER
/*Assuming bulk density of ORGANIC FERTILIZER is between 420-655 kg/m3 (midpoint 537.5kg/m3)
Citation: Khater, E. G. (2015). Some Physical and Chemical Properties of Compost. Agricultural Engineering Department, Faculty of Agriculture, Benha University, Egypt. Corresponding author: Farouk K. M. Wali, Assistant professor, Chemical technology Department, The Prince Sultan Industrial College, Saudi Arabia, Tel: +20132467034; E-mail: alsayed.khater@fagr.bu.edu.eg. Retrieved from https://www.walshmedicalmedia.com/open-access/some-physical-and-chemical-properties-of-compost-2252-5211-1000172.pdf
*/
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
/*ALT: Pesticides and herbicides do not have a bulk density because they are typically sold already in liquid form, so they'd have a mass density. It depends on the concentration of the active ingredient and the presence of any adjuvants and is typically impossible to get right unless you have the specific brand name. Accordingly, EPAR currently assumes 1L=1kg, which results in a slight underestimate of herbicides and pesticides.*/
replace qty = qty*1 if unit== 8 & (codefertherb==2 | codefertherb==3) //liter
replace qty = qty/1000*1 if unit== 9 & (codefertherb==2 | codefertherb==3) //milliliter
replace qty = qty*20*1 if unit== 10 & (codefertherb==2 | codefertherb==3) //bucket

*CONVERTING WHEELBARROW AND OX-CART TO KGS*
/*Assuming 1 WHEELBARROW max load is 80 kg 
Assuming 1 OX-CART has a 800 kgs carrying capacity, though author notes that ox-carts typically carry loads far below their weight capacity, particularly for crops (where yields may not fill the cart entirely)
Citation: Wendroff, A. P. (n.d.). THE MALAWI CART: An Affordable Bicycle-Wheel Wood-Frame Handcart for Agricultural, Rural and Urban Transport Applications in Africa. Research Associate, Department of Geology, Brooklyn College / City University of New York; Director, Malawi Handcart Project. Available at: https://www.academia.edu/15078493/THE_MALAWI_CART_An_Affordable_Bicycle-Wheel_Wood-Frame_Handcart_for_Agricultural_Rural_and_Urban_Transport_Applications_in_Africa
*/
replace qty = qty*80 if unit==11
replace qty = qty*800 if unit==12

* Updating the unit for unit to "1" (to match seed code) for the relevant units after conversion
replace unit = 1 if inlist(unit, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)

tab otherunit
replace qty = 1*2 if qty==. & (strmatch(otherunit, "2 TONNE PICKUP")) // 1 change
replace qty = qty*1000 if strmatch(otherunit, "1 TON") | strmatch(otherunit, "TONS") //Assuming metric ton instead of standard conversion where 1 ton=907.185 kgs // 0 Changes
replace unit = 1 if strmatch(otherunit, "1 TON") | strmatch(otherunit, "TONS") // 0 Changes
replace qty = qty*50 if strmatch(otherunit, "50 KG BAG") // 4 changes
replace unit = 1 if strmatch(otherunit, "50 KG BAG") // 4 real changes
replace qty = qty*90 if strpos(otherunit, "90 KG") // 3 changes
replace unit = 1 if strpos(otherunit, "90 KG") // 5 real changes

label define inputunitrecode 1 "Kilogram", modify
label values unit inputunitrecode
tab unit 
drop if unit==13 //11 observations dropped

drop if (qty==. | qty==0) & strmatch(input, "input") // 1,082,366 observations deleted
drop if unit==. & strmatch(input, "input") // 42 observations deleted
drop if itemcode==. // 0 observations deleted
gen byte qty_missing = missing(qty)
gen byte val_missing = missing(val)
collapse (sum) val qty, by(hhid unit itemcode codefertherb exp input qty_missing val_missing season) 
replace qty =. if qty_missing
replace val =. if val_missing
drop qty_missing val_missing

replace input="orgfert" if codefertherb==0 & input!="transfert"
replace input="orgfert" if codefertherb==1 & input!="transfert"
replace input="pest" if codefertherb==2 & input!="transfert"
replace input="herb" if codefertherb==3 & input!="transfert"
replace qty=. if input=="transfert" //1 changes
keep if qty>0 //0 obs deleted
replace unit=1 if unit==. 
drop if input == "input" & itemc == 11 
tempfile phys_inputs
save `phys_inputs'

	*********************************
	* 			 SEED			    *
	*********************************	
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_h.dta", clear
gen season = 0
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_n.dta"
replace season = 1 if season == .
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season 

recast str50 hhid
ren crop_code seedcode
drop if seedc == . 

local qnum 07 16 26 36 38 42
foreach q in `qnum'{
	tostring ag_h`q'b_oth, format(%19.0f) replace
	tostring ag_n`q'b_oth, format(%19.0f) replace
}

** Filling empties from duplicative questions
* How much seed was purhcased w/o coupons etc.?
replace ag_h16a=ag_h07a if (ag_h07a!=. & ag_h16a==. & ag_h26a==. & ag_h36a==.) // 8,262 changes
replace ag_h16b=ag_h07b if (ag_h07b!=. & ag_h16b==. & ag_h26b==. & ag_h36b==.) // 8,208 changes
replace ag_h16b_oth=ag_h07b_oth if (ag_h07b_oth!="" & ag_h16b_oth=="" & ag_h26b_oth=="" & ag_h36b_oth=="") // 549 changes

*How much did you pay for transpo to acquire seed?
replace ag_h18=ag_h09 if (ag_h09!=. & ag_h18==. & ag_h28==.) // 8,262 changes

* Value of seed purchased? 
replace ag_h19=ag_h10 if (ag_h10!=. & ag_h19==. & ag_h29==.) // 8,262 changes

* Repeat for Module N
replace ag_n16a=ag_n07a if (ag_n07a!=. & ag_n16a==. & ag_n26a==. & ag_n36a==.) // 1,486 changes
replace ag_n16b=ag_n07b if (ag_n07b!=. & ag_n16b==. & ag_n26b==. & ag_n36b==.) // 1,483 changes
replace ag_n16b_oth=ag_n07b_oth if (ag_n07b_oth!="" & ag_n16b_oth=="" & ag_n26b_oth=="" & ag_n36b_oth=="") // 252 changes
replace ag_n18=ag_n09 if (ag_n09!=. & ag_n18==. & ag_n28==.) // 1,486 changes
replace ag_n19=ag_n10 if (ag_n10!=. & ag_n19==. & ag_n29==.) // 1,486 changes
*****

*First Source Seed and Transportation Costs (Explicit)*
	ren ag_h16a qtyseedexp1 
	replace qtyseedexp1 = ag_n16a if qtyseedexp1 ==.
	ren ag_h16b unitseedexp1
	replace unitseedexp1 = ag_n16b if unitseedexp1 ==. 
	ren ag_h18 valseedtransexp1 
	replace valseedtransexp1 = ag_n18 if valseedtransexp1 == .
	ren ag_h19 valseedexp1 
	replace valseedexp1 = ag_n19 if valseedexp1 == .
	gen itemcodeseedexp1 = seedcode if qtyseedexp1!=. 
	
*Second Source Seed and Transportation Costs (Explicit)*
	ren ag_h26a qtyseedexp2 
	replace qtyseedexp2 = ag_n26a if qtyseedexp2 ==.
	ren ag_h26b unitseedexp2
	replace unitseedexp2 = ag_n26b if unitseedexp2 ==.
	ren ag_h28 valseedtransexp2 
	replace valseedtransexp2 = ag_n28 if valseedtransexp2 == .
	ren  ag_h29 valseedexp2
	replace valseedexp2 = ag_n29 if valseedexp2 == .
	gen itemcodeseedexp2 = seedcode if qtyseedexp2!=. 

*Third Source Seed Costs (Explicit)* // Transportation Costs and Value of seed not asked about for third source on W1 instrument, hence the need to impute these costs later provided we have itemcode code and qtym
	ren ag_h36a qtyseedexp3  
	replace qtyseedexp3 = ag_n36a if qtyseedexp3 == .
	ren ag_h36b unitseedexp3
	replace unitseedexp3 = ag_n36b if unitseedexp3 == . 
	gen itemcodeseedexp3 = seedcode if qtyseedexp3!=. 

*Free and Left-Over Seed Costs (Implicit)*
ren ag_h42a qtyseedimp1 
replace qtyseedimp1 = ag_n42a if qtyseedimp1 == . 
ren ag_h42b unitseedimp1
gen itemcodeseedimp1 = seedcode if qtyseedimp1!=. 
replace unitseedimp1 = ag_n42b if unitseedimp1== .
ren ag_h38a qtyseedimp2  
replace qtyseedimp2 = ag_n38a if qtyseedimp2 == .
ren ag_h38b unitseedimp2
replace unitseedimp2 = ag_n38b if unitseedimp2 == . 
gen itemcodeseedimp2 = seedcode if qtyseedimp2!=.

*Free Source Transportation Costs (Explicit)*
ren ag_h40 valseedtransexp3 
replace valseedtransexp3 = ag_n40 if valseedtransexp3 == .


* Checking gaps in "other" unit variables
tab ag_h16b_oth 
tab ag_n16b_oth 
tab ag_h26b_oth // 1 obs "packet"
tab ag_n26b_oth 
tab ag_h36b_oth 
tab ag_n36b_oth 
tab ag_h38b_oth 
tab ag_n38b_oth
tab ag_h42b_oth
tab ag_n42b_oth

**** BACKFILL CODE, EDITED TO MEET THE NEEDS OF W4
ren ag_h16b_o otherunitseedexp1
replace otherunitseedexp1=ag_n16b_o if otherunitseedexp1==""
ren ag_h26b_o otherunitseedexp2
replace otherunitseedexp2=ag_n26b_o if otherunitseedexp2==""
ren ag_h36b_o otherunitseedexp3
replace otherunitseedexp3=ag_n36b_o if otherunitseedexp3==""
ren ag_h38b_o otherunitseedimp1
replace otherunitseedimp1=ag_n38b_o if otherunitseedimp1==""
ren ag_h42b_o otherunitseedimp2
replace otherunitseedimp2=ag_n42b_o if otherunitseedimp2==""

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
recode unitseed`s' (1/8 = 1)
label define unitrecode`s' 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify
label values unitseed`s' unitrecode`s'

//REPLACE UNITS WITH O/S WHERE POSSIBLE
//Malawi instruments do not have unit codes for units like "packet" or "stem" or "bundle". Converting unit codes to align with the Malawi conversion factor file (merged in later). Also, borrowing Nigeria's unit codes for units (e.g. packets) that do not have unit codes in the Malawi instrument or conversion factor file.

* KGs 
replace unitseed`s'=1 if strmatch(otherunitseed`s', "MG") 
replace qtyseed`s'=qtyseed`s'/1000000 if strmatch(otherunitseed`s', "MG") 
replace unitseed`s'=1 if strmatch(otherunitseed`s', "20 KG BAG")
replace qtyseed`s'=qtyseed`s'*20 if strmatch(otherunitseed`s', "20 KG BAG")
replace unitseed`s'=1 if strmatch(otherunitseed`s', "25 KG BAG")
replace qtyseed`s'=qtyseed`s'*25 if strmatch(otherunitseed`s', "25 KG BAG")
replace unitseed`s'=1 if strpos(otherunitseed`s', "50 KG") | strpos(otherunitseed`s', "50KG")
replace qtyseed`s'=qtyseed`s'*50 if strpos(otherunitseed`s', "50 KG") | strpos(otherunitseed`s', "50KG")
replace unitseed`s'=1 if strpos(otherunitseed`s', "70 KG") | strpos(otherunitseed`s', "70KG") 
replace qtyseed`s'=qtyseed`s'*50 if strpos(otherunitseed`s', "70 KG") | strpos(otherunitseed`s', "70KG") 
replace unitseed`s'=1 if strpos(otherunitseed`s', "90 KG") | strpos(otherunitseed`s', "90KG") 
replace qtyseed`s'=qtyseed`s'*90 if strpos(otherunitseed`s', "90 KG") | strpos(otherunitseed`s', "90KG") 
replace unitseed`s'=1 if strpos(otherunitseed`s', "100KG") | strpos(otherunitseed`s', "100 KG")  
replace qtyseed`s'=qtyseed`s'*100 if strpos(otherunitseed`s', "100KG") | strpos(otherunitseed`s', "100 KG") 
replace unitseed`s'=1 if strpos(otherunitseed`s', "100G") | strpos(otherunitseed`s', "8 GRAM")
replace qtyseed`s'=(qtyseed`s'/1000)*100 if strpos(otherunitseed`s', "100KG") 
replace qtyseed`s'=(qtyseed`s'/1000)*8 if strpos(otherunitseed`s', "8 GRAM") 

* Pails
replace unitseed`s'=4 if strpos(otherunitseed`s', "PAIL") 
replace unitseed`s'=5 if strpos(otherunitseed`s', "PAIL") & (strpos(otherunitseed`s', "BIG") | strpos(otherunitseed`s', "LARGE"))
replace qtyseed`s'=qtyseed`s'*2 if strmatch(otherunitseed`s', "2X LARGE PAIL")

* Plates
replace unitseed`s'=6 if (strpos(otherunitseed`s', "PLATE")  | strpos(otherunitseed`s', "10 PLATE") | strpos(otherunitseed`s', "10PLATE")) & !strpos(otherunitseed`s', "KG") 
replace qtyseed`s'=qtyseed`s'*2 if strmatch(otherunitseed`s', "2 NO 10 PLATES")
replace unitseed`s'=7 if strpos(otherunitseed`s', "12 PLATE")  | strpos(otherunitseed`s', "12PLATE") 

* Pieces & Bundles 
replace unitseed`s'=9 if strpos(otherunitseed`s', "PIECE") | strpos(otherunitseed`s', "PIECES") | strpos(otherunitseed`s', "STEMS") | strmatch(otherunitseed`s', "CUTTINGS") | strmatch(otherunitseed`s', "BUNDLES") | strmatch(otherunitseed`s', "MTOLO UMODZI WA BATATA") 
replace qtyseed`s'=qtyseed`s'*100 if strmatch(otherunitseed`s', "BUNDLES") | strmatch(otherunitseed`s', "MTOLO UMODZI WA BATATA")

* Dengu
replace unitseed`s'=11 if strmatch(otherunitseed`s', "DENGU") 

* Packet
replace unitseed`s'=120 if strpos(otherunitseed`s', "PACKET")
replace qtyseed`s'=qtyseed`s'*2 if strmatch(otherunitseed`s', "2 PACKETS")
}


keep item* qty* unit* val* hhid season seed
gen dummya = _n
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i (hhid dummya) j(entry_no)
drop entry_no
replace dummya = _n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if qtyseedexp==. & valseedexp==.
reshape long `stubs2', i(hhid dummya) j(exp) string
replace dummya=_n
reshape long qty unit val itemcode, i(hhid exp dummya) j(input) string
drop if strmatch(exp,"imp") & strmatch(input,"seedtrans")
label define unitrecode 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify
label values unit unitrecode

drop if (qty==. | qty==0) & strmatch(input, "seed") // 12,132 obs deleted
drop if unit==. & strmatch(input, "seed") // 0 obs deleted 
gen byte qty_missing = missing(qty) 
gen byte val_missing = missing(val)
collapse (sum) val qty, by(hhid unit seedcode exp input qty_missing val_missing season)
replace qty =. if qty_missing
replace val =. if val_missing
drop qty_missing val_missing

ren seedcode crop_code
drop if crop_code==. & strmatch(input, "seed") // 0 obs deleted
gen condition=1 
replace condition=3 if inlist(crop_code, 5, 6, 7, 8, 10, 28, 29, 30, 31, 32, 33, 37, 39, 40, 41, 42, 43, 44, 45, 47) 
recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
rename crop_code crop_code_short
recast str50 hhid, force 
merge m:1 hhid using  "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhsize.dta", keepusing (region district TA ea) nogen keep(1 3)
merge m:1 crop_code_short unit condition region using "${MWI_IHS_IHPS_W4_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", keep (1 3) 

replace qty=. if input=="seedtrans" //0 changes
keep if qty>0 //0 obs deleted

//This chunk ensures that conversion factors did not get used for planted-as-seed crops where the conversion factor weights only work for planted-as-harvested crops
replace conversion =. if inlist(crop_code, 5-8, 10, 28-29, 37, 39-45, 47) // 85 real changes 

replace unit=1 if unit==. 
replace conversion = 1 if unit==1 
replace conversion = 1 if unit==9 
replace qty=qty*conversion if conversion!=.
rename crop_code itemcode
drop _m
tempfile seed
save `seed'	

//posible issue with shelled/unshelled data 

*********************************************
*  	MECHANIZED TOOLS AND ANIMAL TRACTION	*
*********************************************

use "${MWI_IHS_IHPS_W4_raw_data}/HH_MOD_M.dta", clear 
rename hh_m0b itemid
gen anml = (itemid>=609 & itemid<=610) // Ox Cart, Ox Plow
gen mech = (itemid>=601 & itemid<= 608 | itemid>=611 & itemid<=612 | itemid>=613 & itemid <=625) // Hand hoe, slasher, axe, sprayer, panga knife, sickle, treadle pump, watering can, ridger, cultivator, generator, motor pump, grain mill, other, chicken house, livestock and poultry kraal, storage house, granary, barn, pig sty AND INCLUDING TRACTOR TO ALIGN WITH NIGERIA
rename hh_m14 rental_cost 
gen rental_cost_anml = rental_cost if anml==1
gen rental_cost_mech = rental_cost if mech==1
recode rental_cost_anml rental_cost_mech (.=0)

collapse (sum) rental_cost_anml rental_cost_mech, by(hhid)
lab var rental_cost_anml "Costs for renting animal traction"
lab var rental_cost_mech "Costs for renting other agricultural items" 
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_asset_rental_costs.dta", replace

ren rental_cost_* val*_rent
reshape long val, i(hhid) j(var) string
ren var input
gen exp = "exp"
tempfile asset_rental
save `asset_rental'

*********************************************
*     	COMBINING AND GETTING PRICES	    *
*********************************************

use `plotrents', clear
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_cost_per_plot.dta", replace

merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_weights.dta",nogen keep(1 3) keepusing(weight region district ea TA) 
merge m:1 hhid plot_id garden_id season using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_areas.dta", keepusing(field_size) 
merge m:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_decision_makers.dta",nogen keep(1 3) keepusing(dm_gender)
gen plotweight = weight*field_size
tempfile all_plot_inputs
save `all_plot_inputs', replace

* Calculating Geographic Medians for PLOT LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	gen price = val/qty
	drop if price==. 
	gen obs=1

	capture restore,not 
	foreach i in ea TA district region hhid {
	preserve
		bys `i' input : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price [aw=plotweight], by (`i' input obs_`i')
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}

	preserve
	bys input : egen obs_country = sum(obs)
	collapse (median) price_country = price [aw=plotweight], by(input obs_country)
	tempfile price_country_median
	save `price_country_median'
	restore

	use `all_plot_inputs',clear
	foreach i in ea TA district region hhid {
		merge m:1 `i' input using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input  using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country region district TA ea  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 //4 households reporting negative quantities of fertilizer.
recode val qty (.=0)
drop if val==0 & qty==0
replace val=qty*price if val==0

* For PLOT LEVEL data, add in plot_labor data
append using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_labor.dta" // 45,846 obs where garden is empty; 9,252 obs where plot is empty, and 23,033 where dm_gender is empty (n = 70,606)
drop if garden == "" & plot_id == "" // drops 9252 obs
collapse (sum) val, by (hhid plot_id garden exp input dm_gender season) 

* Save PLOT-LEVEL Crop Expenses (long)
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_cost_inputs_long.dta",replace 

* Save PLOT-Level Crop Expenses (wide, does not currently get used in MWI W4 code)
preserve
	collapse (sum) val_=val, by(hhid plot_id garden exp dm_gender season) 
	reshape wide val_, i(hhid plot_id garden dm_gender season) j(exp) string
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_cost_inputs.dta", replace 
restore

* HKS 08.21.23: Aggregate PLOT-LEVEL crop expenses data up to HH level and append to HH LEVEL data.	
preserve
use "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_cost_inputs_long.dta", clear
	collapse (sum) val, by(hhid exp input season)
	tempfile plot_to_hh_cropexpenses
	save `plot_to_hh_cropexpenses', replace
restore

*** HH LEVEL Files: seed, asset_rental, phys_inputs
use `seed', clear
append using `asset_rental'
	append using `phys_inputs'
	recast str50 hhid, force
	merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_weights.dta",nogen keep(1 3) keepusing(weight region district ea TA) // merge in hh weight & geo data 
tempfile all_HH_LEV_inputs
save `all_HH_LEV_inputs', replace
	

* Calculating Geographic Medians for HH LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	drop if unit==0 //Remove things with unknown units.
	gen price = val/qty
	drop if price==. 
	gen obs=1

	* Plotweight has been changed to aw = qty*weight (where weight is population weight), as per discussion with ALT
	capture restore,not 
	foreach i in ea TA district region hhid {
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

	use `all_HH_LEV_inputs',clear
	foreach i in ea TA district region hhid {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country region district TA ea  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 
recode val qty (.=0)
drop if val==0 & qty==0 
replace val=qty*price if val==0

* Amend input names to match those of NGA data 
replace input = "anml" if strpos(input, "animal_tract") 
replace input = "inorg" if strpos(input, "inorg")
replace input = "seed" if strpos(input, "seed")
replace input = "mech" if strpos(input, "ag_asset") | strpos(input, "tractor") 

* Add geo variables 
   merge m:1 hhid  using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen keepusing(TA ea district region)
   capture ren TA ta
   capture ren ea ea_id

preserve
	keep if strpos(input,"orgfert") | strpos(input,"inorg") | strpos(input,"herb") | strpos(input,"pest")
	collapse (sum) qty_=qty, by(hhid ta ea district region input season) 
	reshape wide qty_, i(hhid season) j(input) string 
	ren qty_orgfert org_fert_rate
	ren qty_herb herb_rate
	ren qty_pest pest_rate
	la var org_fert_rate "Qty organic fertilizer used (kg)"
	la var herb_rate "Qty of herbicide used (kg/L)"
	la var pest_rate "Qty of pesticide used (kg/L)"

	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_input_quantities.dta", replace 
restore	
	
* Save HH-LEVEL Crop Expenses (long)
preserve
collapse (sum) val qty, by(hhid exp input ta ea district region)
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_cost_inputs_long.dta", replace
restore

* COMBINE HH-LEVEL crop expenses (long) with PLOT level data (long) aggregated up to HH LEVEL:
use "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_cost_inputs_long.dta", clear
	append using `plot_to_hh_cropexpenses'
		collapse (sum) val qty, by(hhid exp input)
		replace exp = "exp" if strpos(input, "asset") |  strpos(input, "animal") | strpos(input, "tractor")
	merge m:1 hhid  using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen keepusing(TA ea district region)
	capture ren (TA ea) (ta ea_id)
	save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_hh_cost_inputs_long_complete.dta", replace

********************************************************************************
* MONOCROPPED PLOTS * 
********************************************************************************
use "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_all_plots.dta", clear
	keep if purestand==1 
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_monocrop_plots.dta" , replace

//Setting things up for AgQuery first
use "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_all_plots.dta",clear
keep if purestand == 1 
	merge m:1  hhid garden_id plot_id using  "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono
	collapse (sum) *mono*, by(hhid garden_id plot_id crop_code dm_gender)
	
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
	drop if `cn'_monocrop_ha==0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${MWI_IHS_IHPS_W4_created_data}\Malawi_IHS_W4_`cn'_monocrop.dta", replace	
	
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' `cn'_monocrop { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	
	collapse (sum) *monocrop_ha* kgs_harv_mono* val_harv_mono* (max) `cn'_monocrop `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed, by(hhid garden_id)
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (Kwacha)"
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
	save "${MWI_IHS_IHPS_W4_created_data}\Malawi_IHS_W4_`cn'_monocrop_hh_area.dta", replace
	}
	}
restore
}

use "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_plot_cost_inputs_long.dta", clear 
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val, by(hhid garden_id plot_id dm_gender input)
levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid garden_id plot_id dm_gender) j(input) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3 //| if dm_gender==. CG not working, waiting on update
	replace dm_gender2 = "unknown" if dm_gender==. 
	drop dm_gender
	
	foreach cn in $topcropname_area {
preserve
capture confirm file "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_`cn'_monocrop.dta"
	if !_rc {
	ren val* val*_`cn'_
	reshape wide val*, i(hhid garden_id plot_id) j(dm_gender2) string
	merge 1:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_`cn'_monocrop.dta", nogen keep(3)
	count
	if(r(N) > 0){
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_inputs_`cn'.dta", replace
	}
	}
restore
}	

****************************************************************************
*LIVESTOCK INCOME - RH complete 7/29 - not checked
****************************************************************************

*Expenses - RH complete 7/20
//can't do disaggregated expenses (no lrum or animal expenses)

use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_r2.dta", clear
rename ag_r26 cost_fodder_livestock       /* VAP: MW2 has no separate cost_water_livestock - same with W4*/
rename ag_r27 cost_vaccines_livestock     /* Includes medicines */
rename ag_r28 cost_othervet_livestock     /* VAP: TZ didn't have this. Includes dipping, deworming, AI */
gen cost_medical_livestock = cost_vaccines_livestock + cost_othervet_livestock /* VAP: Combining the two categories for later. */
rename ag_r25 cost_hired_labor_livestock 
rename ag_r29 cost_input_livestock        /* VAP: TZ didn't have this. Includes housing equipment, feeding utensils */
recode cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock(.=0)

collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock  cost_hired_labor_livestock cost_input_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for <livestock>"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for <livestock>"
lab var cost_othervet_livestock "Cost for other veterinary treatments for <livestock> (incl. dipping, deworming, AI)"
*lab var cost_medical_livestock "Cost for all veterinary services (total vaccine plus othervet)"
lab var cost_hired_labor_livestock "Cost for hired labor for <livestock>"
lab var cost_input_livestock "Cost for livestock inputs (incl. housing, equipment, feeding utensils)"
//ren HHID hhid
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_livestock_expenses.dta", replace

*Livestock products 
* Milk - RH complete 7/21 (question)
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_s.dta", clear
rename ag_s0a livestock_code
keep if livestock_code==401
rename ag_s02 no_of_months_milk // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]?
rename ag_s03a qty_milk_per_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. 
gen milk_liters_produced = no_of_months_milk * qty_milk_per_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

gen liters_sold_12m = ag_s05a if ag_s05b==1 // VAP: Keeping only units in liters
rename ag_s06 earnings_milk_year
gen price_per_liter = earnings_milk_year/liters_sold_12m if liters_sold_12m > 0
gen price_per_unit = price_per_liter // RH: why do we need per liter and per unit if the same?
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) //RH Question: is turning 0s to missing on purpose? Or is this backwards? 
keep hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year //why do we need both per liter and per unit if the same?
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_milk", replace

* Other livestock products  // VAP: Includes milk, eggs, meat, hides/skins and manure. No honey in MW2. TZ does not have meat and manure. - RH complete 7/29
use "${MWI_IHS_IHPS_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s02 months_produced
rename ag_s03a quantity_month
rename ag_s03b quantity_month_unit

drop if livestock_code == 401 //RH edit. Removing milk from "other" dta, will be added back in for all livestock products file
replace quantity_month = round(quantity_month/0.06) if livestock_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs. 
replace quantity_month_unit = 3 if livestock_code== 402 & quantity_month_unit==2
replace quantity_month_unit =. if livestock_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if livestock_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
replace quantity_month = quantity_month*1.5 if livestock_code==404 & quantity_month_unit==3 // VAP: converting pieces to kgs for meat, 
// using conversion for chicken. Cannot convert ltrs & buckets.  
replace quantity_month_unit = 2 if livestock_code== 404 & quantity_month_unit==3
replace quantity_month_unit =. if livestock_code==404 & quantity_month_unit!=2     // VAP: now, only keeping kgs for meat
replace quantity_month_unit =. if livestock_code== 406 & quantity_month_unit!=3   // VAP: skin and hide, pieces. Not converting kg and bucket.
replace quantity_month_unit =. if livestock_code== 407 & quantity_month_unit!=2 // VAP: manure, using only obsns in kgs. 
// This is a bigger problem, as there are many obsns in bucket, wheelbarrow & ox-cart but no conversion factors.
recode months_produced quantity_month (.=0) 
gen quantity_produced = months_produced * quantity_month // Units are liters for milk, pieces for eggs & skin, kg for meat and manure. 
lab var quantity_produced "Quantity of this product produced in past year"

rename ag_s05a sales_quantity
rename ag_s05b sales_unit
*replace sales_unit =. if livestock_code==401 & sales_unit!=1 // milk, liters only
replace sales_unit =. if livestock_code==402 & sales_unit!=3  // chicken eggs, pieces only
replace sales_unit =. if livestock_code== 403 & sales_unit!=3   // guinea fowl eggs, pieces only
replace sales_quantity = sales_quantity*1.5 if livestock_code==404 & sales_unit==3 // VAP: converting obsns in pieces to kgs for meat. Using conversion for chicken. 
replace sales_unit = 2 if livestock_code== 404 & sales_unit==3 // VAP: kgs for meat
replace sales_unit =. if livestock_code== 406 & sales_unit!=3   // VAP: pieces for skin and hide, not converting kg.
replace sales_unit =. if livestock_code== 407 & quantity_month_unit!=2  // VAP: kgs for manure, not converting liters(1 obsn), bucket, wheelbarrow & oxcart

rename ag_s06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales

label define livestock_code_label 402 "Chicken Eggs" 403 "Guinea Fowl Eggs" 404 "Meat" 406 "Skin/Hide" 407 "Manure" 408 "Other" //RH - added "other" lbl to 408, removed 401 "Milk"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price per unit sold"
lab var price_per_unit_hh "Price per unit sold at household level"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_other", replace

*All Livestock Products
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_milk", clear
append using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_other"
recode price_per_unit (0=.)
merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta" //no stratum in hhids
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
lab var price_per_unit "Price per unit sold"
lab var quantity_produced "Quantity of product produced"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", replace

* EA Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district TA ea_id livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district TA ea_id livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_ea.dta", replace

* TA Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district TA livestock_code: egen obs_TA = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district TA livestock_code obs_TA)
rename price_per_unit price_median_TA
lab var price_median_TA "Median price per unit for this livestock product in the TA"
lab var obs_TA "Number of sales observations for this livestock product in the TA"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_TA.dta", replace 

* District Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_district.dta", replace

* Region Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_region.dta", replace

* Country Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_country.dta", replace

use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products", clear
merge m:1 region district TA ea_id livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_TA if price_per_unit==. & obs_TA >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values" 

gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==402|livestock_code==403
gen value_other_produced = quantity_produced * price_per_unit if livestock_code== 404|livestock_code==406|livestock_code==407|livestock_code==408
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livestock prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of skins, meat and manure produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_products", replace

* Manure (Dung in TZ)
use "${MWI_IHS_IHPS_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (hhid)
lab var sales_manure "Value of manure sold" 
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_manure.dta", replace 

*Sales (live animals) //w4 has no slaughter questions
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_r1.dta", clear
rename ag_r0a livestock_code
rename ag_r17 income_live_sales     // total value of sales of [livestock] live animals last 12m -- RH note, w3 label doesn't include "during last 12m"
rename ag_r16 number_sold          // # animals sold alive last 12 m
*rename ag_r19 number_slaughtered  // # animals slaughtered last 12 m - Not available in w4
/* VAP: not available in MW2 or w3 - no slaughter questions in w4
rename lf02_32 number_slaughtered_sold  // # of slaughtered animals sold
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
rename lf02_33 income_slaughtered // # total value of sales of slaughtered animals last 12m
*/
rename ag_r11 value_livestock_purchases // tot. value of purchase of live animals last 12m
recode income_live_sales number_sold /*number_slaughtered*/ /*number_slaughtered_sold income_slaughtered*/ value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animals sold"
recode price_per_animal (0=.) 
merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district TA ea livestock_code number_sold income_live_sales /*number_slaughtered*/ /*number_slaughtered_sold income_slaughtered*/ price_per_animal value_livestock_purchases
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", replace // RH complete - no slaughter questions in w4
 
*Implicit prices  // VAP: MW2, w3, w4 do not have value of slaughtered livestock
		
* EA Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district TA ea_id livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district TA ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_ea.dta", replace 

* TA Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district TA livestock_code: egen obs_TA = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district TA livestock_code obs_TA)
rename price_per_animal price_median_TA
lab var price_median_TA "Median price per unit for this livestock in the TA"
lab var obs_TA "Number of sales observations for this livestock in the TA"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_TA.dta", replace 

* District Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_district.dta", replace

* Region Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_region.dta", replace

* Country Level
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_country.dta", replace //RH note - check TA code? different from ws 2 & 3

use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_sales", clear
merge m:1 region district TA ea_id livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_TA if price_per_animal==. & obs_TA >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
*gen value_slaughtered = price_per_animal * number_slaughtered //RH: no slaughter questions in w4
{
/* VAP: Not available for MW2, w3, w4
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
*gen value_slaughtered_sold = income_slaughtered 
replace value_slaughtered_sold = income_slaughtered if (value_slaughtered_sold < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
replace value_slaughtered = value_slaughtered_sold if (value_slaughtered_sold > value_slaughtered) & (number_slaughtered > number_slaughtered_sold) //replace value of slaughtered with value of slaughtered sold if value sold is larger
*gen value_livestock_sales = value_lvstck_sold  + value_slaughtered_sold 
*/
}

collapse (sum) /*value_livestock_sales*/ value_livestock_purchases value_lvstck_sold /*value_slaughtered*/, by (hhid)
drop if hhid==""
*lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases"
*lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_sales", replace //RH complete

*TLU (Tropical Livestock Units)
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_r1.dta", clear
rename ag_r0a livestock_code 
gen tlu_coefficient=0.5 if (livestock_code==301|livestock_code==302|livestock_code==303|livestock_code==304|livestock_code==3304) // calf, steer/heifer, cow, bull, ox
replace tlu_coefficient=0.1 if (livestock_code==307|livestock_code==308) //goats, sheep
replace tlu_coefficient=0.2 if (livestock_code==309) // pigs
replace tlu_coefficient=0.01 if (livestock_code==311|livestock_code==313|livestock_code==315|livestock_code==319|livestock_code==3310|livestock_code==3314) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
replace tlu_coefficient=0.3 if (livestock_code==3305) // donkey/mule/horse
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

rename ag_r07 number_1yearago
rename ag_r02 number_today_total
rename ag_r03 number_today_exotic
gen number_today_indigenous = number_today_total - number_today_exotic
recode number_today_total number_today_indigenous number_today_exotic (.=0)
*gen number_today = number_today_indigenous + number_today_exotic // already exists (number_today_total)
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_total * tlu_coefficient
rename ag_r17 income_live_sales 
rename ag_r16 number_sold

rename ag_r21b lost_disease // VAP: Includes lost to injury in MW2
*rename lf02_22 lost_injury 
rename ag_r19 lost_stolen // # of livestock lost or stolen in last 12m
egen mean_12months = rowmean(number_today_total number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_stolen)	
gen share_imp_herd_cows = number_today_exotic/(number_today_total) if livestock_code==303 // VAP: only cows, not including calves, steer/heifer, ox and bull
gen species = (inlist(livestock_code,301,302,202,204,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code,311,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calves, steer/heifer, cows, bulls, oxen)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, mules)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today_total number_1yearago animals_lost12months lost_disease /*ihs*/ number_today_exotic lvstck_holding=number_today_total, by(hhid species)
	egen mean_12months = rowmean(number_today_total number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today_total!=. & number_today_total!=0
	
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease /*ihs*/{
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
	
	foreach i in lvstck_holding animals_lost12months mean_12months lost_disease /*ihs*/{
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost in last 12 months"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	lab var lost_disease "Total number of livestock lost to disease or injury" //ihs
	
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease /*ihs*/{
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
	save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_herd_characteristics", replace
restore
	
gen price_per_animal = income_live_sales / number_sold
merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district TA ea livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_prices_country.dta", nogen		
recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_TA if price_per_animal==. & obs_TA >= 10
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
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_TLU.dta", replace

*Livestock income
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_sales", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_livestock_products", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_manure.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_expenses", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_TLU.dta", nogen

gen livestock_income = value_lvstck_sold + /*value_slaughtered*/ - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_livestock_income.dta", replace

************
*FISH INCOME - Complete by HKS 6/29/23, not checked
************
*Fishing expenses  
/*VAP: Method of calculating ft and pt weeks and days consistent with ag module indicators for rainy/dry seasons*/
use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_c.dta", clear
append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_g.dta"
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
collapse (max) weeks_fishing days_per_week, by (hhid case) 
keep hhid weeks_fishing days_per_week
lab var weeks_fishing "Weeks spent working as a fisherman (maximum observed across individuals in household)"
lab var days_per_week "Days per week spent working as a fisherman (maximum observed across individuals in household)"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weeks_fishing.dta", replace

* Fisheries Input
use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_d1.dta", clear // FS MOD D (HIGH season) Q1-6
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_d2.dta"  // FS (HIGH season) MOD D Q7-13
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_d3.dta" // FS (HIGH season) MOD D Q14-24
append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_h1.dta" // FS (LOW season) MOD H Q1-6
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_h2.dta" // FS (LOW season) MOD H Q7-13
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_h3.dta" // FS (LOW season) MOD H Q14-24
//ren HHID hhid
merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weeks_fishing.dta"
rename weeks_fishing weeks
rename fs_d13 fuel_costs_week
replace fuel_costs_week = fs_h13 if fuel_costs_week==.
rename fs_d12 rental_costs_fishing // VAP: Boat/Engine rental.
replace rental_costs_fishing=fs_h12 if rental_costs_fishing==.
rename fs_d06 gear_rent // HKS 6.29.23: not in W2; adding in bc available 
replace gear_rent=fs_h06 if gear_rent==.
rename fs_d10 purchase_costs_fishing // VAP: Boat/Engine purchase. Purchase cost is additional in MW2, TZ code does not have this. 
replace purchase_costs_fishing=fs_h10 if purchase_costs_fishing==. 
rename fs_d04 purchase_gear_cost // HKS 6.29.23: not in W2; adding in bc available 
replace purchase_gear_cost = fs_h04 if purchase_gear_cost ==.
recode weeks fuel_costs_week rental_costs_fishing  purchase_costs_fishing(.=0)
gen cost_fuel = fuel_costs_week * weeks
preserve
collapse (sum) cost_fuel rental_costs_fishing, by (hhid)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fishing_expenses_1.dta", replace // VAP: Not including hired labor costs, keeping consistent with TZ. Can add this for MW if needed. 
restore

* Other fishing costs  
*use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_d.dta", clear
*append using "${MLW_W2_raw_data}\Fisheries\fs_mod_h4_13.dta"
*merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weeks_fishing"
rename fs_d24a total_cost_high // total other costs in high season, only 6 obsns. 
	replace total_cost_high=fs_h24a if total_cost_high==.
rename fs_d24b unit
	replace unit=fs_h24b if unit==. 
gen cost_paid = total_cost_high if unit== 2  // season
	replace cost_paid = total_cost_high * weeks if unit==1 // weeks
collapse (sum) cost_paid, by (hhid) // HKS 6/29/23; there are very few hh with additional expense here (4/1209 obs)
lab var cost_paid "Other costs paid for fishing activities"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fishing_expenses_2.dta", replace

* Fish Prices
//ALT 10.18.19: It doesn't look like the data match up with the questions in module e.
use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_e1.dta", clear
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_i1.dta"
rename fs_e02 fish_code 
	replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=11) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
	replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b fish_quantity_unit
	replace fish_quantity_unit=fs_i06b if fish_quantity_unit==.
rename fs_e08b unit  // piece, dozen/bundle, kg, small basket, large basket
	gen price_per_unit = fs_e08d // VAP: This is already avg. price per packaging unit. Did not divide by avg. qty sold per week similar to TZ, seems to be an error?
replace price_per_unit = fs_i08d if price_per_unit==.
merge m:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hhids.dta", nogen keep(1 3)
recode price_per_unit (0=.) 
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==11
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_prices.dta", replace

* Value of fish harvest & sales 
use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_e1.dta", clear
append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=11) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b unit  // piece, dozen/bundle, kg, small basket, large basket
merge m:1 fish_code unit using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_prices.dta",  nogen keep(1 3)
rename fs_e08a quantity_1 // "How much [fish species] did your hh sell?"
	replace quantity_1=fs_i08a if quantity_1==.
rename fs_e08b unit_1	// "Identify type of packaging.."
	replace unit_1=fs_i08b if unit_1==.
gen price_unit_1 = fs_e08d // not divided by qty unlike TZ, not sure about the logic of dividing here. // "Identify form of processing for..."
	replace price_unit_1=fs_i08d if price_unit_1==.
rename fs_e08g quantity_2 // "How much [fish species] did your hh sell?"
	replace quantity_2=fs_i08g if quantity_2==.
rename fs_e08h unit_2 // form of packaging
	replace unit_2= fs_i08h if unit_2==.
gen price_unit_2=fs_e08j // not divided by qty unlike TZ. // form of processing
	replace price_unit_2=fs_i08j if price_unit_2==.

recode quantity_1 quantity_2 fish_quantity_year (.=0)
gen income_fish_sales = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest = (fish_quantity_year * price_unit_1) if unit==unit_1 
replace value_fish_harvest = (fish_quantity_year * price_per_unit_median) if value_fish_harvest==.
collapse (sum) value_fish_harvest income_fish_sales, by (hhid y4 case_id)
ren y4 y4_hhid
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_income.dta", replace

*Fish trading
use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_c.dta", clear
append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_g.dta"
rename fs_c04a weeks_fish_trading 
	replace weeks_fish_trading=fs_g04a if weeks_fish_trading==.
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (hhid case_id y4)
ren y4 y4_hhid  
keep hhid case_id y4 weeks_fish_trading case_i
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weeks_fish_trading.dta", replace

use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_f1.dta", clear
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_f2.dta"
append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_j1.dta"
	append using "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_j2.dta"
rename fs_f02a quant_fish_purchased_1
	replace quant_fish_purchased_1= fs_j02a if quant_fish_purchased_1==.
rename fs_f02f price_fish_purchased_1 // avg price per packaging unit
	replace price_fish_purchased_1= fs_j02f if price_fish_purchased_1==.
rename fs_f02h quant_fish_purchased_2
	replace quant_fish_purchased_2= fs_j02h if quant_fish_purchased_2==. 
rename fs_f02m price_fish_purchased_2 // avg price per packaging unit
	replace price_fish_purchased_2= fs_j02m if price_fish_purchased_2==.
rename fs_f03a quant_fish_sold_1
	replace quant_fish_sold_1=fs_j03a if quant_fish_sold_1==.
rename fs_f03f price_fish_sold_1
	replace price_fish_sold_1=fs_j03f if price_fish_sold_1==.
rename fs_f03h quant_fish_sold_2
	replace quant_fish_sold_2=fs_j03g if quant_fish_sold_2==.
rename fs_f03m price_fish_sold_2
	replace price_fish_sold_2=fs_j03l if price_fish_sold_2==.
/* VAP: Had added other costs here, but commenting out to be consistent with TZ. 
rename fs_f05 other_costs_fishtrading // VAP: Hired labor, transport, packaging, ice, tax in MW2, not in TZ.
replace other_costs_fishtrading=fs_j05 if other_costs_fishtrading==. 
*/
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 /*other_costs_fishtrading*/(.=0)

gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2) /*+ other_costs_fishtrading*/
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit, by (hhid case_id y4)
 ren y4 y4_hhid
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep hhid weekly_fishtrade_profit case_i y4
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_trading_revenues.dta", replace   

use "${MWI_IHS_IHPS_W4_raw_data}\fs_mod_f2.dta", clear
rename fs_f05 weekly_costs_for_fish_trading // VAP: Other costs: Hired labor, transport, packaging, ice, tax in MW2.
//	replace weekly_costs_for_fish_trading=fs_j05 if weekly_costs_for_fish_trading==.
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (hhid case_id y4)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep hhid case_id weekly_costs_for_fish_trading y4
ren y4 y4_hhid
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_trading_other_costs.dta", replace

use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_weeks_fish_trading.dta", clear
merge 1:1 hhid case_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_trading_revenues.dta" 
drop _merge
merge 1:1 hhid case_id using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep hhid case_id fish_trading_income y4
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fish_trading_income.dta", replace


************
*OTHER INCOME - HKS copied from MS AL Seasonal Hunger by FN on 6.29.23
************
*use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_prices.dta", clear
*keep if crop_code==1 // keeping only maize for later
*save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta", replace

use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_P.dta", clear
append using "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_R.dta" 
append using "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_O.dta"
*merge m:1 HHID using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\temp\Malawi_IHS_LSMS_ISA_W3_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
*merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
rename hh_p0a income_source
ren hh_p01 received_income
ren hh_p02 amount_income
gen rental_income=amount_income if received_income==1 & inlist(income_source, 106, 107, 108, 109) // non-ag land rental, house/apt rental, shope/store rental, vehicle rental
gen pension_investment_income=amount_income if received_income==1 &  income_source==105| income_source==104 | income_source==116 // pension & savings/interest/investment income+ private pension
gen asset_sale_income=amount_income if received_income==1 &  inlist(income_source, 110,111,112) // real estate sales, non-ag hh asset sale income, hh ag/fish asset sale income
gen other_income=amount_income if received_income==1 &  inlist(income_source, 113, 114, 115) // inheritance, lottery, other income
rename hh_r0a prog_code

gen assistance_cash_yesno= hh_r02a!=0 & hh_r02a!=. if inlist(prog_code, 1031, 104,108,1091,111,112) // Cash from MASAF, Non-MASAF pub. works,
*inputs-for-work, sec. level scholarships, tert. level. scholarships, dir. Cash Tr. from govt, DCT other
gen assistance_food= hh_r02b!=0 & hh_r02b!=.  if inlist(prog_code, 101, 102, 1032, 105, 107) //  
gen assistance_otherinkind_yesno=hh_r02b!=0 & hh_r02b!=. if inlist(prog_code,104, 106, 112, 113) // 

rename hh_o14 cash_remittance // VAP: Module O in MW2
rename hh_o17 in_kind_remittance // VAP: Module O in MW2 //ALT - ditto+
recode rental_income pension_investment_income asset_sale_income other_income assistance_cash assistance_food /*assistance_inkind cash_received inkind_gifts_received*/  cash_remittance in_kind_remittance (.=0)
gen remittance_income = /*cash_received + inkind_gifts_received +*/ cash_remittance + in_kind_remittance
*gen assistance_income = assistance_cash + assistance_food + assistance_inkind
lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"

gen remittance_income_yesno = remittance_income!=0 & remittance_income!=. //FN: creating dummy for remittance
gen rental_income_yesno= rental_income!=0 & rental_income!=.

gen pension_investment_income_yesno= pension_investment_income!=0 & pension_investment_income!=.
gen asset_sale_income_yesno= asset_sale_income!=0 & asset_sale_income!=.
gen other_income_yesno= other_income!=0 & other_income!=.
collapse (max) *_yesno  (sum) remittance_income rental_income pension_investment_income asset_sale_income other_income, by(hhid y4 case_id)
recode *_yesno *_income (.=0)
egen any_other_income_yesno=rowmax(rental_income_yesno pension_investment_income_yesno asset_sale_income_yesno other_income_yesno)

lab var remittance_income_yesno "1=Household received some remittances (cash or in-kind)"
lab var any_other_income_yesno "1=Household received some other non-farm income (rental, asset sales, pension, others)"
lab var rental_income_yesno "1=Household received some income from properties rental"
lab var asset_sale_income_yesno "1=Household received some income from the sale of assets"
lab var pension_investment_income_yesno "1=Household received some income from pension"
lab var other_income_yesno "1=Household received some other non-farm income"

lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"

lab var assistance_cash_yesno "1=Household received some cash assistance"
lab var assistance_otherinkind_yesno "1=Household received some inkind assistance"
//ren HHID hhid
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_other_income.dta", replace

************
* Other: Land Rental Income - HKS copied from MWI W2
************
* HKS 6.29.23: MWI W2 (and presumably others) have land rents at the PLOT level, whereas MWI W4 has land rents at the GARDEN level.
	* Questionnaire shows AG MOD B2 Q19 asking " how much did you ALREADY receive from renting out this garden in the rainy season", but q19 is omitted from the raw data
	* We do have Q B217 though: "How much did you receive from renting out this garden in the rainy season"
* Cross section got q17 whereas panel got q19;
* for MSAI request 6/30/23, refer only to cross section (prefer q17); for general LSMS purposes, need to incorporate the panel data;
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_b2.dta", clear // *VAP: The below code calculates only agricultural land rental income, per TZ guideline code 
append using "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_i2.dta" 
rename ag_b217a land_rental_cash_rainy_recd // how much did you receive from renting out this garden in the rainy season
rename ag_b217b land_rental_inkind_rainy_recd // how much did you receive from renting out this garden in the rainy season (in kind)
*rename ag_d19c land_rental_cash_rainy_owed
*rename ag_d19d land_rental_inkind_rainy_owed
rename ag_i217a land_rental_cash_dry_recd // how much did you receive from renting out this garden in the dry season
rename ag_i217b land_rental_inkind_dry_recd // how much did you receive from renting out this garden in the dry season
*rename ag_k20c land_rental_cash_dry_owed
*rename ag_k20d land_rental_inkind_dry_owed
recode land_rental_cash_rainy_recd land_rental_inkind_rainy_recd /*land_rental_cash_rainy_owed land_rental_inkind_rainy_owed*/ land_rental_cash_dry_recd land_rental_inkind_dry_recd /*land_rental_cash_dry_owed land_rental_inkind_dry_owed */ (.=0)
gen land_rental_income_rainyseason= land_rental_cash_rainy_recd + land_rental_inkind_rainy_recd //+ land_rental_cash_rainy_owed + land_rental_inkind_rainy_owed
gen land_rental_income_dryseason= land_rental_cash_dry_recd + land_rental_inkind_dry_recd //+ land_rental_cash_dry_owed + land_rental_inkind_dry_owed 
gen land_rental_income = land_rental_income_rainyseason + land_rental_income_dryseason
collapse (sum) land_rental_income, by (hhid /*y4*/ case_id)
*ren y4 y4_hhid
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_land_rental_income.dta", replace

*****************
* CROP INCOME - HKS copied from CWL code for MWI4 on 6.29.23
*****************


************
*SELF-EMPLOYMENT INCOME - HKS copied from MS AL Seasonal Hunger by FN on 6.29.23
************
use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_N2.dta", clear
rename hh_n40 last_months_profit 
gen self_employed_yesno = .
replace self_employed_yesno = 1 if last_months_profit !=.
replace self_employed_yesno = 0 if last_months_profit == .
*DYA.2.9.2022 Collapse this at the household level
collapse (max) self_employed_yesno (sum) last_months_profit, by(hhid case_id y4)
drop if self != 1
ren last_months self_employ_income
ren y4 y4_hhid
*lab var self_employed_yesno "1=Household has at least one member with self-employment income"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_self_employment_income.dta", replace

************
*NON-AG WAGE INCOME - RH complete 8/2 - not checked
************
use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno // MW2: In last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. 
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. 
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. 
rename hh_e25 most_recent_payment // amount of last payment
replace most_recent_payment=. if inlist(hh_e19b,62 63 64) // VAP: main wage job 
**** 
* VAP: For MW2, above codes are in .dta. 62:Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers   
* For TZ: TASCO codes from TZ Basic Info Document http://siteresources.worldbank.org/INTLSMS/Resources/3358986-1233781970982/5800988-1286190918867/TZNPS_2014_2015_BID_06_27_2017.pdf
	* 921: Agricultural, Forestry, and Fishery Labourers
	* 611: Farmers and Crop Skilled Workers
	* 612: Animal Producers and Skilled Workers
	* 613: Forestry and Related Skilled Workers
	* 614: Fishery Workers, Hunters, and Trappers
	* 621: Subsistence Agricultural, Forestry, Fishery, and Related Workers
***
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if inlist(hh_e19b,62,63,64) // code of main wage job 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if hh_e33_code== 62 // code of secondary wage job; 
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38_1 secwage_hours_pastweek // In the last 7 days, how many hours did you work in this job?
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
tab secwage_payment_period
//ren HHID hhid
collapse (sum) annual_salary, by (hhid case_id y4)
ren y4 y4_hhid
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_wage_income.dta", replace

************
*AG WAGE INCOME - RH IP
************
use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno // MW3: last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
* TZ: last 12m, work as an unpaid apprentice OR employee for a wage, salary, commission or any payment in kind; incl. paid apprenticeship, domestic work or paid farm work 
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. TZ: During the last 12 months, for how many months did [NAME] work in this job?
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. TZ: During the last 12 months, how many weeks per month did [NAME] usually work in this job?
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. TZ: During the last 12 months, how many hours per week did [NAME] usually work in this job?
rename hh_e25 most_recent_payment // amount of last payment

gen agwage = 1 if inlist(hh_e19b,62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers - RH note: occupation codes not in dta file for w3, see BID "Occupation Codes", pg 36

gen secagwage = 1 if inlist(hh_e33_code, 62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers - RH note: occupation codes not in dta file for w3, see BID "Occupation Codes", pg 36

*gen secagwage = 1 if hh_e33_code==62 //62: Agriculture and animal husbandry worker // double check this. Do we actually only want animal husbandry? - VAP code, RH changed to match secagwage codes to agwage codes.

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
rename hh_e38_1 secwage_hours_pastweek // In the last 7 days, how many hours did you work in this job?

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
collapse (sum) annual_salary, by (hhid case_id y4)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_agwage_income.dta", replace  // 0 annual earnings, 3907 obsns


***************
*VACCINE USAGE - RH complete 8/3, rerun after confirming gender_merge
***************
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_r1.dta", clear
gen vac_animal=ag_r22>0
* MW4: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace vac_animal = 0 if ag_r22==0  
replace vac_animal = . if ag_r22==. // VAP: 4092 observations on a hh-animal level

*Disagregating vaccine usage by animal type 
rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 311,313,315,319,3310,3314))
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
// VAP: After collapsing, the data is on hh level, vac_animal now has only 1883 observations
lab var vac_animal "1=Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_vaccine.dta", replace

 
*vaccine use livestock keeper  
use "${MWI_IHS_IHPS_W4_raw_data}\ag_mod_r1.dta", clear
gen all_vac_animal=ag_r22>0
* MW4: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace all_vac_animal = 0 if ag_r22==0  
replace all_vac_animal = . if ag_r22==. // VAP: 4092 observations on a hh-animal level
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
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_gender_merge.dta", nogen //RH NOTE: not yet created, run code after gender_merge
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
ren indiv indidy4 //renamed from indidy3
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_farmer_vaccine.dta", replace	

***************
*ANIMAL HEALTH - DISEASES - RH IP
***************
		
***************
*LIVESTOCK WATER, FEEDING, AND HOUSING - Cannot replicate for MWI
***************
/* Cannot replicate this section as MW2 Qs. does not ask about livestock water, feeding, housing. */


***************
*USE OF INORGANIC FERTILIZER - RH complete 8/6/21
//ALT TO DO: Update with input use module from TZA/NGA
***************
use "${MWI_IHS_IHPS_W4_raw_data}/AG_MOD_D.dta", clear
append using "${MWI_IHS_IHPS_W4_raw_data}/AG_MOD_K.dta" 
gen all_use_inorg_fert=.
replace all_use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace all_use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode all_use_inorg_fert (.=0)
lab var all_use_inorg_fert "1 = Household uses inorganic fertilizer"

keep hhid ag_d01 ag_d01_2a ag_d01_2b ag_k02 ag_k02_2a ag_k02_2b all_use_inorg_fert
ren ag_d01 farmerid1
replace farmerid1= ag_k02 if farmerid1==.
ren ag_d01_2a farmerid2
replace farmerid2= ag_k02_2a if farmerid2==.
ren ag_d01_2b farmerid3
replace farmerid2= ag_k02_2b if farmerid3==.	

//reshape long
gen t = 1
gen patid = sum(t)

reshape long farmerid, i(patid) j(decisionmakerid)
drop t patid

collapse (max) all_use_inorg_fert , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren indiv indidy4
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_farmer_fert_use.dta", replace		

*********************
*USE OF IMPROVED SEED - VAP: cannot be replicated       
*********************
/* VAP: Cannot replicate for MWI w2. Seed type is not broken down into improved and traditional in MW2. */
//ALT: Available for wave 4 (q is ag_g0f). Please construct using the inputs module from NGA/TZA

*********************
*REACHED BY AG EXTENSION - RH complete 8/26/21, not checked  
*********************
use "${MWI_IHS_IHPS_W4_raw_data}/AG_MOD_T1.dta", clear
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
gen advice_electronicmedia = (sourceid==12|sourceid==15|sourceid==16 & receive_advice==1) // electronic media:Radio -- MWI w4 has additional electronic media sources (phone/SMS, other electronic media (TV,etc))
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
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  // QUESTION - ffd and course in unspecified?
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_pvt) //advice_pvt new addition
gen ext_reach_unspecified=(advice_neigh==1 | advice_pub==1 | advice_other==1 | advice_farmer==1 | advice_ffd==1 | advice_course==1 | advice_village==1) //RH - Re: VAP's check request - Farmer field days and courses incl. here - seems correct since we don't know who put those on, but flagging
gen ext_reach_ict=(advice_electronicmedia==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1)

collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_any_ext.dta", replace

********************************************************************************
* MOBILE OWNERSHIP * //RH complete 8/26/21 - not checked
********************************************************************************
//Added based on TZA w5 code

use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_F.dta", clear
//recode missing to 0 in hh_g301 (0 mobile owned if missing)
recode hh_f34 (.=0)
ren hh_f34 hh_number_mobile_owned
*recode hh_number_mobile_owned (.=0) 
gen mobile_owned = 1 if hh_number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0
collapse (max) mobile_owned, by(hhid)
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_mobile_own.dta", replace 
 	
*********************
*USE OF FORMAL FINANCIAL SERVICES - RH complete 8/10/21, not checked
*********************
use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_F.dta", clear
append using "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_S1.dta"
gen borrow_bank= hh_s04==10 // VAP: Code source of loan. No microfinance or mortgage loan in Malawi W2 unlike TZ. 
gen borrow_relative=hh_s04==1|hh_s04==12 //RH Check request: w3 has village bank [12]. Confirm including under "Borrow_bank"?
gen borrow_moneylender=hh_s04==4 // NA in TZ
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
gen borrow_other_fin=hh_s04==7|hh_s04==8|hh_s04==9 // VAP: MARDEF, MRFC, SACCO
gen borrow_neigh=hh_s04==2
gen borrow_employer=hh_s04==5
gen borrow_ngo=hh_s04==11
gen borrow_other=hh_s04==13

gen use_bank_acount=hh_f52==1
// VAP: No MM for MWI.  
// gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 | hh_q01_4==1 // use any MM services - MPESA ZPESA AIRTEL TIGO PESA. 
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit= borrow_bank==1  | borrow_other_fin==1 // VAP: Include religious institution in this definition? No mortgage.  
// VAP: No digital and insurance in MWI
// gen use_fin_serv_insur= borrow_insurance==1
// gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 |  use_fin_serv_others==1 /*use_fin_serv_insur==1 | use_fin_serv_digital==1 */ 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
// lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
// lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_fin_serv.dta", replace	

************
*MILK PRODUCTIVITY - RH complete 8/10/21 - not checked
************
//RH: only cow milk in MWI, not including large ruminant variables
*Total production
use "${MWI_IHS_IHPS_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]? (rh edited)
rename ag_s03a liters_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. (RH renamed to be more consistent with TZA (from qty_milk_per_month to liters_month))
gen milk_liters_produced = months_milked * liters_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

* lab var milk_animals "Number of large ruminants that was milk (household)": Not available in MW2 (only cow milk) 
lab var months_milked "Average months milked in last year (household)"
drop if milk_liters_produced==.
keep hhid product_code months_milked liters_month milk_liters_produced
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_milk_animals.dta", replace

************
*EGG PRODUCTIVITY - RH complete, not checked 
************
use "${MWI_IHS_IHPS_W4_raw_data}\AG_MOD_R1.dta", clear
rename ag_r0a lvstckid
gen poultry_owned = ag_r02 if inlist(lvstckid, 311, 313, 315, 318, 319, 3310, 3314) // For MW2: local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl - RH include other?
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${MWI_IHS_IHPS_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==402 | product_code==403
rename ag_s02 eggs_months // # of months in past year that hh. produced eggs
rename ag_s03a eggs_per_month  // avg. qty of eggs per month in past year
rename ag_s03b quantity_month_unit
replace quantity_month = round(quantity_month/0.06) if product_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs for eggs 
replace quantity_month_unit = 3 if product_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if product_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if product_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
recode eggs_months eggs_per_month (.=0)
collapse (sum) eggs_per_month (max) eggs_months, by (hhid) // VAP: Collapsing chicken & guinea fowl eggs
gen eggs_total_year = eggs_months* eggs_per_month // Units are pieces for eggs 
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months eggs_per_month eggs_total_year poultry_owned 

lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_eggs_animals.dta", replace

********************************************************************************
*CONSUMPTION -- RH complete 10/25/21
******************************************************************************** 
/*
use "${MWI_IHS_IHPS_W4_raw_data}/ihs5_consumption_aggregate.dta", clear 
ren expagg total_cons // using real consumption-adjusted for region price disparities -- this is nominal (but other option was per capita vs hh-level). Confirm?
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hhsize)
gen daily_peraeq_cons = peraeq_cons/365 
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep HHID total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq 
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_consumption.dta", replace
*/
		
********************************************************************************
*HOUSEHOLD FOOD PROVISION* -- RH complete (7/15/21) - not checked
********************************************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_H.dta", clear
numlist "1/25"
forvalues k=1/25 {
    local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_h05`alph' hh_h05_`num'
}
forvalues k = 1/25 {
    gen food_insecurity_`k' = (hh_h05_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
* replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep hhid months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_food_insecurity.dta", replace				
			
***************************************************************************
*HOUSEHOLD ASSETS* - RH complete 8/24/21
***************************************************************************
use "${MWI_IHS_IHPS_W4_raw_data}\HH_MOD_L.dta", clear
*ren hh_m03 price_purch  // RH: No price purchased, only total spent on item
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items

collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_hh_assets.dta", replace 
				
		
***************************************************************************
*SHANNON DIVERSITY INDEX - CWL complete 09/26/22 - not checked
***************************************************************************
/*
use "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_all_plots.dta", clear
/*
*Area planted
*Bringing in area planted for LRS
use "${Tanzania_NPS_W5_created_data}/Tanzania_NPS_W5_hh_crop_area_plan_LRS.dta", clear
append using "${Tanzania_NPS_W5_created_data}/Tanzania_NPS_W5_hh_crop_area_plan_SRS.dta"
//we don't want to count crops that are grown in the SRS and LRS as different.
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
//ALT 07.21.21: As of this update, most tree crops are included with the exception of some instances where it is impossible to estimate crop area because any reasonable attempt at estimation would result in an overplanted plot. The line below is designed to drop tree crops for consistency; remove or comment out if you want to include them */

//Begin tree crop removal
	drop if ha_planted==0 //15,996 observations removed
	drop if number_trees_planted>0 &  (crop_code!=49 & crop_code!=55) //Hold on to cassava and banana; 1248 obs removed
//End tree crop removal

// Generate area_plan by dm_gender
// Note: there is no "${{MWI_IHS_IHPS_W4_created_data}/{MWI_IHS_IHPS_W4_created_data_crop_area_plan_shannon.dta" file
gen area_plan=ha_planted
gen area_plan_hh=ha_planted
gen area_plan_female_hh=ha_planted if dm_gender==2
gen area_plan_male_hh=ha_planted if dm_gender==1
gen area_plan_mixed_hh=ha_planted if dm_gender==3
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
bysort hhhid (sdi_crop_male) : gen allmissing_male = mi(sdi_crop_male[1])
bysort hhid (sdi_crop_mixed) : gen allmissing_mixed = mi(sdi_crop_mixed[1])
*Generating number of crops per household
bysort hhid crop_code : gen nvals_tot = _n==1
gen nvals_female = nvals_tot if area_plan_female!=0 & area_plan_female!=.
gen nvals_male = nvals_tot if area_plan_male!=0 & area_plan_male!=. 
gen nvals_mixed = nvals_tot if area_plan_mixed!=0 & area_plan_mixed!=.
collapse (sum) sdi=sdi_crop sdi_female=sdi_crop_female sdi_male=sdi_crop_male sdi_mixed=sdi_crop_mixed num_crops_hh=nvals_tot num_crops_female=nvals_female num_crops_male=nvals_male num_crops_mixed=nvals_mixed (max) allmissing_female allmissing_male allmissing_mixed, by(hhid)
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
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_shannon_diversity_index.dta"		
*/

********************************************************************************
*AGRICULTURAL WAGES  *CWL complete 9/27/2022 - not checked
********************************************************************************
*Hired labor: Module D of Agriculture Survey
use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_d.dta", clear // Rainy season

/* CWL Note: ag_d46* and ag_d47* look identical in label and instrument - one hypothesis 
is that d46 is for non-panel households and d47 is for panel households where panel households are
involved in multiple waves of the survey. calculating both for comparison
but only including 47 following MWI W3 ag expenses code. 
*/

//Calculating for non-panel households
// CWL: ag_46*1 is labeled "...any non-harvest activity" but instrument says "any and all types of activities" without specifying harvest or non-harvest. 
rename ag_d46a1 no_days_men_npanel // non harvest activities: land preparation, planting, ridging, weeding, fertilizing
rename ag_d46b1 avg_dlywg_men_npanel		// men daily wage 
rename ag_d46a2 no_days_women_npanel
rename ag_d46b2 avg_dlywg_women_npanel
rename ag_d46a3 no_days_chldrn_npanel
rename ag_d46b3 avg_dlywg_chldrn_npanel
recode no_days_men_npanel avg_dlywg_men_npanel no_days_women_npanel avg_dlywg_women_npanel no_days_chldrn_npanel avg_dlywg_chldrn_npanel (.=0)

gen tot_wg_men_npanel = no_days_men_npanel*avg_dlywg_men_npanel 			//wages: rainy season male 
gen tot_wg_women_npanel = no_days_women_npanel*avg_dlywg_women_npanel 		//wages: rainy season female 
gen tot_wg_chldrn_npanel = no_days_chldrn_npanel*avg_dlywg_chldrn_npanel 	//wages: rainy season children 

rename ag_d47a1 no_days_men_nharv 		// non harvest activities: land preparation, planting, ridging, weeding, fertilizing
rename ag_d47b1 avg_dlywg_men_nharv		// men daily wage 
rename ag_d47a2 no_days_women_nharv
rename ag_d47b2 avg_dlywg_women_nharv
rename ag_d47a3 no_days_chldrn_nharv
rename ag_d47b3 avg_dlywg_chldrn_nharv
recode no_days_men_nharv avg_dlywg_men_nharv no_days_women_nharv avg_dlywg_women_nharv no_days_chldrn_nharv avg_dlywg_chldrn_nharv (.=0)

rename ag_d48a1 no_days_men_harv 		// Harvesting wages
rename ag_d48b1 avg_dlywg_men_harv
rename ag_d48a2 no_days_women_harv
rename ag_d48b2 avg_dlywg_women_harv
rename ag_d48a3 no_days_chldrn_harv
rename ag_d48b3 avg_dlywg_chldrn_harv
recode no_days_men_harv avg_dlywg_men_harv no_days_women_harv avg_dlywg_women_harv no_days_chldrn_harv avg_dlywg_chldrn_harv (.=0)

gen tot_wg_men_nharv = no_days_men_nharv*avg_dlywg_men_nharv 			//wages: rainy season male non-harvest activities 
gen tot_wg_women_nharv = no_days_women_nharv*avg_dlywg_women_nharv 		//wages: rainy season female non-harvest activities
gen tot_wg_chldrn_nharv = no_days_chldrn_nharv*avg_dlywg_chldrn_nharv 	//wages: rainy season children non-harvest activities
gen tot_wg_men_harv = no_days_men_harv*avg_dlywg_men_harv 				//wages: rainy season male harvest activities 
gen tot_wg_women_harv = no_days_women_harv*avg_dlywg_women_harv 		//wages: rainy season female harvest activities
gen tot_wg_chldrn_harv = no_days_chldrn_harv*avg_dlywg_chldrn_harv 		//wages: rainy season children harvest activities

*TOTAL WAGES PAID IN RAINY SEASON (add them all up)
gen wages_paid_rainy = tot_wg_men_nharv + tot_wg_women_nharv + tot_wg_chldrn_nharv + tot_wg_men_harv + tot_wg_women_harv + tot_wg_chldrn_harv //This does not include in-kind payments, which are separate in Qs [D50-D53]. 
gen wages_paid_rainy_npanel = tot_wg_men_npanel + tot_wg_women_npanel + tot_wg_chldrn_npanel 

collapse (sum) wages_paid_rainy wages_paid_rainy_npanel, by (hhid) 

//Compare panel and non-panel households - unclear what the relationship is here given most the households that have wages_paid_rainy have two figured for panel and nonpanel which are different numbers. 
count if missing(wages_paid_rainy) //0 missing
count if missing(wages_paid_rainy_npanel) // 0 missing
count if wages_paid_rainy==0 & wages_paid_rainy_npanel==0 //6630
count if wages_paid_rainy !=0 & wages_paid_rainy_npanel !=0 //1390
count if wages_paid_rainy !=0 & wages_paid_rainy_npanel !=0 & wages_paid_rainy !=wages_paid_rainy_npanel //902
count if wages_paid_rainy !=0 & wages_paid_rainy_npanel !=0 & wages_paid_rainy>wages_paid_rainy_npanel //386
drop wages_paid_rainy_npanel
// CWL: we will keep only wages_paid_rainy and non non-panel following W3 for now.

lab var wages_paid_rainy "Wages paid for hired labor in rainyseason"
save "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_wages_rainyseason.dta", replace

use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_k.dta", clear 		// For dry season: All types of activities, no split between harvest and non-harvest like rainy. Check dta: survey says all activites but dta reads for all non-harvest acitivites.  
rename ag_k46a1 no_days_men_all
rename ag_k46b1 avg_dlywg_men_all
rename ag_k46a2 no_days_women_all
rename ag_k46b2 avg_dlywg_women_all
rename ag_k46a3 no_days_chldrn_all
rename ag_k46b3 avg_dlywg_chldrn_all
recode no_days_men_all avg_dlywg_men_all no_days_women_all avg_dlywg_women_all no_days_chldrn_all avg_dlywg_chldrn_all (.=0)

gen tot_wg_men_all = no_days_men_all*avg_dlywg_men_all 			//wages: dry season male
gen tot_wg_women_all = no_days_women_all*avg_dlywg_women_all 	//wages: dry season female 
gen tot_wg_chldrn_all = no_days_chldrn_all*avg_dlywg_chldrn_all //wages:  dry season children 

gen wages_paid_dry = tot_wg_men_all + tot_wg_women_all + tot_wg_chldrn_all //This does not include in-kind payments, which are separate in Qs. 

collapse (sum) wages_paid_dry, by (hhid) 
lab var wages_paid_dry  "Wages paid for hired labor in rainyseason"
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_wages_dryseason.dta", replace

// get wages paid at a household level by adding up wages paid in dry and rainy season 
use "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_wages_rainyseason.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_wages_dryseason.dta", nogen
gen total_wages_paid = wages_paid_rainy if wages_paid_dry==.
replace total_wages_paid = wages_paid_dry if wages_paid_rainy==.
replace total_wages_paid = wages_paid_rainy if wages_paid_dry!=. & wages_paid_rainy!=.
count if missing(total_wages_paid) // no missing wages paid

********************************************************************************
*RATE OF FERTILIZER APPLICATION *CWL complete 10/5/22, Needs checking.
********************************************************************************
/*
* Note: references TZA NPS W5. 
use "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_d.dta", clear //rainy
gen dry=0 //create variable for season
append using "${MWI_IHS_IHPS_W4_raw_data}/ag_mod_k.dta" //dry
recode dry(.=1)
lab var dry "season: 0=rainy, 1=dry"
label define dry 0 "rainy" 1 "dry"
label values dry dry 

// organic fertilizer - rainy (_r) and dry (_d)
rename ag_d36 org_fert_use_r
rename ag_d37a org_fert_qty_r
rename ag_d37b org_fert_unit_r
rename ag_k37 org_fert_use_d
rename ag_k38a org_fert_qty_d
rename ag_k38b org_fert_unit_d // units include: KILOGRAM, BUCKET, WHEELBARROW, OX CART, OTHER. Could not find unit conversion for fertilizer.
// Only use KILOGRAM unit for organic fertilizer 

gen fert_org_kg_r = .
replace fert_org_kg_r = org_fert_qty_r if org_fert_use_r==1 & org_fert_unit_r==2 & org_fert_qty_r !=. // 1932 changes made
gen fert_org_kg_d = .
replace fert_org_kg_d = org_fert_qty_d if org_fert_use_d==1 & org_fert_unit_d==2 & org_fert_qty_d !=. //373 changes made

// inorganic fertilizer - rainy and dry
rename ag_d38 inorg_fert_use_r
rename ag_k39 inorg_fert_use_d

gen fert_inorg_kg_r = .
gen fert_inorg_kg_d = .

// Unit conversion for inorganic fertilizer
foreach i in ag_d39c ag_d39i ag_k40c ag_k40h {
	gen `i'_conversion = .
	replace `i'_conversion = 0.001 if `i'==1 //GRAM
	replace `i'_conversion = 1 if `i'==2 //KG
	replace `i'_conversion = 2 if `i'==3 //2 KG BAG
	replace `i'_conversion = 3 if `i'==4 // 3 KG BAG
	replace `i'_conversion = 5 if `i'==5 // 5 KG BAG
	replace `i'_conversion = 10 if `i'==6 // 10 KG BAG
	replace `i'_conversion = 50 if `i'==7 // 50 KG BAG
}

//0kg if no fertilizer used
replace fert_inorg_kg_r = 0 if inorg_fert_use_r==2 //8,578 changes
replace fert_inorg_kg_d = 0 if inorg_fert_use_d==2 //1,130 changes
//count if inorg_fert_use_r !=. & inorg_fert_use_r!=0 //17,180
//count if inorg_fert_use_r !=. & inorg_fert_use_r!=0 //17,180
//count if inorg_fert_use_d !=. & inorg_fert_use_d!=0 //2,300

//rainy - first application
replace fert_inorg_kg_r = ag_d39b * ag_d39c * ag_d39c_conversion if inorg_fert_use_r==1
// add second application
replace fert_inorg_kg_r = fert_inorg_kg_r + ag_d39h * ag_d39i * ag_d39i_conversion if ag_d39h !=. & ag_d39i !=. 

//dry - first application
replace fert_inorg_kg_d = ag_k40b * ag_k40c * ag_k40c_conversion if inorg_fert_use_d==1  
// add second application
replace fert_inorg_kg_d = fert_inorg_kg_d + ag_k40g * ag_k40h *ag_k40h_conversion if ag_k40g !=. & ag_k40h!=.  

keep hhid case_id plot_id gardenid fert_org_kg_r fert_inorg_kg_r fert_org_kg_d fert_inorg_kg_d

/*
count if fert_inorg_kg_r ==. & fert_inorg_kg_d==. //640
count if fert_inorg_kg_r !=. & fert_inorg_kg_d==. //17,123
count if fert_inorg_kg_r ==. & fert_inorg_kg_d!=. //2,290
// Note: majority only use inorganic fertilizer in rainy season? at least not missing
*/

merge m:1 hhid case_id plot_id gardenid using "${MWI_IHS_IHPS_W4_created_data}\MWI_IHS_IHPS_W4_single_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) // Only 2 not matched
// Note: used a second version of plot decision maker that keeps plotid and gardenid format for merge

collapse (sum) fert*, by(hhid dm_gender)

// combine rainy and dry
gen fert_org_kg = fert_org_kg_r + fert_org_kg_d
gen fert_inorg_kg = fert_inorg_kg_r + fert_inorg_kg_d 
drop fert_org_kg_r fert_org_kg_d
drop fert_inorg_kg_r fert_inorg_kg_d

gen dm_gender2="male" if dm_gender==1
replace dm_gender2="female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop if missing(dm_gender2)
drop dm_gender


ren fert_*_kg fert_*_kg_

reshape wide fert*_, i(hhid) j(dm_gender2) string
//merge 1:1 y5_hhid using "${Tanzania_NPS_W5_created_data}/Tanzania_NPS_W5_hhids.dta", keep (1 3) nogen
gen fert_org_kg = fert_org_kg_male+fert_org_kg_female+fert_org_kg_mixed
gen fert_inorg_kg = fert_inorg_kg_male+fert_inorg_kg_female+fert_inorg_kg_mixed
/*use "${Tanzania_NPS_W4_created_data}/Tanzania_NPS_W4_hh_cost_land.dta", clear
append using "${Tanzania_NPS_W4_created_data}/Tanzania_NPS_W4_hh_fert_lrs.dta"
append using "${Tanzania_NPS_W4_created_data}/Tanzania_NPS_W4_hh_fert_srs.dta"
collapse (sum) ha_planted* fert_org_kg* fert_inorg_kg*, by(y4_hhid)
merge m:1 y4_hhid using "${Tanzania_NPS_W4_created_data}/Tanzania_NPS_W4_hhids.dta", keep (1 3) nogen
*/
lab var fert_inorg_kg "Quantity of fertilizer applied (kgs) (household level)"
lab var fert_inorg_kg_male "Quantity of fertilizer applied (kgs) (male-managed plots)"
lab var fert_inorg_kg_female "Quantity of fertilizer applied (kgs) (female-managed plots)"
lab var fert_inorg_kg_mixed "Quantity of fertilizer applied (kgs) (mixed-managed plots)"

save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_fertilizer_application.dta", replace
*/

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE -- CWL	
******************************************************************************** 
* Malawi LSMS 4 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of household eating nutritious food can be estimated
use "${MWI_IHS_IHPS_W4_raw_data}/HH_MOD_G1.dta" , clear
* recode food items to map HDDS food categories
rename hh_g02 itemcode
recode itemcode 	(101/116 118 835 				=1	"CEREALS" )  //// 
					(201/208    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(491/413     	 				=3	"VEGETABLES"	)  ////	
					(601/610     					=4	"FRUITS"	)  ////	
					(504/512 522 824/825			=5	"MEAT"	)  ////					
					(501 823						=6	"EGGS"	)  ////
					(826 5021/5123					=7  "FISH") ///
					(401/413    					=8	"LEGUMES, NUTS AND SEEDS") ///
					(701/708						=9	"MILK AND MILK PRODUCTS")  ////
					(803   					        =10	"OILS AND FATS"	)  ////
					(801/802 815/817 827     		=11	"SWEETS"	)  //// 
					(810/814 901/915                =14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)		
gen adiet_yes=(hh_g01==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(hhid   Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each household
collapse (sum) adiet_yes, by(hhid )
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= houseold consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= houseold consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${MWI_IHS_IHPS_W4_created_data}/MWI_IHS_IHPS_W4_household_diet.dta", replace


********************************************************************************
*CROP YIELDS
********************************************************************************


********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE
********************************************************************************


