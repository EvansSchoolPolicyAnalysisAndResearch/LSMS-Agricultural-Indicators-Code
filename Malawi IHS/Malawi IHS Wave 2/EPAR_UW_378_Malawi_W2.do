/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (IHS) LSMS-ISA Wave 2 (2013)
*Author(s)		: Didier Alia, Pierre Biscaye, David Coomes, Melissa Howlett, Jack Knauer, Josh Merfeld,  
				  Vedavati Patwardhan, Isabella Sun, Chelsea Sweeney, Emma Weaver, Ayala Wineman, 
				  C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 30 September 2019

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period April-October 2013. 
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/1003

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi LSMS data set.
*Using data files from within the "378 - LSMS Burkina Faso, Malawi, Uganda" folder within the "raw_data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave2-2013\created_data
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. // VAP 5.21.19 Update this with new file path

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputed in the excel file "Tanzania_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. // VAP 5.21.19 Update this with new file path 
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Malawi_IHS_LSMS_ISA_W2_hhids.dta
*INDIVIDUAL IDS						Malawi_IHS_LSMS_ISA_W2_person_ids.dta
*HOUSEHOLD SIZE						Malawi_IHS_LSMS_ISA_W2_hhsize.dta
*PARCEL AREAS						Malawi_IHS_LSMS_ISA_W2_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta

*MONOCROPPED PLOTS					Malawi_IHS_LSMS_ISA_W2_[CROP]_monocrop_hh_area.dta

*TLU (Tropical Livestock Units)		Malawi_IHS_LSMS_ISA_W2_TLU_Coefficients.dta

*GROSS CROP REVENUE					Malawi_IHS_LSMS_ISA_W2_tempcrop_harvest.dta
									Malawi_IHS_LSMS_ISA_W2_tempcrop_sales.dta
									Malawi_IHS_LSMS_ISA_W2_permcrop_harvest.dta
									Malawi_IHS_LSMS_ISA_W2_permcrop_sales.dta
									Malawi_IHS_LSMS_ISA_W2_hh_crop_production.dta
									Malawi_IHS_LSMS_ISA_W2_plot_cropvalue.dta
									Malawi_IHS_LSMS_ISA_W2_hh_crop_prices.dta  
									// VAP: Cannot replicate "crop_losses.dta & crop_residues.dta"
									
*CROP EXPENSES						Malawi_IHS_LSMS_ISA_W2_wages_rainyseason.dta
									Malawi_IHS_LSMS_ISA_W2_wages_dryseason.dta
									Malawi_IHS_LSMS_ISA_W2_fertilizer_costs.dta
									Malawi_IHS_LSMS_ISA_W2_seed_costs.dta
									Malawi_IHS_LSMS_ISA_W2_land_rental_costs.dta
									Malawi_IHS_LSMS_ISA_W2_asset_rental_costs.dta
									Malawi_IHS_LSMS_ISA_W2_transportation_cropsales.dta // VAP: Check code.
									
*CROP INCOME						Malawi_IHS_LSMS_ISA_W2_crop_income.dta
									
*LIVESTOCK INCOME					Malawi_IHS_LSMS_ISA_W2_livestock_products.dta
									Malawi_IHS_LSMS_ISA_W2_livestock_expenses.dta
									Malawi_IHS_LSMS_ISA_W2_manure.dta
									Malawi_IHS_LSMS_ISA_W2_livestock_sales.dta
									Malawi_IHS_LSMS_ISA_W2_TLU.dta
									Malawi_IHS_LSMS_ISA_W2_livestock_income.dta

*FISH INCOME						Malawi_IHS_LSMS_ISA_W2_fishing_expenses_1.dta
									Malawi_IHS_LSMS_ISA_W2_fishing_expenses_2.dta
									Malawi_IHS_LSMS_ISA_W2_fish_income.dta
																	

*SELF-EMPLOYMENT INCOME	           	Malawi_IHS_LSMS_ISA_W2_fish_trading_revenue.dta  
									// VAP: Cannot replicate "self_employment_income.dta & agproducts_profits.dta"
									Malawi_IHS_LSMS_ISA_W2_fish_trading_other_costs.dta
									Malawi_IHS_LSMS_ISA_W2_fish_trading_income.dta
									
*WAGE INCOME						Malawi_IHS_LSMS_ISA_W2_wage_income.dta
									Malawi_IHS_LSMS_ISA_W2_agwage_income.dta
									
*OTHER INCOME						Malawi_IHS_LSMS_ISA_W2_other_income.dta
									Malawi_IHS_LSMS_ISA_W2_land_rental_income.dta

*FARM SIZE / LAND SIZE				Malawi_IHS_LSMS_ISA_W2_land_size.dta
									Malawi_IHS_LSMS_ISA_W2_farmsize_all_agland.dta
									Malawi_IHS_LSMS_ISA_W2_land_size_all.dta
									Malawi_IHS_LSMS_ISA_W2_land_size_total.dta
									
*OFF-FARM HOURS						Malawi_IHS_LSMS_ISA_W2_off_farm_hours.dta									
									
*FARM LABOR							Malawi_IHS_LSMS_ISA_W2_farmlabor_rainyseason.dta
									Malawi_IHS_LSMS_ISA_W2_farmlabor_dryseason.dta
									Malawi_IHS_LSMS_ISA_W2_family_hired_labor.dta
									
*VACCINE USAGE						Malawi_IHS_LSMS_ISA_W2_vaccine.dta
									Malawi_IHS_LSMS_ISA_W2_farmer_vaccine.dta											

*ANIMAL HEALTH						Malawi_IHS_LSMS_ISA_W2_livestock_diseases.dta 
									// VAP: Cannot replicate "livestock_feed_water_house.dta"
																	
*USE OF INORGANIC FERTILIZER		Malawi_IHS_LSMS_ISA_W2_fert_use.dta	
									Malawi_IHS_LSMS_ISA_W2_farmer_fert_use.dta

*USE OF IMPROVED SEED				// VAP: Cannot replicate "improvedseed_use.dta" 
									// VAP: Cannot replicate "farmer_improvedseed_use.dta"

*REACHED BY AG EXTENSION			Malawi_IHS_LSMS_ISA_W2_any_ext.dta

*MOBILE OWNERSHIP                   Malawi_IHS_LSMS_ISA_W2_mobile_own.dta

*USE OF FORMAL FINANCIAL SERVICES	Malawi_IHS_LSMS_ISA_W2_fin_serv.dta

*MILK PRODUCTIVITY					Malawi_IHS_LSMS_ISA_W2_milk_animals.dta

*EGG PRODUCTIVITY					Malawi_IHS_LSMS_ISA_W2_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Malawi_IHS_LSMS_ISA_W2_hh_rental_rate.dta
									Malawi_IHS_LSMS_ISA_W2_hh_cost_land.dta
/// ** VAP: Skipped from here to HDDS
									Malawi_IHS_LSMS_ISA_W2_hh_cost_inputs_lrs.dta
									Malawi_IHS_LSMS_ISA_W2_hh_cost_inputs_srs.dta
									Malawi_IHS_LSMS_ISA_W2_hh_cost_seed_lrs.dta
									Malawi_IHS_LSMS_ISA_W2_hh_cost_seed_srs.dta		
									Malawi_IHS_LSMS_ISA_W2_cropcosts_perha.dta
									
*AGRICULTURAL WAGES					Malawi_IHS_LSMS_ISA_W2_ag_wage.dta   

*RATE OF FERTILIZER APPLICATION		Malawi_IHS_LSMS_ISA_W2_fertilizer_application.dta 
/// 

*HOUSEHOLD'S DIET DIVERSITY SCORE	Malawi_IHS_LSMS_ISA_W2_household_diet.dta

*WOMEN'S CONTROL OVER INCOME		Malawi_IHS_LSMS_ISA_W2_control_income.dta

/// ** VAP: Skipped from here to Household Assets
*WOMEN'S AG DECISION-MAKING			Malawi_IHS_LSMS_ISA_W2_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Malawi_IHS_LSMS_ISA_W2_ownasset.dta

*CROP YIELDS						Malawi_IHS_LSMS_ISA_W2_yield_hh_crop_level.dta
*SHANNON DIVERSITY INDEX			Malawi_IHS_LSMS_ISA_W2_shannon_diversity_index.dta
*CONSUMPTION						Malawi_IHS_LSMS_ISA_W2_consumption.dta
*HOUSEHOLD FOOD PROVISION			Malawi_IHS_LSMS_ISA_W2_food_insecurity.dta
///

*HOUSEHOLD ASSETS					Malawi_IHS_LSMS_ISA_W2_hh_assets.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Malawi_IHS_LSMS_ISA_W2_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Malawi_IHS_LSMS_ISA_W2_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Malawi_IHS_LSMS_ISA_W2_gender_productivity_gap.dta
*SUMMARY STATISTICS					Malawi_IHS_LSMS_ISA_W2_summary_stats.xlsx
*/

* VAP: The reference file used for Malawi Wave 2 code creation & replication is W4_EPAR_UW_335_Tanzania_TNPS_MASTER_7.8.19.do [Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)]

clear	
set more off

clear matrix	
clear mata	
set maxvar 8000	
ssc install findname	// need this user-written ado file for some commands to work

*Set location of raw data and output  // VAP: Update this with final path
global directory "   "


// set directories
* These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global MLW_W2_raw_data 			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave2-2013\raw_data"
global MLW_W2_created_data 		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave2-2013\created_data\TempFiles" //remove temp file folder when done
global MLW_W2_final_data  		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave2-2013\outputs"



************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN USD IDS
************************
global IHS_LSMS_ISA_W2_exchange_rate 730.27		 // https://data.worldbank.org/indicator/PA.NUS.FCRF?end=2017&locations=MW&start=2011
global IHS_LSMS_ISA_W2_gdp_ppp_dollar 205.18     // https://data.worldbank.org/indicator/PA.NUS.PPP?end=2017&locations=MW&start=2011
global IHS_LSMS_ISA_W2_cons_ppp_dollar 226.34	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP?end=2017&locations=MW&start=2011
// global IHS_LSMS_ISA_W4_inflation  // inflation rate 2015-2016. Data was collected during oct 2014-2015. We want to adjust the monetary values to 2016 

//RH 12.16.20: TZA has currency conversion factors and thresholds for winsorization - is that somewhere in here or does it need to be added?

********************************************************************************
*THRESHOLDS FOR WINSORIZATION
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
// BMGF 12 priority crops //
* maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana
** NOTE: Malawi has a Rainy Season and Dry Season - no long/short seasons like TZ**

// List of crops for this instrument - rainy and dry season and *=BMGF priority; (crop code)//
/*
							Rainy Season	Dry Season 
maize* (1) 						*				*
tobacco							*               *
groundnut* (11)					*
rice* (17)						*				
ground bean 					*				*
sweet potato* (28) 				*				*
irish potato					*				*
finger millet					*
sorghum* (32)					*               *
peral millet* (33)				*
beans* (34)						*				*
soyabean						*
pigeon pea						*               *
cotton							*
sunflower						*
sugar cane						*               *
cabbage                         *               *
tanaposi						*				*
nkhwani							*				*
okra							*				*
tomato							*               *
peas							*				*
onion							*				*
paprika                         *               *
other							*				*
*/

**Enter the 12 BMGF priority crops here, plus any crop in the top ten (by area) that is not already included in the priority crops - limit to 6 letters or they will be too long!
**For consistency, add the 12 priority crops in order first, then the additional top ten crops */

global topcropname_area "maize rice sorgum pmill grdnt beans swtptt cotton sunflr pigpea" // VAP 8.12.19: took out cowpea, yam, cassava, and banana because they don't exist in Malawi W2. Wheat does not appear in W2. 
global topcrop_area "1 4 10 11 3 12 6 15 16 14" // VAP: These crop codes are from MW W1. To confirm!
global comma_topcrop_area "1, 4, 10, 11, 3, 12, 6, 15, 16, 14"
global len : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops" // RH: VAP had this as "display "$len". Changed to match TZA W4 "$nb_topcrops", confirm

************************
*HOUSEHOLD IDS
************************
use "${MLW_W2_raw_data}\Household\hh_mod_a_filt_13.dta", clear
rename hh_a10a TA
rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep occ y2_hhid region stratum district TA ea rural weight 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", replace

********************************************************************************
* WEIGHTS *
********************************************************************************
use "${MLW_W2_raw_data}\Household\hh_mod_a_filt_13.dta", clear
rename hh_a10a TA
rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep occ y2_hhid region stratum district TA ea rural weight 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weights.dta", replace


************************
*INDIVIDUAL IDS
************************
use "${MLW_W2_raw_data}\Household\hh_mod_b_13.dta", clear
ren PID personid 
destring personid, replace 
replace personid= mod(personid, 100) // VAP: removing y2hhid info from personid. 
keep personid y2_hhid hh_b01 hh_b03 hh_b04 hh_b05a
sort y2_hhid personid
quietly by y2_hhid personid:  gen dup = cond(_N==1,0,_n)
drop if dup==2 // VAP: dropping 1075 duplicate obsns with same personid and y2_hhid
drop dup
gen female=hh_b03==2 
lab var female "1= individual is female"
gen age=hh_b05a
lab var age "Indivdual age"
gen hh_head=hh_b04==1 
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b04 hh_b05a
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_person_ids.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_person_ids.dta", clear
************************
*HOUSEHOLD SIZE // RH: CHECK CODE - doesn't match TZA W4
************************
use "${MLW_W2_raw_data}\Household\hh_mod_b_13.dta", clear
gen hh_members = 1
rename hh_b04 relhead 
rename hh_b03 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by (y2_hhid)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhsize.dta", replace


************************
*PLOT AREAS --TH checked and edited to match NGA w3 9/29/2021
************************
use "${MLW_W2_raw_data}\Agriculture\ag_mod_c_13.dta", clear //rainy season plot roster
ren ag_c00 plot_id 
tempfile ag_1
save `ag_1'
use "${MLW_W2_raw_data}\Agriculture\ag_mod_j_13.dta", clear //dry season plot roster
ren ag_j00 plot_id 
tempfile ag_2
save `ag_2'
use "${MLW_W2_raw_data}\Agriculture\AG_MOD_O2_13.dta", clear
ren ag_o00 plot_id 
tempfile ag_3 
save `ag_3'

use `ag_1', clear
merge 1:1 y2_hhid plot_id using `ag_2', nogen
merge 1:1 y2_hhid plot_id using `ag_3', nogen


ren ag_c04a area_size
replace area_size =ag_j05a if area_size ==. & ag_j05a!=.
replace area_size =ag_o04a if area_size ==. & ag_o04a!=.
ren ag_c04b area_unit
replace area_unit =ag_j05b if area_unit==. & ag_j05b!=.
replace area_unit =ag_o04b if area_unit==. & ag_o04b!=.

//TK Code renamed area_meas_acres to area_acres_meas to fix variable not found error in LAND SIZE:
ren ag_c04c area_acres_meas

replace area_acres_meas=ag_j05c if area_acres_meas==. & ag_j05c!=.
replace area_acres_meas=ag_o04c if area_acres_meas==. & ag_o04c!=.
//area_acres_meas

gen area_acres_est = area_size if area_unit == 1 
*area_unit definition: 1 = ACRE; 2 = HECTARE; 3 = SQUARE METERS; 4 = OTHER (SPECIFY)

replace area_acres_est = (area_size*2.47105) if area_unit == 2 & area_acres_est ==.
replace area_acres_est = (area_size*0.000247105) if area_unit == 3 & area_acres_est ==.

keep if (area_acres_est !=. | area_acres_meas !=.)

gen field_size= (area_acres_est* (1/2.47105))
replace field_size = (area_acres_meas* (1/2.47105))  if field_size==. & area_acres_meas!=. 

keep y2_hhid plot_id area_acres_est area_acres_meas field_size

gen gps_meas = area_acres_meas!=. 
lab var gps_meas "Plot was measured with GPS, 1=Yes"

lab var area_acres_meas "Plot area in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot area in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
lab var field_size "Area of plot (ha)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_areas.dta", replace


************************
*PLOT DECISION MAKERS -- TH 7.21.22 update to address missing dry season plots 
************************
use "${MLW_W2_raw_data}\Household\hh_mod_b_13.dta", clear
ren hh_b01 personid			// personid is the roster number, combination of y2_hhid and personid are unique id for this wave
drop if personid==.
gen female=hh_b03==2 
gen age=hh_b05a
gen head = hh_b04==1 if hh_b04!=.
keep personid female age y2_hhid head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_gender_merge.dta", replace


use "${MLW_W2_raw_data}/Agriculture/ag_mod_d_13.dta", clear
rename ag_d00 plot_id
drop if plot_id=="" 
drop if ag_d14==.
gen cultivated = ag_d14==1
gen dry=0
tempfile dm_r
save `dm_r'
use "${MLW_W2_raw_data}/Agriculture/ag_mod_k_13.dta", clear
rename ag_k00 plot_id
drop if plot_id==""
drop if ag_k15==.
gen dry=1
gen cultivated = 1 if  ag_k15==1 
tempfile dm_d
save `dm_d'

use `dm_r', clear
append using `dm_d'
recode cultivated (.=0)

*Gender/age variables 
gen personid = ag_d02
replace personid =ag_k03 if personid==. & ag_k03!=. //67 missing
merge m:1 y2_hhid personid using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_gender_merge.dta", gen(dm1_merge) keep(1 3)		// Dropping unmatched from using, 75 not matched

*First decision-maker variables 
gen dm1_female = female
drop female personid
*Second owner
gen personid = ag_d01_2a
replace personid =ag_k02_2a if personid==. &  ag_k02_2a!=.
merge m:1 y2_hhid personid using "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using
gen dm2_female = female
drop female personid
*Third
gen personid = ag_d01_2b
replace personid =ag_k02_2b if personid==. &  ag_k02_2b!=.
merge m:1 y2_hhid personid using "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
gen dm3_female = female
drop female personid

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhsize.dta", nogen keep(1 3)	 								
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
drop if  plot_id==""
keep y2_hhid plot_id dm_gender cultivated dry
lab var cultivated "1=Plot has been cultivated" //6192 observations
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta", replace

