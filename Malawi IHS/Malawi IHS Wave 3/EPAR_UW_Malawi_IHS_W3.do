
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	 : Agricultural Development Indicators for the LSMS-ISA, Malawi Integrated Household Survey (IHS) and Integrated Household Panel Survey
				   (IHPS) LSMS-ISA Wave 4 (2016-17)
				  
*Author(s)       : Didier Alia & C. Leigh Anderson; uw.eparx@uw.edu

*Date            : March 31st, 2025

*Dataset Version : IHPS: MWI_2010-2013-2016_IHPS_v03_M_Stata
				   IHS: MWI_2016_IHS-IV_v04_M_STATA14

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*----------- 
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period April 2016 - April 2017.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2936

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi LSMS data set.
*Using data files from within the "raw_data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in Final DTA Files/created_data. These variables are then brought together at the household, plot, or individual level,
*saving dta files at each level in the Final DTA Files/final_data folder 

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are saved in the excel file "MWI_IHS_IHPS_W3_summary_stats.xlsx" in the "Final DTA files" folder. 
*It is possible to modify the condition  "if rural==1" in the portion of code in the _Summary_statistics/EPAR_UW_335_SUMMARY_STATISTICS following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Malawi_IHS_IHPS_W3_hhids.dta
*INDIVIDUAL IDS						Malawi_IHS_IHPS_W3_person_ids.dta
*GPS COORDINATES					Malawi_IHS_IHPS_W3_hh_coords.dta
*WEIGHTS							Malawi_IHS_IHPS_W3_weights.dta
*PLOT AREAS							Malawi_IHS_IHPS_W3_plot_areas.dta
*CROP UNIT CONVERSION FACTOR		MWI_IHS_IHPS_W3_cf.dta
*ALL PLOTS							Malawi_W3_all_plots.dta
*PLOT-CROP DECISION MAKERS			Malawi_IHS_IHPS_W3_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Malawi_IHS_IHPS_W3_TLU_Coefficients.dta

*GROSS CROP REVENUE					Malawi_IHS_IHPS_W3_tempcrop_harvest.dta
									Malawi_IHS_IHPS_W3_tempcrop_sales.dta
									Malawi_IHS_IHPS_W3_permcrop_harvest.dta
									Malawi_IHS_IHPS_W3_permcrop_sales.dta
									Malawi_IHS_IHPS_W3_hh_crop_production.dta
									Malawi_IHS_IHPS_W3_plot_cropvalue.dta
									Malawi_IHS_IHPS_W3_parcel_cropvalue.dta
									Malawi_IHS_IHPS_W3_crop_residues.dta
									Malawi_IHS_IHPS_W3_hh_crop_prices.dta
									Malawi_IHS_IHPS_W3_crop_losses.dta
*CROP EXPENSES						Malawi_IHS_IHPS_W3_wages_mainseason.dta
									Malawi_IHS_IHPS_W3_wages_shortseason.dta
									
									Malawi_IHS_IHPS_W3_fertilizer_costs.dta
									Malawi_IHS_IHPS_W3_seed_costs.dta
									Malawi_IHS_IHPS_W3_land_rental_costs.dta
									Malawi_IHS_IHPS_W3_asset_rental_costs.dta
									Malawi_IHS_IHPS_W3_transportation_cropsales.dta
									
*MONOCROPPED PLOTS					Malawi_IHS_IHPS_W3_monocrop_plots.dta
									Malawi_IHS_W3_`cn'_monocrop.dta
									Malawi_IHS_IHPS_W3_`cn'_monocrop_hh_area.dta
									Malawi_IHS_W3_inputs_`cn'.dta
																		
*LIVESTOCK INCOME					Malawi_IHS_IHPS_W3_livestock_products.dta
									Malawi_IHS_IHPS_W3_livestock_expenses.dta 
									Malawi_IHS_IHPS_W3_hh_livestock_products.dta
									Malawi_IHS_IHPS_W3_livestock_sales.dta
									Malawi_IHS_IHPS_W3_TLU.dta
									Malawi_IHS_IHPS_W3_livestock_income.dta

*FISH INCOME						Malawi_IHS_IHPS_W3_fishing_expenses_1.dta
									Malawi_IHS_IHPS_W3_fishing_expenses_2.dta
									Malawi_IHS_IHPS_W3_fish_income.dta

*OTHER INCOME						Malawi_IHS_IHPS_W3_other_income.dta
									Malawi_IHS_IHPS_W3_land_rental_income.dta									
									
*CROP INCOME						Malawi_IHS_IHPS_W3_crop_income.dta
																	
*SELF-EMPLOYMENT INCOME				Malawi_IHS_IHPS_W3_self_employment_income.dta
									Malawi_IHS_IHPS_W3_agproducts_profits.dta
									Malawi_IHS_IHPS_W3_fish_trading_revenue.dta
									Malawi_IHS_IHPS_W3_fish_trading_other_costs.dta
									Malawi_IHS_IHPS_W3_fish_trading_income.dta
									
*WAGE INCOME						Malawi_IHS_IHPS_W3_wage_income.dta
									Malawi_IHS_IHPS_W3_agwage_income.dta

*FARM SIZE / LAND SIZE				Malawi_IHS_IHPS_W3_land_size.dta
									Malawi_IHS_IHPS_W3_farmsize_all_agland.dta
									Malawi_IHS_IHPS_W3_land_size_all.dta
*FARM LABOR							Malawi_IHS_IHPS_W3_farmlabor_mainseason.dta
									Malawi_IHS_IHPS_W3_farmlabor_shortseason.dta
									Malawi_IHS_IHPS_W3_family_hired_labor.dta
*VACCINE USAGE						Malawi_IHS_IHPS_W3_vaccine.dta

*ANIMAL HEALTH

*LIVESTOCK WATER, FEEDING, AND HOUSING

*USE OF INORGANIC FERTILIZER		Malawi_IHS_IHPS_W3_fert_use.dta
*USE OF IMPROVED SEED				Malawi_IHS_IHPS_W3_improvedseed_use.dta

*REACHED BY AG EXTENSION			Malawi_IHS_IHPS_W3_any_ext.dta
*MOBILE OWNERSHIP                   Malawi_IHS_LSMS_ISA_W2_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	Malawi_IHS_IHPS_W3_fin_serv.dta

*GENDER PRODUCTIVITY GAP 			Malawi_IHS_IHPS_W3_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Malawi_IHS_IHPS_W3_milk_animals.dta
*EGG PRODUCTIVITY					Malawi_IHS_IHPS_W3_eggs_animals.dta


*CONSUMPTION						Malawi_IHS_IHPS_W3_consumption.dta
*HOUSEHOLD FOOD PROVISION			Malawi_IHS_IHPS_W3_food_insecurity.dta
*HOUSEHOLD ASSETS					Malawi_IHS_IHPS_W3_hh_assets.dta

*FARM SIZE/LAND SIZE				Malawi_IHS_IHPS_W3_land_size.dta

*** BELOW: NOT YET STARTED *****
*CROP PRODUCTION COSTS PER HECTARE	Malawi_IHS_IHPS_W3_hh_cost_land.dta
									Malawi_IHS_IHPS_W3_hh_cost_inputs_lrs.dta
									Malawi_IHS_IHPS_W3_hh_cost_inputs_srs.dta
									Malawi_IHS_IHPS_W3_hh_cost_seed_lrs.dta
									Malawi_IHS_IHPS_W3_hh_cost_seed_srs.dta		
									Malawi_IHS_IHPS_W3_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Malawi_IHS_IHPS_W3_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Malawi_IHS_IHPS_W3_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Malawi_IHS_IHPS_W3_control_income.dta
*WOMEN'S AG DECISION-MAKING			Malawi_IHS_IHPS_W3_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Malawi_IHS_IHPS_W3_ownasset.dta
*AGRICULTURAL WAGES					Malawi_IHS_IHPS_W3_ag_wage.dta
*CROP YIELDS						Malawi_IHS_IHPS_W3_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				MWI_IHS_IHPS_W3_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			MWI_IHS_IHPS_W3_individual_variables.dta	
*PLOT-LEVEL VARIABLES				MWI_IHS_IHPS_W3_gender_productivity_gap.dta
*SUMMARY STATISTICS					MWI_IHS_IHPS_W3_summary_stats.xlsx
*/


clear 
set more off

clear matrix	
clear mata	
set maxvar 8000		
ssc install findname      //need this user-written ado file for some commands to work_TH

*****************************
***** SET DIRECTOREIS *******
*****************************
global directory "../.."
global MWI_IHS_W3_raw_data 					"$directory\Malawi IHS\Malawi IHS Wave 3\Raw DTA Files\IHS" 
global MWI_IHPS_W3_raw_data 				"$directory\Malawi IHS\Malawi IHS Wave 3\Raw DTA Files\IHPS" 
global MWI_IHS_IHPS_W3_appended_data 		"$directory\Malawi IHS\Malawi IHS Wave 3\Final DTA Files\temp_data" 
global MWI_IHS_IHPS_W3_created_data 		"$directory\Malawi IHS\Malawi IHS Wave 3\Final DTA Files\created_data"
global MWI_IHS_IHPS_W3_final_data  			"$directory\Malawi IHS\Malawi IHS Wave 3\Final DTA Files\final_data" 
global summary_stats 						"$directory\_Summary_statistics\EPAR_UW_335_SUMMARY_STATISTICS.do" //Path to the summary statistics file. This can take a long time to run, so the user should comment out this line the summary statistics output is not needed; if this line is commented out, the file will end with an error.

********************************************************************************
* POPULATION FIGURES 
********************************************************************************
*MGM.4.13.2023 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global MWI_IHS_IHPS_W3_pop_tot 17881367
global MWI_IHS_IHPS_W3_pop_rur 14892509
global MWI_IHS_IHPS_W3_pop_urb 2988658

global drop_unmeas_plots 0 //If not 0, this variable will result in all plots not measured by GPS to be dropped; the implied conversion rates between nonstandard units and hectares (based on households with both measured and reported areas) appear to have changed substantially since Wave 3 and have resulted in some large yield estimates because the plots are very small. Easiest fix is to remove them.

********************************************************************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION
********************************************************************************
global MWI_W3_exchange_rate 805.9	  //https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2017&locations=MW&start=2011 {2017:730.27, 2021:805.9} 
global MWI_W3_gdp_ppp_dollar 294.86   //2021 https://data.worldbank.org/indicator/PA.NUS.PPP -2021
global MWI_W3_cons_ppp_dollar 282.09  //2021 https://data.worldbank.org/indicator/PA.NUS.PRVT.PP - using 2021 data 
global MWI_W3_infl_adj 0.684863 // SS: Updated 04/24 // CPI Survey Year 2010/CPI of Poverty Line Baseline Year 2017=340.2421245/340.2421245=1 , {2017/2021:340.2421245/496.8}
//https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
global MWI_W3_poverty_under_190 ((1.90*78.7*340.2)/107.6) //see calculation below
* WB's previous (PPP) poverty threshold is $1.90. (established in 2011)
* Multiplied by 78.7 - 2011 PPP conversion factor, private consumption (LCU per international $) - Malawi
		* https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=MW
* Multiplied by 340.2 - 2017 Consumer price index (2010 = 100)
		* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=MW&start=2017
* Divided by 107.6 - 2011 Consumer price index (2010 = 100)
		* https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2022&locations=MW&start=2011
global MWI_W3_poverty_under_npl (((164191*340.2)/340.2)/365) //see calculation and sources below
//MWI government set national poverty line to MWK 164191 in January 2017 values //https://massp.ifpri.info/files/2019/05/IFPRI_KeyFacts_Poverty_Final.pdf
//Multiplied by CPI in 2017 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
//Divided by CPI in 2017 of 340.2 //https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2017&locations=MW&start=2009
//Divide  by # of days in year (365) to get daily amount
global MWI_W3_poverty_under_215 (2.15* (1.00 * 249.1))  //WB's (PPP) poverty threshold of $2.15 multiplied by globals
global MWI_W3_poverty_under_300 (3.00 * ($MWI_W3_infl_adj * $MWI_W3_cons_ppp_dollar)) //WB's new poverty threshold of $3.00

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
*Enter the 12 priority crops here 
global topcropname_area "maize sorgum nkhwni pigpea tobcco sbean grdnt beans rice cotton swtptt pmill cassav" 
global topcrop_area "1 42 36 5 32 35 11 34 17 37 28 33 49 " // SS 5.16.24, updated 8.21.24 CG
global comma_topcrop_area "1, 42, 36, 5, 32, 35, 11, 34, 17, 37, 28, 33, 49"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"

global nb_topcrops : list sizeof global(topcropname_area)
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
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cropname_table.dta", replace 

********************************************************************************
* APPENDING Malawi IHPS data to IHS data (does not need to be re-run every time)
* To run for first time:
* Create a "Temp" folder in "Final DTA Files" folders
* comment out macro which creates "created_data" above
* create new paths below
* After running, must change created_data file path back to raw/created_data (above)
********************************************************************************

*******************************************************************************
* APPENDING Malawi IHPS data to IHS data (does not need to be re-run every time)
* After running, must change created_data file path back to raw/created_data (above)
********************************************************************************
//This section generates appended data files that contain both the IHS and IHPS datasets, which can help add richness for cross-sectional analyses.
//Some questions (such as inputs) in the survey instrument were only asked to IHPS households, resulting in lower sample sizes.
//It should be possible to run the rest of this code with only the IHPS datasets if you are only interested in the panel sample, but you will get variable not found errors if you attempt to run with just the IHS.
//This block only needs to run once, so we have a simple check for the first file in the temp data directory to avoid having it execute every time the code is run. Delete the named file to replace the directory. 

capture confirm file "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_a.dta"
if _rc {

local test_dir "$MWI_IHPS_W3_raw_data" //dir is not working with globals for some reason
* HKS 7/6/23: appending panel files (IHPS) in to IHS data; renaming HHID hhid 
//local panel_files : dir "${MWI_IHPS_W3_raw_data}/*_16.dta"
local panel_files : dir "`test_dir'" files "*_16.dta", respectcase


* Panel Ids Merger
use "${directory}\Malawi IHS\mwi_panel_ids.dta", clear //This adds a unique identifier that is cross compatible with the other survey waves for tracking panel households
preserve
keep if y3_hhid!="" & qx_type==0 
keep case_id_aux y3_hhid
tempfile cx_hh 
save `cx_hh'
restore
keep if y3_hhid != "" & y3_pid!=""
keep case_id_aux y3_hhid
append using `cx_hh'
//ren case_id_aux hhid
//destring y3_hhid, force replace
//tostring y3_hhid, replace 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhid_merger.dta", replace

di `panel_files'
*fix below bc of created data file above
*  restrict to only those which haven't been run to completion
foreach panelfile of local panel_files {
			*local filename : subinstr local panelfile "16.dta" ""
			*isplay in red "`filename'"
			if("`panelfile'"!="IHPS2016MemberDatabase_16.dta" & "`panelfile'"!="PlotGeovariablesIHPSY3_16.dta") {
	local raw_file = subinstr("`panelfile'", "_16", "", .)
			*if !fileexists("${temp_data}/`raw_file'") { // if file has not yet been saved to temp_data
			if (!strpos("`panelfile'", "meta") & !strpos("`panelfile'", "com_") ){
			use "${MWI_IHPS_W3_raw_data}/`panelfile'", clear // use IHPS
			display in red  "${MWI_IHPS_W3_raw_data}/`panelfile'"
			local append_file "${MWI_IHS_W3_raw_data}/`raw_file'" // Append IHS
			display in red "we will be appending the following raw IHS data: `append_file'"
				
			
			* Households that do not match from master are those which are in IHS but are not also in IHPS.
			* drop hhid y*
			capture confirm variable y3_hhid
			if (!_rc) {
				tostring y3_hhid, replace
			}
			
			capture confirm variable i_pid
			if (!_rc) {
				drop i_pid
			}
			
			capture confirm variable id_code
			if (!_rc) {
				ren id_code pid
			}
			
			capture confirm variable pid
			if (!_rc) {
				destring pid, replace
			}
			
			capture tostring ag_e13_2*, replace
			capture destring ag_f39*, replace
			capture destring ag_h39*, replace
			
			capture encode ag_i204_1, gen(replace_me)
			capture  drop ag_i204_1
			capture ren replace_me ag_i204_1
			capture decode ag_i204_1oth, gen(replace_me)
			capture  drop ag_i204_1oth
			capture ren replace_me ag_i204_1oth
			
			capture decode ag_i204_3_oth, gen(replace_me)
			capture  drop ag_i204_3_oth
			capture ren replace_me ag_i204_3_oth
					
			capture decode ag_i208c_oth, gen(replace_me)
			capture  drop ag_i208c_oth
			capture ren replace_me ag_i208c_oth
								
			capture decode ag_i216c_oth, gen(replace_me)
			capture  drop ag_i216c_oth
			capture ren replace_me ag_i216c_oth
						
			capture decode ag_i32b_oth, gen(replace_me)
			capture  drop ag_i32b_oth
			capture ren replace_me ag_i32b_oth
			
			capture decode ag_k01b, gen(replace_me)
			capture  drop ag_k01b
			capture ren replace_me ag_k01b
			
			capture decode ag_k25_oth, gen(replace_me)
			capture  drop ag_k25_oth
			capture ren replace_me ag_k25_oth

			capture decode ag_l06a, gen(replace_me)
			capture  drop ag_l06a
			capture ren replace_me ag_l06a
			
			capture decode ag_l14b, gen(replace_me)
			capture  drop ag_l14b
			capture ren replace_me ag_l14b
			
			capture decode ag_l39b, gen(replace_me)
			capture  drop ag_l39b
			capture ren replace_me ag_l39b
			
			capture decode ag_o104b_oth, gen(replace_me)
			capture  drop ag_o104b_oth
			capture ren replace_me ag_o104b_oth
			
			capture decode ag_o105e, gen(replace_me)
			capture  drop ag_o105e
			capture ren replace_me ag_o105e
			
			capture decode ag_o04b_oth, gen(replace_me)
			capture  drop ag_o04b_oth
			capture ren replace_me ag_o04b_oth
			
			capture decode ag_q33b_oth, gen(replace_me)
			capture  drop ag_q33b_oth
			capture ren replace_me ag_q33b_oth
						
			capture decode ag_u06b_oth, gen(replace_me)
			capture  drop ag_u06b_oth
			capture ren replace_me ag_u06b_oth
			
			capture encode fs_f03j, gen(replace_me)
			capture  drop fs_f03j
			capture ren replace_me fs_f03j
						
			capture encode fs_i04i, gen(replace_me) // string - no data
			capture  drop fs_i04i
			capture ren replace_me fs_i04i
			
			capture encode fs_i04k, gen(replace_me) // string - no data
			capture  drop fs_i04k
			capture ren replace_me fs_i04k
						
			capture tostring fs_i05a, gen(replace_me) // numeric in IHPS but string in IHS - but supposed to be numeric, except that IHS data has values like " 0" and "2 " and K12500; this gets fixed below 
			capture  drop fs_i05a
			capture ren replace_me fs_i05a
		
			capture confirm variable fs_i05a 
			capture replace fs_i05a= 12500 if fs_i05a== K12500 
			capture destring fs_i05a 
			
			capture encode fs_i06h, gen(replace_me) // string - no data
			capture  drop fs_i06h
			capture ren replace_me fs_i06h
			
			capture encode fs_i06j, gen(replace_me) // string - no data
			capture  drop fs_i06j
			capture ren replace_me fs_i06j
			
			capture encode fs_i08i, gen(replace_me) // string - no data
			capture  drop fs_i08i
			capture ren replace_me fs_i08i
			
			capture encode fs_i08k, gen(replace_me) // string - no data
			capture  drop fs_i08k
			capture ren replace_me fs_i08k
			
			capture encode fs_i11h, gen(replace_me) // numeric - no data in either IHPS or IHS
			capture  drop fs_i11h
			capture ren replace_me fs_i11h
			
			capture encode fs_i11j, gen(replace_me) // string - no data
			capture  drop fs_i11j
			capture ren replace_me fs_i11j
									
			capture encode fs_j02*, gen(replace_me)
			capture  drop fs_j02*
			capture ren replace_me fs_j02*
			
			capture encode fs_j03*, gen(replace_me)
			capture  drop fs_j03*
			capture ren replace_me fs_j03*
			
			capture encode hh_e33_code, gen(replace_me)
			capture  drop hh_e33_code
			capture ren replace_me hh_e33_code
			
			capture encode hh_e34_code, gen(replace_me)
			capture  drop hh_e34_code
			capture ren replace_me hh_e34_code
			
			capture encode hh_e40a, gen(replace_me)
			capture  drop hh_e40a
			capture ren replace_me hh_e40a
			
			capture encode hh_e41, gen(replace_me)
			capture  drop hh_e41
			capture ren replace_me hh_e41
			
			capture encode hh_e47b, gen(replace_me) //
			capture  drop hh_e47b
			capture ren replace_me hh_e47b

	
			capture drop HHID 
			gen survey = "IHPS"
			append using "`append_file'"
			replace survey="IHS" if survey==""
			capture replace y3_hhid = hhid if y3_hhid == "" // Note here that W3 grabs case_id but this is inconsistent with how it was done for w3
			merge m:1 y3_hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhid_merger.dta", nogen keep(1 3) // merge in case_id to each of these IHPS file
			capture drop hhid
			capture drop y*
			rename case_id_aux hhid

			capture drop case_id 
				display in red "we are saving to '${MWI_IHS_IHPS_W3_appended_data}/`raw_file''" 
				save "${MWI_IHS_IHPS_W3_appended_data}/`raw_file'", replace // Save in GH location


							}
}
}

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_p.dta", clear //fixing crop_codes up front
//Sequencing is important here because some plots report multiple crops
tab ag_p0_crops if missing(crop_code) // 4,096
//52 "MANGO" 
replace crop_code = 4 if regexm(ag_p0_crops, "[Mm][AaOoQq]+[NnMm][Gg]") & crop_code==.
//50 "TEA" 
replace crop_code = 2 if regexm(ag_p0_crops, "[Tt][Ee][Aa]") & crop_code==. 
//49 "CASSAVA" 
replace crop_code = 100 if regexm(ag_p0_crops, "[Cc][Aa][Ss][SsAa]")  | regexm(ag_p0_crops, "[Cc][Hh][Ii][Nn][Aa][Nn][Gg][Ww][Aa]") & crop_code==. 
// 51 "COFFEE" 
replace crop_code = 3 if regexm(ag_p0_crops, "[Cc][Oo][Ff]") & crop_code==. 
// 53 "ORANGE" 
replace crop_code = 5 if regexm(ag_p0_crops, "[Oo][Rr][Aa]") & crop_code==.
//54 "PAWPAW/PAPAYA" 
replace crop_code = 6 if regexm(ag_p0_crops, "[Pp][AaOo][PpWwYy]") & crop_code==. 
//55 "BANANA"
replace crop_code = 7 if regexm(ag_p0_crops, "[Bb][Aa][Nn]") & crop_code==.
// 56 "AVOCADO" 
replace crop_code = 8 if regexm(ag_p0_crops, "[AaVv]+[VvCcOo][OoAaCc][CcVvGgDdAa]") & crop_code==.
// 57 "GUAVA" 
replace crop_code = 9 if regexm(ag_p0_crops, "[Gg][UuAaWw][AaUu][VvAaRr]") | regexm(ag_p0_crops, "[Mm][Aa][Pp][Ee][Yy][Aa][Ll][Aa]") | regexm(ag_p0_crops, "[Pp][Ee][Yy][Aa][Ll][Aa]") & crop_code==. 
//58 "LEMON" 
replace crop_code = 10 if regexm(ag_p0_crops, "[Ll][Ee][Mm][Oo][Nn]") | regexm(ag_p0_crops, "[Mm][Aa][Nn][Dd][Ii][Mm][Uu]")
//59 "NAARTJE (TANGERINE)" 
replace crop_code = 11 if regexm(ag_p0_crops, "[Nn][Aa]+[Rr][Tt]") | regexm(ag_p0_crops, "[Tt][Aa][Nn][GgJj]") | regexm(ag_p0_crops, "[Mm][Aa][Nn][Dd][Aa]") & crop_code==.
// 60 "PEACH" 
replace crop_code = 12 if regexm(ag_p0_crops, "[Pp][Ee][Aa][Cc]") | regexm(ag_p0_crops, "[Pp][Ii][Cc][Hh]") & crop_code==.
//61 "POZA (CUSTADE APPLE)" 
replace crop_code = 13 if regexm(ag_p0_crops, "[Pp][OoAa][ZzSs][Aa]") | regexm(ag_p0_crops, "[Cc][UuAa][Ss][Tt]") & crop_code==.
//62 "MASUKU (MEXICAN APPLE)" 
replace crop_code = 14 if regexm(ag_p0_crops, "[Mm][Aa][Ss][Uu][Kk]") | regexm(ag_p0_crops, "[Mm][EeAa][Xx][IiCcAa]") & crop_code==.
//63 "MASAU" 
replace crop_code = 15 if regexm(ag_p0_crops, "[Mm][Aa][Ss][AaUu][UuAa]") & crop_code==.
//65 "MACADEMIA"
replace crop_code = 17 if regexm(ag_p0_crops, "[Mm][Aa][Cc]") & crop_code==.
//fuel wood trees 2000
replace crop_code = 2000 if regexm(ag_p0_crops, "[Ff][Uu][Ee][Ll]") | regexm(ag_p0_crops, "[Pp][Aa][Ll][Mm]") | regexm(ag_p0_crops, "[Bb][Ll][Uu]") | regexm(ag_p0_crops, "[Ee][Uu][Cc][Aa]") & crop_code==.
//fertilizer trees 1900
replace crop_code = 1900 if regexm(ag_p0_crops, "[Aa][CcLl]+[AaEe][CcIiSs][IiCc]") | regexm(ag_p0_crops, "[Cc][Hh][Aa][Mm]") | regexm(ag_p0_crops, "[Mm][Oo][Rr][Ii]") | regexm(ag_p0_crops, "[Mm][UuSs][SsEe][EKk]") | regexm(ag_p0_crops, "[MmNn][Ss][Aa][Nn][Gg][Uu]") | regexm(ag_p0_crops, "[Cc][Aa][Cc][Ii][Aa]") | regexm(ag_p0_crops, "[Jj][Aa][Kk][Aa][Rr][Aa][Nn][Dd][Aa]") & crop_code==. 

*NEW CROPS
//500 "BAOBAB TREE"
replace crop_code = 500 if regexm(ag_p0_crops, "[Mm][AaLlUu][LlAa][AaMm][MmBb][BbEe]+") | regexm(ag_p0_crops, "[Bb][AaOo][OoAa][Bb][AaOo][BbAa]") | regexm(ag_p0_crops, "[Bb][Ww][EeAa][Mm][Bb][AaWw]") & crop_code==.
//501 "COCONUT" 
replace crop_code = 501 if regexm(ag_p0_crops, "[Pp][Ee][Aa][Rr]") & crop_code==.
//502 "PEAR"
replace crop_code = 502 if regexm(ag_p0_crops, "[Pp][Ee][Aa][Rr]") & crop_code==.
//503 "COCOA"
replace crop_code = 503 if regexm(ag_p0_crops, "[Cc][Oo][Cc][Oo][Aa]") & crop_code==.

*GENERAL CROP_CODE CLEANUP
//39 "SUGARCANE" 
replace crop_code = 39 if regexm(ag_p0_crops, "[Ss][Uu][GgNn][AaGgEe][RrAa]") | regexm(ag_p0_crops, "[Jj][Ee][Kk][Ee]") | regexm(ag_p0_crops, "[Pp][Aa][Nn][Ss][Uu][Nn]") | regexm(ag_p0_crops, "[Nn][Zz][Ii][Mm][Bb][Ee]") & crop_code==.
//64 "PINEAPPLE"
replace crop_code = 64 if regexm(ag_p0_crops, "[Pp][Ii][Nn][EeAa][Aa]") & crop_code==.
//55 "BANANA"
replace crop_code = 55 if regexm(ag_p0_crops, "[Tt][Hh][Oo][Cc][Hh][Ii]") & crop_code==.
//181 unassigned
save  "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_p.dta", replace

use "${MWI_IHPS_W3_raw_data}\HouseholdGeovariablesIHPSY3.dta", clear
merge m:1 y3_hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhid_merger.dta" , nogen keep(1 3) 
ren case_id_aux hhid
drop y3_hhid
append using "${MWI_IHS_W3_raw_data}\householdgeovariablesihs4.dta"
save "${MWI_IHS_IHPS_W3_appended_data}\householdgeovariables_ihs4.dta", replace //Does not get used by code

use "${MWI_IHS_W3_raw_data}/IHS4 Consumption Aggregate.dta", clear 
ren case_id y3_hhid
save "${MWI_IHS_IHPS_W3_appended_data}/IHS4 Consumption Aggregate.dta", replace 
use "${MWI_IHS_W3_raw_data}/hh_mod_a_filt.dta", clear
gen y3_hhid = substr(hhid, 1, 2045)
merge m:1 y3_hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhid_merger.dta"
drop if hhid == "" //all unmatched obs are empty
drop y3_hhid
rename case_id y3_hhid
merge m:1 y3_hhid using "${MWI_IHS_IHPS_W3_appended_data}/IHS4 Consumption Aggregate.dta" , nogen keep(1 3) 
drop hhid
ren y3_hhid hhid
save "${MWI_IHS_IHPS_W3_appended_data}/IHS4 Consumption Aggregate.dta", replace 

use "${MWI_IHS_W3_raw_data}\hh_metadata.dta", clear 
gen y3_hhid = substr(hhid, 1, 2045)
append using "${MWI_IHPS_W3_raw_data}\hh_meta_16.dta"
drop if moduleG_start_date=="" //we need only the module G visit for this file.
duplicates tag y3_hhid, g(dupes) //Still a few duplicate observations in the panel; not sure which visit the data entry represents 
drop if dupes
merge m:1 y3_hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhid_merger.dta", nogen keep(3)
drop hhid y3_hhid dupes
ren case_id_aux hhid
save "${MWI_IHS_IHPS_W3_appended_data}\hh_metadata.dta", replace 

* For other files in the original raw folder that were not edited - copy them into new "raw" (that is, my Temp folder):
//use "${MWI_IHS_W3_raw_data}\IHS Agricultural Conversion Factor Database.dta", clear
//save "${MWI_IHS_IHPS_W3_appended_data}\Agricultural Conversion Factor Database.dta", replace

//use "${MWI_IHS_W3_raw_data}\caloric_conversionfactor.dta", clear
	//save "${MWI_IHS_IHPS_W3_appended_data}\caloric_conversionfactor.dta", replace
}

********************************************************************************
*HOUSEHOLD IDS - Complete 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_a_filt.dta", clear
ren hh_a02a ta // RH added 7/29
replace ta = ta_code if ta ==.
rename ea_id ea
gen panel = qx_type!=.
gen pweight=panelweight_2016
gen weight = hh_wgt if panel==0
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep hhid region district ta ea rural weight pweight panel
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", replace

********************************************************************************
* WEIGHTS * - Complete 
********************************************************************************
/*
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_a_filt.dta", clear
rename ta_code ta
rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep hhid region district ta ea rural weight  
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", replace
*/

********************************************************************************
*INDIVIDUAL IDS - Complete 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_b", clear
ren pid indiv			//At the individual-level, the IHPS data from 2010, 2013, and 2016 can be merged using the variable pid - will be used later in data
keep hhid indiv hh_b03 hh_b05a hh_b04
sort hhid indiv

gen female=hh_b03==2 
lab var female "1= indivdual is female"
gen age=hh_b05a
lab var age "Indivdual age"
gen hh_head=hh_b04 if hh_b04==1
replace hh_head=0 if hh_head !=1
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b05a hh_b04
duplicates drop  hhid indiv, force
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", replace

