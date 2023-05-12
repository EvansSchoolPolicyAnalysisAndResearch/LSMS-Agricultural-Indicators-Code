/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Uganda National Panel Survey (UNPS) LSMS-ISA Wave 4 (2013-14)

*Author(s)		: Didier Alia, David Coomes, Elan Ebeling, Nina Forbes, Nida
				  Haroon, Conor Hennessy, Marina Kaminsky, Sammi Kiel, Carly 
				  Schmidt, Anu Sidhu, Isabella Sun, Andrew Tomes, Emma Weaver,
				  Ayala Wineman, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the
				  World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI,
				  IRRI, and the Bill & Melinda Gates Foundation Agricultural
				  Development Data and Policy team in discussing indicator
				  construction decisions. 
				  All coding errors remain ours alone.

*Date			: 05 February 2023

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
* The Uganda National Panel Survey was collected by the Uganda Bureau of Statistics (UBOS) 
* and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
* The data were collected over the period November 2013 - October 2014. 
* All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
* http://microdata.worldbank.org/index.php/catalog/2663

* Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Uganda National Panel Survey.


*Summary of Executing the Master do.file
*-----------
* This Master do.file constructs selected indicators using the Uganda UNPS (UN LSMS) data set.
* Using data files from within the "\data\uganda-wave4-2013-14-unps" folder, the do.file first constructs common and intermediate variables, 
* saving dtafiles when appropriate in the folder "\output\uganda-wave4-2013-14-unps\temp" 
*
* These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available in the
* folder "\output\uganda-wave4-2013-14-unps". 


* The processed files include all households, individuals, and plots in the sample. Toward the end of the do.file, a block of code estimates summary 
* statistics (mean, standard error of the mean, minimum, first quartile, 
* median, third quartile, maximum) of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.

* The results are outputted in the excel file "Uganda_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "\output\uganda-wave4-2013-14-unps" folder. 


* It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary 
* statistics for a different sub_population.


/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file
 					
*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Uganda_NPS_LSMS_ISA_W4_hhids.dta
*INDIVIDUAL IDS						Uganda_NPS_LSMS_ISA_W4_person_ids.dta
*HOUSEHOLD SIZE						Uganda_NPS_LSMS_ISA_W4_hhsize.dta
*PARCEL AREAS						Uganda_NPS_LSMS_ISA_W4_parcel_areas.dta
*PLOT-CROP DECISION MAKERS			Uganda_NPS_LSMS_ISA_W4_plot_decision_makers.dta

*MONOCROPPED PLOTS					Uganda_NPS_LSMS_ISA_W4_[CROP]_monocrop_hh_area.dta					
*TLU (Tropical Livestock Units)		Uganda_NPS_LSMS_ISA_W4_TLU_Coefficients.dta

*GROSS CROP REVENUE					Uganda_NPS_LSMS_ISA_W4_tempcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W4_tempcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W4_permcrop_harvest.dta
									Uganda_NPS_LSMS_ISA_W4_permcrop_sales.dta
									Uganda_NPS_LSMS_ISA_W4_hh_crop_production.dta
									Uganda_NPS_LSMS_ISA_W4_plot_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W4_parcel_cropvalue.dta
									Uganda_NPS_LSMS_ISA_W4_crop_residues.dta
									Uganda_NPS_LSMS_ISA_W4_hh_crop_prices.dta
									Uganda_NPS_LSMS_ISA_W4_crop_losses.dta

*CROP EXPENSES						Uganda_NPS_LSMS_ISA_W4_wages_mainseason.dta
									Uganda_NPS_LSMS_ISA_W4_wages_shortseason.dta
									Uganda_NPS_LSMS_ISA_W4_fertilizer_costs.dta
									Uganda_NPS_LSMS_ISA_W4_seed_costs.dta
									Uganda_NPS_LSMS_ISA_W4_land_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W4_asset_rental_costs.dta
									Uganda_NPS_LSMS_ISA_W4_transportation_cropsales.dta
									
*CROP INCOME						Uganda_NPS_LSMS_ISA_W4_crop_income.dta
									
*LIVESTOCK INCOME					Uganda_NPS_LSMS_ISA_W4_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W4_livestock_expenses.dta
									Uganda_NPS_LSMS_ISA_W4_hh_livestock_products.dta
									Uganda_NPS_LSMS_ISA_W4_livestock_sales.dta
									Uganda_NPS_LSMS_ISA_W4_TLU.dta
									Uganda_NPS_LSMS_ISA_W4_livestock_income.dta

*FISH INCOME						n/a
																	
*SELF-EMPLOYMENT INCOME				n/a

									
*WAGE INCOME						Uganda_NPS_LSMS_ISA_W4_wage_income.dta
									Uganda_NPS_LSMS_ISA_W4_agwage_income.dta					

*OTHER INCOME						Uganda_NPS_LSMS_ISA_W4_other_income.dta
									Uganda_NPS_LSMS_ISA_W4_land_rental_income.dta

*FARM SIZE / LAND SIZE				Uganda_NPS_LSMS_ISA_W4_land_size.dta
									Uganda_NPS_LSMS_ISA_W4_farmsize_all_agland.dta
									Uganda_NPS_LSMS_ISA_W4_land_size_all.dta
									Uganda_NPS_LSMS_ISA_W4_land_size_total.dta					

*FARM LABOR							Uganda_NPS_LSMS_ISA_W4_farmlabor_mainseason.dta
									Uganda_NPS_LSMS_ISA_W4_farmlabor_shortseason.dta
									Uganda_NPS_LSMS_ISA_W4_family_hired_labor.dta
									
*VACCINE USAGE						Uganda_NPS_LSMS_ISA_W4_vaccine.dta
									Uganda_NPS_LSMS_ISA_W4_farmer_vaccine.dta					
							
*ANIMAL HEALTH						Uganda_NPS_LSMS_ISA_W4_livestock_diseases.dta				
									Uganda_NPS_LSMS_ISA_W4_livestock_feed_water_house.dta		

*USE OF INORGANIC FERTILIZER		Uganda_NPS_LSMS_ISA_W4_fert_use.dta
									Uganda_NPS_LSMS_ISA_W4_farmer_fert_use.dta							

*USE OF IMPROVED SEED				Uganda_NPS_LSMS_ISA_W4_improvedseed_use.dta
									Uganda_NPS_LSMS_ISA_W4_farmer_improvedseed_use.dta			

*REACHED BY AG EXTENSION			Uganda_NPS_LSMS_ISA_W4_any_ext.dta
*USE OF FORMAL FINANACIAL SERVICES	Uganda_NPS_LSMS_ISA_W4_fin_serv.dta
*GENDER PRODUCTIVITY GAP 			Uganda_NPS_LSMS_ISA_W4_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W4_milk_animals.dta
*EGG PRODUCTIVITY					Uganda_NPS_LSMS_ISA_W4_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Uganda_NPS_LSMS_ISA_W4_hh_rental_rate.dta 			
									Uganda_NPS_LSMS_ISA_W4_hh_cost_land.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_inputs_fcs.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_inputs_scs.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_seed_fcs.dta
									Uganda_NPS_LSMS_ISA_W4_hh_cost_seed_scs.dta	
									Uganda_NPS_LSMS_ISA_W4_asset_rental_costs.dta 			
									Uganda_NPS_LSMS_ISA_W4_cropcosts_total.dta

*RATE OF FERTILIZER APPLICATION		Uganda_NPS_LSMS_ISA_W4_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Uganda_NPS_LSMS_ISA_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Uganda_NPS_LSMS_ISA_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			Uganda_NPS_LSMS_ISA_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Uganda_NPS_LSMS_ISA_W4_ownasset.dta
*AGRICULTURAL WAGES					Uganda_NPS_LSMS_ISA_W4_ag_wage.dta					
*CROP YIELDS						Uganda_NPS_LSMS_ISA_W4_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Uganda_NPS_LSMS_ISA_W4_shannon_diversity_index.dta
*CONSUMPTION						Uganda_NPS_LSMS_ISA_W4_consumption.dta
*HOUSEHOLD FOOD PROVISION			Uganda_NPS_LSMS_ISA_W4_food_insecurity.dta
*HOUSEHOLD ASSETS					Uganda_NPS_LSMS_ISA_W4_hh_assets.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Uganda_NPS_LSMS_ISA_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Uganda_NPS_LSMS_ISA_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Uganda_NPS_LSMS_ISA_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					Uganda_NPS_LSMS_ISA_W4_summary_stats.xlsx
*/

clear
clear matrix
clear mata
set more off
set maxvar 8000
ssc install findname  

// set directories


global directory "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14"



//set directories: These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.

* windows directory
global Uganda_NPS_W4_raw_data 			"$directory\raw_data"
global Uganda_NPS_W4_created_data 		"$directory\created_data"
global Uganda_NPS_W4_final_data  		"$directory\Final DTA Files\final_data"
/*
global Uganda_NPS_W4_raw_data "${root_folder}\raw_data"
global Uganda_NPS_W4_created_data "${root_folder}\temp"
global Uganda_NPS_W4_final_data "${root_folder}\outputs"

*/
********************************************************************************
*           EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS              *
********************************************************************************
global UGA_W4_exchange_rate 3689.75      // https://www.bloomberg.com/quote/USDUGX:CUR 		
global UGA_W4_gdp_ppp_dollar  1031.13   // https://data.worldbank.org/indicator/PA.NUS.PPP?locations=UG // for 2014 
global UGA_W4_cons_ppp_dollar 1096.22  // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?locations=UG // for 2014 
global UGA_W4_inflation .4996         //  https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=UG  // // inflation rate 2014-2015, data collected 2013-2014. We want to adjust the monetary values to 2015 //(149.96-100)/100 


********************************************************************************
*					THRESHOLDS FOR WINSORIZATION							   *
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*						GLOBALS OF PRIORITY CROPS							   *
********************************************************************************
* maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana

//List of crops for this instrument - including 12 priority and any additional crops from the top 10
/*
maize
rice 
wheat
sorghum
bulrush millet (pearl millet)
cowpea 
groundnut
common bean (includes kidney, pinto, navy, and black beans)
yam
sweet potato
cassava 
banana
cotton
sunflower
pigeon pea
*/

*Enter the 12 priority crops here, plus any crop in the top ten that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops


********************************************************************************
*                                HOUSEHOLD IDS                                 *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC1.dta", clear
ren HHID hhid // In UGA W4, household id variables are not consistently named between the Ag data sections and the Household data sections 
			//In Ag, there are two id variables (HHID and hh) HHID is long and hh is string (they are composed of the same numbers, but string version has 'H' and '-' added)
			//In Household, HHID is string, and in one case hhid is used instead of HHID
			//We rename all string household id variables to "hhid" for consistency and to allow for merging between data files
ren h1aq1a district 
ren h1aq3a county
ren h1aq3b county_name
ren h1aq4a parish
ren h1aq4b parish_name 
ren wgt_X weight //wgt_X  is cross-sectional weight for UNPS 2013-2014, applies to all respondents, alternative variable wgt only applies to those interviewed in previous waves
gen rural=urban==0
keep hhid region sregion district county county_name parish parish_name ea weight rural
lab var rural "1=Household lives in a rural area"
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta"


********************************************************************************
*								INDIVIDUAL IDS								   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC2.dta", clear
ren HHID hhid
destring PID, gen(indiv) ignore ("P" "-") 
gen female=h2q3==2 
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "indivdual age"
gen hh_head=h2q4==1 
lab var hh_head "1= individual is household head"
ren h2q1 individ 
keep indiv hhid female age hh_head individ 
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_person_ids.dta", replace



********************************************************************************
*								HOUSEHOLD SIZE								   *
********************************************************************************
use "${Uganda_NPS_W4_raw_data}\HH\GSEC2.dta", clear
ren HHID hhid
gen hh_members = 1
ren h2q4 relhead 
ren h2q3 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (hhid)	
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhsize.dta", replace




********************************************************************************
*ALL PLOTS
********************************************************************************