************************
*CROP UNIT CONVERSION FACTORS - VAP complete
************************
use "${MLW_W2_raw_data}/Agricultural Conversion Factor Database.dta", clear
ren crop_code crop_code_full
save "${MLW_W2_created_data}/Malawi_W2_cf.dta", replace

    ***************************
	*Crop Values
	***************************
	
//Nonstandard unit values (kg values in plot variables section)
	use "${MLW_W2_raw_data}/Agriculture/ag_mod_i_13.dta", clear
	gen season=0 //rainy season
	append using "${MLW_W2_raw_data}/Agriculture/ag_mod_o_13.dta"
	recode season (.=1) //dry season
	append using "${MLW_W2_raw_data}/Agriculture/AG_MOD_Q_13.dta"
	recode season(.=2) //tree or permanent crop; season 0= rainy, 1= dry, 2= perm
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	keep if ag_i01==1 | ag_o01==1 | ag_q01==1 //keeping only if sold crops harvested
	ren ag_i02a sold_qty //rainy: total sold
	replace sold_qty = ag_o02a if sold_qty ==. & ag_o02a!=. //dry
	replace sold_qty = ag_q02a if sold_qty ==. & ag_q02a!=. //tree/permanent
	ren ag_i02b unit
	replace unit = ag_o02b if unit ==. & ag_o02b!=.
	replace unit = ag_q02b if unit ==. & ag_q02b!=.
	ren ag_i03 sold_value
	replace sold_value=ag_o03 if sold_value==. & ag_o03!=.
	replace sold_value=ag_q03 if sold_value==. & ag_q03!=.
	
	ren ag_i0b crop_code //TH: crop codes for temp and perm are different and have overlapping numbers
	replace crop_code =ag_o0b if crop_code ==. & ag_o0b!=.
	
	gen crop_code_perm=ag_q0b //TH: recode perm crop codes to have unique numbers from temp crop codes
	recode crop_code_perm (1=49) (2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=66)(19=67)(39=68) //TH: Tree codes 19 & 39 were unlabelled in the original file, might be a mistake?
	la var crop_code_perm "Unique crop codes for trees/ permanent crops"
	label define crop_code_perm 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" 67 "N/A" 68 "N/A" //TH: labelling 67 & 68 as N/A 
	label val crop_code_perm crop_code_perm
	
	replace crop_code = crop_code_perm if crop_code==. & crop_code_perm!=. //TH: applying tree codes to crop codes
	label define AG_M0B 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" 67 "N/A" 68 "N/A", add
	
	keep occ y2_hhid qx_type interview_status sold_qty unit sold_value crop_code
		
	merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weights.dta", nogen keepusing(region stratum district TA ea rural weight) //not matched 781, matched 16,673 
	gen price_unit = sold_value/sold_qty //14,640 missing values; n=17,454
	lab var price_unit "Average sold value per crop unit"
	gen obs=price_unit!=.
	
	*create a value for the price of each crop at different levels
	foreach i in y2_hhid{
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
	
	use "${MLW_W2_raw_data}/Agriculture/ag_mod_g_13.dta", clear //rainy
	gen season=0 //create variable for season 
	append using "${MLW_W2_raw_data}/Agriculture/ag_mod_m_13.dta" //dry
	recode season(.=1)
	ren ag_g0b crop_code
	replace crop_code=ag_m0c if crop_code==. & ag_m0c!=.
	ren ag_g00 plot_id 
	replace plot_id=ag_m00 if plot_id==""
	append using "${MLW_W2_raw_data}/Agriculture/ag_mod_p_13.dta"
	replace plot_id=ag_p00 if plot_id=="" 
	replace ag_p03=. if ag_p03==999
	ren ag_p03 number_trees_planted
	recode season (.=2)
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	gen crop_code_perm=ag_p0c //TH: tree crop codes overlap with crop crop codes, i recode them here to have unique numbers
	recode crop_code_perm (1=49) (2=50)(3=51)(4=52)(5=53)(6=54)(7=55)(8=56)(9=57)(10=58)(11=59)(12=60)(13=61)(14=62)(15=63)(16=64)(17=65)(18=66)(19=67)(39=68) //TH: Tree codes 19 & 39 were unlabelled in the original file, might be a mistake?
	la var crop_code_perm "Unique crop codes for trees/ permanent crops"
	label define crop_code_perm 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" 67 "N/A" 68 "N/A" //TH: labelling 67 & 68 as N/A? 
	label val crop_code_perm crop_code_perm
	
	replace crop_code=crop_code_perm if crop_code==. & crop_code_perm!=. //TH: applying tree codes to crop codes
	label define AG_G0D 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" 67 "N/A" 68 "N/A", add
	label val crop_code AG_G0D 
	

	la var crop_code "Unconsolidated crop crops"
**consolidate crop codes (into the lowest number of the crop category)
	gen crop_code_short = crop_code //Generic level (without detail)
	recode crop_code_short (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17) //1-4=maize ; 5-10=tobacco; 11-16=groundnut; 17-26=rice
	la var crop_code_short "Generic level crop code"
	la val crop_code_short AG_G0D
	label define AG_G0D 1 "Maize" 5 "Tobacco" 11 "Groundnut" 17 "Rice", modify
	//TH: condensed crop code variables take 1st code of each crop
	
	drop if crop_code_short==. //4509 obs deleted

	
	*Create area variables 
	
	//7.20.22 TH: Andrew noted to leave out tree crops for now because of too much missing data on plot area for those
	
	gen area_unit=ag_g03 //rainy season TH: this indicates proportion of plot with crop, but NGA area_unit indicates the unit (ie stands/ridges/heaps) that area was measured in; tree file did not ask about area planted
	label var area_unit "Proportion of plot planted with crop"
	replace area_unit=ag_m03 if area_unit==. & ag_m03!=.
	replace area_unit=0.125 if area_unit==1 //converting answers to proportions
	replace area_unit=0.25 if area_unit==2 
	replace area_unit=0.5 if area_unit==3
	replace area_unit=0.75 if area_unit==4
	replace area_unit=.875 if area_unit==5
	replace area_unit=1 if ag_g02==1 | ag_m02==1
	replace area_unit=1 if (ag_g01==1 | ag_m01==1) & area_unit==.
	merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_areas.dta" 
	gen ha_planted=area_unit*area_meas_hectares
	replace ha_planted=area_unit*area_est_hectares if ha_planted==. & area_est_hectares!=. & area_est_hectares!=0
	/*replace ha_planted=ag_p02a* (1/2.47105) if ag_p02b==1 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	replace ha_planted=ag_p02a*(1/10000) if ag_p02b==3 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)

	//include a fix for scattered plantings when they're the only crop on the plot

//replace ha_planted=  if ndistinct ==1 // TH:7/20/22 what area do we plug in here?
*/
	tempfile ha_planted
	save `ha_planted'
	
	//TH: The NGA w3 survey asks "what area of the plot is covered by trees" while the Malawi w2 survey asks "what is the area of the plantation" (for trees, not tree crop specific; area + unit), how can we consolidate these under one indicator/ should we?
	drop area_unit 
	gen ha_harvested=ha_planted //TH: Malawi w2 doesn't ask about area harvested, only if area harvested was less than area planted (y/n, without numerical info). We assume area planted=area harvested bc no extra info 
	
	*Create time variables (month planted, harvest, and length of time grown)
	
	*month planted
	gen month_planted = ag_g05a
	replace month_planted = ag_m05a if month_planted==.
	lab var month_planted "Month of planting"
	
	*year planted
	replace ag_m05b=2011 if ag_m05b==1
	replace ag_m05b=2012 if ag_m05b==2
	drop if ag_m05b==7|ag_m05b==8 |ag_m05b==2007 |ag_m05b==2011 //TH:question asked about dry season in 2013, dropping responses not in 2013
	replace ag_g05b=2012 if ag_g05b==12 //TH:recoding year for recognizable typos and dropping others
	replace ag_g05b=2012 if ag_g05b==2
	replace ag_g05b=2011 if ag_g05b==1
	replace ag_g05b=2012 if ag_g05b==202
	drop if (ag_g05b ==4 |ag_g05b ==20 |ag_g05b ==2005|ag_g05b ==2011) //TH:question asked about rainy in 2012/2013 only, dropping responses not in 2012/13
	gen year_planted1 = ag_g05b
	gen year_planted2 = ag_m05b //dry season 2013, 19 obs from 2012
	gen year_planted = year_planted1
	replace year_planted= year_planted2 if year_planted==.
	lab var year_planted "Year of planting"
	
	*month harvested started
	gen month_harvested = ag_g12a
	replace month_harvested=ag_m12a if month_harvested==. & ag_m12a!=.
	lab var month_harvested "Month of start of harvesting"
	
	*survey did not ask for harvest year
	
	*months crop grown
	gen months_grown = month_harvest - month_planted if month_harvest > month_planted  // since no year info, assuming if month harvested was greater than month planted, they were in same year 
	replace months_grown = 12 - month_planted + month_harvest if month_harvest < month_planted // months in the first calendar year when crop planted 
	replace months_grown = 12 - month_planted if months_grown<1 // reconcile crops for which month planted is later than month harvested in the same year
	replace months_grown=. if months_grown <1 | month_planted==. | month_harvested==.
	lab var months_grown "Total months crops were grown before harvest"
	
 	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs=1
		replace obs=0 if ag_g09a==0 | ag_m11a==0 | ag_p09a==0  //obs=0 if no crops were harvested 
		collapse(sum)crops_plot=obs, by(y2_hhid plot_id)
		br if crops_plot>1
		tempfile ncrops
		save `ncrops'
		restore
	
		merge m:1 y2_hhid plot_id using `ncrops', nogen
		
		gen contradict_mono = 1 if (ag_g01==1 | ag_m01==1) & crops_plot >1 //49 plots reported >1 crop but list as monocrop; tree crops did not ask about mono/mix cropping
		gen contradict_inter = 1 if (ag_g01==2 | ag_m01==2) & crops_plot ==1 
		replace contradict_inter = . if ag_g01==1 | ag_m01==1 //958 plots reported 1 crop but list as intercrop; tree crops did not ask about mono/mix cropping
		
		 
		*Generating monocropped plot variables (Part 1)
		bys y2_hhid plot_id season: egen crops_avg= mean(crop_code_short) //checks for diff versions of same crop in the same plot
		gen purestand=1 if crops_plot==1 //7930 missing values
		gen perm_crop=1 if ag_p0c!=. //11515 missing values
		bys y2_hhid plot_id : egen permax = max(perm_crop) //all perm crop has max of 1
		
	
		*Generating mixed stand plot variables (Part 2)
	gen any_mixed=!(ag_g01==1 | ag_m01==1 | (perm_crop==1 & purestand==1)) //TH: 384 where purestand == any_mixed 4/20/22
	bys y2_hhid plot_id : egen any_mixed_max = max(any_mixed) 
	

	replace purestand=1 if crop_code_short == crops_avg
	replace purestand=0 if purestand ==. //assumes null values are just 0
	drop crops_plot crops_avg permax
	
	//Nigeria includes section to address inaccuracy in hectare planted data using hectare harvested data, but Malawi does not ask about hectare harvested

	
	*Generating total percent of purestand and monocropped on a field
	gen percent_field=ha_planted/field_size 
	
	bys y2_hhid plot_id: egen total_percent = total(percent_field)
	
	preserve
	gen overplanted = total_percent > 1
	duplicates drop y2_hhid plot_id, force
	collapse (mean) overplanted, by(purestand)
	tabstat overplanted, by(purestand)
	restore
	
	//about 64% of plots have a total intercropped sum greater than 1
	//about 2% of plots have a total monocropped sum greater than 1
	
	*Dealing with crops which have monocropping larger than plot size or monocropping that fills plot size and still has intercropping to add
	replace percent_field = percent_field/total_percent if total_percent > 1 & purestand == 0
	replace percent_field=1 if percent_field>1 & purestand==1 //6016 changes made, total increased from 7012 to 12906
	replace ha_planted = percent_field*field_size
	***replace ha_harvest = ha_planted if ha_harvest > ha_planted //no ha_harvest variable in survey
	
	*renaming unit code for merge
	ren ag_g09b unit 
	replace unit = ag_m11b if unit==. & ag_m11b!=.
	replace unit = ag_p09b if unit==. & ag_p09b!=.

	ren ag_g09a quantity_harvested
	replace quantity_harvested = ag_m11a if quantity_harvested==. & ag_m11a!=.
	replace quantity_harvested = ag_p09a if quantity_harvested==. & ag_p09a!=.
	
	*renaming crop_code to match name in using file
	ren crop_code crop_code_full
	
	*renaming condition vars in master to match using file 
	ren ag_g09c condition
	lab val condition condition
	replace condition = ag_m11c if quantity_harvested==. & ag_m11c!=. //tree crop does not have conditions
	
	
	*merging in region from hhids file and conversion factors 
	drop _merge
	merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3) //14229 matched
	merge m:1 region crop_code_full unit condition using  "${MLW_W2_created_data}/Malawi_W2_cf.dta", keep(1 3) gen(cf_merge) //8360 not matched from master, 5869 matched; TH: not sure if i did this merge correctly
	
	gen quant_harv_kg= quantity_harvested*conversion //8516 missing
	//This instrument doesn't ask about value harvest, just value sold, EFW 05.02.2019 (Uganda W1): Since we don't have value harvest for this instrument computing value harvest as price_kg * kgs_harvest for everything; FN: using info calculated above in crop values

rename crop_code_full crop_code 
merge m:1 unit crop_code using `price_unit_country_median', nogen keep(1 3) //not matched 1108, matched 13121

	gen value_harvest = price_unit_country * quant_harv_kg //9305 missing
	gen val_unit = value_harvest/quantity_harvested //9318 missing
	gen val_kg = value_harvest/quant_harv_kg //9318 missing
	merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weights.dta", nogen keep(1 3)
	gen plotweight = ha_planted*conversion //8706 missing
	gen obs=quantity_harvested>0 & quantity_harvested!=.

//AgQuery
	collapse (sum) quant_harv_kg value_harvest ha_planted ha_harvest number_trees_planted percent_field (max) months_grown, by(region stratum district ea rural y2_hhid plot_id crop_code crop_code_short purestand area_meas_hectares)
	bys y2_hhid plot_id : egen percent_area = sum(percent_field)
	bys y2_hhid plot_id : gen percent_inputs = percent_field/percent_area //1216 missing
	drop percent_area //Assumes that inputs are +/- distributed by the area planted. Probably not true for mixed tree/field crops, but reasonable for plots that are all field crops
	//Labor should be weighted by growing season length, though. 
	
	drop if crop_code==. //TH: 7/20/22 deleted 320 observations
	merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) //not matched 5064, matched 8835 // ->not matched 4274 matched 9625
	save "${MLW_W2_created_data}/Malawi_W2_all_plots.dta",replace
	
	
************************
*MONOCROPPED PLOTS
************************
// BMGF 12 priority crops //
* maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana
** NOTE: Malawi has a Rainy Season and Dry Season - no long/short seasons like TZ**


// List of crops for this instrument - rainy and dry season and *=BMGF priority; (crop code)//
/*
							Rainy Season	Dry Season 
maize* (1) 						*				*
tobacco							*               *
groundnut* (11)					*
rice* (17)						*				
ground bean 					*				*
sweet potato* (28) 				*				*
irish potato					*				*
finger millet					*
sorghum* (32)					*               *
peral millet* (33)				*
beans* (34)						*				*
soyabean						*
pigeon pea						*               *
cotton							*
sunflower						*
sugar cane						*               *
cabbage                         *               *
tanaposi						*				*
nkhwani							*				*
okra							*				*
tomato							*               *
peas							*				*
onion							*				*
paprika                         *               *
other							*				*
*/

**Enter the 12 BMGF priority crops here, plus any crop in the top ten (by area) that is not already included in the priority crops - limit to 6 letters or they will be too long!
**For consistency, add the 12 priority crops in order first, then the additional top ten crops */

global topcropname_area "maize rice sorgum pmill grdnt beans swtptt cotton sunflr pigpea" // VAP 8.12.19: took out cowpea, yam, cassava, and banana because they don't exist in Malawi W2. Wheat does not appear in W2. 
global topcrop_area "1 4 10 11 3 12 6 15 16 14" // VAP: These crop codes are from MW W1. To confirm!
global comma_topcrop_area "1, 4, 10, 11, 3, 12, 6, 15, 16, 14"
global len : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$len"

