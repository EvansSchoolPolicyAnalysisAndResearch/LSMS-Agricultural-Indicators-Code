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

***************
*HOUSEHOLD IDS*
***************
use "${UGS_W3_raw_data}/GSEC1.dta", clear
ren h1aq1 district
ren h1aq2 county
ren h1aq3 subcounty 
ren h1aq4 parish
ren comm ea
ren mult weight
//regurb // regionXurbanXrural
gen rural=urban==0
keep region district county subcounty parish ea HHID rural regurb weight // excludes stratum Q. Don't have break down on county and county name, parish and parish name
lab var rural "1 = Household lives in rural area"

//destring HHID, replace //EFW 6.4.19 need to do this so we can merge in crop revenue section
//ALT 10.25.19: Keeping this as a string because destringing causes information loss.

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", replace


****************
*INDIVIDUAL IDS*
****************
use "${UGS_W3_raw_data}/GSEC2.dta", clear
gen female=h2q3==2 // sex=h2q3==2 is female
lab var female "1= indivdual is female"
gen age=h2q8
lab var age "Individual age"
gen hh_head=h2q4==1 // relationship to hh head
lab var hh_head "1= individual is household head"

//ALT 10.25.19 - Keeping as strings and converting doubles later
//EFW 6.5.19 Need to destring HHID & PID since merging in later with variables where they are doubles
//EFW 6.5.19 No duplicates before we destring, 36 duplicates after. What problems does this create for our data???
//destring HHID, replace
//destring PID, replace
//duplicates drop HHID PID, force //EFW 6.5.19
keep HHID PID female age hh_head

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", replace



****************
*HOUSEHOLD SIZE*
****************
use "${UGS_W3_raw_data}/GSEC2.dta", clear
gen hh_members = 1
ren h2q4 relhead //relationship to HH head
ren h2q3 gender // sex
gen fhh = (relhead==1 & gender==2) // EFW changed this to relhead==1. We want just the households where the head is listed as a female, even if this is a small number
collapse (sum) hh_members (max) fhh, by (HHID)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
//destring HHID, replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhsize.dta", replace


 
************
*PLOT AREAS* 
************
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
//EFW 4.17.19 in both files the variable is named parcelID, so we just need to rename it
ren parcelID parcel_id // renamed from plot_ID to parcel_ID

gen area_acres_est = a2aq5 //farmer estimation
replace area_acres_est = a2bq5 if area_acres_est == . 
gen area_acres_meas = a2aq4 // size of parcel in acre - GPS
replace area_acres_meas = a2bq4 if area_acres_meas == .
*keep if area_acres_est !=. // keep if estimation not missing //EFW 4.17.19 I commented this out in my file and replaced it with below. I think the line below makes more sense
drop if area_acres_est==. & area_acres_meas==. //both estimation and measurement missing 

keep HHID parcel_id area_acres_est area_acres_meas //removed plot_ID
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", replace

************************
*PLOT DECISION MAKERS
************************
use "${UGS_W3_raw_data}/GSEC2.dta", clear
ren PID personid			
gen female =h2q3==2
ren h2q8 age
gen head = h2q4==1 if h2q4!=. // Q. should I keep relhead or hh_head? I have one underlying variable 5/8/19
keep personid female age HHID head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
/*destring HHID personid, replace //EFW 4.17.19 add this so that we can merge below //ALT: Bad plan because this loses info. Converting to string downstream.
sort HHID personid
quietly by HHID personid: gen dup = cond(_N==1,0,_n)
drop if dup>1 //76 observations deleted
drop dup
*duplicates drop HHID personid, force // Q.delete? // 20190407 SAK  - dropping duplicates created by the destringing
*/
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", replace

//EFW 4.17.19 Changing this section below. We need section 3A & 3B for plant decision maker, but this doesn't include information on whether the plot is cultivated.
//However, it doesn't seem like we ever use the "cultivated" variable we generate here (we generate it elsewhere and use that). So I suggest we don't gen cultivated here which makes this section a lot more straightforward
//I've commented out the other code and made these changes for now, but we should discuss (perhaps with Dave and Isabella) to make sure this makes sense.

/*/ALT 10.28.19: Experimented with replacing Sec3a/3b (plot inputs) with Sec 2a. Did not help.
use "${UGS_W3_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
*ren plotID plot_id
*ren parcelID parcel_id // using parcel ID 
*drop if plot_id == . 
tempfile plot_inputs
save `plot_inputs', replace

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
merge 1:m HHID parcelID using `plot_inputs'
ren plotID plot_id
ren parcelID parcel_id
*/

use "${UGS_W3_raw_data}/AGSEC3A.dta", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B.dta"
replace season = 2 if season == .
ren plotID plot_id
ren parcelID parcel_id // using parcel ID 
drop if plot_id == . 

*Gender/age variables // Double check section
/*gen double personid = a3aq3_3 // DMC code // who was the primary decision maker during the first cropping?
replace personid = a3bq3_3 if personid==. // who was the primary decision maker during the second cropping? //EFW 5.21.19 zero observations where (a3aq3_3!=. & a3aq3_4a!=.) so include both as person 1 //ALT: Leaving these as strings*/

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
collapse (max) dm1_female dm2_female dm3_female, by (HHID parcel_id plot_id)

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

**************
*AREA PLANTED*
**************
use "${UGS_W3_raw_data}/AGSEC4A", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season = 2 if season == .
ren cropID cropcode
ren parcelID parcel_id
ren plotID plot_id

// check variable for cultivated
gen plot_ha_planted = a4aq7*(1/2.47105)
replace plot_ha_planted = a4bq7*(1/2.47105) if plot_ha_planted==.

duplicates list HHID parcel_id plot_id season cropcode //30 duplicates
duplicates drop HHID parcel_id plot_id season cropcode, force //19 observations deleted //EFW 4.18.19 all season 1 observations don't have ha_planted information, unclear which season 2 observations more correct, so just dropping randomly

*keep HHID parcel_id plot_id season cropcode ha_planted //EFW 6.2.19 commenting this out because need intercropping variable for code below. Add back in before saving

//EFW 5.22.19 add in additional code here per Didier code (factor in intercropping)
merge m:1 parcel_id HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta", nogen keep(1 3)			
*Adjust for inter-croppinp
gen per_intercropped=a4aq9 
replace per_intercropped=a4bq9 if per_intercropped==.  // ta a4bq9  - no obs. No intercropping in second season/visit? 
*replace  per_intercropped=50 if per_intercropped==500 // this is clearly a typo and I am guessing the value is  50% //EFW 6.2.19 In Didier's code, but not in our file. Because of the duplicates we dropped?? Explore further
replace per_intercropped=per_intercropped/100
recode per_intercropped (0=.) //EFW 6.2.19 0 changes made
gen  is_plot_intercropped=a4aq8==2 | a4bq8==2
replace is_plot_intercropped=1 if per_intercropped!=.  // 11 changes //EFW 6.2.19 0 changes in this code. Why 11 in Didier code??
*Scale down percentage
bys  HHID parcel_id plot_id   : egen total_percent_planted = total(per_intercropped)		if 	is_plot_intercropped==1 
replace plot_ha_planted=plot_ha_planted if is_plot_intercropped==0
replace plot_ha_planted=plot_ha_planted*(per_intercropped/total_percent_planted) if is_plot_intercropped==1 
*Now sum area planted for sub-plots should not exceed field size. If so rescal proportionally including for monocrops
bys  HHID parcel_id  : egen total_ha_planted = total(plot_ha_planted)
replace plot_ha_planted=plot_ha_planted*(area_meas_hectares/total_ha_planted) if  	total_ha_planted>area_meas_hectares & total_ha_planted!=.
gen  ha_planted=plot_ha_planted 
/*
//EFW 6.2.19 commenting out this part of Didier code since we want this at the plot level, not the HH level right now (using in monocropped code)
recode ha_planted (.=0)
collapse  (sum) ha_planted, by(hhid)
save "${UGA_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ha_planted.dta", replace
*/
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_area_planted_temp.dta", replace

//EFW END
//ALT 10.25.19 - No major changes to this section

************************
*MONOCROPPED PLOTS
************************

// 12 priority crops
* maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana

///TOP 10 CROPS by area planted across all 4 waves //
*macro list topcropname_area
/*				In 12?
Maize				*					
Beans				*
Paddy				*
Groundnut			*
Sorghum				*
Sweet Potatos		*
Cotton				
Sunflower			
Cowpeas				*	
Pigeon pea			
*/ 

//// Can change the reported crops here. Limit crop names in variables to 6 characters or the variable names will be too long! 
//EFW 4.18.19 removing wheat because there is only 1 observation, which will create problems further in the code (also update the number we loop through)
global topcropname_area "maize rice sorgum pmill cowpea grdnt beans yam swtptt cassav banana" //EFW 4.18.19 millet is "finger millet"; "banana food" included, but not "banana beer" and "banana sweet" similar to other waves
global topcrop_area "130 120 150 141 222 310 210 640 620 630 741" //EFW 4.18.19 updated these based on the crop codes (see "cropID" variable; labelbook cropID)
global comma_topcrop_area "130, 120, 150, 141, 222, 310, 210, 640, 620, 630, 741"


*Generating area harvested and kilograms harvested
forvalues k=1(1)11 {
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${UGS_W3_raw_data}/AGSEC5A", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC5B"
replace season = 2 if season == .

ren parcelID parcel_id 
drop if parcel_id==.
ren plotID plot_id

//ren a5aq5 cropcode // no cropcode in the dataset
//replace cropcode = a5bq5 if cropcode==. & a5bq5!=.

//EFW 4.18.19 rename cropID
ren cropID cropcode

ren a5aq6d conversion
replace conversion = a5bq6d if conversion==. & a5bq6d!=.
ren a5aq6a qty_harvest
replace qty_harvest = a5bq6a if qty_harvest==. & a5bq6a!=. // Sec 5A and 5B

gen kgs_harv_mono_`cn' = qty_harvest*conversion if cropcode==`c'

collapse (sum) kgs_harv_mono_`cn', by(HHID parcel_id plot_id cropcode season)

*merge in area planted
merge 1:1 HHID parcel_id plot_id cropcode season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_area_planted_temp.dta" //ALT 10.28.19: ~500 not merged from master. Reporting errors?

xi i.cropcode, noomit
collapse (sum) kgs_harv_mono_`cn' (max) _Icropcode_*, by(HHID parcel_id plot_id season ha_planted) //EFW 1.31.19 collapse to parcel level because this is the only level of observation included in wave 4???
egen crop_count = rowtotal(_Icropcode_*)
keep if crop_count==1 & _Icropcode_`c'==1
*duplicates report HHID parcel_id
collapse (sum) kgs_harv_mono_`cn' ha_planted (max) _Icropcode_*, by(HHID parcel_id plot_id season) //EFW 6.2.19 changing this to still include season since need season to uniquely identify gender of plot manager

gen `cn'_monocrop_ha=ha_planted
drop if `cn'_monocrop_ha==0 									 
gen `cn'_monocrop=1
tostring HHID, format(%18.0f) replace //Converting to strings now to keep it from having to happen later
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", replace
}

/*//ALT TEST AREA


use "${UGS_W3_raw_data}/AGSEC5A", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC5B"
replace season = 2 if season == .

ren parcelID parcel_id 
drop if parcel_id==.
ren plotID plot_id

//ren a5aq5 cropcode // no cropcode in the dataset
//replace cropcode = a5bq5 if cropcode==. & a5bq5!=.

//EFW 4.18.19 rename cropID
ren cropID cropcode

ren a5aq6d conversion
replace conversion = a5bq6d if conversion==. & a5bq6d!=.
ren a5aq6a qty_harvest
replace qty_harvest = a5bq6a if qty_harvest==. & a5bq6a!=. // Sec 5A and 5B

gen kgs_harv_mono_maize = qty_harvest*conversion if cropcode==130

collapse (sum) kgs_harv_mono_maize, by(HHID parcel_id plot_id cropcode season)

*merge in area planted
merge 1:1 HHID parcel_id plot_id cropcode season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_area_planted_temp.dta" //ALT 10.28.19: ~500 not merged from master. Reporting errors?

xi i.cropcode, noomit
collapse (sum) kgs_harv_mono_maize (max) _Icropcode_*, by(HHID parcel_id plot_id season ha_planted) //EFW 1.31.19 collapse to parcel level because this is the only level of observation included in wave 4???
egen crop_count = rowtotal(_Icropcode_*)
keep if crop_count==1 & _Icropcode_130==1
*duplicates report HHID parcel_id
collapse (sum) kgs_harv_mono_maize ha_planted (max) _Icropcode_*, by(HHID parcel_id plot_id season) //EFW 6.2.19 changing this to still include season since need season to uniquely identify gender of plot manager

gen maize_monocrop_ha=ha_planted
drop if maize_monocrop_ha==0 									 
gen maize_monocrop=1
tostring HHID, format(%18.0f) replace //Converting to strings now to keep it from having to happen later
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", replace


///END ALT TEST AREA
*/


//ALT 10.29.19: No major changes


*Adding in gender of plot manager

forvalues k=1(1)11 {
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", clear
merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta" //0 not matched from master!

foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' { 
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
	replace `i'_male = . if dm_gender!=1
	replace `i'_female = . if dm_gender!=2
	replace `i'_mixed = . if dm_gender!=3
}

gen `cn'_monocrop_male = 0 
replace `cn'_monocrop_male=1 if dm_gender==1
gen `cn'_monocrop_female = 0 
replace `cn'_monocrop_female=1 if dm_gender==2
gen `cn'_monocrop_mixed = 0 
replace `cn'_monocrop_mixed=1 if dm_gender==3