/*Purpose:
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.

*/

	***************************
	*Crop Values
	***************************
	use "${Uganda_NPS_W5_raw_data}\Agric/AGSEC5A.dta", clear
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
	merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keepusing(weight)
	gen obs = price_unit != .
	
	//This loop below creates a value for the price of each crop at the given regional levels seen in the first line. It stores this in temporary storage to allow for cleaner, simpler code, but could be stored permanently if you want.
	foreach i in region ea district scounty_code parish_code hhid {
		preserve
		bys `i' crop_code sold_unit_code : egen obs_`i'_price = sum(obs)
		collapse (median) price_unit_`i' = price_unit [aw=weight], by (`i' sold_unit_code crop_code obs_`i'_price)
		rename sold_unit_code unit_code //needs to be done for a merge near the end of the all_plots indicator
		tempfile price_unit_`i'_median
		save `price_unit_`i'_median'
		restore
	}
	*drop if crop_code != 130 //take away once problem is fixed
	*drop if sold_unit_code != 1 //take away once problem is fixed
	collapse (mean) price_unit_country = price_unit (sum) obs_country_price = obs [aw=weight], by(crop_code sold_unit_code)
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
	
**# Bookmark #1
	
	***************************
	*Plot variables
	***************************	
	*Clean up file and combine both seasons
	use "${Uganda_NPS_W4_raw_data}/AGSEC4A.dta", clear
	gen season = 1
	append using "${Uganda_NPS_W4_raw_data}/AGSEC4B.dta"
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
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_areas.dta", nogen keep(1 3)
	generate percent_field = a4aq9/100
	replace percent_field = a4bq9/100 if percent_planted == .
	
	*Creating time variables (month planted, harvested, and length of time grown)
	gen month_planted = a4aq9_1
	replace month_planted = a4bq9_1 if season == 2 
	replace month_planted = . if a4aq9_1 == 99 //have to remove permanent crops/trees like coffee and bananas
	replace month_planted = . if a4bq9_1 == 99
	lab var month_planted "Month of planting relative to December 2013 (both cropping seasons)"
	merge m:m hhid parcel_id plot_id /*crop_code*/ season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_value.dta", nogen
	rename crop_code crop_code_harvest
	drop if crop_code_harvest == . //10 observations dropped
	gen month_harvest = a5aq6e //JHG 12_31_21: Harvest start and end dates are different. Which to choose? Will use start date for now.
	replace month_harvest = a5bq6e if season == 2
	replace month_harvest = month_harvest + 12 if (a5aq6e < 13 & a5aq6e_1 == 2015) //fixing inconsistency between reported month of harvest and reported year
	lab var month_harvest "Month of planting relative to December 2013 (both cropping seasons)"
	gen perm_tree = 1 if inlist(crop_code_master, 460, 630, 700, 710, 720, 740, 750, 760, 770, 780, 810, 820, 830, 870) //dodo, cassava, oranges, pawpaw, pineapple, bananas, mango, jackfruit, avocado, passion fruit, coffee, cocoa, tea, and vanilla, in that order
	replace perm_tree = 0 if perm_tree == .
	lab var perm_tree "1 = Tree or permanent crop" // JHG 1_14_22: what about perennial, non-tree crops like cocoyam (which I think is also called taro)?
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
	/*replace purestand = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 //JHG 1_14_22: 8 replacements, all of which report missing crop_code values. Should all missing crop_code values be dropped? If so, this should be done at an early stage.
	//I dropped the values after the latest merge above, and there were zero replacements for this line of code. No relay cropping?
	gen relay = 1 if crops_plot > 1 & plant_dates == 1 & harv_dates == 1 & permax == 0 & mixed_max == 0 */
	replace purestand = 1 if crop_code_plant == crops_avg //multiple types of the same crop do not count as intercropping
	replace purestand = 0 if purestand == . //assumes null values are just 0
	lab var purestand "1 = monocropped, 0 = intercropped or relay cropped"
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	/*JHG 1_14_22: Can't do this section because no ha_harvest information. 1,598 plots have ha_planted > field_size
	Okay, now we should be able to relatively accurately rescale plots.
	replace ha_planted = ha_harvest if ha_planted == . //X # of changes
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > field_size & ha_harvest < ha_planted & ha_harvest!=. //X# of changes */

	//gen percent_field = ha_planted/field_size
*Generating total percent of purestand and monocropped on a field
	bys hhid parcel_id plot_id season: egen total_percent = total(percent_field)
//about 51% of plots have a total intercropped sum greater than 1
//about 26% of plots have a total monocropped sum greater than 1

	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field = 1 if percent_field > 1 & purestand == 1
	//8568 changes made
	gen ha_planted = percent_field*field_size
	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey
	
	*Renaming variables for merge to work //JHG 1/20/2022: section is unnecessary if we can't get conversion factors to work
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
	//JHG 1/20/2022: can't do any conversion without conversion factors, there are currently no good substitutes for what they provide and that is very inconsistent within units (different conversion factors for same unit and crop). To get around this, we decided to use median values by crop, condition, and unit given what the survey provides.	
	
	*merging in conversion factors and generating value of harvest variables
	merge m:1 crop_code condition sold_unit_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_conv_fact_sold.dta", keep(1 3) gen(cfs_merge) // two thirds of observations report nothing sold, hence many aren't matched
	merge m:1 crop_code condition_harv unit_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_conv_fact_harv.dta", keep(1 3) gen(cfh_merge) 
	gen quant_sold_kg = sold_qty * conv_fact_sold_median if cfs_merge == 3
	gen quant_harv_kg = quantity_harvested * conv_fact_harv_median //not all harvested is sold, in fact most is not
	gen total_sold_value = price_unit * sold_qty
	gen value_harvest = price_unit * quantity_harvested
	rename price_unit val_unit
	gen val_kg = total_sold_value/quant_sold_kg if cfs_merge == 3
	
	*Generating plot weights, then generating value of both permanently saved and temporarily stored for later use
	merge m:1 hhid using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hhids.dta", nogen keepusing(weight) keep(1 3)
	gen plotweight = ha_planted * weight
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

foreach i in region district scounty_code parish_code ea hhid { //something in here breaks when looking for unit_code
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
save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore

merge m:1 unit_code crop_code using `price_unit_country_median', nogen keep(1 3)
merge m:1 unit_code crop_code using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_crop_prices_median_country.dta", nogen keep(1 3)
merge m:1 crop_code using `val_kg_country_median', nogen keep(1 3)

*Generate a definitive list of value variables
//JHG 1_28_22: We're going to prefer observed prices first, starting at the highest level (country) and moving to the lowest level (ea, I think - need definitive ranking of these geographies)
foreach i in country region district scounty_code parish_code ea {
	replace val_unit = price_unit_`i' if obs_`i'_price > 9
	replace val_kg = val_kg_`i' if obs_`i'_kg  > 9 //JHG 1_28_22: why 9?
}
	gen val_missing = val_unit == .
	replace val_unit = price_unit_hhid if price_unit_hhid != .

foreach i in country region district scounty_code parish_code ea { //JHG 1_28_22: is this filling in empty variables with other geographic levels?
	replace val_unit = val_unit_`i' if obs_`i'_unit > 9 & val_missing == 1
}
	replace val_unit = val_unit_hhid if val_unit_hhid != . & val_missing == 1 //household variables are last resort if the above loops didn't fill in the values
	replace val_kg = val_kg_hhid if val_kg_hhid != . //Preferring household values where available.
	
//All that for these two lines that generate actual harvest values:
	replace value_harvest = val_unit * quantity_harvested if value_harvest == .
	replace value_harvest = val_kg * quant_harv_kg if value_harvest == .
//XXX real changes total. But note we can also subsitute local values for households with weird prices, which might work better than winsorizing.
	//Replacing conversions for unknown units
	replace val_unit = value_harvest / quantity_harvested if val_unit == .
preserve
	ren unit_code unit
	collapse (mean) val_unit, by (hhid crop_code unit)
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_hh_crop_prices_for_wages.dta", replace
restore
		
*AgQuery
	collapse (sum) quant_harv_kg value_harvest ha_planted percent_field (max) months_grown, by(region district scounty_code parish_code ea hhid parcel_id plot_id season crop_code_master purestand field_size)
	bys hhid parcel_id plot_id season : egen percent_area = sum(percent_field)
	bys hhid parcel_id plot_id season : gen percent_inputs = percent_field / percent_area
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	merge m:1 hhid parcel_id plot_id season using "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	save "${Uganda_NPS_W4_created_data}/Uganda_NPS_W4_all_plots.dta", replace

********************************************************************************
*							GROSS CROP REVENUE						  		   *
********************************************************************************
**Crop Sales**
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\raw_data\AGSEC5A.dta", clear
append using "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\raw_data\AGSEC5B.dta"

ren hh hhid
ren cropID crop_code
ren plotID plot_id
ren parcelID parcel_id
drop if plot_id==. 

*Quantity Crop Harvested
ren a5aq6a qty_harvest
replace qty_harvest = a5bq6a if qty_harvest==. & a5bq6a!=.
ren a5aq6d conversion
replace conversion = a5bq6d if conversion==. & a5bq6d!=.
//rename condition and unit of harvest for comparison & conversion below
ren a5aq6c unit_harv
replace unit_harv = a5bq6c if unit_harv==. & a5bq6c!=.
//(NKF NOTE: variables a5aq6b and a5aq6c appear to have been switched in dta files, b should be unit code and c should be condition according to questionnaire and labels, but looking at dta values it is clear they were switched)
ren a5aq6b condition_harv
replace condition_harv = a5bq6b if condition_harv==. & a5bq6b!=.
//Converting to kgs harvested
gen kgs_harvest = qty_harvest if unit_harv==1 // if unit of crop harvested is kgs 
//(NKF NOTE: variables a5aq6b and a5aq6c appear to have been switched in dta files, b should be unit code and c should be condition according to questionnaire and labels, but looking at dta values it is clear they were switched)
replace  kgs_harvest = qty_harvest * conversion if unit_harv!=1 // if unit of crop harvested is not kgs

//Household Specific Errors
replace conversion=80 if unit_harv==11 & hhid=="H04509-04-01" //this observation was missing conversion code although had unit 11 (Sack-80kgs), so hand-coding in conversion
replace conversion=100 if conversion==0 & hhid=="H06109-04-01" // There is 1 observations where conversion is zero, but the unit harvestd is Sack(100 kgs) so replacing with correct conversion code

*Quantity Crop Sold
ren a5aq7a qty_sold  
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 
ren a5aq7d conversion_sold	// conversion factor for quantity sold
replace conversion_sold = a5bq7d if conversion_sold==. & a5bq7d!=.
replace conversion_sold=. if conversion_sold==0 
//rename condition and unit of sale for comparison & conversion below
ren a5aq7c unit_sold
replace unit_sold = a5bq7c if unit_sold==. & a5bq7c!=.
ren a5aq7b condition_sold 
replace condition_sold = a5bq7b if condition_sold==. & a5bq7b!=.
//Converting to kgs sold
gen kgs_sold = qty_sold if unit_sold==1 //if quantity sold already reported in kgs
replace kgs_sold = qty_sold * conversion_sold if unit_sold!=1 // if quantity sold not reported in kgs

*Convert qty_sold to kgs_sold
replace kgs_sold = qty_sold * conversion if kgs_sold==. & condition_harv==condition_sold & unit_harv==unit_sold
replace kgs_sold = qty_sold * conversion if kgs_sold==. & qty_harvest==qty_sold 
replace kgs_sold = qty_sold if kgs_sold==. & qty_harvest==qty_sold & unit_harv==1 
replace kgs_sold = 0 if qty_sold==0  


ren a5aq8 value_sold
replace value_sold = a5bq8 if value_sold==. & a5bq8!=.

recode kgs_harvest kgs_sold value_sold qty_sold (.=0) 

collapse (sum) kgs_harvest kgs_sold value_sold qty_sold, by (hhid parcel_id plot_id crop_code)

lab var kgs_harvest "Kgs harvest of this crop"
lab var kgs_sold "Kgs sold of this crop"
lab var value_sold "Value sold of this crop"

*Price per kg
gen price_kg = value_sold/kgs_sold
lab var price_kg "price per kg sold"

recode price_kg (0=.)
merge m:1 hhid using "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta"
drop if _merge==2 
drop _merge
save "${Uganda_NPS_W4_created_data}\Uganda_NPS_W4_hhids.dta", replace