********************************************************************************
*HOUSEHOLD SIZE - Complete 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_b.dta", clear
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
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep(2 3)
*Adjust to match total population
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${MWI_IHS_IHPS_W3_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur= weight*${MWI_IHS_IHPS_W3_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb= weight*${MWI_IHS_IHPS_W3_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb weight_pop_tot


total hh_members [pweight=pweight]
matrix temp =e(b)
gen weight_pop_tot=pweight*${MWI_IHS_IHPS_W3_pop_tot}/el(temp,1,1)
total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Cross-section weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=pweight] if rural==1
matrix temp =e(b)
gen weight_pop_rur=pweight*${MWI_IHS_IHPS_W3_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=pweight] if rural==0
matrix temp =e(b)
gen weight_pop_urb=pweight*${MWI_IHS_IHPS_W3_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen pweight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=pweight_pop_rururb]  
lab var pweight_pop_rururb "Panel sample weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb weight_pop_tot
recode weight_pop_rururb pweight_pop_rururb (0=.)
total panel
local totsamp e(N)
local panelsamp el(r(table),1,1)
gen combweight = weight_pop_rururb*(`totsamp'-`panelsamp')/(`totsamp')
replace combweight = pweight_pop_rururb*(`panelsamp')/`totsamp' if combweight==.
la var combweight "Combined panel and cross-section sample weights"

//This should probably get made simpler.
ren weight weight_sample
ren pweight weight_panel
ren combweight weight
ren weight_pop_rururb xs_weight 
ren pweight_pop_rururb p_weight
la var weight_sample "Original survey weight - cross section only"

//save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhsize.dta", replace //redundant
keep hhid region district ta ea weight weight_sample weight_panel xs_weight p_weight rural hh_members adulteq fhh panel
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", replace
 
********************************************************************************
*GPS COORDINATES *
********************************************************************************
use "${MWI_IHPS_W3_raw_data}\HouseholdGeovariables_IHPS_13.dta", clear 
rename y2_hhid hhid
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep(3) 
ren LAT_DD_MOD latitude
ren LON_DD_MOD longitude
keep hhid latitude longitude
gen GPS_level = "hhid"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_coords.dta", replace

********************************************************************************
*PLOT AREAS 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_p", clear
gen season=2 //perm
rename plotid plot_id 
rename gardenid garden_id
ren ag_p02a area
ren ag_p02b unit
duplicates drop //zero duplicate entry
drop if garden_id=="" // 61 observations deleted 
drop if plot_id=="" //69 observations deleted //Note from ALT 8.14.2023: So if you check the data at this point, a large number of obs have no plot_id (and are also zeroes) there's no reason to hold on to these observations since they cannot be matched with any other module and don't appear to contain meaningful information.
keep if strpos(plot_id, "T") & plot_id!="" //SS 10.04.2023: 0 obs deleted 
replace crop_code = 13 if strpos(ag_p0_crops, "CUSTADE APPLE") | strpos(ag_p0_crops, "POZA") | strpos(ag_p0_crops, "Poza") | strpos(ag_p0_crops, "MIPOZA") | strpos(ag_p0_crops, "MPOZA") | strpos(ag_p0_crops, "Mpoza") | strpos(ag_p0_crops, "mpoza") | strpos(ag_p0_crops, "MIPOZA")  | strpos(ag_p0_crops, "mapoza")  | strpos(ag_p0_crops, "Mapoza") 
replace crop_code = 100 if strpos(ag_p0_crops, "CASASAVA") 
replace crop_code = 9 if strpos(ag_p0_crops, "guarva") | strpos(ag_p0_crops, "GWUAVA") 
replace crop_code = 4 if strpos(ag_p0_crops, "mamgo") | strpos(ag_p0_crops, "MANGo") 
replace crop_code = 14 if strpos(ag_p0_crops, "mexan apple") | strpos(ag_p0_crops, "Mexcan apple") 
replace crop_code = 14 if strpos(ag_p0_crops, "Payaya") | strpos(ag_p0_crops, "payaya") | strpos(ag_p0_crops, "POWPOW")
replace crop_code = 1900 if strpos(ag_p0_crops, "MSANGU") | strpos(ag_p0_crops, "Musekese") | strpos(ag_p0_crops, "MUSEKESE") | strpos(ag_p0_crops, "MUSEKESE TREES") | strpos(ag_p0_crops, "ACCACIA")
collapse (max) area, by(hhid garden_id plot_id crop_code season unit)
collapse (sum) area, by(hhid garden_id plot_id season unit)
replace area=. if area==0 //the collapse (sum)function turns blank observations in 0s - as the raw data for ag_mod_p have no observations equal to 0, we can do a mass replace of 0s with blank observations so that we are not reporting 0s where 0s were not reported.
drop if area==. & unit==.

gen area_acres_est = area if unit==1 											//Permanent crops in acres
replace area_acres_est = (area*2.47105) if area == 2 & area_acres_est ==.		//Permanent crops in hectares
replace area_acres_est = (area*0.000247105) if area == 3 & area_acres_est ==.	//Permanent crops in square meters
keep hhid plot_id garden_id season area_acres_est
tempfile ag_perm
save `ag_perm'

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_c", clear
gen season=0 //rainy
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_j", gen(dry)
replace season=1 if season==. //dry
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_o2" //APPENDed MODULE O_2 HERE IN ORDER TO INCORPORATE TREE/PERM CROP DATA
replace season=2 if season==. 
ren plotid plot_id
ren gardenid garden_id

* Counting acreage
gen area_acres_est = ag_c04a if ag_c04b == 1 										//Self-report in acres - rainy season 
replace area_acres_est = (ag_c04a*2.47105) if ag_c04b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_c04a*0.000247105) if ag_c04b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_j05a if ag_j05b==1 										//Replace with dry season measures if rainy season is not available
replace area_acres_est = (ag_j05a*2.47105) if ag_j05b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_j05a*0.000247105) if ag_j05b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_o04a if ag_o04b == 1 										//Self-report in acres
replace area_acres_est = (ag_o04a*2.47105) if ag_o04b == 2 & area_acres_est ==.	//self-report in hectares
replace area_acres_est = (ag_o04a*0.000247105) if ag_o04b == 3 & area_acres_est ==. //self-report in square meters 

* GPS MEASURE
gen area_acres_meas = ag_c04c														//GPS measure - rainy
replace area_acres_meas = ag_j05c if area_acres_meas==. 							//GPS measure - replace with dry if no rainy season measure
replace area_acres_meas = ag_o04c if area_acres_meas==.
recode area_acres_meas area_acres_est (0=.)
keep if area_acres_est !=. | area_acres_meas !=. //1,253 obs deleted - Keep if acreage or GPS measure info is available						//GPS measure- replace with tree/perm crop if no rainy season measure 
append using `ag_perm'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen field_size= (area_acres_est* (1/2.47105))
replace field_size = (area_acres_meas* (1/2.47105))  if field_size==. & area_acres_meas!=. 

keep hhid garden_id plot_id season area_acres_est area_acres_meas field_size 			
gen gps_meas = area_acres_meas!=. 
lab var gps_meas "Plot was measured with GPS, 1=Yes" 

lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"

drop if garden_id=="" //3 obs without gardenid 
recast str50 hhid, force 
duplicates drop hhid plot_id garden_id season, force
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", replace

********************************************************************************
*PLOT DECISION MAKERS 
********************************************************************************
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", clear
drop if hh_head==0
tempfile pids 
save `pids'

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_p.dta", clear 	//5315 unique obs
ren gardenid garden_id
ren plotid plot_id
drop if plot_id=="" | garden_id=="" // 130 obs dropped 
//keep if strpos(plot_id, "T") //R and D plots have been reported in previous modules
//Magic number of permanent-only plots is 6772
gen season=2
ren crop_code crop_code_perm
//In the absence of knowing a plot decision maker on any tree/perm plots (T1, T2,...TN) that do not show up in rainy/dry data, we are creating an assumption that the person that decides what to do with earnings for a particular crop is also the plot decision maker. We are only applying this assumption to households that grow a certain crop uniquely on one plot, but not multiple.
//TO DO: A few stray obs where the crop is in the os column and should be recoded. Mostly trees.
//Don't need to worry about multiple varieties of same crop on same plot 
recode crop_code_perm (.a=.)
replace crop_code_perm = ag_p0c if crop_code_perm == .
lab var crop_code_perm "TREE/PERMANENT CROP CODE"
drop if crop_code_perm ==. //248 deleted 
//duplicates drop hhid crop_code_perm garden_id plot_id, force //hhid appears to uniquely identify all households here 
keep hhid garden_id plot_id crop_code_perm season
duplicates tag hhid garden_id plot_id, gen(dups) //4,937
preserve
keep if dups > 0 //3196 deleted
keep hhid garden_id plot_id season
duplicates drop
tempfile dm_p_hoh
save `dm_p_hoh' //reserve the multiple instances of similar crops for use in another recipe
restore
drop if dups>0 //restricting observations to those where a unique crop is grown on only one plot
drop dups
tempfile one_plot_per_crop
gen source_file="mod_p"
save `one_plot_per_crop' //3196

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_q.dta", clear 
//drop if ag_q01==2 //drop if no crop was sold.
ren ag_q06a indiv1 
ren ag_q06b indiv2 
ren crop_code crop_code_perm
duplicates drop hhid crop_code_perm indiv1 indiv2, force
merge 1:m hhid crop_code_perm  using `one_plot_per_crop', keep(2 3)
//The 2's will eventually get the same treatment as "dm_p_hoh"
keep hhid garden_id plot_id indiv* 
reshape long indiv, i(hhid  garden_id plot_id) j(id_no)
gen season=2
recode indiv (.a=.)
tempfile dm_p
save `dm_p'

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_d.dta", clear //No point in attempting to understand ownership because it isn't included in the instrument and all plots have at least one manager listed.
merge m:1 hhid gardenid using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_b2.dta", nogen keep(1 3)
//drop if ag_d20a==. //If no crops were cultivated on plot
rename plotid plot_id
rename gardenid garden_id
drop if plot_id=="" | garden_id=="" //0 observations deleted
gen season=0
ren ag_d01 indiv1 //manager
ren ag_d01_2a indiv2 //manager
ren ag_d01_2b indiv3 //manager
gen no_manager = indiv1==. & indiv2==. & indiv3==. //8 plots with no managers
replace indiv1= ag_b204_2__0 if  no_manager==1 // owners, if no managers //does not exist in W3
replace indiv2 = ag_b204_2__1 if no_manager==1
replace indiv3 = ag_b204_2__2 if no_manager==1
recode indiv* (0=.)
keep hhid plot_id garden_id indiv* season
duplicates drop //0 duplicates
tempfile dm_r
save `dm_r'

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_k.dta", clear
merge m:1 hhid gardenid using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_i2.dta", nogen keep(1 3)
//drop if ag_k21a==. //Uncultivated
ren plotid plot_id
ren gardenid garden_id
drop if plot_id==""
gen season=1
gen indiv1=ag_k02 //manager
gen indiv2=ag_k02_2a //manager
gen indiv3=ag_k02_2b //manager
gen no_manager = indiv1==. & indiv2==. & indiv3==. //80 plots with no managers
replace indiv1= ag_i204a_1 if  no_manager==1 // owners, if no managers 
replace indiv2 = ag_i204a_2 if no_manager==1 
replace indiv3 = ag_i204a_3 if no_manager==1 
recode indiv* (0=.)
keep hhid  plot_id garden_id indiv* season 
//collapse (firstnm) indiv*, by(hhid plot_id garden_id season)
append using `dm_r'
reshape long indiv, i(hhid plot_id garden_id season) j(id_no)
append using `dm_p'

preserve
bys hhid garden_id plot_id season : egen mindiv = min(indiv)
keep if mindiv==. 
duplicates drop
append using `dm_p_hoh' //670 obs
merge m:1 hhid using `pids', nogen keep(3)
gen dm1_gender=female+1
tempfile hoh_plots
save `hoh_plots'
restore


drop if indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", keep (1 3) // only 8 observations unmatched 
gen dm1_gender=female+1 if id_no==1
append using `hoh_plots'
preserve 
keep hhid garden_id plot_id indiv season female //for individual manager input use 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_dm_ids.dta", replace
restore
collapse (mean) female (firstnm) dm1_gender, by(hhid garden_id plot_id season)

gen dm_gender =3 if female !=.
replace dm_gender = 1 if female==0
replace dm_gender = 2 if female==1
replace dm1_gender=dm_gender if dm_gender!=3 & dm1_gender==. //a few dm1_gender still missing here.
la def dm_gender 1 "Male" 2 "Female" 3 "Mixed"
la val dm_gender dm_gender 
la val dm1_gender dm1_gender
drop female
save  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", replace

********************************************************************************
* FORMALIZED LAND RIGHTS * 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear
gen season=0
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta"
replace season=1 if season==.
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen formal_land_rights=1 if inlist(ag_b204_1, 1,2,3) | ag_b204_3==2 | inlist(ag_i204_1, 1,2,3) | inlist(ag_i204_3,2) //ALT 07.22.24: Does the HH have a formal document or a tax receipt? Last category is NA for W3
//replace formal_land_rights=1 if ag_i204_1 ==2 & formal_land_rights==.
//replace formal_land_rights=0 if  ag_b204_1==1 | ag_b204_1==3 | ag_b204_1==4 & formal_land_rights==.
//replace formal_land_rights=0 if ag_i204_1==1 | ag_i204_1 ==3| ag_i204_1 ==4 & formal_land_rights==.

//Primary Land Owner
preserve
gen indiv=ag_b204_2__0
replace indiv=ag_i204a_1 if ag_i204a_1!=. & indiv==.
recast str50 hhid, force 
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 03.07.24 4,255 matched 
gen primary_land_owner = 1
ren female primary_land_owner_female
collapse (max) formal_land_rights primary_land_owner primary_land_owner_female, by(hhid indiv)
drop if indiv == .
tempfile p1
save `p1'
restore

//Secondary Land Owner
gen indiv=ag_b204_2__1
replace indiv=ag_i204a_2 if ag_i204a_2!=. & indiv==.
recast str50 hhid, force 
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 03.07.24 3,909 matched  
gen secondary_land_owner_1 = 1
ren female secondary_land_owner_female_1
drop if indiv == .

//Secondary Land Owner #2 
replace indiv=ag_b204_2__2 if indiv==.
replace indiv=ag_i204a_3 if ag_i204a_3!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 03.07.24 3,813 matched 
gen secondary_land_owner_2 = 1
ren female secondary_land_owner_female_2
drop if indiv == .

//Secondary Land Owner #3 
replace indiv=ag_b204_2__3 if indiv==.
replace indiv=ag_i204a_4 if ag_i204a_4!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 03.07.24 3,809 matched 
ren indiv secondary_land_owner_3
ren female secondary_land_owner_female_3
drop age hh_head

append using `p1'
gen formal_land_rights_f=1 if formal_land_rights==1 & (primary_land_owner_female==1 | secondary_land_owner_female_1==1 | secondary_land_owner_female_2==1 | secondary_land_owner_female_3 ==1 )
preserve
collapse (max) formal_land_rights_f, by(hhid indiv) 	
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_rights_ind.dta", replace
restore
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)
keep hhid formal_land_rights_hh
drop if formal_land_rights==. //1,143 observations deleted 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_rights_hh.dta", replace

************************
*CROP UNIT CONVERSION FACTORS - complete (TH?); not checked
************************
/*From ALT 09.15.23: we'll probably drop this once we're on a single conversion factor file.
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_cf.dta", replace
ren crop_code crop_code_long 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_cf.dta", replace*/

************************
* Caloric Conversion
************************
	use "${directory}/Malawi IHS/Nonstandard Unit Conversion Factors/caloric_conversionfactor.dta", clear
	
	/*ALT: It's important to note that the file contains some redundancies (e.g., we don't need maize flour because we know the caloric value of the grain; white and orange sweet potato are identical, etc. etc.)
	So we need a step to drop the irrelevant entries. */
	//Also there's no way tea and coffee are just tea/coffee
	//Also, data issue: no crop code is indicative of green maize (i.e., sweet corn); I'm assuming this means cultivation information is not tracked for that crop
	//Calories for wheat flour are slightly higher than for raw wheat berries.
	drop if inlist(item_code, 101, 102, 103, 105, 202, 204, 206, 207, 301, 305, 405, 813, 820, 822, 901, 902) | cal_100g == .

	
	local item_name item_name
	foreach var of varlist item_name{
		gen item_name_upper=upper(`var')
	}
	
	gen crop_code = .
	count if missing(crop_code) 
	
	// crop seed master list
	replace crop_code=1 if strpos(item_name_upper, "MAIZE") 
	replace crop_code=5 if strpos(item_name_upper, "TOBACCO")
	replace crop_code=13 if strpos(item_name_upper, "GROUNDNUT") 
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
	//replace crop_code= X if strpos(item_name_upper,"COCOYAM") No crop_code for cocoyam.
	count if missing(crop_code) //76 missing
	drop if crop_code == . 
	
	// More matches using crop_code_short
	save "${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta", replace 
	
********************************************************************************
*ALL PLOTS
********************************************************************************

    ***************************
	*Crop Values
	***************************
	//Nonstandard unit values (kg values in plot variables section)
	use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_I.dta", clear
	gen season=0 //rainy season 
	append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_o.dta" 
	recode season (.=1) //dry season 
	append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_Q.dta"
	recode season (.=2) //tree or permanent crop
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	keep if ag_i01==1 | ag_o01==1 | ag_q01==1
	ren ag_i02a sold_qty //rainy: total sold
	replace sold_qty = ag_o02a if sold_qty ==. & ag_o02a!=. //dry
	replace sold_qty = ag_q02a if sold_qty ==. & ag_q02a!=. //tree/permanent 
	ren ag_i02b unit
	replace unit = ag_o02b if unit ==. & ag_o02b! =.
	replace unit = ag_q02b if unit ==. & ag_q02b! =.
	ren ag_i03 sold_value
	replace sold_value=ag_o03 if sold_value==. & ag_o03!=.
	replace sold_value=ag_q03 if sold_value==. & ag_q03!=.
	gen condition=ag_i02c 
	replace condition=ag_o02c if condition==.
	replace condition=ag_q02c if condition==.
	rename crop_code crop_code_long 
	
	
	label define AG_M0B 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" 67 "N/A" 68 "N/A", add

	label define relabel /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
	label val crop_code_long relabel

	
	//keep hhid crop_code sold_qty unit sold_value 
	recast str50 hhid, force
	ren unit unit_code
	tostring unit_code, g(unit)
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keepusing(region district ta ea rural weight)
	//keep hhid sold_qty unit sold_value crop_code region district ta ea rural  weight
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\Malawi_IHS_cf.dta", nogen keep(1 3)
	drop unit 
	ren unit_code unit
	replace conversion=1 if conversion==. & unit==1 & inlist(condition, 1, 3)
	gen sold_qty_kg=conversion*sold_qty 
	gen price_unit = sold_value/sold_qty 
	gen price_kg = sold_value/sold_qty_kg
	lab var price_unit "Average sold value per crop unit"
	recode price* (0=.)
	gen obs=price_unit!=.
	gen obs_kg=price_kg!=.
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3)		
	
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
	
	
	****************************
	*Plot variables 
	****************************
	use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_p.dta", clear
	ren ag_p0c crop_code_long
	drop crop_code //ag_p0c is more complete 
	recode crop_code_long (100=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=1800)(19=1900)(20=2000)(21=48)
	tempfile tree_perm
	save `tree_perm'
	
	use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_g.dta", clear //rainy ** Running this again because we created a dummy dataset for plot decision maker which changes the variables if np
	gen season=0 //create variable for season 
	append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_m.dta" //dry
	rename crop_code crop_code_long
	recode season(.=1)
	append using `tree_perm' // tree/perm 
	recode season(.=2)
	drop if (ag_g0a!=1 & season==0) | (ag_m0a!=1 & season==1) | crop_code_long==. //Some plots not listed as cultivated //Dropping a few uncategorized tree crops here.
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season

	ren plotid plot_id
	ren gardenid garden_id
	ren ag_p05 number_trees_planted // number of trees planted during last 12 months
recast str50 hhid, force 
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3)
	
*Crop Code Labels
label define relabel /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
	label val crop_code_long relabel
	
	gen crop_code=crop_code_long //Generic level (without detail)
	recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	la var crop_code "Generic level crop code"
	label define relabel2 /*these exist already*/ 1 "MAIZE" 5 "TOBACCO" 11 "GROUNDNUT" 17 "RICE" 28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
	label val crop_code relabel2
	
	gen use_imprv_seed = 1 if crop_code_long == 2 | crop_code_long == 12 | crop_code_long == 18 | crop_code_long == 21 | crop_code_long == 23 | crop_code_long == 25 // MAIZE COMPOSITE/OPV | GROUNDNUT CG7 | RISE FAYA | RISE IET4094 (SENGA) | RISE KILOMBERO | RISE MTUPATUPA
recode use_imprv_seed .=0
gen use_hybrid_seed = 1 if crop_code_long == 3 | crop_code_long == 4 | crop_code_long == 15 | crop_code_long == 19 | crop_code_long == 20 // MAIZE HYBRID | MAIZE HYBRID RECYCLED | GROUNDNUT JL24 | RISE PUSSA | RISE TCG10 
recode use_hybrid_seed .=0

/*Unit Labels
label define unit_label 1 "Kilogram" 2 "50 kg Bag" 3 "90 kg Bag" 4 "Pail (small)" 5 "Pail (large)" 6 "No. 10 Plate" 7 "No. 12 Plate" 8 "Bunch" 9 "Piece" 10 "Bale" 11 "Basket" 12 "Ox-Cart" 13 "Other (specify)" 14 "Pail (medium)" 15 "Heap" 16 "Cup" 21 "Basin" 80 "Bunch (small)" 81 "Bunch (large)" 90 "Piece (small)" 91 "Piece (large)" 150 "Heap (small)" 151 "Heap (large)", modify
label val unit unit_label*/


/**consolidate crop codes (into the lowest number of the crop category)
	gen crop_code=crop_code_long //Generic level (without detail)
	recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	la var crop_code "Generic level crop code"
	la val crop_code crop_complete 
	label define crop_complete 1 "Maize" 5 "Tobacco" 13 "Groundnut" 17 "Rice", modify
	drop if crop_code==. //SS: 1150 obs deleted*/

	*Create area variables
	gen crop_area_share=ag_g03 //rainy season TH: this indicates proportion of plot with crop, but NGA area_unit indicates the unit (ie stands/ridges/heaps) that area was measured in
	label var crop_area_share "Proportion of plot planted with crop"
	replace crop_area_share =ag_m03 if crop_area_share==. & ag_m03!=. //dry szn 
	replace crop_area_share=0.125 if crop_area_share==1 //converting answers to proportions
	replace crop_area_share=0.25 if crop_area_share==2 
	replace crop_area_share=0.5 if crop_area_share==3
	replace crop_area_share=0.75 if crop_area_share==4
	replace crop_area_share=.875 if crop_area_share==5
	replace crop_area_share=1 if ag_g02==1 | ag_m02==1 //FN: ag_g02/ag_m02 = was the plot planted in the entire area of the plot 
 	//recast str50 hhid, force	
	merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", keep (1 3) nogen // 36,624 matched, 877 not matched CG 9.4.2024
	gen ha_planted=crop_area_share*area_meas_hectares
	replace ha_planted=crop_area_share*area_est_hectares if ha_planted==. & area_est_hectares!=. & area_est_hectares!=0
	replace ha_planted=ag_p02a* (1/2.47105) if ag_p02b==1 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	replace ha_planted=ag_p02a*(1/10000) if ag_p02b==3 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)

	tempfile ha_planted
	save `ha_planted'
	save 	"${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ha_planted.dta", replace

	//TH: The NGA w3 survey asks "what area of the plot is covered by trees" while the Malawi w3 survey asks "what is the area of the plantation" (for trees; area + unit), how can we consolidate these under one indicator/ should we?
	drop crop_area_share
	gen ha_harvested=ha_planted

	*** TIME VARIABLES (month planted, harvest, and length of time grown) ***
	
	* Month Planted *
	gen month_planted = ag_g05a
	replace month_planted = ag_m05a if month_planted==.
	lab var month_planted "Month of planting"
	
	* Year Planted *
	codebook ag_m05b 
	drop if ag_g05b==201 | ag_g05b==2013 | ag_g05b==2014 
	gen year_planted1 = ag_g05b
	gen year_planted2 = ag_m05b //
	gen year_planted = year_planted1
	replace year_planted= year_planted2 if year_planted==.
	lab var year_planted "Year of planting"
	
	* Month Harvested (Start) *
	gen harvest_month_begin = ag_g12a
	replace harvest_month_begin =ag_m12a if harvest_month_begin==. & ag_m12a!=.
	lab var harvest_month_begin "Month of start of harvesting"
	
	gen harvest_month_end=ag_g12b
	replace harvest_month_end=ag_m12b if harvest_month_end==. & ag_m12b!=.
	lab var harvest_month_end "Month of end of harvesting"
		
	* Months Crop Grown *
	gen months_grown = harvest_month_begin - month_planted if harvest_month_begin > month_planted  // since no year info, assuming if month harvested was greater than month planted, they were in same year 
	replace months_grown = 12 - month_planted + harvest_month_begin if harvest_month_begin < month_planted // months in the first calendar year when crop planted 
	replace months_grown = 12 - month_planted if months_grown<1 // reconcile crops for which month planted is later than month harvested in the same year
	replace months_grown=. if months_grown <1 | month_planted==. | harvest_month_begin==.
	lab var months_grown "Total months crops were grown before harvest"
	
	//Plot workdays
	preserve
	gen days_grown = months_grown*30 
	collapse (max) days_grown, by(hhid garden_id plot_id season)
	save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_season_length.dta", replace
	restore
	/*
	* Date Planted *
	gen date_planted = mdy(month_planted, 1, ag_g05b) if ag_g05b!=.
	replace date_planted = mdy(month_planted-12, 1, ag_g05b) if month_planted>12 & ag_g05b!=.
	replace date_planted = mdy(month_planted-12, 1, ag_m05b) if month_planted>12 & ag_m05b!=.
	replace date_planted = mdy(month_planted, 1, ag_m05b) if date_planted==. & ag_m05b!=.
	
	* Date Harvested *
	*TH: survey did not ask for harvest year, see/ check assumptions for year:
	gen date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if ag_g05b==2016
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if harvest_month_begin==. & ag_m05b==2016
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if month_planted<=12 &harvest_month_begin>month_planted & date_harvest==. & ag_g05b!=. //assuming if planted in 2015 and month harvested is later than planted, it was harvested in 2015
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if month_planted<=12 &harvest_month_begin>month_planted & date_harvest==. & ag_m05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_g05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_m05b!=.
	
	format date_planted %td
	format date_harvested %td
	gen days_grown=date_harvest-date_planted
	
	bys plot_id hhid : egen min_date_harvested = min(date_harvested)
	bys plot_id hhid : egen max_date_planted = max(date_planted)
	gen overlap_date = min_date_harvested - max_date_planted 
	*/
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs=1
		replace obs=0 if ag_g13a==0 | ag_m13a==0 | ag_p09a==0  
		collapse (sum) crops_plot=obs, by(hhid plot_id garden_id season crop_code)  //permanent crops are not an issue here because they're recorded under a distinct plot id. (This may be its own issue)
		//counting multiple varieties as a single crop 
		replace crops_plot=1 if crops_plot > 1 
		collapse (sum) crops_plot, by(hhid plot_id garden_id season)
		tempfile ncrops
		save `ncrops'
	restore
	
	merge m:1 hhid plot_id garden_id season using `ncrops', nogen 
	gen purestand=crops_plot==1
	
	/*	
	gen contradict_mono = 1 if (ag_g01==1 | ag_m01==1) & crops_plot >1
	gen contradict_inter = 1 if (ag_g01==2 | ag_m01==2) & crops_plot ==1 
	replace contradict_inter = . if ag_g01==1 | ag_m01==1 
*/		
	
		*Generating monocropped plot variables (Part 1)
	/*
		bys hhid plot_id garden_id season: egen crops_avg= mean(crop_code_long) //checks for diff versions of same crop in the same plot
		gen purestand=1 if crops_plot==1 | crops_avg == crop_code_long
		gen perm_crop=1 if crop_code!=. 
		bys hhid plot_id : egen permax = max(perm_crop) 
		*/
/*
		bys hhid plot_id month_planted year_planted : gen plant_date_unique=_n
		bys hhid plot_id harvest_month_begin : gen harv_date_unique=_n //MGM: survey does not ask year of harvest for crops
		bys hhid plot_id : egen plant_dates = max(plant_date_unique)
		bys hhid plot_id : egen harv_dates = max(harv_date_unique) 
*/
/*
	replace purestand=0 if (crops_plot>1 & (plant_dates>1 | harv_dates>1))  | (crops_plot>1 & permax==1)  
	gen any_mixed=!(ag_g01==1 | ag_m01==1 | (perm_crop==1 & purestand==1)) 
	bys hhid plot_id : egen any_mixed_max = max(any_mixed)
	replace purestand=1 if crops_plot>1 & plant_dates==1 & harv_dates==1 & permax==0 & any_mixed_max==0 
	
	replace purestand=1 if crop_code==crops_avg 
	replace purestand=0 if purestand==. 
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
*/	
	* Rescaling plots *
	replace ha_planted = ha_harvest if ha_planted==. 
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > area_meas_hectares & ha_harvest < ha_planted & ha_harvest!=. 
	gen percent_field=ha_planted/area_meas_hectares 
*Generating total percent of purestand and monocropped on a field
	bys hhid plot_id garden_id : egen total_percent = total(percent_field)
	
	replace percent_field = percent_field/total_percent if total_percent>1 & purestand==0
	replace percent_field = 1 if percent_field>1 & purestand==1
	
	replace ha_planted = percent_field*area_meas_hectares
	replace ha_harvest = ha_planted if ha_harvest > ha_planted
	
	
	ren ag_g13b unit // HKS 09.11.23: to preserve unit as a labeled factor, not an un-labeled numeric
	replace unit = ag_m11b if unit == .  // hks 09.11.23: previously was m13b, which is not a unit var
	replace unit = ag_p09b if unit == . // tree crops

	ren ag_g13a quantity_harvested
	replace quantity_harvested = ag_m13a if quantity_harvested==. & ag_m13a !=. 
	replace quantity_harvested = ag_p09a if quantity_harvested==. & ag_p09a !=.
	
	//THIS IS WHERE YOU WILL WANT TO DO THE SAME WITH CROP CODE (O/S) AND UNIT (O/S)
	*OTHER SPECIFIED CROP CODE
	ren primary_variety crop_code_os //this variable can provide us with a little bit more information about other specified crops in the rainy season
	//tostring ag_m0e, format(%30.0f) replace
	//replace crop_code_os=ag_m0e if crop_code_os=="" //there is no data in here that is helpful in us determining other specified crop code
	replace crop_code_os=ag_p0c_oth if crop_code_os=="" //39 real changes
	
	*OTHER SPECIFIED UNITS
	ren ag_g13b_oth unit_os
	replace unit_os=ag_m11b_oth if unit_os=="" //154 changes
	replace unit_os=ag_p09b_oth if unit_os=="" //130 changes
	
	tab crop_code_os
	tab unit_os
	
	* RECODE O/S CROPS HERE SS-some of them aren't working so troubleshoot 
	replace crop_code= 5 if strmatch(crop_code_os, "BULREY")| strmatch(crop_code_os, "TOBACCOBURLEY") 
	replace crop_code= 5 if strmatch(crop_code_os, "BURLEY MAIZE")
	replace crop_code= 49 if strmatch(crop_code_os, "CASSAVA") 
	replace crop_code= 1 if strmatch(crop_code_os, "HYBRID MAIZE") | strmatch(crop_code_os, "KANYANI") | strmatch(crop_code_os, "HYBRID MAIZE")
	replace crop_code= 1 if strmatch(crop_code_os, "KACHENJELE") | strmatch(		crop_code_os, "KAGOLO") | strmatch(crop_code_os, "KANJEREJERE") | strmatch(crop_code_os, "KANJERENJERE") |  strmatch(crop_code_os, "LOCAL MAIZE") | strmatch(crop_code_os, "MAKAOLO") | strmatch(crop_code_os, "MAKOLO") | strmatch(crop_code_os, "MAKOLO/KANJERENJERE")
	replace crop_code= 42 if strmatch(crop_code_os, "SC403")
	replace crop_code= 39 if strmatch(crop_code_os, "SUGARCANE") 
	replace crop_code= 5 if strmatch(crop_code_os, "TOBACCOFLUE(KAMPOPI)") 
	
	* RECODE O/S UNITS HERE [SEE SEEDS SECTION]

replace quantity_harvested = quantity_harvested*10 if strmatch(unit_os, "10 KG BAG") 
replace unit = 1 if strmatch(unit_os, "10 KG BAG") 
replace quantity_harvested = quantity_harvested*100 if strmatch(unit_os, "100 KG BAG")
replace unit = 1 if strmatch(unit_os, "100 KG BAG") 
replace quantity_harvested = quantity_harvested*30 if strmatch(unit_os, "30 KG BAG")
replace unit = 1 if strmatch(unit_os, "30 KG BAG") 
replace quantity_harvested = quantity_harvested*50 if strmatch(unit_os, "50 KG Bag") | strmatch(unit_os, "50 KG BAG")
replace unit = 1 if strmatch(unit_os, "50 KG Bag") |strmatch(unit_os, "50 KG BAG") 
replace quantity_harvested = quantity_harvested*70 if strmatch(unit_os, "70 KG BAG")
replace unit = 1 if strmatch(unit_os, "70 KG BAG") 
replace quantity_harvested = quantity_harvested*80 if strmatch(unit_os, "80 KG BAG")
replace unit = 1 if strmatch(unit_os, "80 KG BAG") 
replace quantity_harvested = quantity_harvested*85 if strmatch(unit_os, "85 KG BAG")
replace unit = 1 if strmatch(unit_os, "85 KG BAG") 
replace unit = 3 if  strmatch(unit_os, "90 KG Bag") | strmatch(unit_os, "90 KG BAG") | strmatch(unit_os, "90 KG")  | strmatch(unit_os, "90KGBAG")
replace unit = 21 if strmatch(unit_os, "BASIN (10L)") | strmatch(unit_os, "BASIN (LARGE)" ) | strmatch(unit_os, "BASIN (SMALL)" ) | strmatch(unit_os, "BASIN (UNSPECIFIED SIZE)")  |strmatch(unit_os, "BASIN (LARGE)") |strmatch(unit_os, "BASIN LA MULINGO") |strmatch(unit_os, "BASINS")| strmatch(unit_os, "BASINS (DISH)")| strmatch(unit_os, "Basin") |  strmatch(unit_os, "MULINGO BASIN" ) // we're placing all the basins in the same category of basins 
replace unit= 11 if strmatch(unit_os, "BASKET" ) |strmatch(unit_os, "BASKET (BIG)") | strmatch(unit_os, "BASKET (LARGE)")  |  strmatch(unit_os, "BASKET (SMALL)" ) | strmatch(unit_os, "BASKET (UNSPECIFIED SIZE)" ) | strmatch(unit_os, "BASKET (UNSPECIFIED)" )| strmatch(unit_os, "Basket") | strmatch(unit_os, "GRASSBASKET" )|strmatch(unit_os, "WEAVINGBUSKET" ) // we're placing all the baskets in the same category of baskets
replace unit=11 if strmatch(unit_os, "DENGU")  |strmatch(unit_os, "DENGU") |  strmatch(unit_os, "Dengu")
replace quantity_harvested =quantity_harvested*12 if  strmatch(unit_os, "DOZEN")
replace unit=9 if strmatch(unit_os, "DOZEN")
replace quantity_harvested = quantity_harvested/1000 if strmatch(unit_os, "GRAM")  |strmatch(unit_os, "GRAMS")
replace unit=1 if strmatch(unit_os, "GRAM")  |strmatch(unit_os, "GRAMS")
replace unit=8 if strmatch(unit_os, "BUNCH")
replace quantity_harvested=quantity_harvested*100 if strmatch(unit_os, "BUNDLE")
replace unit=15 if strmatch(unit_os, "HAIF")  |strmatch(unit_os, "HEAP") |  strmatch(unit_os, "HEAPS")
replace unit=151 if strmatch(unit_os, "Heap (LARGE)")  | strmatch(unit_os, "HEAP (Large)") 
replace unit=7 if strmatch(unit_os, "NO 12 PLATE") 
replace unit = 14 if strmatch(unit_os, "PAIL") |  strmatch(unit_os, "PAIL (20 LITRE)") |  strmatch(unit_os, "PAIL (MEDIUM)") |  strmatch(unit_os, "PAIL (UNSPECIFIED SIZE)") | strmatch(unit_os, "PAIL (20 Litre)") 
replace unit =4 if strmatch(unit_os, "PAIL (15L)") |  strmatch(unit_os, "PAIL (SMALL)") 
replace unit= 5 if strmatch(unit_os, "PAIL (LARGE)")| strmatch(unit_os, "PAIL (40 LITRE)")
replace quantity_harvested=quantity_harvested*12 if strmatch(unit_os, "DOZEN")
replace unit=9 if strmatch(unit_os, "DOZEN")
replace unit=9 if strmatch(unit_os, "PIECE") |strmatch(unit_os, "PIECES")
replace unit=6 if  strmatch(unit_os, "PLATE (SMALL)")
replace unit=1 if strmatch(unit_os, "TONE") |strmatch(unit_os, "TONNE") 
replace quantity_harvested=quantity_harvested*3 if strmatch(unit_os,"TREE") 
replace unit=1 if strmatch(unit_os,"TREE") 

	* Merging in HH module A to bring in region info 
	//ALT: Shouldn't need to do this twice. 
	//merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep(1 3) // updating code accordingly. The created data set offers regional info and renamed case_id to hhid
	
	* Renaming condition vars in master to match using file 
	gen condition=ag_g13c
	lab define condition 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A", modify
	lab val condition condition
	replace condition = ag_g13c if condition==. & ag_g13c !=. 
	replace condition = ag_m11c if condition==. & ag_m11c !=. 
	replace condition = 3 if condition==.
	replace condition = 3 if crop_code == 5
	recode condition (3=2) if inlist(crop_code, 17, 1, 11)
	gen qmult = regexs(0) if(regexm(unit_os, "[0-9]+"))
	gen qty_vol = regexm(unit_os, "[Ll][Ii][Tt][RrEe][RrEe]")
	replace unit = 26 if qty_vol | regexm(unit_os, "[Cc][Hh][IiOo][Gg]")
	destring qmult, replace
	replace quantity_harvested = qmult/5 * quantity_harvested if qmult!=. & qmult!=0 & qty_vol 
	gen qty_wt = regexm(unit_os, "[Kk][Gg]")
	replace unit = 2 if qty_wt
	replace quantity_harvested = qmult/50 * quantity_harvested if qmult!=. & qmult!=0 & qty_wt
	
***** CONVERSION FACTORS ***** 	
	ren unit unit_code 
	tostring unit_code, g(unit)
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\Malawi_IHS_cf.dta", keep(1 3) gen(cf_merge) //26,381 matched, 4,319 not matched CG 11.18.24
	replace conversion=1 if conversion==. & unit=="1" & inlist(condition, 1, 3) //changes 688 obs
	drop unit 
	ren unit_code unit
	gen quant_harv_kg= quantity_harvested*conversion 

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
replace value_harvest = price_kg*quant_harv_kg if value_harvest==. 
gen value_harvest_hh=price_unit_hh*quantity_harvested 
replace value_harvest_hh=price_kg_hh * quant_harv_kg if value_harvest_hh==.

gen val_unit = value_harvest/quantity_harvested 
gen val_kg = value_harvest/quant_harv_kg
drop weight 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3) keepusing(weight)
gen harv_wt=quantity_harvested*weight
preserve
	collapse (mean) val_unit val_kg, by (hhid crop_code crop_code_long unit)
	drop if crop_code_long ==. 
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	duplicates drop hhid, force 
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_prices_for_wages.dta", replace
restore
preserve
collapse (median) val_unit_country = val_unit (count) obs_unit_country=val_unit [aw=harv_wt], by(crop_code unit)
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore	
	
	***** Adding Caloric conversion - CWL
	// Add calories if the prerequisite caloric conversion file exists
	capture {
		confirm file `"${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta"'
	} 
	if _rc!=0 {
		display "Note: file ${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta does not exist - skipping calorie calculations"		
	}
	if _rc==0{
		merge m:1 crop_code using "${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta", nogen keep(1 3)
	
		// logic for units: calories / 100g * kg * 1000g/kg * edibe perc * 100 / perc * 1/1000 = cal
		gen calories = cal_100g * quant_harv_kg * edible_p / .1 
		count if missing(calories) 
	}	
	
	//AgQuery
	gen no_harvest = ha_harvest == .	
	collapse (sum) quant_harv_kg value_harvest* ha_planted ha_harvest number_trees_planted percent_field (max) months_grown no_harvest use_imprv_seed use_hybrid_seed, by(region district ea ta hhid plot_id garden_id season crop_code purestand area_meas_hectares) //removed condition
	recode ha_planted (0=.)
 	replace ha_harvest=. if (ha_harvest==0 & no_harvest==1) | (ha_harvest==0 & quant_harv_kg>0 & quant_harv_kg!=.)
 	replace quant_harv_kg = . if quant_harv_kg==0 & no_harvest==1
 	drop no_harvest
	
	bys hhid plot_id garden_id: egen percent_area = sum(percent_field)
	bys hhid plot_id garden_id : gen percent_inputs = percent_field/percent_area
	drop percent_area 
	capture ren ea ea_id
	merge m:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", keep(1 3) keepusing(dm*) //16 unmatched, mostly tree/perm crops
	order region district ea hhid
	drop if plot_id == "" | crop_code==. | garden_id =="" //15 obs dropped
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta",replace	
	
	collapse (sum) ha_planted, by(hhid plot_id season) //Use planted area for hh-level expenses 
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_planted_area.dta", replace
	
********************************************************************************
*TLU (Tropical Livestock Units) 11/08/23 SS Checked (Need to push it to github)
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_r1.dta", clear		
gen tlu_coefficient=0.5 if (ag_r0a==304|ag_r0a==303|ag_r0a==302|ag_r0a==301) //bull, cow, steer & heifer, calf [for Malawi]
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308) //goat, sheep
replace tlu_coefficient=0.2 if (ag_r0a==309) //pig
replace tlu_coefficient=0.01 if (ag_r0a==3310|ag_r0a==311|ag_r0a==313|ag_r0a==3314|ag_r0a==315) //lvstckid==12|lvstckid==13) //chicken (layer & broiler), duck	
replace tlu_coefficient=0.3 if (ag_r0a==3305) // donkey
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Owned
gen cattle=inrange(ag_r0a,301,304)
gen largerum=inrange(ag_r0a,301,304)
gen smallrum=inlist(ag_r0a,307,308,309)
gen poultry=inrange(ag_r0a,310,316)
gen other_ls=inlist(ag_r0a,305,306)
gen cows=inrange(ag_r0a,303,303)
gen chickens=inrange(ag_r0a,310,313) //MMH 6.8.19: included chicken layer (310), local hen (311), chicken broiler (312), local cock (313)
ren ag_r07 nb_ls_1yearago
gen nb_cattle_1yearago=nb_ls_1yearago if cattle==1 
gen nb_smallrum_1yearago=nb_ls_1yearago if smallrum==1 
gen nb_largerum_1yearago=nb_ls_1yearago if largerum==1
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
*Lots of things are valued in between here, but it isn't a complete story.
*So livestock holdings will be valued using observed sales prices.
ren ag_r0a livestock_code
recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_largerum_1yearago "Number of large ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_ls_1yearago "Number of other livestock (dog, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_largerum_today "Number of small ruminant owned as of the time of survey"
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
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_TLU_Coefficients.dta" , replace

********************************************************************************
*GROSS CROP REVENUE 
********************************************************************************
* Three things we are trying to accomplish with GROSS CROP REVENUE
* 1. Total value of all crop sales by hhid (summed up over all crops)
* 2. Total value of post harvest losses by hhid (summed up over all crops)
* 3. Amount sold (kgs) of unique crops by hhid

use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_Q.dta", clear
	ren crop_code crop_code_long
	recode crop_code_long (100=49)(2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=1800)(19=1900)(20=2000)(21=48)
	tempfile tree_perm
	save `tree_perm'

use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_I.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_O.dta"
rename crop_code crop_code_long
append using `tree_perm'

* Creating a value variable for value of crop sold
rename ag_i03 value
replace value = ag_o03 if  value==. & ag_o03!=.
replace value = ag_q03 if value==. & ag_q03!=.
recode value (.=0)

ren ag_i02a qty
replace qty = ag_o02a if qty==. & ag_o02a!=. 
replace qty=ag_q02a if qty==. & ag_o02a!=. 
gen unit=ag_i02b
replace unit= ag_o02b if unit==.
replace qty=ag_q02b if qty==. 
gen unit_os = ag_i02b_oth
replace unit_os= ag_q02b_oth if unit_os==""

replace qty =ag_i12a if qty==. & ag_i12a!=. 
replace unit=ag_i12b if unit==. & ag_i12b!=.
replace value= ag_i11 if value==. & ag_i11!=. 


*SS: I checked rainy, dry, tree/perm data for data on other specified crops and there are no fields that capture other specified crops - skipping the step of backfilling crop_code_long with data from other specified crops because of this.

* SS: This sections pulls data from other specified units and matches them with existing unit codes
replace qty=qty*10 if strmatch(unit_os, "10 KG BAG") 
replace unit=1 if strmatch(unit_os, "10 KG BAG")
replace qty=qty*100 if strmatch(unit_os, "100 KG BAG") 
replace unit=1 if strmatch(unit_os, "100 KG BAG")
replace qty=qty*1000 if strmatch(unit_os, "TONNE") 
replace unit=1 if strmatch(unit_os, "TONNE")
replace qty=qty*120 if strmatch(unit_os, "120KGBALE") 
replace unit=1 if strmatch(unit_os, "120KGBALE")
replace qty=qty*80 if strmatch(unit_os, "80 KG BALE") 
replace unit=1 if strmatch(unit_os, "80 KG BALE")
replace qty=qty*85 if strmatch(unit_os, "85 KG BALE") 
replace unit=1 if strmatch(unit_os, "85 KG BALE")
replace qty=qty*20 if strmatch(unit_os, "20 KG BAG") 
replace unit=1 if strmatch(unit_os, "20 KG BAG")
replace qty=qty*30 if strmatch(unit_os, "30 KG BAG") 
replace unit=1 if strmatch(unit_os, "30 KG BAG")
replace qty=qty*50 if strmatch(unit_os, "50KGBAG") 
replace unit=1 if strmatch(unit_os, "50KGBAG")
replace qty=qty*70 if strmatch(unit_os, "70 KG BAG") 
replace unit=1 if strmatch(unit_os, "70 KG BAG")
replace qty=qty*75 if strmatch(unit_os, "75 KG BAG") 
replace unit=1 if strmatch(unit_os, "75 KG BAG")
replace unit=3 if strmatch(unit_os, "90 KG BAG")
replace unit=21 if strmatch(unit_os, "5LITREBASIN") | strmatch(unit_os, "BASIN") | strmatch(unit_os, "BASIN(SMALL)") | strmatch(unit_os, "BASINSMALL")
replace qty=qty/1000 if strmatch(unit_os, "GRAMS")  
replace unit=1 if strmatch(unit_os, "GRAMS")  
replace qty=qty*1000 if strmatch(unit_os, "TONNE") |strmatch(unit_os, "TONS") 
replace unit=1 if strmatch(unit_os, "TONNE") |strmatch(unit_os, "TONS") 
replace unit=1 if strmatch(unit_os, "PAIL(40L)") |strmatch(unit_os, "PAIL (LARGE)") 
replace unit=11 if strmatch(unit_os, "BASKET(BAMBOO)") | strmatch(unit_os, "BASKET (LARGE)") | strmatch(unit_os, "BASKET (UNSPECIFIED SIZE)")  | strmatch(unit_os, "BASKETS") | strmatch(unit_os, "WEAVING BASKET")
replace unit=14 if strmatch(unit_os, "PAIL (MEDIUM)") 
replace unit=15 if strmatch(unit_os, "HEAP") 
replace unit=8 if strmatch(unit_os, "BUNCHES") 
replace qty=qty*12 if strmatch(unit_os, "DOZEN") 
replace unit=9 if strmatch(unit_os, "DOZEN") 

*Crop Code Labels
label define L0C /*these exist already*/ 1 "MAIZE LOCAL" 2 "MAIZE COMPOSITE/OPV" 3 "MAIZE HYBRID" 4 "MAIZE HYBRID RECYCLED" 5 "TOBACCO BURLEY" 6 "TOBACCO FLUE CURED" 7 "TOBACCO NNDF" 8 "TOBACCOSDF" 9 "TOBACCO ORIENTAL" 10 "OTHER TOBACCO (SPECIFY)" 11 "GROUNDNUT CHALIMBANA" 12 "GROUNDNUT CG7" 13 "GROUNDNUT MANIPINTA" 14 "GROUNDNUT MAWANGA" 15 "GROUNDNUT JL24" 16 "OTHER GROUNDNUT(SPECIFY)" 17 "RISE LOCAL" 18 "RISE FAYA" 19 "RISE PUSSA" 20 "RISE TCG10" 21 "RISE IET4094 (SENGA)" 22 "RISE WAMBONE" 23 "RISE KILOMBERO" 24 "RISE ITA" 25 "RISE MTUPATUPA" 26 "OTHER RICE(SPECIFY)"  28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
label val crop_code_long L0C

*Unit Labels
label define unit_label 1 "Kilogram" 2 "50 kg Bag" 3 "90 kg Bag" 4 "Pail (small)" 5 "Pail (large)" 6 "No. 10 Plate" 7 "No. 12 Plate" 8 "Bunch" 9 "Piece" 10 "Bale" 11 "Basket" 12 "Ox-Cart" 13 "Other (specify)" 14 "Pail (medium)" 15 "Heap" 16 "Cup" 21 "Basin" 80 "Bunch (small)" 81 "Bunch (large)" 90 "Piece (small)" 91 "Piece (large)" 150 "Heap (small)" 151 "Heap (large)", modify
label val unit unit_label

gen crop_code=crop_code_long //Generic level (without detail)
	recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	la var crop_code "Generic level crop code"
	label define relabel2 /*these exist already*/ 1 "MAIZE" 5 "TOBACCO" 11 "GROUNDNUT" 17 "RICE" 28 "SWEET POTATO" 29 "IRISH [MALAWI] POTATO" 30 "WHEAT" 34 "BEANS" 35 "SOYABEAN" 36 "PIGEONPEA(NANDOLO" 37 "COTTON" 38 "SUNFLOWER" 39 "SUGAR CANE" 40 "CABBAGE" 41 "TANAPOSI" 42 "NKHWANI" 43 "THERERE/OKRA" 44 "TOMATO" 45 "ONION" 46 "PEA" 47 "PAPRIKA" 48 "OTHER (SPECIFY)"/*cleaning up these existing labels*/ 27 "GROUND BEAN (NZAMA)" 31 "FINGER MILLET (MAWERE)" 32 "SORGHUM" 33 "PEARL MILLET (MCHEWERE)" /*now creating unique codes for tree crops*/ 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTADE APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" /*adding other specified crop codes*/ 105 "MAIZE GREEN" 203 "SWEET POTATO WHITE" 204 "SWEET POTATO ORANGE" 207 "PLANTAIN" 208 "COCOYAM (MASIMBI)" 301 "BEAN, WHITE" 302 "BEAN, BROWN" 308 "COWPEA (KHOBWE)" 405 "CHINESE CABBAGE" 409 "CUCUMBER" 410 "PUMPKIN" 1800 "FODDER TREES" 1900 "FERTILIZER TREES" 2000 "FUEL WOOD TREES", modify
	label val crop_code relabel2
	
	drop if crop_code==.


ren ag_i02c condition 
replace condition= ag_o02c if condition==.
replace condition=3 if condition==.
tostring hhid, format(%18.0f) replace
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keepusing(region district ta rural ea weight) keep(1 3)
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
capture tostring unit*, replace force
merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\Malawi_IHS_cf.dta", keep(1 3) gen(cf_merge) //6,697 matched,  27,391 unmatched because raw data do not report any unit or value for the remaining observations; there's not much we can do to make more matches here, 6,807 matched, 26,906 unmatched CG 11.18.24 
destring unit*, replace force

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
 
*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace conversion=conversion if region!=. //  We merge the national standard conversion factor for those hhid with missing regional info. 
gen kgs_sold = qty*conversion 
collapse (sum) value kgs_sold, by (hhid crop_code)
ren value sales_value
lab var sales_value "Value of sales of this crop"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cropsales_value.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta", clear
collapse (sum) value_harvest quant_harv_kg, by (hhid crop_code) // Update: SW We start using the standarized version of value harvested and kg harvested
merge 1:1 hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cropsales_value.dta"
//ren value sales_value
recode value_harvest sales_value (.=0)
replace value_harvest = sales_value if sales_value>value_harvest & sales_value!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren sales_value value_crop_sales 
collapse (sum) value_harvest value_crop_sales, by (hhid crop_code)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_values_production.dta", replace

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_I.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_O.dta"
drop if crop_code==. //302 observations deleted 
rename ag_i36d percent_lost
replace percent_lost = ag_o36d if percent_lost==. & ag_o36d!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
//tostring hhid, format(%18.0f) replace
recast str50 hhid
merge m:1 hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_crop_losses.dta", replace

********************************************************************************
* CROP EXPENSES * 
********************************************************************************

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
	*Hired rainy
	*Crop payments rainy
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear 
	ren plotid plot_id
	ren gardenid garden_id 
	ren ag_d46f crop_code_long 
	ren ag_d46c qty
	ren ag_d46d unit
	ren ag_d46e condition
	keep hhid plot_id garden_id crop_code qty unit condition 
	gen season=0 //"rainy"
tempfile rainy_crop_payments
save `rainy_crop_payments'
	
	*Crop payments dry
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear 
	ren plotid plot_id
	ren gardenid garden_id 
	ren ag_k46c crop_code_long
	ren ag_k46d qty
	ren ag_k46e unit
	ren ag_k46f condition
	keep hhid plot_id garden_id crop_code qty unit condition 
	gen season= 1 //"dry"
tempfile dry_crop_payments
save `dry_crop_payments'

use `rainy_crop_payments', clear
append using `dry_crop_payments'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
merge m:1 hhid  crop_code_long using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_prices_for_wages.dta", nogen keep (1 3) //SS 11.1.2023: only 46 0bs matched // CG 8.21.24: only 38 matched	// 108 matched CG 11.6.24
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep hhid val plot_id garden_id season 
	gen exp = "exp"
	merge m:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep (1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments'

	//140 missing plot_id 
	
*HIRED LABOR
	/*SS 11.1.23 This code creates three temporary files for exchange labor in the rainy season: rainy_hired_all, rainy_hired_nonharvest, and rainy_hired_harvest. Will append nonharvest and harvest to compare to all.*/
	* For MWI W3, relevant question numbers on instrument are:
		* Q46: during rainy season, how many days did you hire men(a1)/women(a2)/children(a3);
		* Q47: during rainy season, how many days did you hire men/women/children for all NON-harvest activities
		* Q48: during the rainy season, how many days did you hire men/women/children for HARVEST activities
		* WAGES:
			* 46-48, b1-3, where b1 is MEN, b2 is WOMEN, and b3 is CHILDREN
			
local qnums "46 47 48" //qnums refer to question numbers on instrument		
foreach q in `qnums' {
    use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear // 6 missing plot_id 
	merge m:1  hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep (1 3)   
	ren ag_d`q'a1 dayshiredmale // 46a1 is days hired male ALL
	ren ag_d`q'a2 dayshiredfemale // 46a2 is days hired FEMALE ALL
	ren ag_d`q'a3 dayshiredchild // 46a3 is dyas hired children all
	ren ag_d`q'b1 wagehiredmale
	ren ag_d`q'b2 wagehiredfemale
	ren ag_d`q'b3 wagehiredchild

	capture ren TA ta
	keep region district ta ea rural hhid gardenid plotid *hired*
	gen season=0 //"rainy"
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
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear 
	compress hhid
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta" , nogen keep (1 3)
	ren ag_k46a1 dayshiredmale // "any and all types of activities "
	ren ag_k46a2 dayshiredfemale
	ren ag_k46a3 dayshiredchild
	ren ag_k46b1 wagehiredmale
	ren ag_k46b2 wagehiredfemale
	ren ag_k46b3 wagehiredchild
	capture ren TA ta
	keep region district ta ea rural hhid plotid gardenid *hired* 
	gen season= 1 // "dry"
	ren plot plot_id
tempfile dry_hired_all
save `dry_hired_all' 

	use `rainy_hired_all'
	append using `dry_hired_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	
	replace plot_id = plotid if plot_id == ""
		drop plotid
	duplicates drop region district ta ea hhid plot_id garden season, force
	reshape long dayshired wagehired, i(region district ta ea hhid garden plot_id season) j(gender) string 
	
	duplicates report region  district ta ea hhid plot season
	duplicates tag region district ta ea hhid gardenid plot season, gen(dups)

	* fill in missing eas
	gsort hhid  -ea
	replace ea = ea[_n-1] if ea == ""	
	
	reshape long days wage, i(region district ta ea hhid garden plot season gender) j(labor_type) string
	recode wage days  (.=0) //no number on MWI
	drop if wage==0 & days==0 /*& number==0 & inkind==0*/ //105,990 observations deleted
	gen val = wage*days

tempfile all_hired
save `all_hired'
	

	*Exchange rainy
/*MGM 5.31.23 This code creates three temporary files for exchange labor in the rainy season: rainy_exchange_all, rainy_exchange_nonharvest, and rainy_exchange_harvest. Will append nonharvest and harvest to compare to all.*/
local qnums "50 52 54" //question numbers
foreach q in `qnums' {
    use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
	compress hhid
	merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep (1 3)
	ren ag_d`q'a daysnonhiredmale
	ren ag_d`q'b daysnonhiredfemale
	ren ag_d`q'c daysnonhiredchild
		capture	ren TA ta
	keep region district ta ea rural hhid plotid garden daysnonhired*
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
	duplicates drop  region district ta ea rural hhid garden plotid season, force //1 duplicate deleted
	reshape long daysnonhired, i(region  district ta ea rural hhid garden plotid season) j(gender) string
    tempfile rainy_exchange`suffix'
    save `rainy_exchange`suffix'', replace
}

	*Exchange dry
    use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear 
	ren gardenid garden_id //135 garden_id missing
	ren plotid plot_id //134 plot_id missing
	drop if plot_id == "" | garden_id == ""
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep (1 3)
	ren ag_k47a daysnonhiredmale
	ren ag_k47b daysnonhiredfemale
	ren ag_k47c daysnonhiredchild
	capture ren TA ta
	keep region district ta ea rural hhid garden plot_id daysnonhired*
	gen season= 1 
	reshape long daysnonhired, i(region district ta ea rural hhid garden plot_id season) j(gender) string
	tempfile dry_exchange_all 
    save `dry_exchange_all', replace
	append using `rainy_exchange_all'
			lab var season "season: 0=rainy, 1=dry, 2=tree crop"
			label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
			label values season season 
	capture replace plot_id = plotid if plot_id == ""
	capture drop plotid 
	gen days = daysn
	gen labor_type = "nonhired"
	drop daysnon
	tempfile all_exchange
	save `all_exchange', replace
	
//creates tempfile `members' to merge with household labor later
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_b.dta", clear
	rename pid indiv
isid  hhid indiv
gen male= (hh_b03==1) 
gen age=hh_b05a
lab var age "Individual age"
keep hhid age male indiv 
tempfile members
save `members', replace

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
ren gardenid garden_id 
ren plotid plot_id
ren ag_d42a* indivplanting*
ren ag_d43a* indivnonharvest*
ren ag_d44a* indivharvest*
ren ag_d42b* weeksplanting*
ren ag_d43b* weeksnonharvest*
ren ag_d44b* weeksharvest*
ren ag_d42c* daysplanting*
ren ag_d43c* daysnonharvest*
ren ag_d44c* daysharvest*
keep hhid garden_id plot_id indiv* weeks* days*
unab vars : *7
local varlist : subinstr local vars "7" "", all
di "`varlist'"
reshape long `varlist', i(hhid garden_id plot_id) j(entry_no)
reshape long indiv days weeks, i(hhid garden_id plot_id entry_no) j(labor_type) string //component of season, not used
drop if indiv==. | days==. | weeks==.
replace days=days*weeks 
collapse (sum) days, by(hhid garden_id plot_id indiv)
gen season=0
tempfile labor_dry
save `labor_dry'

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear
ren gardenid garden_id 
ren plotid plot_id
ren ag_k43a* indivplanting*
ren ag_k44a* indivnonharvest*
ren ag_k45a* indivharvest*
ren ag_k43b* weeksplanting*
ren ag_k44b* weeksnonharvest*
ren ag_k45b* weeksharvest*
ren ag_k43c* daysplanting*
ren ag_k44c* daysnonharvest*
ren ag_k45c* daysharvest*
keep hhid garden_id plot_id indiv* weeks* days*
unab vars : *7
local varlist : subinstr local vars "7" "", all
di "`varlist'"
reshape long `varlist', i(hhid garden_id plot_id) j(entry_no)
reshape long indiv days weeks, i(hhid garden_id plot_id entry_no) j(labor_type) string //component of season, not used
drop if indiv==. | days==. | weeks==.
replace days=days*weeks 
collapse (sum) days, by(hhid garden_id plot_id indiv)
gen season=1
append using `labor_dry'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season 
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_season_length.dta", nogen keep(1 3)
bys hhid garden_id plot_id indiv : egen tot_days=sum(days)
gen days_prop = days/tot_days
replace days = days_prop*days_grown if tot_days > days_grown
merge m:1 hhid indiv using `members', nogen keep (1 3)
gen gender="child" if age<15 //MGM: age <16 on reference code, age <15 on MWI W1 survey instrument
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label values season season
capture ren garden garden_id
append using `all_exchange' //this is where the missing garden/plot_ids come from 

gen val = . //MGM 7.20.23: EPAR cannot construct the value of family labor or nonhired (AKA exchange) labor MWI Waves 1, 2, 3, and 4 given issues with how the value of hired labor is constructed (e.g. we do not know how many laborers are hired and if wages are reported as aggregate or singular). Therefore, we cannot use a median value of hired labor to impute the value of family or nonhired (AKA exchange) labor.
append using `all_hired'
replace garden_id = gardenid if gardenid != "" & garden_ == ""
keep region district ta ea rural hhid garden_ plot_id season days val labor_type gender //MGM: number does not exist for MWI W1
drop if val==.&days==.

merge m:1 plot_id hhid garden_id season using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) 
preserve
	keep if labor_type == "hired"
	drop if days == 0 | val == 0
	gen hired_wage = val/days
	keep hhid garden_id plot_id gender season hired_wage
	tempfile hired_gender_season
	save `hired_gender_season'
	restore

	preserve
	keep if labor_type == "hired"
	drop if days == 0 | val == 0
	gen hired_wage = val/days
	egen med_dist_gen_wage = median(hired_wage), by(district gender season)
	collapse (mean) med_dist_gen_wage, by(district gender season)
	tempfile hired_dist_gen_season
	save `hired_dist_gen_season'
	restore

	merge m:1 hhid garden_id plot_id gender season using `hired_gender_season', nogen keep(1 3)
	replace val = hired_wage * days if labor_type == "nonhired" | labor_type == "family" // 12,483 real changes
	count if (labor_type == "nonhired" | labor_type == "family") & val == . // 163,882 missing obs for nonhired/family labor despite imputation
	merge m:1 district gender season using `hired_dist_gen_season', nogen keep(1 3)
	replace val = med_dist_gen_wage * days if val == . & (labor_type == "nonhired" | labor_type == "family") // 155,593 real changes
	count if (labor_type == "nonhired" | labor_type == "family") & val == . // 8,294 missing obs for nonhired/family labor despite imputation
	drop if days == 0

collapse (sum) val days, by(hhid plot_id garden_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Malawian Kwacha)"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_=days, by (hhid plot_id garden_id labor_type season)
	reshape wide labor_, i(hhid plot_id garden_id season) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_labor_days.dta",replace //AgQuery
restore

//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	collapse (sum) val, by (hhid plot_id garden_id season exp dm_gender)
	gen input="labor"
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_labor.dta", replace //this gets used below.
restore	


//And now we go back to wide
collapse (sum) val, by (hhid plot_id garden_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid plot_id garden_id season dm_gender) j(labor_type) string
ren val* val*_
gen season_fix="rainy" if season==0
replace season_fix="dry" if season==1
drop season
ren season_fix season
reshape wide val*, i (hhid plot_id garden_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid plot_id garden_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_cost_labor.dta", replace

**************************
*    LAND/PLOT RENT     *
************************** 
/*ALT: Section workflow: get value of in-kind rents and combine them with cash rents,
then convert annual to seasonal. 
*/

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta",clear
collapse (sum) ha_planted, by(hhid garden_id plot_id)
tempfile planted_area
save `planted_area' 


	use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_k.dta", clear
	recode ag_k01 (2 .=0)
	collapse (max) ag_k01, by(gardenid hhid)
	ren gardenid garden_id
	ren ag_k01 double_cultivated
	tempfile double_cultivated
	recast str50 hhid, force 
	save `double_cultivated' //For accounting for plot rents, we should follow just rent paid for the production season regardless if the plot was rented in for the full year to keep things consistent across households
							 //With an exception for gardens cultivated during both seasons, because the rent will amortize out (those gardens should have twice the number of plots on them)

/*use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_areas.dta", clear
collapse (sum) field_size, by(garden_id hhid)
tempfile garden_areas
save `garden_areas'*/
//ALT: To follow up - this section looks like it has some problems around crop valuation and we should probably use the generic crop code instead.
* Crops Payments
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear
	gen season=0
	append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta"
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

	keep hhid garden_id cultivate season crop_code* qty* unit* condition* payment_period
	reshape long crop_code qty unit condition, i (hhid season garden_id payment_period cultivate) j(payment_status) string
	ren crop_code crop_code_long
	drop if crop_code_long==. //59 observations deleted, cannot estimate crop values for payments we do not have crop types for
	drop if qty==. //0 observations deleted, cannot estimate crop values for payments we do not have qty for
	duplicates drop hhid, force  //6 observation deleted 
	recast str50 hhid, force 
	
	
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhsize.dta", keepusing (region district ta ea) keep(1 3) nogen // all 64 matched
	capture tostring unit*, replace force
	merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\Malawi_IHS_cf.dta", nogen keep(1 3) //61 matched, 3 unmatched CG 11.15.24
	destring unit*, replace force
	duplicates drop hhid, force 
	merge m:1 hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_prices_for_wages.dta", nogen keep (1 3) //27 matched, 37 unmatched
replace season = 1 if strpos(garden_id, "D") // 4 obs with missing season information.

gen val=qty*hh_price_mean 
drop qty unit crop_code condition hh_price_mean payment_status
keep if val!=. //22 obs deleted
collapse (sum) val, by(hhid garden_id season payment_period) 
merge 1:1 hhid garden_id using `double_cultivated', nogen keep(1 3)
replace val = val * 0.5 if payment_period==3 & double_cultivated!=1 
tempfile plotrentbycrops
save `plotrentbycrops'


	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear
	gen season=0
	append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta"
	replace season=1 if season==.

	drop if garden==""
	gen cultivate=0
	replace cultivate = 1 if ag_b214 == 1
	replace cultivate = 1 if ag_i214 == 1
	drop if cultivate==0 | ag_b212 != .  //quick test for plots rented out; 380 obs
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
	
	drop cash* inkind*
	ren ag_i208a cash_rents_total
	ren ag_i208b inkind_rents_total
    ren ag_i209a cash_rents_paid
	ren ag_i209b inkind_rents_paid
	replace payment_period = ag_i212 if payment_period==.
	replace payment_period=0 if payment_period==3 & (strmatch(ag_i212_oth, "DIMBA SEASON ONLY") | strmatch(ag_i212_oth, "DIMBA SEASOOY") | strmatch(ag_i212_oth, "ONLY DIMBA")) //0 changes
	replace cash_rents_paid=cash_rents_total if cash_rents_paid==. & cash_rents_total!=. & payment_period==0 //0 changes
	//cash_rents_owed & inkind_rents_owed not available 
	
	 replace val = cash_rents_total + inkind_rents_total if val==.
	 recast str50 hhid, force 
	merge 1:1 hhid garden_id using `double_cultivated', nogen keep(1 3)
	replace val = val * 0.5 if payment_period == 3 & double_cultivated!=1 //Scaling annual rent to apply to the season for which the rent was paid. Calculating annual rent expenditures if desired would require multipling the non-3 obs by 2
append using `plotrentbycrops'
collapse (sum) val, by(hhid garden_id season double_cultivated) //Season is not strictly necessary here but best practice is to keep it in to keep the merges generic (and because an error with a merge on season can be a useful signal later)
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season
gen input="plotrent"
gen exp="exp" //all rents are explicit
replace exp="imp" if val==0
recode val (0=.)
recast str50 hhid, force 
merge 1:m hhid garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", nogen keep(1 3)

* Calculate quantity of plot rents etc. 
gen qty = field_size
merge 1:1 hhid garden_id plot_id using `planted_area' , nogen keep(1 3)
replace qty = ha_planted if qty==. 
bys hhid garden_id : egen garden_ha = sum(qty)
gen price = val/garden_ha //Regularize to plots //Might need to winsorize given some extreme values //only affects 603 obs
replace val = price*qty
keep hhid garden_id plot_id season input exp val qty
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_rents.dta", replace
//tempfile plotrents
//save `plotrents'	



	******************************************************
	* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES *
	******************************************************
************************ ANIMAL TRACTION (ASSET RENTAL) ******************************
use "${MWI_IHS_IHPS_W3_appended_data}/HH_MOD_M.dta", clear // reported at the household level
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
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_asset_rental_costs.dta", replace

ren rental_cost_* val*
reshape long val, i(hhid) j(var) string
ren var input
gen exp = "exp"
tempfile asset_rental
save `asset_rental'
tempfile asset_rental
save `asset_rental'

	******************************************
	* FERTILIZER, PESTICIDES, AND HERBICIDES *
	******************************************
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
	gen season=0
	append using   "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta"
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta"
	ren plotid plot_id
	ren gardenid garden_id 
	//replace plot_id = ag_k0a if plot_id==""
	drop if plot_id=="" //4 dropped
	replace season=1 if season==.
	
	ren ag_d37a qtyorgfert1
	ren ag_d37b unitorgfert1
		
	replace qtyorgfert1=qtyorgfert1*50 if strpos(ag_d37b_oth, "50") //50 kg bag
	replace qtyorgfert1=qtyorgfert1*70 if strpos(ag_d37b_oth, "70") //70 kg bag
	replace qtyorgfert1=qtyorgfert1*70 if strpos(ag_d37b_oth, "90") //90 kg bag	
	replace qtyorgfert1=qtyorgfert1*120 if strpos(ag_d37b_oth, "120") //120kg bag
	replace qtyorgfert1=qtyorgfert1*100 if strpos(ag_d37b_oth, "100") //100kg bag
	replace qtyorgfert1=qtyorgfert1*2000 if strpos(ag_d37b_oth, "2") //2 tonne
	replace qtyorgfert1=qtyorgfert1*1000 if ag_d37b_oth=="TONNE"
	replace unitorgfert1=2 if strpos(ag_d37b_oth, "50") | strpos(ag_d37b_oth, "70") | strpos(ag_d37b_oth, "90") | strpos(ag_d37b_oth, "120") | strpos(ag_d37b_oth, "100") | strpos(ag_d37b_oth, "2") | ag_d37b_oth=="TONNE" //changing unit to kilograms for tons or anything with kg
	
	ren ag_k40a itemcodeinorg1
	ren ag_k40d qtyinorg1  
	gen unitinorg1=2
	ren ag_k40f itemcodeinorg2
	ren ag_k40i qtyinorg2
	gen unitinorg2=2
	//no relevant obs for o/s itemcodes or units above 
	ren ag_d39a itemcodeinorg3
	//ag_d39a_oth //are any of these relevant? 
	ren ag_d39d qtyinorg3
	gen unitinorg3 = 2
	ren ag_d39g itemcodeinorg4
	//ag_d39g_oth //are any of these relevant 
	ren ag_d39j qtyinorg4
	gen unitinorg4=2	
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
	//ag_mod d asks if they used organic fertilizer, missing data about unit/qty
	ren ag_k38a qtyorgfert2
	ren ag_k38b unitorgfert2
	replace qtyorgfert2=qtyorgfert2*50 if strpos(ag_k38b_oth, "50") //50 kg bag
	replace qtyorgfert2=qtyorgfert2*70 if strpos(ag_k38b_oth, "90") //90 kg bag	
	replace unitorgfert2=2 if strpos(ag_d37b_oth, "50") | strpos(ag_k38b_oth, "90") //changing unit to kilograms 
	
	keep hhid ea plot_id garden_id qty* unit* itemcode* season
	collapse (firstnm) item* qty* unit*, by(hhid  ea plot_id garden_id season) 
	unab vars : *1
	local stubs : subinstr local vars "1" "", all
	reshape long `stubs', i(hhid ea plot_id garden_id season) j(obs)
	reshape long qty unit itemcode, i(hhid ea plot_id garden_id season obs) j(input) string
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
	recast str50 hhid, force 
	duplicates drop hhid ea season itemcode, force 
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
	gen n_kg = 0.23*itemcode==1 + 0.18 * itemcode==2 + 0.24*itemcode==3 + 0.46*itemcode==4 + 0.10*itemcode==5 if unit==1
	gen p_kg = 0.21*itemcode==1 + 0.46 * itemcode==2 + 0.2*itemcode==5 if unit==1
	gen k_kg = 0.1*itemcode==5 if unit==1
	gen n_org_kg = 0.02*itemcode==0 
	gen nps_kg = qty*(itemcode==1)
	gen dap_kg = qty*(itemcode==2)
	gen can_kg = qty*(itemcode==3)
	gen urea_kg = qty*(itemcode==4)
	gen npk_kg = qty*(itemcode==5) 
	la var nps_kg "Total quantity of NPS fertilizer applied to plot"
	la var dap_kg "Total quantity of DAP fertilizer applied to plot"
	la var can_kg "Total quantity of CAN fertilizer applied to plot"
	la var urea_kg "Total quantity of Urea fertilizer applied to plot"
	la var npk_kg "Total quantity of NPK fertilizer applied to plot"
	la var n_kg "Kg of nitrogen applied to plot from inorganic fertilizer"
	la var p_kg "Kg of phosphorus applied to plot from inorganic fertilizer"
	la var k_kg "Kg of potassium applied to plot from inorganic fertilizer"
	la var n_org_kg "Kg of nitrogen from manure and organic fertilizer applied to plot"
	collapse (sum) *kg, by(ea season hhid)
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fertilizer_kg_application.dta", replace
	
		//Question layout here is a bit weird - ag_f/l01 represents the total amount of fertilizer applied. This may be lower than the total amount purchased - the way the questions are worded seems meant to avoid that (i.e., "how much of <this> input"), but I don't think it's reasonable to conclude that most respondents understood that. 
	
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_f.dta", clear
	gen season = 0 
	append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_l.dta"
	recast str50 hhid, force 
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhsize.dta"
	replace season = 1 if season == .
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	rename ag_f0c itemcode
	replace itemcode=ag_l0c if itemcode==.
	drop if itemcode==. 
	//replace itemcode = 7 if strmatch(ag_f0c_os, "2.4D") //no os variable in module f, mod c os does not have relevant entries
	//replace itemcode = 8 if strmatch(ag_f0c_os, "ROUND UP") //no os variable in module f, mod c os does not have relevant entries
	gen input = "inorg" if inlist(item, 1,2,3,4,5,6)
	replace input = "herb" if itemcode==8
	replace input = "pest" if inlist(itemcode, 7,9,10)
	replace input = "orgfert" if itemcode==0
	drop if itemcode==11 //& (ag_f0c_os!="2.4D" | ag_f0c_os!="ROUND UP" | ag_l0c_os!="DIMETHOATE") //no os variable

	* For all "specify unit" variable
	//rename ag_l36b_oth ag_l36b_os //all of the other specified units are b, not c - changing to b so that the loop works 
	//os variables are strings already, below not necessary 
	local qnum 07 16 26 36 38 42
	foreach q in `qnum'{
		tostring ag_f`q'b_oth, format(%19.0f) replace
		tostring ag_l`q'b_oth, format(%19.0f) replace
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
replace qtyinputimp0 = 0 if qtyinputimp0 < 0 //28 negative observations here, which is strange because we're supposed to have the total amount of input in ag_f01b
gen itemcodeinputimp0=itemcode

gen unitinputimp1 = ag_l01b
gen qtyinputimp1 = ag_l01a if ag_l03==1
replace qtyinputimp1 = ag_l01a - ag_l07a if ag_l03==2
replace qtyinputimp1 = 0 if qtyinputimp1 < 0
gen itemcodeinputimp1 = itemcode

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
gen itemcodeinputimp2 = itemcode
ren ag_f38a qtyinputimp2
replace qtyinputimp2 = ag_l38a if qtyinputimp2 == .
ren ag_f38b unitinputimp2
replace unitinputimp2 = ag_l38b if unitinputimp2 == . 
ren ag_f42a qtyinputimp3
replace qtyinputimp3 = ag_l42a if qtyinputimp3 == .
ren ag_f42b unitinputimp3
replace unitinputimp3 = ag_l42b if unitinputimp2== .

*Free Input Source Transportation Costs (Explicit)*
ren ag_f40 valtransfertexp3
replace valtransfertexp3 = ag_l40 if valtransfertexp3 == .

ren ag_f07b_oth otherunitinputexp0
replace otherunitinputexp0=ag_l07b_oth if otherunitinputexp0==""
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

	keep qty* unit* otherunit* val* hhid ea itemcode input season
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
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3)
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
/*ALT: Pesticides and herbicides do not have a bulk density because they are typically sold already in liquid form, so they'd have a mass density. It depends on the concentration of the active ingredient and the presence of any adjuvants and is typically impossible to get right unless you have the specific brand name. Accordingly, EPAR currently assumes 1L=1kg, which results in a slight underestimate of herbicides and pesticides.*/
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
	recast str50 hhid, force 
	duplicates drop hhid season itemcode, force  
	merge 1:1 hhid season itemcode using `hh_input_kg', nogen
	recode hh_qty_kg qty (.=0)
	replace qty = hh_qty_kg if qty < hh_qty_kg 
	*assert qty == hh_qty_kg
	replace qty=0 if input_hh=="transfert" 
	recode val (0=.)
	keep if qty>0 
	drop hh_qty_kg
	replace exp_ratio = 0 if exp_ratio == . // we assume that missing values correspond to items that were consumed but not purchased, an implicit category
	/* AT: Not used?
	preserve
	gen ratioimp = 1 - exp_ratio
	ren exp_ratio ratioexp
	reshape long ratio, i(hhid itemcode season) j(exp) string
	tempfile phys_inputs1
	save `phys_inputs1'
	restore
	*/
	tempfile phys_inputs
	save `phys_inputs'

	drop if input=="transfert" | val==.
	gen price_kg = val/qty  
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3)
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
	recast str50 hhid, force 
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3) keepusing(region district ta ea)
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
	recast str50 hhid, force 
	merge m:1 hhid itemcode season using `phys_inputs', keepusing(exp_ratio) keep(1 3)
	drop if hhid == "" | exp_ratio == .
	duplicates drop // 0 duplicates dropped
	collapse (sum) qty val (mean) exp_ratio obs_* price_kg_* missing_*, by(hhid  garden_id plot_id season input unit itemcode ea district ta region)
	gen ratioimp = 1-exp_ratio
	ren exp_ratio ratioexp
	duplicates tag hhid plot_id season itemcode ea, gen (dup)
	drop if dup ==1 //2 dups dropped
	reshape long ratio, i(hhid garden_id plot_id season itemcode) j(exp) string
	replace val = val * ratio
	drop ratio
	drop if plot_id == "" | val == 0 // removes null values
	tempfile phys_inputs_plot
	save `phys_inputs_plot'


*********************************
	* 			SEED			*
*********************************
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_h.dta", clear
gen season = 0 // rainy
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_n.dta"
replace season = 1 if season == . // dry
recast str50 hhid
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	
ren crop_code seedcode

drop if seedc == . // HKS 09.05.23: DROPS 302 OBS

* HKS 09.04.23: Note that MWI W1 has variables ending in "os", which indicates "other, specify", while other waves such as MWI W3 have variables ending in "_oth", containing the same information.
local qnum 07 16 26 36 38 42
foreach q in `qnum'{
	tostring ag_h`q'b_oth, format(%19.0f) replace
	tostring ag_n`q'b_oth, format(%19.0f) replace
}

** Filling empties from duplicative questions
* How much seed was purhcased w/o coupons etc.?
replace ag_h16a=ag_h07a if (ag_h07a!=. & ag_h16a==. & ag_h26a==. & ag_h36a==.) // HKS 09.05.23: 6,954 changes
replace ag_h16b=ag_h07b if (ag_h07b!=. & ag_h16b==. & ag_h26b==. & ag_h36b==.) //  HKS 09.05.23: 6,899 changes
replace ag_h16b_oth=ag_h07b_oth if (ag_h07b_oth!="" & ag_h16b_oth=="" & ag_h26b_oth=="" & ag_h36b_oth=="") //  HKS 09.05.23: 369 changes

*How much did you pay for transpo to acquire seed?
replace ag_h18=ag_h09 if (ag_h09!=. & ag_h18==. & ag_h28==.) // HKS 09.05.23: 6,952 changes

* Value of seed purchased? 
replace ag_h19=ag_h10 if (ag_h10!=. & ag_h19==. & ag_h29==.) // HKS 09.05.23: 6,954 changes

* Repeat for Module N
replace ag_n16a=ag_n07a if (ag_n07a!=. & ag_n16a==. & ag_n26a==. & ag_n36a==.) // HKS 09.05.23: 724 changes
replace ag_n16b=ag_n07b if (ag_n07b!=. & ag_n16b==. & ag_n26b==. & ag_n36b==.) // HKS 09.05.23: 722 changes
replace ag_n16b_oth=ag_n07b_oth if (ag_n07b_oth!="" & ag_n16b_oth=="" & ag_n26b_oth=="" & ag_n36b_oth=="") // HKS 09.05.23: 0 changes
replace ag_n18=ag_n09 if (ag_n09!=. & ag_n18==. & ag_n28==.) // HKS 09.05.23: 724 changes
replace ag_n19=ag_n10 if (ag_n10!=. & ag_n19==. & ag_n29==.) // HKS 09.05.23: 723 changes
*****

* EXPLICIT Costs: Seeds bought & Transpo costs:
	* First source
	ren ag_h16a qtyseedsexp1 // qty seeds purchased w/o coupons
	replace qtyseedsexp1 = ag_n16a if qtyseedsexp1 ==.
	ren ag_h16b unitseedsexp1
	replace unitseedsexp1 = ag_n16b if unitseedsexp1 ==. //adding dry season
	ren ag_h18 valseedtransexp1 // all transportation costs are explicit
	replace valseedtransexp1 = ag_n18 if valseedtransexp1 == .
	ren ag_h19 valseedsexp1 // value of seed purchased
	replace valseedsexp1 = ag_n19 if valseedsexp1 == .
	gen itemcodeseedsexp1 = seedcode if qtyseedsexp1!=. 

	* Second source
	ren ag_h26a qtyseedsexp2 // qty purchased w/o coupons
	replace qtyseedsexp2 = ag_n26a if qtyseedsexp2 ==.
	ren ag_h26b unitseedsexp2
	replace unitseedsexp2 = ag_n26b if unitseedsexp2 ==.
	ren ag_h28 valseedtransexp2 //all transportation is explicit
	replace valseedtransexp2 = ag_n28 if valseedtransexp2 == .
	ren  ag_h29 valseedsexp2 // value of seed purchased
	replace valseedsexp2 = ag_n29 if valseedsexp2 == .
	gen itemcodeseedsexp2 = seedcode if qtyseedsexp2!=. 

	* Third Source // Transportation Costs and Value of Seeds not asked about for third source on W3 instrument, hence the need to impute these costs later provided we have itemcode code and qtym
	ren ag_h36a qtyseedsexp3  // Third Source - qty purchased
	replace qtyseedsexp3 = ag_n36a if qtyseedsexp3 == .
	ren ag_h36b unitseedsexp3
	replace unitseedsexp3 = ag_n36b if unitseedsexp3 == . // adding Dry Season
	gen itemcodeseedsexp3 = seedcode if qtyseedsexp3!=. // hks 09.04.23: this line doesn't exist in MWI W1

* IMPLICIT COSTS: Free and Left Over Value:
ren ag_h42a qtyseedsimp1 // Left over seeds
replace qtyseedsimp1 = ag_n42a if qtyseedsimp1 == . 
ren ag_h42b unitseedsimp1
gen itemcodeseedsimp1 = seedcode if qtyseedsimp1!=. //Adding this to reduce the number of empties after the reshape. 
replace unitseedsimp1 = ag_n42b if unitseedsimp1== . // adding Dry Season

ren ag_h38a qtyseedsimp2  // Free seeds
replace qtyseedsimp2 = ag_n38a if qtyseedsimp2 == .
ren ag_h38b unitseedsimp2
replace unitseedsimp2 = ag_n38b if unitseedsimp2 == . // adding Dry Season
gen itemcodeseedsimp2 = seedcode if qtyseedsimp2!=.

* Free Source Transportation Costs (Explicit):
ren ag_h40 valseedtransexp3 //all transportation is explicit
replace valseedtransexp3 = ag_n40 if valseedtransexp3 == .


* Checking gaps in "other" unit variables
tab ag_h16b_oth //backfill needed W3
tab ag_n16b_oth //backfill needed W3
tab ag_h26b_oth // no obs and no need to backfilL W3
tab ag_n26b_oth //no obs and no need to backfil W3
tab ag_h36b_oth //no obs and no need to backfill W3
tab ag_n36b_oth //no obs and no need to backfill W3
tab ag_h38b_oth //backfill needed W3
tab ag_n38b_oth //backfill needed W3
tab ag_h42b_oth //backfill needed W3
tab ag_n42b_oth //backfill needed W3

**** BACKFILL CODE, EDITED TO MEET THE NEEDS OF W3
ren ag_h16b_o otherunitseedsexp1
replace otherunitseedsexp1=ag_n16b_o if otherunitseedsexp1==""
ren ag_h26b_o otherunitseedsexp2
replace otherunitseedsexp2=ag_n26b_o if otherunitseedsexp2==""
ren ag_h36b_o otherunitseedsexp3
replace otherunitseedsexp3=ag_n36b_o if otherunitseedsexp3==""
ren ag_h38b_o otherunitseedsimp1
replace otherunitseedsimp1=ag_n38b_o if otherunitseedsimp1==""
ren ag_h42b_o otherunitseedsimp2
replace otherunitseedsimp2=ag_n42b_o if otherunitseedsimp2==""

local suffix exp1 exp2 exp3 imp1 imp2
foreach s in `suffix' {
//CONVERT SPECIFIED UNITS TO KGS
replace qtyseeds`s'=qtyseeds`s'/1000 if unitseeds`s'==1
replace qtyseeds`s'=qtyseeds`s'*2 if unitseeds`s'==3
replace qtyseeds`s'=qtyseeds`s'*3 if unitseeds`s'==4
replace qtyseeds`s'=qtyseeds`s'*3.7 if unitseeds`s'==5
replace qtyseeds`s'=qtyseeds`s'*5 if unitseeds`s'==6
replace qtyseeds`s'=qtyseeds`s'*10 if unitseeds`s'==7
replace qtyseeds`s'=qtyseeds`s'*50 if unitseeds`s'==8
recode unitseeds`s' (1/8 = 1) //see below for redefining variable labels
label define unitrecode`s' 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify  
label values unitseeds`s' unitrecode`s'

//REPLACE UNITS WITH O/S WHERE POSSIBLE
//Malawi instruments do not have unit codes for units like "packet" or "stem" or "bundle". Converting unit codes to align with the Malawi conversion factor file (merged in later). Also, borrowing Nigeria's unit codes for units (e.g. packets) that do not have unit codes in the Malawi instrument or conversion factor file.

* KGs 
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "MG") 
replace qtyseeds`s'=qtyseeds`s'/1000000 if strmatch(otherunitseeds`s', "MG") 
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "20 KG BAG")
replace qtyseeds`s'=qtyseeds`s'*20 if strmatch(otherunitseeds`s', "20 KG BAG")
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "2.5 KG")
replace qtyseeds`s'=qtyseeds`s'*2.5 if strmatch(otherunitseeds`s', "2.5 KG")
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "5.5KG")
replace qtyseeds`s'=qtyseeds`s'*5.5 if strmatch(otherunitseeds`s', "5.5KG")

replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "25 KG BAG")
replace qtyseeds`s'=qtyseeds`s'*25 if strmatch(otherunitseeds`s', "25 KG BAG")
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "50")  // edited
replace qtyseeds`s'=qtyseeds`s'*50 if strpos(otherunitseeds`s', "50 KG") | strpos(otherunitseeds`s', "50KG") //edited
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "70")
replace qtyseeds`s'=qtyseeds`s'*50 if strpos(otherunitseeds`s', "70 KG") | strpos(otherunitseeds`s', "70KG") //added
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "90 KG") | strpos(otherunitseeds`s', "90KG") //edited
replace qtyseeds`s'=qtyseeds`s'*90 if strpos(otherunitseeds`s', "90 KG") | strpos(otherunitseeds`s', "90KG") //edited
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "100KG") | strpos(otherunitseeds`s', "100 KG")  //edited
replace qtyseeds`s'=qtyseeds`s'*100 if strpos(otherunitseeds`s', "100KG") | strpos(otherunitseeds`s', "100 KG")  //edited
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "100G") | strpos(otherunitseeds`s', "8 GRAM") // edited: grams
replace qtyseeds`s'=(qtyseeds`s'/1000)*100 if strpos(otherunitseeds`s', "100KG") //edited
replace qtyseeds`s'=(qtyseeds`s'/1000)*8 if strpos(otherunitseeds`s', "8 GRAM") //edited
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "GRAMS") // edited: grams
replace qtyseeds`s'=(qtyseeds`s'/1000) if strmatch(otherunitseeds`s', "GRAMS") //edited

* Pails
replace unitseeds`s'=4 if strpos(otherunitseeds`s', "PAIL") // Edited: contains pail (any size)
replace unitseeds`s'=5 if strpos(otherunitseeds`s', "PAIL") & (strpos(otherunitseeds`s', "BIG") | strpos(otherunitseeds`s', "LARGE")) // Edited: big/large pails
replace qtyseeds`s'=qtyseeds`s'*2 if strmatch(otherunitseeds`s', "2X LARGE PAIL")

* Plates
replace unitseeds`s'=6 if strpos(otherunitseeds`s', "PLATE")  | strpos(otherunitseeds`s', "10 PLATE") | strpos(otherunitseeds`s', "10PLATE")
replace qtyseeds`s'=qtyseeds`s'*2 if strmatch(otherunitseeds`s', "2 NO 10 PLATES")
replace unitseeds`s'=7 if strpos(otherunitseeds`s', "12 PLATE")  | strpos(otherunitseeds`s', "12PLATE") // edited: 12 plate

* Pieces & Bundles 
replace unitseeds`s'=9 if strpos(otherunitseeds`s', "PIECE") | strpos(otherunitseeds`s', "PIECES") | strpos(otherunitseeds`s', "STEMS") | strmatch(otherunitseeds`s', "CUTTINGS") | strmatch(otherunitseeds`s', "BUNDLES") | strmatch(otherunitseeds`s', "MTOLO UMODZI WA BATATA") //"motolo umodzi" translates to bundles and a standard bundle is 100 stems
replace qtyseeds`s'=qtyseeds`s'*100 if strmatch(otherunitseeds`s', "BUNDLES") | strmatch(otherunitseeds`s', "MTOLO UMODZI WA BATATA")

* Dengu
replace unitseeds`s'=11 if strmatch(otherunitseeds`s', "DENGU") 

* Packet
replace unitseeds`s'=120 if strpos(otherunitseeds`s', "PACKET") //edited
replace qtyseeds`s'=qtyseeds`s'*2 if strmatch(otherunitseeds`s', "2 PACKETS")

* HKS 09.04.23: For now, ignoring units of teaspoon and tablespoon because bulk densisites can vary seed to seed and there isn't a clear conversion factor (not in database)

* HKS 09.05.23: ADDITIONAL UNITS OF INTEREST THAT ARE NOT LISTED IN THE "FINAL AMENDED IHS AGRICULTURAL CONVERSION FACTOR DATABASE" (yet)
* NO 24 Plate
* chikang'a
}


keep item* qty* unit* val* hhid  season seed
gen dummya = _n //creates a unique number for every observation as hhid is not unique among all observations 
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i (hhid/*season*/ dummya) j(entry_no) // HKS 09.04.23: MWI W1 does not include season; do we expect seed values to not vary season to season? Probably not, and many seeds can only be planted in one season
drop entry_no
replace dummya = _n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if qtyseedsexp==. & valseedsexp==. //we're dropping if both values are missing 
reshape long `stubs2', i(hhid /*season*/ dummya) j(exp) string
replace dummya=_n
reshape long qty unit val itemcode, i(hhid /*season*/ exp dummya) j(input) string
drop if strmatch(exp,"imp") & strmatch(input,"seedtrans") //No implicit transportation costs; all transporatation cost are explicit 
//ALT: Crop recode not necessary for seed expenses.

/*gen crop_code_full = itemcode 
recode crop_code_full (1/4 = 1) (5/7 10 = 2) (11/16 = 3) (17/23 25/26 = 4) (27 = 5) (28 = 6) (29 = 7) (31 = 8) (32 = 9) (33 = 10) (34 = 11) (35 = 12) (36 = 13) (37 = 14) (38 = 15) (39 = 16) (40 = 17) (41 = 18) (42 = 19) (43 = 20) (44 = 21) (45 = 22) (46 = 23) (47 = 24) (48 = 25) */

label define unitrecode 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify
label values unit unitrecode

drop if (qty==. | qty==0) & strmatch(input, "seeds") // HKS 09.05.23: 9,364 obs deleted - cannot impute val without qty for seeds; for the variable input; where any observations have equal seeds 
drop if unit==. & strmatch(input, "seeds") // 2 obs deleted - cannot impute val without unit for seeds
gen byte qty_missing = missing(qty) //only relevant to seedtrans
gen byte val_missing = missing(val)
collapse (sum) val qty, by(hhid unit seedcode exp input qty_missing val_missing season)
replace qty =. if qty_missing
replace val =. if val_missing
drop qty_missing val_missing

ren seedcode crop_code
drop if crop_code==. & strmatch(input, "seeds") // 0 obs deleted
gen condition=1 
replace condition=3 if inlist(crop_code, 5, 6, 7, 8, 10, 28, 29, 30, 31, 32, 33, 37, 39, 40, 41, 42, 43, 44, 45, 47) // X real changes //these are crops for which the cf file only has entries with condition as N/A
//recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
rename crop_code crop_code_long
recast str50 hhid, force 
*ren TA ta
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhsize.dta", keepusing (region district ta ea) nogen keep(1 3) 
capture tostring unit*, replace force
merge m:1 region crop_code_long unit condition using "${directory}\Malawi IHS\Nonstandard Unit Conversion Factors\Malawi_IHS_cf.dta", nogen keep(1 3)
destring unit*, replace force
replace qty=. if input=="seedtrans" 
keep if qty>0 

//This chunk ensures that conversion factors did not get used for planted-as-seed crops where the conversion factor weights only work for planted-as-harvested crops
replace conversion =. if inlist(crop_code, 5-8, 10, 28-29, 37, 39-45, 47) // HKS 09.05.23: 196 real changes 

replace unit=1 if unit==. //Weight, meaningless for transportation 
replace conversion = 1 if unit==1 //conversion factor converts everything in kgs so if kg is the unit, cf is 1
replace conversion = 1 if unit==9 //if unit is piece, we use conversion factor of 1 but maintain unit name as "piece"/unitcode #9
replace qty=qty*conversion if conversion!=.
/*By converting smaller units (e.g. grams, packets, bunches, etc.) into kgs and then imputing values (see end of crop expenses) for these observations where val is missing, we are underestimating the true value of smaller quantities of seeds. For example, seeds are more 
ren crop_code_short itemcode*/
rename crop_code itemcode
tempfile seeds
save `seeds'
******** Tree/ Permanent Crop Transportation***********

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_q.dta", clear 
egen valtreetrans = rowtotal(ag_q18 ag_q27)
collapse (sum) val, by(hhid)
reshape long val, i(hhid) j(input) string
gen exp = "exp" //Transportation is explicit
tempfile tree_transportation
save `tree_transportation' 


******** Temporary Crop Transportation*********** -Come back to this 
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i.dta", clear

append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_o.dta"

egen valtempcroptrans = rowtotal(ag_i10  ag_o10 )
collapse (sum) val, by(hhid)
reshape long val, i(hhid) j(input) string
gen exp = "exp" //Transportation is explicit
tempfile tempcrop_transportation
save `tempcrop_transportation' 


********************************
*** HKS 08.23.23, copied from MWI W3 (originally NGA W3) for use in MONOCROPPED PLOTS below
*** Combining rents and getting prices
*****
*** Plot Level files: plot_rents ONLY as of 08.25.23

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_rents.dta", clear
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_cost_per_plot.dta", replace
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_weights.dta",gen(weights) keep(1 3) keepusing(weight region district ea ta) // added geo vars here to avoid having to merge in later using a diff file
* 08.24.23
merge m:1 hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_areas.dta", gen(plotareas) keep(1 3) keepusing(field_size) //124 obs with missing plot_id 
drop if plot_id == ""
merge m:1 hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_decision_makers.dta", gen(dms) keep(1 3) keepusing(dm_gender) 
//merge m:m hhid ea using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta"

gen plotweight = weight*field_size 
tempfile all_plot_inputs
save `all_plot_inputs', replace

* Calculating Geographic Medians for PLOT LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	gen price = val/qty
	drop if price==. 
	gen obs=1

	* HKS 08.25.23: I dropped "unit" and "itemcode" from all of these loops bc we don't have them anymore (since phys inputs is not at plot level)
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
	foreach i in ea ta district region hhid{
		merge m:1 `i' input using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country region district ta ea  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 
recode val qty (.=0)
drop if val==0 & qty==0 
replace val=qty*price if val==0


* For PLOT LEVEL data, add in plot_labor data
append using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_labor.dta" // hks 08.25.23: many empty garden, plot, dm_genders (where val == 0)
drop if plot_id == "" //1,768 obs dropped
//drop if garden_id == "" & plot_id == "" // HKS: as per discussion with ALT on 08.31.23; 2 obs dropped //0 dropped 11.4.24
collapse (sum) val, by (hhid plot_id garden_id exp input dm_gender season) 
append using `phys_inputs_plot' //ALT: This should get cleaned up.

* Save PLOT-LEVEL Crop Expenses (long)
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_cost_inputs_long.dta",replace 

* Save PLOT-Level Crop Expenses (wide, does not currently get used in MWI W3 code)
preserve
	collapse (sum) val_=val, by(hhid plot_id garden_id exp dm_gender season)
	reshape wide val_, i(hhid plot_id garden_id dm_gender season) j(exp) string 
	duplicates drop hhid, force 
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_cost_inputs.dta", replace // HKS 08.21.23 (mwi W3): This used to get used below in CROP EXPENSES - currently commented out, we'll see if it gets revived
restore


********
*** HH LEVEL Files: seed, asset_rental, phys inputs
use `seeds', clear
	append using `asset_rental'
	append using `phys_inputs' // 08.31.23: ALT says we can drop from price imputation
	append using `tree_transportation'
	append using `tempcrop_transportation'
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3) keepusing(weight region district ea ta) // merge in hh weight & geo data 
tempfile all_HH_LEVEL_inputs
save `all_HH_LEVEL_inputs', replace
	

* Calculating Geographic Medians for HH LEVEL files
	keep if strmatch(exp,"exp") // & qty!=. 
	recode val (0=.)
	drop if unit==0 //Remove things with unknown units.
	gen price = val/qty
	drop if price==.
	gen obs=1

	* HKS 08.28.23: Plotweight has been changed to aw = qty*weight (where weight is population weight), as per discussion with ALT
	capture restore,not 
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
	foreach i in country region district ta ea  {
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

*  HKS 09.14.23: Amend input names to match those of NGA data (GH ISSUE #45)
replace input = "anml" if strpos(input, "animal_tract") 
replace input = "inorg" if strpos(input, "inorg")
replace input = "seed" if strpos(input, "seed")
replace input = "mech" if strpos(input, "ag_asset") | strpos(input, "tractor") | strpos(input, "asset_rent") // double check that ag_asset is basically just mechanized tools


preserve
	keep if strpos(input,"orgfert") | strpos(input,"inorg") | strpos(input,"herb") | strpos(input,"pest") 
	//Unfortunately we have to compress liters and kg here, which isn't ideal.
	collapse (sum) qty_=qty, by(hhid ta ea district region input season) // hks 09.14.23: season added as per MGM/ALT
	reshape wide qty_, i(hhid ta ea district region season) j(input) string // hks 09.14.23: season added as per MGM/ALT
	ren qty_inorg inorg_fert_kg
	ren qty_orgfert org_fert_kg
	ren qty_herb herb_kg
	ren qty_pest pest_kg
	la var inorg_fert_kg "Qty inorganic fertilizer used (kg)"
	la var org_fert_kg "Qty organic fertilizer used (kg)"
    la var herb_kg "Qty of herbicide used (kg/L)"
    la var pest_kg "Qty of pesticide used (kg/L)"
duplicates drop hhid, force 
	merge 1:1 hhid season using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fertilizer_kg_application.dta" // many missing ta, region and district
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_input_quantities.dta", replace
restore	
	
* Save HH-LEVEL Crop Expenses (long)
append using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_cost_inputs_long.dta"
collapse (sum) val qty, by(hhid  exp input season) 
merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keepusing(ta ea district region)
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_cost_inputs_long.dta", replace

	
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_cost_inputs_long.dta", clear
collapse (sum) val, by(hhid garden_id plot_id  exp season)
//duplicates drop hhid , force 
merge m:1 hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) //missing dm_gender was not in original PDM dataset 
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
drop if dm_gender2 == "" //all obs match, can I drop the 2,283 obs that are missing dm_gender bc they are not included in the PDM set
drop dm_gender
ren val* val*_
reshape wide val*, i(hhid garden_id plot_id dm_gender2 season) j(exp) string
ren val* val*_
merge 1:1 hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", nogen keep(1 3) keepusing(field_size) //do per-ha expenses at the same time
merge m:1 hhid garden_id plot_id using `planted_area', nogen keep(1 3)
reshape wide val*, i(hhid garden_id plot_id) j(dm_gender2) string
collapse (sum) val* field_size* ha_planted*, by( hhid)
//Renaming variables to plug into later steps
foreach i in male female mixed {
gen cost_expli_`i' = val_exp_`i'
egen cost_total_`i' = rowtotal(val_exp_`i' val_imp_`i')
}
egen cost_expli_hh = rowtotal(val_exp*)
egen cost_total_hh = rowtotal(val*)
drop val*
save  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_cost_inputs.dta", replace