*And now this code will indicate whether the HOUSEHOLD has at least one of these plots and the total area of monocropped maize plots
collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed `cn'_monocrop = _Icropcode_`c', by(HHID) 

foreach i in male female mixed {
	replace `cn'_monocrop_ha = . if `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if  `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_`i'==0
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_ha_`i'==0
	replace kgs_harv_mono_`cn' = . if `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if  `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_`i'==0 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_ha_`i'==0 
}

tostring HHID, format(%18.0f) replace
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop_hh_area.dta", replace

}

//ALT 12/2/19: As far as I can tell, this works okay. About 500 out of 20,000 records are orphaned.

************************
*TLU (Tropical Livestock Units) //recheck
************************
//EFW 6.2.19 Replaced with Didier code
use "${UGS_W3_raw_data}/AGSEC6A", clear 
ren lvstid  lvstckid
ren a6aq3a nb_ls_today
ren a6aq6 nb_ls_stardseas
keep HHID lvstckid nb_ls_today nb_ls_stardseas //ALT 12/2/19: What is this?
tempfile livestock_largerum
save `livestock_largerum'

use "${UGS_W3_raw_data}/AGSEC6B", clear
ren lvstid  lvstckid
ren a6bq3a nb_ls_today
ren a6bq6 nb_ls_stardseas
keep HHID   lvstckid nb_ls_today nb_ls_stardseas
destring lvstckid , replace
tempfile livestock_smallrum
save `livestock_smallrum'

use "${UGS_W3_raw_data}/AGSEC6C", clear
ren lvstid  lvstckid
ren a6cq3a nb_ls_today
ren a6cq6 nb_ls_stardseas
keep HHID   lvstckid nb_ls_today nb_ls_stardseas
destring lvstckid , replace
tempfile livestock_poultry
save `livestock_poultry'

use `livestock_largerum', clear
append using `livestock_smallrum'
append using `livestock_poultry'
//ALT 10.28.19: Coefficients were 0.5, 0.55, 0.55, 0.2, 0.55. Replaced with coefficients from TZ: Bovines - 0.5, Goats/sheep - 0.1, Pigs - 0.2, Poultry/rabbits - 0.01, Donkeys - 0.3.
gen tlu_coefficient =  0.5 if inlist(lvstckid,1,2,3,4,5,6,7,8,9,10) //Bulls and oxen, calves, heifer and cows
replace tlu_coefficient=0.3 if inlist(lvstckid,11,12) //Mules/horses
replace tlu_coefficient=0.1 if inrange(lvstckid,13,16) | inrange(lvstckid,18,21) //Exotic/native female & male goats & sheep
replace tlu_coefficient = 0.2 if lvstckid==22 | lvstckid==17 //native/exotic pigs
replace tlu_coefficient=0.01 if inrange(lvstckid,23,27) // rabbit, poultry, and others //ALT 10.28.19: Omitting beehives b/c not used in TZ
lab var tlu_coefficient "Tropical Livestock Unit coefficient"
keep HHID lvstckid tlu_coefficient
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU_Coefficients.dta", replace 

/*//CJS Notes 10.10.2019
use "${UGS_W3_raw_data}/AGSEC6A", clear
ren lvstif lv  */ //ALT: What is this for?


********************************************************************************
*ALL PLOTS
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
************************
*CROP VALUES
************************
/*
use "${UGS_W3_raw_data}/AGSEC6A", clear 
append using "${UGS_W3_raw_data}/AGSEC5B"














	use "${Uganda_NPS_W5_raw_data}/AGSEC5A.dta", clear
	append using "${Uganda_NPS_W5_raw_data}/AGSEC5B.dta"
	rename a5aq7a sold_qty
	gen season = 1 if sold_qty != .
	ren a5aq6c unit_code 
	replace unit_code = a5bq6c if unit_code == .
	replace sold_qty = a5bq7a if sold_qty == .
	replace season = 2 if season == . & a5bq7a != .
	rename a5aq7c sold_unit_code
	replace sold_unit_code = a5bq7c if sold_unit_code == .
	rename a5aq8 sold_value
	replace sold_value = a5bq8 if sold_value == .
	merge m:m HHID using "${Uganda_NPS_W5_raw_data}/AGSEC1.dta", nogen keepusing(region district scounty_code parish_code ea region)
	rename HHID hhid
	rename plotID plot_id
	rename parcelID parcel_id
	rename cropID crop_code
	save "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_crop_value.dta", replace
	keep hhid parcel_id plot_id crop_code unit_code sold_unit_code sold_qty sold_value district scounty_code parish_code ea region
	merge m:1 hhid using "${Uganda_NPS_W5_created_data}/Uganda_NPS_W5_hhids.dta", nogen keepusing(weight)
	gen price_unit = sold_value / sold_qty //since value is total, dividing by quantity gives avg unit price
	label var price_unit "Average sold value per crop unit"
	gen obs = price_unit != .
*/
************************
*GROSS CROP REVENUE
************************
*Temporary crops (both seasons)
use "${UGS_W3_raw_data}/AGSEC5A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC5B.dta"

rename parcelID parcel_id
rename plotID plot_id

//EFW 6.2.19 Don't need to destring this or create a new variable that is crop_name; cropID includes both name and number so just need to rename crop_ID
/*
gen crop_code = cropID
destring cropID cropID, replace
tab crop_code

rename cropID crop_name
*/
ren cropID crop_code //EFW 6.4.19 change to crop_code since that's what we use later on

drop if plot_id == . 
//61 deleted

//EFW 6.2.19 Stopped Here; check DYA code
rename a5aq6a qty_harvest 
replace qty_harvest = a5bq6a if qty_harvest==. 
//& a5bq7a!=. this is asking about quantity sold not harvested
rename a5aq6d conversion
replace conversion = a5bq6d if conversion==. & a5bq6d!=.

gen kgs_harvest = qty_harvest * conversion

ren a5aq7a qty_sold 
replace qty_sold = a5bq7a if qty_sold==. & a5bq7a!=. 
*ren a5aq7c unit_sold //EFW 6.4.19 Don't really need this since we have a conversion factor
*replace unit_sold = a5bq7c if unit_sold==. & a5bq7c!=.  //EFW 6.4.19 don't really need this since we have a conversion factor
//condition sold missing in the raw data

//EFW 6.4.19 You don't need to do this in your section because they provide a separate conversion factor for quantity sold (A5AQ7D) 
/*
*rename condition and unit of harvest for comparison & conversion below
ren a5aq6b condition_harv
replace condition_harv = a5bq6b
ren a5aq6c unit_harv
replace unit_harv = a5bq6c
*/
*Calculate kgs sold 
ren A5AQ7D conversion_sold
replace conversion_sold = A5BQ7D if conversion_sold == . //EFW 6.4.19
gen kgs_sold = qty_sold * conversion_sold

//EFW 6.4.19 Don't need to do this (see note above)
/*
count if (condition_harv==. & unit_harv ==. & conversion!=.) & (kgs_sold == . & (qty_sold !=0 & qty_sold !=.)) 
//15

*Assume unit & condition sold same as harvest if harvest condition & unit missing 
replace kgs_sold = qty_sold * conversion if condition_harv==. & unit_harv ==. & conversion!=. & qty_sold!=0 & qty_sold!=. & kgs_sold==.
//15 changes made

count if kgs_sold == . & (qty_sold !=0 & qty_sold !=.) //4212 observations
replace kgs_sold = qty_sold * conversion if unit_sold==unit_harv & kgs_sold==. //5361 changes made
count if kgs_sold == . & (qty_sold !=0 & qty_sold !=.) //4212 observations
*/
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

//EFW 6.4.19 Don't need to do this. It's ok that one variable has both the code and name (this is actually preferable)
/*
destring cropID 
gen crop_code = cropID // we don't have a seperate variable for cropcodes, but if remove labels for cropID we seem them!
destring cropID cropID, replace
tab crop_code
*/

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


//ALT 10.28.19 - only change in above section was making sure HHID stayed as a string throughout

************************
*CROP EXPENSES
************************ 
//ALT 10.28.19: Trying to do main season only when all of the previous files have both seasons is a nightmare from a merging/code checking standpoint.
//I'm going to do main season and off season in the same block and just save as separate files.
//The issue I'm repeatedly having here is that we go back and forth between 3A/3B for some files and 5A/5B for others, and the overlap there isn't perfect

use "${UGS_W3_raw_data}/AGSEC3A", clear //This file has data for first season of 2011 AGSEC3B has data for second
gen season=1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season=2 if season==.
*rename parcel, plot ids
rename parcelID parcel_id
rename plotID plot_id
tostring HHID, format(%18.0f) replace

*Expenses: Hired labor
gen wages = a3aq36
replace wages = a3bq36 if a3aq36==.
recode wages (.=0)

keep HHID parcel_id plot_id season wages
duplicates drop HHID parcel_id plot_id season wages, force //drops 3 dups w/ 0 wage values. 

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_all_temp.dta", replace

preserve
keep if season==1
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_mainseason_temp.dta", replace
restore

preserve
keep if season==2
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_secondseason_temp.dta", replace
restore

use "${UGS_W3_raw_data}/AGSEC5A", clear
gen season=1
append using "${UGS_W3_raw_data}/AGSEC5B"
replace season=2 if season==.
tostring HHID, format(%18.0f) replace
rename parcelID parcel_id
rename plotID plot_id
drop if plot_id==.

merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_all_temp.dta", nogen keep(3) //857 results not matched from using. May be a result of parcel/plot coding errors.

/*//ALT TEST AREA
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta" 
	//, nogen keep(3) //EFW 6.5.19 add plot_id since needed to uniquely identify
	foreach i in wages {
	gen `i'_maize = `i'
	gen `i'_maize_male = `i' if dm_gender==1 
	gen `i'_maize_female = `i' if dm_gender==2 
	gen `i'_maize_mixed = `i' if dm_gender==3 
	}
	
	*merge in monocropped plots
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_maize_monocrop.dta", nogen keep(3) //33 orphaned records for some reason.
	keep if season==1
	collapse (sum) wages_maize*, by(HHID)
	lab var wages_maize "Wages for hired labor in main growing season - Monocropped maize plots"
	foreach g in male female mixed {
		lab var wages_maize_`g' "Wages for hired labor in main growing season - Monocropped `g' maize plots"
	}
	
	

//END ALT TEST AREA */


*Monocropped plots
foreach cn in $topcropname_area {
preserve
	display "`cn'"
	//gen season = 1
	keep if season == 1
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta", nogen keep(3) //EFW 6.5.19 add plot_id since needed to uniquely identify
	ren wages wages_paid_main
	foreach i in wages_paid_main {
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	
	*merge in monocropped plots
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen keep(3) //ALT: A few are not matched from using every time, probably due 3A/3B - 5A/5B conflicts
	
	//EFW 6.5.19 add plot_id since needed to uniquely identify
	collapse (sum) wages_paid_main_`cn'*, by(HHID)
	lab var wages_paid_main_`cn' "Wages for hired labor in main growing season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_main_`cn'_`g' "Wages for hired labor in main growing season - Monocropped `g' `cn' plots"
	}
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_mainseason_`cn'.dta", replace
	
restore
}

preserve
keep if season==1
ren wages wages_paid_main
collapse(sum) wages_paid_main, by(HHID) 
lab var wages  "Wages paid for hired labor (crops) in main growing season"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_mainseason.dta", replace
restore

/*//ALT 12.03.19: Commenting out this chunk because we shouldn't need to reload all of the data. Wages_paid_short is wages if season==2
use "${UGS_W3_raw_data}/AGSEC3B", clear
*rename parcel, plot ids
rename parcelID parcel_id
rename plotID plot_id

*Expenses: Hired labor
rename a3bq36 wages_paid_short //How do we know that the first season is the short season?

//EFW 6.5.19
*Drop duplicates
duplicates drop HHID parcel_id plot_id, force 
//EFW END
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_shortseason_temp.dta", replace

use "${UGS_W3_raw_data}/AGSEC5B", clear
rename parcelID parcel_id
rename plotID plot_id

merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_shortseason_temp.dta", nogen
*/
//ALT 12.03.19: Renaming "short season" as "second season" to keep things consistent with the code above.
*Monocropped plots
foreach cn in $topcropname_area {
preserve
	//gen season = 2
	keep if season==2
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta"
	ren wages wages_paid_second
	foreach i in wages_paid_second {
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
	
	*merge in monocropped plots
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen keep(3)
	
	collapse (sum) wages_paid_second_`cn'*, by(HHID)
	lab var wages_paid_second_`cn' "Wages for hired labor in second growing season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_second_`cn'_`g' "Wages for hired labor in second growing season - Monocropped `g' `cn' plots"
	}
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_secondseason_`cn'.dta", replace
	
restore
}

preserve
keep if season==2
ren wages wages_paid_second
collapse (sum) wages_paid_second, by (HHID)
lab var wages "Wages paid for hired labor (crops) in second growing season"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_secondseason.dta", replace
restore


//ALT 12.03.19: Calling this section done because I don't think the merge conflicts are fixable.

*Formalized Land Rights
use "${UGS_W3_raw_data}/AGSEC2A", clear 
* Section 2b does include question on formal certificate or title. 

gen formal_land_rights = a2aq23!=4 //excluding no document

*individual level (for women)
*starting with the first owner
//EFW 6.5.19 changing individ to PID since that is what variable is called in person_ids.dta
//ALT 12.03.19: changing PID/HHID to string from double.
preserve
	tostring a2aq24a, format(%18.0f) gen(PID) //EFW 6.5.19
	tostring HHID, format(%18.0f) replace
	merge m:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen keep(3) //107 not matched from master
	keep HHID PID female formal_land_rights
	tempfile p1
	save `p1', replace