*Impute crop prices from sales
//median price at ea level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region sregion district county parish ea crop_code: egen obs_ea = count (observation)
collapse (median) price_kg [aw=weight], by (region sregion district county parish ea crop_code obs_ea)
ren price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_ea.dta", replace

//median price at parish level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region sregion district county parish crop_code: egen obs_parish = count (observation)
collapse (median) price_kg [aw=weight], by (region sregion district county parish crop_code obs_parish)
ren price_kg price_kg_median_parish
lab var price_kg_median_parish "Median price per kg for this crop in the parish"
lab var obs_parish "Number of sales observations for this crop in the parish"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_parish.dta", replace

//median price at county level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region sregion district county crop_code: egen obs_county = count (observation)
collapse (median) price_kg [aw=weight], by (region sregion district county crop_code obs_county)
ren price_kg price_kg_median_county
lab var price_kg_median_county "Median price per kg for this crop in the county"
lab var obs_county "Number of sales observations for this crop in the county"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_county.dta", replace

//median price at district level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region sregion district crop_code: egen obs_district = count (observation) 
collapse (median) price_kg [aw=weight], by (region sregion district crop_code obs_district)
ren price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_district.dta", replace

//median price at sub-region level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region sregion crop_code: egen obs_sregion = count (observation)
collapse (median) price_kg [aw=weight], by (region sregion crop_code obs_sregion)
ren price_kg price_kg_median_sregion
lab var price_kg_median_sregion "Median price per kg for this crop in the sub-region"
lab var obs_sregion "Number of sales observations for this crop in the sub-region"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_sregion.dta", replace

//median price at region level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys region crop_code: egen obs_region = count (observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
ren price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_region.dta", replace

//median price at the country level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
gen observation = 1
bys crop_code: egen obs_country = count (observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
ren price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
merge m:1 region sregion district county parish ea crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_ea.dta", nogen
merge m:1 region sregion district county parish crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_parish.dta", nogen
merge m:1 region sregion district county crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_county.dta",nogen
merge m:1 region sregion district crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_district.dta", nogen
merge m:1 region sregion crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_sregion.dta", nogen
merge m:1 region crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_country.dta",nogen

gen price_kg_hh = price_kg

replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_parish if price_kg==. & obs_parish >= 10 & crop_code!=890
replace price_kg = price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=890
replace price_kg = price_kg_median_country if price_kg==. & obs_country >= 10 & crop_code!=890
lab var price_kg "Price per kg, with missing values imputed using local median values"

gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_values_tempfile.dta", replace

preserve
recode value_harvest_imputed value_sold kgs_harvest kgs_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest kgs_sold, by(hhid crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production"
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
lab var kgs_harvest "Kgs harvested of this crop"
lab var kgs_sold "Kgs sold of this crop"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_crop_values_production.dta", replace
restore
*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested,  

collapse (sum) value_harvest_imputed value_sold, by (hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. 
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
ren value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_crop_production.dta", replace
 
*Plot value of crop production
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (hhid)
ren value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_plot_cropvalue.dta", replace

*Crop values for inputs in agricultural product processing (self-employment)
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_sales.dta", clear
merge m:1 region district county parish ea crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_ea.dta", nogen
merge m:1 region district county parish crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_parish.dta", nogen
merge m:1 region district county crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_county.dta", nogen
merge m:1 region district crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_region.dta", nogen
merge m:1 crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_prices_country.dta", nogen
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=890 /* Don't impute prices for "other" crops */
replace price_kg = price_kg_median_parish if price_kg==. & obs_parish >= 10 & crop_code!=890
replace price_kg = price_kg_median_county if price_kg==. & obs_county >= 10 & crop_code!=890
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=890
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=890
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=890
lab var price_kg "Price per kg, with missing values imputed using local median values"
gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
//keep hhid crop_code price_kg 
//duplicates drop
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_crop_prices.dta", replace

*Crops lost post-harvest
use "${UGA_W4_raw_data}\AGSEC5A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC5B.dta" 

ren hh hhid
ren parcelID parcel_id
ren plotID plot_id
ren cropID crop_code
drop if crop_code==.

gen percent_lost = a5aq16 
replace percent_lost = a5bq16 if percent_lost==. & a5bq16!=.

replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 

collapse (sum) percent_lost, by (hhid crop_code)
merge 1:1 hhid crop_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_crop_values_production.dta" 
drop if _merge==2

gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0) 

collapse (sum) value_lost, by (hhid)
ren value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crop_losses.dta", replace


********************************************************************************
*							LIVESTOCK INCOME			  		 			   *
********************************************************************************
*Expenses
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\raw_data\AGSEC7.dta", clear
ren hh hhid
ren a7bq2e cost_fodder_livestock
ren a7bq3f cost_water_livestock
ren a7bq5d cost_vaccines_livestock /* Includes costs of professional */
recode cost_fodder_livestock cost_water_livestock cost_vaccines_livestock (.=0)

preserve
	collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock, by (hhid)
	egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock)
	keep hhid cost_lrum
	lab var cost_lrum "Livestock expenses for large ruminants"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_lrum_expenses", replace
restore 

preserve 
	ren AGroup_ID livestock_code
	gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,104,108)) + 4*(inlist(livestock_code,109,110)) + 5*(inlist(livestock_code,103,107))
	recode species (0=.)
	la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
	la val species species

	collapse (sum) cost_vaccines_livestock, by (hhid species) 
	ren cost_vaccines_livestock ls_exp_vac
		foreach i in ls_exp_vac{
			gen `i'_lrum = `i' if species==1
			gen `i'_srum = `i' if species==2
			gen `i'_pigs = `i' if species==3
			gen `i'_equine = `i' if species==4
			gen `i'_poultry = `i' if species==5
		}
	