********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta",clear
	keep if purestand == 1
	merge m:1  hhid garden_id plot_id using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono
	collapse (sum) *mono*, by(hhid garden_id plot_id crop_code dm_gender)
	
	
forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	di "`cn_full'"
	keep if crop_code==`c'			
	ren monocrop_ha `cn'_monocrop_ha
	drop if `cn'_monocrop_ha==0 | `cn'_monocrop_ha==.	
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_`cn'_monocrop.dta", replace
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3
	}
	
	gen dm_male = dm_gender==1 
	gen dm_female = dm_gender==2
	gen dm_mixed = dm_gender==3
	
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
	save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_`cn'_monocrop_hh_area.dta", replace
restore
}	

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_cost_inputs_long.dta", clear 
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val, by(hhid garden_id plot_id dm_gender input)
levelsof input, clean l(input_names)
	ren val val_
	reshape wide val_, i(hhid garden_id plot_id dm_gender) j(input) string
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3 
	replace dm_gender2 = "unknown" if dm_gender==. 
	drop dm_gender
	
	foreach cn in $topcropname_area {
preserve

	ren val* val*_`cn'_
	reshape wide val*, i(hhid garden_id plot_id) j(dm_gender2) string
	merge 1:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_`cn'_monocrop.dta", nogen keep(3)
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_*)
	}
	save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_inputs_`cn'.dta", replace
	
restore
}	

********************************************************************************
*LIVESTOCK INCOME SS Updated 
********************************************************************************
*Expenses - complete 7/20 
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R2.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta"
rename ag_r26 cost_fodder_livestock     
rename ag_r27 cost_vaccines_livestock    
rename ag_r28 cost_othervet_livestock    
gen cost_medical_livestock = cost_vaccines_livestock + cost_othervet_livestock 
rename ag_r25 cost_hired_labor_livestock 
rename ag_r29 cost_input_livestock      
recode cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock(.=0)

preserve 
keep if inlist(ag_r0a, 301, 302, 303, 304, 3304)
	collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_hired_labor_livestock cost_input_livestock, by (hhid)
	egen cost_lrum = rowtotal (cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_hired_labor_livestock cost_input_livestock)
	keep hhid cost_lrum
	lab var cost_lrum "Livestock expenses for large ruminants"
	recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_lrum_expenses.dta", replace
restore 

preserve 
	rename ag_r0a livestock_code
	gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 311,313,315,319,3310,3314))
	recode species (0=.)
	la def species 1 "Large ruminants (calf, steer/heifer, cow, bull, ox)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
	la val species species

	collapse (sum) cost_medical_livestock, by ( hhid species) 
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
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_livestock_expenses_animal.dta", replace
restore 


collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock  cost_hired_labor_livestock cost_input_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for <livestock>"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for <livestock>"
lab var cost_othervet_livestock "Cost for other veterinary treatments for <livestock> (incl. dipping, deworming, AI)"
lab var cost_hired_labor_livestock "Cost for hired labor for <livestock>"
lab var cost_input_livestock "Cost for livestock inputs (incl. housing, equipment, feeding utensils)"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_livestock_expenses.dta", replace

*Livestock products 
* Milk - RH complete 7/21 (question)
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_s.dta", clear
rename ag_s0a livestock_code
keep if livestock_code==401
rename ag_s02 no_of_months_milk 
rename ag_s03a qty_milk_per_month 
gen milk_liters_produced = no_of_months_milk * qty_milk_per_month if ag_s03b==1  
lab var milk_liters_produced "Liters of milk produced in past 12 months"

gen liters_sold_12m = ag_s05a if ag_s05b==1 
rename ag_s06 earnings_milk_year
gen price_per_liter = earnings_milk_year/liters_sold_12m if liters_sold_12m > 0
gen price_per_unit = price_per_liter 
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
keep hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year 
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_milk", replace	
					
* Other livestock products  
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
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
gen quantity_produced = months_produced * quantity_month // Units are liters for milk, pieces for eggs & skin, kg for meat and manure. (RH Note: only showing values for chicken eggs - is that correct?) ALSO, double check if "other" (408) has quantity produced values
lab var quantity_produced "Quantity of this product produced in past year"

rename ag_s05a sales_quantity
rename ag_s05b sales_unit
*replace sales_unit =. if livestock_code==401 & sales_unit!=1 // milk, liters only
replace sales_unit =. if livestock_code==402 & sales_unit!=3  // chicken eggs, pieces only
replace sales_unit =. if livestock_code== 403 & sales_unit!=3   // guinea fowl eggs, pieces only
replace sales_quantity = sales_quantity*1.5 if livestock_code==404 & sales_unit==3 // VAP: converting obsns in pieces to kgs for meat. Using conversion for chicken. 
replace sales_unit = 2 if livestock_code== 404 & sales_unit==3 // VAP: kgs for meat
replace sales_unit =. if livestock_code== 406 & sales_unit!=3   // VAP: pieces for skin and hide, not converting kg (1 obsn).
replace sales_unit =. if livestock_code== 407 & quantity_month_unit!=2  // VAP: kgs for manure, not converting liters(1 obsn), bucket, wheelbarrow & oxcart (2 obsns each)

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
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_other", replace

*All Livestock Products
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_milk", clear
append using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_other"
recode price_per_unit (0=.)
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta" 
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
lab var price_per_unit "Price per unit sold"
lab var quantity_produced "Quantity of product produced"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", replace
					
* EA Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ta ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ta ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_ea.dta", replace

* TA Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ta livestock_code: egen obs_ta = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ta livestock_code obs_ta)
rename price_per_unit price_median_ta
lab var price_median_ta "Median price per unit for this livestock product in the ta"
lab var obs_ta "Number of sales observations for this livestock product in the ta"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_ta.dta", replace 

* District Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_district.dta", replace

* Region Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_region.dta", replace

* Country Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_country.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_long", clear
merge m:1 region district ta ea livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_ea.dta", nogen
merge m:1 region district ta livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_ta.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ta if price_per_unit==. & obs_ta >= 10
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
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_products", replace // RH complete

*Ag Query 
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_other.dta", clear
gen sales_eggs = earnings_sales if livestock_code == 402 | livestock_code == 403
collapse (sum) sales_eggs, by(hhid)
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_sales_eggs.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_products.dta", clear
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products_milk.dta", nogen keep (1 3)
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_sales_eggs.dta", nogen keep (1 3)
ren earnings_milk_year sales_milk 
collapse (sum) value_milk_produced value_eggs_produced value_livestock_products value_other_produced share_livestock_prod_sold sales_livestock_products sales_milk sales_eggs, by (hhid)
gen prop_dairy_sold = sales_milk / value_milk_produced
gen prop_eggs_sold = sales_eggs / value_eggs_produced
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_products.dta", replace

* Manure (Dung in TZ)
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (hhid)
lab var sales_manure "Value of manure sold" 
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_manure.dta", replace // RH complete

*Sales (live animals)
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
rename ag_r0a livestock_code
rename ag_r17 income_live_sales     // total value of sales of [livestock] live animals last 12m -- RH note, w3 label doesn't include "during last 12m"
rename ag_r16 number_sold          // # animals sold alive last 12 m
rename ag_r19 number_slaughtered  // # animals slaughtered last 12 m 
rename ag_r11 value_livestock_purchases 
/* VAP: not available in MW2 or w3
rename lf02_32 number_slaughtered_sold  // # of slaughtered animals sold
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
rename lf02_33 income_slaughtered // # total value of sales of slaughtered animals last 12m
*/
//rename ag_r13 value_livestock_purchases // tot. value of purchase of live animals last 12m
recode income_live_sales number_sold number_slaughtered /*number_slaughtered_sold income_slaughtered*/ value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animals sold"
recode price_per_animal (0=.) 
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3)
keep hhid weight region district ta ea livestock_code number_sold income_live_sales number_slaughtered /*number_slaughtered_sold income_slaughtered*/ price_per_animal value_livestock_purchases
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", replace // RH complete - can we do anything about missing slaughtered/sold data? Is total value of sales actually live only? Label says "total value of livestock sales", not total value of live sales

*Implicit prices  // VAP: MW2 & w3 do not have value of slaughtered livestock

* EA Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ta ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ta ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_ea.dta", replace 

* TA Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ta livestock_code: egen obs_ta = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ta livestock_code obs_ta)
rename price_per_animal price_median_ta
lab var price_median_ta "Median price per unit for this livestock in the ta"
lab var obs_ta "Number of sales observations for this livestock in the ta"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_ta.dta", replace 

* District Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_district.dta", replace

* Region Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_region.dta", replace

* Country Level
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_country.dta", replace //RH complete

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_sales", clear
merge m:1 region district ta ea livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_ea.dta", nogen
merge m:1 region district ta livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_ta.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_livestock_sales = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered

collapse (sum) /*value_livestock_sales*/ value_livestock_purchases value_livestock_sales /*value_slaughtered*/, by (hhid)
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases"
*lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_livestock_sales "Value of livestock sold live" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_sales", replace //RH complete

*TLU (Tropical Livestock Units)
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
rename ag_r0a livestock_code 
gen tlu_coefficient=0.5 if (livestock_code==301|livestock_code==302|livestock_code==303|livestock_code==304|livestock_code==3304) // calf, steer/heifer, cow, bull, ox
replace tlu_coefficient=0.1 if (livestock_code==307|livestock_code==308) //goats, sheep
replace tlu_coefficient=0.2 if (livestock_code==309) // pigs
replace tlu_coefficient=0.01 if (livestock_code==313|livestock_code==313|livestock_code==315|livestock_code==319|livestock_code==3310|livestock_code==3314) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
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
rename ag_r15 lost_stolen // # of livestock lost or stolen in last 12m
egen mean_12months = rowmean(number_today_total number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_stolen)	
gen share_imp_herd_cows = number_today_exotic/(number_today_total) if livestock_code==303 // VAP: only cows, not including calves, steer/heifer, ox and bull
gen species = (inlist(livestock_code,301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code,311,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calves, steer/heifer, cows, bulls, oxen)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, mules)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
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
	drop lvstck_holding animals_lost12months mean_12months lost_disease 
	recast str50 hhid, force 
	save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep(1 3)
merge m:1 region district ta ea livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_ea.dta", nogen
merge m:1 region district ta livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_ta.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_prices_country.dta", nogen

recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today_total * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by ( hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_TLU.dta", replace

*Livestock income
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_sales", clear
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_products", nogen
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_manure.dta", nogen
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_expenses", nogen
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_TLU.dta", nogen

gen livestock_income = value_livestock_sales  /*value_slaughtered*/ /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_income", replace


********************************************************************************
*FISH INCOME - SS Reviewed and Updated 
********************************************************************************
*Fishing expenses  
*VAP: Method of calculating ft and pt weeks and days consistent with ag module indicators for rainy/dry seasons*/
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_c.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_g.dta"
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
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weeks_fishing.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_d1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_h2.dta"
recast str50 hhid, force
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weeks_fishing.dta"
rename weeks_fishing weeks
rename fs_h13 fuel_costs_week
rename fs_h12 rental_costs_fishing 
// Relevant and in the MW2 Qs., but missing in .dta files. 
// fs_d6: "How much did your hh. pay to rent [gear] for use in last high season?" 
rename fs_h10 purchase_costs_fishing // VAP: Boat/Engine purchase. Purchase cost is additional in MW2, TZ code does not have this. 
recode weeks fuel_costs_week rental_costs_fishing  purchase_costs_fishing(.=0)
gen cost_fuel = fuel_costs_week * weeks
collapse (sum) cost_fuel rental_costs_fishing, by (hhid)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fishing_expenses_1.dta", replace // VAP: Not including hired labor costs, keeping consistent with TZ. Can add this for MW if needed. 

* Other fishing costs  
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_d3.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_h3.dta"
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weeks_fishing"
rename fs_d24a total_cost_high // total other costs in high season, only 6 obsns. 
replace total_cost_high=fs_h24a if total_cost_high==.
rename fs_d24b unit
replace unit=fs_h24b if unit==. 
gen cost_paid = total_cost_high if unit== 2  // season
replace cost_paid = total_cost_high * weeks_fishing if unit==1 // weeks
collapse (sum) cost_paid, by (hhid)
lab var cost_paid "Other costs paid for fishing activities"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fishing_expenses_2.dta", replace

* Fish Prices
//ALT 10.18.19: It doesn't look like the data match up with the questions in module e.

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_e1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=13) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b fish_quantity_unit
replace fish_quantity_unit=fs_i06b if fish_quantity_unit==.
rename fs_e08b unit  // piece, dozen/bundle, kg, small basket, large basket
gen price_per_unit = fs_e08d // VAP: This is already avg. price per packaging unit. Did not divide by avg. qty sold per week similar to TZ, seems to be an error?
replace price_per_unit = fs_i08d if price_per_unit==.
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hhids.dta", nogen keep(1 3) 
recode price_per_unit (0=.) 
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==13
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_prices.dta", replace

* Value of fish harvest & sales 

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_e1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=13) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b unit  // piece, dozen/bundle, kg, small basket, large basket
recast str50 hhid, force 
merge m:1 fish_code unit using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_prices.dta"
drop if _merge==2
drop _merge
rename fs_e08a quantity_1
replace quantity_1=fs_i08a if quantity_1==.
rename fs_e08b unit_1
replace unit_1=fs_i08b if unit_1==.
gen price_unit_1 = fs_e08d // not divided by qty unlike TZ, not sure about the logic of dividing here. 
replace price_unit_1=fs_i08d if price_unit_1==.
rename fs_e08g quantity_2
replace quantity_2=fs_i08g if quantity_2==.
rename fs_e08h unit_2 
replace unit_2= fs_i08h if unit_2==.
gen price_unit_2=fs_e08j // not divided by qty unlike TZ.
replace price_unit_2=fs_i08j if price_unit_2==.
recode quantity_1 quantity_2 fish_quantity_year (.=0)
gen income_fish_sales = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest = (fish_quantity_year * price_unit_1) if unit==unit_1 
replace value_fish_harvest = (fish_quantity_year * price_per_unit_median) if value_fish_harvest==.
collapse (sum) value_fish_harvest income_fish_sales, by (hhid)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_income.dta", replace


* HKS 09.01.23: This section was previously labeled self-employment income, which was separate from other self-employment income. I've moved this to the rest of fish income; not sure if these files should be appended/merged/consolidated with the above fish_income.dta
*Fish trading
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_c.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_g.dta"
rename fs_c04a weeks_fish_trading 
replace weeks_fish_trading=fs_g04a if weeks_fish_trading==.
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (hhid) 
keep hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weeks_fish_trading.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_f1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_f2.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_j1.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_j2.dta"
rename fs_f02a quant_fish_purchased_1
replace quant_fish_purchased_1= fs_j02a if quant_fish_purchased_1==.
rename fs_f02f price_fish_purchased_1
replace price_fish_purchased_1= fs_j02f if price_fish_purchased_1==.
rename fs_f02h quant_fish_purchased_2
replace quant_fish_purchased_2= fs_j02h if quant_fish_purchased_2==.
rename fs_f02m price_fish_purchased_2
replace price_fish_purchased_2= fs_j02m if price_fish_purchased_2==.
rename fs_f03a quant_fish_sold_1
replace quant_fish_sold_1=fs_j03a if quant_fish_sold_1==.
rename fs_f03f price_fish_sold_1
replace price_fish_sold_1=fs_j03f if price_fish_sold_1==.
rename fs_f03h quant_fish_sold_2
replace quant_fish_sold_2=fs_j03g if quant_fish_sold_2==.
rename fs_f03m price_fish_sold_2
replace price_fish_sold_2=fs_j03l if price_fish_sold_2==.

recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 /*other_costs_fishtrading*/(.=0)

gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2) /*+ other_costs_fishtrading*/
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit, by (hhid)
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep hhid weekly_fishtrade_profit
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_trading_revenues.dta", replace   

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_f2.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_j2.dta"
rename fs_f05 weekly_costs_for_fish_trading // VAP: Other costs: Hired labor, transport, packaging, ice, tax in MW2.
replace weekly_costs_for_fish_trading=fs_j05 if weekly_costs_for_fish_trading==.
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (hhid)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep hhid weekly_costs_for_fish_trading
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_trading_other_costs.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weeks_fish_trading.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_trading_revenues.dta" 
drop _merge
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_trading_other_costs.dta"
drop _merg
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep hhid fish_trading_income
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fish_trading_income.dta", replace

********************************************************************************
*SELF-EMPLOYMENT INCOME - HKS copied from MS AL Seasonal Hunger by FN on 6.29.23 - CNC (Needs Review from ALT or MGM)
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_N2.dta", clear
rename hh_n40 last_months_profit 
gen self_employed_yesno = .
replace self_employed_yesno = 1 if last_months_profit !=.
replace self_employed_yesno = 0 if last_months_profit == .
*DYA.2.9.2022 Collapse this at the household level
collapse (max) self_employed_yesno (sum) last_months_profit, by(hhid)
drop if self != 1
ren last_months self_employ_income
*lab var self_employed_yesno "1=Household has at least one member with self-employment income"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_self_employment_income.dta", replace

********************************************************************************
*NON-AG WAGE INCOME
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno 
rename hh_e22 number_months  
rename hh_e23 number_weeks   
rename hh_e24 number_hours  
rename hh_e25 most_recent_payment // amount of last payment
replace most_recent_payment =. if most_recent_payment== 1.50e+09
replace most_recent_payment=. if inlist(hh_e19b,62 63 64) 
replace hh_e26a=. if hh_e26a >=1500
replace most_recent_payment = most_recent_payment/hh_e26a

//For MW3, above codes are in .dta. 62:Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers- Got this from Wave 1.  

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
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_wage_income.dta", replace

********************************************************************************
*AG WAGE INCOME
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_E.dta", clear
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
gen annual_salary_wage = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary_wage, by (hhid)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_agwage_income.dta", replace  

********************************************************************************
*OTHER INCOME - HKS copied from MS AL Seasonal Hunger by FN on 6.29.23 - CNC
********************************************************************************
*use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_prices.dta", clear
*keep if crop_code==1 // keeping only maize for later
*save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_P.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_R.dta" 
append using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_O.dta"
*merge m:1 HHID using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\temp\MWI_IHS_IHPS_W3_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
*merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
rename hh_p0a income_source
ren hh_p01 received_income
ren hh_p02 amount_income
gen rental_income=amount_income if received_income==1 & inlist(income_source, 106, 107, 108, 109) // non-ag land rental, house/apt rental, shope/store rental, vehicle rental
gen pension_investment_income=amount_income if received_income==1 &  income_source==105| income_source==104 | income_source==136 // pension & savings/interest/investment income+ private pension
gen asset_sale_income=amount_income if received_income==1 &  inlist(income_source, 130,131,132) // real estate sales, non-ag hh asset sale income, hh ag/fish asset sale income
gen other_income=amount_income if received_income==1 &  inlist(income_source, 133, 134, 135) // inheritance, lottery, other income
rename hh_r0a prog_code

gen assistance_cash_yesno= hh_r02a!=0 & hh_r02a!=. if inlist(prog_code, 1031, 104,108,1091,131,132) // Cash from MASAF, Non-MASAF pub. works,
*inputs-for-work, sec. level scholarships, tert. level. scholarships, dir. Cash Tr. from govt, DCT other
gen assistance_food= hh_r02b!=0 & hh_r02b!=.  if inlist(prog_code, 101, 102, 1032, 105, 107) //  
gen assistance_otherinkind_yesno=hh_r02b!=0 & hh_r02b!=. if inlist(prog_code,104, 106, 132, 133) // 

rename hh_o14 cash_remittance 
rename hh_o17 in_kind_remittance 
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
collapse (max) *_yesno  (sum) remittance_income rental_income pension_investment_income asset_sale_income other_income, by(hhid )
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
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_other_income.dta", replace

************
* Other: Land Rental Income - HKS copied from MWI W2

* HKS 6.29.23:
	* Questionnaire shows AG MOD B2 Q19 asking " how much did you ALREADY receive from renting out this garden in the rainy season", but q19 is omitted from the raw data
	* We do have Q B217 though: "How much did you receive from renting out this garden in the rainy season"
* Cross section got q17 whereas panel got q19;
* for MSAI request 6/30/23, refer only to cross section (prefer q17); for general LSMS purposes, need to incorporate the panel data;
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear // *VAP: The below code calculates only agricultural land rental income, per TZ guideline code 
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta" 
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
collapse (sum) land_rental_income, by (hhid )
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_rental_income.dta", replace


********************************************************************************
* CROP INCOME - HKS copied from CWL code for MWI4 on 6.29.23 - CNC
********************************************************************************
/*use "${Malawi_IHS_W3_created_data}/Malawi_IHS_W3_land_rental_costs.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_wages_rainyseason.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_wages_dryseason.dta", nogen
merge 1:1 hhid using "${Malawi_W3_created_data}/Malawi_IHS_W3_transportation_cropsales.dta", nogen
merge 1:! hhid using "{$Malawi_W3_created_data}/Malawi_IHS_W3_fertilizer_costs.dta", nogen
recode rental_cost_land cost_seed value_fertilizer value_herbicide value_pesticide wages_paid_rainy /*
*/ wages_paid_dry transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_land cost_seed value_fertilizer value_herbicide /* 
*/ value_pesticide wages_paid_dry wages_paid_rainy transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"
	ren hhid HHID 
save "${Malawi_IHS_W3_created_data}\MWI_IHS_IHPS_W3_crop_income.dta", replace*/

********************************************************************************
*OFF FARM HOURS SS: 2/12/24 Updated 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_e.dta", clear
gen  hrs_main_wage_off_farm=hh_e24_1 if !inlist(hh_e19b, 62, 63, 64) & hh_e19b!=. 	
gen  hrs_sec_wage_off_farm=hh_e38_1 if !strmatch(hh_e33, "TOBACCO PLUCKER") |!strmatch(hh_e33, "growing crops") | !strmatch(hh_e33, "working garden")
egen hrs_wage_off_farm= rowtotal(hrs_main_wage_off_farm hrs_sec_wage_off_farm)
gen  hrs_main_wage_on_farm=hh_e24_1 if inlist(hh_e19b, 62, 63, 64) & hh_e19b!=. 		 
gen  hrs_sec_wage_on_farm= hh_e38_1 if strmatch(hh_e33, "TOBACCO PLUCKER") |strmatch(hh_e33, "growing crops") | strmatch(hh_e33, "working garden")
egen hrs_wage_on_farm= rowtotal(hrs_main_wage_on_farm hrs_sec_wage_on_farm) 
drop *main* *sec*
gen hrs_unpaid_off_farm = hh_e52_1 

recode hh_e06 hh_e05 (.=0)
gen  hrs_domest_fire_fuel=(hh_e06+ hh_e05)*7 // hrs worked just yesterday

ren  hh_e07a hrs_ag_activ
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
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_off_farm_hours.dta", replace

********************************************************************************
*FARM SIZE / LAND SIZE -SS Updated 2/22
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_g.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_m.dta"
ren plotid plot_id
ren gardenid garden_id
drop if plot_id==""
drop if crop_code==. 
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid plot_id garden_id)
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_crops_grown.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear
ren plotid plot_id
ren gardenid garden_id
tempfile ag_mod_k_13_numeric 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_k_13_temp.dta", replace 

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
ren gardenid garden_id
ren plotid plot_id
append using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_k_13_temp.dta"
gen cultivated = (ag_d14==1) // | ag_k15==1) question is in instrument but missing from raw data CG 1.5.2024 // VAP: cultivated plots in rainy or dry seasons
collapse (max) cultivated, by (hhid plot_id garden_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_cultivated.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_cultivated.dta", clear
recast str50 hhid, force 
merge 1:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta",
drop if _merge==2
keep if cultivated==1

replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
rename area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_size.dta", replace

* All agricultural land
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
ren plotid plot_id
ren gardenid garden_id
append using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_k_13_temp.dta"
drop if plot_id==""
recast str50 hhid, force 
merge m:1 hhid plot_id garden_id  using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_crops_grown.dta", nogen // 1,682 matched
gen rented_out = (ag_d14==2) // rented out (2), missing dry raw data for ag_k15
drop if rented_out==1 & crop_grown!=1 //182 obs dropped
gen agland = (ag_d14==1 | ag_d14==4) // cultivated (1) and fallow (4), missing dry raw data for ag_k15
drop if agland!=1 & crop_grown==. //227 obs dropped
collapse (max) agland, by (hhid plot_id garden_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_agland.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
ren plotid plot_id
ren gardenid garden_id
append using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_k_13_temp.dta"
drop if plot_id==""
gen rented_out = (ag_d14==2 | ag_d14==3) // | ag_k15==2 | ag_k15==3) //rented out (2), gave out for free (3)
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (hhid garden_id plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_held.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_held.dta", clear
recast str hhid, force 
merge 1:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
rename area_acres_meas land_size
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_size_all.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", clear
recast str50 hhid, force 
merge m:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_agland.dta", nogen
keep if agland==1
collapse (sum) field_size, by (hhid)
ren field_size farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated, fallow, or pastureland"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmsize_all_agland.dta", replace

*Total land holding including cultivated and rented out
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
ren plotid plot_id
ren gardenid garden_id
append using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_k_13_temp.dta"
drop if plot_id==""
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)	
collapse (max) area_acres_meas, by(hhid garden_id plot_id)
rename area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_size_total.dta", replace

/*
use "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_g.dta", clear
append using "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_m.dta"
gen cultivated = 1 
ren plotid plot_id
drop if plot_id==""
replace ag_g0a = ag_m0a if ag_g0a == .
ren ag_g0a cultivated_this_year // Plant any crops during 2012/2013 rainy season or 2013 dry season 

preserve 
use "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_p.dta", clear
gen cultivated = 1 if (ag_p05 !=. & ag_p05 !=0 | ag_p05 !=. & ag_p05 !=0)
ren plotid plot_id
ren gardenid garden_id
collapse (max) cultivated, by (hhid plot_id garden_id)
tempfile tree
save `tree', replace
restore
append using `tree'

preserve 

use "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_b2.dta", clear
append using "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_i2.dta"
ren gardenid garden_id
drop if garden_id== ""
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_b2_i2_temp.dta", replace
restore 
recast str50 hhid, force 
merge m:1 hhid garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_b2_i2_temp.dta"
replace cultivated = 1 if (ag_b214 | ag_i214==1)
replace cultivated = 1 if cultivated_this_year==1 & cultivated==.

collapse (max) cultivated, by (hhid garden_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_cultivated.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_cultivated.dta", clear
merge 1:m hhid garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", nogen keep(1 3)
keep if cultivated==1
replace area_meas_hectares=. if area_meas_hectares<0 
replace area_meas_hectares = area_est_hectares if area_meas_hectares ==. 
collapse (sum) area_meas_hectares, by (hhid garden_id)
rename area_meas_hectares field_size
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_sizes.dta", replace
collapse (sum) field_size, by (hhid)
ren field_size farm_area
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_size.dta", replace

* All agricultural land
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_b2_i2_temp.dta", clear 
gen agland = (ag_b214==1 | ag_b214==4 |ag_i214==1 | ag_i214==4) // All cultivated AND fallow plots 
merge m:1 hhid garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_cultivated.dta", nogen keep(1 3)

preserve 
use "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_p.dta", clear
ren gardenid garden_id 
gen cultivated = 1 if (ag_p05 !=. & ag_p05 !=0 | ag_p05 !=. & ag_p05 !=0)
drop if garden_id== ""
collapse (max) cultivated, by (hhid garden_id)
tempfile tree
save `tree', replace
restore
append using `tree'
replace agland=1 if cultivated==1
keep if agland==1
collapse (max) agland, by (hhid garden_id)
keep hhid garden_id agland
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_agland.dta", replace


use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_agland.dta", clear
recast str50 hhid, force
merge 1:m hhid  garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta"
keep if agland==1
replace area_meas_hectares=. if area_meas_hectares<0 
replace area_meas_hectares = area_est_hectares if area_meas_hectares ==. 
replace area_meas_hectares = area_est_hectares if area_meas_hectares==0 & (area_est_hectares>0 & area_est_hectares!=.)	
collapse (sum) area_meas_hectares, by (hhid)
ren area_meas_hectares farm_size_agland
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmsize_all_agland.dta", replace

* parcels held
use "${MWI_IHS_IHPS_W3_raw_data}\ag_mod_b2.dta", clear
append using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ag_mod_b2_i2_temp.dta"
drop if garden_id==""
gen rented_out = (ag_b214==2 | ag_b214==3 | ag_i214==2 | ag_i214==3) 
gen cultivated_dry = (ag_i214==1)
bys hhid garden_id: egen land_cult_dry = max(cultivated_dry)
replace rented_out = 0 if land_cult_dry==1 // If cultivated in dry season, not considered rented out in rainy season.
drop if rented_out==1
gen land_held = 1
collapse (max) land_held, by (hhid garden_id)
lab var land_held "1= Parcel was NOT rented out in the main season"
save  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_held.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_parcels_held.dta", clear
recast str50 hhid, force
merge 1:m hhid garden_id using"${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta"
drop if _merge==2
replace area_meas_hectares=. if area_meas_hectares<0 
replace area_meas_hectares = area_est_hectares if area_meas_hectares ==. 
collapse (sum) area_meas_hectares, by (hhid)
rename area_meas_hectares land_size
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_size_all.dta", replace


use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", clear
replace area_meas_hectares=. if area_meas_hectares<0 
replace area_meas_hectares = area_est_hectares if area_meas_hectares ==. 
replace area_meas_hectares = area_est_hectares if area_meas_hectares==0 & (area_est_hectares>0 & area_est_hectares!=.)
collapse (sum) area_meas_hectares, by(hhid)
ren area_meas_hectares land_size_total
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_size_total.dta", replace
*/
********************************************************************************
*FARM LABOR SS Updated 2/12/24 
********************************************************************************
** Family labor
* Rainy Season
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
rename ag_d47a2 landprep_women  // # of days women hired for land preparation, planting, ridging, weeding and fertilizing
rename ag_d47a1 landprep_men   // # of days men hired for land preparation, planting, ridging, weeding and fertilizing
rename ag_d47a3 landprep_child // # of days children hired for land preparation, planting, ridging, weeding and fertilizing 
rename ag_d48a1 harvest_men    // # of days men hired for harvesting
rename ag_d48a2 harvest_women // # of days women hired for harvesting
rename ag_d48a3 harvest_child // # of days children hired for harvesting
recode landprep_women landprep_men landprep_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_rainyseason = rowtotal(landprep_women landprep_men landprep_child harvest_men harvest_women harvest_child) 
recode ag_d42c1 ag_d42c2 ag_d42c3 ag_d42c4(.=0)  // # of days per week spent by hh.members (upto 4) in land prep/planting
egen days_flab_landprep = rowtotal(ag_d42c1 ag_d42c2 ag_d42c3 ag_d42c4)
recode ag_d43c1 ag_d43c2 ag_d43c3 ag_d43c4 (.=0) // # of days per week spent by hh.members (upto 4) in weeding, fertilizing and/or any other non-harvest activity
egen days_flab_weeding = rowtotal(ag_d43c1 ag_d43c2 ag_d43c3 ag_d43c4)
recode ag_d44c1 ag_d44c2 ag_d44c3 ag_d44c4 (.=0) // # of days per week spent by hh.members (upto 4) in harvesting
egen days_flab_harvest = rowtotal(ag_d44c1 ag_d44c2 ag_d44c3 ag_d44c4)
gen days_famlabor_rainyseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotid plot_id
ren gardenid garden_id
collapse (sum) days_hired_rainyseason days_famlabor_rainyseason, by (hhid plot_id garden_id)
lab var days_hired_rainyseason  "Workdays for hired labor (crops) in rainy season"
lab var days_famlabor_rainyseason  "Workdays for family labor (crops) in rainy season"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_farmlabor_rainyseason.dta", replace

* Dry Season
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear
rename ag_k47a no_days_men_all
rename ag_k47b no_days_women_all 
rename ag_k47c no_days_chldrn_all 
recode no_days_men_all no_days_women_all no_days_chldrn_all(.=0)
egen days_hired_dryseason = rowtotal(no_days_men_all no_days_women_all no_days_chldrn_all) 
recode ag_k43c1 ag_k43c2 ag_k43c3 ag_k43c4(.=0) // # of days per week spent by hh.members (upto 4) in land prep/planting
egen days_flab_landprep = rowtotal(ag_k43c1 ag_k43c2 ag_k43c3 ag_k43c4)
recode ag_k44c1 ag_k44c2 ag_k44c3 ag_k44c4 (.=0) // # of days per week spent by hh.members (upto 4) in weeding, fertilizing and/or any other non-harvest activity
egen days_flab_weeding = rowtotal(ag_k44c1 ag_k44c2 ag_k44c3 ag_k44c4)
recode ag_k45c1 ag_k45c2 ag_k45c3 ag_k45c4(.=0) // # of days per week spent by hh.members (upto 4) in harvesting
egen days_flab_harvest = rowtotal(ag_k45c1 ag_k45c2 ag_k45c3 ag_k45c4)
gen days_famlabor_dryseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren plotid plot_id
ren gardenid garden_id
collapse (sum) days_hired_dryseason days_famlabor_dryseason, by (hhid plot_id garden_id)
lab var days_hired_dryseason  "Workdays for hired labor (crops) in dry season"
lab var days_famlabor_dryseason  "Workdays for family labor (crops) in dry season"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_farmlabor_dryseason.dta", replace


*Hired Labor
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_farmlabor_rainyseason.dta", clear
merge 1:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_farmlabor_dryseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(hhid plot_id garden_id)
egen labor_hired =rowtotal(days_hired_rainyseason days_hired_dryseason)
egen labor_family=rowtotal(days_famlabor_rainyseason  days_famlabor_dryseason)
egen labor_total = rowtotal(days_hired_rainyseason days_famlabor_rainyseason days_hired_dryseason days_famlabor_dryseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_family_hired_labor.dta", replace


********************************************************************************
*VACCINE USAGE - SS Checked and Updated 11-29-2023 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
gen vac_animal=ag_r22>0 
replace vac_animal = 0 if ag_r22==0  
replace vac_animal = . if ag_r22==. 

*Disagregating vaccine usage by animal type 
rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 313,313,315,319,3310,3314))
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
	recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_vaccine.dta", replace

 
*vaccine use livestock keeper  
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
gen all_vac_animal=ag_r22>0
* MW3: How many of your[Livestock] are currently vaccinated? 
replace all_vac_animal = 0 if ag_r22==0  
replace all_vac_animal = . if ag_r22==. 
preserve 
keep hhid ag_r06a all_vac_animal
ren ag_r06a farmerid
tempfile farmer1
save `farmer1'
restore 
preserve
keep hhid ag_r06a ag_r06b all_vac_animal
ren ag_r06b farmerid
tempfile farmer2
save `farmer2'
restore 
gen t=1
use   `farmer1', replace
append using  `farmer2'
collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
recast str50 hhid, force
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", nogen 
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_vaccine.dta", replace	

********************************************************************************
*ANIMAL HEALTH - DISEASES - SS Checked and Updated 11-29-2023 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
gen disease_animal = ag_r20==1 if ag_r01==1 // Answered "yes" for "Did livestock suffer from any disease in last 12m?" //ALT: Updated to only count households that report owning livestock 

//RH where are main diseases? BID? Do these change over waves?
gen disease_ASF = ag_r21a==30 //  African swine fever (RH, now 30)
replace disease_ASF = ag_r21a==30 if strmatch(ag_r21_oth,  " SWINE FEVER") 
gen disease_amapl = ag_r21a==18 // Amaplasmosis (now 18?)
gen disease_bruc = . // Brucelosis not incl w3
gen disease_mange = ag_r21a==36 // Mange (now 36)
gen disease_NC= ag_r21a==22 // New Castle disease (now 7)
gen disease_spox= . // Small pox not found in W3
gen disease_other = inrange(ag_r21a, 3, 6) | inrange(ag_r21a, 8, 17) | ag_r21a==21 | ag_r21a > 22 //ALT: adding "other" category to capture rarer diseases. Either useful or useless b/c every household had something in that category

rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 313,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"  6 "Other"
la val species species

*A loop to create species variables
foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox { 
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
	gen `i'_other = `i' if species==6
}