*Manually collapse crop codes
use "${MLW_W2_raw_data}/Agriculture/ag_mod_g_13.dta", clear
append using "${MLW_W2_raw_data}/Agriculture/ag_mod_m_13.dta", gen(dry)
gen crop_code=.
replace crop_code=1 if ag_g0b == 1 | ag_g0b  == 2 | ag_g0b == 3 | ag_g0b  == 4 | ag_m0c == 1 | ag_m0c== 2 | ag_m0c == 3 | ag_m0c== 4 // maize
replace crop_code=2 if ag_g0b == 5 | ag_g0b == 6 | ag_g0b== 7 | ag_g0b == 10 | ag_m0c == 6 //tobacco
replace crop_code=3 if ag_g0b == 11 | ag_g0b == 12 | ag_g0b == 13 |ag_g0b == 14 | ag_g0b == 15 | ag_g0b == 16  //groundnut
replace crop_code=4 if ag_g0b == 17 | ag_g0b == 18 | ag_g0b == 19 | ag_g0b == 20 | ag_g0b == 21 | ag_g0b == 22 | ag_g0b == 23 | ag_g0b == 25 | ag_g0b == 26 | ag_g0b == 27| ag_m0c == 18 | ag_m0c == 20 | ag_m0c == 21 | ag_m0c == 23 | ag_m0c == 25 | ag_m0c == 26 //rice
replace crop_code=5 if ag_g0b == 27 |ag_m0c == 27 //groundbean
replace crop_code=6 if ag_g0b == 28 | ag_m0c == 28 //sweet potato
replace crop_code=7 if ag_g0b == 29 | ag_m0c == 29 //Irish (Malawi) potato
replace crop_code=8 if ag_g0b == 31  //finger millet
replace crop_code=9 if ag_g0b == 32 | ag_m0c == 32 //sorghum
replace crop_code=10 if ag_g0b == 33 //pearl millet
replace crop_code=11 if ag_g0b == 34 |ag_m0c == 34 //beans
replace crop_code=12 if ag_g0b == 35 //soyabean
replace crop_code=13 if ag_g0b == 36 |ag_m0c == 36 //pigeonpea
replace crop_code=14 if ag_g0b == 37 //cotton
replace crop_code=15 if ag_g0b == 38 //sunflower
replace crop_code=16 if ag_g0b == 39 |ag_m0c == 39  //sugarcane
replace crop_code=17 if ag_g0b == 40 | ag_m0c == 40 //cabbage
replace crop_code=18 if ag_g0b == 41 | ag_m0c == 41 //tanaposi
replace crop_code=19 if ag_g0b == 42 | ag_m0c == 42 //nkhwani
replace crop_code=20 if ag_g0b == 43 | ag_m0c == 43 //okra
replace crop_code=21 if ag_g0b == 44 | ag_m0c == 44 //tomato
replace crop_code=22 if ag_g0b == 45 | ag_m0c == 45 //onion
replace crop_code=23 if ag_g0b == 46 | ag_m0c == 46 //pea
replace crop_code=24 if ag_g0b == 47 | ag_m0c == 47 // paprika 
replace crop_code=25 if ag_g0b == 48 | ag_m0c == 48 //other
la def crop_code 1 "Maize" 2 "Tobacco" 3 "Groundnut" 4 "Rice" 5 "Ground Bean" 6 "Sweet Potato" 7 "Irish (Malawi) Potato" 8"Finger Millet" 9 "Sorghum" 10 "Pearl Millet" 11 "Beans" 12 "Soyabean" 13 "Pigeon Pea" /*
*/ 14 "Cotton" 15 "Sunflower" 16 "Sugar Cane" 17 "Cabbage" 18 "Tanaposi" 19 "Nkhwani" 20 "Okra" 21 "Tomato" 22 "Onion" 23 "Pea" 24 "Paprika" 25 "Other"
la val crop_code crop_code
lab var crop_code "Crop Code"


*Rename variables so they match in merged files
ren ag_g0b crop_code_full
replace crop_code_full = ag_m0c if crop_code_full==.
ren ag_g13b unit //replacing with Q9 if missing
replace unit = ag_g09b if unit==. 
replace unit = ag_m11b if unit==.
ren ag_g13c condition
replace condition = ag_g09c if condition==. 
replace condition = ag_m11c if condition==.

*Merge in region from hhids file and conversion factors
merge m:1 y2_hhid using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3)	
merge m:1 region crop_code_full unit condition using  "${MLW_W2_created_data}/Malawi_W2_cf.dta"
save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_collapsed_crops_w_cf.dta", replace


*Generating area harvested and kilograms harvested
forvalues k=1(1)10 {		
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_collapsed_crops_w_cf.dta", clear 	//Rainy & dry season
rename ag_g00 plot_id
append using "${MLW_W2_raw_data}/Agriculture/ag_mod_p_13.dta", gen(perm)
recode dry (.=0)
drop if plot_id==""

gen kgs_harv_mono_`cn' = ag_g09a*conversion if crop_code_full==`c' 						//KG harvested in rainy season first
replace kgs_harv_mono_`cn' = ag_m08a*conversion if crop_code_full==`c' & dry==1 		//If nothing in rainy, replace with dry
replace kgs_harv_mono_`cn' = ag_p09a*conversion if crop_code_full==`c' & kgs_harv_mono==.	//If nothing in either of those, replace with perm crops
recode kgs_harv_mono_`cn' (.=0)

*First, get percent of plot planted with crop
replace ag_g02 = ag_m02 if ag_g02==.
replace ag_g03 = ag_m03 if ag_g03==.
//set trace on

gen percent_`cn' = 1 if ag_g02==1 & crop_code_full==`c'
replace percent_`cn' = 1 if ag_m02==1 & crop_code_full== `c' & ag_g02==. 
replace percent_`cn' = 0.125*(ag_g03==1) + 0.25*(ag_g03==2) + 0.5*(ag_g03==3) + 0.75*(ag_g03==4) + 0.875*(ag_g03==5)  if percent_`cn'==. & crop_code_full==`c'	//for when area harvested is not 100% of one crop

xi i.crop_code_full, noomit							//xi= separates out categories "i.[variable]" "noomit" don't skip even if there are no observation for category
collapse (sum) kgs_harv_mono_`cn' (max) _Icrop_code_* percent_`cn', by(y2_hhid plot_id dry)	// * captures every crop [placeholder]
egen crop_count = rowtotal(_Icrop_code_*)	
keep if crop_count==1 & _Icrop_code_`c'==1  	//only keeping monocropped option for relevant crop  

merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_plot_areas.dta", nogen keep(3) //Help plot areas has duplicates
replace area_meas_hectares=. if area_meas_hectares==0 					
replace area_meas_hectares = area_est_hectares if area_meas_hectares==. 	// Replacing missing with estimated
gen `cn'_monocrop_ha = area_meas_hectares*percent_`cn'			
drop if `cn'_monocrop_ha==0 

save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_`cn'_monocrop.dta", replace  
}

*Adding in gender of plot manager
forvalues k=1(1)10  {		
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_`cn'_monocrop.dta", clear
merge m:1 y2_hhid plot_id dry using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta" 
foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' { 
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	// gen `i'_mixed = `i' if dm_gender==3  VAP: No mixed in MLW2
	replace `i'_male = . if dm_gender!=1
	replace `i'_female = . if dm_gender!=2
	// replace `i'_mixed = . if dm_gender!=3
}

gen `cn'_monocrop_male = 0 
replace `cn'_monocrop_male=1 if dm_gender==1
gen `cn'_monocrop_female = 0 
replace `cn'_monocrop_female=1 if dm_gender==2


*And now this code will indicate whether the HOUSEHOLD has at least one of these plots and the total area of monocropped maize plots
collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female /*`cn'_monocrop_mixed*/ `cn'_monocrop = _Icrop_code_`c', by(y2_hhid) 
gen monocrop_`cn'=1 //code runs till here.

foreach i in male female /*mixed*/ {
	replace `cn'_monocrop_ha = . if `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if  `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_`i'==0
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_ha_`i'==0
	replace kgs_harv_mono_`cn' = . if `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if  `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_`i'==0 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_ha_`i'==0 
}

save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_`cn'_monocrop_hh_area.dta", replace
}

************************
*TLU (Tropical Livestock Units)
************************
use "${MLW_W2_raw_data}/Agriculture/ag_mod_r1_13.dta", clear
gen tlu_coefficient=0.5 if (ag_r0a==304|ag_r0a==303|ag_r0a==302|ag_r0a==301) // bull, cow, steer & heifer, calf 
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308) // goat, sheep
replace tlu_coefficient=0.2 if (ag_r0a==309) // pig
replace tlu_coefficient=0.01 if (ag_r0a==311|ag_r0a==313|ag_r0a==315|ag_r0a==318|ag_r0a==319|ag_r0a==3310|ag_r0a==3314|ag_r0a==315) //chicken, duck, other poultry, hare in TZ. For MW2: local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Livestock categories
gen cattle=inrange(ag_r0a,301,304) // calf and bull for MW2. TZ included bull and female calf under cattle. VAP: Why are male calves not included in TZ under cattle?
gen smallrum=inlist(ag_r0a,307,309) // sheep, goat
gen poultry=inlist(ag_r0a,311,313,315, 319,3310,3314)  // chicken, duck, poultry, hare in TZ. For MW2: local hen, local cock, duck, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl
gen other_ls=ag_r0a==318 | 3305 | 3304 // includes other, donkey/horse, ox
gen cows=ag_r0a==303
gen chickens= ag_r0a==313 | 311 | 3310 | 3314 // includes local cock (313), local hen (311),  chicken layer and broiler(3310), and turkey (3314)
ren ag_r0a livestock_code

*Number of livestock owned at present
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

*Number of livestock owned 1 year ago
gen nb_cattle_1yearago = ag_r07 if cattle==1
gen nb_smallrum_1yearago=ag_r07 if smallrum==1
gen nb_poultry_1yearago=ag_r07 if poultry==1
gen nb_other_1yearago=ag_r07 if other==1
gen nb_cows_1yearago=ag_r07 if cows==1
gen nb_chickens_1yearago=ag_r07 if chickens==1
gen tlu_1yearago = ag_r07 * tlu_coefficient
ren ag_r07 nb_ls_1yearago 

lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminant owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of cattle poultry as of 12 months ago"
lab var nb_other_1yearago "Number of other livestock (horse, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_ls_1yearago "Number of livestock owned 12 months ago"

recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (y2_hhid)
drop tlu_coefficient
save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_TLU_Coefficients.dta", replace


************************
*GROSS CROP REVENUE
************************

use "${MLW_W2_raw_data}/Agriculture/ag_mod_g_13.dta", clear
append using "${MLW_W2_raw_data}/Agriculture/ag_mod_m_13.dta", gen(dry)
gen crop_code=.
replace crop_code=1 if ag_g0b == 1 | ag_g0b  == 2 | ag_g0b == 3 | ag_g0b  == 4 | ag_m0c == 1 | ag_m0c== 2 | ag_m0c == 3 | ag_m0c== 4 // maize
replace crop_code=2 if ag_g0b == 5 | ag_g0b == 6 | ag_g0b== 7 | ag_g0b == 10 | ag_m0c == 6 //tobacco
replace crop_code=3 if ag_g0b == 11 | ag_g0b == 12 | ag_g0b == 13 |ag_g0b == 14 | ag_g0b == 15 | ag_g0b == 16  //groundnut
replace crop_code=4 if ag_g0b == 17 | ag_g0b == 18 | ag_g0b == 19 | ag_g0b == 20 | ag_g0b == 21 | ag_g0b == 22 | ag_g0b == 23 | ag_g0b == 25 | ag_g0b == 26 | ag_g0b == 27| ag_m0c == 18 | ag_m0c == 20 | ag_m0c == 21 | ag_m0c == 23 | ag_m0c == 25 | ag_m0c == 26 //rice
replace crop_code=5 if ag_g0b == 27 |ag_m0c == 27 //groundbean
replace crop_code=6 if ag_g0b == 28 | ag_m0c == 28 //sweet potato
replace crop_code=7 if ag_g0b == 29 | ag_m0c == 29 //Irish (Malawi) potato
replace crop_code=8 if ag_g0b == 31  //finger millet
replace crop_code=9 if ag_g0b == 32 | ag_m0c == 32 //sorghum
replace crop_code=10 if ag_g0b == 33 //pearl millet
replace crop_code=11 if ag_g0b == 34 |ag_m0c == 34 //beans
replace crop_code=12 if ag_g0b == 35 //soyabean
replace crop_code=13 if ag_g0b == 36 |ag_m0c == 36 //pigeonpea
replace crop_code=14 if ag_g0b == 37 //cotton
replace crop_code=15 if ag_g0b == 38 //sunflower
replace crop_code=16 if ag_g0b == 39 |ag_m0c == 39  //sugarcane
replace crop_code=17 if ag_g0b == 40 | ag_m0c == 40 //cabbage
replace crop_code=18 if ag_g0b == 41 | ag_m0c == 41 //tanaposi
replace crop_code=19 if ag_g0b == 42 | ag_m0c == 42 //nkhwani
replace crop_code=20 if ag_g0b == 43 | ag_m0c == 43 //okra
replace crop_code=21 if ag_g0b == 44 | ag_m0c == 44 //tomato
replace crop_code=22 if ag_g0b == 45 | ag_m0c == 45 //onion
replace crop_code=23 if ag_g0b == 46 | ag_m0c == 46 //pea
replace crop_code=24 if ag_g0b == 47 | ag_m0c == 47 // paprika 
replace crop_code=25 if ag_g0b == 48 | ag_m0c == 48 //other
la def crop_code 1 "Maize" 2 "Tobacco" 3 "Groundnut" 4 "Rice" 5 "Ground Bean" 6 "Sweet Potato" 7 "Irish (Malawi) Potato" 8"Finger Millet" 9 "Sorghum" 10 "Pearl Millet" 11 "Beans" 12 "Soyabean" 13 "Pigeon Pea" /*
*/ 14 "Cotton" 15 "Sunflower" 16 "Sugar Cane" 17 "Cabbage" 18 "Tanaposi" 19 "Nkhwani" 20 "Okra" 21 "Tomato" 22 "Onion" 23 "Pea" 24 "Paprika" 25 "Other"
la val crop_code crop_code
lab var crop_code "Crop Code"

*Rename variables so they match in merged files
ren ag_g00 plot_id
ren ag_g0b crop_code_full
replace crop_code_full = ag_m0c if crop_code_full==.
ren ag_g13b unit 
replace unit = ag_g09b if unit==. 
replace unit = ag_m11b if unit==.
ren ag_g13c condition
replace condition = ag_g09c if condition==. 
replace condition = ag_m11c if condition==.

*Merge in region from hhids file and conversion factors
merge m:1 y2_hhid using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3)	
merge m:1 region crop_code_full unit condition using  "${MLW_W2_created_data}/Malawi_W2_cf.dta"

*Temporary crops (both seasons)
gen harvest_yesno=.
replace harvest_yesno = 1 if ag_g13a > 0 & ag_g13a !=. 
replace harvest_yesno = 2 if ag_g13a == 0
gen kgs_harvest = ag_g13a*conversion if crop_code== `c' 
replace kgs_harvest = ag_m11a*conversion if crop_code==`c' & kgs_harvest==.
//rename ag4a_29 value_harvest					VAP 08.19.2019: cannot construct value_harvest for MW2, used value_sold below instead
//replace value_harvest = ag4b_29 if value_harvest==.
replace kgs_harvest = 0 if harvest_yesno==2
//replace value_harvest = 0 if harvest_yesno==2
collapse (sum) kgs_harvest /*value_harvest*/, by (y2_hhid crop_code plot_id)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
//lab var value_harvest "Value harvested of this crop, summed over main and short season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_tempcrop_harvest.dta", replace


*Value of harvest by quantity sold - in Module I of Malawi LSMS W2 (no value of harvest question)
use "${MLW_W2_raw_data}/Agriculture/ag_mod_i_13.dta", clear
append using "${MLW_W2_raw_data}/Agriculture/ag_mod_o_13.dta", gen(dry)

gen crop_code=.
replace crop_code=1 if ag_i0b == 1 | ag_i0b == 2 | ag_i0b == 3 | ag_i0b == 4 | ag_o0b == 1 | ag_o0b == 2 | ag_o0b == 3 | ag_o0b == 4 //maize
replace crop_code=2 if ag_i0b == 5 | ag_i0b == 6 | ag_i0b == 7 | ag_i0b == 10 //tobacco
replace crop_code=3 if ag_i0b == 11 | ag_i0b == 12 | ag_i0b == 13 | ag_i0b == 14 | ag_i0b == 15 | ag_i0b == 16 // groundnut
replace crop_code=4 if ag_i0b == 17 | ag_i0b == 18 | ag_i0b == 19 | ag_i0b == 20 | ag_i0b == 21 | ag_i0b == 22 | ag_i0b == 23 | ag_i0b == 25 | ag_i0b == 26 | ag_o0b == 18 | ag_o0b == 20 | ag_o0b == 21/*
*/ | ag_o0b == 23 | ag_o0b == 25 | ag_o0b == 26 // rice  
replace crop_code=5 if ag_i0b == 27 // ground bean
replace crop_code=6 if ag_i0b == 28 | ag_o0b == 28 //sweet potato
replace crop_code=7 if ag_i0b == 29 | ag_o0b == 29 // Irish potato
replace crop_code=9 if ag_i0b == 31 // finger millet
replace crop_code=10 if ag_i0b == 32 | ag_o0b == 32 // sorghum
replace crop_code=11 if ag_i0b == 33 // pearl millet
replace crop_code=12 if ag_i0b == 34 | ag_o0b == 34 //beans
replace crop_code=13 if ag_i0b == 35 | ag_o0b == 35 // soyabean
replace crop_code=14 if ag_i0b == 36 | ag_o0b == 36 // pigeonpea
replace crop_code=15 if ag_i0b == 37 // cotton
replace crop_code=16 if ag_i0b == 38 // sunflower
replace crop_code=17 if ag_i0b == 39 | ag_o0b == 39 // sugarcane
replace crop_code=18 if ag_i0b == 40 | ag_o0b == 40 // cabbage
replace crop_code=19 if ag_i0b == 41 | ag_o0b == 41 // tanaposi
replace crop_code=20 if ag_i0b == 42 | ag_o0b == 42 // nkhwani
replace crop_code=21 if ag_i0b == 43 | ag_o0b == 43 // okra
replace crop_code=22 if ag_i0b == 44 | ag_o0b == 44 // tomato
replace crop_code=23 if ag_i0b == 45 | ag_o0b == 45 // onion
replace crop_code=24 if ag_i0b == 46 | ag_o0b == 46 // pea
replace crop_code=25 if ag_i0b == 47 | ag_o0b == 47 // paprika
replace crop_code=26 if ag_i0b == 48 | ag_o0b == 48 // other
la def crop_code 1 "Maize" 2 "Tobacco" 3 "Groundnut" 4 "Rice" 5 "Ground Bean" 6 "Sweet Potato" 7 "Irish (Malawi) Potato" 8 "Finger Millet" 9 "Sorghum" 10 "Pearl Millet" 11 "Beans" 12 "Soyabean" 13 "Pigeon Pea" /*
*/ 14 "Cotton" 15 "Sunflower" 16 "Sugar Cane" 17 "Cabbage" 18 "Tanaposi" 19 "Nkhwani" 20 "Okra" 21 "Tomato" 22 "Onion" 23 "Pea" 24 "Paprika" 25 "Other"
la val crop_code crop_code
lab var crop_code "Crop Code" 