restore

*Now second owner
preserve
    tostring a2aq24a, format(%18.0f) gen(PID) //EFW 6.5.19
	tostring HHID, format(%18.0f) replace
	merge m:1 HHID PID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", nogen keep(3)
	keep HHID PID female
	append using `p1'
	gen formal_land_rights_f = formal_land_rights==1 & female==1
	collapse(max) formal_land_rights_f, by(HHID PID)
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_ind.dta", replace
restore

collapse (max) formal_land_rights_hh = formal_land_rights, by(HHID)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rights_hh.dta", replace


*Expenses: Inputs
use "${UGS_W3_raw_data}/AGSEC3A", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC3B"
replace season = 2 if season == .
tostring HHID, format(%18.0f) replace

ren parcelID parcel_id
ren plotID plot_id

//EFW 6.5.19 This should be inorganic fertilizer (not organic). Updated the code below.
gen value_fertilizer = a3aq18 //value of fertilizer purchased //EFW 6.5.19
replace value_fertilizer = a3bq18 if value_fertilizer == . //EFW 6.5.19

gen value_pesticide = a3aq27
replace value_pesticide = a3bq27 if value_pesticide == . //value of pesticide purchased

recode value_fertilizer value_pesticide (.=0) 

*Monocropped plots //EFW 6.5.19 adding plot_id in the merges below since needed to uniquely identify
foreach cn in $topcropname_area {					
preserve
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta" 
	*merge in monocropped plots
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen keep(3) //6 not matched from master
	foreach i in value_fertilizer value_pesticide {
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1
	gen `i'_`cn'_female = `i' if dm_gender==2
	gen `i'_`cn'_mixed = `i' if dm_gender==3
}
	collapse(sum) value_fertilizer_`cn'* value_pesticide_`cn'*, by(HHID)
	lab var value_fertilizer_`cn' "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	lab var value_pesticide_`cn' "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons - Monocropped `cn' plots only"
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fertilizer_costs_`cn'.dta", replace
restore
}

collapse (sum) value_fertilizer value_pesticide, by (HHID) 
lab var value_fertilizer "Value of fertilizer purchased (not necessarily the same as used) in main and short growing seasons" 
lab var value_pesticide "Value of pesticide purchased (not necessarily the same as used) in main and short growing seasons"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fertilizer_costs.dta", replace

*Seed
use "${UGS_W3_raw_data}/AGSEC4A", clear
gen season = 1
append using "${UGS_W3_raw_data}/AGSEC4B"
replace season = 2 if season ==.
tostring HHID, format(%18.0f) replace

ren parcelID parcel_id
ren plotID plot_id

gen cost_seed = a4aq15
replace cost_seed = a4bq15 if cost_seed==. 
recode cost_seed (.=0)

*Monocropped plots
foreach cn in $topcropname_area {
preserve 
	*disaggregate by gender of plot manager
	merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta" 
	gen cost_seed_male=cost_seed if dm_gender==1
	gen cost_seed_female=cost_seed if dm_gender==2
	gen cost_seed_mixed=cost_seed if dm_gender==3
	*merge in monocropped plots
	merge m:1 HHID parcel_id plot_id season using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen assert(1 3) keep(3)
	collapse (sum) cost_seed_`cn' = cost_seed cost_seed_`cn'_male = cost_seed_male cost_seed_`cn'_female = cost_seed_female cost_seed_`cn'_mixed = cost_seed_mixed, by(HHID)		// renaming all to "_`cn'" suffix
	lab var cost_seed_`cn' "Expenditures on seed for temporary crops - Monocropped `cn' plots only"
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_seed_costs_`cn'.dta", replace
restore
}

collapse(sum) cost_seed, by(HHID)
lab var cost_seed "Expenditures on seed for temporary crops"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_seed_costs.dta", replace


*Land rental
use "${UGS_W3_raw_data}/AGSEC2B", clear //"land that hh has use rights to" section
tostring HHID, format(%18.0f) replace

*rename parcel ID (no plot id in this section)
ren parcelID parcel_id
 
gen rental_cost_land = a2bq9 //how much rent did you or will you pay during the two cropping seasons?
recode rental_cost_land (.=0)

//EFW 6.5.19 modified merges slightly (added plot_id to second merge and changed first to 1:m)
*Monocropped plots
foreach cn in $topcropname_area {
preserve
	*disaggregate by gender of plot manager
	merge 1:m HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta" 
	*merge in monocropped plots
	merge 1:m HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_`cn'_monocrop.dta", nogen keep(3) //ALT: 39 from master not matched
	gen rental_cost_land_`cn'=rental_cost_land
	gen rental_cost_land_`cn'_male=rental_cost_land if dm_gender==1
	gen rental_cost_land_`cn'_female=rental_cost_land if dm_gender==2
	gen rental_cost_land_`cn'_mixed=rental_cost_land if dm_gender==3
	collapse(sum) rental_cost_land_`cn'* , by(HHID)	
	lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rental_costs_`cn'.dta", replace
restore
}

collapse(sum) rental_cost_land, by (HHID)
lab var rental_cost_land "Rental costs paid for land"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rental_costs.dta", replace

*Rental of agricultural tools, machines, animal traction
use "${UGS_W3_raw_data}/AGSEC10.dta", clear
tostring HHID, format(%18.0f) replace
ren itmcd itemid
gen animal_traction = (itemid==14 | itemid==23)
//EFW START
*gen ag_asset = (/*itemid==1 | */itemid=<5 | itemid>=7 & =<13 | itemid=>15 | itemid== | itemid== | itemid== | 
gen ag_asset = itemid<6 | (itemid >6 & itemid<=13) | (itemid >=15 & itemid <= 22)
gen tractor = /*(itemid==2 | */ itemid==6 /*| itemid==16)*/
//EFW END

rename a10q8 rental_cost //How much did your household pay to rent or borrow [ITEM] during the last 12 months?

gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1

recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (HHID)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items"
lab var rental_cost_tractor "Costs for renting a tractor"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_asset_rental_costs.dta", replace


*Transport costs for crop sales
use "${UGS_W3_raw_data}/AGSEC5A", clear
append using "${UGS_W3_raw_data}/AGSEC5B"

tostring HHID, format(%18.0f) replace

rename a5aq10 transport_costs_cropsales
replace transport_costs_cropsales = a5bq10 if transport_costs_cropsales==.
recode transport_costs_cropsales (.=0) //NH what does this code do? //EFW 6.5.19 If there is a missing value before a collapse it makes everything collapsed to the higher level missing, so we recode to zero when summing

collapse(sum) transport_costs_cropsales, by(HHID)
lab var transport_costs_cropsales "Expenditures on transportation for crop sales of temporary crops"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_transportation_cropsales.dta", replace

*Crop costs
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rental_costs.dta", clear
tostring HHID, format(%18.0f) replace
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_seed_costs.dta", nogen
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fertilizer_costs.dta", nogen
//merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_shortseason.dta", nogen
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_mainseason.dta", nogen
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wages_secondseason.dta", nogen
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_asset_rental_costs.dta", nogen
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_transportation_cropsales.dta",nogen
recode rental_cost_land cost_seed value_fertilizer  /*

*/ value_pesticide wages_paid_second wages_paid_main transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_land cost_seed value_fertilizer /*
*/ value_pesticide wages_paid_second wages_paid_main transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crop_income.dta", replace //why are we saving this as crop income and not expenses? //EFW 6.5.19 It incorporates both costs and expenses in this last chunk of code


//ALT 12.03.19: see section header for changes. 
//KEF 01.08.21: start point for editing. 
************
*LIVESTOCK INCOME
************
*Expenses
use "${UGS_W3_raw_data}/AGSEC7A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC7B.dta"
ren a7bq2e cost_fodder_livestock  
ren a7bq3f cost_water_livestock
ren a7bq5d cost_vaccines_livestock /* Includes vaccine and professional fees */
//rename a7bq6c cost_deworming_livestock /* Includes cost of deworming and professional fees. Not included in 335/TNZ but included in W3. Should include?*/
/*Not included a7bq7c What was the total cost of the treatment of [...] against ticks, including cost of drugs and professional fee?*/
ren a7bq8c cost_hired_labor_livestock /* Includes cost of drugs and professional fee */
recode cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock (.=0)
tostring HHID, format(%18.0f) replace // KEF 01.08.21 What's happening here?//


*Livestock expenses for large ruminants // KEF: Added these titles for clarity. //
preserve 
rename AGroup_ID lvstckcat // KEF: Why doesn't this seem to do anything? //
keep if lvstckcat == 101 | lvstckcat == 105 /* These are both Large Ruminants; Exotic/Cross and Indigenous are separate variables in W3. */
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock, by (HHID)
egen cost_lrum = rowtotal (cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock)
keep HHID cost_lrum
la var cost_lrum "Livestock expenses for large ruminants"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses.dta", replace
restore 


*Vaccine expenses by livestock type
preserve 
	ren AGroup_ID livestock_code //ALT: Why do we use different names for this? KEF: agreed? //
	gen species = (inlist(livestock_code,101,105)) + 2*(inlist(livestock_code,102,106)) + 3*(inlist(livestock_code,103,107)) + 4*(inlist(livestock_code,104,108)) 
	recode species (0=.)
	la def species 1 "Large ruminants (Exotic/Cross, Indigenous)" 2 "Small ruminants (Exotic/Cross, Indigenous)" 3 "Poultry (Exotic/Cross, Indigenous)" 4 "Pigs(Exotic/Cross, Indigenous)"
	la val species species 

	collapse (sum) cost_vaccines_livestock, by (HHID species) 
	rename cost_vaccines_livestock ls_exp_vac
		foreach i in ls_exp_vac{
			gen `i'_lrum = `i' if species==1
			gen `i'_srum = `i' if species==2
			gen `i'_poultry = `i' if species==3
			gen `i'_pigs = `i' if species==4			
		}
// KEF: None of these recent renames seem to be generating anything? Why not? //	
	collapse (firstnm) *lrum *srum *poultry *pigs, by(HHID)

	foreach i in ls_exp_vac{
		gen `i' = .
	}
	la var ls_exp_vac "Cost for vaccines and veterinary treatment for livestock"
	
	foreach i in ls_exp_vac{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_poultry "`l`i'' - poultry"
		lab var `i'_pigs "`l`i'' - pigs"
	}
	drop ls_exp_vac
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses_animal.dta", replace
restore 
 
collapse (sum) cost_fodder_livestock cost_water_livestock cost_vaccines_livestock cost_hired_labor_livestock, by (HHID)
lab var cost_water_livestock "Cost for water for livestock"
lab var cost_fodder_livestock "Cost for fodder for livestock"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for livestock"
lab var cost_hired_labor_livestock "Cost for hired labor for livestock"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses", replace //KEF: Isn't this the same output as up above? Why overwrite it to repeat it? This disaggregate seems to write over the total? Stopping point 01.10.21

*Livestock products
* Milk
//ALT 12.03.19: I had to overhaul this section to clear up some unit confusion between days and years. As of 12/3 there are still some discrepancies in the results that need to be resolved.
use "${UGS_W3_raw_data}/AGSEC8B.dta", clear
//ALT: Questionnaire lists all units as liter
tostring HHID, format(%18.0f) replace
rename AGroup_ID livestock_code 
//keep if livestock_code!=.
keep if livestock_code==101 | livestock_code==105 //Exotic+Indigenous large ruminants. Leaving out small ruminants because small ruminant milk accounts only for 0.04% of total production, and there's no price information
												  //Per Anu, should we use the UG W1 goat milk price as small ruminant milk price?
rename a8bq1 animals_milked
rename a8bq2 days_milked /*(days) */
//gen months_milked = days_milked/30 //ALT: Why do we need this?
rename a8bq3 liters_per_day  
recode animals_milked days_milked liters_per_day (.=0)
//gen milk_liters_produced = (animals_milked * months_milked * 30 * liters_per_day) /* 30 days per month */
gen milk_liters_produced = animals_milked*liters_per_day*days_milked
lab var milk_liters_produced "Liters of milk produced in past 12 months"
rename a8bq7 liters_sold_per_year //ALT: The question asks how many liters did you sell per year but lists units as liters/day. Looking at the data, it's mostly liters/year,
								  //but there's a tenfold difference between liters/animal in some responses,
								  //and estimated prices vary pretty wildly. It seems like the going rate is around 800-1000 USH/L, but some reports of per-day sales are resulting in highly inflated values.
rename a8bq6 liters_per_year_to_dairy // dairy instead of cheese //ALT Q asks for liters/day, but the numbers don't make sense and I think most answers are liters/year
rename a8bq9 earnings_per_year_milk //Unsure if this earnings for past 12 months or per day //ALT: It's past twelve months
recode liters_sold_per_year liters_per_year_to_dairy (.=0)
gen liters_sold_day = (liters_sold_per_year + liters_per_year_to_dairy)/days_milked 
gen price_per_liter = earnings_per_year_milk / liters_sold_per_year
gen price_per_unit = price_per_liter  
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) 
//gen earnings_milk_year = earnings_per_day_milk*months_milked*30 
gen earnings_milk_year=price_per_liter*(liters_sold_per_year + liters_per_year_to_dairy) //ALT: Double check and make sure this is actually what we want.
keep HHID livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold"
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta", replace


*Eggs
use "${UGS_W3_raw_data}/AGSEC8C.dta", clear
tostring HHID, format(%18.0f) replace
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
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_milk.dta", clear
append using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_other.dta"
recode price_per_unit (0=.)
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta", nogen keep(1 3) //47 not matched from master
replace price_per_unit = . if price_per_unit == 0 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", replace