collapse (max) disease_*, by (hhid)
lab var disease_animal "1= Household has animal that suffered from disease"

//may have to edit below if diseases changed
lab var disease_ASF "1= Household has animal that suffered from African Swine Fever"
lab var disease_amapl"1= Household has animal that suffered from amaplasmosis disease"
lab var disease_bruc"1= Household has animal that suffered from brucelosis"
lab var disease_mange "1= Household has animal that suffered from mange disease"
lab var disease_NC "1= Household has animal that suffered from New Castle disease"
lab var disease_spox "1= Household has animal that suffered from small pox"
lab var disease_other "1=Household experienced another disease"

	foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox{ //RH edit flag
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
		lab var `i'_other "`l`i'' in other" 
	}
//recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_livestock_diseases.dta", replace


********************************************************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING - Cannot replicate for MWI
********************************************************************************	
/* Cannot replicate this section as MWI w3 does not ask about livestock water, feeding, housing. */

********************************************************************************
*PLOT MANAGERS - SS Updated 3.04.23 
********************************************************************************
//This section combines all the variables that we're interested in at manager level
//(inorganic fertilizer, improved seed) into a single operation.
//Doing improved seed and agrochemicals at the same time.

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_cost_inputs_long.dta", clear

gen use_herb = input == "herb"
gen use_pest = input == "pest"
gen use_org_fert = input == "orgfert"
gen use_inorg_fert = input == "inorg"
collapse (max) use*, by(hhid garden_id plot_id season)
merge m:m hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_dm_ids.dta", nogen keep(1 3)
tempfile plotfertilizer
save `plotfertilizer'

	
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_all_plots.dta"

merge m:m hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_dm_ids.dta", nogen keep(1 3)

preserve
ren use_imprv_seed all_imprv_seed_
ren use_hybrid_seed all_hybrid_seed_
collapse (max) all*, by(hhid indiv female crop_code)
merge m:1 crop_code using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_cropname_table.dta", nogen keep(3) // all matched 
drop crop_code
gen farmer_ = 1
recast str50 hhid
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid indiv female) j(crop_name) string
recode farmer_* (.=0)
ren farmer_* *_farmer
gen all_imprv_seed_use = .
foreach x in beans cotton maize nkhwni pigpea pmill rice sorgum swtptt {
	if all_imprv_seed_use == . {
		replace all_imprv_seed_use = 0 if all_imprv_seed_`x' == 0 | all_imprv_seed_`x' == .
	}
	else {
		replace all_imprv_seed_use = 1 if all_imprv_seed_`x' == 1
	}
}
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_improved_hybrid_seed_use.dta", replace
restore

preserve
use  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_improved_hybrid_seed_use.dta", clear
collapse (max) all_hybrid_seed_* all_imprv_seed_*, by(hhid)
ren all_hybrid_seed_* hybrid_seed_*
ren all_imprv_seed_* imprv_seed_*
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_improved_hybrid_seed_use.dta", replace
restore

append using `plotfertilizer'
collapse (max) use_*, by(hhid indiv female)	
gen all_imprv_seed_use = use_imprv_seed	
gen all_hybrid_seed_Use = use_hybrid_seed
gen all_org_fert_use = use_org_fert
gen all_inorg_fert_use = use_inorg_fert
gen all_pest_use = use_pest 
gen all_herb_use=use_herb

preserve	
collapse (max) use_*, by(hhid)	
la var use_imprv_seed "1 = household uses improved seed for at least one crop"	
la var use_hybrid_seed "1 = household uses hybrid seed for at least one crop"
la var use_inorg_fert "1=household uses inorganic fertilizer on at least one plot"
la var use_org_fert "1=household uses organic fertilizer on at least one plot"	
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_input_use.dta" , replace	
restore	


/* We cannot run this section due to ag_mod_l and ag_mod_f issue (same as above)
preserve
ren use_inorg_fert all_use_inorg_fert
	lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
	gen farm_manager=1 if indiv!=.
	recode farm_manager (.=0)
	lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
	save "${Malawi_IHS_W3_created_data}\Malawi_IHS_W3_farmer_fert_use.dta", replace //This is currently used for AgQuery.
restore
*/


********************************************************************************
*REACHED BY AG EXTENSION - SS Checked and Updated 11-29-2023 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_T1.dta", clear
ren ag_t01 receive_advice
ren ag_t01_oth receive_advice_other
ren ag_t02 sourceid
ren ag_t02_1 sourceid_other

**Government Extension
gen advice_gov = (sourceid==1 | sourceid==3 & receive_advice==1) // govt ag extension & govt. fishery extension. 
replace advice_gov= sourceid==1 if strmatch(sourceid_other,  "GOVERNMENTFORESTEXTANTIONOFFICER") | strmatch(sourceid_other,  " GOVERNMENTFORESTEXTANTIONSERVICES") | strmatch(sourceid_other,  " GOVERNMENTAGENCY") | strmatch(sourceid_other,  "GOVERNMENTVETENARY") | strmatch(sourceid_other,  "GOVERNMENTVETENARYVILLAGEMEETING")
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
replace advice_ngo = sourceid==4 if strmatch(sourceid_other,  "ONEACREFUND") | strmatch(sourceid_other,  "  ADRAMALAWI") | strmatch(sourceid_other,  " ADRAMALAWIAN") | strmatch(sourceid_other,  " AEDC") | strmatch(sourceid_other,  " CONCERNUNIVERSAL") | strmatch(sourceid_other,  " DAPP") | strmatch(sourceid_other,  " DAPP")
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1) // ag coop/farmers association
replace advice_coop = sourceid==5 if strmatch(sourceid_other,  " FARMERCOOPERATIVE") | strmatch(sourceid_other,  " MZUZUCOFFEECOOPERATIVE")
**Large Scale Farmer
gen advice_farmer =(sourceid== 10 & receive_advice==1) // lead farmers
**Radio/TV
gen advice_electronicmedia = (sourceid==12 & receive_advice==1) // electronic media:TV/Radio
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1) // handouts, flyers
**Neighbor
gen advice_neigh = (sourceid==13 & receive_advice==1) // Other farmers: neighbors, relatives
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