*Rename variables so they match in merged files
ren ag_i0b crop_code_full
replace crop_code_full = ag_o0b if crop_code_full==.
ren ag_i02b unit 
replace unit = ag_o02b if unit==. 
ren ag_i02c condition
replace condition = ag_o02c if condition==.

*Merge in region from hhids file and conversion factors
merge m:1 y2_hhid using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3)	
merge m:1 region crop_code_full unit condition using  "${MLW_W2_created_data}/Malawi_W2_cf.dta"

*Temporary crop sales 
drop if crop_code_full==.
rename ag_i01 sell_yesno
replace sell_yesno = ag_o01 if sell_yesno==.
gen quantity_sold = ag_i02a*conversion 
replace quantity_sold = ag_o02a*conversion if quantity_sold==.
rename ag_i03 value_sold
replace value_sold = ag_o03 if value_sold==.
keep if sell_yesno==1
collapse (sum) quantity_sold value_sold, by (y2_hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over rainy and dry season"
lab var value_sold "Value sold of this crop, summed over rainy and dry season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_tempcrop_sales.dta", replace

*Permanent and tree crops //VAP: Need to discuss conversion
use "${MLW_W2_raw_data}/Agriculture/ag_mod_p_13.dta", clear // rainy season
drop if ag_p02b==.
rename ag_p0c crop_code
rename ag_p00 plotid
replace crop_code = 100 if crop_code == 1 // VAP: renamed crop code labels as they overlap with temporary crop codes
replace crop_code = 200 if crop_code == 2
replace crop_code = 300 if crop_code == 3
replace crop_code = 400 if crop_code == 4
replace crop_code = 500 if crop_code == 5
replace crop_code = 600 if crop_code == 6
replace crop_code = 700 if crop_code == 7
replace crop_code = 800 if crop_code == 8
replace crop_code = 900 if crop_code == 9
replace crop_code = 1000 if crop_code == 10
replace crop_code = 1100 if crop_code == 11
replace crop_code = 1200 if crop_code == 12
replace crop_code = 1300 if crop_code == 13
replace crop_code = 1400 if crop_code == 14
replace crop_code = 1500 if crop_code == 15
replace crop_code = 1600 if crop_code == 16
replace crop_code = 1700 if crop_code == 17
replace crop_code = 1800 if crop_code == 18
la def crop_code 100 "Cassava" 200 "Tea" 300 "Mango" 400 "Orange" 500"Papaya"  600 "Banana" 700 "Avocado" 800 "Guava" 900 "Lemon" 1000 "Tangerine" 1100 "Peach" 1200 "Custade Apple (Poza)" 1300 "Mexican Apple (Masuku)" /*
*/ 1400 "Masau" 1500 "Pineapple" 1700 "Other" 

*Rename to match conversion file
ren ag_p09b unit	


* Using conversion file from MW W3, reference is resources PDF provided by World Bank -  missing crops include peach, poza, cassava, and masuku 
merge m:1 y2_hhid using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3)		
merge m:1 region crop_code unit using  "${MLW_W2_raw_data}/Conversion_factors_perm.dta"					 

gen kgs_harvest = ag_p09a*Conversion		// VAP: MW W3 file is  missing conversion codes for some units, e.g. "basket"
collapse (sum) kgs_harvest, by (y2_hhid crop_code plotid)
lab var kgs_harvest "Kgs harvested of this crop, summed over wet and dry season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_permcrop_harvest.dta", replace


use "${MLW_W2_raw_data}/Agriculture/ag_mod_q_13.dta", clear //Dry season 
ren ag_q0b crop_code
drop if crop_code==.
replace crop_code = 100 if crop_code == 1 // cassava VAP: renamed crop code labels as overlap with temporary crop codes. q=867 - use Zambia code 
replace crop_code = 200 if crop_code == 2 // tea
replace crop_code = 300 if crop_code == 3 // coffee
replace crop_code = 400 if crop_code == 4 // mango
replace crop_code = 500 if crop_code == 5 //orange
replace crop_code = 600 if crop_code == 6 // papaya
replace crop_code = 700 if crop_code == 7 // banana
replace crop_code = 800 if crop_code == 8 // avocado
replace crop_code = 900 if crop_code == 9  // guava
replace crop_code = 1000 if crop_code == 10  //lemon
replace crop_code = 1100 if crop_code == 11  // tangerine
replace crop_code = 1200 if crop_code == 12  // peach - q=38 - use orange conversion
replace crop_code = 1300 if crop_code == 13  //poza - - q=25 - use tangerine conversion 
replace crop_code = 1400 if crop_code == 14  //masuku
replace crop_code = 1500 if crop_code == 15  //masau
replace crop_code = 1600 if crop_code == 16  //pineapple
replace crop_code = 1700 if crop_code == 17  //macademia
replace crop_code = 1800 if crop_code == 18  //other
la def crop_code 100 "Cassava" 200 "Tea" 300 "Coffee" 400 "Mango" 500 "Orange" 600 "Papaya" 700 "Banana" 800 "Avocado" 900 "Guava" 1000 "Lemon" 1100 "Tangerine" 1200 "Peach" 1300 "Custade Apple (Poza)" 1400 "Mexican Apple (Masuku)" /*
*/ 1500 "Masau" 1600 "Pineapple" 1700 "Macademia" 1800 "Other" 

*Rename to match conversion file
ren ag_q02b unit

*Using conversion file from MW W3, refer resources PDF provided by World Bank 
//Note: Peach, Poza, Cassava, and Masuku do not have conversion codes in Malawi reference doc. Using following conversions from MW W3 for each of these crops:
	/*Peach = Orange, Poza = Tangerine, Masuku = Tangerine,  and Cassava =  "Raw cassava" conversion from Zambia LSMS; use raw because most cassava is sold raw in Malawi (http://citeseerx.ist.psu.edu
		/viewdoc/download?doi=10.1.1.480.7549&rep=rep1&type=pdf*/
	*Ox-cart also does not have a conversion, instead use the conversion factor for "extra large wheelbarrow" from Nigeria (https://microdata.worldbank.org/index.php/catalog/1002/datafile/F75/V1961)
merge m:1 y2_hhid using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3)		
merge m:1 region crop_code unit using  "${MLW_W2_raw_data}/Conversion_factors_perm.dta"					