collapse (firstnm) *lrum *srum *pigs *equine *poultry, by(hhid)

	foreach i in ls_exp_vac{
		gen `i' = .
	}
	la var ls_exp_vac "Cost for vaccines and veterinary treatment for livestock"
	
	foreach i in ls_exp_vac{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
	drop ls_exp_vac
	save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_expenses_animal", replace
restore 
 
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock, by (hhid)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for livestock"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_expenses", replace

**Livestock products**
*Milk
use "${UGA_W4_raw_data}\AGSEC8B.dta", clear
ren hh hhid
ren AGroup_ID livestock_code 
keep if livestock_code==101 | livestock_code==102 | livestock_code==105 | livestock_code==106
ren a8bq1 animals_milked
ren a8bq2 months_milked
ren a8bq3 liters_per_day 
recode animals_milked months_milked liters_per_day (.=0)
gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
lab var milk_liters_produced "Liters of milk produced in past 12 months"
ren a8bq5_1 liters_sold_per_day
ren a8bq7 liters_perday_to_cheese 
ren a8bq9 earnings_per_day_milk 
recode liters_sold_per_day liters_perday_to_cheese (.=0)
gen liters_sold_day = liters_sold_per_day + liters_perday_to_cheese 
gen price_per_liter = earnings_per_day_milk / liters_sold_day
gen price_per_unit = price_per_liter
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
gen earnings_milk_year = earnings_per_day_milk*months_milked*30		
keep hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_milk", replace

*Eggs
use "${UGA_W4_raw_data}\AGSEC8C.dta", clear
ren hh hhid
ren AGroup_ID livestock_code
keep if livestock_code==103 | livestock_code==107
ren a8cq1 months_produced //how many animals laid eggs in the last 3 months
ren a8cq2 quantity_month //what quantity of eggs were produced in the last 3 months
recode months_produced quantity_month (.=0)
gen quantity_produced = months_produced * quantity_month
lab var quantity_produced "Quantity of this product produced in past year"
ren a8cq3 sales_quantity
ren a8cq5 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales
replace livestock_code = 21 if livestock_code==103 | livestock_code==107 		
label define livestock_code_label 21 "Eggs"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price of eggs per unit sold"
lab var price_per_unit_hh "Price of eggs per unit sold at household level"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_eggs", replace

use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_milk", clear
append using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_eggs"
recode price_per_unit (0=.)
merge m:1 hhid using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", replace


//median price at ea level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region sregion district county parish ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region sregion district county parish ea livestock_code obs_ea)
ren price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_ea.dta", replace

//median price at parish level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region sregion district county parish livestock_code: egen obs_parish = count(observation)
collapse (median) price_per_unit [aw=weight], by (region sregion district county parish livestock_code obs_parish)
ren price_per_unit price_median_parish
lab var price_median_parish "Median price per unit for this livestock product in the parish"
lab var obs_parish "Number of sales observations for this livestock product in the parish"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_parish.dta", replace

//median price at county level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region sregion district county livestock_code: egen obs_county = count(observation)
collapse (median) price_per_unit [aw=weight], by (region sregion district county livestock_code obs_county)
ren price_per_unit price_median_county
lab var price_median_county "Median price per unit for this livestock product in the county"
lab var obs_county "Number of sales observations for this livestock product in the county"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_county.dta", replace

//median price at district level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region sregion district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region sregion district livestock_code obs_district)
ren price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_district.dta", replace

//median price at sregion level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region sregion livestock_code: egen obs_sregion = count(observation)
collapse (median) price_per_unit [aw=weight], by (region sregion livestock_code obs_sregion)
ren price_per_unit price_median_sregion
lab var price_median_sregion "Median price per unit for this livestock product in the sub-region"
lab var obs_sregion "Number of sales observations for this livestock product in the sub-region"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_sregion.dta", replace

//median price at region level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
ren price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_region.dta", replace

//median price at country level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
ren price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_country.dta", replace

//Pull prices into estimates
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products", clear
merge m:1 region sregion district county parish ea livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_ea.dta", nogen
merge m:1 region sregion district county parish livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_parish.dta", nogen
merge m:1 region sregion district county livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_county.dta",nogen
merge m:1 region sregion district livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_district.dta", nogen
merge m:1 region sregion livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_sregion.dta", nogen
merge m:1 region livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_products_prices_country.dta",nogen

replace price_per_unit  = price_median_ea if price_per_unit==. & obs_ea >= 10 
replace price_per_unit  = price_median_parish if price_per_unit==. & obs_parish >= 10 
replace price_per_unit  = price_median_county if price_per_unit==. & obs_county >= 10 
replace price_per_unit  = price_median_district if price_per_unit==. & obs_district >= 10
replace price_per_unit  = price_median_sregion if price_per_unit==. & obs_sregion >= 10 
replace price_per_unit  = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit  = price_median_country if price_per_unit==. & obs_country >= 10 

gen value_milk_produced = milk_liters_produced * price_per_unit if (livestock_code==101 | livestock_code==102 | livestock_code==105 | livestock_code==106)
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==103 | livestock_code==107

egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		

collapse (sum) value_milk_produced value_eggs_produced sales_livestock_products, by (hhid)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
lab var value_livestock_products "value of livestock prodcuts produced (milk, eggs)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
recode value_milk_produced value_eggs_produced (0=.)
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_products", replace


*Sales (live animals)
use "${UGA_W4_raw_data}\AGSEC6A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC6B.dta"
append using "${UGA_W4_raw_data}\AGSEC6C.dta"

ren hh hhid
gen livestock_code = LiveStockID
replace livestock_code = ALiveStock_Small_ID if livestock_code==. & ALiveStock_Small_ID!=.
replace livestock_code = APCode if livestock_code==. & APCode!=.



gen price_per_animal = a6aq14b          //On average what was the value of each sold?
replace price_per_animal = a6bq14b if price_per_animal==. & a6bq14b!=.
replace price_per_animal = a6cq14b if price_per_animal==. & a6cq14b!=.

gen number_sold = a6aq14a
replace number_sold = a6bq14a if number_sold==. & a6bq14a!=.
replace number_sold = 4*a6cq14a if number_sold==. & a6cq14a!=.  

gen income_live_sales = number_sold*price_per_animal // average total sales value of all sold
lab var income_live_sales "Average total income from animals sold"

gen number_slaughtered = a6aq15
replace number_slaughtered = a6bq15 if number_slaughtered ==. & a6bq15!=.
replace number_slaughtered = 4*a6cq15 if number_slaughtered ==. & a6cq15!=.

gen value_livestock_purchases = (a6aq13a*a6aq13b) //number of [animal] bought in last year*average value of each [animal] bought
replace value_livestock_purchases = (a6bq13a*a6bq13b) if value_livestock_purchases==. & a6bq13b!=. & a6bq13a!=. //number of [animal] bought in last year*average value of each [animal] bought
replace value_livestock_purchases = ((a6cq13a*4)*a6cq13b) if value_livestock_purchases==. & a6cq13b!=. & a6cq13a!=. //number of [animal] bought in past three months*4*average value of each [animal] bought

recode income_live_sales number_sold price_per_animal number_slaughtered value_livestock_purchases (.=0)
 
merge m:1 hhid using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)

keep hhid weight region sregion district county parish ea livestock_code number_sold income_live_sales number_slaughtered price_per_animal value_livestock_purchases

save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", replace


**Implicit prices
*ea level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region sregion district county parish ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region sregion district county parish ea livestock_code obs_ea)
ren price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_ea.dta", replace

*parish level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region sregion district county parish livestock_code: egen obs_parish = count(observation)
collapse (median) price_per_animal [aw=weight], by (region sregion district county parish livestock_code obs_parish)
ren price_per_animal price_median_parish
lab var price_median_parish "Median price per unit for this livestock in the parish"
lab var obs_parish "Number of sales observations for this livestock in the parish"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_parish.dta", replace

*county level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region sregion district county livestock_code: egen obs_county = count(observation)
collapse (median) price_per_animal [aw=weight], by (region sregion district county livestock_code obs_county)
ren price_per_animal price_median_county
lab var price_median_county "Median price per unit for this livestock in the county"
lab var obs_county "Number of sales observations for this livestock in the county"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_county.dta", replace

*district level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region sregion district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region sregion district livestock_code obs_district)
ren price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_district.dta", replace

*sub-region level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region sregion livestock_code: egen obs_sregion = count(observation)
collapse (median) price_per_animal [aw=weight], by (region sregion livestock_code obs_sregion)
ren price_per_animal price_median_sregion
lab var price_median_sregion "Median price per unit for this livestock in the sub-region"
lab var obs_sregion "Number of sales observations for this livestock in the sub-region"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_sregion.dta", replace

*region level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
ren price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_region.dta", replace

*country level
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
ren price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_country.dta", replace

use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_sales", clear
merge m:1 region sregion district county parish ea livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_ea.dta", nogen
merge m:1 region sregion district county parish livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_parish.dta", nogen
merge m:1 region sregion district county livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_county.dta",nogen
merge m:1 region sregion district livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_district.dta", nogen
merge m:1 region sregion livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_sregion.dta", nogen
merge m:1 region livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_country.dta",nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_parish if price_per_animal==. & obs_parish >= 10
replace price_per_animal = price_median_county if price_per_animal==. & obs_county >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_sregion if price_per_animal==. & obs_sregion >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 

lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"

gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered 
gen value_livestock_sales = value_lvstck_sold + value_slaughtered // NKF 7.10.19 no value of slaughtered sold, so use value of slaughtered animal multiplied by live price
collapse (sum) value_livestock_sales value_livestock_purchases value_lvstck_sold value_slaughtered, by (hhid)
drop if hhid==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_sales", replace
 

*TLU (Tropical Livestock Units)
use "${UGA_W4_raw_data}\AGSEC6A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC6B.dta"
append using "${UGA_W4_raw_data}\AGSEC6C.dta"

ren hh hhid
gen livestock_code = LiveStockID
replace livestock_code = ALiveStock_Small_ID if livestock_code==. & ALiveStock_Small_ID!=.
replace livestock_code = APCode if livestock_code==. & APCode!=.

gen tlu_coefficient=0.5 if (livestock_code==1|livestock_code==2|livestock_code==3|livestock_code==4|livestock_code==5|livestock_code==6|livestock_code==7|livestock_code==8|livestock_code==9|livestock_code==10|livestock_code==11) 
//Calves, Bulls, Oxen, Heifers, Horses (indigenous and exotic)
replace tlu_coefficient=0.45 if livestock_code==12 // Donkeys/ Mules are a combined variable in this instrument, donkeys are .3 and mules are .6, so using average of .45
replace tlu_coefficient=0.1 if livestock_code==13|livestock_code==14|livestock_code==15|livestock_code==16|livestock_code==18|livestock_code==19|livestock_code==20|livestock_code==21 //goats, sheep (indigenous and exotic)
replace tlu_coefficient=.3 if livestock_code==17|livestock_code==22 //pigs (indigenous and exotic)
replace tlu_coefficient=.01 if livestock_code==23|livestock_code==24|livestock_code==25|livestock_code==26|livestock_code==27 //chickens (indigenous and exotic), other poultry, rabbits
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

gen number_1yearago = a6aq6
replace number_1yearago = a6bq6 if number_1yearago==. & a6bq6!=. //in questionnaire a6bq6 asks about past 12 months, but in dta file label refers to past 6 months, we are assuming questionnaire is correct
replace number_1yearago = a6cq6 if number_1yearago==. & a6cq6!=. // a6cq6 is only for past 3 months, so we are assuming number owned 12 months ago is same as number owned 3 months ago

gen number_today = a6aq3a 
replace number_today = a6bq3a if number_today==. & a6bq3a!=.
replace number_today = a6cq3a if number_today==. & a6cq3a!=. 

gen number_today_exotic = number_today if inlist(livestock_code,1,2,3,4,5,13,14,15,16,17,24,25)

gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
ren a6aq14b income_individual_sale // on  average
replace income_individual_sale = a6bq14b if income_individual_sale==. & a6bq14b!=.
replace income_individual_sale = a6cq14b if income_individual_sale==. & a6cq14b!=.
ren a6aq14a number_sold
replace number_sold = a6bq14a if number_sold==. & a6bq14a!=.
replace number_sold = 4*a6cq14a if number_sold==. & a6cq14a!=. //multiplying by four because variable is only for three months
gen income_live_sales = income_individual_sale*number_sold // on average
 
ren a6aq12 lost_disease
replace lost_disease = a6bq12 if lost_disease==. & a6bq12!=.
replace lost_disease = 4*a6cq12 if lost_disease==. & a6cq12!=. //multiplying by four because variable is only for three months

ren a6aq11 lost_injury 
replace lost_injury = a6bq11 if lost_injury==. & a6bq11!=.
replace lost_injury = 4*a6cq11 if lost_injury==. & a6cq11!=. //multiplying by four because variable is only for three months

ren a6aq10 lost_theft 
replace lost_theft = a6bq10 if lost_theft==. & a6bq10!=.
replace lost_theft = 4*a6cq10 if lost_theft==. & a6cq10!=. //multiplying by four because variable is only for three months

egen mean_12months = rowmean(number_today number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_injury lost_theft)

gen herd_cows_indigenous = number_today if livestock_code==10
gen herd_cows_exotic = number_today if livestock_code==5
egen herd_cows_tot = rowtotal(herd_cows_indigenous herd_cows_exotic)
gen share_imp_herd_cows = herd_cows_exotic / herd_cows_tot

gen species = (inlist(livestock_code,1,2,3,4,5,6,7,8,9,10)) + 2*(inlist(livestock_code,13,14,15,16,18,19,20,21)) + 3*(inlist(livestock_code,17,22)) + 4*(inlist(livestock_code,11,12)) + 5*(inlist(livestock_code,23,24,25,26,27))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry and Rabbits"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lost_disease lvstck_holding=number_today, by(hhid species)
	egen mean_12months = rowmean(number_today number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
	
	foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease {
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
	
	foreach i in lvstck_holding animals_lost12months mean_12months lost_disease {
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost to disease or injury"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	lab var lost_disease "Total number of livestock lost to disease" 
	
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
	save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_herd_characteristics", replace
restore


gen price_per_animal = income_live_sales / number_sold
merge m:1 hhid using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region sregion district county parish ea livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_ea.dta", nogen
merge m:1 region sregion district county parish livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_parish.dta", nogen
merge m:1 region sregion district county livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_county.dta",nogen
merge m:1 region sregion district livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_district.dta", nogen
merge m:1 region sregion livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_sregion.dta", nogen
merge m:1 region livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_prices_country.dta",nogen
recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_parish if price_per_animal==. & obs_parish >= 10
replace price_per_animal = price_median_county if price_per_animal==. & obs_county >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_sregion if price_per_animal==. & obs_sregion >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_TLU.dta", replace


*Livestock income
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_sales", clear
merge 1:1 hhid using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_hh_livestock_products"
drop _merge
merge 1:1 hhid using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_livestock_expenses"
drop _merge
merge 1:1 hhid using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_TLU.dta"
drop _merge

gen livestock_income = value_lvstck_sold + value_slaughtered - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced) /*
*/ - (cost_water_livestock + cost_fodder_livestock + cost_vaccines_livestock)

lab var livestock_income "Net livestock income"
save "$UGA_W4_created_data\Uganda_NPS_LSMS_ISA_W4_livestock_income", replace


********************************************************************************
*							 WAGE INCOME			 		  		   			*
********************************************************************************
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\uganda-wave4-2013-14\raw_data\GSEC8_1.dta", clear
ren HHID hhid
gen wage_yesno = h8q5==1 // did any wage work in the last 12 months y/n
ren h8q30a number_months // months worked for main job
ren h8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12
egen hours_pastweek = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g)
gen number_hours = hours_pastweek*number_weeks

gen most_recent_payment = h8q31a // cash and in-kind payments
gen most_recent_payment_other = h8q31b
ren h8q31c payment_period 
ren h8q37 secwage_yesno // did they have a secondary wage?
ren h8q45a secwage_most_recent_payment
ren h8q45b secwage_most_recent_pay_other
ren h8q45c secwage_payment_period
ren h8q43 secwage_hours_pastweek

gen annual_salary_cash = (number_months*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = ((number_hours/8)*most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace annual_salary_cash = (number_hours*most_recent_payment) if payment_period==1

gen second_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace second_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace second_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace second_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

gen annual_salary_in_kind = (number_months*most_recent_payment_other) if secwage_payment_period==4
replace annual_salary_in_kind = (number_weeks*most_recent_payment_other) if secwage_payment_period==3
replace annual_salary_in_kind = ((number_hours/8)*most_recent_payment_other) if secwage_payment_period==2 // assuming 8 hour workdays 
replace annual_salary_in_kind = (number_hours*most_recent_payment_other) if secwage_payment_period==1

gen second_salary_in_kind = (number_months*secwage_most_recent_pay_other) if secwage_payment_period==4
replace second_salary_in_kind = (number_weeks*secwage_most_recent_pay_other) if secwage_payment_period==3
replace second_salary_in_kind = ((number_hours/8)*secwage_most_recent_pay_other) if secwage_payment_period==2 // assuming 8 hour workdays 
replace second_salary_in_kind = (number_hours*secwage_most_recent_pay_other) if secwage_payment_period==1

recode annual_salary_cash second_salary_cash annual_salary_in_kind second_salary_in_kind (.=0)
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from all wages"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_wage_income.dta", replace


********************************************************************************
*							AG WAGE INCOME							  		   *
********************************************************************************
use "${UGA_W4_raw_data}\GSEC8_1.dta", clear
ren HHID hhid
gen wage_yesno = h8q5==1 // did any wage work in the last 12 months y/n
ren h8q30a number_months // months worked for main job
ren h8q30b number_weeks_per_month //weeks per month worked for main job
gen number_weeks = number_weeks_per_month*12
egen hours_pastweek = rowtotal(h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g)
gen number_hours = hours_pastweek*number_weeks

destring h8q38B, replace // Primary wage variable is long, secondary is string, so de-stringing

gen agwage = 1 if ((h8q19B>=6111 & h8q19B<=6340) | (h8q19B>=9211 & h8q19B<=9216))	//Based on ISCO classifications used in Basic Information Document used for Wave 4
gen secagwage = 1 if ((h8q38B>=6111 & h8q38B<=6340) | (h8q38B>=9211 & h8q38B<=9216))	//Based on ISCO classifications used in Basic Information Document used for Wave 4

gen most_recent_payment = h8q31a // cash and in-kind payments
replace most_recent_payment = . if agwage!=1
gen most_recent_payment_other = h8q31b
replace most_recent_payment_other = . if agwage!=1
ren h8q31c payment_period 
ren h8q37 secwage_yesno // did they have a secondary wage?

ren h8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if secagwage!=1
ren h8q45b secwage_most_recent_pay_other

ren h8q45c secwage_payment_period
ren h8q43 secwage_hours_pastweek

gen annual_salary_cash = (number_months*most_recent_payment) if payment_period==4
replace annual_salary_cash = (number_weeks*most_recent_payment) if payment_period==3
replace annual_salary_cash = ((number_hours/8)*most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace annual_salary_cash = (number_hours*most_recent_payment) if payment_period==1

gen second_salary_cash = (number_months*secwage_most_recent_payment) if payment_period==4
replace second_salary_cash = (number_weeks*secwage_most_recent_payment) if payment_period==3
replace second_salary_cash = ((number_hours/8)*secwage_most_recent_payment) if payment_period==2 // assuming 8 hour workdays 
replace second_salary_cash = (number_hours*secwage_most_recent_payment) if payment_period==1

gen annual_salary_in_kind = (number_months*most_recent_payment_other) if secwage_payment_period==4
replace annual_salary_in_kind = (number_weeks*most_recent_payment_other) if secwage_payment_period==3
replace annual_salary_in_kind = ((number_hours/8)*most_recent_payment_other) if secwage_payment_period==2 // assuming 8 hour workdays 
replace annual_salary_in_kind = (number_hours*most_recent_payment_other) if secwage_payment_period==1

gen second_salary_in_kind = (number_months*secwage_most_recent_pay_other) if secwage_payment_period==4
replace second_salary_in_kind = (number_weeks*secwage_most_recent_pay_other) if secwage_payment_period==3
replace second_salary_in_kind = ((number_hours/8)*secwage_most_recent_pay_other) if secwage_payment_period==2 // assuming 8 hour workdays 
replace second_salary_in_kind = (number_hours*secwage_most_recent_pay_other) if secwage_payment_period==1

recode annual_salary_cash second_salary_cash annual_salary_in_kind second_salary_in_kind (.=0)
gen annual_salary = annual_salary_cash + second_salary_cash + annual_salary_in_kind + second_salary_in_kind
collapse (sum) annual_salary, by (hhid)
ren annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_agwage_income.dta", replace


********************************************************************************
*								OTHER INCOME						  		   *
********************************************************************************
use "${UGA_W4_raw_data}\GSEC11A.dta", clear
append using "${UGA_W4_raw_data}\GSEC11B.dta"

ren HHID hhid
gen rental_income_cash = h11q5 if (h11q2==21 | h11q2==22 | h11q2==23)
gen rental_income_inkind = h11q6 if (h11q2==21 | h11q2==22 | h11q2==23)
gen pension_income_cash = h11q5 if h11q2==41
gen pension_income_inkind = h11q6 if h11q2==41
gen other_income_cash = h11q5 if (h11q2==45 | h11q2==44 | h11q2==41 | h11q2==36 | h11q2==35 | h11q2==34 | h11q2==33 | h11q2==32 | h11q2==31) 
gen other_income_inkind = h11q6 if (h11q2==45 | h11q2==44 | h11q2==41 | h11q2==36 | h11q2==35 | h11q2==34 | h11q2==33 | h11q2==32 | h11q2==31)
gen remittance_cash = h11q5 if h11q2==42 | h11q2==43
gen remittance_inkind = h11q6 if h11q2==42 | h11q2==43
recode rental_income_cash rental_income_inkind pension_income_cash pension_income_inkind other_income_cash other_income_inkind remittance_cash remittance_inkind (.=0)
gen rental_income = rental_income_cash + rental_income_inkind
gen pension_income = pension_income_cash + pension_income_inkind
gen other_income = other_income_cash + other_income_inkind
gen remittance_income = remittance_cash + remittance_inkind
collapse (sum) rental_income pension_income other_income remittance_income, by (hhid)

lab var rental_income "Estimated income from rentals of buildings, property, land over previous 12 months"
lab var pension_income "Estimated income from a pension and life insurance annuity benefits over previous 12 months"
lab var other_income "Estimated income from any OTHER source over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_other_income.dta", replace

use "${UGA_W4_raw_data}\AGSEC2A.dta", clear
ren hh hhid
ren a2aq14 land_rental_income
recode land_rental_income (.=0)
collapse (sum) land_rental_income, by (hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_land_rental_income.dta", replace


********************************************************************************
*								FARM SIZE / LAND SIZE				  		   *
********************************************************************************
*Determining whether crops were grown on a plot
use "${UGA_W4_raw_data}\AGSEC4A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC4B.dta"
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
ren plotID plot_id
drop if plot_id==.
ren ACropCode crop_code
replace crop_code= ACrop2_ID if crop_code==.
drop if crop_code==.
gen crop_grown = 1 
collapse (max) crop_grown, by(hhid parcel_id)
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crops_grown.dta", replace

**
use "${UGA_W4_raw_data}\AGSEC2A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC2B.dta"
ren hh hhid
gen cultivated = (a2aq11a==1 | a2aq11b==1)
ren parcelID parcel_id
collapse (max) cultivated, by (hhid parcel_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcels_cultivated.dta", replace

**
use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcels_cultivated.dta", clear
merge 1:1 hhid parcel_id using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcel_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_land_size.dta", replace

*All agricultural land
use "${UGA_W4_raw_data}\AGSEC2A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC2B.dta"
*ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
merge m:1 hhid parcel_id using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_crops_grown.dta", nogen
*5,155 matched
*281 not matched (from master)
gen rented_out = (a2aq11a==3 | a2aq11b==3) 
//NKF 10.4.19 2nd cropping season is "short"
gen cultivated_short = (a2aq11b==1 | a2aq11b==2) //own cultivated annual and perennial crops
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
*3 changes made
drop if rented_out==1 & crop_grown!=1
*31 obs dropped
gen agland = a2aq11a==1 | a2aq11a==2 | a2aq11a==5 | a2aq11a==6| a2aq11b==1 | a2aq11b==2 | a2aq11b==5 | a2aq11b==6 // includes cultivated, fallow, pasture
drop if agland!=1 & crop_grown==.
*67 obs dropped
collapse (max) agland, by (hhid parcel_id)
lab var agland "1= Parcel was used for crop cultivation or pasture or left fallow in this past year (forestland and other uses excluded)"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcels_agland.dta", replace

use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcels_agland.dta", clear
merge 1:1 hhid parcel_id using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcel_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_farmsize_all_agland.dta", replace

use "${UGA_W4_raw_data}\AGSEC2A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC2B.dta"
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
gen rented_out = (a2aq11a==3 | a2aq11b==3) 
gen cultivated_short = (a2aq11b==1 | a2aq11b==2)
bys hhid parcel_id: egen parcel_cult_short = max(cultivated_short)
replace rented_out = 0 if parcel_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen parcel_held = 1
collapse (max) parcel_held, by (hhid parcel_id)
lab var parcel_held "1= Parcel was NOT rented out in the main season"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcels_held.dta", replace

use "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcels_held.dta", clear
merge 1:1 hhid parcel_id using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcel_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (hhid)
ren area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all parcels listed by the household except those rented out" 
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${UGA_W4_raw_data}\AGSEC2A.dta", clear
append using "${UGA_W4_raw_data}\AGSEC2B.dta"
ren hh hhid
ren parcelID parcel_id
drop if parcel_id==.
merge m:1 hhid parcel_id using "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_parcel_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (max) area_acres_meas, by(hhid parcel_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by(hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${UGA_W4_created_data}\Uganda_NPS_LSMS_ISA_W4_land_size_total.dta", replace


********************************************************************************
*									OFF-FARM HOURS							   *
********************************************************************************
use "${UGA_W4_raw_data}\GSEC8_1.dta", clear
ren HHID hhid
*Use ISIC codes for non-farm activities
egen primary_hours = rowtotal (h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g) if (h8q19B<6111 | (h8q19B>6340 & h8q19B<9211) | h8q19B>9216) //Based on ISCO classifications used in Basic Information Document used for Wave 4
gen secondary_hours = h8q43 if (h8q19B<6111 | (h8q19B>6340 & h8q19B<9211) | h8q19B>9216) //Based on ISCO classifications used in Basic Information Document used for Wave 4

egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(hhid)

la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_off_farm_hours.dta", replace




********************************************************************************
*					LIVESTOCK WATER, FEEDING, AND HOUSING 					   *
********************************************************************************
use "${UGA_W4_raw_data}/AGSEC7.dta", clear
ren hh hhid
gen feed_grazing = (a7bq2a==1 | a7bq2b==2) // only grazing or mainly grazing
lab var feed_grazing "1=HH feeds only or mainly by grazing"
gen water_source_nat = (a7bq3b==5 | a7bq3b==6 | a7bq3b==7) //river, spring, stream, 
gen water_source_const = (a7bq3b==1 | a7bq3b==2 | a7bq3b==3 | a7bq3b==4 |a7bq3b==8 | a7bq3b==9 | a7bq3b==10) //constructed water points, rainwater harvesting, tap water, borehole, dam, well 
gen water_source_cover = (a7bq3b==1 | a7bq3b==2) //covered water tapwater, borehole
lab var water_source_nat "1=HH water livestock using natural source"
lab var water_source_const "1=HH water livestock using constructed source"
lab var water_source_cover "1=HH water livestock using covered source"
gen lvstck_housed = (a7abq4==2 | a7abq4==3 | a7abq4==4 | a7abq4==5 | a7abq4==6 ) // Confined in: sheds, paddocks, fences, cage , basket. Does not include "none" and "other/ not specified"
lab var lvstck_housed "1=HH used enclosed housing system for livestock" 
ren AGroup_ID livestock_code
gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,104,108)) + 4*(inlist(livestock_code,109,110)) + 5*(inlist(livestock_code,103,107))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry" 
la val species species

*A loop to create species variables
foreach i in feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}
collapse (max) feed_grazing* water_source* lvstck_housed*, by (hhid)
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
	lab var `i'_equine "`l`i'' - equine"
	lab var `i'_poultry "`l`i'' - poultry"
}
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_livestock_feed_water_house.dta", replace



********************************************************************************
*							REACHED BY AG EXTENSION							   *
********************************************************************************
use "${UGA_W4_raw_data}/AGSEC9.dta", clear
ren hh hhid
ren a9q3 receive_advice
ren a9q2 sourceid
**Government Extension
gen advice_gov = (sourceid==1 & receive_advice==1)
**Input Supplier
gen advice_input = (sourceid==2 & receive_advice==1)
**NGO
gen advice_ngo = (sourceid==3 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==4 & receive_advice==1)
**Large Scale Farmer
gen advice_farmer =(sourceid==5 & receive_advice==1)
**Other
gen advice_other = (sourceid==6 & receive_advice==1)

**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_input==1)
gen ext_reach_unspecified=(advice_other==1)
//gen ext_reach_ict=(advice_radio==1) // NKF 12.4.19 ICT not included in this instrument, so can't construct
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
//lab var ext_reach_ict "1 = Household reached by extensition services through ICT"
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_any_ext.dta", replace




********************************************************************************
*								EGG PRODUCTIVITY							   *
********************************************************************************
use "${UGA_W4_raw_data}/AGSEC6C.dta", clear
append using "${UGA_W4_raw_data}/AGSEC8C.dta"
ren hh hhid
gen poultry_owned = a6cq3a if APCode==23 | 24 // including both "Indigenous dual-purpose chicken"  "Layers (exotic/cross chicken)"collapse (sum) poultry_owned, by(hhid)
//gen eggs_months =  // NKF 12.5.19 I don't have a variable that says how many months eggs were produced
gen eggs_per_quarter = a8cq2
gen eggs_per_month = eggs_per_quarter/3
gen eggs_total_year = 12*eggs_per_month // NKF 12.5.19 assuming same egg production across every month due to lack of eggs_months variable			
keep hhid eggs_per_month eggs_total_year poultry_owned 
//lab var eggs_months "Number of months eggs were produced (household)" // NKF 12.5.19 I don't have a variable that says how many months eggs were produced
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_eggs_animals.dta", replace



********************************************************************************
*							AGRICULTURAL WAGES								   *
********************************************************************************
use "${UGA_W4_raw_data}/AGSEC3A.dta", clear
append using "${UGA_W4_raw_data}/AGSEC3B.dta"
ren hh hhid
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode a3aq35* a3bq35* (0=.)
ren a3aq35a hired_male_labor
replace hired_male_labor= a3bq35a if hired_male_labor==.
ren a3aq35b hired_female_labor
replace hired_female_labor = a3bq35b if hired_female_labor==.
ren a3aq36 hlabor_paid
replace hlabor_paid = a3bq36 if hlabor_paid==.
recode hired* hlabor* (.=0)
*first collapse accross plot  to houshold level
collapse (sum) hired* hlabor*, by(hhid)
* get weighted average of paid wage at household level
gen hirelabor=(hired_male_labor+hired_female_labor)
gen wage_paid_aglabor=hlabor_paid/hirelabor
recode wage_paid_aglabor hirelabor (.=0)
*later will use hired_labor*weight for the summary stats on wage 
keep hhid wage_paid_aglabor 
lab var wage_paid_aglabor "Daily wage in agriculture"
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_ag_wage.dta", replace





 

********************************************************************************
*							SHANNON DIVERSITY INDEX							   *
********************************************************************************
*Area planted
*Bringing in area planted for LRS
use "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_crop_area_plan_FCS.dta", clear
append using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_crop_area_plan_SCS.dta"
//we don't want to count crops that are grown in the SCS and FCS as different.
collapse (sum) area_plan*, by(hhid cropID)
*Some households have crop observations, but the area planted=0. These are permanent crops. Right now they are not included in the SDI unless they are the only crop on the plot, but we could include them by estimating an area based on the number of trees planted
*drop if area_plan==0
drop if cropID==.
*generating area planted of each crop as a proportion of the total area
preserve 
collapse (sum) area_plan_hh=area_plan area_plan_female_hh=area_plan_female area_plan_male_hh=area_plan_male area_plan_mixed_hh=area_plan_mixed, by(hhid)
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_crop_area_plan_shannon.dta", replace
restore
merge m:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_crop_area_plan_shannon.dta", nogen		//___ matched
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
bysort hhid cropID : gen nvals_tot = _n==1
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
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_shannon_diversity_index.dta", replace
 

 
 *******************************************************************************
*HOUSEHOLD FOOD PROVISION						   *
********************************************************************************
use "${UGA_W4_raw_data}/GSEC17_2.dta", clear
ren HHID hhid
egen months_food_insec = sum(h17q10a==1), by(hhid)
collapse months_food_insec, by(hhid)
keep hhid months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_food_insecurity.dta", replace



********************************************************************************
*								HOUSEHOLD ASSETS							   *
********************************************************************************
use "${UGA_W4_raw_data}/GSEC14A.dta", clear
ren HHID hhid
//ren  price_purch //NKF 12.30.19 variable not in this instrument
ren h14q5 value_today
//ren age_item //NKF 12.30.19 variable not in this instrument
ren h14q4 num_items
collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_assets.dta", replace 




 *******************************************************************************
*							HOUSEHOLD VARIABLES								   *
********************************************************************************
global empty_vars ""
use "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hhids.dta", clear

*Gross crop income 
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_crop_production.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_crop_losses.dta", nogen
recode value_crop_production crop_value_lost (.=0)
*Variables: value_crop_production crop_value_lost

*Crop costs
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_asset_rental_costs.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_rental_costs.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_seed_costs.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_fertilizer_costs.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_wages_shortseason.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_wages_mainseason.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_transportation_cropsales.dta", nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_herbicide value_pesticide wages_paid_short wages_paid_main transport_costs_cropsales)
gen crop_income = value_crop_production - crop_production_expenses - crop_value_lost
lab var crop_production_expenses "Crop production expenditures (explicit)"
lab var crop_income "Net crop revenue"

*top crop costs by area planted
foreach c in $topcropname_area {
	merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_rental_costs_`c'.dta", nogen
	merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_fertilizer_costs_`c'.dta", nogen
	merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_`c'_monocrop_hh_area.dta", nogen
}
*top crop costs that are only present in short season
foreach c in $topcropname_short{
	merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_wages_shortseason_`c'.dta", nogen
}
*costs that only include annual crops (seed costs and mainseason wages)
foreach c in $topcropname_annual {
	merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_seed_costs_`c'.dta", nogen
	merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_wages_mainseason_`c'.dta", nogen
}

*generate missing vars to run code that collapses all costs
global missing_vars wages_paid_short_sunflr wages_paid_short_pigpea wages_paid_short_wheat wages_paid_short_pmill cost_seed_cassav cost_seed_banana wages_paid_main_cassav wages_paid_main_banana
foreach v in $missing_vars{
	gen `v' = . 
	foreach i in male female mixed{
		gen `v'_`i' = .
	}
}
foreach c in $topcropname_area {
	recode `c'_monocrop (.=0) 
	egen `c'_exp = rowtotal(rental_cost_land_`c' cost_seed_`c' value_fertilizer_`c' value_herbicide_`c' value_pesticide_`c' wages_paid_short_`c' wages_paid_main_`c')
	lab var `c'_exp "Crop production costs(explicit)-Monocrop `c' plots only"
	la var `c'_monocrop_ha "Total `c' monocrop hectares planted - Household"		
	*disaggregate by gender of plot manager
	foreach i in male female mixed{
		egen `c'_exp_`i' = rowtotal(rental_cost_land_`c'_`i' cost_seed_`c'_`i' value_fertilizer_`c'_`i' value_herbicide_`c'_`i' value_pesticide_`c'_`i' wages_paid_short_`c'_`i' wages_paid_main_`c'_`i')
		local l`c'_exp : var lab `c'_exp
		la var `c'_exp_`i' "`l`c'_exp' - `i' managed plots"
	}
	replace `c'_exp = . if `c'_monocrop_ha==.			// set to missing if the household does not have any monocropped plots
	foreach i in male female mixed{
		replace `c'_exp_`i' = . if `c'_monocrop_ha_`i'==.
	}
}

*land rights
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_rights_hh.dta", nogen
la var formal_land_rights_hh "Household has documentation of land rights (at least one plot)"

*Livestock income
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_livestock_sales", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_livestock_products", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_dung.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_livestock_expenses", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_TLU.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_herd_characteristics", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_TLU_Coefficients.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_livestock_expenses_animal.dta", nogen 
gen livestock_income = value_slaughtered + value_lvstck_sold - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_dung) /* 
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock)
lab var livestock_income "Net livestock income"
gen livestock_expenses = cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_water_livestock
ren cost_vaccines_livestock ls_exp_vac  
drop value_livestock_purchases value_other_produced sales_dung cost_hired_labor_livestock cost_fodder_livestock cost_water_livestock
lab var sales_livestock_products "Value of sales of livestock products"
lab var value_livestock_products "Value of livestock products"
lab var livestock_expenses "Total livestock expenses"


*Fish income
// Can't construct in this instrument

*Self-employment income
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_self_employment_income.dta", nogen
//merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_fish_trading_income.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_agproducts_profits.dta", nogen
egen self_employment_income = rowtotal(annual_selfemp_profit byproduct_profits)
lab var self_employment_income "Income from self-employment"
drop annual_selfemp_profit byproduct_profits 

*Wage income
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_wage_income.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_agwage_income.dta", nogen
recode annual_salary annual_salary_agwage(.=0)
ren annual_salary nonagwage_income
ren annual_salary_agwage agwage_income

*Off-farm hours
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_off_farm_hours.dta", nogen

*Other income
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_other_income.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_rental_income.dta", nogen
egen transfers_income = rowtotal (pension_income remittance_income assistance_income)
lab var transfers_income "Income from transfers including pension, remittances, and assisances)"
egen all_other_income = rowtotal (rental_income other_income  land_rental_income)
lab var all_other_income "Income from all other revenue"
drop pension_income remittance_income assistance_income rental_income other_income land_rental_income

*Farm size
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_size.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_size_all.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_farmsize_all_agland.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_size_total.dta", nogen
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
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_family_hired_labor.dta", nogen
recode   labor_hired labor_family (.=0)
  
*Household size
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hhsize.dta", nogen

*Rates of vaccine usage, improved seeds, etc.
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_vaccine.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_fert_use.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_improvedseed_use.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_any_ext.dta", nogen
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_fin_serv.dta", nogen
recode use_fin_serv* ext_reach* use_inorg_fert imprv_seed_use vac_animal (.=0)
replace vac_animal=. if tlu_today==0 
replace use_inorg_fert=. if farm_area==0 | farm_area==. 
recode ext_reach* (0 1=.) if (value_crop_production==0 & livestock_income==0 & farm_area==0 & tlu_today==0)
recode ext_reach* (0 1=.) if farm_area==.
replace imprv_seed_use=. if farm_area==.
global empty_vars $empty_vars imprv_seed_cassav imprv_seed_banana hybrid_seed_*

*Milk productivity
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_milk_animals.dta", nogen
gen liters_milk_produced=liters_per_largeruminant * milk_animals
lab var liters_milk_produced "Total quantity (liters) of milk per year" 
drop liters_per_largeruminant
gen liters_per_cow = . 
gen liters_per_buffalo = . 

*Dairy costs 
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_lrum_expenses", nogen
gen avg_cost_lrum = cost_lrum/mean_12months_lrum 
lab var avg_cost_lrum "Average cost per large ruminant"
gen costs_dairy = avg_cost_lrum*milk_animals 
*gen costs_dairy_percow == avg_cost_lrum
gen costs_dairy_percow=. 
drop avg_cost_lrum cost_lrum
lab var costs_dairy "Dairy production cost (explicit)"
lab var costs_dairy_percow "Dairy production cost (explicit) per cow"
gen share_imp_dairy = . 

*Egg productivity
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_eggs_animals.dta", nogen
gen egg_poultry_year = . 
global empty_vars $empty_vars *liters_per_cow *liters_per_buffalo *costs_dairy_percow* share_imp_dairy *egg_poultry_year

*Costs of crop production per hectare
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_cropcosts_total.dta", nogen

*Rate of fertilizer application 
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_fertilizer_application.dta", nogen

*Agricultural wage rate
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_ag_wage.dta", nogen

*Crop yields 
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_yield_hh_crop_level.dta", nogen

*Total area planted and harvested accross all crops, plots, and seasons
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_area_planted_harvested_allcrops.dta", nogen

*Household diet
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_household_diet.dta", nogen

*Consumption
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_consumption.dta", nogen

*Household assets
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hh_assets.dta", nogen

*Food insecurity
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_food_insecurity.dta", nogen
gen hhs_little = . 
gen hhs_moderate = . 
gen hhs_severe = . 
gen hhs_total = . 
global empty_vars $empty_vars hhs_* 

*Distance to agrodealer // cannot construct 
gen dist_agrodealer = . 
global empty_vars $empty_vars *dist_agrodealer
 
*Livestock health
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_livestock_diseases.dta", nogen

*livestock feeding, water, and housing
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_livestock_feed_water_house.dta", nogen
 
*Shannon diversity index
merge 1:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_shannon_diversity_index.dta", nogen
 
*Farm Production 
gen value_farm_production = value_crop_production + value_livestock_products + value_slaughtered + value_lvstck_sold
lab var value_farm_production "Total value of farm production (crops + livestock products)"
gen value_farm_prod_sold = value_crop_sales + sales_livestock_products + value_livestock_sales 
lab var value_farm_prod_sold "Total value of farm production that is sold" 
replace value_farm_prod_sold = 0 if value_farm_prod_sold==. & value_farm_production!=.

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
//recode fishing_income (.=0)
//gen fishing_hh = (fishing_income!=0)
//lab  var fishing_hh "1= Household has some fishing income"

****getting correct subpopulations***** 
*Recoding missings to 0 for households growing crops
recode grew* (.=0)
*all rural households growing specific crops 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (.=0) if grew_`cn'==1
	recode value_harv_`cn' value_sold_`cn' kgs_harvest_`cn' total_planted_area_`cn' total_harv_area_`cn' `cn'_exp (nonmissing=.) if grew_`cn'==0
}

//IHS 9.18 
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
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode lost_disease_`i' ls_exp_vac_`i' disease_animal_`i' feed_grazing_`i' water_source_nat_`i' water_source_const_`i' water_source_cover_`i' lvstck_housed_`i'(.=0) if lvstck_holding_`i'==1	
}
 
*households engaged in crop production
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (.=0) if crop_hh==1
recode cost_expli_hh value_crop_production value_crop_sales labor_hired labor_family farm_size_agland all_area_harvested all_area_planted (nonmissing=.) if crop_hh==0
 
*all rural households engaged in livestock production 
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (.=0) if livestock_hh==1
recode animals_lost12months* mean_12months* livestock_expenses disease_animal feed_grazing water_source_nat water_source_const water_source_cover lvstck_housed (nonmissing=.) if livestock_hh==0
 
*all rural households 
recode off_farm_hours crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income value_assets (.=0)
*all rural households engaged in dairy production
recode costs_dairy liters_milk_produced value_milk_produced (.=0) if dairy_hh==1 
recode costs_dairy liters_milk_produced value_milk_produced (nonmissing=.) if dairy_hh==0
*all rural households eith egg-producing animals
recode eggs_total_year value_eggs_produced (.=0) if egg_hh==1
recode eggs_total_year value_eggs_produced (nonmissing=.) if egg_hh==0

global gender "female male mixed"
*Variables winsorized at the top 1% only 
global wins_var_top1 /*
*/ value_crop_production value_crop_sales value_harv* value_sold* kgs_harvest* kgs_harv_mono* total_planted_area* total_harv_area* /*
*/ labor_hired labor_family /*
*/ animals_lost12months* mean_12months* lost_disease* /* 
*/ liters_milk_produced costs_dairy /*
*/ eggs_total_year value_eggs_produced value_milk_produced egg_poultry_year /*
*/ off_farm_hours crop_production_expenses value_assets cost_expli_hh /*
*/ livestock_expenses ls_exp_vac*  sales_livestock_products value_livestock_products value_livestock_sales /*
*/ value_farm_production value_farm_prod_sold 

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
global wins_var_top1_gender $wins_var_top1_gender cost_total cost_expli fert_inorg_kg wage_paid_aglabor
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
lab var w_labor_total "`llabor_total' - Winzorized top 1%"

*Variables winsorized both at the top 1% and bottom 1% 
global wins_var_top1_bott1  /* 
*/ farm_area farm_size_agland all_area_harvested all_area_planted ha_planted /*
*/ crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income /*
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
 
*generate inorg_fert_rate, costs_total_ha, and costs_expli_ha using winsorized values
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

*Off farm hours per capita using winsorized version off_farm_hours 
gen off_farm_hours_pc_all = w_off_farm_hours/member_count					
gen off_farm_hours_pc_any = w_off_farm_hours/off_farm_any_count			
la var off_farm_hours_pc_all "Off-farm hours per capita, all members>5 years"
la var off_farm_hours_pc_any "Off-farm hours per capita, only members>5 years workings"

*generating total crop production costs per hectare
gen cost_expli_hh_ha = w_cost_expli_hh / w_ha_planted
lab var cost_expli_hh_ha "Explicit costs (per ha) of crop production (household level)"

*land and labor productivity
gen land_productivity = w_value_crop_production/w_farm_area
gen labor_productivity = w_value_crop_production/w_labor_total 
lab var land_productivity "Land productivity (value production per ha cultivated)"
lab var labor_productivity "Labor productivity (value production per labor-day)"   

*milk productivity
gen liters_per_largeruminant= w_liters_milk_produced/milk_animals 
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
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (.=0) if crop_hh==1
recode inorg_fert_rate cost_total_ha cost_expli_ha cost_expli_hh_ha land_productivity labor_productivity (nonmissing=.) if crop_hh==0
*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode mortality_rate_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode mortality_rate_`i' (.=0) if lvstck_holding_`i'==1	
}

*all rural households 
recode off_farm_hours_pc_all (.=0)
*households engaged in monocropped production of specific crops
forvalues k=1/$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (.=0) if `cn'_monocrop==1
	recode `cn'_exp `cn'_exp_ha `cn'_exp_kg (nonmissing=.) if `cn'_monocrop==0
		foreach g in male female mixed { //IHS 
		recode `cn'_exp_`g' `cn'_exp_ha_`g' `cn'_exp_kg_`g' (.=0) if `cn'_monocrop_`g'==1
		recode `cn'_exp_`g' `cn'_exp_ha_`g' `cn'_exp_kg_`g' (nonmissing=.) if `cn'_monocrop_`g'==0
		}
}

*all rural households growing specific crops (in the first cropping season) 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_`cn' (.=0) if grew_`cn'_fcs==1 //IHS 9.25.19 only reporting FCS yield so only replace if grew in FCS
	recode yield_pl_`cn' (nonmissing=.) if grew_`cn'_fcs==0 //IHS 9.25.19 only reporting FCS yield so only replace if grew in FCS
}
*all rural households harvesting specific crops (in the first cropping season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_`cn' (.=0) if harvested_`cn'_fcs==1 //IHS 9.25.19 only reporting FCS yield so only replace if grew in FCS
	recode yield_hv_`cn' (nonmissing=.) if harvested_`cn'_fcs==0 //IHS 9.25.19 only reporting FCS yield so only replace if grew in FCS
}

*households growing specific crops that have also purestand plots of that crop 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_pl_pure_`cn' (.=0) if grew_`cn'_fcs==1 & w_area_plan_pure_`cn'!=. //IHS 9.25.19 only reporting FCS yield so only replace if grew in FCS
	recode yield_pl_pure_`cn' (nonmissing=.) if grew_`cn'_fcs==0 | w_area_plan_pure_`cn'==.  //IHS 9.25.19 only reporting FCS yield so only replace if grew in FCS
}
*all rural households harvesting specific crops (in the first cropping season) that also have purestand plots 
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode yield_hv_pure_`cn' (.=0) if harvested_`cn'_fcs==1 & w_area_plan_pure_`cn'!=. // only reporting FCS yield so only replace if grew in FCS
	recode yield_hv_pure_`cn' (nonmissing=.) if harvested_`cn'_fcs==0 | w_area_plan_pure_`cn'==.  //only reporting FCS yield so only replace if grew in FCS
}

*households engaged in dairy production 
recode costs_dairy_percow cost_per_lit_milk (.=0) if dairy_hh==1
recode costs_dairy_percow cost_per_lit_milk (nonmissing=.) if dairy_hh==0

*now winsorize ratios only at top 1% 
global wins_var_ratios_top1 inorg_fert_rate /*
*/ cost_total_ha cost_expli_ha cost_expli_hh_ha /*
*/ land_productivity labor_productivity /*
*/ mortality_rate* liters_per_largeruminant costs_dairy_percow liters_per_cow liters_per_buffalo /*
*/ off_farm_hours_pc_all off_farm_hours_pc_any cost_per_lit_milk 	

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
egen total_income = rowtotal(crop_income livestock_income self_employment_income nonagwage_income agwage_income transfers_income all_other_income)
egen nonfarm_income = rowtotal(self_employment_income nonagwage_income transfers_income all_other_income)
egen farm_income = rowtotal(crop_income livestock_income agwage_income)
lab var  nonfarm_income "Nonfarm income (excludes ag wages)"
gen percapita_income = total_income/hh_members
lab var total_income "Total household income"
lab var percapita_income "Household incom per hh member per year"
lab var farm_income "Farm income"

egen w_total_income = rowtotal(w_crop_income w_livestock_income w_self_employment_income w_nonagwage_income w_agwage_income w_transfers_income w_all_other_income)
egen w_nonfarm_income = rowtotal(w_self_employment_income w_nonagwage_income w_transfers_income w_all_other_income)
egen w_farm_income = rowtotal(w_crop_income w_livestock_income w_agwage_income)
lab var  w_nonfarm_income "Nonfarm income (excludes ag wages) - Winzorized top 1%"
lab var w_farm_income "Farm income - Winzorized top 1%"
gen w_percapita_income = w_total_income/hh_members
lab var w_total_income "Total household income - Winzorized top 1%"
lab var w_percapita_income "Household income per hh member per year - Winzorized top 1%"

global income_vars crop livestock self_employment nonagwage agwage transfers all_other
foreach p of global income_vars {
gen `p'_income_s = `p'_income
replace `p'_income_s = 0 if `p'_income_s < 0

gen w_`p'_income_s = w_`p'_income
replace w_`p'_income_s = 0 if w_`p'_income_s < 0 
}
egen w_total_income_s = rowtotal(w_crop_income_s w_livestock_income_s w_self_employment_income_s w_nonagwage_income_s w_agwage_income_s  w_transfers_income_s w_all_other_income_s)
foreach p of global income_vars {
gen w_share_`p' = w_`p'_income_s / w_total_income_s
lab var w_share_`p' "Share of household (winsorized) income from `p'_income"
}

egen w_nonfarm_income_s = rowtotal(w_self_employment_income_s w_nonagwage_income_s w_transfers_income_s w_all_other_income_s)
gen w_share_nonfarm = w_nonfarm_income_s / w_total_income_s
lab var w_share_nonfarm "Share of household income (winsorized) from nonfarm sources"
foreach p of global income_vars {
drop `p'_income_s  w_`p'_income_s 
}
drop w_total_income_s w_nonfarm_income_s

***getting correct subpopulations 
*all rural households 
//note that consumption indicators are not included because there is missing consumption data and we do not consider 0 values for consumption to be valid
recode w_total_income w_percapita_income w_crop_income w_livestock_income w_nonagwage_income w_agwage_income w_self_employment_income w_transfers_income w_all_other_income /*
*/ w_share_crop w_share_livestock w_share_nonagwage w_share_agwage w_share_self_employment w_share_transfers w_share_all_other w_share_nonfarm /*
*/ use_fin_serv* /*
*/ formal_land_rights_hh w_off_farm_hours_pc_all months_food_insec w_value_assets /*
*/ lvstck_holding_tlu lvstck_holding_all lvstck_holding_lrum lvstck_holding_srum lvstck_holding_poultry (.=0) if rural==1 
 
*all rural households engaged in livestock production
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses w_ls_exp_vac  any_imp_herd_all (. = 0) if livestock_hh==1 
recode vac_animal w_share_livestock_prod_sold w_livestock_expenses w_ls_exp_vac  any_imp_herd_all (nonmissing = .) if livestock_hh==0 

*all rural households engaged in livestcok production of a given species
foreach i in lrum srum poultry{
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (nonmissing=.) if lvstck_holding_`i'==0
	recode vac_animal_`i' any_imp_herd_`i' w_lost_disease_`i' w_ls_exp_vac_`i' (.=0) if lvstck_holding_`i'==1	
}

*households engaged in crop production
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate* w_cost_expli* w_cost_total* /*
*/ w_value_crop_production w_value_crop_sales w_all_area_planted w_all_area_harvested /*
*/ encs* num_crops* multiple_crops (.=0) if crop_hh==1
recode w_proportion_cropvalue_sold w_farm_size_agland w_labor_family w_labor_hired /*
*/ imprv_seed_use use_inorg_fert w_labor_productivity w_land_productivity /*
*/ w_inorg_fert_rate* w_cost_expli* w_cost_total* /*
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
	
*all rural households growing specific crops (in the first cropping season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_pl_`cn' (.=0) if grew_`cn'_fcs==1
	recode w_yield_pl_`cn' (nonmissing=.) if grew_`cn'_fcs==0
}
*all rural households that harvested specific crops (in the first cropping season)
forvalues k=1(1)$nb_topcrops {
	local cn: word `k' of $topcropname_area
	recode w_yield_hv_`cn' (.=0) if harvested_`cn'_fcs==1
	recode w_yield_hv_`cn' (nonmissing=.) if harvested_`cn'_fcs==0
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
gen weight_milk=milk_animals*weight
gen weight_egg=poultry_owned*weight
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

************Rural poverty headcount ratio***************


*First, we convert $1.90/day to local currency in 2011 using https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2011&locations=UG&start=1990
	// 1.90 * 946.89 = 1799.09  
*NOTE: this is using the "Private Consumption, PPP" conversion factor because that's what we have been using. 
* This can be changed this to the "GDP, PPP" if we change the rest of the conversion factors.
*The global poverty line of $1.90/day is set by the World Bank
*http://www.worldbank.org/en/topic/poverty/brief/global-poverty-line-faq
*Second, we inflate the local currency to the year that this survey was carried out (2013-2014) using the CPI inflation rate using https://data.worldbank.org/indicator/FP.CPI.TOTL?end=2014&locations=UG&start=2003
	// 1+ [(142.024 - 116.564)/ 116.564] = 1.21842078	
	// 1799.09 * 1.21842078 = 2192.0486 UGX
*NOTE: if the survey was carried out over multiple years we use the last year (2014)
*This is the poverty line at the local currency in the year the survey was carried out

gen poverty_under_1_9 = (daily_percap_cons<2192.0486)
la var poverty_under_1_9 "Household has a percapita conumption of under $1.90 in 2011 $ PPP)"

*average consumption expenditure of the bottom 40% of the rural consumption expenditure distribution
*By per capita consumption
_pctile w_daily_percap_cons [aw=individual_weight] if rural==1, p(40)
gen bottom_40_percap = 0
replace bottom_40_percap = 1 if r(r1) > w_daily_percap_cons & rural==1

*By peraeq consumption
_pctile w_daily_peraeq_cons [aw=adulteq_weight] if rural==1, p(40)
gen bottom_40_peraeq = 0
replace bottom_40_peraeq = 1 if r(r1) > w_daily_peraeq_cons & rural==1

********Currency Conversion Factors*********
gen ccf_loc = (1+$UGA_W4_inflation) 
lab var ccf_loc "currency conversion factor - 2014 $UGX"
gen ccf_usd = (1+$UGA_W4_inflation) / $UGA_W4_exchange_rate
lab var ccf_usd "currency conversion factor - 2014 $USD"
gen ccf_1ppp = (1+$UGA_W4_inflation) / $UGA_W4_cons_ppp_dollar 
lab var ccf_1ppp "currency conversion factor - 2014 $Private Consumption PPP"
gen ccf_2ppp = (1+$UGA_W4_inflation) / $UGA_W4_gdp_ppp_dollar
lab var ccf_2ppp "currency conversion factor - 2014 $GDP PPP"

*replace vars that cannot be created with .
*empty crop vars (cassava and banana - no area information for permanent crops) 
global empty_vars $empty_vars *yield_*_cassav *yield_*_banana *total_planted_area_cassav *total_harv_area_cassav *total_planted_area_banana *total_harv_area_banana *cassav_exp_ha* *banana_exp_ha*

*replace empty vars with missing 
foreach v of varlist $empty_vars {
	replace `v' = .
}

*Cleaning up output to get below 5,000 variables
*dropping unnecessary variables and recoding to missing any variables that cannot be created in this instrument
drop *_inter_* harvest_* w_harvest_*

// Removing intermediate variables to get below 5,000 vars
keep hhid fhh clusterid strataid *weight* *wgt* region region_name district district_name ward ward_name village village_name ea rural farm_size* *total_income* /*
*/ *percapita_income* *percapita_cons* *daily_percap_cons* *peraeq_cons* *daily_peraeq_cons* /*
*/ *income* *share* *proportion_cropvalue_sold *farm_size_agland hh_members adulteq *labor_family *labor_hired use_inorg_fert vac_* /*
*/ feed* water* lvstck_housed* ext_* use_fin_* lvstck_holding* *mortality_rate* *lost_disease* disease* any_imp* formal_land_rights_hh /*
*/ *livestock_expenses* *ls_exp_vac* *prop_farm_prod_sold *off_farm_hours_pc* months_food_insec *value_assets* hhs_* *dist_agrodealer /*
*/ encs* num_crops_* multiple_crops* imprv_seed_* hybrid_seed_* *labor_total *farm_area *labor_productivity* *land_productivity* /*
*/ *wage_paid_aglabor* *labor_hired ar_h_wgt_* *yield_hv_* ar_pl_wgt_* *yield_pl_* *liters_per_* milk_animals poultry_owned *costs_dairy* *cost_per_lit* /*
*/ *egg_poultry_year* *inorg_fert_rate* *ha_planted* *cost_expli_hh* *cost_expli_ha* *monocrop_ha* *kgs_harv_mono* *cost_total_ha* /*
*/ *_exp* poverty_under_1_9 *value_crop_production* *value_harv* *value_crop_sales* *value_sold* *kgs_harvest* *total_planted_area* *total_harv_area* /*
*/ *all_area_* grew_* agactivities_hh ag_hh crop_hh livestock_hh *_milk_produced* *eggs_total_year *value_eggs_produced* /*
*/ *value_livestock_products* *value_livestock_sales* *total_cons* nb_cattle_today nb_poultry_today bottom_40_percap bottom_40_peraeq /*
*/ ccf_loc ccf_usd ccf_1ppp ccf_2ppp *sales_livestock_products

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2013-14"
// NKF 12.30.19 What #s do we use for Uganda?
gen instrument = 
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" /*
	*/ 
label values instrument instrument	

saveold "${UGA_W4_final_data}/Uganda_NPS_LSMS_ISA_W4_household_variables.dta", replace
 
 
********************************************************************************
*						INDIVIDUAL-LEVEL VARIABLES							   *
********************************************************************************
use "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_person_ids.dta", clear
merge m:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_household_diet.dta", nogen
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_control_income.dta", nogen  keep(1 3)
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_make_ag_decision.dta", nogen  keep(1 3)
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_ownasset.dta", nogen  keep(1 3)
merge m:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hhsize.dta", nogen keep (1 3)
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_farmer_fert_use.dta", nogen  keep(1 3)
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_farmer_improvedseed_use.dta", nogen  keep(1 3)
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_farmer_vaccine.dta", nogen  keep(1 3)
merge m:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hhids.dta", nogen keep (1 3)

*land rights
merge 1:1 hhid PID using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_land_rights_ind.dta", nogen
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
gen women_diet=.
replace number_foodgroup=.

//////////Identifier Variables ////////
*Add variables and ren household id so dta file can be appended with dta files from other instruments
ren PID indid
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2013-14"
// NKF 12.30.19 What #s do we use for Uganda?
gen instrument = 
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	

*merge in hh variable to determine ag household
preserve
use "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_household_variables.dta", clear
keep hhid ag_hh
tempfile ag_hh
save `ag_hh'
restore
merge m:1 hhid using `ag_hh', nogen keep (1 3)
replace   make_decision_ag =. if ag_hh==0
saveold "${UGA_W4_final_data}/Uganda_NPS_LSMS_ISA_W4_individual_variables.dta", replace


********************************************************************************
*							PLOT -LEVEL VARIABLES							   *
********************************************************************************
*GENDER PRODUCTIVITY GAP (PLOT LEVEL)
use "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_plot_cropvalue.dta", clear
merge 1:1 hhid plot_id using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_plot_areas.dta", keep (1 3) nogen
merge 1:1 hhid plot_id  using  "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_plot_decision_makers.dta", keep (1 3) nogen
merge m:1 hhid using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_hhids.dta", keep (1 3) nogen
merge 1:1 hhid plot_id using "${UGA_W4_created_data}/Uganda_NPS_LSMS_ISA_W4_plot_family_hired_labor.dta", keep (1 3) nogen
replace area_meas_hectares=area_est_hectares if area_meas_hectares==.
keep if cultivated==1
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
	
global monetary_val plot_value_harvest plot_productivity plot_labor_prod 
foreach p of varlist $monetary_val {
	gen `p'_1ppp = (1+$UGA_W4_inflation) * `p' / $UGA_W4_cons_ppp_dollar 
	gen `p'_2ppp = (1+$UGA_W4_inflation) * `p' / $UGA_W4_gdp_ppp_dollar 
	gen `p'_usd = (1+$UGA_W4_inflation) * `p' / $UGA_W4_exchange_rate
	gen `p'_loc = (1+$UGA_W4_inflation) * `p' 
	local l`p' : var lab `p' 
	lab var `p'_1ppp "`l`p'' (2014 $ Private Consumption PPP)"
	lab var `p'_2ppp "`l`p'' (2014 $ GDP PPP)"
	lab var `p'_usd "`l`p'' (2014 $ USD)"
	lab var `p'_loc "`l`p'' (2014 UGX)"  
	lab var `p' "`l`p'' (UGX)"  
	gen w_`p'_1ppp = (1+$UGA_W4_inflation) * w_`p' / $UGA_W4_cons_ppp_dollar 
	gen w_`p'_2ppp = (1+$UGA_W4_inflation) * w_`p' / $UGA_W4_gdp_ppp_dollar 
	gen w_`p'_usd = (1+$UGA_W4_inflation) * w_`p' / $UGA_W4_exchange_rate 
	gen w_`p'_loc = (1+$UGA_W4_inflation) * w_`p' 
	local lw_`p' : var lab w_`p'
	lab var w_`p'_1ppp "`lw_`p'' (2014 $ Private Consumption PPP)"
	lab var w_`p'_2ppp "`lw_`p'' (2014 $ GDP PPP)"
	lab var w_`p'_usd "`lw_`p'' (2014 $ USD)"
	lab var w_`p'_loc "`lw_`p'' (2014 UGX)"
	lab var w_`p' "`lw_`p'' (UGX)"  
}

*We are reporting two variants of gender-gap
* mean difference in log productivitity without and with controls (plot size and region/state)
* both can be obtained using a simple regression.
* use clustered standards errors
qui svyset clusterid [pweight=plot_weight], strata(strataid) singleunit(centered) // get standard errors of the mean
* SIMPLE MEAN DIFFERENCE
gen male_dummy=dm_gender==1  if  dm_gender!=3 & dm_gender!=. //generate dummy equals to 1 if plot managed by male only and 0 if managed by female only

*Gender-gap 1a 
gen lplot_productivity_usd=ln(w_plot_productivity_usd) 
gen larea_meas_hectares=ln(w_area_meas_hectares)
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
gen geography = "Uganda"
gen survey = "LSMS-ISA"
gen year = "2013-14"
// NKF 12.30.19 What #s do we use for Uganda?
gen instrument = 
label define instrument 1 "Tanzania NPS Wave 1" 2 "Tanzania NPS Wave 2" 3 "Tanzania NPS Wave 3" 4 "Tanzania NPS Wave 4" /*
	*/ 5 "Ethiopia ESS Wave 1" 6 "Ethiopia ESS Wave 2" 7 "Ethiopia ESS Wave 3" /*
	*/ 8 "Nigeria GHS Wave 1" 9 "Nigeria GHS Wave 2" 10 "Nigeria GHS Wave 3" /*
	*/ 11 "Tanzania TBS AgDev (Lake Zone)" 12 "Tanzania TBS AgDev (Northern Zone)" 13 "Tanzania TBS AgDev (Southern Zone)" /*
	*/ 14 "Ethiopia ACC Baseline" /*
	*/ 15 "India RMS Baseline (Bihar)" 16 "India RMS Baseline (Odisha)" 17 "India RMS Baseline (Uttar Pradesh)" 18 "India RMS Baseline (West Bengal)" /*
	*/ 19 "Nigeria NIBAS AgDev (Nassarawa)" 20 "Nigeria NIBAS AgDev (Benue)" 21 "Nigeria NIBAS AgDev (Kaduna)" /*
	*/ 22 "Nigeria NIBAS AgDev (Niger)" 23 "Nigeria NIBAS AgDev (Kano)" 24 "Nigeria NIBAS AgDev (Katsina)" 
label values instrument instrument	
saveold "${UGA_W4_final_data}/Uganda_NPS_LSMS_ISA_W4_field_plot_variables.dta", replace


********************************************************************************
*								SUMMARY STATISTICS							   *
******************************************************************************** 
/* 
All the pre-processed files include all households, individuals, and plots in the sample. 
The summary statistics are outputted only for the sub_population of households, individuals, and plots in rural areas. 
The code for outputting the summary statistics is in a separare dofile that is called here
*/ 
*Parameters
global list_instruments  "Uganda_NPS_LSMS_ISA_W4"
do "${directory}\SUMMARY STATISTICS_123019.do" 





 