collapse (max) ext_reach_* , by ( hhid)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_any_ext.dta", replace

********************************************************************************
* MOBILE OWNERSHIP * SS Checked and Updated 11-21-2023 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_F.dta", clear
*recode missing to 0 in hh_f34 (0 mobile owned if missing)
recode hh_f34 (.=0)
ren hh_f34 hh_number_mobile_owned
*recode hh_number_mobile_owned (.=0) 
gen mobile_owned = 1 if hh_number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0
collapse (max) mobile_owned, by( hhid)
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_mobile_own.dta", replace
 
********************************************************************************
*USE OF FORMAL FINANCIAL SERVICES -SS Checked and Updated 11-29-2023 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_F.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_S1.dta"
gen borrow_bank= hh_s04==10 | hh_s04==13 //Includes both bank(commercial) & village bank 
replace borrow_bank= hh_s04==10 if strmatch(hh_s04_oth, "BANK (COMMERCIAL)") 
//gen borrow_relative=hh_s04==1|hh_s04==12 
gen borrow_credit= hh_s04==9 |hh_s04==7 | hh_s04==8 // MARDEF, MRFC, SACCO
replace borrow_credit = hh_s04==9 if  strmatch(hh_s04_oth, "AGRIC COOPERATIVE") |  strmatch(hh_s04_oth, "CREDIT UNION")| strmatch(hh_s04_oth, "MICROFINANCE INSTITUTION") |strmatch(hh_s04_oth, "COOPERATIVE")
gen borrow_moneylender=hh_s04==4 
replace borrow_moneylender = hh_s04==4 if strmatch(hh_s04_oth, " ASSOCIATION") |  strmatch(hh_s04_oth, "MONEY LENDER")| strmatch(hh_s04_oth, "PRIVATE INDIVIDUAL") 
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
replace borrow_relig=hh_s04==6 if strmatch(hh_s04_oth, " CHURCH")  
gen borrow_oth_informal=hh_s04==2 | hh_s04==1 
replace borrow_oth_informal=hh_s04==1 if strmatch(hh_s04_oth, "RELATIVE")
gen borrow_employer=hh_s04==5
replace borrow_employer=hh_s04==5 if strmatch(hh_s04_oth, "EMPLOYER")
gen borrow_ngo=hh_s04==11
replace borrow_ngo=hh_s04==11 if strmatch(hh_s04_oth, "NGO")
gen borrow_other=hh_s04==13
replace borrow_other=hh_s04==13 if  strmatch(hh_s04_oth, "GOV'T LOAN")
gen use_bank_acount=hh_f52==1
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit= borrow_bank==1  | borrow_credit==1 
gen use_fin_serv_others= borrow_other==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 |  use_fin_serv_others==1 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fin_serv.dta", replace	

********************************************************************************
*MILK PRODUCTIVITY -SS Checked and Updated 11-21-2023 (Needs Review)
********************************************************************************
//RH: only cow milk in MWI, not including large ruminant variables
*Total production
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
keep if livestock_code==401 & ag_s02!=0
rename ag_s02 months_milked 
rename ag_s03a liters_month 
gen liters_milk_produced = months_milked * liters_month if ag_s03b==1 
lab var liters_milk_produced "Liters of milk produced in past 12 months"

lab var months_milked "Average months milked in last year (household)"
drop if liters_milk_produced==.
keep hhid livestock_code months_milked liters_month liters_milk_produced 
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_milk_animals.dta", replace


********************************************************************************
*EGG PRODUCTIVITY - SS Checked and Updated 11-21-2023 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
rename ag_r0a lvstckid
gen poultry_owned = ag_r02 if inlist(lvstckid, 313, 313, 315, 318, 319, 3310, 3314) // local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl 
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh
recast str50 hhid, force 
save `eggs_animals_hh'

use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==402 | product_code==403 //chicken eggs, guinea fowl eggs
rename ag_s02 eggs_months_produced // # of months in past year that hh. produced eggs
rename ag_s03a eggs_quantity_produced // avg. qty of eggs per month in past year
rename ag_s03b quantity_month_unit
replace eggs_quantity_produced = round(eggs_quantity_produced/0.06) if product_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs for eggs 
replace quantity_month_unit = 3 if product_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if product_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if product_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
recode eggs_months_produced eggs_quantity_produced (.=0)
gen eggs_total_year = eggs_months_produced* eggs_quantity_produced // Units are pieces for eggs 
collapse (sum) eggs_total_year eggs_quantity_produced (max) eggs_months_produced, by (hhid) // Collapsing chicken & guinea fowl eggs
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months_produced eggs_quantity_produced eggs_total_year poultry_owned 

lab var eggs_months_produced "Number of months eggs were produced (household)"
lab var eggs_quantity_produced "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_eggs_animals.dta", replace

********************************************************************************
* CROP PRODUCTION COSTS PER HECTARE- SS Checked and Updated 
********************************************************************************
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta", clear
collapse (sum) ha_planted ha_harvest, by(hhid plot_id garden_id purestand area_meas_hectares season)
reshape long ha_, i(hhid plot_id garden_id purestand area_meas_hectares season) j(area_type) string
tempfile plot_areas
save `plot_areas'

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_cost_inputs_long.dta", clear
collapse (sum) cost_=val, by(hhid plot_id garden_id exp season) 
reshape wide cost_, i(hhid plot_id garden_id season) j(exp) string
merge 1:1 hhid plot_id garden_id season using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3)
recode cost_exp cost_imp (.=0)
gen cost_total=cost_imp+cost_exp
drop cost_imp
merge 1:m hhid plot_id garden_id season using `plot_areas', nogen keep(3)
gen cost_exp_ha_ = cost_exp/ha_ 
gen cost_total_ha_ = cost_total/ha_
collapse (mean) cost*ha_ [aw=area_meas_hectares], by(hhid dm_gender area_type)
gen dm_gender2 = "male"
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3 
//replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
replace area_type = "harvested" if strmatch(area_type,"harvest")
reshape wide cost*_, i(hhid dm_gender2) j(area_type) string
ren cost* cost*_
reshape wide cost*, i(hhid) j(dm_gender2) string
foreach i in male female mixed /*unknown*/ {
	foreach j in planted harvested {
		la var cost_exp_ha_`j'_`i' "Explicit cost per hectare by area `j', `i'-managed plots"
		la var cost_total_ha_`j'_`i' "Total cost per hectare by area `j', `i'-managed plots"
	}
}
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cropcosts.dta", replace
********************************************************************************
*USE OF INORGANIC FERTILIZER - SS  Updated 5-22-2024 
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_D.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_K.dta" 
gen use_inorg_fert=.
replace use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode use_inorg_fert (.=0)
ren gardenid garden_id
ren plotid plot_id
collapse (max) use_inorg_fert, by (hhid)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fert_use.dta", replace

*Fertilizer use by farmers (a farmer is an individual listed as plot manager)
use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_D.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_K.dta" 
gen all_use_inorg_fert=(ag_d38==1 | ag_k39==1)
ren ag_d01 farmerid
replace farmerid= ag_k02 if farmerid==.
ren plotid plot_id
ren gardenid garden_id
collapse (max) all_use_inorg_fert , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
recast str50 hhid
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_fert_use.dta", replace

********************************************************************************
*USE OF IMPROVED SEED - SS updated 6.15.24
********************************************************************************
//ALT: This section needs further review - some of the code is out of date
use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_G.dta", clear
gen season=0
append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_M.dta" 
recast str50 hhid
recode season (.=1)
ren gardenid garden_id
ren plotid plot_id
gen imprv_seed_use= ag_g0f==2 | ag_m0f==2 | ag_m0f==3
collapse (max) imprv_seed_use, by(hhid plot_id garden_id crop_code season)
tempfile imprv_seed
save `imprv_seed' //Will use this in a minute
collapse (max) imprv_seed_use, by(hhid crop_code) //AgQuery
*Use of seed by crop
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
	gen hybrid_seed_`cn'=.
}
collapse (max) imprv_seed_* hybrid_seed_*, by(hhid)
lab var imprv_seed_use "1 = Household uses improved seed"
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}
//Replacing permanent crop seed information with missing because this section does not ask about permanent crops 
//replace imprv_seed_cassav = .
//replace imprv_seed_banana = . 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_improvedseed_use.dta", replace // Not available in W3 */

use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_D.dta", clear 
gen season=0
append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_K.dta" 
recode season (.=1)
recast str50 hhid
ren plotid plot_id
ren gardenid garden_id
recast str50 hhid
merge 1:m hhid plot_id garden_id season using `imprv_seed', nogen
ren ag_d01 dm1
ren ag_d01_2a dm2
ren ag_d01_2b dm3 
ren ag_k02 dm0
ren ag_k02_2a dm0_2a
ren ag_k02_2b dm0_2b
keep hhid plot_id crop_code dm* imprv*
gen dummy=_n
reshape long dm, i(hhid plot_id crop_code imprv_seed_use dummy) j(idno)
drop idno
drop if dm==. //90,231 obs deleted 
collapse (max) imprv_seed_use, by(hhid crop_code dm)
ren dm indiv 
//To go to "wide" format:
egen cropmatch = anymatch(crop_code), values($topcrop_area)
keep if cropmatch==1
drop cropmatch
ren imprv_seed_use all_imprv_seed_
gen all_hybrid_seed_ = .
gen farmer_ = 1 //indiv update
gen cropname=""
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	replace cropname = "`cn'" if crop_code==`c'
}
drop crop_code
bys hhid indiv : egen all_imprv_seed_use = max(all_imprv_seed_)
reshape wide all_imprv_seed_ all_hybrid_seed_ farmer_, i(hhid all_imprv_seed_use indiv) j(cropname) string //indiv update
forvalues k=1/$nb_topcrops {
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	capture confirm var all_imprv_seed_`cn' //Checks for missing topcrops
	if _rc!=0 { 
		gen all_imprv_seed_`cn'=.
		gen all_hybrid_seed_`cn'=.
		gen `cn'_farmer=0
	}
}
gen all_hybrid_seed_use=.
ren farmer_* *_farmer 
drop if indiv==.
recode all_imprv_seed_* *_farmer (.=0) 
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", nogen //6,645 matched, 60,567 not matched
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
forvalues k=1/$nb_topcrops {
	local v : word `k' of $topcropname_area
	local vn : word `k' of $topcropname_area_full
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `vn'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `vn'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `vn'"
}
gen farm_manager=1 if indiv!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
/*Replacing permanent crop seed information with missing because this section does not ask about permanent crops
replace all_imprv_seed_cassav = . 
replace all_imprv_seed_banana = . */
//replace  all_imprv_seed_mango=. 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_improvedseed_use.dta", replace

 
********************************************************************************
* RATE OF FERTILIZER APPLICATION * -SS Checked and Updated 02-26-24
********************************************************************************
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_planted_area.dta", clear
merge 1:m hhid plot_id season using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3)
ren plot_id plotid
ren garden_id gardenid
merge 1:m hhid plotid gardenid using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", nogen keep (1 3)
merge 1:m hhid plotid gardenid using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", nogen keep (1 3)
merge 1:m hhid plotid gardenid using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", nogen keep (1 3)
merge m:1 hhid season using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_input_quantities.dta", nogen keep(1 3)
ren plotid plot_id
ren gardenid garden_id 
drop if ha_planted==0
//drop if plot_id=="" 
//replace season=1 if season==.
gen plot_irr=1 if ag_d28a !=7 //7 is no irrigation
replace plot_irr=1 if plot_irr==0 & ag_k29a != 7
recode plot_irr (.=0)
gen ha_irr = plot_irr * ha_planted
unab vars : *kg 
local vars `vars' ha_irr ha_planted

recode *kg (.=0)
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
//replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
ren *kg *kg_
ren ha_planted ha_planted_
ren ha_irr ha_irr_
drop ag_* _merge qx_type interview_status survey
reshape wide *_, i(hhid plot_id garden_id season) j(dm_gender2) string
//merge in weights merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_weights.dta", nogen // keep(1 3) 
collapse (sum) ha_planted_* *kg* ha_irr_*, by(hhid)
foreach i in `vars' {
	egen `i' = rowtotal(`i'_*)
}

//drop *_unknown
lab var inorg_fert_kg "Inorganic fertilizer (kgs) for household"
lab var org_fert_kg "Organic fertilizer (kgs) for household" 
lab var pest_kg "Pesticide (kgs) for household"
lab var herb_kg "Herbicide (kgs) for household"
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
lab var herb_kg_`i' "Herbicide (kgs) for `i'-managed plots"
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
save  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fertilizer_application.dta", replace

********************************************************************************
*HOUSEHOLD'S DIET DIVERSITY SCORE - CG Updated 3/3/25
********************************************************************************
* Malawi LSMS W3 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of households eating nutritious food can be estimated
* Constructing rCSI: stands for reduced coping strategies index and is a weighted total of the types of strategies a household uses to avoid insufficient food
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_h.dta" , clear
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
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_rcsi.dta", replace