rename ag_q01 sell_yesno
gen quantity_sold = ag_q02a*Conversion			
replace quantity_sold = ag_q02a*1 if unit==1	//If quantity is measured in kg multiply by 1 to get KG quantity_sold (don't have this variable in conversion file)
rename ag_q03 value_sold
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (y2_hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over rainy and dry season"
lab var value_sold "Value sold of this crop, summed over rainy and dry season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_permcrop_sales.dta", replace

*Prices of permanent and tree crops need to be imputed from sales  // VAP: check output files for all crop prices, are crop codes coded correctly?
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_permcrop_sales.dta", clear
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_tempcrop_sales.dta"
recode price_kg (0=.)
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta"
drop if _merge==2
drop _merge
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", clear	 //Measure by EA 
gen observation = 1
bys region district ea crop_code: egen obs_ea = count(observation)			
collapse (median) price_kg [aw=weight], by (region district TA ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_ea.dta", replace 

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", clear // Measure by TA
gen observation = 1
bys region district TA crop_code: egen obs_ta = count(observation)
collapse (median) price_kg [aw=weight], by (region district TA crop_code obs_ta)
rename price_kg price_kg_median_ta
lab var price_kg_median_ta "Median price per kg for this crop in the TA"
lab var obs_ta "Number of sales observations for this crop in the TA"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_TA.dta", replace


use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", clear //Measure by District 
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_district.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", clear	//Measure by Region
gen observation = 1
bys crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_region.dta", replace


use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", clear	//Now by country
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_tempcrop_harvest.dta", clear
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_permcrop_harvest.dta"
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 y2_hhid crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta"   
drop _merge
merge m:1 region district TA ea crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_ea.dta"
drop _merge
merge m:1 region district TA crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_ta.dta"
drop _merge
merge m:1 region district crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_country.dta"
drop _merge
gen price_kg_hh = price_kg
lab var price_kg_hh "Price per kg, with missing values imputed using local median values"
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=25 & crop_code!=1800 /* Don't impute prices for "other" permanent or temporary crops */
replace price_kg = price_kg_median_ta if price_kg==. & obs_ta >= 10 & crop_code!=25 & crop_code!=1800 
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=25 & crop_code!=1800
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=25 & crop_code!=1800
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=25 & crop_code!=1800
lab var price_kg "Price per kg, with missing values imputed using local median values"

//VAP: Following MMH 6.21.19 (Malawi W1): This instrument doesn't ask about value harvest, just value sold, EFW 05.02.2019 (Uganda W1): Since we don't have value harvest for this instrument computing value harvest as price_kg * kgs_harvest for everything. This is what was done in Ethiopia baseline
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
lab var value_harvest_imputed "Imputed value of crop production"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_values_tempfile.dta", replace 

preserve 		
recode  value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (y2_hhid crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production, summed over rainy and dry season"
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far, summed over rainy and dry season"
lab var kgs_harvest "Kgs harvested of this crop, summed over rainy and dry  season"
ren quantity_sold kgs_sold
lab var kgs_sold "Kgs sold of this crop, summed over rainy and dry season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_values_production.dta", replace
restore
*The file above will be used is the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested.  

collapse (sum) value_harvest_imputed value_sold, by (y2_hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_production.dta", replace

*Plot value of crop production
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (y2_hhid plot_id)
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_cropvalue.dta", replace

*Crop residues (captured only in Tanzania) 		// VAP 08/20/2019: Malawi W2 doesn't ask about crop residues

*Crop values for inputs in agricultural product processing (self-employment)
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_tempcrop_harvest.dta", clear
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_permcrop_harvest.dta"
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta", nogen keep(1 3)
merge m:1 y2_hhid crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_sales.dta", nogen
merge m:1 region district TA ea crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_ea.dta", nogen
merge m:1 region district TA crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_ta.dta", nogen
merge m:1 region district crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_region.dta", nogen
merge m:1 crop_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_prices_country.dta", nogen
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!= 1800/* Don't impute prices for "other" crops. VAP: Check code 1800 for other */ 
replace price_kg = price_kg_median_ta if price_kg==. & obs_ta >= 10 & crop_code!=1800
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=1800
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=1800
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=1800 
lab var price_kg "Price per kg, with missing values imputed using local median values"

gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=.  //MW W2 doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
keep y2_hhid crop_code price_kg 
duplicates drop
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_prices.dta", replace

*Crops lost post-harvest: VAP: MW W2 Questionnaire only asks about qty lost, not value. Cannot create Malawi_IHS_LSMS_ISA_W2_crop_losses.dta similar to TZ. 

************************
*CROP EXPENSES
************************
*Expenses: Hired labor
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear // For rainy season.  
rename ag_d47a no_days_men_nharv // non harvest activities: land preparation, planting, ridging, weeding, fertilizing
rename ag_d47b avg_dlywg_men_nharv // Daily Wage Men
rename ag_d47c no_days_women_nharv
rename ag_d47d avg_dlywg_women_nharv  // Daily Wage Women
rename ag_d47e no_days_chldrn_nharv
rename ag_d47f avg_dlywg_chldrn_nharv
recode no_days_men_nharv avg_dlywg_men_nharv no_days_women_nharv avg_dlywg_women_nharv no_days_chldrn_nharv avg_dlywg_chldrn_nharv (.=0)

rename ag_d48a no_days_men_harv // harvesting
rename ag_d48b avg_dlywg_men_harv
rename ag_d48c no_days_women_harv
rename ag_d48d avg_dlywg_women_harv
rename ag_d48e no_days_chldrn_harv
rename ag_d48f avg_dlywg_chldrn_harv
recode no_days_men_harv avg_dlywg_men_harv no_days_women_harv avg_dlywg_women_harv no_days_chldrn_harv avg_dlywg_chldrn_harv (.=0)

gen tot_wg_men_nharv = no_days_men_nharv*avg_dlywg_men_nharv             //wages: rainy season male non-harvest activities 
gen tot_wg_women_nharv = no_days_women_nharv*avg_dlywg_women_nharv 		 //wages: rainy season female non-harvest activities
gen tot_wg_chldrn_nharv = no_days_chldrn_nharv*avg_dlywg_chldrn_nharv	 //wages: rainy season children non-harvest activities
gen tot_wg_men_harv = no_days_men_harv*avg_dlywg_men_harv				 //wages: rainy season male harvest activities 
gen tot_wg_women_harv = no_days_women_harv*avg_dlywg_women_harv			 //wages: rainy season female harvest activities
gen tot_wg_chldrn_harv = no_days_chldrn_harv*avg_dlywg_chldrn_harv		 //wages: rainy season children harvest activities

// Summing wages paid in Rainy Season
gen wages_paid_rainy = tot_wg_men_nharv + tot_wg_women_nharv + tot_wg_chldrn_nharv + tot_wg_men_harv + tot_wg_women_harv + tot_wg_chldrn_harv 
// VAP: This does not include in-kind payments, which are separate in Qs. 
// I tried merging the hh_crop_prices.dta file to calculate value of in-kind(crop)payments, but ag_mod_13 is at the plot level, while hh_crop_prices.dta is at the hh-crop level.


*Monocropped plots
*renaming list of topcrops for hired labor. 
global topcropname_annual "maize rice pmill grdnt beans swtptt sunflr" //VAP: not including sorgum, cotton, pigpea, as 0 obsns for monocropping. Not sure if the following comment is applicable to Malawi: Labor for permanent crops is all recorded in the SRS 
foreach cn in $topcropname_annual {		
preserve
	gen dry=0
	ren ag_d00 plot_id
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta"
	foreach i in wages_paid_rainy{
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
*Merge in monocropped plots
	merge m:1 y2_hhid plot_id dry using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		
	collapse (sum) wages_paid_rainy_`cn'*, by(y2_hhid)		
	lab var wages_paid_rainy_`cn' "Wages for hired labor in rainy  season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_rainy_`cn'_`g' "Wages for hired labor in rainy season - Monocropped `g' `cn' plots"
	}
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wages_rainyseason_`cn'.dta", replace

restore
} 
collapse (sum) wages_paid_rainy, by (y2_hhid) 
lab var wages_paid_rainy "Wages paid for hired labor (crops) in rainyseason"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wages_rainyseason.dta", replace

use "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta", clear // VAP: Check output files. // For dry season: All types of activities, no split between harvest and non-harvest like rainy.   
rename ag_k46a no_days_men_all
rename ag_k46b avg_dlywg_men_all
rename ag_k46c no_days_women_all
rename ag_k46d avg_dlywg_women_all
rename ag_k46e no_days_chldrn_all
rename ag_k46f avg_dlywg_chldrn_all
recode no_days_men_all avg_dlywg_men_all no_days_women_all avg_dlywg_women_all no_days_chldrn_all avg_dlywg_chldrn_all (.=0)

gen tot_wg_men_all = no_days_men_all*avg_dlywg_men_all //wages: dry season male
gen tot_wg_women_all = no_days_women_all*avg_dlywg_women_all //wages: dry season female 
gen tot_wg_chldrn_all = no_days_chldrn_all*avg_dlywg_chldrn_all //wages:  dry season children 

gen wages_paid_dry = tot_wg_men_all + tot_wg_women_all + tot_wg_chldrn_all //VAP: This does not include in-kind payments, which are separate in Qs. 
//AT 10.17.19: For MLW W1, I included in-kind payments in wages.

*Monocropped plots
*renaming list of topcrops for hired labor. 
global topcropname_dry "maize rice pmill grdnt beans swtptt sunflr" //VAP: not including sorgum, cotton, pigpea, as 0 obsns for monocropping. Not sure if the following comment is applicable to Malawi: Labor for permanent crops is all recorded in the SRS 
foreach cn in $topcropname_annual {		
preserve
	gen dry =1
	ren ag_k00 plot_id
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta"
	foreach i in wages_paid_dry{
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
*Merge in monocropped plots
	merge m:1 y2_hhid plot_id dry using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		
	collapse (sum) wages_paid_dry_`cn'*, by(y2_hhid)		
	lab var wages_paid_dry_`cn' "Wages for hired labor in rainy  season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_dry_`cn'_`g' "Wages for hired labor in rainy season - Monocropped `g' `cn' plots"
	}
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wages_dryseason_`cn'.dta", replace

restore
} 
collapse (sum) wages_paid_dry, by (y2_hhid) 
lab var wages_paid_dry  "Wages paid for hired labor (crops) in rainyseason"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wages_dryseason.dta", replace

*Expenses: Inputs
// use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
// append using "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta", gen(dry)	

*formalized land rights  
// VAP: Individual level IDs do not match between hh-level module and ag-module, so cannot merge. 
// personid from person_ids.dta is in string format, with hhid appended in the beginning. Format also not consistent across all hh members. 
// Can't convert personid to 1,2,3, 4 etc to match ag module.

//  VAP: TZ uses "what other types of ownership or legal documents does your household have for this plot? Includes anything other than "no documents" as formal
//  VILLAGE-GOVERNMENT-WITNESSED PURCHASE AGREEMENT...1 LOCAL-COURT-CERTIFIED PURCHASE AGREEMENT.........2 
//  INHERITANCE LETTER...........3 LETTER OF ALLOCATION FROM VILLAGE GOV'T.........4
//  OTHER GOVERNMENT DOCUMENT....5 OFFICIAL CORRESPONDENCE......6 UTILITY OR OTHER BILL........7 NO DOCUMENTATION.............8
//  VAP: This qs not available in MW2. Tried using: "Does your household currently have a title for this [PLOT]?" 

/*
replace ag_d03_1= ag_k04_1 if ag_d03_1==.		// replacing with values in dry season for dry season observations
gen formal_land_rights = ag_d03_1==1 									

*Individual level (for women)
replace ag_d04a = ag_k05a if ag_d04a==. //who in the hh owns the plot (ID 1)
replace ag_d04b = ag_k05b if ag_d04b==. //who in the hh owns the plot (ID 2)
*Starting with first owner
preserve
	ren ag_d04a personid
	merge m:1 y2_hhid personid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_person_ids.dta", nogen keep(3)		// keep only matched
	keep y2_hhid personid female formal_land_rights
	tempfile p1
	save `p1', replace
restore
*Now second owner
preserve
	ren ag_d04b personid		
	merge m:1 y2_hhid personid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_person_ids.dta", nogen keep(3)		// keep only matched 
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 if female==1
	collapse (max) formal_land_rights_f, by(y2_hhid personid)		
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_rights_ind.dta", replace
restore	
	
preserve
	collapse (max) formal_land_rights_hh=formal_land_rights, by(y2_hhid)		// VAP: taking max at hh level, =1 if they have title for atleast one plot. TZ: taking max at household level; equals one if they have official documentation for at least one plot
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_rights_hh.dta", replace
restore
*/ 

* Fertilizer                // VAP: For MW2, this is the value of fertilizer purchase without coupons/vouchers. 
use "${MLW_W2_raw_data}\Agriculture\ag_mod_f_13.dta", clear
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_l_13.dta", gen(dry)	
gen inorganic_fertilizer1 = ag_f19 if ag_f0d>=1 & ag_f0d <=6 
replace inorganic_fertilizer1 = ag_l19 if ag_f0d>=1 & ag_f0d <=6 & ag_l0d>=1 & ag_l0d <=6  & ag_f19 ==. // VAP: This includes input codes from both rainy and dry seasons. 
gen inorganic_fertilizer2 = ag_f29 if ag_f0d>=1 & ag_f0d <=6 
replace inorganic_fertilizer2 = ag_l29 if ag_f0d>=1 & ag_f0d <=6 & ag_l0d>=1 & ag_l0d <=6 & ag_f29 ==.
recode inorganic_fertilizer1 inorganic_fertilizer2 (.=0)
gen value_fertilizer = inorganic_fertilizer1 + inorganic_fertilizer2

* Pesticide/Herbicide 
// VAP: Combining value of pesticide and herbicide for MW 2. Herbicide is specified as a separate category
// but the last category "OTHER PESTICIDE/HERBICIDE(SPECIFY)" doesn't distinguish between the two.  
gen value_pesticide_herbicide1 = ag_f19 if ag_f0d>=7 & ag_f0d <=11
replace value_pesticide_herbicide1 = ag_l19 if ag_f0d>=7 & ag_f0d <=11 & ag_l0d>=7 & ag_l0d <=11  & ag_f19 ==.
gen value_pesticide_herbicide2 = ag_f29 if ag_f0d>=7 & ag_f0d <=11
replace value_pesticide_herbicide2 = ag_l29 if ag_f0d>=7 & ag_f0d <=11 & ag_l0d>=7 & ag_l0d <=11 & ag_f29 ==.
recode value_pesticide_herbicide1 value_pesticide_herbicide2 (.=0)
gen value_pesticide_herbicide = value_pesticide_herbicide1 + value_pesticide_herbicide2

// VAP: MW2 does not have a value for organic fertilizer/manure


// VAP: Cannot replicate fertilizer cost for monocropped plots, as master files ag_mod_f_13 and g_mod_l_13 aren't on plot-level.


*In the survey instrument, the value of inputs obtained on credit is already captured in the question "What was the value of the [INPUT] that you purchased without coupons / vouchers or purchased on credit from [SOURCE] during...?"
collapse (sum) value_fertilizer value_pesticide_herbicide, by (y2_hhid)
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in rainy and dry growing seasons" 
lab var value_pesticide_herbicide "Value of herbicides/pesticides purchased (not necessarily the same as used) in rainy and dry growing seasons" //ALT 10.16.19: This line said "inorganic fertilizer"; replaced w/ "herbicides/pesticides"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fertilizer_costs.dta", replace

*Seed 
// VAP: Using "value of the [SEED] purchased without coupons/vouchers or on credit from [SOURCE] during the 2013 rainy & dry seasons"
// TZ does not have this exact qs, used tot. amount paid for seeds in both seasons. 
use "${MLW_W2_raw_data}\Agriculture\ag_mod_h_13.dta", clear
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_n_13.dta", gen(dry)		
gen cost_seed_1 = ag_h19 // rainy season, value of purchased seeds from 1st source
replace cost_seed_1 = ag_n19 if cost_seed_1==. // dry season, value of purchased seeds from 1st source
gen cost_seed_2= ag_h29 // rainy season, value of purchased seeds from 2nd source
replace cost_seed_2= ag_n29 if cost_seed_2==. // dry season, value of purchased seeds from 2nd source
recode cost_seed_1 cost_seed_2 (.=0)
gen cost_seed = cost_seed_1 + cost_seed_2

collapse (sum) cost_seed, by (y2_hhid)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_seed_costs.dta", replace
*Note that planting material for permanent crops is not captured anywhere.


*Land rental 
// VAP: for MW 2, split by already paid and future. For TZ, there is no split by already paid and future. 
// "How much did you pay to the owner for the use of this land in the long rainy season 2014? 
// INCLUDES: IN-KIND PAYMENTS, PAYMENT BY CROP OUTPUT,FUTURE / PLANNED PAYMENTS, PAST PAYMENTS FOR THE LONG RAINY SEASON 2014
use "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta", clear
rename ag_k00 plot_id
tempfile ag_mod_k_13
save `ag_mod_k_13', replace // This is a fix for renaming plot_id, as it appears in both mod k and d. 
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
rename ag_d00 plot_id
append using `ag_mod_k_13', gen(dry)	
gen rental_cost_land_cshpd = ag_d11a //rainy season, cash already paid
replace rental_cost_land_cshpd = ag_k12a if ag_d11a ==. //dry season, cash already paid
gen rental_cost_land_kindpd = ag_d11b //rainy season, in-kind already paid
replace rental_cost_land_kindpd =ag_k12b if ag_d11b ==. //dry season, in-kind already paid
gen rental_cost_land_cshfut = ag_d11c //rainy season, future cash payment owed
replace rental_cost_land_cshfut = ag_k12c if ag_d11c ==. //dry season, future cash payment owed
gen rental_cost_land_kindfut = ag_d11d //rainy season,in-kind payment owed
replace rental_cost_land_kindfut = ag_k12d if ag_d11d ==.
recode rental_cost_land_cshpd rental_cost_land_kindpd rental_cost_land_cshfut rental_cost_land_kindfut (.=0)
gen rental_cost_land = rental_cost_land_cshpd + rental_cost_land_kindpd + rental_cost_land_cshfut + rental_cost_land_kindfut

global topcropname_land "maize rice pmill grdnt beans swtptt sunflr" // VAP: removed sorgum, cotton, pigpea due to 0 obsns. 
*Monocropped plots // VAP: Can replicate, as master files are at plot-level!
foreach cn in $topcropname_land {		
preserve
	*disaggregate by gender of plot manager
	merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta"
	*Merge in monocropped plots
	merge 1:1 y2_hhid plot_id dry using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		// only in master and matched; keeping only matched, because these are the maize monocropped plots	
	gen rental_cost_land_`cn'=rental_cost_land
	gen rental_cost_land_`cn'_male=rental_cost_land if dm_gender==1
	gen rental_cost_land_`cn'_female=rental_cost_land if dm_gender==2
	gen rental_cost_land_`cn'_mixed=rental_cost_land if dm_gender==3
	collapse (sum) rental_cost_land_`cn'* , by(y2_hhid)				// Now, this sum should be only rental costs for parcels that are monocrops
	lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_rental_costs_`cn'.dta", replace  
restore
}

collapse (sum) rental_cost_land, by (y2_hhid)
lab var rental_cost_land "Rental costs paid for land"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${MLW_W2_raw_data}\Household\hh_mod_m_13.dta", clear
rename hh_m0b itemid
gen animal_traction = (itemid>=609 & itemid<=610) // VAP: MW2: Ox Plough, Ox Cart. // TZ: Ox Plough, Ox Cart, Ox Seed Planter
gen ag_asset = (itemid>=601 & itemid<= 608 | itemid>=613 & itemid <=625) 
// VAP: TZ: Hand Hoe, Hand powered Sprayer, SHELLER/THRESHER; HAND MILL/GRINDER; WATERING CAN; FARM BUILDINGS/STORAGE FACILITIES; 
// GERI CANS/DRUMS; POWER TILLER ; OTHER 
// MW2: Hand hoe, slasher, axe, sprayer, panga knife, sickle, treadle pump, watering can, ridger, cultivator, generator, motor pump, 
// grain mill, other, chicken house, livestock and poultry kraal, storage house, granary, barn, pig sty
gen tractor = (itemid>=611 & itemid<=612) //VAP: MW2: Tractor, Tractor Plough. // TZ: tractor, tractor plough, tractor harrow
rename hh_m14 rental_cost // VAP: Both MW2 and TZ: "how much did hh pay to rent or borrow [item] in last 12 months"
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)

collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (y2_hhid)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items" // VAP: Do we want to split ag_assets further into implements and storage for Malawi? 
lab var rental_cost_tractor "Costs for renting a tractor"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_asset_rental_costs.dta", replace


// VAP: Now, with permanent crops and dry season
use "${MLW_W2_raw_data}\Agriculture\ag_mod_i_13.dta", clear
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_o_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_q_13.dta"
rename ag_i18 transport_costs_cropsales1 // VAP: Tot cost of transportation associated with temp [crop] sales to largest buyer, rainy season"
// TZ: How much did you pay to transport [crop] during 2014 long rainy season? 
replace transport_costs_cropsales1 = ag_o18 if transport_costs_cropsales1==. // VAP: Tot cost of transportation associated with temp [crop] sales to largest buyer, dry season"
rename ag_i27 transport_costs_cropsales2 // VAP: Tot cost of transportation associated with temp [crop] sales to 2nd largest buyer, rainy season"
replace transport_costs_cropsales2 = ag_o27 if transport_costs_cropsales2==. // VAP: Tot cost of transportation associated with temp [crop] sales to 2nd largest buyer, dry season"
rename ag_q18 transport_costs_cropsales_perm1 // VAP: Tot cost of transportation associated with perm [crop] sales to largest buyer in last 12 months
rename ag_q27 transport_costs_cropsales_perm2 // VAP: Tot cost of transportation associated with perm [crop] sales to 2nd largest buyer in last 12 months
recode transport_costs_cropsales1 transport_costs_cropsales2 transport_costs_cropsales_perm1 transport_costs_cropsales_perm2(.=0)
gen transport_costs_cropsales = transport_costs_cropsales1 + transport_costs_cropsales2 + transport_costs_cropsales_perm1 + transport_costs_cropsales_perm2
collapse (sum) transport_costs_cropsales, by (y2_hhid)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of all crops" // VAP: TZ had only temporary. 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_transportation_cropsales.dta", replace

*Crop costs
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_asset_rental_costs.dta", clear
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_rental_costs.dta", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_seed_costs.dta", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fertilizer_costs.dta", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wages_dryseason.dta", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wages_rainyseason.dta", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_transportation_cropsales.dta",nogen
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer  /*
*/ value_pesticide_herbicide /*value_herbicide value_pesticide*/ wages_paid_dry wages_paid_rainy transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor rental_cost_land cost_seed value_fertilizer /*
*/ value_pesticide_herbicide /*value_herbicide value_pesticide*/ wages_paid_dry wages_paid_rainy transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crop_income.dta", replace

************
*LIVESTOCK INCOME - VAP complete; RH edited; HI checked 5/2/22 - needs review
************
{ //This bracket here to make the section collapsible.
*Expenses - RH edited, can't disaggregate; complete 7/20
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r2_13.dta", clear
rename ag_r28 cost_fodder_livestock       /* VAP: MW2 has no separate cost_water_livestock */
rename ag_r29 cost_vaccines_livestock     /* Includes medicines */
rename ag_r30 cost_othervet_livestock     /* VAP: TZ didn't have this. Includes dipping, deworming, AI */
gen cost_medical_livestock = cost_vaccines_livestock + cost_othervet_livestock /* VAP: Combining the two categories for later. */
rename ag_r27 cost_hired_labor_livestock 
rename ag_r31 cost_input_livestock        /* VAP: TZ didn't have this. Includes housing equipment, feeding utensils */
recode cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock(.=0) 

collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock  cost_hired_labor_livestock cost_input_livestock, by (y2_hhid)
lab var cost_fodder_livestock "Cost for fodder for <livestock>"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for <livestock>"
lab var cost_othervet_livestock "Cost for other veterinary treatments for <livestock> (incl. dipping, deworming, AI)"
*lab var cost_medical_livestock "Cost for all veterinary services (total vaccine plus othervet)"
lab var cost_hired_labor_livestock "Cost for hired labor for <livestock>"
lab var cost_input_livestock "Cost for livestock inputs (incl. housing, equipment, feeding utensils)"
save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_livestock_expenses.dta", replace



*Livestock products 
* Milk - VAP complete (but question about per unit and per liter price)
use "${MLW_W2_raw_data}\Agriculture\ag_mod_s_13.dta", clear
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
keep y2_hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year //why do we need both per liter and per unit if the same?
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_milk", replace

* Other livestock products  // VAP: Includes milk, eggs, meat, hides/skins and manure. No honey in MW2. TZ does not have meat and manure.  
//RH: Why include milk here if we have a separate milk file (from same raw dta file) and append it later?
use "${MLW_W2_raw_data}\Agriculture\ag_mod_s_13.dta", clear
rename ag_s0a livestock_code
rename ag_s02 months_produced
rename ag_s03a quantity_month
rename ag_s03b quantity_month_unit
*replace quantity_month_unit =. if livestock_code==401 & quantity_month_unit!=1     // milk, keeping only liters.  // removing milk, since this is "other"
// 2 obsns in buckets will be 0. Conversion?
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
gen quantity_produced = months_produced * quantity_month // Units are liters for milk, pieces for eggs & skin, kg for meat and manure. (RH Note: only showing values for chicken eggs - is that correct?)
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
keep y2_hhid livestock_code quantity_produced price_per_unit earnings_sales

label define livestock_code_label 402 "Chicken Eggs" 403 "Guinea Fowl Eggs" 404 "Meat" 406 "Skin/Hide" 407 "Manure" 408 "Other" //RH - added "other" lbl to 408, removed 401 "Milk"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price per unit sold"
lab var price_per_unit_hh "Price per unit sold at household level"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_other", replace

// RH: removing milk, so this only has other livestock products. Next section will have milk and other

*All Livestock Products
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_milk", clear
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_other"
recode price_per_unit (0=.)
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta"
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
lab var price_per_unit "Price per unit sold"
lab var quantity_produced "Quantity of product produced"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", replace
//RH Note: double check values later, esp quantity produced (why only chicken eggs?)

* EA Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district TA ea livestock_code: egen obs_ea = count(observation)
//RH note - TA is traditional authority. Do we want the label?
collapse (median) price_per_unit [aw=weight], by (region district TA ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_ea.dta", replace

* TA Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district TA livestock_code: egen obs_TA = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district TA livestock_code obs_TA)
rename price_per_unit price_median_TA
lab var price_median_TA "Median price per unit for this livestock product in the TA"
lab var obs_TA "Number of sales observations for this livestock product in the TA"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_TA.dta", replace

* District Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_district.dta", replace

* Region Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_region.dta", replace

* Country Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_country.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products", clear
merge m:1 region district TA ea livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_TA if price_per_unit==. & obs_TA >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values" //is 10 the local median value?

gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==402|livestock_code==403
gen value_other_produced = quantity_produced * price_per_unit if livestock_code== 404|livestock_code==406|livestock_code==407|livestock_code==408
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (y2_hhid)

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
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_products", replace // RH complete
 
* Manure (Dung in TZ)
use "${MLW_W2_raw_data}\Agriculture\ag_mod_s_13.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (y2_hhid)
lab var sales_manure "Value of manure sold" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_manure.dta", replace // RH complete

*Sales (live animals)
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta", clear
rename ag_r0a livestock_code
rename ag_r17 income_live_sales     // total value of sales of [livestock] live animals last 12m
rename ag_r16 number_sold          // # animals sold alive last 12 m
rename ag_r19 number_slaughtered  // # animals slaughtered last 12 m 
/* VAP: not available in MW2
rename lf02_32 number_slaughtered_sold  // # of slaughtered animals sold
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
rename lf02_33 income_slaughtered // # total value of sales of slaughtered animals last 12m
*/
rename ag_r11 value_livestock_purchases // tot. value of purchase of live animals last 12m
recode income_live_sales number_sold number_slaughtered /*number_slaughtered_sold income_slaughtered*/ value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animals sold"
recode price_per_animal (0=.) 
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta"
drop if _merge==2
drop _merge
keep y2_hhid weight region district TA ea livestock_code number_sold income_live_sales number_slaughtered /*number_slaughtered_sold income_slaughtered*/ price_per_animal value_livestock_purchases
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", replace // RH complete

*Implicit prices  // VAP: MW2 does not have value of slaughtered livestock
* EA Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district TA ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district TA ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_ea.dta", replace // RH complete

* TA Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district TA livestock_code: egen obs_TA = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district TA livestock_code obs_TA)
rename price_per_animal price_median_TA
lab var price_median_TA "Median price per unit for this livestock in the TA"
lab var obs_TA "Number of sales observations for this livestock in the TA"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_TA.dta", replace // RH complete

* District Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_district.dta", replace

* Region Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_region.dta", replace

* Country Level
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_country.dta", replace //RH complete

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_sales", clear
merge m:1 region district TA ea livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_TA if price_per_animal==. & obs_TA >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold // VAP: This mean value differs from mean of ag_r17: total value of [livestock]sales last 12m
gen value_slaughtered = price_per_animal * number_slaughtered


collapse (sum) /*value_livestock_sales*/ value_livestock_purchases value_lvstck_sold /*value_slaughtered*/, by (y2_hhid)
drop if y2_hhid==""
*lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases"
*lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_sales", replace //RH complete

*TLU (Tropical Livestock Units)
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta", clear
rename ag_r0a lvstckid //NOTE: why changing the name to lvstckid here?
gen tlu_coefficient=0.5 if (lvstckid==301|lvstckid==302|lvstckid==303|lvstckid==304|lvstckid==3304) // calf, steer/heifer, cow, bull, ox
replace tlu_coefficient=0.1 if (lvstckid==307|lvstckid==308) //goats, sheep
replace tlu_coefficient=0.2 if (lvstckid==309) // pigs
replace tlu_coefficient=0.01 if (lvstckid==311|lvstckid==313|lvstckid==315|lvstckid==319|lvstckid==3310|lvstckid==3314) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
replace tlu_coefficient=0.3 if (lvstckid==3305) // donkey/mule/horse
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

rename lvstckid livestock_code //why not do this earlier?
rename ag_r07 number_1yearago
rename ag_r02 number_today_total
rename ag_r03 number_today_exotic
gen number_today_indigenous = number_today_total - number_today_exotic
recode number_today_total number_today_indigenous number_today_exotic (.=0)
*gen number_today = number_today_indigenous + number_today_exotic
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_total * tlu_coefficient
rename ag_r17 income_live_sales 
rename ag_r16 number_sold 

rename ag_r23b lost_disease // VAP: Includes lost to injury in MW2
*rename lf02_22 lost_injury 
rename ag_r15 lost_stolen // # of livestock lost or stolen in last 12m
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
	collapse (firstnm) share_imp_herd_cows (sum) number_today_total number_1yearago animals_lost12months lost_disease /*ihs*/ number_today_exotic lvstck_holding=number_today_total, by(y2_hhid species)
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
	collapse (sum) number_today_total number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(y2_hhid)
	
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
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district TA ea livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_ea.dta"
drop _merge
merge m:1 region district TA livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_TA.dta"
drop _merge
merge m:1 region district livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_district.dta"
drop _merge
merge m:1 region livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_region.dta"
drop _merge
merge m:1 livestock_code using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_prices_country.dta"
drop _merge 
recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_TA if price_per_animal==. & obs_TA >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today_total * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (y2_hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if y2_hhid==""
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_TLU.dta", replace

*Livestock income
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_sales", clear
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_livestock_products", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_manure.dta", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_expenses", nogen
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_TLU.dta", nogen

gen livestock_income = value_lvstck_sold + /*value_slaughtered*/ - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_income", replace

}

************
*FISH INCOME

************
*Fishing expenses  
/*VAP: Method of calculating ft and pt weeks and days consistent with ag module indicators for rainy/dry seasons*/
use "${MLW_W2_raw_data}\Fisheries\fs_mod_c_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_g_13.dta"
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
collapse (max) weeks_fishing days_per_week, by (y2_hhid) 
keep y2_hhid weeks_fishing days_per_week
lab var weeks_fishing "Weeks spent working as a fisherman (maximum observed across individuals in household)"
lab var days_per_week "Days per week spent working as a fisherman (maximum observed across individuals in household)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weeks_fishing.dta", replace

use "${MLW_W2_raw_data}\Fisheries\fs_mod_d1_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_h2_13.dta"
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weeks_fishing.dta"
rename weeks_fishing weeks
rename fs_d13 fuel_costs_week
replace fuel_costs_week = fs_h13 if fuel_costs_week==.
rename fs_d12 rental_costs_fishing // VAP: Boat/Engine rental.
// Relevant and in the MW2 Qs., but missing in .dta files. 
// fs_d6: "How much did your hh. pay to rent [gear] for use in last high season?" 
replace rental_costs_fishing=fs_h12 if rental_costs_fishing==.
rename fs_d10 purchase_costs_fishing // VAP: Boat/Engine purchase. Purchase cost is additional in MW2, TZ code does not have this. 
// Also relevant but missing in .dta files. 
// fs_d4: "If you or any member of your household engaged in fishing had to purchase a [FISHING GEAR], how much would you have
// paid during the last HIGH fishing season? 
replace purchase_costs_fishing=fs_h10 if purchase_costs_fishing==. 
recode weeks fuel_costs_week rental_costs_fishing  purchase_costs_fishing(.=0)
gen cost_fuel = fuel_costs_week * weeks
collapse (sum) cost_fuel rental_costs_fishing, by (y2_hhid)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fishing_expenses_1.dta", replace // VAP: Not including hired labor costs, keeping consistent with TZ. Can add this for MW if needed. 

* Other fishing costs  
use "${MLW_W2_raw_data}\Fisheries\fs_mod_d4_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_h4_13.dta"
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weeks_fishing"
rename fs_d24a total_cost_high // total other costs in high season, only 6 obsns. 
replace total_cost_high=fs_h24a if total_cost_high==.
rename fs_d24b unit
replace unit=fs_h24b if unit==. 
gen cost_paid = total_cost_high if unit== 2  // season
replace cost_paid = total_cost_high * weeks_fishing if unit==1 // weeks
collapse (sum) cost_paid, by (y2_hhid)
lab var cost_paid "Other costs paid for fishing activities"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fishing_expenses_2.dta", replace

* Fish Prices
//ALT 10.18.19: It doesn't look like the data match up with the questions in module e.

use "${MLW_W2_raw_data}\Fisheries\fs_mod_e1_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_i1_13.dta"
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
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hhids.dta"
drop if _merge==2
drop _merge
recode price_per_unit (0=.) 
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==11
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_prices.dta", replace

* Value of fish harvest & sales 
use "${MLW_W2_raw_data}\Fisheries\fs_mod_e1_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_i1_13.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=11) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b unit  // piece, dozen/bundle, kg, small basket, large basket
merge m:1 fish_code unit using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_prices.dta"
drop if _merge==2
drop _merge
rename fs_e08a quantity_1
replace quantity_1=fs_i08a if quantity_1==.
rename fs_e08b unit_1
replace unit_1=fs_i08b if unit_1==.
gen price_unit_1 = fs_e08d // not divided by qty unlike TZ, not sure about the logic of dividing here. 
replace price_unit_1=fs_i08d if price_unit_1==.
rename fs_e08e quantity_2
replace quantity_2=fs_i08e if quantity_2==.
rename fs_e08f unit_2 
replace unit_2= fs_i08f if unit_2==.
gen price_unit_2=fs_e08h // not divided by qty unlike TZ.
replace price_unit_2=fs_i08h if price_unit_2==.
recode quantity_1 quantity_2 fish_quantity_year (.=0)
gen income_fish_sales = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest = (fish_quantity_year * price_unit_1) if unit==unit_1 
replace value_fish_harvest = (fish_quantity_year * price_per_unit_median) if value_fish_harvest==.
collapse (sum) value_fish_harvest income_fish_sales, by (y2_hhid)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_income.dta", replace
//ALT changes for W1:
//replace price_unit_1 = price_per_unit_median if price_unit_1==. //Replace w/ median value if unit_1 value is missing
//recode quantity_1 quantity_2 fish_quantity_year price_unit_2 (.=0) //need to include price_unit_2 or income calculation will fail


************
*SELF-EMPLOYMENT INCOME
************

*Fish trading
use "${MLW_W2_raw_data}\Fisheries\fs_mod_c_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_g_13.dta"
rename fs_c04a weeks_fish_trading 
replace weeks_fish_trading=fs_g04a if weeks_fish_trading==.
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (y2_hhid) 
keep y2_hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weeks_fish_trading.dta", replace

use "${MLW_W2_raw_data}\Fisheries\fs_mod_f1_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_f2_13.dta"
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_j1_13.dta"
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_j2_13.dta"
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
/* VAP: Had added other costs here, but commenting out to be consistent with TZ. 
rename fs_f05 other_costs_fishtrading // VAP: Hired labor, transport, packaging, ice, tax in MW2, not in TZ.
replace other_costs_fishtrading=fs_j05 if other_costs_fishtrading==. 
*/
recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 /*other_costs_fishtrading*/(.=0)

gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2) /*+ other_costs_fishtrading*/
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit, by (y2_hhid)
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep y2_hhid weekly_fishtrade_profit
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_trading_revenues.dta", replace   

use "${MLW_W2_raw_data}\Fisheries\fs_mod_f2_13.dta", clear
append using "${MLW_W2_raw_data}\Fisheries\fs_mod_j2_13.dta"
rename fs_f05 weekly_costs_for_fish_trading // VAP: Other costs: Hired labor, transport, packaging, ice, tax in MW2.
replace weekly_costs_for_fish_trading=fs_j05 if weekly_costs_for_fish_trading==.
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (y2_hhid)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep y2_hhid weekly_costs_for_fish_trading
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_trading_other_costs.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_weeks_fish_trading.dta", clear
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_trading_revenues.dta" 
drop _merge
merge 1:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep y2_hhid fish_trading_income
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fish_trading_income.dta", replace


************
*NON-AG WAGE INCOME
************
use "${MLW_W2_raw_data}\Household\hh_mod_e_13.dta", clear
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
replace secwage_most_recent_payment = . if hh_e33b== 62  // code of secondary wage job
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
collapse (sum) annual_salary, by (y2_hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_wage_income.dta", replace



************
*AG WAGE INCOME
************
use "${MLW_W2_raw_data}\Household\hh_mod_e_13.dta", clear
rename hh_e06_4 wage_yesno // MW2: last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
* TZ: last 12m, work as an unpaid apprentice OR employee for a wage, salary, commission or any payment in kind; incl. paid apprenticeship, domestic work or paid farm work 
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. TZ: During the last 12 months, for how many months did [NAME] work in this job?
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. TZ: During the last 12 months, how many weeks per month did [NAME] usually work in this job?
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. TZ: During the last 12 months, how many hours per week did [NAME] usually work in this job?
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
collapse (sum) annual_salary, by (y2_hhid)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_agwage_income.dta", replace  // 0 annual earnings, 3907 obsns


************
*OTHER INCOME
************
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_prices.dta", clear
keep if crop_code==1 // keeping only maize for later
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta", replace

use "${MLW_W2_raw_data}\Household\hh_mod_p_13.dta", clear
append using "${MLW_W2_raw_data}\Household\hh_mod_r_13.dta"
append using "${MLW_W2_raw_data}\Household\hh_mod_o_13.dta"
merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
rename hh_p0a income_source
gen rental_income=1 if inlist(income_source, 106, 107, 108, 109) // non-ag land rental, house/apt rental, shope/store rental, vehicle rental
gen pension_investment_income=1 if income_source==105| income_source==104 // pension & savings/interest/investment income
gen asset_sale_income=1 if inlist(income_source, 110,111,112) // real estate sales, non-ag hh asset sale income, hh ag/fish asset sale income
gen other_income=1 if inlist(income_source, 113, 114, 115) // inheritance, lottery, other income
rename hh_r0a prog_code
gen assistance_cash= hh_r02a if inlist(prog_code, 1031, 1032,104,108,1091,111,112) // Cash from MASAF, Non-MASAF pub. works, 
*inputs-for-work, sec. level scholarships, tert. level. scholarships, dir. Cash Tr. from govt, DCT other
gen assistance_food= hh_r02b if inlist(prog_code, 102, 1032) // Cash value of in-kind assistance from free food and Food for work. 
replace assistance_food=hh_r02c*price_kg if prog_code==101 & crop_code==1 // cash value of free maize, imputed from hh. median prices. 
gen assistance_inkind=hh_r02b if inlist(prog_code, 1031, 104, 108, 1091, 111, 112) // cash value of in-kind assistance from MASAF
* inputs-for-work, scholarships (sec. & tert.), direct cash transfers (govt & other)
gen cash_received=1 if income_source== 101 // Cash transfers/gifts from indivs. 
gen inkind_gifts_received=1 if inlist(income_source, 102,103) // Food & In-kind transfers/gifts from indivs.
rename hh_o14 cash_remittance // VAP: Module O in MW2
rename hh_o17 in_kind_remittance // VAP: Module O in MW2
recode rental_income pension_investment_income asset_sale_income other_income assistance_cash assistance_food assistance_inkind cash_received inkind_gifts_received cash_remittance in_kind_remittance (.=0)

gen remittance_income = cash_received + inkind_gifts_received + cash_remittance + in_kind_remittance
gen assistance_income = assistance_cash + assistance_food + assistance_inkind
collapse (sum) rental_income pension_investment_income asset_sale_income other_income remittance_income assistance_income, by (y2_hhid)
lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_other_income.dta", replace


use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear // *VAP: The below code calculates only agricultural land rental income, per TZ guideline code 
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta"
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
collapse (sum) land_rental_income, by (y2_hhid)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_rental_income.dta", replace

************
*FARM SIZE / LAND SIZE
************

***Determining whether crops were grown on a plot
use "${MLW_W2_raw_data}\Agriculture\ag_mod_g_13.dta", clear
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_m_13.dta"
ren ag_g00 plot_id
drop if plot_id==""
drop if ag_g0b==. // crop code
gen crop_grown = 1 
collapse (max) crop_grown, by(y2_hhid plot_id)
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crops_grown.dta", replace
***

use "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta", clear
rename ag_k00 plot_id
tempfile ag_mod_k_13_numeric
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_ag_mod_k_13_temp.dta", replace  // VAP:Renaming plot ids, to work with Module D and K together.
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
rename ag_d00 plot_id
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_ag_mod_k_13_temp.dta"
gen cultivated = (ag_d14==1 | ag_k15==1) // VAP: cultivated plots in rainy or dry seasons
collapse (max) cultivated, by (y2_hhid plot_id)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_parcels_cultivated.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_parcels_cultivated.dta", clear
merge 1:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_areas.dta",
drop if _merge==2
keep if cultivated==1

replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (y2_hhid)
rename area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_size.dta", replace

* All agricultural land
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
rename ag_d00 plot_id
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_ag_mod_k_13_temp.dta"
drop if plot_id==""
merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_crops_grown.dta", nogen
// VAP: 
* 6,196 matched
*1,107 not matched (from master)
gen rented_out = (ag_d14==2 |ag_k15==2)
gen cultivated_dry = (ag_k15==1)
bys y2_hhid plot_id: egen plot_cult_dry = max(cultivated_dry)
replace rented_out = 0 if plot_cult_dry==1 // VAP: From TZ:If cultivated in short season, not considered rented out in long season.
// TZ code commented out the below:
* drop if rented_out==1
* 62 obs dropped
//
drop if rented_out==1 & crop_grown!=1
* VAP:25 obs dropped
gen agland = (ag_d14==1 | ag_d14==4 |ag_k15==1 | ag_k15==4) // All cultivated AND fallow plots, forests/woodlot & pasture is captured within "other" (can't be separated out)
// TZ code commented out the below:
*keep if agland==1
*4,360 obs dropped 
//DMC adding 6.25.19 
drop if agland!=1 & crop_grown==.
* 352 obs dropped
collapse (max) agland, by (y2_hhid plot_id)
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_parcels_agland.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_parcels_agland.dta", clear
merge 1:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)		
collapse (sum) area_acres_meas, by (y2_hhid)
rename area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_farmsize_all_agland.dta", replace


use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_ag_mod_k_13_temp.dta"
drop if plot_id==""
gen rented_out = (ag_d14==2 | ag_d14==3 | ag_k15==2 | ag_k15==3) // VAP: In MW2, rented out (2) & gave out for free (3)
gen cultivated_dry = (ag_k15==1)
bys y2_hhid plot_id: egen plot_cult_dry = max(cultivated_dry)
replace rented_out = 0 if plot_cult_dry==1 // If cultivated in dry season, not considered rented out in rainy season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (y2_hhid plot_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_parcels_held.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_parcels_held.dta", clear
merge 1:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (y2_hhid)
rename area_acres_meas land_size
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
rename ag_d00 plot_id
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_ag_mod_k_13_temp.dta"
drop if plot_id==""
merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_areas.dta", nogen keep(1 3)
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)	
collapse (max) area_acres_meas, by(y2_hhid plot_id)
rename area_acres_meas land_size_total
collapse (sum) land_size_total, by(y2_hhid)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_land_size_total.dta", replace

***************
*OFF-FARM HOURS // RH: Needs update w/ Didier's 3/21/21 code    
***************
use "${MLW_W2_raw_data}\Household\hh_mod_e_13.dta", clear
gen primary_hours = hh_e24_1 if !inlist(hh_e19b, 62, 63, 64, 71) & hh_e19b!=. 
*VAP: Excluding agr. & animal husbandry workers, forestry workers, fishermen & hunters, miners & quarrymen per TZ.
*using occup. code variable hh_e19b, confirm.  
gen secondary_hours = hh_e38_1 if hh_e33b!=21 & hh_e33b!=.  
* VAP: Excluding ag & animal husbandry. Confirm use of occup. code variabe hh_e33b
gen ownbiz_hours =  hh_e08 + hh_e09 // VAP: TZ used # of hrs as unpaid family worker on non-farm hh. biz. 
* VAP: For MW2, I am using "How many hours in the last seven days did you run or do any kind of non-agricultural or non-fishing 
* household business, big or small, for yourself?" &
* "How many hours in the last seven days did you help in any of the household's non-agricultural or non-fishing household businesses, if any"?
egen off_farm_hours = rowtotal(primary_hours secondary_hours ownbiz_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(y2_hhid)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_off_farm_hours.dta", replace

************
*FARM LABOR
************
** Family labor
* Rainy Season
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
rename ag_d47c landprep_women  // # of days women hired for land preparation, planting, ridging, weeding and fertilizing
rename ag_d47a landprep_men   // # of days men hired for land preparation, planting, ridging, weeding and fertilizing
rename ag_d47e landprep_child // # of days children hired for land preparation, planting, ridging, weeding and fertilizing 
rename ag_d48a harvest_men    // # of days men hired for harvesting
rename ag_d48c harvest_women // # of days women hired for harvesting
rename ag_d48e harvest_child // # of days children hired for harvesting
recode landprep_women landprep_men landprep_child harvest_men harvest_women harvest_child (.=0)
egen days_hired_rainyseason = rowtotal(landprep_women landprep_men landprep_child harvest_men harvest_women harvest_child) 
recode ag_d42c ag_d42g ag_d42k ag_d42o(.=0)  // # of days per week spent by hh.members (upto 4) in land prep/planting
egen days_flab_landprep = rowtotal(ag_d42c ag_d42g ag_d42k ag_d42o)
recode ag_d43c ag_d43g ag_d43k ag_d43o (.=0) // # of days per week spent by hh.members (upto 4) in weeding, fertilizing and/or any other non-harvest activity
egen days_flab_weeding = rowtotal(ag_d43c ag_d43g ag_d43k ag_d43o)
recode ag_d44c ag_d44g ag_d44k ag_d44o (.=0) // # of days per week spent by hh.members (upto 4) in harvesting
egen days_flab_harvest = rowtotal(ag_d44c ag_d44g ag_d44k ag_d44o)
gen days_famlabor_rainyseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren ag_d00 plot_id
collapse (sum) days_hired_rainyseason days_famlabor_rainyseason, by (y2_hhid plot_id)
lab var days_hired_rainyseason  "Workdays for hired labor (crops) in rainy season"
lab var days_famlabor_rainyseason  "Workdays for family labor (crops) in rainy season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_farmlabor_rainyseason.dta", replace

* Dry Season
use "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta", clear
rename ag_k46a no_days_men_all
rename ag_k46c no_days_women_all 
rename ag_k46e no_days_chldrn_all 
recode no_days_men_all no_days_women_all no_days_chldrn_all(.=0)
egen days_hired_dryseason = rowtotal(no_days_men_all no_days_women_all no_days_chldrn_all) 
recode ag_k43c ag_k43g ag_k43k ag_k43o(.=0) // # of days per week spent by hh.members (upto 4) in land prep/planting
egen days_flab_landprep = rowtotal(ag_k43c ag_k43g ag_k43k ag_k43o)
recode ag_k44c ag_k44g ag_k44k ag_k44o (.=0) // # of days per week spent by hh.members (upto 4) in weeding, fertilizing and/or any other non-harvest activity
egen days_flab_weeding = rowtotal(ag_k44c ag_k44g ag_k44k ag_k44o)
recode ag_k45c ag_k45g ag_k45k ag_k45o(.=0) // # of days per week spent by hh.members (upto 4) in harvesting
egen days_flab_harvest = rowtotal(ag_k45c ag_k45g ag_k45k ag_k45o)
gen days_famlabor_dryseason = days_flab_landprep + days_flab_weeding + days_flab_harvest
ren ag_k00 plot_id
collapse (sum) days_hired_dryseason days_famlabor_dryseason, by (y2_hhid plot_id)
lab var days_hired_dryseason  "Workdays for hired labor (crops) in dry season"
lab var days_famlabor_dryseason  "Workdays for family labor (crops) in dry season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_farmlabor_dryseason.dta", replace


*Hired Labor
use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_farmlabor_rainyseason.dta", clear
merge 1:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_farmlabor_dryseason.dta"
drop _merge
recode days*  (.=0)
collapse (sum) days*, by(y2_hhid plot_id)
egen labor_hired =rowtotal(days_hired_rainyseason days_hired_dryseason)
egen labor_family=rowtotal(days_famlabor_rainyseason  days_famlabor_dryseason)
egen labor_total = rowtotal(days_hired_rainyseason days_famlabor_rainyseason days_hired_dryseason days_famlabor_dryseason)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
//lab var labor_total "Total labor days allocated to the farm" ALT: Duplicate
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_family_hired_labor.dta", replace
collapse (sum) labor_*, by(y2_hhid)
lab var labor_total "Total labor days (family, hired, or other) allocated to the farm"
lab var labor_hired "Total labor days (hired) allocated to the farm"
lab var labor_family "Total labor days (family) allocated to the farm"
lab var labor_total "Total labor days allocated to the farm" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_family_hired_labor.dta", replace

***************
*VACCINE USAGE - VAP/ALT complete
***************
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta", clear
gen vac_animal=ag_r24>0
* MW2: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace vac_animal = 0 if ag_r24==0  
replace vac_animal = . if ag_r24==. // VAP: 4092 observations on a hh-animal level

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

collapse (max) vac_animal*, by (y2_hhid)
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
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_vaccine.dta", replace

 
*vaccine use livestock keeper  
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta", clear
gen all_vac_animal=ag_r24>0
* MW2: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace all_vac_animal = 0 if ag_r24==0  
replace all_vac_animal = . if ag_r24==. // VAP: 4092 observations on a hh-animal level
keep y2_hhid ag_r06a ag_r06b all_vac_animal

//ALT 10.21.19: These lines do the same thing as the commented lines without dealing with juggling tempfiles
ren ag_r06a farmerid1
ren ag_r06b farmerid2
gen t=1
gen patid=sum(t)
reshape long farmerid, i(patid) j(idnum)
drop t patid

collapse (max) all_vac_animal , by(y2_hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 y2_hhid personid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_gender_merge.dta", nogen
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
ren personid indidy2
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_farmer_vaccine.dta", replace

***************
*ANIMAL HEALTH - DISEASES - VAP complete, RH checked 8/3
***************
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta", clear
gen disease_animal = 1 if ag_r22==1 // Answered "yes" for "Did livestock suffer from any disease in last 12m?"
replace disease_animal = 0 if inlist(ag_r22,0,2,3,4,6,9) // VAP: 2=No disease, other category numbers are unnamed, dropping these. 
replace disease_animal = . if (ag_r22==.) 
* VAP: TZ main diseases: FMD, lumpy skin, brucelosis, CCPP, BQ. MW2 has different main diseases. 
gen disease_ASF = ag_r23a==1  //  African swine fever
gen disease_amapl = ag_r23a==2 // Amaplasmosis
gen disease_bruc = ag_r23a== 7 // Brucelosis
gen disease_mange = ag_r23a==18 // Mange
gen disease_NC= ag_r23a==20 // New Castle disease
gen disease_spox= ag_r23a==22 // Small pox

rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 311,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

*A loop to create species variables
foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox{
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) disease_*, by (y2_hhid)
lab var disease_animal "1= Household has animal that suffered from disease"
lab var disease_ASF "1= Household has animal that suffered from African Swine Fever"
lab var disease_amapl"1= Household has animal that suffered from amaplasmosis disease"
lab var disease_bruc"1= Household has animal that suffered from brucelosis"
lab var disease_mange "1= Household has animal that suffered from mange disease"
lab var disease_NC "1= Household has animal that suffered from New Castle disease"
lab var disease_spox "1= Household has animal that suffered from small pox"

	foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}

save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_livestock_diseases.dta", replace

***************
*USE OF INORGANIC FERTILIZER -VAP/ALT, RH edited 8/6/21 
***************
use "${MLW_W2_raw_data}/Agriculture/ag_mod_d_13.dta", clear
append using "${MLW_W2_raw_data}/Agriculture/ag_mod_k_13.dta" 
gen all_use_inorg_fert=.
replace all_use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace all_use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode all_use_inorg_fert (.=0)
lab var all_use_inorg_fert "1 = Household uses inorganic fertilizer"

keep y2_hhid ag_d01 ag_d01_2a ag_d01_2b ag_k02 ag_k02_2a ag_k02_2b all_use_inorg_fert
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

collapse (max) all_use_inorg_fert , by(y2_hhid farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 y2_hhid personid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren personid indidy2
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_farmer_fert_use.dta", replace


*********************
*REACHED BY AG EXTENSION - VAP complete, RH checked (1 question) 8/26/21   
*********************
//RH: edited to add ag_mod_t1_10, rainy vs dry season
use "${MLW_W2_raw_data}/Agriculture/ag_mod_t1_13.dta", clear
append using "${MLW_W2_raw_data}/Agriculture/ag_mod_t1_10.dta", force
//^^using append force b/c mismatch bw string and byte for variable qx_type; variable is not needed for this section
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
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  // VAP: Added new variables to categories based on MW2 data, please check. 
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_pvt) //advice_pvt new addition
gen ext_reach_unspecified=(advice_neigh==1 | advice_pub==1 | advice_other==1 | advice_farmer==1 | advice_ffd==1 | advice_course==1 | advice_village==1) //RH - Re: VAP's check request - Farmer field days and courses incl. here - seems correct since we don't know who put those on, but flagging
gen ext_reach_ict=(advice_electronicmedia==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1)

collapse (max) ext_reach_* , by (y2_hhid)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_any_ext.dta", replace

********************************************************************************
* MOBILE OWNERSHIP * //RH complete 8/26/21 - HI checked 5/2/22
********************************************************************************
//Added based on TZA w5 code

use "${MLW_W2_raw_data}\Household\hh_mod_f_13.dta", clear
//recode missing to 0 in hh_g301 (0 mobile owned if missing)
recode hh_f34 (.=0)
ren hh_f34 hh_number_mobile_owned
*recode hh_number_mobile_owned (.=0) 
gen mobile_owned = 1 if hh_number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0
collapse (max) mobile_owned, by(y2_hhid)
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_mobile_own.dta", replace

*********************
*USE OF FORMAL FINANCIAL SERVICES -- VAP complete, RH checked 8/9/21 
*********************
use "${MLW_W2_raw_data}\Household\hh_mod_f_13.dta", clear
append using "${MLW_W2_raw_data}\Household\hh_mod_s1_13.dta"
gen borrow_bank= hh_s04==10 // VAP: Code source of loan. No microfinance or mortgage loan in Malawi W2 unlike TZ. 
gen borrow_relative=hh_s04==1 // NA in TZ
gen borrow_moneylender=hh_s04==4 // NA in TZ
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
gen borrow_other_fin=hh_s04==7|hh_s04==8|hh_s04==9 // VAP: MARDEF, MRFC, SACCO
gen borrow_neigh=hh_s04==2
gen borrow_employer=hh_s04==5
gen borrow_ngo=hh_s04==11
gen borrow_other=hh_s04==12

gen use_bank_acount=hh_f52==1
// VAP: No MM for MW2.  
// gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 | hh_q01_4==1 // use any MM services - MPESA ZPESA AIRTEL TIGO PESA. 
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit= borrow_bank==1  | borrow_other_fin==1 // VAP: Include religious institution in this definition? No mortgage.  
// VAP: No digital and insurance in MW2
// gen use_fin_serv_insur= borrow_insurance==1
// gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 |  use_fin_serv_others==1 /*use_fin_serv_insur==1 | use_fin_serv_digital==1 */ 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (y2_hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
// lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
// lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_fin_serv.dta", replace

************
*MILK PRODUCTIVITY - VAP/ALT complete, RH edited 8/10/21
************
*Total production
//RH: only cow milk in MWI, not including large ruminant variables
use "${MLW_W2_raw_data}\Agriculture\ag_mod_s_13.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]? (rh edited)
rename ag_s03a liters_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. (RH renamed to be more consistent with TZA (from qty_milk_per_month to liters_month))
gen milk_liters_produced = months_milked * liters_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

lab var months_milked "Average months milked in last year (household)"
drop if milk_liters_produced==.
keep y2_hhid product_code months_milked liters_month milk_liters_produced
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_milk_animals.dta", replace


************
*EGG PRODUCTIVITY - VAP complete, RH checked
************
use "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta", clear
rename ag_r0a lvstckid
gen poultry_owned = ag_r02 if inlist(lvstckid, 311, 313, 315, 318, 319, 3310, 3314) // For MW2: local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl
collapse (sum) poultry_owned, by(y2_hhid)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${MLW_W2_raw_data}\Agriculture\ag_mod_s_13.dta", clear
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
collapse (sum) eggs_per_month (max) eggs_months, by (y2_hhid) // VAP: Collapsing chicken & guinea fowl eggs
gen eggs_total_year = eggs_months* eggs_per_month // Units are pieces for eggs 
merge 1:1 y2_hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep y2_hhid eggs_months eggs_per_month eggs_total_year poultry_owned 

lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_eggs_animals.dta", replace



************
*LAND RENTAL 
************

* Rainy Season *
use "${MLW_W2_raw_data}\Agriculture\ag_mod_c_13.dta", clear		
rename ag_c00 plot_id
gen area_acres_est = ag_c04a if ag_c04b == 1
replace area_acres_est = (ag_c04a*2.47105) if ag_c04b == 2 & area_acres_est ==.  // ha to acres
replace area_acres_est = (ag_c04a*0.000247105) if ag_c04b == 3 & area_acres_est ==. // m-sq to acres
gen area_acres_meas = ag_c04c
keep if area_acres_est !=.
gen area_est_hectares=area_acres_est* (1/2.47105)  // farmer estimated
gen area_meas_hectares= area_acres_meas* (1/2.47105) // GPS area
keep y2_hhid plot_id area_est_hectares area_meas_hectares
lab var area_meas_hectares "Plot area in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_area_rainyseason.dta", replace


*Getting plot rental rate
use "${MLW_W2_raw_data}/Agriculture/ag_mod_d_13.dta", clear
rename ag_d00 plot_id
merge 1:1 plot_id y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_area_rainyseason.dta" , nogen		
drop if plot_id=="" 
gen cultivated = ag_d14==1
merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta", nogen keep (1 3)

tab ag_d12 // VAP: Periods of time covered: Rainy season, full year, other
gen rental_cost_land_cshpd = ag_d11a //rainy season, cash already paid
gen rental_cost_land_kindpd = ag_d11b //rainy season, in-kind already paid
gen rental_cost_land_cshfut = ag_d11c //rainy season, future cash payment owed
gen rental_cost_land_kindfut = ag_d11d //rainy season,in-kind payment owed
recode rental_cost_land_cshpd rental_cost_land_kindpd rental_cost_land_cshfut rental_cost_land_kindfut (.=0)
gen plot_rental_rate = rental_cost_land_cshpd + rental_cost_land_kindpd + rental_cost_land_cshfut + rental_cost_land_kindfut
recode plot_rental_rate (0=.) 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rent_nomiss_rainyseason.dta", replace

preserve
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	// gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(y2_hhid)
	lab var value_rented_land_male "Value of rented land (male-managed plot)
	lab var value_rented_land_female "Value of rented land (female-managed plot)
	// lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)"
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rental_rate_rainyseason.dta", replace
restore
 
gen ha_rental_rate_hh = plot_rental_rate/area_meas_hectares
preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			
	collapse (sum) plot_rental_rate area_meas_hectares, by(y2_hhid)		
	gen ha_rental_hh_rs = plot_rental_rate/area_meas_hectares				
	keep ha_rental_hh_rs y2_hhid
	lab var ha_rental_hh_rs "Area of rented plot during the rainy season"
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_rental_rate_hhid_rainyseason.dta", replace
restore

*Merging in geographic variables
merge m:1 y2_hhid using "${MLW_W2_raw_data}\Household\hh_mod_a_filt_13.dta", nogen assert(2 3) keep(3)
rename hh_a10a TA
rename ea_id ea	
*Geographic medians
bys region district TA ea: egen ha_rental_count_ea = count(ha_rental_rate_hh) // region, district, TA, ea (TZ had ward & village instead of TA & EA)
bys region district TA ea: egen ha_rental_rate_ea = median(ha_rental_rate_hh)

bys region district TA: egen ha_rental_count_TA = count(ha_rental_rate_hh)
bys region district TA: egen ha_rental_rate_TA = median(ha_rental_rate_hh)

bys region district: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region district: egen ha_rental_rate_dist = median(ha_rental_rate_hh)

bys region: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_reg = median(ha_rental_rate_hh)

egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_ea if ha_rental_count_ea>=10		
replace ha_rental_rate = ha_rental_rate_TA if ha_rental_count_TA>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(region district TA ea)
lab var ha_rental_rate "Land rental rate per ha"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_rental_rate_rainyseason.dta", replace


* Dry Season *  
use "${MLW_W2_raw_data}\Agriculture\ag_mod_j_13.dta", clear		
rename ag_j00 plot_id
gen area_acres_est = ag_j05a if ag_j05b == 1
replace area_acres_est = (ag_j05a*0.000247105) if ag_j05b == 3 & area_acres_est ==. // m-sq to acres
gen area_acres_meas = ag_j05c
keep if area_acres_est !=.
gen area_est_hectares=area_acres_est* (1/2.47105)  // farmer estimated
gen area_meas_hectares= area_acres_meas* (1/2.47105) // GPS area
keep y2_hhid plot_id area_est_hectares area_meas_hectares
lab var area_meas_hectares "Plot area in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_area_dryseason.dta", replace
*Getting plot rental rate 
use "${MLW_W2_raw_data}/Agriculture/ag_mod_k_13.dta", clear
rename ag_k00 plot_id
drop if plot_id=="" 
gen cultivated = ag_k15==1
merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_decision_makers.dta", nogen keep (1 3)
merge 1:1 plot_id y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_area_dryseason.dta" , nogen
// merge 1:1 plot_id y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_plot_area_rainyseason.dta", nogen update replace		

gen rental_cost_land_cshpd = ag_k12a //dry season, cash already paid
gen rental_cost_land_kindpd = ag_k12b //dry season, in-kind already paid
gen rental_cost_land_cshfut = ag_k12c //dry season, future cash payment owed
gen rental_cost_land_kindfut = ag_k12d //dry season,in-kind payment owed
recode rental_cost_land_cshpd rental_cost_land_kindpd rental_cost_land_cshfut rental_cost_land_kindfut (.=0)
gen plot_rental_rate = rental_cost_land_cshpd + rental_cost_land_kindpd + rental_cost_land_cshfut + rental_cost_land_kindfut
recode plot_rental_rate (0=.) 
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rent_nomiss_dryseason.dta", replace

preserve
	gen value_rented_land_male = plot_rental_rate if dm_gender==1
	gen value_rented_land_female = plot_rental_rate if dm_gender==2
	// gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
	collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(y2_hhid)
	lab var value_rented_land_male "Value of rented land (male-managed plot)"
	lab var value_rented_land_female "Value of rented land (female-managed plot)"
	// lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)"
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rental_rate_dryseason.dta", replace
restore
 
gen ha_rental_rate_hh = plot_rental_rate/area_meas_hectares
preserve
	keep if plot_rental_rate!=. & plot_rental_rate!=0			
	collapse (sum) plot_rental_rate area_meas_hectares, by(y2_hhid)		
	gen ha_rental_hh_ds = plot_rental_rate/area_meas_hectares				
	keep ha_rental_hh_ds y2_hhid
	lab var ha_rental_hh_ds "Area of rented plot during the dry season"
	save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_rental_rate_hhid_dryseason.dta", replace
restore

*Merging in geographic variables
merge m:1 y2_hhid using "${MLW_W2_raw_data}\Household\hh_mod_a_filt_13.dta", nogen assert(2 3) keep(3)
rename hh_a10a TA
rename ea_id ea

*Geographic medians
bys region district TA ea: egen ha_rental_count_ea = count(ha_rental_rate_hh) // region, district, TA, ea (TZ had ward & village instead of TA & EA)
bys region district TA ea: egen ha_rental_rate_ea = median(ha_rental_rate_hh)

bys region district TA: egen ha_rental_count_TA = count(ha_rental_rate_hh)
bys region district TA: egen ha_rental_rate_TA = median(ha_rental_rate_hh)

bys region district: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region district: egen ha_rental_rate_dist = median(ha_rental_rate_hh)

bys region: egen ha_rental_count_reg = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_reg = median(ha_rental_rate_hh)

egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_ea if ha_rental_count_ea>=10		
replace ha_rental_rate = ha_rental_rate_TA if ha_rental_count_TA>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(region district TA ea)
lab var ha_rental_rate "Land rental rate per ha in dry season"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_rental_rate_dryseason.dta", replace

*Now getting total ha of all plots that were cultivated at least once 
                                     
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rent_nomiss_dryseason.dta"
collapse (max) cultivated area_meas_hectares, by(y2_hhid plot_id)		// collapsing down to household-plot level
gen ha_cultivated_plots = area_meas_hectares if cultivate==1			// non-missing only if plot was cultivated in at least one season
collapse (sum) ha_cultivated_plots, by(y2_hhid)				// total ha of all plots that were cultivated in at least one season
lab var ha_cultivated_plots "Area of cultivated plots (ha)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_cultivated_plots_ha.dta", replace

use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rental_rate_rainyseason.dta", clear
append using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rental_rate_dryseason.dta"
collapse (sum) value_rented_land*, by(y2_hhid)		// total over BOTH seasons (total spent on rent over course of entire year)
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
// lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rental_rate.dta", replace

*Now getting area planted 
*  Rainy Season *
use "${MLW_W2_raw_data}\Agriculture\ag_mod_g_13.dta", clear
drop if ag_g00==""
ren ag_g00 plot_id
merge m:1 y2_hhid plot_id using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_rent_nomiss_rainyseason.dta", nogen keep(1 3)

*First rescaling
gen percent_plot = 1 if ag_g02==1 // VAP: "Was crop planted in entire area of plot"
replace percent_plot = 0.125*(ag_g03==1) + 0.25*(ag_g03==2) + 0.5*(ag_g03==3) + 0.75*(ag_g03==4) + 0.875*(ag_g03==5) if ag_g02==2 // VAP: Created 2 new categories for < 1/4 & >3/4. "Approx how much of plot was planted with [crop]"
bys y2_hhid plot_id: egen total_percent_plot = total(percent_plot)		
replace percent_plot = percent_plot*(1/total_percent_plot) if total_percent_plot>1 & total_percent_plot!=.	

*RH_FLAG
** CODE RUNS TILL HERE **

*AGRICULTURAL WAGES					Malawi_IHS_LSMS_ISA_W2_ag_wage.dta 

************
*AGRICULTURAL WAGES - RH FLAG
************
*RH note: no equivalent dta file - module d (rainy) k (dry) have plot details
*use "${Tanzania_NPS_W4_raw_data}/ag_sec_3a.dta", clear
*append using "${Tanzania_NPS_W4_raw_data}/ag_sec_3b.dta"
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor

*Rainy Season - Module D
use "$/malawi-wave2-2013/raw_data/Agriculture/AG_MOD_D_10.dta", clear
append using "malawi-wave2-2013/raw_data/Agriculture/AG_MOD_D_13.dta"

*this has rainy season plot details 

* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode ag_d48a (0=.) /* set hired 0 days to missing */
ren ag_d48a hired_male_lanprep
replace hired_male_lanprep = ag3b_74_2 if hired_male_lanprep==.
*FLAG - stopped here. Need to figure out how .10 and .13 relate to each other before setting missing to .13 variable (also they have the same name). 


*Dry Season - Module K
use "$/malawi-wave2-2013/raw_data/Agriculture/AG_MOD_K_10.dta", clear
append using "malawi-wave2-2013/raw_data/Agriculture/AG_MOD_K_13.dta"

************
*WOMEN'S DIET QUALITY
************
*Women's diet quality: proportion of women consuming nutrient-rich foods (%)
*Information not available


************
*HOUSEHOLD'S DIET DIVERSITY SCORE
************
* Malawi LSMS 2 does not report individual consumption but instead household level consumption of various food items.
* Thus, only the proportion of households eating nutritious food can be estimated
use "${MLW_W2_raw_data}\Household\hh_mod_g1_13.dta" , clear
ren hh_g02 itemcode
* recode food items to map HDDS food categories
recode itemcode 	(101/117 						=1	"CEREALS" )  //// VAP: Also includes biscuits, buns, scones
					(201/209    					=2	"WHITE ROOTS,TUBERS AND OTHER STARCHES"	)  ////
					(401/414	 					=3	"VEGETABLES"	)  ////	
					(601/610						=4	"FRUITS"	)  ////	
					(504/512 515					=5	"MEAT"	)  ////	VAP: 512: Tinned meat or fish, included in meat				
					(501 						    =6	"EGGS"	)  ////
					(502/503 513/514				=7  "FISH") ///
					(301/310						=8	"LEGUMES, NUTS AND SEEDS") ///
					(701/709						=9	"MILK AND MILK PRODUCTS")  ////
					(801/804  						=10	"OILS AND FATS"	)  ////
					(815/817 						=11	"SWEETS"	)  //// 
					(901/916  810/814 818			=14 "SPICES, CONDIMENTS, BEVERAGES"	)  ////
					,generate(Diet_ID)
				
gen adiet_yes=(hh_g01==1)
ta Diet_ID   
** Now, collapse to food group level; household consumes a food group if it consumes at least one item
collapse (max) adiet_yes, by(y2_hhid Diet_ID) 
label define YesNo 1 "Yes" 0 "No"
label val adiet_yes YesNo
* Now, estimate the number of food groups eaten by each individual
collapse (sum) adiet_yes, by(y2_hhid )
ren adiet_yes number_foodgroup 
sum number_foodgroup 
local cut_off1=6
local cut_off2=round(r(mean))
gen household_diet_cut_off1=(number_foodgroup>=`cut_off1')
gen household_diet_cut_off2=(number_foodgroup>=`cut_off2')
lab var household_diet_cut_off1 "1= household consumed at least `cut_off1' of the 12 food groups last week" 
lab var household_diet_cut_off2 "1= household consumed at least `cut_off2' of the 12 food groups last week" 
label var number_foodgroup "Number of food groups individual consumed last week HDDS"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_household_diet.dta", replace
 
 
 
************
*WOMEN'S OWNERSHIP OF ASSETS
************
* Code as 1 if a woman is sole or joint owner of any specified productive asset; 
* can report on % of women who own, taking total number of women HH members as denominator
* MLW W2 asked to list up to 2 owners.
* Indicator may be biased downward if some women would have been not listed among the two the first 2 asset-owners can also claim ownership of some assets
*First, append all files with information on asset ownership
use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear //rainy
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta" //dry
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta"
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

* append who has right to sell or use
preserve
replace type_asset="landowners" if  !inlist( ag_d04_2a, .,0,99) |  !inlist( ag_d04_2b, .,0,99) 
replace asset_owner1=ag_d04_2a if !inlist( ag_d04_2a, .,0,99)  
replace asset_owner2=ag_d04_2b if !inlist( ag_d04_2b, .,0,99)

replace type_asset="landowners" if  !inlist( ag_k05_2a, .,0,99) |  !inlist( ag_k05_2b, .,0,99) 
replace asset_owner1=ag_k05_2a if !inlist( ag_k05_2a, .,0,99)  
replace asset_owner2=ag_k05_2b if !inlist( ag_k05_2b, .,0,99)
keep if !inlist( ag_d04_2a, .,0,99) |  !inlist( ag_d04_2b, .,0,99)   | !inlist( ag_k05_2a, .,0,99) |  !inlist( ag_k05_2b, .,0,99) 
keep y2_hhid type_asset asset_owner*
tempfile land2
save `land2'
restore
append using `land2'  

*non-poultry livestock (keeps/manages)
replace type_asset="livestockowners" if  !inlist( ag_r05a, .,0,99) |  !inlist( ag_r05b, .,0,99)  
replace asset_owner1=ag_r05a if !inlist( ag_r05a, .,0,99)  
replace asset_owner2=ag_r05b if !inlist( ag_r05b, .,0,99)
* non-farm equipment,  large durables/appliances, mobile phone
* SECTION M: FARM IMPLEMENTS, MACHINERY, AND STRUCTURES - does not report who in the household own them) 
* No ownership of non-farm equipment,  large durables/appliances, mobile phone
keep y2_hhid type_asset asset_owner1 asset_owner2  
preserve
keep y2_hhid type_asset asset_owner2
drop if asset_owner2==.
ren asset_owner2 asset_owner
tempfile asset_owner2
save `asset_owner2'
restore
keep y2_hhid type_asset asset_owner1
drop if asset_owner1==.
ren asset_owner1 asset_owner
append using `asset_owner2'
gen own_asset=1 
collapse (max) own_asset, by(y2_hhid asset_owner)
ren asset_owner personid
* Now merge with member characteristics
merge 1:1 y2_hhid personid  using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_person_ids.dta", nogen 
recode own_asset (.=0)
lab var own_asset "1=invidual owns an assets (land or livestock)"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_ownasset.dta", replace

********************************************************************************
*WOMEN'S PARTICIPATION IN AGRICULTURAL DECISION MAKING
********************************************************************************
*	Code as 1 if a woman is listed as one of the decision-makers for at least 2 plots, crops, or livestock activities; 
*	can report on % of women who make decisions, taking total number of women HH members as denominator
*	In most cases, TZA LSMS 4 lists the first TWO decision makers.
*	Indicator may be biased downward if some women would participate in decisions but are not listed among the first two
* first append all files related to agricultural activities with income in who participate in the decision making

use "${MLW_W2_raw_data}\Agriculture\ag_mod_d_13.dta", clear
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_k_13.dta" 
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_g_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_m_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_i_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_o_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_p_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_q_13.dta"
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_r1_13.dta"
gen type_decision="" 
gen decision_maker1=.
gen decision_maker2=.
gen decision_maker3=.
************
*WOMEN'S CONTROL OVER INCOME
************
*Code as 1 if a woman is listed as one of the decision-makers for at least 1 income-related area; 
*can report on % of women who make decisions, taking total number of women HH members as denominator
*In most cases, MW LSMS 2 lists the first TWO decision makers.
*Indicator may be biased downward if some women would participate in decisions about the use of income
*but are not listed among the first two
 
/*

** Decision-making areas
*	Control over crop production income
*	Control over livestock production income
*	Control over fish production income
*	Control over farm (all) production income
*	Control over wage income
*	Control over business income
*	Control over nonfarm (all) income
*	Control over (all) income
		
VAP: TZ-4 and MW-2 both also include 
	* Control over remittance income
	* Control over income from [program] assistance (social safety nets)

VAP: Added the following to the indicator construction for MW2
	* Control over other income (cash & in-kind transfers from individuals, pension, rental, asset sale, lottery, inheritance)	
*/

* First append all files with information on who control various types of income
* Control over Crop production income
use "${MLW_W2_raw_data}\Agriculture\ag_mod_i_13.dta", clear  // control over crop sale earnings rainy season
// append using "${MLW_W2_raw_data}\Agriculture\ag_mod_ba_13.dta" // control over crop sale earnings rainy season
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_o_13.dta" // control over crop sale earnings dry season
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_q_13.dta" // control over permanent crop sale earnings 
* Control over Livestock production income
append using "${MLW_W2_raw_data}\Agriculture\ag_mod_s_13.dta" // control over livestock product sale earnings
* Control over wage income
append using "${MLW_W2_raw_data}\Household\hh_mod_e_13.dta" // control over salary payment, allowances/gratuities, ganyu labor earnings 
* Control over business income
append using "${MLW_W2_raw_data}\Household\hh_mod_n2_13.dta" // household enterprise ownership
* Control over program assistance 
append using "${MLW_W2_raw_data}\Household\hh_mod_r_13.dta"
* Control over other income 
append using "${MLW_W2_raw_data}\Household\hh_mod_p_13.dta"
* Control over remittances
append using "${MLW_W2_raw_data}\Household\hh_mod_o_13.dta"


gen type_decision="" 
gen controller_income1=. 
gen controller_income2=.

// 
* control_annualsales
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
replace type_decision="control_annualsales" if  !inlist( ag_o23a, .,0,99) |  !inlist( ag_o23b, .,0,99) 
replace controller_income1=ag_o23a if !inlist( ag_o23a, .,0,99)  
replace controller_income2=ag_o23b if !inlist( ag_o23b, .,0,99)
keep if !inlist( ag_i23a, .,0,99) |  !inlist( ag_i23b, .,0,99)  | !inlist( ag_o23a, .,0,99) |  !inlist( ag_o23b, .,0,99) 
keep y2_hhid type_decision controller_income1 controller_income2
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

* livestock_sales (products) 
replace type_decision="control_livestocksales" if  !inlist( ag_s07a, .,0,99) |  !inlist( ag_s07b, .,0,99) 
replace controller_income1=ag_s07a if !inlist( ag_s07a, .,0,99)  
replace controller_income2=ag_s07b if !inlist( ag_s07b, .,0,99)


* Fish production income 
*No information available in MW2

* Business income 
* Malawi LSMS 2 did not ask directly about of who controls Business Income
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
keep y2_hhid type_decision controller_income1 controller_income2
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
keep y2_hhid type_decision controller_income1 controller_income2
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
keep y2_hhid type_decision controller_income1 controller_income2
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

keep y2_hhid type_decision controller_income1 controller_income2
 
preserve
keep y2_hhid type_decision controller_income2
drop if controller_income2==.
ren controller_income2 controller_income
tempfile controller_income2
save `controller_income2'
restore
keep y2_hhid type_decision controller_income1
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
																					
gen control_nonfarmincome=1 if  type_decision=="control_remittance" ///
							  | type_decision=="control_assistance" ///
							  | type_decision=="control_otherincome" /// VAP: additional in MW2
							  | control_salaryincome== 1 /// VAP: additional in MW2
							  | control_businessincome== 1 
recode 	control_nonfarmincome (.=0)
																		
collapse (max) control_* , by(y2_hhid controller_income )  //any decision
gen control_all_income=1 if  control_farmincome== 1 | control_nonfarmincome==1
recode 	control_all_income (.=0)															
ren controller_income personid
*	Now merge with member characteristics
merge 1:1 y2_hhid personid  using  "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_person_ids.dta", nogen keep (3) // 6,445  matched

recode control_* (.=0)
lab var control_cropincome "1=individual has control over crop income"
lab var control_livestockincome "1=individual has control over livestock income"
lab var control_farmincome "1=individual has control over farm (crop or livestock) income"
lab var control_businessincome "1=individual has control over business income"
lab var control_salaryincome "1= individual has control over salary income"
lab var control_nonfarmincome "1=individual has control over non-farm (business, salary, assistance, remittances or other income) income"
lab var control_all_income "1=individual has control over at least one type of income"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_control_income.dta", replace


********************************************************************************
*CONSUMPTION -- RH 7/14/21 complete - HI checked 5/2/22
******************************************************************************** 
use "${MLW_W2_raw_data}/ConsAggW2.dta", clear // RH - renamed dta file for consagg
ren rexpagg total_cons // using real consumption-adjusted for region price disparities -- household level
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hhsize)
gen daily_peraeq_cons = peraeq_cons/365 
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep y2_hhid total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq
save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_consumption.dta", replace

********************************************************************************
*HOUSEHOLD FOOD PROVISION* - RH 7/14/21 complete - HI checked 5/2/22
********************************************************************************
use "${MLW_W2_raw_data}\Household\HH_MOD_H_10.dta", clear

forvalues k=1/10 {
	local j : display %02.0f `k' // to account for leading zero
	gen food_insecurity_`k' = (hh_h05a_`j' == "X")
}
forvalues k=1/15 {
	local j : display %02.0f `k'
	local i = `k' + 10 //to continue list from a to b variable
	gen food_insecurity_`i' = (hh_h05b_`j' == "X")
}

egen months_food_insec = rowtotal(food_insecurity_*) 
* replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep HHID months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${MLW_W2_created_data}/Malawi_IHS_LSMS_ISA_W2_food_insecurity.dta", replace


***************************************************************************
*HOUSEHOLD ASSETS* - VAP complete, RH checked
***************************************************************************
use "${MLW_W2_raw_data}\Household\hh_mod_l_13.dta", clear
*ren hh_m03 price_purch  // VAP: purchse price not available in MW2s
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items

collapse (sum) value_assets=value_today, by(y2_hhid)
la var value_assets "Value of household assets"
save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_assets.dta", replace 