//Median livestock product prices by EA
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products.dta", clear
//keep if price_per_unit !=.  //ALT: This drops a lot of observations b/c zeros are recoded as missing above.
keep if quantity_produced>0
gen observation = 1
preserve
bys region district parish ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district parish ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_ea.dta", replace
restore

//Median livestock product prices by parish
preserve
bys region district parish livestock_code: egen obs_parish = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district parish livestock_code obs_parish)
rename price_per_unit price_median_parish
lab var price_median_parish "Median price per unit for this livestock product in the parish"
lab var obs_parish "Number of sales observations for this livestock product in the parish"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_parish.dta", replace
restore

//Median livestock product prices by district
preserve
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_district.dta", replace
restore

//Median livestock product prices by region
preserve
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_region.dta", replace
restore

//Median livestock product prices at country level
preserve
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", replace
restore

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products", clear
merge m:1 region district parish ea livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_ea.dta", nogen
merge m:1 region district parish livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_parish.dta", nogen
merge m:1 region district livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_parish if price_per_unit==. & obs_parish >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values"
/*gen price_cowmilk_med = price_median_country if livestock_code==101 | livestock_code==102 | livestock_code==105 | livestock_code==106
egen price_cowmilk = max(price_cowmilk_med)
replace price_per_unit = price_cowmilk if livestock_code==101 | livestock_code==102 | livestock_code==105 | livestock_code==106*/ //ALT: I updated the TZ code for these lines but I don't think they're needed because the code above takes care of it.
lab var price_per_unit "Price per liter (milk) or per egg, imputed with local median prices if household did not sell"
gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==103 | livestock_code==107
//gen value_other_produced = quantity_produced * price_per_unit if livestock_code==22 | livestock_code==23 //ALT: We only have milk and eggs

//ALT: No price information is available for small ruminants
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		

collapse (sum) value_milk_produced value_eggs_produced sales_livestock_products, by (HHID)

//Subsequent code is taken from Uganda W1
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced)
lab var value_livestock_products "value of livesotck prodcuts produced (milk & eggs)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=. //19 changes made
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
recode value_milk_produced value_eggs_produced (0=.)

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_products", replace

*Sales (live animals)
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

//ALT 12.04.19: Similar to UGS W1, just updated question numbers that changed and noted difference between W1 (total value of animals) and W2 (price per animal)

*Implicit prices
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district county subcounty parish ea livestock_code: egen obs_ea = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county subcounty parish ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_ea.dta", replace 

//median price at the parish level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district county subcounty parish livestock_code: egen obs_parish = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county subcounty parish livestock_code obs_parish)
rename price_per_animal price_median_parish

lab var price_median_parish "Median price per unit for this livestock in the parish"
lab var obs_parish "Number of sales observations for this livestock in the parish"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_parish.dta", replace

//median price at the subcounty level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
keep if price_per_animal !=.
gen observation = 1
bys region district county subcounty livestock_code: egen obs_sub = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county subcounty livestock_code obs_sub)
rename price_per_animal price_median_sub

lab var price_median_sub "Median price per unit for this livestock in the subcounty"
lab var obs_sub "Number of sales observations for this livestock in the subcounty"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_subcounty.dta", replace

//median price at the county level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
gen observation = 1
bys region district county livestock_code: egen obs_county = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district county livestock_code obs_county)
rename price_per_animal price_median_county

lab var price_median_county "Median price per unit for this livestock in the county"
lab var obs_county "Number of sales observations for this livestock in the county"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_county.dta", replace