* Constructing FCS: similar to HDDS but it adds in the last 7 days and weighted by food group 
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_g2.dta", clear
ren hh_g08a foodgroup_A
ren hh_g08b foodgroup_B
ren hh_g08c foodgroup_C
ren hh_g08d foodgroup_D
ren hh_g08e foodgroup_E
ren hh_g08f foodgroup_F
ren hh_g08g foodgroup_G
ren hh_g08h foodgroup_H
ren hh_g08i foodgroup_I
ren hh_g08j foodgroup_J
drop qx* interview_status survey
gen max_days = max(foodgroup_A, foodgroup_B)
gen min_days = min(foodgroup_A, foodgroup_B)
gen sum_days = foodgroup_A + foodgroup_B
gen fcs_a =.
replace fcs_a =7 if max_days==7
replace fcs_a=max_days if min_days==0
replace fcs_a=((max_days+min_days)/2) if sum_days>7
drop foodgroup_A foodgroup_B foodgroup_J *_days
ren fcs_a foodgroup_A
reshape long foodgroup_, i(hhid) j(foodgroup) string
rename foodgroup_ days
gen weight = .
replace weight = 2 if foodgroup=="A"  // max of A and B 
replace weight = 3 if foodgroup == "C"  // C
replace weight = 1 if foodgroup == "D" | foodgroup == "F" // D & F
replace weight = 4 if foodgroup == "E" | foodgroup == "G"  // E & G
replace weight = 0.5 if foodgroup == "H" | foodgroup == "I"  // H & I
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
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fcs.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_g1.dta" , clear
ren hh_g02 itemcode
drop if itemcode==829 | itemcode==830 | itemcode==837 //Restaurant meals and other.
* recode food items to map HDDS food categories
recode itemcode 	(101/117 820 835						=1	"CEREALS" )  //// VAP: Also includes biscuits, buns, scones
					(201/209 822 831/832 838 				=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(401/414	 							=3	"VEGETABLES"	)  ////	
					(601/610								=4	"FRUITS"	)  ////	
					(504/512 515 522 824/825				=5	"MEAT"	)  ////	VAP: 512: Tinned meat or fish, included in meat				
					(501 823 						  		=6	"EGGS"	)  ////
					(502/503 513/514 826 5021/5123			=7  "FISH") ///
					(301/313 833/834						=8	"LEGUMES, NUTS AND SEEDS") ///
					(701/709								=9	"MILK AND MILK PRODUCTS")  ////
					(801/804 821 827/828					=10	"OILS AND FATS"	)  ////
					(815/817 836							=11	"SWEETS"	)  //// 
					(901/916  810/814 818					=14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
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
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_rcsi.dta", nogen 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fcs.dta", nogen 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_household_diet.dta", replace

********************************************************************************
*WOMEN'S CONTROL OVER INCOME- SS Updated 2/12/24
********************************************************************************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*In most cases, MW LSMS 2 lists the first TWO decision makers.
*Indicator may be biased downward if some women would participate in decisions about the use of income
*but are not listed among the first two
 

/*
Areas of decision making to be considered
Decision-making areas
*Control over crop production income
*Control over livestock production income
*Control over fish production income
*Control over farm (all) production income
*Control over wage income
*Control over business income
*Control over nonfarm (all) income
*Control over (all) income
		
VAP: TZ-4 and MW-2 both also include 
	* Control over remittance income
	* Control over income from [program] assistance (social safety nets)

VAP: Added the following to the indicator construction for MW2
	* Control over other income (cash & in-kind transfers from individuals, pension, rental, asset sale, lottery, inheritance)	
*/

* First append all files with information on who control various types of income


use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_g.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_m.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_r1.dta"

* Control over Crop production income
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i.dta"  // control over crop sale earnings rainy season
// append using "${Malawi_IHPS_W2_appended_data}\Agriculture\ag_mod_ba_13.dta" // control over crop sale earnings rainy season
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_o.dta" // control over crop sale earnings dry season
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_p.dta" 

append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_q.dta"  // control over permanent crop sale earnings 

append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_r1.dta"
* Control over Livestock production income
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_s.dta" // control over livestock product sale earnings
* Control over wage income
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_e.dta" // control over salary payment, allowances/gratuities, ganyu labor earnings 
* Control over business income
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_n2.dta" // household enterprise ownership
* Control over program assistance 
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_r.dta"
* Control over other income 
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_p.dta"
* Control over remittances
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_o.dta"
gen type_decision="" 
gen controller_income1=. 
gen controller_income2=.

/* No question in MW3
* control of harvest from permanent crops
replace type_decision="control_permharvest" if  !inlist( ag6a_08_1, .,0,99) |  !inlist( ag6a_08_2, .,0,99) 
replace controller_income1=ag6a_08_1 if !inlist( ag6a_08_1, .,0,99)  
replace controller_income2=ag6a_08_2 if !inlist( ag6a_08_2, .,0,99)
replace type_decision="control_permharvest" if  !inlist( ag6b_08_1, .,0,99) |  !inlist( ag6b_08_2, .,0,99) 
replace controller_income1=ag6b_08_1 if !inlist( ag6b_08_1, .,0,99)  
replace controller_income2=ag6b_08_2 if !inlist( ag6b_08_2, .,0,99)
*/

* control of harvest from annual crops
replace type_decision="control_annualharvest" if  !inlist( ag_g14a, .,0,99) |  !inlist( ag_g14b, .,0,99) 
replace controller_income1=ag_g14a if !inlist( ag_g14a, .,0,99)  
replace controller_income2=ag_g14b if !inlist( ag_g14b, .,0,99)
replace type_decision="control_annualharvest" if  !inlist( ag_m13a, .,0,99) |  !inlist( ag_m13b, .,0,99) 
replace controller_income1=ag_m13a if !inlist( ag_m13a, .,0,99)  
replace controller_income2= ag_m13b if !inlist( ag_m13b, .,0,99)

* control annualsales
replace type_decision="control_annualsales" if  !inlist( ag_i14a, .,0,99) |  !inlist( ag_i14b, .,0,99) 
replace controller_income1=ag_i14a if !inlist(ag_i14a, .,0,99)  
replace controller_income2=ag_i14b if !inlist(ag_i14b, .,0,99)
replace type_decision="control_annualsales" if  !inlist(ag_o14a, .,0,99) |  !inlist( ag_o14b, .,0,99) 
replace controller_income1=ag_o14a if !inlist( ag_o14a, .,0,99)  
replace controller_income2=ag_o14b if !inlist( ag_o14b, .,0,99)
* append who controls earning from sale to customer 2 
preserve
replace type_decision="control_annualsales" if  !inlist( ag_i23a, .,0,99) |  !inlist( ag_i23b, .,0,99) 
replace controller_income1=ag_i23a if !inlist( ag_i23a, .,0,99)  
replace controller_income2=ag_i23b if !inlist( ag_i23b, .,0,99)
**No data for W3
/*replace type_decision="control_annualsales" if  !inlist( ag_o23a, .,0,99) |  !inlist( ag_o23b, .,0,99) 
replace controller_income1=ag_o23a if !inlist( ag_o23a, .,0,99)  
replace controller_income2=ag_o23b if !inlist( ag_o23b, .,0,99)
keep if !inlist( ag_i23a, .,0,99) |  !inlist( ag_i23b, .,0,99)  | !inlist( ag_o23a, .,0,99) |  !inlist( ag_o23b, .,0,99) */
keep hhid type_decision controller_income1 controller_income2
tempfile saletocustomer2
save `saletocustomer2'
restore
append using `saletocustomer2'
  
* control_permsales
replace type_decision="control_permsales" if  !inlist( ag_q14a, .,0,99) |  !inlist( ag_q14b, .,0,99) 
replace controller_income1=ag_q14a if !inlist( ag_q14a, .,0,99)  
replace controller_income2=ag_q14b if !inlist( ag_q14b, .,0,99)
replace type_decision="control_permsales" if  !inlist( ag_q23a, .,0,99) |  !inlist( ag_q23b, .,0,99) 
replace controller_income1=ag_q23a if !inlist( ag_q23a, .,0,99)  
replace controller_income2=ag_q23b if !inlist( ag_q23b, .,0,99)


* livestock_sales (products- Milk, egges, Meat) 
replace type_decision="control_livestocksales" if  !inlist( ag_s07a, .,0,99) |  !inlist( ag_s07b, .,0,99) 
replace controller_income1=ag_s07a if !inlist( ag_s07a, .,0,99)  
replace controller_income2=ag_s07b if !inlist( ag_s07b, .,0,99)

* Fish production income 
*No information available in MW3

* Business income 
* Malawi LSMS 3 did not ask directly about of who controls Business Income
* We are making the assumption that whoever owns the business might have some sort of control over the income generated by the business.
* We don't think that the business manager have control of the business income. If she does, she is probably listed as owner
* control_businessincome
replace type_decision="control_businessincome" if  !inlist( hh_n12a, .,0,99) |  !inlist( hh_n12b, .,0,99) 
replace controller_income1=hh_n12a if !inlist( hh_n12a, .,0,99)  
replace controller_income2=hh_n12b if !inlist( hh_n12b, .,0,99)

** --- Wage income --- * 
* Malawi 2 has questions on control over salary payments & allowances/gratuities in main + secondary job & ganyu earnings

* control_salary
replace type_decision="control_salary" if  !inlist( hh_e26_1a, .,0,99) |  !inlist( hh_e26_1b, .,0,99) // main wage job
replace controller_income1=hh_e26_1a if !inlist( hh_e26_1a , .,0,99)  
replace controller_income2=hh_e26_1b if !inlist( hh_e26_1b, .,0,99)
* append who controls salary earnings from secondary job
preserve
replace type_decision="control_salary" if  !inlist(hh_e40_1a , .,0,99) |  !inlist(hh_e40_1b, .,0,99) 
replace controller_income1=hh_e40_1a if !inlist( hh_e40_1a , .,0,99)  
replace controller_income2=hh_e40_1b if !inlist( hh_e40_1b, .,0,99)
keep if !inlist( hh_e40_1a, .,0,99) |  !inlist( hh_e40_1b, .,0,99)  
keep hhid type_decision controller_income1 controller_income2
tempfile wages2
save `wages2'
restore
append using `wages2'

* control_allowances
replace type_decision="control_allowances" if  !inlist(hh_e28_1a , .,0,99) |  !inlist(hh_e28_1b , .,0,99) 
replace controller_income1=hh_e28_1a if !inlist(hh_e28_1a , .,0,99)  
replace controller_income2=hh_e28_1b if !inlist(hh_e28_1b , .,0,99)
* append who controls  allowance/gratuity earnings from secondary job
preserve
replace type_decision="control_allowances" if  !inlist(hh_e42_1a , .,0,99) |  !inlist(hh_e42_1b , .,0,99) 
replace controller_income1=hh_e42_1a if !inlist( hh_e42_1a, .,0,99)  
replace controller_income2= hh_e42_1b if !inlist( , .,0,99)
keep if !inlist( hh_e42_1a, .,0,99) |  !inlist(hh_e42_1b , .,0,99)  //ALT 10.22.19: fixed typo, first hh_e42_1b -> hh_e42_1a
keep hhid type_decision controller_income1 controller_income2
tempfile allowances2
save `allowances2'
restore
append using `allowances2'

* control_ganyu
replace type_decision="control_ganyu" if  !inlist(hh_e59_1a , .,0,99) |  !inlist(hh_e59_1b , .,0,99) 
replace controller_income1= hh_e59_1a if !inlist( hh_e59_1a, .,0,99)  
replace controller_income2= hh_e59_1b if !inlist( hh_e59_1b, .,0,99)

* control_remittance
replace type_decision="control_remittance" if  !inlist( hh_o14_1a, .,0,99) |  !inlist( hh_o14_1b, .,0,99) 
replace controller_income1=hh_o14_1a if !inlist( hh_o14_1a, .,0,99)  
replace controller_income2=hh_o14_1b if !inlist( hh_o14_1b, .,0,99)
* append who controls in-kind remittances
preserve
replace type_decision="control_remittance" if  !inlist( hh_o18a, .,0,99) |  !inlist( hh_o18b, .,0,99) 
replace controller_income1=hh_o18a if !inlist( hh_o18a, .,0,99)  
replace controller_income2=hh_o18b if !inlist( hh_o18b, .,0,99)
keep if  !inlist( hh_o18a, .,0,99) |  !inlist( hh_o18b, .,0,99) 
keep hhid type_decision controller_income1 controller_income2
tempfile control_remittance2
save `control_remittance2'
restore
append using `control_remittance2'

* control_assistance income
replace type_decision="control_assistance" if  !inlist( hh_r05a, .,0,99) |  !inlist( hh_r05b, .,0,99) 
replace controller_income1=hh_r05a if !inlist( hh_r05a, .,0,99)  
replace controller_income2=hh_r05b if !inlist( hh_r05b, .,0,99)

* control_other income 
replace type_decision="control_otherincome" if  !inlist(hh_p04a , .,0,99) |  !inlist(hh_p04b , .,0,99) 
replace controller_income1=hh_p04a if !inlist(hh_p04a , .,0,99)  
replace controller_income2=hh_p04b if !inlist(hh_p04b , .,0,99) 

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


gen control_cropincome =  type_decision=="control_annualharvest" ///
							| type_decision=="control_annualsales" ///
							| type_decision=="control_permsales" ///
						
							
gen control_livestockincome =  type_decision=="control_livestocksales" 												

gen control_farmincome =  control_cropincome==1 | control_livestockincome==1							
							
gen control_businessincome = type_decision=="control_businessincome" 

gen control_salaryincome = type_decision=="control_salary"| type_decision=="control_allowances"| type_decision=="control_ganyu"						 
																					
gen control_nonfarmincome =  type_decision=="control_remittance" ///
							  | type_decision=="control_assistance" ///
							  | type_decision=="control_otherincome" /// VAP: additional in MW2
							  | control_salaryincome== 1 /// VAP: additional in MW2
							  | control_businessincome== 1 
																		
collapse (max) control_* , by(hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income indiv
*	Now merge with member characteristics
recast str50 hhid, force
merge 1:m hhid indiv  using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", nogen keep (3) // 6,445  matched

recode control_* (.=0)
lab var control_cropincome "1=individual has control over crop income"
lab var control_livestockincome "1=individual has control over livestock income"
lab var control_farmincome "1=individual has control over farm (crop or livestock) income"
lab var control_businessincome "1=individual has control over business income"
lab var control_salaryincome "1= individual has control over salary income"
lab var control_nonfarmincome "1=individual has control over non-farm (business, salary, assistance, remittances or other income) income"
lab var control_all_income "1=individual has control over at least one type of income"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_control_income.dta", replace

********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING- SS Checked and Updated 01-30-2024 (Needs Review)
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	In most cases, MLW LSMS 4 lists the first TWO decision makers.
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making

use  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta" 
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_g.dta"
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_m.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta"
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_o.dta"
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta"
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_p.dta"
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_q.dta"
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_r1.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.
gen decision_maker4=. 

* planting_input - Makes decision about plot Rainy Season
*Decisions concerning the timing of cropping activities, crop choice and input use on the [PLOT]
replace type_decision="planting_input" if !inlist(ag_d01, .,0,99) | !inlist(ag_d01_2a, .,0,99) | !inlist(ag_d01_2b, .,0,99)
replace decision_maker1=ag_d01 if !inlist(ag_d01, .,0,99, 98)
replace decision_maker2=ag_d01_2a if !inlist(ag_d01_2a, .,0,99, 98)
replace decision_maker3=ag_d01_2b if !inlist(ag_d01_2b, .,0,99, 98)

* Makes decision about plot dry Season
replace type_decision="planting_input" if !inlist(ag_k02, .,0,99) | !inlist(ag_k02_2a, .,0,99) | !inlist(ag_k02_2b, .,0,99)
replace decision_maker1=ag_k02 if !inlist(ag_k02, .,0,99, 98) 
replace decision_maker2=ag_k02_2a if !inlist(ag_k02_2a, .,0,99, 98) 
replace decision_maker3=ag_k02_2b if !inlist(ag_k02_2b, .,0,99, 98)  

* append who make decision about (owner plot) rainy
preserve
replace type_decision="planting_input" if !inlist(ag_b204_2__0, .,0,99) | !inlist(ag_b204_2__1, .,0,99) | !inlist(ag_b204_2__2, .,0,99) | !inlist(ag_b204_2__3, .,0,99)
replace decision_maker1=ag_b204_2__0 if !inlist(ag_b204_2__0, .,0,99, 98) 
replace decision_maker2=ag_b204_2__1 if !inlist(ag_b204_2__1, .,0,99, 98) 
replace decision_maker3=ag_b204_2__2 if !inlist(ag_b204_2__2, .,0,99, 98) 
replace decision_maker4=ag_b204_2__3 if !inlist(ag_b204_2__3, .,0,99, 98) 

* append who make decision about (owner plot) dry
replace type_decision="planting_input" if !inlist(ag_i204a_1, .,0,99) | !inlist(ag_i204a_2, .,0,99) | !inlist(ag_i204a_3, .,0,99) | !inlist(ag_i204a_4, .,0,99)
replace decision_maker1=ag_i204a_1 if !inlist(ag_i204a_1, .,0,99, 98) 
replace decision_maker2=ag_i204a_2 if !inlist(ag_i204a_2, .,0,99, 98) 
replace decision_maker3=ag_i204a_3 if !inlist(ag_i204a_3, .,0,99, 98) 
replace decision_maker4=ag_i204a_4 if !inlist(ag_i204a_4, .,0,99, 98) 


keep if !inlist(ag_b204_2__0, .,0,99) | !inlist(ag_b204_2__1, .,0,99) | !inlist(ag_b204_2__2, .,0,99) | !inlist(ag_b204_2__3, .,0,99)| !inlist(ag_i204a_1, .,0,99)| !inlist(ag_i204a_2, .,0,99) | !inlist(ag_i204a_3, .,0,99)| !inlist(ag_i204a_4, .,0,99)


keep hhid type_decision decision_maker*
tempfile planting_input1
save `planting_input1'
restore
append using `planting_input1' 
 
*Decisions concerning harvested crop Rainy
replace type_decision="harvest"  if !inlist(ag_g14a, .,0,99) | !inlist(ag_g14b, .,0,99)
replace decision_maker1=ag_g14a if  !inlist( ag_g14a, .,0,99, 98)
replace decision_maker2=ag_g14b if  !inlist( ag_g14b, .,0,99, 98)

*Decisions concerning harvested crop Dry 
replace type_decision="harvest" if !inlist(ag_m13a, .,0,99) | !inlist(ag_m13b, .,0,99) 
replace decision_maker1=ag_m13a if !inlist( ag_m13a, .,0,99, 98)
replace decision_maker2=ag_m13b if !inlist( ag_m13b, .,0,99, 98)

*Livestock owners
replace type_decision="livestockowners" if !inlist(ag_r05a, .,0,99) | !inlist(ag_r05b, .,0,99)
replace decision_maker1=ag_r05a if !inlist(ag_r05a, .,0,99) 
replace decision_maker2=ag_r05b if !inlist(ag_r05b, .,0,99) 

/*Wave 3 doesn't have data for who negotiated
/*replace type_decision="sales_annualcrop" if !inlist(ag_i12_1a, .,0,99) | !inlist(ag_i12_1b, .,0,99)
replace decision_maker1=ag_i12_1a if !inlist(ag_i12_1a, .,0,99) 
replace decision_maker2=ag_i21_1a if !inlist(ag_i12_1b, .,0,99) 

replace type_decision="sales_annualcrop" if !inlist(ag_i21_1a, .,0,99) | !inlist(ag_i21_1b, .,0,99)
replace decision_maker1=ag_i21_1a if !inlist(ag_i21_1a, .,0,99) 
replace decision_maker2=ag_i21_1b if !inlist(ag_i21_1b, .,0,99)

* append who make negotiate sale to customer 2
preserve
replace type_decision="sales_annualcrop" if !inlist(ag_o12_1a, .,0,99) | !inlist(ag_o12_1b, .,0,99)
replace decision_maker1=ag_o12_1a if !inlist(ag_o12_1a, .,0,99) 
replace decision_maker2=ag_o21_1a if !inlist(ag_o12_1b, .,0,99) 

replace type_decision="sales_annualcrop" if !inlist(ag_o21_1a, .,0,99) | !inlist(ag_o21_1b, .,0,99)
replace decision_maker1=ag_o21_1a if !inlist(ag_o21_1a, .,0,99) 
replace decision_maker2=ag_o21_1b if !inlist(ag_o21_1b, .,0,99)
keep if !inlist(ag_o12_1a, .,0,99) | !inlist(ag_o12_1b, .,0,99) | !inlist(ag_o21_1a, .,0,99) | !inlist(ag_o21_1b, .,0,99)*/ 

keep hhid type_decision decision_maker* 
tempfile sales_annualcrop2
save `sales_annualcrop2'
append using `sales_annualcrop2' */

keep hhid type_decision decision_maker1 decision_maker2 decision_maker3 decision_maker4 
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
preserve
keep hhid type_decision decision_maker4
drop if decision_maker4==.
ren decision_maker4 decision_maker
tempfile decision_maker4
save `decision_maker4'
restore

keep hhid type_decision decision_maker1
drop if decision_maker1==.
ren decision_maker1 decision_maker
append using `decision_maker2'
append using `decision_maker3'
append using `decision_maker4'
* number of time appears as decision maker
bysort hhid decision_maker : egen nb_decision_participation=count(decision_maker)
drop if nb_decision_participation==1
gen make_decision_crop=1 if  type_decision=="planting_input" ///
							| type_decision=="harvest" ///
							/*| type_decision=="sales_annualcrop" ///
							| type_decision=="sales_processcrop"*/
recode 	make_decision_crop (.=0)
gen make_decision_livestock=1 if  type_decision=="livestockowners"   
recode 	make_decision_livestock (.=0)
gen make_decision_ag=1 if make_decision_crop==1 | make_decision_livestock==1
recode 	make_decision_ag (.=0)
collapse (max) make_decision_* , by(hhid decision_maker )  //any decision
ren decision_maker indiv 
* Now merge with member characteristics
recast str50 hhid, force
merge 1:1 hhid indiv  using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", nogen // 4,747   matched
* 1 member ID in decision files not in member list
recode make_decision_* (.=0)
lab var make_decision_crop "1=invidual makes decision about crop production activities"
lab var make_decision_livestock "1=invidual makes decision about livestock production activities"
lab var make_decision_ag "1=invidual makes decision about agricultural (crop or livestock) production activities"

save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_make_ag_decision.dta", replace

********************************************************************************
*WOMEN'S OWNERSHIP OF ASSETS*
********************************************************************************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* MWI W1 asked to list the first TWO owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets

*First, append all files with information on asset ownership
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear //rainy
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta" //dry
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_r1.dta"
gen type_asset=""
gen asset_owner1=.
gen asset_owner2=.
gen asset_owner3=.
gen asset_owner4=.

* Ownership of land.
replace type_asset="landowners" if  !inlist( ag_b204_2__0, .,0,99) |  !inlist( ag_b204_2__1, .,0,99) |  !inlist( ag_b204_2__2, .,0,99) |  !inlist( ag_b204_2__3, .,0,99)
replace asset_owner1=ag_b204_2__0 if !inlist(ag_b204_2__0, .,0,99)  
replace asset_owner2=ag_b204_2__1 if !inlist( ag_b204_2__1, .,0,99)
replace asset_owner3=ag_b204_2__2 if !inlist( ag_b204_2__2, .,0,99)
replace asset_owner4=ag_b204_2__3 if !inlist( ag_b204_2__3, .,0,99)

replace type_asset="landowners" if  !inlist( ag_i204a_1, .,0,99) |  !inlist( ag_i204a_2, .,0,99) |  !inlist( ag_i204a_3, .,0,99) |  !inlist( ag_i204a_4, .,0,99) 
replace asset_owner1= ag_i204a_1 if !inlist(  ag_i204a_1, .,0,99)  
replace asset_owner2= ag_i204a_2 if !inlist(  ag_i204a_2, .,0,99)
replace asset_owner3= ag_i204a_3 if !inlist(  ag_i204a_3, .,0,99)
replace asset_owner4= ag_i204a_4 if !inlist(  ag_i204a_4, .,0,99)

preserve
replace type_asset="landowners" if  !inlist( ag_b204_6a__0, .,0,99) |  !inlist( ag_b204_6a__1, .,0,99) |  !inlist( ag_b204_6a__2, .,0,99) |  !inlist( ag_b204_6a__3, .,0,99) 
replace asset_owner1=ag_b204_6a__0 if !inlist(ag_b204_6a__0, .,0,99)
replace asset_owner2=ag_b204_6a__1 if !inlist( ag_b204_6a__1, .,0,99)
replace asset_owner3=ag_b204_6a__2 if !inlist( ag_b204_6a__2, .,0,99)
replace asset_owner4=ag_b204_6a__3 if !inlist( ag_b204_6a__3, .,0,99)

replace type_asset="landowners" if  !inlist( ag_i204_6a_1, .,0,99) |  !inlist( ag_i204_6a_2, .,0,99) |  !inlist( ag_i204_6a_3, .,0,99) |  !inlist( ag_i204_6a_4, .,0,99) 
replace asset_owner1=ag_i204_6a_1 if !inlist(ag_i204_6a_1, .,0,99)
replace asset_owner2=ag_i204_6a_2 if !inlist( ag_i204_6a_2, .,0,99)
replace asset_owner3=ag_i204_6a_3 if !inlist( ag_i204_6a_3, .,0,99)
replace asset_owner4=ag_i204_6a_4 if !inlist( ag_i204_6a_4, .,0,99)
keep hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'

*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( ag_r05a, .,0,99) |  !inlist( ag_r05b, .,0,99)  
replace asset_owner1=ag_r05a if !inlist( ag_r05a, .,0,99)  
replace asset_owner2=ag_r05b if !inlist( ag_r05b, .,0,99)

* non-farm equipment,  large durables/appliances, mobile phone
// Module M: FARM IMPLEMENTS, MACHINERY, AND STRUCTURES - does not report who in the household own them
// No ownership information regarding non-farm equipment,  large durables/appliances, mobile phone

keep hhid type_asset asset_owner1 asset_owner2 asset_owner3 asset_owner4

preserve
keep hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore

preserve
keep hhid type_asset asset_owner3
drop if asset_owner3==.
ren asset_owner3 asset_owner
tempfile asset_owner3
save `asset_owner3'
restore

preserve
keep hhid type_asset asset_owner4
drop if asset_owner4==.
ren asset_owner4 asset_owner
tempfile asset_owner4
save `asset_owner4'
restore

keep hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
append using `asset_owner3'
append using `asset_owner4'
gen own_asset=1 
collapse (max) own_asset, by (hhid asset_owner)
ren asset_owner indiv

* Now merge with member characteristics
merge 1:1 hhid indiv  using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", nogen 
recode own_asset (.=0)
recode hh_head (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ownasset.dta", replace
********************************************************************************
*AGRICULTURAL WAGES SS Updated 5-22-2024
********************************************************************************

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_labor_long.dta", clear
keep if strmatch(labor_type,"hired") & (strmatch(gender,"male") | strmatch(gender,"female"))
collapse (sum) wage_paid_aglabor_=val hired_=days, by(hhid gender)
reshape wide wage_paid_aglabor_ hired_, i (hhid ) j(gender) string
egen wage_paid_aglabor = rowtotal(wage*)
egen hired_all = rowtotal(hired*)
lab var wage_paid_aglabor "Daily agricultural wage paid for hired labor (local currency)"
lab var wage_paid_aglabor_female "Daily agricultural wage paid for hired labor - female workers(local currency)"
lab var wage_paid_aglabor_male "Daily agricultural wage paid for hired labor - male workers (local currency)"
lab var hired_all "Total hired labor (number of persons days)"
lab var hired_female "Total hired labor (number of persons days) -female workers"
lab var hired_male "Total hired labor (number of persons days) -male workers"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_ag_wage.dta", replace

********************************************************************************
*CROP YIELDS* SS Completed 02/26/2024
********************************************************************************
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta", clear
gen number_trees_planted_banana = number_trees_planted if crop_code == 55
recode crop_code (52 53 54 56 57 58 59 60 61 62 63 64=100) // recode to "other fruit":  mango, orange, papaya, avocado, guava, lemon, tangerine, peach, poza, masuku, masau, pineapple
*global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea" global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
gen number_trees_planted_other_fruit = number_trees_planted if crop_code == 100
gen number_trees_planted_cassava = number_trees_planted if crop_code == 49
gen number_trees_planted_tea = number_trees_planted if crop_code == 50
gen number_trees_planted_coffee = number_trees_planted if crop_code == 51 
gen number_trees_planted_mango = number_trees_planted if crop_code == 52
recode number_trees_planted_banana number_trees_planted_other_fruit number_trees_planted_cassava number_trees_planted_mango number_trees_planted_tea number_trees_planted_coffee (.=0)
collapse (sum) number_trees_planted*, by(hhid)
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_trees.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta", clear
gen no_harvest=ha_harvest==.
ren quant_harv_kg harvest 
ren ha_planted area_plan
ren ha_harvest area_harv 
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
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_area_plan.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_all_plots.dta", clear
//Legacy stuff- agquery gets handled above.
collapse (sum) area_harv_=ha_harvest area_plan_=ha_planted harvest_=quant_harv_kg, by(hhid dm_gender purestand crop_code)
drop if purestand == .
gen mixed = "inter" if purestand==0
replace mixed="pure" if purestand==1
gen dm_gender2="male"
replace dm_gender2="female" if dm_gender==2
replace dm_gender2="mixed" if dm_gender==3
drop dm_gender purestand
duplicates tag hhid dm_gender2 crop_code mixed, gen(dups) // temporary measure while we work on plot_decision_makers
drop if dups > 0 // temporary measure while we work on plot_decision_makers
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


*Total planted and harvested area summed accross all plots, crops, and seasons.
preserve
	collapse (sum) all_area_harvested=area_harv all_area_planted=area_plan, by(hhid)
	replace all_area_harvested=all_area_planted if all_area_harvested>all_area_planted & all_area_harvested!=.
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_area_planted_harvested_allcrops.dta", replace
restore
keep if inlist(crop_code, $comma_topcrop_area)
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_crop_harvest_area_yield.dta", replace

*Yield at the household level
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_crop_harvest_area_yield.dta", clear
//ren crop_code_long crop_code

*Value of crop production
merge m:1 crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cropname_table.dta", nogen keep(1 3)
merge m:1 hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_values_production.dta", nogen keep(1 3)
ren value_crop_production value_harv_
ren value_crop_sales value_sold_
foreach i in harvest area {
	ren `i'* `i'*_
}
gen total_planted_area_ = area_plan_
gen total_harv_area_ = area_harv_ 
gen kgs_harvest_ = harvest_
drop crop_code*
unab vars : *_
reshape wide `vars', i(hhid) j(crop_name) string 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_trees.dta"
collapse (sum) harvest* area_harv*  area_plan* total_planted_area* total_harv_area* kgs_harvest*   value_harv* value_sold* number_trees_planted*  , by(hhid) 
recode harvest*   area_harv* area_plan* kgs_harvest* total_planted_area* total_harv_area*    value_harv* value_sold* (0=.)
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

foreach p of global topcropname_area {
	gen grew_`p'=(total_harv_area_`p'!=. & total_harv_area_`p'!=.0 ) | (total_planted_area_`p'!=. & total_planted_area_`p'!=.0)
	lab var grew_`p' "1=Household grew `p'" 
	gen harvested_`p'= (total_harv_area_`p'!=. & total_harv_area_`p'!=.0 )
	lab var harvested_`p' "1= Household harvested `p'"
}
//replace grew_banana =1 if  number_trees_planted_banana!=0 & number_trees_planted_banana!=. 
//replace grew_cassav =1 if number_trees_planted_cassav!=0 & number_trees_planted_cassava!=. 
//replace grew_mango =1 if number_trees_planted_mango!=0 & number_trees_planted_mango!=.
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_yield_hh_crop_level.dta", replace

* VALUE OF CROP PRODUCTION  // using 335 output
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_values_production.dta", clear //need another file? 
*Grouping following IMPACT categories but also mindful of the consumption categories.
//ren crop_code crop_code
gen crop_group=""
replace crop_group=	"Maize"	if crop_code==	1
replace crop_group=	"Other other"	if crop_code==	5 //tobacco 
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
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	38 //sunflower
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
replace crop_group=	"Bananas"	if crop_code==	55 //banana
replace crop_group=	"Fruits"	if crop_code==	56 //avocado
replace crop_group=	"Fruits"	if crop_code==	57 //guava
replace crop_group=	"Fruits"	if crop_code==	58 //lemon
replace crop_group=	"Fruits"	if crop_code==	59 //tangerine
replace crop_group=	"Fruits"	if crop_code==	60 //peach
replace crop_group=	"Fruits"	if crop_code==	61 //poza
replace crop_group=	"Fruits"	if crop_code==	62 //masuku
replace crop_group=	"Fruits"	if crop_code==	63 //masau
replace crop_group=	"Other nuts, seeds, and pulses"	if crop_code==	65 //macademia 
replace crop_group=	"Other other"	if crop_code==	1800 //fodder trees
replace crop_group=	"Other other"	if crop_code==	1900 //fertilizer trees 
replace crop_group=	"Other other"	if crop_code==	2000 //fuel wood trees 
ren  crop_group commodity

*High/low value crops
gen type_commodity=""
* CJS 10.21 revising commodity high/low classification
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
	ren value_`s'1 value_`s'_bana
	ren value_`s'2 value_`s'_beanc
	ren value_`s'3 value_`s'_casav
	ren value_`s'4 value_`s'_coton
	ren value_`s'5 value_`s'_fruit
	ren value_`s'6 value_`s'_gdnut
	ren value_`s'7 value_`s'_maize
	ren value_`s'8 value_`s'_mill 
	ren value_`s'9 value_`s'_onuts
	ren value_`s'10 value_`s'_oths
	ren value_`s'11 value_`s'_pota 
	ren value_`s'12 value_`s'_rice 
	ren value_`s'13 value_`s'_sorg
	ren value_`s'14 value_`s'_sybea 
	ren value_`s'15 value_`s'_spice
	ren value_`s'16 value_`s'_suga
	ren value_`s'17 value_`s'_spota
	ren value_`s'18 value_`s'_tea
	ren value_`s'19 value_`s'_vegs
	ren value_`s'20 value_`s'_whea
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
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_values_production_grouped.dta", replace
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
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_values_production_type_crop.dta", replace

********************************************************************************
*SHANNON DIVERSITY INDEX SS Updated 02/26/24
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_crop_area_plan.dta", clear
/*gen area_plan = area_plan_pure_hh + area_plan_inter_hh
foreach i in male female mixed { 
	egen area_plan_`i' = rowtotal(area_plan_*_`i')
}
*/
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
drop if area_plan==0
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_crop_area_plan_shannon.dta", nogen		//all matched
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
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_shannon_diversity_index.dta", replace

	
********************************************************************************
*CONSUMPTION -- SS Checked and Updated 11-21-2023, CG updated 8.21.24
******************************************************************************** 
use "${MWI_IHS_IHPS_W3_appended_data}/IHS4 Consumption Aggregate.dta", clear 
gen intmonth =. 
replace intmonth = 4 if strpos(interviewDate, "-04-") > 0
replace intmonth = 5 if strpos(interviewDate, "-05-") > 0
replace intmonth = 6 if strpos(interviewDate, "-06-") > 0
replace intmonth = 7 if strpos(interviewDate, "-07-") > 0
replace intmonth = 8 if strpos(interviewDate, "-08-") > 0
replace intmonth = 9 if strpos(interviewDate, "-09-") > 0
replace intmonth = 10 if strpos(interviewDate, "-10-") > 0
replace intmonth = 11 if strpos(interviewDate, "-11-") > 0
replace intmonth = 12 if strpos(interviewDate, "-12-") > 0
replace intmonth = 1 if strpos(interviewDate, "-01-") > 0
replace intmonth = 2 if strpos(interviewDate, "-02-") > 0
replace intmonth = 3 if strpos(interviewDate, "-03-") > 0
ren ea_id ea
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_intmonth_consumption_aggregate.dta", replace
keep ea district
duplicates drop 
tempfile ea_filt
save `ea_filt'
*check bid for section on consumption aggregate, if there is no information, try going down a geographic level and check SD (it should be 0)
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_intmonth_consumption_aggregate.dta", clear
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep (3)
preserve
collapse (mean) price_index_district=price_index (sd) price_index_sd=price_index /*(min) price_index_min=price_index (max) price_index_max=price_index*/ [aw=weight], by(district intmonth)
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_price_index_lookup_district.dta", replace
restore
collapse (mean) price_index_ea=price_index [aw=weight], by(ea district intmonth)
fillin ea district intmonth //This will create a bunch of spurious ea-district combinations.
merge m:1 ea district using `ea_filt', keep(3)
merge m:1 district intmonth using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_price_index_lookup_district.dta", nogen keep (3)
gen price_index=price_index_ea
replace price_index=price_index_district if price_index ==.
keep ea intmonth price_index
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_price_index_lookup.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_g1.dta", clear
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
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen	
keep hhid weight price_unit unit* qty* itemcode region district ta ea
gen country = "MWI" 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cons_value.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cons_value.dta", clear
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
	
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cons_value.dta", clear
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
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep (1 3)
merge m:1 hhid using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_a_filt.dta", nogen keep(1 3)	
merge m:1 hhid using "${MWI_IHS_IHPS_W3_appended_data}\hh_metadata.dta", nogen keep(1 3)  
gen interviewdate = moduleG_start_date 
gen intmonth=.
replace intmonth = 1 if strpos(interviewdate, "-01-") > 0
replace intmonth = 2 if strpos(interviewdate, "-02-") > 0
replace intmonth = 3 if strpos(interviewdate, "-03-") > 0
replace intmonth = 4 if strpos(interviewdate, "-04-") > 0
replace intmonth = 5 if strpos(interviewdate, "-05-") > 0
replace intmonth = 6 if strpos(interviewdate, "-06-") > 0
replace intmonth = 7 if strpos(interviewdate, "-07-") > 0
replace intmonth = 8 if strpos(interviewdate, "-08-") > 0
replace intmonth = 9 if strpos(interviewdate, "-09-") > 0
replace intmonth = 10 if strpos(interviewdate, "-10-") > 0
replace intmonth = 11 if strpos(interviewdate, "-11-") > 0
replace intmonth = 12 if strpos(interviewdate, "-12-") > 0
keep intmonth hhid val_fdcons district region ea
merge m:m ea intmonth using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_price_index_lookup.dta", nogen keep(1 3) 
gen missing_p_index = price_index ==.
gen intmonth_orig=intmonth
replace intmonth=intmonth-1 if missing_p_index == 1
replace intmonth=2 if intmonth==0
rename price_index price_index1
merge m:m ea intmonth using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_price_index_lookup.dta", nogen keep(1 3) //28,038 matched, 2,511 not matched
replace price_index1=price_index if price_index1==.
drop price_index
rename price_index1 price_index
gen imputed=missing_p_index & price_index !=.
gen price_fdcons = (price_index/100)*val_fdcons 
keep hhid val_fdcons district region district intmonth price_index price_fdcons ea
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_food_consumption.dta", replace
merge m:1 ea hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_intmonth_consumption_aggregate.dta", nogen keep(3)
gen annual_val_fdcons=(val_fdcons*52)
sum annual_val_fdcons
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_agg_consumption.dta", replace 

use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_i1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_i2.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_j.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_k1.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_k2.dta"
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
keep hhid rexp*
ren rexp* rexp*new
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_intmonth_consumption_aggregate.dta", nogen keep(3)
*Our method produces differnces from the World Bank consumption method. This code allows you to compare both panel and cross section. 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_aggregate_consumption.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}/IHS4 Consumption Aggregate.dta", clear 
ren expagg total_cons // using real consumption-adjusted for region price disparities -- this is nominal (but other option was per capita vs hh-level). 
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hhsize)
gen daily_peraeq_cons = peraeq_cons/365 
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq 
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_consumption.dta", replace