//median price at the district level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
gen observation = 1
bys region district livestock_code: egen obs_district = count (observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district

lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_district.dta", replace

//median price at the region level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
gen observation = 1
bys region livestock_code: egen obs_region = count (observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region

lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_region.dta", replace

//median price at the country level
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales.dta", clear
gen observation = 1
bys livestock_code: egen obs_country = count (observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country

lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_country.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_sales", clear
merge m:1 region district county subcounty parish ea livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_ea.dta", nogen
merge m:1 region district county subcounty parish livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_parish.dta", nogen
merge m:1 region district county subcounty livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_subcounty.dta", nogen
merge m:1 region district county livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_county.dta", nogen
merge m:1 region district livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_country.dta", nogen
replace price_per_animal  = price_median_ea if price_per_animal==. & obs_ea >= 10 
replace price_per_animal  = price_median_parish if price_per_animal==. & obs_parish >= 10 
replace price_per_animal  = price_median_sub if price_per_animal==. & obs_sub >= 10 
replace price_per_animal  = price_median_county if price_per_animal==. & obs_county >= 10 
replace price_per_animal  = price_median_district if price_per_animal==. & obs_district >= 10 
replace price_per_animal  = price_median_region if price_per_animal==. & obs_region >= 10 
replace price_per_animal  = price_median_country if price_per_animal==. & obs_country >= 10 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered
//EFW 6.10.19 Don't have value slaughtered so just value with the live animal price (see construction decisions)
gen value_livestock_sales = value_lvstck_sold + value_slaughtered
collapse (sum) value_livestock_sales value_lvstck_sold value_slaughtered value_livestock_purchases, by (HHID)
drop if HHID==""
lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases (seems to span only the agricutlural season, not the year)"
lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_sales", replace
//ALT 12.04.19: Ran above code without modification.

*TLU (Tropical Livestock Unit)
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
ren lvstid lvstckid

ren a6aq2 animal_owned
replace animal_owned=a6bq2 if animal_owned==.
replace animal_owned=a6cq2 if animal_owned==.

keep if animal_owned==1

gen tlu_coefficient =  0.5 if inrange(lvstckid, 1, 10) //Bulls and oxen, calves, heifer and cows
replace tlu_coefficient = 0.55 if lvstckid==12 //mules/horses; average of the two (horses = 0.5 and mules = 0.6)
replace tlu_coefficient = 0.3 if lvstckid==11 //donkeys
replace tlu_coefficient = 0.2 if lvstckid==17 | lvstckid==22 //pigs
replace tlu_coefficient = 0.1 if inrange(lvstckid, 13,16) | inrange(lvstckid, 18,21) //female & male goats & sheep
replace tlu_coefficient = 0.01 if inrange(lvstckid, 23,27) //rabbits, ducks, turkeys 
//geese and other birds, backyard chicken, parent stock for broilers, parents stock for layers, layers, pullet chicks, growers, broilers; beehives not included
//ALT: Changed from 0.1 to 0.01, assuming 0.1 is a coding error
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

gen number_1yearago = a6aq6
replace number_1yearago = a6bq6 if number_1yearago==.
replace number_1yearago = a6cq6 if number_1yearago==.

gen number_today= a6aq3a
replace number_today = a6bq3a if number_today==. 
replace number_today = a6bq3a if number_today==. 

gen number_today_exotic = number_today if inlist(lvstckid,1,2,3,4,5,13,14,15,16,17)

//ALT 12.05.19: End of work. Be sure to update the variables below because they don't match up between waves.

//SW 7.22.21 Continue working updating the variables below since they don't seem to work.
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today * tlu_coefficient
gen income_live_sales = a6aq14b
replace income_live_sales = a6bq14b*2 if income_live_sales==. & a6bq14b!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace income_live_sales = a6cq14b*4 if income_live_sales==. & a6cq14b!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months
gen number_sold = a6aq14a
replace number_sold = a6bq14a*2 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiply by 2 because question asks in last 6 months
replace number_sold = a6cq14a*4 if number_sold==. & a6bq14a!=. //EFW 8.26.19 multiplu by 4 because question asks in last 3 months

egen mean_12months = rowmean(number_1yearago number_today)

gen animals_lost12monthstheft = a6aq10
replace animals_lost12monthstheft = a6bq10*2 if animals_lost12monthstheft==. & a6bq10!=.
replace animals_lost12monthstheft = a6cq10*4 if animals_lost12monthstheft==. & a6cq10!=.

gen animals_lost12monthsian = a6aq11
replace animals_lost12monthsian = a6bq11*2 if animals_lost12monthsian==. & a6bq11!=.
replace animals_lost12monthsian = a6cq11*4 if animals_lost12monthsian==. & a6cq11!=.

gen animals_lost12monthsdis = a6aq12 //includes animals died or lost
replace animals_lost12monthsdis = a6bq12*2 if animals_lost12monthsdis==. & a6bq12!=. 
replace animals_lost12monthsdis = a6cq12*4 if animals_lost12monthsdis==. & a6cq12!=.
 
gen animals_lost12months = animals_lost12monthstheft + animals_lost12monthsian + animals_lost12monthsdis //includes animals died or lost due to theft,injury accident natural calamity and disease

*SW 7.22.21 Here W3 is different than W1 and W2. There are different variables for lost. 1. How many animals lost to theft in the last 12 month (a6aq10), 6 months(a6bq10), 3 months(a6cq10) 
*2. Lost to injury/accident/natural calamity in the last 12 months(a6aq11), 6 months(a6bq11), 3 months (a6cq11) 3. Lost to disease last 12 months(a6aq12), 6 months(a6bq12) and 3 months (a6cq12)
gen herd_cows_indigenous = number_today if lvstckid==6
gen herd_cows_exotic = number_today if lvstckid==3
egen herd_cows_tot = rowtotal(herd_cows_indigenous herd_cows_exotic)
gen share_imp_herd_cows = herd_cows_exotic / herd_cows_tot

rename lvstckid livestock_code

gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 2*(inlist(livestock_code,13,14,15,16,17,18,19,20)) + 3*(livestock_code==21) + 4*(inlist(livestock_code,7,8)) + 5*(inlist(livestock_code,31,32,33,34,35,36,37,38,39,40,41))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today number_1yearago animals_lost12months number_today_exotic lvstck_holding=number_today, by(HHID species) //EFW 6.9.19 doesn't include lost to disease or injury disaggregated (just died/lost) SW I changed that variable including those lost to disease and injury not sure if its good
	egen mean_12months = rowmean(number_today number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today!=. & number_today!=0
	
	foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding {
		gen `i'_lrum = `i' if species==1
		gen `i'_srum = `i' if species==2
		gen `i'_pigs = `i' if species==3
		gen `i'_equine = `i' if species==4
		gen `i'_poultry = `i' if species==5
	}
	*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
	collapse (sum) number_today number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(HHID)

	*Overall any improved herd
	gen any_imp_herd = number_today_exotic!=0 if number_today!=0
	drop number_today_exotic number_today
	
	foreach i in lvstck_holding animals_lost12months mean_12months {
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost to disease or injury"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months {
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
	drop lvstck_holding animals_lost12months mean_12months
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district county subcounty parish ea livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_ea.dta", nogen
merge m:1 region district county subcounty parish livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_parish.dta", nogen
merge m:1 region district county subcounty livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_subcounty.dta", nogen
merge m:1 region district county livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_county.dta", nogen
merge m:1 region district livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_prices_country.dta", nogen 
recode price_per_animal (0=.)
replace price_per_animal  = price_median_ea if price_per_animal==. & obs_ea >= 10 
replace price_per_animal  = price_median_parish if price_per_animal==. & obs_parish >= 10 
replace price_per_animal  = price_median_sub if price_per_animal==. & obs_sub >= 10 
replace price_per_animal  = price_median_county if price_per_animal==. & obs_county >= 10 
replace price_per_animal  = price_median_district if price_per_animal==. & obs_district >= 10 
replace price_per_animal  = price_median_region if price_per_animal==. & obs_region >= 10 
replace price_per_animal  = price_median_country if price_per_animal==. & obs_country >= 10 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (HHID)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if HHID==""
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU.dta", replace


*Livestock income
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_sales", clear
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_livestock_products"
drop _merge
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_expenses"
drop _merge
merge 1:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_TLU.dta"
drop _merge

gen livestock_income = value_lvstck_sold + value_slaughtered - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock)
*value_other_produced  cost_other_livestock 
lab var livestock_income "Net livestock income"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_livestock_income", replace
*/
*************
*FISH INCOME*
*************
*Fishing expenses
/*use "${UGS_W3_raw_data}/AGSEC9D.dta", clear
ren Hhid HHID
//EFW 6.10.19 all "fishing operation cost" included as one variable
rename A9q11b costs_fishing //includes labor on shore, labor in boat, fuel/oil, fish container, repair & maintenance, transportation of catch, rent of machinery, other
recode costs_fishing (.=0)
collapse(sum) costs_fishing, by(HHID)
la var costs_fishing "Costs for fishing expenses over the past year"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fishing_expenses.dta", replace

use "${UGS_W3_raw_data}/AGSEC9A.dta", clear
ren Hhid HHID
//EFW 6.11.19 should we restrict the file above to just fishing HHs since we do in this file??
drop if A9q1==2 | A9q1==. //answered "no" to "did anybody in the household practic fishing in the past 12 months" //EFW 6.11.19 used to mimic fish_code==. in TZ W4 code
ren A9q2 type_fishing
replace type_fishing="A" if type_fishing=="1"
replace type_fishing="B" if type_fishing=="2"
drop if type_fishing=="C" //artificial fish pond; 7 observations deleted
ren A9q8 quantity_sold //"How much, if any, of the daily catch did you sell, either as fresh fish or as smoked fish or dried fish?"
ren A9q9 value_sold //"How much did you and other members receive per day for the sale of fresh fish?"
ren A9q3 months_fished //"For how many months did you fish last year?"
ren A9q4 days_fished //"During those months how many days did your household fish on average?"
ren A9q5 fish_quantity_day //"what is your average quantity of daily catch during those months? (kg/day)"

gen price_per_unit = value_sold / quantity_sold

recode price_per_unit (0=.)
*impute prices to value fish not sold (by type of fishing) //EFW 6.11.19 added per Didier code
preserve
collapse (mean) price_per_unit, by(type_fishing)
tempfile price_type_fishing
ren price_per_unit price_per_unit_type
save `price_type_fishing'
restore
merge m:1 type_fishing using  `price_type_fishing', nogen

gen value_fish_harvest = fish_quantity_day * days_fished * months_fished * price_per_unit
replace value_fish_harvest = fish_quantity_day * days_fished * months_fished * price_per_unit_type if value_fish_harvest==.
gen income_fish_sales = value_sold * days_fished * months_fished

recode value_fish_harvest income_fish_sales (.=0)
collapse(sum) value_fish_harvest income_fish_sales, by(HHID)

lab var value_fish_harvest "Value of fish harvest (including what is sold)"
lab var income_fish_sales "Value of fish sales"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fish_income.dta", replace //EFW 6.11.19 why are we calling this fish income?? It doesn't yet incorporate expenses (saved above)

*/
************************
*SELF-EMPLOYMENT INCOME*
************************
use "${UGS_W3_raw_data}/GSEC12.dta", clear
ren h12q12 months_activ
replace months_activ = 12 if months_activ > 12 & months_activ!=. //1 change made
ren h12q13 monthly_revenue
ren h12q15 wage_expense
ren h12q16 materials_expense
ren h12q17 operating_expense
recode monthly_revenue wage_expense materials_expense operating_expense (.=0)
gen monthly_profit = monthly_revenue - (wage_expense + materials_expense + operating_expense)
count if monthly_profit <0 & monthly_profit!=. //156 EFW 6.24.19 What do we do with negatives profit, recode to zero?? check other code
gen annual_selfemp_profit = monthly_profit * months_activ
count if annual_selfemp_profit<0 & annual_selfemp_profit!=. //152
recode annual_selfemp_profit (.=0)
collapse (sum) annual_selfemp_profit, by(HHID)
lab var annual_selfemp_profit "Estimated annual net profit from self-employment over previous 12 months"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_self_employment_income.dta", replace

*Processed crops
//EFW 6.24.19 Can't construct in this instrument; only includes question "how much of the [crop] harvested was used to produce processed food products for sale and for animal feed?"

*Fish trading
//EFW 7.10.19 not captured in this instrument


*************
*WAGE INCOME*
*************
*SW 4.15.22 Wage Income section does not run, will not include it in the Github update on April 15.
/*
UGS Wave 1 did not capture number of weeks per month individual worked. 
We impute these using median values by industry and type of residence using UGS W2
see imputation below. This follows RIGA methods.


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

//use wave 1 income
use "${UGS_W3_raw_data}/GSEC8.dta", clear
*ren Hhid HHID
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta"
drop _merge
//Classification of Industry to get median wage for imputation, taken from r coding
gen industry=1 if H8q20b<=2
replace industry=2 if H8q20b>=131 & H8q20b<=142
replace industry=3 if H8q20b>=151 & H8q20b<=372
replace industry=4 if H8q20b>=401 & H8q20b<=410
replace industry=5 if H8q20b>=451 & H8q20b<=455
replace industry=6 if H8q20b>=501 & H8q20b<=526
replace industry=7 if H8q20b>=551 & H8q20b<=642
replace industry=8 if H8q20b>=651 & H8q20b<=749
replace industry=9 if H8q20b>=751 & H8q20b<=930
replace industry=10 if H8q20b>=950 & H8q20b<=990

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
rename H8q30 number_months
egen number_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) //EFW 7.10.19 
rename H8q31a most_recent_payment
replace most_recent_payment = . if (H8q19b > 611 & H8q19b < 623) | H8q19b != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct?
rename H8q31c payment_period
rename H8q31b most_recent_payment_other
rename H8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if (H8q19b > 611 & H8q19b < 623) | H8q19b != 921 //EFW 7.17.19 TZA W1 doesn't do this, which is correct?
rename H8q45c secwage_payment_period
rename H8q45b secwage_recent_payment_other
gen secwage_hours_pastweek = H8q43 

gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse(sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_wage_income.dta", replace

//Ag Wage Income
use "${UGS_W3_raw_data}/GSEC8.dta", clear
ren Hhid HHID
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta"
drop _merge
//Classification of Industry to get median wage for imputation, taken from r coding
gen industry=1 if H8q20b<=2
replace industry=2 if H8q20b>=131 & H8q20b<=142
replace industry=3 if H8q20b>=151 & H8q20b<=372
replace industry=4 if H8q20b>=401 & H8q20b<=410
replace industry=5 if H8q20b>=451 & H8q20b<=455
replace industry=6 if H8q20b>=501 & H8q20b<=526
replace industry=7 if H8q20b>=551 & H8q20b<=642
replace industry=8 if H8q20b>=651 & H8q20b<=749
replace industry=9 if H8q20b>=751 & H8q20b<=930
replace industry=10 if H8q20b>=950 & H8q20b<=990

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

rename H8q30 number_months
egen number_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) //EFW 7.10.19 
rename H8q31a most_recent_payment
replace most_recent_payment = . if industry!=1
rename H8q31c payment_period
rename H8q31b most_recent_payment_other
rename H8q45a secwage_most_recent_payment
replace secwage_most_recent_payment = . if industry!=1
rename H8q45c secwage_payment_period
rename H8q45b secwage_recent_payment_other
gen secwage_hours_pastweek = H8q43 

gen annual_salary_cash = most_recent_payment*number_months if payment_period==4
replace annual_salary_cash = most_recent_payment*weeks if payment_period==3
replace annual_salary_cash = most_recent_payment*weeks*(number_hours/8) if payment_period==2
replace annual_salary_cash = most_recent_payment*weeks*number_hours if payment_period==1

gen wage_salary_other = most_recent_payment_other*number_months if payment_period==4
replace wage_salary_other = most_recent_payment_other*weeks if payment_period==3
replace wage_salary_other = most_recent_payment_other*weeks*(number_hours/8) if payment_period==2
replace wage_salary_other = most_recent_payment_other*weeks*number_hours if payment_period==1

recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse(sum) annual_salary, by (HHID)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_agwage_income.dta", replace
*/

**************
*OTHER INCOME*
**************
*SAW 4.15.22 This section does not run will not include in the Github 
/*
use "${UGS_W3_raw_data}/GSEC11.dta", clear
gen rental_income_cash = h11aq05 if (h11aq03==21 | h11aq03==22 | h11aq03==23) //EFW 7.17.19 doesn't explicitly exclude agricultural land (as TZA W4 does)
gen rental_income_inkind = h11aq06 if (h11aq03==21 | h11aq03==22 | h11aq03==23)
gen pension_income_cash = h11aq05 if h11aq03==41
gen pension_income_inkind = h11aq06 if h11aq03==41
gen assistance_cash = h11aq05 if (h11aq03==42 | h11aq03==43)
gen assistance_inkind = h11aq06 if (h11aq03==42 | h11aq03==43)
gen other_income_cash = h11aq05 if (h11aq03==23 | h11aq03==32 | h11aq03==33 | h11aq03==34 | h11aq03==35 | h11aq03==36 | h11aq03==44 | h11aq03==45)
gen other_income_inkind = h11aq06 if (h11aq03==23 | h11aq03==32 | h11aq03==33 | h11aq03==34 | h11aq03==35 | h11aq03==36 | h11aq03==44 | h11aq03==45)
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

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
ren Hhid HHID
rename A2aq16 land_rental_income
recode land_rental_income (.=0)
collapse(sum) land_rental_income, by(HHID)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_rental_income.dta", replace
*/
*SAW 4.17.22 The following code does not run and needs to be reviewed
/*
***********************
*FARM SIZE / LAND SIZE*
***********************
use "${UGS_W3_raw_data}/AGSEC4A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC4B.dta"
ren Hhid HHID
ren A4aq2 parcel_id
replace parcel_id = A4bq2 if parcel_id == .
ren A4aq4 plot_id
replace plot_id = A4bq4 if plot_id == .
ren A4aq6 crop_code
replace crop_code = A4bq6 if crop_code == .
drop if plot_id==.
drop if parcel_id==.
drop if crop_code == .
gen crop_grown = 1
collapse (max) crop_grown, by (HHID parcel_id) 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crops_grown.dta", replace

use "${UGS_W3_raw_data}/AGSEC4A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC4B.dta"
ren Hhid HHID
ren A4aq2 parcel_id
replace parcel_id = A4bq2 if parcel_id == .
ren A4aq4 plot_id
replace plot_id = A4bq4 if plot_id == .
ren A4aq1 cultivated
replace cultivated = A4bq1 if cultivated == .
collapse (max) cultivated, by (HHID parcel_id) 
lab var cultivated "1= Parcel was cultivated in this data set"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_cultivated.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_cultivated.dta", clear
merge 1:1 HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta"
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
ren area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size.dta", replace 

*All agricultural land
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id == .
drop if parcel_id==.
merge m:1 HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_crops_grown.dta", nogen 
*5,202 matched
*623 not matched (from master)
gen rented_out = (A2aq13a==3 | A2aq13a==4 | A2aq13b==3 | A2aq13b==4) //rented out & cultivated by mailo tenant
//EFW 7.19.19 2nd cropping season is "short"
gen cultivated_short = (A2aq13b==1 | A2aq13b==2) //own cultivated annual and perennial crops
bys HHID parcel_id: egen plot_cult_short=max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
*8 changes made
drop if rented_out==1 & crop_grown!=1
*73 obs dropped
gen agland = (A2aq13a==1 | A2aq13a==2 | A2aq13a==5 | A2aq13a==6 | A2aq13b==1 | A2aq13b==2 | A2aq13b==5 | A2aq13b==6) //cultivated, fallow & pasture
drop if agland!=1 & crop_grown==.
*228 obs deleted
collapse (max) agland, by (HHID parcel_id) 
lab var agland "1= Parcel was used for crop cultivation or left fallow in this past year (forestland and other uses excluded)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_agland.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_agland.dta", clear
merge 1:1 HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (sum) area_acres_meas, by (HHID)
rename area_acres_meas farm_size_agland
replace farm_size_agland = farm_size_agland * (1/2.47105) /* Convert to hectares */
lab var farm_size_agland "Land size in hectares, including all plots cultivated or left fallow"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmsize_all_agland.dta", replace

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id == .
drop if parcel_id==.
gen rented_out = (A2aq13a==3 | A2aq13a==4 | A2aq13b==3 | A2aq13b==4) //rented out & cultivated by mailo tenant
gen cultivated_short = (A2aq13b==1 | A2aq13b==2) //own cultivated annual and perennial crops
bys HHID parcel_id: egen plot_cult_short=max(cultivated_short)
replace rented_out = 0 if plot_cult_short==1 // If cultivated in short season, not considered rented out in long season.
drop if rented_out==1
gen plot_held = 1
collapse (max) plot_held, by (HHID parcel_id)
lab var plot_held "1= Parcel was NOT rented out in the main season"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_held.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_parcels_held.dta", clear
merge 1:1 HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta"
drop if _merge==2
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
rename area_acres_meas land_size
replace land_size = land_size * (1/2.47105) /* Convert to hectares */
lab var land_size "Land size in hectares, including all plots listed by the household except those rented out" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size_all.dta", replace

*Total land holding including cultivated and rented out
use "${UGS_W3_raw_data}/AGSEC2A.dta", clear
append using "${UGS_W3_raw_data}/AGSEC2B.dta"
ren Hhid HHID
ren A2aq2 parcel_id
replace parcel_id = A2bq2 if parcel_id == .
merge m:1 HHID parcel_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_areas.dta"
replace area_acres_meas=. if area_acres_meas<0
replace area_acres_meas = area_acres_est if area_acres_meas==. 
replace area_acres_meas = area_acres_est if area_acres_meas==0 & (area_acres_est>0 & area_acres_est!=.)
collapse (max) area_acres_meas, by(HHID parcel_id)
ren area_acres_meas land_size_total
collapse (sum) land_size_total, by (HHID)
replace land_size_total = land_size_total * (1/2.47105) /* Convert to hectares */
lab var land_size_total "Total land size in hectares, including rented in and rented out plots"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_land_size_total.dta", replace

****************
*OFF-FARM HOURS*
****************
use "${UGS_W3_raw_data}/GSEC8.dta", clear
ren Hhid HHID
//EFW 7.10.19 codes are not labeled so use (and assume) so use iternational standard classification of occupations (ISCO)
egen primary_hours = rowtotal(H8q36a H8q36b H8q36c H8q36d H8q36e H8q36f H8q36g) if (H8q19b < 611 | H8q19b > 623) & H8q19b != 921
//92=agricultural, fishery and related laborers; section 6 = agricultural and fishery related workers
gen secondary_hours = H8q43 if (H8q38b < 611 | H8q38b > 623) & H8q38b != 921
egen off_farm_hours = rowtotal(primary_hours secondary_hours)
gen off_farm_any_count = off_farm_hours!=0
gen member_count = 1
collapse (sum) off_farm_hours off_farm_any_count member_count, by(HHID)
la var member_count "Number of HH members age 5 or above"
la var off_farm_any_count "Number of HH members with positive off-farm hours"
la var off_farm_hours "Total household off-farm hours"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_off_farm_hours.dta", replace

************
*FARM LABOR*
************
use "${UGS_W3_raw_data}/AGSEC3A.dta", clear
ren Hhid HHID
ren A3aq1 parcel_id 
ren A3aq3 plot_id
ren A3aq39 days_famlabor_mainseason //person days: reflects both size of team & number of days spent
ren A3aq42a days_hired_men
ren A3aq42b days_hired_women
ren A3aq42c days_hired_child
egen days_hired_mainseason = rowtotal(days_hired_men days_hired_women days_hired_child)
recode days_famlabor_mainseason days_hired_mainseason (.=0)
collapse (sum) days_famlabor_mainseason days_hired_mainseason, by (HHID parcel_id plot_id) //EFW 7.19.19 correct level??
lab var days_hired_mainseason  "Workdays for hired labor (crops) in main growing season"
lab var days_famlabor_mainseason  "Workdays for family labor (crops) in main growing season"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_mainseason.dta", replace

use "${UGS_W3_raw_data}/AGSEC3B.dta", clear
ren a3bq1 parcel_id 
ren a3bq3 plot_id
ren a3bq39 days_famlabor_shortseason
ren a3bq42a days_hired_men
ren a3bq42b days_hired_women
ren a3bq42c days_hired_child
egen days_hired_shortseason = rowtotal(days_hired_men days_hired_women days_hired_child)
recode days_famlabor_shortseason days_hired_shortseason (.=0)
collapse (sum) days_hired_shortseason days_famlabor_shortseason, by (HHID parcel_id plot_id)
lab var days_hired_shortseason  "Workdays for hired labor (crops) in short growing season"
lab var days_famlabor_shortseason  "Workdays for family labor (crops) in short growing season"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_shortseason.dta", replace

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_mainseason.dta", clear
merge 1:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmlabor_shortseason.dta"
drop _merge
recode days* (.=0)
collapse (sum) days*, by (HHID parcel_id plot_id)
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
*/
/*
***************
*VACCINE USAGE*
***************
use "${UGS_W3_raw_data}/AGSEC6A", clear
ren Hhid HHID
*append using "${UGS_W3_raw_data}/AGSEC6B" //EFW 7.24.29 vaccine usage only included in large animal file
*append using "${UGS_W3_raw_data}/AGSEC6C" //EFW 7.24.19 vaccine usage only included in large animal file

gen livestock_code = A6aq3
/*
destring a6bq3 a6cq3, replace
replace lvstckid = a6bq3 if lvstckid ==. & a6bq3!=.
replace lvstckid = a6cq3 if lvstckid ==. & a6cq3!=.
*/
gen vac_animal=A6aq18==1 | A6aq18==2 //EFW 7.19.19 only included in dta file for large animals (large ruminants and equine)
//missing if the household did now own any of these types of animals 
replace vac_animal = . if A6aq4==2 | A6aq4==. 

gen species = (inlist(livestock_code,1,2,3,4,5,6)) + 4*(inlist(livestock_code,7,8))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 4 "Equine (horses, donkeys)" 
la val species species

*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	*gen `i'_srum = `i' if species==2
	*gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	*gen `i'_poultry = `i' if species==5
}

collapse (max) vac_animal*, by (HHID)
lab var vac_animal "1= Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		*lab var `i'_srum "`l`i'' - small ruminants"
		*lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		*lab var `i'_poultry "`l`i'' - poultry"
	}
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_vaccine.dta", replace

*vaccine use livestock keeper 
use "${UGS_W3_raw_data}/AGSEC6A", clear
ren Hhid HHID
*append using "${UGS_W3_raw_data}/AGSEC6B" //EFW 7.24.29 vaccine usage only included in large animal file
*append using "${UGS_W3_raw_data}/AGSEC6C" //EFW 7.24.19 vaccine usage only included in large animal file

gen livestock_code = A6aq3
/*
destring a6bq3 a6cq3, replace
replace lvstckid = a6bq3 if lvstckid ==. & a6bq3!=.
replace lvstckid = a6cq3 if lvstckid ==. & a6cq3!=.
*/
gen all_vac_animal=A6aq18==1 | A6aq18==2 //EFW 7.19.19 only included in dta file for large animals (large ruminants and equine)
//missing if the household did now own any of these types of animals 
replace all_vac_animal = . if A6aq4==2 | A6aq4==. 
preserve 
keep HHID all_vac_animal A6aq17a
ren A6aq17a farmerid
tempfile farmer1
save `farmer1'
restore
preserve
keep HHID all_vac_animal A6aq17b 
ren A6aq17b farmerid
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'

collapse (max) all_vac_animal , by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", nogen //99 unmatched from master, 17,764 unmatched from using
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_vaccine.dta", replace


**************************
*ANIMAL HEALTH - DISEASES*
**************************
*can't construct in this instrument. doesn't include question on what diseases animals suffer


***************************************
*LIVESTOCK WATER, FEEDING, AND HOUSING*
***************************************
*can't construct in this instrument. doesn't include question on feeding and watering practices


*****************************
*USE OF INORGANIC FERTILIZER*
*****************************
use "${UGS_W3_raw_data}/AGSEC3A", clear
ren Hhid HHID
append using "${UGS_W3_raw_data}/AGSEC3B"
gen use_inorg_fert=.
replace use_inorg_fert=0 if A3aq14==2 | a3bq14==2
replace use_inorg_fert=1 if A3aq14==1 | a3bq14==1
recode use_inorg_fert (.=0)
collapse (max) use_inorg_fert, by (HHID)
lab var use_inorg_fert "1 = Household uses inorganic fertilizer"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_fert_use.dta", replace

*Fertilizer use by farmers ( a farmer is an individual listed as plot manager)
use "${UGS_W3_raw_data}/AGSEC3A", clear
ren Hhid HHID
append using "${UGS_W3_raw_data}/AGSEC3B"
gen parcel_id = A3aq1
replace parcel_id = a3bq1 if parcel_id == .
gen plot_id = A3aq3
replace plot_id = a3bq3 if plot_id == .
gen all_use_inorg_fert=(A3aq14==1 | a3bq14==1)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_fert_use_temp.dta", replace 

use "${UGS_W3_raw_data}/AGSEC2A.dta", clear //land household owns
ren Hhid HHID
gen parcel_id = A2aq2
drop if parcel_id == .
gen plot_id = A2aq2
drop if plot_id == .
append using "${UGS_W3_raw_data}/AGSEC2B.dta" //land household has user rights to
replace HHID=Hhid if HHID==""
replace parcel_id = A2bq2 if parcel_id == .
drop if parcel_id == .
replace plot_id = A2bq2 if plot_id == .
drop if plot_id == .

merge 1:m HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_fert_use_temp.dta" 

preserve
keep HHID all_use_inorg_fert A2aq27a A2bq25a //"Who usually (mainly) works on this parcel?" 
ren A2aq27a farmerid //"Who usually (mainly) works on this parcel?" 
replace farmerid = A2bq25a if farmerid == . & A2bq25a!=.
tempfile farmer1
save `farmer1'
restore
preserve
keep HHID all_use_inorg_fert A2aq27b A2bq25b
ren A2aq27b farmerid
replace farmerid = A2bq25b if farmerid == . & A2bq25b!=.
tempfile farmer2
save `farmer2'
restore

use   `farmer1', replace
append using  `farmer2'
collapse (max) all_use_inorg_fert, by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot" 
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_fert_use.dta", replace


**********************
*USE OF IMPROVED SEED*
**********************
use "${UGS_W3_raw_data}/AGSEC4A", clear
append using "${UGS_W3_raw_data}/AGSEC4B"
ren Hhid HHID
gen crop_code = A4aq6
replace crop_code = A4bq6 if crop_code==.

gen imprv_seed_use=.
replace imprv_seed_use=1 if (A4aq13==2 | A4bq13==2)
replace imprv_seed_use=0 if (A4aq13==1 | A4bq13==1)
recode imprv_seed_use (.=0)

*Use of seed by crop
forvalues k=1(1)$len {
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
gen imprv_seed_`cn'=imprv_seed_use if crop_code==`c'
gen hybrid_seed_`cn'=. //EFW 8.5.19 no question about hybrid seed in this instrument
}

collapse (max) imprv_seed_* hybrid_seed_*, by(HHID)
foreach v in $topcropname_area {
	lab var imprv_seed_`v' "1= Household uses improved `v' seed"
	lab var hybrid_seed_`v' "1= Household uses improved `v' seed"
}

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", replace

*Seed adoption by farmers (a farmer is an individual listed as plot manager)
//EFW 8.5.19 we use IDs from sections 2A and 2B for questions related to who manages the plot
//Section 5 includes "who controls the output from this crop?" which is at the crop level. Use here instead. Is this OK? This is a different definition of "plot manager"
//Should we revist earlier in the code and change that plot manager variable as well??
use "${UGS_W3_raw_data}/AGSEC4A", clear
ren Hhid HHID
ren A4aq2 parcel_id
ren A4aq4 plot_id
ren A4aq6 crop_code

preserve
use "${UGS_W3_raw_data}/AGSEC5A", clear
ren Hhid HHID
ren A5aq1 parcel_id 
ren A5aq3 plot_id
ren A5aq5 crop_code
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use_temp1.dta", replace
restore

merge 1:m HHID parcel_id plot_id crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use_temp1.dta"

preserve 
use "${UGS_W3_raw_data}/AGSEC5B", clear
ren Hhid HHID
ren A5bq1 parcel_id 
ren A5bq3 plot_id 
ren A5bq5 crop_code
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use_temp2.dta", replace

use "${UGS_W3_raw_data}/AGSEC4B", clear
ren Hhid HHID
ren A4bq2 parcel_id 
ren A4bq4 plot_id 
ren A4bq6 crop_code
merge 1:m HHID parcel_id plot_id crop_code using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use_temp2.dta"
tempfile seedb
save `seedb'
restore

append using `seedb'

gen imprv_seed_use=.
replace imprv_seed_use=1 if (A4aq13==2 | A4bq13==2)
replace imprv_seed_use=0 if (A4aq13==1 | A4bq13==1)
recode imprv_seed_use (.=0)

ren imprv_seed_use all_imprv_seed_use

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp.dta", replace

*Use of seed by crop
forvalues k=1(1)$len {
	use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp.dta", clear
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	*Adding adoption of improved seed
	gen all_imprv_seed_`cn'=all_imprv_seed_use if crop_code==`c'
	gen all_hybrid_seed_`cn'=. //EFW 8.5.19 no question about hybrid seed in this instrument
	*We also need a variable that indicates if farmer (plot manager) grows crop
	gen `cn'_farmer= crop_code==`c'
	ren A5aq11 farmerid
	replace farmerid=A5bq11 if farmerid==.

	collapse (max) all_imprv_seed_use  all_imprv_seed_`cn' all_hybrid_seed_`cn'  `cn'_farmer, by (HHID farmerid)
	save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp_`cn'.dta", replace
}	

*Combining all crop disaggregated files together
foreach v in $topcropname_area {
	merge 1:1 HHID farmerid all_imprv_seed_use using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_farmer_improvedseed_use_temp_`v'.dta", nogen
}

gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_gender_merge.dta", nogen //3,160 matched
lab var all_imprv_seed_use "1 = Individual farmer (plot manager) uses improved seeds"
foreach v in $topcropname_area {
	lab var all_imprv_seed_`v' "1 = Individual farmer (plot manager) uses improved seeds - `v'"
	lab var all_hybrid_seed_`v' "1 = Individual farmer (plot manager) uses hybrid seeds - `v'"
	lab var `v'_farmer "1 = Individual farmer (plot manager) grows `v'"
}

gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Indvidual is listed as a manager for at least one plot"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_improvedseed_use.dta", replace


*************************
*REACHED BY AG EXTENSION*
*************************
use "${UGS_W3_raw_data}/AGSEC10", clear
ren Hhid HHID
//EFW 8.8.19 A10q3 (and A10q2) seems to be labeled incorrectly in the dta file. Responses are consisten with survey question.
gen receive_advice=.
replace receive_advice=1 if A10q3==1
replace receive_advice=0 if A10q3==2

*Government Extension
gen advice_gov = (A10q2=="NAADS" & receive_advice==1)
*NGO
gen advice_ngo = (A10q2=="NGO" & receive_advice==1)
**Cooperative/Farmer Association
gen advice_coop = (A10q2=="COOPERATIVE" & receive_advice==1)
*Large Scale Farmer
gen advice_farmer = (A10q2=="LARGE SCALE FARMER" & receive_advice==1)
*Input Supplier
gen advice_input = (A10q2=="INPUT SUPPLIER" & receive_advice==1)
*Other
gen advice_other = (A10q2=="OTHERS" & receive_advice==1)

gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_input==1)
gen ext_reach_unspecified=(advice_other==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1)
*can't construct ext_reach_ict
gen ext_reach_ict=.

collapse (max) ext_reach_*, by (HHID)
lab var ext_reach_all "1 = Household reached by extensition services - all sources"
lab var ext_reach_public "1 = Household reached by extensition services - public sources"
lab var ext_reach_private "1 = Household reached by extensition services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extensition services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extensition services through ICT"

save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_any_ext.dta", replace


******************************************************************************************************
*USE OF FORMAL FINANCIAL SERVICES*
******************************************************************************************************
use "${UGS_W3_raw_data}/GSEC13", clear
gen borrow_bank = h13q05 == 1 | h13q07 == 1
gen borrow_government = h13q06 == 1 // this variable added for Uganda, government is a formal financial service asked about in the Uganda survey
gen borrow_employer = h13q09 == 1
gen borrow_micro = h13q08 == 1
gen borrow_neigh =  h13q11 == 1 //using "borrowed money from a family member or friend"
gen borrow_other = h13q10 == 1 | h13q13 == 1 //using "borrowed money from a SACCOS or other informal savings club" and "borrowed money from a money lender"


//gen use_MM = 
gen use_bank_account = h13q01 == 1 | h13q19 == 1
gen use_fin_serv_bank = h13q20 == 1 | h13q01 == 1 
gen use_fin_serv_credit = borrow_bank == 1 | borrow_other == 1 |h13q18 == 1
gen use_fin_serv_insur = h13q21 == 1 | h13q22 == 1 | h13q23 == 1 | h13q24 == 1 | h13q25 == 1
//gen use_fin_serv_digital =

gen use_fin_serv_others = h13q02 == 1 | h13q03 == 1 //includes SACCOS or "other informal savings clubs"

gen use_fin_serv_all = use_fin_serv_bank==1 | use_fin_serv_credit==1 | use_fin_serv_insur==1 | use_fin_serv_others==1 // | use_fin_serv_digital==1
recode use_fin_serv* (.=0)

lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
//lab var use_fin_serv_digital "1= Household uses formal financial services - digital" 
lab var use_fin_serv_others "1= Household uses financial services - others" //is this meant to be other formal?

collapse (max)use_fin_serv*, by (HHID)

save "${UGS_W3_created_data}/UGS_W3_fin_serv.dta", replace 


******************************************************************************************************
*MILK PRODUCTIVITY*
******************************************************************************************************
use "${UGS_W3_raw_data}/AGSEC6A", clear
append using "${UGS_W3_raw_data}/AGSEC8"
ren Hhid HHID
gen ruminants_large =  A6aq3 == 1 | 2 | 3 | 4 | 5 | 6 
gen milk_animals = A6aq3 == 3 | 6 
gen is_cow_milk = A8q2 == 1 //only considering cow milk, not goat milk, sour milk, or ghee
gen months_milked = A8q3 * is_cow_milk
//gen kg_to_liters_conversion = (A8q5 == 1) * (1/1.03) is this line necessary, or do you assume liter == kg
gen liters_day = A8q4 * is_cow_milk * (1/30.5)
gen liters_per_largeruminant = (liters_day*365*(months_milked/12))
//keep if milk_animals!=0 & milk_animals!=.
//drop if liters_per_largeruminant==.
keep HHID milk_animals months_milked liters_per_largeruminant 
lab var milk_animals "Number of large ruminants that was milk (household)"
lab var months_milked "Average months milked in last year (household)"
lab var liters_per_largeruminant "average quantity (liters) per year (household)"
save "${UGS_W3_created_data}/UGS_W3_milk_animals.dta", replace
*/
*SW 7/20/21 I will do Milk productivity again since I can not find the temp file and AGSEC8 raw data does not seem to exist.
use "${UGS_W3_raw_data}/AGSEC8B", clear
keep if AGroup_ID==101 | AGroup_ID==105
* SW We keep only large ruminants(exotic/cross & Indigenous)
*SW we remove outliers in variable a8bq1 (Do we keep outliers until winzorization?)
replace a8bq1=. if a8bq1>1000
gen milk_animals = a8bq1
*SW Not able to considerd only Cow milk, it will consider all milk from large ruminants.
gen days_milked = a8bq2
*This won't consider HH that had large ruminant but did not used them to get milk.
gen months_milked = days_milked/30.5
*gen months_milked = round(days_milked/30.5)
gen liters_day = a8bq3
gen liters_per_largerruminant = days_milked*liters_day
keep HHID milk_animals months_milked days_milked liters_per_largerruminant liters_day
label variable milk_animals "Number of large ruminants that was milk (household)"
label variable days_milked "Average days milked in last year (household)"
label variable months_milked "Average months milked in last year (household)"
label variable  liters_day "Average milk production  (liters) per day per milked animal"
label variable liters_per_largerruminant "Average quantity (liters) per year per milked animal (household)"
save "${UGS_W3_created_data}/UGS_W3_milk_animals.dta", replace
/*Notes: Not sure if it is possible to dissagregate this indicator by type of large ruminant(cows etc.). 
Also, do we want the indicator to be Average quantity per year per milked animal or by total sum of milked animals?"
Indicator liters_per_largerruminant mean 721.35 vs Tanzania wave 4 indicator is 1123.2 */
*SW Check for outliers in milk animals(a8bq1)


******************************************************************************************************
*EGG PRODUCTIVITY*
******************************************************************************************************
/*
use "${UGS_W3_raw_data}/AGSEC6C", clear
append using "${UGS_W3_raw_data}/AGSEC8"
gen has_backyard_chickens = A6cq3 == "32"
gen has_parent_stock_for_broilers = A6cq3 == "33"
gen has_parent_stock_for_layers = A6cq3 == "34"
gen has_layers = A6cq3 == "35"
gen has_pullet_chicks = A6cq3 == "36"
gen has_growers = A6cq3 == "37"
gen has_broilers = A6cq3 == "38"
gen has_turkeys = A6cq3 == "39"
gen has_ducks = A6cq3 == "40"
gen has_other_poultry = A6cq3 == "41"
gen has_any_poultry = has_backyard_chickens | has_parent_stock_for_broilers | has_parent_stock_for_layers | has_layers | has_pullet_chicks | has_growers | has_broilers | has_turkeys | has_ducks | has_other_poultry
gen poultry_owned = has_any_poultry * A6cq5
gen eggs_months = (A8q2 == 5) * A8q3
gen eggs_per_month = (A8q2 == 5) * A8q4
gen eggs_total_year = eggs_months * eggs_per_month
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var poultry_owned "Total number of poulty owned (household)"
*/
*SW 7.20.21 I will do Egg productivity again since the code above doesn't seem to work
use "${UGS_W3_raw_data}/AGSEC8C", clear
gen poultry_owned = a8cq1
gen eggs_per_month = a8cq2/3
*gen eggs_total_year = eggs_per_month*12
gen eggs_total_year = a8cq2
*SW We don't have information regarding the number of months eggs were produced during a year. Do we make an assumption that the production is equal during the whole year? In Tanzania the average of months eggs were produced is 3.3 with sd 2. In UG W1 is 4
label variable poultry_owned "Total number of poulty owned that laid eggs (household)"
label variable eggs_per_month "Number of months eggs that were produced per month (household)"
label variable eggs_total_year "Total number of eggs that was produced (household)"
keep HHID eggs_per_month eggs_total_year poultry_owned
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_eggs_animals.dta", replace

/*EGG PRODUCTIVITY, JUST CHICKENS 
use "${UGS_W3_raw_data}/AGSEC6C", clear
append using "${UGS_W3_raw_data}/AGSEC8"
gen has_backyard_chickens = A6cq3 == "32"
gen has_parent_stock_for_broilers = A6cq3 == "33"
gen has_parent_stock_for_layers = A6cq3 == "34"
gen has_layers = A6cq3 == "35"
gen has_pullet_chicks = A6cq3 == "36"
gen has_growers = A6cq3 == "37"
gen has_broilers = A6cq3 == "38"
gen has_any_chickens = has_backyard_chickens | has_parent_stock_for_broilers | has_parent_stock_for_layers | has_layers | has_pullet_chicks | has_growers | has_broilers
gen chickens_owned = has_any_chickens * A6cq5
gen eggs_months = (A8q2 == 5) * A8q3
gen eggs_per_month = (A8q2 == 5) * A8q4
gen eggs_total_year = eggs_months * eggs_per_month
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var chickens_owned "Total number of chickens owned (household)" */

/*EGG PRODUCTIVITY, JUST EGG PRODUCERS
use "${UGS_W3_raw_data}/AGSEC6C", clear
append using "${UGS_W3_raw_data}/AGSEC8"
gen has_parent_stock_for_layers = A6cq3 == "34"
gen has_layers = A6cq3 == "35"
gen has_egg_producers =  has_parent_stock_for_layers | has_layers
gen chickens_owned = has_egg_producers * A6cq5
gen eggs_months = (A8q2 == 5) * A8q3
gen eggs_per_month = (A8q2 == 5) * A8q4
gen eggs_total_year = eggs_months * eggs_per_month
lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of months eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced (household)"
lab var chickens_owned "Total number of egg-producing chickens owned (household)" */
********************************************************************************
*CROP PRODUCTION COST PER HECTARE*
********************************************************************************
/*
*****LAND RENTAL************
* start by getting parcel size
use "${UGS_W3_raw_data}/AGSEC2B", clear
ren Hhid HHID
ren A2bq2 plot_id
gen plot_ha = A2bq4/2.47105	
replace plot_ha = A2bq5/2.47105 if plot_ha==.	
keep plot_ha plot_id HHID
lab var plot_ha "Plot area in hectare" 
save"${UGS_W3_created_data}/UGS_W3_plot_area_lrs.dta", replace
*SW: For land size we only have information at the Parcel level (not on plot level).
* We get rental cost per parcel

merge 1:1 plot_id HHID using "${UGS_W3_created_data}/UGS_W3_plot_area_lrs.dta" , nogen	
drop if plot_id==""
gen cultivated = A2bq15a == 1 | A2bq15a == 2 | A2bq15b == 1 | A2bq15b == 2 
merge m:1 y4_hhid plot_id using  "${UGS_W3_created_data}/UGS_W3_plot_decision_makers.dta", nogen keep (1 3)
//tab ag3a_34_1 ag3a_34_2, nol
gen plot_rental_rate = A2bq9
recode plot_rental_rate (0=.) 

preserve
gen value_rented_land_male = plot_rental_rate if dm_gender==1
gen value_rented_land_female = plot_rental_rate if dm_gender==2
gen value_rented_land_mixed = plot_rental_rate if dm_gender==3
collapse (sum) value_rented_land_* value_rented_land = plot_rental_rate, by(HHID)
lab var value_rented_land_male "Value of rented land (male-managed plot)
lab var value_rented_land_female "Value of rented land (female-managed plot)
lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)
save
restore

gen ha_rental_rate_hh = plot_rental_rate/plot_ha
preserve
keep if plot_rental_rate!=. & plot_rental_rate!=0
collapse (sum) plot_rental_rate plot_ha, by(HHID)
gen ha_rental_hh_lrs = plot_rental_rate/plot_ha				
keep ha_rental_hh_lrs HHID
lab var ha_rental_hh_lrs "Area of rented plot during the ?long run? season"
save
restore

*Merging in geographic variables
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta", nogen /*assert(2 3)*/ keep(3)	//no error here

*Merging in geographic variables
bys h1aq1_05 h1aq2 h1aq3 h1aq4: egen ha_rental_count_parish = count(ha_rental_rate_hh)
bys h1aq1_05 h1aq2 h1aq3 h1aq4: egen ha_rental_rate_parish = median(ha_rental_rate_hh)
bys h1aq1_05 h1aq2 h1aq3: egen ha_rental_count_subcounty = count(ha_rental_rate_hh)
bys h1aq1_05 h1aq2 h1aq3: egen ha_rental_rate_subcounty = median(ha_rental_rate_hh)
bys h1aq1_05 h1aq2: egen ha_rental_count_county = count(ha_rental_rate_hh)
bys h1aq1_05 h1aq2: egen ha_rental_rate_county = median(ha_rental_rate_hh)
bys h1aq1_05: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys h1aq1_05: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least ten observations
gen ha_rental_rate = ha_rental_rate_parish if ha_rental_count_parish>=10		
replace ha_rental_rate = ha_rental_rate_subcounty if ha_rental_count_subcounty>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_county if ha_rental_count_county>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.				
collapse (firstnm) ha_rental_rate, by(h1aq1_05 h1aq2 h1aq3 h1aq4)
lab var ha_rental_rate "Land rental rate per ha"
save"${UGS_W3_created_data}/UGS_W3_rental_rate_lrs.dta", replac

*/

********************************************************************************
*LAND RENTAL
********************************************************************************
/*
*SW 12/27/2021
*LRS For Owners of Land
/*use "${UGS_W3_raw_data}/AGSEC2A", clear
ren parcelID parcel_id
*Check if parcel means the same as plotID
gen parcel_ha = a2aq4/2.47105	
replace parcel_ha = a2aq5/2.47105 if parcel_ha==.	
keep parcel_id parcel_ha HHID
lab var parcel_ha "Parcel area in hectare" 
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_area_lrs.dta", replace */
/* LRS For HH who has Land use rights (might rent the place)
use "${UGS_W3_raw_data}/AGSEC2B", clear
ren parcelID parcel_id
gen parcel_ha = a2bq4/2.47105	
replace parcel_ha = a2bq5/2.47105 if parcel_ha==.	
keep parcel_id parcel_ha HHID
lab var parcel_ha "Parcel area in hectare" 
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_area_lrs.dta", replace */
*Here, owns or has use rights (2A and 2B)
use "${UGS_W3_raw_data}/AGSEC2B", clear
append using "${UGS_W3_raw_data}/AGSEC2A"
ren parcelID parcel_id
gen parcel_ha = a2bq4/2.47105	
replace parcel_ha = a2bq5/2.47105 if parcel_ha==.	
replace parcel_ha = a2aq4/2.47105 if parcel_ha==.
replace parcel_ha = a2aq5/2.47105 if parcel_ha==.	
keep parcel_id parcel_ha HHID
lab var parcel_ha "Parcel area in hectare" 
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_area_lrs.dta", replace
*Notes: For land size we only have information at the Parcel level (not on a plot level). Also, information is for both seasons (not dissagregated by LRS/SRS)
* Now, we get Parcel rental rate
use "${UGS_W3_raw_data}/AGSEC2B", clear
ren parcelID parcel_id
merge 1:1 parcel_id HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_area_lrs.dta" , nogen
gen cultivated=1 if a2bq12a==1 | a2bq12a==2 | a2bq12b==1 | a2bq12b==2
replace cultivated=0 if cultivated==.
tostring HHID, format(%18.0f) replace
merge 1:m parcel_id HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_decision_makers.dta" , nogen
*When we merge plot decision makers, dm_gender are at the plot level (it may appear that parcel_id obs are double counted)
gen parcel_rental_rate = a2bq9
*Note: It's already payment for both cropping seasons (Rent per year), no need to standardize to a yearly payment.
recode parcel_rental_rate (0=.)
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rent_nomiss_lrs.dta", replace

preserve
gen value_rented_land_male = parcel_rental_rate if dm_gender==1
gen value_rented_land_female = parcel_rental_rate if dm_gender==2
gen value_rented_land_mixed = parcel_rental_rate if dm_gender==3
collapse (max) value_rented_land_* parcel_rental_rate, by(HHID parcel_id)
collapse (sum) value_rented_land_* value_rented_land = parcel_rental_rate, by(HHID)
lab var value_rented_land_male "Value of rented land (male-managed plot)"
lab var value_rented_land_female "Value of rented land (female-managed plot)"
lab var value_rented_land_mixed "Value of rented land (mixed-managed plot)"
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rental_rate_lrs.dta", replace
restore
*use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rent_nomiss_lrs.dta", replace
*use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rental_rate_lrs.dta", replace
*SW: When merging the plot_decision makers dta file, parcel_id observations are double counted, sometimes dm_gender  are different at the plot level for one parcel, but rental rate are only available at the parcel level, who do you attribute these costs then? Currently, they are attribute to each one of the dm_gender at the HHID level. 
gen ha_rental_rate_hh = parcel_rental_rate/parcel_ha
preserve
keep if parcel_rental_rate!=. & parcel_rental_rate!=0
collapse (max) parcel_rental_rate parcel_ha, by(HHID parcel_id)
collapse (sum) parcel_rental_rate parcel_ha, by(HHID)
gen ha_rental_hh_lrs = parcel_rental_rate/parcel_ha				
keep ha_rental_hh_lrs HHID
lab var ha_rental_hh_lrs "Area of rented parcel during both seasons"
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rental_rate_hhid_lrs.dta", replace
restore
*use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rental_rate_hhid_lrs.dta", replace

*Merging in geographic variables 
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta" , nogen
*Geographic medians
bys region h1aq1 h1aq4: egen ha_rental_count_ward = count(ha_rental_rate_hh)
bys region h1aq1 h1aq4: egen ha_rental_rate_ward = median(ha_rental_rate_hh)
*Notes: Here are the following regional categories: Region, Subregion, District, County/Municipality, Sub-County/Municipality, Parish/Ward. No information on the Village level. 
bys region h1aq1: egen ha_rental_count_dist = count(ha_rental_rate_hh)
bys region h1aq1: egen ha_rental_rate_dist = median(ha_rental_rate_hh)
bys region: egen ha_rental_count_region = count(ha_rental_rate_hh)
bys region: egen ha_rental_rate_region = median(ha_rental_rate_hh)
egen ha_rental_rate_nat = median(ha_rental_rate_hh)
*Now, getting median rental rate at the lowest level of aggregation with at least 10 observations.
gen ha_rental_rate = ha_rental_rate_ward if ha_rental_count_ward>=10
replace ha_rental_rate = ha_rental_rate_dist if ha_rental_count_dist>=10 & ha_rental_rate==.	
replace ha_rental_rate = ha_rental_rate_reg if ha_rental_count_reg>=10 & ha_rental_rate==.		
replace ha_rental_rate = ha_rental_rate_nat if ha_rental_rate==.		
collapse (firstnm) ha_rental_rate, by(region h1aq1 h1aq4)
lab var ha_rental_rate "Land rental rate per ha"
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_rental_rate_lrs.dta", replace

*SRS
*Notes: It seems like in UG W3 The information is already done for both LRS and SRS. This means we don't need to do a specific coding for SRS like TZN W4.

*TOTAL HA OF PLOT CULTIVATED AT LEAST ONCE:
use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rent_nomiss_lrs.dta", clear
collapse (max) cultivated parcel_ha, by(HHID parcel_id) // Collapsing down to HH-parcel level
gen ha_cultivated_parcel = parcel_ha if cultivated==1 // non-missing only if plot was cultivated during seasons
collapse (sum) ha_cultivated_parcel, by(HHID)				// total ha of all plots that were cultivated in at least one season
lab var ha_cultivated_parcel "Area of cultivated parcels (ha)"
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_cultivated_plot_ha.dta", replace
*Notes: Around 1500 observation for ha_cultivated_parcel are 0. In contrast, TZN W4 only has 80 for a total of 2092 (There might be a problem driving these results.)
*Notes: In the last collapse, when HH dont have any observation in variable ha_cultivated_parcel (which means they didn't cultivate land or no info on parcel_ha) the collapse command makes those HH observations equal to 0 Should we consider those?
*recode ha_cultivated_parcel (0=.)

use "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rental_rate_lrs.dta", clear
*collapse (sum) value_rented_land*, by(HHID)		// total over BOTH seasons (total spent on rent over course of entire year)
*This step is not necessary since it's already for both seasons
lab var value_rented_land "Value of rented land (household expenditures)"
lab var value_rented_land_male "Value of rented land (household expenditures - male-managed plots)"
lab var value_rented_land_female "Value of rented land (household expenditures - female-managed plots)"
lab var value_rented_land_mixed "Value of rented land (household expenditures - mixed-managed plots)"
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_rental_rate.dta", replace

*Now, we look for area planted
*Notes: Before, data was available on a parcel dimension and yearly. Now, data is available on a plot level and for each season.
* LRS  *
use "${UGS_W3_raw_data}/AGSEC4A", clear
ren parcelID parcel_id
ren plotID plot_id
*No need for rescaling, variable area planted already in total acres.Must change to hectares.
*Merging in total *parcel area from previous module
merge m:m HHID parcel_id   using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_plot_area_lrs.dta", nogen keep(1 3)
tostring HHID, generate(HHID_2) format("%20.0f") //General conversion for numeric hhid
rename HHID HHIDold
rename HHID_2 HHID
merge m:1 HHID parcel_id plot_id using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
gen ha_planted = a4aq7/2.47105	
gen ha_planted_male = a4aq7/2.47105	if dm_gender==1
gen ha_planted_female = a4aq7/2.47105 if dm_gender==2
gen ha_planted_mixed = a4aq7/2.47105 if dm_gender==3
collapse (min) ha_plantedmin=ha_planted (max) ha_planted parcel_ha, by(HHIDold parcel_id plot_id)
collapse (sum) ha_plantedmin ha_planted (max) parcel_ha, by(HHIDold parcel_id)
*destring HHID, replace
*Merging in Geographic variables
*tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta" , nogen
*Merging in Aggregate rental costs (both seasons/yearly)
merge m:1 region  h1aq1 h1aq4 using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_rental_rate_lrs.dta", nogen assert(2 3) keep(3)
*Merging in rental costs of individual parcels(both seasons/yearly)
merge m:1 HHID parcel_id plot_id  using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rent_nomiss_lrs.dta", nogen keep(1 3)
*Now merging in HH rental rate
merge m:1 HHID using "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_hh_rental_rate_hhid_lrs.dta", nogen keep(1 3)
gen value_owned_land = ha_planted*ha_rental_rate if a2bq9==0 | a2bq9==.
*/
*INPUT COSTS
/*
********************************************************************************
*SW 9/20/21 Using TZN W4 as References. I might need to start with Land Rental


*   LRS   *
use "${UGS_W3_raw_data}/AGSEC3A", clear
drop if missing(plotID)
*Merging in geographic variables first (for constructing prices)
tostring HHID, format(%18.0f) replace
merge m:1 HHID using "${UGS_W3_raw_data}/GSEC1.dta", //nogen assert(2 3) keep(3)
rename _merge _merge1
*Note: Problem merging observations (TZN W4 0 non matched obs here is 879)
*Gender variables
ren  plotID plot_id
merge m:1 HHID plot_id using "${Tanzania_NPS_W4_created_data}/Tanzania_NPS_W4_hh_rent_nomiss_lrs.dta", //nogen keep(1 3) keepusing(dm_gender)
*Starting with fertilizer
egen value_inorg_fert_lrs = rowtotal(ag3a_51 ag3a_58)			
egen value_herb_pest_lrs = rowtotal(ag3a_63 ag3a_65c)			
gen value_org_purchased_lrs = ag3a_45			
*/



******Agricultural Wages*******
* SW 08.02.2021
use "${UGS_W3_raw_data}/AGSEC3A", clear
append using "${UGS_W3_raw_data}/AGSEC3B"
* The survey reports total wage paid and amount of hired labor: wage=total paid/ amount of labor
* set wage paid to . if zero or negative
recode a3aq35* a3aq34* (0=.)
rename a3aq35a hired_male_lanprep
replace hired_male_lanprep = a3bq35a if hired_male_lanprep==.
rename  a3aq35b hired_female_lanprep
replace hired_female_lanprep = a3bq35b if hired_female_lanprep==.
rename a3aq36 hlabor_paid_lanprep
replace hlabor_paid_lanprep = a3bq36 if hlabor_paid_lanprep==.
recode hired* hlabor* (.=0)
*First collapse accross plot to household level
collapse (sum) hired* hlabor*, by(HHID)
gen hirelabor_lanprep=(hired_male_lanprep+hired_female_lanprep)
gen wage_lanprep=hlabor_paid_lanprep/hirelabor_lanprep
recode  wage_lanprep hirelabor_lanprep (.=0)
keep HHID wage_lanprep
rename wage_lanprep wage_paid_aglabor
label var wage_paid_aglabor "Daily wage in agriculture"
save"${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_ag_wage.dta", replace
*SW Notes: *There is also info for children, not considered. I wonder why 55% of the results end up why $0 in daily wages in agric (In  UG W1 is 67% of cases and TZN W4 only 14%, is this driving differences in indicators between waves?) In code number 2972 recode  wage_lanprep hirelabor_lanprep (.=0) we make wage_lanprep = $0 when hirelabor_lanprep is 0 (We are including in the analysis HH that did not work.) 



*******Rate of Fertilizer Application********
*SW 08.02.2021
use "${UGS_W3_raw_data}/AGSEC3A", clear
append using "${UGS_W3_raw_data}/AGSEC3B"
*SW We need Crop Production cost per hectare firstnm

************Women's Diet Quality*******************
*SW Need to find a good example on how to construct this variable. Not available in TZN W4

*****Household Diet Diversity Score****************
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

******Women's onwnership of  assets **************
*SW 8.13.21
use "${UGS_W3_raw_data}/AGSEC2A", clear
append using "${UGS_W3_raw_data}/AGSEC2B"
append using "${UGS_W3_raw_data}/AGSEC6A"
append using "${UGS_W3_raw_data}/AGSEC6B"
append using "${UGS_W3_raw_data}/AGSEC6C"
gen type_asset=""
gen double asset_owner1=.
gen double asset_owner2=.
*Ownership of land
*Notes: There is no information about ownership of plot, only on a parcel level? Also, we use ownership as ownership of right of the parcel. But in section 2a first question is about ownership of land which may means that only yes responses are available? SEC2B only considered parcels that the hh has users right access (considered, since TZNW4 does)
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
*No information regarding non-farm implements and machinery. Same with HH assets (Only info on a HH level)
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


******Women's Agricultural decision making********* SW 9/2/21
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
*Notes: In TZN4 Only 1 observation is not merged from master, here there are 102. In tzn indidy4 (PID) is float range [1,99] and y4_hhid is string str8 %8s, decision makers vars are float // for individual person_ids y4_hhid is str8 %8s, indidy4 is byte %8.0g  vs UG W3 decision-maker in master file is double 10.0g%  . HHHID is double 10.0g%  //indivual person_ids dataset is str-17 %-17s for HHID and str19 for PID 
/*clear all 
use  "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", replace 
destring HHID, gen(HHID2)
destring PID, gen(PID2)
save "${UGS_W3_created_data}/Uganda_NPS_LSMS_ISA_W3_person_ids.dta", replace
*/


*********Women's control over income****************
*SW 8.3.21
use "${UGS_W3_raw_data}/AGSEC5A", clear
append using  "${UGS_W3_raw_data}/AGSEC5B"
append using  "${UGS_W3_raw_data}/AGSEC8A"
append using  "${UGS_W3_raw_data}/AGSEC8B"
append using  "${UGS_W3_raw_data}/AGSEC8C"
append using  "${UGS_W3_raw_data}/GSEC12", force
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
*SW Notes: There is information regarding Sales of live livestock in AG. Questionnaire 6A,6B.. might be able to construct it using questions Who owns the livestock [] and did you sell any live [] in the last 12 months? May be more related to asset control.
*Control over business income
*Notes: Unlike TZN 4, UG W3 asks who owns / managed the business (enterprise) in a same question, not able to differentiate between each. Would have to make the assumption that whoever owns or manages the business has control over the income (May not be true) Household Questionnaire Section 8 Question 22 . Does run a business means to own it? Second Job (S8 Q40A,B)
*Non Agricultural Enterprises. Who owns/runs the enterprise up to 2 IDS (S12 Q5A,B)
*destring h12q5a, replace
*destring h12q5b, replace
*replace type_decision="control_businessincome" if !missing(h12q5a) | !missing(h12q5b)
*replace controller_income1=h12q5a if controller_income1==.
*replace controller_income2=h12q5b if controller_income2==.
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
*SW Notes: In UG W3 There is less information regarding types of incomes decision makers in compared to TZn W4

********************************************************************************
*SHANNON DIVERSITY INDEX
********************************************************************************
*SW  9/20/21 Reference work : TZN W4
*Area Planted