***************************************************************************
*HOUSEHOLD FOOD PROVISION* - CG updated 3.4.2025 
***************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}/hh_mod_a_filt.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_H.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_appended_data}\hh_metadata.dta", nogen
gen int_month_s = substr(moduleH_start_date, 6, 2)
gen int_month = real(int_month_s)
*Replacing int_month and int_year with interviewdate_v1 and v2 to cover IHPS households
replace int_month = 4 if strpos(interviewdate_v1, "-04-") > 0
replace int_month = 5 if strpos(interviewdate_v1, "-05-") > 0
replace int_month = 6 if strpos(interviewdate_v1, "-06-") > 0
replace int_month = 7 if strpos(interviewdate_v1, "-07-") > 0
replace int_month = 8 if strpos(interviewdate_v1, "-08-") > 0
replace int_month = 1 if strpos(interviewdate_v2, "-01-") > 0
replace int_month = 2 if strpos(interviewdate_v2, "-02-") > 0
replace int_month = 3 if strpos(interviewdate_v2, "-03-") > 0
replace int_month = 4 if strpos(interviewdate_v2, "-04-") > 0
replace int_month = 8 if strpos(interviewdate_v2, "-08-") > 0
replace int_month = 9 if strpos(interviewdate_v2, "-09-") > 0
replace int_month = 10 if strpos(interviewdate_v2, "-10-") > 0
replace int_month = 11 if strpos(interviewdate_v2, "-11-") > 0
replace int_month = 12 if strpos(interviewdate_v2, "-12-") > 0
gen int_year_s = substr(moduleH_start_date, 1, 4)
gen int_year = real(int_year)
replace int_year = 2016 if strpos(interviewdate_v1, "2016") > 0
replace int_year = 2016 if strpos(interviewdate_v2, "2016") > 0
replace int_year = 2017 if strpos(interviewdate_v2, "2017") > 0
preserve
keep hhid int_month int_year survey
tempfile int_meta
save `int_meta'
restore
foreach let in a b c d e f g h i j k l m n o p q r s t u v w x y {
 replace hh_h05`let' = "" if hh_h04 == 2
}
gen apr_2015 = hh_h05a == "X" if int_month <  5 & int_year!=2017
gen may_2015 = hh_h05b == "X" if int_month <  6 & int_year!=2017
gen jun_2015 = hh_h05c == "X" if int_month <  7 & int_year!=2017 
gen jul_2015 = hh_h05d == "X" if int_month <  8 & int_year!=2017
gen aug_2015 = hh_h05e == "X" if int_month <  9 & int_year!=2017
gen sep_2015 = hh_h05f == "X" if int_month < 10 & int_year!=2017
gen oct_2015 = hh_h05g == "X" if int_month < 11 & int_year!=2017
gen nov_2015 = hh_h05h == "X" if int_month < 12 & int_year!=2017
gen dec_2015 = hh_h05i == "X" if int_year!=2017
gen jan_2016 = hh_h05j == "X" if (int_month > 1 & int_year==2016) | (int_month < 2 & int_year==2017)
gen feb_2016 = hh_h05k == "X" if (int_month > 2 & int_year==2016) | (int_month < 3 & int_year==2017)
gen mar_2016 = hh_h05l == "X" if (int_month > 3 & int_year==2016) | (int_month < 4 & int_year==2017)
gen apr_2016 = hh_h05m == "X" if (int_month > 4 & int_year==2016) | (int_month < 5 & int_year==2017)
gen may_2016 = hh_h05n == "X" if int_month >  5 | int_year==2017
gen jun_2016 = hh_h05o == "X" if int_month >  6 | int_year==2017
gen jul_2016 = hh_h05p == "X" if int_month >  7 | int_year==2017
gen aug_2016 = hh_h05q == "X" if int_month >  8 | int_year==2017
gen sep_2016 = hh_h05r == "X" if int_month >  9 | int_year==2017
gen oct_2016 = hh_h05s == "X" if int_month > 10 | int_year==2017
gen nov_2016 = hh_h05t == "X" if int_month > 11 | int_year==2017
gen dec_2016 = hh_h05u == "X" if int_year == 2017
gen jan_2017 = hh_h05v == "X" if int_year == 2017 & int_month > 1
gen feb_2017 = hh_h05w == "X" if int_year == 2017 & int_month > 2
gen mar_2017 = hh_h05x == "X" if int_year == 2017 & int_month > 3
gen apr_2017 = hh_h05y == "X" if int_year == 2017 & int_month > 4
egen months_food_insec=rowtotal(apr_2015-apr_2017)
replace months_food_insec=. if survey=="IHPS"
keep hhid  months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_months_food_insufficient.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}/hh_mod_a_filt.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_appended_data}/hh_mod_h.dta", nogen
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
keep ea_id hhid days_nofd rcsi* int*
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_months_food_insufficient.dta", nogen
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_food_insecurity.dta", replace

***************************************************************************
*HOUSEHOLD ASSETS* - SS Checked and Updated 11-20-2023 
***************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_L.dta", clear
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 number_items_owned
gen value_assets = value_today*number_items_owned
collapse (sum) value_assets, by(hhid)
la var value_assets "Value of household assets"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_assets.dta", replace 

********************************************************************************
*FOOD SECURITY*- SS Updated 02-24-24, CG checked 8.21.24
********************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}/IHS4 Consumption Aggregate.dta", clear
ren rexp_cat011 fdconstot
gen daily_per_aeq_fdcons = fdconstot / adulteq / 365
gen daily_percap_fdcons = fdconstot / hhsize / 365
keep case_id ea region urban district hhsize adulteq fdconstot daily_per_aeq_fdcons daily_percap_fdcons
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_food_cons.dta", replace

********************************************************************************
*HOUSEHOLD VARIABLES
********************************************************************************
//setting up empty variable list: create these with a value of missing and then recode all of these to missing at the end of the HH section (some may be recoded to 0 in this section)
global empty_vars ""
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_weights.dta", clear

*Gross crop income 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_crop_production.dta" 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_crop_losses.dta", nogen keep(1 3)
recode value_crop_production crop_value_lost (.=0)

merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_plot_cost_inputs.dta", nogen

*Production by group and type of crops0
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_crop_values_production_grouped.dta", nogen 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_crop_values_production_type_crop.dta", nogen 
recode value_pro* value_sal* (.=0)
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_cost_inputs.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_yield_hh_crop_level.dta", nogen 


*Crop costs
//Merge in summarized crop costs:
gen crop_production_expenses = val_exp
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue (value of production minus crop expenses)"
*top crop costs by area planted

foreach c in $topcropname_area {
	merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_inputs_`c'.dta", nogen
	merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_`c'_monocrop_hh_area.dta", nogen
}

global empty_crops ""

foreach c in $topcropname_area {
	//ALT 07.23.21: Because variable names are similar, we can use wildcards to collapse and avoid mentioning missing variables by name.
capture confirm var `c'_monocrop //Check to make sure this isn't empty.
if !_rc {
	egen `c'_exp = rowtotal(val_*_`c'_hh) //Only explicit costs for right now; add "exp" and "imp" tag to variables to disaggregate in future 

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
		gen `c'_monocrop=.
		gen `c'_exp=.
		gen `c'_monocrop_ha=.
		foreach i in male female mixed {
		gen `c'_exp_`i' = .
		}
	}
	lab var `c'_exp "Crop production costs(explicit)-Monocrop `c' plots only"
	la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household"		
}

*Land rights
merge 1:1 hhid using   "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_land_rights_hh.dta", nogen keep(1 3)
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)" 

*Fish income
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fish_income.dta", nogen keep(1 3)
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fishing_expenses_1.dta", nogen keep(1 3)
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fishing_expenses_2.dta", nogen keep(1 3)
gen fishing_income = value_fish_harvest - cost_fuel - rental_costs_fishing - cost_paid
lab var fishing_income "Net fish income"
drop cost_fuel rental_costs_fishing cost_paid

*Livestock income
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_livestock_sales.dta", nogen keep(1 3)
merge 1:1 hhid  using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_livestock_expenses.dta", nogen keep(1 3)
merge 1:1 hhid using   "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_hh_livestock_products", nogen keep (1 3)
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_manure.dta", nogen
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_TLU.dta", nogen keep(1 3)
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_herd_characteristics.dta", nogen keep(1 3)
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_TLU_Coefficients.dta", nogen keep(1 3)

recode value_livestock_sales value_livestock_purchases value_milk_produced  value_eggs_produced sales_manure value_other_produced cost_hired_labor_livestock cost_fodder_livestock  (.=0)
gen livestock_income = value_livestock_sales - value_livestock_purchases + ( value_milk_produced + value_eggs_produced + value_other_produced) - ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock )
recode livestock_income (.=0)
lab var livestock_income "Net livestock income (value of production and consumption minus expenditures)"
gen livestock_expenses = ( cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock)
lab var livestock_expenses "Expenditures on livestock purchases and maintenance"
ren cost_vaccines_livestock ls_exp_vac 
gen livestock_product_revenue = ( value_milk_produced + value_eggs_produced + value_other_produced)
lab var livestock_product_revenue "Gross revenue from sale of livestock products"
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
gen animals_lost12months =0 
gen mean_12months=0
la var animals_lost12months "Total number of livestock  lost to disease"
la var mean_12months "Average number of livestock  today and 1  year ago"
foreach i in lrum srum poultry {
	gen ls_exp_vac_`i' = .
}
gen value_slaughtered = .
gen sales_dung = .
gen cost_water_livestock = .
global empty_vars $empty_vars *ls_exp_vac_*


//adding - starting list of missing variables - recode all of these to missing at end of HH level file
global empty_vars $empty_vars animals_lost12months mean_12months *ls_exp_vac_lrum* *ls_exp_vac_srum* *ls_exp_vac_poultry* any_imp_herd_* 

*Self-employment income
merge 1:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_self_employment_income.dta", nogen keep(1 3)
merge 1:1 hhid  using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fish_trading_income.dta", nogen keep(1 3)
egen self_employment_income = rowtotal(self_employ_income fish_trading_income)
recode self_employment_income (.=0)
lab var self_employment_income "Income from self-employment (business)"

*Wage income
merge 1:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_wage_income.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_agwage_income.dta", nogen
recode annual_salary annual_salary_agwage (.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_off_farm_hours.dta", nogen keep(1 3)

*Other income
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_other_income.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_land_rental_income.dta", nogen
egen transfers_income = rowtotal (remittance_income pension_investment_income )
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal ( land_rental_income asset_sale_income rental_income other_income)
lab var all_other_income "Income from other revenue streams not captured elsewhere"
drop other_income

*Farm size
merge 1:1 hhid  using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_land_size.dta", nogen
merge 1:1 hhid  using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_land_size_all.dta", nogen 
merge 1:1 hhid  using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_farmsize_all_agland.dta", nogen
merge 1:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_land_size_total.dta", nogen 
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
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_family_hired_labor.dta", nogen 
capture confirm file "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_days_famlabor.dta" 
if _rc global empty_vars $empty_vars labor_family

*Household size
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hhsize.dta", nogen
 
*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_vaccine.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_input_use.dta", nogen 
merge 1:1 hhid  using  "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_fert_use.dta", nogen 
merge 1:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_improvedseed_use.dta", nogen 
merge 1:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_any_ext.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fin_serv.dta", nogen
drop if hhid == ""

recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use  vac_animal (.=0)
replace vac_animal=. if tlu_today==0
replace use_inorg_fert=. if farm_area==0 | farm_area==. //CG 3.28.24: no use_inorg_fert, need to fix inorg fert sections and come back to this
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
global empty_vars $empty_vars hybrid_seed_*

*Milk productivity
//recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_milk_animals.dta", nogen keep(1 3)
//gen liters_milk_produced=liters_per_largeruminant * milk_animals //CG 3.28.24: not necessary, this variable was created in original data file
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
//drop liters_per_largeruminant
gen liters_per_cow = . 
gen liters_per_buffalo = .
gen share_imp_dairy = . 
gen milk_animals = . 
global empty_vars $empty_vars share_imp_dairy *liters_per_cow *liters_per_buffalo milk_animals


*Dairy costs 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_lrum_expenses", nogen 
gen avg_cost_lrum = cost_lrum/mean_12months_lrum
lab var avg_cost_lrum "Average cost per large ruminant"
gen costs_dairy = avg_cost_lrum*milk_animals 
gen costs_dairy_percow = avg_cost_lrum
drop avg_cost_lrum cost_lrum
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"

*Egg productivity
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_eggs_animals.dta", nogen keep(1 3)
gen egg_poultry_year = . 
global empty_vars $empty_vars *egg_poultry_year poultry_owned

*Costs of crop production per hectare
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_cropcosts.dta", nogen keep(1 3)  

*Rate of fertilizer application 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_fertilizer_application.dta", nogen
*Agricultural wage rate
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_ag_wage.dta", nogen
*Crop yields 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_yield_hh_crop_level.dta", nogen
*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_area_planted_harvested_allcrops.dta", nogen
*Household diet
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_household_diet.dta", nogen
*Consumption
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_consumption.dta", nogen
*Household assets
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_hh_assets.dta", nogen

*Food insecurity
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_food_insecurity.dta", nogen
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Livestock health
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_livestock_diseases.dta", nogen keep(1 3)

*livestock feeding, water, and housing
*cannot construct 
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

*Shannon Diversity index
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/Malawi_IHS_IHPS_W3_shannon_diversity_index.dta", nogen keep(1 3)

*Farm Production 
recode value_crop_production  value_livestock_products value_livestock_sales (.=0)
gen value_farm_production = value_crop_production + value_livestock_products + value_livestock_sales
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products +  value_livestock_sales
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
foreach i in lrum srum poultry {
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i' ==1	
}

*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted  num_crops_hh multiple_crops (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted num_crops_hh multiple_crops (nonmissing=.) if crop_hh==0
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

global gender "female male mixed" //ALT 08.04.21
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harv* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months mean_12months lost_disease* /*			
*/ liters_milk_produced costs_dairy /*	
*/ eggs_total_year value_eggs_produced value_milk_produced /*
*/ /*DYA.10.26.2020*/ hrs_ag_activ hrs_wage_off_farm hrs_wage_on_farm hrs_unpaid_off_farm hrs_domest_fire_fuel hrs_off_farm hrs_on_farm hrs_domest_all hrs_other_all hrs_self_off_farm  crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac* sales_livestock_products value_livestock_products value_livestock_sales/*
*/ value_farm_production value_farm_prod_sold  value_pro* value_sal*

gen wage_paid_aglabor_mixed=.  //create this just to make the loop work and delete after
foreach v of varlist $wins_var_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top 1%"
}

*Variables winsorized at the top 1% only - for variables disaggregated by the gender of the plot manager
global wins_var_top1_gender=""
foreach v in $topcropname_area {
	global wins_var_top1_gender $wins_var_top1_gender `v'_exp
}
gen cost_total = cost_total_hh
gen cost_expli = cost_expli_hh //ALT 08.04.21: Kludge til I get names fully consistent
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli inorg_fert_kg org_fert_kg pest_kg herb_kg urea_kg npk_kg n_kg p_kg k_kg wage_paid_aglabor ha_irr

foreach v of varlist $wins_var_top1_gender {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top 1%"
	
	*some variables are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	foreach g of global gender {
		gen w_`v'_`g'=`v'_`g'
		replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
		local l`v'_`g' : var lab `v'_`g'
		lab var  w_`v'_`g'  "`l`v'_`g'' - Winsorized top 1%"
	}
}

drop *wage_paid_aglabor_mixed
egen w_labor_total=rowtotal(w_labor_hired w_labor_family)
local llabor_total : var lab labor_total 
lab var w_labor_total "`llabor_total' - Winsorized top 1%"

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
global wins_var_top1_bott1_2 area_harv  area_plan harvest //ALT 08.04.21: Breaking here. To do: figure out where area_harv comes from.
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
foreach v in inorg_fert org_fert n p k herb pest urea npk {
	gen `v'_rate=w_`v'_kg/w_ha_planted
	foreach g of global gender {
		gen `v'_rate_`g'=w_`v'_kg_`g'/ w_ha_planted_`g'
					
} 
}

foreach g of global gender {
	gen cost_total_ha_`g'=w_cost_total_`g'/ w_ha_planted_`g' 
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
la var irr_rate_`g' "Proportion of planted area irrigated (household) (`g'-managed plots)"
lab var npk_rate_`g' "Rate of NPK fertilizer application (kgs/ha) (`g'-managed plots)"
}

lab var inorg_fert_rate "Rate of fertilizer application (kgs/ha) (household level)"
lab var org_fert_rate "Rate of organic fertilizer application (kgs/ha) (household level)"
lab var n_rate "Rate of nitrogen application (kgs/ha) (household level)"
lab var p_rate "Rate of potassium application (kgs/ha) (household level)"
lab var k_rate "Rate of potassium application (kgs/ha) (household level)"
lab var herb_rate "Rate of herbicide application (kgs/ha) (household level)"
lab var pest_rate "Rate of pesticide application (kgs/ha) (household level)"
lab var urea_rate "Rate of urea application (kgs/ha) (household level)"
lab var npk_rate "Rate of urea application (kgs/ha) (household level)"
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
*all rural housseholds engaged in crop production //Doesn't run 
recode *irr_rate* *org_fert_rate* *n_rate* *p_rate* *k_rate* *herb_rate* *pest_rate* *urea_rate* *npk_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha* land_productivity labor_productivity (.=0) if crop_hh==1
recode *irr_rate* *org_fert_rate* *n_rate* *p_rate* *k_rate* *herb_rate* *pest_rate* *urea_rate* *npk_rate* cost_total_ha* cost_expli_ha* cost_expli_hh_ha* land_productivity labor_productivity (nonmissing=.) if crop_hh==0

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
global wins_var_ratios_top1 inorg_fert_rate org_fert_rate n_rate p_rate k_rate herb_rate pest_rate urea_rate npk_rate cost_total_ha cost_expli_ha cost_expli_hh_ha irr_rate /*
*/ land_productivity labor_productivity /*
*/ /*mortality_rate*/ liters_per_largeruminant liters_per_cow liters_per_buffalo egg_poultry_year costs_dairy_percow /*
*/ hrs_*_pc_all hrs_*_pc_any cost_per_lit_milk 

foreach v of varlist $wins_var_ratios_top1 {
	_pctile `v' [aw=weight] , p($wins_upper_thres)  
	gen w_`v'=`v'
	replace  w_`v' = r(r1) if  w_`v' > r(r1) &  w_`v'!=.
	local l`v' : var lab `v'
	lab var  w_`v'  "`l`v'' - Winsorized top 1%"
	*some variables  are disaggreated by gender of plot manager. For these variables, we use the top 1% percentile to winsorize gender-disagregated variables
	if "`v'" =="inorg_fert_rate" | "`v'" =="cost_total_ha"  | "`v'" =="cost_expli_ha" | "`v'"=="n_rate" | "`v'"=="k_rate" | "`v'"=="p_rate"  | "`v'"=="urea_rate" | "`v'"=="npk_rate" | "`v'"=="org_fert_rate" | "`v'"=="pest_rate" | "`v'"=="herb_rate" {
		foreach g of global gender {
			gen w_`v'_`g'=`v'_`g'
			replace  w_`v'_`g' = r(r1) if w_`v'_`g' > r(r1) & w_`v'_`g'!=.
			local l`v'_`g' : var lab `v'_`g'
			lab var  w_`v'_`g'  "`l`v'_`g'' - Winsorized top 1%"
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
	lab var  w_`v'_exp_ha  "`l`v'_exp_ha - Winsorized top 1%"
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
	lab var  w_`v'_exp_kg  "`l`v'_exp_kg' - Winsorized top 1%"
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
		_pctile `i'_`c' [aw=weight] ,  p(95)  //IHS WINSORIZING YIELD FOR NIGERIA AT 5 PERCENT. 
		gen w_`i'_`c'=`i'_`c'
		replace  w_`i'_`c' = r(r1) if  w_`i'_`c' > r(r1) &  w_`i'_`c'!=.
		local w_`i'_`c' : var lab `i'_`c'
		lab var  w_`i'_`c'  "`w_`i'_`c'' - Winsorized top 5%"
		foreach g of global allyield  {
			gen w_`i'_`g'_`c'= `i'_`g'_`c'
			replace  w_`i'_`g'_`c' = r(r1) if  w_`i'_`g'_`c' > r(r1) &  w_`i'_`g'_`c'!=.
			local w_`i'_`g'_`c' : var lab `i'_`g'_`c'
			lab var  w_`i'_`g'_`c'  "`w_`i'_`g'_`c'' - Winsorized top 5%"
		}
	}
}
 
 ***DYA 12.06.19 Because of the use of odd area units in Nigeria, we have many tiny plots. We are reporting yield when area_plan>0.1ha
foreach c of global topcropname_area {
	replace w_yield_pl_`c'=. if w_area_plan_`c'<0.05
	replace w_yield_hv_`c'=. if w_area_plan_`c'<0.05
	foreach g of global allyield  {
		replace w_yield_pl_`g'_`c'=. if w_area_plan_`c'<0.05
		replace w_yield_hv_`g'_`c'=. if w_area_plan_`c'<0.05	
	}
}

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
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winsorized top 1%"
lab var w_farm_income "Farm income - Winsorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winsorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winsorized top 1%"
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
*all rural households //Needs work 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
//ALT 08.16.21: Kludge for imprv seed use - for consistency, it should really be use_imprv_seed 
recode w_total_income w_percapita_income w_crop_income w_livestock_income w_fishing_income w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_fishing w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* use_inorg_fert imprv_seed_use /*
*/ formal_land_rights_hh *_hrs_*_pc_all  months_food_insec w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold livestock_expenses w_ls_exp_vac (nonmissing = .) if livestock_hh==0 


*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (.=0) if lvstck_holding_`i'==1	
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
	recode yield_hv_`cn' (.=0) if harvested_`cn'==1 
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'==0 
}


*all rural households that harvested specific crops
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'==1 
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'==0 
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
gen individual_weight=hh_members*xs_weight if panel==0
gen adulteq_weight=adulteq*xs_weight if panel==0

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

gen ccf_loc = (1/$MWI_W3_infl_adj) 
lab var ccf_loc "currency conversion factor - 2021 MWK"
gen ccf_usd = ccf_loc/$MWI_W3_exchange_rate 
lab var ccf_usd "currency conversion factor - 2021 $USD"
gen ccf_1ppp = ccf_loc/$MWI_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2021 $Private Consumption PPP"
gen ccf_2ppp = ccf_loc/$MWI_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2021 $GDP PPP"

gen poverty_under_190 = daily_percap_cons < $MWI_W3_poverty_under_190
la var poverty_under_190 "Household per-capita conumption is below $1.90 in 2011 $ PPP"
gen poverty_under_215 = daily_percap_cons < $MWI_W3_poverty_under_215
la var poverty_under_215 "Household per-capita consumption is below $2.15 in 2017 $ PPP"
gen poverty_under_npl = daily_percap_cons < $MWI_W3_poverty_under_npl
la var poverty_under_npl "Household per-capita consumption is below the 2017 national poverty line."
gen poverty_under_300 = daily_percap_cons < $MWI_W3_poverty_under_300
la var poverty_under_300 "Household per-capita consumption is below the 2021 national poverty line"

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

*dropping unnecessary varables
//drop *_inter_*

*create missing crop variables (no cowpea or yam)
foreach x of varlist *maize* {
	foreach c in wheat {
		gen `x'_x = .
		ren *maize*_x *`c'*
	}
}

global empty_vars $empty_vars *wheat* //*beans* 

*Recode to missing any variables that cannot be created in this instrument
*replace empty vars with missing

foreach v of varlist $empty_vars {
capture confirm var `v'
if _rc {
gen `v' = . 
}
else {
replace `v' =.
}
}

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* /*zone*/ region district ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold *hrs_*   months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_* *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh fishing_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_cows_today nb_largerum_today nb_smallrum_today nb_chickens_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products area_plan* area_harv* *_rate* *value_pro* *value_sal* *inter*
 
gen ssp = (farm_size_agland <= 2 & farm_size_agland != 0) & (nb_cows_today <= 10 & nb_smallrum_today <= 10 & nb_chickens_today <= 50) // This line is for HH vars only; rest for all three


//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Malawi"
gen survey = "LSMS-ISA" 
gen year = "2016-17"
gen instrument = 43
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
	*/ 21 "Ethiopia ESS Wave 1" 22 "Ethiopia ESS Wave 2" 23 "Ethiopia ESS Wave 3" 24 "Ethiopia ESS Wave 4" 25 "Ethiopia ESS Wave 5" /*
	*/ 31 "Nigeria GHS Wave 1" 32 "Nigeria GHS Wave 2" 33 "Nigeria GHS Wave 3" 34 "Nigeria GHS Wave 4" 35 "Nigeria GHS Wave 5"/*
	*/ 41 "Malawi IHS/IHPS Wave 1" 42 "Malawi IHS/IHPS Wave 2" 43 "Malawi IHS/IHPS Wave 3" 44 "Malawi IHS/IHPS Wave 4" /*
    */ 51 "Uganda NPS Wave 1" 52 "Uganda NPS Wave 2" 53 "Uganda NPS Wave 3" 54 "Uganda NPS Wave 4" 55 "Uganda NPS Wave 5" /*W6 does not exist*/ 56 "Uganda NPS Wave 7" 57 "Uganda NPS Wave 8" /* 
*/ 61 "Burkina Faso EMC Wave 1" /* 
*/ 71 "Mali EACI Wave 1" 72 "Mali EACI Wave 2" /*
*/ 81 "Niger ECVMA Wave 1" 82 "Niger ECVMA Wave 2"
label values instrument instrument
//gen strataid=district // defined earlier in section
save "${MWI_IHS_IHPS_W3_final_data}\MWI_IHS_IHPS_W3_household_variables.dta", replace

********************************************************************************
*INDIVIDUAL LEVEL VARIABLES*
********************************************************************************
//global empty_vars ""
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_person_ids.dta", clear
merge 1:1 hhid indiv using"${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid  indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid  indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", nogen keep (1 3) 
merge 1:1 hhid  indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid  indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_improvedseed_use.dta"
merge 1:1 hhid  indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_improved_hybrid_seed_use.dta", nogen  keep(1 3)
merge 1:1 hhid  indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_farmer_vaccine.dta", nogen  keep(1 3)



*Land rights
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_land_rights_ind.dta", nogen
recode formal_land_rights_f (.=0) if female==1
la var formal_land_rights_f "Individual has documentation of land rights (at least one plot) - Women only"

*getting correct subpopulations (women aged 18 or above in rural households)
recode control_all_income make_decision_ag own_asset formal_land_rights_f (.=0) if female==1 
recode control_all_income make_decision_ag own_asset formal_land_rights_f (nonmissing=.) if female==0

*merge in hh variable to determine ag household
preserve

use "${MWI_IHS_IHPS_W3_final_data}\MWI_IHS_IHPS_W3_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
recast str50 hhid, force 
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

* Recode to missing any variables that cannot be created in this instrument
* replace empty vars with missing
/*foreach v of varlist $empty_vars { 
	capture confirm var `v'
	if _rc {
		gen `v' = .
	}
	else {
		replace `v' = .
	}
}*/


//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen hhid_panel = hhid 
lab var hhid_panel "panel hh identifier" 
gen geography = "Malawi"
gen survey = "LSMS-ISA"
gen year = "2016-17"
gen instrument = 43
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
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
save "${MWI_IHS_IHPS_W3_final_data}\MWI_IHS_IHPS_W3_individual_variables.dta", replace

********************************************************************************
*PLOT LEVEL VARIABLES
********************************************************************************
*GENDER PRODUCTIVITY GAP
use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_all_plots.dta", clear
collapse (sum) plot_value_harvest = value_harvest, by(hhid plot_id garden_id season)
tempfile crop_values 
save `crop_values'

use "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_areas.dta", clear
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_weights.dta", keep(1 3) nogen
merge 1:1 hhid  plot_id garden_id using `crop_values', nogen keep(1 3)
merge 1:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_decision_makers.dta", keep (1 3) nogen
merge 1:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_family_hired_labor.dta", keep (1 3) nogen
merge 1:1 hhid plot_id garden_id season using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plot_labor_days.dta", keep(1 3) nogen
//merge m:1 hhid plot_id using "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_plots_cultivate.dta", nogen keep(1 3) // plot_areas does not include "cultivate"

merge m:1 hhid using  "${MWI_IHS_IHPS_W3_final_data}\MWI_IHS_IHPS_W3_household_variables.dta", nogen keep(1 3) keepusing(ag_hh fhh farm_size_agland)
recode farm_size_agland (.=0)
gen rural_ssp=(farm_size_agland<=4 & farm_size_agland!=0) & rural == 1
recode rural_ssp .=0

//keep if cultivate==1
replace area_meas_hectares=area_est_hectares if area_meas_hectares==. // 519 changes
// ren field_size  area_meas_hectares // already defined
// egen labor_total = rowtotal(labor_family labor_hired labor_nonhired) // already defined

global winsorize_vars area_meas_hectares labor_total
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
	lab var  w_`v'  "`l`v'' - Winsorized top 1%"
}


****Currency Conversion Factors***
gen ccf_loc = 1 
lab var ccf_loc "currency conversion factor - 2016 $MWK"
gen ccf_usd = 1/ $MWI_W3_exchange_rate 
lab var ccf_usd "currency conversion factor - 2016 $USD"
gen ccf_1ppp = 1/ $MWI_W3_cons_ppp_dollar
lab var ccf_1ppp "currency conversion factor - 2016 $Private Consumption PPP"
gen ccf_2ppp = 1/ $MWI_W3_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2017 $GDP PPP"

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
svy, subpop(if rural==1) : reg  lplot_productivity_usd male_dummy larea_meas_hectares i.district
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
svy, subpop(  if rural==1 & rural_ssp==1): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.district
matrix b1b=e(b)
gen gender_prod_gap1b_ssp=100*el(b1b,1,1)
sum gender_prod_gap1b_ssp
lab var gender_prod_gap1b_ssp "Gender productivity gap (%) - regression in logs with controls - SSP"
matrix V1b=e(V)
gen segender_prod_gap1b_ssp= 100*sqrt(el(V1b,1,1)) 
sum segender_prod_gap1b_ssp
lab var segender_prod_gap1b_ssp "SE Gender productivity gap (%) - regression in logs with controls - SSP"


*LS_SSP
svy, subpop(  if rural==1 & rural_ssp==0): reg  lplot_productivity_usd male_dummy larea_meas_hectares i.district
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
	
//global empty_vars $empty_vars gen_gaps gender_prod_gap1b segender_prod_gap1b gender_prod_gap1b_ssp segender_prod_gap1b_ssp gender_prod_gap1b_lsp segender_prod_gap1b_lsp manager_male* manager_female* manager_mixed*  manager_gender_lsp3  manager_mixed_lsp

global gen_gaps gender_prod_gap1b segender_prod_gap1b gender_prod_gap1b_ssp segender_prod_gap1b_ssp gender_prod_gap1b_lsp segender_prod_gap1b_lsp manager_male* manager_female* /*manager_mixed* */


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
rename v1 MW_wave3

save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_IHPS_W3_gendergap.dta", replace
restore

foreach i in 1ppp 2ppp loc{
	gen w_plot_productivity_all_`i'=w_plot_productivity_`i'
	gen w_plot_productivity_female_`i'=w_plot_productivity_`i' if dm_gender==2
	gen w_plot_productivity_male_`i'=w_plot_productivity_`i' if dm_gender==1
	gen w_plot_productivity_mixed_`i'=w_plot_productivity_`i' if dm_gender==3
}

*Create weight 
gen plot_labor_weight= w_labor_total*weight

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
gen year = "2016-17"
gen instrument = 43
//Only runs if label isn't already defined.
capture label define instrument 11 "Tanzania NPS Wave 1" 12 "Tanzania NPS Wave 2" 13 "Tanzania NPS Wave 3" 14 "Tanzania NPS Wave 4" 15 "Tanzania NPS Wave 5" /*
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
save "${MWI_IHS_IHPS_W3_final_data}\MWI_IHS_IHPS_W3_field_plot_variables.dta", replace

********************************************************************************
*SUMMARY STATISTICS   
********************************************************************************
/*
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
//This takes a while to run, so if you don't need to compile summary statistics, either skip or comment out.
*Parameters	
global list_instruments  "MWI_IHS_IHPS_W3"
do "$summary_stats"
 
